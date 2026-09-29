#!/usr/bin/env node
/**
 * Проверяет батчи справок (`data/entity-reference/{lab-tests,medical-services}-*.json`)
 * перед сборкой SQL: слаги, комплектность локалей, YMYL-ограничения, копипасту.
 *
 * Ловит то, что параллельные агенты ломают чаще всего:
 *   - слаг, которого нет в БД (переименован или выдуман);
 *   - пропущенную локаль или поле;
 *   - символ `|` (vue-i18n читает его как плюрализацию);
 *   - экавицу в сербском (нужна иекавица: lijek, prije, vrijeme);
 *   - числовые референсы с единицами измерения (запрещены по YMYL);
 *   - одинаковый текст у соседних позиций (шаблон вместо содержания).
 *
 * Usage: node scripts/entity-reference/validate-reference-batches.mjs [--only lab-tests]
 */

import mysql from 'mysql2/promise';
import { readFileSync, readdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');
const DATA_DIR = resolve(ROOT, 'data/entity-reference');

const LOCALES = ['ru', 'en', 'sr', 'de', 'tr'];
const FIELDS = ['what', 'how', 'when', 'prep', 'abnormal'];

const onlyArg = process.argv.indexOf('--only');
const ONLY = onlyArg > -1 ? process.argv[onlyArg + 1] : null;

// Экавские формы, у которых в иекавице другой корень. Сверяем по токенам,
// а не регуляркой со словесной границей: «elektrolita» не должен ловиться на «lek».
const EKAVICA = new Set([
	'lek', 'leka', 'lekovi', 'lekova', 'lekove', 'lekar', 'lekara', 'lekari', 'lekarski',
	'pre', 'beli', 'bela', 'belo', 'bele', 'mleko', 'mleka', 'vreme',
	'dete', 'deteta', 'deca', 'mesto', 'mesta', 'nedelja', 'nedelje', 'sprecavanje',
	'sprečavanje', 'ceo', 'celo', 'cela', 'primena', 'primene', 'pregled pre',
]);
const tokens = (s) => s.toLowerCase().split(/[^\p{L}]+/u).filter(Boolean);

// Числовой референс с единицей измерения: «3,5–5,5 ммоль/л», «10 mg/dL».
const UNIT_RE = /\d\s*(?:[-–—]\s*\d[\d.,]*\s*)?(ммоль|мкмоль|мкг|мг\/|г\/л|ед\/л|мкме|ме\/|mmol|µmol|umol|mg\/d|g\/l|u\/l|iu\/l|ng\/m|pg\/m|mIU|mIU\/|nmol)/i;

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const dbSlugs = {
	lab_test: new Set((await db.query('SELECT slug FROM lab_tests'))[0].map((r) => r.slug)),
	medical_service: new Set((await db.query('SELECT slug FROM medical_services'))[0].map((r) => r.slug)),
};
await db.end();

const problems = [];
const texts = new Map(); // «локаль|поле|текст» -> [слаги]
let cards = 0;
const files = readdirSync(DATA_DIR)
	.filter((f) => f.endsWith('.json') && !f.startsWith('_'))
	.filter((f) => (ONLY ? f.startsWith(ONLY) : true))
	.sort();

const seenSlugs = new Map();

for (const file of files) {
	let items;
	try {
		items = JSON.parse(readFileSync(resolve(DATA_DIR, file), 'utf-8'));
	} catch (e) {
		problems.push(`${file}: не парсится — ${e.message}`);
		continue;
	}
	for (const card of items) {
		cards++;
		const where = `${file} / ${card.slug}`;
		const first = seenSlugs.get(card.slug);
		if (first) problems.push(`${where}: дубль слага, уже есть в ${first}`);
		else seenSlugs.set(card.slug, file);

		if (!['lab_test', 'medical_service'].includes(card.entity_type)) {
			problems.push(`${where}: entity_type = ${card.entity_type}`);
		} else if (!dbSlugs[card.entity_type].has(card.slug)) {
			problems.push(`${where}: слага нет в БД (${card.entity_type})`);
		}

		for (const loc of LOCALES) {
			const tr = card.translations?.[loc];
			if (!tr) {
				problems.push(`${where}: нет локали ${loc}`);
				continue;
			}
			for (const f of FIELDS) {
				const v = tr[f];
				if (typeof v !== 'string' || !v.trim()) {
					problems.push(`${where}: пустое ${loc}.${f}`);
					continue;
				}
				if (v.includes('|')) problems.push(`${where}: символ | в ${loc}.${f}`);
				if (UNIT_RE.test(v)) problems.push(`${where}: числовой референс в ${loc}.${f}: «${v.slice(0, 90)}»`);
				if (loc === 'sr') {
					const bad = tokens(v).filter((t) => EKAVICA.has(t));
					if (bad.length) problems.push(`${where}: экавица «${[...new Set(bad)].join(', ')}» в sr.${f}`);
				}
				const key = `${loc}|${f}|${v.trim().toLowerCase()}`;
				if (!texts.has(key)) texts.set(key, []);
				texts.get(key).push(card.slug);
			}
		}
	}
}

// Копипасту схлопываем по набору слагов: один и тот же шаблон обычно повторяется
// сразу во всех пяти локалях, и пять одинаковых строк в отчёте только мешают.
const dupes = new Map(); // «поле|слаги» -> [локали]
for (const [key, slugs] of texts) {
	if (slugs.length < 2) continue;
	const [loc, field] = key.split('|');
	// «Забор венозной крови» и «Подготовка не требуется» у сотни анализов — норма;
	// одинаковые what/when/abnormal означают шаблон вместо содержания.
	if (field === 'prep' || field === 'how') continue;
	const k = `${field}|${slugs.join(', ')}`;
	if (!dupes.has(k)) dupes.set(k, []);
	dupes.get(k).push(loc);
}
for (const [k, locs] of dupes) {
	const [field, slugs] = k.split('|');
	problems.push(`копипаста ${field} (${locs.join('/')}) у ${slugs.split(', ').length} позиций: ${slugs}`);
}

console.log(`Проверено ${cards} карточек в ${files.length} файл(ах)`);
if (!problems.length) {
	console.log('Проблем не найдено.');
} else {
	console.log(`Проблем: ${problems.length}\n`);
	for (const p of problems) console.log('  ' + p);
	process.exitCode = 1;
}

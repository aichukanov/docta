#!/usr/bin/env node
/**
 * Сверка прода с миграциями 036/037 через публичное API — без доступа к БД.
 *
 * Ожидаемые значения берутся из самих SQL-файлов (037 поверх 036), поэтому
 * скрипт проверяет ровно то, что было применено, а не то, что лежит в батчах.
 *
 *   - названия: /api/services/details по выборке слагов, во всех локалях;
 *   - синонимы: /api/services/list с синонимом в качестве запроса — услуга
 *     должна найтись, а синоним — оказаться в matchedSynonyms.
 *
 * Тело запроса уходит в curl через stdin в UTF-8: кириллица в аргументе
 * командной строки в Git Bash на Windows приходит на сервер битой, и поиск
 * молча отдаёт весь каталог без фильтра — это выглядит как поломка сайта.
 *
 * Usage: node scripts/services/verify-service-names-prod.mjs [--names 60] [--synonyms 60] [--host https://docta.me]
 */

import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { searchFold } from '../common/service-name-rules.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const arg = (n, d) => {
	const i = process.argv.indexOf(n);
	return i > -1 ? process.argv[i + 1] : d;
};
const HOST = arg('--host', 'https://docta.me');
const N_NAMES = Number(arg('--names', 60));
const N_SYN = Number(arg('--synonyms', 60));

/** Локаль API → колонка. sr в details приходит отдельным полем localName. */
const LOCALE_COLUMN = { en: 'en', ru: 'ru', de: 'de', tr: 'tr', 'sr-cyrl': 'sr_cyrl' };
/** Слаги, которые проверяются всегда: по одному на каждый класс правок. */
const MUST = [
	'calcaneus-fracture-open-or-closed', // обрубок ru, конфликт fix/review
	'x-ray-hand', // кракозябры в sr
	'thyroid-ultrasound', // экавица в sr
	'breast-ultrasound', // синонимы
	'packed-red-blood-cells-unit-rh-positive', // ручной батч fix-90
	'operating-theatre-costs-tier-ii-over-180-points', // серия fix-90
	'permagna-ventral-incisional-hernioplasty', // мягкий перенос
	'zirconia-crown-with-veneer', // смешение алфавитов в sr_cyrl
	'follow-up-ophthalmologist-examination', // кириллица внутри sr
	'pulpitis-treatment-two-root-niti', // сведённая серия
];

const unq = (s) => s.replace(/''/g, "'").replace(/\\\\/g, '\\');
const STR = String.raw`'((?:[^'\\]|''|\\.)*)'`;

function parse(file) {
	// Редактор или git на Windows пересохраняют миграцию с CRLF — MySQL это безразлично, регуляркам нет.
	const sql = readFileSync(resolve(ROOT, 'server/sql/migrations', file), 'utf-8').replace(/\r\n/g, '\n');
	const names = new Map();
	for (const m of sql.matchAll(/UPDATE medical_services SET\n([\s\S]*?)\n WHERE slug = '([^']+)';/g)) {
		const cols = {};
		for (const c of m[1].matchAll(new RegExp(String.raw`name_(\w+) = ${STR}`, 'g'))) cols[c[1]] = unq(c[2]);
		names.set(m[2], cols);
	}
	const synonyms = [];
	for (const m of sql.matchAll(new RegExp(String.raw`SELECT id, ${STR}, '([a-z-]+)' FROM medical_services WHERE slug = '([^']+)'`, 'g'))) {
		synonyms.push({ value: unq(m[1]), language: m[2], slug: m[3] });
	}
	return { names, synonyms };
}

const a = parse('036-service-names-mechanical.sql');
const b = parse('037-service-names-review.sql');
const expected = new Map(a.names);
for (const [slug, cols] of b.names) expected.set(slug, { ...(expected.get(slug) || {}), ...cols });
const allSynonyms = [...a.synonyms, ...b.synonyms];

function post(path, body) {
	const out = execFileSync(
		'curl',
		['-s', '-m', '40', '-X', 'POST', `${HOST}${path}`, '-H', 'Content-Type: application/json; charset=utf-8',
			'-H', 'User-Agent: Mozilla/5.0 (docta-verify)', '--data-binary', '@-', '-w', '\n%{http_code}'],
		{ input: Buffer.from(JSON.stringify(body), 'utf-8'), maxBuffer: 64 * 1024 * 1024 },
	).toString('utf-8');
	const cut = out.lastIndexOf('\n');
	const code = Number(out.slice(cut + 1));
	if (code !== 200) throw new Error(`${path} → HTTP ${code}`);
	return JSON.parse(out.slice(0, cut));
}

const shuffle = (arr) => arr.map((v) => [Math.random(), v]).sort((x, y) => x[0] - y[0]).map(([, v]) => v);

// ── Названия
const slugs = [...new Set([...MUST.filter((s) => expected.has(s)), ...shuffle([...expected.keys()]).slice(0, N_NAMES)])];
let checked = 0;
const nameFails = [];
for (const slug of slugs) {
	const exp = expected.get(slug);
	const needed = Object.keys(LOCALE_COLUMN).filter((l) => exp[LOCALE_COLUMN[l]] !== undefined);
	// sr приходит localName в любом ответе — достаточно одного запроса, если других колонок нет
	const locales = needed.length ? needed : ['en'];
	for (const locale of locales) {
		const r = post('/api/services/details', { slug, locale });
		const col = LOCALE_COLUMN[locale];
		if (exp[col] !== undefined) {
			checked++;
			if (r.name !== exp[col]) nameFails.push({ slug, col, expected: exp[col], actual: r.name });
		}
		if (locale === locales[0] && exp.sr !== undefined) {
			checked++;
			if (r.localName !== exp.sr) nameFails.push({ slug, col: 'sr', expected: exp.sr, actual: r.localName });
		}
	}
}

// ── Синонимы
const synSample = shuffle(allSynonyms).slice(0, N_SYN);
const synFails = [];
for (const s of synSample) {
	const locale = s.language === 'sr-cyrl' ? 'sr-cyrl' : s.language;
	const r = post('/api/services/list', { name: s.value, locale, page: 1, pageSize: 200 });
	const hit = r.items.find((i) => i.slug === s.slug);
	if (!hit) synFails.push({ ...s, why: `услуга не найдена (всего ${r.totalCount})` });
	else if (!(hit.matchedSynonyms || []).some((m) => searchFold(m) === searchFold(s.value))) {
		// Услуга могла найтись по названию, а синоним — оказаться подстрокой другого синонима: не ошибка.
		const byName = Object.values(expected.get(s.slug) || {}).some((n) => searchFold(n).includes(searchFold(s.value)));
		if (!byName && !(hit.matchedSynonyms || []).length) synFails.push({ ...s, why: 'найдена, но не по синониму' });
	}
}

console.log(`названия: ${slugs.length} услуг, ${checked} полей, расхождений ${nameFails.length}`);
for (const f of nameFails) console.log(`  ✗ ${f.slug}.${f.col}\n      ждали: ${f.expected}\n      на проде: ${f.actual}`);
console.log(`синонимы: ${synSample.length} запросов, не найдено ${synFails.length}`);
for (const f of synFails) console.log(`  ✗ ${f.slug} «${f.value}» (${f.language}): ${f.why}`);
process.exit(nameFails.length || synFails.length ? 1 : 0);

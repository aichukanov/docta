#!/usr/bin/env node
/**
 * Заполняет локаль `sr_cyrl` в data/entity-reference/{lab-tests,medical-services}.json
 * механической транслитерацией из `sr` (common/serbian-transliteration.ts).
 *
 * sr_cyrl НЕ переводится отдельно — иначе sr и sr_cyrl рассинхронизируются при правках.
 *
 * Латинские аббревиатуры и имена собственные, которые в сербской кириллице
 * не транслитерируются побуквенно, защищены списком PROTECTED_LATIN_TOKENS.
 * Устоявшиеся сербские кириллические аббревиатуры (ЕКГ, ЕЕГ, ХОБП, ХИВ, МР)
 * в список НЕ входят — они транслитерируются корректно.
 *
 * Usage:
 *   node scripts/entity-reference/generate-sr-cyrl.mjs           # только отсутствующие
 *   node scripts/entity-reference/generate-sr-cyrl.mjs --force   # пересобрать все
 */

import { readFileSync, writeFileSync, readdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createJiti } from 'jiti';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');

const jiti = createJiti(import.meta.url);
const { toCyrillic } = await jiti.import(
	resolve(ROOT, 'common/serbian-transliteration.ts'),
);

// Токены, которые остаются латиницей: бренды, международные обозначения,
// иностранные фамилии в названиях формул/методик.
const PROTECTED_LATIN_TOKENS = [
	'LASIK',
	'Fowler-Sabine',
	'PSA',
	'HbA1c',
	'HCG',
	'HCV',
	'TPHA',
	// PAPP-A намеренно НЕ защищён: батч 7 зафиксировал «ПАПП-А» кириллицей,
	// эта форма уже в проде и проверена (см. PROGRESS.md)
	'OCT',
	'VEGF',
	'FRC',
	'Rh',
	'IgE',
	'IgG',
	'IgM',
	// бренды имплантационных/ортодонтических систем и препаратов (тир B)
	'Nobel Biocare',
	'Straumann',
	'Bredent',
	'Invisalign',
	'Vistabel',
	'Botox',
	// протоколы, материалы, обозначения
	'All on 4',
	'All on 6',
	'E-max',
	'CAD/CAM',
	'CoCr',
	'PRP',
	'IOL',
	// римские цифры стадий: без защиты «I-III» превращается в «И-ИИИ»
	'I-III',
	'II-III',
	'I-II',
];

const FIELDS = ['what', 'how', 'when', 'prep', 'abnormal'];
const DATA_DIR = 'data/entity-reference';

// Тот же глоб, что в build-entity-reference-sql.mjs: батчи лежат в
// отдельных `<prefix>-batch-*.json`, чтобы над ними можно было работать параллельно
const FILES = readdirSync(resolve(ROOT, DATA_DIR))
	.filter(
		(f) =>
			f.endsWith('.json') &&
			(f.startsWith('lab-tests') || f.startsWith('medical-services')),
	)
	.sort()
	.map((f) => `${DATA_DIR}/${f}`);

const force = process.argv.includes('--force');

// Маркер парковки защищённого токена — индекс между управляющими символами,
// а не «голая» цифра: в текстах полно чисел («seansa traje 15–20 minuta»), и
// восстановление по /(\d+)/g подменяло бы их на found[15] === undefined.
// Код 1, а не 0: \x00 занят внутренним механизмом toCyrillic для {placeholder}.
const MARK = String.fromCharCode(1);
const MARK_RE = new RegExp(`${MARK}(\\d+)${MARK}`, 'g');

/** Транслитерация с защитой латинских токенов от побуквенной замены. */
function transliterate(text) {
	const found = [];
	let masked = text;

	for (const token of PROTECTED_LATIN_TOKENS) {
		// \b не работает для токенов с дефисом на границе, поэтому проверяем вручную
		const re = new RegExp(
			`(^|[^\\p{L}\\p{N}])(${token})(?=$|[^\\p{L}\\p{N}])`,
			'gu',
		);
		masked = masked.replace(re, (_, before, match) => {
			found.push(match);
			return `${before}${MARK}${found.length - 1}${MARK}`;
		});
	}

	return toCyrillic(masked).replace(MARK_RE, (_, index) => found[+index]);
}

let totalFilled = 0;

for (const file of FILES) {
	const path = resolve(ROOT, file);
	const items = JSON.parse(readFileSync(path, 'utf-8'));
	let filled = 0;

	for (const item of items) {
		const sr = item.translations?.sr;
		if (!sr) {
			console.warn(`  ${item.slug}: нет локали sr — пропущено`);
			continue;
		}
		if (item.translations.sr_cyrl && !force) continue;

		item.translations.sr_cyrl = Object.fromEntries(
			FIELDS.map((field) => [field, transliterate(sr[field])]),
		);
		filled++;
	}

	// не переписываем файл вхолостую — иначе нечего не изменившие прогоны
	// всё равно шумят в git diff (перенос строк, отступы)
	if (filled) {
		writeFileSync(path, JSON.stringify(items, null, 2) + '\n', 'utf-8');
	}
	console.log(`${file}: ${filled} карточек (всего ${items.length})`);
	totalFilled += filled;
}

console.log(`Итого заполнено sr_cyrl: ${totalFilled}`);

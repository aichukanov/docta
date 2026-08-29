#!/usr/bin/env node
/**
 * Собирает `server/sql/migrations/insert-med-substance-reference-info.sql` из
 * батчей `data/entity-reference/substances/batch-*.json` (схема — миграция 024).
 *
 * Батчей несколько файлов, а не один массив: над контентом работают
 * параллельные агенты, и общий файл терял бы правки молча.
 *
 * `sr_cyrl` не берётся из данных — транслитерируется из `sr`
 * (common/serbian-transliteration.ts) с защитой латинских аббревиатур, иначе
 * две сербские локали разъезжаются при первой же правке.
 *
 * Ключ — `substance_id` (= med_substances.id). `name` в батче нужен только для
 * читаемости и сверки: скрипт падает, если имя разошлось с ростером.
 *
 * Usage: node scripts/entity-reference/build-substance-reference-sql.mjs
 */

import { readFileSync, writeFileSync, readdirSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createJiti } from 'jiti';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');

const jiti = createJiti(import.meta.url);
const { toCyrillic } = await jiti.import(
	resolve(ROOT, 'common/serbian-transliteration.ts'),
);

const DATA_DIR = 'data/entity-reference/substances';
const OUT = 'server/sql/migrations/insert-med-substance-reference-info.sql';

const FIELDS = ['what', 'used_for', 'caution'];
const LOCALES = ['en', 'sr', 'sr_cyrl', 'ru', 'de', 'tr'];

// Латиница, остающаяся латиницей в сербской кириллице: международные
// обозначения классов и лабораторных показателей.
const PROTECTED_LATIN_TOKENS = [
	'NSAIL',
	'NSAID',
	'ACE',
	'COX-2',
	'COX',
	'SSRI',
	'PPI',
	'H1',
	'H2',
	'B12',
	'B9',
	'B6',
	'B2',
	'B1',
	'D3',
	'LDL',
	'HDL',
	'HbA1c',
	'PSA',
	'HIV',
	'SGLT2',
	'DPP-4',
	'GLP-1',
	// Фактор свёртывания Xa: «Ха» в кириллице читается как слог, а не как обозначение
	'Xa',
	'B5',
	'GnRH',
	'TNF',
	'COVID-19',
	'mRNA',
	'IgE',
	// Латинские биномы растений: побуквенно дают «Хедера хеликс», чего в
	// сербских текстах не пишут — бином остаётся латиницей
	'Hedera helix',
	'Ginkgo biloba',
	'Bacillus clausii',
	'Saccharomyces boulardii',
	'Malva sylvestris',
	'Mentha piperita',
	'Melissa officinalis',
	'Serenoa repens',
	'Silybum marianum',
	'Echinacea purpurea',
	'Aloe vera',
	'Valeriana officinalis',
	'Primula veris',
	'Primula elatior',
	'Thymus vulgaris',
	'Thymus zygis',
	'Glycyrrhiza glabra',
	'Matricaria chamomilla',
	'Chelidonium majus',
	'Angelica archangelica',
	'Iberis amara',
	'Carum carvi',
	'Cardiospermum halicacabum',
	'Plantago lanceolata',
	'Cetraria islandica',
	'Rosmarinus officinalis',
	// Латинские названия родов и видов микроорганизмов: «Цандида» вместо
	// Candida — не то, как это пишут в сербских медицинских текстах
	'Candida',
	'Helicobacter pylori',
	'Escherichia coli',
	'Streptococcus',
	'Staphylococcus',
];

const MARK = String.fromCharCode(1);
const MARK_RE = new RegExp(`${MARK}(\\d+)${MARK}`, 'g');

function transliterate(text) {
	const found = [];
	let masked = text;

	for (const token of PROTECTED_LATIN_TOKENS) {
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

function esc(value) {
	if (value == null || value === '') return 'NULL';
	return "'" + String(value).replace(/\\/g, '\\\\').replace(/'/g, "''") + "'";
}

const rosterPath = resolve(ROOT, DATA_DIR, '_roster.json');
const roster = existsSync(rosterPath)
	? JSON.parse(readFileSync(rosterPath, 'utf-8'))
	: [];
const rosterById = new Map(roster.map((item) => [item.id, item]));

const files = readdirSync(resolve(ROOT, DATA_DIR))
	.filter((file) => file.startsWith('batch-') && file.endsWith('.json'))
	.sort();

if (!files.length) {
	console.error(`Нет батчей в ${DATA_DIR}`);
	process.exit(1);
}

const cards = [];
const seen = new Map();
const problems = [];

for (const file of files) {
	const items = JSON.parse(
		readFileSync(resolve(ROOT, DATA_DIR, file), 'utf-8'),
	);

	for (const item of items) {
		const id = item.substance_id;

		if (seen.has(id)) {
			problems.push(`${file}: вещество ${id} уже есть в ${seen.get(id)}`);
			continue;
		}
		seen.set(id, file);

		const rosterItem = rosterById.get(id);
		if (rosterItem && item.name && rosterItem.name !== item.name) {
			problems.push(
				`${file}: id ${id} — имя "${item.name}" не совпадает с ростером "${rosterItem.name}"`,
			);
		}

		const translations = item.translations || {};
		if (!translations.ru || !translations.sr) {
			problems.push(`${file}: ${item.name || id} — нет ru или sr`);
			continue;
		}

		for (const [locale, fields] of Object.entries(translations)) {
			for (const field of FIELDS) {
				const value = fields?.[field];
				if (value && value.includes('|')) {
					problems.push(
						`${file}: ${item.name || id} ${locale}.${field} — символ "|" запрещён`,
					);
				}
			}
		}

		translations.sr_cyrl = Object.fromEntries(
			FIELDS.map((field) => [
				field,
				translations.sr[field] ? transliterate(translations.sr[field]) : null,
			]),
		);

		cards.push({ id, name: item.name, translations });
	}
}

if (problems.length) {
	console.error('Проблемы в батчах:\n  ' + problems.join('\n  '));
	process.exit(1);
}

cards.sort((a, b) => a.id - b.id);

const columns = [
	'substance_id',
	...FIELDS.flatMap((field) => LOCALES.map((locale) => `${field}_${locale}`)),
];

const lines = [
	'-- СГЕНЕРИРОВАННЫЙ ФАЙЛ — правки вносить в data/entity-reference/substances/batch-*.json',
	'-- и пересобирать: node scripts/entity-reference/build-substance-reference-sql.mjs',
	'--',
	'-- Схема: server/sql/migrations/024-med-substance-reference-info.sql',
	'-- Идемпотентно: повторный прогон обновляет тексты, а не плодит строки.',
	'-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/insert-med-substance-reference-info.sql',
	'',
	'SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;',
	'',
];

for (const card of cards) {
	const values = [
		card.id,
		...FIELDS.flatMap((field) =>
			LOCALES.map((locale) => esc(card.translations[locale]?.[field])),
		),
	];

	lines.push(`-- ${card.name}`);
	lines.push(
		`INSERT INTO med_substance_reference_info (${columns.join(', ')})`,
	);
	lines.push(`VALUES (${values.join(', ')})`);
	lines.push(
		'ON DUPLICATE KEY UPDATE ' +
			columns
				.slice(1)
				.map((column) => `${column} = VALUES(${column})`)
				.join(', ') +
			';',
	);
	lines.push('');
}

lines.push(
	'SELECT COUNT(*) AS substance_reference_rows FROM med_substance_reference_info;',
);

writeFileSync(resolve(ROOT, OUT), lines.join('\n') + '\n', 'utf-8');

console.log(`${OUT}: ${cards.length} веществ из ${files.length} батчей`);
const sample = cards.find((card) => card.translations.sr_cyrl?.what);
if (sample) {
	console.log(`sr-cyrl (${sample.name}): ${sample.translations.sr_cyrl.what}`);
}

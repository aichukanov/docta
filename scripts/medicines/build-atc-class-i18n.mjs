#!/usr/bin/env node
/**
 * Собирает `i18n/atc-class.ts` — метки фармакологического класса лекарства по
 * ATC level-2 (`R06` → «антигистаминное»), 6 локалей.
 *
 * Вход:
 *   data/atc-class/base.json    — [{code, official_en, ru}], эталон списка кодов и ru-меток
 *   data/atc-class/loc-en.json  — {code: label}, переводы (собираются субагентами)
 *   data/atc-class/loc-sr.json
 *   data/atc-class/loc-de.json
 *   data/atc-class/loc-tr.json
 *
 * `sr-cyrl` НЕ переводится отдельно: транслитерируется из `sr`
 * (common/serbian-transliteration.ts), иначе две сербские локали разъезжаются
 * при правках. Латинские аббревиатуры защищены PROTECTED_LATIN_TOKENS.
 *
 * Проверки (падаем, а не тихо генерим дырявый файл):
 *   - набор кодов в каждом loc-*.json совпадает с base.json;
 *   - набор кодов в base.json совпадает с ATC_CLASS_CODES из enums/atc-class.ts;
 *   - в метках нет `|` (vue-i18n трактует его как плюрализацию).
 *
 * Usage: node scripts/medicines/build-atc-class-i18n.mjs
 */

import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createJiti } from 'jiti';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');

const jiti = createJiti(import.meta.url);
const { toCyrillic } = await jiti.import(
	resolve(ROOT, 'common/serbian-transliteration.ts'),
);
const { ATC_CLASS_CODES } = await jiti.import(
	resolve(ROOT, 'enums/atc-class.ts'),
);

// Латиница, которая в сербской кириллице остаётся латиницей: международные
// аббревиатуры классов. NSAIL/ACE/COX — именно так их пишут и в кириллических
// текстах, побуквенная транслитерация дала бы «НСАИЛ», «АЦЕ».
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
	'GnRH',
	'TNF',
	'SGLT2',
	'DPP-4',
];

const MARK = String.fromCharCode(1);
const MARK_RE = new RegExp(`${MARK}(\\d+)${MARK}`, 'g');

/** Транслитерация с защитой латинских токенов от побуквенной замены. */
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

const readJson = (relative) =>
	JSON.parse(readFileSync(resolve(ROOT, relative), 'utf-8'));

const base = readJson('data/atc-class/base.json');
const codes = base.map((item) => item.code);

const missingInEnum = codes.filter((code) => !ATC_CLASS_CODES.has(code));
const extraInEnum = [...ATC_CLASS_CODES].filter(
	(code) => !codes.includes(code),
);
if (missingInEnum.length || extraInEnum.length) {
	console.error(
		'base.json и enums/atc-class.ts разошлись.\n' +
			`  нет в enum: ${missingInEnum.join(', ') || '—'}\n` +
			`  лишние в enum: ${extraInEnum.join(', ') || '—'}`,
	);
	process.exit(1);
}

const translated = {
	en: readJson('data/atc-class/loc-en.json'),
	sr: readJson('data/atc-class/loc-sr.json'),
	de: readJson('data/atc-class/loc-de.json'),
	tr: readJson('data/atc-class/loc-tr.json'),
};

const labels = {
	en: {},
	ru: {},
	sr: {},
	'sr-cyrl': {},
	de: {},
	tr: {},
};

for (const { code, ru } of base) {
	labels.ru[code] = ru;

	for (const [locale, dictionary] of Object.entries(translated)) {
		const value = dictionary[code];
		if (!value) {
			console.error(`loc-${locale}.json: нет метки для ${code}`);
			process.exit(1);
		}
		labels[locale][code] = value;
	}

	labels['sr-cyrl'][code] = transliterate(translated.sr[code]);
}

for (const [locale, dictionary] of Object.entries(labels)) {
	for (const [code, value] of Object.entries(dictionary)) {
		if (value.includes('|')) {
			console.error(
				`${locale}/${code}: символ "|" запрещён (vue-i18n читает его как плюрализацию)`,
			);
			process.exit(1);
		}
	}
}

const LOCALE_ORDER = ['en', 'ru', 'sr', 'sr-cyrl', 'de', 'tr'];

const body = LOCALE_ORDER.map((locale) => {
	const entries = codes
		.map((code) => `\t\t\tAtcClass${code}: ${JSON.stringify(labels[locale][code])},`)
		.join('\n');

	return `\t\t'${locale}': {\n${entries}\n\t\t},`;
}).join('\n');

const output = `// СГЕНЕРИРОВАННЫЙ ФАЙЛ — правки вносить в data/atc-class/*.json и
// пересобирать: node scripts/medicines/build-atc-class-i18n.mjs
//
// Метки фармакологического класса лекарства по ATC level-2. Ключ — AtcClass<КОД>,
// см. enums/atc-class.ts (getAtcClassKey). Локаль sr-cyrl — транслитерация из sr.

export default {
	messages: {
${body}
	},
};
`;

writeFileSync(resolve(ROOT, 'i18n/atc-class.ts'), output, 'utf-8');

console.log(
	`i18n/atc-class.ts собран: ${codes.length} кодов × ${LOCALE_ORDER.length} локалей`,
);
console.log(
	'sr-cyrl (выборка):',
	['H02', 'M01', 'R06', 'J01']
		.map((code) => `${code}=${labels['sr-cyrl'][code]}`)
		.join(' · '),
);

#!/usr/bin/env node
/**
 * Печатает латинские токены, встречающиеся в сербских текстах справок, —
 * кандидаты в `PROTECTED_LATIN_TOKENS` из generate-sr-cyrl.mjs.
 *
 * Транслитерация в кириллицу портит международные обозначения («CK» → «ЦК»,
 * «Helicobacter» → «Хелицобацтер»), а проверять их глазами в 350 карточках
 * нереально. Скрипт отбирает то, что выглядит обозначением, а не сербским
 * словом: аббревиатуры из заглавных, латинские видовые названия, коды с цифрами.
 *
 * Usage: node scripts/entity-reference/list-latin-tokens.mjs [prefix]
 */

import { readFileSync, readdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const DATA_DIR = resolve(__dirname, '..', '..', 'data/entity-reference');
const PREFIX = process.argv[2] || '';

const found = new Map(); // токен -> число вхождений

for (const file of readdirSync(DATA_DIR)) {
	if (!file.endsWith('.json') || file.startsWith('_')) continue;
	if (PREFIX && !file.startsWith(PREFIX)) continue;
	for (const card of JSON.parse(readFileSync(resolve(DATA_DIR, file), 'utf-8'))) {
		const sr = card.translations?.sr;
		if (!sr) continue;
		for (const text of Object.values(sr)) {
			const str = String(text);
			// латинские видовые названия: слово с заглавной НЕ в начале фразы
			// («zasijavanje na Candida albicans»), вместе со вторым словом биномена
			for (const m of str.matchAll(
				/(?<=[a-zšđčćž,]\s)([A-Z][a-z]{2,})(\s+[a-z]{3,})?/g,
			)) {
				const t = (m[1] + (m[2] || '')).trim();
				found.set(t, (found.get(t) || 0) + 1);
			}
			// аббревиатуры (2+ заглавных, возможно с цифрами и дефисом) и коды
			for (const m of str.matchAll(/\b[A-Z][A-Za-z0-9]*(?:[-–][A-Za-z0-9]+)*\b/g)) {
				const t = m[0];
				if (t.length < 2) continue;
				const upper = t.replace(/[^A-Z]/g, '').length;
				// одно заглавное в начале — обычное слово в начале фразы, пропускаем,
				// если следом нет цифры или дефиса
				if (upper < 2 && !/[0-9-]/.test(t)) continue;
				found.set(t, (found.get(t) || 0) + 1);
			}
		}
	}
}

for (const [t, n] of [...found.entries()].sort((a, b) => b[1] - a[1])) {
	console.log(String(n).padStart(4), t);
}
console.log(`\nвсего уникальных: ${found.size}`);

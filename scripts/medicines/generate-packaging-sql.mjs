#!/usr/bin/env node
/**
 * Генерирует миграцию структурированной упаковки из data/medicines.json.
 * Запуск: node scripts/medicines/generate-packaging-sql.mjs
 * Вывод:  server/sql/migrations/packaging-structured.sql
 *
 * Миграцию применяет пользователь командой mysql (см. вывод скрипта).
 * Сопоставление строго по cinmed_id (стабильный ключ реестра).
 */
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { parsePackaging } from './parse-packaging.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');

const data = JSON.parse(
	readFileSync(resolve(ROOT, 'data/medicines.json'), 'utf-8'),
);
const items = data.medicines || data;

const num = (v) => (v == null ? 'NULL' : String(v));
const str = (v) => (v == null ? 'NULL' : `'${String(v).replace(/'/g, "''")}'`);

const lines = [
	'-- Структурированная упаковка med_medicines (генерируется parse-packaging).',
	`-- Generated: ${new Date().toISOString()}`,
	'-- Исходный текст реестра (detail_packaging) сохраняется как есть, на фронт',
	'-- не выводится; локализованный текст собирается из структурных полей.',
	'',
	'SET NAMES utf8mb4;',
	'',
	'-- MySQL не поддерживает ADD COLUMN IF NOT EXISTS — колонки добавляются один раз.',
	'ALTER TABLE med_medicines',
	'  ADD COLUMN pack_total SMALLINT UNSIGNED NULL,',
	'  ADD COLUMN pack_unit VARCHAR(16) NULL,',
	'  ADD COLUMN pack_container VARCHAR(16) NULL,',
	'  ADD COLUMN pack_container_count SMALLINT UNSIGNED NULL,',
	'  ADD COLUMN pack_per_container SMALLINT UNSIGNED NULL,',
	'  ADD COLUMN pack_volume DECIMAL(8,2) NULL,',
	'  ADD COLUMN pack_volume_unit VARCHAR(6) NULL,',
	'  ADD COLUMN pack_parse_status VARCHAR(8) NULL;',
	'',
];

let ok = 0;
let manual = 0;
for (const it of items) {
	if (it.cinmed_id == null) continue;
	const text = (it.detail_packaging || it.packaging || '').trim();
	if (!text) continue;
	const r = parsePackaging(text);
	const cid = String(it.cinmed_id).replace(/'/g, "''");
	if (r.status === 'ok') {
		ok++;
		lines.push(
			`UPDATE med_medicines SET ` +
				`pack_total=${num(r.total)}, ` +
				`pack_unit=${str(r.unit)}, ` +
				`pack_container=${str(r.container)}, ` +
				`pack_container_count=${num(r.containerCount)}, ` +
				`pack_per_container=${num(r.perContainer)}, ` +
				`pack_volume=${num(r.volume)}, ` +
				`pack_volume_unit=${str(r.volumeUnit)}, ` +
				`pack_parse_status='ok' ` +
				`WHERE cinmed_id='${cid}';`,
		);
	} else {
		manual++;
		lines.push(
			`UPDATE med_medicines SET pack_parse_status='manual' WHERE cinmed_id='${cid}';`,
		);
	}
}

const outPath = resolve(ROOT, 'server/sql/migrations/packaging-structured.sql');
writeFileSync(outPath, lines.join('\n') + '\n', 'utf-8');

console.log(`wrote ${outPath}`);
console.log(`  ok updates:     ${ok}`);
console.log(`  manual flagged: ${manual}`);

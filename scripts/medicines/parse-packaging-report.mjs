#!/usr/bin/env node
/**
 * Прогон парсера упаковки по data/medicines.json — отчёт покрытия.
 * Запуск: node scripts/medicines/parse-packaging-report.mjs
 */
import { readFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { parsePackaging } from './parse-packaging.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');

const data = JSON.parse(
	readFileSync(resolve(ROOT, 'data/medicines.json'), 'utf-8'),
);
const items = data.medicines || data;

let ok = 0;
let manual = 0;
let noText = 0;
const unitCounts = {};
const containerCounts = {};
const manualSamples = [];

for (const it of items) {
	const text = (it.detail_packaging || it.packaging || '').trim();
	if (!text) {
		noText++;
		continue;
	}
	const r = parsePackaging(text);
	if (r.status === 'ok') {
		ok++;
		unitCounts[r.unit] = (unitCounts[r.unit] || 0) + 1;
		if (r.container)
			containerCounts[r.container] = (containerCounts[r.container] || 0) + 1;
	} else {
		manual++;
		if (manualSamples.length < 40) manualSamples.push(text);
	}
}

const total = ok + manual + noText;
console.log(`total medicines: ${total}`);
console.log(
	`  ok:     ${ok} (${((100 * ok) / total).toFixed(1)}%)`,
);
console.log(
	`  manual: ${manual} (${((100 * manual) / total).toFixed(1)}%)`,
);
console.log(`  no text: ${noText}`);

console.log('\n--- unit distribution (ok rows) ---');
for (const [u, c] of Object.entries(unitCounts).sort((a, b) => b[1] - a[1]))
	console.log(`  ${String(c).padStart(5)} ${u}`);

console.log('\n--- container distribution (ok rows) ---');
for (const [u, c] of Object.entries(containerCounts).sort((a, b) => b[1] - a[1]))
	console.log(`  ${String(c).padStart(5)} ${u}`);

console.log('\n--- manual samples (up to 40 distinct) ---');
for (const s of [...new Set(manualSamples)]) console.log('  -', s.slice(0, 110));

#!/usr/bin/env node
/**
 * Ищет в medical_service_tariffs названия, сдвинутые на соседний код.
 *
 * Как возник дефект: при слиянии OCR и LLM-разбора прайса в `*-FINAL.json`
 * (scripts/fzocg/merge_to_final.py) для части блоков имя бралось из LLM, а код
 * и цена — из построчного OCR (PaddleOCR). Там, где LLM пропускал или
 * склеивал строку, имена съезжали на соседнюю позицию, а цены — нет. Импорт в
 * БД шёл из FINAL, поэтому на странице услуги под верным кодом и верной ценой
 * стоит название соседней позиции: у X01036 (биопсия щитовидной железы) —
 * «катетеризация мочевого пузыря у мужчин».
 *
 * Эталон — построчный OCR (`paddleocr/*.items.json`): там код, имя и цена
 * читаются из одной строки таблицы. Он без диакритики и местами с мусором,
 * поэтому исправленное имя берётся не из OCR, а из FINAL — у той позиции,
 * чьё OCR-имя совпадает с нашим. То есть имена переставляются на свои коды,
 * а не переписываются.
 *
 * Выход — data/fzocg/_shifted-tariff-names.json: по строке на каждое
 * расхождение с предложенным исправлением и уверенностью.
 *
 * Usage: node scripts/fzocg/find-shifted-tariff-names.mjs [--source fzocg-sekundarna]
 */

import mysql from 'mysql2/promise';
import { readFileSync, readdirSync, writeFileSync, existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const DIR = resolve(ROOT, 'data/fzocg');

/** tariff_source → папка прайса */
const SOURCES = {
	'fzocg-sekundarna': 'sekundarna-ostalo',
	'fzocg-pzz': 'primarna-zdravstvena-zastita',
	'fzocg-van-mreze': 'van-mreze',
	'fzocg-transfuziologija': 'transfuziologija',
};
const argSrc = process.argv.indexOf('--source');
const only = argSrc > -1 ? process.argv[argSrc + 1] : null;

const fold = (s) =>
	(s || '')
		.toLowerCase()
		.normalize('NFD')
		.replace(/\p{M}/gu, '')
		.replace(/đ/g, 'd')
		.replace(/[^a-z0-9]+/g, ' ')
		.trim();
/**
 * Сходство по символьным триграммам (коэффициент Дайса): OCR пишет «Ekstrakciia»,
 * «glaveivrata», «Sklerozaciia» — пословное сравнение на такой строке ломается,
 * триграммное терпит опечатку в одной-двух буквах.
 */
function trigrams(s) {
	const t = ` ${fold(s)} `;
	const out = new Map();
	for (let i = 0; i < t.length - 2; i++) {
		const g = t.slice(i, i + 3);
		out.set(g, (out.get(g) || 0) + 1);
	}
	return out;
}
function similarity(a, b) {
	const x = trigrams(a);
	const y = trigrams(b);
	let common = 0;
	let total = 0;
	for (const [g, n] of x) {
		common += Math.min(n, y.get(g) || 0);
		total += n;
	}
	for (const n of y.values()) total += n;
	return total ? (2 * common) / total : 0;
}
/** OCR-строка без смысла: одно слово, код вместо имени, «cYaGentaoY». */
const junk = (s) => fold(s).split(' ').filter((w) => w.length > 2).length < 2 || /[a-z][A-Z]{1,}[a-z]+[A-Z]/.test(s) || /^[A-Z]\d{5}$/.test(s.trim());

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [rows] = await db.query(
	`SELECT t.id, t.tariff_source src, t.code, t.name_sr_latin name, t.medical_service_id sid, t.lab_test_id lid,
	        s.slug, s.name_sr service_sr
	   FROM medical_service_tariffs t LEFT JOIN medical_services s ON s.id = t.medical_service_id`,
);
await db.end();

const out = [];
for (const [src, folder] of Object.entries(SOURCES)) {
	if (only && only !== src) continue;
	const pdir = resolve(DIR, folder, 'paddleocr');
	if (!existsSync(pdir)) continue;

	// OCR: код → все имена по всем документам (база + поправки)
	const ocr = new Map();
	for (const f of readdirSync(pdir).filter((f) => f.endsWith('.items.json'))) {
		const j = JSON.parse(readFileSync(resolve(pdir, f), 'utf-8'));
		for (const it of Array.isArray(j) ? j : j.items || []) {
			if (!it.code || !it.name) continue;
			if (!ocr.has(it.code)) ocr.set(it.code, []);
			ocr.get(it.code).push(it.name);
		}
	}
	const final = JSON.parse(readFileSync(resolve(DIR, folder, `${folder}-FINAL.json`), 'utf-8'));
	const finalByCode = new Map();
	for (const it of final.items || []) if (!finalByCode.has(it.code)) finalByCode.set(it.code, it.name);

	const srcRows = rows.filter((r) => r.src === src);
	for (const r of srcRows) {
		const names = ocr.get(r.code);
		if (!names) continue;
		const best = Math.max(...names.map((n) => similarity(n, r.name)));
		if (best >= 0.55) continue;
		// OCR-имя этой строки мусорное (одно слово, цифры) — сверять не с чем
		const ocrName = [...names].sort((a, b) => b.length - a.length)[0];
		const ocrUsable = !junk(ocrName);
		const ocrName2 = names.find((n) => !junk(n)) || ocrName;

		// Чьё FINAL-имя совпадает с OCR-именем нашего кода — то имя и наше
		let fix = null;
		let fixFrom = null;
		let fixScore = 0;
		if (ocrUsable) {
			for (const [code, fname] of finalByCode) {
				const sc = similarity(fname, ocrName2);
				if (sc > fixScore) [fix, fixFrom, fixScore] = [fname, code, sc];
			}
		}
		// Наше текущее имя принадлежит какому коду по OCR — показывает направление сдвига
		let ownerCode = null;
		let ownerScore = 0;
		for (const [code, ns] of ocr) {
			const sc = Math.max(...ns.map((n) => similarity(n, r.name)));
			if (sc > ownerScore) [ownerCode, ownerScore] = [code, sc];
		}
		out.push({
			src, code: r.code, tariff_id: r.id, service: r.slug, lab_test_id: r.lid,
			db_name: r.name, ocr_name: ocrName,
			db_name_belongs_to: ownerScore >= 0.6 ? ownerCode : null,
			fix: fixScore >= 0.6 ? fix : null, fix_from: fixScore >= 0.6 ? fixFrom : null, fix_score: +fixScore.toFixed(2),
			db_vs_ocr: +best.toFixed(2), ocr_junk: !ocrUsable,
			confidence: !ocrUsable ? 'ocr-junk' : fixScore >= 0.75 ? 'high' : fixScore >= 0.6 ? 'medium' : 'none',
		});
	}
}

writeFileSync(resolve(DIR, '_shifted-tariff-names.json'), JSON.stringify(out, null, '\t') + '\n');
const by = {};
for (const o of out) by[`${o.src} ${o.confidence}`] = (by[`${o.src} ${o.confidence}`] || 0) + 1;
console.log(`расхождений: ${out.length}`, JSON.stringify(by));

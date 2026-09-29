#!/usr/bin/env node
/**
 * Раскладывает услуги по батчам для вычитки названий (docs/audit/service-names-2026-09.md):
 *
 *   data/service-names/_batch-fix-NN.json     — шаг 1: механические дефекты по всему
 *                                               каталогу (ekavica_sr, diacritics_sr, truncated_ru);
 *   data/service-names/_batch-review-NN.json  — шаг 2: полная вычитка + синонимы
 *                                               для услуг с клиниками >= --min-clinics.
 *
 * Агенту нужны факты, иначе он допишет названия по общим знаниям: поэтому в
 * ростере все шесть локалей, категории, специальности, уже существующие синонимы,
 * официальное название позиции из прайса FZOCG и подсказки сканера.
 *
 * Батчи шага 2 собраны по самой узкой категории услуги и отсортированы по
 * name_en — серия («Rendgen …», «Pregled …») попадает к одному агенту целиком,
 * и формулировки внутри серии выходят одинаковыми.
 *
 * Требует свежий data/service-names/_flags.json (scan-name-quality.mjs).
 *
 * Usage: node scripts/services/build-name-review-roster.mjs [--min-clinics 3] [--review-size 45] [--fix-size 40]
 */

import mysql from 'mysql2/promise';
import { readFileSync, readdirSync, unlinkSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');
const DIR = resolve(ROOT, 'data/service-names');

const arg = (name, fallback) => {
	const i = process.argv.indexOf(name);
	return i > -1 ? Number(process.argv[i + 1]) : fallback;
};
const MIN_CLINICS = arg('--min-clinics', 3);
const REVIEW_SIZE = arg('--review-size', 45);
const FIX_SIZE = arg('--fix-size', 40);

/** Классы сканера, которые чинятся на шаге 1. Остальные идут подсказками в шаг 2. */
const MECHANICAL = ['ekavica_sr', 'diacritics_sr', 'truncated_ru'];
const HINTS = [...MECHANICAL, 'copy_of_en', 'short_vs_en'];

const flagsReport = JSON.parse(readFileSync(resolve(DIR, '_flags.json'), 'utf-8'));
const hintsById = new Map();
for (const kind of HINTS) {
	for (const f of flagsReport[kind] || []) {
		if (!hintsById.has(f.id)) hintsById.set(f.id, []);
		hintsById.get(f.id).push(f.detail ? `${kind}: ${f.detail}` : kind);
	}
}
const mechanicalIds = new Set(MECHANICAL.flatMap((k) => (flagsReport[k] || []).map((f) => f.id)));

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const q = async (sql) => (await db.query(sql))[0];

const services = await q(`
	SELECT s.id, s.slug, s.name_en, s.name_sr, s.name_sr_cyrl, s.name_ru, s.name_de, s.name_tr,
	       COUNT(DISTINCT cs.clinic_id) AS clinics
	  FROM medical_services s
	  LEFT JOIN clinic_medical_services cs ON cs.medical_service_id = s.id
	 GROUP BY s.id`);
const categories = await q(`
	SELECT rel.medical_service_id AS id, cat.name
	  FROM medical_service_categories_relations rel
	  JOIN medical_service_categories cat ON cat.id = rel.medical_service_category_id`);
const specialties = await q(`
	SELECT rsp.medical_service_id AS id, sp.name
	  FROM medical_services_specialties rsp
	  JOIN specialties sp ON sp.id = rsp.specialty_id`);
const synonyms = await q(`SELECT medical_service_id AS id, language, another_name FROM medical_service_synonyms`);
const tariffs = await q(`
	SELECT medical_service_id AS id, tariff_source, code, name_sr_latin
	  FROM medical_service_tariffs
	 WHERE medical_service_id IS NOT NULL AND name_sr_latin IS NOT NULL
	 ORDER BY tariff_source, code`);
await db.end();

const group = (rows, value) => {
	const map = new Map();
	for (const r of rows) {
		if (!map.has(r.id)) map.set(r.id, []);
		map.get(r.id).push(value(r));
	}
	return map;
};
const catsById = group(categories, (r) => r.name);
const specsById = group(specialties, (r) => r.name);
const tariffsById = group(tariffs, (r) => ({ source: r.tariff_source, code: r.code, name: r.name_sr_latin }));
const synsById = new Map();
for (const r of synonyms) {
	if (!synsById.has(r.id)) synsById.set(r.id, {});
	(synsById.get(r.id)[r.language] ||= []).push(r.another_name);
}

// Размер категории — чтобы выбрать у услуги самую узкую: «Ambulatory Surgery,
// Cardiology» относится к кардиологии, а не к амбулаторной хирургии.
const catSize = new Map();
for (const c of categories) catSize.set(c.name, (catSize.get(c.name) || 0) + 1);
const primaryCategory = (id) =>
	(catsById.get(id) || []).sort((a, b) => catSize.get(a) - catSize.get(b) || a.localeCompare(b))[0] || '(без категории)';

// Правки шага 1 накрывают БД: агент вычитки должен видеть уже починенное
// название, а не обрубок, иначе он починит его ещё раз и по-своему, и два
// батча разойдутся в одной строке (сборщик применит последний).
const fixedBySlug = new Map();
for (const f of readdirSync(DIR).filter((f) => /^fix-\d+\.json$/.test(f)).sort()) {
	for (const item of JSON.parse(readFileSync(resolve(DIR, f), 'utf-8'))) {
		if (item.names && Object.keys(item.names).length) fixedBySlug.set(item.slug, item.names);
	}
}

const card = (s) => ({
	slug: s.slug,
	id: s.id,
	clinics: s.clinics,
	categories: catsById.get(s.id) || [],
	specialties: specsById.get(s.id) || [],
	names: { en: s.name_en, sr: s.name_sr, sr_cyrl: s.name_sr_cyrl, ru: s.name_ru, de: s.name_de, tr: s.name_tr },
	existing_synonyms: synsById.get(s.id) || {},
	fzocg: (tariffsById.get(s.id) || []).slice(0, 3),
	hints: hintsById.get(s.id) || [],
});

/** Карточка шага 2 с наложенными правками шага 1. */
const reviewCard = (s) => {
	const c = card(s);
	const fixed = fixedBySlug.get(s.slug);
	if (!fixed) return c;
	for (const [loc, value] of Object.entries(fixed)) {
		c.hints.push(`шаг 1 уже поправил ${loc}: «${c.names[loc]}» → «${value}» — не переделывай без причины`);
		c.names[loc] = value;
	}
	return c;
};

// Пересборка не должна оставлять хвост из батчей прошлого прогона с другим размером.
// Номера от 90 — ручные батчи (README), их ростеры пишутся руками и не пересобираются.
for (const f of readdirSync(DIR)) {
	const m = f.match(/^_batch-(fix|review)-(\d+)\.json$/);
	if (m && Number(m[2]) < 90) unlinkSync(resolve(DIR, f));
}

const write = (kind, n, items) =>
	writeFileSync(resolve(DIR, `_batch-${kind}-${String(n).padStart(2, '0')}.json`), JSON.stringify(items, null, '\t') + '\n');

// ── Шаг 1: подряд по id — партия FZOCG лежит плотно, и её серии не разрываются.
const fixRows = services.filter((s) => mechanicalIds.has(s.id)).sort((a, b) => a.id - b.id);
let fixBatches = 0;
for (let i = 0; i < fixRows.length; i += FIX_SIZE) write('fix', ++fixBatches, fixRows.slice(i, i + FIX_SIZE).map(card));

// ── Шаг 2: группы по узкой категории. Крупная группа режется на РАВНЫЕ части
// (139 → 4×35, а не 45+45+45+4: огрызок из четырёх услуг — это агент, который
// не видит серию), мелкие упаковываются вместе first-fit decreasing.
const byCategory = new Map();
for (const s of services.filter((s) => s.clinics >= MIN_CLINICS)) {
	const c = primaryCategory(s.id);
	if (!byCategory.has(c)) byCategory.set(c, []);
	byCategory.get(c).push(s);
}
const chunks = [];
for (const rows of byCategory.values()) {
	rows.sort((a, b) => a.name_en.localeCompare(b.name_en));
	const parts = Math.ceil(rows.length / REVIEW_SIZE);
	const size = Math.ceil(rows.length / parts);
	for (let i = 0; i < rows.length; i += size) chunks.push(rows.slice(i, i + size));
}
chunks.sort((a, b) => b.length - a.length);

const reviewBatches = [];
for (const chunk of chunks) {
	const bin = reviewBatches.find((b) => b.length + chunk.length <= REVIEW_SIZE);
	if (bin) bin.push(...chunk);
	else reviewBatches.push([...chunk]);
}
reviewBatches.forEach((rows, i) => write('review', i + 1, rows.map(reviewCard)));

const reviewCount = reviewBatches.reduce((n, b) => n + b.length, 0);
console.log(`шаг 1: ${fixRows.length} услуг → ${fixBatches} батчей по ≤${FIX_SIZE}`);
console.log(`шаг 2: ${reviewCount} услуг (клиник >= ${MIN_CLINICS}) → ${reviewBatches.length} батчей по ≤${REVIEW_SIZE}`);
for (const [i, rows] of reviewBatches.entries()) {
	const cats = [...new Set(rows.map((r) => primaryCategory(r.id)))];
	console.log(`  review-${String(i + 1).padStart(2, '0')}: ${String(rows.length).padStart(2)}  ${cats.slice(0, 4).join(', ')}${cats.length > 4 ? ` +${cats.length - 4}` : ''}`);
}

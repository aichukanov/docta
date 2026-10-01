#!/usr/bin/env node
/**
 * План исправления сдвинутых строк тарифов FZOCG (детектор —
 * find-shifted-tariff-names.mjs, разбор — docs/audit/service-names-2026-09.md).
 *
 * Дефект: при слиянии OCR и LLM-разбора в `*-FINAL.json` часть строк LLM
 * съехала на соседнюю позицию. Иногда только имя (цену брали из OCR), иногда
 * имя вместе с ценой (цену брали из того же LLM-ответа). Импорт в БД шёл из
 * FINAL, и на странице услуги под верным кодом стоит чужое название, а местами
 * и чужая цена.
 *
 * Три независимых источника:
 *   - построчный OCR — код, имя и цена из одной строки таблицы; без диакритики
 *     и местами мусор, но позиции обычно не путает (исключение — блок PZZ H01,
 *     там сдвинут сам OCR);
 *   - название услуги, к которой привязан тариф: его писали по прайсу клиники;
 *   - цены клиник 88 и 137: их прайс — FZOCG × 2,5 к колонке «odjeljenje»
 *     (у операций — к «operacija»), так что цена клиники по коду выдаёт,
 *     какой строке FINAL она на самом деле соответствует.
 *
 * Решение для строки:
 *   1) имя в БД совпадает с названием услуги (или с OCR) — это шум, не дефект;
 *   2) иначе ищется «донор» — строка FINAL того же прайса, чьё имя совпадает с
 *      эталоном (отремонтированный OCR, а если он мусор — название услуги);
 *   3) цена клиники = 2,5 × собственная цена тарифа → съехало только имя:
 *      чиним имя. Цена клиники = 2,5 × цена донора → съехала строка целиком:
 *      берём у донора имя и цены. Ни то, ни другое → вручную;
 *   4) у тарифа без клиник — только имя и только когда OCR и донор дают одно
 *      и то же, а цена в FINAL взята из OCR.
 *
 * Выход: data/fzocg/_tariff-name-fixes.json { fix, manual, ok }.
 *
 * Usage: node scripts/fzocg/plan-tariff-name-fixes.mjs
 */

import mysql from 'mysql2/promise';
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';
import { createRepairer } from './ocr-name-repair.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const DIR = resolve(ROOT, 'data/fzocg');
const FOLDER = {
	'fzocg-sekundarna': 'sekundarna-ostalo',
	'fzocg-pzz': 'primarna-zdravstvena-zastita',
	'fzocg-van-mreze': 'van-mreze',
	'fzocg-transfuziologija': 'transfuziologija',
};
const MULTIPLIER_CLINICS = [88, 137];
const MULTIPLIER = 2.5;
/** Колонки цен: в FINAL и в БД они называются одинаково (generate_tariff_sql.py). */
const PRICE_COLS = ['price_eur', 'price_odjeljenje_eur', 'price_ambulanta_eur', 'price_operacija_eur', 'price_anestezija_eur', 'price_ukupno_eur'];

const fold = (s) => (s || '').toLowerCase().normalize('NFD').replace(/\p{M}/gu, '').replace(/đ/g, 'd').replace(/[^a-z0-9]+/g, ' ').trim();
function sim(a, b) {
	const g = (s) => {
		const t = ` ${fold(s)} `;
		const m = new Map();
		for (let i = 0; i < t.length - 2; i++) m.set(t.slice(i, i + 3), (m.get(t.slice(i, i + 3)) || 0) + 1);
		return m;
	};
	const x = g(a);
	const y = g(b);
	let c = 0;
	let n = 0;
	for (const [k, v] of x) { c += Math.min(v, y.get(k) || 0); n += v; }
	for (const v of y.values()) n += v;
	return n ? (2 * c) / n : 0;
}

const detected = JSON.parse(readFileSync(resolve(DIR, '_shifted-tariff-names.json'), 'utf-8'));
// Сдвиги к соседу по серии (find-sibling-shifted-tariff-names.mjs): имена отличаются одним словом, и триграммный
// детектор их не видит. Слово-различие уже сверено с названием услуги, поэтому проверка
// «имя похоже на услугу» к ним не применяется. PZZ не берём: там местами сдвинут сам OCR.
const seen = new Set(detected.map((d) => d.tariff_id));
for (const h of JSON.parse(readFileSync(resolve(DIR, '_sibling-shifts.json'), 'utf-8'))) {
	if (h.src !== 'fzocg-sekundarna') continue;
	// Уже найден триграммным детектором — помечаем, иначе правило «похоже на OCR» его отбросит
	if (seen.has(h.tariff_id)) {
		detected.find((d) => d.tariff_id === h.tariff_id).sibling = true;
		continue;
	}
	detected.push({ src: h.src, code: h.code, tariff_id: h.tariff_id, service: h.slug, lab_test_id: null, db_name: h.db, ocr_name: h.ocr, ocr_junk: false, sibling: true });
}
const finals = {};
for (const [src, folder] of Object.entries(FOLDER)) {
	finals[src] = JSON.parse(readFileSync(resolve(DIR, folder, `${folder}-FINAL.json`), 'utf-8')).items;
}

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [tariffs] = await db.query('SELECT * FROM medical_service_tariffs');
const [svcRows] = await db.query('SELECT slug, name_sr FROM medical_services');
const [labRows] = await db.query('SELECT id, name_sr FROM lab_tests');
const [clinicPrices] = await db.query(
	`SELECT code, price FROM clinic_medical_services WHERE clinic_id IN (?) AND price IS NOT NULL AND code IS NOT NULL
	 UNION ALL
	 SELECT code, price FROM clinic_lab_tests WHERE clinic_id IN (?) AND price IS NOT NULL AND code IS NOT NULL`,
	[MULTIPLIER_CLINICS, MULTIPLIER_CLINICS],
);
await db.end();

const serviceSr = new Map(svcRows.map((r) => [r.slug, r.name_sr]));
const donorsBySrc = new Map();
for (const t of tariffs) {
	if (!donorsBySrc.has(t.tariff_source)) donorsBySrc.set(t.tariff_source, []);
	const row = { code: t.code, name: t.name_sr_latin };
	for (const c of PRICE_COLS) row[c] = t[c] == null ? null : Number(t[c]);
	donorsBySrc.get(t.tariff_source).push(row);
}
const labSr = new Map(labRows.map((r) => [r.id, r.name_sr]));
const pricesByCode = new Map();
for (const r of clinicPrices) {
	if (!pricesByCode.has(r.code)) pricesByCode.set(r.code, []);
	pricesByCode.get(r.code).push(Number(r.price));
}

// Словарь ремонта OCR — только из чистых имён: LLM-имена FINAL и названия каталога.
const clean = [...svcRows.map((r) => r.name_sr), ...labRows.map((r) => r.name_sr)];
for (const items of Object.values(finals)) for (const it of items) if (it.name && !String(it._sources?.name || '').startsWith('paddle')) clean.push(it.name);
const repair = createRepairer(clean);

const bases = (row) => [row.price_odjeljenje_eur, row.price_operacija_eur, row.price_eur, row.price_ambulanta_eur].filter((v) => v != null).map(Number);
/** Совпадает ли цена клиник по коду с ценами этой строки (тариф из БД или элемент FINAL). */
/** «ambulanta» = 2,138 × «odjeljenje» у 816 строк FINAL, поэтому к ней коэффициент клиник 2,5 / 2,138. */
const AMBULANTA_MULTIPLIER = MULTIPLIER / 2.138;
const clinicMatches = (code, row) =>
	(pricesByCode.get(code) || []).some(
		(p) =>
			bases(row).some((b) => Math.abs(p - b * MULTIPLIER) < 0.02) ||
			(row.price_ambulanta_eur != null && Math.abs(p - Number(row.price_ambulanta_eur) * AMBULANTA_MULTIPLIER) < 0.03),
	);

const fix = [];
const manual = [];
const ok = [];
for (const d of detected) {
	const t = tariffs.find((x) => x.id === d.tariff_id);
	const own = finals[d.src].find((x) => x.code === d.code);
	const reference = d.service ? serviceSr.get(d.service) : d.lab_test_id ? labSr.get(d.lab_test_id) : null;
	const repaired = d.ocr_junk ? null : repair(d.ocr_name);
	// Обрывок строки таблицы: OCR прихватил соседнюю колонку с ценой («…gel metoda 4.37 .»)
	const tableJunk = (s) => /\d+[.,]\d{2}\b/.test(s) || /\s[.,]\s*$/.test(s);
	const ocrClean = repaired && !repaired.unresolved.length && !tableJunk(repaired.name) ? repaired.name : null;
	const base = { src: d.src, code: d.code, tariff_id: d.tariff_id, service: d.service, lab_test_id: d.lab_test_id, db_name: d.db_name, ocr_name: d.ocr_name, reference };

	// 1) не дефект: имя БД совпадает с услугой или с OCR
	if (!d.sibling && reference && sim(reference, d.db_name) >= 0.6) {
		ok.push({ ...base, why: 'имя совпадает с услугой' });
		continue;
	}
	if (!d.sibling && ocrClean && sim(ocrClean, d.db_name) >= 0.8) {
		ok.push({ ...base, why: 'расхождение только в шуме OCR' });
		continue;
	}
	// Услуга совпадает с именем БД, а не с OCR — сдвинут сам OCR (блок PZZ H01)
	if (!d.sibling && reference && ocrClean && sim(reference, ocrClean) < sim(reference, d.db_name) + 0.1) {
		manual.push({ ...base, proposed: ocrClean, why: 'название услуги не подтверждает OCR — сдвинут, похоже, сам OCR' });
		continue;
	}

	// 2) эталон и донор
	const target = ocrClean || reference;
	if (!target) {
		manual.push({ ...base, why: d.ocr_junk ? 'OCR нечитаем, а услуги нет — сверить с PDF' : `в OCR нераспознанные слова: ${repaired.unresolved.join(', ')}` });
		continue;
	}
	let donor = null;
	let donorScore = 0;
	// Донор — из таблицы тарифов, а не из FINAL.json: FINAL сборщик 038 правит теми же
	// исправлениями, и после этого у «донора» лежали бы уже починенные имя и цены.
	// В БД — ровно то, что импортировано из исходного FINAL, со сдвигами.
	for (const it of donorsBySrc.get(d.src) || []) {
		if (it.code === d.code || !it.name) continue;
		const sc = sim(it.name, target);
		if (sc > donorScore) [donor, donorScore] = [it, sc];
	}
	if (donorScore < 0.7) donor = null;
	// Имя FINAL чище OCR (диакритика, пробелы у дефиса), но берётся, только если совпадает с OCR почти дословно
	// Из двух почти одинаковых вариантов — тот, где больше диакритики: у донора в БД бывает «grade» вместо «građe»
	const dia = (x) => (x.match(/[čćžšđČĆŽŠĐ]/g) || []).length;
	let newName = ocrClean && donor && sim(ocrClean, donor.name) >= 0.95 && dia(donor.name) >= dia(ocrClean) ? donor.name : ocrClean || donor?.name || null;
	if (!newName) {
		manual.push({ ...base, why: 'OCR нечитаем и донор по названию услуги не нашёлся — сверить с PDF' });
		continue;
	}
	newName = newName[0].toUpperCase() + newName.slice(1);

	// 3) что съехало — решают цены клиник
	if (pricesByCode.has(d.code)) {
		if (clinicMatches(d.code, t)) {
			fix.push({ ...base, new_name: newName, prices: null, how: 'съехало только имя — цена клиник подтверждает цену тарифа' });
		} else if (donor && clinicMatches(d.code, donor)) {
			const prices = Object.fromEntries(PRICE_COLS.map((c) => [c, donor[c] ?? null]));
			fix.push({ ...base, new_name: newName, prices, donor: donor.code, how: `съехала строка целиком — имя и цены из ${donor.code} (цена клиник = 2,5 × цена донора)` });
		} else {
			manual.push({ ...base, proposed: newName, donor: donor?.code, why: 'цена клиник не сходится ни с тарифом, ни с донором' });
		}
		continue;
	}
	// 4) без клиник — только имя, только при двух согласных сигналах и цене из OCR
	const priceFromOcr = String(own?._sources?.price || '').startsWith('paddle');
	if (ocrClean && donor && sim(ocrClean, donor.name) >= 0.9 && priceFromOcr) {
		fix.push({ ...base, new_name: newName, prices: null, how: 'без клиник: OCR и донор согласны, цена из OCR' });
	} else {
		manual.push({ ...base, proposed: newName, why: 'без клиник и без двух согласных сигналов — сверить с PDF' });
	}
}

// Ручные решения (_tariff-overrides.json) — там, где автомату не хватило сигнала, а имя и
// цену подтверждают OCR, прайс Данило и цены клиник. Перекрывают автомат для своих кодов.
for (const o of JSON.parse(readFileSync(resolve(DIR, '_tariff-overrides.json'), 'utf-8'))) {
	const t = tariffs.find((x) => x.tariff_source === o.src && x.code === o.code);
	if (!t) throw new Error(`override: нет тарифа ${o.src}/${o.code}`);
	for (const list of [fix, manual, ok]) {
		const i = list.findIndex((x) => x.tariff_id === t.id);
		if (i > -1) list.splice(i, 1);
	}
	const prices = PRICE_COLS.some((c) => o[c] !== undefined)
		? Object.fromEntries(PRICE_COLS.map((c) => [c, o[c] !== undefined ? o[c] : t[c] == null ? null : Number(t[c])]))
		: null;
	fix.push({ src: o.src, code: o.code, tariff_id: t.id, db_name: t.name_sr_latin, new_name: o.name, prices, how: `вручную: ${o.why}` });
}

writeFileSync(resolve(DIR, '_tariff-name-fixes.json'), JSON.stringify({ fix, manual, ok }, null, '\t') + '\n');
console.log(`чиним: ${fix.length} (имя: ${fix.filter((f) => !f.prices).length}, строка целиком: ${fix.filter((f) => f.prices).length}); не дефект: ${ok.length}; вручную: ${manual.length}`);
const why = {};
for (const m of manual) why[m.why.replace(/:.*/, '')] = (why[m.why.replace(/:.*/, '')] || 0) + 1;
for (const [k, v] of Object.entries(why)) console.log(`  ${String(v).padStart(3)}  ${k}`);

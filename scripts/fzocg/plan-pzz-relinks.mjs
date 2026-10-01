#!/usr/bin/env node
/**
 * PZZ-тарифы, привязанные к больничным услугам по совпадению кода.
 *
 * Коды первичного (PZZ) и секундарного прайсов FZOCG пересекаются и значат
 * разное: X01025 в PZZ — «Stavljanje IUD», в секундарном — биопсия лимфоузла;
 * L01001 в PZZ — патронаж новорождённого, в секундарном — гистология
 * аппендикса. Импорт тарифов связывал их с каталогом по голому коду клиник,
 * и PZZ-позиция повисала на больничной услуге с тем же кодом.
 *
 * Правило: PZZ-тариф вправе висеть на услуге, только если её держит ДОМ
 * ЗДОРОВЬЯ с этим кодом — с префиксом (HN_, MO_HN_, MO_, суффикс _KO) или
 * без него (ДЗ Херцег-Нови и Даниловград местами пишут код голым). Больницы
 * (88 Данило, 131 Рисан, 137 Никшич) работают по секундарному прайсу, и
 * их голый код — секундарный.
 *
 * Если оправдания нет: тариф переносится на услугу, где этот код держит дом
 * здоровья, а если такой нет — отвязывается (medical_service_id = NULL;
 * по коду в поиске он находиться продолжит).
 *
 * Блок J06 у ДЗ Херцег-Нови не переносится: нумерация там своя и с FZOCG не
 * совпадает (см. память о дедупликации 027–034).
 *
 * Выход: data/fzocg/_pzz-relinks.json
 *
 * Usage: node scripts/fzocg/plan-pzz-relinks.mjs
 */

import mysql from 'mysql2/promise';
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const HOSPITALS = new Set([88, 131, 137]);

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [clinicCols] = await db.query('SHOW COLUMNS FROM clinics');
const nameCol = clinicCols.map((c) => c.Field).find((f) => /^name/.test(f));
const [clinics] = await db.query(`SELECT id, ${nameCol} AS n FROM clinics`);
const [tariffs] = await db.query(
	`SELECT t.id, t.code, t.name_sr_latin n, t.medical_service_id sid, s.slug
	   FROM medical_service_tariffs t JOIN medical_services s ON s.id = t.medical_service_id
	  WHERE t.tariff_source = 'fzocg-pzz'`,
);
const [rows] = await db.query('SELECT medical_service_id sid, clinic_id c, code FROM clinic_medical_services WHERE code IS NOT NULL');
const [services] = await db.query('SELECT id, slug, name_sr FROM medical_services');
await db.end();

const primaryCare = new Set(clinics.filter((c) => /dom zdravlja/i.test(c.n || '')).map((c) => c.id));
const slugById = new Map(services.map((s) => [s.id, s.slug]));
const serviceSr = new Map(services.map((s) => [s.id, s.name_sr]));
const bare = (code) => code.replace(/^(MO_HN_|HN_|MO_)/, '').replace(/_KO$/, '');
const prefixed = (code) => /^(MO_HN_|HN_|MO_)|_KO$/.test(code);

/** Услуги, где дом здоровья держит этот PZZ-код. */
const holders = new Map();
for (const r of rows) {
	if (!(primaryCare.has(r.c) || prefixed(r.code)) || HOSPITALS.has(r.c)) continue;
	const k = bare(r.code);
	if (!holders.has(k)) holders.set(k, new Map());
	holders.get(k).set(r.sid, (holders.get(k).get(r.sid) || 0) + 1);
}

const fold = (x) => (x || '').toLowerCase().normalize('NFD').replace(/\p{M}/gu, '').replace(/đ/g, 'd').replace(/[^a-z0-9]+/g, ' ').trim();
function sim(x, y) {
	const g = (v) => {
		const t = ` ${fold(v)} `;
		const m = new Map();
		for (let i = 0; i < t.length - 2; i++) m.set(t.slice(i, i + 3), (m.get(t.slice(i, i + 3)) || 0) + 1);
		return m;
	};
	const p = g(x);
	const q = g(y);
	let c = 0;
	let n = 0;
	for (const [k, v] of p) { c += Math.min(v, q.get(k) || 0); n += v; }
	for (const v of q.values()) n += v;
	return n ? (2 * c) / n : 0;
}

// Код ДЗ как указатель цели НЕ годится: у ДЗ Херцег-Нови коды местами сдвинуты
// (как блок I03, миграция 033), и перенос по ним сажает «Bris oka» на мазок из уха,
// а кислород — на клизму. Цель ищется по названию, а ошибкой считается только
// привязка, где PZZ-название явно не о той услуге.
const UNRELATED = 0.3;
const TARGET = 0.7;
const plan = [];
for (const t of tariffs) {
	const where = holders.get(t.code);
	if (where?.has(t.sid)) continue; // дом здоровья держит код на этой услуге — привязка верна
	const current = serviceSr.get(t.sid);
	const now = sim(t.n, current);
	if (now >= UNRELATED) continue; // по смыслу та же процедура — оставляем
	let best = null;
	let bestScore = 0;
	for (const s2 of services) {
		if (s2.id === t.sid) continue;
		const sc = sim(t.n, s2.name_sr);
		if (sc > bestScore) [best, bestScore] = [s2, sc];
	}
	const target = bestScore >= TARGET ? best : null;
	plan.push({
		tariff_id: t.id,
		code: t.code,
		pzz_name: t.n,
		from: t.slug,
		from_sr: current,
		to: target?.slug || null,
		to_sr: target?.name_sr || null,
		action: target ? 'relink' : 'unlink',
		why: target
			? `PZZ-позиция не о «${current}» (сходство ${now.toFixed(2)}); по названию это «${target.name_sr}» (${bestScore.toFixed(2)})`
			: `PZZ-позиция не о «${current}» (сходство ${now.toFixed(2)}), подходящей услуги в каталоге нет — отвязываем`,
	});
}

// Ручные решения: цель подтверждена и смыслом, и кодом двух домов здоровья сразу.
for (const o of JSON.parse(readFileSync(resolve(ROOT, 'data/fzocg/_pzz-relink-overrides.json'), 'utf-8'))) {
	const p = plan.find((x) => x.code === o.code);
	const target = services.find((s) => s.slug === o.to);
	if (!p || !target) throw new Error(`override ${o.code} → ${o.to}: нет в плане или нет услуги`);
	Object.assign(p, { action: 'relink', to: target.slug, to_sr: target.name_sr, why: `вручную: ${o.why}` });
}

writeFileSync(resolve(ROOT, 'data/fzocg/_pzz-relinks.json'), JSON.stringify(plan, null, '\t') + '\n');
console.log(`PZZ-тарифов на услугах: ${tariffs.length}; перепривязать: ${plan.filter((p) => p.action === 'relink').length}; отвязать: ${plan.filter((p) => p.action === 'unlink').length}`);
for (const p of plan) console.log(`  ${p.action.padEnd(7)} ${p.code} «${p.pzz_name.slice(0, 50)}» | было «${(p.from_sr || '').slice(0, 40)}» → ${p.to_sr ? '«' + p.to_sr.slice(0, 45) + '»' : '∅'}`);

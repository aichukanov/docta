#!/usr/bin/env node
/**
 * Собирает ростеры «что ещё без справки» для анализов и услуг:
 *   data/entity-reference/_roster-lab-tests.json
 *   data/entity-reference/_roster-medical-services.json
 *
 * Аналог `substances/_roster.json`: агенту, который пишет справку, нужны факты
 * (названия во всех локалях, категории, покрытие клиниками), иначе он допишет
 * их по общим знаниям.
 *
 * Из выборки исключаются:
 *   - позиции, у которых справка уже написана (по JSON-батчам, а не по БД:
 *     локальная БД отстаёт от прода);
 *   - выбывающие половинки непринятых миграций дедупликации (027/029/030) —
 *     писать справку для слага, который схлопнется, незачем.
 *
 * Usage: node scripts/entity-reference/build-reference-roster.mjs [--min-clinics 5]
 */

import mysql from 'mysql2/promise';
import { readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '..', '..');
const DATA_DIR = resolve(ROOT, 'data/entity-reference');
const MIGRATIONS = resolve(ROOT, 'server/sql/migrations');

const argMin = process.argv.indexOf('--min-clinics');
const MIN_CLINICS = argMin > -1 ? Number(process.argv[argMin + 1]) : 5;

loadEnv(ROOT);

/** Слаги, для которых справка уже написана (все файлы по префиксу). */
function writtenSlugs(prefix) {
	const out = new Set();
	for (const f of readdirSync(DATA_DIR)) {
		if (!f.startsWith(prefix) || !f.endsWith('.json') || f.startsWith('_')) continue;
		for (const card of JSON.parse(readFileSync(resolve(DATA_DIR, f), 'utf-8'))) {
			out.add(card.slug);
		}
	}
	return out;
}

/** id, которые исчезнут при применении непринятых миграций дедупликации. */
function retiredIds() {
	const svc = new Set();
	const lab = new Set();
	for (const f of readdirSync(MIGRATIONS)) {
		if (!/^(027|029|030)/.test(f)) continue;
		const sql = readFileSync(resolve(MIGRATIONS, f), 'utf-8');
		for (const m of sql.matchAll(/^CALL dedup_merge_medical_service\(\d+,\s*(\d+)\)/gm)) svc.add(+m[1]);
		for (const m of sql.matchAll(/^CALL dedup_move_service_to_lab_test\(\d+,\s*(\d+)/gm)) svc.add(+m[1]);
		for (const m of sql.matchAll(/^CALL dedup_merge_lab_test\(\d+,\s*(\d+)\)/gm)) lab.add(+m[1]);
		for (const m of sql.matchAll(/^CALL dedup_move_lab_test_to_service\(\d+,\s*(\d+)\)/gm)) lab.add(+m[1]);
	}
	return { svc, lab };
}

const db = await mysql.createConnection(dbConfigFromEnv());
const q = async (sql) => (await db.query(sql))[0];
const retired = retiredIds();

const labRows = await q(`
	SELECT t.id, t.slug, t.name_en, t.name_sr, t.name_ru, t.name_de, t.name_tr,
	       COUNT(DISTINCT cl.clinic_id) AS clinics,
	       GROUP_CONCAT(DISTINCT cat.name ORDER BY cat.name SEPARATOR ', ') AS categories
	  FROM lab_tests t
	  LEFT JOIN clinic_lab_tests cl ON cl.lab_test_id = t.id
	  LEFT JOIN lab_test_categories_relations rel ON rel.lab_test_id = t.id
	  LEFT JOIN lab_test_categories cat ON cat.id = rel.category_id
	 GROUP BY t.id
	 ORDER BY clinics DESC, t.name_en`);

const svcRows = await q(`
	SELECT s.id, s.slug, s.name_en, s.name_sr, s.name_ru, s.name_de, s.name_tr,
	       COUNT(DISTINCT cs.clinic_id) AS clinics,
	       GROUP_CONCAT(DISTINCT cat.name ORDER BY cat.name SEPARATOR ', ') AS categories,
	       GROUP_CONCAT(DISTINCT sp.name ORDER BY sp.name SEPARATOR ', ') AS specialties
	  FROM medical_services s
	  LEFT JOIN clinic_medical_services cs ON cs.medical_service_id = s.id
	  LEFT JOIN medical_service_categories_relations rel ON rel.medical_service_id = s.id
	  LEFT JOIN medical_service_categories cat ON cat.id = rel.medical_service_category_id
	  LEFT JOIN medical_services_specialties rsp ON rsp.medical_service_id = s.id
	  LEFT JOIN specialties sp ON sp.id = rsp.specialty_id
	 GROUP BY s.id
	 ORDER BY clinics DESC, s.name_en`);

await db.end();

function build(rows, written, retiredSet, prefixNote) {
	return rows
		.filter((r) => r.clinics >= MIN_CLINICS && !written.has(r.slug) && !retiredSet.has(r.id))
		.map((r, i) => ({ priority: i + 1, ...r, note: prefixNote }));
}

const labs = build(labRows, writtenSlugs('lab-tests'), retired.lab, undefined)
	.map(({ note, ...rest }) => rest);
const svcs = build(svcRows, writtenSlugs('medical-services'), retired.svc, undefined)
	.map(({ note, ...rest }) => rest);

writeFileSync(resolve(DATA_DIR, '_roster-lab-tests.json'), JSON.stringify(labs, null, '\t') + '\n');
writeFileSync(resolve(DATA_DIR, '_roster-medical-services.json'), JSON.stringify(svcs, null, '\t') + '\n');

console.log(`lab tests:        ${labs.length} без справки, клиник >= ${MIN_CLINICS}`);
console.log(`medical services: ${svcs.length} без справки, клиник >= ${MIN_CLINICS}`);

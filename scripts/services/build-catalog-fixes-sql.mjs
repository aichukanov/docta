#!/usr/bin/env node
/**
 * Миграция 038: тарифы FZOCG и дубли, найденные вычиткой названий
 * (docs/audit/service-names-2026-09.md, раздел «038»).
 *
 * Входы (все — результат разбора, руками правятся только решения):
 *   data/fzocg/_tariff-name-fixes.json   — plan-tariff-name-fixes.mjs: сдвинутые имена и цены тарифов
 *   data/fzocg/_pzz-relinks.json         — plan-pzz-relinks.mjs: PZZ-тарифы на чужих услугах
 *   data/service-names/_dedup-decisions.json — слияния, отказы, перенос строк по коду
 *
 * Порядок внутри миграции важен:
 *   1) имена и цены тарифов;
 *   2) перепривязка PZZ-тарифов — цель пропускается через карту слияний, чтобы
 *      тариф не уехал на услугу, которая ниже же сольётся в другую;
 *   3) перенос строк по коду (panoramic-x-ray → J11001) — до слияний, иначе
 *      сливаемые ОПТГ смешались бы с чужой позицией;
 *   4) слияния — процедура из 030, вызов по слагу;
 *   5) отказы — в очередь дублей, чтобы детектор не поднимал их снова;
 *   6) синонимы, совпавшие с собственным названием после слияний (как 031).
 *
 * Всё адресуется по slug и (source, code), а не по id: у локальной БД и прода
 * расходится автоинкремент. UPDATE тарифа идёт только если имя в БД всё ещё
 * старое — повторный прогон и чужие правки на проде он не тронет.
 *
 * Заодно правит data/fzocg/<прайс>/<прайс>-FINAL.json теми же исправлениями —
 * иначе следующая пересборка тарифов (generate_tariff_sql.py) вернёт сдвиг.
 *
 * Usage: node scripts/services/build-catalog-fixes-sql.mjs
 */

import mysql from 'mysql2/promise';
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const OUT = resolve(ROOT, 'server/sql/migrations/038-tariff-names-and-dedup.sql');
const FOLDER = {
	'fzocg-sekundarna': 'sekundarna-ostalo',
	'fzocg-pzz': 'primarna-zdravstvena-zastita',
	'fzocg-van-mreze': 'van-mreze',
	'fzocg-transfuziologija': 'transfuziologija',
};
const PRICE_COLS = ['price_eur', 'price_odjeljenje_eur', 'price_ambulanta_eur', 'price_operacija_eur', 'price_anestezija_eur', 'price_ukupno_eur'];

const read = (p) => JSON.parse(readFileSync(resolve(ROOT, p), 'utf-8'));
const { fix: tariffFixes } = read('data/fzocg/_tariff-name-fixes.json');
const relinks = read('data/fzocg/_pzz-relinks.json');
const decisions = read('data/service-names/_dedup-decisions.json');

loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const [services] = await db.query('SELECT id, slug FROM medical_services');
await db.end();
const slugOf = new Map(services.map((s) => [s.id, s.slug]));
const slug = (id) => {
	const s = slugOf.get(id);
	if (!s) throw new Error(`нет услуги id ${id}`);
	return s;
};

const sq = (s) => (s == null ? 'NULL' : `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`);
const num = (v) => (v == null ? 'NULL' : String(Number(v)));
const svcId = (s) => `(SELECT id FROM medical_services WHERE slug = ${sq(s)})`;

// ── Карта слияний: вторичная → основная (для перенацеливания PZZ-тарифов)
const mergeTo = new Map(decisions.merges.map((m) => [slug(m.secondary), slug(m.primary)]));
const finalTarget = (s) => {
	let t = s;
	while (mergeTo.has(t)) t = mergeTo.get(t);
	return t;
};

const out = [];
const header = `-- 038: тарифы FZOCG и дубли каталога, найденные вычиткой названий услуг.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/038-tariff-names-and-dedup.sql
--
-- Собрано scripts/services/build-catalog-fixes-sql.mjs — руками не править.
-- Разбор: docs/audit/service-names-2026-09.md, раздел «038». Применять ПОСЛЕ 036/037.
--
-- 1. ИМЕНА И ЦЕНЫ ТАРИФОВ (${tariffFixes.length} строк). При слиянии OCR и LLM-разбора прайса
--    в FINAL.json часть строк LLM съехала на соседнюю позицию: у X01036
--    («биопсия щитовидной железы») стояла «катетеризация у мужчин», у X10001
--    «manjih» вместо «malignih», у E09004/E09005 имена переставлены. Где съехала
--    строка целиком (${tariffFixes.filter((f) => f.prices).length}), неверной была и цена. Каждое исправление
--    подтверждено независимо: построчным OCR, названием услуги по прайсу клиники,
--    ценами клиник 88/137 (FZOCG × 2,5) и прайсом Данило (× 3 к «ambulanta»).
--    UPDATE идёт только если в БД всё ещё старое имя.
--
-- 2. PZZ-ТАРИФЫ НА ЧУЖИХ УСЛУГАХ (${relinks.length}). Коды первичного и секундарного прайсов
--    пересекаются: X01025 в PZZ — «Stavljanje IUD», в секундарном — биопсия
--    лимфоузла; L01001 — патронаж новорождённого против гистологии аппендикса.
--    PZZ-позиция переносится на свою услугу или отвязывается.
--
-- 3. ПЕРЕНОС ПО КОДУ. panoramic-x-ray смешивал ОПТГ частных клиник (J11003) и
--    позицию J11001 «Panoramska dentalna radiografija» (~3 €): строки и тарифы
--    J11001 уезжают на panoramic-dental-radiography.
--
-- 4. СЛИЯНИЯ (${decisions.merges.length}) и 5. ОТКАЗЫ (${decisions.dismissals.length}). Правило 027–034: решает код прайса.
--    Названия дубля остаются синонимами, старые слаги — 301 на основную.
--
-- Процедуры создаются и удаляются внутри файла. CREATE PROCEDURE делает неявный
-- COMMIT, поэтому транзакции нет; повторный прогон безопасен (слияние
-- проверяет, что обе половинки ещё на месте).

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';
`;
out.push(header);

// ── 1. Имена и цены тарифов
out.push('\n-- ═══ 1. Имена и цены тарифов ═══\n');
for (const f of tariffFixes) {
	const sets = [`name_sr_latin = ${sq(f.new_name)}`];
	if (f.prices) for (const c of PRICE_COLS) sets.push(`${c} = ${num(f.prices[c])}`);
	out.push(`-- ${f.code}: ${f.how}`);
	out.push(`UPDATE medical_service_tariffs SET ${sets.join(', ')}\n WHERE tariff_source = ${sq(f.src)} AND code = ${sq(f.code)} AND name_sr_latin = ${sq(f.db_name)};`);
}

// ── 2. PZZ-тарифы
out.push('\n-- ═══ 2. PZZ-тарифы на чужих услугах ═══\n');
let relinked = 0;
let unlinked = 0;
for (const r of relinks) {
	const guard = `tariff_source = 'fzocg-pzz' AND code = ${sq(r.code)} AND medical_service_id = ${svcId(r.from)}`;
	if (r.action === 'unlink') {
		out.push(`-- ${r.code}: ${r.why}`);
		out.push(`UPDATE medical_service_tariffs SET medical_service_id = NULL WHERE ${guard};`);
		unlinked++;
		continue;
	}
	const to = finalTarget(r.to);
	if (to === r.from) continue; // цель сливается как раз в текущую услугу
	out.push(`-- ${r.code}: ${r.why}${to !== r.to ? ` (${r.to} сливается в ${to})` : ''}`);
	out.push(`UPDATE medical_service_tariffs SET medical_service_id = ${svcId(to)}\n WHERE ${guard} AND EXISTS (SELECT 1 FROM medical_services WHERE slug = ${sq(to)});`);
	relinked++;
}

// ── 3. Перенос строк по коду
out.push('\n-- ═══ 3. Перенос строк клиник и тарифов по коду ═══\n');
for (const m of decisions.moves) {
	const from = slug(m.from);
	const to = slug(m.to);
	out.push(`-- ${from} → ${to}, код ${m.code}: ${m.why}`);
	out.push(`SET @move_from = ${svcId(from)};`);
	out.push(`SET @move_to = ${svcId(to)};`);
	out.push(`UPDATE IGNORE clinic_medical_service_doctors d
  JOIN clinic_medical_services c ON c.clinic_id = d.clinic_id AND c.medical_service_id = d.medical_service_id
   SET d.medical_service_id = @move_to
 WHERE d.medical_service_id = @move_from AND c.code = ${sq(m.code)} AND @move_to IS NOT NULL;`);
	out.push(`UPDATE IGNORE clinic_medical_services SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = ${sq(m.code)} AND @move_to IS NOT NULL;`);
	out.push(`UPDATE medical_service_tariffs SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = ${sq(m.code)} AND @move_to IS NOT NULL;`);
}

// ── 4. Слияния: процедура из 030 как есть + обёртка по слагу
const src030 = readFileSync(resolve(ROOT, 'server/sql/migrations/030-catalog-dedup-batch-02.sql'), 'utf-8').replace(/\r\n/g, '\n');
const start = src030.indexOf('CREATE PROCEDURE dedup_merge_medical_service(');
const end = src030.indexOf('END$$', start) + 'END$$'.length;
if (start < 0 || end < start) throw new Error('не нашёл процедуру слияния в 030');
out.push('\n-- ═══ 4. Слияния ═══\n');
out.push(`-- Процедура слияния — дословно из 030 (там же разобрано, что и в каком порядке она переносит).
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;

DELIMITER $$

${src030.slice(start, end)}

-- Вызов по слагу: id на проде и локально могут не совпадать.
CREATE PROCEDURE dedup_merge_medical_service_by_slug(IN p_primary VARCHAR(280), IN p_secondary VARCHAR(280))
BEGIN
	DECLARE v_primary INT DEFAULT NULL;
	DECLARE v_secondary INT DEFAULT NULL;
	-- SET, а не SELECT … INTO: пустая выборка в INTO поднимает условие NOT FOUND
	SET v_primary = (SELECT id FROM medical_services WHERE slug = p_primary COLLATE utf8mb4_unicode_ci);
	SET v_secondary = (SELECT id FROM medical_services WHERE slug = p_secondary COLLATE utf8mb4_unicode_ci);
	IF v_primary IS NOT NULL AND v_secondary IS NOT NULL AND v_primary <> v_secondary THEN
		CALL dedup_merge_medical_service(v_primary, v_secondary);
	END IF;
END$$

DELIMITER ;
`);
for (const m of decisions.merges) {
	out.push(`-- ${m.why}`);
	out.push(`CALL dedup_merge_medical_service_by_slug(${sq(slug(m.primary))}, ${sq(slug(m.secondary))});`);
}

// ── 5. Отказы
out.push('\n-- ═══ 5. Отказы — чтобы детектор дублей не поднимал эти пары снова ═══\n');
for (const d of decisions.dismissals) {
	out.push(`-- ${slug(d.a)} ≠ ${slug(d.b)}: ${d.why}`);
	out.push(`INSERT INTO medical_service_duplicate_candidates (service_id_a, service_id_b, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:service-names-2026-09', 'dismissed', NOW()
  FROM medical_services a JOIN medical_services b ON a.slug = ${sq(slug(d.a))} AND b.slug = ${sq(slug(d.b))}
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();`);
}

// ── 6. Синонимы, совпавшие с собственным названием
out.push(`
-- ═══ 6. Синонимы, совпавшие с собственным названием после слияний (как 031) ═══

DELETE syn FROM medical_service_synonyms syn
  JOIN medical_services m ON m.id = syn.medical_service_id
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN m.name_en
           WHEN 'sr' THEN m.name_sr
           WHEN 'sr-cyrl' THEN m.name_sr_cyrl
           WHEN 'ru' THEN m.name_ru
           WHEN 'de' THEN m.name_de
           WHEN 'tr' THEN m.name_tr
           ELSE NULL
       END;

DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
`);

writeFileSync(OUT, out.join('\n') + '\n');

// ── FINAL.json: те же исправления, чтобы пересборка тарифов не вернула сдвиг.
// Правка текстовая, по месту: файл пишет Python (json.dump, CRLF, числа вида «13.0»),
// и пересериализация из JS переписала бы все 2 МБ ради сотни строк.
const pyNum = (v) => (v == null ? 'null' : Number.isInteger(Number(v)) ? `${Number(v)}.0` : String(Number(v)));
const JSON_STR = String.raw`"(?:[^"\\]|\\.)*"`;
const touched = new Map();
let patched = 0;
for (const f of tariffFixes) {
	const folder = FOLDER[f.src];
	const path = resolve(ROOT, `data/fzocg/${folder}/${folder}-FINAL.json`);
	if (!touched.has(folder)) touched.set(folder, readFileSync(path, 'utf-8'));
	let text = touched.get(folder);
	const at = text.indexOf(`"code": ${JSON.stringify(f.code)}`);
	if (at < 0) continue;
	const from = text.lastIndexOf('\n    {', at);
	const to = text.indexOf('\n    }', at);
	let span = text.slice(from, to);
	span = span.replace(new RegExp(`("name": )${JSON_STR}`), (_, k) => `${k}${JSON.stringify(f.new_name)}`);
	span = span.replace(/("_sources": \{[\s\S]*?"name": )"(?:[^"\\]|\\.)*"/, (_, k) => `${k}"shift-fix-2026-09"`);
	if (f.prices) {
		for (const c of PRICE_COLS) {
			if (f.prices[c] === undefined) continue;
			span = span.replace(new RegExp(`("${c}": )(null|-?[0-9.]+)`), (_, k) => `${k}${pyNum(f.prices[c])}`);
		}
		span = span.replace(/("_sources": \{[\s\S]*?"price": )"(?:[^"\\]|\\.)*"/, (_, k) => `${k}"shift-fix-2026-09"`);
	}
	text = text.slice(0, from) + span + text.slice(to);
	touched.set(folder, text);
	patched++;
}
for (const [folder, text] of touched) writeFileSync(resolve(ROOT, `data/fzocg/${folder}/${folder}-FINAL.json`), text);

console.log(`038: тарифов ${tariffFixes.length} (с ценой ${tariffFixes.filter((f) => f.prices).length}); PZZ: перенос ${relinked}, отвязка ${unlinked}; перенос по коду ${decisions.moves.length}; слияний ${decisions.merges.length}; отказов ${decisions.dismissals.length}`);
console.log(`FINAL.json: поправлено ${patched} позиций в ${[...touched.keys()].join(", ")}`);

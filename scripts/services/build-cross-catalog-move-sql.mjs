#!/usr/bin/env node
/**
 * Миграция 043: хвост 029 — лабораторные позиции, заведённые в каталоге услуг.
 *
 * ДЗ Херцег-Нови, ДЗ Мойковац и Никшич импортировали микробиологию, серологию
 * и биохимию как medical_services, хотя у клиники 88 те же коды лежат в
 * lab_tests. 029 перенесла 160 таких позиций по совпадению отпечатков
 * названий; эти отпечатки не совпали из-за одного слова («Bris nosa» /
 * «Bris nosa bakterije»), и позиции остались в услугах.
 *
 * Вход: data/service-names/_cross-catalog-043.json — подготовка, переносы, пропуски.
 *
 * Порядок внутри миграции:
 *   1) подготовка — диапазон цены и перепривязки строк клиники 88. До
 *      переносов: строка клиники, которая уже стоит на целевом анализе, при
 *      переносе не перезаписывается, а цель 88 должна быть верной раньше,
 *      чем на неё сядут строки ДЗ;
 *   2) переносы — процедура из 029 плюс два шага, которых в 029 не было:
 *      справка услуги переезжает, если у анализа своей нет (справки волны 3
 *      появились после 029), и услуга с отзывами не переносится вовсе (у
 *      reviews нет lab_test_id, а FK на услугу — CASCADE).
 *
 * Всё по slug — и записи каталога, и клиники: id локальной БД и прода
 * расходятся (Никшич — 137 локально и 141 на проде).
 *
 * Usage: node scripts/services/build-cross-catalog-move-sql.mjs
 */

import mysql from 'mysql2/promise';
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const OUT = resolve(ROOT, 'server/sql/migrations/043-cross-catalog-labtests-from-services.sql');
const decisions = JSON.parse(readFileSync(resolve(ROOT, 'data/service-names/_cross-catalog-043.json'), 'utf-8'));

// ── Сверка слагов с локальной БД (слитое этой же миграцией живёт как 301)
loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const slugs = async (sql) => new Set((await db.query(sql))[0].map((r) => r.slug));
const known = {
	svc: await slugs(`SELECT slug COLLATE utf8mb4_unicode_ci AS slug FROM medical_services UNION ALL SELECT old_slug COLLATE utf8mb4_unicode_ci FROM slug_redirects WHERE entity_type = 'services'`),
	lab: await slugs('SELECT slug FROM lab_tests'),
	clinic: await slugs('SELECT slug FROM clinics'),
};
await db.end();
const missing = [];
const need = (kind, slug) => { if (!known[kind].has(slug)) missing.push(`${kind}:${slug}`); };
for (const p of decisions.prep) {
	need('clinic', p.clinic);
	if (p.op === 'lab-range') need('lab', p.lab);
	else { need('lab', p.from); need('lab', p.to); }
}
const seen = new Set();
for (const m of decisions.moves) {
	need('svc', m.service);
	need('lab', m.lab);
	if (seen.has(m.service)) throw new Error(`${m.service} переносится дважды`);
	seen.add(m.service);
}
if (missing.length) throw new Error(`нет в локальной БД: ${missing.join(', ')}`);

const sq = (s) => `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`;
const lab = (slug) => `(SELECT id FROM lab_tests WHERE slug = ${sq(slug)})`;
const clinic = (slug) => `(SELECT id FROM clinics WHERE slug = ${sq(slug)})`;
const num = (n) => Number(n).toFixed(2);

// ── Процедура из 029 + два шага
const src029 = readFileSync(resolve(ROOT, 'server/sql/migrations/029-move-labtests-out-of-services.sql'), 'utf-8').replace(/\r\n/g, '\n');
const start = src029.indexOf('CREATE PROCEDURE dedup_move_service_to_lab_test(');
const end = src029.indexOf('END$$', start) + 'END$$'.length;
if (start < 0 || end < start) throw new Error('не нашёл dedup_move_service_to_lab_test в 029');
let proc = src029.slice(start, end);
const patch = (from, to) => {
	if (!proc.includes(from)) throw new Error(`процедура в 029 изменилась — не нашёл «${from.trim().slice(0, 60)}»`);
	proc = proc.replace(from, to);
};
patch(
	`	   AND (SELECT COUNT(*) FROM lab_tests WHERE id = p_lab_test_id) = 1 THEN`,
	`	   AND (SELECT COUNT(*) FROM lab_tests WHERE id = p_lab_test_id) = 1
	   -- (043) отзывы привязаны только к услуге, FK — CASCADE: такую услугу не трогаем
	   AND (SELECT COUNT(*) FROM reviews WHERE medical_service_id = p_service_id) = 0 THEN`,
);
patch(
	`		-- 4. Тарифы ФЗОЦГ переезжают в лабораторную колонку.`,
	`		-- 3.2 (043) Справка услуги — анализу, если у него своей нет: колонки
		-- таблиц одинаковые, UNIQUE на lab_test_id не даст затереть существующую.
		INSERT IGNORE INTO lab_test_reference_info
			(lab_test_id, what_en, what_sr, what_sr_cyrl, what_ru, what_de, what_tr,
			 how_en, how_sr, how_sr_cyrl, how_ru, how_de, how_tr,
			 indications_en, indications_sr, indications_sr_cyrl, indications_ru, indications_de, indications_tr,
			 prep_en, prep_sr, prep_sr_cyrl, prep_ru, prep_de, prep_tr,
			 abnormal_en, abnormal_sr, abnormal_sr_cyrl, abnormal_ru, abnormal_de, abnormal_tr)
		SELECT p_lab_test_id, what_en, what_sr, what_sr_cyrl, what_ru, what_de, what_tr,
			 how_en, how_sr, how_sr_cyrl, how_ru, how_de, how_tr,
			 indications_en, indications_sr, indications_sr_cyrl, indications_ru, indications_de, indications_tr,
			 prep_en, prep_sr, prep_sr_cyrl, prep_ru, prep_de, prep_tr,
			 abnormal_en, abnormal_sr, abnormal_sr_cyrl, abnormal_ru, abnormal_de, abnormal_tr
		  FROM medical_service_reference_info
		 WHERE medical_service_id = p_service_id;

		-- 4. Тарифы ФЗОЦГ переезжают в лабораторную колонку.`,
);

const out = [];
out.push(`-- 043: лабораторные позиции, заведённые в каталоге услуг (хвост 029).
--
-- Собрано scripts/services/build-cross-catalog-move-sql.mjs из
-- data/service-names/_cross-catalog-043.json — руками не править.
-- Независима от 038–042; 029 должна быть применена (процедура и
-- slug_redirects.target_entity_type оттуда).
--
-- ЧТО ПЕРЕНОСИТСЯ. ${decisions.moves.length} услуг ДЗ Херцег-Нови, ДЗ Мойковац и Никшича, у которых
-- тот же код прайса у клиники 88 лежит в каталоге анализов: мазки и посевы
-- K01, детекция K02, серология K03, трансфузиологические тесты X12, биохимия
-- Z01/Z02. 029 нашла 160 таких позиций по совпадению отпечатков названий;
-- эти не совпали из-за одного слова («Bris nosa» / «Bris nosa bakterije»).
--
-- КАК ВЫБРАНА ЦЕЛЬ. Анализ клиники 88 с тем же кодом. У строк ДЗ решает
-- название, а не код: коды ДЗ Херцег-Нови местами сдвинуты (HN_K01011 у них
-- «Bris uha», а в ФЗОЦГ K01011 — «Bris oka»). У строк Никшича решает код: код
-- из PDF клиники, а названия её услуг в K03 съехали с соседних позиций
-- FINAL.json (как анализы в 040). Такие названия синонимами анализа НЕ
-- заводятся — иначе «гепатит A» находил бы тест на гепатит E (${decisions.moves.filter((m) => !m.keep_names).length} переносов
-- без синонимов).
--
-- НЕ ПЕРЕНОСИТСЯ (${decisions.skipped.length}): ${decisions.skipped.map((s) => s.service).join(', ')} —
-- название ДЗ противоречит коду, и подходящего анализа нет. Причины — в
-- _cross-catalog-043.json.
--
-- ЧТО ДОБАВЛЕНО К ПРОЦЕДУРЕ 029: перенос справки услуги, если у анализа
-- своей нет, и запрет переноса услуги с отзывами. На текущих данных отзывов
-- на переносимых услугах нет, а все четыре справки услуг дублируют справки
-- анализов — они убраны из data/entity-reference тем же коммитом.
--
-- Числовой /services/<id> после переноса отдаёт 404, слаг — 301 на анализ
-- (как в 029). Повторный прогон безопасен: перенос ничего не делает, если
-- услуги уже нет; подготовка — если строки уже не в старом виде.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';
`);

out.push('-- ═══ 1. Подготовка ═══\n');
for (const p of decisions.prep) {
	out.push(`-- ${p.why}`);
	if (p.op === 'lab-range') {
		out.push(`UPDATE clinic_lab_tests SET price = ${num(p.price)}, price_max = ${num(p.price_max)}, code = ${sq(p.code)}
 WHERE clinic_id = ${clinic(p.clinic)} AND lab_test_id = ${lab(p.lab)}
   AND code = ${sq(p.from_code)} AND price_max IS NULL;`);
	} else if (p.op === 'lab-relink') {
		out.push(`UPDATE IGNORE clinic_lab_tests SET lab_test_id = ${lab(p.to)}
 WHERE clinic_id = ${clinic(p.clinic)} AND code = ${sq(p.code)} AND lab_test_id = ${lab(p.from)};`);
	} else throw new Error(`неизвестная операция ${p.op}`);
}

out.push(`
-- ═══ 2. Переносы услуга → анализ ═══

-- Процедура — из 029 с шагами 3.2 и проверкой отзывов (помечены «043»).
DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test;
DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test_by_slug;

DELIMITER $$

${proc}

-- Вызов по слагу. COLLATE обязателен: параметр получает коллацию схемы
-- (локально utf8mb4_0900_ai_ci), а slug — utf8mb4_unicode_ci.
CREATE PROCEDURE dedup_move_service_to_lab_test_by_slug(IN p_lab VARCHAR(280), IN p_service VARCHAR(280), IN p_keep_names TINYINT)
BEGIN
	DECLARE v_lab INT DEFAULT NULL;
	DECLARE v_service INT DEFAULT NULL;
	SET v_lab = (SELECT id FROM lab_tests WHERE slug = p_lab COLLATE utf8mb4_unicode_ci);
	SET v_service = (SELECT id FROM medical_services WHERE slug = p_service COLLATE utf8mb4_unicode_ci);
	IF v_lab IS NOT NULL AND v_service IS NOT NULL THEN
		CALL dedup_move_service_to_lab_test(v_lab, v_service, p_keep_names);
	END IF;
END$$

DELIMITER ;
`);
for (const m of decisions.moves) {
	out.push(`-- ${m.why}`);
	out.push(`CALL dedup_move_service_to_lab_test_by_slug(${sq(m.lab)}, ${sq(m.service)}, ${m.keep_names ? 1 : 0});`);
}
out.push(`
DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test_by_slug;
DROP PROCEDURE IF EXISTS dedup_move_service_to_lab_test;

-- ═══ Проверка: должно остаться 0 ═══
SELECT COUNT(*) AS services_left FROM medical_services WHERE slug IN (
${decisions.moves.map((m) => `  ${sq(m.service)}`).join(',\n')}
);`);

writeFileSync(OUT, out.join('\n') + '\n');
console.log(`${OUT}\n  подготовка: ${decisions.prep.length}, переносы: ${decisions.moves.length} (без синонимов ${decisions.moves.filter((m) => !m.keep_names).length}), пропуски: ${decisions.skipped.length}`);

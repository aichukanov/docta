#!/usr/bin/env node
/**
 * Миграция 039: дубли каталога, которые различаются одним словом или языком
 * записи («Rapid Strep Test» / «Rapid Strep A», «HSV1 IgG» / «Herpes Simplex I
 * IgG», «Telekardiografija» / «Teleradiografija srca»). Детектор
 * find-duplicate-services / find-duplicate-labtests их не видит: отпечатки
 * языков у таких пар расходятся, а нечёткое сравнение глушат вето.
 *
 * Вход: data/service-names/_dedup-039.json — подготовка, слияния, отказы.
 *
 * Порядок внутри миграции:
 *   1) подготовка — диапазоны цен и перенос строк по коду. До слияний, иначе
 *      строка клиники, стоящая на обеих половинках, при слиянии потеряет вторую
 *      цену, а чужой код уедет на основную вместе с остальными;
 *   2) слияния услуг — процедура из 030 как есть;
 *   3) слияния анализов — процедура из 030 плюс перенос тарифов
 *      (medical_service_tariffs.lab_test_id появился в 028, а процедуру
 *      анализов писали без него: FK стоит на SET NULL и отвязал бы тариф молча);
 *   4) отказы — в очереди дублей, чтобы детектор не поднимал их снова;
 *   5) синонимы, совпавшие с собственным названием после слияний (как 031).
 *
 * Всё адресуется по slug: автоинкремент локальной БД и прода расходится.
 * Сборщик сверяет слаги с локальной БД и падает, если какой-то не найден.
 *
 * Usage: node scripts/services/build-name-variant-dedup-sql.mjs
 */

import mysql from 'mysql2/promise';
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { loadEnv, dbConfigFromEnv } from '../common/dedup-text.mjs';

const ROOT = resolve(dirname(fileURLToPath(import.meta.url)), '..', '..');
const OUT = resolve(ROOT, 'server/sql/migrations/039-name-variant-dedup.sql');
const decisions = JSON.parse(readFileSync(resolve(ROOT, 'data/service-names/_dedup-039.json'), 'utf-8'));

const CATALOG = {
	svc: { table: 'medical_services', clinics: 'clinic_medical_services', fk: 'medical_service_id', queue: 'medical_service_duplicate_candidates', a: 'service_id_a', b: 'service_id_b', synonyms: 'medical_service_synonyms' },
	lab: { table: 'lab_tests', clinics: 'clinic_lab_tests', fk: 'lab_test_id', queue: 'lab_test_duplicate_candidates', a: 'lab_test_id_a', b: 'lab_test_id_b', synonyms: 'lab_test_synonyms' },
};

// ── Сверка слагов с локальной БД
loadEnv(ROOT);
const db = await mysql.createConnection(dbConfigFromEnv());
const known = {};
for (const [kind, c] of Object.entries(CATALOG)) {
	const [rows] = await db.query(`SELECT slug FROM ${c.table}`);
	known[kind] = new Set(rows.map((r) => r.slug));
	// Слаг, уже слитый этой миграцией, живёт как 301 — пересборка после применения не падает
	const [redirects] = await db.query('SELECT old_slug FROM slug_redirects WHERE entity_type = ?', [kind === 'svc' ? 'services' : 'labtests']);
	for (const r of redirects) known[kind].add(r.old_slug);
}
known.clinic = new Set((await db.query('SELECT slug FROM clinics'))[0].map((r) => r.slug));
await db.end();

const missing = [];
const need = (kind, slug) => { if (!known[kind].has(slug)) missing.push(`${kind}:${slug}`); };
for (const p of decisions.prep) {
	if (p.op === 'move') { need('svc', p.from); need('svc', p.to); } else { need(p.catalog, p.slug); need('clinic', p.clinic); }
}
for (const [kind, list] of [['svc', decisions.merges_svc], ['lab', decisions.merges_lab]]) {
	const secondaries = new Set();
	for (const m of list) {
		need(kind, m.primary);
		need(kind, m.secondary);
		if (m.primary === m.secondary) throw new Error(`${kind}: ${m.primary} сливается сам в себя`);
		if (secondaries.has(m.secondary)) throw new Error(`${kind}: ${m.secondary} сливается дважды`);
		secondaries.add(m.secondary);
	}
	// Основная не должна сама исчезать в этой же миграции — иначе нужна перецелка
	for (const m of list) if (secondaries.has(m.primary)) throw new Error(`${kind}: основная ${m.primary} сама сливается`);
}
for (const [kind, list] of [['svc', decisions.dismissals_svc], ['lab', decisions.dismissals_lab]]) for (const d of list) { need(kind, d.a); need(kind, d.b); }
if (missing.length) throw new Error(`нет в локальной БД: ${missing.join(', ')}`);

// ── SQL
const sq = (s) => `'${String(s).replace(/\\/g, '\\\\').replace(/'/g, "''")}'`;
const idOf = (kind, slug) => `(SELECT id FROM ${CATALOG[kind].table} WHERE slug = ${sq(slug)})`;
const num = (n) => Number(n).toFixed(2);
// Клиника — только по slug: id локальной БД и прода расходятся (Никшич 137 локально, 141 на проде; 137 на проде — Беране)
const clinicOf = (slug) => {
	if (typeof slug !== 'string') throw new Error(`клиника должна быть слагом, а не id: ${slug}`);
	return `(SELECT id FROM clinics WHERE slug = ${sq(slug)})`;
};

const out = [];
out.push(`-- 039: дубли каталога, различающиеся одним словом или языком записи.
--
-- Собрано scripts/services/build-name-variant-dedup-sql.mjs из
-- data/service-names/_dedup-039.json — руками не править.
-- Применять ПОСЛЕ 038: слияние ergometry-stress-test ← exercise-ecg-ergometry
-- рассчитано на то, что 038 уже слила туда ergometry-ecg-stress-test, а три
-- пары ниже пересматривают отказы 038.
--
-- ОТКУДА ПАРЫ. Агенты волны 3 справок отметили около двадцати дублей
-- (prd/service-reference-content/PROGRESS.md). Остальное найдено тремя
-- проходами по базе: один код ФЗОЦГ на разных записях каталога, слаги с
-- разницей в одно «пустое» слово (test, culture, total, rapid…), совпадение
-- названия или синонима одной записи с названием другой на любом языке.
-- Слияний: услуг — ${decisions.merges_svc.length}, анализов — ${decisions.merges_lab.length}; отказов — ${decisions.dismissals_svc.length + decisions.dismissals_lab.length}.
--
-- ПРАВИЛО ПРЕЖНЕЕ (027–034): решает код прайса. Один код в разных клиниках —
-- дубль. Обе записи в одной клинике по разной цене — разные позиции (так
-- отклонены грибы из зева и метанефрины у клиники 64). Коды PZZ и
-- секундарного прайса в блоках H, I03, J, K и X03/X14/X15 совпадают по
-- смыслу — это проверено по названиям обоих прайсов, поэтому строки ДЗ 80/127
-- и больниц 88/131/137 с одним кодом сливаются. В X01/X02 коды ДЗ
-- Херцег-Нови сдвинуты, там решает название.
--
-- ПЕРЕСМОТР ОТКАЗОВ 038. Три пары 038 отклоняет, здесь они сливаются:
--   * x-ray-chest-heart / x-ray-chest-and-heart — отказ верный по сути
--     (J06010 — снимок сердца, J06051 — лёгких и сердца), но лечится переносом
--     J06010 на heart-teleradiography, как 038 сама сделала с panoramic-x-ray
--     и J11001. После переноса обе записи — снимок лёгких и сердца.
--   * mri-pelvic-organs / mri-pelvis — отказ по контрасту (J09017 / J09018),
--     но МРТ в каталоге по контрасту не делится нигде: у клиники 88 все
--     исследования блока J09 лежат на одной записи с двумя кодами и диапазоном.
--   * dental-sinus-lift / sinus-lift-with-augmentation — отказ «клиника 117
--     держит обе», но обе её строки без цены, а на её сайте одна процедура
--     синус-лифта с костным графтом.
--
-- ЧТО ТЕРЯЕТСЯ. Строка клиники 88 X12055 «Combo test Ag/At HCV» стояла на
-- hcv-total-antibodies, хотя это другой тест (антиген + антитела); своей
-- записи у него нет, и при слиянии в anti-hcv она уходит. Справки дублей,
-- если у основной есть своя, удаляются каскадом — в data/entity-reference
-- они убраны тем же коммитом, чтобы пересборка справок не упала на NULL в FK.
--
-- Процедуры создаются и удаляются внутри файла. CREATE PROCEDURE делает неявный
-- COMMIT, поэтому транзакции нет; повторный прогон безопасен: слияние
-- проверяет, что обе половинки ещё на месте, подготовка — что строки ещё в
-- старом виде.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';
`);

// ── 1. Подготовка
out.push('\n-- ═══ 1. Подготовка: диапазоны цен и перенос строк по коду ═══\n');
for (const p of decisions.prep) {
	out.push(`-- ${p.op === 'move' ? `${p.from} → ${p.to}, код ${p.code}` : `${p.slug}, клиника ${p.clinic}`}: ${p.why}`);
	if (p.op === 'range') {
		const c = CATALOG[p.catalog];
		const sets = [`price_max = ${num(p.price_max)}`];
		if (p.code) sets.push(`code = ${sq(p.code)}`);
		const guards = [`${c.fk} = ${idOf(p.catalog, p.slug)}`, `clinic_id = ${clinicOf(p.clinic)}`, 'price_max IS NULL'];
		if (p.from_code) guards.push(`code = ${sq(p.from_code)}`);
		if (p.from_price != null) guards.push(`price = ${num(p.from_price)}`);
		out.push(`UPDATE ${c.clinics} SET ${sets.join(', ')}\n WHERE ${guards.join('\n   AND ')};`);
	} else if (p.op === 'drop-row') {
		const c = CATALOG[p.catalog];
		out.push(`DELETE FROM ${c.clinics}\n WHERE ${c.fk} = ${idOf(p.catalog, p.slug)} AND clinic_id = ${clinicOf(p.clinic)} AND code = ${sq(p.code)};`);
	} else if (p.op === 'move') {
		out.push(`SET @move_from = ${idOf('svc', p.from)};`);
		out.push(`SET @move_to = ${idOf('svc', p.to)};`);
		out.push(`UPDATE IGNORE clinic_medical_service_doctors d
  JOIN clinic_medical_services c ON c.clinic_id = d.clinic_id AND c.medical_service_id = d.medical_service_id
   SET d.medical_service_id = @move_to
 WHERE d.medical_service_id = @move_from AND c.code = ${sq(p.code)} AND @move_to IS NOT NULL;`);
		out.push(`UPDATE IGNORE clinic_medical_services SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = ${sq(p.code)} AND @move_to IS NOT NULL;`);
		out.push(`-- Остались строки клиник, которые уже стояли на цели с тем же кодом: это копия, а не вторая позиция.
-- Строка, у которой на цели другой код, остаётся на месте — её разбирать руками.
DELETE d FROM clinic_medical_service_doctors d
  JOIN clinic_medical_services s ON s.clinic_id = d.clinic_id AND s.medical_service_id = d.medical_service_id
  JOIN clinic_medical_services t ON t.clinic_id = s.clinic_id AND t.medical_service_id = @move_to AND t.code = s.code
 WHERE d.medical_service_id = @move_from AND s.code = ${sq(p.code)};`);
		out.push(`DELETE s FROM clinic_medical_services s
  JOIN clinic_medical_services t ON t.clinic_id = s.clinic_id AND t.medical_service_id = @move_to AND t.code = s.code
 WHERE s.medical_service_id = @move_from AND s.code = ${sq(p.code)};`);
		out.push(`UPDATE medical_service_tariffs SET medical_service_id = @move_to
 WHERE medical_service_id = @move_from AND code = ${sq(p.code)} AND @move_to IS NOT NULL;`);
	} else throw new Error(`неизвестная операция ${p.op}`);
}

// ── 2. Слияния услуг: процедура из 030 как есть + обёртка по слагу
const src030 = readFileSync(resolve(ROOT, 'server/sql/migrations/030-catalog-dedup-batch-02.sql'), 'utf-8').replace(/\r\n/g, '\n');
const procBody = (name) => {
	const start = src030.indexOf(`CREATE PROCEDURE ${name}(`);
	const end = src030.indexOf('END$$', start) + 'END$$'.length;
	if (start < 0 || end < start) throw new Error(`не нашёл ${name} в 030`);
	return src030.slice(start, end);
};
const bySlug = (kind, proc) => `CREATE PROCEDURE ${proc}_by_slug(IN p_primary VARCHAR(280), IN p_secondary VARCHAR(280))
BEGIN
	DECLARE v_primary INT DEFAULT NULL;
	DECLARE v_secondary INT DEFAULT NULL;
	-- SET, а не SELECT … INTO: пустая выборка в INTO поднимает условие NOT FOUND
	SET v_primary = (SELECT id FROM ${CATALOG[kind].table} WHERE slug = p_primary COLLATE utf8mb4_unicode_ci);
	SET v_secondary = (SELECT id FROM ${CATALOG[kind].table} WHERE slug = p_secondary COLLATE utf8mb4_unicode_ci);
	IF v_primary IS NOT NULL AND v_secondary IS NOT NULL AND v_primary <> v_secondary THEN
		CALL ${proc}(v_primary, v_secondary);
	END IF;
END$$`;

out.push('\n-- ═══ 2. Слияния услуг ═══\n');
out.push(`-- Процедура слияния — дословно из 030 (там же разобрано, что и в каком порядке она переносит).
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;

DELIMITER $$

${procBody('dedup_merge_medical_service')}

-- Вызов по слагу: id на проде и локально могут не совпадать.
${bySlug('svc', 'dedup_merge_medical_service')}

DELIMITER ;
`);
for (const m of decisions.merges_svc) {
	out.push(`-- ${m.why}`);
	out.push(`CALL dedup_merge_medical_service_by_slug(${sq(m.primary)}, ${sq(m.secondary)});`);
}

// ── 3. Слияния анализов: процедура из 030 + перенос тарифов
const TARIFF_STEP = `		-- 4.2 Тарифы ФЗОЦГ (добавлено в 039: lab_test_id появился в 028, FK стоит
		-- на SET NULL — без переноса код молча отвязался бы от каталога)
		UPDATE medical_service_tariffs
		   SET lab_test_id = p_primary
		 WHERE lab_test_id = p_secondary;

		-- 5. Связи дубликата`;
const labProc = procBody('dedup_merge_lab_test');
if (!labProc.includes('\t\t-- 5. Связи дубликата')) throw new Error('процедура анализов в 030 изменилась — некуда вставить перенос тарифов');
out.push('\n-- ═══ 3. Слияния анализов ═══\n');
out.push(`-- Процедура слияния — из 030, плюс шаг 4.2 (перенос тарифов).
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;

DELIMITER $$

${labProc.replace('\t\t-- 5. Связи дубликата', TARIFF_STEP)}

${bySlug('lab', 'dedup_merge_lab_test')}

DELIMITER ;
`);
for (const m of decisions.merges_lab) {
	out.push(`-- ${m.why}`);
	out.push(`CALL dedup_merge_lab_test_by_slug(${sq(m.primary)}, ${sq(m.secondary)});`);
}

// ── 4. Отказы
out.push('\n-- ═══ 4. Отказы — чтобы детектор дублей не поднимал эти пары снова ═══\n');
for (const [kind, list] of [['svc', decisions.dismissals_svc], ['lab', decisions.dismissals_lab]]) {
	const c = CATALOG[kind];
	for (const d of list) {
		out.push(`-- ${d.a} ≠ ${d.b}: ${d.why}`);
		out.push(`INSERT INTO ${c.queue} (${c.a}, ${c.b}, tier, score, signals, status, decided_at)
SELECT LEAST(a.id, b.id), GREATEST(a.id, b.id), 'C', 0, 'manual:name-variants-2026-10', 'dismissed', NOW()
  FROM ${c.table} a JOIN ${c.table} b ON a.slug = ${sq(d.a)} AND b.slug = ${sq(d.b)}
ON DUPLICATE KEY UPDATE status = 'dismissed', decided_at = NOW();`);
	}
}

// ── 5. Синонимы, совпавшие с собственным названием
out.push('\n-- ═══ 5. Синонимы, совпавшие с собственным названием после слияний (как 031) ═══\n');
for (const kind of ['lab', 'svc']) {
	const c = CATALOG[kind];
	out.push(`DELETE syn FROM ${c.synonyms} syn
  JOIN ${c.table} e ON e.id = syn.${c.fk}
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN e.name_en
           WHEN 'sr' THEN e.name_sr
           WHEN 'sr-cyrl' THEN e.name_sr_cyrl
           WHEN 'ru' THEN e.name_ru
           WHEN 'de' THEN e.name_de
           WHEN 'tr' THEN e.name_tr
           ELSE NULL
       END;
`);
}

out.push(`DROP PROCEDURE IF EXISTS dedup_merge_medical_service_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_medical_service;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;`);

writeFileSync(OUT, out.join('\n') + '\n');
console.log(`${OUT}\n  подготовка: ${decisions.prep.length}, слияния: ${decisions.merges_svc.length} услуг + ${decisions.merges_lab.length} анализов, отказы: ${decisions.dismissals_svc.length + decisions.dismissals_lab.length}`);

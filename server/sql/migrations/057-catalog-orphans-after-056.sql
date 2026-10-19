SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 057: записи-сироты каталога услуг, оставшиеся после 056 (сверка прайсов ДЗ Херцег-Нови и Мойковац с PDF).
--
-- Порядок: ПОСЛЕ 055 и 056. Всё по slug, литеральных id нет (на проде id другие). Процедур нет: файл прогоняется
-- на сессионных TEMPORARY-копиях таблиц (проверено: 055 → 056 → 057 → 057, второй прогон 057 ничего не меняет).
--
-- 43 записи завели импорты ДЗ 2026-05, читавшие сканы «на глаз»; 056 перенесла с них все строки клиник на правильные
-- записи. Решение по каждой:
--   * 12 — дубли АНАЛИЗОВ (позиции Z и K, заведённые в каталог услуг): 301 со слага услуги на анализ, как в 043
--     (slug_redirects.target_entity_type = 'labtests'; числовой /services/<id> между каталогами не редиректится).
--   * 30 — дубли живых УСЛУГ или выдуманные названия: 301 на ближайшую по смыслу живую запись
--     (medical_service_redirects + slug_redirects). 11 из 13 справок медицины труда ХН — на общую
--     medical-certificate-for-other-purposes: их названия выдуманы, аналога в каталоге нет.
--   * 1 оставлена: typhoid-vaccination-vivotif — реальная прививка (пероральная вакцина против брюшного тифа),
--     дубля в каталоге нет; клиник у неё нет (строка ХН HES07 была бешенством и ушла в 056 на Verorab).
-- Названия сироты становятся синонимами цели, только если это настоящее название той же позиции (17 записей);
-- выдуманные и ошибочные названия, а также названия с припиской раздела «(TBC)» — нет.
-- Справочных карточек у этих 43 записей нет ни в БД, ни в data/entity-reference — снимать нечего.
--
-- Самопроверка в момент применения: если у записи всё же есть строки клиник, тарифы, отзывы или врачи, она НЕ
-- удаляется — журнал tmp_057_log в конце показывает её с deleted = 0 и числом зависимостей.
-- Идемпотентно: удаление и 301 — только пока запись на месте; синонимы — INSERT IGNORE.


DROP TEMPORARY TABLE IF EXISTS tmp_057_log;
CREATE TEMPORARY TABLE tmp_057_log (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	target VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	orphan_id INT NULL, target_id INT NULL, dependents INT NULL, deleted TINYINT NOT NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ═══ ДО: состояние 43 записей (после 056 у всех должно быть 0 клиник / тарифов / отзывов / врачей) ═══
SELECT 'before' AS state, ms.slug,
	(SELECT COUNT(*) FROM clinic_medical_services c WHERE c.medical_service_id = ms.id) AS clinics,
	(SELECT COUNT(*) FROM medical_service_tariffs t WHERE t.medical_service_id = ms.id) AS tariffs,
	(SELECT COUNT(*) FROM reviews r WHERE r.medical_service_id = ms.id) AS reviews,
	(SELECT COUNT(*) FROM clinic_medical_service_doctors d WHERE d.medical_service_id = ms.id) AS doctors,
	(SELECT COUNT(*) FROM medical_service_reference_info i WHERE i.medical_service_id = ms.id) AS reference_card
FROM medical_services ms
WHERE ms.slug IN (
	'alpha-amylase-activity',
	'c-reactive-protein-crp',
	'complete-blood-count-with-differential',
	'fecal-occult-blood-qualitative',
	'ldl-cholesterol-calculated',
	'serum-creatinine',
	'serum-urea-kinetic',
	'urine-hcg-strip-test',
	'urine-protein-qualitative',
	'urine-protein-quantitative',
	'vaginal-smear-microscopy',
	'joint-fluid-native-preparation',
	'activities-of-daily-living-adl-test',
	'coordination-and-balance-exercises',
	'patient-body-posture-training',
	'sanitary-patient-transport-per-kilometer',
	'gastric-sounding-and-lavage',
	'vaginal-suppository-application',
	'local-drug-application-subcutaneous-intramuscular-tb',
	'swab-collection-for-tb-analysis',
	'enema-administration-tb-center',
	'group-exercises-type-a',
	'segmental-isokinetic-exercises',
	'ultraviolet-and-biogenic-lamp-treatment',
	'back-exercises',
	'fluoroscopy-examination',
	'endodontic-canal-contrast-radiography',
	'speech-therapy-preventive-examination',
	'typhoid-immunoglobulin',
	'medical-certificate-for-low-risk-work',
	'medical-certificate-for-significant-risk-work',
	'medical-certificate-for-educational-institutions',
	'medical-certificate-disability-suspicion',
	'medical-certificate-for-foreign-marriage',
	'medical-certificate-for-licensing',
	'medical-certificate-for-pension',
	'medical-certificate-for-prison-visit',
	'medical-certificate-for-psychotropic-work-monitoring',
	'medical-certificate-for-special-course',
	'medical-certificate-for-special-treatment',
	'medical-certificate-for-visits-montenegro',
	'medical-certificate-observation',
	'typhoid-vaccination-vivotif')
ORDER BY ms.slug;

SELECT 'before' AS state, (SELECT COUNT(*) FROM medical_services) AS medical_services_total,
	(SELECT COUNT(*) FROM slug_redirects) AS slug_redirects_total,
	(SELECT COUNT(*) FROM medical_service_redirects) AS medical_service_redirects_total;

-- страховка: цели, которых нет в базе. Ожидается ПУСТО.
DROP TEMPORARY TABLE IF EXISTS tmp_057_targets;
CREATE TEMPORARY TABLE tmp_057_targets (
	kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (kind, slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
INSERT IGNORE INTO tmp_057_targets (kind, slug) VALUES
('L', 'amylase'),
('L', 'c-reactive-protein'),
('L', 'complete-blood-count-with-leukocyte-formula'),
('L', 'fecal-occult-blood'),
('L', 'ldl-cholesterol'),
('L', 'creatinine'),
('L', 'urea'),
('L', 'urine-pregnancy-test-hcg-qualitative'),
('L', 'urinary-protein-qualitative'),
('L', 'protein-in-urine'),
('L', 'direct-microscopic-preparation-vaginal'),
('L', 'synovial-fluid-direct-microscopic-preparation'),
('S', 'activities-of-daily-living-test'),
('S', 'gait-coordination-correction-and-balance-automation-exercises'),
('S', 'patient-training-in-specific-protective-body-positions'),
('S', 'medical-transport-per-km'),
('S', 'gastric-lavage'),
('S', 'cervical-drug-application'),
('S', 'subcutaneous-or-intramuscular-injection'),
('S', 'swab-collection-for-laboratory-analysis'),
('S', 'enema'),
('S', 'group-exercises-type-b'),
('S', 'segmental-isometric-exercises'),
('S', 'infrared-ultraviolet-and-bioptron-lamp-irradiation'),
('S', 'kinesiotherapy-for-spine-deformities'),
('S', 'lung-fluoroscopy'),
('S', 'intraoral-x-ray'),
('S', 'speech-development-assessment'),
('S', 'typhoid-vaccination-vivotif'),
('S', 'medical-certificate-low-risk-work-with-examination'),
('S', 'medical-certificate-for-high-risk-work'),
('S', 'medical-certificate-for-continued-education'),
('S', 'medical-certificate-for-other-purposes');
SELECT x.kind, x.slug AS missing_target FROM tmp_057_targets x
 WHERE (x.kind = 'S' AND NOT EXISTS (SELECT 1 FROM medical_services ms WHERE ms.slug = x.slug))
    OR (x.kind = 'L' AND NOT EXISTS (SELECT 1 FROM lab_tests lt WHERE lt.slug = x.slug));

-- 1. alpha-amylase-activity → анализ amylase: амилаза (Z01026 в PDF)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'amylase');
SET @s = (SELECT id FROM medical_services WHERE slug = 'alpha-amylase-activity');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'alpha-amylase-activity', 'amylase', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 2. c-reactive-protein-crp → анализ c-reactive-protein: CRP (Z01088)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'c-reactive-protein');
SET @s = (SELECT id FROM medical_services WHERE slug = 'c-reactive-protein-crp');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'c-reactive-protein-crp', 'c-reactive-protein', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 3. complete-blood-count-with-differential → анализ complete-blood-count-with-leukocyte-formula: КАК с лейкоформулой — одноимённый анализ (строки ДЗ ушли на Z01003 «Izabrani parametri krvne slike»)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'complete-blood-count-with-leukocyte-formula');
SET @s = (SELECT id FROM medical_services WHERE slug = 'complete-blood-count-with-differential');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'complete-blood-count-with-differential', 'complete-blood-count-with-leukocyte-formula', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 4. fecal-occult-blood-qualitative → анализ fecal-occult-blood: скрытая кровь в кале (Z01090)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'fecal-occult-blood');
SET @s = (SELECT id FROM medical_services WHERE slug = 'fecal-occult-blood-qualitative');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'fecal-occult-blood-qualitative', 'fecal-occult-blood', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 5. ldl-cholesterol-calculated → анализ ldl-cholesterol: ЛПНП (Z02094)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'ldl-cholesterol');
SET @s = (SELECT id FROM medical_services WHERE slug = 'ldl-cholesterol-calculated');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'ldl-cholesterol-calculated', 'ldl-cholesterol', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 6. serum-creatinine → анализ creatinine: креатинин (Z01030)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'creatinine');
SET @s = (SELECT id FROM medical_services WHERE slug = 'serum-creatinine');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'serum-creatinine', 'creatinine', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 7. serum-urea-kinetic → анализ urea: мочевина (Z01029)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'urea');
SET @s = (SELECT id FROM medical_services WHERE slug = 'serum-urea-kinetic');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'serum-urea-kinetic', 'urea', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 8. urine-hcg-strip-test → анализ urine-pregnancy-test-hcg-qualitative: hCG в моче тест-полоской (Z01052)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'urine-pregnancy-test-hcg-qualitative');
SET @s = (SELECT id FROM medical_services WHERE slug = 'urine-hcg-strip-test');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'urine-hcg-strip-test', 'urine-pregnancy-test-hcg-qualitative', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 9. urine-protein-qualitative → анализ urinary-protein-qualitative: белок в моче качественно (Z01109)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'urinary-protein-qualitative');
SET @s = (SELECT id FROM medical_services WHERE slug = 'urine-protein-qualitative');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'urine-protein-qualitative', 'urinary-protein-qualitative', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 10. urine-protein-quantitative → анализ protein-in-urine: белок в моче (Z01040/Z02098)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'protein-in-urine');
SET @s = (SELECT id FROM medical_services WHERE slug = 'urine-protein-quantitative');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'urine-protein-quantitative', 'protein-in-urine', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 11. vaginal-smear-microscopy → анализ direct-microscopic-preparation-vaginal: микроскопия вагинального мазка = «Direktan mikroskopski preparat vagina» (строка ХН на K01051 была перианальным отпечатком)
SET @p = (SELECT id FROM lab_tests WHERE slug = 'direct-microscopic-preparation-vaginal');
SET @s = (SELECT id FROM medical_services WHERE slug = 'vaginal-smear-microscopy');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'vaginal-smear-microscopy', 'direct-microscopic-preparation-vaginal', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM lab_tests WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM lab_tests WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM lab_tests WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM lab_tests WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM lab_tests WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM lab_tests WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 12. joint-fluid-native-preparation → анализ synovial-fluid-direct-microscopic-preparation: «Nativni preparat - artritis» — искажённое чтение K01054 (амёбы); по названию ближе всего нативный препарат синовиальной жидкости
SET @p = (SELECT id FROM lab_tests WHERE slug = 'synovial-fluid-direct-microscopic-preparation');
SET @s = (SELECT id FROM medical_services WHERE slug = 'joint-fluid-native-preparation');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'joint-fluid-native-preparation', 'synovial-fluid-direct-microscopic-preparation', 'L', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на анализ (как 043): числовой редирект между каталогами невозможен — строки medical_service_redirects убираются
DELETE FROM medical_service_redirects WHERE (old_id = @s OR new_id = @s) AND @ok;
UPDATE slug_redirects SET entity_id = @p, target_entity_type = 'labtests'
 WHERE entity_type = 'services' AND COALESCE(target_entity_type, 'services') = 'services' AND entity_id = @s AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id, target_entity_type)
SELECT 'services', slug, @p, 'labtests' FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 13. activities-of-daily-living-adl-test → услуга activities-of-daily-living-test: M01029 — тот же тест ADL
SET @p = (SELECT id FROM medical_services WHERE slug = 'activities-of-daily-living-test');
SET @s = (SELECT id FROM medical_services WHERE slug = 'activities-of-daily-living-adl-test');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'activities-of-daily-living-adl-test', 'activities-of-daily-living-test', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 14. coordination-and-balance-exercises → услуга gait-coordination-correction-and-balance-automation-exercises: M01019 — упражнения на координацию и баланс
SET @p = (SELECT id FROM medical_services WHERE slug = 'gait-coordination-correction-and-balance-automation-exercises');
SET @s = (SELECT id FROM medical_services WHERE slug = 'coordination-and-balance-exercises');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'coordination-and-balance-exercises', 'gait-coordination-correction-and-balance-automation-exercises', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 15. patient-body-posture-training → услуга patient-training-in-specific-protective-body-positions: M01030 — обучение защитным положениям тела
SET @p = (SELECT id FROM medical_services WHERE slug = 'patient-training-in-specific-protective-body-positions');
SET @s = (SELECT id FROM medical_services WHERE slug = 'patient-body-posture-training');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'patient-body-posture-training', 'patient-training-in-specific-protective-body-positions', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 16. sanitary-patient-transport-per-kilometer → услуга medical-transport-per-km: санитарная перевозка за километр
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-transport-per-km');
SET @s = (SELECT id FROM medical_services WHERE slug = 'sanitary-patient-transport-per-kilometer');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'sanitary-patient-transport-per-kilometer', 'medical-transport-per-km', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 17. gastric-sounding-and-lavage → услуга gastric-lavage: промывание желудка (строки ДЗ на X02008 были постоянным катетером)
SET @p = (SELECT id FROM medical_services WHERE slug = 'gastric-lavage');
SET @s = (SELECT id FROM medical_services WHERE slug = 'gastric-sounding-and-lavage');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'gastric-sounding-and-lavage', 'gastric-lavage', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 18. vaginal-suppository-application → услуга cervical-drug-application: «Lokalno apliciranje lijeka vaginalete» — вагинальное введение лекарства; запись X01024 после 054 — «вагинально и цервикально» (в PDF строки GX01023 нет)
SET @p = (SELECT id FROM medical_services WHERE slug = 'cervical-drug-application');
SET @s = (SELECT id FROM medical_services WHERE slug = 'vaginal-suppository-application');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'vaginal-suppository-application', 'cervical-drug-application', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
-- названия сироты — синонимами цели (совпавшие с названием цели не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
CREATE TEMPORARY TABLE tmp_057_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl, TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_en, 'en' FROM tmp_057_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr, 'sr' FROM tmp_057_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_057_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_ru, 'ru' FROM tmp_057_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_de, 'de' FROM tmp_057_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT @p, n_tr, 'tr' FROM tmp_057_names WHERE n_tr NOT IN ('', @p_tr);
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 19. local-drug-application-subcutaneous-intramuscular-tb → услуга subcutaneous-or-intramuscular-injection: X01021 в разделе ТБ-центра — та же манипуляция; название «(TBC)» — только раздел прайса
SET @p = (SELECT id FROM medical_services WHERE slug = 'subcutaneous-or-intramuscular-injection');
SET @s = (SELECT id FROM medical_services WHERE slug = 'local-drug-application-subcutaneous-intramuscular-tb');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'local-drug-application-subcutaneous-intramuscular-tb', 'subcutaneous-or-intramuscular-injection', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 20. swab-collection-for-tb-analysis → услуга swab-collection-for-laboratory-analysis: X01007 в разделе ТБ-центра — то же взятие мазка
SET @p = (SELECT id FROM medical_services WHERE slug = 'swab-collection-for-laboratory-analysis');
SET @s = (SELECT id FROM medical_services WHERE slug = 'swab-collection-for-tb-analysis');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'swab-collection-for-tb-analysis', 'swab-collection-for-laboratory-analysis', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 21. enema-administration-tb-center → услуга enema: клизма «(TBC centar)» — выдумана на X01006 (кислород); по названию — клизма
SET @p = (SELECT id FROM medical_services WHERE slug = 'enema');
SET @s = (SELECT id FROM medical_services WHERE slug = 'enema-administration-tb-center');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'enema-administration-tb-center', 'enema', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 22. group-exercises-type-a → услуга group-exercises-type-b: «тип A» — выдуман на M01020 (дыхательные упражнения); по названию — групповые упражнения
SET @p = (SELECT id FROM medical_services WHERE slug = 'group-exercises-type-b');
SET @s = (SELECT id FROM medical_services WHERE slug = 'group-exercises-type-a');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'group-exercises-type-a', 'group-exercises-type-b', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 23. segmental-isokinetic-exercises → услуга segmental-isometric-exercises: M01026 — «Izometrijske vježbe segmentne», «izokinetičke» — ошибка чтения
SET @p = (SELECT id FROM medical_services WHERE slug = 'segmental-isometric-exercises');
SET @s = (SELECT id FROM medical_services WHERE slug = 'segmental-isokinetic-exercises');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'segmental-isokinetic-exercises', 'segmental-isometric-exercises', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 24. ultraviolet-and-biogenic-lamp-treatment → услуга infrared-ultraviolet-and-bioptron-lamp-irradiation: M01006 — «biogena lampa» = ошибка чтения «bioptron»
SET @p = (SELECT id FROM medical_services WHERE slug = 'infrared-ultraviolet-and-bioptron-lamp-irradiation');
SET @s = (SELECT id FROM medical_services WHERE slug = 'ultraviolet-and-biogenic-lamp-treatment');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'ultraviolet-and-biogenic-lamp-treatment', 'infrared-ultraviolet-and-bioptron-lamp-irradiation', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 25. back-exercises → услуга kinesiotherapy-for-spine-deformities: «Vježba leđa» — выдумана на M01017 (ходьба); по названию ближе всего кинезитерапия позвоночника
SET @p = (SELECT id FROM medical_services WHERE slug = 'kinesiotherapy-for-spine-deformities');
SET @s = (SELECT id FROM medical_services WHERE slug = 'back-exercises');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'back-exercises', 'kinesiotherapy-for-spine-deformities', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 26. fluoroscopy-examination → услуга lung-fluoroscopy: «Dijaskopski (fluo) pregled» раздела ТБ-центра — рентгеноскопия грудной клетки; строки ДЗ на X02013 были пункцией плевры
SET @p = (SELECT id FROM medical_services WHERE slug = 'lung-fluoroscopy');
SET @s = (SELECT id FROM medical_services WHERE slug = 'fluoroscopy-examination');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'fluoroscopy-examination', 'lung-fluoroscopy', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 27. endodontic-canal-contrast-radiography → услуга intraoral-x-ray: «Snimanje kanala sa kontrastom» — выдумано на J11004 (телерентгенография); по названию — внутриротовой снимок зуба
SET @p = (SELECT id FROM medical_services WHERE slug = 'intraoral-x-ray');
SET @s = (SELECT id FROM medical_services WHERE slug = 'endodontic-canal-contrast-radiography');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'endodontic-canal-contrast-radiography', 'intraoral-x-ray', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 28. speech-therapy-preventive-examination → услуга speech-development-assessment: «Logopedski preventivni pregled» — позиции нет в PDF; ближайшая — логопедическая оценка речевого развития (I03003)
SET @p = (SELECT id FROM medical_services WHERE slug = 'speech-development-assessment');
SET @s = (SELECT id FROM medical_services WHERE slug = 'speech-therapy-preventive-examination');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'speech-therapy-preventive-examination', 'speech-development-assessment', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 29. typhoid-immunoglobulin → услуга typhoid-vaccination-vivotif: иммуноглобулина против тифа не существует — строка HES08 была иммуноглобулином против бешенства; по названию — единственная «тифозная» запись
SET @p = (SELECT id FROM medical_services WHERE slug = 'typhoid-vaccination-vivotif');
SET @s = (SELECT id FROM medical_services WHERE slug = 'typhoid-immunoglobulin');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'typhoid-immunoglobulin', 'typhoid-vaccination-vivotif', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 30. medical-certificate-for-low-risk-work → услуга medical-certificate-low-risk-work-with-examination: работа без повышенного риска
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-low-risk-work-with-examination');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-low-risk-work');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-low-risk-work', 'medical-certificate-low-risk-work-with-examination', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 31. medical-certificate-for-significant-risk-work → услуга medical-certificate-for-high-risk-work: работа со значительным (повышенным) риском
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-high-risk-work');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-significant-risk-work');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-significant-risk-work', 'medical-certificate-for-high-risk-work', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 32. medical-certificate-for-educational-institutions → услуга medical-certificate-for-continued-education: справка для учёбы
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-continued-education');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-educational-institutions');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-educational-institutions', 'medical-certificate-for-continued-education', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 33. medical-certificate-disability-suspicion → услуга medical-certificate-for-other-purposes: аналога нет — общая «za druge potrebe»
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-disability-suspicion');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-disability-suspicion', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 34. medical-certificate-for-foreign-marriage → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-foreign-marriage');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-foreign-marriage', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 35. medical-certificate-for-licensing → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-licensing');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-licensing', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 36. medical-certificate-for-pension → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-pension');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-pension', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 37. medical-certificate-for-prison-visit → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-prison-visit');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-prison-visit', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 38. medical-certificate-for-psychotropic-work-monitoring → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-psychotropic-work-monitoring');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-psychotropic-work-monitoring', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 39. medical-certificate-for-special-course → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-special-course');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-special-course', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 40. medical-certificate-for-special-treatment → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-special-treatment');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-special-treatment', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 41. medical-certificate-for-visits-montenegro → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-visits-montenegro');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-for-visits-montenegro', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 42. medical-certificate-observation → услуга medical-certificate-for-other-purposes: аналога нет
SET @p = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-other-purposes');
SET @s = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-observation');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @deps = 0 AND @p <> @s);
INSERT INTO tmp_057_log (slug, target, kind, orphan_id, target_id, dependents, deleted)
SELECT 'medical-certificate-observation', 'medical-certificate-for-other-purposes', 'S', @s, @p, @deps, COALESCE(@ok, 0) FROM DUAL WHERE @s IS NOT NULL;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301 на услугу: числовой URL (старые редиректы на сироту — перецеливаем) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- ═══ ПОСЛЕ ═══

-- журнал этого прогона: deleted = 0 при dependents > 0 — запись НЕ удалена, разобрать руками
SELECT * FROM tmp_057_log ORDER BY deleted, kind, slug;

-- что из 43 осталось в каталоге (ожидается только typhoid-vaccination-vivotif — оставлена намеренно)
SELECT 'after' AS state, ms.slug,
	(SELECT COUNT(*) FROM clinic_medical_services c WHERE c.medical_service_id = ms.id) AS clinics
FROM medical_services ms
WHERE ms.slug IN (
	'alpha-amylase-activity',
	'c-reactive-protein-crp',
	'complete-blood-count-with-differential',
	'fecal-occult-blood-qualitative',
	'ldl-cholesterol-calculated',
	'serum-creatinine',
	'serum-urea-kinetic',
	'urine-hcg-strip-test',
	'urine-protein-qualitative',
	'urine-protein-quantitative',
	'vaginal-smear-microscopy',
	'joint-fluid-native-preparation',
	'activities-of-daily-living-adl-test',
	'coordination-and-balance-exercises',
	'patient-body-posture-training',
	'sanitary-patient-transport-per-kilometer',
	'gastric-sounding-and-lavage',
	'vaginal-suppository-application',
	'local-drug-application-subcutaneous-intramuscular-tb',
	'swab-collection-for-tb-analysis',
	'enema-administration-tb-center',
	'group-exercises-type-a',
	'segmental-isokinetic-exercises',
	'ultraviolet-and-biogenic-lamp-treatment',
	'back-exercises',
	'fluoroscopy-examination',
	'endodontic-canal-contrast-radiography',
	'speech-therapy-preventive-examination',
	'typhoid-immunoglobulin',
	'medical-certificate-for-low-risk-work',
	'medical-certificate-for-significant-risk-work',
	'medical-certificate-for-educational-institutions',
	'medical-certificate-disability-suspicion',
	'medical-certificate-for-foreign-marriage',
	'medical-certificate-for-licensing',
	'medical-certificate-for-pension',
	'medical-certificate-for-prison-visit',
	'medical-certificate-for-psychotropic-work-monitoring',
	'medical-certificate-for-special-course',
	'medical-certificate-for-special-treatment',
	'medical-certificate-for-visits-montenegro',
	'medical-certificate-observation',
	'typhoid-vaccination-vivotif')
ORDER BY ms.slug;

-- 301 по слагам сирот: у каждой цель — живая запись своего каталога
SELECT sr.old_slug, COALESCE(sr.target_entity_type, sr.entity_type) AS target_catalog, sr.entity_id,
	COALESCE(ms.slug, lt.slug) AS target_slug
FROM slug_redirects sr
LEFT JOIN medical_services ms ON ms.id = sr.entity_id AND COALESCE(sr.target_entity_type, sr.entity_type) = 'services'
LEFT JOIN lab_tests lt ON lt.id = sr.entity_id AND sr.target_entity_type = 'labtests'
WHERE sr.entity_type = 'services' AND sr.old_slug IN (
	'alpha-amylase-activity',
	'c-reactive-protein-crp',
	'complete-blood-count-with-differential',
	'fecal-occult-blood-qualitative',
	'ldl-cholesterol-calculated',
	'serum-creatinine',
	'serum-urea-kinetic',
	'urine-hcg-strip-test',
	'urine-protein-qualitative',
	'urine-protein-quantitative',
	'vaginal-smear-microscopy',
	'joint-fluid-native-preparation',
	'activities-of-daily-living-adl-test',
	'coordination-and-balance-exercises',
	'patient-body-posture-training',
	'sanitary-patient-transport-per-kilometer',
	'gastric-sounding-and-lavage',
	'vaginal-suppository-application',
	'local-drug-application-subcutaneous-intramuscular-tb',
	'swab-collection-for-tb-analysis',
	'enema-administration-tb-center',
	'group-exercises-type-a',
	'segmental-isokinetic-exercises',
	'ultraviolet-and-biogenic-lamp-treatment',
	'back-exercises',
	'fluoroscopy-examination',
	'endodontic-canal-contrast-radiography',
	'speech-therapy-preventive-examination',
	'typhoid-immunoglobulin',
	'medical-certificate-for-low-risk-work',
	'medical-certificate-for-significant-risk-work',
	'medical-certificate-for-educational-institutions',
	'medical-certificate-disability-suspicion',
	'medical-certificate-for-foreign-marriage',
	'medical-certificate-for-licensing',
	'medical-certificate-for-pension',
	'medical-certificate-for-prison-visit',
	'medical-certificate-for-psychotropic-work-monitoring',
	'medical-certificate-for-special-course',
	'medical-certificate-for-special-treatment',
	'medical-certificate-for-visits-montenegro',
	'medical-certificate-observation')
ORDER BY target_catalog, sr.old_slug;

SELECT 'after' AS state, (SELECT COUNT(*) FROM medical_services) AS medical_services_total,
	(SELECT COUNT(*) FROM slug_redirects) AS slug_redirects_total,
	(SELECT COUNT(*) FROM medical_service_redirects) AS medical_service_redirects_total;

DROP TEMPORARY TABLE IF EXISTS tmp_057_names;
DROP TEMPORARY TABLE IF EXISTS tmp_057_targets;
DROP TEMPORARY TABLE IF EXISTS tmp_057_log;

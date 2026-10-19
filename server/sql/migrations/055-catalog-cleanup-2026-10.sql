SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 055: чистка каталога услуг после 054 — дубли, сироты, привязки тарифов ФЗОЦГ (PZZ K и D, секундарные D/X),
-- справка cervical-drug-application.
--
-- Порядок: ПОСЛЕ 054 (сироты и строки ДЗ — её наследие), ДО 056 (исправление ДЗ Херцег-Нови и Мойковац).
-- Всё по slug / (tariff_source, code); клиники — по коду строки прайса, литеральных id нет (на проде id другие).
-- Процедур нет: файл прогоняется и на сессионных TEMPORARY-копиях таблиц, поэтому дубль читается через tmp_*.
--
-- 1. Слияния 5 пар (остаётся ← уходит), процедура 030/039: строки клиник (при совпадении клиники — строка основной,
--    пустые цена/код дозаполняются), врачи, специальности, категории, тарифы, отзывы, синонимы, справка;
--    названия уходящей — синонимами основной; 301 через medical_service_redirects и slug_redirects.
--      mechanical-contraceptive-device-check   ← contraceptive-device-check                         (X01017)
--      social-worker-interview-social-history  ← social-survey-interview                            (H04002)
--      primary-wound-care-without-sutures      ← wound-care-without-suturing                        (X01014)
--      subcutaneous-or-intramuscular-injection ← local-drug-application-subcutaneous-and-intramuscular (X01021)
--      swab-collection-for-laboratory-analysis ← routine-swab-sample-collection                     (X01007)
--    Уходят 11 строк клиник (ДЗ Херцег-Нови, Мойковац, Ульцинь), тарифов/отзывов/врачей/справок у уходящих нет.
--    Пара chest-ribs-or-sternum-x-ray-per-view / x-ray-sternum НЕ сливается (первая шире: рёбра или грудина).
-- 2. Пять записей-сирот после 054 (ни клиник, ни тарифов, ни отзывов, ни синонимов, ни справок — проверяется
--    в самом файле, при зависимостях запись не трогается) удаляются с 301 на ближайшую по смыслу живую запись.
--    Их названия — ошибки распознавания сканов ДЗ Херцег-Нови, синонимами не переносятся.
-- 3. Секундарный прайс: D01061 (радикальная гистерэктомия Вертгейма — Мейгса), D02230 (лапароскопическая операция
--    Гартмана), D06122 (склеральный буклинг с имплантатом) стояли на чужих операциях — три новые записи, на них тариф
--    и строки Данило / ОБ Никшич с этим кодом. X01033 / X01035 — имена и цены, съехавшие в FINAL на соседей;
--    X01035 привязан к bladder-catheterization-in-males.
-- 4. PZZ K: 45 непривязанных тарифов (38 в K01 + 7 в K02) — к записям, где лежат строки больниц с тем же кодом;
--    секундарные двойники тех же кодов (44, кроме K02008) — туда же.
-- 5. PZZ D (стоматология, 107 кодов, была 1 привязка): +58 привязок по названию, 48 оставлено (список в разделе 5).
-- 6. Справка cervical-drug-application переписана под «вагинально и цервикально».
--
-- Файлы, поправленные тем же коммитом (чтобы пересборка не откатила):
--   data/fzocg/sekundarna-ostalo/sekundarna-ostalo-FINAL.json и server/sql/insert-tariff-fzocg-sekundarna.sql — X01033/X01035;
--   data/entity-reference/medical-services-w3-48.json и server/sql/migrations/insert-entity-reference-info.sql — справка;
--   server/sql/insert-clinic-dom-zdravlja-ulcinj-services.sql — уходящие слаги заменены выживающими.
--   Карточек справок у уходящих записей нет ни в БД, ни в data/entity-reference — чистить нечего.
--
-- Идемпотентно: слияние и удаление — только пока обе записи на месте; новые записи — ON DUPLICATE KEY;
-- переносы — с исходной записи; привязки K/D — только непривязанных строк; имена/цены и справка — присваивание.


-- ═══ 0. ДО ═══

SELECT 'before' AS state, ms.slug,
	(SELECT COUNT(*) FROM clinic_medical_services c WHERE c.medical_service_id = ms.id) AS clinics,
	(SELECT GROUP_CONCAT(CONCAT(t.tariff_source, ':', t.code) ORDER BY t.code) FROM medical_service_tariffs t WHERE t.medical_service_id = ms.id) AS tariffs,
	(SELECT COUNT(*) FROM reviews r WHERE r.medical_service_id = ms.id) AS reviews,
	(SELECT COUNT(*) FROM medical_service_synonyms y WHERE y.medical_service_id = ms.id) AS synonyms,
	(SELECT COUNT(*) FROM medical_service_reference_info i WHERE i.medical_service_id = ms.id) AS reference_card
FROM medical_services ms
WHERE ms.slug IN ('mechanical-contraceptive-device-check', 'contraceptive-device-check', 'social-worker-interview-social-history', 'social-survey-interview', 'primary-wound-care-without-sutures', 'wound-care-without-suturing', 'subcutaneous-or-intramuscular-injection', 'local-drug-application-subcutaneous-and-intramuscular', 'swab-collection-for-laboratory-analysis', 'routine-swab-sample-collection', 'reproductive-age-women-preventive-examination-with-pap-test', 'gynecological-preventive-visit', 'legal-responsibility-assessment', 'expert-organized-assessment', 'social-worker-expert-assessment', 'social-worker-counseling-and-intervention', 'individual-supportive-therapy', 'individual-preventive-therapy', 'wechsler-bellevue-test-for-special-needs-children-over-14', 'wechsler-bellevue-test-variant-for-special-needs-over-14', 'total-laparoscopic-abdominal-hysterectomy', 'radical-hysterectomy-wertheim-meigs', 'hartmann-reconstruction', 'laparoscopic-hartmann-procedure', 'scleral-buckle-with-vitrectomy', 'scleral-buckling-with-implant', 'bladder-catheterization-in-males', 'iv-cannula-application')
ORDER BY ms.slug;

SELECT 'before' AS state, t.tariff_source, t.code, t.price_odjeljenje_eur, t.price_ambulanta_eur, t.name_sr_latin, ms.slug
FROM medical_service_tariffs t LEFT JOIN medical_services ms ON ms.id = t.medical_service_id
WHERE t.tariff_source = 'fzocg-sekundarna' AND t.code IN ('D01061', 'D02230', 'D06122', 'X01032', 'X01033', 'X01034', 'X01035')
ORDER BY t.code;

SELECT 'before' AS state, t.tariff_source, LEFT(t.code, 1) AS block,
	COUNT(*) AS total, SUM(t.medical_service_id IS NOT NULL) AS on_services, SUM(t.lab_test_id IS NOT NULL) AS on_lab_tests,
	SUM(t.medical_service_id IS NULL AND t.lab_test_id IS NULL) AS unlinked
FROM medical_service_tariffs t
WHERE (t.tariff_source = 'fzocg-pzz' AND (t.code LIKE 'K%' OR t.code LIKE 'D%'))
   OR (t.tariff_source = 'fzocg-sekundarna' AND (t.code LIKE 'K01%' OR t.code LIKE 'K02%'))
GROUP BY t.tariff_source, LEFT(t.code, 1) ORDER BY t.tariff_source, block;

SELECT 'before' AS state, (SELECT COUNT(*) FROM medical_services) AS medical_services_total,
	(SELECT COUNT(*) FROM clinic_medical_services) AS clinic_medical_services_total,
	(SELECT COUNT(*) FROM medical_service_redirects) AS redirects_total;

-- ═══ 1. Слияния дублей (остаётся ← уходит) ═══

-- 1.0 contraceptive-device-check → mechanical-contraceptive-device-check
-- X01017 «Kontrola mehaničkog kontraceptivnog sredstva»: сербское название одно, у дубля строки ДЗ Херцег-Нови/Мойковац (HN_GX01017), у основной — тарифы PZZ X01017 и секундарный X04019
SET @p = (SELECT id FROM medical_services WHERE slug = 'mechanical-contraceptive-device-check');
SET @s = (SELECT id FROM medical_services WHERE slug = 'contraceptive-device-check');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);
SELECT 'contraceptive-device-check' AS merging, 'mechanical-contraceptive-device-check' AS into_slug, @s AS secondary_id, @p AS primary_id, @ok AS will_merge;

-- строки клиник дубля — во временную таблицу (временную копию нельзя читать и писать одним запросом)
DROP TEMPORARY TABLE IF EXISTS tmp_sec_cms;
CREATE TEMPORARY TABLE tmp_sec_cms AS
SELECT clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete
  FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
-- клиники, которых у основной ещё нет
INSERT IGNORE INTO clinic_medical_services (medical_service_id, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete)
SELECT @p, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete FROM tmp_sec_cms;
-- клиника была на обеих: оставляем строку основной, пустые цену/код дозаполняем из дубля
-- (is_price_outdated — первым: SET вычисляется слева направо)
UPDATE clinic_medical_services p
  JOIN tmp_sec_cms s ON s.clinic_id = p.clinic_id
   SET p.is_price_outdated = CASE WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated ELSE p.is_price_outdated END,
       p.price = COALESCE(p.price, s.price),
       p.price_min = COALESCE(p.price_min, s.price_min),
       p.price_max = COALESCE(p.price_max, s.price_max),
       p.code = COALESCE(p.code, s.code)
 WHERE p.medical_service_id = @p;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT specialty_id AS rel_id FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT @p, rel_id FROM tmp_sec_rel;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT medical_service_category_id AS rel_id FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT @p, rel_id FROM tmp_sec_rel;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_doc;
CREATE TEMPORARY TABLE tmp_sec_doc AS
SELECT clinic_id, doctor_id, price, price_max FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, @p, doctor_id, price, price_max FROM tmp_sec_doc;

-- справка (UNIQUE по услуге: переедет, только если у основной своей нет), тарифы, отзывы, синонимы
UPDATE IGNORE medical_service_reference_info SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE medical_service_tariffs SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE reviews SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE IGNORE medical_service_synonyms SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;

-- названия дубля — синонимами основной (совпавшие с названием основной не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_sec_names;
CREATE TEMPORARY TABLE tmp_sec_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl,
       TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_en, 'en' FROM tmp_sec_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr, 'sr' FROM tmp_sec_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_sec_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_ru, 'ru' FROM tmp_sec_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_de, 'de' FROM tmp_sec_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_tr, 'tr' FROM tmp_sec_names WHERE n_tr NOT IN ('', @p_tr);

-- связи дубля
DELETE FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 1.1 social-survey-interview → social-worker-interview-social-history
-- H04002 «Socijalni radnik-intervju» (PZZ) = «Intervju socijalnog radnika - socijalna anamneza» (секундарный): у дубля строка ДЗ Херцег-Нови с тем же кодом H04002
SET @p = (SELECT id FROM medical_services WHERE slug = 'social-worker-interview-social-history');
SET @s = (SELECT id FROM medical_services WHERE slug = 'social-survey-interview');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);
SELECT 'social-survey-interview' AS merging, 'social-worker-interview-social-history' AS into_slug, @s AS secondary_id, @p AS primary_id, @ok AS will_merge;

-- строки клиник дубля — во временную таблицу (временную копию нельзя читать и писать одним запросом)
DROP TEMPORARY TABLE IF EXISTS tmp_sec_cms;
CREATE TEMPORARY TABLE tmp_sec_cms AS
SELECT clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete
  FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
-- клиники, которых у основной ещё нет
INSERT IGNORE INTO clinic_medical_services (medical_service_id, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete)
SELECT @p, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete FROM tmp_sec_cms;
-- клиника была на обеих: оставляем строку основной, пустые цену/код дозаполняем из дубля
-- (is_price_outdated — первым: SET вычисляется слева направо)
UPDATE clinic_medical_services p
  JOIN tmp_sec_cms s ON s.clinic_id = p.clinic_id
   SET p.is_price_outdated = CASE WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated ELSE p.is_price_outdated END,
       p.price = COALESCE(p.price, s.price),
       p.price_min = COALESCE(p.price_min, s.price_min),
       p.price_max = COALESCE(p.price_max, s.price_max),
       p.code = COALESCE(p.code, s.code)
 WHERE p.medical_service_id = @p;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT specialty_id AS rel_id FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT @p, rel_id FROM tmp_sec_rel;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT medical_service_category_id AS rel_id FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT @p, rel_id FROM tmp_sec_rel;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_doc;
CREATE TEMPORARY TABLE tmp_sec_doc AS
SELECT clinic_id, doctor_id, price, price_max FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, @p, doctor_id, price, price_max FROM tmp_sec_doc;

-- справка (UNIQUE по услуге: переедет, только если у основной своей нет), тарифы, отзывы, синонимы
UPDATE IGNORE medical_service_reference_info SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE medical_service_tariffs SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE reviews SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE IGNORE medical_service_synonyms SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;

-- названия дубля — синонимами основной (совпавшие с названием основной не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_sec_names;
CREATE TEMPORARY TABLE tmp_sec_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl,
       TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_en, 'en' FROM tmp_sec_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr, 'sr' FROM tmp_sec_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_sec_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_ru, 'ru' FROM tmp_sec_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_de, 'de' FROM tmp_sec_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_tr, 'tr' FROM tmp_sec_names WHERE n_tr NOT IN ('', @p_tr);

-- связи дубля
DELETE FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 1.2 wound-care-without-suturing → primary-wound-care-without-sutures
-- X01014 «Primarna obrada rane bez šivenja»: у дубля строки ДЗ ХН/Мойковац/Ульцинь с кодом X01014, у основной тарифы X01014 и справка
SET @p = (SELECT id FROM medical_services WHERE slug = 'primary-wound-care-without-sutures');
SET @s = (SELECT id FROM medical_services WHERE slug = 'wound-care-without-suturing');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);
SELECT 'wound-care-without-suturing' AS merging, 'primary-wound-care-without-sutures' AS into_slug, @s AS secondary_id, @p AS primary_id, @ok AS will_merge;

-- строки клиник дубля — во временную таблицу (временную копию нельзя читать и писать одним запросом)
DROP TEMPORARY TABLE IF EXISTS tmp_sec_cms;
CREATE TEMPORARY TABLE tmp_sec_cms AS
SELECT clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete
  FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
-- клиники, которых у основной ещё нет
INSERT IGNORE INTO clinic_medical_services (medical_service_id, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete)
SELECT @p, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete FROM tmp_sec_cms;
-- клиника была на обеих: оставляем строку основной, пустые цену/код дозаполняем из дубля
-- (is_price_outdated — первым: SET вычисляется слева направо)
UPDATE clinic_medical_services p
  JOIN tmp_sec_cms s ON s.clinic_id = p.clinic_id
   SET p.is_price_outdated = CASE WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated ELSE p.is_price_outdated END,
       p.price = COALESCE(p.price, s.price),
       p.price_min = COALESCE(p.price_min, s.price_min),
       p.price_max = COALESCE(p.price_max, s.price_max),
       p.code = COALESCE(p.code, s.code)
 WHERE p.medical_service_id = @p;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT specialty_id AS rel_id FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT @p, rel_id FROM tmp_sec_rel;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT medical_service_category_id AS rel_id FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT @p, rel_id FROM tmp_sec_rel;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_doc;
CREATE TEMPORARY TABLE tmp_sec_doc AS
SELECT clinic_id, doctor_id, price, price_max FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, @p, doctor_id, price, price_max FROM tmp_sec_doc;

-- справка (UNIQUE по услуге: переедет, только если у основной своей нет), тарифы, отзывы, синонимы
UPDATE IGNORE medical_service_reference_info SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE medical_service_tariffs SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE reviews SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE IGNORE medical_service_synonyms SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;

-- названия дубля — синонимами основной (совпавшие с названием основной не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_sec_names;
CREATE TEMPORARY TABLE tmp_sec_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl,
       TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_en, 'en' FROM tmp_sec_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr, 'sr' FROM tmp_sec_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_sec_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_ru, 'ru' FROM tmp_sec_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_de, 'de' FROM tmp_sec_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_tr, 'tr' FROM tmp_sec_names WHERE n_tr NOT IN ('', @p_tr);

-- связи дубля
DELETE FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 1.3 local-drug-application-subcutaneous-and-intramuscular → subcutaneous-or-intramuscular-injection
-- X01021 «Lokalno apliciranje lijeka (subkutano i intramuskularno)» = «Davanje subkutanih i intramuskularnih injekcija»: у дубля строки ДЗ ХН/Мойковац/Ульцинь с кодом X01021, у основной тарифы X01021 и справка
SET @p = (SELECT id FROM medical_services WHERE slug = 'subcutaneous-or-intramuscular-injection');
SET @s = (SELECT id FROM medical_services WHERE slug = 'local-drug-application-subcutaneous-and-intramuscular');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);
SELECT 'local-drug-application-subcutaneous-and-intramuscular' AS merging, 'subcutaneous-or-intramuscular-injection' AS into_slug, @s AS secondary_id, @p AS primary_id, @ok AS will_merge;

-- строки клиник дубля — во временную таблицу (временную копию нельзя читать и писать одним запросом)
DROP TEMPORARY TABLE IF EXISTS tmp_sec_cms;
CREATE TEMPORARY TABLE tmp_sec_cms AS
SELECT clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete
  FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
-- клиники, которых у основной ещё нет
INSERT IGNORE INTO clinic_medical_services (medical_service_id, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete)
SELECT @p, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete FROM tmp_sec_cms;
-- клиника была на обеих: оставляем строку основной, пустые цену/код дозаполняем из дубля
-- (is_price_outdated — первым: SET вычисляется слева направо)
UPDATE clinic_medical_services p
  JOIN tmp_sec_cms s ON s.clinic_id = p.clinic_id
   SET p.is_price_outdated = CASE WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated ELSE p.is_price_outdated END,
       p.price = COALESCE(p.price, s.price),
       p.price_min = COALESCE(p.price_min, s.price_min),
       p.price_max = COALESCE(p.price_max, s.price_max),
       p.code = COALESCE(p.code, s.code)
 WHERE p.medical_service_id = @p;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT specialty_id AS rel_id FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT @p, rel_id FROM tmp_sec_rel;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT medical_service_category_id AS rel_id FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT @p, rel_id FROM tmp_sec_rel;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_doc;
CREATE TEMPORARY TABLE tmp_sec_doc AS
SELECT clinic_id, doctor_id, price, price_max FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, @p, doctor_id, price, price_max FROM tmp_sec_doc;

-- справка (UNIQUE по услуге: переедет, только если у основной своей нет), тарифы, отзывы, синонимы
UPDATE IGNORE medical_service_reference_info SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE medical_service_tariffs SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE reviews SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE IGNORE medical_service_synonyms SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;

-- названия дубля — синонимами основной (совпавшие с названием основной не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_sec_names;
CREATE TEMPORARY TABLE tmp_sec_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl,
       TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_en, 'en' FROM tmp_sec_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr, 'sr' FROM tmp_sec_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_sec_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_ru, 'ru' FROM tmp_sec_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_de, 'de' FROM tmp_sec_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_tr, 'tr' FROM tmp_sec_names WHERE n_tr NOT IN ('', @p_tr);

-- связи дубля
DELETE FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 1.4 routine-swab-sample-collection → swab-collection-for-laboratory-analysis
-- X01007 «Uzimanje briseva sa slanjem na analizu»: у дубля строки ДЗ ХН/Мойковац с кодом X01007, у основной тарифы X01007 и справка
SET @p = (SELECT id FROM medical_services WHERE slug = 'swab-collection-for-laboratory-analysis');
SET @s = (SELECT id FROM medical_services WHERE slug = 'routine-swab-sample-collection');
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s);
SELECT 'routine-swab-sample-collection' AS merging, 'swab-collection-for-laboratory-analysis' AS into_slug, @s AS secondary_id, @p AS primary_id, @ok AS will_merge;

-- строки клиник дубля — во временную таблицу (временную копию нельзя читать и писать одним запросом)
DROP TEMPORARY TABLE IF EXISTS tmp_sec_cms;
CREATE TEMPORARY TABLE tmp_sec_cms AS
SELECT clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete
  FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
-- клиники, которых у основной ещё нет
INSERT IGNORE INTO clinic_medical_services (medical_service_id, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete)
SELECT @p, clinic_id, code, price, price_min, price_max, is_price_outdated, is_obsolete FROM tmp_sec_cms;
-- клиника была на обеих: оставляем строку основной, пустые цену/код дозаполняем из дубля
-- (is_price_outdated — первым: SET вычисляется слева направо)
UPDATE clinic_medical_services p
  JOIN tmp_sec_cms s ON s.clinic_id = p.clinic_id
   SET p.is_price_outdated = CASE WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated ELSE p.is_price_outdated END,
       p.price = COALESCE(p.price, s.price),
       p.price_min = COALESCE(p.price_min, s.price_min),
       p.price_max = COALESCE(p.price_max, s.price_max),
       p.code = COALESCE(p.code, s.code)
 WHERE p.medical_service_id = @p;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT specialty_id AS rel_id FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT @p, rel_id FROM tmp_sec_rel;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
CREATE TEMPORARY TABLE tmp_sec_rel AS
SELECT medical_service_category_id AS rel_id FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT @p, rel_id FROM tmp_sec_rel;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_doc;
CREATE TEMPORARY TABLE tmp_sec_doc AS
SELECT clinic_id, doctor_id, price, price_max FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
INSERT IGNORE INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT clinic_id, @p, doctor_id, price, price_max FROM tmp_sec_doc;

-- справка (UNIQUE по услуге: переедет, только если у основной своей нет), тарифы, отзывы, синонимы
UPDATE IGNORE medical_service_reference_info SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE medical_service_tariffs SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE reviews SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;
UPDATE IGNORE medical_service_synonyms SET medical_service_id = @p WHERE medical_service_id = @s AND @ok;

-- названия дубля — синонимами основной (совпавшие с названием основной не нужны)
SET @p_en = (SELECT TRIM(COALESCE(name_en, '')) FROM medical_services WHERE id = @p);
SET @p_sr = (SELECT TRIM(COALESCE(name_sr, '')) FROM medical_services WHERE id = @p);
SET @p_sr_cyrl = (SELECT TRIM(COALESCE(name_sr_cyrl, '')) FROM medical_services WHERE id = @p);
SET @p_ru = (SELECT TRIM(COALESCE(name_ru, '')) FROM medical_services WHERE id = @p);
SET @p_de = (SELECT TRIM(COALESCE(name_de, '')) FROM medical_services WHERE id = @p);
SET @p_tr = (SELECT TRIM(COALESCE(name_tr, '')) FROM medical_services WHERE id = @p);
DROP TEMPORARY TABLE IF EXISTS tmp_sec_names;
CREATE TEMPORARY TABLE tmp_sec_names AS
SELECT TRIM(COALESCE(name_en, '')) AS n_en, TRIM(COALESCE(name_sr, '')) AS n_sr, TRIM(COALESCE(name_sr_cyrl, '')) AS n_sr_cyrl,
       TRIM(COALESCE(name_ru, '')) AS n_ru, TRIM(COALESCE(name_de, '')) AS n_de, TRIM(COALESCE(name_tr, '')) AS n_tr
  FROM medical_services WHERE id = @s AND @ok;
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_en, 'en' FROM tmp_sec_names WHERE n_en NOT IN ('', @p_en);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr, 'sr' FROM tmp_sec_names WHERE n_sr NOT IN ('', @p_sr);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_sr_cyrl, 'sr-cyrl' FROM tmp_sec_names WHERE n_sr_cyrl NOT IN ('', @p_sr_cyrl);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_ru, 'ru' FROM tmp_sec_names WHERE n_ru NOT IN ('', @p_ru);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_de, 'de' FROM tmp_sec_names WHERE n_de NOT IN ('', @p_de);
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @p, n_tr, 'tr' FROM tmp_sec_names WHERE n_tr NOT IN ('', @p_tr);

-- связи дубля
DELETE FROM clinic_medical_services WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
DELETE FROM clinic_medical_service_doctors WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- синонимы, совпавшие с собственным названием основной (как 031)
DELETE syn FROM medical_service_synonyms syn
  JOIN medical_services e ON e.id = syn.medical_service_id
 WHERE e.slug IN ('mechanical-contraceptive-device-check', 'social-worker-interview-social-history', 'primary-wound-care-without-sutures', 'subcutaneous-or-intramuscular-injection', 'swab-collection-for-laboratory-analysis')
   AND syn.another_name = CASE syn.language
           WHEN 'en' THEN e.name_en WHEN 'sr' THEN e.name_sr WHEN 'sr-cyrl' THEN e.name_sr_cyrl
           WHEN 'ru' THEN e.name_ru WHEN 'de' THEN e.name_de WHEN 'tr' THEN e.name_tr ELSE NULL END;

-- ═══ 2. Записи-сироты после 054 (без клиник, тарифов, отзывов, синонимов, справок) → 301 ═══

-- 2.0 gynecological-preventive-visit → 301 на reproductive-age-women-preventive-examination-with-pap-test
-- «Preventivni odlazak ginekologu…» — искажённое чтение C01002 (кариотип плода; строки ушли в анализ в 054). По смыслу названия ближе всего профилактический гинекологический осмотр C01007
SET @p = (SELECT id FROM medical_services WHERE slug = 'reproductive-age-women-preventive-examination-with-pap-test');
SET @s = (SELECT id FROM medical_services WHERE slug = 'gynecological-preventive-visit');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_reference_info WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s AND @deps = 0);
SELECT 'gynecological-preventive-visit' AS retiring, 'reproductive-age-women-preventive-examination-with-pap-test' AS redirect_to, @s AS orphan_id, @p AS target_id, @deps AS dependents, @ok AS will_delete;
-- категории/специальности/названия сироты не переносим: названия — ошибки распознавания, связи у цели свои
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 2.1 expert-organized-assessment → 301 на legal-responsibility-assessment
-- «Vještačenje stručno organizovano» — искажённое чтение H04010 «Vještačenje zakonske odgovornosti»; строки клиник туда и ушли в 054
SET @p = (SELECT id FROM medical_services WHERE slug = 'legal-responsibility-assessment');
SET @s = (SELECT id FROM medical_services WHERE slug = 'expert-organized-assessment');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_reference_info WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s AND @deps = 0);
SELECT 'expert-organized-assessment' AS retiring, 'legal-responsibility-assessment' AS redirect_to, @s AS orphan_id, @p AS target_id, @deps AS dependents, @ok AS will_delete;
-- категории/специальности/названия сироты не переносим: названия — ошибки распознавания, связи у цели свои
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 2.2 social-worker-counseling-and-intervention → 301 на social-worker-expert-assessment
-- «Socijalni radnik - savjetovanje i intervencije» — искажённое чтение H04001 «Socijalni radnik, nalaz i mišljenje»; строки ушли туда в 054
SET @p = (SELECT id FROM medical_services WHERE slug = 'social-worker-expert-assessment');
SET @s = (SELECT id FROM medical_services WHERE slug = 'social-worker-counseling-and-intervention');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_reference_info WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s AND @deps = 0);
SELECT 'social-worker-counseling-and-intervention' AS retiring, 'social-worker-expert-assessment' AS redirect_to, @s AS orphan_id, @p AS target_id, @deps AS dependents, @ok AS will_delete;
-- категории/специальности/названия сироты не переносим: названия — ошибки распознавания, связи у цели свои
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 2.3 individual-preventive-therapy → 301 на individual-supportive-therapy
-- «Individualna preventivna terapija» — искажённое чтение H02025 «Individualna površna terapija»; строки ушли туда в 054
SET @p = (SELECT id FROM medical_services WHERE slug = 'individual-supportive-therapy');
SET @s = (SELECT id FROM medical_services WHERE slug = 'individual-preventive-therapy');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_reference_info WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s AND @deps = 0);
SELECT 'individual-preventive-therapy' AS retiring, 'individual-supportive-therapy' AS redirect_to, @s AS orphan_id, @p AS target_id, @deps AS dependents, @ok AS will_delete;
-- категории/специальности/названия сироты не переносим: названия — ошибки распознавания, связи у цели свои
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- 2.4 wechsler-bellevue-test-variant-for-special-needs-over-14 → 301 на wechsler-bellevue-test-for-special-needs-children-over-14
-- «W-B skala (alt)» — второе чтение той же строки H02013, после сдвига 054 оно лишнее
SET @p = (SELECT id FROM medical_services WHERE slug = 'wechsler-bellevue-test-for-special-needs-children-over-14');
SET @s = (SELECT id FROM medical_services WHERE slug = 'wechsler-bellevue-test-variant-for-special-needs-over-14');
SET @deps = (SELECT COUNT(*) FROM clinic_medical_services WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_tariffs WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM reviews WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = @s)
          + (SELECT COUNT(*) FROM medical_service_reference_info WHERE medical_service_id = @s);
SET @ok = (@p IS NOT NULL AND @s IS NOT NULL AND @p <> @s AND @deps = 0);
SELECT 'wechsler-bellevue-test-variant-for-special-needs-over-14' AS retiring, 'wechsler-bellevue-test-for-special-needs-children-over-14' AS redirect_to, @s AS orphan_id, @p AS target_id, @deps AS dependents, @ok AS will_delete;
-- категории/специальности/названия сироты не переносим: названия — ошибки распознавания, связи у цели свои
DELETE FROM medical_services_specialties WHERE medical_service_id = @s AND @ok;
DELETE FROM medical_service_categories_relations WHERE medical_service_id = @s AND @ok;
-- 301: числовой URL (сначала перецеливаем старые редиректы на дубль) и слаг
UPDATE medical_service_redirects SET new_id = @p WHERE new_id = @s AND @ok;
INSERT IGNORE INTO medical_service_redirects (old_id, new_id) SELECT @s, @p FROM DUAL WHERE @ok;
UPDATE slug_redirects SET entity_id = @p
 WHERE entity_id = @s AND COALESCE(target_entity_type, entity_type) = 'services' AND @ok;
INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'services', slug, @p FROM medical_services WHERE id = @s AND @ok;
DELETE FROM medical_services WHERE id = @s AND @ok;

-- ═══ 3. Секундарный прайс: привязки D01061 / D02230 / D06122 и имена X01033 / X01035 ═══

-- 3.0 D01061: total-laparoscopic-abdominal-hysterectomy → radical-hysterectomy-wertheim-meigs (новая запись)
-- D01061 «Radikalna histerektomija sa Wertheim Meigs» (прайс Данило: «RADIKALNA HISTEREKTOMIJA SEC. WERTHEIM MEIGS», 1668 €) стоял на «тотальной лапароскопической гистерэктомии» — это другая операция (открытая радикальная, с параметриями и лимфоузлами). Новая запись — как соседи D01007/D01060 (категории 7, 16; специальность 5). Частные клиники (A3 Medical, Da Vinci) остаются на лапароскопической — у них она и есть
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Radical Hysterectomy (Wertheim-Meigs)', 'radical-hysterectomy-wertheim-meigs', 'Radikalna histerektomija po Wertheim-Meigsu', 'Радикална хистеректомија по Вертхајм-Мејгсу', 'Радикальная гистерэктомия (операция Вертгейма — Мейгса)', 'Radikale Hysterektomie nach Wertheim-Meigs', 'Radikal histerektomi (Wertheim-Meigs)')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'radical-hysterectomy-wertheim-meigs';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 16 FROM medical_services WHERE slug = 'radical-hysterectomy-wertheim-meigs';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'radical-hysterectomy-wertheim-meigs';
SET @from = (SELECT id FROM medical_services WHERE slug = 'total-laparoscopic-abdominal-hysterectomy');
SET @to = (SELECT id FROM medical_services WHERE slug = 'radical-hysterectomy-wertheim-meigs');
UPDATE medical_service_tariffs SET medical_service_id = @to
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D01061' AND medical_service_id = @from AND @to IS NOT NULL;
-- строки больниц с этим кодом (Данило, ОБ Никшич; по коду, не по id клиники)
UPDATE clinic_medical_services SET medical_service_id = @to
 WHERE medical_service_id = @from AND REGEXP_SUBSTR(code, '[A-Z][0-9]{5}') = 'D01061' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_service_doctors SET medical_service_id = @to
 WHERE medical_service_id = @from AND @to IS NOT NULL
   AND clinic_id IN (SELECT clinic_id FROM clinic_medical_services WHERE medical_service_id = @to);

-- 3.1 D02230: hartmann-reconstruction → laparoscopic-hartmann-procedure (новая запись)
-- D02230 «Hartmanova procedura laparoskopska» (прайс Данило: «HARTMANOVA PROCEDURA LAPAROSKOPSKA», 1251 €) стоял на «реконструкции после операции Гартмана» (синонимы записи — Hartmann Reversal, «Zatvaranje kolostome») — это обратная операция. Новая запись — как соседи D02226/D02250 (категория 17, специальность 3). Частные клиники (A3 Medical, Ars Medica) остаются на реконструкции
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Laparoscopic Hartmann Procedure', 'laparoscopic-hartmann-procedure', 'Laparoskopska Hartmanova procedura', 'Лапароскопска Хартманова процедура', 'Лапароскопическая операция Гартмана', 'Laparoskopische Hartmann-Operation', 'Laparoskopik Hartmann prosedürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 17 FROM medical_services WHERE slug = 'laparoscopic-hartmann-procedure';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 3 FROM medical_services WHERE slug = 'laparoscopic-hartmann-procedure';
SET @from = (SELECT id FROM medical_services WHERE slug = 'hartmann-reconstruction');
SET @to = (SELECT id FROM medical_services WHERE slug = 'laparoscopic-hartmann-procedure');
UPDATE medical_service_tariffs SET medical_service_id = @to
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D02230' AND medical_service_id = @from AND @to IS NOT NULL;
-- строки больниц с этим кодом (Данило, ОБ Никшич; по коду, не по id клиники)
UPDATE clinic_medical_services SET medical_service_id = @to
 WHERE medical_service_id = @from AND REGEXP_SUBSTR(code, '[A-Z][0-9]{5}') = 'D02230' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_service_doctors SET medical_service_id = @to
 WHERE medical_service_id = @from AND @to IS NOT NULL
   AND clinic_id IN (SELECT clinic_id FROM clinic_medical_services WHERE medical_service_id = @to);

-- 3.2 D06122: scleral-buckle-with-vitrectomy → scleral-buckling-with-implant (новая запись)
-- D06122 «Skleralni bukling sa implantatom» (прайс Данило дословно) стоял на «серкляже с витрэктомией» — витрэктомии в позиции нет. Новая запись — как сосед D06123 other-scleral-buckling (категория 33, специальность 81). Офтальмологический центр Раонич остаётся на серкляже с витрэктомией
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Scleral Buckling with Implant', 'scleral-buckling-with-implant', 'Skleralni bukling sa implantatom', 'Склерални буклинг са имплантатом', 'Склеральное пломбирование с имплантатом', 'Skleraeindellung mit Implantat', 'İmplantlı skleral çökertme')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 33 FROM medical_services WHERE slug = 'scleral-buckling-with-implant';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 81 FROM medical_services WHERE slug = 'scleral-buckling-with-implant';
SET @from = (SELECT id FROM medical_services WHERE slug = 'scleral-buckle-with-vitrectomy');
SET @to = (SELECT id FROM medical_services WHERE slug = 'scleral-buckling-with-implant');
UPDATE medical_service_tariffs SET medical_service_id = @to
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'D06122' AND medical_service_id = @from AND @to IS NOT NULL;
-- строки больниц с этим кодом (Данило, ОБ Никшич; по коду, не по id клиники)
UPDATE clinic_medical_services SET medical_service_id = @to
 WHERE medical_service_id = @from AND REGEXP_SUBSTR(code, '[A-Z][0-9]{5}') = 'D06122' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_service_doctors SET medical_service_id = @to
 WHERE medical_service_id = @from AND @to IS NOT NULL
   AND clinic_id IN (SELECT clinic_id FROM clinic_medical_services WHERE medical_service_id = @to);

-- 3.4 X01033 / X01035: в FINAL.json имена и цены съехали на соседей (llm-substantive / llm-fallback; X01033 дублировал
-- X01032, X01035 — X01034). Построчный OCR (paddleocr base.items.json, стр. 35) и прайс Данило (= 3 × ambulanta):
--   X01033 «Postavljanje kanile i uključivanje infuzije» — ambulanta 2,78 (Данило 8,34), odjeljenje 1,30 (Данило/Никшич 3,25 = 2,5 × 1,30);
--   X01035 «Kateterizacija mokraćne bešike kod muškaraca sa ili bez ispiranja» — ambulanta 2,22 (KCCG 6,66), odjeljenje 1,04.
-- Привязка X01033 к iv-cannula-application верна (строки Данило/Никшич); X01035 был не привязан — ставим на
-- bladder-catheterization-in-males (там строка KCCG с этим кодом). FINAL и insert-tariff-fzocg-sekundarna.sql поправлены тем же коммитом.
UPDATE medical_service_tariffs SET name_sr_latin = 'Postavljanje kanile i uključivanje infuzije', price_odjeljenje_eur = 1.30, price_ambulanta_eur = 2.78
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01033';
UPDATE medical_service_tariffs SET name_sr_latin = 'Kateterizacija mokraćne bešike kod muškaraca sa ili bez ispiranja', price_odjeljenje_eur = 1.04, price_ambulanta_eur = 2.22
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01035';
SET @to = (SELECT id FROM medical_services WHERE slug = 'bladder-catheterization-in-males');
UPDATE medical_service_tariffs SET medical_service_id = @to
 WHERE tariff_source = 'fzocg-sekundarna' AND code = 'X01035' AND medical_service_id IS NULL AND lab_test_id IS NULL AND @to IS NOT NULL;

-- ═══ 4. PZZ, блок K: привязка к анализам ═══
-- Цель — запись, на которой стоят строки больниц с этим же кодом (Данило, KCCG, ОБ Никшич, ДЗ Ульцинь; большинство;
-- у ДЗ Херцег-Нови в K01031/K01040/K01047/K01051/K01054 строки на чужих записях — это ошибки импорта ХН, не цель).
-- K01068 и K02008 — на услуги, как уже привязанные соседи K01059/K01065/K01066 (CRP/ASO): там лежат строки больниц.
-- Коды K в PZZ и секундарном прайсе совпадают по смыслу — секундарный двойник (тоже не привязан) ставится туда же,
-- кроме K02008: его имя в секундарном FINAL съехало на K02007.
-- Только непривязанные строки: повторный прогон ничего не меняет.

DROP TEMPORARY TABLE IF EXISTS tmp_k_links;
CREATE TEMPORARY TABLE tmp_k_links (
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	lab_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	svc_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	sek TINYINT NOT NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_k_links (code, lab_slug, svc_slug, sek) VALUES
('K01004', 'microscopic-examination-of-swab-for-gonorrhea', NULL, 1),
('K01005', 'amine-test', NULL, 1),
('K01009', 'tongue-swab-bacteria', NULL, 1),
('K01010', 'nose-swab-bacteria', NULL, 1),
('K01025', 'vibrio-cholerae-culture', NULL, 1),
('K01028', 'antibiogram', NULL, 1),
('K01029', 'mycoplasma-hominis-ureaplasma', NULL, 1),
('K01030', 'dermatophytes-nail-scraping', NULL, 1),
('K01031', 'dermatophytes-skin-scraping', NULL, 1),
('K01032', 'dermatophytes-hair-scraping', NULL, 1),
('K01034', 'hair-swab-fungi', NULL, 1),
('K01035', 'nail-swab-fungi', NULL, 1),
('K01037', 'vulvar-swab-fungi', NULL, 1),
('K01038', 'glans-swab-fungi', NULL, 1),
('K01039', 'prepuce-swab-fungi', NULL, 1),
('K01040', 'urethral-swab-fungi', NULL, 1),
('K01042', 'urine-fungi', NULL, 1),
('K01043', 'nose-swab-fungi', NULL, 1),
('K01045', 'throat-swab-fungi', NULL, 1),
('K01046', 'palate-swab-fungi', NULL, 1),
('K01047', 'wound-swab-fungi', NULL, 1),
('K01050', 'trichomonas-test', NULL, 1),
('K01051', 'perianal-cellophane-tape-test-pinworm', NULL, 1),
('K01052', 'stool-parasites', NULL, 1),
('K01053', 'stool-microscopic-examination-for-protozoa', NULL, 1),
('K01054', 'native-microscopic-preparation-for-amebae-with-provocation', NULL, 1),
('K01055', 'cryptosporidium-in-stool-ziehl-neelsen', NULL, 1),
('K01056', 'malaria', NULL, 1),
('K01057', 'skin-ectoparasite-identification', NULL, 1),
('K01058', 'demodex-species', NULL, 1),
('K01060', 'vdrl', NULL, 1),
('K01062', 'monosticon', NULL, 1),
('K01063', 'tpha-treponema-pallidum', NULL, 1),
('K01064', 'direct-microscopic-preparation', NULL, 1),
('K01067', 'rheumatoid-factor', NULL, 1),
('K01068', NULL, 'rheumatoid-factor-turbidimetry', 1),
('K01069', 'waaler-rose-test', NULL, 1),
('K01070', 'tongue-swab-fungi', NULL, 1),
('K02001', 'antimicrobial-antibody-detection-by-elisa', NULL, 1),
('K02002', 'microbial-antigen-detection-by-elisa', NULL, 1),
('K02005', 'antimicrobial-antibody-detection-by-complement-fixation', NULL, 1),
('K02006', 'antimicrobial-antibody-detection-by-hemagglutination', NULL, 1),
('K02007', 'antimicrobial-antibody-detection-by-latex-agglutination', NULL, 1),
('K02008', NULL, 'microbial-antigen-latex-agglutination-test', 0),
('K02009', 'microbial-nucleic-acid-detection-by-hybridization', NULL, 1);

-- страховка: цели, которых нет в базе. Ожидается ПУСТО.
SELECT l.code, l.lab_slug, l.svc_slug FROM tmp_k_links l
 WHERE (l.lab_slug IS NOT NULL AND NOT EXISTS (SELECT 1 FROM lab_tests lt WHERE lt.slug = l.lab_slug))
    OR (l.svc_slug IS NOT NULL AND NOT EXISTS (SELECT 1 FROM medical_services ms WHERE ms.slug = l.svc_slug));

UPDATE medical_service_tariffs t
  JOIN tmp_k_links l ON l.code = t.code
  LEFT JOIN lab_tests lt ON lt.slug = l.lab_slug
  LEFT JOIN medical_services ms ON ms.slug = l.svc_slug
   SET t.lab_test_id = lt.id, t.medical_service_id = ms.id
 WHERE (t.tariff_source = 'fzocg-pzz' OR (t.tariff_source = 'fzocg-sekundarna' AND l.sek = 1))
   AND t.medical_service_id IS NULL AND t.lab_test_id IS NULL
   AND (lt.id IS NOT NULL OR ms.id IS NOT NULL);

-- ═══ 5. PZZ, стоматология (блок D): привязка к услугам ═══
-- Ни одна клиника коды PZZ D не использует, поэтому решает название: привязано только то, где запись каталога
-- называет ту же процедуру (детские и взрослые пломбы одной площади — на одну запись, как у KCCG D22/D23).
-- Единственная прежняя привязка D13023 → pulp-capping-direct-or-indirect верна. Не привязаны (нет записи или
-- запись уже/шире): D11001, D11002, D11004, D11006, D12001, D12002, D13003, D13009–D13011, D13021, D13022,
-- D13027–D13033 (экстирпация/гангрена с пломбировкой каналов — в каталоге разведено по числу корней),
-- D13036, D13047, D13051, D13053–D13056, D14010, D15001, D15004, D15006, D15007,
-- D17002–D17006 и D18001–D18012 (лабораторные этапы протезов и аппаратов).

DROP TEMPORARY TABLE IF EXISTS tmp_d_links;
CREATE TEMPORARY TABLE tmp_d_links (
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	svc_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_d_links (code, svc_slug) VALUES
('D11003', 'topical-fluoride-treatment'),
('D11005', 'dental-fissure-sealant'),
('D11007', 'soft-dental-deposit-removal'),
('D13001', 'initial-dental-examination-and-medical-record-opening'),
('D13002', 'dental-consultation'),
('D13004', 'therapeutic-tooth-grinding'),
('D13005', 'dental-x-ray-interpretation'),
('D13006', 'dental-x-ray-interpretation'),
('D13007', 'dental-x-ray-interpretation'),
('D13008', 'pulp-and-gingival-polyp-cauterization'),
('D13012', 'dental-filling-single-surface'),
('D13013', 'dental-filling-two-surfaces'),
('D13014', 'dental-filling-three-surfaces'),
('D13015', 'dental-filling-single-surface'),
('D13016', 'dental-filling-two-surfaces'),
('D13017', 'dental-filling-three-surfaces'),
('D13018', 'dental-filling-single-surface'),
('D13019', 'dental-filling-two-surfaces'),
('D13020', 'dental-filling-three-surfaces'),
('D13024', 'tooth-vitality-test'),
('D13025', 'mortal-pulpotomy'),
('D13026', 'mortal-pulp-extirpation'),
('D13034', 'root-canal-retreatment'),
('D13035', 'intraoral-abscess-incision'),
('D13037', 'dental-local-anesthesia'),
('D13038', 'dental-local-anesthesia'),
('D13039', 'primary-tooth-extraction'),
('D13040', 'primary-tooth-extraction'),
('D13041', 'tooth-extraction'),
('D13042', 'tooth-extraction'),
('D13043', 'tooth-extraction-complex'),
('D13044', 'tooth-extraction-and-oral-surgery-in-high-risk-patients'),
('D13045', 'tooth-replantation'),
('D13046', 'composite-splint'),
('D13048', 'periodontal-dressing-application'),
('D13049', 'alveolitis-treatment'),
('D13050', 'bleeding-control-dental'),
('D13052', 'temporary-filling-with-medication'),
('D14001', 'orthodontic-consultation'),
('D14002', 'study-model-fabrication-and-analysis'),
('D14003', 'cephalometric-analysis'),
('D14004', 'orthodontic-treatment-planning'),
('D14005', 'orthodontic-removable-plate-appliance'),
('D14006', 'functional-orthodontic-appliance-adjustment'),
('D14007', 'orthodontic-functional-monoblock-appliance'),
('D14008', 'chin-cap'),
('D14009', 'follow-up-orthodontist-examination'),
('D15002', 'cast-post-and-core'),
('D15003', 'cast-metal-crown'),
('D15005', 'veneered-metal-crown'),
('D15008', 'complete-acrylic-denture'),
('D15009', 'complete-denture-with-cast-metal-base'),
('D15010', 'partial-acrylic-denture'),
('D15011', 'partial-acrylic-denture'),
('D15012', 'skeletal-partial-denture'),
('D15013', 'denture-reocclusion-and-rearticulation'),
('D17001', 'study-model-fabrication'),
('D18013', 'custom-acrylic-impression-tray');

-- страховка: цели, которых нет в базе. Ожидается ПУСТО.
SELECT l.code, l.svc_slug FROM tmp_d_links l
 WHERE NOT EXISTS (SELECT 1 FROM medical_services ms WHERE ms.slug = l.svc_slug);

UPDATE medical_service_tariffs t
  JOIN tmp_d_links l ON l.code = t.code
  JOIN medical_services ms ON ms.slug = l.svc_slug
   SET t.medical_service_id = ms.id
 WHERE t.tariff_source = 'fzocg-pzz' AND t.medical_service_id IS NULL AND t.lab_test_id IS NULL;

-- ═══ 6. Справка cervical-drug-application: запись — «вагинально и цервикально», текст был только про шейку ═══
-- Тот же текст — в data/entity-reference/medical-services-w3-48.json и insert-entity-reference-info.sql.

UPDATE medical_service_reference_info r
JOIN medical_services ms ON ms.id = r.medical_service_id
SET
	r.what_en = 'Applying a medicine locally into the vagina or onto the cervix during a gynaecological appointment',
	r.what_sr = 'Lokalna primjena lijeka u vaginu ili na grlić materice tokom ginekološkog pregleda',
	r.what_sr_cyrl = 'Локална примјена лијека у вагину или на грлић материце током гинеколошког прегледа',
	r.what_ru = 'Местное введение лекарственного средства во влагалище или нанесение на шейку матки на приёме у гинеколога',
	r.what_de = 'Örtliche Anwendung eines Medikaments in der Scheide oder am Gebärmutterhals während der frauenärztlichen Untersuchung',
	r.what_tr = 'Jinekolojik muayene sırasında ilacın vajinaya veya rahim ağzına yerel olarak uygulanması',
	r.how_en = 'A speculum is inserted, the mucosa is dried with a swab if needed and the preparation is placed in the vagina or applied to the cervix with an applicator or a tampon, it takes a few minutes',
	r.how_sr = 'Ljekar postavi spekulume, po potrebi osuši sluznicu tupferom i unese preparat u vaginu ili ga nanese na grlić aplikatorom ili tamponom, postupak traje nekoliko minuta',
	r.how_sr_cyrl = 'Љекар постави спекулуме, по потреби осуши слузницу тупфером и унесе препарат у вагину или га нанесе на грлић апликатором или тампоном, поступак траје неколико минута',
	r.how_ru = 'Врач вводит зеркала, при необходимости осушает слизистую тампоном и вводит препарат во влагалище или наносит его на шейку матки аппликатором или тампоном, процедура занимает несколько минут',
	r.how_de = 'Ein Spekulum wird eingesetzt, die Schleimhaut bei Bedarf mit einem Tupfer getrocknet und das Präparat mit Applikator oder Tupfer in die Scheide eingebracht oder auf den Muttermund aufgetragen, das dauert wenige Minuten',
	r.how_tr = 'Spekulum yerleştirilir, gerekirse mukoza tamponla kurulanır ve preparat aplikatör ya da tamponla vajinaya yerleştirilir veya rahim ağzına sürülür, işlem birkaç dakika sürer',
	r.indications_en = 'Inflammatory changes of the vagina and cervix, treatment after diagnostic procedures, a course of local therapy prescribed by the doctor',
	r.indications_sr = 'Upalne promjene vagine i grlića materice, obrada poslije dijagnostičkih zahvata, kura lokalne terapije koju je odredio ljekar',
	r.indications_sr_cyrl = 'Упалне промјене вагине и грлића материце, обрада послије дијагностичких захвата, кура локалне терапије коју је одредио љекар',
	r.indications_ru = 'Воспалительные изменения влагалища и шейки матки, обработка после диагностических вмешательств, назначенный врачом курс местной терапии',
	r.indications_de = 'Entzündliche Veränderungen von Scheide und Gebärmutterhals, Behandlung nach diagnostischen Eingriffen, eine ärztlich verordnete örtliche Behandlungsserie',
	r.indications_tr = 'Vajina ve rahim ağzındaki iltihabi değişiklikler, tanısal işlemler sonrası bakım, hekimin belirlediği yerel tedavi kürü',
	r.prep_en = 'Come outside the days of your period and avoid vaginal products and douching the day before unless the doctor said otherwise',
	r.prep_sr = 'Doći van dana menstruacije, a dan ranije ne koristiti vaginalne preparate i ispiranje, osim ako ljekar nije rekao drugačije',
	r.prep_sr_cyrl = 'Доћи ван дана менструације, а дан раније не користити вагиналне препарате и испирање, осим ако љекар није рекао другачије',
	r.prep_ru = 'Приходить вне дней менструации, накануне не использовать вагинальные средства и спринцевание, если врач не указал иначе',
	r.prep_de = 'Außerhalb der Regelblutung kommen und am Vortag keine Vaginalpräparate und keine Spülungen verwenden, sofern nicht anders besprochen',
	r.prep_tr = 'Adet günleri dışında gelmek ve hekim aksini söylemediyse bir gün önce vajinal preparat ve duş kullanmamak gerekir',
	r.abnormal_en = 'Light discharge and mild burning for a few days after the application are expected. How many times the procedure is repeated is decided by the doctor, and increasing pain, bleeding or fever call for a review',
	r.abnormal_sr = 'Oskudan iscjedak i blago pečenje nekoliko dana poslije postupka su očekivani. Koliko puta se postupak ponavlja određuje ljekar, a pojačan bol, krvarenje ili temperatura traže pregled',
	r.abnormal_sr_cyrl = 'Оскудан исцједак и благо печење неколико дана послије поступка су очекивани. Колико пута се поступак понавља одређује љекар, а појачан бол, крварење или температура траже преглед',
	r.abnormal_ru = 'Скудные выделения и лёгкое жжение в течение нескольких дней после процедуры ожидаемы. Сколько раз повторять процедуру, определяет врач, а усиление боли, кровотечение или температура требуют осмотра',
	r.abnormal_de = 'Leichter Ausfluss und ein mildes Brennen für einige Tage sind zu erwarten. Wie oft die Anwendung wiederholt wird, legt die Ärztin oder der Arzt fest, und zunehmende Schmerzen, Blutung oder Fieber gehören untersucht',
	r.abnormal_tr = 'Uygulamadan sonra birkaç gün hafif akıntı ve hafif yanma beklenen durumdur. İşlemin kaç kez tekrarlanacağına hekim karar verir, artan ağrı, kanama veya ateş muayene gerektirir'
WHERE ms.slug = 'cervical-drug-application';

-- ═══ 7. ПОСЛЕ ═══

SELECT 'after' AS state, ms.slug,
	(SELECT COUNT(*) FROM clinic_medical_services c WHERE c.medical_service_id = ms.id) AS clinics,
	(SELECT GROUP_CONCAT(CONCAT(t.tariff_source, ':', t.code) ORDER BY t.code) FROM medical_service_tariffs t WHERE t.medical_service_id = ms.id) AS tariffs,
	(SELECT COUNT(*) FROM reviews r WHERE r.medical_service_id = ms.id) AS reviews,
	(SELECT COUNT(*) FROM medical_service_synonyms y WHERE y.medical_service_id = ms.id) AS synonyms,
	(SELECT COUNT(*) FROM medical_service_reference_info i WHERE i.medical_service_id = ms.id) AS reference_card
FROM medical_services ms
WHERE ms.slug IN ('mechanical-contraceptive-device-check', 'contraceptive-device-check', 'social-worker-interview-social-history', 'social-survey-interview', 'primary-wound-care-without-sutures', 'wound-care-without-suturing', 'subcutaneous-or-intramuscular-injection', 'local-drug-application-subcutaneous-and-intramuscular', 'swab-collection-for-laboratory-analysis', 'routine-swab-sample-collection', 'reproductive-age-women-preventive-examination-with-pap-test', 'gynecological-preventive-visit', 'legal-responsibility-assessment', 'expert-organized-assessment', 'social-worker-expert-assessment', 'social-worker-counseling-and-intervention', 'individual-supportive-therapy', 'individual-preventive-therapy', 'wechsler-bellevue-test-for-special-needs-children-over-14', 'wechsler-bellevue-test-variant-for-special-needs-over-14', 'total-laparoscopic-abdominal-hysterectomy', 'radical-hysterectomy-wertheim-meigs', 'hartmann-reconstruction', 'laparoscopic-hartmann-procedure', 'scleral-buckle-with-vitrectomy', 'scleral-buckling-with-implant', 'bladder-catheterization-in-males', 'iv-cannula-application')
ORDER BY ms.slug;

SELECT 'after' AS state, t.tariff_source, t.code, t.price_odjeljenje_eur, t.price_ambulanta_eur, t.name_sr_latin, ms.slug
FROM medical_service_tariffs t LEFT JOIN medical_services ms ON ms.id = t.medical_service_id
WHERE t.tariff_source = 'fzocg-sekundarna' AND t.code IN ('D01061', 'D02230', 'D06122', 'X01032', 'X01033', 'X01034', 'X01035')
ORDER BY t.code;

SELECT 'after' AS state, t.tariff_source, LEFT(t.code, 1) AS block,
	COUNT(*) AS total, SUM(t.medical_service_id IS NOT NULL) AS on_services, SUM(t.lab_test_id IS NOT NULL) AS on_lab_tests,
	SUM(t.medical_service_id IS NULL AND t.lab_test_id IS NULL) AS unlinked
FROM medical_service_tariffs t
WHERE (t.tariff_source = 'fzocg-pzz' AND (t.code LIKE 'K%' OR t.code LIKE 'D%'))
   OR (t.tariff_source = 'fzocg-sekundarna' AND (t.code LIKE 'K01%' OR t.code LIKE 'K02%'))
GROUP BY t.tariff_source, LEFT(t.code, 1) ORDER BY t.tariff_source, block;

-- редиректы: 10 последних числовых и 10 слаговых, у каждого цель — живая запись
SELECT r.old_id, r.new_id, ms.slug AS target FROM medical_service_redirects r
  LEFT JOIN medical_services ms ON ms.id = r.new_id ORDER BY r.id DESC LIMIT 10;
SELECT sr.old_slug, sr.entity_id, ms.slug AS target FROM slug_redirects sr
  LEFT JOIN medical_services ms ON ms.id = sr.entity_id
 WHERE sr.entity_type = 'services' AND sr.old_slug IN ('contraceptive-device-check', 'social-survey-interview', 'wound-care-without-suturing', 'local-drug-application-subcutaneous-and-intramuscular', 'routine-swab-sample-collection', 'gynecological-preventive-visit', 'expert-organized-assessment', 'social-worker-counseling-and-intervention', 'individual-preventive-therapy', 'wechsler-bellevue-test-variant-for-special-needs-over-14');

SELECT 'after' AS state, (SELECT COUNT(*) FROM medical_services) AS medical_services_total,
	(SELECT COUNT(*) FROM clinic_medical_services) AS clinic_medical_services_total,
	(SELECT COUNT(*) FROM medical_service_redirects) AS redirects_total;

DROP TEMPORARY TABLE IF EXISTS tmp_sec_cms;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_rel;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_doc;
DROP TEMPORARY TABLE IF EXISTS tmp_sec_names;
DROP TEMPORARY TABLE IF EXISTS tmp_k_links;
DROP TEMPORARY TABLE IF EXISTS tmp_d_links;

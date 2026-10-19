-- ═══════════════════════════════════════════════════════════════════════════
-- Dental Montenegro (Bečići, Budva) — перечень услуг
-- Run ПОСЛЕ server/sql/insert-clinic-dental-montenegro-budva.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-montenegro-budva-services.sql
--
-- Источник: https://www.dentalmontenegro.com/, curl 2026-10-08. Прайса нет; цена есть у 1 позиции (0 € — «besplatni»), остальные NULL.
-- Заведены только процедуры, прямо названные на сайте; направления и оборудование — в excluded записи импорта.
-- Сайт не делит услуги по ординациям сети — список одинаковый для всех филиалов.
--
-- Итого: 9 услуг (1 с ценой), новых записей каталога — 1 (bitewing-x-ray). Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJLcP15BbUTRMRC61qGgrhtCw' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dental-montenegro-budva' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dental-montenegro-budva.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- dentalmontenegro.com /me/usluge/x-ray-ortopan: «Zagrizni (bite wing) snimak — Zagrizni snimak koristi se za
-- dijagnostiku karijesa u prostorima između dva zuba». Отдельная проекция, в каталоге нет ни под одним названием
-- (bitewing / zagrizni / interproximal). Категории и специальности — как у intraoral-x-ray (3 XRAY + 20
-- DENTISTRY; 10 + 78).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'bitewing-x-ray', 'Bitewing X-Ray', 'Zagrizni (bitewing) snimak', 'Загризни (bitewing) снимак',
	'Прикусной рентгеновский снимок (bitewing)', 'Bissflügelaufnahme (Bitewing)', 'Isırma (bitewing) röntgeni', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'bitewing-x-ray' OR name_en = 'Bitewing X-Ray');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 3 FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 10 FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bite-wing X-ray', 'en' FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Interproximal X-ray', 'en' FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bitewing snimak', 'sr' FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Битвинг снимак', 'sr-cyrl' FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Интерпроксимальный снимок', 'ru' FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Прикусной снимок', 'ru' FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bitewing-Röntgen', 'de' FROM medical_services WHERE slug = 'bitewing-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bitewing röntgen', 'tr' FROM medical_services WHERE slug = 'bitewing-x-ray';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (9)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_q_dm_services;
CREATE TEMPORARY TABLE tmp_q_dm_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_q_dm_services (slug, price, price_min, price_max) VALUES
	('dental-consultation-with-treatment-plan', 0.00, NULL, NULL), -- /me/o-nama: «Pregled sa predračunom, konsultacije i savet su besplatni!», /me/dental-turizam: «Besplatne konsultacije … okviran plan terapije, trajanje kao i iznos predračuna»
	('dental-implant-nobel-biocare', NULL, NULL, NULL), -- /me/usluge/implantologija: «Koriste se isključivo implantati Nobel Biocare»
	('immediate-implant-placement', NULL, NULL, NULL), -- «U toku implantološke intervencije koriste se sve najnovije savremene metode: imedijatna ugradnja»
	('implant-suprastructure', NULL, NULL, NULL), -- «ukoliko nedostaje više zuba implantati služe kao nosač mosta», «bezubost: … ugrađuje se minimum 6-8 implantata u jednu vilicu a zatim se izrađuje cirkularni most»
	('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL), -- /me/usluge/ortopedija: «koristimo najkvalitetnije sisteme bravica na tržištu … fiksnih proteza» — материал/система не названы
	('ceramic-veneer', NULL, NULL, NULL), -- /me/usluge/estetska-stomatologija: «Fasete su tanke ljuspice od keramike koje se fiksiraju na prednju površinu zuba»
	('panoramic-x-ray', NULL, NULL, NULL), -- /me/usluge/x-ray-ortopan: «Za snimak ortopana …», «digitalni ortopan poslednje generacije RayScan by Samsung»
	('intraoral-x-ray', NULL, NULL, NULL), -- «Retroalveolarni snimak daje nam uvid u stanje 1-3 zuba», «digitalni intraoralni rendgen "Cefla"»
	('bitewing-x-ray', NULL, NULL, NULL); -- «Zagrizni (bite wing) snimak — … za dijagnostiku karijesa u prostorima između dva zuba» (НОВАЯ запись каталога)

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_q_dm_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_q_dm_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_q_dm_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Сайт не называет врачей у услуг — привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 9, with_price = 1.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Новые записи каталога: категории, специальности, синонимы.
SELECT ms.id, ms.slug, ms.name_sr,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specs,
	(SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
FROM medical_services ms WHERE ms.slug IN ('bitewing-x-ray');

DROP TEMPORARY TABLE IF EXISTS tmp_q_dm_services;

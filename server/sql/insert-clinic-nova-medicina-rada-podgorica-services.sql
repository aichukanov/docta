-- ═══════════════════════════════════════════════════════════════════════════
-- Nova Medicina Rada — Podgorica — услуги и анализы
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-nova-medicina-rada-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-nova-medicina-rada-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/nova-medicina-rada-podgorica.json.
-- 
-- Услуг: 18, анализов: 1, с ценой: 0 (цен на сайте нет). Перечень одинаков для обоих филиалов (блок «Usluge Medicine Rada u …»).
-- Новых записей каталога нет. Синонимы к occupational-medicine-specialist-examination.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги/анализы прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ0yT2MFfrTRMRH4vGudufERY' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'nova-medicina-rada-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-nova-medicina-rada-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Procjena radne sposobnosti', 'sr' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'Процјена радне способности', 'sr-cyrl' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'Periodični pregled zaposlenih', 'sr' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'Периодични преглед запослених', 'sr-cyrl' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'Work Ability Assessment', 'en' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'Periodic Occupational Health Examination', 'en' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'Периодический медосмотр', 'ru' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'Arbeitsmedizinische Untersuchung', 'de' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination'
UNION ALL SELECT id, 'İşyeri hekimi muayenesi', 'tr' FROM medical_services WHERE slug = 'occupational-medicine-specialist-examination';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_nova_medicina_rada_podgorica;
CREATE TEMPORARY TABLE tmp_nova_medicina_rada_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_nova_medicina_rada_podgorica (slug, price, price_min, price_max) VALUES
('pre-employment-medical-certificate', NULL, NULL, NULL), -- «Pregledi za zaposlenje i sistematski pregledi — Inicijalni, periodični i kontrolni pregledi», /…/sistematski-pregledi-za-zaposlenje: «sistematske preglede za zaposlenje u skladu sa zakonskim propisima Crne Gore» — инициальный (при приёме на работу)
('occupational-medicine-specialist-examination', NULL, NULL, NULL), -- «… periodični … pregledi», «Procjena radne sposobnosti» (синоним добавлен), «Sistematski pregled obuhvata opšti ljekarski pregled, laboratorijske analize, EKG, spirometriju i psihološku procjenu …»
('follow-up-occupational-medicine-specialist-examination', NULL, NULL, NULL), -- «… i kontrolni pregledi»
('medical-certificate-for-high-risk-and-difficult-working-conditions', NULL, NULL, NULL), -- «Ljekarsko uvjerenje za posebne pozicije» — справка для работы на особых (повышенный риск) рабочих местах
('psychological-counseling', NULL, NULL, NULL), -- «Psihološko savjetovanje — Individualno savjetovanje i podrška, Procjena stresa i anksioznosti, Krizno savjetovanje», «Naši psiholozi …» (психологи — не врачи, врачами не заводятся)
('first-psychiatrist-examination', NULL, NULL, NULL), -- «Psihijatrijski pregledi — Procjena mentalnog zdravlja … Pregledi u okviru radne procjene», «Standardni psihijatrijski pregled traje 30-45 minuta»
('follow-up-psychiatrist-examination', NULL, NULL, NULL), -- «Terapeutska podrška i praćenje», «Kontinuirana podrška i praćenje stanja pacijenata nakon pregleda»
('medical-certificate-for-driving-license-category-a-b-c-d-e', NULL, NULL, NULL), -- «Pregledi za vozače — Ljekarski pregledi za sve kategorije»
('medical-certificate-for-driving-license-renewal-category-a-b-c-d-e', NULL, NULL, NULL), -- «Obnavljanje ljekarskih uvjerenja»
('medical-certificate-for-professional-drivers', NULL, NULL, NULL), -- «ovlašćena za izdavanje ljekarskih uvjerenja za sve kategorije vozačkih dozvola, uključujući profesionalne vozače i vozače teretnih vozila»
('ecg', NULL, NULL, NULL), -- «Laboratorijska dijagnostika — … EKG i mjerenje krvnog pritiska …»
('blood-pressure-and-bmi-measurement', NULL, NULL, NULL), -- «… i mjerenje krvnog pritiska» — единственная запись измерения давления в каталоге (с ИМТ)
('spirometry', NULL, NULL, NULL), -- «Spirometrija»
('abdomen-ultrasound', NULL, NULL, NULL), -- «Ultrazvučni (UZ) pregledi — Abdominalni, štitne žlijezde, dojki»
('thyroid-ultrasound', NULL, NULL, NULL), -- «… štitne žlijezde …»
('breast-ultrasound', NULL, NULL, NULL), -- «… dojki»
('soft-tissue-ultrasound', NULL, NULL, NULL), -- «Mekih tkiva i limfnih čvorova»
('ultrasound-lymph-nodes', NULL, NULL, NULL); -- «… i limfnih čvorova»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_nova_medicina_rada_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_nova_medicina_rada_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_nova_medicina_rada_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 1b: АНАЛИЗЫ КЛИНИКИ (clinic_lab_tests, цены NULL): 1
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_nova_medicina_rada_podgorica_lab;
CREATE TEMPORARY TABLE tmp_nova_medicina_rada_podgorica_lab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_nova_medicina_rada_podgorica_lab (slug, price) VALUES
('complete-blood-count', NULL); -- «Osnovne laboratorijske analize», «Krvna slika, biohemija, EKG, spirometrija i mnoge druge analize» — конкретно названа только «krvna slika»

-- Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_test
FROM tmp_nova_medicina_rada_podgorica_lab t
LEFT JOIN lab_tests l ON l.slug = t.slug
WHERE l.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, l.id, t.price, NULL, NULL
FROM lab_tests l
JOIN tmp_nova_medicina_rada_podgorica_lab t ON t.slug = l.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_max = NULL;

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
LEFT JOIN tmp_nova_medicina_rada_podgorica_lab t ON t.slug = l.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 18 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 1 анализов, с ценой 0.
SELECT COUNT(*) AS lab_tests_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

SELECT l.slug, l.name_en, clt.price
FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
WHERE clt.clinic_id = @clinic_id
ORDER BY l.name_en;

DROP TEMPORARY TABLE IF EXISTS tmp_nova_medicina_rada_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_nova_medicina_rada_podgorica_lab;

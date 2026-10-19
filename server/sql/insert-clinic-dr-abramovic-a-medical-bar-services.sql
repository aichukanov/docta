-- ═══════════════════════════════════════════════════════════════════════════
-- Dr Abramović — A Medical (Bar) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dr-abramovic-a-medical-bar-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-dr-abramovic-a-medical-bar.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/dr-abramovic-a-medical-bar.json.
-- 
-- Услуг: 18, анализов: 0, с ценой: 0 (цен на сайте нет). Источник — /usluge/ (3 группы, 11 пунктов).
-- Новая запись каталога: bone-x-ray — идемпотентно по slug.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ87q7SAB0ThMRIed9XD0ALgs' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dr-abramovic-a-medical-bar' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dr-abramovic-a-medical-bar.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Dr Abramović: «Rtg snimanje: … kostiju tijela, kičme i glave». Кичма и голова заведены существующими записями; общего «рентген костей» в каталоге нет — только 60+ частных проекций (запястье, лодыжка, грудина …) и extremity-x-ray-per-image (только конечности, тариф «за снимак»). Общая услуга кабинетов рентгена. 3 XRAY, 10 RADIOLOGY.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'bone-x-ray', 'Bone X-Ray', 'Rendgen kostiju', 'Рендген костију',
	'Рентген костей', 'Röntgen der Knochen', 'Kemik röntgeni', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'bone-x-ray' OR name_en = 'Bone X-Ray');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 3 FROM medical_services WHERE slug IN ('bone-x-ray');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug IN ('bone-x-ray');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'RTG kostiju', 'sr' FROM medical_services WHERE slug = 'bone-x-ray'
UNION ALL SELECT id, 'РТГ костију', 'sr-cyrl' FROM medical_services WHERE slug = 'bone-x-ray'
UNION ALL SELECT id, 'Rendgen kostiju tijela', 'sr' FROM medical_services WHERE slug = 'bone-x-ray'
UNION ALL SELECT id, 'Skeletal X-Ray', 'en' FROM medical_services WHERE slug = 'bone-x-ray'
UNION ALL SELECT id, 'Рентген скелета', 'ru' FROM medical_services WHERE slug = 'bone-x-ray'
UNION ALL SELECT id, 'Knochenröntgen', 'de' FROM medical_services WHERE slug = 'bone-x-ray'
UNION ALL SELECT id, 'Kemik grafisi', 'tr' FROM medical_services WHERE slug = 'bone-x-ray'
UNION ALL SELECT id, 'Pasaža jednjaka i gastroduodenuma', 'sr' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy'
UNION ALL SELECT id, 'Пасажа једњака и гастродуоденума', 'sr-cyrl' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy'
UNION ALL SELECT id, 'Barium Swallow', 'en' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy'
UNION ALL SELECT id, 'Рентген пищевода и желудка с барием', 'ru' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy'
UNION ALL SELECT id, 'Breischluck', 'de' FROM medical_services WHERE slug = 'esophagus-stomach-and-duodenum-fluoroscopy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_dr_abramovic_a_medical_bar;
CREATE TEMPORARY TABLE tmp_dr_abramovic_a_medical_bar (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dr_abramovic_a_medical_bar (slug, price, price_min, price_max) VALUES
('x-ray-chest-heart', NULL, NULL, NULL), -- «Digitalni Rentgen — Rtg snimanje: grudnog koša pluća i srca»
('bone-x-ray', NULL, NULL, NULL), -- «Rtg snimanje: kostiju tijela, kičme i glave» — кости тела (НОВАЯ общая запись)
('x-ray-cervical-spine', NULL, NULL, NULL), -- «… kičme …» — отделы не названы → три стандартные записи отделов
('x-ray-thoracic-spine', NULL, NULL, NULL), -- «… kičme …»
('x-ray-lumbar-spine-and-sacrum', NULL, NULL, NULL), -- «… kičme …»
('x-ray-head-craniogram', NULL, NULL, NULL), -- «… i glave»
('x-ray-paranasal-sinuses', NULL, NULL, NULL), -- «Rtg snimanje: sinusa»
('esophagus-stomach-and-duodenum-fluoroscopy', NULL, NULL, NULL), -- «Rtg snimanje: pasaža jednjaka i gastroduodenuma» (синоним «Pasaža jednjaka i gastroduodenuma» добавлен)
('abdomen-ultrasound', NULL, NULL, NULL), -- «4D Ultrazvuk — Pregledi trbušnog … prostora, jetre, žucne kese, pankreasa, bubrega …»
('ultrasound-bladder-with-prostate', NULL, NULL, NULL), -- «… bešike i prostate»
('lung-ultrasound', NULL, NULL, NULL), -- «Pregledi … grudnog prostora …» — общая запись УЗИ лёгких/грудной полости
('4d-pregnancy-ultrasound', NULL, NULL, NULL), -- «4D pregledi trudnoće, materice i jajnika»
('gynecological-ultrasound', NULL, NULL, NULL), -- «4D pregledi … materice i jajnika»
('blood-vessels-doppler', NULL, NULL, NULL), -- «Collor doppler krvnih sudova» — сосуды не названы → общая запись
('breast-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk dojke i štitne žlijezde»
('thyroid-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk dojke i štitne žlijezde»
('pediatric-hip-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk dječjih kukova»
('first-radiologist-examination', NULL, NULL, NULL); -- «Spec.pregledi — Konsultacije uz pregled sa analizom laboratorijskih i drugih nalaza, Savjetovanje u vezi drugih pregleda i terapija», врач — радиолог

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_dr_abramovic_a_medical_bar t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_dr_abramovic_a_medical_bar t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dr_abramovic_a_medical_bar t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 18
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_dr_abramovic_a_medical_bar_ds;
CREATE TEMPORARY TABLE tmp_dr_abramovic_a_medical_bar_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dr_abramovic_a_medical_bar_ds (doctor_slug, service_slug) VALUES
('zarko-abramovic', 'x-ray-chest-heart'), -- единственный врач (радиолог)
('zarko-abramovic', 'bone-x-ray'), -- единственный врач (радиолог)
('zarko-abramovic', 'x-ray-cervical-spine'), -- единственный врач (радиолог)
('zarko-abramovic', 'x-ray-thoracic-spine'), -- единственный врач (радиолог)
('zarko-abramovic', 'x-ray-lumbar-spine-and-sacrum'), -- единственный врач (радиолог)
('zarko-abramovic', 'x-ray-head-craniogram'), -- единственный врач (радиолог)
('zarko-abramovic', 'x-ray-paranasal-sinuses'), -- единственный врач (радиолог)
('zarko-abramovic', 'esophagus-stomach-and-duodenum-fluoroscopy'), -- единственный врач (радиолог)
('zarko-abramovic', 'abdomen-ultrasound'), -- единственный врач (радиолог)
('zarko-abramovic', 'ultrasound-bladder-with-prostate'), -- единственный врач (радиолог)
('zarko-abramovic', 'lung-ultrasound'), -- единственный врач (радиолог)
('zarko-abramovic', '4d-pregnancy-ultrasound'), -- единственный врач (радиолог)
('zarko-abramovic', 'gynecological-ultrasound'), -- единственный врач (радиолог)
('zarko-abramovic', 'blood-vessels-doppler'), -- единственный врач (радиолог)
('zarko-abramovic', 'breast-ultrasound'), -- единственный врач (радиолог)
('zarko-abramovic', 'thyroid-ultrasound'), -- единственный врач (радиолог)
('zarko-abramovic', 'pediatric-hip-ultrasound'), -- единственный врач (радиолог)
('zarko-abramovic', 'first-radiologist-examination'); -- единственный врач (радиолог)

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_dr_abramovic_a_medical_bar_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_dr_abramovic_a_medical_bar_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

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

-- Ожидается 18 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 1: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('bone-x-ray');

DROP TEMPORARY TABLE IF EXISTS tmp_dr_abramovic_a_medical_bar;
DROP TEMPORARY TABLE IF EXISTS tmp_dr_abramovic_a_medical_bar_ds;

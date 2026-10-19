-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija za ultrazvučnu dijagnostiku dr Rahović (Bijelo Polje) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-dr-rahovic-bijelo-polje-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ordinacija-dr-rahovic-bijelo-polje.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/ordinacija-dr-rahovic-bijelo-polje.json.
-- 
-- Услуг: 14, анализов: 0, с ценой: 0 (цен на сайте нет). Источник — блок «Vršimo sledeće preglede» (14 пунктов).
-- Новая запись каталога: kidney-ultrasound — идемпотентно по slug. Врачей нет → привязок врач↔услуга нет.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJf5_pUe2jUhMRCQ-FegySUig' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ordinacija-dr-rahovic-bijelo-polje' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ordinacija-dr-rahovic-bijelo-polje.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Dr Rahović: «Eho bubrega» — отдельной строкой рядом с «Eho urotrakta». УЗИ только почек в каталоге нет (есть комбинации abdomen-and-kidney / hip-and-kidney / kidney-with-doppler и urinary-tract-ultrasound — «bubrezi i mokraćna bešika», которая у этой клиники уже стоит отдельно). Схема — как у urinary-tract-ultrasound: 4 ULTRASOUND, 10 RADIOLOGY.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'kidney-ultrasound', 'Kidney Ultrasound', 'Ultrazvuk bubrega', 'Ултразвук бубрега',
	'УЗИ почек', 'Nierenultraschall', 'Böbrek ultrasonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'kidney-ultrasound' OR name_en = 'Kidney Ultrasound');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('kidney-ultrasound');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug IN ('kidney-ultrasound');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Eho bubrega', 'sr' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Ехо бубрега', 'sr-cyrl' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'UZ bubrega', 'sr' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'УЗ бубрега', 'sr-cyrl' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Renal Ultrasound', 'en' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Ультразвук почек', 'ru' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Nierensonographie', 'de' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Böbrek USG', 'tr' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Kolor dopler splenoportalnog sistema', 'sr' FROM medical_services WHERE slug = 'doppler-portal-vein'
UNION ALL SELECT id, 'Колор доплер спленопорталног система', 'sr-cyrl' FROM medical_services WHERE slug = 'doppler-portal-vein'
UNION ALL SELECT id, 'Splenoportal Doppler', 'en' FROM medical_services WHERE slug = 'doppler-portal-vein'
UNION ALL SELECT id, 'Допплерография спленопортальной системы', 'ru' FROM medical_services WHERE slug = 'doppler-portal-vein';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_dr_rahovic_bijelo_polje;
CREATE TEMPORARY TABLE tmp_ordinacija_dr_rahovic_bijelo_polje (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ordinacija_dr_rahovic_bijelo_polje (slug, price, price_min, price_max) VALUES
('abdomen-ultrasound', NULL, NULL, NULL), -- «Eho pregled abdomena»
('urinary-tract-ultrasound', NULL, NULL, NULL), -- «Eho urotrakta»
('kidney-ultrasound', NULL, NULL, NULL), -- «Eho bubrega» — отдельной строкой рядом с «Eho urotrakta» (НОВАЯ)
('testicular-ultrasound', NULL, NULL, NULL), -- «Eho testisa»
('ultrasound-neck-glands-and-soft-tissue', NULL, NULL, NULL), -- «Eho mekih tkiva vrata» (у записи синоним «Ultrazvuk mekih tkiva vrata»)
('breast-ultrasound', NULL, NULL, NULL), -- «Eho dojki»
('pediatric-hip-ultrasound', NULL, NULL, NULL), -- «Eho kukova kod djece»
('ultrasound-bladder-with-prostate', NULL, NULL, NULL), -- «Eho mokraćne bešike i prostate»
('soft-tissue-ultrasound', NULL, NULL, NULL), -- «Eho mekih tkiva»
('doppler-neck-blood-vessels', NULL, NULL, NULL), -- «Kolor dopler KS vrata»
('doppler-lower-extremity-blood-vessels', NULL, NULL, NULL), -- «Kolor dopler KS donnih [donjih] ekstremiteta»
('doppler-upper-extremity-blood-vessels', NULL, NULL, NULL), -- «Kolor dopler KS gornjih ekstremiteta»
('doppler-renal-arteries', NULL, NULL, NULL), -- «Kolor dopler renalnih arterija»
('doppler-portal-vein', NULL, NULL, NULL); -- «Kolor dopler splenoportalnog sistema» — запись «Kolor dopler vene porte» (синоним добавлен)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_ordinacija_dr_rahovic_bijelo_polje t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_ordinacija_dr_rahovic_bijelo_polje t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_ordinacija_dr_rahovic_bijelo_polje t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 14 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 1: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('kidney-ultrasound');

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_dr_rahovic_bijelo_polje;

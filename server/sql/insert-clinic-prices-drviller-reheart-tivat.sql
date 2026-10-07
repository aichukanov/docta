SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- DrViller Reheart (Tivat) — pricelist, new import
-- Source: https://doctor-viller.com/servises (Tilda, Russian; table t431, div.t431__data-part2
--         "Услуга;Стоимость, EUR")
-- Snapshot: data/clinic-pricelists/sources/drviller-reheart-tivat/2026-10-02.html
-- Price date: not stated on the page. HTTP Last-Modified: Tue, 08 Sep 2026 20:11:35 GMT
--   (Tilda republish date of the page) → fresh, is_price_outdated = 0
-- Collected: 2026-10-02
--
-- Source rows: 13, all medical services (no lab tests)
--   imported:            12
--     matched to catalog: 6 (Professor Cardiologist Examination, Professor Cardiology Package,
--                            Specialist Examination, ECG, Infusion Therapy, Intramuscular Injection)
--     new catalog records: 6 (see PART 1)
--   not imported:         1 — "Мониторинг ЭКГ в амбулатории;20" (unclear what it is; owner decision)
-- "от N" → price_min. No clinic codes in the source.
-- Record: data/clinic-imports/drviller-reheart-tivat.json
-- Idempotent: ON DUPLICATE KEY on medical_services.name_en, INSERT IGNORE everywhere else.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'drviller-reheart-tivat');

SET @cat_cardiology = 8;
SET @cat_general_medicine = 9;
SET @cat_injections_infusions = 29;
SET @spec_cardiology = 1;
SET @spec_general_medicine = 45;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: NEW CATALOG RECORDS
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order) VALUES
('Professor Cardiologist Examination with ECG', 'professor-cardiologist-examination-with-ecg',
	'Profesorski pregled kardiologa sa EKG-om', 'Професорски преглед кардиолога са ЕКГ-ом',
	'Профессорский осмотр кардиолога с ЭКГ', 'Kardiologische Untersuchung durch einen Professor mit EKG',
	'EKG ile Profesör Kardiyoloji Muayenesi', 1),
('Intravenous Ozone Therapy', 'intravenous-ozone-therapy',
	'Intravenska ozonoterapija', 'Интравенска озонотерапија',
	'Внутривенная озонотерапия', 'Intravenöse Ozontherapie',
	'İntravenöz Ozon Tedavisi', NULL),
('Local Ozone Therapy', 'local-ozone-therapy',
	'Lokalna ozonoterapija', 'Локална озонотерапија',
	'Местная озонотерапия', 'Lokale Ozontherapie',
	'Lokal Ozon Tedavisi', NULL),
('Autohemotherapy', 'autohemotherapy',
	'Autohemoterapija', 'Аутохемотерапија',
	'Аутогемотерапия', 'Eigenbluttherapie',
	'Otohemoterapi', NULL),
('Ozone Autohemotherapy', 'ozone-autohemotherapy',
	'Ozonska autohemoterapija', 'Озонска аутохемотерапија',
	'Аутогемотерапия с озоном', 'Ozon-Eigenbluttherapie',
	'Ozonlu Otohemoterapi', NULL),
('Medical Documentation Review', 'medical-documentation-review',
	'Pregled medicinske dokumentacije', 'Преглед медицинске документације',
	'Анализ медицинской документации', 'Durchsicht medizinischer Unterlagen',
	'Tıbbi Belge İncelemesi', NULL)
ON DUPLICATE KEY UPDATE name_en = name_en;

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_cardiology FROM medical_services WHERE slug = 'professor-cardiologist-examination-with-ecg'
UNION ALL SELECT id, @cat_general_medicine FROM medical_services WHERE slug = 'medical-documentation-review'
UNION ALL SELECT id, @cat_injections_infusions FROM medical_services WHERE slug IN (
	'intravenous-ozone-therapy',
	'local-ozone-therapy',
	'autohemotherapy',
	'ozone-autohemotherapy'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_cardiology FROM medical_services WHERE slug = 'professor-cardiologist-examination-with-ecg'
UNION ALL SELECT id, @spec_general_medicine FROM medical_services WHERE slug = 'medical-documentation-review';

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'Капельница с озонотерапией', 'ru' FROM medical_services WHERE slug = 'intravenous-ozone-therapy'
UNION ALL SELECT id, 'Озонированный физраствор', 'ru' FROM medical_services WHERE slug = 'intravenous-ozone-therapy'
UNION ALL SELECT id, 'Ozonated Saline Infusion', 'en' FROM medical_services WHERE slug = 'intravenous-ozone-therapy'
UNION ALL SELECT id, 'Ozonizovani fiziološki rastvor', 'sr' FROM medical_services WHERE slug = 'intravenous-ozone-therapy'
UNION ALL SELECT id, 'Озонизовани физиолошки раствор', 'sr-cyrl' FROM medical_services WHERE slug = 'intravenous-ozone-therapy'
UNION ALL SELECT id, 'Ozon-Infusion', 'de' FROM medical_services WHERE slug = 'intravenous-ozone-therapy'
UNION ALL SELECT id, 'Topical Ozone Therapy', 'en' FROM medical_services WHERE slug = 'local-ozone-therapy'
UNION ALL SELECT id, 'Autologous Blood Therapy', 'en' FROM medical_services WHERE slug = 'autohemotherapy'
UNION ALL SELECT id, 'Лечение собственной кровью', 'ru' FROM medical_services WHERE slug = 'autohemotherapy'
UNION ALL SELECT id, 'Terapija vlastitom krvlju', 'sr' FROM medical_services WHERE slug = 'autohemotherapy'
UNION ALL SELECT id, 'Терапија властитом крвљу', 'sr-cyrl' FROM medical_services WHERE slug = 'autohemotherapy'
UNION ALL SELECT id, 'Аутогемотерапия в комбинации с озонотерапией', 'ru' FROM medical_services WHERE slug = 'ozone-autohemotherapy'
UNION ALL SELECT id, 'Озоно-аутогемотерапия', 'ru' FROM medical_services WHERE slug = 'ozone-autohemotherapy'
UNION ALL SELECT id, 'Autohemotherapy with Ozone', 'en' FROM medical_services WHERE slug = 'ozone-autohemotherapy'
UNION ALL SELECT id, 'Eigenblutbehandlung mit Ozon', 'de' FROM medical_services WHERE slug = 'ozone-autohemotherapy'
UNION ALL SELECT id, 'Расшифровка анализов', 'ru' FROM medical_services WHERE slug = 'medical-documentation-review'
UNION ALL SELECT id, 'Анализ медицинской документации и анализов', 'ru' FROM medical_services WHERE slug = 'medical-documentation-review'
UNION ALL SELECT id, 'Medical Records Review', 'en' FROM medical_services WHERE slug = 'medical-documentation-review'
UNION ALL SELECT id, 'Analiza medicinske dokumentacije', 'sr' FROM medical_services WHERE slug = 'medical-documentation-review'
UNION ALL SELECT id, 'Анализа медицинске документације', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-documentation-review';

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC PRICES
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, ms.id, p.price, p.price_min, NULL, NULL, 0
FROM (
	          SELECT 'professor-cardiologist-examination' AS slug, NULL AS price, 70.00 AS price_min -- Прием профессора; от 70
	UNION ALL SELECT 'specialist-examination', 60.00, NULL                                           -- Прием врача; 60
	UNION ALL SELECT 'professor-cardiologist-examination-with-ecg', NULL, 70.00                      -- Прием профессора с ЭКГ; от 70
	UNION ALL SELECT 'professor-cardiology-package', NULL, 100.00                                    -- Прием профессора с ЭКГ с доп. исследованиями;от 100
	UNION ALL SELECT 'ecg', 20.00, NULL                                                              -- ЭКГ с расшифровкой;20
	UNION ALL SELECT 'medical-documentation-review', 30.00, NULL                                     -- Анализ медицинской документации и анализов;30
	UNION ALL SELECT 'infusion-therapy', NULL, 40.00                                                 -- Капельница в зависимости от количества препаратов;от 40
	UNION ALL SELECT 'intravenous-ozone-therapy', NULL, 60.00                                        -- Капельница с озонотерапией;от 60
	UNION ALL SELECT 'intramuscular-injection', 15.00, NULL                                          -- Внутримышечная инъекция;15
	UNION ALL SELECT 'local-ozone-therapy', NULL, 50.00                                              -- Местная озонотерапия;от 50
	UNION ALL SELECT 'autohemotherapy', 20.00, NULL                                                  -- Аутогемотерапия;20
	UNION ALL SELECT 'ozone-autohemotherapy', 30.00, NULL                                            -- Аутогемотерапия в комбинации с озонотерапией;30
) AS p
JOIN medical_services ms ON ms.slug = p.slug;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: one row, the clinic id on this database
SELECT @clinic_id AS clinic_id;

-- expected: 6 rows, each with cats and (for the first and the last) specs
SELECT ms.id, ms.slug, ms.name_sr_cyrl, ms.sort_order,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specs,
	(SELECT COUNT(*) FROM medical_service_synonyms y WHERE y.medical_service_id = ms.id) AS synonyms
FROM medical_services ms
WHERE ms.slug IN ('professor-cardiologist-examination-with-ecg', 'intravenous-ozone-therapy', 'local-ozone-therapy',
	'autohemotherapy', 'ozone-autohemotherapy', 'medical-documentation-review');

-- expected: services = 12, price_sum = 175.00, price_min_sum = 390.00, outdated = 0
SELECT COUNT(*) AS services, SUM(price) AS price_sum, SUM(price_min) AS price_min_sum, SUM(is_price_outdated) AS outdated
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_ru, cms.price, cms.price_min
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

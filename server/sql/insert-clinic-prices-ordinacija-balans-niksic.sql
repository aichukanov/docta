SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Ordinacija Balans (Nikšić) — pricelist, new import
-- Source: https://drbalans.me/cjenovnik/ (WordPress page, HTML table "CJENOVNIK ZDRAVSTVENIH USLUGA ORDINACIJE "BALANS"")
-- Snapshot: data/clinic-pricelists/sources/ordinacija-balans-niksic/2026-10-02.html
-- Price date: not stated on the page. wp-json /wp/v2/pages?search=cjen → page id 115 "cjenovnik",
--   modified 2025-12-01T18:31:29 → fresh, is_price_outdated = 0
-- Collected: 2026-10-02
--
-- Source rows: 35 prices (34 table rows; the nutritionist row carries two prices), all medical services, no lab tests
--   imported:            34
--     matched to catalog: 31
--     new catalog records: 3 (see PART 1)
--   not imported:         1 — "24h mobilni EKG | 10,00€", excluded by decision (unclear service, price)
-- "10,00-20,00€" → price + price_max. No clinic codes in the source.
-- The page has no physiotherapy prices, although the clinic runs a physiotherapy centre.
-- Notes on the page, not imported as rows (see record notes):
--   +10,00 € on non-working days and outside working hours; 10% off the second examination;
--   follow-up price valid within a month of the first examination; medication not included.
-- Record: data/clinic-imports/ordinacija-balans-niksic.json
-- Idempotent: ON DUPLICATE KEY on medical_services.name_en, INSERT IGNORE everywhere else.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'ordinacija-balans-niksic');

SET @cat_ultrasound = 4;
SET @cat_cardiology = 8;
SET @cat_general_medicine = 9;
SET @spec_cardiology = 1;
SET @spec_internal_medicine = 2;
SET @spec_radiology = 10;
SET @spec_general_medicine = 45;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: NEW CATALOG RECORDS
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order) VALUES
('ECG with Internist or Cardiologist Consultation', 'ecg-with-internist-or-cardiologist-consultation',
	'EKG uz konsultaciju interniste ili kardiologa', 'ЕКГ уз консултацију интернисте или кардиолога',
	'ЭКГ с консультацией интерниста или кардиолога', 'EKG mit Beratung durch Internisten oder Kardiologen',
	'Dahiliye veya Kardiyoloji Konsültasyonu ile EKG', NULL),
('Follow-up Nutritionist Examination', 'follow-up-nutritionist-examination',
	'Kontrolni pregled nutricioniste', 'Контролни преглед нутриционисте',
	'Контрольный осмотр нутрициолога', 'Kontrolluntersuchung beim Ernährungsberater',
	'Diyetisyen Kontrol Muayenesi', 2),
('Abdomen, Thyroid and Breast Ultrasound', 'abdomen-thyroid-and-breast-ultrasound',
	'Ultrazvuk abdomena, štitne žlijezde i dojki', 'Ултразвук абдомена, штитне жлијезде и дојки',
	'УЗИ брюшной полости, щитовидной железы и молочных желёз', 'Abdomen-, Schilddrüsen- und Brust-Ultraschall',
	'Karın, Tiroid ve Meme Ultrasonu', NULL)
ON DUPLICATE KEY UPDATE name_en = name_en;

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
          SELECT id, @cat_cardiology FROM medical_services WHERE slug = 'ecg-with-internist-or-cardiologist-consultation'
UNION ALL SELECT id, @cat_general_medicine FROM medical_services WHERE slug = 'follow-up-nutritionist-examination'
UNION ALL SELECT id, @cat_ultrasound FROM medical_services WHERE slug = 'abdomen-thyroid-and-breast-ultrasound';

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
          SELECT id, @spec_cardiology FROM medical_services WHERE slug = 'ecg-with-internist-or-cardiologist-consultation'
UNION ALL SELECT id, @spec_internal_medicine FROM medical_services WHERE slug = 'ecg-with-internist-or-cardiologist-consultation'
UNION ALL SELECT id, @spec_general_medicine FROM medical_services WHERE slug = 'follow-up-nutritionist-examination'
UNION ALL SELECT id, @spec_radiology FROM medical_services WHERE slug = 'abdomen-thyroid-and-breast-ultrasound';

-- Synonyms: the clinic's own wording where it differs from the catalog name
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
          SELECT id, 'EKG uz konsultaciju interniste/kardiologa', 'sr' FROM medical_services WHERE slug = 'ecg-with-internist-or-cardiologist-consultation'
UNION ALL SELECT id, 'ЕКГ уз консултацију интернисте/кардиолога', 'sr-cyrl' FROM medical_services WHERE slug = 'ecg-with-internist-or-cardiologist-consultation'
UNION ALL SELECT id, 'Kontrola nutricioniste', 'sr' FROM medical_services WHERE slug = 'follow-up-nutritionist-examination'
UNION ALL SELECT id, 'Контрола нутриционисте', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-nutritionist-examination'
UNION ALL SELECT id, 'Повторная консультация нутрициолога', 'ru' FROM medical_services WHERE slug = 'follow-up-nutritionist-examination'
UNION ALL SELECT id, 'Follow-up Dietitian Consultation', 'en' FROM medical_services WHERE slug = 'follow-up-nutritionist-examination'
UNION ALL SELECT id, 'Ultrazvučni pregled abdomena, štitaste žlijezde, dojki', 'sr' FROM medical_services WHERE slug = 'abdomen-thyroid-and-breast-ultrasound'
UNION ALL SELECT id, 'Ултразвучни преглед абдомена, штитасте жлијезде, дојки', 'sr-cyrl' FROM medical_services WHERE slug = 'abdomen-thyroid-and-breast-ultrasound'
UNION ALL SELECT id, 'Konsultacija nutricioniste', 'sr' FROM medical_services WHERE slug = 'nutritionist-specialist-examination'
UNION ALL SELECT id, 'Консултација нутриционисте', 'sr-cyrl' FROM medical_services WHERE slug = 'nutritionist-specialist-examination'
UNION ALL SELECT id, 'Test opterećenja', 'sr' FROM medical_services WHERE slug = 'ergometry-stress-test'
UNION ALL SELECT id, 'Тест оптерећења', 'sr-cyrl' FROM medical_services WHERE slug = 'ergometry-stress-test'
UNION ALL SELECT id, 'Kućna posjeta u gradu', 'sr' FROM medical_services WHERE slug = 'home-visit-city-center'
UNION ALL SELECT id, 'Кућна посјета у граду', 'sr-cyrl' FROM medical_services WHERE slug = 'home-visit-city-center';

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC PRICES
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, ms.id, p.price, NULL, p.price_max, NULL, 0
FROM (
	          SELECT 'specialist-examination' AS slug, 40.00 AS price, NULL AS price_max -- Specijalistički pregled | 40,00€
	UNION ALL SELECT 'subspecialist-examination', 50.00, NULL                              -- Subspecijalistički pregled(kardiolog, endokrinolog, reumatolog, pulmolog, gastroenterohepatolog-infektolog, hematolog) | 50,00€
	UNION ALL SELECT 'follow-up-specialist-examination', 25.00, NULL                       -- Kontrolni pregled specijaliste | 25,00€
	UNION ALL SELECT 'follow-up-subspecialist-examination', 40.00, NULL                    -- Kontrolni pregled subspecijaliste | 40,00€
	UNION ALL SELECT 'echocardiography-heart-ultrasound', 40.00, NULL                      -- Ultrazvuk srca | 40,00€
	UNION ALL SELECT 'nutritionist-specialist-examination', 60.00, NULL                    -- Konsultacija nutricioniste sa izradom individualnog jelovnika | 60,00€
	UNION ALL SELECT 'follow-up-nutritionist-examination', 40.00, NULL                     -- Kontrola nutricioniste | 40,00€
	UNION ALL SELECT 'holter-ecg-24h', 50.00, NULL                                         -- 24h Holter EKG monitoring | 50,00€
	UNION ALL SELECT 'holter-ecg-48h', 90.00, NULL                                         -- 48h Holter EKG monitoring | 90,00€
	UNION ALL SELECT 'holter-blood-pressure-24h', 50.00, NULL                              -- Holter krvnog pritiska | 50,00€
	UNION ALL SELECT 'ergometry-stress-test', 60.00, NULL                                  -- Test opterećenja-Ergometrija | 60,00€
	UNION ALL SELECT 'ecg', 10.00, NULL                                                    -- EKG | 10,00€
	UNION ALL SELECT 'ecg-with-internist-or-cardiologist-consultation', 20.00, NULL        -- EKG uz konsultaciju interniste/kardiologa | 20,00€
	UNION ALL SELECT 'spirometry', 20.00, NULL                                             -- Spirometrija | 20,00€
	UNION ALL SELECT 'home-visit-city-center', 60.00, NULL                                 -- Kućna posjeta u gradu | 60,00€
	UNION ALL SELECT 'intramuscular-injection', 10.00, 20.00                               -- Davanje intramuskularne injekcije | 10,00-20,00€
	UNION ALL SELECT 'intravenous-medication-application', 10.00, 50.00                    -- Davanje intravenske injekcije | 10,00-50,00€
	UNION ALL SELECT 'inhalation-therapy', 10.00, NULL                                     -- Inhalacija | 10,00€
	UNION ALL SELECT 'aspiration', 10.00, NULL                                             -- Aspiracija | 10,00€
	UNION ALL SELECT 'abdomen-ultrasound', 50.00, NULL                                     -- Ultrazvučni pregled abdomena(jetra, pankreas, slezina, bubrezi, mokraćna bešika) | 50,00€
	UNION ALL SELECT 'urinary-tract-ultrasound', 30.00, NULL                               -- Ultrazvučni pregled urotrakta(bubrezi, mokraćna bešika, prostata) | 30,00€
	UNION ALL SELECT 'upper-abdomen-ultrasound', 30.00, NULL                               -- Utrazvučni pregled (gornji abdomen) (jetra, pankreas, slezina, žučna kesa) | 30,00€
	UNION ALL SELECT 'breast-ultrasound', 40.00, NULL                                      -- Ultrazvučni pregled dojki | 40,00€
	UNION ALL SELECT 'peripheral-region-ultrasound', 40.00, NULL                           -- Ultrazvučni pregled perifernih tkiva (regionalni limfatici) | 40,00€
	UNION ALL SELECT 'thyroid-ultrasound', 35.00, NULL                                     -- Ultrazvučni pregled štitaste žlijezde | 35,00€
	UNION ALL SELECT 'ultrasound-neck-glands-and-soft-tissue', 50.00, NULL                 -- Ultrazvučni pregled vratnih struktura(štitasta žlijezda, pljuvačne žlijezde, meka tkiva vrata) | 50,00€
	UNION ALL SELECT 'soft-tissue-ultrasound', 30.00, NULL                                 -- Ultrazvučni pregled mekih tkiva | 30,00€
	UNION ALL SELECT 'testicular-ultrasound', 40.00, NULL                                  -- Ultrazvučni pregled testisa | 40,00€
	UNION ALL SELECT 'lung-base-ultrasound', 30.00, NULL                                   -- Ultrazvučni pregled plućnih baza | 30,00€
	UNION ALL SELECT 'abdomen-thyroid-and-breast-ultrasound', 110.00, NULL                 -- Ultrazvučni pregled abdomena, štitaste žlijezde, dojki | 110,00€
	UNION ALL SELECT 'doppler-neck-blood-vessels', 40.00, NULL                             -- Kolor dopler duplex scan krvnih sudova vrata | 40,00€
	UNION ALL SELECT 'doppler-lower-extremity-blood-vessels', 50.00, NULL                  -- Kolor dopler duplex scan krvnih sudova donjih ekstremiteta | 50,00€
	UNION ALL SELECT 'doppler-upper-extremity-blood-vessels', 40.00, NULL                  -- Kolor dopler duplex scan krvnih sudova gornjih ekstremiteta | 40,00€
	UNION ALL SELECT 'orthopedic-ultrasound-single-joint', 40.00, NULL                     -- Ultrazvučni pregled zglobova | 40,00€
	-- Not imported by decision (see record excluded): 24h mobilni EKG | 10,00€
) AS p
JOIN medical_services ms ON ms.slug = p.slug;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: one row, the clinic id on this database (69 locally and on prod as of 2026-10-02)
SELECT @clinic_id AS clinic_id;

-- expected: 3 rows, each with cats and specs; follow-up nutritionist sort_order = 2
SELECT ms.id, ms.slug, ms.name_sr_cyrl, ms.sort_order,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specs,
	(SELECT COUNT(*) FROM medical_service_synonyms y WHERE y.medical_service_id = ms.id) AS synonyms
FROM medical_services ms
WHERE ms.slug IN ('ecg-with-internist-or-cardiologist-consultation', 'follow-up-nutritionist-examination',
	'abdomen-thyroid-and-breast-ultrasound');

-- expected: services = 34, price_sum = 1350.00, price_max_sum = 70.00, outdated = 0
SELECT COUNT(*) AS services, SUM(price) AS price_sum, SUM(price_max) AS price_max_sum, SUM(is_price_outdated) AS outdated
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_sr, cms.price, cms.price_max
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

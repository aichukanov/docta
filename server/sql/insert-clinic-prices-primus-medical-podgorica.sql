SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Primus Medical (Podgorica) — services pricelist, new import (clinic had 0 services)
-- Sources (three PDFs, one per department, linked from Divi "Cjenovnik" buttons):
--   1. https://primus-medical.me/wp-content/uploads/2023/03/Cjenovnik-vene-2023.pdf
--      phlebology, 10 rows, text PDF. Date: "Podgorica 01.09.2025." in the document
--      (file updated in place: Last-Modified 2026-04-17, PDF ModDate 2026-04-17) → current
--   2. https://primus-medical.me/wp-content/uploads/2023/01/cjenovnik-urologija.pdf
--      urology, 7 rows, HP scan without text layer, read from the rendered page.
--      No date in the document; Last-Modified 2023-01-11, PDF CreationDate 2023-01-10
--      → older than 2 years, is_price_outdated = 1
--   3. https://primus-medical.me/wp-content/uploads/2022/01/cjenovnik-nefrologija.pdf
--      nephrology, 2 rows. No date in the document; Last-Modified 2022-01-27,
--      PDF ModDate 2021-09-11 → older than 2 years, is_price_outdated = 1
-- Snapshots: data/clinic-pricelists/sources/primus-medical-podgorica/
-- Collected: 2026-10-02
--
-- Source rows: 19 (10 + 7 + 2), all services, no lab tests
--   clinic rows: 20 — one source row goes to two records: Cistoskopija mokraćne
--     bešike 150 → Cystoscopy (Male) + Cystoscopy (Female), the catalog has no
--     sex-neutral record
--   matched to existing catalog records: 15 records
--   new catalog records: 5
--     Laser Varicose Vein Surgery (Both Legs) / … with Ligation — EVLA variants
--     Sclerotherapy Veins (by Region and Number of Sessions)   — next to "Redovna skleroterapija"
--     Follow-up Vascular Surgeon Examination after 2 Years     — next to "do dvije godine"
--     Follow-up Urologist Examination after 6 Months           — next to "do 6 mjeseci"
--     For the last three pairs the plain catalog record takes the ordinary variant
--     (regular sclerotherapy, follow-up within the period); only the conditional
--     variant gets its own record.
--   is_price_outdated = 1: 10 rows (urology 8, nephrology 2)
-- Record: data/clinic-imports/primus-medical-podgorica.json
-- Idempotent: ON DUPLICATE KEY on medical_services, INSERT IGNORE everywhere else.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'primus-medical-podgorica');

SET @cat_surgical_examination = 14;
SET @cat_general_surgery = 17;
SET @cat_urology = 22;
SET @spec_general_surgery = 3;
SET @spec_urology = 9;
SET @spec_vascular_surgery = 34;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: NEW CATALOG RECORDS
-- ═══════════════════════════════════════════════════════════════
-- EVLA one leg goes to the existing 'Laser Varicose Vein Surgery' (synonyms EVLA /
-- Endovenous Laser Ablation already point there); both legs and with ligation are
-- separate prices, so separate records, after 'Vein Surgery (One Leg)' / 'Both Legs'.
-- The other three are the conditional half of a pair whose ordinary half is an
-- existing record; categories and specialties copied from that record.

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Laser Varicose Vein Surgery (Both Legs)', 'laser-varicose-vein-surgery-both-legs',
	'Laserska operacija proširenih vena — obje noge', 'Ласерска операција проширених вена — обје ноге',
	'Лазерная операция варикозных вен — обе ноги', 'Laser-Krampfaderoperation an beiden Beinen', 'Lazer Varis Ameliyatı - İki Bacak'),
('Laser Varicose Vein Surgery with Ligation', 'laser-varicose-vein-surgery-with-ligation',
	'Laserska operacija proširenih vena sa ligaturom', 'Ласерска операција проширених вена са лигатуром',
	'Лазерная операция варикозных вен с лигированием', 'Laser-Krampfaderoperation mit Ligatur', 'Ligasyonlu Lazer Varis Ameliyatı'),
('Sclerotherapy Veins (by Region and Number of Sessions)', 'sclerotherapy-veins-by-region-and-number-of-sessions',
	'Skleroterapija vena (po regiji i broju tretmana)', 'Склеротерапија вена (по регији и броју третмана)',
	'Склеротерапия вен (по зоне и числу сеансов)', 'Venenverödung (nach Region und Anzahl der Sitzungen)', 'Ven skleroterapisi (bölge ve seans sayısına göre)'),
('Follow-up Vascular Surgeon Examination after 2 Years', 'follow-up-vascular-surgeon-examination-after-2-years',
	'Kontrolni pregled — vaskularni hirurg, nakon dvije godine', 'Контролни преглед — васкуларни хирург, након двије године',
	'Контрольный осмотр сосудистого хирурга спустя 2 года', 'Kontrolluntersuchung beim Gefäßchirurgen nach 2 Jahren', '2 yıl sonra damar cerrahı kontrol muayenesi'),
('Follow-up Urologist Examination after 6 Months', 'follow-up-urologist-examination-after-6-months',
	'Kontrolni pregled urologa nakon 6 mjeseci', 'Контролни преглед уролога након 6 мјесеци',
	'Контрольный осмотр уролога спустя 6 месяцев', 'Urologische Kontrolluntersuchung nach 6 Monaten', '6 ay sonra ürolog kontrol muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- follow-ups sort after first examinations, as their plain records do
UPDATE medical_services SET sort_order = 2
WHERE slug IN ('follow-up-vascular-surgeon-examination-after-2-years', 'follow-up-urologist-examination-after-6-months')
	AND sort_order IS NULL;

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT ms.id, r.category_id
FROM (
	          SELECT 'laser-varicose-vein-surgery-both-legs' AS slug, @cat_general_surgery AS category_id
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', @cat_general_surgery
	UNION ALL SELECT 'sclerotherapy-veins-by-region-and-number-of-sessions', @cat_general_surgery
	UNION ALL SELECT 'follow-up-vascular-surgeon-examination-after-2-years', @cat_surgical_examination
	UNION ALL SELECT 'follow-up-urologist-examination-after-6-months', @cat_urology
) r
JOIN medical_services ms ON ms.slug = r.slug;

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT ms.id, r.specialty_id
FROM (
	          SELECT 'laser-varicose-vein-surgery-both-legs' AS slug, @spec_vascular_surgery AS specialty_id
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', @spec_general_surgery
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', @spec_vascular_surgery
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', @spec_general_surgery
	UNION ALL SELECT 'sclerotherapy-veins-by-region-and-number-of-sessions', @spec_vascular_surgery
	UNION ALL SELECT 'follow-up-vascular-surgeon-examination-after-2-years', @spec_vascular_surgery
	UNION ALL SELECT 'follow-up-vascular-surgeon-examination-after-2-years', @spec_general_surgery
	UNION ALL SELECT 'follow-up-urologist-examination-after-6-months', @spec_urology
) r
JOIN medical_services ms ON ms.slug = r.slug;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: SYNONYMS
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT ms.id, s.another_name, s.language
FROM (
	-- new EVLA records: same search words as the one-leg record
	          SELECT 'laser-varicose-vein-surgery-both-legs' AS slug, 'EVLA' AS another_name, 'en' AS language
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', 'Endovenous Laser Ablation', 'en'
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', 'Endovenska laser ablacija', 'sr'
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', 'Ендовенска ласер аблација', 'sr-cyrl'
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', 'ЭВЛК', 'ru'
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', 'Endovenöse Lasertherapie', 'de'
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', 'Endovenöz lazer ablasyonu', 'tr'
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 'EVLA', 'en'
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 'Endovenous Laser Ablation', 'en'
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 'Endovenska laser ablacija', 'sr'
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 'Ендовенска ласер аблација', 'sr-cyrl'
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 'ЭВЛК', 'ru'
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 'Endovenöse Lasertherapie', 'de'
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 'Endovenöz lazer ablasyonu', 'tr'
	-- existing records: wording of this pricelist
	UNION ALL SELECT 'leg-ulcer-dressing', 'Previjanje venske rane', 'sr'                 -- Prevoj i obrada venske rane
	UNION ALL SELECT 'leg-ulcer-dressing', 'Превијање венске ране', 'sr-cyrl'
	UNION ALL SELECT 'leg-ulcer-dressing', 'Перевязка трофической язвы', 'ru'
	UNION ALL SELECT 'transrectal-prostate-echosonography', 'TRUS', 'en'                -- Transrektalni UZ
	UNION ALL SELECT 'transrectal-prostate-echosonography', 'Transrektalni ultrazvuk', 'sr'
	UNION ALL SELECT 'transrectal-prostate-echosonography', 'Трансректални ултразвук', 'sr-cyrl'
	UNION ALL SELECT 'transrectal-prostate-echosonography', 'ТРУЗИ', 'ru'
) s
JOIN medical_services ms ON ms.slug = s.slug;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: CLINIC PRICES
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, ms.id, p.price, NULL, p.price_max, NULL, p.outdated
FROM (
	-- VENE — Cjenovnik-vene-2023.pdf, 01.09.2025
	          SELECT 'doppler-lower-extremity-blood-vessels' AS slug, 100.00 AS price, NULL AS price_max, 0 AS outdated -- 1. Doppler krvnih sudova donjih ekstremiteta 100,00
	UNION ALL SELECT 'laser-varicose-vein-surgery', 1750.00, NULL, 0              -- 2. Endovenska laser ablacija (EVLA) jedne noge 1750,00
	UNION ALL SELECT 'laser-varicose-vein-surgery-both-legs', 2750.00, NULL, 0    -- 3. Endovenska laser ablacija (EVLA) obije noge 2750,00
	UNION ALL SELECT 'laser-varicose-vein-surgery-with-ligation', 1700.00, NULL, 0 -- 4. Endovenska laser ablacija (EVLA) sa ligaturom 1700,00
	UNION ALL SELECT 'leg-ulcer-dressing', 50.00, NULL, 0                         -- 5. Prevoj i obrada venske rane 50,00
	UNION ALL SELECT 'sclerotherapy-veins-by-region-and-number-of-sessions', 300.00, 850.00, 0 -- 6. Skleroterapija (regija,broj tretmana) 300,00-850,00
	UNION ALL SELECT 'first-vascular-surgeon-examination', 70.00, NULL, 0         -- 7. Pregled specijaliste 70,00
	UNION ALL SELECT 'follow-up-vascular-surgeon-examination-after-2-years', 100.00, NULL, 0 -- 8. Kontrolni pregled nakon dvije godine 100,00
	UNION ALL SELECT 'sclerotherapy-veins', 100.00, 200.00, 0                     -- 9. Redovna skleroterapija 100,00-200,00
	UNION ALL SELECT 'follow-up-vascular-surgeon-examination', 70.00, NULL, 0     -- 10. Kontrolni pregled do dvije godine 70,00
	-- UROLOGIJA — cjenovnik-urologija.pdf, scan, 2023-01
	UNION ALL SELECT 'urologist-examination-with-ultrasound', 100.00, NULL, 1     -- 1. Prvi pregled specijaliste sa UZ urotrakta -100,00 €
	UNION ALL SELECT 'transrectal-prostate-echosonography', 20.00, NULL, 1        -- 2. Transrektalni UZ -20,00 €
	UNION ALL SELECT 'follow-up-urologist-examination', 80.00, NULL, 1            -- 3. Kontrolni pregled do 6 mjeseci - 80,00 €
	UNION ALL SELECT 'follow-up-urologist-examination-after-6-months', 100.00, NULL, 1 -- 4. Kontrolni pregled nakon 6 mjeseci - 100,00 €
	UNION ALL SELECT 'urinary-catheter-placement', 30.00, NULL, 1                 -- 5. Kateterizacija mokracne besike - 30,00 €
	UNION ALL SELECT 'cystoscopy-male', 150.00, NULL, 1                           -- 6. Cistoskopija mokracne besike - 150,00 €
	UNION ALL SELECT 'cystoscopy-female', 150.00, NULL, 1                         -- 6. (same row)
	UNION ALL SELECT 'wound-dressing', 15.00, 30.00, 1                            -- 7. Prevoj - 15,00€ -30,00 €
	-- NEFROLOGIJA — cjenovnik-nefrologija.pdf, 2022-01
	UNION ALL SELECT 'first-nephrologist-examination', 50.00, NULL, 1             -- 1. Prvi pregled specijaliste nefrologa - 50,00 €
	UNION ALL SELECT 'follow-up-nephrologist-examination', 50.00, NULL, 1         -- 2. Kontrolni pregled - 50,00 €
) p
JOIN medical_services ms ON ms.slug = p.slug;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: one row, the clinic id on this database
SELECT @clinic_id AS clinic_id;

-- expected: 5 rows; EVLA both: 17 / 3,34; sclerotherapy course: 17 / 34;
--   vascular follow-up: 14 / 3,34, sort_order 2; urologist follow-up: 22 / 9, sort_order 2
SELECT ms.id, ms.slug, ms.name_sr, ms.sort_order,
	(SELECT GROUP_CONCAT(medical_service_category_id ORDER BY 1) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS categories,
	(SELECT GROUP_CONCAT(specialty_id ORDER BY 1) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specialties
FROM medical_services ms
WHERE ms.slug IN ('laser-varicose-vein-surgery-both-legs', 'laser-varicose-vein-surgery-with-ligation',
	'sclerotherapy-veins-by-region-and-number-of-sessions', 'follow-up-vascular-surgeon-examination-after-2-years',
	'follow-up-urologist-examination-after-6-months');

-- expected: 20 rows total, 10 with is_price_outdated = 1
SELECT ms.slug, cms.price, cms.price_min, cms.price_max, cms.is_price_outdated, cms.is_obsolete
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY cms.is_price_outdated, ms.slug;

SELECT COUNT(*) AS total, SUM(is_price_outdated) AS outdated
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

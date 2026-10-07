SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Codra Hospital (Podgorica) — laboratory pricelist, new import
-- Source: https://www.codra.me/wp-content/uploads/2022/02/Cenovnik_Laboratorija-02.jpg
--         (image, linked from https://www.codra.me/cjenovnik-lab-dijagnostika/)
-- Snapshot: data/clinic-pricelists/sources/codra-hospital-podgorica/2026-10-02.jpg
-- Price date: 2022-02 (wp media upload path /2022/02/, media date 2022-02-14)
--   → older than 2 years, every row gets is_price_outdated = 1
-- Collected: 2026-10-02
--
-- Source rows: 83 (82 lab + 1 service "VAĐENJE KRVI")
--   lab tests:  81 distinct, all matched to existing catalog records (BETA HCG listed twice, same price)
--   services:   1, matched (Venous Blood Draw)
--   new catalog records: 0
-- Source quirk: "AST (SGPT)" / "ALT (SGOT)" — the abbreviations in brackets are swapped
--   in the image (AST = SGOT, ALT = SGPT); mapped by the main name AST / ALT.
-- Record: data/clinic-imports/codra-hospital-podgorica.json
-- Idempotent: INSERT IGNORE on (clinic_id, lab_test_id) / (clinic_id, medical_service_id).

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'codra-hospital-podgorica');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: LAB TESTS
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code, is_price_outdated)
SELECT @clinic_id, lt.id, p.price, NULL, NULL, 1
FROM (
	-- HEMATOLOGIJA
	          SELECT 'complete-blood-count' AS slug, 5.00 AS price            -- KRVNA SLIKA
	UNION ALL SELECT 'erythrocyte-sedimentation-rate', 1.00                    -- SEDIMENTACIJA ERITROCITA
	-- KOAGULACIJA
	UNION ALL SELECT 'bleeding-time', 1.00                                     -- VRIJEME KRVARENJA
	UNION ALL SELECT 'coagulation-time', 1.00                                  -- VRIJEME KOAGULACIJE
	UNION ALL SELECT 'fibrinogen', 3.00                                        -- FIBRINOGEN
	UNION ALL SELECT 'prothrombin-time-pt-inr', 3.00                           -- PROTROBINSKO VRIJEME
	UNION ALL SELECT 'd-dimer', 20.00                                          -- D-DIMER
	UNION ALL SELECT 'activated-partial-thromboplastin-time', 6.00             -- APTT
	-- BIOHEMIJA
	UNION ALL SELECT 'glucose', 2.00                                           -- GLUKOZA
	UNION ALL SELECT 'oral-glucose-tolerance-test', 12.00                      -- TEST OPTERECENJA GLUKOZOM (O-GTT)
	UNION ALL SELECT 'urea', 2.00                                              -- UREA
	UNION ALL SELECT 'urea-clearance', 8.00                                    -- UREA KLIRENS
	UNION ALL SELECT 'creatinine', 2.00                                        -- KREATININ
	UNION ALL SELECT 'creatinine-clearance', 8.00                              -- KREATININ KLIRENS
	UNION ALL SELECT 'uric-acid', 2.00                                         -- ACIDUM URICUM
	UNION ALL SELECT 'total-bilirubin', 2.00                                   -- BILIRUBIN UKUPNI
	UNION ALL SELECT 'direct-bilirubin', 2.00                                  -- BILIRUBIN DIREKTNI
	UNION ALL SELECT 'total-protein', 2.00                                     -- PROTEINI UKUPNI
	UNION ALL SELECT 'albumin', 2.00                                           -- ALBUMINI
	UNION ALL SELECT 'cholesterol', 2.00                                       -- HOLESTEROL
	UNION ALL SELECT 'triglycerides', 2.00                                     -- TRIGLECERIDI
	UNION ALL SELECT 'lipid-profile', 8.00                                     -- LIPIDNI STATUS (HDL,LDL)
	-- PREGLED URINA
	UNION ALL SELECT 'complete-urinalysis', 4.00                               -- KVALITATIVNO SA SEDIMENTOM
	UNION ALL SELECT 'calcium-in-24h-urine', 4.00                              -- KALCIJUM U24H
	-- PAS
	UNION ALL SELECT 'drug-panel-10-ii', 50.00                                 -- TEST NA OPOJNE DROGE - PANEL (10)
	-- ENZIMI
	UNION ALL SELECT 'ast', 2.00                                               -- AST (SGPT)
	UNION ALL SELECT 'alt', 2.00                                               -- ALT (SGOT)
	UNION ALL SELECT 'gamma-gt', 2.00                                          -- GAMA GT
	UNION ALL SELECT 'alkaline-phosphatase', 2.00                              -- ALKALNA FOSFATAZA
	UNION ALL SELECT 'ck', 2.00                                                -- KREATIN KINAZA (CK)
	UNION ALL SELECT 'ldh', 2.00                                               -- LDH
	UNION ALL SELECT 'amylase', 4.00                                           -- ALFA AMILAZA (SERUM)
	UNION ALL SELECT 'amylase-in-urine', 4.00                                  -- ALFA AMILAZA (URIN)
	UNION ALL SELECT 'troponin', 12.00                                         -- TROPONIN
	UNION ALL SELECT 'lipase', 5.00                                            -- LIPAZA
	-- METABOLITI
	UNION ALL SELECT 'iron', 3.00                                              -- GVOŽĐE (FE)
	UNION ALL SELECT 'ferritin', 13.00                                         -- FERITIN
	UNION ALL SELECT 'vitamin-b12', 13.00                                      -- VITAMIN B12
	UNION ALL SELECT 'vitamin-d-25-oh', 30.00                                  -- VITAMIN D
	-- ELEKTROLITI
	UNION ALL SELECT 'sodium', 3.00                                            -- NATRIJUM
	UNION ALL SELECT 'potassium', 3.00                                         -- KALIJUM
	UNION ALL SELECT 'calcium', 3.00                                           -- KALCIJUM UKUPNI
	UNION ALL SELECT 'chloride', 3.00                                          -- HLORIDI
	UNION ALL SELECT 'magnesium', 3.00                                         -- MAGNEZIJUM
	UNION ALL SELECT 'phosphorus', 3.00                                        -- FOSFOR
	-- REUMATSKI TESTOVI
	UNION ALL SELECT 'c-reactive-protein', 5.00                                -- CRP
	-- HORMONI / TIREOIDNI
	UNION ALL SELECT 'tsh', 5.50                                               -- TSH
	UNION ALL SELECT 'free-t3', 10.00                                          -- FREE T3
	UNION ALL SELECT 'free-t4', 10.00                                          -- FREE T4
	UNION ALL SELECT 'thyroglobulin', 15.00                                    -- TIREOGLOBULIN
	UNION ALL SELECT 'anti-tpo', 15.00                                         -- ANTI PO
	UNION ALL SELECT 'anti-thyroglobulin-antibodies', 15.00                    -- ANTI TG At
	-- HORMONI / REPRODUKTIVNI
	UNION ALL SELECT 'estradiol', 8.00                                         -- ESTRADIOL
	UNION ALL SELECT 'lh', 8.00                                                -- LH
	UNION ALL SELECT 'fsh', 8.00                                               -- FSH
	UNION ALL SELECT 'prolactin', 8.00                                         -- PROLAKTIN
	UNION ALL SELECT 'progesterone', 8.00                                      -- PROGESTERON
	UNION ALL SELECT 'beta-hcg', 14.00                                         -- BETA HCG, also BETA HCG (TESTISI) 14.00 under TUMOR MARKERI
	UNION ALL SELECT 'testosterone', 10.00                                     -- TESTOSTERON
	-- ADRENALNA FUNKCIJA
	UNION ALL SELECT 'cortisol', 9.00                                          -- KORTIZOL
	-- OSTEOPOROZA (+ prenatal screening printed in the same block)
	UNION ALL SELECT 'pth', 15.00                                              -- PTH
	UNION ALL SELECT 'calcitonin', 15.00                                       -- KALCITONIN
	UNION ALL SELECT 'triple-test-second-trimester-screening', 48.00                                      -- TRIPLE TEST
	UNION ALL SELECT 'double-test-first-trimester-screening', 40.00                                      -- DUBLE TEST
	-- DIJABETES
	UNION ALL SELECT 'hba1c', 14.00                                            -- BA1C
	UNION ALL SELECT 'insulin', 12.00                                          -- INSULIN
	UNION ALL SELECT 'c-peptide', 12.00                                        -- C-PEPTID
	-- TUMOR MARKERI
	UNION ALL SELECT 'afp', 15.00                                              -- AFP (JETRA, TESTISI)
	UNION ALL SELECT 'cea', 15.00                                              -- CEA (OPSTI, KOLON)
	UNION ALL SELECT 'ca-15-3', 16.00                                          -- CA 15-3 (DOJKA)
	UNION ALL SELECT 'ca-125', 16.00                                           -- CA 125 (JAJNICI)
	UNION ALL SELECT 'he4', 25.00                                              -- HE-4
	UNION ALL SELECT 'ca-19-9', 15.00                                          -- CA 19-9 (PANKREAS)
	UNION ALL SELECT 'psa', 14.00                                              -- PSA (PROSTATA)
	UNION ALL SELECT 'free-psa', 14.00                                         -- FREE PSA (PROSTATA)
	-- SEPSA
	UNION ALL SELECT 'procalcitonin', 30.00                                    -- PROCALCITONIN
	-- VIRUSI
	UNION ALL SELECT 'hiv-ag-ab', 15.00                                        -- HIV
	UNION ALL SELECT 'anti-hcv', 15.00                                         -- HCV
	UNION ALL SELECT 'hbsag', 14.00                                            -- HBsAg
	-- COVID 19
	UNION ALL SELECT 'covid-19-antigen-test', 20.00                            -- BRZI ANTIGENSKI TEST
	UNION ALL SELECT 'anti-sars-cov', 20.00                                    -- ANTI SARS COV-2 UKUPNA ANTITIJELA
) AS p
JOIN lab_tests lt ON lt.slug = p.slug;

-- Clinic wording as search synonyms (only where the catalog had nothing similar)
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
          SELECT id, 'Lipidni status', 'sr' FROM lab_tests WHERE slug = 'lipid-profile'
UNION ALL SELECT id, 'Липидни статус', 'sr' FROM lab_tests WHERE slug = 'lipid-profile'
UNION ALL SELECT id, 'Test na opojne droge', 'sr' FROM lab_tests WHERE slug = 'drug-panel-10-ii'
UNION ALL SELECT id, 'Тест на опојне дроге', 'sr' FROM lab_tests WHERE slug = 'drug-panel-10-ii';

-- ═══════════════════════════════════════════════════════════════
-- PART 2: MEDICAL SERVICES
-- ═══════════════════════════════════════════════════════════════

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, ms.id, 1.00, NULL, NULL, NULL, 1
FROM medical_services ms
WHERE ms.slug = 'venous-blood-draw';                                           -- USLUGE / VAĐENJE KRVI 1.00

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: one row, the clinic id on this database
SELECT @clinic_id AS clinic_id;

-- expected: lab_tests = 81, outdated = 81, sum = 816.50
SELECT COUNT(*) AS lab_tests, SUM(is_price_outdated) AS outdated, SUM(price) AS price_sum
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

-- expected: 1 row, Venous Blood Draw 1.00, outdated = 1
SELECT ms.slug, cms.price, cms.is_price_outdated
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id;

SELECT lt.slug, lt.name_en, clt.price
FROM clinic_lab_tests clt JOIN lab_tests lt ON lt.id = clt.lab_test_id
WHERE clt.clinic_id = @clinic_id
ORDER BY lt.name_en;

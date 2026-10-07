SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Vaše zdravlje (Podgorica) — disputed lines of the import, closed.
-- Runs after insert-clinic-prices-vase-zdravlje-podgorica.sql and
--   update-clinic-prices-vase-zdravlje-podgorica-dobutamine.sql (both applied locally and on prod).
-- Source: https://vasezdravlje.me/cjenovnik/ — rechecked by curl 2026-10-06, page modified 2026-04-22T08:44:10
--   (wp-json /wp/v2/pages/684?_fields=modified), both lines unchanged.
-- State before: local = prod for this clinic (2026-10-06): 88 services / sum 3070.00, 147 lab tests / sum 1816.00;
--   /api/labtests/details troponin → clinics 28, 141 only; /api/services/details
--   medical-certificate-for-high-risk-and-difficult-working-conditions → clinic 39 at 35.00.
--
-- 1) «hs Troponin – 10€» → lab test Troponin (slug troponin), 10.00, current.
--    The line does not say T or I. The catalog has a letterless record, Troponin: Codra's «TROPONIN» and
--    Opšta bolnica Nikšić's letterless FZOCG tariff Z02053 «Troponin» sit on it (KCCG, Danilo, Risan keep the
--    same code on Troponin I — a catalog inconsistency, not this import's). «hs» names the assay sensitivity,
--    not the isoform, so the letterless record states exactly what the clinic states.
--    For reference, comparable private labs would point to T, not I: Troponin T HS is held by In Vitro (3, 10 €),
--    Milmedika (4), Moj Lab (9), Diagnostica, Lab Medical, Dr Zejnilović, Tesla; Troponin I by Novi Standard and
--    Tesla among private clinics. Picking a letter would be a guess; the letterless record avoids it.
--    Synonym «hs Troponin» (the clinic's wording; «hs Troponin T» stays on Troponin T HS).
-- 2) «radna mjesta sa posebnim uslovima – 35€» → the same record as the neighbouring line
--    «radna mjesta sa povećanim rizikom (prethodni pregled) – 35€»: Medical Certificate for High Risk and
--    Difficult Working Conditions. Dom zdravlja Podgorica's pricelist names it «radnim mjestima sa posebnim
--    uslovima rada odnosno povećanim rizikom» — one category. The clinic row already exists at 35.00 and both
--    lines cost 35, so no price row changes; only the clinic's wording is added as a synonym (sr + sr-cyrl).
--
-- Idempotent: INSERT IGNORE only; a second run inserts 0 rows.
-- Clinic and catalog records by slug only.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'vase-zdravlje-podgorica');
SET @troponin_id = (SELECT id FROM lab_tests WHERE slug = 'troponin');
SET @high_risk_id = (SELECT id FROM medical_services WHERE slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions');

-- ═══ 1. hs Troponin ═══

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code, is_price_outdated)
SELECT @clinic_id, @troponin_id, 10.00, NULL, NULL, 0
FROM DUAL
WHERE @clinic_id IS NOT NULL AND @troponin_id IS NOT NULL;

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT @troponin_id, 'hs Troponin', 'sr' FROM DUAL WHERE @troponin_id IS NOT NULL
UNION ALL SELECT @troponin_id, 'hs Troponin', 'en' FROM DUAL WHERE @troponin_id IS NOT NULL;

-- ═══ 2. radna mjesta sa posebnim uslovima ═══

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT @high_risk_id, 'Ljekarsko uvjerenje za radna mjesta sa posebnim uslovima rada', 'sr' FROM DUAL WHERE @high_risk_id IS NOT NULL
UNION ALL SELECT @high_risk_id, 'Љекарско увјерење за радна мјеста са посебним условима рада', 'sr-cyrl' FROM DUAL WHERE @high_risk_id IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: lab_tests = 148, price sum = 1826.00
SELECT COUNT(*) AS lab_tests, SUM(price) AS price_sum
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

-- expected: services = 88, price sum = 3070.00 (unchanged)
SELECT COUNT(*) AS services, SUM(price) AS price_sum
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- expected: one row, troponin 10.00, outdated 0 (no row on troponin-t-hs / troponin-i)
SELECT lt.slug, clt.price, clt.is_price_outdated
FROM clinic_lab_tests clt JOIN lab_tests lt ON lt.id = clt.lab_test_id
WHERE clt.clinic_id = @clinic_id AND lt.slug IN ('troponin', 'troponin-t-hs', 'troponin-i', 'troponin-t-and-i-combined');

-- expected: one row, 35.00
SELECT ms.slug, cms.price, cms.is_price_outdated
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id AND ms.id = @high_risk_id;

-- expected: 2 rows on troponin, 2 rows on medical-certificate-for-high-risk-and-difficult-working-conditions
SELECT lt.slug, s.another_name, s.language
FROM lab_test_synonyms s JOIN lab_tests lt ON lt.id = s.lab_test_id
WHERE s.another_name = 'hs Troponin';

SELECT ms.slug, s.another_name, s.language
FROM medical_service_synonyms s JOIN medical_services ms ON ms.id = s.medical_service_id
WHERE s.medical_service_id = @high_risk_id AND s.another_name LIKE '%posebnim uslovima%'
	OR s.medical_service_id = @high_risk_id AND s.another_name LIKE '%посебним условима%';

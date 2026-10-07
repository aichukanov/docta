SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Primus Medical (Podgorica) — clear is_price_outdated on urology and nephrology rows
-- insert-clinic-prices-primus-medical-podgorica.sql flagged them by the file dates
-- (cjenovnik-urologija.pdf 2023-01, cjenovnik-nefrologija.pdf 2022-01; no date inside).
-- Decision 2026-10-02: the prices are treated as current —
--   both PDFs are still linked from the live department pages as the pricelist,
--   the clinic re-uploaded the vein pricelist in 2025 and left these two as they are,
--   and the prices sit at or above other clinics (urologist exam with US 100 vs 50–80,
--   cystoscopy 150 vs 150/170), which an outdated pricelist would not.
-- Idempotent; only rows still at the imported price are touched, so a price
-- corrected by hand keeps its flag as it is.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'primus-medical-podgorica');

UPDATE clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
JOIN (
	          SELECT 'urologist-examination-with-ultrasound' AS slug, 100.00 AS price
	UNION ALL SELECT 'transrectal-prostate-echosonography', 20.00
	UNION ALL SELECT 'follow-up-urologist-examination', 80.00
	UNION ALL SELECT 'follow-up-urologist-examination-after-6-months', 100.00
	UNION ALL SELECT 'urinary-catheter-placement', 30.00
	UNION ALL SELECT 'cystoscopy-male', 150.00
	UNION ALL SELECT 'cystoscopy-female', 150.00
	UNION ALL SELECT 'wound-dressing', 15.00
	UNION ALL SELECT 'first-nephrologist-examination', 50.00
	UNION ALL SELECT 'follow-up-nephrologist-examination', 50.00
) p ON p.slug = ms.slug AND p.price = cms.price
SET cms.is_price_outdated = 0
WHERE cms.clinic_id = @clinic_id AND cms.is_price_outdated = 1;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: total 20, outdated 0
SELECT COUNT(*) AS total, SUM(is_price_outdated) AS outdated
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

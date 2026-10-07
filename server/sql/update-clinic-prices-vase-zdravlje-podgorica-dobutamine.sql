SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Vaše zdravlje (Podgorica) — correction to insert-clinic-prices-vase-zdravlje-podgorica.sql (first version,
--   applied locally and on prod 2026-10-05).
-- «Dobutaminski test – 80€» was merged into Stress Echocardiography, though the catalog has its own record
--   Pharmacological Stress Echo Test Dobutamine (slug pharmacological-stress-echo-test-dobutamine).
--   1) the clinic gets a row on that record, 80.00, current;
--   2) Stress Echocardiography keeps 80.00 — that is the price of «Stres ehokardiografski test (stres EHO)»;
--   3) the 4 synonyms the first version hung on Stress Echocardiography move to the dobutamine record
--      (they name the other service and would pull its searches away). Only these 4 rows move;
--      the older synonyms of Stress Echocardiography (2026-09-29) stay.
-- Idempotent: INSERT IGNORE; UPDATE / DELETE find nothing on a second run.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'vase-zdravlje-podgorica');
SET @stress_echo_id = (SELECT id FROM medical_services WHERE slug = 'stress-echocardiography');
SET @dobutamine_id = (SELECT id FROM medical_services WHERE slug = 'pharmacological-stress-echo-test-dobutamine');

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code, is_price_outdated)
SELECT @clinic_id, @dobutamine_id, 80.00, NULL, NULL, NULL, 0
FROM DUAL
WHERE @clinic_id IS NOT NULL AND @dobutamine_id IS NOT NULL;

-- IGNORE + DELETE: if the dobutamine record already has a row (revised insert file ran too), the UNIQUE
--   (service, name, language) skips the move and the DELETE drops the leftover on Stress Echocardiography.
UPDATE IGNORE medical_service_synonyms
SET medical_service_id = @dobutamine_id
WHERE medical_service_id = @stress_echo_id
	AND @dobutamine_id IS NOT NULL
	AND (another_name, language) IN (
		('Dobutaminski test', 'sr'),
		('Добутамински тест', 'sr-cyrl'),
		('Dobutamine Stress Echo', 'en'),
		('Добутаминовая стресс-эхокардиография', 'ru')
	);

DELETE FROM medical_service_synonyms
WHERE medical_service_id = @stress_echo_id
	AND @dobutamine_id IS NOT NULL
	AND (another_name, language) IN (
		('Dobutaminski test', 'sr'),
		('Добутамински тест', 'sr-cyrl'),
		('Dobutamine Stress Echo', 'en'),
		('Добутаминовая стресс-эхокардиография', 'ru')
	);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- expected: services = 88, price sum = 3070.00
SELECT COUNT(*) AS services, SUM(price) AS price_sum
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- expected: two rows, both 80.00
SELECT ms.slug, cms.price, cms.is_price_outdated
FROM clinic_medical_services cms JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id AND ms.id IN (@stress_echo_id, @dobutamine_id);

-- expected: 4 rows, all on pharmacological-stress-echo-test-dobutamine
SELECT ms.slug, s.another_name, s.language
FROM medical_service_synonyms s JOIN medical_services ms ON ms.id = s.medical_service_id
WHERE s.another_name IN ('Dobutaminski test', 'Добутамински тест', 'Dobutamine Stress Echo', 'Добутаминовая стресс-эхокардиография');

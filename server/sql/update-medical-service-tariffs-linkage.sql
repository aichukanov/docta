-- Populate medical_service_tariffs.medical_service_id by matching on `code`
-- with existing clinic_medical_services rows (e.g. clinic 88, 131 — already FZOCG-coded).
-- For codes that map to multiple medical_service_ids, picks the most frequently
-- used mapping (majority vote).
--
-- Run AFTER all insert-tariff-fzocg-*.sql scripts.
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/update-medical-service-tariffs-linkage.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Single UPDATE with majority-vote subquery
UPDATE `medical_service_tariffs` t
JOIN (
  SELECT
    code,
    medical_service_id,
    COUNT(*) AS hits,
    ROW_NUMBER() OVER (PARTITION BY code ORDER BY COUNT(*) DESC, medical_service_id ASC) AS rn
  FROM `clinic_medical_services`
  WHERE code IS NOT NULL AND code <> ''
  GROUP BY code, medical_service_id
) c
  ON c.code = t.code
 AND c.rn = 1
SET t.medical_service_id = c.medical_service_id
WHERE t.medical_service_id IS NULL;

-- Report:
SELECT
  tariff_source,
  COUNT(*) AS total_rows,
  SUM(medical_service_id IS NOT NULL) AS linked,
  SUM(medical_service_id IS NULL)     AS unlinked
FROM `medical_service_tariffs`
GROUP BY tariff_source
ORDER BY tariff_source;

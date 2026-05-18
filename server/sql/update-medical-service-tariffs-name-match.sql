-- Second-pass linkage: match remaining unlinked tariffs by name_sr_latin ≈ medical_services.name_sr.
-- Uses utf8mb4_unicode_ci collation which is diacritic- and case-insensitive
-- (š/Š/s, č/Č/c, etc. all collate equal).
--
-- Only updates rows where medical_service_id IS NULL after the code-based pass.
-- Skips ambiguous matches (when one normalized name maps to multiple medical_services).
--
-- Run AFTER update-medical-service-tariffs-linkage.sql.
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/update-medical-service-tariffs-name-match.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Build a 1:1 normalized-name → medical_service_id map (skip ambiguous duplicates).
-- We pick the lowest medical_service_id when name collides; alternative is to skip,
-- but at this point a deterministic pick is more useful than dropping the row.
UPDATE `medical_service_tariffs` t
JOIN (
  SELECT
    LOWER(TRIM(name_sr)) COLLATE utf8mb4_unicode_ci AS norm_name,
    MIN(id)   AS medical_service_id,
    COUNT(*)  AS cnt
  FROM `medical_services`
  WHERE name_sr IS NOT NULL AND name_sr <> ''
  GROUP BY LOWER(TRIM(name_sr)) COLLATE utf8mb4_unicode_ci
) ms_idx
  ON ms_idx.norm_name = LOWER(TRIM(t.name_sr_latin)) COLLATE utf8mb4_unicode_ci
SET t.medical_service_id = ms_idx.medical_service_id
WHERE t.medical_service_id IS NULL
  AND t.name_sr_latin IS NOT NULL
  AND CHAR_LENGTH(TRIM(t.name_sr_latin)) >= 5
  AND ms_idx.cnt = 1;

-- Final report
SELECT
  tariff_source,
  COUNT(*) AS total_rows,
  SUM(medical_service_id IS NOT NULL) AS linked,
  SUM(medical_service_id IS NULL)     AS unlinked
FROM `medical_service_tariffs`
GROUP BY tariff_source
ORDER BY tariff_source;

-- Migration: lab_test_info + lab_test_sample_types tables
-- Adds structured metadata for lab tests: sample type, preparation, turnaround time,
-- parameters included, and localized summaries for SEO content.
--
-- Apply:
--   mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/create-labtest-info.sql

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ---------------------------------------------------------------------------
-- lab_test_sample_types — lookup table, maps to LabTestSampleType enum
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lab_test_sample_types (
  id         TINYINT      NOT NULL AUTO_INCREMENT,
  code       VARCHAR(30)  NOT NULL COMMENT 'Snake_case code used in app and enum: venous_blood, urine, ...',
  sort_order TINYINT      NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY uq_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Lookup table for lab test sample collection types. Maps 1:1 to LabTestSampleType enum.';

INSERT INTO lab_test_sample_types (code, sort_order) VALUES
  ('venous_blood',    1),
  ('capillary_blood', 2),
  ('urine',           3),
  ('stool',           4),
  ('swab',            5),
  ('saliva',          6),
  ('csf',             7),
  ('other',           8)
ON DUPLICATE KEY UPDATE sort_order = VALUES(sort_order);

-- ---------------------------------------------------------------------------
-- lab_test_info — one row per lab test
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS lab_test_info (
  lab_test_id      INT          NOT NULL,
  -- How the sample is collected
  sample_type_id   TINYINT      NOT NULL,
  -- Fasting requirements
  fasting          VARCHAR(20)  NOT NULL DEFAULT 'not_required'
    COMMENT 'required | recommended | not_required',
  fasting_hours    TINYINT      NULL     COMMENT 'Typical hours of fasting (NULL if not applicable)',
  -- Turnaround time in hours
  turnaround_min   SMALLINT     NOT NULL COMMENT 'Minimum hours until results are ready',
  turnaround_max   SMALLINT     NOT NULL COMMENT 'Maximum hours until results are ready',
  -- Parameters included (JSON array of strings, English names/abbreviations)
  parameters       JSON         NULL     COMMENT 'Array of parameter names measured in this test',
  -- Localized 1–2 sentence summaries for SEO
  summary_en       TEXT         NULL,
  summary_ru       TEXT         NULL,
  summary_sr       TEXT         NULL,
  summary_sr_cyrl  TEXT         NULL,
  summary_de       TEXT         NULL,
  summary_tr       TEXT         NULL,

  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (lab_test_id),
  CONSTRAINT fk_lab_test_info_lab_test
    FOREIGN KEY (lab_test_id)    REFERENCES lab_tests(id)            ON DELETE CASCADE,
  CONSTRAINT fk_lab_test_info_sample_type
    FOREIGN KEY (sample_type_id) REFERENCES lab_test_sample_types(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Structured metadata for lab tests: preparation, turnaround, parameters, localized summaries.';

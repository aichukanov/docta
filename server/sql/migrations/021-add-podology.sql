-- Podology: new clinic type + new medical service category
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/021-add-podology.sql

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: clinic_types — Podiatry Clinic (ClinicType.PODOLOGY_CABINET)
-- ═══════════════════════════════════════════════════════════════
-- Самостоятельный подологический кабинет. Специальность PODIATRY = 85
-- остаётся для подологов, работающих внутри клиник (напр. Kerber, clinic 29).

INSERT INTO clinic_types (id, name) VALUES (25, 'Podiatry Clinic')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- ═══════════════════════════════════════════════════════════════
-- PART 2: medical_service_categories — Podiatry (MedicalServiceCategory.PODOLOGY)
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_service_categories (id, name) VALUES (36, 'Podiatry')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT id, name FROM clinic_types WHERE id = 25;
SELECT id, name FROM medical_service_categories WHERE id = 36;

-- ═══════════════════════════════════════════════════════════════════════════
-- Tafica Dental & Dermatology Clinic (Ulcinj) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-tafica-dental-clinic-ulcinj.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-tafica-dental-clinic-ulcinj-services.sql
--
-- Источник: https://www.tafica.com/ — заглушка «under construction», услуг нет.
--
-- Итого: 0 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Услуг нет: файл ничего не пишет и ничего не удаляет — только precheck и verification.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJja4C-WQTThMR-4-t1EmDqW8' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'tafica-dental-clinic-ulcinj' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-tafica-dental-clinic-ulcinj.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: УСЛУГИ — 0
-- Сайт — заглушка «under construction»: ни одной услуги не названо, цен нет. Каталог не трогаем.
-- Файл оставлен для единообразия пары SQL: precheck + verification.
-- Сознательно без DELETE: пустой список не должен сносить услуги, добавленные позже вручную.
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Врачей и услуг нет — привязок нет.
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 0, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- ═══════════════════════════════════════════════════════════════════════════
-- Temel Dental (Подгорица, slug temel-dental-podgorica) — перечень услуг и цены
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/update-clinic-temel-dental-podgorica-services.sql
--
-- Источник: письменный «план лечения», присланный клиникой пациентке в переписке
-- (октябрь 2026, кейс prd/clinic-reputation, статья temel-dental-case):
--   • ортодонтический аппарат на верхнюю челюсть — 800 €
--   • ортодонтический аппарат на нижнюю челюсть — 800 €
--   • полное ортодонтическое лечение с брекетами — 3500–4000 €
-- Верх/низ — одна и та же позиция каталога (аппарат считается за челюсть),
-- поэтому в clinic_medical_services одна строка с ценой 800 €.
--
-- Что снимается:
--   • аппарат 1000 € (внесён 2026-10-21) — это был размер предоплаты, а не цена позиции;
--   • clear-aligner-therapy 1200–2400 € — цифры выведены из устной оценки «100–200 € в месяц»,
--     в прайсе клиники не подтверждены (решение юзера 2026-10-23: неподтверждённые цены убрать).
-- У клиники остаются только позиции из письменного плана.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- Идентификаторы клиники и врача берутся по slug: локальные id ≠ прод.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'temel-dental-podgorica' LIMIT 1);
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'ibrahim-halil-temel' LIMIT 1);

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника temel-dental-podgorica не найдена',
	CONCAT('OK: clinic_id = ', @clinic_id, ', doctor_id = ', COALESCE(@doctor_id, 'NULL'))) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (2)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_temel_services;
CREATE TEMPORARY TABLE tmp_x_temel_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_temel_services (slug, price, price_min, price_max) VALUES
	-- «Ортодонтический аппарат для верхней челюсти — 800 €» + «для нижней челюсти — 800 €»
	('orthodontic-removable-plate-appliance', 800.00, NULL, NULL),
	-- «Полное ортодонтическое лечение с брекетами — от 3500 до 4000 €»
	('complex-fixed-orthodontic-treatment', 3500.00, NULL, 4000.00);

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_temel_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_temel_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = VALUES(price),
	price_min = VALUES(price_min),
	price_max = VALUES(price_max),
	is_price_outdated = 0,
	is_obsolete = 0;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_temel_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL)
-- Обе позиции — ортодонтия, ведёт их ортодонт клиники dr Ibrahim Halil Temel
-- (specialty 93), от него же исходил письменный план.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

INSERT INTO clinic_medical_service_doctors (clinic_id, medical_service_id, doctor_id, price, price_max)
SELECT @clinic_id, ms.id, @doctor_id, NULL, NULL
FROM tmp_x_temel_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL AND @doctor_id IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- Ожидается ровно 2 строки услуг:
--   complex-fixed-orthodontic-treatment     3500.00 / NULL / 4000.00
--   orthodontic-removable-plate-appliance    800.00 / NULL / NULL
-- и 2 привязки на dr Ibrahim Halil Temel.
-- ═══════════════════════════════════════════════════════════════

SELECT ms.slug, ms.name_ru, cms.price, cms.price_min, cms.price_max, cms.is_price_outdated
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.slug;

SELECT d.slug AS doctor, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_x_temel_services;

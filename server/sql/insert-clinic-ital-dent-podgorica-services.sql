-- ═══════════════════════════════════════════════════════════════════════════
-- Ital-Dent (Podgorica) — перечень услуг
-- Run ПОСЛЕ server/sql/insert-clinic-ital-dent-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ital-dent-podgorica-services.sql
--
-- Источник: https://www.ital-dent.com/clinica/ («Cosa facciamo - Prestazioni», 12 пунктов), главная («I nostri servizi») и FAQ, curl 2026-10-09.
-- Цены — только по запросу; 2 позиции с ценой 0 €: главная «Eseguiamo ortopantomografie digitali (panoramiche) gratuite su CD» и
-- «Eseguiamo radiografie endoriali digitali (ogni singolo dente) gratuite su CD» (по образцу dental-montenegro-budva — 0.00 при «бесплатно»).
--
-- Итого: 14 услуг (2 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJWZaIIQrrTRMRgnAL_yZDUcA' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ital-dent-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ital-dent-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (14)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_itd_services;
CREATE TEMPORARY TABLE tmp_x_itd_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_itd_services (slug, price, price_min, price_max) VALUES
	('conscious-sedation', NULL, NULL, NULL), -- /clinica/: «Eseguiamo interventi in sedazione con la presenza di anestetista»; FAQ «Cosa si intende per sedazione cosciente?? — Un anestesista pratica una sedazione al paziente»
	('dental-implant-placement', NULL, NULL, NULL), -- /clinica/: «Implantologia»; «Utilizzo tecnica Piezosurgery ©» (FAQ: «permette di inserire gli impianti la dove un tempo non era possibile … ad ultrasuoni»)
	('immediate-implant-placement', NULL, NULL, NULL), -- FAQ: «Dopo un'estrazione dentale, quanto deve passare per inserire un impianto? — Normalmente 60 giorni, in alcuni casi anche subito dopo»
	('laser-teeth-whitening', NULL, NULL, NULL), -- /clinica/: «Sbiancamento dentale con laser …»
	('teeth-whitening', NULL, NULL, NULL), -- /clinica/: «Sbiancamento dentale … o lampada al plasma» — ламповое отбеливание в кабинете
	('dental-caries-treatment', NULL, NULL, NULL), -- /clinica/: «Cure dentali conservative»
	('ceramic-veneer', NULL, NULL, NULL), -- /clinica/: «Faccette in ceramica …»
	('direct-composite-veneer', NULL, NULL, NULL), -- /clinica/: «Faccette … o composito»
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- /clinica/: «Parodontologia (per curare la "piorrea")» — пиорея = пародонтит
	('dental-sinus-lift', NULL, NULL, NULL), -- /clinica/: «Chirurgia del rialzo del seno mascellare …»
	('bone-augmentation', NULL, NULL, NULL), -- /clinica/: «… e/o innesti ossei»; FAQ: «interventi specifici che permettono di aumentare il suo spessore»
	('clear-aligner-therapy', NULL, NULL, NULL), -- /clinica/: «Ortodonzia invisibile» — бренд не назван, общая запись элайнеров
	('panoramic-x-ray', 0, NULL, NULL), -- /clinica/: «Esami radiologici digitali su tutta l'arcata»; главная: «Eseguiamo ortopantomografie digitali (panoramiche) gratuite su CD» — 0 €
	('intraoral-x-ray', 0, NULL, NULL); -- /clinica/: «… o settoriali»; главная: «Eseguiamo radiografie endoriali digitali (ogni singolo dente) gratuite su CD» — 0 €

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_itd_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_itd_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_itd_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Врачей в импорте нет → привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 14, with_price = 2.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_x_itd_services;
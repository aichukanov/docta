-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Polident (Bijela, Herceg Novi) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-polident-bijela.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-polident-bijela-services.sql
--
-- Источник: https://polident.me/ — 4 направления на главной, curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные в подписях направлений. Протетика без материалов — в excluded записи импорта.
--
-- Итого: 6 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJLY89jhUxTBMRtWuukyexrlE' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'polident-bijela' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-polident-bijela.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (6)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_pld_services;
CREATE TEMPORARY TABLE tmp_x_pld_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_pld_services (slug, price, price_min, price_max) VALUES
	('dental-caries-treatment', NULL, NULL, NULL), -- «Konzervativna Stomatologija — Popravljanje, ekstrakcije, endodonsko liječenje zuba»: «Popravljanje» (бытовое «popravka zuba» = лечение кариеса/пломба)
	('tooth-extraction', NULL, NULL, NULL), -- «Konzervativna Stomatologija — … ekstrakcije …»
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- «Konzervativna Stomatologija — … endodonsko liječenje zuba» — число каналов не названо (как dental-smile-tivat)
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- «Estetska Stomatologija — Uklanjanje zubnog kamenca i bijeljenje zuba»
	('teeth-whitening', NULL, NULL, NULL); -- «Estetska Stomatologija — … bijeljenje zuba»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_pld_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_pld_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_pld_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Врач на сайте один, услуги по врачам сайт не распределяет и специализации у врача нет → привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 6, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_x_pld_services;
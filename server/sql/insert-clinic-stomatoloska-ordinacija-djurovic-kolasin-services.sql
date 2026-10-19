-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Đurović (Kolašin) — перечень услуг
-- Run ПОСЛЕ server/sql/insert-clinic-stomatoloska-ordinacija-djurovic-kolasin.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-djurovic-kolasin-services.sql
--
-- Источник: https://ordinacijadjurovic.me/ — 6 блоков «Naše Usluge» и текст «Stomatološka ordinacija "Đurović"», curl 2026-10-09.
-- Прайса нет («taksativno cijenu cjelokupnog liječenja» — по присланному ортопану). Цена есть у 1 позиции: осмотр 0 € («besplatni pregled»,
-- по образцу dental-montenegro-budva); остальные NULL. Демо-блок «Dental X-Rays / Exams & Cleanings / Root Canals …» не используется.
--
-- Итого: 9 услуг (1 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ1UEIXoF9TRMRmL9j1wA5KOY' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'stomatoloska-ordinacija-djurovic-kolasin' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-stomatoloska-ordinacija-djurovic-kolasin.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (9)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_dju_services;
CREATE TEMPORARY TABLE tmp_x_dju_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_dju_services (slug, price, price_min, price_max) VALUES
	('dental-consultation', 0, NULL, NULL), -- Главная: «svakom pacijentu obezbijedili smo besplatni pregled uz preciznu analizu zdravlja usta i zuba»; EN: «check the health of your teeth and gums for FREE» — 0 €
	('dental-implant-nobel-biocare', NULL, NULL, NULL), -- «Implanti — … U našoj ordinaciji koriste se implanti renomiranih proizvođača Nobel biocare, Bredent»
	('dental-implant-bredent', NULL, NULL, NULL), -- «Implanti — … Nobel biocare, Bredent»
	('complete-denture', NULL, NULL, NULL), -- «Protetika — … nadomještanjem izgubljenih zuba … potpunim (totalnim) … protezama» — материал не назван
	('partial-denture', NULL, NULL, NULL), -- «Protetika — … ili djelimičnim (parcijalnim) protezama»
	('orthodontic-consultation', NULL, NULL, NULL), -- «Ortopedija vilice je grana stomatologije koja se bavi dijagnostikom i liječenjem nepravilnosti zuba, vilica i lica kod djece i odraslih» — аппараты не названы, только диагностика
	('dental-local-anesthesia', NULL, NULL, NULL), -- «Oralna hirurgija — Savremena stomatologija odgovarajućim hirurškim postupcima i primjenom lokalne anestezije omogućava bezbolne oralno hirurške intervencije»
	('dental-caries-treatment', NULL, NULL, NULL), -- «Bolesti zuba i usta — Najčešće intervencije u stomatologiji se primjenjuju u oblasti bolesti zuba i usta»
	('teeth-whitening', NULL, NULL, NULL); -- «Izbljeljivanje zuba … postojeće nijanse zuba mijenjaju u nekoliko nijansi svjetlijih, postoji nekoliko metoda» — метод не назван

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_dju_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_dju_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_dju_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Врач заведён по косвенным признакам; услуги по врачам сайт не распределяет → привязок нет (решение координатора).
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 9, with_price = 1.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_x_dju_services;
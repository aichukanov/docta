-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Dr Vuksanović Ulcinj — анализы (без цен, кроме экспресс-теста)
-- Run ПОСЛЕ server/sql/insert-clinic-poliklinika-dr-vuksanovic-ulcinj.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-dr-vuksanovic-ulcinj-services.sql
--
-- Источники (WP REST drvuksanovic.me, curl 2026-10-08):
--   * Medicina rada — /o-nama/ (2026-06-27) и пост medicina-rada (2021-01): перечень удостоверений;
--   * анализы — памятки /preporuke/… (2020-08: микробиология, «posebne preporuke»), пост «Promotivna ponuda»
--     (2020-08, состав сета), пост об иммунохимическом тесте, баннер главной «Brzi antigen test-BAT na
--     SARS-CoV-2 10.00 €» (картинка 2021-12, на главной 2026). Перечня анализов на сайте нет.
-- Цена есть только у экспресс-теста (10.00 €, баннер 2021-12 — дата цены в записи импорта).
-- Лаборатория Ульциня — та же лаборатория («nalazi se na još jednoj lokaciji») → тот же список анализов; медицины труда в Ульцине нет.
--
-- Итого: 0 услуг (0 с ценой), 26 анализов (1 с ценой). Новых записей каталога — 0.
-- Привязок врач↔услуга нет: сайт не называет врачей у услуг.
--
-- Самоисправляющийся: канонические списки во временных таблицах, upsert + DELETE лишнего.
-- ⚠️ Позиции, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-dr-vuksanovic-ulcinj' LIMIT 1);

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-dr-vuksanovic-ulcinj.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (0)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_vuks_ul_services;
CREATE TEMPORARY TABLE tmp_vuks_ul_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_vuks_ul_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_vuks_ul_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_vuks_ul_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: АНАЛИЗЫ (26)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_vuks_ul_labs;
CREATE TEMPORARY TABLE tmp_vuks_ul_labs (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_vuks_ul_labs (slug, price, price_max) VALUES
	('covid-19-antigen-test', 10.00, NULL), -- главная, баннер «Brzi antigen test-BAT na SARS-CoV-2 10.00 €» (картинка 2021-12, на главной 2026)
	('urine-culture', NULL, NULL), -- /preporuke/…mikrobioloska…: «Urin za urinokulturu»
	('throat-swab-bacteria', NULL, NULL), -- «Brisevi grla, nosa i usne duplje»; промо-сет: «bris nosa i grla na bakterije i gljivice»
	('throat-swab-fungi', NULL, NULL), -- промо-сет: «bris … grla na … gljivice»
	('nose-swab-bacteria', NULL, NULL), -- «Brisevi … nosa»; промо-сет
	('nose-swab-fungi', NULL, NULL), -- промо-сет: «bris nosa … na … gljivice»
	('oral-cavity-swab-bacteria', NULL, NULL), -- «Brisevi grla, nosa i usne duplje»
	('vaginal-swab-bacteria', NULL, NULL), -- «Vaginalni i cervikalni bris»; промо-сет: «vaginalni i cervikalni bris na bakterije i gljivice»
	('vaginal-swab-fungi', NULL, NULL), -- промо-сет
	('cervical-swab-bacteria', NULL, NULL), -- «Vaginalni i cervikalni bris»; промо-сет
	('cervical-swab-fungi', NULL, NULL), -- промо-сет
	('urethral-swab-bacteria', NULL, NULL), -- «Uretralni bris»
	('sperm-culture-bacteria', NULL, NULL), -- «Spermokultura»
	('sputum-bacteria', NULL, NULL), -- «Ispljuvak-sputum»
	('stool-culture', NULL, NULL), -- «Za koprokulturu»; промо-сет «koprokulturu»
	('stool-parasites', NULL, NULL), -- «Za parazite … pregled tri uzorka stolice»
	('perianal-impression', NULL, NULL), -- «Perianalni otisak»
	('prothrombin-time-pt-inr', NULL, NULL), -- /posebne-preporuke/: «Protrombinsko vrijeme – pacijente koji su na oralnoj antikoagulantnoj terapiji»
	('oral-glucose-tolerance-test', NULL, NULL), -- «Test opterećenja glukozom (OGTT)»
	('catecholamines-in-24h-urine', NULL, NULL), -- «skupljanje 24h urina za kateholamine, VMA, ketosteroide, kortikosteroide, serotonin i 5-HIAA»
	('vma-in-urine', NULL, NULL), -- «… VMA …» (24h urin)
	('17-ketosteroids', NULL, NULL), -- «… ketosteroide …» (24h urin)
	('serotonin-in-24h-urine', NULL, NULL), -- «… serotonin …» (24h urin)
	('5-hiaa-in-24h-urine', NULL, NULL), -- «… i 5-HIAA» (24h urin)
	('spermogram', NULL, NULL), -- «Spermogram … Uzorak sperme se daje u laboratoriji»
	('fecal-occult-blood', NULL, NULL); -- «Uputstva za test na okultno krvavljenje-krv u stolici Imunohemijski test»; пост «Jednostavan imunohemijski test»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_slug
FROM tmp_vuks_ul_labs t
LEFT JOIN lab_tests lt ON lt.slug = t.slug
WHERE lt.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, lt.id, t.price, t.price_max, NULL
FROM tmp_vuks_ul_labs t
JOIN lab_tests lt ON lt.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_max = t.price_max;

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests lt ON lt.id = clt.lab_test_id
LEFT JOIN tmp_vuks_ul_labs t ON t.slug = lt.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Только там, где сайт сам называет врача услуги/направления.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 0, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается: labs_total = 26, with_price = 1.
SELECT COUNT(*) AS labs_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_vuks_ul_services;
DROP TEMPORARY TABLE IF EXISTS tmp_vuks_ul_labs;

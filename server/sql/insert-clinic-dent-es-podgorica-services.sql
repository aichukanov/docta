-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dent-ES (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dent-es-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dent-es-podgorica-services.sql
--
-- Источник: https://dent-es.me/usluge/ (WP REST, modified 2017-11-06), curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- ⚠️ Перечень 2017 года — состав мог устареть. Детская ортодонтия по договору с ФЗО — факт для описания, тарифы ФЗОЦГ ценами НЕ ставились.
--
-- Итого: 20 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJyzoiodjqTRMRkYqHpi_xiNU' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dent-es-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dent-es-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (20)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_s_des_services;
CREATE TEMPORARY TABLE tmp_s_des_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_s_des_services (slug, price, price_min, price_max) VALUES
	('dental-caries-treatment', NULL, NULL, NULL), -- OSNOVNE STOMATOLOŠKE USLUGE ZA DJECU I ODRASLE: «popravka zuba sa najsavremenijim materijalima» — материал не назван
	('tooth-extraction', NULL, NULL, NULL), -- «ekstrakcija zuba»
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- «uklanjanje zubnog kamenca …»
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- «… i tretman parodontopatičnih zuba» (повторено в HIRURŠKE USLUGE)
	('partial-acrylic-denture', NULL, NULL, NULL), -- PROTETSKE USLUGE: «izrada pločastih parcijalnih … proteza»
	('complete-acrylic-denture', NULL, NULL, NULL), -- «izrada pločastih … totalnih proteza»
	('skeletal-partial-denture', NULL, NULL, NULL), -- «izrada skeletiranih- vizil proteza» (синоним записи «Vizil proteza»)
	('metal-ceramic-bridge-pontic', NULL, NULL, NULL), -- «izrada metalo-keramičkih mostova»
	('all-ceramic-crown', NULL, NULL, NULL), -- «bezmetalna keramika» — отдельная строка, вид работы не уточнён
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- «cirkonijum»
	('cast-post-and-core', NULL, NULL, NULL), -- «izrad livenih nadogradnji …»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- ORTODONTSKE USLUGE: «ortodontski mobilni aparati»; «djeca mogu dobiti mobilne ortodontske aparate besplatno sa ovjerenom zdravsvenom knjižicom» (договор с ФЗО — цена не ставится)
	('fixed-braces-metal-per-jaw', NULL, NULL, NULL), -- «fiksni ortodontski aparati sa metalnim … bravicama ( tzv. “fiksna proteza” )»
	('fixed-braces-ceramic-or-composite-per-jaw', NULL, NULL, NULL), -- «… i estetskim bravicama»
	('frenectomy', NULL, NULL, NULL), -- HIRUŠKE USLUGE: «resekcija frenuluma» (стоматологическая запись; frenulum-resection — ЛОР)
	('apicoectomy', NULL, NULL, NULL), -- «apikotomija»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- «režanj operacije»
	('dental-implant-placement', NULL, NULL, NULL), -- «ugradnja implanta» — бренд не назван
	('panoramic-x-ray', NULL, NULL, NULL), -- SNIMANJE ZUBA: «Ortopan snimak»; главная/Kontakt: «Ortopan kabinet: +382 67 481 047»
	('intraoral-x-ray', NULL, NULL, NULL); -- «Klasični snimak zuba»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_s_des_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_s_des_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_s_des_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Сайт не называет врачей у услуг — привязок нет (ортодонтов двое).
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 20, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_s_des_services;
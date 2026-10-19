-- ═══════════════════════════════════════════════════════════════════════════
-- Pedijatrijska ordinacija Vuleković Sutomore — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-pedijatrijska-ordinacija-vulekovic-sutomore.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-pedijatrijska-ordinacija-vulekovic-sutomore-services.sql
--
-- Источники (WP REST, curl 2026-10-08): pocetna (FAQ), o-nama, nasi-ljekari (2025-01). Цен нет → все NULL.
-- Заведены только названные процедуры/осмотры; разделы «Ultrazvuk», «Alergologija», «Dijetoterapija»,
-- «Logopedija» — направления без процедур, в excluded записи импорта.
-- Явно подгорицкие услуги (ревматолог, дерматолог, Hyfrecator) сюда не входят; остальные — «если не разделяет — к обоим».
--
-- Итого: 3 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязки врач↔услуга (1) — где сайт называет врача.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'pedijatrijska-ordinacija-vulekovic-sutomore' LIMIT 1);

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-pedijatrijska-ordinacija-vulekovic-sutomore.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (3)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_vulekovic_sut_services;
CREATE TEMPORARY TABLE tmp_vulekovic_sut_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_vulekovic_sut_services (slug, price, price_min, price_max) VALUES
	('pediatric-examination', NULL, NULL, NULL), -- / FAQ: «detaljan ljekarski pregled … Pregled nije potrebno zakazivati»; /nasi-ljekari/ «OPŠTA PEDIJATRIJA»
	('newborn-home-visit', NULL, NULL, NULL), -- / FAQ: «u ponudi naše ordinacije su i kućne posjete, koje uključuju i detaljan pregled pedijatra, mjerenje djeteta i savjete oko njege novorođenčadi»
	('ent-specialist-examination', NULL, NULL, NULL); -- /o-nama/: «ORL pregledi u našoj ordinaciji … ordinira dr Maja Jovanović, specijalista ORL»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_vulekovic_sut_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_vulekovic_sut_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_vulekovic_sut_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 1
-- Только там, где сайт сам называет врача услуги/направления.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_vulekovic_sut_doctor_services;
CREATE TEMPORARY TABLE tmp_vulekovic_sut_doctor_services (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
);

INSERT INTO tmp_vulekovic_sut_doctor_services (doctor_slug, service_slug) VALUES
	('jovanovic-maja', 'ent-specialist-examination');

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО.
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_vulekovic_sut_doctor_services t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_vulekovic_sut_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 3, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 1 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_vulekovic_sut_services;
DROP TEMPORARY TABLE IF EXISTS tmp_vulekovic_sut_doctor_services;

-- ═══════════════════════════════════════════════════════════════════════════
-- Dentix — Stomatološka ordinacija Dr Đurković (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dentix-djurkovic-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dentix-djurkovic-podgorica-services.sql
--
-- Источник: https://www.djurkovicdent.me/, curl 2026-10-08. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные на сайте; направления и оборудование — в excluded записи импорта.
-- Сайт не делит услуги по ординациям сети — список одинаковый для всех филиалов.
--
-- Итого: 20 услуг (0 с ценой), новых записей каталога — 0. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJD721XwDrTRMRgFhZKEqO3GI' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dentix-djurkovic-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dentix-djurkovic-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (20)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_q_dxp_services;
CREATE TEMPORARY TABLE tmp_q_dxp_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_q_dxp_services (slug, price, price_min, price_max) VALUES
	('tooth-extraction', NULL, NULL, NULL), -- /: Oralna Hirurgija — «Vadjenje (ekstrakcija) zuba»
	('wisdom-tooth-extraction', NULL, NULL, NULL), -- /services.html: «Hirusko Vadnjenje Umnjaka»
	('apicoectomy', NULL, NULL, NULL), -- /: «Apikotomija-resekcija korijena zuba»
	('frenectomy', NULL, NULL, NULL), -- /: «Resekcija frenuluma»
	('laser-frenectomy', NULL, NULL, NULL), -- /: «Najsvestraniji diodni laser — Bezbolno uklanjanje frenuluma kod djece i odraslih, bez krvi, bez potrebe za sivenjem»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- /: «Rezanj operacija»
	('laser-gingivectomy', NULL, NULL, NULL), -- / (diodni laser): «Gingivektomija rjesavanje problema gummy-smile-a»
	('aphthous-ulcer-treatment', NULL, NULL, NULL), -- / (diodni laser): «Terapija bola, pomaze u brzem zarastanju afti i herpesa»
	('dental-implant-placement', NULL, NULL, NULL), -- /: «Implantologija … ugradnjom implantata», /services.html: «Ugradnja Zubnih Implanta» — бренд не назван
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- /: «Endodoncija … tretman obolele zubne pulpe – kako u kruničnom tako i u korenskom delu zuba»
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- то же
	('composite-filling', NULL, NULL, NULL), -- /services.html: «Bijele Plombe»
	('dental-caries-treatment', NULL, NULL, NULL), -- /services.html: «Lijecenje Zuba»
	('teeth-whitening', NULL, NULL, NULL), -- /: «Izbjeljivanje zuba — Bijeljenje zuba je proces uklanjanja raznih mrlja i diskoloracija»
	('laser-teeth-whitening', NULL, NULL, NULL), -- / (diodni laser): «Lasersko izbjeljivanje zuba»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- /: «Ortodoncija — Mobilna i Fiksna»
	('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL), -- то же — материал брекетов не назван
	('3d-dental-x-ray-cbct', NULL, NULL, NULL), -- /: «Snimanje zuba — 3D Snimanje, Ortopan (2D), Retroalveolarni radiogram»
	('panoramic-x-ray', NULL, NULL, NULL), -- «Ortopan (2D)»
	('intraoral-x-ray', NULL, NULL, NULL); -- «Retroalveolarni radiogram»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_q_dxp_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_q_dxp_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_q_dxp_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Сайт не называет врачей у услуг — привязок нет.
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

DROP TEMPORARY TABLE IF EXISTS tmp_q_dxp_services;

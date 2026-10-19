-- ═══════════════════════════════════════════════════════════════════════════
-- Ana Medica (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-ana-medica-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ana-medica-podgorica-services.sql
--
-- Источник перечня — /usluge/ («Usluge dermatološke ordinacije», 7 пунктов) + /contact-2/ («dermatološki pregled,
-- dermoskopski pregled mladeža …») + главная («Polno prenosive bolesti — Diskretno testiranje»). /oblasti/ —
-- просветительские тексты о болезнях («Vaš dermatolog …»): упомянутые там методы (трихоскопия, total body scan,
-- фототерапия, IPL, лазеры) клиника как свои услуги не заявляет → excluded в записи импорта.
-- Цен на сайте нет → все price = NULL. Новых записей каталога нет. Анализов нет.
-- Привязок врач↔услуга нет: все три врача — дерматовенерологи, сайт не распределяет услуги по врачам.
--
-- Итого: 11 услуг, все без цены; новых записей каталога: 0.
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJA5G1lTTrTRMRz1RQ8FugQoI';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ana-medica-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ana-medica-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (11)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_anamedica_services;
CREATE TEMPORARY TABLE tmp_anamedica_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_anamedica_services (slug, price, price_min, price_max) VALUES
	('dermatologist-examination', NULL, NULL, NULL), -- /contact-2/: «U našoj ustanovi možete obaviti dermatološki pregled»
	('dermatoscopy', NULL, NULL, NULL), -- /usluge/: «Dermoskopija — Neinvazivna metoda za rano otkrivanje melanoma … Omogućava čuvanje i poređenje slika kroz vrijeme»; /contact-2/: «dermoskopski pregled mladeža». Цифровые записи каталога разбиты по числу родинок — сайт числа не даёт, взята общая
	('radiowave-skin-lesion-removal', NULL, NULL, NULL), -- «Elektrohirurgija radiotalasima — … uklanjanje dobroćudnih promjena»
	('cryotherapy', NULL, NULL, NULL), -- «Kriohirurgija — Primjena tečnog azota (-196°C) za uništavanje lezija (keratoze, bradavice, fibromi, angiomi)» — общая запись кат. 24; варианты по числу очагов не подходят
	('chemical-peel', NULL, NULL, NULL), -- «Hemijski pilinzi — Rastvori kiselina uklanjaju oštećeni sloj kože …»
	('hyperhidrosis-botox-treatment', NULL, NULL, NULL), -- «Hiperhidroza — Liječi se antiperspirantima, jontoforezom, lokalnom primjenom neuromodulatora …» — единственная процедура из перечня, которую делают в кабинете; см. openQuestions
	('skin-and-subcutaneous-tissue-biopsy', NULL, NULL, NULL), -- «Dijagnostička biopsija kože — Uzimanje uzorka kože pod lokalnom anestezijom» — без заявленного ПГ-заключения
	('prick-test-inhalation-allergens', NULL, NULL, NULL), -- «Prick testovi: otkrivaju alergije na inhalacione …»
	('prick-test-nutritive-allergens', NULL, NULL, NULL), -- «… i prehrambene alergene»
	('patch-test', NULL, NULL, NULL), -- «Epikutani (patch) testovi: … Testiranje traje 48–72 sata»
	('std-testing-package', NULL, NULL, NULL); -- главная: «Polno prenosive bolesti — Diskretno testiranje i stručno liječenje»; name_sr записи «Testiranje na polno prenosive bolesti»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_anamedica_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_anamedica_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_anamedica_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- Привязок нет (см. шапку): только очистка, чтобы повторный прогон снимал ручные хвосты.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 11, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_anamedica_services;

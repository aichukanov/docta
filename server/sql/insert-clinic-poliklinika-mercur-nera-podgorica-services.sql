-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Mercur Nera (Podgorica) — перечень услуг и анализов (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-poliklinika-mercur-nera-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-mercur-nera-podgorica-services.sql
--
-- Цен на сайте нет → все price = NULL. Новых записей каталога нет. Перечень — со страниц разделов «Usluge»;
-- обобщения без конкретной процедуры («Intenzivna terapija», «Sva … doppler dijagnostika», «Hormonska dijagnostika»,
-- «Brisevi» и т.п.) — в excluded записи импорта. ⚠️ Сайт ~2013: перечень мог устареть.
-- Привязки врач↔услуга — только осмотр по специальности каждого из трёх врачей «Stručni tim».
--
-- Итого: 51 услуг, 10 анализов, все без цены; новых записей каталога: 0.
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJARdxydjqTRMRs1L64zL89Gw';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-mercur-nera-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-mercur-nera-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (51)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_mercurnera_services;
CREATE TEMPORARY TABLE tmp_mercurnera_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_mercurnera_services (slug, price, price_min, price_max) VALUES
	('internist-examination', NULL, NULL, NULL), -- O nama: «obavljamo internističke … preglede»; Sistematski: «Internistički pregled»
	('hematologist-examination', NULL, NULL, NULL), -- Interna medicina: «Hematalogija» (так на сайте)
	('cardiologist-examination', NULL, NULL, NULL), -- Interna medicina: «Kardiologija»
	('endocrinologist-examination', NULL, NULL, NULL), -- Interna medicina: «Endokrinologija»
	('rheumatologist-examination', NULL, NULL, NULL), -- Interna medicina: «Reumatologija»; отдельный пункт меню «Reumatologija» (страница пустая)
	('pulmonologist-examination', NULL, NULL, NULL), -- Interna medicina: «Pulmologija»
	('allergist-examination', NULL, NULL, NULL), -- Interna medicina: «Alergologija»
	('first-nephrologist-examination', NULL, NULL, NULL), -- Interna medicina: «Nefrologija» — общей записи «осмотр нефролога» нет, только первичный/повторный
	('first-gastroenterologist-examination', NULL, NULL, NULL), -- Interna medicina: «Gastroenterologija, Hepatologija» — гепатолога отдельно в каталоге нет
	('nutritionist-specialist-examination', NULL, NULL, NULL), -- Interna medicina: «Higijena ishrane i dijetetika»
	('gynecological-specialist-examination', NULL, NULL, NULL), -- Ginekologija: «Ginekološki pregledi»
	('pregnancy-specialist-examination', NULL, NULL, NULL), -- Ginekologija: «praćenje trudnoće»
	('colposcopy', NULL, NULL, NULL), -- Ginekologija: «kolposkopija»
	('pediatric-examination', NULL, NULL, NULL), -- Pedijatrija: «Pedijatrijski pregledi»
	('urologist-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Urolog-pregled, ultrazvuk»
	('oncologist-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Onkolog-pregled, ultrazvuk»
	('first-neurologist-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Neurolog» — общей записи нет, только первичный/повторный
	('orthopedist-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Ortoped-pregled, EHO pregled»
	('first-psychiatrist-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Psihijatar»
	('first-physiatrist-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Fizijatar-pregled, terapijski tretmani»
	('first-neurosurgeon-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Neurohirurg»
	('surgical-examination', NULL, NULL, NULL), -- Konsultativni pregledi: «Hirurg»
	('comprehensive-health-checkup', NULL, NULL, NULL), -- Sistematski pregledi: «Kompletna laboratorijska obrada krvi, Analiza urina, Internistički pregled, EKG, Ultrazvučni pregled abdomena i štitaste žlijezde»; O nama: «sistematske preglede djece i odraslih, pojedinačne i kompanijske»
	('preoperative-assessment', NULL, NULL, NULL), -- Ambulantno liječenje: «Preventivni i predoperativni pregledi»
	('ecg', NULL, NULL, NULL), -- Sistematski pregledi: «Provjera elektrofiziologije srca (EKG)»
	('ergometry-stress-test', NULL, NULL, NULL), -- Ambulantno liječenje: «Test opterećenja srca (ergometrija)»
	('stress-echocardiography', NULL, NULL, NULL), -- «… stres ehokardiografija»
	('holter-ecg-24h', NULL, NULL, NULL), -- «24-satni Holter EKG-a …»
	('holter-blood-pressure-24h', NULL, NULL, NULL), -- «… i krvnog pritiska»
	('echocardiography-heart-ultrasound', NULL, NULL, NULL), -- Ultrazvučni pregledi: «Ultrazvuk srca»
	('abdomen-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk trbuha»
	('thyroid-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk štitaste žlijezde»
	('soft-tissue-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk površnih struktura»
	('gynecological-ultrasound', NULL, NULL, NULL), -- «Ginekološki ultrazvuk»; Ginekologija: «ultrazvučna dijagnostika»
	('urinary-tract-ultrasound', NULL, NULL, NULL), -- «Urološki ultrazvuk»
	('musculoskeletal-ultrasound', NULL, NULL, NULL), -- «Ortopedski ultrazvuk»; Konsultativni: «Ortoped-… EHO pregled»
	('infant-brain-ultrasound-neurosonography', NULL, NULL, NULL), -- «CNS» (список УЗИ); Pedijatrija: «ultrazvućna dijagnostika, CNS i kukova»
	('pediatric-hip-ultrasound', NULL, NULL, NULL), -- Pedijatrija: «… CNS i kukova»
	('capillaroscopy', NULL, NULL, NULL), -- страница «Kapilaroskopija» (id 90)
	('oxygen-administration', NULL, NULL, NULL), -- Ambulantno liječenje: «Oksigenoterapija …»
	('inhalation-therapy', NULL, NULL, NULL), -- «…, inhalacije»
	('intramuscular-injection', NULL, NULL, NULL), -- «Parentalna medikamentalna terapija (injekcije …»
	('infusion-therapy', NULL, NULL, NULL), -- «… i infuziona terapija)»
	('primary-wound-care-with-sutures', NULL, NULL, NULL), -- «Šivenje rana …»
	('wound-dressing', NULL, NULL, NULL), -- «… i previjanje»
	('magnetic-therapy', NULL, NULL, NULL), -- Terapijski tretmani: «Kvantna terapija-magnet, …»
	('laser-therapy', NULL, NULL, NULL), -- «Kvantna terapija-…, laser, …»
	('tens-therapy', NULL, NULL, NULL), -- «Tens terapija-fizijatrijske procedure bolnih stanja …»
	('home-visit-examination', NULL, NULL, NULL), -- O nama: «Radimo kućne posjete doktora …»; Patronaža: «Medicinsko praćenje pacijenata u kućnim uslovima (specijalistički pregled …)»
	('nurse-home-visit', NULL, NULL, NULL), -- O nama: «… i medicinskih sestara»
	('home-visit-for-laboratory-sample-collection', NULL, NULL, NULL); -- Patronaža: «Uzimanje uzoraka krvi i urina po pozivu (kućne posjete i kućna njega)»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_mercurnera_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_mercurnera_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_mercurnera_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: КАНОНИЧЕСКИЙ СПИСОК АНАЛИЗОВ КЛИНИКИ (10)
-- Страница «Laboratorija» (id 78) и «Mikrobiologija» (id 79). Только позиции, у которых в каталоге одна
-- разумная запись; групповые формулировки — в excluded, неоднозначные — в openQuestions записи импорта.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_mercurnera_lab_tests;
CREATE TEMPORARY TABLE tmp_mercurnera_lab_tests (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL
);

INSERT INTO tmp_mercurnera_lab_tests (slug, price) VALUES
	('complete-urinalysis', NULL), -- Laboratorija: «Analiza urina»; Sistematski: «Analiza urina»
	('psa', NULL), -- «Utvrđivanje tumor markera (… prostata …)»
	('ca-15-3', NULL), -- «… tumor markera (dojka, …)»
	('cea', NULL), -- «… tumor markera (… debelo crijevo …)»
	('helicobacter-pylori', NULL), -- «Utvrđivanje antitijela na bakteriju … (HELICO BACTER PYLORI)» — запись «Antitijela na Helicobacter pylori»
	('hiv-ag-ab', NULL), -- «Virusološka obrada (HIV, …)»
	('hbsag', NULL), -- «… HbS …»
	('anti-hcv', NULL), -- «… HcV …»
	('urine-culture', NULL), -- Mikrobiologija: «urinokulture»
	('stool-culture', NULL); -- Mikrobiologija: «koprokulture»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_slug
FROM tmp_mercurnera_lab_tests t
LEFT JOIN lab_tests lt ON lt.slug = t.slug
WHERE lt.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, lt.id, t.price, NULL, NULL
FROM tmp_mercurnera_lab_tests t
JOIN lab_tests lt ON lt.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_max = NULL;

-- Снятие анализов клиники, которых нет в каноническом списке. Только эта клиника.
DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests lt ON lt.id = clt.lab_test_id
LEFT JOIN tmp_mercurnera_lab_tests t ON t.slug = lt.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 3
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_mercurnera_doctor_services;
CREATE TEMPORARY TABLE tmp_mercurnera_doctor_services (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
);

INSERT INTO tmp_mercurnera_doctor_services (doctor_slug, service_slug) VALUES
	('snezana-corac', 'hematologist-examination'),
	('svetlana-aligrudic', 'rheumatologist-examination'),
	('predrag-rakocevic', 'gynecological-specialist-examination');

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО.
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_mercurnera_doctor_services t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_mercurnera_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 51, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается: lab_total = 10, with_price = 0.
SELECT COUNT(*) AS lab_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

-- Ожидается 3 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_mercurnera_services;
DROP TEMPORARY TABLE IF EXISTS tmp_mercurnera_lab_tests;
DROP TEMPORARY TABLE IF EXISTS tmp_mercurnera_doctor_services;

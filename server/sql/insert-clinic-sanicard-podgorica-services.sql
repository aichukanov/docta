-- ═══════════════════════════════════════════════════════════════════════════
-- Zdravstvena ustanova Sanicard (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-sanicard-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-sanicard-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/sanicard-podgorica.json.
-- 
-- Услуг: 28, анализов: 0, с ценой: 1 (справка для моряков 60 €, главная, дата — modified главной 2023-02-26). Источник — /usluge/ (2023-02) + /o-nama/.
-- Новая запись каталога: athlete-cardiology-examination — идемпотентно по slug.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJk8O8ac7rTRMRFUCm_58AP9U' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'sanicard-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-sanicard-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Sanicard: «KARDIOLOŠKI PREGLEDI SPORTISTA ZA DJECU I ODRASLE». В каталоге только sports-medical-examination (общий спортивно-медицинский осмотр, не кардиолог), medical-certificate-for-athletes (справка) и три брендовых пакета одной клиники (sports-cardiology-package-basic/intermediate/advanced) — generic-записи кардиологического осмотра спортсмена нет. 8 CARDIOLOGY; специальности 1 CARDIOLOGY + 23 PEDIATRIC_CARDIOLOGY («za djecu i odrasle»).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'athlete-cardiology-examination', 'Cardiology Examination for Athletes', 'Kardiološki pregled sportista', 'Кардиолошки преглед спортиста',
	'Кардиологический осмотр спортсменов', 'Kardiologische Untersuchung für Sportler', 'Sporcular için kardiyoloji muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'athlete-cardiology-examination' OR name_en = 'Cardiology Examination for Athletes');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 8 FROM medical_services WHERE slug IN ('athlete-cardiology-examination');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 1 FROM medical_services WHERE slug IN ('athlete-cardiology-examination');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 23 FROM medical_services WHERE slug IN ('athlete-cardiology-examination');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Kardiološki pregled za sportiste', 'sr' FROM medical_services WHERE slug = 'athlete-cardiology-examination'
UNION ALL SELECT id, 'Кардиолошки преглед за спортисте', 'sr-cyrl' FROM medical_services WHERE slug = 'athlete-cardiology-examination'
UNION ALL SELECT id, 'Sports Cardiology Screening', 'en' FROM medical_services WHERE slug = 'athlete-cardiology-examination'
UNION ALL SELECT id, 'Кардиологическое обследование спортсменов', 'ru' FROM medical_services WHERE slug = 'athlete-cardiology-examination'
UNION ALL SELECT id, 'Sportkardiologische Untersuchung', 'de' FROM medical_services WHERE slug = 'athlete-cardiology-examination'
UNION ALL SELECT id, 'Sporcu kalp taraması', 'tr' FROM medical_services WHERE slug = 'athlete-cardiology-examination';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_sanicard_podgorica;
CREATE TEMPORARY TABLE tmp_sanicard_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_sanicard_podgorica (slug, price, price_min, price_max) VALUES
('pediatric-examination', NULL, NULL, NULL), -- «Pedijatrija — Pregledi bolesne … dijece»
('well-child-preventive-check-up', NULL, NULL, NULL), -- «… i sistematski pregledi zdrave dijece»
('systematic-infant-examination', NULL, NULL, NULL), -- «Neonatologija — Sistematski pregledi odojčadi …»
('pediatric-hip-ultrasound', NULL, NULL, NULL), -- «Neonatologija — … UZ kukova …», /o-nama/: «vrsni neonatolog na ultrazvučnom aparatu prati i razvoj CNS-a i kukova»
('infant-brain-ultrasound-neurosonography', NULL, NULL, NULL), -- «Neonatologija — … UZ … CNS-a»
('cardiologist-examination-with-ecg', NULL, NULL, NULL), -- «KARDIOLOGIJA ZA DJECU I ODRASLE — Fizikalni pregled sa EKG-om i monitoriranjem» (взрослые)
('first-pediatric-cardiologist-examination', NULL, NULL, NULL), -- «KARDIOLOGIJA ZA DJECU …» — осмотр детского кардиолога (основатель — педиатр-кардиолог), общей записи «осмотр детского кардиолога» в каталоге нет, есть первичный/повторный
('echocardiography-heart-ultrasound', NULL, NULL, NULL), -- «Ehokardiografija srca sa color-dopplerom» (взрослые)
('pediatric-echocardiography', NULL, NULL, NULL), -- «Ehokardiografija srca sa color-dopplerom» (дети, биография: «uvodi ehokardiografsku dijagnostiku kod djece u Crnoj Gori»)
('ergometry-stress-test', NULL, NULL, NULL), -- «Test opterečenja /ergometrija»
('holter-ecg-24h', NULL, NULL, NULL), -- «HOLTER EKG-a» — длительность не названа → стандартный 24 ч
('holter-blood-pressure-24h', NULL, NULL, NULL), -- «HOLTER - krvnog pritiska»
('spirometry', NULL, NULL, NULL), -- «Spirometrija»
('athlete-cardiology-examination', NULL, NULL, NULL), -- «KARDIOLOŠKI PREGLEDI SPORTISTA ZA DJECU I ODRASLE» (НОВАЯ)
('internist-examination', NULL, NULL, NULL), -- «INTERNA MEDICINA», /o-nama/: «PEDIJATRIJSKA I INTERNISTIČKA ORDINACIJA»
('abdomen-and-urinary-tract-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk abdomena i urotrakta»
('thyroid-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk štitaste žlijezde»
('breast-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk dojke»
('doppler-neck-blood-vessels', NULL, NULL, NULL), -- «Doppler kratidnih [karotidnih] arterija»
('doppler-lower-extremity-blood-vessels', NULL, NULL, NULL), -- «Doppler perifernih krvnih sudova», /o-nama/: «dopller krvnih sudova vrata i nogu»
('gynecological-specialist-examination', NULL, NULL, NULL), -- «KONSULTANTSKI PREGLEDI — Ginekologija», /o-nama/: «Rad je proširen i ginekološkim pregledima»
('endocrinologist-examination', NULL, NULL, NULL), -- «KONSULTANTSKI PREGLEDI — … endokrinologija»
('pediatric-gastroenterologist-examination', NULL, NULL, NULL), -- «KONSULTANTSKI PREGLEDI — … gastroenterologija za djecu»
('orthopedist-examination', NULL, NULL, NULL), -- «KONSULTANTSKI PREGLEDI — … ortopedija», /o-nama/: «Konsultacije vrši i ortoped»
('first-neurologist-examination', NULL, NULL, NULL), -- /o-nama/: «od konsultanata radi neurolog. Uz klasičan pregled, sprovodi se i EMG-dijagnostika»
('electromyoneurography-emng', NULL, NULL, NULL), -- «NEUROLOGIJA I PSIHIJATRIJA — Elektormiografija /EMNG/»
('comprehensive-health-checkup', NULL, NULL, NULL), -- /o-nama/: «vrše … sistematski pregledi za zaposlenike sa prefiksom UN-a u Crnoj Gori»
('medical-certificate-for-maritime-workers', 60.00, NULL, NULL); -- Главная: «Ljekarsa uvjerenja za pomorce sa sistematskim pregledom (cijena 60€)» — 60 €

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_sanicard_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_sanicard_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_sanicard_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 4
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_sanicard_podgorica_ds;
CREATE TEMPORARY TABLE tmp_sanicard_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_sanicard_podgorica_ds (doctor_slug, service_slug) VALUES
('svjetlana-zekovic', 'pediatric-examination'), -- педиатрия / детская кардиология → основатель, педиатр-кардиолог
('svjetlana-zekovic', 'well-child-preventive-check-up'), -- педиатрия / детская кардиология → основатель, педиатр-кардиолог
('svjetlana-zekovic', 'first-pediatric-cardiologist-examination'), -- педиатрия / детская кардиология → основатель, педиатр-кардиолог
('svjetlana-zekovic', 'pediatric-echocardiography'); -- педиатрия / детская кардиология → основатель, педиатр-кардиолог

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_sanicard_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_sanicard_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 28 услуг, с ценой 1.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 4 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 1: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('athlete-cardiology-examination');

DROP TEMPORARY TABLE IF EXISTS tmp_sanicard_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_sanicard_podgorica_ds;

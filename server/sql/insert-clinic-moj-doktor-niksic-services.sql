-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Moj Doktor (Nikšić) — услуги, анализы, привязки врач↔услуга
-- Run ПОСЛЕ server/sql/insert-clinic-moj-doktor-niksic.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-moj-doktor-niksic-services.sql
--
-- Источники (WP REST, curl -k 2026-10-08):
--   /laboratorijske-analize/ (2023-03-15) — 28 строк анализов, цена ОДНА: «Kompletna krvna
--     slika – 5.0€» (единственная цена на всём сайте); «Uzorkovanje (usluga vadenja krvi)» —
--     услуга (процедура), не анализ;
--   /ljekarska-uvjerenja/ (2023-03-15) — 14 видов справок;
--   /pedijatar/ (2023-03-15) — «Usluge:» 4 строки;
--   /kucne-posjete-doktora/ (2023-03-15) — «U kućnim uslovima možemo organizovati:» 9 строк;
--   /onama/ (2023-03-15), /usluge/ (2021-07-17), главная (2023-05-19) — перечень в прозе.
-- Дата «прайса» (одна цена) — 2023-03-15 (modified страницы анализов).
--
-- Итого в клинике: 40 услуг (0 с ценой), из них новых в каталоге: 3;
-- 28 анализов (1 с ценой). Привязки врач↔услуга — только там, где страница прямо ставит
-- врача над перечнем: /pedijatar/ (2 педиатра), /kucne-posjete-doktora/ (dr Ljiljana Adžić),
-- главная «ULTRAZVUK SRCA, HOLTER, EKG — Dr Srdjan Perazić Internista kardiolog».
-- is_price_outdated не ставится (решение юзера 2026-10-08).
--
-- Самоисправляющийся: канонические списки (услуги, анализы, привязки) лежат во временных
-- таблицах, по ним идут upsert и DELETE лишнего. ⚠️ Услуги/анализы/привязки, добавленные
-- клинике вручную, следующий прогон снесёт — вносить их сюда.
-- Сопоставление «строка сайта → slug» — data/clinic-imports/moj-doktor-niksic.json.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJbaoQbACpTRMRFwDCc29-_GY';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'moj-doktor-niksic' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-moj-doktor-niksic.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (3, идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- «LJEKARSKO UVJERENJE ZA RADNIKE NA PUMPI»: справки для работников АЗС в каталоге нет
-- (ближайшие — по условиям труда: hemijske materije / povećan rizik — не то же самое).
-- Категория 9 / спец. 45 — как у остальных medical-certificate-*.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'medical-certificate-for-petrol-station-workers', 'Medical Certificate for Petrol Station Workers', 'Ljekarsko uvjerenje za radnike na pumpi', 'Љекарско увјерење за раднике на пумпи',
	'Медицинская справка для работников АЗС', 'Ärztliches Attest für Tankstellenmitarbeiter', 'Akaryakıt İstasyonu Çalışanları İçin Sağlık Raporu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'medical-certificate-for-petrol-station-workers' OR name_en = 'Medical Certificate for Petrol Station Workers');

-- «Dolazak patronažne sestre» (кućne posjete): в каталоге визиты патронажной сестры есть
-- только как тарифы ДЗ с привязкой к расстоянию (patronage-nurse-*-up-to-5-km и т.п.) и
-- «ljekar + tehničar»; отдельного визита медсестры на дом нет. Категория 30 = HOME_VISITS.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'nurse-home-visit', 'Nurse Home Visit', 'Kućna posjeta medicinske sestre', 'Кућна посјета медицинске сестре',
	'Визит медсестры на дом', 'Hausbesuch einer Pflegekraft', 'Hemşire ev ziyareti', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'nurse-home-visit' OR name_en = 'Nurse Home Visit');

-- «Previjanje rana» (кućne posjete): перевязки в каталоге только амбулаторные; домашние
-- варианты заведены волной 2a для инъекций, инфузий и катетера (*-home-visit) — по той же
-- схеме. Категории 31 = WOUND_CARE + 30 = HOME_VISITS.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'wound-dressing-home-visit', 'Wound Dressing Home Visit', 'Previjanje rane u kućnoj posjeti', 'Превијање ране у кућној посјети',
	'Перевязка раны на дому', 'Wundverband beim Hausbesuch', 'Evde yara pansumanı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'wound-dressing-home-visit' OR name_en = 'Wound Dressing Home Visit');

-- Категория 9 = GENERAL_MEDICINE
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 9 FROM medical_services WHERE slug IN ('medical-certificate-for-petrol-station-workers');

-- Категория 30 = HOME_VISITS
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 30 FROM medical_services WHERE slug IN ('nurse-home-visit', 'wound-dressing-home-visit');

-- Категория 31 = WOUND_CARE
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 31 FROM medical_services WHERE slug IN ('wound-dressing-home-visit');

-- Специальность 45 = GENERAL_MEDICINE (авто по категории 9)
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 45 FROM medical_services WHERE slug IN ('medical-certificate-for-petrol-station-workers');

-- Синонимы: формулировки сайта и бытовые названия. sr дублируется в sr-cyrl.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Ljekarsko uvjerenje za benzinsku pumpu', 'sr' FROM medical_services WHERE slug = 'medical-certificate-for-petrol-station-workers'
UNION ALL SELECT id, 'Љекарско увјерење за бензинску пумпу', 'sr-cyrl' FROM medical_services WHERE slug = 'medical-certificate-for-petrol-station-workers'
UNION ALL SELECT id, 'Справка для работы на заправке', 'ru' FROM medical_services WHERE slug = 'medical-certificate-for-petrol-station-workers'
UNION ALL SELECT id, 'Medical certificate for gas station workers', 'en' FROM medical_services WHERE slug = 'medical-certificate-for-petrol-station-workers'
UNION ALL SELECT id, 'Dolazak patronažne sestre', 'sr' FROM medical_services WHERE slug = 'nurse-home-visit'
UNION ALL SELECT id, 'Долазак патронажне сестре', 'sr-cyrl' FROM medical_services WHERE slug = 'nurse-home-visit'
UNION ALL SELECT id, 'Патронажная медсестра на дом', 'ru' FROM medical_services WHERE slug = 'nurse-home-visit'
UNION ALL SELECT id, 'Home nursing visit', 'en' FROM medical_services WHERE slug = 'nurse-home-visit'
UNION ALL SELECT id, 'Previjanje rana kod kuće', 'sr' FROM medical_services WHERE slug = 'wound-dressing-home-visit'
UNION ALL SELECT id, 'Превијање рана код куће', 'sr-cyrl' FROM medical_services WHERE slug = 'wound-dressing-home-visit'
UNION ALL SELECT id, 'Перевязка на дому', 'ru' FROM medical_services WHERE slug = 'wound-dressing-home-visit';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (40, все без цены)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_mojdoktor_services;
CREATE TEMPORARY TABLE tmp_mojdoktor_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_mojdoktor_services (slug, price, price_min, price_max) VALUES
	-- /ljekarska-uvjerenja/ (14 строк → 16 позиций)
	('medical-certificate-for-driving-license-category-a-b-c-d-e', NULL, NULL, NULL), -- «ZA SVE KATEGORIJE VOŽNJE A, B, C, D, E»
	('medical-certificate-for-general-work', NULL, NULL, NULL), -- «ZA OPŠTU RADNU SPOSOBNOST»
	('medical-certificate-for-high-risk-and-difficult-working-conditions', NULL, NULL, NULL), -- «ZA RAD U OTEŽANIM USLOVIMA»
	('medical-certificate-for-professional-drivers', NULL, NULL, NULL), -- «ZA RAD PROFESIONALNIH VOZAČA»
	('medical-certificate-for-petrol-station-workers', NULL, NULL, NULL), -- «ZA RADNIKE NA PUMPI» (НОВАЯ)
	('medical-certificate-for-citizenship-and-permanent-residence', NULL, NULL, NULL), -- «ZA DOBIJANJE DRŽAVLJANSTVA, PRODUŽENJE BORAVKA, DOBIJANJE DOZVOLE ZA RAD I ODLAZAK U INOSTRANSTVO»
	('medical-certificate-for-residence-and-work-in-montenegro', NULL, NULL, NULL), -- та же строка: «PRODUŽENJE BORAVKA, DOBIJANJE DOZVOLE ZA RAD»
	('medical-certificate-for-work-abroad', NULL, NULL, NULL), -- та же строка: «ODLAZAK U INOSTRANSTVO»
	('medical-certificate-for-firearms-possession', NULL, NULL, NULL), -- «ZA DOBIJANJE I PRODUŽENJE DOZVOLE ZA POSJEDOVANJE VATRENOG ORUŽJA»
	('medical-certificate-for-military-service', NULL, NULL, NULL), -- «O SPOSOBNOSTI ZA OBAVLJANJE SLUŽBE U VOJSCI CRNE GORE»
	('medical-certificate-for-underage-marriage', NULL, NULL, NULL), -- «ZA SKLAPANJE BRAKA ZA MALOLJETNE OSOBE»
	('medical-certificate-for-child-adoption', NULL, NULL, NULL), -- «O PODOBNOSTI ZA USVAJANJE DJETETA»
	('medical-certificate-for-court-expert', NULL, NULL, NULL), -- «ZA POSAO SUDSKOG VJEŠTKA»
	('medical-certificate-for-life-insurance', NULL, NULL, NULL), -- «ZA ŽIVOTNO OSIGURANJE»
	('medical-certificate-for-athletes', NULL, NULL, NULL), -- «ZA SPORTISTE»
	('medical-certificate-for-continued-education', NULL, NULL, NULL), -- «ZA NASTAVAK ŠKOLOVANJA»
	-- /pedijatar/ «Usluge:»
	('pediatric-examination', NULL, NULL, NULL), -- «Specijalistički pregled pedijatra za bebe i djecu»
	('follow-up-pediatric-examination', NULL, NULL, NULL), -- «Kontrolni specijalistički pregled pedijatra»
	('pediatric-hip-ultrasound', NULL, NULL, NULL), -- «Ultrazvučni pregled kukova kod beba»
	-- /kucne-posjete-doktora/ «U kućnim uslovima možemo organizovati:»
	('home-visit-examination', NULL, NULL, NULL), -- «Posjetu ljekara specijaliste»; «Pregledi i kontrole»
	('home-visit-follow-up', NULL, NULL, NULL), -- «Pregledi i kontrole»
	('ecg-home-visit', NULL, NULL, NULL), -- «EKG»
	('nurse-home-visit', NULL, NULL, NULL), -- «Dolazak patronažne sestre» (НОВАЯ)
	('home-visit-for-laboratory-sample-collection', NULL, NULL, NULL), -- «Uzimanje uzoraka za laboratorijske analize»
	('intramuscular-injection-home-visit', NULL, NULL, NULL), -- «Davanje terapije (injekcije, infuzije itd.)»
	('infusion-therapy-home-visit', NULL, NULL, NULL), -- «Davanje terapije (injekcije, infuzije itd.)»
	('wound-dressing-home-visit', NULL, NULL, NULL), -- «Previjanje rana» (НОВАЯ)
	('urinary-catheter-placement-home-visit', NULL, NULL, NULL), -- «Zamjena urinarnog katetera»
	-- /onama/, /usluge/, главная
	('audiometry', NULL, NULL, NULL), -- «audiometriju»
	('spirometry', NULL, NULL, NULL), -- «spirometriju»
	('ecg', NULL, NULL, NULL), -- «ekg»; главная «ULTRAZVUK SRCA, HOLTER, EKG»
	('echocardiography-heart-ultrasound', NULL, NULL, NULL), -- «ultrazvuk srca»
	('holter-ecg-24h', NULL, NULL, NULL), -- главная «HOLTER» (в кардиоблоке рядом с EKG — Holter EKG; длительность не указана)
	('cardiologist-examination', NULL, NULL, NULL), -- «internističko kardiološke preglede»
	('x-ray-reading', NULL, NULL, NULL), -- «opisivanje RTG … snimaka»
	('ct-scan-reading', NULL, NULL, NULL), -- «opisivanje … CT snimaka»
	('first-psychological-examination', NULL, NULL, NULL), -- «pregled psihologa»
	('psychological-counseling', NULL, NULL, NULL), -- «psihološka savjetovanja»; главная «PSIHOLOŠKO SAVJETOVANJE»
	('nutritionist-specialist-examination', NULL, NULL, NULL), -- главная «SPECIJALISTIČKA AMBULANTA ZA PRAVILNU ISHRANU»
	-- /laboratorijske-analize/
	('venous-blood-draw', NULL, NULL, NULL); -- «Uzorkovanje (usluga vadenja krvi)»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_mojdoktor_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_mojdoktor_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_mojdoktor_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: АНАЛИЗЫ КЛИНИКИ (28, с ценой 1) — clinic_lab_tests
-- /laboratorijske-analize/: строка «HDL – holesterol» в источнике повторена дважды — одна позиция.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_mojdoktor_lab;
CREATE TEMPORARY TABLE tmp_mojdoktor_lab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_mojdoktor_lab (slug, price, price_max) VALUES
	('complete-blood-count', 5.00, NULL), -- «Kompletna krvna slika – 5.0€»
	('erythrocyte-sedimentation-rate', NULL, NULL), -- «Sedimentacija»
	('glucose', NULL, NULL), -- «Glukoza»
	('cholesterol', NULL, NULL), -- «Holesterol»
	('triglycerides', NULL, NULL), -- «Trigliceridi»
	('hdl-cholesterol', NULL, NULL), -- «HDL – holesterol» (×2 в источнике)
	('ldl-cholesterol', NULL, NULL), -- «LDL – holesterol»
	('urea', NULL, NULL), -- «Urea»
	('creatinine', NULL, NULL), -- «Kreatinin»
	('ast', NULL, NULL), -- «AST»
	('alt', NULL, NULL), -- «ALT»
	('alkaline-phosphatase', NULL, NULL), -- «ALP (Alkalna fosfataza)»
	('amylase', NULL, NULL), -- «Amilaza»
	('ldh', NULL, NULL), -- «LDH (Laktat dehidrogenaza)»
	('gamma-gt', NULL, NULL), -- «GGT»
	('total-protein', NULL, NULL), -- «Proteini»
	('albumin', NULL, NULL), -- «Albumin»
	('calcium', NULL, NULL), -- «Ukupni kalcijum»
	('c-reactive-protein', NULL, NULL), -- «CRP»
	('iron', NULL, NULL), -- «Gvožđe»
	('total-bilirubin', NULL, NULL), -- «Ukupni bilirubin»
	('direct-bilirubin', NULL, NULL), -- «Direktni bilirubin»
	('hba1c', NULL, NULL), -- «HbA1c»; /onama/ «tromjesečni šećer»
	('complete-urinalysis', NULL, NULL), -- «Citohemijska analiza urina»
	('psychoactive-substances-panel-10-parameters', NULL, NULL), -- «Test na psihoaktivne supstance (panel od 10 testova)»
	('tsh', NULL, NULL), -- «Analiza hormona štitaste žlijezde: TSH, T3, T4»
	('t3', NULL, NULL), -- то же
	('t4', NULL, NULL); -- то же

SELECT t.slug AS unmatched_lab_test
FROM tmp_mojdoktor_lab t
LEFT JOIN lab_tests lt ON lt.slug = t.slug
WHERE lt.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, lt.id, t.price, t.price_max, NULL
FROM tmp_mojdoktor_lab t
JOIN lab_tests lt ON lt.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_max = t.price_max;

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests lt ON lt.id = clt.lab_test_id
LEFT JOIN tmp_mojdoktor_lab t ON t.slug = lt.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 3: ПРИВЯЗКИ ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, без личных цен)
-- Врачи — по slug (заводятся insert-clinic-moj-doktor-niksic.sql).
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_mojdoktor_links;
CREATE TEMPORARY TABLE tmp_mojdoktor_links (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
);

INSERT INTO tmp_mojdoktor_links (doctor_slug, service_slug) VALUES
	-- /pedijatar/: «Specijalista pedijatar dr Senka Dumović Kontić / dr Branka Šupić — Usluge: …»
	('senka-dumovic-kontic', 'pediatric-examination'),
	('senka-dumovic-kontic', 'follow-up-pediatric-examination'),
	('senka-dumovic-kontic', 'pediatric-hip-ultrasound'),
	('branka-supic', 'pediatric-examination'),
	('branka-supic', 'follow-up-pediatric-examination'),
	('branka-supic', 'pediatric-hip-ultrasound'),
	-- /kucne-posjete-doktora/: «dr Ljiljana Adžić, specijalista opšte medicine — U kućnim uslovima možemo organizovati: …»
	('ljiljana-adzic', 'home-visit-examination'),
	('ljiljana-adzic', 'home-visit-follow-up'),
	('ljiljana-adzic', 'ecg-home-visit'),
	('ljiljana-adzic', 'nurse-home-visit'),
	('ljiljana-adzic', 'home-visit-for-laboratory-sample-collection'),
	('ljiljana-adzic', 'intramuscular-injection-home-visit'),
	('ljiljana-adzic', 'infusion-therapy-home-visit'),
	('ljiljana-adzic', 'wound-dressing-home-visit'),
	('ljiljana-adzic', 'urinary-catheter-placement-home-visit'),
	-- главная: «ULTRAZVUK SRCA, HOLTER, EKG — Dr Srdjan Perazić Internista kardiolog»; /onama/ «internističko kardiološke preglede»
	('srdjan-perazic', 'echocardiography-heart-ultrasound'),
	('srdjan-perazic', 'holter-ecg-24h'),
	('srdjan-perazic', 'ecg'),
	('srdjan-perazic', 'cardiologist-examination');

-- Страховка: врач или услуга не нашлись. Ожидается ПУСТО (после применения обоих файлов).
SELECT t.doctor_slug, t.service_slug,
	IF(d.id IS NULL, 'NO DOCTOR', 'ok') AS doctor, IF(ms.id IS NULL, 'NO SERVICE', 'ok') AS service
FROM tmp_mojdoktor_links t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN medical_services ms ON ms.slug = t.service_slug
WHERE d.id IS NULL OR ms.id IS NULL;

INSERT IGNORE INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_mojdoktor_links t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id
WHERE @clinic_id IS NOT NULL;

-- Снятие привязок этой клиники, которых нет в каноническом списке.
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
LEFT JOIN tmp_mojdoktor_links t ON t.doctor_slug = d.slug AND t.service_slug = ms.slug
WHERE cmsd.clinic_id = @clinic_id AND t.doctor_slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: services total = 40, with_price = 0; lab total = 28, with_price = 1; links = 19.
SELECT
	(SELECT COUNT(*) FROM clinic_medical_services WHERE clinic_id = @clinic_id) AS services_total,
	(SELECT COUNT(*) FROM clinic_medical_services WHERE clinic_id = @clinic_id AND price IS NOT NULL) AS services_with_price,
	(SELECT COUNT(*) FROM clinic_lab_tests WHERE clinic_id = @clinic_id) AS lab_total,
	(SELECT COUNT(*) FROM clinic_lab_tests WHERE clinic_id = @clinic_id AND price IS NOT NULL) AS lab_with_price,
	(SELECT COUNT(*) FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id) AS doctor_links;

-- Новые записи каталога: ожидается 3 строки, у каждой категория (у справки — и специальность 45).
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	GROUP_CONCAT(DISTINCT r.medical_service_category_id) AS categories,
	GROUP_CONCAT(DISTINCT s.specialty_id) AS specialties
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_services_specialties s ON s.medical_service_id = ms.id
WHERE ms.slug IN (
	'medical-certificate-for-petrol-station-workers',
	'nurse-home-visit',
	'wound-dressing-home-visit'
)
GROUP BY ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_mojdoktor_services;
DROP TEMPORARY TABLE IF EXISTS tmp_mojdoktor_lab;
DROP TEMPORARY TABLE IF EXISTS tmp_mojdoktor_links;

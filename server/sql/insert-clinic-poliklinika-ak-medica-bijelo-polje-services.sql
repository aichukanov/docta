-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika AK Medica (Bijelo Polje) — перечень услуг (без цен)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-ak-medica-bijelo-polje-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-poliklinika-ak-medica-bijelo-polje.sql.
-- Клиника — по google_place_id/slug, услуги — по slug, литеральных id нет.
--
-- Источник: https://akmedica.me/ — wp-json /wp/v2/pages (собрано 2026-10-08; правки страниц
-- 2025-08-11…2026-08-24). 12 направлений с блоком «… usluge u poliklinici AK MEDICA» и
-- 27 страниц отдельных услуг (pregledi, UZ, dopler, EKG, Holter, EEG, EMNG, gastroskopija,
-- kolonoskopija).
--
-- ЦЕН НЕТ нигде на сайте — все услуги NULL по дизайну.
-- Привязок врач↔услуга НЕТ: ни одна страница услуги не называет врача (приёмы описаны
-- безлично: «obavljaju naši stručni i posvećeni ljekari»). Сайт docta.me подставит врачей
-- клиники по специальности сам.
-- Лаборатории у клиники нет — анализов нет.
--
-- Взяты только позиции из блоков «… usluge u poliklinici AK MEDICA» и названия страниц услуг.
-- Перечни возможностей метода («Gastroskopija omogućava: … dilataciju», «Kolonoskopija
-- omogućava: … biopsija») и рекомендации к дообследованию («može predložiti … spirometriju,
-- kapilaroskopiju, bronhoskopiju») — не услуги клиники.
--
-- СПОРНЫЕ (не заведены, см. data/clinic-imports/poliklinika-ak-medica-bijelo-polje.json):
--   * «Blokade nerava» (terapija bola) — в каталоге только конкретные блокады (межрёберная,
--     седалищного нерва, плечевого сплетения, паравертебральная…), общей нет.
--   * «Zaustavljanje krvarenja jednjaka, želuca, dvanaestopalačnog crijeva i debelog crijeva» —
--     в каталоге гемостаз разделён по методу (инъекционный / механический клипсами), сайт метод
--     не называет.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишнее от прошлых прогонов
-- удаляется. ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJp_rPsp2lUhMRAP5YnLNnO7I' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-ak-medica-bijelo-polje' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-ak-medica-bijelo-polje.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (1) — идемпотентно по slug
-- ═══════════════════════════════════════════════════════════════

-- /gastroenterologija/: «Uklanjanje velikih tumorskih lezija iz debelog crijeva metodama endoskopske
-- mukozne resekcije i endoskopske submukozne disekcije (EMR i ESD)». EMR в каталоге есть
-- (emr-endoscopic-mucosal-resection), ESD — нет ни одной записи. Категория 6 GASTROENTEROLOGY,
-- специальность 13 (авто для категории 6).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'endoscopic-submucosal-dissection-esd', 'Endoscopic Submucosal Dissection (ESD)', 'Endoskopska submukozna disekcija (ESD)', 'Ендоскопска субмукозна дисекција (ESD)',
	'Эндоскопическая подслизистая диссекция (ESD)', 'Endoskopische Submukosadissektion (ESD)', 'Endoskopik submukozal diseksiyon (ESD)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'endoscopic-submucosal-dissection-esd' OR name_en = 'Endoscopic Submucosal Dissection (ESD)');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 6 FROM medical_services WHERE slug = 'endoscopic-submucosal-dissection-esd';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 13 FROM medical_services WHERE slug = 'endoscopic-submucosal-dissection-esd';

-- Синонимы: формулировки клиники, отличные от названий каталога.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Gastroenterohepatološki pregled', 'sr' FROM medical_services WHERE slug = 'first-gastroenterologist-examination'
UNION ALL SELECT id, 'Гастроентерохепатолошки преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'first-gastroenterologist-examination'
UNION ALL SELECT id, 'Ultrazvuk pazušnih jama i preponske regije', 'sr' FROM medical_services WHERE slug = 'ultrasound-axilla-and-groin'
UNION ALL SELECT id, 'Ултразвук пазушних јама и препонске регије', 'sr-cyrl' FROM medical_services WHERE slug = 'ultrasound-axilla-and-groin'
UNION ALL SELECT id, 'Specijalistički pregled za terapiju bola', 'sr' FROM medical_services WHERE slug = 'pain-medicine-subspecialist-examination'
UNION ALL SELECT id, 'Специјалистички преглед за терапију бола', 'sr-cyrl' FROM medical_services WHERE slug = 'pain-medicine-subspecialist-examination'
UNION ALL SELECT id, 'Приём специалиста по терапии боли', 'ru' FROM medical_services WHERE slug = 'pain-medicine-subspecialist-examination'
UNION ALL SELECT id, 'Подслизистая эндоскопическая диссекция', 'ru' FROM medical_services WHERE slug = 'endoscopic-submucosal-dissection-esd';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (все без цены — NULL по дизайну)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_akmedica_services;
CREATE TEMPORARY TABLE tmp_akmedica_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_akmedica_services (slug, price, price_min, price_max) VALUES
-- ── KARDIOLOGIJA — /kardiologija/ «Kardiološke usluge u poliklinici AK MEDICA» ───
('cardiologist-examination', NULL, NULL, NULL), -- Kardiološki pregled
('ecg', NULL, NULL, NULL), -- EKG (elektrokardiogram)
('echocardiography-heart-ultrasound', NULL, NULL, NULL), -- Ultrazvuk srca (ehokardiografija)
('holter-ecg-24h', NULL, NULL, NULL), -- Holter EKG-a (24h/48h)
('holter-ecg-48h', NULL, NULL, NULL), -- Holter EKG-a (24h/48h)
('holter-blood-pressure-24h', NULL, NULL, NULL), -- Holter krvnog pritiska (24h)
-- ── GASTROENTEROLOGIJA — /gastroenterologija/ «Gastroenterohepatološke usluge u poliklinici AK MEDICA» ───
('first-gastroenterologist-examination', NULL, NULL, NULL), -- Gastroenterohepatološki pregled
('abdomen-ultrasound', NULL, NULL, NULL), -- Ultrazvuk abdomena
('gastroscopy-without-anesthesia', NULL, NULL, NULL), -- Endoskopski pregledi sa ili bez analgosedacije: Gastroskopija (ezofagogastroduodenoskopija)
('gastroscopy-with-anesthesia', NULL, NULL, NULL), -- то же — с analgosedacijom
('colonoscopy-without-anesthesia', NULL, NULL, NULL), -- Endoskopski pregledi sa ili bez analgosedacije: Kolonoskopija
('colonoscopy-with-anesthesia', NULL, NULL, NULL), -- то же — с analgosedacijom
('esophagogastroduodenoscopy-with-biopsy', NULL, NULL, NULL), -- Endoskopske intervencije: Biopsije sluznice želuca i dvanaestopalačnog crijeva
('colonoscopy-with-polypectomy', NULL, NULL, NULL), -- Polipektomija – uklanjanje polipa iz debelog crijeva
('emr-endoscopic-mucosal-resection', NULL, NULL, NULL), -- Uklanjanje velikih tumorskih lezija iz debelog crijeva … endoskopske mukozne resekcije (EMR)
('endoscopic-submucosal-dissection-esd', NULL, NULL, NULL), -- … i endoskopske submukozne disekcije (ESD) (новая запись)
-- ── PULMOLOGIJA — /pulmologija/ ───────────────────────────────────────────
('pulmonologist-examination', NULL, NULL, NULL), -- Pregled pulmologa
('lung-ultrasound', NULL, NULL, NULL), -- Ultrazvuk pluća
-- ── REUMATOLOGIJA — /reumatologija/ ───────────────────────────────────────
('rheumatologist-examination', NULL, NULL, NULL), -- Pregled reumatologa
('joint-and-soft-tissue-ultrasound', NULL, NULL, NULL), -- Ultrazvuk zglobova i mekih tkiva
-- ── HEMATOLOGIJA — /hematologija/ ─────────────────────────────────────────
('hematologist-examination', NULL, NULL, NULL), -- Hematološki pregled
-- ── ENDOKRINOLOGIJA — /endokrinologija/ ───────────────────────────────────
('endocrinologist-examination', NULL, NULL, NULL), -- Endokrinološki pregled
('thyroid-ultrasound', NULL, NULL, NULL), -- Ultrazvuk štitaste žlijezde
-- ── NEUROLOGIJA — /neurologija/ «Neurološke usluge u poliklinici AK MEDICA» ───
('first-neurologist-examination', NULL, NULL, NULL), -- Neurološki pregled
('doppler-neck-blood-vessels', NULL, NULL, NULL), -- Color Doppler krvnih sudova vrata
('electromyoneurography-emng', NULL, NULL, NULL), -- Elektromioneurografija (EMNG)
('electroencephalography', NULL, NULL, NULL), -- Elektroencefalografija (EEG)
-- ── ALERGOLOGIJA — /alergologija/ ─────────────────────────────────────────
('allergist-examination', NULL, NULL, NULL), -- Alergološki pregled
-- ── UROLOGIJA — /urologija/ «Urološke usluge u poliklinici AK MEDICA» ─────
('urologist-examination', NULL, NULL, NULL), -- Urološki pregled
('urinary-tract-ultrasound', NULL, NULL, NULL), -- Ultrazvučni urološki pregled — «Ultrazvuk bubrega, mokraćne bešike i prostate»
('testicular-ultrasound', NULL, NULL, NULL), -- Ultrazvučni urološki pregled — «Ultrazvuk muškog reproduktivnog sistema» (testisi, epididimis)
-- ── TERAPIJA BOLA — /terapija-bola/ «Usluge u okviru terapije bola u poliklinici AK MEDICA» ───
('pain-medicine-subspecialist-examination', NULL, NULL, NULL), -- SPECIJALISTIČKI PREGLED ZA TERAPIJU BOLA
('medication-infiltration', NULL, NULL, NULL), -- Invazivne procedure – … infiltracije
('epidural-steroid-injection-for-lumbar-syndrome', NULL, NULL, NULL), -- Invazivne procedure – … epiduralne injekcije (единственная запись каталога про эпидуральную инъекцию)
('tens-therapy', NULL, NULL, NULL), -- Neinvazivne procedure – TENS (transkutana električna nervna stimulacija)
('acupuncture', NULL, NULL, NULL), -- Neinvazivne procedure – … akupunktura
-- ── ULTRAZVUČNA DIJAGNOSTIKA — отдельные страницы услуг ───────────────────
('neck-ultrasound', NULL, NULL, NULL), -- /ultrazvuk-vrata/ ULTRAZVUK VRATA
('ultrasound-axilla-and-groin', NULL, NULL, NULL), -- /ultrazvuk-pazusnih-jama-aksila/ ULTRAZVUK PAZUŠNIH JAMA (AKSILA) + ULTRAZVUK PREPONSKE (INGVINALNE) REGIJE
('doppler-lower-extremity-blood-vessels', NULL, NULL, NULL), -- /color-doppler-krvnih-sudova-donjih-ekstremiteta/ COLOR DOPPLER … DONJIH EKSTREMITETA
('doppler-upper-extremity-blood-vessels', NULL, NULL, NULL), -- та же страница: COLOR DOPPLER KRVNIH SUDOVA GORNJIH EKSTREMITETA
-- ── PSIHIJATRIJA — /psihijatrija/ «Psihijatrijske usluge u poliklinici AK MEDICA» ───
('first-psychiatrist-examination', NULL, NULL, NULL), -- Psihijatrijski pregled
('individual-supportive-psychotherapy-and-counseling', NULL, NULL, NULL); -- Individualno savjetovanje i terapija

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_akmedica_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_akmedica_services t
JOIN medical_services ms ON ms.slug = t.slug
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_akmedica_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 42 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 1 новых записей каталога, у каждой категория и специальность.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties sp WHERE sp.medical_service_id = ms.id) AS specs
FROM medical_services ms WHERE ms.slug IN ('endoscopic-submucosal-dissection-esd');

DROP TEMPORARY TABLE IF EXISTS tmp_akmedica_services;

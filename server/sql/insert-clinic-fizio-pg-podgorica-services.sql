-- ═══════════════════════════════════════════════════════════════════════════
-- Fizio PG (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-fizio-pg-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-fizio-pg-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/fizio-pg-podgorica.json.
--
-- Услуг: 13, с ценой: 0. Новых записей каталога: 2 (physiotherapist-examination, magnetophoresis) —
-- дублируются в data/clinic-imports/_wave2c-new-catalog-P.json для сверки координатором.
-- is_price_outdated не ставится (решение юзера 2026-10-08).
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены обновляются
-- ON DUPLICATE KEY UPDATE, лишние услуги и привязки врач↔услуга прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJCU-J5kLrTRMRvx5Ou2CKSfo' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'fizio-pg-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-fizio-pg-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- Категория 5 = PHYSIOTHERAPY; специальность 42 = PHYSICAL_MEDICINE (авто-привязка кат. 5).
-- ═══════════════════════════════════════════════════════════════

-- Осмотр физиотерапевта (не врача): Fizio Centar Nikšić — «Pregled obuhvata komunikaciju pacijenta i terapeuta, upoznavanje sa problemom, testiranja kroz određene vježbe, određivanje protokola, a trajanje pregleda je od 45 min do 1h»; Fizio PG — «Specijalistički pregled — Detaljna procjena i individualni plan tretmana» (в штате только физиотерапевты). В каталоге есть осмотры физиатра (врача), осмотра физиотерапевта нет. sort_order = 1, как у первичных осмотров.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'physiotherapist-examination', 'Physiotherapist Examination', 'Pregled fizioterapeuta', 'Преглед физиотерапеута',
	'Осмотр физиотерапевта', 'Physiotherapeutische Untersuchung', 'Fizyoterapist muayenesi', 1
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'physiotherapist-examination' OR name_en = 'Physiotherapist Examination');

-- Fizio PG «Magnetoforeza — Sofisticirana fizio-estetska terapija…». Введение препарата магнитным полем (по аналогии с Electrophoresis / Phonophoresis), в каталоге нет; Magnetic Therapy — без препарата.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'magnetophoresis', 'Magnetophoresis', 'Magnetoforeza', 'Магнетофореза',
	'Магнитофорез', 'Magnetophorese', 'Manyetoforez', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'magnetophoresis' OR name_en = 'Magnetophoresis');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN (
	'physiotherapist-examination',
	'magnetophoresis'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN (
	'physiotherapist-examination',
	'magnetophoresis'
);

-- Синонимы: новые записи + бренды и формулировки сайтов к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Fizioterapeutska procjena', 'sr' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Физиотерапеутска процјена', 'sr-cyrl' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Physiotherapy Assessment', 'en' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Консультация физиотерапевта', 'ru' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Physiotherapeutischer Befund', 'de' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Fizyoterapi değerlendirmesi', 'tr' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'INDIBA', 'en' FROM medical_services WHERE slug = 'tecar-therapy'
UNION ALL SELECT id, 'INDIBA', 'sr' FROM medical_services WHERE slug = 'tecar-therapy'
UNION ALL SELECT id, 'INDIBA терапия', 'ru' FROM medical_services WHERE slug = 'tecar-therapy'
UNION ALL SELECT id, 'K-Laser', 'en' FROM medical_services WHERE slug = 'hilt-laser-therapy'
UNION ALL SELECT id, 'K Laser', 'sr' FROM medical_services WHERE slug = 'hilt-laser-therapy'
UNION ALL SELECT id, 'Compex', 'en' FROM medical_services WHERE slug = 'muscle-electrical-stimulation'
UNION ALL SELECT id, 'Compex', 'sr' FROM medical_services WHERE slug = 'muscle-electrical-stimulation'
UNION ALL SELECT id, 'MLS laser', 'en' FROM medical_services WHERE slug = 'laser-therapy'
UNION ALL SELECT id, 'MLS laser', 'sr' FROM medical_services WHERE slug = 'laser-therapy'
UNION ALL SELECT id, 'CryoOne', 'en' FROM medical_services WHERE slug = 'thermotherapy-cryotherapy'
UNION ALL SELECT id, 'Krioterapija hladnim vazduhom', 'sr' FROM medical_services WHERE slug = 'thermotherapy-cryotherapy'
UNION ALL SELECT id, 'Криотерапија хладним ваздухом', 'sr-cyrl' FROM medical_services WHERE slug = 'thermotherapy-cryotherapy'
UNION ALL SELECT id, 'Криотерапия холодным воздухом', 'ru' FROM medical_services WHERE slug = 'thermotherapy-cryotherapy'
UNION ALL SELECT id, 'Kinetec', 'en' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'Artromot', 'en' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'CPMotion', 'en' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'Kinetec', 'sr' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'Артромот', 'ru' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'CPM-терапия', 'ru' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'Motorschiene', 'de' FROM medical_services WHERE slug = 'exercises-on-equipment-pulley-ergocycle-cpm-suspension'
UNION ALL SELECT id, 'Super induktivni sistem', 'sr' FROM medical_services WHERE slug = 'super-inductive-system-therapy'
UNION ALL SELECT id, 'Супер индуктивни систем', 'sr-cyrl' FROM medical_services WHERE slug = 'super-inductive-system-therapy'
UNION ALL SELECT id, 'BTL SIS', 'en' FROM medical_services WHERE slug = 'super-inductive-system-therapy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_pg_podgorica;
CREATE TEMPORARY TABLE tmp_fizio_pg_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_fizio_pg_podgorica (slug, price, price_min, price_max) VALUES
('physiotherapist-examination', NULL, NULL, NULL), -- Specijalistički pregled — «Detaljna procjena i individualni plan tretmana» (naslovna; u timu samo specijalisti primijenjene fizioterapije i fizioterapeuti)
('tecar-therapy', NULL, NULL, NULL), -- INDIBA terapija — «Svjetski lider u radiofrekventnoj terapiji. Ubrzano liječenje, oporavak mišića, ublažavanje bolova i poboljšanje tonusa kože.»
('hilt-laser-therapy', NULL, NULL, NULL), -- K Laser — «Napredni terapijski laser klase IV koji koristi infracrvenu i blisko-infracrvenu svjetlost…»
('laser-therapy', NULL, NULL, NULL), -- Laser terapija — «Laseri male snage bez izraženog termičkog dejstva…»; Medicinski Laser M-Hi (MLS®) — «…koristi naprednu MLS tehnologiju…»
('muscle-electrical-stimulation', NULL, NULL, NULL), -- Compex terapija — «Vodeća svjetska tehnologija mišićne elektrostimulacije…»; Elektrostimulacija — «…električne impulse za izazivanje mišićne kontrakcije»
('super-inductive-system-therapy', NULL, NULL, NULL), -- BTL SIS – Super Induktivni Sistem — «…fokusirano visoko-intenzivno elektromagnetno polje…»
('shock-wave-therapy', NULL, NULL, NULL), -- ShockWave terapija — «Savremena neinvazivna metoda rehabilitacije radijalnim talasima…»
('mechanical-spinal-traction', NULL, NULL, NULL), -- Trakcija kičme — «Istezanje kičmenog stuba primenom mehaničke sile na specijalnom trakcionom stolu…»
('lymphatic-drainage-complete', NULL, NULL, NULL), -- Limfna drenaža — «Terapija koja poboljšava kretanje limfe, drenažu tkiva i krvotok.» (generic-запись «limfna drenaža» в каталоге — Complete Lymphatic Drainage, синоним «Manual Lymphatic Drainage»)
('magnetophoresis', NULL, NULL, NULL), -- Magnetoforeza — «Sofisticirana fizio-estetska terapija koja nadoknađuje deficit kolagena, poboljšava pokretljivost zglobova i usporava starenje kože.»
('thermotherapy-cryotherapy', NULL, NULL, NULL), -- Enraf-Nonius CryoOne — «Lokalizovani uređaj za terapiju hladnim vazduhom (-30°C do -43°C)…»
('exercises-on-equipment-pulley-ergocycle-cpm-suspension', NULL, NULL, NULL), -- Robot – Kinetec CPM — «Aparat za ranu rehabilitaciju. Pasivni pokreti zglobova koljena, stopala i kuka putem motornog BTL-CPMotion sistema.» (в каталоге CPM = «kinetička šina» в этой записи)
('sports-injury-rehabilitation', NULL, NULL, NULL); -- JSON-LD description: «Pružamo usluge fizioterapije, sportske rehabilitacije, INDIBA terapije, laser terapije i ShockWave tretmana.»

-- Ожидается ПУСТО: slug, не найденные в каталоге.
SELECT t.slug AS unmatched_service
FROM tmp_fizio_pg_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_fizio_pg_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_fizio_pg_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 13 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;


-- Ожидается 2: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(s.specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('physiotherapist-examination', 'magnetophoresis');

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_pg_podgorica;

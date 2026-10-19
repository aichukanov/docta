-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Stefanija Dental (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-stefanija-dental-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stefanija-dental-podgorica-services.sql
--
-- Источник: https://stefanijadental.me/ (me), 7 страниц услуг + главная + O nama, wp-json, curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные на страницах услуг. Пояснения без процедуры и расплывчатые пункты — в excluded записи импорта.
--
-- Итого: 29 услуг (0 с ценой), новых записей каталога — 2 (gummy-smile-correction, gingivitis-treatment). Анализов нет.
-- Привязок врач↔услуга: 8.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJGfZDbdTrTRMRgSNa8wqx50s' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'stefanija-dental-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-stefanija-dental-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- stefanijadental.me /parodontologija/: «… menadžmentom mekog tkiva i korekcijom gummy smile-a». Метод не назван.
-- В каталоге нет (поиск gummy / gingival smile / «десневая улыбка»). Общая запись. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'gummy-smile-correction', 'Gummy Smile Correction', 'Korekcija gingivalnog osmijeha (gummy smile)', 'Корекција гингивалног осмијеха (gummy smile)',
	'Коррекция «десневой улыбки»', 'Korrektur des Gummy Smile', 'Diş eti gülüşü düzeltme', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'gummy-smile-correction' OR name_en = 'Gummy Smile Correction');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gummy smile', 'en' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gingival smile correction', 'en' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gummy smile korekcija', 'sr' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Korekcija desni pri osmijehu', 'sr' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Корекција десни при осмијеху', 'sr-cyrl' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Десневая улыбка', 'ru' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Коррекция десневой улыбки', 'ru' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zahnfleischlächeln', 'de' FROM medical_services WHERE slug = 'gummy-smile-correction';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gummy smile tedavisi', 'tr' FROM medical_services WHERE slug = 'gummy-smile-correction';

-- stefanijadental.me /parodontologija/: «Bavimo se terapijom gingivitisa, uklanjanjem zubnog kamenca …».
-- В каталоге нет (поиск gingivit); periodontal-scaling-root-planing — пародонтит. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'gingivitis-treatment', 'Gingivitis Treatment', 'Terapija gingivitisa', 'Терапија гингивитиса',
	'Лечение гингивита', 'Gingivitisbehandlung', 'Diş eti iltihabı (gingivitis) tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'gingivitis-treatment' OR name_en = 'Gingivitis Treatment');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Liječenje gingivitisa', 'sr' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Liječenje upale desni', 'sr' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лијечење упале десни', 'sr-cyrl' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gum inflammation treatment', 'en' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лечение воспаления дёсен', 'ru' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Behandlung von Zahnfleischentzündung', 'de' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Diş eti iltihabı tedavisi', 'tr' FROM medical_services WHERE slug = 'gingivitis-treatment';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- teeth-whitening: stefanijadental.me /estetska-stomatologija/: «Izbjeljivanje je moguće u ordinaciji primjenom Flash sistema – za 60 minuta postiže se i do 8 nijansi svjetliji osmijeh». Система отбеливания названа сайтом; по сути это то же ordinacijsko izbjeljivanje (teeth-whitening, как Zoom/Opalescence Boost) — бренд-дубль не заводим, название системы — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Flash izbjeljivanje zuba', 'sr' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Flash избјељивање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Flash teeth whitening', 'en' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Отбеливание Flash', 'ru' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Flash-Bleaching', 'de' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Flash diş beyazlatma', 'tr' FROM medical_services WHERE slug = 'teeth-whitening';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (29)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_sfd_services;
CREATE TEMPORARY TABLE tmp_x_sfd_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_sfd_services (slug, price, price_min, price_max) VALUES
	('initial-dental-examination-and-medical-record-opening', NULL, NULL, NULL), -- /o-nama/: «Poseban značaj pridajemo prvom stomatološkom pregledu. On obuhvata klinički pregled, anamnezu, RTG dijagnostiku, fotografisanje i 3D skeniranje zuba»
	('follow-up-dental-examination', NULL, NULL, NULL), -- Главная, «Svakodnevne procedure»: «Redovni stomatološki pregledi — Kontrole koje omogućavaju pravovremenu dijagnostiku»
	('dental-calculus-removal-and-air-flow', NULL, NULL, NULL), -- /opsta-stomatologija/: «uklanjanje zubnog kamenca i pjeskarenje»
	('composite-filling', NULL, NULL, NULL), -- /opsta-stomatologija/: «kompozitne plombe»
	('machine-root-canal-treatment-per-canal', NULL, NULL, NULL), -- /opsta-stomatologija/: «mašinsku endodonciju (liječenje kanala korijena zuba)»
	('tooth-build-up', NULL, NULL, NULL), -- /opsta-stomatologija/: «i nadogradnju zuba» — материал/штифт не названы
	('tooth-extraction', NULL, NULL, NULL), -- Главная, «Svakodnevne procedure»: «Vađenje i liječenje zuba — Vađenje ili liječenje zuba uz pažljiv i bezbjedan pristup»
	('all-ceramic-crown', NULL, NULL, NULL), -- /protetika/: «Bezmetalne krunice – prozirne su i prozračne … Čvrsta keramika garantuje dugotrajnost» — материал (цирконий/e.max) не назван → общая keramička krunica
	('ceramic-veneer', NULL, NULL, NULL), -- /protetika/: «Keramičke ljuskice (prep i non-prep) – viniri ili fasete»; /estetska-stomatologija/: «izradu keramičkih ljuskica»
	('no-prep-veneer', NULL, NULL, NULL), -- /protetika/: «(prep i non-prep) … Mogu se izraditi bez brušenja ili uz minimalnu pripremu zuba»
	('metal-ceramic-crown', NULL, NULL, NULL), -- /protetika/: «Metalo-keramičke krunice – tradicionalne krunice koje imaju metalnu osnovu obloženu keramikom»
	('ceramic-inlay-onlay', NULL, NULL, NULL), -- /protetika/: «Keramičke plombe – trajnije i otpornije od kompozitnih i amalgamskih ispuna … Izrađuju se od iste keramike kao i krunice»
	('implant-overdenture-with-locators', NULL, NULL, NULL), -- /protetika/: «Izrađujemo i … proteze na implantatima» — съёмный протез на имплантах; тип замков не назван, единственная общая запись (как dental-smile-tivat)
	('dental-implant-placement', NULL, NULL, NULL), -- /implantologija/: «terapija izbora je ugradnja implantata na mjestu nedostatka … Ugradnja jednog implantata traje oko 20 minuta»; /oralna-hirurgija/: «implantacija»
	('surgical-tooth-extraction', NULL, NULL, NULL), -- /oralna-hirurgija/: «hirurško vađenje zuba»
	('impacted-tooth-extraction', NULL, NULL, NULL), -- /oralna-hirurgija/: «vađenje impaktiranih zuba»
	('apicoectomy', NULL, NULL, NULL), -- /oralna-hirurgija/: «apikotomija (resekcija vrha korijena)»
	('gingivectomy', NULL, NULL, NULL), -- /oralna-hirurgija/: «gingivektomija»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- /oralna-hirurgija/: «režanj operacije»; /parodontologija/: «režanj operacijama»
	('bone-augmentation', NULL, NULL, NULL), -- /oralna-hirurgija/: «augmentacija kosti» — материал не назван
	('dental-sinus-lift', NULL, NULL, NULL), -- /oralna-hirurgija/: «sinus lift»
	('gingivitis-treatment', NULL, NULL, NULL), -- /parodontologija/: «Bavimo se terapijom gingivitisa» (НОВАЯ запись) (НОВАЯ запись каталога)
	('periodontal-pocket-treatment', NULL, NULL, NULL), -- /parodontologija/: «obradom parodontalnih džepova»
	('gummy-smile-correction', NULL, NULL, NULL), -- /parodontologija/: «korekcijom gummy smile-a» (НОВАЯ запись) (НОВАЯ запись каталога)
	('intraoral-x-ray', NULL, NULL, NULL), -- /rtg-dijagnostika/: «digitalne retroalveolarne snimke (ciljani snimak jednog zuba)»
	('panoramic-x-ray', NULL, NULL, NULL), -- /rtg-dijagnostika/: «digitalne panoramske 2D ortopan snimke svih zuba, zglobova i sinusa»
	('teeth-whitening', NULL, NULL, NULL), -- /estetska-stomatologija/: «Izbjeljivanje je moguće u ordinaciji primjenom Flash sistema – za 60 minuta» → синоним Flash
	('home-teeth-whitening', NULL, NULL, NULL), -- /estetska-stomatologija/: «izrađujemo individualne folije za kućno izbjeljivanje u trajanju od 5 do 7 dana»
	('internal-bleaching-of-devitalized-tooth', NULL, NULL, NULL); -- /estetska-stomatologija/: «izbjeljivanje avitalnog zuba»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_sfd_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_sfd_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_sfd_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 8
-- Врач на сайте один — dr Stefanija Pantović, специалист оральной хирургии; /dr-stefanija/: «posebno usmjerena na implantologiju, estetsku
-- stomatologiju, protetsko-hirurške tretmane». Привязаны хирургические и имплантологические услуги (по специальности); остальное сайт по врачам
-- не распределяет — без привязок.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_x_sfd_ds;
CREATE TEMPORARY TABLE tmp_x_sfd_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_x_sfd_ds (doctor_slug, service_slug) VALUES
	('stefanija-pantovic', 'dental-implant-placement'),
	('stefanija-pantovic', 'surgical-tooth-extraction'),
	('stefanija-pantovic', 'impacted-tooth-extraction'),
	('stefanija-pantovic', 'apicoectomy'),
	('stefanija-pantovic', 'gingivectomy'),
	('stefanija-pantovic', 'flap-surgery-periodontal'),
	('stefanija-pantovic', 'bone-augmentation'),
	('stefanija-pantovic', 'dental-sinus-lift');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_x_sfd_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_x_sfd_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 29, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 8 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Новые записи каталога: категории, специальности, синонимы.
SELECT ms.id, ms.slug, ms.name_sr,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specs,
	(SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
FROM medical_services ms WHERE ms.slug IN ('gummy-smile-correction', 'gingivitis-treatment');

DROP TEMPORARY TABLE IF EXISTS tmp_x_sfd_services;
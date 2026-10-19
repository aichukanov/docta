-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija DentArt (Tivat) — услуги и цены
-- Run ПОСЛЕ server/sql/insert-clinic-dentart-tivat.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dentart-tivat-services.sql
--
-- Источник: https://dentart.me/cenovnik/ (в меню нет; 46 строк в €; wp-json modified
-- 2022-03-19, © 2022) + главная и страницы /estetska-stomatologija/, /mezoterapija/,
-- /hijaluronski-fileri/, /botox/, /laserska-epilacija/ (позиции без цены), curl 2026-10-08.
--
-- «plomba 1/2/3 površine» без материала → dental-filling-* (решение юзера 2026-10-08:
-- композит только там, где прайс его называет). «izbjeljivanje zuba po vilici» → новая
-- teeth-whitening-per-arch (способ не назван).
--
-- Все 46 строк сопоставлены. Несколько строк → одна запись: удаление молочного зуба
-- с анестезией 15 / без 5 → 5–15; резекция корня одно-/двухкорневого 100–120.
-- «plastika frenuluma, plike 60 €» — одна строка на две операции → две записи по 60 €.
-- Эстетика (мезотерапия, филлеры, ботокс, эпиляция) — существующие записи каталога,
-- без цены: акционные цены с главной («MEZOTERAPIJA LICA – 20 eura», «HIJALURONSKI
-- FILERI 1ml – 150 eura», «20% popusta na profesionalno čišćenje») не берём.
-- «Stomatološki pregled i stručna dijagnostika se ne naplaćuju» → Dental Consultation 0.00.
--
-- Итого в клинике: 52 услуг (46 с ценой, 6 без цены), из них новых в каталоге: 6.
-- Анализов нет — блока lab_tests в файле нет. Привязок врач↔услуга нет: сайт не
-- приписывает услуги конкретным врачам.
-- is_price_outdated не ставится (решение юзера, дата прайса — в записи импорта).
--
-- Самоисправляющийся: канонический список (slug + цена) лежит во временной
-- таблице, по ней идут upsert и DELETE лишнего. Повторный прогон приводит клинику
-- ровно к этому списку и этим ценам.
-- ⚠️ Услуги и цены, добавленные клинике вручную (админка, кабинет клиники),
-- следующий прогон снесёт/перезапишет — вносить их сюда.
-- Сопоставление «строка прайса → slug» с обоснованиями — data/clinic-imports/dentart-tivat.json.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJFyjGiygyTBMROATKetg5SU8';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dentart-tivat' LIMIT 1));

-- Без клиники дальше смысла нет: INSERT отфильтруется по @clinic_id IS NOT NULL.
SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dentart-tivat.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (идемпотентно по slug)
-- Обоснование каждой — в комментарии. Определения общие для файлов агента A
-- волны 1: если запись уже заведена другим файлом, INSERT пропускается.
-- ═══════════════════════════════════════════════════════════════

-- Teeth Whitening per Arch: DentArt «izbjeljivanje zuba po vilici 100 €»: способ (домашнее/кабинетное) не назван. В каталоге «по челюсти» есть только Home Teeth Whitening per Arch и In-Office Teeth Whitening Single Arch — оба приписывают способ.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'teeth-whitening-per-arch', 'Teeth Whitening per Arch', 'Izbjeljivanje zuba po vilici', 'Избјељивање зуба по вилици',
	'Отбеливание зубов (одна челюсть)', 'Zahnaufhellung pro Kiefer', 'Çene başına diş beyazlatma', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'teeth-whitening-per-arch');

-- Pulpitis Treatment per Canal: DentArt «pulpit po kanalu 15 €». В каталоге пульпит по корням (с NiTi/машинный) или без единицы; цена за канал в generic Pulpitis Treatment ввела бы в заблуждение.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pulpitis-treatment-per-canal', 'Pulpitis Treatment per Canal', 'Liječenje pulpitisa po kanalu', 'Лијечење пулпитиса по каналу',
	'Лечение пульпита (за один канал)', 'Pulpitisbehandlung pro Kanal', 'Kanal başına pulpitis tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pulpitis-treatment-per-canal');

-- Dental Gangrene Treatment per Canal: DentArt «gangrene po kanalu 20 €». В каталоге гангрена по корням (1/2/3) — канал ≠ корень.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-gangrene-treatment-per-canal', 'Dental Gangrene Treatment per Canal', 'Liječenje gangrene po kanalu', 'Лијечење гангрене по каналу',
	'Лечение гангрены пульпы (за один канал)', 'Behandlung der Pulpagangrän pro Kanal', 'Kanal başına diş gangreni tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-gangrene-treatment-per-canal');

-- Dental Air Polishing: DentArt «pjeskarenje svih zuba 20 €» отдельно от «skidanje kamenca». Dental Calculus Removal and Air-Flow включает удаление камня.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-air-polishing', 'Dental Air Polishing', 'Pjeskarenje zuba', 'Пјескарење зуба',
	'Пескоструйная чистка зубов', 'Pulverstrahlreinigung der Zähne', 'Hava ile diş parlatma (air polishing)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-air-polishing');

-- Dental Implant with Abutment: DentArt «ugradnja implanta + nadogradnja 800 €» — пакет. Цена в Dental Implant Placement (только имплант) завысила бы позицию.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-implant-with-abutment', 'Dental Implant with Abutment', 'Ugradnja implanta sa nadogradnjom', 'Уградња импланта са надоградњом',
	'Имплантат с абатментом', 'Zahnimplantat mit Abutment', 'Abutmentli diş implantı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-implant-with-abutment');

-- Complete Denture with Cast Metal Base: DentArt «totalna skeletirana proteza 400 €» («metalom ojačane akrilatne proteze» на /stomatoloske-usluge/). Skeletal Partial Denture — частичный протез.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'complete-denture-with-cast-metal-base', 'Complete Denture with Cast Metal Base', 'Totalna skeletirana proteza', 'Тотална скелетирана протеза',
	'Полный съёмный протез на литом металлическом базисе', 'Totalprothese mit Metallbasis', 'Döküm metal kaideli tam protez', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'complete-denture-with-cast-metal-base');

-- Категория 20 = DENTISTRY
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 20 FROM medical_services WHERE slug IN (
	'teeth-whitening-per-arch',
	'pulpitis-treatment-per-canal',
	'dental-gangrene-treatment-per-canal',
	'dental-air-polishing',
	'dental-implant-with-abutment',
	'complete-denture-with-cast-metal-base'
);

-- Специальность 74 = ORAL_SURGERY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 74 FROM medical_services WHERE slug IN (
	'dental-implant-with-abutment'
);

-- Специальность 78 = DENTISTRY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 78 FROM medical_services WHERE slug IN (
	'teeth-whitening-per-arch',
	'pulpitis-treatment-per-canal',
	'dental-gangrene-treatment-per-canal',
	'dental-air-polishing',
	'dental-implant-with-abutment',
	'complete-denture-with-cast-metal-base'
);

-- Синонимы: формулировки прайса, бытовые названия, бренды. sr дублируется в sr-cyrl.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Pulpit po kanalu', 'sr' FROM medical_services WHERE slug = 'pulpitis-treatment-per-canal'
UNION ALL SELECT id, 'Пулпит по каналу', 'sr-cyrl' FROM medical_services WHERE slug = 'pulpitis-treatment-per-canal'
UNION ALL SELECT id, 'Gangrena po kanalu', 'sr' FROM medical_services WHERE slug = 'dental-gangrene-treatment-per-canal'
UNION ALL SELECT id, 'Гангрена по каналу', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-gangrene-treatment-per-canal'
UNION ALL SELECT id, 'Peskiranje zuba', 'sr' FROM medical_services WHERE slug = 'dental-air-polishing'
UNION ALL SELECT id, 'Пескирање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-air-polishing'
UNION ALL SELECT id, 'Teeth Sandblasting', 'en' FROM medical_services WHERE slug = 'dental-air-polishing'
UNION ALL SELECT id, 'Implant sa nadogradnjom', 'sr' FROM medical_services WHERE slug = 'dental-implant-with-abutment'
UNION ALL SELECT id, 'Имплант са надоградњом', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-implant-with-abutment';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ
-- Рядом с каждой — строка прайса/страницы, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_dentart_services;
CREATE TEMPORARY TABLE tmp_dentart_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_dentart_services (slug, price, price_min, price_max) VALUES
	('panoramic-x-ray', 20.00, NULL, NULL), -- ortopan snimak — 20.00 €
	('intraoral-x-ray', 10.00, NULL, NULL), -- retroalveolarni snimak — 10.00 €
	('dental-first-aid', 10.00, NULL, NULL), -- prva pomoć — 10.00 €
	('pulpitis-treatment-per-canal', 15.00, NULL, NULL), -- pulpit po kanalu — 15.00 €
	('dental-gangrene-treatment-per-canal', 20.00, NULL, NULL), -- gangrene po kanalu — 20.00 €
	('deep-caries-treatment', 10.00, NULL, NULL), -- liječenje dubokog karijesa — 10.00 €
	('dental-filling-single-surface', 25.00, NULL, NULL), -- plomba 1 površina — 25.00 €
	('dental-filling-two-surfaces', 30.00, NULL, NULL), -- plomba 2 površine — 30.00 €
	('dental-filling-three-surfaces', 35.00, NULL, NULL), -- plomba 3 površine — 35.00 €
	('internal-bleaching-of-devitalized-tooth', 20.00, NULL, NULL), -- izbjeljivanje devitaliziranog zuba — 20.00 €
	('teeth-whitening-per-arch', 100.00, NULL, NULL), -- izbjeljivanje zuba po vilici — 100.00 €
	('primary-tooth-pulp-treatment', 10.00, NULL, NULL), -- pulpit mliječnog zuba — 10.00 €
	('infected-tooth-drainage', 5.00, NULL, NULL), -- drenaža mliječnog zuba — 5.00 €
	('composite-filling-on-primary-tooth', 20.00, NULL, NULL), -- plomba na mliječnom zubu — 20.00 €
	('primary-tooth-extraction', 5.00, NULL, 15.00), -- vađenje mliječnog zuba sa anestezijijom — 15.00 € | vađenje mliječnog zuba bez anestezije — 5.00 €
	('dental-fissure-sealant', 10.00, NULL, NULL), -- zalivanje fisura — 10.00 €
	('orthodontic-removable-plate-appliance', 200.00, NULL, NULL), -- mobilni aparat po vilici — 200.00 €
	('orthodontic-functional-monoblock-appliance', 400.00, NULL, NULL), -- monoblok — 400.00 €
	('fixed-orthodontic-braces-per-arch', 700.00, NULL, NULL), -- fiksni aparat po vilici — 700.00 €
	('custom-dental-guard', 50.00, NULL, NULL), -- zaštitni splint — 50.00 €
	('plaque-and-calculus-removal', 25.00, NULL, NULL), -- skidanje kamenca sa svih zuba — 25.00 €
	('soft-dental-deposit-removal', 15.00, NULL, NULL), -- skidanje mekih naslaga — 15.00 €
	('dental-air-polishing', 20.00, NULL, NULL), -- pjeskarenje svih zuba — 20.00 €
	('periodontal-surgical-therapy-flap-surgery-per-tooth', 60.00, NULL, NULL), -- hirurška obrada parodontalnog džepa — 60.00 €
	('periodontal-pocket-treatment', 10.00, NULL, NULL), -- obrada parodontalnog džepa — 10.00 €
	('tooth-extraction', 20.00, NULL, NULL), -- vađenje zuba sa anestezijom — 20.00 €
	('tooth-extraction-complex', 35.00, NULL, NULL), -- komplikovano vađenje zuba — 35.00 €
	('impacted-tooth-extraction', 110.00, NULL, NULL), -- vađenje impaktiranog zuba — 110.00 €
	('apicoectomy-with-orthograde-root-canal-filling', 100.00, NULL, 120.00), -- resekcija jednok. zuba sa punjenjem kanala — 100.00 € | resekcija dvokor. zuba sa punjenjem kanala — 120.00 €
	('frenectomy', 60.00, NULL, NULL), -- plastika frenuluma, plike — 60.00 €
	('oral-mucosal-fold-correction', 60.00, NULL, NULL), -- plastika frenuluma, plike — 60.00 €
	('alveolar-ridge-leveling', 60.00, NULL, NULL), -- nivelacija grebena — 60.00 €
	('intraoral-abscess-incision', 15.00, NULL, NULL), -- incizija abscesa — 15.00 €
	('flap-surgery-periodontal', 400.00, NULL, NULL), -- režanj operacija po vilici — 400.00 €
	('dental-implant-with-abutment', 800.00, NULL, NULL), -- ugradnja implanta + nadogradnja — 800.00 €
	('partial-acrylic-denture', 200.00, NULL, NULL), -- parcijalna akrilatna proteza — 200.00 €
	('complete-acrylic-denture', 250.00, NULL, NULL), -- totalna akrilatna proteza — 250.00 €
	('skeletal-partial-denture', 350.00, NULL, NULL), -- parcijalna skeletirana proteza — 350.00 €
	('complete-denture-with-cast-metal-base', 400.00, NULL, NULL), -- totalna skeletirana proteza — 400.00 €
	('partial-flexible-denture', 280.00, NULL, NULL), -- parcijalna fleksibilna proteza — 280.00 €
	('complete-flexible-denture', 320.00, NULL, NULL), -- totalna fleksibilna proteza — 320.00 €
	('metal-ceramic-crown', 100.00, NULL, NULL), -- metalokeramička krunica — 100.00 €
	('all-ceramic-crown', 200.00, NULL, NULL), -- bezmetalna krunica — 200.00 €
	('ceramic-veneer', 250.00, NULL, NULL), -- bezmetalna faseta — 250.00 €
	('temporary-crown', 10.00, NULL, NULL), -- privremena kruna — 10.00 €
	('dental-consultation', 0.00, NULL, NULL), -- «Stomatološki pregled i stručna dijagnostika se ne naplaćuju»
	('home-teeth-whitening', NULL, NULL, NULL), -- «Izbjeljivanje se može izvoditi kod kuće ili u ordinaciji»
	('dental-jewelry-application', NULL, NULL, NULL), -- «Zubni nakit … najčešćeg cirkona»
	('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- Mezoterapija
	('hyaluronic-acid-filler', NULL, NULL, NULL), -- Hijaluronski fileri
	('botox-injection', NULL, NULL, NULL), -- Botox
	('laser-hair-removal', NULL, NULL, NULL); -- Laserska epilacija

-- Страховка: slug, которого нет в каталоге (опечатка, запись переименована на
-- проде). Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_dentart_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: СИНХРОНИЗАЦИЯ clinic_medical_services
-- ═══════════════════════════════════════════════════════════════

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_dentart_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dentart_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 52, with_price = 46.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_sr, cms.price, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_sr;

-- Новые записи каталога: ожидается 6 строк, у каждой категория и специальность.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	GROUP_CONCAT(DISTINCT r.medical_service_category_id) AS categories,
	GROUP_CONCAT(DISTINCT s.specialty_id) AS specialties
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_services_specialties s ON s.medical_service_id = ms.id
WHERE ms.slug IN (
	'teeth-whitening-per-arch',
	'pulpitis-treatment-per-canal',
	'dental-gangrene-treatment-per-canal',
	'dental-air-polishing',
	'dental-implant-with-abutment',
	'complete-denture-with-cast-metal-base'
)
GROUP BY ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_dentart_services;

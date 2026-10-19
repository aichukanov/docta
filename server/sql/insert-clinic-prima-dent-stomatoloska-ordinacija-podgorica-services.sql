-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Prima Dent (Podgorica) — услуги и цены
-- Run ПОСЛЕ server/sql/insert-clinic-prima-dent-stomatoloska-ordinacija-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-prima-dent-stomatoloska-ordinacija-podgorica-services.sql
--
-- Источник: https://www.primadent.me/cjenovnik/ (HTML-таблица; wp-json modified 2023-07-17)
-- + страницы /usluge/* (2014–2015, позиции без цены), curl 2026-10-08.
--
-- 32 строки с ценой + 2 «uključeno u cijenu»: «pregled ortodonta i mišljenje» →
-- Orthodontic Consultation без цены; «pregled hirurga i mišljenje» — в «Спорные» (приёма
-- орального хирурга в каталоге нет). «podlaganje proteze 30 €» — в «Спорные» (прямое или
-- непрямое — не указано), не заведена. Итого заведено 31 из 32 строк с ценой.
-- Решение юзера 2026-10-08: «(bijela) plomba» = композит → composite-filling-single-surface /
-- composite-filling-two-surfaces (заведены в файле Lopičić; здесь — та же идемпотентная
-- вставка по slug, если этот файл применят раньше).
-- Договор с ФЗОЦГ (бесплатно для детей до 18, студентов до 26, беременных, пенсионеров
-- 65+) ценами не моделируется: прайс — для самоплатящих.
--
-- Итого в клинике: 39 услуг (31 с ценой, 8 без цены), из них новых в каталоге: 2.
-- Анализов нет — блока lab_tests в файле нет. Привязок врач↔услуга нет: сайт не
-- приписывает услуги конкретным врачам.
-- is_price_outdated не ставится (решение юзера, дата прайса — в записи импорта).
--
-- Самоисправляющийся: канонический список (slug + цена) лежит во временной
-- таблице, по ней идут upsert и DELETE лишнего. Повторный прогон приводит клинику
-- ровно к этому списку и этим ценам.
-- ⚠️ Услуги и цены, добавленные клинике вручную (админка, кабинет клиники),
-- следующий прогон снесёт/перезапишет — вносить их сюда.
-- Сопоставление «строка прайса → slug» с обоснованиями — data/clinic-imports/prima-dent-stomatoloska-ordinacija-podgorica.json.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJx7QUgULrTRMR-qolqxNm6Yo';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'prima-dent-stomatoloska-ordinacija-podgorica' LIMIT 1));

-- Без клиники дальше смысла нет: INSERT отфильтруется по @clinic_id IS NOT NULL.
SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-prima-dent-stomatoloska-ordinacija-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (идемпотентно по slug)
-- Обоснование каждой — в комментарии. Определения общие для файлов агента A
-- волны 1: если запись уже заведена другим файлом, INSERT пропускается.
-- ═══════════════════════════════════════════════════════════════

-- Composite Filling Single Surface: Решение юзера 2026-10-08: прайс прямо называет материал (Lopičić «Kompozitni ispun I površinski», Prima Dent «jednopovršinska (bijela) plomba») — нужен generic-композит по поверхностям. В каталоге композит либо без поверхностей (Composite Filling), либо брендовый (Ivoclar EvoCeram). Категории/специальности — как у dental-filling-*.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'composite-filling-single-surface', 'Composite Filling Single Surface', 'Kompozitni ispun – jedna površina', 'Композитни испун – једна површина',
	'Композитная пломба (одна поверхность)', 'Kompositfüllung einflächig', 'Tek yüzeyli kompozit dolgu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'composite-filling-single-surface');

-- Composite Filling Two Surfaces: Решение юзера 2026-10-08: Lopičić «Kompozitni ispun II površinski», Prima Dent «dvopovršinska (bijela) plomba». См. composite-filling-single-surface.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'composite-filling-two-surfaces', 'Composite Filling Two Surfaces', 'Kompozitni ispun – dvije površine', 'Композитни испун – двије површине',
	'Композитная пломба (две поверхности)', 'Kompositfüllung zweiflächig', 'İki yüzeyli kompozit dolgu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'composite-filling-two-surfaces');

-- Категория 20 = DENTISTRY
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 20 FROM medical_services WHERE slug IN (
	'composite-filling-single-surface',
	'composite-filling-two-surfaces'
);

-- Категория 35 = PEDIATRIC_DENTISTRY
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 35 FROM medical_services WHERE slug IN (
	'composite-filling-single-surface',
	'composite-filling-two-surfaces'
);

-- Специальность 78 = DENTISTRY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 78 FROM medical_services WHERE slug IN (
	'composite-filling-single-surface',
	'composite-filling-two-surfaces'
);

-- Специальность 87 = PEDIATRIC_DENTISTRY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 87 FROM medical_services WHERE slug IN (
	'composite-filling-single-surface',
	'composite-filling-two-surfaces'
);

-- Синонимы: формулировки прайса, бытовые названия, бренды. sr дублируется в sr-cyrl.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Kompozitni ispun I površinski', 'sr' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Композитни испун И површински', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Jednopovršinska bijela plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Једноповршинска бијела пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Kompozitni ispun II površinski', 'sr' FROM medical_services WHERE slug = 'composite-filling-two-surfaces'
UNION ALL SELECT id, 'Композитни испун ИИ површински', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-two-surfaces'
UNION ALL SELECT id, 'Dvopovršinska bijela plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling-two-surfaces'
UNION ALL SELECT id, 'Двоповршинска бијела пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-two-surfaces';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ
-- Рядом с каждой — строка прайса/страницы, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_primadent_services;
CREATE TEMPORARY TABLE tmp_primadent_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_primadent_services (slug, price, price_min, price_max) VALUES
	('dental-consultation', 10.00, NULL, NULL), -- stomatološki pregled — 10 €
	('composite-filling-single-surface', 35.00, NULL, NULL), -- jednopovršinska (bijela) plomba — 35 €
	('composite-filling-two-surfaces', 40.00, NULL, NULL), -- dvopovršinska (bijela) plomba — 40 €
	('deep-caries-treatment', 30.00, NULL, NULL), -- liječenje (dubokog karijesa) caries profunda — 30 €
	('endodontic-treatment-single-canal-tooth', 50.00, NULL, NULL), -- liječenje (vađenje živca) jednokorijenog zuba — 50 €
	('endodontic-treatment-multi-canal-tooth', 70.00, NULL, NULL), -- liječenje (vađenje živca) višekorijenog zuba — 70 €
	('conservative-treatment-of-periapical-process-and-dental-gangrene', 80.00, NULL, NULL), -- liječenje gangrene — 80 €
	('tooth-extraction', 25.00, NULL, NULL), -- vađenje zuba — 25 €
	('tooth-extraction-complex', 40.00, NULL, NULL), -- komplikovano vađenje zuba — 40 €
	('primary-tooth-extraction', 20.00, NULL, NULL), -- vađenje mliječnog zuba — 20 €
	('dental-fissure-sealant', 15.00, NULL, NULL), -- zalivanje fisura — 15 €
	('heavy-dental-scaling-and-polishing', 30.00, NULL, NULL), -- uklanjanje zubnog kamenca sa poliranjem zuba — 30 €
	('intraoral-x-ray', 10.00, NULL, NULL), -- RTG snimak zuba — 10 €
	('temporary-crown', 20.00, NULL, NULL), -- privremena krunica — 20 €
	('metal-ceramic-crown', 100.00, NULL, 120.00), -- metalo-keramička krunica — 100-120 €
	('cast-post-and-core', 20.00, NULL, NULL), -- livena nadogradnja — 20 €
	('metal-free-zirconia-ceramic-crown', 200.00, NULL, NULL), -- bezmetalna (cirkonijum) krunica — 200 €
	('metal-ceramic-crown-gold', 320.00, NULL, NULL), -- krunica zlato keramika — 320 €
	('complete-acrylic-denture', 250.00, NULL, NULL), -- totalna akrilatna proteza — 250 €
	('partial-acrylic-denture', 250.00, NULL, NULL), -- parcijalna akrilatna proteza — 250 €
	('skeletal-partial-denture', 500.00, NULL, NULL), -- skeletirana (vizil) proteza — 500 €
	('partial-denture-with-precision-attachment', 650.00, NULL, NULL), -- skeletirana (vizil) proteza sa atacmenima — 650 €
	('denture-repair', 30.00, NULL, NULL), -- reparatura proteze — 30 €
	('denture-tooth-addition', 30.00, NULL, NULL), -- dodatak zuba na protezi — 30 €
	('orthodontic-consultation', NULL, NULL, NULL), -- pregled ortodonta i mišljenje — uključeno u cijenu terapije
	('orthodontic-removable-plate-appliance', 220.00, NULL, NULL), -- mobilni aparat — 220 €
	('fixed-orthodontic-braces-per-arch', 500.00, NULL, NULL), -- fiksni aparat — 500 €
	('intraoral-abscess-incision', 20.00, NULL, NULL), -- incizija i drenaža apscesa — 20 €
	('surgical-tooth-extraction', 80.00, NULL, NULL), -- hirurško vađenje zuba — 80€
	('impacted-tooth-extraction', 140.00, NULL, NULL), -- vađenje impaktiranog umnjaka — 140€
	('frenectomy', 60.00, NULL, NULL), -- frenektomija — 60€
	('apicoectomy', 120.00, NULL, NULL), -- apikotomija — 120€
	('root-canal-retreatment', NULL, NULL, NULL), -- «potrebna je revizija endodontskog liječenja … Mašinska endodoncija omogućuje brzu i uspješnu reviziju»
	('topical-fluoride-treatment', NULL, NULL, NULL), -- «Tretmane fluorizacije»
	('teeth-whitening', NULL, NULL, NULL), -- «Izbjeljivanje zuba»
	('surgical-extraction-of-residual-root', NULL, NULL, NULL), -- «vađenje zaostalih i slomljenih korijenova zuba»
	('cystectomy', NULL, NULL, NULL), -- «vađenje ciste (cistectomija)»
	('dental-implant-placement', NULL, NULL, NULL), -- «ugradnju dentalnih implantata»
	('bone-augmentation', NULL, NULL, NULL); -- «augmentacija kosti sa ili bez umjetne kosti»

-- Страховка: slug, которого нет в каталоге (опечатка, запись переименована на
-- проде). Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_primadent_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: СИНХРОНИЗАЦИЯ clinic_medical_services
-- ═══════════════════════════════════════════════════════════════

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_primadent_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_primadent_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 39, with_price = 31.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_sr, cms.price, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_sr;

-- Новые записи каталога: ожидается 2 строк, у каждой категория и специальность.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	GROUP_CONCAT(DISTINCT r.medical_service_category_id) AS categories,
	GROUP_CONCAT(DISTINCT s.specialty_id) AS specialties
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_services_specialties s ON s.medical_service_id = ms.id
WHERE ms.slug IN (
	'composite-filling-single-surface',
	'composite-filling-two-surfaces'
)
GROUP BY ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_primadent_services;

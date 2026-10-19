-- ═══════════════════════════════════════════════════════════════════════════
-- Cirkon Dental Lab (Podgorica) — услуги и цены
-- Run ПОСЛЕ server/sql/insert-clinic-cirkon-dental-lab-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-cirkon-dental-lab-podgorica-services.sql
--
-- Источник: https://www.cirkondentallab.com/cjenovnik (Next.js SSR-HTML, curl 2026-10-08;
-- даты на странице нет, sitemap lastmod = дата сборки) + /usluge и /usluge/* (позиции без
-- цены). Оговорка прайса: «Cijene su informativne. Za preciznu ponudu potreban je pregled —
-- pregled i konsultacije su besplatni.» — при этом в том же прайсе «Stomatološki pregled
-- 10 €»: взята цена из прайса, противоречие — в записи импорта.
--
-- В прайсе 25 строк с ценой (3 + 5 + 8 + 8 + 1; в заметках проверки сайта было «27» и
-- «estetska 6» — пересчитано по HTML и RSC-payload: 25). Заведено 24 строки:
--   * «Nano kompozitne fasete i plombe 70 €» — одна строка на две услуги → две записи
--     (direct-composite-veneer + новая nano-composite-filling), обе по 70 €;
--   * «Nadogradnje Helio 50 €» — в «Спорные» (что такое «Helio» — сайт не поясняет), не заведена.
-- + 3 позиции со страниц /usluge/* без цены.
-- Итого в клинике: 28 услуг (25 с ценой, 3 без цены), из них новых в каталоге: 6.
-- Анализов нет. Врачей нет — привязок врач↔услуга нет.
-- is_price_outdated не ставится (решение юзера; даты прайса нет — в записи импорта).
--
-- Самоисправляющийся: канонический список (slug + цена) лежит во временной
-- таблице, по ней идут upsert и DELETE лишнего. Повторный прогон приводит клинику
-- ровно к этому списку и этим ценам.
-- ⚠️ Услуги и цены, добавленные клинике вручную (админка, кабинет клиники),
-- следующий прогон снесёт/перезапишет — вносить их сюда.
-- Сопоставление «строка прайса → slug» с обоснованиями — data/clinic-imports/cirkon-dental-lab-podgorica.json.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'cirkon-dental-lab-podgorica' LIMIT 1);

-- Без клиники дальше смысла нет: INSERT отфильтруется по @clinic_id IS NOT NULL.
SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-cirkon-dental-lab-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (идемпотентно по slug)
-- Обоснование каждой — в комментарии и в data/clinic-imports/_wave2a-new-catalog-E.json.
-- ═══════════════════════════════════════════════════════════════

-- Nano-Composite Filling: «Nano kompozitne fasete i plombe 70 €» (Estetska stomatologija) рядом
-- с «Kompozitne plombe 35 €» (Terapija). Материал назван (нанокомпозит) и цена вдвое выше —
-- в Composite Filling не сводится (там уже 35 €). По образцу Microhybrid Composite Filling.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'nano-composite-filling', 'Nano-Composite Filling', 'Nano kompozitna plomba', 'Нано композитна пломба',
	'Нанокомпозитная пломба', 'Nanokomposit-Füllung', 'Nano kompozit dolgu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'nano-composite-filling');

-- Zirconia Crown EMAX 4D: «Cirkonijum premium krunica EMAX 4D 300 €». Бренд/линейка названы;
-- в каталоге E-max только как CAD/CAM E-max Layered Crown (облицованная, без «cirkonijum»
-- и «4D») и generic Zirconia Multilayer Crown — бренд не теряем.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'zirconia-crown-emax-4d', 'Zirconia Crown EMAX 4D', 'Cirkonijum krunica EMAX 4D', 'Цирконијум круница EMAX 4D',
	'Циркониевая коронка EMAX 4D', 'Zirkonkrone EMAX 4D', 'EMAX 4D zirkonyum kron', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'zirconia-crown-emax-4d');

-- Hollywood Smile Zirconia Crown: «Hollywood Smile cirkon krunica 250 €» — отдельная строка
-- рядом с «Cirkon krunica klasik 180 €» (→ Metal-Free (Zirconia) Ceramic Crown). Чем она
-- отличается (оттенок bleach, многослойный цирконий) сайт не говорит — приписывать не стали.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'hollywood-smile-zirconia-crown', 'Hollywood Smile Zirconia Crown', 'Cirkon krunica Hollywood Smile', 'Циркон круница Hollywood Smile',
	'Циркониевая коронка Hollywood Smile', 'Zirkonkrone Hollywood Smile', 'Hollywood Smile zirkonyum kron', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'hollywood-smile-zirconia-crown');

-- Metal-Ceramic Crown with 3D-Printed Framework: «Krunica print metal keramika 150 €».
-- Технология каркаса названа (печатный металл) — в generic Metal-Ceramic Crown не сводим;
-- CoCr / золото / серебро-палладий — это сплавы, не технология.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'metal-ceramic-crown-with-3d-printed-framework', 'Metal-Ceramic Crown with 3D-Printed Framework', 'Metalokeramička krunica na printanom metalu', 'Металокерамичка круница на принтаном металу',
	'Металлокерамическая коронка на 3D-печатном каркасе', 'Metallkeramikkrone mit 3D-gedrucktem Gerüst', '3D baskı altyapılı metal seramik kron', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'metal-ceramic-crown-with-3d-printed-framework');

-- Pulpitis Treatment, Single-Root Tooth: «Liječenje pulpita (1 korijen) 35 €». Однокорневой
-- пульпит в каталоге только с методикой (NiTi / mašinski), которую сайт не называет; пара
-- к существующей generic Gangrene Treatment, Single-Root Tooth (туда — «Liječenje gangrene
-- (1 korijen)»). Vital Extirpation… with Definitive Filling не берём: витальность и
-- постоянная пломба канала не заявлены.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pulpitis-treatment-single-root', 'Pulpitis Treatment, Single-Root Tooth', 'Liječenje pulpitisa jednokorijenog zuba', 'Лијечење пулпитиса једнокоријеног зуба',
	'Лечение пульпита однокорневого зуба', 'Pulpitisbehandlung eines einwurzeligen Zahns', 'Tek Köklü Diş Pulpitis Tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pulpitis-treatment-single-root');

-- Clear Aligner per Tray: «Ortodontska folija (1 folija) 100 €». Цена за одну каппу; Clear
-- Aligner Therapy — курс лечения целиком, цена за каппу в нём ввела бы в заблуждение;
-- Invisalign / Quick Aligner / M-Aligner — бренды, которых сайт не называет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'clear-aligner-per-tray', 'Clear Aligner per Tray', 'Ortodontska folija (po foliji)', 'Ортодонтска фолија (по фолији)',
	'Элайнер (за одну каппу)', 'Aligner-Schiene (pro Schiene)', 'Şeffaf plak (plak başına)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'clear-aligner-per-tray');

-- Категория 20 = DENTISTRY
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 20 FROM medical_services WHERE slug IN (
	'nano-composite-filling',
	'zirconia-crown-emax-4d',
	'hollywood-smile-zirconia-crown',
	'metal-ceramic-crown-with-3d-printed-framework',
	'pulpitis-treatment-single-root'
);

-- Категория 34 = ORTHODONTICS (ортодонтия — не DENTISTRY)
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 34 FROM medical_services WHERE slug IN (
	'clear-aligner-per-tray'
);

-- Специальность 78 = DENTISTRY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 78 FROM medical_services WHERE slug IN (
	'nano-composite-filling',
	'zirconia-crown-emax-4d',
	'hollywood-smile-zirconia-crown',
	'metal-ceramic-crown-with-3d-printed-framework',
	'pulpitis-treatment-single-root'
);

-- Специальность 93 = ORTHODONTIST
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 93 FROM medical_services WHERE slug IN (
	'clear-aligner-per-tray'
);

-- Синонимы: формулировки прайса, бытовые названия. sr дублируется в sr-cyrl.
-- Новые записи:
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Nano kompozitne plombe', 'sr' FROM medical_services WHERE slug = 'nano-composite-filling'
UNION ALL SELECT id, 'Нано композитне пломбе', 'sr-cyrl' FROM medical_services WHERE slug = 'nano-composite-filling'
UNION ALL SELECT id, 'Nanocomposite Filling', 'en' FROM medical_services WHERE slug = 'nano-composite-filling'
UNION ALL SELECT id, 'Cirkonijum premium krunica EMAX 4D', 'sr' FROM medical_services WHERE slug = 'zirconia-crown-emax-4d'
UNION ALL SELECT id, 'Цирконијум премиум круница EMAX 4D', 'sr-cyrl' FROM medical_services WHERE slug = 'zirconia-crown-emax-4d'
UNION ALL SELECT id, 'Hollywood Smile cirkon krunica', 'sr' FROM medical_services WHERE slug = 'hollywood-smile-zirconia-crown'
UNION ALL SELECT id, 'Hollywood Smile циркон круница', 'sr-cyrl' FROM medical_services WHERE slug = 'hollywood-smile-zirconia-crown'
UNION ALL SELECT id, 'Holivudski osmijeh', 'sr' FROM medical_services WHERE slug = 'hollywood-smile-zirconia-crown'
UNION ALL SELECT id, 'Холивудски осмијех', 'sr-cyrl' FROM medical_services WHERE slug = 'hollywood-smile-zirconia-crown'
UNION ALL SELECT id, 'Голливудская улыбка', 'ru' FROM medical_services WHERE slug = 'hollywood-smile-zirconia-crown'
UNION ALL SELECT id, 'Krunica print metal keramika', 'sr' FROM medical_services WHERE slug = 'metal-ceramic-crown-with-3d-printed-framework'
UNION ALL SELECT id, 'Круница принт метал керамика', 'sr-cyrl' FROM medical_services WHERE slug = 'metal-ceramic-crown-with-3d-printed-framework'
UNION ALL SELECT id, 'Printana metalokeramička krunica', 'sr' FROM medical_services WHERE slug = 'metal-ceramic-crown-with-3d-printed-framework'
UNION ALL SELECT id, 'Принтана металокерамичка круница', 'sr-cyrl' FROM medical_services WHERE slug = 'metal-ceramic-crown-with-3d-printed-framework'
UNION ALL SELECT id, '3D-Printed Metal-Ceramic Crown', 'en' FROM medical_services WHERE slug = 'metal-ceramic-crown-with-3d-printed-framework'
UNION ALL SELECT id, 'Liječenje pulpita', 'sr' FROM medical_services WHERE slug = 'pulpitis-treatment-single-root'
UNION ALL SELECT id, 'Лијечење пулпита', 'sr-cyrl' FROM medical_services WHERE slug = 'pulpitis-treatment-single-root'
UNION ALL SELECT id, 'Ortodontska folija', 'sr' FROM medical_services WHERE slug = 'clear-aligner-per-tray'
UNION ALL SELECT id, 'Ортодонтска фолија', 'sr-cyrl' FROM medical_services WHERE slug = 'clear-aligner-per-tray'
UNION ALL SELECT id, 'Single Aligner Tray', 'en' FROM medical_services WHERE slug = 'clear-aligner-per-tray';

-- Существующие записи: формулировки этого прайса, которых в синонимах ещё нет.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Vizil proteza', 'sr' FROM medical_services WHERE slug = 'skeletal-partial-denture'
UNION ALL SELECT id, 'Визил протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'skeletal-partial-denture'
UNION ALL SELECT id, 'Providna proteza', 'sr' FROM medical_services WHERE slug = 'flexible-denture'
UNION ALL SELECT id, 'Провидна протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'flexible-denture'
UNION ALL SELECT id, 'Flex proteza', 'sr' FROM medical_services WHERE slug = 'flexible-denture'
UNION ALL SELECT id, 'Флекс протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'flexible-denture'
UNION ALL SELECT id, 'Ultrazvučno uklanjanje kamenca', 'sr' FROM medical_services WHERE slug = 'plaque-and-calculus-removal'
UNION ALL SELECT id, 'Ултразвучно уклањање каменца', 'sr-cyrl' FROM medical_services WHERE slug = 'plaque-and-calculus-removal'
UNION ALL SELECT id, 'Ультразвуковая чистка зубов', 'ru' FROM medical_services WHERE slug = 'plaque-and-calculus-removal'
UNION ALL SELECT id, 'Rutinsko vađenje zuba', 'sr' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Рутинско вађење зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'tooth-extraction'
UNION ALL SELECT id, 'Cirkon krunica', 'sr' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Циркон круница', 'sr-cyrl' FROM medical_services WHERE slug = 'metal-free-zirconia-ceramic-crown'
UNION ALL SELECT id, 'Nano kompozitne fasete', 'sr' FROM medical_services WHERE slug = 'direct-composite-veneer'
UNION ALL SELECT id, 'Нано композитне фасете', 'sr-cyrl' FROM medical_services WHERE slug = 'direct-composite-veneer';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ
-- Рядом с каждой — строка прайса/страницы, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_cirkon_services;
CREATE TEMPORARY TABLE tmp_cirkon_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_cirkon_services (slug, price, price_min, price_max) VALUES
	-- Dijagnostika
	('dental-consultation', 10.00, NULL, NULL), -- Stomatološki pregled — 10 € (при «pregled i konsultacije su besplatni» над прайсом)
	('panoramic-x-ray', 25.00, NULL, NULL), -- Ortopan snimak — 25 €
	('intraoral-x-ray', 10.00, NULL, NULL), -- Intraoralni snimak — 10 €
	-- Estetska stomatologija
	('direct-composite-veneer', 70.00, NULL, NULL), -- Nano kompozitne fasete i plombe — 70 € (фасеты)
	('nano-composite-filling', 70.00, NULL, NULL), -- Nano kompozitne fasete i plombe — 70 € (пломбы)
	('zirconia-crown-emax-4d', 300.00, NULL, NULL), -- Cirkonijum premium krunica EMAX 4D — 300 €
	('metal-free-zirconia-ceramic-crown', 180.00, NULL, NULL), -- Cirkon krunica klasik — 180 €
	('home-teeth-whitening-per-arch', 150.00, NULL, NULL), -- Izbjeljivanje zuba folijom – 1 vilica — 150 € (folije = домашнее, /usluge/izbjeljivanje-zuba)
	('hollywood-smile-zirconia-crown', 250.00, NULL, NULL), -- Hollywood Smile cirkon krunica — 250 €
	-- Protetika
	('complete-acrylic-denture', 300.00, NULL, NULL), -- Totalna akrilatna proteza — 300 €
	('partial-acrylic-denture', 200.00, NULL, NULL), -- Parcijalna akrilatna proteza — 200 €
	('skeletal-partial-denture', 400.00, NULL, NULL), -- Skeletarna – Vizil proteza — 400 €
	('precision-attachment-for-denture', 100.00, NULL, NULL), -- Atečmeni — 100 €
	('metal-ceramic-crown-with-3d-printed-framework', 150.00, NULL, NULL), -- Krunica print metal keramika — 150 €
	('flexible-denture', 500.00, NULL, NULL), -- Flex ili providna proteza — 500 €
	('crown-removal', 10.00, NULL, NULL), -- Skidanje stare krunice — 10 €
	('temporary-crown', 20.00, NULL, NULL), -- Privremene krunice — 20 €
	-- Terapija
	('dental-first-aid', 20.00, NULL, NULL), -- Ukazivanje prve pomoći — 20 €
	('plaque-and-calculus-removal', 35.00, NULL, NULL), -- Ultrazvučno uklanjanje kamenca i mekih naslaga — 35 €
	('tooth-extraction', 25.00, NULL, NULL), -- Rutinsko vađenje zuba — 25 €
	('tooth-extraction-complex', 50.00, NULL, NULL), -- Komplikovano vađenje zuba — 50 €
	('composite-filling', 35.00, NULL, NULL), -- Kompozitne plombe — 35 €
	('pulpitis-treatment-single-root', 35.00, NULL, NULL), -- Liječenje pulpita (1 korijen) — 35 €
	('gangrene-treatment-single-root', 35.00, NULL, NULL), -- Liječenje gangrene (1 korijen) — 35 €
	-- Ortodoncija
	('clear-aligner-per-tray', 100.00, NULL, NULL), -- Ortodontska folija (1 folija) — 100 €
	-- Без цены: страницы /usluge/*
	('ceramic-veneer', NULL, NULL, NULL), -- /usluge/zubne-fasete: «Keramičke fasete … Izrada keramičkih faseta»
	('in-office-teeth-whitening-single-arch', NULL, NULL, NULL), -- /usluge/izbjeljivanje-zuba: «Izbjeljivanje u ordinaciji … tri puta po 15 minuta»
	('digital-smile-design', NULL, NULL, NULL); -- /cjenovnik «Digitalni Smile Design» (в пакете Hollywood Smile), /usluge/zubne-fasete «Digital Smile Design povezuje fotografije, sken i proporcije lica»

-- Страховка: slug, которого нет в каталоге (опечатка, запись переименована на
-- проде). Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_cirkon_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: СИНХРОНИЗАЦИЯ clinic_medical_services
-- ═══════════════════════════════════════════════════════════════

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_cirkon_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_cirkon_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 28, with_price = 25.
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
	'nano-composite-filling',
	'zirconia-crown-emax-4d',
	'hollywood-smile-zirconia-crown',
	'metal-ceramic-crown-with-3d-printed-framework',
	'pulpitis-treatment-single-root',
	'clear-aligner-per-tray'
)
GROUP BY ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_cirkon_services;

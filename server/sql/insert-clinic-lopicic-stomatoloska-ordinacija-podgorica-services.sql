-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Lopičić (Podgorica) — услуги и цены
-- Run ПОСЛЕ server/sql/insert-clinic-lopicic-stomatoloska-ordinacija-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-lopicic-stomatoloska-ordinacija-podgorica-services.sql
--
-- Источник: https://www.stomatoloskaordinacija.me/cjenovnik (в меню нет; 106 строк в €,
-- разделы Opšte usluge, Konzervativa, Protetika, Endodoncija, Oralna hirurgija, Dječija
-- stomatologija, Parodontopatija, Estetska stomatologija, Ortopedija vilica; оговорка
-- «Cijene su okvirne»; даты нет) + страницы услуг (позиции без цены), curl 2026-10-08.
--
-- 104 строки прайса сопоставлены, 2 — в «Спорные» (Akrylock atečmeni 120 €,
-- Kompjuterska analiza položaja zuba 50 €), не заведены.
-- Несколько строк → одна запись: цена = минимум, price_max = максимум
-- (рецементировка коронки/моста 20–30, временная коронка 20–40, эндодонтия 2–4 канала
-- 100–200, ортодонтический контроль 10–20). Строки, повторённые в детском разделе по
-- той же цене (Ponavljanje lijeka, Selektivno brušenje, Vadjenje mliječnog zuba,
-- Uklanjanje kamenca), сведены к одной записи.
--
-- Решения юзера 2026-10-08: «Kompozitni ispun I/II/III površinski» → новые
-- composite-filling-*-surface(s) (создаются здесь, Prima Dent переиспользует);
-- «Walplast proteza» → flexible-denture (Valplast = гибкий протез, отдельной записи нет);
-- «Izbjeljivanje zuba folijama» (капы) → home-teeth-whitening / home-teeth-whitening-per-arch.
--
-- Итого в клинике: 101 услуг (97 с ценой, 4 без цены), из них новых в каталоге: 17.
-- Анализов нет — блока lab_tests в файле нет. Привязок врач↔услуга нет: сайт не
-- приписывает услуги конкретным врачам.
-- is_price_outdated не ставится (решение юзера, дата прайса — в записи импорта).
--
-- Самоисправляющийся: канонический список (slug + цена) лежит во временной
-- таблице, по ней идут upsert и DELETE лишнего. Повторный прогон приводит клинику
-- ровно к этому списку и этим ценам.
-- ⚠️ Услуги и цены, добавленные клинике вручную (админка, кабинет клиники),
-- следующий прогон снесёт/перезапишет — вносить их сюда.
-- Сопоставление «строка прайса → slug» с обоснованиями — data/clinic-imports/lopicic-stomatoloska-ordinacija-podgorica.json.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJT3m0yTHrTRMRTG-Eba4IBHo';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'lopicic-stomatoloska-ordinacija-podgorica' LIMIT 1));

-- Без клиники дальше смысла нет: INSERT отфильтруется по @clinic_id IS NOT NULL.
SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-lopicic-stomatoloska-ordinacija-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (идемпотентно по slug)
-- Обоснование каждой — в комментарии. Определения общие для файлов агента A
-- волны 1: если запись уже заведена другим файлом, INSERT пропускается.
-- ═══════════════════════════════════════════════════════════════

-- Wisdom Tooth Extraction: «Vadjenje umnjaka 50 €» — отдельная строка рядом с «Hirurško vadjenje impaktiranog zuba». В каталоге umnjak есть только как синоним Impacted Tooth Extraction (ретинированный), простого удаления зуба мудрости нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'wisdom-tooth-extraction', 'Wisdom Tooth Extraction', 'Vađenje umnjaka', 'Вађење умњака',
	'Удаление зуба мудрости', 'Weisheitszahnentfernung', 'Yirmi yaş dişi çekimi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'wisdom-tooth-extraction');

-- Michigan Occlusal Splint: «Michigan okluzalni splint 150 €». Bruxism Night Guard (folija) и Custom Dental Guard — другие изделия; тип шины назван конкретно.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'michigan-occlusal-splint', 'Michigan Occlusal Splint', 'Michigan okluzalni splint', 'Michigan оклузални сплинт',
	'Окклюзионная шина Michigan', 'Michigan-Okklusionsschiene', 'Michigan oklüzal splint', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'michigan-occlusal-splint');

-- Attachment Matrix Replacement: «Zamjena matrice 50 €» в разделе протетики рядом с атачменами. Аналога в каталоге нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'attachment-matrix-replacement', 'Attachment Matrix Replacement', 'Zamjena matrice atečmena', 'Замјена матрице атечмена',
	'Замена матрицы аттачмена', 'Austausch der Attachment-Matrize', 'Ataşman matrisi değişimi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'attachment-matrix-replacement');

-- Veneered Metal Crown: «Fasetirana krunica 60 €» — литая коронка с облицовкой. В каталоге только ремонт облицовки (Crown Facing Repair).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'veneered-metal-crown', 'Veneered Metal Crown', 'Fasetirana krunica', 'Фасетирана круница',
	'Металлическая коронка с облицовкой', 'Verblendete Metallkrone', 'Kaplamalı metal kron', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'veneered-metal-crown');

-- Cast Metal Crown: «Livena krunica 50 €». В каталоге есть только Cast Post and Core (livena nadogradnja) — другое изделие.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'cast-metal-crown', 'Cast Metal Crown', 'Livena krunica', 'Ливена круница',
	'Цельнолитая металлическая коронка', 'Gegossene Metallkrone', 'Döküm metal kron', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'cast-metal-crown');

-- Intraradicular Attachment: «Intraradikularni atečmeni 80 €». В каталоге атачмены только общие (Precision Attachment for Denture) и брендовые CeKa/Bredent.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'intraradicular-attachment', 'Intraradicular Attachment', 'Intraradikularni atečmen', 'Интрарадикуларни атечмен',
	'Интрарадикулярный аттачмен', 'Intraradikuläres Attachment', 'İntraradiküler ataşman', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'intraradicular-attachment');

-- Dental Mock-up: «Mock up 50 €». Digital Smile Design — другое (цифровое планирование), отдельной записи под mock-up нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-mock-up', 'Dental Mock-up', 'Mock-up zuba', 'Mock-up зуба',
	'Мокап зубов (mock-up)', 'Mock-up (ästhetische Zahnprobe)', 'Diş mock-up uygulaması', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-mock-up');

-- Foreign Body Removal from Root Canal: «Uklanjanje stranog tijela iz kanala 30 €». Broken Instrument Removal from Root Canal уже (только обломок инструмента).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'foreign-body-removal-from-root-canal', 'Foreign Body Removal from Root Canal', 'Uklanjanje stranog tijela iz kanala korijena', 'Уклањање страног тијела из канала коријена',
	'Извлечение инородного тела из корневого канала', 'Fremdkörperentfernung aus dem Wurzelkanal', 'Kök kanalından yabancı cisim çıkarılması', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'foreign-body-removal-from-root-canal');

-- Laser Frenectomy: «Lasersko uklanjanje frenuluma 50 €». Метод назван (лазер) — generic Frenectomy не подставляем.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'laser-frenectomy', 'Laser Frenectomy', 'Laserska frenektomija', 'Ласерска френектомија',
	'Лазерная френэктомия', 'Laser-Frenektomie', 'Lazer frenektomi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'laser-frenectomy');

-- Laser Gingivectomy: «Lasersko podizanje desni (cirkumcizija) 50 €». Метод назван — generic Gingivectomy не подставляем.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'laser-gingivectomy', 'Laser Gingivectomy', 'Laserska gingivektomija', 'Ласерска гингивектомија',
	'Лазерная гингивэктомия', 'Laser-Gingivektomie', 'Lazer gingivektomi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'laser-gingivectomy');

-- Dental Barrier Membrane: «Membrana 100 €» без типа и бренда. В каталоге только Resorbable Membrane (свойство не заявлено) и Biooss Membrane Small/Large (бренд не заявлен).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-barrier-membrane', 'Dental Barrier Membrane', 'Barijerna membrana (stomatologija)', 'Баријерна мембрана (стоматологија)',
	'Барьерная мембрана (стоматология)', 'Barrieremembran (Zahnmedizin)', 'Bariyer membran (diş hekimliği)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-barrier-membrane');

-- Dental Implant Alpha-Bio: «Implant AlphaBio 500 €». Брендовые импланты в каталоге заведены по бренду (Nobel Biocare, Zimmer, Straumann…), Alpha-Bio нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-implant-alpha-bio', 'Dental Implant Alpha-Bio', 'Ugradnja implantata Alpha-Bio', 'Уградња имплантата Alpha-Bio',
	'Имплантат Alpha-Bio', 'Zahnimplantat Alpha-Bio', 'Alpha-Bio diş implantı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-implant-alpha-bio');

-- Dental Implant Dentium: «Implant Dentium 500 €». Бренда Dentium в каталоге нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-implant-dentium', 'Dental Implant Dentium', 'Ugradnja implantata Dentium', 'Уградња имплантата Dentium',
	'Имплантат Dentium', 'Zahnimplantat Dentium', 'Dentium diş implantı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-implant-dentium');

-- M-Aligner: «Folija za ispravljanje zuba M-aligner 100 €». Бренд назван — generic Clear Aligner Therapy не подставляем (по образцу Quick Aligner / Invisalign Aligner).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'm-aligner', 'M-Aligner', 'M-Aligner folija', 'M-Aligner фолија',
	'Элайнер M-Aligner', 'M-Aligner-Schiene', 'M-Aligner şeffaf plak', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'm-aligner');

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

-- Composite Filling Three Surfaces: Решение юзера 2026-10-08: Lopičić «Kompozitni ispun III površinski». См. composite-filling-single-surface.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'composite-filling-three-surfaces', 'Composite Filling Three Surfaces', 'Kompozitni ispun – tri površine', 'Композитни испун – три површине',
	'Композитная пломба (три поверхности)', 'Kompositfüllung dreiflächig', 'Üç yüzeyli kompozit dolgu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'composite-filling-three-surfaces');

-- Категория 20 = DENTISTRY
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 20 FROM medical_services WHERE slug IN (
	'wisdom-tooth-extraction',
	'michigan-occlusal-splint',
	'attachment-matrix-replacement',
	'veneered-metal-crown',
	'cast-metal-crown',
	'intraradicular-attachment',
	'dental-mock-up',
	'foreign-body-removal-from-root-canal',
	'laser-frenectomy',
	'laser-gingivectomy',
	'dental-barrier-membrane',
	'dental-implant-alpha-bio',
	'dental-implant-dentium',
	'composite-filling-single-surface',
	'composite-filling-two-surfaces',
	'composite-filling-three-surfaces'
);

-- Категория 34 = ORTHODONTICS
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 34 FROM medical_services WHERE slug IN (
	'm-aligner'
);

-- Категория 35 = PEDIATRIC_DENTISTRY
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 35 FROM medical_services WHERE slug IN (
	'composite-filling-single-surface',
	'composite-filling-two-surfaces',
	'composite-filling-three-surfaces'
);

-- Специальность 74 = ORAL_SURGERY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 74 FROM medical_services WHERE slug IN (
	'wisdom-tooth-extraction',
	'laser-frenectomy',
	'laser-gingivectomy',
	'dental-barrier-membrane',
	'dental-implant-alpha-bio',
	'dental-implant-dentium'
);

-- Специальность 78 = DENTISTRY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 78 FROM medical_services WHERE slug IN (
	'wisdom-tooth-extraction',
	'michigan-occlusal-splint',
	'attachment-matrix-replacement',
	'veneered-metal-crown',
	'cast-metal-crown',
	'intraradicular-attachment',
	'dental-mock-up',
	'foreign-body-removal-from-root-canal',
	'laser-frenectomy',
	'laser-gingivectomy',
	'dental-barrier-membrane',
	'dental-implant-alpha-bio',
	'dental-implant-dentium',
	'composite-filling-single-surface',
	'composite-filling-two-surfaces',
	'composite-filling-three-surfaces'
);

-- Специальность 87 = PEDIATRIC_DENTISTRY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 87 FROM medical_services WHERE slug IN (
	'composite-filling-single-surface',
	'composite-filling-two-surfaces',
	'composite-filling-three-surfaces'
);

-- Специальность 93 = ORTHODONTIST
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 93 FROM medical_services WHERE slug IN (
	'm-aligner'
);

-- Синонимы: формулировки прайса, бытовые названия, бренды. sr дублируется в sr-cyrl.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Vađenje zuba mudrosti', 'sr' FROM medical_services WHERE slug = 'wisdom-tooth-extraction'
UNION ALL SELECT id, 'Вађење зуба мудрости', 'sr-cyrl' FROM medical_services WHERE slug = 'wisdom-tooth-extraction'
UNION ALL SELECT id, 'Third Molar Extraction', 'en' FROM medical_services WHERE slug = 'wisdom-tooth-extraction'
UNION ALL SELECT id, 'Удаление восьмёрки', 'ru' FROM medical_services WHERE slug = 'wisdom-tooth-extraction'
UNION ALL SELECT id, 'Michigan Splint', 'en' FROM medical_services WHERE slug = 'michigan-occlusal-splint'
UNION ALL SELECT id, 'Мичиганская шина', 'ru' FROM medical_services WHERE slug = 'michigan-occlusal-splint'
UNION ALL SELECT id, 'Zamjena matrice', 'sr' FROM medical_services WHERE slug = 'attachment-matrix-replacement'
UNION ALL SELECT id, 'Замјена матрице', 'sr-cyrl' FROM medical_services WHERE slug = 'attachment-matrix-replacement'
UNION ALL SELECT id, 'Мокап', 'ru' FROM medical_services WHERE slug = 'dental-mock-up'
UNION ALL SELECT id, 'Mock up', 'sr' FROM medical_services WHERE slug = 'dental-mock-up'
UNION ALL SELECT id, 'Lasersko uklanjanje frenuluma', 'sr' FROM medical_services WHERE slug = 'laser-frenectomy'
UNION ALL SELECT id, 'Ласерско уклањање френулума', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-frenectomy'
UNION ALL SELECT id, 'Лазерная пластика уздечки', 'ru' FROM medical_services WHERE slug = 'laser-frenectomy'
UNION ALL SELECT id, 'Lasersko podizanje desni', 'sr' FROM medical_services WHERE slug = 'laser-gingivectomy'
UNION ALL SELECT id, 'Ласерско подизање десни', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-gingivectomy'
UNION ALL SELECT id, 'Laser Gum Lift', 'en' FROM medical_services WHERE slug = 'laser-gingivectomy'
UNION ALL SELECT id, 'Лазерная коррекция десны', 'ru' FROM medical_services WHERE slug = 'laser-gingivectomy'
UNION ALL SELECT id, 'Implant AlphaBio', 'sr' FROM medical_services WHERE slug = 'dental-implant-alpha-bio'
UNION ALL SELECT id, 'Имплант AlphaBio', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-implant-alpha-bio'
UNION ALL SELECT id, 'Alpha-Bio Tec Implant', 'en' FROM medical_services WHERE slug = 'dental-implant-alpha-bio'
UNION ALL SELECT id, 'Implant Dentium', 'sr' FROM medical_services WHERE slug = 'dental-implant-dentium'
UNION ALL SELECT id, 'Имплант Dentium', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-implant-dentium'
UNION ALL SELECT id, 'Kompozitni ispun I površinski', 'sr' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Композитни испун И површински', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Jednopovršinska bijela plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Једноповршинска бијела пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-single-surface'
UNION ALL SELECT id, 'Kompozitni ispun II površinski', 'sr' FROM medical_services WHERE slug = 'composite-filling-two-surfaces'
UNION ALL SELECT id, 'Композитни испун ИИ површински', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-two-surfaces'
UNION ALL SELECT id, 'Dvopovršinska bijela plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling-two-surfaces'
UNION ALL SELECT id, 'Двоповршинска бијела пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-two-surfaces'
UNION ALL SELECT id, 'Kompozitni ispun III površinski', 'sr' FROM medical_services WHERE slug = 'composite-filling-three-surfaces'
UNION ALL SELECT id, 'Композитни испун ИИИ површински', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-three-surfaces'
UNION ALL SELECT id, 'Tropovršinska bijela plomba', 'sr' FROM medical_services WHERE slug = 'composite-filling-three-surfaces'
UNION ALL SELECT id, 'Троповршинска бијела пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-filling-three-surfaces';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ
-- Рядом с каждой — строка прайса/страницы, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_lopicic_services;
CREATE TEMPORARY TABLE tmp_lopicic_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_lopicic_services (slug, price, price_min, price_max) VALUES
	('dental-consultation', 10.00, NULL, NULL), -- Stomatološki pregled — 10 €
	('specialist-dental-examination', 30.00, NULL, NULL), -- Specijalistički pregled — 30 €
	('intraoral-x-ray', 10.00, NULL, NULL), -- RTG snimak — 10 €
	('panoramic-x-ray', 30.00, NULL, NULL), -- Ortopan snimak — 30 €
	('3d-dental-x-ray-cbct', 80.00, NULL, NULL), -- 3D snimak — 80 €
	('dental-first-aid', 10.00, NULL, NULL), -- Prva pomoć — 10 €
	('pulp-capping-direct-or-indirect', 10.00, NULL, NULL), -- Indirektno prekrivanje pulpe — 10 €
	('direct-pulp-capping', 10.00, NULL, NULL), -- Direktno prekrivanje pulpe — 10 €
	('composite-filling-single-surface', 30.00, NULL, NULL), -- Kompozitni ispun I površinski — 30 €
	('composite-filling-two-surfaces', 40.00, NULL, NULL), -- Kompozitni ispun II površinski — 40 €
	('composite-filling-three-surfaces', 50.00, NULL, NULL), -- Kompozitni ispun III površinski — 50 €
	('composite-core-build-up', 60.00, NULL, NULL), -- Kompozitna nadogradnja — 60 €
	('direct-composite-veneer', 100.00, NULL, NULL), -- Kompozitna faseta — 100 €
	('filling-retention-with-metal-post', 10.00, NULL, NULL), -- Parapurplani kočić — 10 €
	('michigan-occlusal-splint', 150.00, NULL, NULL), -- Michigan okluzalni splint — 150 €
	('composite-splint', 50.00, NULL, NULL), -- Kompozitni splint — 50 €
	('therapeutic-tooth-grinding', 10.00, NULL, NULL), -- Selektivno brušenje zuba — 10 € (po zubu) | Selektivno brušenje zuba — 10 €
	('crown-or-bridge-recementation', 20.00, NULL, 30.00), -- Cementiranje stare krunice — 20 € | Cementiranje starog mosta — 30 €
	('temporary-crown', 20.00, NULL, 40.00), -- Privremene krunice — 20 € (po zubu) | Privremena krunica urađena u laboratoriji — 40 €
	('crown-removal', 10.00, NULL, NULL), -- Skidanje stare krunice — 10 € | Skidanje mosta — 10 € (po članu)
	('frc-post', 50.00, NULL, NULL), -- Kompozitni kočić — 50 €
	('metal-ceramic-crown', 120.00, NULL, NULL), -- Metalokeramička krunica — 120 €
	('implant-crown-metal-ceramic', 170.00, NULL, NULL), -- Metalokeramička krunica na implantu — 170 €
	('all-ceramic-crown', 250.00, NULL, NULL), -- Bezmetalna krunica — 250 €
	('metal-free-implant-crown-with-original-abutment', 300.00, NULL, NULL), -- Bezmetalna krunica na implantu — 300 €
	('screw-retained-implant-crown-zirconia', 350.00, NULL, NULL), -- Bezmetalna krunica na implant na šrafljenje — 350 €
	('ceramic-veneer', 300.00, NULL, NULL), -- Keramička faseta — 300 €
	('maryland-bridge', 350.00, NULL, NULL), -- Meryland most — 350 €
	('complete-denture', 400.00, NULL, NULL), -- Totalna proteza — 400 €
	('partial-denture', 350.00, NULL, NULL), -- Parcijalna proteza — 350 €
	('flexible-denture', 400.00, NULL, NULL), -- Walplast proteza — 400 €
	('skeletal-partial-denture', 600.00, NULL, NULL), -- Parcijalna skeletirana proteza (vizil) — 600 €
	('attachment-matrix-replacement', 50.00, NULL, NULL), -- Zamjena matrice — 50 €
	('dolder-bar', 40.00, NULL, NULL), -- Dolder prečka — 40 €
	('direct-denture-relining', 50.00, NULL, NULL), -- Direktno podlaganje proteze — 50 €
	('indirect-denture-relining', 100.00, NULL, NULL), -- Indirektno podlaganje proteze — 100 €
	('veneered-metal-crown', 60.00, NULL, NULL), -- Fasetirana krunica — 60 €
	('telescopic-crown', 180.00, NULL, NULL), -- Teleskop krunica — 180 €
	('cast-metal-crown', 50.00, NULL, NULL), -- Livena krunica — 50 €
	('cast-post-and-core', 50.00, NULL, NULL), -- Livena nadogradnja — 50 €
	('precision-attachment-for-denture', 150.00, NULL, NULL), -- Ugradnja atečmena — 150 € (par)
	('denture-retention-system-ceka', 150.00, NULL, NULL), -- CeKa atečmeni — 150 € (par)
	('denture-retention-system-bredent', 100.00, NULL, NULL), -- Bredent atečmeni — 100 €
	('intraradicular-attachment', 80.00, NULL, NULL), -- Intraradikularni atečmeni — 80 €
	('denture-tooth-addition', 20.00, NULL, NULL), -- Dodatak zuba u protezu — 20 €
	('denture-repair', 30.00, NULL, NULL), -- Reparatura proteze — 30 €
	('flipper-denture', 100.00, NULL, NULL), -- Žabica — 100 €
	('dental-mock-up', 50.00, NULL, NULL), -- Mock up — 50 €
	('removal-of-old-root-canal-filling', 20.00, NULL, NULL), -- Uklanjanje starog kanalnog punjenja — 20 €
	('foreign-body-removal-from-root-canal', 30.00, NULL, NULL), -- Uklanjanje stranog tijela iz kanala — 30 €
	('endodontic-treatment-single-canal-tooth', 50.00, NULL, NULL), -- Liječenje jednokanalnog zuba — 50 €
	('endodontic-treatment-multi-canal-tooth', 100.00, NULL, 200.00), -- Liječenje dvokalanog zuba — 100 € | Liječenje trokanalnog zuba — 150 € | Liječenje četvorokanalnog zuba — 200 €
	('temporary-filling-with-medication', 10.00, NULL, NULL), -- Ponavljanje lijeka — 10 €
	('primary-tooth-extraction', 20.00, NULL, NULL), -- Vadjenje mlječnog zuba — 20 € | Vadjenje mliječnog zuba — 20 €
	('tooth-extraction-simple', 30.00, NULL, NULL), -- Rutinsko vadjenje stalnog zuba — 30 €
	('tooth-extraction-complex', 60.00, NULL, NULL), -- Komplikovano vadjenje zuba — 60 €
	('wisdom-tooth-extraction', 50.00, NULL, NULL), -- Vadjenje umnjaka — 50 €
	('surgical-tooth-extraction', 100.00, NULL, NULL), -- Hirurško vadjenje zuba — 100 €
	('impacted-tooth-extraction', 150.00, NULL, NULL), -- Hirurško vadjenje impaktiranog zuba — 150 €
	('apicoectomy', 150.00, NULL, NULL), -- Apikotomija — 150 €
	('laser-frenectomy', 50.00, NULL, NULL), -- Lasersko uklanjanje frenuluma — 50 €
	('laser-gingivectomy', 50.00, NULL, NULL), -- Lasersko podizanje desni (cirkumcizija) — 50 €
	('intraoral-abscess-incision', 20.00, NULL, NULL), -- Incizija abcesa — 20 €
	('bleeding-control-dental', 20.00, NULL, NULL), -- Biološka hemostaza — 20 €
	('alveolitis-treatment', 10.00, NULL, NULL), -- Terapija alveolita — 10 € (po seansi)
	('alveolar-ridge-leveling', 100.00, NULL, NULL), -- Nivelacija grebena — 100 €
	('vestibuloplasty', 100.00, NULL, NULL), -- Produbljivanje formiksa — 100 €
	('sinus-closure', 80.00, NULL, NULL), -- Hirurško zatvaranje sinusa — 80 €
	('periodontal-surgical-therapy-flap-surgery-per-tooth', 50.00, NULL, NULL), -- Režanj operacija — 50 € (po zubu)
	('tuberoplasty-and-toroplasty', 100.00, NULL, NULL), -- Tuberoktomija — 100 €
	('dental-barrier-membrane', 100.00, NULL, NULL), -- Membrana — 100 €
	('bone-augmentation-biooss', 100.00, NULL, NULL), -- BiOss — 100 €
	('dental-implant-alpha-bio', 500.00, NULL, NULL), -- Implant AlphaBio — 500 €
	('dental-implant-dentium', 500.00, NULL, NULL), -- Implant Dentium — 500 €
	('dental-implant-nobel-biocare', 650.00, NULL, NULL), -- Implant Nobel Bio care — 650 €
	('dental-implant-zimmer', 700.00, NULL, NULL), -- Implant Zimmer — 700 €
	('implant-suprastructure', 100.00, NULL, NULL), -- Suprastruktura — 100 €
	('primary-tooth-pulp-treatment', 20.00, NULL, NULL), -- Liječenje zuba — 20 €
	('composite-filling-on-primary-tooth', 30.00, NULL, NULL), -- Kompozitni ispun — 30 €
	('glass-ionomer-filling', 20.00, NULL, NULL), -- GJC plomba — 20 €
	('dental-fissure-sealant', 20.00, NULL, NULL), -- Zalivanje fisura — 20 €
	('plaque-and-calculus-removal', 30.00, NULL, NULL), -- Uklanjanje kamenca — 30 €
	('periodontal-pocket-treatment', 20.00, NULL, NULL), -- Kiretaža paradontalnog džepa — 20 €
	('dental-calculus-removal-and-air-flow', 50.00, NULL, NULL), -- Uklanjanje tvrdih i mekih naslaga i peskiranje zuba — 50 €
	('soft-dental-deposit-removal', 20.00, NULL, NULL), -- Uklanjanje mekih naslaga i poliranje — 20 €
	('home-teeth-whitening', 200.00, NULL, NULL), -- Izbjeljivanje zuba folijama — 200 € (100 € po vilici)
	('home-teeth-whitening-per-arch', 100.00, NULL, NULL), -- Izbjeljivanje zuba folijama — 200 € (100 € po vilici)
	('laser-teeth-whitening', 250.00, NULL, NULL), -- Izbjeljivanje zuba lampom — 250 € (125 € po vilici)
	('in-office-teeth-whitening-single-arch', 125.00, NULL, NULL), -- Izbjeljivanje zuba lampom — 250 € (125 € po vilici)
	('internal-bleaching-of-devitalized-tooth', 20.00, NULL, NULL), -- Izbjeljivanje devitalizovanog zuba — 20 €
	('dental-jewelry-application', 20.00, NULL, NULL), -- Zubni nakit (cirkon) — 20 €
	('facial-mesotherapy-single-treatment', 50.00, NULL, NULL), -- Mezoterapija lica (jedan tretman, jedna regija) — 50 €
	('fixed-orthodontic-braces-per-arch', 700.00, NULL, NULL), -- Fiksna proteza — 700 €
	('orthodontic-removable-plate-appliance', 300.00, NULL, NULL), -- Mobilna proteza — 300 €
	('retention-aligner-fabrication', 80.00, NULL, NULL), -- Retenciona folija — 80 €
	('m-aligner', 100.00, NULL, NULL), -- Folija za ispravljanje zuba M-aligner — 100 €
	('orthodontic-follow-up-monthly', 10.00, NULL, 20.00), -- Mjesečne kontrole (u zavisnosti od aparata) — 10-20 €
	('root-canal-retreatment', NULL, NULL, NULL), -- «Revizija endodontskog punjenja»
	('conservative-treatment-of-periapical-process-and-dental-gangrene', NULL, NULL, NULL), -- «Liječenje gangrene»
	('cystectomy', NULL, NULL, NULL), -- «cistektomija»
	('topical-fluoride-treatment', NULL, NULL, NULL); -- «Fluorizacija zuba» (и «Fluorisanje zuba» на /preventivna-stomatologija)

-- Страховка: slug, которого нет в каталоге (опечатка, запись переименована на
-- проде). Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_lopicic_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: СИНХРОНИЗАЦИЯ clinic_medical_services
-- ═══════════════════════════════════════════════════════════════

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_lopicic_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_lopicic_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 101, with_price = 97.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_sr, cms.price, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_sr;

-- Новые записи каталога: ожидается 17 строк, у каждой категория и специальность.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	GROUP_CONCAT(DISTINCT r.medical_service_category_id) AS categories,
	GROUP_CONCAT(DISTINCT s.specialty_id) AS specialties
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_services_specialties s ON s.medical_service_id = ms.id
WHERE ms.slug IN (
	'wisdom-tooth-extraction',
	'michigan-occlusal-splint',
	'attachment-matrix-replacement',
	'veneered-metal-crown',
	'cast-metal-crown',
	'intraradicular-attachment',
	'dental-mock-up',
	'foreign-body-removal-from-root-canal',
	'laser-frenectomy',
	'laser-gingivectomy',
	'dental-barrier-membrane',
	'dental-implant-alpha-bio',
	'dental-implant-dentium',
	'm-aligner',
	'composite-filling-single-surface',
	'composite-filling-two-surfaces',
	'composite-filling-three-surfaces'
)
GROUP BY ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_lopicic_services;

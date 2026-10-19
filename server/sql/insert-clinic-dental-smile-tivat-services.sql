-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dental Smile (Tivat) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dental-smile-tivat.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-smile-tivat-services.sql
--
-- Источник: https://www.dentalsmiletivat.com/ (me), 26 страниц меню «Usluge», curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные на страницах услуг (включая список применений лазера TurboWaterlase MD).
-- Пояснения без процедуры и расплывчатые пункты — в excluded записи импорта.
--
-- Итого: 53 услуг (0 с ценой), новых записей каталога — 3 (composite-inlay-onlay, tmj-occlusal-splint, dentin-hypersensitivity-treatment), повторено из других импортов агента W — laser-periodontal-therapy. Анализов нет.
-- Привязок врач↔услуга: 8.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJydO23XcxTBMRzyYOeS5QKa4' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dental-smile-tivat' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dental-smile-tivat.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- (запись заведена в insert-clinic-dental-studio-przno-budva-services.sql; повторена идемпотентно — файл не зависит от порядка применения)
-- dentalstudioglusica.me /dentalni-laser/: «Laserska operacija parodontoze … kiretaže parodontalnog džepa … Za razliku od klasične režanj
-- operacije», «Laserska obrada džepa». Лазерного пародонтологического лечения в каталоге нет (laser-gingivectomy — иссечение десны).
-- Категория 20, специальности 78 + 95 (как periodontal-pocket-treatment).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'laser-periodontal-therapy', 'Laser Periodontal Therapy', 'Laserska terapija parodontopatije', 'Ласерска терапија пародонтопатије',
	'Лазерное лечение пародонтита', 'Laser-Parodontitistherapie', 'Lazerle periodontitis tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'laser-periodontal-therapy' OR name_en = 'Laser Periodontal Therapy');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 95 FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laserska operacija parodontoze', 'sr' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laserska obrada parodontalnog džepa', 'sr' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ласерска операција пародонтозе', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ласерска обрада пародонталног џепа', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laser periodontal pocket treatment', 'en' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laser gum surgery', 'en' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лазерное лечение пародонтоза', 'ru' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лазерная обработка пародонтального кармана', 'ru' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laserbehandlung von Zahnfleischtaschen', 'de' FROM medical_services WHERE slug = 'laser-periodontal-therapy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Lazerle periodontal cep tedavisi', 'tr' FROM medical_services WHERE slug = 'laser-periodontal-therapy';

-- dentalsmiletivat.com /inlay_overlay: «Izrađuju se od kompozitnog ili keramičkog materijala u zubotehničkom laboratoriju».
-- В каталоге вкладки только ceramic/gold/zirconia — композитной нет. Категория 20, специальность 78 (как ceramic-inlay-onlay).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'composite-inlay-onlay', 'Composite Inlay Onlay', 'Kompozitni inlay ili onlay', 'Композитни inlay или onlay',
	'Композитная вкладка инлей или онлей', 'Komposit-Inlay oder -Onlay', 'Kompozit inley veya onley', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'composite-inlay-onlay' OR name_en = 'Composite Inlay Onlay');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompozitni inlej', 'sr' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompozitni onlej', 'sr' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Композитни инлеј', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Composite inlay', 'en' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Indirect composite restoration', 'en' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Композитная вкладка', 'ru' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompositinlay', 'de' FROM medical_services WHERE slug = 'composite-inlay-onlay';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompozit inley', 'tr' FROM medical_services WHERE slug = 'composite-inlay-onlay';

-- dentalsmiletivat.com /splintovi: «Splintovi za TMZ … izradom splinta moguće je znatno smanjiti ili eliminisati ove probleme».
-- Тип не назван; в каталоге только Michigan (конкретный дизайн) и bruxism-night-guard → общая запись. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'tmj-occlusal-splint', 'TMJ Occlusal Splint', 'Okluzalni splint za TMZ', 'Оклузални сплинт за ТМЗ',
	'Окклюзионная шина при дисфункции ВНЧС', 'Aufbissschiene bei CMD', 'TME okluzal splinti', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'tmj-occlusal-splint' OR name_en = 'TMJ Occlusal Splint');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Splint za TMZ', 'sr' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Splint za vilični zglob', 'sr' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Сплинт за ТМЗ', 'sr-cyrl' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'TMJ splint', 'en' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Occlusal splint', 'en' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Сплинт для ВНЧС', 'ru' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Окклюзионная шина', 'ru' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Okklusionsschiene', 'de' FROM medical_services WHERE slug = 'tmj-occlusal-splint';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Çene eklemi splinti', 'tr' FROM medical_services WHERE slug = 'tmj-occlusal-splint';

-- dentalsmiletivat.com /turbo: «Desenzibilizacija bola ogoljenih zuba osjetljivih na hladno i toplo» (лазер TurboWaterlase MD).
-- В каталоге нет (поиск desenz/sensitiv/hiperestez/чувствит). Общая запись, метод — в src. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dentin-hypersensitivity-treatment', 'Dentin Hypersensitivity Treatment', 'Desenzibilizacija osjetljivih zuba', 'Десензибилизација осјетљивих зуба',
	'Лечение повышенной чувствительности зубов', 'Behandlung überempfindlicher Zähne', 'Diş hassasiyeti tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment' OR name_en = 'Dentin Hypersensitivity Treatment');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Desenzibilizacija zuba', 'sr' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Liječenje preosjetljivosti zuba', 'sr' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Десензибилизација зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Tooth desensitization', 'en' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Десенситизация зубов', 'ru' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лечение гиперестезии зубов', 'ru' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Desensibilisierung der Zähne', 'de' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Diş duyarsızlaştırma', 'tr' FROM medical_services WHERE slug = 'dentin-hypersensitivity-treatment';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- hyaluronic-acid-filler: dentalsmiletivat.com /estetika_lica: «Moguci neželjeni efekti pri upotrebi Restilana …» — клиника называет препарат гиалуроновой кислоты (Restylane). Это та же процедура, что hyaluronic-acid-filler; бренд-дубль не заводим (решение юзера 2026-10-08), бренд — синонимом для поиска.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Restylane', 'en' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Restylane filer', 'sr' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Restilan', 'sr' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Рестилан', 'sr-cyrl' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Рестилайн', 'ru' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Restylane-Filler', 'de' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Restylane dolgu', 'tr' FROM medical_services WHERE slug = 'hyaluronic-acid-filler';
-- skeletal-partial-denture: dentalsmiletivat.com /skeletirana: «Drugo poznatije ime za ovu nadoknadu je vizil ili wironit proteza» — разговорное название по сплаву (Wironit); «Vizil proteza» у записи уже есть.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Wironit proteza', 'sr' FROM medical_services WHERE slug = 'skeletal-partial-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Виронит протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'skeletal-partial-denture';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (53)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_w_dsm_services;
CREATE TEMPORARY TABLE tmp_w_dsm_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_w_dsm_services (slug, price, price_min, price_max) VALUES
	('hyaluronic-acid-filler', NULL, NULL, NULL), -- /estetika_lica: «moguće je u potpunosti remodelirati crte lica najkvalitetnijim preparatima hijaluronske kiseline», «Podizanje jagodica», «Za popunjavanje ožiljaka»; препарат — Restylane («pri upotrebi Restilana») → синоним
	('lip-augmentation', NULL, NULL, NULL), -- /estetika_lica: «Povećanje volumena usana»
	('wrinkle-correction-hyaluronic-acid', NULL, NULL, NULL), -- /estetika_lica: «Popunjavanje bora lica», «Popunjavnaje bora vrata», «Bora oko usana», «Opuštenih uglova usana»
	('hand-rejuvenation-hyaluronic-fillers', NULL, NULL, NULL), -- /estetika_lica: «Popunjavanje bora ruku»
	('composite-filling', NULL, NULL, NULL), -- /kompozitni_ispuni: «Najsavremeniji kompozitni ispuni imaju snagu lijepljenja na zub daleko veću …»
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- /endodoncija: «Lječenje kanala korena zuba … uklanjanje inficiranog pulpnog tkiva … punjenje kanala» — число каналов не названо (как Mušura, dr-sevaljevic-tivat)
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('laser-teeth-whitening', NULL, NULL, NULL), -- /beljenje_zuba: «Lasersko bijeljenje zuba je polučasovna procedura … White smile metoda … gel … i specijalne UV lampe»; /turbo: «20-to minutno beljenje zuba»
	('ceramic-inlay-onlay', NULL, NULL, NULL), -- /inlay_overlay: «Keramički inlay svojom bojom može biti identičan prirodnom zubu», «Izrađuju se od kompozitnog ili keramičkog materijala»
	('composite-inlay-onlay', NULL, NULL, NULL), -- /inlay_overlay: «Izrađuju se od kompozitnog ili keramičkog materijala u zubotehničkom laboratoriju» (НОВАЯ запись) (НОВАЯ запись каталога)
	('dental-air-polishing', NULL, NULL, NULL), -- /izbeljivanje_nakit: «Uklanjanje mekih naslaga i pigmentacija zuba … sistemom Air-Flow, a procedura se zove peskaranje zuba»
	('dental-calculus-removal-and-air-flow', NULL, NULL, NULL), -- /izbeljivanje_nakit, «MINI MAKEOVER»: «Cišćenje i peskarenje zuba (air flow metodom)»
	('dental-jewelry-application', NULL, NULL, NULL), -- /izbeljivanje_nakit: «Zubni nakit – cirkoni … Ukrašavanje zuba cirkonima»; MINI MAKEOVER «Zubni nakit»
	('lumineers', NULL, NULL, NULL), -- /ljuskice: «Lumineers su porculanske ljuspice unaprijed fabrički napravljane … ne zahtijevaju dodatna brušenja zuba»
	('ceramic-veneer', NULL, NULL, NULL), -- /ljuskice: «Keramičke ljuspice se izrađuju u zubotehničkoj laboratoriji press tehnikom ili kompjuteriziranom CAD/CAM tehnologijom»
	('direct-composite-veneer', NULL, NULL, NULL), -- /ljuskice: «Kompozitne ljuspice se najčešće izrađuju direktno u ustima pacijenta»
	('laser-gingivectomy', NULL, NULL, NULL), -- /ljuskice: «Po potrebi se laserom koriguju desni da bi bile simetrične»
	('invisalign-aligner', NULL, NULL, NULL), -- /invisalign: «Invisalign ispravlja zube koristeći seriju skoro nevidljivih, skidajućih folija»
	('fixed-braces-metal-per-jaw', NULL, NULL, NULL), -- /fiksna: «Imamo više vrsta bravica – od vidljivih (klasične, metalne) …»
	('fixed-braces-ceramic-or-composite-per-jaw', NULL, NULL, NULL), -- /fiksna: «… do slabo vidljivih (estetska)»
	('lingual-braces-per-jaw', NULL, NULL, NULL), -- /fiksna: «… i nevidljivih (lingvalne ili sakrivene)», «Bravica može biti postavljena sa … unutrašnje strane zuba»
	('self-ligating-braces-metal-per-jaw', NULL, NULL, NULL), -- /fiksna: «U našoj ordinaciji najzastupljeniji je Damon system-samolegirajući breketi» — Damon уже синоним этой записи (ortholine-podgorica)
	('orthodontic-functional-monoblock-appliance', NULL, NULL, NULL), -- /fukcionalna: «Funkcionalni ortodonski aparati … mogu se izrađivati izjedna za obje vilice ili, pak, pojedinačno»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- /mobilna: «1. aktivni, pločasti ortodontski aparati … Pločasti ortodonski aparati se pričvršćuju pomoću žičanih kukica»
	('tmj-occlusal-splint', NULL, NULL, NULL), -- /splintovi: «Splintovi za TMZ … Pravilnom dijagnostikom i izradom splinta» (НОВАЯ запись) (НОВАЯ запись каталога)
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- /parodontologija: «U početnom stadijumu stvaranja džepova, dovoljno je ukloniti zubni kamenac, mehanički obraditi džepove i isprati ih rastvorom antiseptika»
	('periodontal-flap-surgery-with-bone-graft-per-tooth', NULL, NULL, NULL), -- /parodontologija: «radi se hirurška intervencija, prilikom koje se čiste defekti u kosti … koriste se razne zamjene za kost tzv. vještačke kosti»
	('guided-tissue-regeneration', NULL, NULL, NULL), -- /parodontologija: «… vještačke kosti, membrane i faktori rasta, koji omogućavaju obnavljanje razorenog tkiva»
	('panoramic-x-ray', NULL, NULL, NULL), -- меню «Digitalni rengen — OPT», страница /otp (текст страницы — копия парадонтологии, услуга по заголовку)
	('intraoral-x-ray', NULL, NULL, NULL), -- /rtg: «U našem stomatološkom studiju koristimo moderni digitalni zubni rentgen»
	('laser-periodontal-therapy', NULL, NULL, NULL), -- /turbo: «Terapija parodontopatije», «Terapija inficiranih i neinficiranih džepova oko zuba» (лазер TurboWaterlase MD, Biolase) (НОВАЯ запись каталога)
	('laser-frenectomy', NULL, NULL, NULL), -- /turbo: «Incizija frenuluma» (лазер)
	('oral-mucosa-circumcision-or-excision', NULL, NULL, NULL), -- /turbo: «Cirkumcizija umnjaka i neizniklih zuba» (лазер) — лазерной записи нет, метод в src
	('aphthous-ulcer-treatment', NULL, NULL, NULL), -- /turbo: «Terapija afti, herpesa, lihen planusa i drugih bolnih stanja u ustima» (лазер)
	('dental-crown-lengthening', NULL, NULL, NULL), -- /turbo: «Produženje klinicke krune zuba i gingivoplastika» (лазер)
	('gingivoplasty', NULL, NULL, NULL), -- /turbo: «… i gingivoplastika» (лазер)
	('dentin-hypersensitivity-treatment', NULL, NULL, NULL), -- /turbo: «Desenzibilizacija bola ogoljenih zuba oseljivih na hladno i toplo» (лазер; НОВАЯ запись) (НОВАЯ запись каталога)
	('intraoral-abscess-incision', NULL, NULL, NULL), -- /turbo: «Incizija apscesa» (лазер; внутриротовой доступ — единственный при лазерном вскрытии)
	('dental-consultation', NULL, NULL, NULL), -- /pregledi «Pregledi i konsultacije»: «zakažite Vaš prijegled i konsultaciju»
	('dental-implant-nobel-biocare', NULL, NULL, NULL), -- /implanti: «Implantat je vijak izrađen od titana … mogućnost odbacivanja implanta od strane Vašeg organizma (NOBEL Biocare), Vam sledeći ugrađuje gratis» — бренд назван
	('all-on-4-implant-prosthesis-nobel', NULL, NULL, NULL), -- /implanti: «možemo ih staviti u obliku fiksnog mosta na samo 4 implantata. To se zove sistem ALL-ON-FOUR» — импланты клиники Nobel Biocare (там же)
	('implant-suprastructure', NULL, NULL, NULL), -- /krunice_mostovi «Krunice i mostovi na zubnim implantima»: «Suprastruktura je veza između implantata i krunice. Izrađuje se od titanijuma ili cirkonijum keramike»
	('hybrid-abutment-zirconia', NULL, NULL, NULL), -- /krunice_mostovi: «Suprastrukture izrađene od cirkonijum keramike se često ugrađuju u implantate u prednjem dijelu vilice»
	('metal-ceramic-crown', NULL, NULL, NULL), -- /metalno_keramicke: «U osnovi, konstrukciji, imaju metal (čelik, titan, zlato), a sa svih strana presvučene su keramikom»
	('metal-ceramic-crown-gold', NULL, NULL, NULL), -- /metalno_keramicke: «metal (… zlato)», «Titanske i zlatne su kompjuterske izrade»
	('ceramic-crown-on-titanium', NULL, NULL, NULL), -- /metalno_keramicke: «metal (… titan …)», «Titanske i zlatne su kompjuterske izrade»
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- /bezmetalno_keramicke «Bezmetalno-keramičke – cirkon»: «Keramika na cirkonu … daje živu, prirodnu boju»
	('ceramic-dental-bridge', NULL, NULL, NULL), -- /bezmetalno_keramicke: «Krunice i mostovi izrađeni od cirkona jaki su …»
	('temporary-crown', NULL, NULL, NULL), -- /bezmetalno_keramicke: «U toku izrade krunice nose se privremene krunice»
	('complete-denture', NULL, NULL, NULL), -- /totalne_proteze: «Totalna proteza za zube stavlja se u slučajevima kada u vilici nema nijednog zuba» — материал не назван
	('skeletal-partial-denture', NULL, NULL, NULL), -- /skeletirana: «Skeletirana proteza … skelet od neplemenite legure (kobalt-hrom-molibden) … vizil ili wironit proteza»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- /proteze_dodaci «Proteze sa atačmenima»: «Atečemeni su zapravo mehanički sklopovi iz dva dijela»
	('implant-overdenture-with-locators', NULL, NULL, NULL); -- /proteza_implant: «Proteze na zubnim implantima … izrađene su od posebnih elemenata koji se vezuju na elemente koji su ugrađeni u implante … jednostavno uklanjaju iz usta» — съёмный протез на имплантах; тип замков не назван, единственная общая запись

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_w_dsm_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_w_dsm_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_w_dsm_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 8
-- Ортодонтия: единственный специалист-ортодонт — dr Danijela Sindik («specijalista ortopedije vilica») → 8 ортодонтических услуг на неё
-- (как Dentalux). dr Nevena Đuričić: «Edukovala se iz oblasti oralne higijene i oralne protetike» — обучение, не распределение услуг → без привязок.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_dsm_ds;
CREATE TEMPORARY TABLE tmp_w_dsm_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_w_dsm_ds (doctor_slug, service_slug) VALUES
	('danijela-sindik', 'invisalign-aligner'),
	('danijela-sindik', 'fixed-braces-metal-per-jaw'),
	('danijela-sindik', 'fixed-braces-ceramic-or-composite-per-jaw'),
	('danijela-sindik', 'lingual-braces-per-jaw'),
	('danijela-sindik', 'self-ligating-braces-metal-per-jaw'),
	('danijela-sindik', 'orthodontic-functional-monoblock-appliance'),
	('danijela-sindik', 'orthodontic-removable-plate-appliance'),
	('danijela-sindik', 'tmj-occlusal-splint');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_w_dsm_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_dsm_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 53, with_price = 0.
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
FROM medical_services ms WHERE ms.slug IN ('laser-periodontal-therapy', 'composite-inlay-onlay', 'tmj-occlusal-splint', 'dentin-hypersensitivity-treatment');

DROP TEMPORARY TABLE IF EXISTS tmp_w_dsm_services;
-- ═══════════════════════════════════════════════════════════════════════════
-- Dental Studio Pržno (Glušica), Sveti Stefan — Budva — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dental-studio-przno-budva.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-studio-przno-budva-services.sql
--
-- Источник: https://dentalstudioglusica.me/ (me), 10 страниц меню «USLUGE», curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные на страницах услуг. Пояснения «что это» без процедуры — в excluded записи импорта.
--
-- Итого: 28 услуг (0 с ценой), новых записей каталога — 3 (laser-periodontal-therapy, laser-root-canal-disinfection, biohpp-denture). Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ1S6cCobVTRMRKa9sXal5EB4' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dental-studio-przno-budva' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dental-studio-przno-budva.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

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

-- dentalstudioglusica.me: «sterilizacija kanala-endodoncija» лазером; «prije punjenja kanala … preporučuje se laserska terapija … smanjuje
-- se broj mikroorganizama». Отдельный этап эндодонтии, в каталоге нет. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'laser-root-canal-disinfection', 'Laser Root Canal Disinfection', 'Laserska dezinfekcija kanala korijena', 'Ласерска дезинфекција канала коријена',
	'Лазерная дезинфекция корневого канала', 'Laserdesinfektion des Wurzelkanals', 'Kök kanalının lazerle dezenfeksiyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'laser-root-canal-disinfection' OR name_en = 'Laser Root Canal Disinfection');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laserska sterilizacija kanala', 'sr' FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laserska terapija kanala korijena', 'sr' FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ласерска стерилизација канала', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laser-assisted endodontics', 'en' FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лазерная стерилизация корневых каналов', 'ru' FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Laserunterstützte Endodontie', 'de' FROM medical_services WHERE slug = 'laser-root-canal-disinfection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Lazer destekli kanal tedavisi', 'tr' FROM medical_services WHERE slug = 'laser-root-canal-disinfection';

-- dentalstudioglusica.me /proteze/: «proteze mogu biti: … Bio HPP proteze» — вид протеза наравне с акрилатными, скелетированными
-- и Valplast. В каталоге BioHPP нет (поиск biohpp/hpp/peek). Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'biohpp-denture', 'BioHPP Denture', 'BioHPP proteza', 'BioHPP протеза',
	'Протез из BioHPP', 'BioHPP-Prothese', 'BioHPP protez', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'biohpp-denture' OR name_en = 'BioHPP Denture');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bio HPP proteza', 'sr' FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'BioHPP protetski rad', 'sr' FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bio HPP протеза', 'sr-cyrl' FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'BioHPP prosthesis', 'en' FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Протез BioHPP', 'ru' FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zahnersatz aus BioHPP', 'de' FROM medical_services WHERE slug = 'biohpp-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'BioHPP protetik restorasyon', 'tr' FROM medical_services WHERE slug = 'biohpp-denture';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- intraoral-x-ray: dentalstudioglusica.me /rtg-dijagnostika-snimanje-zuba/: «Mali RA snimak koristi se … snimiti stanje jednog zuba» — разговорное название ретроальвеолярного снимка; формулировка клиники для поиска.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Mali RA snimak', 'sr' FROM medical_services WHERE slug = 'intraoral-x-ray';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Мали РА снимак', 'sr-cyrl' FROM medical_services WHERE slug = 'intraoral-x-ray';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (28)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_w_prz_services;
CREATE TEMPORARY TABLE tmp_w_prz_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_w_prz_services (slug, price, price_min, price_max) VALUES
	('laser-periodontal-therapy', NULL, NULL, NULL), -- /dentalni-laser/: «liječenje parodontopatije», «terapija zubnog džepa»; «1. Laserska operacija desni / Laserska operacija parodontoze», «3. Laserska obrada džepa» (НОВАЯ запись каталога)
	('laser-root-canal-disinfection', NULL, NULL, NULL), -- /dentalni-laser/: «liječenje kanala korijena zuba (sterilizacija kanala-endodoncija)»; /lijecenje-kanala-korijena-zuba/: «Upotreba lasera u endodonciji … preporučuje se laserska terapija» (НОВАЯ запись каталога)
	('laser-frenectomy', NULL, NULL, NULL), -- /dentalni-laser/: «incizija frenuluma», «2. Laserska operacija resice - frenektomija»; /djecija-i-preventivna-stomatologija/: «Lasersko uklanjanje frenuluma»
	('oral-mucosa-circumcision-or-excision', NULL, NULL, NULL), -- /dentalni-laser/: «cirkumcizija umnjaka» (laserom) — лазерной записи нет, метод в src
	('laser-teeth-whitening', NULL, NULL, NULL), -- /dentalni-laser/: «lasersko izbjeljivanje zuba»; /izbjeljivanje-zuba/: «3. Lasersko izbjeljivanje zuba … laser aktivira djelovanje gela»
	('home-teeth-whitening', NULL, NULL, NULL), -- /izbjeljivanje-zuba/: «1. Kućno izbjeljivanje … izrade folije koje pacijent dobija zajedno sa gelom i nosi kući»
	('teeth-whitening', NULL, NULL, NULL), -- /izbjeljivanje-zuba/: «2. Profesionalno izbjeljivanje zuba — Obavlja se u ordinaciji i traje do 45 minuta … Gel … se aktivira na svjetlost UV lampe»
	('composite-filling', NULL, NULL, NULL), -- /kompozitne-plombe/: «Kompozitne (bijele) plombe … jedini materijal koji može odgovoriti tim zahtjevima je kompozit»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- /ortodonski-aparati/: «Mobilni ortodontski aparat — Terapija mobilnim ortodontskim aparatima … u ranom dobu»; dječija: «Izrada mobilnih ortodontskih aparata»
	('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL), -- /ortodonski-aparati/: «Fiksna proteza sa bravicama … konvencionalnim ili klasičnim bravicama»; «Samoligirajući fiksni aparat» — материал брекетов не назван → generic (как dr-sevaljevic-tivat, решение координатора 2026-10-09)
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- /krunice-i-viniri/: «Bezmetalne krune … Osnova joj je cirkon, za razliku od metalokeramičke»
	('metal-ceramic-crown', NULL, NULL, NULL), -- /krunice-i-viniri/: «Metalokeramička kruna … Osnov je metal, dok se preko tog metala nanosi sloj keramike»
	('ceramic-veneer', NULL, NULL, NULL), -- /krunice-i-viniri/: «Viniri … ili keramičke fasete izradjuju se najsavremenijim CAD/CAM tehnikama»
	('machine-root-canal-treatment-per-canal', NULL, NULL, NULL), -- /lijecenje-kanala-korijena-zuba/: «Korišćenjem apeks lokatora … i mašinskom obradom kanala korijena postižu se izuzetna tačnost i uspješnost»
	('dental-implant-placement', NULL, NULL, NULL), -- /zubni-implanti/: «Implant predstavlja efikasnu zamjenu nedostajućeg zuba … Izrađeni su od biokompatibilnog materijala titanijuma» — бренд не назван
	('implant-suprastructure', NULL, NULL, NULL), -- /zubni-implanti/: «radi se protetika na implantatu. Na implat se ušrafljuje originalna odgovarajuća suprastruktura preko koje se cementira krunica»
	('partial-acrylic-denture', NULL, NULL, NULL), -- /proteze/: «Postoje dvije vrste akrilatnih proteza- parcijalna i totalna. Parcijalna akrilatna proteza …»
	('complete-acrylic-denture', NULL, NULL, NULL), -- /proteze/: «Postoje dvije vrste akrilatnih proteza- parcijalna i totalna»
	('skeletal-partial-denture', NULL, NULL, NULL), -- /proteze/: «Vizil ili metalne proteze (parcijalne skeletirane proteze)», «Skeletirana proteza … metalne kukice male veličine» (Vizil — уже синоним записи)
	('flexible-denture', NULL, NULL, NULL), -- /proteze/: «Silikonske proteze (valplast proteza)», «Valplast proteza, poznatija kao savitljiva» (Valplast — уже синоним записи)
	('biohpp-denture', NULL, NULL, NULL), -- /proteze/: «Bio HPP proteze», «Ovaj materijal koristimo kao osnovu u izradi kruna i mostova na implantima i u protezama» (НОВАЯ запись) (НОВАЯ запись каталога)
	('intraoral-x-ray', NULL, NULL, NULL), -- /rtg-dijagnostika-snimanje-zuba/: «Mali RA snimak … snimiti stanje jednog zuba»
	('panoramic-x-ray', NULL, NULL, NULL), -- /rtg-dijagnostika-snimanje-zuba/: «Ortopan snimak (OPT)»
	('3d-dental-x-ray-cbct', NULL, NULL, NULL), -- /rtg-dijagnostika-snimanje-zuba/: «3D, CBCT snimak … kada pacijet želi implantološko zbrinjavanje»; /zubni-implanti/: «Prvo što je neophodno uraditi je 3D snimak regije»
	('primary-tooth-extraction', NULL, NULL, NULL), -- /djecija-i-preventivna-stomatologija/: «U našoj ordinaciji pružamo sve usluge iz dječije stomatologije: Vađenje zuba»
	('pediatric-caries-treatment', NULL, NULL, NULL), -- /djecija-i-preventivna-stomatologija/: «Terapija karijesa»
	('dental-and-soft-tissue-trauma-treatment', NULL, NULL, NULL), -- /djecija-i-preventivna-stomatologija/: «Povreda Zuba»
	('dental-fissure-sealant', NULL, NULL, NULL); -- /djecija-i-preventivna-stomatologija/: «Zalivanje fisura»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_w_prz_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_w_prz_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_w_prz_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Сайт не распределяет услуги по врачам (оба — «DR stomatologije», без направлений) → привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 28, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
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
FROM medical_services ms WHERE ms.slug IN ('laser-periodontal-therapy', 'laser-root-canal-disinfection', 'biohpp-denture');

DROP TEMPORARY TABLE IF EXISTS tmp_w_prz_services;
-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dentalux (Tivat) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dentalux-tivat.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dentalux-tivat-services.sql
--
-- Источник: https://www.dentalux.me/ (me), curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные на сайте (7 разделов /me/обслуживание/…, статьи /me/service/…, акция Zoom).
-- Направления без конкретной процедуры, коронки/мосты без материала, менторство — в excluded записи импорта.
--
-- Итого: 29 услуг (0 с ценой), новых записей каталога — 1 (compomer-filling). Анализов нет.
-- Привязок врач↔услуга: 5.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJe7RkFpYxTBMRHTr3t1ahdTY' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dentalux-tivat' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dentalux-tivat.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- dentalux.me Restaurativna stomatologija: «koristimo … kompoziti, glasjonomeri, kompomeri». Композит и стеклоиономер в каталоге
-- есть, компомера — нет (поиск compomer/kompomer по name_* и синонимам). Категория 20, специальность 78 — как у glass-ionomer-filling.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'compomer-filling', 'Compomer Filling', 'Kompomerni ispun', 'Компомерни испун',
	'Компомерная пломба', 'Kompomerfüllung', 'Kompomer dolgu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'compomer-filling' OR name_en = 'Compomer Filling');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'compomer-filling';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'compomer-filling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompomer plomba', 'sr' FROM medical_services WHERE slug = 'compomer-filling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Компомер пломба', 'sr-cyrl' FROM medical_services WHERE slug = 'compomer-filling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Compomer restoration', 'en' FROM medical_services WHERE slug = 'compomer-filling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Пломба из компомера', 'ru' FROM medical_services WHERE slug = 'compomer-filling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompomer-Füllung', 'de' FROM medical_services WHERE slug = 'compomer-filling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompomer restorasyon', 'tr' FROM medical_services WHERE slug = 'compomer-filling';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- teeth-whitening: Сайт называет систему «Zoom lampa» (dentalux.me /me/usluge Za još blistaviji osmijeh, ortholine.me /izbjeljivanje-zuba «ZOOM TM izbjeljivanje»). Это ординационное отбеливание той же сути, что teeth-whitening; бренд-дубль не заводим (правило 10), бренд сохраняем синонимом для поиска.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zoom izbjeljivanje zuba', 'sr' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zoom избјељивање зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zoom teeth whitening', 'en' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Отбеливание Zoom', 'ru' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zoom-Bleaching', 'de' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zoom diş beyazlatma', 'tr' FROM medical_services WHERE slug = 'teeth-whitening';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (29)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_s_dlx_services;
CREATE TEMPORARY TABLE tmp_s_dlx_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_s_dlx_services (slug, price, price_min, price_max) VALUES
	('dental-caries-treatment', NULL, NULL, NULL), -- Restaurativna stomatologija: «U restaurativnu stomatologiju spadaju dijagnostika, liječenje zuba …», «Karijes … Redovne posjete stomatologu, u mnogome pomažu ranom otkrivanju karijesa i njegovom gotovo bezbolnom saniranju»
	('composite-filling', NULL, NULL, NULL), -- «… nadoknada oštećenog zubnog tkiva kompozitnim ispunama … kompoziti»
	('glass-ionomer-filling', NULL, NULL, NULL), -- «… koristimo najkvalitetnije materijale …: kompoziti, glasjonomeri, kompomeri»
	('compomer-filling', NULL, NULL, NULL), -- «… kompoziti, glasjonomeri, kompomeri» (НОВАЯ запись каталога)
	('aesthetic-tooth-restoration', NULL, NULL, NULL), -- «upotrebu estetskih adhezivnih materijala u boji zuba … idealnu estetsku rekonstrukciju oštećenih i oboljelih zuba»
	('fractured-tooth-build-up', NULL, NULL, NULL), -- «najčešće se radi zbrinjavanje zuba sa karijesnim i nekarijesnim oštećenjima …, zbrinjavanje frakturiranih krunica zuba»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- Protetika: «Postoje i kombinovane nadoknade, kod kojih je jedan dio fiksiran na postojeće zube, a drugi mobilan», «… bilo da se radi o krunicama, mostovima ili kombinovanim radovima»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- Ortodoncija: «ortodontsku terapiju mobilnim i fiksnim ortodontskim aparatima»; /me/service/Mobilne-proteze…: «Mobilne proteze … za korekciju nepravilnosti u mlađem uzrastu, obično između šest i 12 godina»
	('fixed-braces-metal-per-jaw', NULL, NULL, NULL), -- «kroz primjenu klasičnih metalnih bravica»; /me/service/Fiksne-proteze…: «koristimo izuzetne njemačke materijale proizvođača “Dentaurum”» (производитель брекетов, не отдельная запись)
	('fixed-braces-ceramic-or-composite-per-jaw', NULL, NULL, NULL), -- «… keramičkih bravica»
	('lingual-braces-per-jaw', NULL, NULL, NULL), -- «… ali i kroz primjenu lingvalne tehnike tj. lijepljenjem bravica sa unutrašnje strane zuba»
	('invisalign-aligner', NULL, NULL, NULL), -- «Folije za ispravljanje zuba — … jedan od najnaprednijih sistema za nevidljivo ispravljanje zuba – INVISALIGN»
	('dental-fissure-sealant', NULL, NULL, NULL), -- Dječja i preventivna stomatologija: «Radimo preventivno zalivanje fisura mliječnih i stalnih zuba»
	('topical-fluoride-treatment', NULL, NULL, NULL), -- «Pored toga radimo loklanu aplikaciju fluora»
	('dental-counseling', NULL, NULL, NULL), -- «Roditeljima i djeci dajemo iscrpne savjete i demonstriramo pravilno održavanje higijene usta i zuba … Dajemo savjete i u pogledu pravilne ishrane trudnica i djece»
	('dental-consultation', NULL, NULL, NULL), -- /me/service/Preventivna-stomatologija…: «redovni stomatološki pregledi … Ove posjete trebalo bi uvesti u svoju rutinu na svakih šest mjeseci»; /me/Kontakt: «zakažite pregled»
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- /me/service/Preventivna-stomatologija…: «Tokom redovnih posjeta stomatolog će vam očistiti zube od kamenca i plaka»
	('tooth-extraction', NULL, NULL, NULL), -- Oralna hirurgija: «grana stomatologije koja se bavi vađenjem zuba … omogućava vađenje zuba iz protetskih, ortodontskih, paradentoloških i drugih razloga»
	('wisdom-tooth-extraction', NULL, NULL, NULL), -- «U našem centru vršimo usluge hirurških zahvata, kao što su vađenje umnjaka»
	('apicoectomy', NULL, NULL, NULL), -- «… apikotomije»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- «… hirurške intervencije na parodoncijumu»
	('periodontal-pocket-treatment', NULL, NULL, NULL), -- «… terapija gingivalnih džepova»
	('dental-implant-placement', NULL, NULL, NULL), -- Implantologija: «Primjena dentalnih implantata …», «Jednostavna, bezbolna i brza hirurška procedura» — бренд не назван
	('implant-suprastructure', NULL, NULL, NULL), -- «U daljoj terapiji se za implantate vezuju protetske nadoknade (krunice, mostovi)»
	('teeth-whitening', NULL, NULL, NULL), -- Za još blistaviji osmijeh: «BIJELJENJE ZUBA ZOOM LAMPOM … za samo 30 minuta»; акция главной «IZBJELJIVANJE ZUBA ZOOM LAMPOM» — бренд Zoom сохранён синонимом
	('home-teeth-whitening', NULL, NULL, NULL), -- «BIJELJENJE ZUBA VACUUM FORMER APARATOM — … u ordinaciji se izrađuju folije za zube, koje služe kao nosači gela … Izbjeljivanje se zatim vrši u kućnim uslovima»
	('dental-jewelry-application', NULL, NULL, NULL), -- «NAKIT ZA ZUBE — … laka i brza ugradnja nekog blistavog ornamenta na površini zdravog zuba»
	('hyaluronic-acid-filler', NULL, NULL, NULL), -- «ANTI-AGING STOMATOLOGIJA — Našim pacijentima nudimo aplikaciju hijaluronske kiseline …» (показания: marionetske linije, nazolabijalne brazde, „pušačke bore”, hipotrofični ožiljci)
	('lip-augmentation', NULL, NULL, NULL); -- Показания к гиалуроновой кислоте: «asimetrije usana (genetske i stečene)», «volumen i kontura usana»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_s_dlx_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_s_dlx_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_s_dlx_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 5
-- Ortodoncija: «Terapiju vrši iskusan specijalista ortodoncije s višedecenijskim radnim iskustvom». Единственный специалист-ортодонт
-- с многолетним стажем — prof. dr Jasminka Anđelić (dr Ivana Anđelić — «budući specijalista») → 5 ортодонтических услуг на неё.
-- Остальные разделы сайт по врачам не называет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_s_dlx_ds;
CREATE TEMPORARY TABLE tmp_s_dlx_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_s_dlx_ds (doctor_slug, service_slug) VALUES
	('jasminka-andjelic', 'orthodontic-removable-plate-appliance'),
	('jasminka-andjelic', 'fixed-braces-metal-per-jaw'),
	('jasminka-andjelic', 'fixed-braces-ceramic-or-composite-per-jaw'),
	('jasminka-andjelic', 'lingual-braces-per-jaw'),
	('jasminka-andjelic', 'invisalign-aligner');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_s_dlx_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_s_dlx_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 29, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 5 привязок врач↔услуга.
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
FROM medical_services ms WHERE ms.slug IN ('compomer-filling');

DROP TEMPORARY TABLE IF EXISTS tmp_s_dlx_services;
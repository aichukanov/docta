-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Ortholine (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-ortholine-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ortholine-podgorica-services.sql
--
-- Источник: https://ortholine.me/ (WP REST, 29 страниц, modified 2020-04), curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- ⚠️ Страницы услуг 2020 года — перечень мог устареть. Заведены процедуры, прямо названные на страницах разделов и в «Pitanja pacijenata».
-- Бренды систем (Opalescence, Damon, Incognito, Componeer, Valplast) — синонимами к существующим записям той же сути; бренд-дублей не заводили.
--
-- Итого: 61 услуг (0 с ценой), новых записей каталога — 2 (inman-aligner, enamel-microabrasion). Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ4XH3VlLrTRMRIsNalxWsYSE' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ortholine-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ortholine-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- ortholine.me /mobilni-aparati: «Inman aparat … pokretni ortodontski aparat … nitinolske opruge sa unutrasnje strane i akrilatnu
-- plocu sa spoljasnje strane zuba». Не пластинка с винтом и не элайнер; в каталоге нет. Категория 34 ORTHODONTICS, специальность 93.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'inman-aligner', 'Inman Aligner', 'Inman aparat', 'Inman апарат',
	'Аппарат Inman Aligner', 'Inman-Aligner-Zahnspange', 'Inman aligner apareyi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'inman-aligner' OR name_en = 'Inman Aligner');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 34 FROM medical_services WHERE slug = 'inman-aligner';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 93 FROM medical_services WHERE slug = 'inman-aligner';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Inman aligner', 'sr' FROM medical_services WHERE slug = 'inman-aligner';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Инман апарат', 'sr-cyrl' FROM medical_services WHERE slug = 'inman-aligner';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Inman appliance', 'en' FROM medical_services WHERE slug = 'inman-aligner';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Аппарат Инмана', 'ru' FROM medical_services WHERE slug = 'inman-aligner';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Inman-Spange', 'de' FROM medical_services WHERE slug = 'inman-aligner';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Inman apareyi', 'tr' FROM medical_services WHERE slug = 'inman-aligner';

-- ortholine.me /bijeljenje-zuba: «IZBJELJIVANJE HIPERPIGMETNIRANIH ZUBA (FLUOROZA) — OPALUSTRE TM — Mikro abrazivna pasta … Hemijsko i
-- mehaničko izbjeljivanje». Не перекисное отбеливание и не Icon; в каталоге нет. Категория 20, специальность 78; Opalustre — синоним.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'enamel-microabrasion', 'Enamel Microabrasion', 'Mikroabrazija gleđi', 'Микроабразија глеђи',
	'Микроабразия эмали', 'Schmelz-Mikroabrasion', 'Mine mikroabrazyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'enamel-microabrasion' OR name_en = 'Enamel Microabrasion');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalustre', 'en' FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalustre', 'sr' FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Izbjeljivanje fluoroze', 'sr' FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Избјељивање флуорозе', 'sr-cyrl' FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Enamel microabrasion Opalustre', 'en' FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Микроабразия Opalustre', 'ru' FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Mikroabrasion des Zahnschmelzes', 'de' FROM medical_services WHERE slug = 'enamel-microabrasion';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Mikroabrazyon', 'tr' FROM medical_services WHERE slug = 'enamel-microabrasion';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- teeth-whitening: ortholine.me /bijeljenje-zuba: «Bijeljenje zuba u ordinaciji — Opalescence boost TM … Profesionalni sistem koji se izvodi u stomatološkoj ordinaciji». Та же суть, что teeth-whitening; бренд — синонимом (Zoom-синонимы добавлены импортом dentalux-tivat).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalescence Boost', 'en' FROM medical_services WHERE slug = 'teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalescence Boost izbjeljivanje', 'sr' FROM medical_services WHERE slug = 'teeth-whitening';
-- home-teeth-whitening: ortholine.me /izbjeljivanje-zuba: «izbjeljivanje zuba radimo američkim preparatom Opalescence … u ordinaciji se uzme otisak … kalup (tray) i pacijent nosi preparat u toku noći». Бренд геля — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalescence kućno izbjeljivanje', 'sr' FROM medical_services WHERE slug = 'home-teeth-whitening';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalescence home whitening', 'en' FROM medical_services WHERE slug = 'home-teeth-whitening';
-- internal-bleaching-of-devitalized-tooth: ortholine.me /bijeljenje-zuba: «BIJELJENJE LIJEČENIH/POTAMNJELIH ZUBA — OPALESCENCE ENDO TM … Gel se aplicira u unutrašnjost … potamnjelog zuba». Бренд — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalescence Endo', 'en' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Opalescence Endo', 'sr' FROM medical_services WHERE slug = 'internal-bleaching-of-devitalized-tooth';
-- self-ligating-braces-metal-per-jaw: ortholine.me /fiksni-ortodonski-aparati: «U Ortholine-u koristimo Damon system (Ormco) samoligirajucih breketa … metalne Damon bravice». Бренд системы — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Damon breketi', 'sr' FROM medical_services WHERE slug = 'self-ligating-braces-metal-per-jaw';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Damon брекети', 'sr-cyrl' FROM medical_services WHERE slug = 'self-ligating-braces-metal-per-jaw';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Damon braces', 'en' FROM medical_services WHERE slug = 'self-ligating-braces-metal-per-jaw';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Брекеты Damon', 'ru' FROM medical_services WHERE slug = 'self-ligating-braces-metal-per-jaw';
-- lingual-braces-per-jaw: ortholine.me /fiksni-ortodonski-aparati: «Lingvalne fiksne proteze … Najnovije kod nas! Incognito 3M … breketi se liju na zlatu». Та же суть (лингвальные брекеты), бренд — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Incognito lingvalne bravice', 'sr' FROM medical_services WHERE slug = 'lingual-braces-per-jaw';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Incognito lingual braces', 'en' FROM medical_services WHERE slug = 'lingual-braces-per-jaw';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лингвальные брекеты Incognito', 'ru' FROM medical_services WHERE slug = 'lingual-braces-per-jaw';
-- prefabricated-composite-veneer: ortholine.me /fasete: «Componeer fasete … nova vrsta faseta (vinira) izrađena od visoko kvalitetnog nano-hibridnog-kompozita … Coltène/Whaledent AG». Это и есть готовая (конфекционная) композитная ляминка; бренд — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Componeer', 'en' FROM medical_services WHERE slug = 'prefabricated-composite-veneer';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Componeer fasete', 'sr' FROM medical_services WHERE slug = 'prefabricated-composite-veneer';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Виниры Componeer', 'ru' FROM medical_services WHERE slug = 'prefabricated-composite-veneer';
-- flexible-denture: ortholine.me /mobilna-zubna-protetika: «… mnogo značajnije mjesto zauzimaju fiksne nadoknade (krunice i mostovi), skeletirane proteze i valplast proteze». Valplast = flexible denture (правило 10); бренд — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Valplast proteza', 'sr' FROM medical_services WHERE slug = 'flexible-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Valplast denture', 'en' FROM medical_services WHERE slug = 'flexible-denture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Протез Valplast', 'ru' FROM medical_services WHERE slug = 'flexible-denture';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (61)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_s_orl_services;
CREATE TEMPORARY TABLE tmp_s_orl_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_s_orl_services (slug, price, price_min, price_max) VALUES
	('dental-consultation', NULL, NULL, NULL), -- Početna: «Zakažite pregled — Redovna kontrola je pravi put do lijepog osmijeha … Zakažite kontrolu putem telefona»
	('panoramic-x-ray', NULL, NULL, NULL), -- /dijagnostika: «DIGITALNI ORTOPAN — Ortopan je panoramski snimak gornje i donje vilice … gotovo uvijek je sastavni dio prvog pregleda»
	('intraoral-x-ray', NULL, NULL, NULL), -- «U ordinaciji koristimo RVG senzor za snimanje pojedinacnih zuba», «kompletnu uslugu rendgenskog snimanja, bilo pojedinih zuba ili cijele vilice»
	('pediatric-dentist-consultation', NULL, NULL, NULL), -- /djecja-i-preventivna-stomatologija: «Prvu posjetu stomatologu trebalo bi uraditi do prve godine zivota … Rane posjete stomatologu I preventivna njega»
	('pediatric-dental-adaptation', NULL, NULL, NULL), -- «… kroz igru I razne animacije, plombe u boji, diplome I medalje za hrabre, oni rado dolaze»
	('pediatric-caries-treatment', NULL, NULL, NULL), -- «… plombe u boji» (детские пломбы), «Karijes mlečnih zuba …»
	('dental-fissure-sealant', NULL, NULL, NULL), -- «Zalivanje fisura — Je preventivna metoda zastite zuba tecnom kompozitnom plombom»
	('composite-filling', NULL, NULL, NULL), -- /konzervativna-stomatologija: «Kompozitni ispuni (bijele plombe) imaju veliku estetsku prednost»; /estetski-ispuni: «Kompozitni materijali novih generacija»
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- «ENDODONCIJA-LIJEČENJE KANALA KORIJENA ZUBA … koju možemo uraditi ručno i mašinski» — число каналов не названо
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('machine-root-canal-treatment-per-canal', NULL, NULL, NULL), -- «Mašinski postupak se radi uz pomoć endo-motora s apeks lokatorom»
	('apicoectomy', NULL, NULL, NULL), -- «Tada je neophodno uraditi hirušku sanaciju- apikotomiju»; /usluge Oralna hirurgija: «operisanje korena zuba»
	('ceramic-inlay-onlay', NULL, NULL, NULL), -- /keramicki-inlay: «Cjelokupni ispun … ispunjen je keramikom»; /fiksna-protetika: «Inlay I Onlay … koristimo Inlay ili Onlay keramicku nadoknadu»
	('ceramic-veneer', NULL, NULL, NULL), -- /fasete: «Veniri(fasete) su tanke ljuspe od porcelana koji se lijepe na prednje zube»
	('direct-composite-veneer', NULL, NULL, NULL), -- /pitanja-pacijenata, /fiksna-protetika: «Fasete mogu biti keramicke ili kompozitne»
	('prefabricated-composite-veneer', NULL, NULL, NULL), -- /fasete: «Componeer fasete – OSMIJEH ZA PONIJETI! … nano-hibridnog-kompozita … Coltène/Whaledent AG» (бренд — синонимом)
	('teeth-whitening', NULL, NULL, NULL), -- /bijeljenje-zuba: «Bijeljenje zuba u ordinaciji — Opalescence boost TM», «ZOOM TM izbjeljivanje … gel … aktivira se specijalno dizajniranom UV lampom»
	('home-teeth-whitening', NULL, NULL, NULL), -- «Bijeljenje zuba kod kuće — 10/15/20% H2O2 … Gel se nanosi u individualno izrađene trejeve»; /izbjeljivanje-zuba: «američkim preparatom Opalescence … kalup (tray)»
	('internal-bleaching-of-devitalized-tooth', NULL, NULL, NULL), -- «BIJELJENJE LIJEČENIH/POTAMNJELIH ZUBA — OPALESCENCE ENDO TM»
	('enamel-microabrasion', NULL, NULL, NULL), -- «IZBJELJIVANJE HIPERPIGMETNIRANIH ZUBA (FLUOROZA) — OPALUSTRE TM — Mikro abrazivna pasta» (НОВАЯ запись каталога)
	('dental-air-polishing', NULL, NULL, NULL), -- «Air flow metoda poliranja zuba — … Bezbolno skida plak, nikotinske naslage …»
	('orthodontic-consultation', NULL, NULL, NULL), -- /ortodoncija: «Prva posjeta ortodontu trebala bi biti u 7 godini zivota»
	('comprehensive-orthodontic-diagnostics', NULL, NULL, NULL), -- /fiksni-ortodonski-aparati: «Odluka o vidu terapije … donosi se nakon detaljne i sveobuhvatne analize studijskih modela i rentgenskih snimaka (ortopan i profilni telerentgen)»
	('orthodontic-treatment-of-impacted-permanent-teeth', NULL, NULL, NULL), -- /ortodoncija: «moguće je izvlaciti iz vilicne kosti zube koji nikada nisu nikli tzv: impaktirane zube (najcesce su to ocnjaci …)»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- /mobilni-aparati: «Mobilni aparati — Mogu biti aktivni i funkcionalni … kod djece od 8-14 godina»
	('orthodontic-functional-monoblock-appliance', NULL, NULL, NULL), -- «… i funkcionalni» (функциональный аппарат; в каталоге generic-функциональный — monoblok)
	('inman-aligner', NULL, NULL, NULL), -- «Inman aparat — Inman je jednostavan ortodontski aparat … nitinolske opruge … akrilatnu plocu» (НОВАЯ запись каталога)
	('fixed-braces-metal-per-jaw', NULL, NULL, NULL), -- /fiksni-ortodonski-aparati: «Metalni fiksni aparati — Mozete ih uciniti zanimljivim izborom ligaturnih gumica»
	('fixed-braces-ceramic-or-composite-per-jaw', NULL, NULL, NULL), -- «Estetski fiksni aparati … (bravice su od keramike, safirnog stakla)»; /estetske-fiksne-proteze: «polikarboksilat, keramika i safirno staklo»
	('fixed-braces-sapphire-per-jaw', NULL, NULL, NULL), -- «… safirnog stakla» (отдельный материал, запись в каталоге есть)
	('self-ligating-braces-metal-per-jaw', NULL, NULL, NULL), -- «U Ortholine-u koristimo Damon system (Ormco) samoligirajucih breketa … metalne Damon bravice» (бренд — синонимом)
	('lingual-braces-per-jaw', NULL, NULL, NULL), -- «Lingvalne fiksne proteze … Incognito 3M … Bravice se izrađuju koristeci 3D tehnologiju od legure zlata» (бренд — синонимом)
	('fixed-orthodontic-check-up', NULL, NULL, NULL), -- «Kontrolni pregledi najcesce se vrse u intervalima 2-4 sedmice»
	('orthodontic-retainer', NULL, NULL, NULL), -- «Nakon skidanja fixnog aparata … RETENCIJA. Ritejneri su mobilni aparati ili folije»
	('retention-aligner-fabrication', NULL, NULL, NULL), -- «Ritejneri su mobilni aparati ili folije koji se nose po skidanju fiksnih aparata»
	('metal-ceramic-crown', NULL, NULL, NULL), -- /fiksna-protetika: «Mogu biti izradjene kao metalo-keramicke …»
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- «… bezmetalne zirkonijum-keramicke …», «Zirkonijum keramika danas zauzima vodece mjesto»
	('ceramic-crown-on-titanium', NULL, NULL, NULL), -- «… titanijum-keramicke …», «Titan keramika — … u potpunosti je prekriven keramikom»
	('metal-ceramic-crown-gold', NULL, NULL, NULL), -- «… I zlato-keramicke krunice», «Zlato-keramika … cesto se koristi u pokrivanju premolara i molara»
	('temporary-crown', NULL, NULL, NULL), -- «Za izradu krunice potrebno je nekoliko dana, a pacijentu se za to vrijeme stavlja privremena krunica»
	('partial-acrylic-denture', NULL, NULL, NULL), -- /mobilna-zubna-protetika: «Parcijalne plocaste proteze nastarije su I najduze koriscene»
	('skeletal-partial-denture', NULL, NULL, NULL), -- «Parcijalna skeletirana proteza –Vizil proteza je maksimalno redukovana proteza ciju osnovu cini metalni skelet»
	('flexible-denture', NULL, NULL, NULL), -- «… skratirane proteze i valplast proteze» (Valplast = flexible denture; бренд — синонимом)
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- «Kombinovani protetski radovi … najcesce se koriste atecmeni»
	('complete-denture', NULL, NULL, NULL), -- /protetika: «… nadoknadjivanjem izgubljenih zuba krunicama, mostovima, fasetama (ljuskama) I parcijalnim ili totalnim protezama» — материал полного протеза не назван
	('dental-implant-placement', NULL, NULL, NULL), -- /implantologija: «Sama ugradnja implantata traje oko 30 minuta» — бренд не назван
	('bone-augmentation', NULL, NULL, NULL), -- «Ako nema [koštane mase], prije implantiranja vrši se operacija ugradnje vještačke kosti»
	('implant-suprastructure', NULL, NULL, NULL), -- «… na implant ušrafljuje nadograđena struktura (supra struktura) i vrši izrada protetskih nadoknada (krunica)»
	('hyaluronic-acid-filler', NULL, NULL, NULL), -- /hijaluronski-fileri: «Gdje upotrebljavamo hijaluronske filere? … obrva, temporalna regija … nazo-labijalna regija, marionete … brada»
	('lip-augmentation', NULL, NULL, NULL), -- «korektivna terapija usana (volumen i oblik, podizanje ugla usana, bore oko usana)»; /usluge: «… ili povecanje usana»
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- /parodontopatija: «Uklanjanjem dentalnog plaka, zubnog kamenca i drugih naslaga sa zuba …»
	('periodontal-scaling-root-planing', NULL, NULL, NULL), -- «Prva ili kauzalna faza lečenja … i obradom parodontalnih džepova»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- «Druga faza lečenja je hirurška faza. Različitim vrstama tzv. režanj operacija …»
	('periodontal-flap-surgery-with-bone-graft-per-tooth', NULL, NULL, NULL), -- «Popunjavanjem koštanih defekata “vještačkom kosti” tokom režanj operacije …»
	('gingivectomy', NULL, NULL, NULL), -- /gummy-smile: «Najcesce primjenjivana terapijska procedura je Gingivektomija»
	('laser-gingivectomy', NULL, NULL, NULL), -- «Gingivektomija se radi najcesce laserom, kod blazih slucajeva»
	('dental-crown-lengthening', NULL, NULL, NULL), -- «Produzavanje klinicke krunice — … kada postoji potreba za ekstenzivnijom redukcijom gingive, najcesce i dijela kosti»
	('tooth-extraction', NULL, NULL, NULL), -- /usluge Oralna hirurgija: «vađenje običnih zuba»
	('wisdom-tooth-extraction', NULL, NULL, NULL), -- «vađenje umnjaka operacijom»
	('surgical-extraction-of-residual-root', NULL, NULL, NULL), -- «… kao i vađenje zaostalog korijena zuba»
	('bruxism-night-guard', NULL, NULL, NULL); -- /pitanja-pacijenata «ZASTO SKRIPIMO ZUBIMA?»: «Na osnovu otisaka zuba pacijenta, radi se silikonski stitnik tzv: night-guard tray, koji se nosi nocu»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_s_orl_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_s_orl_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_s_orl_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Сайт не называет врачей у услуг — привязок нет (dr Dubravka Babić — единственный ортодонт, но ортодонтия ей явно не приписана).
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 61, with_price = 0.
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
FROM medical_services ms WHERE ms.slug IN ('inman-aligner', 'enamel-microabrasion');

DROP TEMPORARY TABLE IF EXISTS tmp_s_orl_services;
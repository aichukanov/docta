-- ═══════════════════════════════════════════════════════════════════════════
-- Opšta stomatološka ordinacija Mitranić (Bar) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-stomatoloska-ordinacija-mitranic-bar.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-mitranic-bar-services.sql
--
-- Источник: https://mitranicdental.com/ (me), главная + 16 страниц меню «Usluge», curl 2026-10-09. Прайса нет; все позиции price = NULL.
-- ⚠️ Страницы стоматологических услуг 2016–2018 — перечень мог устареть. Эстетика — 2020, Morpheus8 — 2024.
-- Заведены только процедуры, прямо названные на страницах. Пояснения без процедуры — в excluded записи импорта.
--
-- Итого: 41 услуг (0 с ценой), новых записей каталога — 2 (composite-diastema-closure, morpheus8-radiofrequency-microneedling). Анализов нет.
-- Привязок врач↔услуга: 9.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJB0JfTwB0ThMRXHNR6Zb9OVU' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'stomatoloska-ordinacija-mitranic-bar' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-stomatoloska-ordinacija-mitranic-bar.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- mitranicdental.com /konzervativna-stomatologija/: «koristimo i za estetske korekcije dijasteme … a bez brušenja zuba»; главная
-- (Smile Makeover): «zatvaranje diasteme … kompozitnim materijalima». В каталоге нет (поиск dijastem/diastem). Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'composite-diastema-closure', 'Composite Diastema Closure', 'Zatvaranje dijasteme kompozitom', 'Затварање дијастеме композитом',
	'Закрытие диастемы композитом', 'Diastemaschluss mit Komposit', 'Kompozit ile diastema kapatma', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'composite-diastema-closure' OR name_en = 'Composite Diastema Closure');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zatvaranje razmaka između zuba', 'sr' FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Estetska korekcija dijasteme', 'sr' FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Затварање размака између зуба', 'sr-cyrl' FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Diastema closure', 'en' FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gap closure with composite bonding', 'en' FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Закрытие щели между зубами', 'ru' FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Lückenschluss mit Komposit', 'de' FROM medical_services WHERE slug = 'composite-diastema-closure';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Diş arası boşluk kapatma', 'tr' FROM medical_services WHERE slug = 'composite-diastema-closure';

-- mitranicdental.com /morpheus8/: «Morpheus 8 … putem radiofrekvencije i mikroiglica dopire i do najdubljh slojeva kože».
-- В каталоге нет ни Morpheus8, ни RF-микронидлинга (dermapen-microneedling — без RF). Устройство в названии, как Ultraformer/Exilis.
-- Категории 18 + 24, специальности 7, 18, 44 (как dermapen-microneedling).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'morpheus8-radiofrequency-microneedling', 'Morpheus8 Radiofrequency Microneedling', 'Morpheus8 radiofrekventne mikroiglice', 'Morpheus8 радиофреквентне микроиглице',
	'Радиочастотный микронидлинг Morpheus8', 'Morpheus8 Radiofrequenz-Microneedling', 'Morpheus8 radyofrekans mikro iğneleme', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling' OR name_en = 'Morpheus8 Radiofrequency Microneedling');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 18 FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 24 FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 7 FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 18 FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 44 FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Morpheus 8', 'sr' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Morfeus 8', 'sr' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Морфеус 8', 'sr-cyrl' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Morpheus8 RF microneedling', 'en' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'RF microneedling', 'en' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Морфеус 8', 'ru' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'RF-Microneedling', 'de' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'RF mikro iğneleme', 'tr' FROM medical_services WHERE slug = 'morpheus8-radiofrequency-microneedling';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- facial-mesotherapy-single-treatment: mitranicdental.com /mezoterapija/: «Koristimo proizvode renomiranog proizvođača Aesthetic Dermal RRS … profesionalni mezoterapijski kokteli» — бренд коктейлей; та же процедура, что facial-mesotherapy-single-treatment, бренд-дубль не заводим (решение юзера 2026-10-08) → синоним.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'RRS mezoterapija', 'sr' FROM medical_services WHERE slug = 'facial-mesotherapy-single-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'RRS мезотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'facial-mesotherapy-single-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'RRS mesotherapy', 'en' FROM medical_services WHERE slug = 'facial-mesotherapy-single-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Мезотерапия RRS', 'ru' FROM medical_services WHERE slug = 'facial-mesotherapy-single-treatment';
-- mesothreads-treatment: mitranicdental.com /mezo-niti/: «Stadijumi delovanja za Mezotrax proceduru» — бренд мезонитей; та же процедура, что mesothreads-treatment → синоним.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Mezotrax', 'sr' FROM medical_services WHERE slug = 'mesothreads-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Mezotrax', 'en' FROM medical_services WHERE slug = 'mesothreads-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Мезотракс', 'sr-cyrl' FROM medical_services WHERE slug = 'mesothreads-treatment';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (41)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_w_mit_services;
CREATE TEMPORARY TABLE tmp_w_mit_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_w_mit_services (slug, price, price_min, price_max) VALUES
	('fissure-sealant-with-fluoride', NULL, NULL, NULL), -- /preventivna-stomatologija/: «ZALIVANJE FISURA … Zalivanje fisura vrši se tako što se na njih nanosi površinski premaz sa dodatkom fluora»; /djecja-stomatologija/: «ZALIVANJE FISURA»
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- /preventivna-stomatologija/: «UKLANJANJE MEKIH I ČVRSTIH ZUBNIH NASLAGA … (zubni kamenac)»
	('topical-fluoride-treatment', NULL, NULL, NULL), -- /preventivna-stomatologija/: «POLIRANJE ZUBA … koriste se paste sa visokim koncentracijama fluora (lokalna fluorizacija zuba)»; /djecja-stomatologija/: «FLORIZACIJA ZUBA»
	('dental-air-polishing', NULL, NULL, NULL), -- /preventivna-stomatologija/: «Poliranje se vrši takođe mikrogranulama pod pritiskom»
	('pediatric-dental-adaptation', NULL, NULL, NULL), -- /djecja-stomatologija/: «U prvoj posjeti djeteta nikada ne planiramo ozbiljnije intervencije nego upoznajemo dijete sa prostorom i instrumentima, kroz igru i razgovor»
	('dental-counseling', NULL, NULL, NULL), -- /djecja-stomatologija/: «Prva posjeta … U ovoj posjeti možete očekivati stručna uputstva o higijeni prvih zubića kao i savjete o ishrani» (как dentalux-tivat)
	('dental-caries-treatment', NULL, NULL, NULL), -- /konzervativna-stomatologija/: «Uklanjanje karijesa i lečenja oboljenja zubne pulpe …»
	('composite-filling', NULL, NULL, NULL), -- /konzervativna-stomatologija/: «Korišćenjem velikog spektra boja kompozitnih ispuna (plombi)»
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- /konzervativna-stomatologija/: «Liječenje oboljelog zuba uz tretiranje korjenskog kanala uz stalnu rentgensku kontrolu» — число каналов не названо (как Mušura, dr-sevaljevic-tivat)
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('composite-diastema-closure', NULL, NULL, NULL), -- /konzervativna-stomatologija/: «koristimo i za estetske korekcije dijasteme … bez brušenja zuba»; главная Smile Makeover: «zatvaranje diasteme … kompozitnim materijalima bez brušenja zuba» (НОВАЯ запись) (НОВАЯ запись каталога)
	('metal-ceramic-crown', NULL, NULL, NULL), -- /fiksna-protetika/: «Mogu se raditi na metalnoj osnovi (metalokeramičke krune I mostovi)»
	('metal-ceramic-bridge-pontic', NULL, NULL, NULL), -- /fiksna-protetika/: «… (metalokeramičke krune I mostovi)»
	('all-ceramic-crown', NULL, NULL, NULL), -- /fiksna-protetika/: «mogu se raditi I bez metalne osnove (bezmetalna keramika)»
	('metal-free-zirconia-ceramic-crown', NULL, NULL, NULL), -- /fiksna-protetika/: «u ponudi je takođe CIRKONIJUM keramika»
	('ceramic-dental-bridge', NULL, NULL, NULL), -- /fiksna-protetika/: «Krunice ili mostovi izdrađuju se od keramike najnovijih generacija … bez metalne osnove»
	('skeletal-partial-denture', NULL, NULL, NULL), -- /mobilna-protetika/: «SKELETIRANA PARCIJALNA VIZIL PROTEZA»
	('partial-acrylic-denture', NULL, NULL, NULL), -- /mobilna-protetika/: «PLOČASTA PARCIJALNA PROTEZA … proteze sa žičanim kukicama»
	('complete-acrylic-denture', NULL, NULL, NULL), -- /mobilna-protetika/: «TOTALNA AKRILATNA PROTEZA»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- /mobilna-protetika/: «KOMBINOVANI RADOVI … keramičke krunice sa posebnim ležistima za vezu … I Skeletirana proteza»
	('orthodontic-consultation', NULL, NULL, NULL), -- /ortodoncija/: «Djeca bi trebala doći na pregled kod ortodonta …», «Ortodontski pregledi moraju se obavljati periodično»
	('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL), -- /ortodoncija/: «U ortodonciji se koriste fiksni aparati koji su pričvršćeni na zube» — вид брекетов не назван
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- /ortodoncija/: «… i mobilni aparati (koje može stavljati i skidati prema uputstvima ortodonta)»
	('orthodontic-retainer', NULL, NULL, NULL), -- /ortodoncija/: «nakon završene terapije nose se tzv. retencioni aparati»
	('teeth-whitening', NULL, NULL, NULL), -- /izbjeljivanje-zuba/: «Ordinacijsko (profesionalno bjeljenje): vrsi se pod kontrolom ljekara u 2-3 seanse trajanja po 30 min a uz pomoć specijalnih lampi»
	('home-teeth-whitening', NULL, NULL, NULL), -- /izbjeljivanje-zuba/: «Kućno bjeljene: Nakon uzimanja otiska, pacijent dobija specijalne folije»
	('internal-bleaching-of-devitalized-tooth', NULL, NULL, NULL), -- /izbjeljivanje-zuba/: «Bjeljenje avitalnih zuba-prednje zube koji su devitalizovani … moguće je izbjeliti u 2-3 seanse»
	('dental-implant-straumann', NULL, NULL, NULL), -- /implantati/: «U Mitranić dental & aesthetic centru koristimo vrhunske Straumann implantate»
	('dental-implant-sweden-martina', NULL, NULL, NULL), -- /implantati/: «u našoj ponudi su i SWEDEN MARTINA implantni sistemi»
	('implant-suprastructure', NULL, NULL, NULL), -- /implantati/: «na njega se postavlja implantatska suprastruktura, na koju se zatim postavlja protetski rad»
	('intraoral-x-ray', NULL, NULL, NULL), -- /digitalna-radiografija/: «SIMENS SIRONA VARIO DG digitalni dentalni retgen aparat», «Svakih 6 mjeseci za dijagnostiku interdentalnih karijesa»
	('panoramic-x-ray', NULL, NULL, NULL), -- /digitalna-radiografija/: «Svake 2 godine panoramski (OPT) za opštu kontolu»; /implantati/: «digitalni rendgenski snimak obje vilice (ortopan)»
	('hyaluronic-acid-filler', NULL, NULL, NULL), -- /hijaluronski-fileri/: «Hijaluronski fileri …», «Remodelacija jagodica»; /estetska-medicina-2/: «Remodelovanje kompletnog lica (Full Face Aproach) - hijaluronskim filerima»
	('lip-augmentation', NULL, NULL, NULL), -- /hijaluronski-fileri/: «Usne (ivice, volumen, promjena oblika)»
	('wrinkle-correction-hyaluronic-acid', NULL, NULL, NULL), -- /hijaluronski-fileri/: «Nazolabijalne bore, Marionette, Bore iznad gornje usne, Bore ispod donje usne, Bore čeone regije, Bore izmedju obrva»
	('botox-injection', NULL, NULL, NULL), -- /botox-terapija-bora/: «Botox, u Europi poznat pod nazivom Vistabel … za uklanjanje bora na području čela» — назван Botox (vistabel-botox не ставили: Vistabel упомянут как европейское название того же препарата)
	('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- /mezoterapija/: «Mezoterapija je metoda koja se primjenjuje u estetskoj medicini s ciljem regeneracije kože … Koristimo proizvode … Aesthetic Dermal RRS» — бренд синонимом
	('mesothreads-treatment', NULL, NULL, NULL), -- /mezo-niti/: «Mezo-niti … Stadijumi delovanja za Mezotrax proceduru» — бренд синонимом
	('face-lifting-cog-threads', NULL, NULL, NULL), -- /mezo-niti/: «Mezo-niti u kombinaciji sa COG Lift nazubljenim nitima pružaju trenutno i prirodno podmlađivanje»
	('prp-facial-treatment', NULL, NULL, NULL), -- /estetska-medicina-2/, подменю: «PRP terapija» (отдельной страницы нет; раздел — эстетика лица)
	('morpheus8-radiofrequency-microneedling', NULL, NULL, NULL); -- /morpheus8/: «Morpheus 8 je revolucionarni aparat … putem radiofrekvencije i mikroiglica»; главная: «Morpheus8 inmode laserska platforma» (НОВАЯ запись) (НОВАЯ запись каталога)

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_w_mit_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_w_mit_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_w_mit_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 9
-- Эстетика: /estetska-medicina-2/ — «Dr Tamara Mitranić je licencirani ljekar u različitim oblastima nehirurške facijalne estetske medicine»; других
-- врачей-эстетистов на сайте нет → 9 эстетических процедур (филлеры, Botox, мезотерапия, нити, PRP, Morpheus8) на неё.
-- Стоматологию сайт по врачам не распределяет — привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_mit_ds;
CREATE TEMPORARY TABLE tmp_w_mit_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_w_mit_ds (doctor_slug, service_slug) VALUES
	('tamara-mitranic', 'hyaluronic-acid-filler'),
	('tamara-mitranic', 'lip-augmentation'),
	('tamara-mitranic', 'wrinkle-correction-hyaluronic-acid'),
	('tamara-mitranic', 'botox-injection'),
	('tamara-mitranic', 'facial-mesotherapy-single-treatment'),
	('tamara-mitranic', 'mesothreads-treatment'),
	('tamara-mitranic', 'face-lifting-cog-threads'),
	('tamara-mitranic', 'prp-facial-treatment'),
	('tamara-mitranic', 'morpheus8-radiofrequency-microneedling');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_w_mit_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_w_mit_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 41, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 9 привязок врач↔услуга.
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
FROM medical_services ms WHERE ms.slug IN ('composite-diastema-closure', 'morpheus8-radiofrequency-microneedling');

DROP TEMPORARY TABLE IF EXISTS tmp_w_mit_services;
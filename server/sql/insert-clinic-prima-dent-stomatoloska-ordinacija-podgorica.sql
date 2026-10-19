-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Prima Dent (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-prima-dent-stomatoloska-ordinacija-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/prima-dent-stomatoloska-ordinacija-podgorica.json):
--   * https://www.primadent.me/ — главная (врач, договор с ФЗО), /cjenovnik/ (wp-json modified
--     2023-07-17), /kontakt/ (2023-07-17), 7 страниц /usluge/* (2014–2015), /pacijenti/;
--   * data/google-places/podgorica/stomatoloska-ordinacija-prima-dent.json — place_id,
--     координаты 42.4428706 / 19.2506733, телефон +382 69 956 673. Отзывов 0.
--
-- Сверка: адрес «Bulevar Svetog Petra Cetinjskog br. 30, I sprat» (сайт) = Google
-- «30 Bulevar Svetog Petra Cetinjskog». Телефоны: +382 69 956 673 (сайт + Google),
-- +382 20 223 224 (футер), +382 69 956 670 (/kontakt/).
--
-- ДОГОВОР С ФЗОЦГ: на главной «NOVO!! IMAMO POTPISAN UGOVOR SA FONDOM ZDRAVSTVA CRNE
-- GORE NOVO!!» + «BESPLATNE USLUGE ZA: djecu do 18 g., studente do 26 g., trudnice,
-- penzionere preko 65 g.». Отдельного поля в схеме нет — факт в description_* и в
-- записи импорта.
--
-- Instagram на сайте не найден, есть только Facebook.
--
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug, врачи
-- по name_sr / перевёрнутому имени / slug; пустые поля существующей записи
-- дозаполняются, непустые не трогаются (status тоже). description_* клиники и
-- врачей пишутся БЕЗУСЛОВНЫМ UPDATE — правки описаний вносить сюда, иначе
-- следующий прогон их перезапишет. Языки клиники и часы синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJx7QUgULrTRMR-qolqxNm6Yo';
SET @clinic_slug = 'prima-dent-stomatoloska-ordinacija-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	1, -- CityId.PODGORICA
	'Stomatološka ordinacija Prima Dent',
	'Стоматолошка ординација Prima Dent',
	'Стоматологическая клиника Prima Dent',
	'Bulevar Svetog Petra Cetinjskog 30, I sprat',
	'Булевар Светог Петра Цетињског 30, I спрат',
	'',
	'',
	'81000',
	42.44287060,
	19.25067330,
	'+38269956673;+38220223224;+38269956670',
	'primadent.me@gmail.com',
	'https://www.primadent.me/',
	'facebook.com/primadent.me',
	'',
	'',
	'',
	'',
	'https://www.primadent.me/wp-content/uploads/2014/02/Untitled-primadent-300x102.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Prima Dent', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая клиника Prima Dent', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Bulevar Svetog Petra Cetinjskog 30, I sprat', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Булевар Светог Петра Цетињског 30, I спрат', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude = COALESCE(latitude, 42.44287060),
	longitude = COALESCE(longitude, 19.25067330),
	phone = IF(phone IS NULL OR phone = '', '+38269956673;+38220223224;+38269956670', phone),
	email = IF(email IS NULL OR email = '', 'primadent.me@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.primadent.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/primadent.me', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.primadent.me/wp-content/uploads/2014/02/Untitled-primadent-300x102.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (см. шапку). Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija u Podgorici, na Bulevaru Svetog Petra Cetinjskog 30 (I sprat), u kojoj ordinira dr Mašan Šljivančanin. Ordinacija ima potpisan ugovor sa Fondom za zdravstveno osiguranje Crne Gore, pa su usluge besplatne za djecu do 18 godina, studente do 26 godina, trudnice i penzionere starije od 65 godina. Ordinacija se bavi endodoncijom (ručnom i mašinskom, uključujući reviziju starih liječenja), dječijom i preventivnom stomatologijom, estetskom i restorativnom stomatologijom (profesionalno čišćenje, estetski ispuni, izbjeljivanje zuba), protetikom (metalokeramičke i cirkonijumske krunice, mostovi, akrilatne i skeletirane proteze, stabilizacione udlage za liječenje poremećaja viličnog zgloba), ortodoncijom i oralnom hirurgijom. Snimci zuba su digitalni.',
	description_sr_cyrl = 'Стоматолошка ординација у Подгорици, на Булевару Светог Петра Цетињског 30 (I спрат), у којој ординира др Машан Шљиванчанин. Ординација има потписан уговор са Фондом за здравствено осигурање Црне Горе, па су услуге бесплатне за дјецу до 18 година, студенте до 26 година, труднице и пензионере старије од 65 година. Ординација се бави ендодонцијом (ручном и машинском, укључујући ревизију старих лијечења), дјечијом и превентивном стоматологијом, естетском и ресторативном стоматологијом (професионално чишћење, естетски испуни, избјељивање зуба), протетиком (металокерамичке и цирконијумске крунице, мостови, акрилатне и скелетиране протезе, стабилизационе удлаге за лијечење поремећаја виличног зглоба), ортодонцијом и оралном хирургијом. Снимци зуба су дигитални.',
	description_ru = 'Стоматологическая клиника в Подгорице, на бульваре Светог Петра Цетиньског, 30 (второй этаж), где принимает доктор Машан Шливанчанин. У клиники заключён договор с Фондом медицинского страхования Черногории (ФЗО), поэтому услуги бесплатны для детей до 18 лет, студентов до 26 лет, беременных и пенсионеров старше 65 лет. Клиника занимается эндодонтией (ручной и машинной, включая перелечивание каналов), детской и профилактической стоматологией, эстетической и реставрационной стоматологией (профессиональная чистка, эстетические пломбы, отбеливание), протезированием (металлокерамические и циркониевые коронки, мосты, акриловые и бюгельные протезы, стабилизирующие шины для лечения нарушений височно-нижнечелюстного сустава), ортодонтией и хирургической стоматологией. Рентгеновские снимки зубов цифровые.',
	description_en = 'A dental practice in Podgorica, at Bulevar Svetog Petra Cetinjskog 30 (first floor), where Dr Mašan Šljivančanin practises. The practice has a contract with the Health Insurance Fund of Montenegro, so services are free for children under 18, students under 26, pregnant women and pensioners over 65. The practice provides endodontics (manual and rotary, including retreatment of old root fillings), paediatric and preventive dentistry, cosmetic and restorative dentistry (professional cleaning, tooth-coloured fillings, teeth whitening), prosthodontics (metal-ceramic and zirconia crowns, bridges, acrylic and cast-metal dentures, stabilisation splints for jaw joint disorders), orthodontics and oral surgery. Dental X-rays are digital.',
	description_de = 'Zahnarztpraxis in Podgorica, Bulevar Svetog Petra Cetinjskog 30 (1. Stock), in der Dr. Mašan Šljivančanin praktiziert. Die Praxis hat einen Vertrag mit dem Krankenversicherungsfonds Montenegros; daher sind die Leistungen für Kinder unter 18, Studierende unter 26, Schwangere und Rentner über 65 kostenlos. Angeboten werden Endodontie (manuell und maschinell, einschließlich Revision alter Wurzelfüllungen), Kinder- und Präventivzahnheilkunde, ästhetische und restaurative Zahnmedizin (professionelle Zahnreinigung, zahnfarbene Füllungen, Zahnaufhellung), Prothetik (Metallkeramik- und Zirkonkronen, Brücken, Kunststoff- und Modellgussprothesen, Stabilisierungsschienen bei Kiefergelenkbeschwerden), Kieferorthopädie und Oralchirurgie. Die Zahnröntgenaufnahmen sind digital.',
	description_tr = 'Podgorica''da Bulevar Svetog Petra Cetinjskog 30 (1. kat) adresinde, Dr. Mašan Šljivančanin''in hasta kabul ettiği diş kliniği. Kliniğin Karadağ Sağlık Sigortası Fonu ile sözleşmesi vardır; bu nedenle 18 yaş altı çocuklar, 26 yaş altı öğrenciler, hamileler ve 65 yaş üstü emekliler için hizmetler ücretsizdir. Klinikte endodonti (eski kanal tedavilerinin yenilenmesi dahil, el ve makine ile), çocuk ve koruyucu diş hekimliği, estetik ve restoratif diş hekimliği (profesyonel temizlik, estetik dolgular, diş beyazlatma), protez (metal seramik ve zirkonyum kronlar, köprüler, akrilik ve iskelet protezler, çene eklemi bozukluklarının tedavisi için stabilizasyon splintleri), ortodonti ve ağız cerrahisi hizmetleri sunulmaktadır. Diş röntgenleri dijitaldir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет
-- приём на других языках → только SR (LanguageId.SR = 1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы НЕ заполняются: сайт противоречит сам себе. Футер всех страниц: «ponedeljak - petak: 11h -19h / subota: 9h - 13h»; /kontakt/ (правка 2023-07-17): «PONEDELJAK - PETAK : 13h -20h / SUBOTA: po zakazivanju». Решение — за юзером (openQuestions).

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Специальность 78 = DENTISTRY. Язык 1 = SR (других сайт не заявляет).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Mašan Šljivančanin — stomatolog (специальность на сайте не указана)
-- Единственный врач клиники («Ordinira dr Mašan Šljivančanin»). Фото на сайте нет.
-- В БД есть однофамилец Predrag Šljivančanin (id 1399, офтальмолог) — другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mašan Šljivančanin' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Šljivančanin Mašan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'masan-sljivancanin' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'masan-sljivancanin', 'Mašan Šljivančanin', 'Машан Шљиванчанин', 'Машан Шливанчанин', 'Masan Sljivancanin', 'Dr',
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog u ordinaciji Prima Dent u Podgorici. Pored obaveznog ljekarskog staža ima višegodišnje iskustvo u privatnoj praksi. Kontinuirano se edukuje na seminarima i kongresima o različitim oblastima stomatologije, materijalima i tehnikama rada, o čemu svjedoče brojni sertifikati i diplome.',
	description_sr_cyrl = 'Стоматолог у ординацији Prima Dent у Подгорици. Поред обавезног љекарског стажа има вишегодишње искуство у приватној пракси. Континуирано се едукује на семинарима и конгресима о различитим областима стоматологије, материјалима и техникама рада, о чему свједоче бројни сертификати и дипломе.',
	description_ru = 'Стоматолог клиники Prima Dent в Подгорице. Помимо обязательной врачебной стажировки, имеет многолетний опыт частной практики. Постоянно повышает квалификацию на семинарах и конгрессах по различным разделам стоматологии, материалам и методикам, что подтверждают многочисленные сертификаты и дипломы.',
	description_en = 'A dentist at the Prima Dent practice in Podgorica. In addition to the mandatory medical internship, he has many years of experience in private practice. He continuously trains at seminars and congresses on various fields of dentistry, materials and techniques, as shown by numerous certificates and diplomas.',
	description_de = 'Zahnarzt in der Praxis Prima Dent in Podgorica. Neben dem obligatorischen ärztlichen Praktikum verfügt er über langjährige Erfahrung in der Privatpraxis. Er bildet sich laufend auf Seminaren und Kongressen zu verschiedenen Bereichen der Zahnmedizin, zu Materialien und Arbeitstechniken fort, wovon zahlreiche Zertifikate und Diplome zeugen.',
	description_tr = 'Podgorica''daki Prima Dent kliniğinin diş hekimi. Zorunlu hekimlik stajının yanı sıra özel muayenehanede uzun yıllara dayanan deneyime sahiptir. Diş hekimliğinin çeşitli alanları, malzemeler ve çalışma teknikleri üzerine seminer ve kongrelerde sürekli olarak kendini geliştirmekte olup bunu çok sayıda sertifika ve diploma belgelemektedir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '2', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1 врач(а); created_at сильно раньше запуска = переиспользован
-- существующий врач — убедиться, что это тот же человек.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	IF(d.description_sr IS NULL, 'NO BIO', 'ok') AS bio,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;

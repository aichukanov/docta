-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dent-ES (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dent-es-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/dent-es-podgorica.json):
--   * https://dent-es.me/ — WordPress. WP REST /wp-json/wp/v2/pages: Početna (modified 2025-02-16), Usluge (2017-11-06),
--     O Nama (2017-10-10), Stručni tim (2017-10-10), Kontakt (2021-02-16). ⚠️ Услуги и состав — по состоянию на 2017,
--     состав мог устареть. На главной 2025 — баннер EYCA-скидки и часы работы.
--   * data/google-places/podgorica/stomatoloska-ordinacija-dent-es.json — place_id, координаты, телефон.
-- Адрес: сайт «CITY KVART, LAMELA2-7/L-3C, 81000 Podgorica» = Google. Телефоны: ordinacija +382 20 512 697 (= Google),
-- +382 67 874 362; «Ortopan kabinet: +382 67 481 047». Email, Facebook, логотип — сайт.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJyzoiodjqTRMRkYqHpi_xiNU';
SET @clinic_slug = 'dent-es-podgorica';

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
	'Stomatološka ordinacija Dent-ES',
	'Стоматолошка ординација Dent-ES',
	'Стоматологический кабинет Dent-ES',
	'City kvart, lamela 2-7/L-3C',
	'Сити кварт, ламела 2-7/L-3C',
	'',
	'',
	'81000',
	42.44027900,
	19.23530500,
	'+38220512697;+38267874362;+38267481047',
	'ordinacija.dentes@gmail.com',
	'https://dent-es.me/',
	'facebook.com/stomatoloskaordinacija.dentes',
	'',
	'',
	'',
	'',
	'https://dent-es.me/wp-content/uploads/2016/09/NOVI-LOGO-1.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Dent-ES', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Dent-ES', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'City kvart, lamela 2-7/L-3C', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Сити кварт, ламела 2-7/L-3C', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220512697;+38267874362;+38267481047', phone),
	email = IF(email IS NULL OR email = '', 'ordinacija.dentes@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://dent-es.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/stomatoloskaordinacija.dentes', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://dent-es.me/wp-content/uploads/2016/09/NOVI-LOGO-1.png', logo_url),
	latitude = COALESCE(latitude, 42.44027900),
	longitude = COALESCE(longitude, 19.23530500)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Dent-ES“ (PZU Specijalistička stomatološka i ortodontska ordinacija) nalazi se u Podgorici, u City kvartu (lamela 2-7/L-3C), i radi od 2012. godine. Pruža osnovne stomatološke usluge za djecu i odrasle, protetske, ortodontske i hirurške usluge, kao i snimanje zuba — ortopan i klasični snimak zuba. Iz oblasti ortodoncije ordinacija ima ugovor sa Fondom za zdravstveno osiguranje, tako da djeca uz ovjerenu zdravstvenu knjižicu mogu besplatno dobiti mobilne ortodontske aparate. U ordinaciji rade tri doktora — dvije specijalistkinje ortopedije vilica i stomatolog.',
	description_sr_cyrl = 'Стоматолошка ординација „Dent-ES“ (ПЗУ Специјалистичка стоматолошка и ортодонтска ординација) налази се у Подгорици, у Сити кварту (ламела 2-7/L-3C), и ради од 2012. године. Пружа основне стоматолошке услуге за дјецу и одрасле, протетске, ортодонтске и хируршке услуге, као и снимање зуба — ортопан и класични снимак зуба. Из области ортодонције ординација има уговор са Фондом за здравствено осигурање, тако да дјеца уз овјерену здравствену књижицу могу бесплатно добити мобилне ортодонтске апарате. У ординацији раде три доктора — двије специјалисткиње ортопедије вилица и стоматолог.',
	description_ru = 'Стоматологический кабинет «Dent-ES» (частное учреждение — специализированный стоматологический и ортодонтический кабинет) находится в Подгорице, в квартале City kvart (ламела 2-7/L-3C), и работает с 2012 года. Кабинет оказывает базовые стоматологические услуги детям и взрослым, услуги протезирования, ортодонтии и хирургической стоматологии, а также делает снимки зубов — ортопантомограмму и обычный прицельный снимок. По ортодонтии у кабинета договор с Фондом медицинского страхования: дети с заверенной медицинской книжкой могут бесплатно получить съёмные ортодонтические аппараты. В кабинете работают три врача — два специалиста по ортодонтии и стоматолог.',
	description_en = 'Dent-ES is a specialist dental and orthodontic practice in Podgorica, in the City kvart district (lamela 2-7/L-3C), operating since 2012. It provides basic dental care for children and adults, prosthodontic, orthodontic and oral surgery services, and dental X-rays — panoramic (OPG) and conventional intraoral images. For orthodontics the practice has a contract with the Health Insurance Fund, so children with a validated health insurance card can receive removable orthodontic appliances free of charge. Three doctors work here: two orthodontics specialists and a dentist.',
	description_de = 'Dent-ES ist eine fachzahnärztliche und kieferorthopädische Praxis in Podgorica im Viertel City kvart (lamela 2-7/L-3C) und besteht seit 2012. Angeboten werden zahnärztliche Grundversorgung für Kinder und Erwachsene, Prothetik, Kieferorthopädie und Oralchirurgie sowie Röntgenaufnahmen der Zähne – Panoramaaufnahme (OPG) und klassische Einzelzahnaufnahme. Im Bereich Kieferorthopädie hat die Praxis einen Vertrag mit dem Krankenversicherungsfonds, sodass Kinder mit beglaubigtem Versicherungsheft herausnehmbare kieferorthopädische Apparaturen kostenlos erhalten können. Hier arbeiten drei Ärzte: zwei Fachärztinnen für Kieferorthopädie und ein Zahnarzt.',
	description_tr = 'Dent-ES, Podgorica''nın City kvart semtinde (lamela 2-7/L-3C) bulunan, 2012''den beri hizmet veren uzman diş ve ortodonti muayenehanesidir. Çocuklar ve yetişkinler için temel diş tedavileri, protez, ortodonti ve ağız cerrahisi hizmetleri ile diş röntgeni — panoramik (OPG) ve klasik diş filmi — sunar. Ortodonti alanında Sağlık Sigortası Fonu ile sözleşmesi vardır; onaylı sağlık karnesi olan çocuklar hareketli ortodontik apareyleri ücretsiz alabilir. Muayenehanede iki ortodonti uzmanı ve bir diş hekimi olmak üzere üç hekim çalışır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: главная (modified 2025-02-16): «Radno vrijeme: Ponedeljak-Petak 09-20h. Subotom i nedjeljom ne radimo». На «O Nama» (2017) — старый график 09–18 и каждая вторая суббота; взят свежий.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3)
-- Состав — /strucni-tim/ (2017-10-10) и блок «Stručni tim» на главной: 3 доктора + Tatjana Đaletić («Stomatološka sestra») — сестра
-- не заводится. В БД никого из троих нет (поиск 2026-10-09: Rakočević/Žujović есть только с другими именами).
-- Специальности: 78 = DENTISTRY, 93 = ORTHODONTIST. Язык 1 = SR.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Maida Hrapović — Specijalista ortopedije vilica
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Maida Hrapović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Hrapović Maida' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'maida-hrapovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'maida-hrapovic', 'Maida Hrapović', 'Маида Храповић', 'Маида Храпович', 'Maida Hrapovic', 'dr',
	'https://dent-es.me/wp-content/uploads/2015/03/Maida-Hrapovic-1.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista ortopedije vilica. Stomatološki fakultet u Beogradu završila je 1996. godine, a specijalističke studije iz ortopedije vilica 2004. godine. Najveći dio radnog vremena posvećuje ortodonciji, a bavi se i estetskom stomatologijom. Redovno pohađa stomatološke seminare i kongrese.',
	description_sr_cyrl = 'Специјалиста ортопедије вилица. Стоматолошки факултет у Београду завршила је 1996. године, а специјалистичке студије из ортопедије вилица 2004. године. Највећи дио радног времена посвећује ортодонцији, а бави се и естетском стоматологијом. Редовно похађа стоматолошке семинаре и конгресе.',
	description_ru = 'Специалист по ортодонтии. В 1996 году окончила стоматологический факультет в Белграде, в 2004 году — специализацию по ортодонтии. Большую часть рабочего времени посвящает ортодонтии, занимается также эстетической стоматологией. Регулярно посещает стоматологические семинары и конгрессы.',
	description_en = 'Orthodontics specialist. She graduated from the School of Dentistry in Belgrade in 1996 and completed her specialist training in orthodontics in 2004. She devotes most of her working time to orthodontics and also practises cosmetic dentistry. She regularly attends dental seminars and congresses.',
	description_de = 'Fachärztin für Kieferorthopädie. Sie schloss 1996 das Zahnmedizinstudium in Belgrad und 2004 die Fachausbildung in Kieferorthopädie ab. Den größten Teil ihrer Arbeitszeit widmet sie der Kieferorthopädie, daneben ist sie in der ästhetischen Zahnheilkunde tätig. Sie besucht regelmäßig zahnmedizinische Seminare und Kongresse.',
	description_tr = 'Ortodonti uzmanı. 1996''da Belgrad Diş Hekimliği Fakültesinden mezun oldu, 2004''te ortodonti uzmanlık eğitimini tamamladı. Çalışma zamanının büyük bölümünü ortodontiye ayırır, estetik diş hekimliğiyle de ilgilenir. Diş hekimliği seminer ve kongrelerine düzenli olarak katılır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Tanja Rakočević — Specijalista ortopedije vilica
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Tanja Rakočević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Rakočević Tanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'tanja-rakocevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'tanja-rakocevic', 'Tanja Rakočević', 'Тања Ракочевић', 'Таня Ракочевич', 'Tanja Rakocevic', 'dr',
	'https://dent-es.me/wp-content/uploads/2015/03/Tanja-Rakocevic-1.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Drago Žujović — Stomatolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Drago Žujović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Žujović Drago' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'drago-zujovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'drago-zujovic', 'Drago Žujović', 'Драго Жујовић', 'Драго Жуйович', 'Drago Zujovic', 'dr',
	'https://dent-es.me/wp-content/uploads/2015/03/Drago-Zujovic-1.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 2, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3 врач(а/ей): maida-hrapovic, tanja-rakocevic, drago-zujovic.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	IF(d.description_sr IS NULL OR d.description_sr = '', 'NO BIO', 'ok') AS bio,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;

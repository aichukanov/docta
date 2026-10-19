-- ═══════════════════════════════════════════════════════════════════════════
-- Dentix — Stomatološka ordinacija Dr Đurković (Nikšić) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dentix-djurkovic-niksic.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/dentix-djurkovic-niksic.json):
--   * https://www.djurkovicdent.me/ — статичный шаблон (index/about/services/contact), Last-Modified 2022-12-12.
--   * data/google-places/niksic/dentix-stomatoloska-ordinacija-dr-djurkovic.json — place_id, координаты.
-- Филиал; Podgorica — server/sql/insert-clinic-dentix-djurkovic-podgorica.sql. Врачи find-or-create в обоих файлах.
-- ⚠️ В Google два места по ОДНОМУ адресу «22 Dr Nika Miljanića»: «Dentix - Стоматолошка ординација Др.Ђурковић»
-- (ChIJQ8a_pU2oTRMRbxwj1PwkZpk, 31 отзыв, +382 69 078 272) и «Đurković Dent» (ChIJkQJkUJupTRMROd69naruGTw, 8 отзывов,
-- +382 68 108 272; data/google-places/niksic/djurkovic-dent.json) — дубль одной ординации. Взято первое (больше отзывов);
-- второе — в openQuestions записи импорта (отзывы обоих мест при выгрузке сводить в эту клинику).
-- Адрес: сайт «Nika Miljanica 22» = Google «22 Dr Nika Miljanića, Nikšić 81400». Телефоны 068/108-272 и 069/078-272 —
-- сайт (без привязки к ординации), оба подтверждены Google-местами.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJQ8a_pU2oTRMRbxwj1PwkZpk';
SET @clinic_slug = 'dentix-djurkovic-niksic';

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
	2, -- CityId.NIKSIC
	'Dentix Dr Đurković Nikšić',
	'Dentix Др Ђурковић Никшић',
	'Стоматология Dentix доктора Джурковича (Никшич)',
	'Nika Miljanića 22',
	'Ника Миљанића 22',
	'',
	'',
	'81400',
	42.77765090,
	18.94807230,
	'+38268108272;+38269078272',
	'velibordjurkovic9@yahoo.com',
	'https://www.djurkovicdent.me/',
	'facebook.com/velibor.djurkovic',
	'@djurkovic_dent',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Dentix Др Ђурковић Никшић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматология Dentix доктора Джурковича (Никшич)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Nika Miljanića 22', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Ника Миљанића 22', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81400', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38268108272;+38269078272', phone),
	email = IF(email IS NULL OR email = '', 'velibordjurkovic9@yahoo.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.djurkovicdent.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/velibor.djurkovic', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@djurkovic_dent', instagram),
	latitude = COALESCE(latitude, 42.77765090),
	longitude = COALESCE(longitude, 18.94807230)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Dentix“ dr Đurkovića (Đurković Dent) radi u Nikšiću, u Ulici Nika Miljanića 22, a druga ordinacija nalazi se u Podgorici, u Ulici 13. jula 15. U timu su četiri doktora stomatologije, a ordinacija navodi više od 20 godina iskustva. Bavi se parodontologijom i oralnom medicinom, oralnom hirurgijom (vađenje zuba, hirurško vađenje umnjaka, apikotomija, resekcija frenuluma, operacija režnja), implantologijom, endodoncijom, opštom stomatologijom, protetikom, ortodoncijom (mobilni i fiksni aparati), izbjeljivanjem zuba i dječijom stomatologijom. Za snimanje zuba koristi 3D snimanje, ortopan (2D) i retroalveolarni radiogram, a diodni laser primjenjuje za uklanjanje frenuluma, gingivektomiju, lasersko izbjeljivanje, endodonciju i terapiju afti.',
	description_sr_cyrl = 'Стоматолошка ординација „Dentix“ др Ђурковића (Đurković Dent) ради у Никшићу, у Улици Ника Миљанића 22, а друга ординација налази се у Подгорици, у Улици 13. јула 15. У тиму су четири доктора стоматологије, а ординација наводи више од 20 година искуства. Бави се пародонтологијом и оралном медицином, оралном хирургијом (вађење зуба, хируршко вађење умњака, апикотомија, ресекција френулума, операција режња), имплантологијом, ендодонцијом, општом стоматологијом, протетиком, ортодонцијом (мобилни и фиксни апарати), избјељивањем зуба и дјечијом стоматологијом. За снимање зуба користи 3D снимање, ортопан (2D) и ретроалвеоларни радиограм, а диодни ласер примјењује за уклањање френулума, гингивектомију, ласерско избјељивање, ендодонцију и терапију афти.',
	description_ru = 'Стоматологический кабинет Dentix доктора Джурковича (Đurković Dent) работает в Никшиче, на улице Ника Милянича, 22; второй кабинет находится в Подгорице, на улице 13 Июля, 15. В команде четыре врача-стоматолога; клиника указывает более 20 лет опыта. Здесь занимаются пародонтологией и заболеваниями слизистой полости рта, хирургической стоматологией (удаление зубов, хирургическое удаление зубов мудрости, резекция верхушки корня, иссечение уздечки, лоскутные операции), имплантацией, эндодонтией, общей стоматологией, протезированием, ортодонтией (съёмные и несъёмные аппараты), отбеливанием зубов и детской стоматологией. Для диагностики используются 3D-снимки, ортопантомограмма (2D) и прицельные снимки, а диодный лазер применяется для иссечения уздечки, гингивэктомии, лазерного отбеливания, эндодонтии и лечения афт.',
	description_en = 'The Dentix dental practice of Dr Đurković (Đurković Dent) is located in Nikšić, at Nika Miljanića Street 22; its second practice is in Podgorica, at 13. jula Street 15. The team consists of four dentists, and the practice cites more than 20 years of experience. It provides periodontology and oral medicine, oral surgery (tooth extraction, surgical wisdom tooth removal, apicoectomy, frenectomy, flap surgery), implantology, endodontics, general dentistry, prosthodontics, orthodontics (removable and fixed appliances), teeth whitening and paediatric dentistry. Imaging includes 3D scans, panoramic (2D) and periapical X-rays, and a diode laser is used for frenectomy, gingivectomy, laser whitening, endodontics and the treatment of mouth ulcers.',
	description_de = 'Die Zahnarztpraxis Dentix von Dr. Đurković (Đurković Dent) befindet sich in Nikšić, Straße Nika Miljanića 22; die zweite Praxis liegt in Podgorica, Straße 13. jula 15. Das Team besteht aus vier Zahnärzten; die Praxis verweist auf mehr als 20 Jahre Erfahrung. Angeboten werden Parodontologie und Oralmedizin, Oralchirurgie (Zahnextraktion, chirurgische Weisheitszahnentfernung, Wurzelspitzenresektion, Frenektomie, Lappenoperation), Implantologie, Endodontie, allgemeine Zahnheilkunde, Prothetik, Kieferorthopädie (herausnehmbare und feste Apparaturen), Zahnaufhellung und Kinderzahnheilkunde. Für die Bildgebung stehen 3D-Aufnahmen, Panoramaaufnahmen (2D) und Einzelzahnaufnahmen zur Verfügung; ein Diodenlaser wird für Frenektomie, Gingivektomie, Laser-Bleaching, Endodontie und die Behandlung von Aphthen eingesetzt.',
	description_tr = 'Dr. Đurković''in Dentix diş muayenehanesi (Đurković Dent) Nikšić''te Nika Miljanića Caddesi 22 adresindedir; ikinci muayenehanesi Podgorica''da 13. jula Caddesi 15 adresindedir. Ekipte dört diş hekimi bulunur; muayenehane 20 yılı aşkın deneyime sahip olduğunu belirtir. Periodontoloji ve ağız hastalıkları, ağız cerrahisi (diş çekimi, cerrahi yirmilik dişi çekimi, apikal rezeksiyon, frenektomi, flep operasyonu), implantoloji, endodonti, genel diş hekimliği, protez, ortodonti (hareketli ve sabit apareyler), diş beyazlatma ve çocuk diş hekimliği hizmetleri sunulur. Görüntülemede 3D çekim, panoramik (2D) ve periapikal röntgen kullanılır; diyot lazer frenektomi, gingivektomi, lazerle beyazlatma, endodonti ve aft tedavisinde uygulanır.'
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

-- Часы работы: /contact.html (там только адрес Nikšić): «Radno vrijeme — Pon-Pet 09h-20h, Sub: 10h-13h, 16h-19h». Воскресенье не названо — выходной.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "13:00"},{"start": "16:00", "end": "19:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (4)
-- Состав — главная («Upoznajte nas tim») и /about.html: 4 «Doktor stomatologije», в футере «Dr.». Сайт не делит
-- врачей по ординациям — вся команда привязана к обеим (Nikšić и Podgorica). Имена на сайте без диакритики
-- («Djurkovic», «Snezana Perovic», «Natasa Memedovic»); записаны в сербской орфографии (Google: «Др.Ђурковић»).
-- Сёстры Vesna Popović и Sanja Samardžić — не врачи, не заводятся. Все 4 — новые (локально и прод-API: 204).
-- Специальности: 78 = DENTISTRY. Языки: 1 = SR, 3 = EN, 6 = DE.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Vidoje Đurković — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vidoje Đurković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đurković Vidoje' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vidoje-djurkovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vidoje-djurkovic', 'Vidoje Đurković', 'Видоје Ђурковић', 'Видое Джуркович', 'Vidoje Djurkovic', 'Dr',
	'https://www.djurkovicdent.me/assets/images/djurkovic/004A9906.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Velibor Đurković — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Velibor Đurković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đurković Velibor' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'velibor-djurkovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'velibor-djurkovic', 'Velibor Đurković', 'Велибор Ђурковић', 'Велибор Джуркович', 'Velibor Djurkovic', 'Dr',
	'https://www.djurkovicdent.me/assets/images/djurkovic/004A9888.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Snežana Perović — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Snežana Perović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Perović Snežana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'snezana-perovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-perovic', 'Snežana Perović', 'Снежана Перовић', 'Снежана Перович', 'Snezana Perovic', 'Dr',
	'https://www.djurkovicdent.me/assets/images/djurkovic/004A9897.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Nataša Memedović — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nataša Memedović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Memedović Nataša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'natasa-memedovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natasa-memedovic', 'Nataša Memedović', 'Наташа Мемедовић', 'Наташа Мемедович', 'Natasa Memedovic', 'Dr',
	'https://www.djurkovicdent.me/assets/images/djurkovic/natasa%20dr.JPG', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 2, status = published, clinic_languages = 1, clinic_types = 2, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 4 врач(а/ей): vidoje-djurkovic, velibor-djurkovic, snezana-perovic, natasa-memedovic.
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

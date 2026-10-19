-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Dr Vuksanović — laboratorija Ulcinj — клиника (без врачей)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-dr-vuksanovic-ulcinj.sql
--
-- Источники (curl, 2026-10-08): https://drvuksanovic.me/kontakt/ulcinj/ (2021-04), пост «Laboratorija Dr Vuksanović
-- na još jednoj lokaciji» (2020-08: «Braće Frašeri b. b., preko puta Gimnazije»), «Odluka o radnom vremenu»
-- (PDF 10.09.2025: «Laboratorija Ulcinj Ponedjeljak – Petak 08 – 11, Subota 08 – 10») — точка действующая.
--
-- Места в Google НЕТ: google_place_id NULL, координаты: ПРИМЕРНАЯ точка 41.931887, 19.219906 (юзер не нашёл место; район Bulevardi Sami Frashëri, Тотоши, по OSM Nominatim, 2026-10-08), клиника ищется только по slug.
-- Врачей не привязываем: PDF состава разносит людей по службам (Biohemijska/Mikrobiološka laboratorija,
-- Medicina rada), но не по городам. Основная клиника — insert-clinic-poliklinika-dr-vuksanovic-bar.sql.
--
-- Идемпотентно и самоисправляюще (см. файл Бара).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = NULL;
SET @clinic_slug = 'poliklinika-dr-vuksanovic-ulcinj';

-- Места в Google нет: клиника ищется только по slug.
SET @clinic_id = (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1);

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
	5, -- CityId.ULCINJ
	'Poliklinika Dr Vuksanović Ulcinj',
	'Поликлиника Др Вуксановић (Улцињ)',
	'Поликлиника Dr Vuksanović (Ульцинь)',
	'Braće Frašeri bb',
	'Браће Фрашери бб',
	'',
	'',
	'85360',
	41.931887,
	19.219906,
	'+38269203773;+38230315900',
	'info@drvuksanovic.me',
	'https://drvuksanovic.me/',
	'',
	'',
	'',
	'',
	'',
	'https://drvuksanovic.me/wp-content/uploads/2020/09/Poliklinika-Dr-Vuksanovic-Logo.jpg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	latitude = IF(latitude IS NULL OR latitude = 0, 41.931887, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.219906, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Др Вуксановић (Улцињ)', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Dr Vuksanović (Ульцинь)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Braće Frašeri bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Браће Фрашери бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85360', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269203773;+38230315900', phone),
	email = IF(email IS NULL OR email = '', 'info@drvuksanovic.me', email),
	website = IF(website IS NULL OR website = '', 'https://drvuksanovic.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://drvuksanovic.me/wp-content/uploads/2020/09/Poliklinika-Dr-Vuksanovic-Logo.jpg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Laboratorija Poliklinike Dr Vuksanović u Ulcinju, u ulici Braće Frašeri, preko puta Gimnazije. Ovo je druga lokacija biohemijsko-mikrobiološke laboratorije čije je sjedište u Baru (biohemijska laboratorija od 1999, mikrobiološka od 2003. godine). Laboratorija radi radnim danima od 8 do 11 i subotom od 8 do 10 časova.',
	description_sr_cyrl = 'Лабораторија Поликлинике Др Вуксановић у Улцињу, у улици Браће Фрашери, преко пута Гимназије. Ово је друга локација биохемијско-микробиолошке лабораторије чије је сједиште у Бару (биохемијска лабораторија од 1999, микробиолошка од 2003. године). Лабораторија ради радним данима од 8 до 11 и суботом од 8 до 10 часова.',
	description_ru = 'Лаборатория поликлиники Dr Vuksanović в Ульцине, на улице Браче Фрашери, напротив гимназии. Это второй адрес биохимической и микробиологической лаборатории, головной офис которой находится в Баре (биохимическая лаборатория — с 1999 года, микробиологическая — с 2003 года). Лаборатория работает по будням с 8 до 11 и по субботам с 8 до 10.',
	description_en = 'The Ulcinj laboratory of the Dr Vuksanović polyclinic, on Braće Frašeri street, opposite the grammar school. It is the second location of the biochemistry and microbiology laboratory headquartered in Bar (biochemistry laboratory since 1999, microbiology since 2003). The laboratory is open on weekdays from 8 to 11 and on Saturdays from 8 to 10.',
	description_de = 'Das Labor der Poliklinik Dr Vuksanović in Ulcinj, in der Straße Braće Frašeri gegenüber dem Gymnasium. Es ist der zweite Standort des biochemischen und mikrobiologischen Labors mit Hauptsitz in Bar (biochemisches Labor seit 1999, mikrobiologisches seit 2003). Das Labor ist werktags von 8 bis 11 Uhr und samstags von 8 bis 10 Uhr geöffnet.',
	description_tr = 'Dr Vuksanović polikliniğinin Ulcinj''deki laboratuvarı, Braće Frašeri caddesinde, lisenin karşısında. Merkezi Bar''da bulunan biyokimya ve mikrobiyoloji laboratuvarının ikinci şubesidir (biyokimya laboratuvarı 1999''dan, mikrobiyoloji 2003''ten beri). Laboratuvar hafta içi 08.00–11.00, cumartesi 08.00–10.00 saatleri arasında açıktır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DIAGNOSTIC_LABORATORY = 4 (в Ульцине — только лаборатория)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 4);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт (латиница/кириллица) других языков не заявляет → только SR.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- «Odluka o radnom vremenu» (10.09.2025): «Laboratorija Ulcinj Ponedjeljak – Petak 08 – 11, Subota 08 – 10» (= /kontakt/ulcinj/).
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "11:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "11:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "11:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "11:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "11:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "10:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- Врачей нет: PDF состава не указывает, кто работает в Ульцине.
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 5, status = published, google_place_id NULL, clinic_languages = 1, clinic_types = 4, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 0 врачей.
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

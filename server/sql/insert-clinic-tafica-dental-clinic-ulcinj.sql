-- ═══════════════════════════════════════════════════════════════════════════
-- Tafica Dental & Dermatology Clinic (Ulcinj) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-tafica-dental-clinic-ulcinj.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/tafica-dental-clinic-ulcinj.json):
--   * https://www.tafica.com/ — заглушка «Faqja jonë është aktualisht në ndërtim / Naša web stranica je trenutno u izradi /
--     Our website is currently under construction» (Last-Modified 2026-02-11), одна страница: название «Tafica Dental &
--     Dermatology Clinic», 4 «Dr.» с телефонами (у двоих — email), Instagram, адрес «Rr. Nënë Tereza, Ulcinj 85360». Услуг и цен нет.
--   * data/google-places/ulcinj/tafica-dental-clinic.json — place_id, координаты, телефон (+382 69 572 346 = Dr. Liridon Tafica).
-- Адрес: «Rr. Nënë Tereza» (алб.) = ул. Majke Tereze. Телефоны — все четыре со страницы (+355 — албанский номер, контакт
-- дерматологии). Email клиники — dentalclinic@tafica.com (контакт стоматологии; dermatologyclinic@tafica.com — в записи импорта).
-- Типы: DENTAL_CLINIC + DERMATOLOGY_CLINIC — по названию «Dental & Dermatology Clinic» и двум email (dentalclinic@, dermatologyclinic@).
-- Врачи заведены по косвенным признакам (решение юзера 2026-10-09), обоснование — у каждого в PART 3.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJja4C-WQTThMR-4-t1EmDqW8';
SET @clinic_slug = 'tafica-dental-clinic-ulcinj';

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
	5, -- CityId.ULCINJ
	'Tafica Dental & Dermatology Clinic',
	'Tafica Dental & Dermatology Clinic',
	'Стоматологическая и дерматологическая клиника Tafica',
	'Majke Tereze',
	'Мајке Терезе',
	'',
	'',
	'85360',
	41.92964300,
	19.22099410,
	'+38269572346;+38269215931;+38269229134;+355697278118',
	'dentalclinic@tafica.com',
	'https://www.tafica.com/',
	'',
	'@tafica.clinic',
	'',
	'',
	'',
	'https://www.tafica.com/logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Tafica Dental & Dermatology Clinic', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая и дерматологическая клиника Tafica', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Majke Tereze', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Мајке Терезе', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85360', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269572346;+38269215931;+38269229134;+355697278118', phone),
	email = IF(email IS NULL OR email = '', 'dentalclinic@tafica.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.tafica.com/', website),
	instagram = IF(instagram IS NULL OR instagram = '', '@tafica.clinic', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.tafica.com/logo.png', logo_url),
	latitude = COALESCE(latitude, 41.92964300),
	longitude = COALESCE(longitude, 19.22099410)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Tafica Dental & Dermatology Clinic je stomatološka i dermatološka klinika u Ulcinju, u Ulici Majke Tereze.',
	description_sr_cyrl = 'Tafica Dental & Dermatology Clinic је стоматолошка и дерматолошка клиника у Улцињу, у Улици Мајке Терезе.',
	description_ru = 'Tafica Dental & Dermatology Clinic — стоматологическая и дерматологическая клиника в Ульцине, на улице Матери Терезы.',
	description_en = 'Tafica Dental & Dermatology Clinic is a dental and dermatology clinic in Ulcinj, on Mother Teresa Street (Rr. Nënë Tereza).',
	description_de = 'Tafica Dental & Dermatology Clinic ist eine Zahn- und Hautarztklinik in Ulcinj, in der Mutter-Teresa-Straße (Rr. Nënë Tereza).',
	description_tr = 'Tafica Dental & Dermatology Clinic, Ulcinj''de Rahibe Teresa Caddesi''nde (Rr. Nënë Tereza) bulunan bir diş ve dermatoloji kliniğidir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2 — название «Dental & Dermatology Clinic», dentalclinic@tafica.com, Google «Tafica Dental Clinic» (dental_clinic)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);
-- ClinicType.DERMATOLOGY_CLINIC = 10 — название «Dental & Dermatology Clinic», dermatologyclinic@tafica.com — см. openQuestions
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 10);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт трёхъязычный (sq/sr/en), но приём на других языках не заявлен → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: на сайте не указаны — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (4)
-- На странице 4 «Dr.» с телефонами, специальность явно не названа. Решение юзера 2026-10-09: заводить по косвенным признакам.
-- Поиск в БД (2026-10-09): Tafica, Halili, Curanovic/Ćuranović, Darsei, Arbnore — нет (liridon-dushaj — другой человек).
-- Фото и описаний на сайте нет. Языки — только SR (приём на других языках не заявлен).
-- ═══════════════════════════════════════════════════════════════

-- Dr. Liridon Tafica — стоматолог: email dentalclinic@tafica.com, его телефон = телефон места Google «Tafica Dental Clinic».
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Liridon Tafica' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'liridon-tafica' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'liridon-tafica', 'Liridon Tafica', 'Лиридон Тафица', 'Лиридон Тафица', 'Liridon Tafica', 'dr', NULL, '+38269572346', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Dr. Darsei Curanovic — стоматолог: на странице вторым в блоке стоматологов (Liridon Tafica, он, Admir Halili), дерматологический
-- контакт отдельно последним. Других признаков нет. Написание без диакритики на сайте; -ović по норме фамилии, начальная C — как на сайте.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Darsei Curanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'darsei-curanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'darsei-curanovic', 'Darsei Curanović', 'Дарсеи Цурановић', 'Дарсеи Цуранович', 'Darsei Curanovic', 'dr', NULL, '+38269215931', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Dr. Admir Halili — стоматолог: в блоке стоматологов; в отзыве Google о клинике — лечение моляра у него.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Admir Halili' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'admir-halili' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'admir-halili', 'Admir Halili', 'Адмир Халили', 'Адмир Халили', 'Admir Halili', 'dr', NULL, '+38269229134', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Dr. Arbnore Tafica — дерматовенеролог: email dermatologyclinic@tafica.com (вторая половина «Dental & Dermatology Clinic»),
-- албанский номер +355.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Arbnore Tafica' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'arbnore-tafica' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'arbnore-tafica', 'Arbnore Tafica', 'Арбноре Тафица', 'Арбноре Тафица', 'Arbnore Tafica', 'dr', NULL, '+355697278118', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Dermatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 5, status = published, clinic_languages = 1, clinic_types = 2,10, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 4 врача: liridon-tafica, darsei-curanovic, admir-halili (78), arbnore-tafica (7).
SELECT d.slug, d.name_sr, dc.position, GROUP_CONCAT(ds.specialty_id) AS specialties
FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
WHERE dc.clinic_id = @clinic_id
GROUP BY d.id, dc.position;

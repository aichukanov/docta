-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Polident (Bijela, Herceg Novi) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-polident-bijela.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/polident-bijela.json):
--   * https://polident.me/ — WordPress (тема Salient), фактически одностраничная заглушка: реальны только заголовок, блок
--     «Upoznajte Dr. Sandru Brkić» и 4 направления услуг; остальной текст — демо темы (lorem ipsum, «875+ premium locations») — игнорируется.
--     wp-json закрыт (404). Адреса, телефона и часов на сайте нет.
--   * data/google-places/tivat/stomatoloska-ordinacija-polident-dom-zdravlja-bijela.json — место «Stomatološka Ordinacija "Polident"
--     Dom zdravlja Bijela», «b.b Dom Zdravlja, Bijela 85343», +382 69 341 846: адрес, координаты, телефон.
-- Город: Bijela — населённый пункт муниципалитета Herceg Novi → CityId.HERCEG_NOVI = 8, town_sr = Bijela, индекс 85343 (Google).
-- Facebook/Instagram — ссылки в шапке сайта.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJLY89jhUxTBMRtWuukyexrlE';
SET @clinic_slug = 'polident-bijela';

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
	8, -- CityId.HERCEG_NOVI
	'Stomatološka ordinacija Polident',
	'Стоматолошка ординација Polident',
	'Стоматологический кабинет Polident',
	'Dom zdravlja Bijela bb',
	'Дом здравља Бијела бб',
	'Bijela',
	'Бијела',
	'85343',
	42.45081410,
	18.65166760,
	'+38269341846',
	'',
	'https://polident.me/',
	'https://www.facebook.com/polident.bijela',
	'https://www.instagram.com/polident.bijela/',
	'',
	'',
	'',
	'https://polident.me/wp-content/uploads/2023/07/cropped-Site-Logo-250x250-1.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Polident', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Polident', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Dom zdravlja Bijela bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Дом здравља Бијела бб', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Bijela', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Бијела', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85343', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269341846', phone),
	website = IF(website IS NULL OR website = '', 'https://polident.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'https://www.facebook.com/polident.bijela', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', 'https://www.instagram.com/polident.bijela/', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://polident.me/wp-content/uploads/2023/07/cropped-Site-Logo-250x250-1.png', logo_url),
	latitude = COALESCE(latitude, 42.45081410),
	longitude = COALESCE(longitude, 18.65166760)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Polident“ nalazi se u Bijeloj (opština Herceg Novi), u zgradi Doma zdravlja Bijela. U ordinaciji radi dr Sandra Brkić, stomatolog sa višegodišnjim iskustvom. Ordinacija nudi konzervativnu stomatologiju (popravljanje i vađenje zuba, endodontsko liječenje), stomatološku protetiku (mobilne proteze, krunice i mostovi), estetsku stomatologiju (uklanjanje zubnog kamenca i bijeljenje zuba) i dječiju stomatologiju, uz strpljiv i bezbolan pristup djeci.',
	description_sr_cyrl = 'Стоматолошка ординација „Polident“ налази се у Бијелој (општина Херцег Нови), у згради Дома здравља Бијела. У ординацији ради др Сандра Бркић, стоматолог са вишегодишњим искуством. Ординација нуди конзервативну стоматологију (поправљање и вађење зуба, ендодонтско лијечење), стоматолошку протетику (мобилне протезе, крунице и мостови), естетску стоматологију (уклањање зубног каменца и бијељење зуба) и дјечију стоматологију, уз стрпљив и безболан приступ дјеци.',
	description_ru = 'Стоматологический кабинет «Polident» находится в Биеле (община Херцег-Нови), в здании Дома здоровья Биела. Принимает Сандра Бркич, стоматолог с многолетним опытом. Кабинет предлагает терапевтическую стоматологию (лечение и удаление зубов, эндодонтическое лечение), протезирование (съёмные протезы, коронки и мосты), эстетическую стоматологию (удаление зубного камня и отбеливание зубов) и детскую стоматологию с терпеливым и безболезненным подходом к детям.',
	description_en = 'Polident is a dental practice in Bijela (Herceg Novi municipality), in the Bijela health centre building. The dentist is Dr Sandra Brkić, who has many years of experience. The practice offers restorative dentistry (fillings, extractions and root canal treatment), prosthodontics (removable dentures, crowns and bridges), cosmetic dentistry (scaling and teeth whitening) and paediatric dentistry with a patient, pain-free approach to children.',
	description_de = 'Polident ist eine Zahnarztpraxis in Bijela (Gemeinde Herceg Novi), im Gebäude des Gesundheitszentrums Bijela. Es behandelt Dr. Sandra Brkić, Zahnärztin mit langjähriger Erfahrung. Die Praxis bietet konservierende Zahnheilkunde (Füllungen, Zahnentfernung, Wurzelkanalbehandlung), Prothetik (herausnehmbare Prothesen, Kronen und Brücken), ästhetische Zahnheilkunde (Zahnsteinentfernung und Zahnaufhellung) sowie Kinderzahnheilkunde mit geduldigem und schmerzfreiem Umgang mit Kindern.',
	description_tr = 'Polident, Bijela''da (Herceg Novi belediyesi) Bijela sağlık merkezi binasında bulunan bir diş muayenehanesidir. Uzun yıllara dayanan deneyime sahip diş hekimi Dr. Sandra Brkić hasta kabul eder. Muayenehane koruyucu diş hekimliği (dolgu, diş çekimi, kanal tedavisi), protez (hareketli protezler, kron ve köprüler), estetik diş hekimliği (diş taşı temizliği ve diş beyazlatma) ile çocuklara sabırlı ve ağrısız yaklaşımla çocuk diş hekimliği hizmetleri sunar.'
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

-- Часы работы: на сайте и в месте Google часов нет — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- Врач один — главная: «Upoznajte Dr. Sandru Brkić, vašeg stručnjaka za oralno zdravlje u stomatološkoj ambulanti 'Polident'».
-- В БД уже есть: sandra-brkic (специальность 78, клиники stomatoloska-poliklinika-vukotic-podgorica и -herceg-novi, «Doktor stomatologije»)
-- — та же специальность, привязка. Фото у карточки уже есть (сайт Vukotić); фото с polident.me (/2023/11/Sandra-Brkic.jpg) — только если пусто.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Sandra Brkić — Stomatolog
-- ───────────────────────────────────────────────────────────────
-- Существующая карточка (id 3306 локально, на проде есть). Био на Polident — рекламная фраза («posvećena pružanju izuzetne dentalne njege») — не заводим.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sandra Brkić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Brkić Sandra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sandra-brkic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'sandra-brkic', 'Sandra Brkić', 'Сандра Бркић', 'Сандра Бркич', 'Sandra Brkic', 'Dr',
	'https://polident.me/wp-content/uploads/2023/11/Sandra-Brkic.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Врач уже в БД: дозаполняем только пустые поля, заполненное не трогаем.
UPDATE doctors SET
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Сандра Бркић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Сандра Бркич', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Sandra Brkic', name_en),
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://polident.me/wp-content/uploads/2023/11/Sandra-Brkic.jpg', photo_url),
	professional_title = IF(professional_title IS NULL OR professional_title = '', 'Dr', professional_title)
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 8, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1 врач(а/ей): sandra-brkic.
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

-- ═══════════════════════════════════════════════════════════════════════════
-- OssPhysio (Čeluga, Bar) — клиника без названных специалистов
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ossphysio-bar.sql
-- Затем: server/sql/insert-clinic-ossphysio-bar-services.sql
-- Запись импорта: data/clinic-imports/ossphysio-bar.json. Подволна 2e, агент Y.
-- 
-- Источники (собрано 2026-10-09):
--   * https://www.oss-physio.com/ — Vite/React SPA: контент — словари i18n me/en в бандле /assets/index-DXjDuVFh.js
--     (Jf={me:{…},en:{…}}). Блок «Cjenovnik — Transparentne cijene za sve usluge» есть только словарём
--     (massage30/massage60/… без чисел и длительностей) — цен нет. Часов работы нет. Скриншот в бандле датирован 2026-01-24.
--   * data/google-places/bar/ossphysio.json — place_id, координаты 42.0881387 / 19.1219796, +382 69 962 056,
--     «84 Belvederska, Bar 85000» (Google не перезапрашивался; отзывов в файле нет).
-- 
-- Адрес: сайт «Belvederska ulica, 85353 Čeluga, Bar» (без номера) + номер 84 из Google → address «Belvederska 84»,
-- town «Čeluga», индекс 85353 — с сайта (Google даёт общий 85000 Bar).
-- Телефоны — оба tel: с сайта (+382 69 962 056 = Google), WhatsApp — wa.me/38269962056, Instagram — instagram.com/ossphysio.
-- Логотипа нет (только favicon).
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJW28rHgB1ThMRAFhjsoLtkI0';
SET @clinic_slug = 'ossphysio-bar';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('OssPhysio', 'OSS PHYSIO', 'OSS Physio', 'Oss Physio') AND city_id = 7 LIMIT 1));

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
	7, -- CityId.BAR (Čeluga — opština Bar)
	'OssPhysio',
	'OssPhysio',
	'OssPhysio',
	'Belvederska 84',
	'Белведерска 84',
	'Čeluga',
	'Челуга',
	'85353',
	42.08813870,
	19.12197960,
	'+38269962056;+38268228337',
	'ossphysiobar@gmail.com',
	'https://www.oss-physio.com/',
	'',
	'@ossphysio',
	'',
	'+38269962056',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.08813870, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.12197960, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'OssPhysio', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'OssPhysio', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Belvederska 84', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Белведерска 84', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Čeluga', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Челуга', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85353', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269962056;+38268228337', phone),
	email = IF(email IS NULL OR email = '', 'ossphysiobar@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.oss-physio.com/', website),
	instagram = IF(instagram IS NULL OR instagram = '', '@ossphysio', instagram),
	whatsapp = IF(whatsapp IS NULL OR whatsapp = '', '+38269962056', whatsapp)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'OssPhysio je centar za fizikalnu terapiju i rehabilitaciju u Čelugi kod Bara, u Belvederskoj ulici. Centar se nedavno preselio u novi, prostraniji i komforniji prostor, opremljen savremenom opremom: BTL Tecar i BTL Shockwave aparatima i multifunkcionalnim aparatom BTL 4825SL za elektroterapiju i ultrazvučnu terapiju. U ponudi su opuštajuća, sportska i medicinska masaža, kineziterapija, elektroterapija, Tecar terapija, shockwave terapija, hidžama (cupping), kiropraktika, akupunktura i kinesio taping.',
	description_sr_cyrl = 'OssPhysio је центар за физикалну терапију и рехабилитацију у Челуги код Бара, у Белведерској улици. Центар се недавно преселио у нови, пространији и комфорнији простор, опремљен савременом опремом: BTL Tecar и BTL Shockwave апаратима и мултифункционалним апаратом BTL 4825SL за електротерапију и ултразвучну терапију. У понуди су опуштајућа, спортска и медицинска масажа, кинезитерапија, електротерапија, Tecar терапија, shockwave терапија, хиџама (cupping), киропрактика, акупунктура и kinesio taping.',
	description_ru = 'OssPhysio — центр физиотерапии и реабилитации в Челуге под Баром, на улице Belvederska. Недавно центр переехал в новое, более просторное и удобное помещение с современным оборудованием: аппаратами BTL Tecar и BTL Shockwave и многофункциональным аппаратом BTL 4825SL для электротерапии и ультразвуковой терапии. В перечне услуг — расслабляющий, спортивный и лечебный массаж, кинезитерапия, электротерапия, Tecar-терапия, ударно-волновая терапия, хиджама (баночная терапия), хиропрактика, акупунктура и кинезиотейпирование.',
	description_en = 'OssPhysio is a physical therapy and rehabilitation centre in Čeluga near Bar, on Belvederska Street. The centre recently moved to new, more spacious and comfortable premises equipped with modern devices: BTL Tecar and BTL Shockwave units and the BTL 4825SL multifunctional unit for electrotherapy and ultrasound therapy. Services include relaxing, sports and medical massage, exercise therapy, electrotherapy, Tecar therapy, shockwave therapy, hijama (cupping), chiropractic, acupuncture and kinesio taping.',
	description_de = 'OssPhysio ist ein Zentrum für physikalische Therapie und Rehabilitation in Čeluga bei Bar, Belvederska-Straße. Das Zentrum ist vor Kurzem in neue, geräumigere und komfortablere Räume umgezogen, die mit modernen Geräten ausgestattet sind: BTL Tecar und BTL Shockwave sowie dem Multifunktionsgerät BTL 4825SL für Elektro- und Ultraschalltherapie. Angeboten werden Entspannungs-, Sport- und medizinische Massage, Bewegungstherapie, Elektrotherapie, Tecar-Therapie, Stoßwellentherapie, Hijama (Schröpfen), Chiropraktik, Akupunktur und Kinesio-Taping.',
	description_tr = 'OssPhysio, Bar yakınlarındaki Čeluga''da, Belvederska Caddesi''nde bir fizik tedavi ve rehabilitasyon merkezidir. Merkez kısa süre önce modern cihazlarla donatılmış yeni, daha geniş ve konforlu bir mekâna taşındı: BTL Tecar ve BTL Shockwave cihazları ile elektroterapi ve ultrason tedavisi için çok fonksiyonlu BTL 4825SL cihazı. Hizmetler arasında rahatlatıcı, spor ve tıbbi masaj, egzersiz tedavisi, elektroterapi, Tecar tedavisi, şok dalga tedavisi, hacamat (kupa), kayropraktik, akupunktur ve kinezyo bantlama bulunur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24: «centar za fizikalnu terapiju i rehabilitaciju».
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт me/en, приём на других языках прямо не заявлен → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы НЕ заполняются: ни на сайте (словари бандла), ни в файле Google их нет.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- ═══════════════════════════════════════════════════════════════
-- Специалистов не заводим: имён на сайте нет («Certificirani terapeuti sa godinama iskustva», «Naš tim stručnjaka» — без имён).

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 7, status = published, clinic_languages = '1', clinic_types = '24', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 0: .
-- Если created_at нового врача старше даты прогона — запись уже была: проверить, тот ли человек.
SELECT d.id, d.slug, d.name_sr, d.professional_title,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id
ORDER BY d.name_sr;

-- ═══════════════════════════════════════════════════════════════════════════
-- Numanović Dental & Aesthetic (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-numanovic-dental-aesthetic-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/numanovic-dental-aesthetic-podgorica.json):
--   * https://drnumanovic.me/ — WordPress на теме AncoraThemes, в стадии наполнения (страницы изменены 2026-10-03…2026-10-09).
--     Реальны (на сербском): /usluge/ (8 направлений), /o-nama/ (2 направления + контакты и часы), /kontakt/ и 10 страниц
--     /services/<направление>/ (по одной фразе). Демо темы игнорируется: блок команды на главной (Dr. Jessica Smith, Sheila/Alex
--     Coredero, Simona Willams), «Mn - St: 8:00am - 9:00pm», «1 800 345 67 56», таймлайн 2004/2008/2016, lorem ipsum, «ProDent Clinic».
--   * data/google-places/podgorica/stomatoloska-ordinacija-dr-numanovic-podgorica.json — place_id, координаты.
-- Адрес: сайт «Ulica 13. jula br. 5, Podgorica» = Google «br 5 13. Jula». Телефоны (оба) и email — /kontakt/, /o-nama/.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ73Ry4dXrTRMRm2ShmpTyQfc';
SET @clinic_slug = 'numanovic-dental-aesthetic-podgorica';

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
	'Numanović Dental & Aesthetic',
	'Numanović Dental & Aesthetic',
	'Numanović Dental & Aesthetic',
	'Ulica 13. jula 5',
	'Улица 13. јула 5',
	'',
	'',
	'81000',
	42.44570090,
	19.25579760,
	'+38267012392;+38267218350',
	'dental@drnumanovic.me',
	'https://drnumanovic.me/',
	'',
	'https://www.instagram.com/numanovic_dental/',
	'',
	'',
	'',
	'https://drnumanovic.me/wp-content/uploads/2026/10/Numanovic-Dental-Aesthetic-Logo.webp',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Numanović Dental & Aesthetic', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Numanović Dental & Aesthetic', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Ulica 13. jula 5', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Улица 13. јула 5', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267012392;+38267218350', phone),
	email = IF(email IS NULL OR email = '', 'dental@drnumanovic.me', email),
	website = IF(website IS NULL OR website = '', 'https://drnumanovic.me/', website),
	instagram = IF(instagram IS NULL OR instagram = '', 'https://www.instagram.com/numanovic_dental/', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://drnumanovic.me/wp-content/uploads/2026/10/Numanovic-Dental-Aesthetic-Logo.webp', logo_url),
	latitude = COALESCE(latitude, 42.44570090),
	longitude = COALESCE(longitude, 19.25579760)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Numanović Dental & Aesthetic je stomatološka ordinacija u centru Podgorice, u Ulici 13. jula br. 5. Ordinacija pruža savremenu stomatološku njegu uz individualan pristup — od preventivnih pregleda i liječenja zuba do estetske stomatologije, protetike, implantologije i profesionalnog izbjeljivanja. Polazi od želja pacijenta i detaljne analize stanja, a cilj je rezultat koji izgleda prirodno, traje i čuva zdravlje i funkciju osmijeha. U ponudi su opšta i dječja stomatologija, liječenje karijesa i estetske kompozitne restauracije, endodoncija, parodontologija, profesionalno čišćenje zuba, izbjeljivanje zuba, estetska stomatologija, fiksna protetika (krunice i mostovi) i implantologija.',
	description_sr_cyrl = 'Numanović Dental & Aesthetic је стоматолошка ординација у центру Подгорице, у Улици 13. јула бр. 5. Ординација пружа савремену стоматолошку његу уз индивидуалан приступ — од превентивних прегледа и лијечења зуба до естетске стоматологије, протетике, имплантологије и професионалног избјељивања. Полази од жеља пацијента и детаљне анализе стања, а циљ је резултат који изгледа природно, траје и чува здравље и функцију осмијеха. У понуди су општа и дјечја стоматологија, лијечење каријеса и естетске композитне рестаурације, ендодонција, пародонтологија, професионално чишћење зуба, избјељивање зуба, естетска стоматологија, фиксна протетика (крунице и мостови) и имплантологија.',
	description_ru = 'Numanović Dental & Aesthetic — стоматологический кабинет в центре Подгорицы, на улице 13 Июля, 5. Кабинет оказывает современную стоматологическую помощь с индивидуальным подходом — от профилактических осмотров и лечения зубов до эстетической стоматологии, протезирования, имплантологии и профессионального отбеливания. Работа начинается с пожеланий пациента и подробного анализа состояния; цель — естественный и долговечный результат, сохраняющий здоровье и функцию зубов. Кабинет предлагает общую и детскую стоматологию, лечение кариеса и эстетические композитные реставрации, эндодонтию, пародонтологию, профессиональную чистку зубов, отбеливание, эстетическую стоматологию, несъёмное протезирование (коронки и мосты) и имплантологию.',
	description_en = 'Numanović Dental & Aesthetic is a dental practice in central Podgorica, at Ulica 13. jula 5. The practice provides modern dental care with an individual approach — from preventive check-ups and treatment of teeth to cosmetic dentistry, prosthodontics, implantology and professional whitening. Treatment starts from the patient’s wishes and a detailed assessment, aiming for results that look natural, last and preserve the health and function of the smile. Services include general and paediatric dentistry, caries treatment and cosmetic composite restorations, endodontics, periodontology, professional teeth cleaning, teeth whitening, cosmetic dentistry, fixed prosthodontics (crowns and bridges) and implantology.',
	description_de = 'Numanović Dental & Aesthetic ist eine Zahnarztpraxis im Zentrum von Podgorica, Ulica 13. jula 5. Die Praxis bietet moderne zahnärztliche Versorgung mit individuellem Ansatz – von Vorsorgeuntersuchungen und Zahnbehandlung bis zu ästhetischer Zahnheilkunde, Prothetik, Implantologie und professioneller Zahnaufhellung. Ausgangspunkt sind die Wünsche des Patienten und eine genaue Befundaufnahme; Ziel ist ein natürlich wirkendes, dauerhaftes Ergebnis, das Gesundheit und Funktion erhält. Angeboten werden allgemeine und Kinderzahnheilkunde, Kariesbehandlung und ästhetische Kompositrestaurationen, Endodontie, Parodontologie, professionelle Zahnreinigung, Zahnaufhellung, ästhetische Zahnheilkunde, festsitzende Prothetik (Kronen und Brücken) und Implantologie.',
	description_tr = 'Numanović Dental & Aesthetic, Podgorica merkezinde Ulica 13. jula 5 adresinde bulunan bir diş muayenehanesidir. Muayenehane bireysel yaklaşımla modern diş bakımı sunar — koruyucu muayene ve diş tedavisinden estetik diş hekimliğine, protez, implantoloji ve profesyonel beyazlatmaya kadar. Tedavi hastanın isteklerinden ve ayrıntılı bir değerlendirmeden yola çıkar; amaç doğal görünen, kalıcı ve gülüşün sağlığını ve işlevini koruyan bir sonuçtur. Genel ve çocuk diş hekimliği, çürük tedavisi ve estetik kompozit restorasyonlar, endodonti, periodontoloji, profesyonel diş temizliği, diş beyazlatma, estetik diş hekimliği, sabit protez (kron ve köprüler) ve implantoloji hizmetleri sunulur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Переключатель языков сайта (me/en/zh/it/ru/tr/es/fr) — не заявление о приёме, переводов фактически нет → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: /o-nama/ (Contact Info): «Pon - Uto: 12:00 - 20:00 Sri - Pet: 09:00 - 17:00»; выходные не указаны → закрыто. Второй график в шапке страниц /services/ («Mn - St: 8:00am - 9:00pm», рядом демо-телефон «1 800 345 67 56») — шаблон темы, не используется.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- Врачей на сайте нет: блок команды на главной — демо темы (Dr. Jessica Smith, Dr. Sheila Coredero, Dr. Alex Coredero, Dr. Simona Willams),
-- /tim/ — без людей. Бренд «Dr Numanović» (место Google «Stomatološka ordinacija Dr Numanović») даёт только фамилию; email dental@ — без имени.
-- Поиск в БД (Numanović / numanovic, 2026-10-09): только Elvidina Numanović — izabrani doktor za odrasle (45 = GENERAL_MEDICINE), ДЗ Подгорица —
-- не стоматолог, другой человек.
-- Врач заведён ПО КОСВЕННЫМ ПРИЗНАКАМ (решение координатора 2026-10-09): бренд ординации «Dr Numanović» (сайт, место Google
-- «Stomatološka ordinacija Dr Numanović») + отзыв Google 2026-01-11 «Odradila sam obje vilice kod dr.Eldina prije 4 godine» →
-- Eldin Numanović, стоматолог (78). Имя на сайте не названо; фото и био нет. Slug eldin-numanovic свободен (локально и на проде — 204).
-- Привязки врач↔услуга не ставятся (кто что делает — неизвестно), только к клинике.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Eldin Numanović — Stomatolog
-- ───────────────────────────────────────────────────────────────
-- Косвенно: бренд «Dr Numanović» + отзыв Google «kod dr.Eldina». Сайт имени не называет.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Eldin Numanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Numanović Eldin' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'eldin-numanovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'eldin-numanovic', 'Eldin Numanović', 'Елдин Нумановић', 'Эльдин Нуманович', 'Eldin Numanovic', 'dr',
	NULL, NULL, NOW()
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

-- Ожидается 1 врач(а/ей): eldin-numanovic.
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

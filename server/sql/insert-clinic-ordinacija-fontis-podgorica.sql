-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija Fontis (Podgorica) — клиника + врач (интерна и медэстетика)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-fontis-podgorica.sql
-- Затем: server/sql/insert-clinic-ordinacija-fontis-podgorica-services.sql
-- Запись импорта: data/clinic-imports/ordinacija-fontis-podgorica.json. Подволна 2e, агент Y.
-- 
-- Источники (собрано 2026-10-09):
--   * https://fontiscg.com/ — WordPress/Elementor; wp-json /wp/v2/pages (16, modified до 2026-09-29) и /wp/v2/services (14 — 7 me + 7 en,
--     modified 2026-04-13…17), сырой HTML /kontakt и главной (соцсети, логотип). Цен нет нигде. Часов работы нет. Email на сайте нет.
--   * Google — ДВА места по одному адресу Svetozara Markovića 1, одна карточка:
--     - data/google-places/podgorica/ordinacija-fontis-interna-medicina.json — «Ordinacija Fontis - Interna medicina» (медицинское,
--       взято: place_id ChIJeemPdTrrTRMRDf_15muQOhc, 42.4426187 / 19.2518847, 16 отзывов);
--     - data/google-places/podgorica/fontis.json — «Fontis» (skin_care_clinic, производитель косметики; place_id ChIJm0Il2zDrTRMR1Fm031vRYjE,
--       55 отзывов) — та же компания, отдельной клиникой не заводится (см. запись импорта).
-- 
-- Телефоны — /kontakt: +382 69 015 303 (= Google, первым), +382 20 248 914, +382 68 739 439. Соцсети — ссылки сайта.
-- Название — по медицинскому месту Google и сайту («Ordinacija Fontis»); Fontis как компания — дермокозметика и салон.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJeemPdTrrTRMRDf_15muQOhc';
SET @clinic_slug = 'ordinacija-fontis-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Ordinacija Fontis', 'Ordinacija Fontis - Interna medicina', 'Ordinacija Fontis – Interna medicina', 'Fontis') AND city_id = 1 LIMIT 1));

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
	'Ordinacija Fontis',
	'Ординација Фонтис',
	'Кабинет Fontis',
	'Svetozara Markovića 1',
	'Светозара Марковића 1',
	'',
	'',
	'81000',
	42.44261870,
	19.25188470,
	'+38269015303;+38220248914;+38268739439',
	'',
	'https://fontiscg.com/',
	'facebook.com/p/Ordinacija-Fontis-100057308207673',
	'@ordinacijafontis',
	'',
	'',
	'',
	'https://fontiscg.com/wp-content/uploads/2026/04/fontis-text-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.44261870, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.25188470, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Ординација Фонтис', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Кабинет Fontis', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Svetozara Markovića 1', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Светозара Марковића 1', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269015303;+38220248914;+38268739439', phone),
	website = IF(website IS NULL OR website = '', 'https://fontiscg.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/p/Ordinacija-Fontis-100057308207673', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@ordinacijafontis', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://fontiscg.com/wp-content/uploads/2026/04/fontis-text-logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Ordinacija Fontis u Podgorici, u ulici Svetozara Markovića 1, dio je kompanije Fontis, osnovane 1995. godine, koja se bavi njegom zdrave i problematične kože, izradom dermokozmetičkih preparata u sopstvenoj laboratoriji i estetskim tretmanima. Specijalističku internističku djelatnost obavlja dr mr sci. med. Predrag Maraš, specijalista interne medicine: opšti internistički pregledi, EKG, 24-časovni Holter monitoring krvnog pritiska, pregledi iz oblasti endokrinologije, ultrazvučni pregledi štitaste žlijezde, vrata, dojki, abdomena, male karlice, bubrega, prostate, mokraćne bešike i testisa, color doppler pregledi arterija vrata, ruku i nogu i savjeti iz oblasti nutricionizma. Od estetskih tretmana dostupni su Dermapen 4 mikronidling, Hydrafacial tretman i laserska epilacija aparatom Alma Soprano Titanium.',
	description_sr_cyrl = 'Ординација Фонтис у Подгорици, у улици Светозара Марковића 1, дио је компаније Фонтис, основане 1995. године, која се бави његом здраве и проблематичне коже, израдом дермокозметичких препарата у сопственој лабораторији и естетским третманима. Специјалистичку интернистичку дјелатност обавља др мр сци. мед. Предраг Мараш, специјалиста интерне медицине: општи интернистички прегледи, EKG, 24-часовни Holter мониторинг крвног притиска, прегледи из области ендокринологије, ултразвучни прегледи штитасте жлијезде, врата, дојки, абдомена, мале карлице, бубрега, простате, мокраћне бешике и тестиса, color doppler прегледи артерија врата, руку и ногу и савјети из области нутриционизма. Од естетских третмана доступни су Dermapen 4 микронидлинг, Hydrafacial третман и ласерска епилација апаратом Alma Soprano Titanium.',
	description_ru = 'Кабинет Fontis в Подгорице, на улице Svetozara Markovića, 1, входит в компанию Fontis, основанную в 1995 году, которая занимается уходом за здоровой и проблемной кожей, производством дермокосметики в собственной лаборатории и эстетическими процедурами. Приём по внутренним болезням ведёт dr mr sci. med. Предраг Мараш, специалист по внутренним болезням: общий осмотр терапевта-интерниста, ЭКГ, суточное мониторирование артериального давления (Холтер), консультации по эндокринологии, УЗИ щитовидной железы, шеи, молочных желёз, брюшной полости, малого таза, почек, предстательной железы, мочевого пузыря и яичек, цветное допплеровское исследование артерий шеи, рук и ног и консультации по питанию. Из эстетических процедур доступны микронидлинг Dermapen 4, процедура Hydrafacial и лазерная эпиляция на аппарате Alma Soprano Titanium.',
	description_en = 'Ordinacija Fontis in Podgorica, at Svetozara Markovića 1, is part of Fontis, a company founded in 1995 that specialises in care for healthy and problem skin, dermocosmetic preparations made in its own laboratory and aesthetic treatments. Specialist internal medicine services are provided by Dr Predrag Maraš, MD, MSc, specialist in internal medicine: general internal medicine examinations, ECG, 24-hour blood pressure Holter monitoring, endocrinology consultations, ultrasound of the thyroid, neck, breasts, abdomen, pelvis, kidneys, prostate, urinary bladder and testes, colour Doppler of the arteries of the neck, arms and legs, and nutritional counselling. Aesthetic treatments include Dermapen 4 microneedling, Hydrafacial and laser hair removal with the Alma Soprano Titanium.',
	description_de = 'Die Ordinacija Fontis in Podgorica, Svetozara Markovića 1, gehört zum 1995 gegründeten Unternehmen Fontis, das sich auf die Pflege gesunder und problematischer Haut, dermokosmetische Präparate aus eigenem Labor und ästhetische Behandlungen spezialisiert hat. Die internistische Fachpraxis führt Dr. Predrag Maraš, MSc, Facharzt für Innere Medizin: allgemeine internistische Untersuchungen, EKG, 24-Stunden-Blutdruckmessung (Holter), endokrinologische Untersuchungen, Ultraschall von Schilddrüse, Hals, Brust, Abdomen, kleinem Becken, Nieren, Prostata, Harnblase und Hoden, Farbdoppler der Arterien von Hals, Armen und Beinen sowie Ernährungsberatung. Zu den ästhetischen Behandlungen gehören Dermapen-4-Microneedling, Hydrafacial und Laser-Haarentfernung mit dem Alma Soprano Titanium.',
	description_tr = 'Podgorica''da Svetozara Markovića 1 adresindeki Ordinacija Fontis, 1995''te kurulan ve sağlıklı ile sorunlu cilt bakımı, kendi laboratuvarında dermokozmetik ürün üretimi ve estetik uygulamalar alanında uzmanlaşan Fontis şirketinin bir parçasıdır. İç hastalıkları muayenelerini iç hastalıkları uzmanı Dr. Predrag Maraš (MSc) yapar: genel dahiliye muayenesi, EKG, 24 saatlik Holter tansiyon izlemi, endokrinoloji muayeneleri, tiroid, boyun, meme, karın, küçük pelvis, böbrek, prostat, mesane ve testis ultrasonu, boyun, kol ve bacak arterlerinin renkli Doppler incelemesi ve beslenme danışmanlığı. Estetik uygulamalar arasında Dermapen 4 mikro iğneleme, Hydrafacial ve Alma Soprano Titanium ile lazer epilasyon bulunur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- POLYCLINIC = 1 (специалистический кабинет интерны: осмотры, ЭКГ, Холтер, УЗИ, допплер — отдельного типа интерны нет, как internos-medical-podgorica) + AESTHETIC_CLINIC = 14 (Dermapen 4, Hydrafacial, лазерная эпиляция Alma Soprano Titanium).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1), (@clinic_id, 14);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт me/en, приём на других языках прямо не заявлен → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы НЕ заполняются: ни на сайте (/kontakt, главная), ни в файлах Google их нет.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- ═══════════════════════════════════════════════════════════════
-- Источник: /nas-tim («Zdravstveni segment — dr mr sc. med. Predrag Maraš specijalista interne medicine») и /services/ordinacija-za-internu-medicinu.
-- НЕ заводятся (решение юзера: фармацевты, медсёстры, косметологи — не врачи): Slavica Vučurović dipl. farm., Jovana Krivokapić mag. farm.,
-- prof. dr Zorica Potpara (konsultant, доктор фармацевтических наук), Nataša Vujačić (farm. tehničar), Marija Vešović (med. sestra/kozmetolog),
-- Dijana Perović (kozmetolog).

-- ───────────────────────────────────────────────────────────────
-- Predrag Maraš — «dr mr sci. med. Predrag Maraš, specijalista interne medicine».
-- НАЙДЕН в БД: predrag-maras (локаль и прод id 133, «dr mr sci. med.», спец. 2, фото /uploads/…, клиники Moj Lab ×4 + Vaše zdravlje) —
-- тот же титул и специальность, Podgorica → тот же человек. Не путать с dejan-maras / dejan-maras-2 (анестезиолог / другой интернист).
-- Карточку не перезаписываем: фото и описание не трогаем (INSERT не сработает), только привязка к клинике.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Predrag Maraš' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Maraš Predrag' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'predrag-maras' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-maras', 'Predrag Maraš', 'Предраг Мараш', 'Предраг Мараш', 'Predrag Maras', 'dr mr sci. med.',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описания у карточки нет, на сайте Fontis био тоже нет — не пишем.

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista interne medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '1,14', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: predrag-maras (2).
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

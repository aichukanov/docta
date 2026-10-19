-- ═══════════════════════════════════════════════════════════════════════════
-- Nova Medicina Rada — Nikšić — клиника (врачей нет)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-nova-medicina-rada-niksic.sql
-- Затем: server/sql/insert-clinic-nova-medicina-rada-niksic-services.sql
-- Запись импорта: data/clinic-imports/nova-medicina-rada-niksic.json. Подволна 2e, агент Z. Второй филиал — nova-medicina-rada-podgorica (отдельная карточка: другой город).
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://www.novamedicinarada.com/ — Next.js SSR, sitemap: главная, /podgorica, /niksic, /usluge, 6 страниц услуг /podgorica/…, блог.
--     Страниц /niksic/<услуга> нет (404); на /niksic тот же блок из 6 услуг, что и на /podgorica → одинаковый перечень в обоих филиалах.
--     Цен нет, имён врачей нет («Profesionalan tim», «licencirani psihijatri», «stručni psiholozi»).
--   * data/google-places/niksic/nova-medicina-rada-niksic.json — place_id ChIJZ6WskGepTRMRatT0sa89Uv8 («Nova Medicina Rada Niksic»), 42.7730952 / 18.96578, +382 68 875 500, «Vuka Karadzica 84, Никшић 81400», отзывов 0. ⚠️ Координатор считал, что места у Никшича нет, — файл есть (коммит 7808c4d «raw clinics data»), взят он, примерная точка не нужна.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJZ6WskGepTRMRatT0sa89Uv8';
SET @clinic_slug = 'nova-medicina-rada-niksic';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Nova Medicina Rada Nikšić', 'Nova Medicina Rada Niksic') AND city_id = 2 LIMIT 1));

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
	'Nova Medicina Rada Nikšić',
	'Nova Medicina Rada Никшић',
	'Nova Medicina Rada (Никшич)',
	'Vuka Karadžića 84',
	'Вука Караџића 84',
	'',
	'',
	'81400',
	42.77309520,
	18.96578000,
	'+38268875500;+38268875501',
	'niksic@novamedicinarada.com',
	'https://www.novamedicinarada.com/niksic',
	'facebook.com/profile.php?id=100038215403169',
	'@nova_medicina_rada',
	'',
	'',
	'',
	'https://www.novamedicinarada.com/brand/nmr-logo-horizontalni-niksic-svijetla-podloga.svg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.77309520, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.96578000, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Nova Medicina Rada Никшић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Nova Medicina Rada (Никшич)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vuka Karadžića 84', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Вука Караџића 84', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81400', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38268875500;+38268875501', phone),
	email = IF(email IS NULL OR email = '', 'niksic@novamedicinarada.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.novamedicinarada.com/niksic', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/profile.php?id=100038215403169', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@nova_medicina_rada', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.novamedicinarada.com/brand/nmr-logo-horizontalni-niksic-svijetla-podloga.svg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'PZU „Nova medicina rada“ je privatna klinika medicine rada s ordinacijama u Podgorici i Nikšiću, koja spaja iskustvo iz oblasti medicine rada, psihologije, psihijatrije i radiologije. Usluge: pregledi za zaposlenje i sistematski pregledi — inicijalni, periodični i kontrolni pregledi, ljekarska uvjerenja za posebne pozicije i procjena radne sposobnosti (sistematski pregled obuhvata opšti ljekarski pregled, laboratorijske analize, EKG, spirometriju i psihološku procjenu, u zavisnosti od radnog mjesta), uz posebne pakete i grupne preglede za kompanije; psihološko savjetovanje — individualno savjetovanje i podrška, procjena stresa i anksioznosti, krizno savjetovanje; psihijatrijski pregledi — procjena mentalnog zdravlja, terapeutska podrška i praćenje, pregledi u okviru radne procjene; pregledi za vozače svih kategorija i obnavljanje ljekarskih uvjerenja, uključujući profesionalne vozače; laboratorijska dijagnostika — osnovne analize, EKG i mjerenje krvnog pritiska, spirometrija; ultrazvučni pregledi abdomena, štitne žlijezde, dojki, mekih tkiva i limfnih čvorova. Pregledi se zakazuju online preko sajta ili telefonom. Ordinacija u Nikšiću nalazi se u ulici Vuka Karadžića 84, iza OŠ „Mileva Lajović Lalatović“. Radno vrijeme: ponedjeljak–petak od 9 do 17 časova.',
	description_sr_cyrl = 'ПЗУ „Нова медицина рада“ је приватна клиника медицине рада с ординацијама у Подгорици и Никшићу, која спаја искуство из области медицине рада, психологије, психијатрије и радиологије. Услуге: прегледи за запослење и систематски прегледи — иницијални, периодични и контролни прегледи, љекарска увјерења за посебне позиције и процјена радне способности (систематски преглед обухвата општи љекарски преглед, лабораторијске анализе, EKG, спирометрију и психолошку процјену, у зависности од радног мјеста), уз посебне пакете и групне прегледе за компаније; психолошко савјетовање — индивидуално савјетовање и подршка, процјена стреса и анксиозности, кризно савјетовање; психијатријски прегледи — процјена менталног здравља, терапеутска подршка и праћење, прегледи у оквиру радне процјене; прегледи за возаче свих категорија и обнављање љекарских увјерења, укључујући професионалне возаче; лабораторијска дијагностика — основне анализе, EKG и мјерење крвног притиска, спирометрија; ултразвучни прегледи абдомена, штитне жлијезде, дојки, меких ткива и лимфних чворова. Прегледи се заказују онлине преко сајта или телефоном. Ординација у Никшићу налази се у улици Вука Караџића 84, иза ОШ „Милева Лајовић Лалатовић“. Радно вријеме: понедјељак–петак од 9 до 17 часова.',
	description_ru = 'PZU «Nova medicina rada» — частная клиника медицины труда с кабинетами в Подгорице и Никшиче, объединяющая опыт в медицине труда, психологии, психиатрии и радиологии. Услуги: медосмотры при приёме на работу и профилактические осмотры — первичные, периодические и контрольные, медицинские справки для особых должностей и оценка трудоспособности (профосмотр включает общий осмотр врача, лабораторные анализы, ЭКГ, спирометрию и психологическую оценку в зависимости от рабочего места), специальные пакеты и групповые осмотры для компаний; психологическое консультирование — индивидуальные консультации и поддержка, оценка стресса и тревожности, кризисное консультирование; психиатрические осмотры — оценка психического здоровья, терапевтическая поддержка и наблюдение, осмотры в рамках оценки трудоспособности; медосмотры водителей всех категорий и продление справок, в том числе для профессиональных водителей; лабораторная диагностика — базовые анализы, ЭКГ и измерение давления, спирометрия; УЗИ брюшной полости, щитовидной и молочных желёз, мягких тканей и лимфоузлов. Запись онлайн на сайте или по телефону. Кабинет в Никшиче находится на улице Vuka Karadžića 84, за школой «Милева Лайович Лалатович». Часы работы: пн–пт с 9 до 17.',
	description_en = 'PZU "Nova medicina rada" is a private occupational medicine clinic with practices in Podgorica and Nikšić, combining experience in occupational medicine, psychology, psychiatry and radiology. Services: pre-employment and routine examinations — initial, periodic and follow-up examinations, medical certificates for special positions and work ability assessment (a routine examination includes a general medical examination, laboratory tests, ECG, spirometry and a psychological assessment depending on the job), with special packages and group examinations for companies; psychological counselling — individual counselling and support, stress and anxiety assessment, crisis counselling; psychiatric examinations — mental health assessment, therapeutic support and follow-up, examinations as part of work ability assessment; driver medicals for all licence categories and certificate renewals, including professional drivers; laboratory diagnostics — basic tests, ECG and blood pressure measurement, spirometry; ultrasound of the abdomen, thyroid, breasts, soft tissues and lymph nodes. Appointments can be booked online via the website or by phone. The Nikšić practice is at Vuka Karadžića 84, behind the "Mileva Lajović Lalatović" primary school. Opening hours: Monday–Friday 9:00–17:00.',
	description_de = 'Die PZU „Nova medicina rada“ ist eine private arbeitsmedizinische Klinik mit Praxen in Podgorica und Nikšić, die Erfahrung aus Arbeitsmedizin, Psychologie, Psychiatrie und Radiologie vereint. Leistungen: Einstellungs- und Vorsorgeuntersuchungen — Erst-, regelmäßige und Kontrolluntersuchungen, ärztliche Bescheinigungen für besondere Positionen und Beurteilung der Arbeitsfähigkeit (die Vorsorgeuntersuchung umfasst je nach Arbeitsplatz eine allgemeinärztliche Untersuchung, Laboranalysen, EKG, Spirometrie und eine psychologische Beurteilung), mit besonderen Paketen und Gruppenuntersuchungen für Unternehmen; psychologische Beratung — Einzelberatung und Unterstützung, Stress- und Angstbeurteilung, Krisenberatung; psychiatrische Untersuchungen — Beurteilung der psychischen Gesundheit, therapeutische Begleitung und Verlaufskontrolle, Untersuchungen im Rahmen der Arbeitsfähigkeitsbeurteilung; Untersuchungen für Kraftfahrer aller Klassen und Verlängerung von Bescheinigungen, auch für Berufskraftfahrer; Labordiagnostik — Basisanalysen, EKG und Blutdruckmessung, Spirometrie; Ultraschall von Abdomen, Schilddrüse, Brust, Weichteilen und Lymphknoten. Termine online über die Website oder telefonisch. Die Praxis in Nikšić befindet sich in der Vuka Karadžića 84, hinter der Grundschule „Mileva Lajović Lalatović“. Öffnungszeiten: Montag–Freitag 9–17 Uhr.',
	description_tr = 'PZU "Nova medicina rada", Podgorica ve Nikšić''te muayenehaneleri bulunan, iş sağlığı, psikoloji, psikiyatri ve radyoloji alanlarındaki deneyimi birleştiren özel bir iş sağlığı kliniğidir. Hizmetler: işe giriş ve periyodik muayeneler — ilk, periyodik ve kontrol muayeneleri, özel pozisyonlar için sağlık raporları ve çalışma kapasitesi değerlendirmesi (periyodik muayene, iş yerine göre genel hekim muayenesi, laboratuvar tahlilleri, EKG, spirometri ve psikolojik değerlendirmeyi kapsar), şirketler için özel paketler ve toplu muayeneler; psikolojik danışmanlık — bireysel danışmanlık ve destek, stres ve kaygı değerlendirmesi, kriz danışmanlığı; psikiyatri muayeneleri — ruh sağlığı değerlendirmesi, terapötik destek ve takip, çalışma kapasitesi değerlendirmesi kapsamında muayeneler; profesyonel sürücüler dahil tüm ehliyet sınıfları için sürücü muayeneleri ve rapor yenileme; laboratuvar tanısı — temel tahliller, EKG ve tansiyon ölçümü, spirometri; karın, tiroid, meme, yumuşak doku ve lenf nodu ultrasonu. Randevu web sitesi üzerinden online veya telefonla alınır. Nikšić muayenehanesi "Mileva Lajović Lalatović" ilkokulunun arkasında, Vuka Karadžića 84 adresindedir. Çalışma saatleri: pazartesi–cuma 9:00–17:00.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- POLYCLINIC = 1 — клиника медицины труда (медосмотры, психиатр, психолог, лаборатория, УЗИ); отдельного типа медицины труда нет (как у прошлых импортов «laboratorija + medicina rada»).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском, другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — /niksic: «Radno vrijeme: Ponedjeljak - Petak: 09:00 - 17:00, Subota - Nedjelja: Zatvoreno».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday),
	tuesday = VALUES(tuesday),
	wednesday = VALUES(wednesday),
	thursday = VALUES(thursday),
	friday = VALUES(friday),
	saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- ═══════════════════════════════════════════════════════════════
-- Имён врачей на сайте нет (только «licencirani psihijatri», «tim licenciranih psihologa», «specijalisti») → по правилу юзера не заводим.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 2, status = published, clinic_languages = '1', clinic_types = '1', hours = 1
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

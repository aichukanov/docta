-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dr Ševaljević (Tivat) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dr-sevaljevic-tivat.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/dr-sevaljevic-tivat.json):
--   * https://www.drsevaljevic.me/ — одностраничник (me), английская версия — drsevaljevic.com (тот же состав).
--     ⚠️ Last-Modified картинок — 2015 (фото врачей 2015-07, логотип 2015-12), ссылки на Google+ — сайт ~2015, состав мог устареть.
--   * data/google-places/tivat/stomatoloska-ordinacija-dr-sevaljevic-dentist-dr-sevaljevic.json — place_id, координаты, телефон.
-- Адрес: сайт «Njegoševa 1A, Tivat 85320» = Google «1 A Njegoševa». Телефоны: «Fiksni: 032 671 977», «Mob: Dr Marina: 069 088 810,
-- Dr Jovan: 069 504 992, Dr Branko: 069 447 599» (мобильный Марины = Google). Email/Facebook — сайт (Twitter и Google+ не заносим).
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ0yC6VJwxTBMRLu4wgJzWJCU';
SET @clinic_slug = 'dr-sevaljevic-tivat';

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
	4, -- CityId.TIVAT
	'Stomatološka ordinacija Dr Ševaljević',
	'Стоматолошка ординација Др Шеваљевић',
	'Стоматологический кабинет Dr Ševaljević',
	'Njegoševa 1A',
	'Његошева 1А',
	'',
	'',
	'85320',
	42.42936800,
	18.69742900,
	'+38232671977;+38269088810;+38269504992;+38269447599',
	'kontakt@drsevaljevic.me',
	'https://www.drsevaljevic.me/',
	'facebook.com/drsevaljevic',
	'',
	'',
	'',
	'',
	'https://www.drsevaljevic.me/img/logo-dr-sevaljevic.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Др Шеваљевић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Dr Ševaljević', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Njegoševa 1A', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Његошева 1А', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85320', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38232671977;+38269088810;+38269504992;+38269447599', phone),
	email = IF(email IS NULL OR email = '', 'kontakt@drsevaljevic.me', email),
	website = IF(website IS NULL OR website = '', 'https://www.drsevaljevic.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/drsevaljevic', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.drsevaljevic.me/img/logo-dr-sevaljevic.png', logo_url),
	latitude = COALESCE(latitude, 42.42936800),
	longitude = COALESCE(longitude, 18.69742900)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Dr Ševaljević“ nalazi se u Tivtu, u Njegoševoj ulici 1A, i postoji od 1997. godine — prva je privatna stomatološka ordinacija u Tivtu. Osnovali su je supružnici Jovan i Marina Ševaljević, koji i danas ordiniraju zajedno sa sinom Brankom i timom stručnjaka iz različitih oblasti stomatologije (oralni hirurg, ortodont, protetičari). Ordinacija pruža preglede i dijagnostiku, endodonciju, dječju stomatologiju, ortopediju vilica, parodontologiju, zubnu protetiku (metal-keramika, bezmetalna keramika e.max i cirkon, skeletirane i totalne proteze, keramičke fasete, kombinovani radovi sa atečmenima), implante, bijeljenje zuba i oralnu hirurgiju.',
	description_sr_cyrl = 'Стоматолошка ординација „Др Шеваљевић“ налази се у Тивту, у Његошевој улици 1А, и постоји од 1997. године — прва је приватна стоматолошка ординација у Тивту. Основали су је супружници Јован и Марина Шеваљевић, који и данас ординирају заједно са сином Бранком и тимом стручњака из различитих области стоматологије (орални хирург, ортодонт, протетичари). Ординација пружа прегледе и дијагностику, ендодонцију, дјечју стоматологију, ортопедију вилица, пародонтологију, зубну протетику (метал-керамика, безметална керамика e.max и циркон, скелетиране и тоталне протезе, керамичке фасете, комбиновани радови са атечменима), импланте, бијељење зуба и оралну хирургију.',
	description_ru = 'Стоматологический кабинет «Dr Ševaljević» находится в Тивате, на улице Негошева, 1A, и работает с 1997 года — это первый частный стоматологический кабинет в Тивате. Его основали супруги Йован и Марина Шевалевич, которые и сегодня ведут приём вместе с сыном Бранко и командой специалистов из разных областей стоматологии (хирург-стоматолог, ортодонт, ортопеды-стоматологи). Кабинет проводит осмотры и диагностику, эндодонтическое лечение, детскую стоматологию, ортодонтию, пародонтологию, протезирование (металлокерамика, безметалловая керамика e.max и цирконий, бюгельные и полные съёмные протезы, керамические виниры, комбинированные конструкции с аттачменами), имплантацию, отбеливание зубов и хирургическую стоматологию.',
	description_en = 'Dr Ševaljević is a dental practice in Tivat, at Njegoševa 1A, operating since 1997 as the first private dental practice in Tivat. It was founded by the married couple Jovan and Marina Ševaljević, who still work there together with their son Branko and a team of specialists from various fields of dentistry (oral surgeon, orthodontist, prosthodontists). The practice offers examinations and diagnostics, endodontics, paediatric dentistry, orthodontics, periodontology, prosthodontics (metal-ceramic, metal-free e.max and zirconia, cast partial and complete dentures, ceramic veneers, combined fixed-removable work with attachments), dental implants, teeth whitening and oral surgery.',
	description_de = 'Dr Ševaljević ist eine Zahnarztpraxis in Tivat, Njegoševa 1A, die seit 1997 besteht – die erste private Zahnarztpraxis in Tivat. Gegründet wurde sie von dem Ehepaar Jovan und Marina Ševaljević, die heute gemeinsam mit ihrem Sohn Branko und einem Team von Fachleuten aus verschiedenen Bereichen der Zahnmedizin (Oralchirurg, Kieferorthopäde, Prothetiker) arbeiten. Die Praxis bietet Untersuchung und Diagnostik, Endodontie, Kinderzahnheilkunde, Kieferorthopädie, Parodontologie, Prothetik (Metallkeramik, metallfreie Keramik e.max und Zirkon, Modellguss- und Totalprothesen, Keramikveneers, kombinierte festsitzend-herausnehmbare Arbeiten mit Geschieben), Implantate, Zahnaufhellung und Oralchirurgie.',
	description_tr = 'Dr Ševaljević, Tivat''ta Njegoševa 1A adresinde bulunan ve 1997''den beri hizmet veren bir diş muayenehanesidir; Tivat''taki ilk özel diş muayenehanesidir. Muayenehaneyi Jovan ve Marina Ševaljević çifti kurdu; bugün de oğulları Branko ve diş hekimliğinin farklı alanlarından uzmanlarla (ağız cerrahı, ortodontist, protez uzmanları) birlikte çalışıyorlar. Muayene ve teşhis, endodonti, çocuk diş hekimliği, ortodonti, periodontoloji, protez (metal-seramik, metalsiz e.max ve zirkonyum, iskelet ve tam protezler, seramik lamina, ataşmanlı kombine çalışmalar), implant, diş beyazlatma ve ağız cerrahisi hizmetleri sunulur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (английская версия drsevaljevic.com — не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: «Radno vrijeme — Pon - Pet: 8h do 13h i 16h do 20h, Sub: 8h do 11h, Ned: Zatvoreno» (блок «Posjetite našu Ordinaciju»).
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "11:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3)
-- Состав — блок «Naš tim»: Marina, Jovan и Branko Ševaljević, все «Stomatolog». «Konsultanti — Oralni Hirurg i Ortodont» без имён — не
-- заводятся. В БД никого с фамилией Ševaljević нет (поиск 2026-10-09). Специальность 78 = DENTISTRY, язык 1 = SR.
-- Телефон врача — его мобильный из блока «Kontakt informacije».
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Marina Ševaljević — Stomatolog; osnivač ordinacije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marina Ševaljević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ševaljević Marina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marina-sevaljevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'marina-sevaljevic', 'Marina Ševaljević', 'Марина Шеваљевић', 'Марина Шевалевич', 'Marina Sevaljevic', 'dr',
	'https://www.drsevaljevic.me/img/team/dr-marina-sevaljevic.jpg', '+38269088810', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog. Stomatološki fakultet u Beogradu završila je 1988. godine, a stručnu praksu obavila je na Stomatološkom fakultetu u Beogradu. Sa suprugom Jovanom 1997. godine otvorila je privatnu stomatološku ordinaciju „Dr Ševaljević“ u Tivtu.',
	description_sr_cyrl = 'Стоматолог. Стоматолошки факултет у Београду завршила је 1988. године, а стручну праксу обавила је на Стоматолошком факултету у Београду. Са супругом Јованом 1997. године отворила је приватну стоматолошку ординацију „Др Шеваљевић“ у Тивту.',
	description_ru = 'Стоматолог. В 1988 году окончила стоматологический факультет в Белграде, там же прошла профессиональную практику. В 1997 году вместе с супругом Йованом открыла в Тивате частный стоматологический кабинет «Dr Ševaljević».',
	description_en = 'Dentist. She graduated from the School of Dentistry in Belgrade in 1988 and completed her professional training there. In 1997 she and her husband Jovan opened the private Dr Ševaljević dental practice in Tivat.',
	description_de = 'Zahnärztin. Sie schloss 1988 das Zahnmedizinstudium in Belgrad ab und absolvierte dort auch ihr Praktikum. 1997 eröffnete sie mit ihrem Ehemann Jovan die private Zahnarztpraxis Dr Ševaljević in Tivat.',
	description_tr = 'Diş hekimi. 1988''de Belgrad Diş Hekimliği Fakültesinden mezun oldu ve stajını da orada tamamladı. 1997''de eşi Jovan ile birlikte Tivat''ta özel Dr Ševaljević diş muayenehanesini açtı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog; osnivač ordinacije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Jovan Ševaljević — Stomatolog; osnivač ordinacije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jovan Ševaljević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ševaljević Jovan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jovan-sevaljevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'jovan-sevaljevic', 'Jovan Ševaljević', 'Јован Шеваљевић', 'Йован Шевалевич', 'Jovan Sevaljevic', 'dr',
	'https://www.drsevaljevic.me/img/team/dr-jovan-sevaljevic.jpg', '+38269504992', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog. Stomatološki fakultet u Beogradu završio je 1989. godine, a stručnu praksu obavio je u Domu zdravlja Tivat. Sa suprugom Marinom 1997. godine otvorio je privatnu stomatološku ordinaciju „Dr Ševaljević“ u Tivtu.',
	description_sr_cyrl = 'Стоматолог. Стоматолошки факултет у Београду завршио је 1989. године, а стручну праксу обавио је у Дому здравља Тиват. Са супругом Марином 1997. године отворио је приватну стоматолошку ординацију „Др Шеваљевић“ у Тивту.',
	description_ru = 'Стоматолог. В 1989 году окончил стоматологический факультет в Белграде, профессиональную практику прошёл в Доме здоровья Тивата. В 1997 году вместе с супругой Мариной открыл в Тивате частный стоматологический кабинет «Dr Ševaljević».',
	description_en = 'Dentist. He graduated from the School of Dentistry in Belgrade in 1989 and completed his professional training at the Tivat health centre. In 1997 he and his wife Marina opened the private Dr Ševaljević dental practice in Tivat.',
	description_de = 'Zahnarzt. Er schloss 1989 das Zahnmedizinstudium in Belgrad ab und absolvierte sein Praktikum im Gesundheitszentrum Tivat. 1997 eröffnete er mit seiner Ehefrau Marina die private Zahnarztpraxis Dr Ševaljević in Tivat.',
	description_tr = 'Diş hekimi. 1989''da Belgrad Diş Hekimliği Fakültesinden mezun oldu, stajını Tivat Sağlık Merkezinde yaptı. 1997''de eşi Marina ile birlikte Tivat''ta özel Dr Ševaljević diş muayenehanesini açtı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog; osnivač ordinacije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Branko Ševaljević — Stomatolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Branko Ševaljević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ševaljević Branko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'branko-sevaljevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'branko-sevaljevic', 'Branko Ševaljević', 'Бранко Шеваљевић', 'Бранко Шевалевич', 'Branko Sevaljevic', 'dr',
	'https://www.drsevaljevic.me/img/team/dr-branko-sevaljevic.jpg', '+38269447599', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog. Stomatološki fakultet u Pančevu završio je 2013. godine, a stručnu praksu obavio je na Vojnomedicinskoj akademiji u Beogradu. U ordinaciji „Dr Ševaljević“ radi od 2015. godine.',
	description_sr_cyrl = 'Стоматолог. Стоматолошки факултет у Панчеву завршио је 2013. године, а стручну праксу обавио је на Војномедицинској академији у Београду. У ординацији „Др Шеваљевић“ ради од 2015. године.',
	description_ru = 'Стоматолог. В 2013 году окончил стоматологический факультет в Панчево, профессиональную практику прошёл в Военно-медицинской академии в Белграде. Работает в кабинете «Dr Ševaljević» с 2015 года.',
	description_en = 'Dentist. He graduated from the School of Dentistry in Pančevo in 2013 and completed his professional training at the Military Medical Academy in Belgrade. He has worked at the Dr Ševaljević practice since 2015.',
	description_de = 'Zahnarzt. Er schloss 2013 das Zahnmedizinstudium in Pančevo ab und absolvierte sein Praktikum an der Militärmedizinischen Akademie in Belgrad. Seit 2015 arbeitet er in der Praxis Dr Ševaljević.',
	description_tr = 'Diş hekimi. 2013''te Pančevo Diş Hekimliği Fakültesinden mezun oldu, stajını Belgrad Askeri Tıp Akademisinde yaptı. 2015''ten beri Dr Ševaljević muayenehanesinde çalışıyor.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 4, status = published, clinic_languages = 1, clinic_types = 2, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3 врач(а/ей): marina-sevaljevic, jovan-sevaljevic, branko-sevaljevic.
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

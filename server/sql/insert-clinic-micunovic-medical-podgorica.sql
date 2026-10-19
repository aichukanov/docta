-- ═══════════════════════════════════════════════════════════════════════════
-- Mićunović Medical (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-micunovic-medical-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/micunovic-medical-podgorica.json):
--   * https://www.micunovicmedical.me/ — WP REST /wp-json/wp/v2/pages (home-one 2026-08-28,
--     nas-tim 2026-08-28, o-nama 2026-07-29, kontakt 2026-07-27, 3 страницы услуг 2026-07-17),
--     /wp-json/wp/v2/doctio_team (био Petar / Miljan / Gradimirka / Ana Gadža),
--     /wp-json/wp/v2/posts (ZygoMax). ⚠️ curl с UA «Mozilla/5.0» получает 403 — без UA
--     или с полным UA браузера отдаёт 200.
--   * data/google-places/podgorica/micunovic-medical.json — place_id, координаты
--     42.4540883 / 19.2369073, телефон +382 69 869 377 (74 отзыва — не импортируются).
--
-- Сверка: адрес «Slovačka 22, Podgorica» (сайт /kontakt/) = Google «22 Slovačka».
-- Телефоны: стоматология 069869377 (сайт + Google), гинекология 020623626 (сайт),
-- +382 20 623 880 (главная и /o-nama/ «KONTAKTIRAJTE NAS»).
-- Часы: «Naše radno vrijeme je svakog dana od 09:00 do 17:00 h, nedjelja je neradna»
-- (страницы гинекологии и УЗИ) → пн–сб 09:00–17:00, вс закрыто.
--
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug, врачи
-- по name_sr / перевёрнутому имени / slug; пустые поля существующей записи
-- дозаполняются, непустые не трогаются (status тоже). description_* клиники и
-- новых врачей пишутся БЕЗУСЛОВНЫМ UPDATE — правки описаний вносить сюда, иначе
-- следующий прогон их перезапишет. Языки клиники и часы синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ1VxH0hTrTRMRyy8OYWPH7kU';
SET @clinic_slug = 'micunovic-medical-podgorica';

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
	'Mićunović Medical',
	'Мићуновић Medical',
	'Клиника Mićunović Medical',
	'Slovačka 22',
	'Словачка 22',
	'',
	'',
	'81000',
	42.45408830,
	19.23690730,
	'+38269869377;+38220623626;+38220623880',
	'micunovicmedical@gmail.com',
	'https://www.micunovicmedical.me/',
	'facebook.com/Micunovicmedical',
	'@micunovic_medical',
	'',
	'',
	'',
	'https://www.micunovicmedical.me/wp-content/uploads/2026/07/micunovic-medical-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Мићуновић Medical', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Клиника Mićunović Medical', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Slovačka 22', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Словачка 22', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude = COALESCE(latitude, 42.45408830),
	longitude = COALESCE(longitude, 19.23690730),
	phone = IF(phone IS NULL OR phone = '', '+38269869377;+38220623626;+38220623880', phone),
	email = IF(email IS NULL OR email = '', 'micunovicmedical@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.micunovicmedical.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/Micunovicmedical', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@micunovic_medical', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.micunovicmedical.me/wp-content/uploads/2026/07/micunovic-medical-logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (см. шапку). Только то, что клиника пишет о себе; превосходные
-- степени сайта («jedna od vodećih», «najbolji stomatolog») не перенесены.
UPDATE clinics SET
	description_sr = 'Privatna zdravstvena ustanova u Podgorici, u Slovačkoj ulici 22, koja pruža usluge iz oblasti stomatologije, ginekologije i ultrazvučne dijagnostike. Ustanova postoji od 1983. godine. Centar za stomatologiju čine tri ordinacije, odvojeni sterilizacioni blok i rendgen dijagnostika najnovije generacije. Stomatološki tim radi redovne preglede, profesionalno čišćenje zuba, liječenje korijenskih kanala i vađenje zuba, estetsku stomatologiju (izbjeljivanje zuba, keramičke krunice i mostovi, fasete), oralnu hirurgiju i implantologiju sa implantatima Nobel Biocare, Sweden & Martina, Camlog i JDental Care. Ginekološka služba obuhvata ginekološke preglede i liječenje, savjetovanje o kontracepciji i planiranju porodice, kao i 2D, 3D i 4D ultrazvučne preglede, uključujući praćenje trudnoće.',
	description_sr_cyrl = 'Приватна здравствена установа у Подгорици, у Словачкој улици 22, која пружа услуге из области стоматологије, гинекологије и ултразвучне дијагностике. Установа постоји од 1983. године. Центар за стоматологију чине три ординације, одвојени стерилизациони блок и рендген дијагностика најновије генерације. Стоматолошки тим ради редовне прегледе, професионално чишћење зуба, лијечење коријенских канала и вађење зуба, естетску стоматологију (избјељивање зуба, керамичке крунице и мостови, фасете), оралну хирургију и имплантологију са имплантатима Nobel Biocare, Sweden & Martina, Camlog и JDental Care. Гинеколошка служба обухвата гинеколошке прегледе и лијечење, савјетовање о контрацепцији и планирању породице, као и 2D, 3D и 4D ултразвучне прегледе, укључујући праћење трудноће.',
	description_ru = 'Частное медицинское учреждение в Подгорице на улице Словачка, 22, работающее в области стоматологии, гинекологии и ультразвуковой диагностики. Учреждение существует с 1983 года. Стоматологический центр состоит из трёх кабинетов, отдельного стерилизационного блока и рентгеновской диагностики последнего поколения. Стоматологи проводят регулярные осмотры, профессиональную чистку зубов, лечение корневых каналов и удаление зубов, эстетическую стоматологию (отбеливание зубов, керамические коронки и мосты, виниры), хирургическую стоматологию и имплантацию с имплантами Nobel Biocare, Sweden & Martina, Camlog и JDental Care. Гинекологическая служба выполняет гинекологические осмотры и лечение, консультирует по контрацепции и планированию семьи, проводит УЗИ в режимах 2D, 3D и 4D, в том числе для наблюдения беременности.',
	description_en = 'A private healthcare facility in Podgorica, at Slovačka 22, providing dentistry, gynaecology and ultrasound diagnostics. The facility has existed since 1983. Its dental centre consists of three surgeries, a separate sterilisation unit and latest-generation X-ray diagnostics. The dental team provides regular check-ups, professional teeth cleaning, root canal treatment and tooth extraction, cosmetic dentistry (teeth whitening, ceramic crowns and bridges, veneers), oral surgery and implantology with Nobel Biocare, Sweden & Martina, Camlog and JDental Care implants. The gynaecology service covers gynaecological examinations and treatment, contraception and family planning counselling, and 2D, 3D and 4D ultrasound, including pregnancy monitoring.',
	description_de = 'Private Gesundheitseinrichtung in Podgorica, Slovačka 22, mit Leistungen in Zahnmedizin, Gynäkologie und Ultraschalldiagnostik. Die Einrichtung besteht seit 1983. Das Zahnzentrum umfasst drei Behandlungsräume, einen separaten Sterilisationsbereich und Röntgendiagnostik der neuesten Generation. Das zahnärztliche Team bietet regelmäßige Kontrolluntersuchungen, professionelle Zahnreinigung, Wurzelkanalbehandlung und Zahnextraktion, ästhetische Zahnmedizin (Zahnaufhellung, Keramikkronen und -brücken, Veneers), Oralchirurgie und Implantologie mit Implantaten von Nobel Biocare, Sweden & Martina, Camlog und JDental Care. Die gynäkologische Abteilung bietet gynäkologische Untersuchungen und Behandlungen, Beratung zu Verhütung und Familienplanung sowie 2D-, 3D- und 4D-Ultraschall, einschließlich Schwangerschaftsbegleitung.',
	description_tr = 'Podgorica''da Slovačka 22 adresinde diş hekimliği, jinekoloji ve ultrason tanı hizmetleri veren özel sağlık kuruluşu. Kuruluş 1983 yılından beri faaliyettedir. Diş merkezi üç muayene odası, ayrı bir sterilizasyon ünitesi ve son nesil röntgen tanı cihazlarından oluşur. Diş hekimleri düzenli kontroller, profesyonel diş temizliği, kanal tedavisi ve diş çekimi, estetik diş hekimliği (diş beyazlatma, seramik kron ve köprüler, lamina), ağız cerrahisi ve Nobel Biocare, Sweden & Martina, Camlog ve JDental Care implantlarıyla implantoloji hizmetleri sunar. Jinekoloji bölümü jinekolojik muayene ve tedavi, doğum kontrolü ve aile planlaması danışmanlığı ile gebelik takibi dahil 2D, 3D ve 4D ultrason muayeneleri yapar.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2, GYNECOLOGICAL_CLINIC = 7 (два направления клиники;
-- УЗИ на сайте — гинекологическое и в беременности).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2), (@clinic_id, 7);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет
-- приём на других языках → только SR (LanguageId.SR = 1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- «svakog dana od 09:00 do 17:00 h, nedjelja je neradna»
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "17:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (11 из /nas-tim/, порядок как на сайте)
-- Специальности: 78 = DENTISTRY, 74 = ORAL_SURGERY, 93 = ORTHODONTIST,
--                5 = GYNECOLOGY_OBSTETRICS, 19 = ANESTHESIOLOGY.
-- «spec. protetike» — отдельной специальности протетики в enum нет → DENTISTRY (78),
-- как у остальных протетиков в БД. «ortopedija vilice» = ортодонтия → 78 + 93.
-- Язык 1 = SR (других сайт ни у кого из 11 не заявляет).
-- Фото: на /nas-tim/ у 6 врачей стоит общая заглушка wp-content/uploads/2026/08/images.jpeg
-- (8,9 КБ, один файл на всех) — им photo_url = NULL.
-- НЕ заводятся: Edin Osmanović («anestetičar», не врач); dr Ana Gadža — есть отдельная
-- страница /team/dr-ana-gadza/, но в текущем составе /nas-tim/ (правка 2026-08-28) её нет.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Petar Mićunović — spec. protetike
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Petar Mićunović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mićunović Petar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'petar-micunovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'petar-micunovic', 'Petar Mićunović', 'Петар Мићуновић', 'Петар Мичунович', 'Petar Micunovic', 'Dr',
	'https://www.micunovicmedical.me/wp-content/uploads/2026/08/2.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Osnivač ordinacije Mićunović Medical. Stomatološki fakultet u Nišu završio je 1983. godine, a specijalizaciju iz stomatološke protetike na Stomatološkom fakultetu u Beogradu 1991. godine. Ima 40 godina radnog iskustva, uz edukacije u zemlji i inostranstvu i boravak na Klinici za stomatologiju VMA u Beogradu. Skoro deceniju, do juna 1999. godine, vodio je Stomatološku polikliniku u Peći.',
	description_sr_cyrl = 'Оснивач ординације Mićunović Medical. Стоматолошки факултет у Нишу завршио је 1983. године, а специјализацију из стоматолошке протетике на Стоматолошком факултету у Београду 1991. године. Има 40 година радног искуства, уз едукације у земљи и иностранству и боравак на Клиници за стоматологију ВМА у Београду. Скоро деценију, до јуна 1999. године, водио је Стоматолошку поликлинику у Пећи.',
	description_ru = 'Основатель клиники Mićunović Medical. В 1983 году окончил стоматологический факультет в Нише, в 1991 году получил специализацию по ортопедической стоматологии (протезированию) на стоматологическом факультете в Белграде. Стаж работы — 40 лет; проходил обучение в стране и за рубежом, работал в Клинике стоматологии Военно-медицинской академии в Белграде. Почти десять лет, до июня 1999 года, руководил стоматологической поликлиникой в Пече.',
	description_en = 'Founder of Mićunović Medical. He graduated from the School of Dentistry in Niš in 1983 and specialised in prosthodontics at the School of Dental Medicine in Belgrade in 1991. He has 40 years of professional experience, including training in Serbia and abroad and a period at the Dental Clinic of the Military Medical Academy in Belgrade. For almost a decade, until June 1999, he headed the dental polyclinic in Peć.',
	description_de = 'Gründer der Praxis Mićunović Medical. Er schloss 1983 das Zahnmedizinstudium in Niš ab und absolvierte 1991 die Fachausbildung in zahnärztlicher Prothetik an der Zahnmedizinischen Fakultät in Belgrad. Er verfügt über 40 Jahre Berufserfahrung, mit Fortbildungen im In- und Ausland und einer Tätigkeit an der Zahnklinik der Militärmedizinischen Akademie in Belgrad. Fast ein Jahrzehnt, bis Juni 1999, leitete er die zahnärztliche Poliklinik in Peć.',
	description_tr = 'Mićunović Medical kliniğinin kurucusu. 1983 yılında Niş Diş Hekimliği Fakültesinden mezun oldu, 1991 yılında Belgrad Diş Hekimliği Fakültesinde protetik diş tedavisi uzmanlığını aldı. Yurt içi ve yurt dışında eğitimler ve Belgrad Askeri Tıp Akademisi Diş Kliniğinde çalışma dahil 40 yıllık mesleki deneyime sahiptir. Haziran 1999''a kadar yaklaşık on yıl boyunca İpek''teki (Peć) diş polikliniğini yönetti.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista stomatološke protetike')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Miljan Mićunović — spec. oralne hirurgije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Miljan Mićunović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mićunović Miljan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'miljan-micunovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'miljan-micunovic', 'Miljan Mićunović', 'Миљан Мићуновић', 'Милян Мичунович', 'Miljan Micunovic', 'Dr',
	'https://www.micunovicmedical.me/wp-content/uploads/2026/08/6.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- «direktor» не перенесён: сайт противоречит сам себе (пост 2026-07-27 называет директором
-- Miljana, био Gradimirke — её с 2023, био Petra — «osnivač i direktor»); оставлено только в био
-- Gradimirke как её собственный факт.
-- Рейтинги сайта («među 100 najboljih doktora u svijetu», «jedan od vodećih hirurga»)
-- не перенесены — заявление клиники, не проверяемый факт.
UPDATE doctors SET
	description_sr = 'Specijalista oralne hirurgije u ordinaciji Mićunović Medical. Bavi se zigomatskim implantatima; vlasnik je ZAGA centra Crna Gora i osnivač asocijacije ZygoMax, koja organizuje međunarodne kongrese i edukacije uživo iz oralne hirurgije i dentalne implantologije.',
	description_sr_cyrl = 'Специјалиста оралне хирургије у ординацији Mićunović Medical. Бави се зигоматским имплантатима; власник је ZAGA центра Црна Гора и оснивач асоцијације ZygoMax, која организује међународне конгресе и едукације уживо из оралне хирургије и денталне имплантологије.',
	description_ru = 'Специалист по хирургической стоматологии в клинике Mićunović Medical. Занимается скуловыми (зигоматическими) имплантами; владелец центра ZAGA Черногория и основатель ассоциации ZygoMax, которая проводит международные конгрессы и обучение с операциями в прямом эфире по хирургической стоматологии и дентальной имплантологии.',
	description_en = 'Oral surgery specialist at Mićunović Medical. He works with zygomatic implants; he owns the ZAGA Centre Montenegro and founded the ZygoMax association, which organises international congresses and live-surgery training in oral surgery and dental implantology.',
	description_de = 'Facharzt für Oralchirurgie in der Praxis Mićunović Medical. Er arbeitet mit Zygoma-Implantaten; er ist Inhaber des ZAGA-Zentrums Montenegro und Gründer der Vereinigung ZygoMax, die internationale Kongresse und Live-OP-Fortbildungen in Oralchirurgie und dentaler Implantologie veranstaltet.',
	description_tr = 'Mićunović Medical kliniğinde ağız cerrahisi uzmanı. Zigomatik implantlarla çalışır; ZAGA Karadağ merkezinin sahibi ve ağız cerrahisi ile dental implantoloji alanında uluslararası kongreler ve canlı cerrahi eğitimleri düzenleyen ZygoMax derneğinin kurucusudur.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Gradimirka Mićunović — specijalista ginekologije i akušerstva
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Gradimirka Mićunović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mićunović Gradimirka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'gradimirka-micunovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gradimirka-micunovic', 'Gradimirka Mićunović', 'Градимирка Мићуновић', 'Градимирка Мичунович', 'Gradimirka Micunovic', 'Dr',
	'https://www.micunovicmedical.me/wp-content/uploads/2026/08/1-2.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Rođena 1962. godine u Peći. Medicinski fakultet u Beogradu završila je 1985. godine, a specijalizaciju iz ginekologije i akušerstva u Nišu 1994. godine. Do 1999. godine radila je na ginekološko-akušerskom odjeljenju Opšte bolnice u Peći, a od 2003. do 2014. godine u centru za vantjelesnu oplodnju privatne zdravstvene ustanove ARS Medica u Podgorici. U Mićunović Medical radi od 2012. godine, a od 2023. godine je direktorka ustanove.',
	description_sr_cyrl = 'Рођена 1962. године у Пећи. Медицински факултет у Београду завршила је 1985. године, а специјализацију из гинекологије и акушерства у Нишу 1994. године. До 1999. године радила је на гинеколошко-акушерском одјељењу Опште болнице у Пећи, а од 2003. до 2014. године у центру за вантјелесну оплодњу приватне здравствене установе ARS Medica у Подгорици. У Mićunović Medical ради од 2012. године, а од 2023. године је директорка установе.',
	description_ru = 'Родилась в 1962 году в Пече. В 1985 году окончила медицинский факультет в Белграде, в 1994 году получила специализацию по гинекологии и акушерству в Нише. До 1999 года работала в гинекологическо-акушерском отделении общей больницы в Пече, с 2003 по 2014 год — в центре ЭКО частного медицинского учреждения ARS Medica в Подгорице. В Mićunović Medical работает с 2012 года, с 2023 года — директор учреждения.',
	description_en = 'Born in 1962 in Peć. She graduated from the Faculty of Medicine in Belgrade in 1985 and specialised in gynaecology and obstetrics in Niš in 1994. Until 1999 she worked in the gynaecology and obstetrics department of the General Hospital in Peć, and from 2003 to 2014 at the IVF centre of the private healthcare facility ARS Medica in Podgorica. She has worked at Mićunović Medical since 2012 and has been its director since 2023.',
	description_de = '1962 in Peć geboren. Sie schloss 1985 das Medizinstudium in Belgrad ab und erwarb 1994 in Niš die Facharztanerkennung für Gynäkologie und Geburtshilfe. Bis 1999 arbeitete sie in der gynäkologisch-geburtshilflichen Abteilung des Allgemeinen Krankenhauses in Peć, von 2003 bis 2014 im IVF-Zentrum der privaten Gesundheitseinrichtung ARS Medica in Podgorica. Seit 2012 ist sie bei Mićunović Medical tätig, seit 2023 als Direktorin der Einrichtung.',
	description_tr = '1962 yılında İpek''te (Peć) doğdu. 1985 yılında Belgrad Tıp Fakültesinden mezun oldu, 1994 yılında Niş''te kadın hastalıkları ve doğum uzmanlığını aldı. 1999 yılına kadar İpek Genel Hastanesinin kadın hastalıkları ve doğum servisinde, 2003–2014 yılları arasında ise Podgorica''daki özel sağlık kuruluşu ARS Medica''nın tüp bebek merkezinde çalıştı. 2012''den beri Mićunović Medical''da çalışmakta olup 2023''ten beri kuruluşun direktörüdür.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ginekologije i akušerstva')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Snežana Ražnatović — specijalista ortopedije vilice. Фото — заглушка.
-- В БД есть однофамильцы Ražnatović (Aleksandra — психиатр, Boris/Zorica — Dr Ražnatović
-- stomatološka ordinacija, Zoran — хирург): другие люди, Snežane нет.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Snežana Ražnatović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ražnatović Snežana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'snezana-raznatovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-raznatovic', 'Snežana Ražnatović', 'Снежана Ражнатовић', 'Снежана Ражнатович', 'Snezana Raznatovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilice')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Miloš Simonović — specijalista ortopedije vilice. Фото — заглушка.
-- ⚠️ НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: doctors.id 690 (локаль), slug milos-simonovic, «dr spec.»,
-- DENTISTRY (78), привязан к «Dr Simonović — Stomatološka Ordinacija» (Бар). Тёзка-стоматолог
-- со званием специалиста в соседнем городе — единственный кандидат, привязка по правилу
-- find-or-create; добавляется ORTHODONTIST (93). Если это другой человек — см. openQuestions
-- записи импорта (тогда заводить с отдельным slug).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Miloš Simonović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Simonović Miloš' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milos-simonovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milos-simonovic', 'Miloš Simonović', 'Милош Симоновић', 'Милош Симонович', 'Milos Simonovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilice')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Elizabeta Sinishtaj — doktor stomatologije. Фото — заглушка.
-- Фамилия в албанской орфографии, как на сайте («sh» = ш): кириллица «Сиништај».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Elizabeta Sinishtaj' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Sinishtaj Elizabeta' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'elizabeta-sinishtaj' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'elizabeta-sinishtaj', 'Elizabeta Sinishtaj', 'Елизабета Сиништај', 'Элизабета Сиништай', 'Elizabeta Sinishtaj', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Nenad Mračević — doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nenad Mračević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mračević Nenad' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nenad-mracevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nenad-mracevic', 'Nenad Mračević', 'Ненад Мрачевић', 'Ненад Мрачевич', 'Nenad Mracevic', 'Dr',
	'https://www.micunovicmedical.me/wp-content/uploads/2026/08/4.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Medina Tuzović — doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Medina Tuzović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Tuzović Medina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'medina-tuzovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'medina-tuzovic', 'Medina Tuzović', 'Медина Тузовић', 'Медина Тузович', 'Medina Tuzovic', 'Dr',
	'https://www.micunovicmedical.me/wp-content/uploads/2026/08/5-1.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Milena Milikić — doktor stomatologije. Фото — заглушка.
-- В БД есть Dragica Milikić (id 263, невролог) — другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milena Milikić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Milikić Milena' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milena-milikic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-milikic', 'Milena Milikić', 'Милена Миликић', 'Милена Миликич', 'Milena Milikic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Emina Ostojić — doktor stomatologije. Фото — заглушка.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Emina Ostojić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ostojić Emina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'emina-ostojic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'emina-ostojic', 'Emina Ostojić', 'Емина Остојић', 'Эмина Остоич', 'Emina Ostojic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Dejan Maraš — specijalista anesteziologije, reanimatologije i intenzivne terapije.
-- Фото — заглушка. Опечатка сайта «intezivne» исправлена. Однофамильцы в БД
-- (Perica, Predrag, Željko Maraš) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dejan Maraš' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Maraš Dejan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dejan-maras' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-maras', 'Dejan Maraš', 'Дејан Мараш', 'Деян Мараш', 'Dejan Maras', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 19);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista anesteziologije, reanimatologije i intenzivne terapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '2,7', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 11 врачей. Существующий (created_at старше сегодняшнего): milos-simonovic
-- (specialties 78,93). Остальные 10 — новые; NO PHOTO у 6 (заглушка на сайте),
-- bio — у Petar, Miljan, Gradimirka.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	IF(d.description_sr IS NULL, 'NO BIO', 'ok') AS bio,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;

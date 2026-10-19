-- ═══════════════════════════════════════════════════════════════════════════
-- Pedijatrijska ordinacija Vuleković — ogranak Sutomore — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-pedijatrijska-ordinacija-vulekovic-sutomore.sql
--
-- Источники (curl, 2026-10-08): https://vulekovic.me/kontakt/ («Kontakt Sutomore: Vuka Karadžića 2, 85355 Sutomore»),
-- главная («Tokom cijele godine brinemo … i u našoj ordinaciji u Sutomoru»), RU-пост 2025-01 «В Сутоморе открыта
-- новая специализированная амбулаторная клиника для детей и взрослых … во главе с доктором-педиатром Синишей Вулековичем».
--
-- Места в Google НЕТ (data/google-places — только Подгорица): google_place_id NULL, координаты: 42.140300, 19.044891 — по ссылке Google Maps от юзера 2026-10-08 (maps.app.goo.gl/x6Mdx7oon261zpzn9),
-- клиника ищется только по slug. Телефоны и email — общие с Подгорицей (сайт даёт те же).
-- Врачи: сайт не делит состав по ординациям → привязаны все, кроме явно «u Podgorici»
-- (Gordana Sušić, Sanja Vujanović) — правило координатора «если не разделяет — к обоим».
--
-- Идемпотентно и самоисправляюще (см. файл Подгорицы).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = NULL;
SET @clinic_slug = 'pedijatrijska-ordinacija-vulekovic-sutomore';

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
	7, -- CityId.BAR (Sutomore — opština Bar, как a3-medical-sutomore)
	'Pedijatrijska ordinacija Vuleković Sutomore',
	'Педијатријска ординација Вулековић (Сутоморе)',
	'Педиатрическая клиника Вулекович (Сутоморе)',
	'Vuka Karadžića 2',
	'Вука Караџића 2',
	'Sutomore',
	'Сутоморе',
	'85355',
	42.140300,
	19.044891,
	'+38220244244;+38269072242',
	'ordinacija@vulekovic.me',
	'https://vulekovic.me/',
	'facebook.com/drvulekovic',
	'',
	'',
	'',
	'',
	'https://vulekovic.me/wp-content/uploads/2025/01/vulekovic-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	latitude = IF(latitude IS NULL OR latitude = 0, 42.140300, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.044891, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Педијатријска ординација Вулековић (Сутоморе)', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Педиатрическая клиника Вулекович (Сутоморе)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vuka Karadžića 2', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Вука Караџића 2', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Sutomore', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Сутоморе', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85355', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220244244;+38269072242', phone),
	email = IF(email IS NULL OR email = '', 'ordinacija@vulekovic.me', email),
	website = IF(website IS NULL OR website = '', 'https://vulekovic.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/drvulekovic', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://vulekovic.me/wp-content/uploads/2025/01/vulekovic-logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Ogranak privatne pedijatrijske ordinacije „Vuleković“ iz Podgorice, u Sutomoru, u ulici Vuka Karadžića 2. Prema navodima ordinacije, ambulanta u Sutomoru prima djecu i odrasle, a tim predvodi pedijatar dr Siniša Vuleković, osnivač ordinacije koja u Podgorici radi od 2018. godine. Ordinacija navodi da o zdravlju pacijenata u Sutomoru brine tokom cijele godine; radno vrijeme ogranka je sezonsko, pa termin treba provjeriti telefonom.',
	description_sr_cyrl = 'Огранак приватне педијатријске ординације „Вулековић“ из Подгорице, у Сутомору, у улици Вука Караџића 2. Према наводима ординације, амбуланта у Сутомору прима дјецу и одрасле, а тим предводи педијатар др Синиша Вулековић, оснивач ординације која у Подгорици ради од 2018. године. Ординација наводи да о здрављу пацијената у Сутомору брине током цијеле године; радно вријеме огранка је сезонско, па термин треба провјерити телефоном.',
	description_ru = 'Филиал частной педиатрической клиники «Вулекович» из Подгорицы в Сутоморе, на улице Вука Караджича, 2. По данным клиники, амбулатория в Сутоморе принимает детей и взрослых; команду возглавляет педиатр доктор Синиша Вулекович, основатель клиники, которая работает в Подгорице с 2018 года. Клиника сообщает, что принимает пациентов в Сутоморе круглый год; график филиала сезонный, поэтому время приёма лучше уточнять по телефону.',
	description_en = 'The Sutomore branch of the private paediatric practice Vuleković from Podgorica, at Vuka Karadžića 2. According to the practice, the Sutomore clinic treats children and adults; the team is led by the paediatrician Dr Siniša Vuleković, founder of the practice, which has operated in Podgorica since 2018. The practice states that it cares for patients in Sutomore all year round; the branch''s opening hours are seasonal, so it is best to check by phone.',
	description_de = 'Zweigstelle der privaten Kinderarztpraxis Vuleković aus Podgorica in Sutomore, Vuka Karadžića 2. Nach Angaben der Praxis behandelt die Ambulanz in Sutomore Kinder und Erwachsene; das Team leitet der Kinderarzt Dr. Siniša Vuleković, Gründer der seit 2018 in Podgorica tätigen Praxis. Die Praxis gibt an, Patienten in Sutomore das ganze Jahr über zu betreuen; die Öffnungszeiten der Zweigstelle sind saisonal, daher empfiehlt sich eine telefonische Rückfrage.',
	description_tr = 'Podgorica''daki özel çocuk muayenehanesi Vuleković''in Sutomore şubesi, Vuka Karadžića 2 adresinde. Muayenehanenin belirttiğine göre Sutomore''deki ayakta tedavi birimi çocuk ve yetişkinlere hizmet verir; ekibin başında, 2018''den beri Podgorica''da faaliyet gösteren muayenehanenin kurucusu çocuk doktoru Dr. Siniša Vuleković bulunur. Muayenehane Sutomore''de yıl boyunca hasta kabul ettiğini belirtmektedir; şubenin çalışma saatleri mevsimseldir, bu nedenle telefonla teyit edilmesi önerilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.PEDIATRIC_CLINIC = 12
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 12);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт имеет /ru/ и /en/ версии, но приём на русском/английском прямо НЕ заявлен → только SR.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Рабочее время НЕ заполняем: RU-пост 2025-01 «с апреля по июль … в среду и субботу с 16 до 19» — сезонное и устаревшее.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (10)
-- Сайт не делит врачей по ординациям, кроме явных «u Podgorici» (Gordana Sušić, Sanja Vujanović) → они НЕ здесь.
-- Остальные 10 — те же карточки, что и в Подгорице (find-or-create, повторный прогон безопасен).
-- Специальности/языки — как в файле Подгорицы.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Siniša Vuleković — specijalista pedijatar, osnivač
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Siniša Vuleković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vuleković Siniša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sinisa-vulekovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sinisa-vulekovic', 'Siniša Vuleković', 'Синиша Вулековић', 'Синиша Вулекович', 'Sinisa Vulekovic', 'Dr',
	'https://vulekovic.me/wp-content/uploads/2025/01/sinisa.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista pedijatar, osnivač privatne pedijatrijske ordinacije „Vuleković“ (2018). Rođen je 1965. godine u Podgorici, gdje je završio gimnaziju. Medicinski fakultet u Sarajevu završio je 1991. godine, a specijalizaciju iz pedijatrije 1999. godine na Institutu za majku i dijete u Beogradu. Od 1991. do 2003. godine radio je u Domu zdravlja Podgorica, a zatim u PZU „Malbaški“ do marta 2018. godine, kada je otvorio svoju ordinaciju. Angažovan je i u sportskoj i porodičnoj medicini; 2007. godine završio je četvoromjesečni kurs iz porodične medicine. Autor je i koautor više stručnih radova.',
	description_sr_cyrl = 'Специјалиста педијатар, оснивач приватне педијатријске ординације „Вулековић“ (2018). Рођен је 1965. године у Подгорици, гдје је завршио гимназију. Медицински факултет у Сарајеву завршио је 1991. године, а специјализацију из педијатрије 1999. године на Институту за мајку и дијете у Београду. Од 1991. до 2003. године радио је у Дому здравља Подгорица, а затим у ПЗУ „Малбашки“ до марта 2018. године, када је отворио своју ординацију. Ангажован је и у спортској и породичној медицини; 2007. године завршио је четворомјесечни курс из породичне медицине. Аутор је и коаутор више стручних радова.',
	description_ru = 'Врач-педиатр, основатель частной педиатрической клиники «Вулекович» (2018). Родился в 1965 году в Подгорице, где окончил гимназию. В 1991 году окончил медицинский факультет в Сараеве, в 1999 году — специализацию по педиатрии в Институте матери и ребёнка в Белграде. С 1991 по 2003 год работал в Доме здоровья Подгорицы, затем до марта 2018 года — в частном учреждении «Malbaški», после чего открыл собственную клинику. Занимается также спортивной и семейной медициной; в 2007 году окончил четырёхмесячный курс по семейной медицине. Автор и соавтор ряда профессиональных работ.',
	description_en = 'Paediatrician and founder of the private paediatric practice Vuleković (2018). Born in 1965 in Podgorica, where he finished grammar school, he graduated from the Faculty of Medicine in Sarajevo in 1991 and completed his specialisation in paediatrics at the Institute for Mother and Child in Belgrade in 1999. He worked at the Podgorica Health Centre from 1991 to 2003 and then at the private facility Malbaški until March 2018, when he opened his own practice. He is also active in sports and family medicine and completed a four-month course in family medicine in 2007. He is the author and co-author of several professional papers.',
	description_de = 'Facharzt für Kinderheilkunde und Gründer der privaten Kinderarztpraxis Vuleković (2018). Geboren 1965 in Podgorica, wo er das Gymnasium besuchte, schloss er 1991 das Medizinstudium in Sarajevo ab und absolvierte 1999 die Facharztausbildung in Pädiatrie am Institut für Mutter und Kind in Belgrad. Von 1991 bis 2003 arbeitete er im Gesundheitszentrum Podgorica, danach bis März 2018 in der privaten Einrichtung Malbaški, bevor er seine eigene Praxis eröffnete. Er ist auch in der Sport- und Familienmedizin tätig und absolvierte 2007 einen viermonatigen Kurs in Familienmedizin. Er ist Autor und Mitautor mehrerer Fachartikel.',
	description_tr = 'Çocuk sağlığı ve hastalıkları uzmanı; özel çocuk muayenehanesi Vuleković''in kurucusu (2018). 1965''te Podgorica''da doğdu ve burada liseyi bitirdi. 1991''de Saraybosna Tıp Fakültesinden mezun oldu, 1999''da Belgrad Anne ve Çocuk Enstitüsünde pediatri uzmanlığını tamamladı. 1991–2003 yılları arasında Podgorica Sağlık Merkezinde, ardından Mart 2018''e kadar özel Malbaški kuruluşunda çalıştı ve sonra kendi muayenehanesini açtı. Spor hekimliği ve aile hekimliği alanlarında da çalışmakta olup 2007''de dört aylık aile hekimliği kursunu tamamladı. Çeşitli bilimsel çalışmaların yazarı ve ortak yazarıdır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatar, osnivač ordinacije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Đuro Latković — specijalista pedijatar
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: latkovic-djuro («Latković Đuro», прод id 92, PEDIATRICS; Danilo I Cetinje, Milmedika) —
-- имя и специальность совпадают. Фото у карточки есть, на сайте Vuleković портрета нет.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Đuro Latković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Latković Đuro' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'latkovic-djuro' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'latkovic-djuro', 'Đuro Latković', 'Ђуро Латковић', 'Джуро Латкович', 'Djuro Latkovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Ivan Ivanović — specijalista pedijatar
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: ivan-ivanovic (прод id 1120, PEDIATRICS; Danilo I Cetinje, ДЗ Cetinje) — имя и
-- специальность совпадают → тот же (правило юзера). Имя частое — см. openQuestions записи импорта.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivan Ivanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ivanović Ivan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivan-ivanovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-ivanovic', 'Ivan Ivanović', 'Иван Ивановић', 'Иван Иванович', 'Ivan Ivanovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Žanka Cerović — specijalista radiolog
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: zanka-cerovic (прод id 923, RADIOLOGY; КЦЦГ, Hipokrat).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Žanka Cerović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Cerović Žanka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zanka-cerovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zanka-cerovic', 'Žanka Cerović', 'Жанка Церовић', 'Жанка Церович', 'Zanka Cerovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Danijela Latković — specijalista radiolog
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: latkovic-danijela («Latković Danijela», прод id 20, RADIOLOGY; Milmedika, Danilo I).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Danijela Latković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Latković Danijela' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'latkovic-danijela' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'latkovic-danijela', 'Danijela Latković', 'Данијела Латковић', 'Даниела Латкович', 'Danijela Latkovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Maja Jovanović — specijalista ORL
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: jovanovic-maja («Jovanović Maja», прод id 54, ENT; Danilo I, Milmedika).
-- /o-nama/: «Od 17. maja 2018. u našoj ustanovi ordinira dr Maja Jovanović, specijalista ORL» → ORL pregled.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Maja Jovanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Jovanović Maja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jovanovic-maja' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jovanovic-maja', 'Maja Jovanović', 'Маја Јовановић', 'Майя Йованович', 'Maja Jovanovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 11);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ORL')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Vladimir Ljubić — specijalista ORL
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: vladimir-ljubic (прод id 245, ENT; КЦЦГ, Smartmed). На сайте опечатка «specijalista OR».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vladimir Ljubić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ljubić Vladimir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vladimir-ljubic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vladimir-ljubic', 'Vladimir Ljubić', 'Владимир Љубић', 'Владимир Любич', 'Vladimir Ljubic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 11);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ORL')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Lidija Poček — specijalista pedijatar, subspecijalista alergolog
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: pocek-lidija («Poček Lidija», прод id 105, PEDIATRICS + PEDIATRIC_ALLERGOLOGY).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Lidija Poček' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Poček Lidija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'pocek-lidija' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'pocek-lidija', 'Lidija Poček', 'Лидија Почек', 'Лидия Почек', 'Lidija Pocek', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4), (@doctor_id, 30);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatar, subspecijalista alergolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr sci. med. Snežana Barjaktarović Labović — specijalista higijene, subspecijalista dijetoterapije
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ (по slug): snezana-barjaktarovic-labovic («Barjaktarović-Labović», прод id 1180,
-- ДЗ Бар, «sub.spec. higijene», спец. 52 — так в БД заведены все гигиенисты). Тот же специалист по гигиене →
-- привязка; специальность не добавляем (в enum нет гигиены/диетологии).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Snežana Barjaktarović Labović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Barjaktarović Labović Snežana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'snezana-barjaktarovic-labovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-barjaktarovic-labovic', 'Snežana Barjaktarović Labović', 'Снежана Барјактаровић Лабовић', 'Снежана Барьяктарович Лабович', 'Snezana Barjaktarovic Labovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista higijene, subspecijalista dijetoterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Anita Marić — logoped
-- Логопед — не врач, но такие специалисты в БД заводятся как карточки со специальностью 70
-- (SPEECH_THERAPY, professional_title NULL: filip-rajcevic, nikolina-tisma-knezic и др.). Фото нет.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Anita Marić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Marić Anita' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'anita-maric' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'anita-maric', 'Anita Marić', 'Анита Марић', 'Анита Марич', 'Anita Maric', NULL,
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 70);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Logoped')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 7, town_sr = Sutomore, status = published, google_place_id NULL, clinic_languages = 1, clinic_types = 12, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 10 карточек (те же id, что в клинике Подгорицы, без Sušić и Vujanović).
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

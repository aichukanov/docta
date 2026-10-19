-- ═══════════════════════════════════════════════════════════════════════════
-- Pedijatrijska ordinacija Vuleković (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-pedijatrijska-ordinacija-vulekovic-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/pedijatrijska-ordinacija-vulekovic-podgorica.json):
--   * https://vulekovic.me/ — WordPress + Polylang, WP REST: pages (pocetna 2025-01-29, nasi-ljekari 2025-01-21,
--     o-nama 2025-01-21, kontakt 2025-01-24, ru/en-версии), posts (5).
--   * data/google-places/podgorica/privatna-ordinacija-vulekovic.json — place_id, координаты, телефон.
--
-- Сеть из двух ординаций (Podgorica + Sutomore) — у нас отдельными клиниками; Sutomore —
-- server/sql/insert-clinic-pedijatrijska-ordinacija-vulekovic-sutomore.sql.
-- Сверка: адрес «Svetozara Markovića 5, 81000 Podgorica» — сайт = Google («5 Svetozara Markovića»).
-- Телефоны: +382 20 244 244 (сайт + Google), +382 69 072 242 (сайт). Email ordinacija@vulekovic.me.
--
-- Идемпотентно и самоисправляюще: клиника по google_place_id → slug; врачи по name_sr / перевёрнутому
-- имени / slug. Пустые поля существующих записей дозаполняются. description_* клиники и новых врачей —
-- БЕЗУСЛОВНЫЙ UPDATE; био существующих — только если пусто.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJYWpwNDHrTRMRbH9EJu0L02c';
SET @clinic_slug = 'pedijatrijska-ordinacija-vulekovic-podgorica';

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
	'Pedijatrijska ordinacija Vuleković Podgorica',
	'Педијатријска ординација Вулековић (Подгорица)',
	'Педиатрическая клиника Вулекович (Подгорица)',
	'Svetozara Markovića 5',
	'Светозара Марковића 5',
	'',
	'',
	'81000',
	42.44340040,
	19.25162730,
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

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Педијатријска ординација Вулековић (Подгорица)', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Педиатрическая клиника Вулекович (Подгорица)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Svetozara Markovića 5', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Светозара Марковића 5', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220244244;+38269072242', phone),
	email = IF(email IS NULL OR email = '', 'ordinacija@vulekovic.me', email),
	website = IF(website IS NULL OR website = '', 'https://vulekovic.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/drvulekovic', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://vulekovic.me/wp-content/uploads/2025/01/vulekovic-logo.png', logo_url),
	latitude = COALESCE(latitude, 42.44340040),
	longitude = COALESCE(longitude, 19.25162730)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Privatna pedijatrijska ordinacija u Podgorici, u ulici Svetozara Markovića 5 (preko Morače), koja radi od marta 2018. godine; osnivač je pedijatar dr Siniša Vuleković. Ordinacija radi svakog dana u nedjelji, pregled nije potrebno zakazivati, a u ponudi su i kućne posjete novorođenčadi sa pregledom pedijatra, mjerenjem djeteta i savjetima o njezi. Pored opšte pedijatrije, u ordinaciji rade radiolozi (ultrazvuk) i konsultanti: dječji reumatolog, ORL specijalisti, alergolog, specijalista dijetoterapije, dermatovenerolog i logoped. Dermatovenerolog uklanja manje promjene na koži (do 1 cm) uređajem Hyfrecator 2000. Ordinacija ima i ogranak u Sutomoru.',
	description_sr_cyrl = 'Приватна педијатријска ординација у Подгорици, у улици Светозара Марковића 5 (преко Мораче), која ради од марта 2018. године; оснивач је педијатар др Синиша Вулековић. Ординација ради сваког дана у недјељи, преглед није потребно заказивати, а у понуди су и кућне посјете новорођенчади са прегледом педијатра, мјерењем дјетета и савјетима о њези. Поред опште педијатрије, у ординацији раде радиолози (ултразвук) и консултанти: дјечји реуматолог, ОРЛ специјалисти, алерголог, специјалиста дијетотерапије, дерматовенеролог и логопед. Дерматовенеролог уклања мање промјене на кожи (до 1 цм) уређајем Hyfrecator 2000. Ординација има и огранак у Сутомору.',
	description_ru = 'Частная педиатрическая клиника в Подгорице на улице Светозара Марковича, 5 (за Морачей), работает с марта 2018 года; основатель — педиатр доктор Синиша Вулекович. Клиника принимает каждый день недели, записываться на осмотр не нужно; также доступны визиты на дом к новорождённым — осмотр педиатра, измерения и советы по уходу. Помимо общей педиатрии, в клинике работают рентгенологи (УЗИ) и консультанты: детский ревматолог, ЛОР-врачи, аллерголог, специалист по диетотерапии, дерматовенеролог и логопед. Дерматовенеролог удаляет небольшие образования кожи (до 1 см) аппаратом Hyfrecator 2000. У клиники есть филиал в Сутоморе.',
	description_en = 'A private paediatric practice in Podgorica at Svetozara Markovića 5 (across the Morača), open since March 2018 and founded by the paediatrician Dr Siniša Vuleković. The practice is open every day of the week and no appointment is needed for an examination; home visits to newborns, with a paediatric examination, measurements and care advice, are also offered. Besides general paediatrics, the team includes radiologists (ultrasound) and consultants: a paediatric rheumatologist, ENT specialists, an allergist, a dietary therapy specialist, a dermatovenereologist and a speech therapist. The dermatovenereologist removes small skin lesions (up to 1 cm) with a Hyfrecator 2000 device. The practice also has a branch in Sutomore.',
	description_de = 'Private Kinderarztpraxis in Podgorica, Svetozara Markovića 5 (jenseits der Morača), seit März 2018 geöffnet; Gründer ist der Kinderarzt Dr. Siniša Vuleković. Die Praxis ist an jedem Wochentag geöffnet, eine Terminvereinbarung für die Untersuchung ist nicht nötig; angeboten werden auch Hausbesuche bei Neugeborenen mit kinderärztlicher Untersuchung, Messungen und Pflegeberatung. Neben der allgemeinen Pädiatrie arbeiten in der Praxis Radiologen (Ultraschall) und Konsiliarärzte: eine Kinderrheumatologin, HNO-Ärzte, eine Allergologin, eine Fachärztin für Diättherapie, eine Dermatovenerologin und eine Logopädin. Die Dermatovenerologin entfernt kleinere Hautveränderungen (bis 1 cm) mit dem Gerät Hyfrecator 2000. Die Praxis hat auch eine Zweigstelle in Sutomore.',
	description_tr = 'Podgorica''da Svetozara Markovića 5 adresinde (Morača''nın karşı yakasında) Mart 2018''den beri hizmet veren özel çocuk muayenehanesi; kurucusu çocuk doktoru Dr. Siniša Vuleković''tir. Muayenehane haftanın her günü açıktır, muayene için randevu gerekmez; yenidoğanlara çocuk doktoru muayenesi, ölçümler ve bakım önerilerini içeren ev ziyaretleri de sunulur. Genel pediatrinin yanı sıra muayenehanede radyologlar (ultrason) ve konsültanlar çalışır: çocuk romatoloğu, KBB uzmanları, alerji uzmanı, diyet tedavisi uzmanı, dermatovenerolog ve dil-konuşma terapisti. Dermatovenerolog küçük cilt lezyonlarını (1 cm''ye kadar) Hyfrecator 2000 cihazıyla alır. Muayenehanenin Sutomore''de de bir şubesi vardır.'
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

-- Рабочее время НЕ заполняем: на сайте только «Ljetnje radno vrijeme» (летнее, сезонное); круглогодичного нет.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (12)
-- Состав — /nasi-ljekari/ (11 врачей по разделам) + логопед Anita Marić. Все — к Подгорице.
-- Специальности: 4 = PEDIATRICS, 10 = RADIOLOGY, 16 = RHEUMATOLOGY, 11 = OTORHINOLARYNGOLOGY,
-- 30 = PEDIATRIC_ALLERGOLOGY, 7 = DERMATOVENEROLOGY, 70 = SPEECH_THERAPY. Языки: 1 = SR.
-- Найдены в БД (9): latkovic-djuro, ivan-ivanovic, zanka-cerovic, latkovic-danijela, jovanovic-maja, vladimir-ljubic,
-- pocek-lidija, snezana-barjaktarovic-labovic, sanja-vujanovic. Новые (3): sinisa-vulekovic, gordana-susic, anita-maric.
-- Фото с сайта есть только у Siniša Vuleković и Gordana Sušić (/o-nama/).
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
-- Prim. dr sci. med. Gordana Sušić — pedijatar-reumatolog (только Подгорица: «U našoj ordinaciji u Podgorici»)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Gordana Sušić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Sušić Gordana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'gordana-susic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'gordana-susic', 'Gordana Sušić', 'Гордана Сушић', 'Гордана Сушич', 'Gordana Susic', 'Prim. dr sci. med.',
	'https://vulekovic.me/wp-content/uploads/2025/01/gsusic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Pedijatar-reumatolog, primarijus i doktor medicinskih nauka, naučni saradnik Instituta za reumatologiju u Beogradu. Na Medicinskom fakultetu Univerziteta u Beogradu specijalizirala je pedijatriju 1991. godine, a užu specijalizaciju iz reumatologije završila 1998. godine; magistrirala je 2006, a doktorirala 2011. godine. Objavila je preko 150 radova iz oblasti dječije reumatologije. Konsultant je Univerzitetske dječije klinike u Tiršovoj i Specijalne bolnice za rehabilitaciju Banja Koviljača. U ordinaciji „Vuleković“ dijagnostikuje i liječi djecu i adolescente sa juvenilnim idiopatskim artritisom i drugim oblicima artritisa, sistemskim bolestima vezivnog tkiva i drugim autoimunim bolestima, bolovima u koštano-zglobnom sistemu i problemima vezanim za rast.',
	description_sr_cyrl = 'Педијатар-реуматолог, примаријус и доктор медицинских наука, научни сарадник Института за реуматологију у Београду. На Медицинском факултету Универзитета у Београду специјализирала је педијатрију 1991. године, а ужу специјализацију из реуматологије завршила 1998. године; магистрирала је 2006, а докторирала 2011. године. Објавила је преко 150 радова из области дјечије реуматологије. Консултант је Универзитетске дјечије клинике у Тиршовој и Специјалне болнице за рехабилитацију Бања Ковиљача. У ординацији „Вулековић“ дијагностикује и лијечи дјецу и адолесценте са јувенилним идиопатским артритисом и другим облицима артритиса, системским болестима везивног ткива и другим аутоимуним болестима, боловима у коштано-зглобном систему и проблемима везаним за раст.',
	description_ru = 'Детский ревматолог, примариус и доктор медицинских наук, научный сотрудник Института ревматологии в Белграде. На медицинском факультете Белградского университета в 1991 году получила специализацию по педиатрии, в 1998 году — узкую специализацию по ревматологии; в 2006 году защитила магистерскую, в 2011 году — докторскую диссертацию. Опубликовала более 150 работ по детской ревматологии. Консультант Университетской детской клиники на Тиршовой и Специальной больницы реабилитации Баня-Ковиляча. В клинике «Вулекович» занимается диагностикой и лечением детей и подростков с ювенильным идиопатическим артритом и другими артритами, системными заболеваниями соединительной ткани и другими аутоиммунными болезнями, болями в костях и суставах, нарушениями роста.',
	description_en = 'Paediatric rheumatologist, primarius and doctor of medical sciences, research associate at the Institute of Rheumatology in Belgrade. At the Faculty of Medicine of the University of Belgrade she specialised in paediatrics in 1991 and completed her subspecialisation in rheumatology in 1998; she obtained her master''s degree in 2006 and her doctorate in 2011. She has published more than 150 papers in paediatric rheumatology and is a consultant at the University Children''s Clinic in Tiršova Street and the Banja Koviljača Special Rehabilitation Hospital. At the Vuleković practice she diagnoses and treats children and adolescents with juvenile idiopathic arthritis and other forms of arthritis, systemic connective tissue and other autoimmune diseases, musculoskeletal pain and growth problems.',
	description_de = 'Kinderrheumatologin, Primaria und Doktorin der Medizin, wissenschaftliche Mitarbeiterin des Instituts für Rheumatologie in Belgrad. An der Medizinischen Fakultät der Universität Belgrad erwarb sie 1991 die Facharztanerkennung für Pädiatrie und 1998 die Subspezialisierung in Rheumatologie; 2006 folgte der Magister-, 2011 der Doktortitel. Sie hat über 150 Arbeiten zur Kinderrheumatologie veröffentlicht und ist Konsiliarärztin der Universitätskinderklinik in der Tiršova-Straße sowie der Spezialklinik für Rehabilitation Banja Koviljača. In der Praxis Vuleković diagnostiziert und behandelt sie Kinder und Jugendliche mit juveniler idiopathischer Arthritis und anderen Arthritisformen, systemischen Bindegewebs- und anderen Autoimmunerkrankungen, Schmerzen des Bewegungsapparats sowie Wachstumsstörungen.',
	description_tr = 'Çocuk romatoloğu, primarius ve tıp bilimleri doktoru; Belgrad Romatoloji Enstitüsünde araştırmacı. Belgrad Üniversitesi Tıp Fakültesinde 1991''de pediatri uzmanlığını, 1998''de romatoloji yan dal uzmanlığını tamamladı; 2006''da yüksek lisans, 2011''de doktora derecesi aldı. Çocuk romatolojisi alanında 150''den fazla çalışma yayımlamıştır; Tiršova Caddesi''ndeki Üniversite Çocuk Kliniği ile Banja Koviljača Özel Rehabilitasyon Hastanesinin konsültanıdır. Vuleković muayenehanesinde jüvenil idiyopatik artrit ve diğer artrit türleri, sistemik bağ dokusu hastalıkları ve diğer otoimmün hastalıklar, kas-iskelet ağrıları ve büyüme sorunları olan çocuk ve ergenlerin tanı ve tedavisini yapmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4), (@doctor_id, 16);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Pedijatar – reumatolog')
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
-- Dr Sanja Vujanović — specijalista dermatovenerolog (только Подгорица: «U našoj ordinaciji u Podgorici ordinira»)
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: sanja-vujanovic (прод id 1128, DERMATOVENEROLOGY; Danilo I Cetinje, MOA).
-- Био сайта пишется только если у карточки био пусто (сейчас пусто).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sanja Vujanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vujanović Sanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sanja-vujanovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-vujanovic', 'Sanja Vujanović', 'Сања Вујановић', 'Саня Вуянович', 'Sanja Vujanovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: био пишется, только если его ещё нет.
UPDATE doctors SET
	description_sr = 'Specijalista dermatovenerologije. Specijalizaciju je završila na Klinici za dermatovenerologiju Vojnomedicinske akademije 2017. godine, uz sticanje vještina iz dermatoskopije. Radno iskustvo sticala je kao izabrani doktor za odrasle u Domu zdravlja Podgorica, a nakon specijalizacije radila je kao dermatovenerolog u Opštoj bolnici „Danilo I“ na Cetinju. Aktivno učestvuje na dermatološkim sekcijama u organizaciji VMA i na domaćim i međunarodnim kongresima; član je Udruženja dermatovenerologa Crne Gore. U ordinaciji „Vuleković“ u Podgorici obavlja preglede i konsultacije, kao i uklanjanje manjih promjena na koži uređajem Hyfrecator 2000.',
	description_sr_cyrl = 'Специјалиста дерматовенерологије. Специјализацију је завршила на Клиници за дерматовенерологију Војномедицинске академије 2017. године, уз стицање вјештина из дерматоскопије. Радно искуство стицала је као изабрани доктор за одрасле у Дому здравља Подгорица, а након специјализације радила је као дерматовенеролог у Општој болници „Данило I“ на Цетињу. Активно учествује на дерматолошким секцијама у организацији ВМА и на домаћим и међународним конгресима; члан је Удружења дерматовенеролога Црне Горе. У ординацији „Вулековић“ у Подгорици обавља прегледе и консултације, као и уклањање мањих промјена на кожи уређајем Hyfrecator 2000.',
	description_ru = 'Врач-дерматовенеролог. Специализацию окончила в 2017 году в Клинике дерматовенерологии Военно-медицинской академии (VMA), освоив дерматоскопию. Работала участковым врачом для взрослых в Доме здоровья Подгорицы, после специализации — дерматовенерологом в общей больнице «Данило I» в Цетине. Активно участвует в дерматологических секциях VMA, отечественных и международных конгрессах; член Ассоциации дерматовенерологов Черногории. В клинике «Вулекович» в Подгорице проводит осмотры и консультации, а также удаление небольших образований кожи аппаратом Hyfrecator 2000.',
	description_en = 'Dermatovenereologist. She completed her specialisation at the Clinic of Dermatovenereology of the Military Medical Academy (VMA) in 2017, including training in dermatoscopy. She worked as a primary care physician for adults at the Podgorica Health Centre and, after specialising, as a dermatovenereologist at the Danilo I General Hospital in Cetinje. She takes an active part in dermatology sections organised by the VMA and in national and international congresses, and is a member of the Association of Dermatovenereologists of Montenegro. At the Vuleković practice in Podgorica she provides examinations and consultations and removes small skin lesions with the Hyfrecator 2000 device.',
	description_de = 'Fachärztin für Dermatovenerologie. Ihre Facharztausbildung schloss sie 2017 an der Klinik für Dermatovenerologie der Militärmedizinischen Akademie (VMA) ab und erwarb dabei Kenntnisse in der Dermatoskopie. Sie arbeitete als Hausärztin für Erwachsene im Gesundheitszentrum Podgorica und nach der Facharztausbildung als Dermatovenerologin im Allgemeinen Krankenhaus „Danilo I“ in Cetinje. Sie nimmt aktiv an dermatologischen Sektionen der VMA sowie an nationalen und internationalen Kongressen teil und ist Mitglied der Vereinigung der Dermatovenerologen Montenegros. In der Praxis Vuleković in Podgorica führt sie Untersuchungen und Beratungen durch und entfernt kleinere Hautveränderungen mit dem Gerät Hyfrecator 2000.',
	description_tr = 'Dermatoveneroloji uzmanı. Uzmanlığını 2017''de Askeri Tıp Akademisi (VMA) Dermatoveneroloji Kliniğinde dermatoskopi becerileri kazanarak tamamladı. Podgorica Sağlık Merkezinde yetişkinler için aile hekimi olarak, uzmanlığın ardından Cetinje''deki Danilo I Genel Hastanesinde dermatovenerolog olarak çalıştı. VMA''nın düzenlediği dermatoloji oturumlarına ve ulusal ve uluslararası kongrelere aktif olarak katılmakta olup Karadağ Dermatovenerologlar Derneği üyesidir. Vuleković muayenehanesinin Podgorica şubesinde muayene ve konsültasyonların yanı sıra Hyfrecator 2000 cihazıyla küçük cilt lezyonlarını almaktadır.'
WHERE id = @doctor_id AND (description_sr IS NULL OR description_sr = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatovenerologije')
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

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 12, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 12 карточек: 9 существующих (created_at старше сегодня) + 3 новых.
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

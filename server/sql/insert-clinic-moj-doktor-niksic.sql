-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Moj Doktor (Nikšić) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-moj-doktor-niksic.sql
--
-- Источники (curl -k, 2026-10-08; запись импорта — data/clinic-imports/moj-doktor-niksic.json):
--   * https://mojdoktor.co.me/ — WP REST /wp-json/wp/v2/pages (8 страниц: home 2023-05-19,
--     onama / pedijatar / kucne-posjete-doktora / ljekarska-uvjerenja / laboratorijske-analize
--     2023-03-15, usluge 2021-07-17, kontakt 2020-05-23). TLS-сертификат сайта не проходит
--     проверку — curl только с -k.
--   * data/google-places/niksic/moj-doktor.json — place_id, координаты 42.7786885 / 18.9434218,
--     телефон +382 68 339 999 (3 отзыва — не импортируются).
--
-- Сверка: адрес «Ulica Nika Miljanića 1 (preko puta bolnice), Nikšić» (сайт /kontakt/). Google
-- даёт «Drvoimpex, Nikšić 81400» — название соседнего объекта, а не адрес; взят адрес сайта.
-- Телефоны: 068 33 99 99 (сайт + Google), 040 280 447 (сайт). Отдельные номера направлений
-- (педиатр +38268028999, кардиолог 068 07 99 99, лаборатория 068 04 82 05, психолог
-- 069 00 77 88) в карточку клиники не вынесены — см. запись импорта.
-- Часы работы на сайте не указаны → clinic_working_hours не заполняется.
-- Соцсети: в футере только демо-ссылка темы (facebook.com/pages/Themefusion/…) — не клиники.
--
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug, врачи
-- по name_sr / перевёрнутому имени / slug; пустые поля существующей записи
-- дозаполняются, непустые не трогаются (status тоже). description_* клиники пишется
-- БЕЗУСЛОВНЫМ UPDATE — правки описания вносить сюда. Языки клиники синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJbaoQbACpTRMRFwDCc29-_GY';
SET @clinic_slug = 'moj-doktor-niksic';

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
	2, -- CityId.NIKSIC
	'Moj Doktor',
	'Мој Доктор',
	'Клиника Moj Doktor',
	'Nika Miljanića 1',
	'Ника Миљанића 1',
	'',
	'',
	'81400',
	42.77868850,
	18.94342180,
	'+38268339999;+38240280447',
	'mojdoktorniksic@yahoo.com',
	'https://mojdoktor.co.me/',
	'',
	'',
	'',
	'',
	'',
	'https://mojdoktor.co.me/wp-content/uploads/2020/05/mojdoktorlogo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Мој Доктор', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Клиника Moj Doktor', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Nika Miljanića 1', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Ника Миљанића 1', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81400', postal_code),
	latitude = COALESCE(latitude, 42.77868850),
	longitude = COALESCE(longitude, 18.94342180),
	phone = IF(phone IS NULL OR phone = '', '+38268339999;+38240280447', phone),
	email = IF(email IS NULL OR email = '', 'mojdoktorniksic@yahoo.com', email),
	website = IF(website IS NULL OR website = '', 'https://mojdoktor.co.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://mojdoktor.co.me/wp-content/uploads/2020/05/mojdoktorlogo.png', logo_url)
WHERE id = @clinic_id;

-- Описание — безусловно (см. шапку). Только то, что клиника пишет о себе; «oprema vrhunske
-- tehnologije» и «najpovoljnije cijene» не перенесены.
UPDATE clinics SET
	description_sr = 'Privatna zdravstvena ustanova u Nikšiću, u ulici Nika Miljanića 1, preko puta bolnice. Pruža usluge iz oblasti medicine rada (izdavanje svih vrsta ljekarskih uvjerenja — za vozače, radnu sposobnost, oružje, sportiste i druge namjene) i sportske medicine. U ponudi su i laboratorijske analize, audiometrija, spirometrija, EKG, ultrazvuk srca, Holter i internističko-kardiološki pregledi, ultrazvučna dijagnostika, opisivanje RTG i CT snimaka, pregled psihologa i psihološko savjetovanje, pedijatrijski pregledi sa ultrazvukom kukova kod beba i specijalistička ambulanta za pravilnu ishranu. Organizuju se i kućne posjete ljekara: pregledi i kontrole, EKG, uzimanje uzoraka za laboratorijske analize, davanje terapije, previjanje rana, zamjena urinarnog katetera i dolazak patronažne sestre.',
	description_sr_cyrl = 'Приватна здравствена установа у Никшићу, у улици Ника Миљанића 1, преко пута болнице. Пружа услуге из области медицине рада (издавање свих врста љекарских увјерења — за возаче, радну способност, оружје, спортисте и друге намјене) и спортске медицине. У понуди су и лабораторијске анализе, аудиометрија, спирометрија, ЕКГ, ултразвук срца, Холтер и интернистичко-кардиолошки прегледи, ултразвучна дијагностика, описивање РТГ и CT снимака, преглед психолога и психолошко савјетовање, педијатријски прегледи са ултразвуком кукова код беба и специјалистичка амбуланта за правилну исхрану. Организују се и кућне посјете љекара: прегледи и контроле, ЕКГ, узимање узорака за лабораторијске анализе, давање терапије, превијање рана, замјена уринарног катетера и долазак патронажне сестре.',
	description_ru = 'Частное медицинское учреждение в Никшиче, на улице Ника Милянича, 1, напротив больницы. Работает в области медицины труда (оформление всех видов медицинских справок — для водителей, о трудоспособности, на оружие, для спортсменов и других целей) и спортивной медицины. Также выполняет лабораторные анализы, аудиометрию, спирометрию, ЭКГ, УЗИ сердца, холтер и осмотры терапевта-кардиолога, ультразвуковую диагностику, описание рентгеновских и КТ-снимков, консультации психолога, педиатрические осмотры с УЗИ тазобедренных суставов у младенцев; есть специализированный кабинет правильного питания. Врачи выезжают на дом: осмотры и контрольные визиты, ЭКГ, забор анализов, введение лекарств, перевязки, замена мочевого катетера, визит патронажной медсестры.',
	description_en = 'A private healthcare facility in Nikšić, at Nika Miljanića 1, opposite the hospital. It provides occupational medicine (issuing all types of medical certificates — for drivers, fitness for work, firearms, athletes and other purposes) and sports medicine. Services also include laboratory tests, audiometry, spirometry, ECG, heart ultrasound, Holter monitoring and internist-cardiologist examinations, ultrasound diagnostics, reporting of X-ray and CT scans, psychologist consultations and counselling, paediatric examinations with hip ultrasound for babies, and a specialist clinic for healthy nutrition. Doctors also make home visits: examinations and follow-ups, ECG, collection of samples for laboratory tests, administration of therapy, wound dressing, urinary catheter replacement and visits by a community nurse.',
	description_de = 'Private Gesundheitseinrichtung in Nikšić, Nika Miljanića 1, gegenüber dem Krankenhaus. Sie bietet Arbeitsmedizin (Ausstellung aller Arten ärztlicher Atteste — für Fahrer, Arbeitsfähigkeit, Waffenbesitz, Sportler und andere Zwecke) und Sportmedizin. Zum Angebot gehören außerdem Laboranalysen, Audiometrie, Spirometrie, EKG, Herzultraschall, Holter und internistisch-kardiologische Untersuchungen, Ultraschalldiagnostik, Befundung von Röntgen- und CT-Aufnahmen, psychologische Untersuchung und Beratung, kinderärztliche Untersuchungen mit Hüftultraschall bei Säuglingen sowie eine Fachambulanz für gesunde Ernährung. Ärzte kommen auch zu Hausbesuchen: Untersuchungen und Kontrollen, EKG, Probenentnahme für Laboranalysen, Verabreichung von Therapien, Wundverbände, Wechsel des Blasenkatheters und Besuche einer Gemeindepflegekraft.',
	description_tr = 'Nikšić''te, hastanenin karşısında, Nika Miljanića 1 adresinde bulunan özel sağlık kuruluşu. İş hekimliği (sürücüler, çalışma yeterliliği, ruhsatlı silah, sporcular ve diğer amaçlar için her türlü sağlık raporunun düzenlenmesi) ve spor hekimliği hizmetleri verir. Ayrıca laboratuvar tahlilleri, odyometri, spirometri, EKG, kalp ultrasonu, Holter ve dahiliye-kardiyoloji muayeneleri, ultrason tanısı, röntgen ve BT görüntülerinin raporlanması, psikolog muayenesi ve danışmanlığı, bebeklerde kalça ultrasonu ile çocuk muayeneleri ve sağlıklı beslenme uzman polikliniği bulunur. Doktorlar ev ziyaretleri de yapar: muayene ve kontroller, EKG, laboratuvar için numune alma, tedavi uygulama, yara pansumanı, idrar sondası değişimi ve toplum sağlığı hemşiresi ziyareti.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет
-- приём на других языках → только SR (LanguageId.SR = 1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Рабочее время НЕ заполняется: на сайте его нет.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (8 из 9; источники — /onama/, главная, /pedijatar/, /kucne-posjete-doktora/)
-- Специальности: 9 = UROLOGY, 50 = OCCUPATIONAL_MEDICINE, 11 = OTORHINOLARYNGOLOGY,
--                4 = PEDIATRICS, 45 = GENERAL_MEDICINE, 10 = RADIOLOGY,
--                2 = INTERNAL_MEDICINE, 1 = CARDIOLOGY.
-- Язык 1 = SR. Фото врачей на сайте нет ни одного → photo_url не трогаем.
-- Найдутся существующие (локаль): Mrkić Zoran 64, Pejaković Mišo 68, Perović Dejan 70,
-- Branka Šupić 1417, Srđan Perazić 2956 — все уже с этой специальностью, у всех место
-- работы в Никшиче (Milmedika Nikšić / Opšta bolnica Nikšić), у Perazića — Podgorica.
-- НЕ заводятся: Monika Sekulović («Psiholog», не врач); Prim. dr Ljiljana Žižić — см. блок
-- в конце PART 3 (нет подходящей специальности).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Zoran Mrkić — spec. urologije (найдётся: «Mrkić Zoran», id 64)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Zoran Mrkić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mrkić Zoran' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zoran-mrkic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mrkic-zoran' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-mrkic', 'Zoran Mrkić', 'Зоран Мркић', 'Зоран Мркич', 'Zoran Mrkic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista urologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Boško Kontić — spec. medicine rada (новый)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Boško Kontić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kontić Boško' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'bosko-kontic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bosko-kontic', 'Boško Kontić', 'Бошко Контић', 'Бошко Контич', 'Bosko Kontic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 50);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista medicine rada')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Mišo Pejaković — spec. otorinolaringolog (ORL) (найдётся: «Pejaković Mišo», id 68)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mišo Pejaković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Pejaković Mišo' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'miso-pejakovic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'pejakovic-miso' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'miso-pejakovic', 'Mišo Pejaković', 'Мишо Пејаковић', 'Мишо Пеякович', 'Miso Pejakovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 11);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista otorinolaringologije (ORL)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Senka Dumović Kontić — specijalista pedijatar (новая)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Senka Dumović Kontić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Dumović Kontić Senka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'senka-dumovic-kontic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'senka-dumovic-kontic', 'Senka Dumović Kontić', 'Сенка Думовић Контић', 'Сенка Думович Контич', 'Senka Dumovic Kontic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Branka Šupić — specijalista pedijatar (найдётся: id 1417, Opšta bolnica Nikšić)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Branka Šupić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Šupić Branka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'branka-supic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'branka-supic', 'Branka Šupić', 'Бранка Шупић', 'Бранка Шупич', 'Branka Supic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Ljiljana Adžić — specijalista opšte medicine (кućne posjete)
-- Параллельно её заводит агент F (ДЗ Никшич, «ID odrasli»): find-or-create, slug строго
-- 'ljiljana-adzic'. На локали на 2026-10-08 её нет (есть только Milena Adžić, id 1,
-- и Antoaneta Adžić Zečević — другие люди) → создастся тем файлом, что применят первым.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'ljiljana-adzic' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ljiljana Adžić' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Adžić Ljiljana' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-adzic', 'Ljiljana Adžić', 'Љиљана Аџић', 'Лиляна Аджич', 'Ljiljana Adzic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 45);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista opšte medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Dejan Perović — specijalista radiolog (найдётся: «Perović Dejan», id 70, Milmedika Nikšić)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dejan Perović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Perović Dejan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dejan-perovic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'perovic-dejan' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-perovic', 'Dejan Perović', 'Дејан Перовић', 'Деян Перович', 'Dejan Perovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Srđan Perazić — internista kardiolog (на сайте «Srdjan»; найдётся: id 2956,
-- slug srdjan-perazic, CARDIOLOGY + INTERNAL_MEDICINE, Novi Cenex Medical и ДЗ Podgorica).
-- Тёзка с той же специальностью — единственный кандидат, привязка по правилу.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Srđan Perazić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Perazić Srđan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'srdjan-perazic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-perazic', 'Srđan Perazić', 'Срђан Перазић', 'Срджан Перазич', 'Srdjan Perazic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Internista kardiolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Prim. dr Ljiljana Žižić — «specijalista za pravilnu ishranu» — НЕ ЗАВОДИТСЯ.
-- В enums/specialty.ts нет ни диетологии/нутрициологии, ни гигиены питания, а новые
-- специальности в этой волне не создаются (правило 8). Готовый блок ниже — раскомментировать
-- после решения юзера, подставив specialty_id (см. openQuestions записи импорта).
-- В БД есть Jelena Žižić (id 386) и Nebojša Žižić (id 793) — другие люди.
-- ───────────────────────────────────────────────────────────────
-- SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ljiljana Žižić' LIMIT 1);
-- SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Žižić Ljiljana' LIMIT 1));
-- SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ljiljana-zizic' LIMIT 1));
-- INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
-- SELECT 'ljiljana-zizic', 'Ljiljana Žižić', 'Љиљана Жижић', 'Лиляна Жижич', 'Ljiljana Zizic', 'Prim. dr', NULL, NOW()
-- FROM dual WHERE @doctor_id IS NULL;
-- SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
-- INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, <SPECIALTY_ID>);
-- INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
-- INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista za pravilnu ishranu')
-- ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 2, status = published, clinic_languages = '1', clinic_types = '1', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 8 врачей. Существующие (created_at старше сегодняшнего): mrkic-zoran,
-- pejakovic-miso, perovic-dejan, branka-supic, srdjan-perazic; ljiljana-adzic — существующая,
-- если раньше применён импорт ДЗ Никшич (агент F). Новые: bosko-kontic, senka-dumovic-kontic.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id) AS languages,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;

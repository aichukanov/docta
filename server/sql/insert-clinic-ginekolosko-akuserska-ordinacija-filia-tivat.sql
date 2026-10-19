-- ═══════════════════════════════════════════════════════════════════════════
-- Ginekološko akušerska ordinacija «Filia» (Tivat) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ginekolosko-akuserska-ordinacija-filia-tivat.sql
-- Затем: server/sql/insert-clinic-ginekolosko-akuserska-ordinacija-filia-tivat-services.sql
-- Запись импорта: data/clinic-imports/ginekolosko-akuserska-ordinacija-filia-tivat.json. Подволна 2d, агент V.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://filia.co.me/ — WordPress/Elementor на теме xcare (pbminfotech). wp-json pages: «Filia Tivat» (главная) modified 2024-09-12,
--     «O nama» 2024-05-24, «Kontakt» 2024-05-15, «Zakaži termin» 2024-05-15; остальные страницы — демо темы (Homepage 02–05, Grid …, Our Team Member).
--     Перечень услуг — табы на главной (Ginekološke usluge / Ginekološke intervencije / Trudnoća). /service/* — справочные тексты
--     (часть явно скопирована с чужого сайта: «u GinekoMedici posvećujemo …»), услуги из них — только «Oblasti koje nudimo». Цен нет.
--   * data/google-places/tivat/ginekolosko-akuserska-ordinacija-filia.json — place_id, координаты 42.4438029 / 18.6969683,
--     +382 66 141 001, «22 Tomičići, Tivat 85320» (Google не перезапрашивался).
-- 
-- Email: на /kontakt два адреса («Mail 24/7»: ordinacijafilia@gmail.com, info@filia.co.me) — оба. Facebook — share-ссылка с сайта (не читался).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJnx6daAAxTBMRv3yePloZC4c';
SET @clinic_slug = 'ginekolosko-akuserska-ordinacija-filia-tivat';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Ginekološko akušerska ordinacija "Filia"', 'Ginekološko akušerska ordinacija Filia', 'Filia', 'Filia Tivat') AND city_id = 4 LIMIT 1));

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
	'Ginekološko akušerska ordinacija Filia',
	'Гинеколошко акушерска ординација Filia',
	'Гинекологическо-акушерский кабинет Filia',
	'Tomičići 22',
	'Томичићи 22',
	'',
	'',
	'85320',
	42.44380290,
	18.69696830,
	'+38266141001',
	'ordinacijafilia@gmail.com;info@filia.co.me',
	'https://filia.co.me/',
	'facebook.com/share/1pxBoJPHxRq7R1we',
	'@ginekoloska_ordinacija_filia',
	'',
	'',
	'',
	'https://filia.co.me/wp-content/uploads/2024/05/FILIA-LOGO-200.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.44380290, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.69696830, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Гинеколошко акушерска ординација Filia', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Гинекологическо-акушерский кабинет Filia', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Tomičići 22', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Томичићи 22', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85320', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38266141001', phone),
	email = IF(email IS NULL OR email = '', 'ordinacijafilia@gmail.com;info@filia.co.me', email),
	website = IF(website IS NULL OR website = '', 'https://filia.co.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/share/1pxBoJPHxRq7R1we', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@ginekoloska_ordinacija_filia', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://filia.co.me/wp-content/uploads/2024/05/FILIA-LOGO-200.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Ginekološko akušerska ordinacija Filia je savremena privatna ordinacija u Tivtu (Tomičići 22), namijenjena zdravstvenim potrebama moderne žene; sa radom je počela 2024. godine. Organizovana je kao dijagnostičko-terapijska ordinacija koja većinu postupaka i liječenja obavlja ambulantno, a rezultati ispitivanja su gotovi u kratkom vremenskom periodu. Ordiniraju ginekolozi dr Julija Samardžić i dr Božidar Petričević; ordinacija ima i konsultante iz oblasti endokrinologije i mikrobiologije. Usluge: ginekološki i kolposkopski pregled, PAPA test, ultrazvuk male karlice i kolor dopler, sistematski ginekološki pregled (ginekološki pregled, kolposkopija, PAPA, vaginalni sekret, ultrazvuk male karlice); ispitivanje i liječenje steriliteta (spermogram, spermokultura, hormonska ispitivanja supružnika, folikulometrija), poremećaja menstrualnog ciklusa i tegoba menopauze (hormonska supstituciona terapija); kontracepcija; laboratorijske analize — nivo hormona, dijagnostika cervikalnih infekcija (Chlamydia, Mycoplasma, Ureaplasma, bakterijska vaginoza), HPV tipizacija PCR metodom; intervencije — incizija Bartolinijeve žlijezde, vađenje spirale, aplikacija pesara; dijagnostika i vođenje trudnoće, ultrazvuk u trudnoći, ultrazvučni skrining fetalnih anomalija, Double, Triple i Quadruple test i NIPT test. Nedjeljom ordinacija radi samo kada je hitan slučaj.',
	description_sr_cyrl = 'Гинеколошко акушерска ординација Filia је савремена приватна ординација у Тивту (Томичићи 22), намијењена здравственим потребама модерне жене; са радом је почела 2024. године. Организована је као дијагностичко-терапијска ординација која већину поступака и лијечења обавља амбулантно, а резултати испитивања су готови у кратком временском периоду. Ординирају гинеколози др Јулија Самарџић и др Божидар Петричевић; ординација има и консултанте из области ендокринологије и микробиологије. Услуге: гинеколошки и колпоскопски преглед, PAPA тест, ултразвук мале карлице и колор доплер, систематски гинеколошки преглед (гинеколошки преглед, колпоскопија, PAPA, вагинални секрет, ултразвук мале карлице); испитивање и лијечење стерилитета (спермограм, спермокултура, хормонска испитивања супружника, фоликулометрија), поремећаја менструалног циклуса и тегоба менопаузе (хормонска супституциона терапија); контрацепција; лабораторијске анализе — ниво хормона, дијагностика цервикалних инфекција (Chlamydia, Mycoplasma, Ureaplasma, бактеријска вагиноза), HPV типизација PCR методом; интервенције — инцизија Бартолинијеве жлијезде, вађење спирале, апликација песара; дијагностика и вођење трудноће, ултразвук у трудноћи, ултразвучни скрининг феталних аномалија, Double, Triple и Quadruple тест и NIPT тест. Недјељом ординација ради само када је хитан случај.',
	description_ru = 'Гинекологическо-акушерский кабинет Filia — современный частный кабинет в Тивате (Tomičići 22), созданный для потребностей современной женщины; работает с 2024 года. Кабинет устроен как диагностико-лечебный: большинство процедур и лечения проводится амбулаторно, результаты обследований готовы в короткий срок. Принимают гинекологи д-р Юлия Самарджич и д-р Божидар Петричевич; у кабинета есть консультанты по эндокринологии и микробиологии. Услуги: гинекологический и кольпоскопический осмотр, ПАП-тест, УЗИ малого таза и цветовой допплер, комплексный гинекологический осмотр (осмотр, кольпоскопия, ПАП-тест, мазок на чистоту, УЗИ малого таза); обследование и лечение бесплодия (спермограмма, посев спермы, гормональное обследование супругов, фолликулометрия), нарушений менструального цикла и симптомов менопаузы (заместительная гормональная терапия); контрацепция; лабораторные анализы — уровень гормонов, диагностика цервикальных инфекций (Chlamydia, Mycoplasma, Ureaplasma, бактериальный вагиноз), типирование ВПЧ методом ПЦР; процедуры — вскрытие бартолиновой железы, удаление спирали, установка пессария; диагностика и ведение беременности, УЗИ при беременности, УЗИ-скрининг пороков развития плода, двойной, тройной и четверной тест и NIPT. По воскресеньям кабинет принимает только в экстренных случаях.',
	description_en = 'Filia is a modern private gynaecology and obstetrics practice in Tivat (Tomičići 22), designed for the health needs of the modern woman; it opened in 2024. It works as a diagnostic and treatment practice where most procedures and treatments are carried out on an outpatient basis and test results are ready within a short time. Gynaecologists Dr Julija Samardžić and Dr Božidar Petričević see patients; the practice also works with consultants in endocrinology and microbiology. Services: gynaecological and colposcopic examination, Pap test, pelvic ultrasound and colour Doppler, a comprehensive gynaecological check-up (examination, colposcopy, Pap test, vaginal secretion, pelvic ultrasound); investigation and treatment of infertility (semen analysis, semen culture, hormone tests for both partners, folliculometry), menstrual cycle disorders and menopausal symptoms (hormone replacement therapy); contraception; laboratory tests — hormone levels, diagnosis of cervical infections (Chlamydia, Mycoplasma, Ureaplasma, bacterial vaginosis), HPV typing by PCR; procedures — Bartholin gland incision, IUD removal, pessary insertion; diagnosis and management of pregnancy, pregnancy ultrasound, ultrasound screening for fetal anomalies, double, triple and quadruple tests and NIPT. On Sundays the practice is open for emergencies only.',
	description_de = 'Filia ist eine moderne private Praxis für Gynäkologie und Geburtshilfe in Tivat (Tomičići 22), ausgerichtet auf die Gesundheitsbedürfnisse der modernen Frau; sie besteht seit 2024. Sie arbeitet als Diagnose- und Behandlungspraxis, in der die meisten Eingriffe und Behandlungen ambulant erfolgen und Untersuchungsergebnisse kurzfristig vorliegen. Es behandeln die Gynäkologen Dr. Julija Samardžić und Dr. Božidar Petričević; die Praxis arbeitet zudem mit Konsiliarärzten für Endokrinologie und Mikrobiologie. Leistungen: gynäkologische und kolposkopische Untersuchung, Pap-Abstrich, Ultraschall des kleinen Beckens und Farbdoppler, gynäkologische Vorsorgeuntersuchung (Untersuchung, Kolposkopie, Pap-Abstrich, Vaginalsekret, Beckenultraschall); Abklärung und Behandlung von Unfruchtbarkeit (Spermiogramm, Spermakultur, Hormonuntersuchungen beider Partner, Follikelmonitoring), Zyklusstörungen und Wechseljahresbeschwerden (Hormonersatztherapie); Verhütung; Laboranalysen — Hormonspiegel, Diagnostik zervikaler Infektionen (Chlamydia, Mycoplasma, Ureaplasma, bakterielle Vaginose), HPV-Typisierung per PCR; Eingriffe — Inzision der Bartholin-Drüse, Entfernung der Spirale, Pessareinlage; Diagnose und Betreuung der Schwangerschaft, Schwangerschaftsultraschall, Ultraschall-Screening auf fetale Fehlbildungen, Double-, Triple- und Quadruple-Test sowie NIPT. Sonntags ist die Praxis nur in Notfällen geöffnet.',
	description_tr = 'Filia, Tivat''ta (Tomičići 22) modern kadının sağlık ihtiyaçlarına yönelik, 2024''te açılmış modern bir özel kadın hastalıkları ve doğum muayenehanesidir. Tanı ve tedavi muayenehanesi olarak çalışır: işlemlerin ve tedavilerin çoğu ayaktan yapılır, tetkik sonuçları kısa sürede hazır olur. Kadın doğum uzmanları Dr. Julija Samardžić ve Dr. Božidar Petričević hasta kabul eder; muayenehane endokrinoloji ve mikrobiyoloji danışmanlarıyla da çalışır. Hizmetler: jinekolojik ve kolposkopik muayene, Pap testi, pelvik ultrason ve renkli Doppler, kapsamlı jinekolojik check-up (muayene, kolposkopi, Pap testi, vajinal akıntı, pelvik ultrason); kısırlık (sperm analizi, sperm kültürü, eşlerin hormon tetkikleri, folikül takibi), adet düzensizlikleri ve menopoz şikâyetlerinin (hormon replasman tedavisi) araştırılması ve tedavisi; doğum kontrolü; laboratuvar tahlilleri — hormon düzeyleri, servikal enfeksiyonların tanısı (Chlamydia, Mycoplasma, Ureaplasma, bakteriyel vajinoz), PCR yöntemiyle HPV tiplemesi; işlemler — Bartholin bezi insizyonu, spiral çıkarılması, pesser uygulaması; gebeliğin tanısı ve takibi, gebelik ultrasonu, fetal anomali ultrason taraması, ikili, üçlü ve dörtlü test ile NIPT. Pazar günleri muayenehane yalnızca acil durumlarda hizmet verir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- GYNECOLOGICAL_CLINIC = 7 (частный гинеколого-акушерский кабинет).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 7);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском, другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — подвал всех страниц (решение координатора 2026-10-09): «Radno vrijeme Pon - Pet: 14.00 - 20.00, Subota: 10.00 - 20.00, Ned: samo kada je hitan slučaj». Вс → closed (приём только в экстренных случаях — фраза в описании). Блок шапки «Ponedeljak – Petak 08:00 - 20:00 … 24/7 Usluga dostupne» — виджет темы xcare, не берём.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "14:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "20:00"}]}',
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
-- PART 3: DOCTORS (2)
-- ═══════════════════════════════════════════════════════════════
-- Источник: /o-nama/ («Ordiniraju ginekolozi dr Julija Samardžić i dr Božidar Petričević»).
-- НЕ заводятся: «konsultante iz oblasti endokrinologije, mikrobiologije itd.» — без имён; /our-team-member/ — демо-контент темы
-- (Jordan Peele, Bobby Flay); в форме «Zakaži termin» имена «Marija, Sanja, Jovan, Nikola, Sara» — тоже заготовка темы.

-- ───────────────────────────────────────────────────────────────
-- /o-nama: «Ordiniraju ginekolozi dr Julija Samardžić i dr Božidar Petričević».
-- В БД есть: julija-samardzic (локаль id 1287, specialty 5, dom-zdravlja-tivat; прод-API 200) — тот же город и специальность → привязка.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'julija-samardzic' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'julija-samardzic', 'Julija Samardžić', 'Јулија Самарџић', 'Юлия Самарджич', 'Julija Samardzic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Врач уже в БД: дозаполнение пустых имён (ru/en), существующие не трогаем.
UPDATE doctors SET
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Юлия Самарджич', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Julija Samardzic', name_en)
WHERE id = @doctor_id;

-- Описание врача не задаём: на сайте только «ginekolog».

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Ginekolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- /o-nama: «Ordiniraju ginekolozi … dr Božidar Petričević».
-- В БД не найден (локаль: bozidar-petricevic / petricevic-bozidar нет; есть Marija и Ljubomir Petričević — другие люди; прод-API 204) — новый. 5 = GYNECOLOGY_OBSTETRICS.
-- Фото на сайте нет (/our-team-member/ — демо-контент темы).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Božidar Petričević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Petričević Božidar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'bozidar-petricevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bozidar-petricevic', 'Božidar Petričević', 'Божидар Петричевић', 'Божидар Петричевич', 'Bozidar Petricevic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Ginekolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 4, status = published, clinic_languages = '1', clinic_types = '7', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2: julija-samardzic (5), bozidar-petricevic (5).
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

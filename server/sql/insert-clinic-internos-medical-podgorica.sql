-- ═══════════════════════════════════════════════════════════════════════════
-- Internos Medical & Laboratorija (Podgorica) — клиника + 7 врачей
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-internos-medical-podgorica.sql
-- Затем: server/sql/insert-clinic-internos-medical-podgorica-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://internosmedical.me/ — WordPress (тема Xcare / pbmit), одностраничник.
--     wp-sitemap: одна страница (главная, modified 2026-03-12), 5 записей pbmit-service
--     (modified 2025-04-03) и 3 pbmit-team-member (modified 2026-03-12). /wp-json/wp/v2/pages
--     — та же одна страница, записей блога нет.
--     Страницы /service/* — только заголовок и фото; /service/kozmetika-i-estetika/ —
--     английский демо-текст шаблона («Delivering world class medical care», lorem ipsum),
--     не используется. Карточки /team-member/* — имя и «spec.urolog»/«spec.radiolog»,
--     у dr Sergej Kolosov — только имя; фото врачей нет нигде.
--   * data/google-places/podgorica/internos-medical-laboratorija.json — place_id,
--     координаты, телефон (Google не перезапрашивался).
--
-- Сверка фактов:
--   * Адрес: сайт «8. marta broj 76, Podgorica» и «na adresi, 8.mart 76», Google
--     «76 8. Marta, Podgorica» — совпадают. Индекса на сайте нет — 81000 (Podgorica).
--   * Координаты 42.4341256 / 19.2436515 — Google Places, единственный источник.
--   * Телефоны: «+382 69 540 400 — Medical», «+382 69 223 422 — Laboratorija» (блок
--     контактов); Google подтверждает первый.
--   * Email info@internosmedical.me; соцсетей на сайте нет.
--   * Часы на сайте не указаны («Stojimo vam na raspolaganju 24/7» — слоган, не часы) —
--     clinic_working_hours не заполняется.
--   * Языки клиники: только SR (сайт только на черногорском, других языков не заявляет).
--   * Тип: POLYCLINIC (1) — PZU с приёмами семи специальностей; DIAGNOSTIC_LAB (4) —
--     лаборатория в самом названии («Internos Medical & Laboratorija») и с отдельным
--     телефоном. Перечня анализов на сайте нет — clinic_lab_tests не заполняется.
--   * Логотип — custom-logo темы (cropped-Logo.png).
--
-- Врачи — названы в текстах направлений на главной + 3 карточки team-member: 7 врачей.
-- НЕ заводятся: Radmila Stupar Đurišić (psihološkinja — не врач); dr Sergej Kolosov —
-- карточка team-member без специальности, нигде на сайте её нет (в спорных записи импорта).
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания клиники
-- пишутся безусловным UPDATE (правки из админки следующий прогон перезатрёт — вносить
-- сюда), языки синхронизируются. Поля уже существующих врачей не перезаписываются,
-- специальности — INSERT IGNORE.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJeTqm7EjrTRMRwOE9-ehR6jo';
SET @clinic_slug = 'internos-medical-podgorica';

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
	'Internos Medical & Laboratorija',
	'Internos Medical & Лабораторија', -- бренд латиницей, как у Medicus Tim / Stojanović Medical
	'Internos Medical & Лаборатория',
	'8. marta 76',
	'8. марта 76',
	'',
	'',
	'81000',
	42.43412560,
	19.24365150,
	'+38269540400;+38269223422',
	'info@internosmedical.me',
	'https://internosmedical.me/',
	'', -- на сайте нет
	'', -- на сайте нет
	'',
	'',
	'',
	'https://internosmedical.me/wp-content/uploads/2025/04/cropped-Logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Internos Medical & Лабораторија', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Internos Medical & Лаборатория', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', '8. marta 76', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', '8. марта 76', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude        = COALESCE(latitude, 42.43412560),
	longitude       = COALESCE(longitude, 19.24365150),
	phone           = IF(phone IS NULL OR phone = '', '+38269540400;+38269223422', phone),
	email           = IF(email IS NULL OR email = '', 'info@internosmedical.me', email),
	website         = IF(website IS NULL OR website = '', 'https://internosmedical.me/', website),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://internosmedical.me/wp-content/uploads/2025/04/cropped-Logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что клиника пишет о себе: блок «O nama»,
-- тексты направлений, карточки услуг главной. Слоганы («Najbolji doktori», «24/7») не
-- переносятся.
UPDATE clinics SET
	description_sr = 'Internos Medical Centar & laboratorija je privatna zdravstvena ustanova u ulici 8. marta 76 u Podgorici, koja radi od 2016. godine; djelatnost je u međuvremenu proširena internističkom ambulantom, a u ponudi su i kozmetičko-estetske usluge. U centru se obavljaju konsultativni specijalistički pregledi iz kardiologije, hirurgije (vaskularna hirurgija), psihijatrije, endokrinologije i urologije, radiološki pregledi za djecu i odrasle, ginekologija i internistički pregledi, kao i 4D ultrazvuk. Ustanova ima sopstvenu laboratoriju, pruža kućnu njegu i patronažu, a u okviru psihološkog savjetovališta za adolescente i odrasle nudi individualni rad sa klijentom, program za porodicu i bračno savjetovanje.',
	description_sr_cyrl = 'Internos Medical Центар & лабораторија је приватна здравствена установа у улици 8. марта 76 у Подгорици, која ради од 2016. године; дјелатност је у међувремену проширена интернистичком амбулантом, а у понуди су и козметичко-естетске услуге. У центру се обављају консултативни специјалистички прегледи из кардиологије, хирургије (васкуларна хирургија), психијатрије, ендокринологије и урологије, радиолошки прегледи за дјецу и одрасле, гинекологија и интернистички прегледи, као и 4D ултразвук. Установа има сопствену лабораторију, пружа кућну његу и патронажу, а у оквиру психолошког савјетовалишта за адолесценте и одрасле нуди индивидуални рад са клијентом, програм за породицу и брачно савјетовање.',
	description_ru = 'Internos Medical Centar & laboratorija — частное медицинское учреждение на улице 8 Марта, 76 в Подгорице, работающее с 2016 года; позже к нему добавился кабинет терапевта-интерниста, также предлагаются косметологические услуги. В центре ведут консультативные приёмы кардиолог, хирург (сосудистая хирургия), психиатр, эндокринолог и уролог, проводятся рентгенорадиологические обследования для детей и взрослых, приём гинеколога и терапевта-интерниста, а также 4D УЗИ. Есть собственная лаборатория, услуги ухода на дому и патронажа, а психологическая консультация для подростков и взрослых предлагает индивидуальную работу с клиентом, программу для семьи и консультирование супружеских пар.',
	description_en = 'Internos Medical Centre & Laboratory is a private healthcare institution at 8. marta 76 in Podgorica, operating since 2016; it has since added an internal medicine practice and also offers cosmetic and aesthetic services. The centre provides specialist consultations in cardiology, surgery (vascular surgery), psychiatry, endocrinology and urology, radiology examinations for children and adults, gynaecology and internal medicine check-ups, as well as 4D ultrasound. It runs its own laboratory, provides home nursing care and patronage visits, and its psychological counselling service for adolescents and adults offers individual sessions, a family programme and marital counselling.',
	description_de = 'Internos Medical Centar & Labor ist eine private Gesundheitseinrichtung in der Straße 8. marta 76 in Podgorica und besteht seit 2016; inzwischen wurde sie um eine internistische Ambulanz erweitert und bietet auch kosmetisch-ästhetische Leistungen an. Im Zentrum finden fachärztliche Konsultationen in Kardiologie, Chirurgie (Gefäßchirurgie), Psychiatrie, Endokrinologie und Urologie statt, dazu radiologische Untersuchungen für Kinder und Erwachsene, Gynäkologie, internistische Untersuchungen sowie 4D-Ultraschall. Die Einrichtung hat ein eigenes Labor, bietet häusliche Pflege und Hausbesuche durch Pflegekräfte an, und die psychologische Beratungsstelle für Jugendliche und Erwachsene bietet Einzelarbeit, ein Familienprogramm und Eheberatung.',
	description_tr = 'Internos Medical Centar & Laboratuvar, Podgorica''da 8. marta 76 adresinde 2016''dan beri hizmet veren özel bir sağlık kuruluşudur; zamanla bir dahiliye polikliniği eklenmiş olup kozmetik ve estetik hizmetler de sunulmaktadır. Merkezde kardiyoloji, cerrahi (damar cerrahisi), psikiyatri, endokrinoloji ve üroloji alanlarında uzman konsültasyonları, çocuk ve yetişkinler için radyoloji incelemeleri, jinekoloji ve dahiliye muayeneleri ile 4D ultrason yapılır. Kurumun kendi laboratuvarı vardır, evde bakım ve hemşire ev ziyaretleri sunar; ergenler ve yetişkinler için psikolojik danışmanlık birimi bireysel çalışma, aile programı ve evlilik danışmanlığı sağlar.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1, ClinicType.DIAGNOSTIC_LAB = 4
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1), (@clinic_id, 4);

-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы НЕ заполняются: на сайте их нет.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS — 7 врачей из текстов направлений и карточек team-member.
-- Специальности: 1 CARDIOLOGY, 2 INTERNAL_MEDICINE, 3 GENERAL_SURGERY, 9 UROLOGY,
--   10 RADIOLOGY, 12 ENDOCRINOLOGY, 21 PSYCHIATRY, 34 VASCULAR_SURGERY.
-- Язык — только SR (1). Фото — нет на сайте (у найденных в БД остаются свои).
-- 6 из 7 уже есть в БД — для них только привязка, position и специальность сайта.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Dijana Drekalović — spec. internista-kardiolog (новая)
-- «U našem medicinskom centru iz oblasti kardiologije ordinira dr Dijana Drekalović –
-- spec.internista-kardiolog». (Siniša Drekalović, анестезиолог КЦЦГ, — другой человек.)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dijana Drekalović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Drekalović Dijana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dijana-drekalovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dijana-drekalovic', 'Dijana Drekalović', 'Дијана Дрекаловић', 'Дияна Дрекалович', 'Dijana Drekalovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista interne medicine – kardiolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Perica Maraš — spec. opšte hirurgije, subspecijalista vaskularne hirurgije
-- В БД уже есть: slug maras-perica, name_sr «Maraš Perica» (локально id 58; Milmedika,
-- Codra, КЦЦГ, Konzilijum; специальности 3, 34).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Perica Maraš' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Maraš Perica' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'perica-maras' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'maras-perica' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'perica-maras', 'Perica Maraš', 'Перица Мараш', 'Перица Мараш', 'Perica Maras', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3), (@doctor_id, 34);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista opšte hirurgije, subspecijalista vaskularne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Lidija Injac Stevović — spec. psihijatrije
-- В БД уже есть: slug lidija-injac-stevovic (локально id 778; КЦЦГ; «prof. dr.»).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Lidija Injac Stevović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Injac Stevović Lidija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'lidija-injac-stevovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'lidija-injac-stevovic', 'Lidija Injac Stevović', 'Лидија Ињац Стевовић', 'Лидия Иняц Стевович', 'Lidija Injac Stevovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista psihijatrije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Mira Obradović — spec. radiolog
-- В БД уже есть: slug mira-obradovic (локально id 984; Medikid; радиология).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mira Obradović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Obradović Mira' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mira-obradovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mira-obradovic', 'Mira Obradović', 'Мира Обрадовић', 'Мира Обрадович', 'Mira Obradovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Sanja Čejović — spec. radiolog
-- В БД уже есть: slug sanja-cejovic (локально id 171; Moj Lab; радиология).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sanja Čejović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Čejović Sanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sanja-cejovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-cejovic', 'Sanja Čejović', 'Сања Чејовић', 'Саня Чейович', 'Sanja Cejovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Đorđe Krnjević — spec. internista endokrinolog
-- В БД уже есть как Đorđije Krnjević: slug djordjije-krnjevic (локально id 723; КЦЦГ;
-- эндокринология). Đorđe — бытовая форма Đorđije (как у Đorđe Kaluđerović в импорте MOA,
-- подтверждено юзером 2026-10-08) → явный фолбэк на slug djordjije-krnjevic.
-- Сайт называет его интернистом-эндокринологом — добавляется 2 INTERNAL_MEDICINE.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Đorđe Krnjević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Krnjević Đorđe' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'djordje-krnjevic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'djordjije-krnjevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'djordjije-krnjevic', 'Đorđije Krnjević', 'Ђорђије Крњевић', 'Джорджие Крньевич', 'Djordjije Krnjevic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 12);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista interne medicine – endokrinolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Vladimir Brajović — spec. urolog
-- В БД уже есть: slug brajovic-vladimir, name_sr «Brajović Vladimir» (локально id 5;
-- Milmedika, Codra, Kerber; урология).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vladimir Brajović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Brajović Vladimir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vladimir-brajovic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'brajovic-vladimir' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vladimir-brajovic', 'Vladimir Brajović', 'Владимир Брајовић', 'Владимир Брайович', 'Vladimir Brajovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista urologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, languages = 1, types = 1,4, working_hours = 0.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 7 строк, у каждой непустая position и непустой список специальностей.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(ds.specialty_id ORDER BY ds.specialty_id) AS specialties
FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
WHERE dc.clinic_id = @clinic_id
GROUP BY d.id, d.slug, d.name_sr, d.professional_title, dc.position
ORDER BY d.id;

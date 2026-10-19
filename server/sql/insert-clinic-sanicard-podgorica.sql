-- ═══════════════════════════════════════════════════════════════════════════
-- Zdravstvena ustanova Sanicard (Podgorica) — клиника + врач
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-sanicard-podgorica.sql
-- Затем: server/sql/insert-clinic-sanicard-podgorica-services.sql
-- Запись импорта: data/clinic-imports/sanicard-podgorica.json. Подволна 2e, агент Z.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA + WP REST /wp/v2/pages):
--   * https://sanicard.me/ — WordPress/Elementor, me/en/ru; главная и /usluge/ — modified 2023-02-26, /o-nama/ и /kontakt/ — 2022-12;
--     блог — до 2026-04. © 2023. Единственная цена — главная: «Ljekarsa uvjerenja za pomorce sa sistematskim pregledom (cijena 60€)».
--     Год основания на сайте противоречив (1993 — главная, 1994 — биография) — в описание не взят.
--   * data/google-places/podgorica/zdravstvena-ustanova-sanicard.json — place_id, координаты 42.4335757 / 19.2434791, +382 69 767 506,
--     «64 Ilije Plamenca, Podgorica 81000», 2 отзыва — не импортировались.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJk8O8ac7rTRMRFUCm_58AP9U';
SET @clinic_slug = 'sanicard-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Sanicard', 'SANICARD', 'Zdravstvena ustanova Sanicard', 'Zdravstvena ustanova SANICARD', 'PZU Sanicard', 'Ordinacija Sanicard') AND city_id = 1 LIMIT 1));

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
	'Sanicard',
	'Sanicard',
	'Sanicard',
	'Bulevar Ilije Plamenca 64',
	'Булевар Илије Пламенца 64',
	'',
	'',
	'81000',
	42.43357570,
	19.24347910,
	'+38220662039;+38220662013;+38269013550;+38269767506',
	'kontakt@sanicard.me;sanicard@hotmail.com',
	'https://sanicard.me/',
	'facebook.com/profile.php?id=100064059334752',
	'@sanicard.me',
	'',
	'',
	'',
	'https://sanicard.me/wp-content/uploads/elementor/thumbs/sanicard-pykvh5xbnmjdft1dqel8gw05liiihqtupmh7lag0d4.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.43357570, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.24347910, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Sanicard', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Sanicard', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Bulevar Ilije Plamenca 64', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Булевар Илије Пламенца 64', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220662039;+38220662013;+38269013550;+38269767506', phone),
	email = IF(email IS NULL OR email = '', 'kontakt@sanicard.me;sanicard@hotmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://sanicard.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/profile.php?id=100064059334752', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@sanicard.me', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://sanicard.me/wp-content/uploads/elementor/thumbs/sanicard-pykvh5xbnmjdft1dqel8gw05liiihqtupmh7lag0d4.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Privatna zdravstvena ustanova Sanicard u Podgorici, na Bulevaru Ilije Plamenca 64, jedna je od prvih privatnih medicinskih ustanova u Crnoj Gori. Osnivač i rukovodilac je prim. dr sci. med. Svjetlana Zeković, pedijatar i subspecijalista kardiologije. Registrovana je kao pedijatrijska i internistička ordinacija s fokusom na kardiologiju za djecu i odrasle i opremljena je aparatima za neinvazivnu kardiološku dijagnostiku: EKG s monitoringom, ultrazvučni aparat s kolor doplerom, ergometar, holteri za EKG i krvni pritisak, oksimetrija i spirometrija. Usluge: pregledi bolesne i sistematski pregledi zdrave djece; neonatologija — sistematski pregledi odojčadi i ultrazvuk kukova i CNS-a; kardiologija za djecu i odrasle — pregled s EKG-om i monitoringom, ehokardiografija s kolor doplerom, test opterećenja (ergometrija), holter EKG-a i krvnog pritiska, spirometrija; kardiološki pregledi sportista za djecu i odrasle; interna medicina; ultrazvuk abdomena i urotrakta, štitaste žlijezde i dojke, dopler karotidnih arterija i perifernih krvnih sudova; konsultantski pregledi iz ginekologije, endokrinologije, dječje gastroenterologije i ortopedije; neurološki pregled i elektromioneurografija (EMNG). Ustanova radi sistematske preglede za zaposlene u organizacijama UN u Crnoj Gori i izdaje ljekarska uvjerenja za pomorce sa sistematskim pregledom. Radno vrijeme: ponedjeljak–petak od 9 do 13 i od 17 do 20 časova, subotom od 9 do 14 časova.',
	description_sr_cyrl = 'Приватна здравствена установа Sanicard у Подгорици, на Булевару Илије Пламенца 64, једна је од првих приватних медицинских установа у Црној Гори. Оснивач и руководилац је прим. др сци. мед. Свјетлана Зековић, педијатар и субспецијалиста кардиологије. Регистрована је као педијатријска и интернистичка ординација с фокусом на кардиологију за дјецу и одрасле и опремљена је апаратима за неинвазивну кардиолошку дијагностику: EKG с мониторингом, ултразвучни апарат с колор доплером, ергометар, холтери за EKG и крвни притисак, оксиметрија и спирометрија. Услуге: прегледи болесне и систематски прегледи здраве дјеце; неонатологија — систематски прегледи одојчади и ултразвук кукова и CNS-а; кардиологија за дјецу и одрасле — преглед с EKG-ом и мониторингом, ехокардиографија с колор доплером, тест оптерећења (ергометрија), холтер EKG-а и крвног притиска, спирометрија; кардиолошки прегледи спортиста за дјецу и одрасле; интерна медицина; ултразвук абдомена и уротракта, штитасте жлијезде и дојке, доплер каротидних артерија и периферних крвних судова; консултантски прегледи из гинекологије, ендокринологије, дјечје гастроентерологије и ортопедије; неуролошки преглед и електромионеурографија (EMNG). Установа ради систематске прегледе за запослене у организацијама UN у Црној Гори и издаје љекарска увјерења за поморце са систематским прегледом. Радно вријеме: понедјељак–петак од 9 до 13 и од 17 до 20 часова, суботом од 9 до 14 часова.',
	description_ru = 'Частное медицинское учреждение Sanicard в Подгорице, бульвар Ilije Plamenca 64, — одно из первых частных медицинских учреждений Черногории. Основатель и руководитель — прим. д-р мед. наук Светлана Зекович, педиатр и субспециалист по кардиологии. Учреждение зарегистрировано как педиатрический и терапевтический кабинет с упором на кардиологию для детей и взрослых и оснащено аппаратурой для неинвазивной кардиологической диагностики: ЭКГ с мониторингом, УЗИ-аппарат с цветовым допплером, эргометр, холтеры ЭКГ и давления, оксиметрия и спирометрия. Услуги: осмотры больных и профилактические осмотры здоровых детей; неонатология — профилактические осмотры грудных детей, УЗИ тазобедренных суставов и ЦНС; кардиология для детей и взрослых — осмотр с ЭКГ и мониторингом, эхокардиография с цветовым допплером, нагрузочный тест (эргометрия), холтер ЭКГ и суточный мониторинг давления, спирометрия; кардиологические осмотры спортсменов — детей и взрослых; терапия; УЗИ брюшной полости и мочевыводящих путей, щитовидной и молочной железы, допплер сонных артерий и периферических сосудов; консультации гинеколога, эндокринолога, детского гастроэнтеролога и ортопеда; осмотр невролога и электромионейрография (ЭМНГ). Учреждение проводит профилактические осмотры сотрудников организаций ООН в Черногории и выдаёт медицинские справки для моряков с профилактическим осмотром. Часы работы: пн–пт с 9 до 13 и с 17 до 20, суббота с 9 до 14.',
	description_en = 'Sanicard is a private healthcare institution in Podgorica at Bulevar Ilije Plamenca 64 and one of the first private medical institutions in Montenegro. It was founded and is run by Prim. Dr Sci. Med. Svjetlana Zeković, a paediatrician and cardiology subspecialist. Registered as a paediatric and internal medicine practice focused on cardiology for children and adults, it is equipped for non-invasive cardiac diagnostics: ECG with monitoring, an ultrasound machine with colour Doppler, an ergometer, ECG and blood pressure Holters, oximetry and spirometry. Services: examinations of sick children and check-ups of healthy children; neonatology — infant check-ups and hip and brain (CNS) ultrasound; cardiology for children and adults — examination with ECG and monitoring, echocardiography with colour Doppler, exercise stress test (ergometry), Holter ECG and blood pressure monitoring, spirometry; cardiology examinations for athletes, children and adults; internal medicine; abdominal and urinary tract, thyroid and breast ultrasound, carotid and peripheral vascular Doppler; consultant examinations in gynaecology, endocrinology, paediatric gastroenterology and orthopaedics; neurological examination and electromyoneurography (EMNG). The institution performs routine medical examinations for employees of UN organisations in Montenegro and issues seafarer medical certificates with a full check-up. Opening hours: Monday–Friday 9:00–13:00 and 17:00–20:00, Saturday 9:00–14:00.',
	description_de = 'Sanicard ist eine private Gesundheitseinrichtung in Podgorica, Bulevar Ilije Plamenca 64, und eine der ersten privaten medizinischen Einrichtungen Montenegros. Gründerin und Leiterin ist Prim. Dr. sc. med. Svjetlana Zeković, Kinderärztin und Subspezialistin für Kardiologie. Registriert als pädiatrische und internistische Praxis mit Schwerpunkt Kardiologie für Kinder und Erwachsene, ist sie für die nichtinvasive kardiologische Diagnostik ausgestattet: EKG mit Monitoring, Ultraschallgerät mit Farbdoppler, Ergometer, Holter für EKG und Blutdruck, Oxymetrie und Spirometrie. Leistungen: Untersuchungen kranker und Vorsorgeuntersuchungen gesunder Kinder; Neonatologie — Vorsorgeuntersuchungen von Säuglingen, Ultraschall der Hüften und des ZNS; Kardiologie für Kinder und Erwachsene — Untersuchung mit EKG und Monitoring, Echokardiographie mit Farbdoppler, Belastungstest (Ergometrie), Holter-EKG und Langzeit-Blutdruckmessung, Spirometrie; kardiologische Untersuchungen von Sportlern (Kinder und Erwachsene); Innere Medizin; Ultraschall von Abdomen und Harnwegen, Schilddrüse und Brust, Doppler der Halsschlagadern und peripheren Gefäße; konsiliarische Untersuchungen in Gynäkologie, Endokrinologie, Kindergastroenterologie und Orthopädie; neurologische Untersuchung und Elektromyoneurographie (EMNG). Die Einrichtung führt Vorsorgeuntersuchungen für Mitarbeitende von UN-Organisationen in Montenegro durch und stellt Seediensttauglichkeitszeugnisse mit Vorsorgeuntersuchung aus. Öffnungszeiten: Montag–Freitag 9–13 und 17–20 Uhr, Samstag 9–14 Uhr.',
	description_tr = 'Sanicard, Podgorica''da Bulevar Ilije Plamenca 64 adresinde bulunan özel bir sağlık kuruluşudur ve Karadağ''ın ilk özel tıp kuruluşlarından biridir. Kurucusu ve yöneticisi çocuk doktoru ve kardiyoloji yan dal uzmanı Prim. Dr. Sci. Med. Svjetlana Zeković''tir. Çocuklar ve yetişkinler için kardiyoloji ağırlıklı pediatri ve iç hastalıkları muayenehanesi olarak kayıtlıdır ve invazif olmayan kardiyolojik tanı için donatılmıştır: monitörlü EKG, renkli Doppler''li ultrason cihazı, ergometre, EKG ve tansiyon Holter cihazları, oksimetri ve spirometri. Hizmetler: hasta çocukların muayenesi ve sağlıklı çocukların check-up''ı; neonatoloji — bebeklerin rutin muayenesi, kalça ve MSS ultrasonu; çocuklar ve yetişkinler için kardiyoloji — EKG ve monitörlü muayene, renkli Doppler''li ekokardiyografi, efor testi (ergometri), Holter EKG ve tansiyon Holteri, spirometri; çocuk ve yetişkin sporcular için kardiyoloji muayenesi; iç hastalıkları; karın ve idrar yolları, tiroid ve meme ultrasonu, karotis ve periferik damar Doppler incelemesi; jinekoloji, endokrinoloji, çocuk gastroenterolojisi ve ortopedi konsültan muayeneleri; nöroloji muayenesi ve elektromiyonörografi (EMNG). Kuruluş Karadağ''daki BM kuruluşlarının çalışanları için rutin sağlık muayeneleri yapar ve gemiadamları için check-up''lı sağlık raporu düzenler. Çalışma saatleri: pazartesi–cuma 9:00–13:00 ve 17:00–20:00, cumartesi 9:00–14:00.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PEDIATRIC_CLINIC = 12 + CARDIOLOGY_CLINIC = 11 — «Registrovana je kao PEDIJATRIJSKA I INTERNISTIČKA ORDINACIJA SA FOKUSOM NA KARDIOLOGIJI ZA DJECU I ODRASLE» (/o-nama/).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 12), (@clinic_id, 11);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт на me/en/ru, но приём на других языках не заявлен (версии сайта — не заявление, решение юзера) → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: на сайте два графика. Шаблонный — шапка и /kontakt/ «Ponedjeljak – Petak: 8am to 8pm | Subota: 07am – 1pm» (am/pm-формат темы, в той же шапке устаревший адрес «Ilije Plamenca 105»). Не шаблонный — блок подвала «Radno vrijeme u ordinaciji “Sanicard”: Od 09-13h i 17-20h Ponedeljak-Petak, Subota od 09-14h» → взят он. Вс не назван в этом блоке, в шаблонном «Nedjelja: Ne radimo» → closed.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "14:00"}]}',
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
-- PART 3: DOCTORS (1)
-- ═══════════════════════════════════════════════════════════════
-- Именован только основатель. Консультанты (гинекология, эндокринология, дечья гастроэнтерология, ортопедия, неврология, «vrsni neonatolog») без имён — не заводились (решение юзера).
-- Привязки врач↔услуга — только педиатрические и детская кардиология (основатель — педиатр-кардиолог); взрослая кардиология/консультанты — без привязки.

-- ───────────────────────────────────────────────────────────────
-- «Osnivač i rukovodilac je Prim. dr. sci. md. Svjetlana Zeković» (главная); биография — /o-nama/ («specijalizira pedijatriju … subspecijalista iz kardiologije»).
-- В БД не найдена (локаль: Zeković — только Aldijana (общая медицина, ДЗ Подгорица); svjetlana-zekovic нет; прод-API 204) — новая.
-- 4 = PEDIATRICS + 23 = PEDIATRIC_CARDIOLOGY. Фото — портрет рядом с биографией на /o-nama/ (unnamed.jpg). Языки не заявлены → SR.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Svjetlana Zeković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Zeković Svjetlana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'svjetlana-zekovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'svjetlana-zekovic', 'Svjetlana Zeković', 'Свјетлана Зековић', 'Светлана Зекович', 'Svjetlana Zekovic', 'prim. dr sci. med.',
	'https://sanicard.me/wp-content/uploads/2022/12/unnamed.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://sanicard.me/wp-content/uploads/2022/12/unnamed.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Rođena je u Osijeku; Medicinski fakultet završila je u Zagrebu, a zatim je radila u Medicinskom zavodu u Titogradu, u Školskom dispanzeru. Specijalizaciju iz pedijatrije završila je u Titogradu i Beogradu (1977–1980), a subspecijalizaciju iz kardiologije u Beogradu, gdje je 1985. godine odbranila završni rad o ranoj i poznoj evoluciji i prognozi reumatske groznice. Godine 1983. osnovala je Odjeljenje za dječju kardiologiju u okviru Dječje klinike u Podgorici i rukovodila njegovim radom, a 1986. godine uvela je ehokardiografsku dijagnostiku kod djece u Crnoj Gori. Zvanje primarijusa dobila je 1990. godine. Magistrirala je 2000. godine radom „Istraživanje urođenih srčanih mana u Crnoj Gori“, a doktorsku disertaciju „Procjena pulmonalne regurgitacije kod djece operisane od tetralogije Fallot“ odbranila je na Univerzitetu u Beogradu. Godine 1994. osnovala je privatnu zdravstvenu ustanovu za pedijatriju i internu medicinu s kardiologijom. Bila je predsjednica Udruženja privatnih doktora medicine Crne Gore (UPDOM), a sada je predsjednica Skupštine UPDOM-a.',
	description_sr_cyrl = 'Рођена је у Осијеку; Медицински факултет завршила је у Загребу, а затим је радила у Медицинском заводу у Титограду, у Школском диспанзеру. Специјализацију из педијатрије завршила је у Титограду и Београду (1977–1980), а субспецијализацију из кардиологије у Београду, гдје је 1985. године одбранила завршни рад о раној и позној еволуцији и прогнози реуматске грознице. Године 1983. основала је Одјељење за дјечју кардиологију у оквиру Дјечје клинике у Подгорици и руководила његовим радом, а 1986. године увела је ехокардиографску дијагностику код дјеце у Црној Гори. Звање примаријуса добила је 1990. године. Магистрирала је 2000. године радом „Истраживање урођених срчаних мана у Црној Гори“, а докторску дисертацију „Процјена пулмоналне регургитације код дјеце оперисане од тетралогије Fallot“ одбранила је на Универзитету у Београду. Године 1994. основала је приватну здравствену установу за педијатрију и интерну медицину с кардиологијом. Била је предсједница Удружења приватних доктора медицине Црне Горе (UPDOM), а сада је предсједница Скупштине UPDOM-а.',
	description_ru = 'Родилась в Осиеке; окончила медицинский факультет в Загребе, затем работала в Медицинском институте Титограда, в школьном диспансере. Специализацию по педиатрии прошла в Титограде и Белграде (1977–1980), субспециализацию по кардиологии — в Белграде, где в 1985 году защитила выпускную работу о ранней и поздней эволюции и прогнозе ревматической лихорадки. В 1983 году основала отделение детской кардиологии при Детской клинике в Подгорице и руководила им, в 1986 году ввела в Черногории эхокардиографическую диагностику у детей. Звание примариуса получила в 1990 году. В 2000 году защитила магистерскую работу «Исследование врождённых пороков сердца в Черногории», затем в Белградском университете — докторскую диссертацию «Оценка лёгочной регургитации у детей, оперированных по поводу тетрады Фалло». В 1994 году основала частное медицинское учреждение по педиатрии и терапии с кардиологией. Была председателем Ассоциации частных врачей Черногории (UPDOM), сейчас — председатель Собрания UPDOM.',
	description_en = 'Born in Osijek, she graduated from the Faculty of Medicine in Zagreb and then worked at the Medical Institute in Titograd, in the school dispensary. She completed her paediatrics residency in Titograd and Belgrade (1977–1980) and a subspecialisation in cardiology in Belgrade, defending her final thesis on the early and late course and prognosis of rheumatic fever in 1985. In 1983 she founded and headed the Department of Paediatric Cardiology at the Children''s Clinic in Podgorica, and in 1986 she introduced paediatric echocardiography in Montenegro. She was awarded the title of primarius in 1990. She obtained her master''s degree in 2000 with the thesis "Research on Congenital Heart Defects in Montenegro" and defended her doctoral dissertation "Assessment of Pulmonary Regurgitation in Children Operated on for Tetralogy of Fallot" at the University of Belgrade. In 1994 she founded a private healthcare institution for paediatrics and internal medicine with cardiology. She has served as president of the Association of Private Medical Doctors of Montenegro (UPDOM) and now chairs its Assembly.',
	description_de = 'Geboren in Osijek, studierte sie Medizin in Zagreb und arbeitete danach im Medizinischen Institut in Titograd, im Schuldispensar. Die Facharztausbildung in Pädiatrie absolvierte sie in Titograd und Belgrad (1977–1980), die Subspezialisierung in Kardiologie in Belgrad, wo sie 1985 ihre Abschlussarbeit über frühen und späten Verlauf und Prognose des rheumatischen Fiebers verteidigte. 1983 gründete sie die Abteilung für Kinderkardiologie an der Kinderklinik in Podgorica und leitete sie; 1986 führte sie die Echokardiographie bei Kindern in Montenegro ein. 1990 erhielt sie den Titel Primarius. Im Jahr 2000 schloss sie ihr Magisterstudium mit der Arbeit „Erforschung angeborener Herzfehler in Montenegro“ ab und verteidigte an der Universität Belgrad ihre Dissertation „Beurteilung der Pulmonalinsuffizienz bei Kindern nach Operation einer Fallot-Tetralogie“. 1994 gründete sie eine private Gesundheitseinrichtung für Pädiatrie und Innere Medizin mit Kardiologie. Sie war Präsidentin des Verbands der privaten Ärzte Montenegros (UPDOM) und ist heute Vorsitzende seiner Versammlung.',
	description_tr = 'Osijek''te doğdu; Zagreb Tıp Fakültesi''ni bitirdikten sonra Titograd Tıp Enstitüsü''nde okul dispanserinde çalıştı. Pediatri uzmanlığını Titograd ve Belgrad''da (1977–1980), kardiyoloji yan dal uzmanlığını Belgrad''da tamamladı ve 1985''te romatizmal ateşin erken ve geç seyri ile prognozu üzerine bitirme çalışmasını savundu. 1983''te Podgorica Çocuk Kliniği bünyesinde Çocuk Kardiyolojisi Bölümü''nü kurup yönetti, 1986''da Karadağ''da çocuklarda ekokardiyografik tanıyı başlattı. 1990''da primarius unvanını aldı. 2000''de "Karadağ''da doğuştan kalp hastalıklarının araştırılması" başlıklı yüksek lisans tezini, ardından Belgrad Üniversitesi''nde "Fallot tetralojisi nedeniyle ameliyat edilen çocuklarda pulmoner yetersizliğin değerlendirilmesi" başlıklı doktora tezini savundu. 1994''te kardiyoloji ağırlıklı pediatri ve iç hastalıkları alanında özel bir sağlık kuruluşu kurdu. Karadağ Özel Hekimler Derneği''nin (UPDOM) başkanlığını yaptı, şu anda derneğin Genel Kurul başkanıdır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4), (@doctor_id, 23);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Osnivač i rukovodilac; pedijatar, subspecijalista kardiologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '12,11', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: svjetlana-zekovic (4,23).
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

-- ═══════════════════════════════════════════════════════════════════════════
-- Dom zdravlja Rožaje — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-rozaje.sql
-- Затем: server/sql/insert-clinic-dom-zdravlja-rozaje-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://dzrozaje.me/ — WordPress, wp-json /wp/v2/pages (10 страниц) и /wp/v2/posts (9 записей).
--     /organizacione-jedinice/ (modified 2026-07-08), /specijalisticke-ambulante/ (2026-08-19),
--     /radno-vrijeme/ (2026-04-01), /kontakt/ (2026-09-09), /o-nama/ (2026-07-08),
--     /ugovori-o-dopunskom-radu/ (2026-06-10), /dokumenta/ (2026-09-09).
--   * data/google-places/berane/health-center-rozaje.json — place_id, координаты, телефон.
--
-- Сверка фактов:
--   * Адрес: сайт «ul. 29 novembra 84310 Rožaje», Google «ul. 29 Novembar, Rožaje 84310» —
--     согласованы; записан «29. novembra» (сербская орфография).
--   * Телефоны: сайт +382 51 271 347 (подтверждён Google) и «Call Centar 067 004 666».
--   * Email dzrozaje@t-com.me, Facebook facebook.com/dzrozaje/ (футер). Логотип — site-logo из шапки.
--   * Город: cities.id = 17 (в таблице «Rozaje»).
--   * Тип: POLYCLINIC (1), как у всех ДЗ. Языки: только SR. Взлома сайта нет.
--
-- Врачи (20): 16 своих (новые) + 4 врача ОБ Беране на дополнительной работе (уже в БД —
-- только привязка). Не заводятся: ORL — на странице только «prim. dr spec. otorinolaringolog» без
-- имени; Almira Honsić, Irma Kardović, Melisa Zekić, Anesa Nurković — тимы 5–8 «Medicina rada»
-- без «dr» и без специальности (правило ДЗ); dr Sanja Beloica и dr Denis Kalač — договоры о
-- дополнительной работе истекли (09.2025 и 01.2026), в текущем списке их нет; glavni tehničar
-- Mirsad Muković и медсёстры — не врачи. Подробно — в записи импорта.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания пишутся
-- безусловным UPDATE (правки из админки следующий прогон перезатрёт — вносить сюда), языки
-- клиники синхронизируются, position привязки к этой клинике обновляется.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJUxlYZUfmUhMRPsI6M2SUK6U';
SET @clinic_slug = 'dom-zdravlja-rozaje';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id, name_sr, name_sr_cyrl, name_ru, address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code, latitude, longitude, phone, email, website, doctor_schedule_url, facebook, instagram, telegram, whatsapp, viber, logo_url, created_at
)
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	17, -- CityId.ROZAJE (в cities записан как «Rozaje»)
	'Dom zdravlja Rožaje',
	'Дом здравља Рожаје',
	'Дом здоровья Рожае',
	'29. novembra',
	'29. новембра',
	'',
	'',
	'84310',
	42.84057740,
	20.16482620,
	'+38251271347;+38267004666',
	'dzrozaje@t-com.me',
	'https://dzrozaje.me/',
	'',
	'facebook.com/dzrozaje',
	'',
	'',
	'',
	'',
	'https://dzrozaje.me/wp-content/uploads/2025/05/cropped-cropped-site-logo.webp',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Дом здравља Рожаје', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Дом здоровья Рожае', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', '29. novembra', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', '29. новембра', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '84310', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38251271347;+38267004666', phone),
	email = IF(email IS NULL OR email = '', 'dzrozaje@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://dzrozaje.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/dzrozaje', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://dzrozaje.me/wp-content/uploads/2025/05/cropped-cropped-site-logo.webp', logo_url),
	latitude = COALESCE(latitude, 42.84057740),
	longitude = COALESCE(longitude, 20.16482620)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что ДЗ пишет о себе: /o-nama/ (2026-07),
-- /organizacione-jedinice/ (2026-07), /specijalisticke-ambulante/ (2026-08), /radno-vrijeme/
-- (2026-04), /kontakt/ (2026-09). Оценочные формулировки («lider», «centar izvrsnosti») не переносятся.
UPDATE clinics SET
	description_sr = 'Dom zdravlja Rožaje je ustanova primarne zdravstvene zaštite za građane Rožaja i okolnih područja — prevencija, dijagnostika, liječenje i rehabilitacija. Izabrani doktori za odrasle i za djecu rade u dvije smjene radnim danima i vikendom, a ginekološko-akušerska ambulanta radnim danima. Specijalističke ambulante — oftalmološka, psihijatrijska, ORL i internistička — rade radnim danima od 07 do 15 časova, uz radiološku dijagnostiku, higijensko-epidemiološku službu i Centar za hemodijalizu. U sastavu su i laboratorijska dijagnostika, medicina rada, Centar za plućne bolesti i TBC, Centar za mentalno zdravlje, patronaža, fizikalna terapija, sanitetski prevoz, populaciono savjetovalište i savjetovalište za reproduktivno zdravlje, kao i bolnička odjeljenja: interno, dječije i ginekologija sa akušerstvom. U okviru dopunskog rada u Domu zdravlja primaju i ljekari Opšte bolnice Berane — fizijatar, urolog, hirurg i ortoped. Call centar: 067 004 666.',
	description_sr_cyrl = 'Дом здравља Рожаје је установа примарне здравствене заштите за грађане Рожаја и околних подручја — превенција, дијагностика, лијечење и рехабилитација. Изабрани доктори за одрасле и за дјецу раде у двије смјене радним данима и викендом, а гинеколошко-акушерска амбуланта радним данима. Специјалистичке амбуланте — офталмолошка, психијатријска, ORL и интернистичка — раде радним данима од 07 до 15 часова, уз радиолошку дијагностику, хигијенско-епидемиолошку службу и Центар за хемодијализу. У саставу су и лабораторијска дијагностика, медицина рада, Центар за плућне болести и TBC, Центар за ментално здравље, патронажа, физикална терапија, санитетски превоз, популационо савјетовалиште и савјетовалиште за репродуктивно здравље, као и болничка одјељења: интерно, дјечије и гинекологија са акушерством. У оквиру допунског рада у Дому здравља примају и љекари Опште болнице Беране — физијатар, уролог, хирург и ортопед. Call центар: 067 004 666.',
	description_ru = 'Дом здоровья Рожае — учреждение первичной медицинской помощи для жителей Рожае и окрестностей: профилактика, диагностика, лечение и реабилитация. Выбранные врачи для взрослых и детей принимают в две смены по будням и в выходные, гинекологическо-акушерский кабинет — по будним дням. Специализированные кабинеты — офтальмолога, психиатра, ЛОР-врача и терапевта-интерниста — работают по будним дням с 7 до 15 часов; есть также рентгенодиагностика, гигиено-эпидемиологическая служба и центр гемодиализа. В составе Дома здоровья — лабораторная диагностика, медицина труда, Центр лёгочных болезней и туберкулёза, Центр психического здоровья, патронажная служба, физиотерапия, санитарный транспорт, консультации по здоровью населения и по репродуктивному здоровью, а также стационарные отделения: терапевтическое, детское и гинекологии с акушерством. В порядке дополнительной работы в Доме здоровья принимают и врачи Общей больницы Беране — физиатр, уролог, хирург и ортопед. Колл-центр: 067 004 666.',
	description_en = 'Dom zdravlja Rožaje is the primary health care centre for the residents of Rozaje and the surrounding area, covering prevention, diagnostics, treatment and rehabilitation. The chosen doctors for adults and children work in two shifts on weekdays and also at weekends, while the gynaecology and obstetrics clinic is open on weekdays. The specialist clinics — ophthalmology, psychiatry, ENT and internal medicine — are open on weekdays from 7 am to 3 pm, alongside radiological diagnostics, the hygiene and epidemiology service and a haemodialysis centre. The centre also includes laboratory diagnostics, occupational medicine, a Centre for Lung Diseases and TB, a Mental Health Centre, home nursing, physical therapy, patient transport, population and reproductive health counselling, and inpatient wards for internal medicine, paediatrics and gynaecology with obstetrics. Doctors from Berane General Hospital — a physiatrist, a urologist, a surgeon and an orthopaedist — also see patients here as supplementary work. Call centre: 067 004 666.',
	description_de = 'Dom zdravlja Rožaje ist das Zentrum der primären Gesundheitsversorgung für die Einwohner von Rozaje und Umgebung – Prävention, Diagnostik, Behandlung und Rehabilitation. Die gewählten Ärzte für Erwachsene und Kinder arbeiten werktags in zwei Schichten und auch am Wochenende, die gynäkologisch-geburtshilfliche Ambulanz werktags. Die Facharztambulanzen für Augenheilkunde, Psychiatrie, HNO und Innere Medizin sind werktags von 7 bis 15 Uhr geöffnet; dazu kommen Röntgendiagnostik, der hygienisch-epidemiologische Dienst und ein Hämodialysezentrum. Zum Gesundheitszentrum gehören außerdem Labordiagnostik, Arbeitsmedizin, ein Zentrum für Lungenkrankheiten und Tuberkulose, ein Zentrum für psychische Gesundheit, Hauskrankenpflege, Physiotherapie, Krankentransport, Beratungsstellen für Bevölkerungs- und reproduktive Gesundheit sowie stationäre Abteilungen für Innere Medizin, Kinderheilkunde und Gynäkologie mit Geburtshilfe. Im Rahmen einer Nebentätigkeit behandeln hier auch Fachärzte des Allgemeinen Krankenhauses Berane für physikalische Medizin, Urologie, Chirurgie und Orthopädie. Callcenter: 067 004 666.',
	description_tr = 'Dom zdravlja Rožaje, Rozaje ve çevresinde yaşayanlar için koruyucu hizmetler, tanı, tedavi ve rehabilitasyon sunan birinci basamak sağlık kuruluşudur. Yetişkinler ve çocuklar için seçilmiş hekimler hafta içi iki vardiya halinde ve hafta sonu da çalışır; kadın hastalıkları ve doğum polikliniği hafta içi hizmet verir. Göz, psikiyatri, KBB ve dahiliye uzman poliklinikleri hafta içi 07.00–15.00 saatleri arasında açıktır; ayrıca radyolojik tanı, hijyen ve epidemiyoloji servisi ile hemodiyaliz merkezi bulunur. Bünyesinde laboratuvar tanı, iş sağlığı, akciğer hastalıkları ve tüberküloz merkezi, ruh sağlığı merkezi, evde bakım hemşireliği, fizik tedavi, hasta nakli, toplum sağlığı ve üreme sağlığı danışmanlıkları ile dahiliye, çocuk ve kadın doğum yatan hasta servisleri de yer alır. Ek çalışma kapsamında Berane Genel Hastanesi''nden fizik tedavi, üroloji, genel cerrahi ve ortopedi uzmanları da burada hasta kabul eder. Çağrı merkezi: 067 004 666.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 (как у всех ДЗ в БД)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- Языки клиники: только SR — сайт только на черногорском, о других языках не пишет.
-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: /kontakt/ (2026-09-09) «Pon – Pet: 07:00 – 21:00, Subota: 08:00 – 15:00». Воскресенье
-- /kontakt/ не называет; /organizacione-jedinice/ (2026-07-08) у команд izabranih doktora
-- «Vikendom 08:00 – 15:00», /radno-vrijeme/ (2026-04-01) «Sub – Ned / Praznici 08:00 – 14:00,
-- Radi vikendom». Взято 08:00–15:00 по более свежей странице (расхождение — в записи импорта).
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "15:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "15:00"}]}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Существующие — только привязка; новые — «найти или создать» по slug.
-- Специальности — по формулировке сайта; spec. opšte medicine и «doktor medicine» → general_medicine,
-- эпидемиолог → infectious_diseases (правила ДЗ). photo_url — только у директора.
-- ═══════════════════════════════════════════════════════════════

-- ── 3.1 Уже в БД (ОБ Беране, opsta-bolnica-berane) — только привязка (4) ──

-- Vanja Vukićević — /organizacione-jedinice/ «Dopunski rad doktora — Doktori iz drugih ustanova: Fizijatar — OB Berane, dr Vanja Vukićević», /ugovori-o-dopunskom-radu/ (последний договор 12.2025–05.2026). В БД — OB Berane, Physical Medicine and Rehabilitation
SET @d = (SELECT id FROM doctors WHERE slug = 'vanja-vukicevic' LIMIT 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Fizijatar (OB Berane), dopunski rad' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Tanja Cimbaljević — /organizacione-jedinice/ «Urolog — OB Berane, dr Tanja Cimbaljević». В БД — OB Berane, urology
SET @d = (SELECT id FROM doctors WHERE slug = 'tanja-cimbaljevic' LIMIT 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Urolog (OB Berane), dopunski rad' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Igor Babić — /organizacione-jedinice/ «Hirurg — OB Berane, dr Igor Babić». В БД — OB Berane, general_surgery
SET @d = (SELECT id FROM doctors WHERE slug = 'igor-babic' LIMIT 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Hirurg (OB Berane), dopunski rad' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Saša Novović — /organizacione-jedinice/ «Ortoped — OB Berane, dr Saša Novović». В БД — OB Berane, orthopedics_traumatology
SET @d = (SELECT id FROM doctors WHERE slug = 'sasa-novovic' LIMIT 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Ortoped (OB Berane), dopunski rad' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ── 3.2 Новые (16) ──

-- Asad Kalač — /organizacione-jedinice/ «Direktor — Specijalista interne medicine, Dr Asad Kalač» (фото карточки), «Interno odjeljenje — Internista dr Asad Kalač», /specijalisticke-ambulante/ «Internistička ambulanta — spec. interne medicine Asad Kalač»
SET @d = (SELECT id FROM doctors WHERE slug = 'asad-kalac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'asad-kalac', 'Asad Kalač', 'Асад Калач', 'Асад Калач', 'Asad Kalac', 'Dr', 'https://dzrozaje.me/wp-content/uploads/2026/07/direktor.jpeg.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'asad-kalac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'internal_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Direktor; Internistička ambulanta, Interno odjeljenje' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jaho Pepić — /organizacione-jedinice/ «Timovi — Medicina rada, Tim 1: Spec. medicine rada, dr Jaho Pepić»
SET @d = (SELECT id FROM doctors WHERE slug = 'jaho-pepic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jaho-pepic', 'Jaho Pepić', 'Јахо Пепић', 'Яхо Пепич', 'Jaho Pepic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jaho-pepic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'occupational_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Medicina rada, tim 1' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Fikret Mujević — /organizacione-jedinice/ «Tim 2: Spec. medicine rada, dr Fikret Mujević»
SET @d = (SELECT id FROM doctors WHERE slug = 'fikret-mujevic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'fikret-mujevic', 'Fikret Mujević', 'Фикрет Мујевић', 'Фикрет Муевич', 'Fikret Mujevic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'fikret-mujevic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'occupational_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Medicina rada, tim 2' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jasmin Sutović — /organizacione-jedinice/ «Tim 3: Spec. opšte medicine, dr Jasmin Sutović» → general_medicine
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmin-sutovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasmin-sutovic', 'Jasmin Sutović', 'Јасмин Сутовић', 'Ясмин Сутович', 'Jasmin Sutovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jasmin-sutovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Medicina rada, tim 3' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Almir Honsić — /organizacione-jedinice/ «Tim 4: Doktor medicine, dr Almir Honsić» → general_medicine
SET @d = (SELECT id FROM doctors WHERE slug = 'almir-honsic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'almir-honsic', 'Almir Honsić', 'Алмир Хонсић', 'Альмир Хонсич', 'Almir Honsic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'almir-honsic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Medicina rada, tim 4' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Mehmed Kurpejović — /organizacione-jedinice/ «Timovi — Izabrani doktor za djecu, Tim 1: Spec. pedijatar, dr Mehmed Kurpejović»
SET @d = (SELECT id FROM doctors WHERE slug = 'mehmed-kurpejovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mehmed-kurpejovic', 'Mehmed Kurpejović', 'Мехмед Курпејовић', 'Мехмед Курпеевич', 'Mehmed Kurpejovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mehmed-kurpejovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, tim 1' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Nervija Dedeić — /organizacione-jedinice/ «Tim 2: Spec. pedijatar, dr Nervija Dedeić», «Dječije odjeljenje — Pedijatar dr Nervija Dedeić»
SET @d = (SELECT id FROM doctors WHERE slug = 'nervija-dedeic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nervija-dedeic', 'Nervija Dedeić', 'Нервија Дедеић', 'Нервия Дедеич', 'Nervija Dedeic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nervija-dedeic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, tim 2; Dječije odjeljenje' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Mirsad Hodžić — /organizacione-jedinice/ «Tim 3: Spec. pedijatar, dr Mirsad Hodžić»
SET @d = (SELECT id FROM doctors WHERE slug = 'mirsad-hodzic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirsad-hodzic', 'Mirsad Hodžić', 'Мирсад Хоџић', 'Мирсад Ходжич', 'Mirsad Hodzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mirsad-hodzic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, tim 3' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Senad Lukač — /organizacione-jedinice/ «Tim 4: Spec. pedijatar, dr Senad Lukač»
SET @d = (SELECT id FROM doctors WHERE slug = 'senad-lukac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'senad-lukac', 'Senad Lukač', 'Сенад Лукач', 'Сенад Лукач', 'Senad Lukac', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'senad-lukac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu, tim 4' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Azra Lukač — /organizacione-jedinice/ «Tim — Ginekološko akušerska ambulanta, Ginekolog prim. dr sci. Azra Lukač», /specijalisticke-ambulante/
SET @d = (SELECT id FROM doctors WHERE slug = 'azra-lukac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'azra-lukac', 'Azra Lukač', 'Азра Лукач', 'Азра Лукач', 'Azra Lukac', 'Prim. dr sci.', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'azra-lukac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Ginekološko-akušerska ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Almina Dacić — /organizacione-jedinice/ «Bolnički odjeli — Ginekologija i akušerstvo, Ginekolog dr Almina Dacić»
SET @d = (SELECT id FROM doctors WHERE slug = 'almina-dacic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'almina-dacic', 'Almina Dacić', 'Алмина Дацић', 'Альмина Дацич', 'Almina Dacic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'almina-dacic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Ginekologija i akušerstvo (bolničko odjeljenje)' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Saimir Markišić — /specijalisticke-ambulante/ «Oftalmološka ambulanta — dr mr. spec. oftalmolog Saimir Markišić», /organizacione-jedinice/ также в «Dopunski rad unutar DZ — Medicina rada»
SET @d = (SELECT id FROM doctors WHERE slug = 'saimir-markisic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'saimir-markisic', 'Saimir Markišić', 'Саимир Маркишић', 'Саимир Маркишич', 'Saimir Markisic', 'Mr dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'saimir-markisic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'ophthalmology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Oftalmološka ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sead Nurković — /specijalisticke-ambulante/ «Psihijatrijska ambulanta — spec. psihijatar dr Sead Nurković», /organizacione-jedinice/ также в «Dopunski rad unutar DZ — Medicina rada»
SET @d = (SELECT id FROM doctors WHERE slug = 'sead-nurkovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sead-nurkovic', 'Sead Nurković', 'Сеад Нурковић', 'Сеад Нуркович', 'Sead Nurkovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sead-nurkovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Psihijatrijska ambulanta' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sajma Pepić — /specijalisticke-ambulante/ «Radiološka dijagnostika — spec. radiolog dr Sajma Pepić»
SET @d = (SELECT id FROM doctors WHERE slug = 'sajma-pepic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sajma-pepic', 'Sajma Pepić', 'Сајма Пепић', 'Сайма Пепич', 'Sajma Pepic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sajma-pepic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'radiology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Radiološka dijagnostika' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sadat Šutković — /specijalisticke-ambulante/ «Higijensko epidemiološka služba — spec. epidemiolog Sadat Šutković» (без «dr» — титул не ставится), эпидемиолог → infectious_diseases (правило ДЗ)
SET @d = (SELECT id FROM doctors WHERE slug = 'sadat-sutkovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sadat-sutkovic', 'Sadat Šutković', 'Садат Шутковић', 'Садат Шуткович', 'Sadat Sutkovic', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sadat-sutkovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'infectious_diseases' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Higijensko-epidemiološka služba, spec. epidemiolog' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Semir Murić — /specijalisticke-ambulante/ «Centar za hemodijalizu — spec. interne medicine Semir Murić» (без «dr» — титул не ставится)
SET @d = (SELECT id FROM doctors WHERE slug = 'semir-muric' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'semir-muric', 'Semir Murić', 'Семир Мурић', 'Семир Мурич', 'Semir Muric', NULL, NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'semir-muric' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'internal_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za hemodijalizu, spec. interne medicine' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 17, status = published, languages = 1, types = 1, hours = 1.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 20 врачей; у каждого есть специальность и язык sr.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, dc.position,
	(SELECT GROUP_CONCAT(s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
	(SELECT GROUP_CONCAT(l.code) FROM doctor_languages dl JOIN languages l ON l.id = dl.language_id WHERE dl.doctor_id = d.id) AS languages,
	(SELECT GROUP_CONCAT(c2.slug) FROM doctor_clinics dc2 JOIN clinics c2 ON c2.id = dc2.clinic_id WHERE dc2.doctor_id = d.id) AS clinics
FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @clinic_id
ORDER BY dc.position, d.name_sr;

-- Страховка: slug из этого файла, которых нет у клиники. Ожидается ПУСТО.
SELECT s.slug AS missing_doctor FROM (
	SELECT 'vanja-vukicevic' AS slug
	UNION ALL SELECT 'tanja-cimbaljevic' AS slug
	UNION ALL SELECT 'igor-babic' AS slug
	UNION ALL SELECT 'sasa-novovic' AS slug
	UNION ALL SELECT 'asad-kalac' AS slug
	UNION ALL SELECT 'jaho-pepic' AS slug
	UNION ALL SELECT 'fikret-mujevic' AS slug
	UNION ALL SELECT 'jasmin-sutovic' AS slug
	UNION ALL SELECT 'almir-honsic' AS slug
	UNION ALL SELECT 'mehmed-kurpejovic' AS slug
	UNION ALL SELECT 'nervija-dedeic' AS slug
	UNION ALL SELECT 'mirsad-hodzic' AS slug
	UNION ALL SELECT 'senad-lukac' AS slug
	UNION ALL SELECT 'azra-lukac' AS slug
	UNION ALL SELECT 'almina-dacic' AS slug
	UNION ALL SELECT 'saimir-markisic' AS slug
	UNION ALL SELECT 'sead-nurkovic' AS slug
	UNION ALL SELECT 'sajma-pepic' AS slug
	UNION ALL SELECT 'sadat-sutkovic' AS slug
	UNION ALL SELECT 'semir-muric' AS slug
) s
LEFT JOIN doctors d ON d.slug = s.slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

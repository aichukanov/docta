-- ═══════════════════════════════════════════════════════════════════════════
-- Dental Montenegro (Bečići, Budva) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-montenegro-budva.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/dental-montenegro-budva.json):
--   * https://www.dentalmontenegro.com/ (ME): /me, /me/o-nama, /me/usluge + 5 страниц услуг, /me/kontakt,
--     /me/dental-montenegro, /me/splendid-dental, /me/nase-ordinacije, /me/dental-turizam, /me/cijene, страницы 3 врачей.
--   * data/google-places/budva/center-for-dental-implantology-and-cosmetic-dentistry-dental.json — place_id, координаты.
-- Вторая ординация — Splendid Dental: server/sql/insert-clinic-splendid-dental-budva.sql.
-- Адрес: сайт «Dental Montenegro 1 — Alekse Šantića 1, 85310 Bečići» = Google «1 Alekse Šantića, Budva 85310».
-- Телефоны +382 33 472 935 и +382 67 211 777 — сайт; второй подтверждён Google.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJLcP15BbUTRMRC61qGgrhtCw';
SET @clinic_slug = 'dental-montenegro-budva';

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
	3, -- CityId.BUDVA (Bečići — town_sr, как medical-centar-budva)
	'Dental Montenegro',
	'Dental Montenegro',
	'Стоматология Dental Montenegro (Бечичи)',
	'Alekse Šantića 1',
	'Алексе Шантића 1',
	'Bečići',
	'Бечићи',
	'85310',
	42.28351500,
	18.86054750,
	'+38233472935;+38267211777',
	'dentalmontenegro@gmail.com',
	'https://www.dentalmontenegro.com/',
	'facebook.com/centar-za-implantologiju-i-estetsku-stomatologiju-137164939630773',
	'@dental_montenegro',
	'',
	'',
	'',
	'https://www.dentalmontenegro.com/images/dental-montenegro-budva.svg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Dental Montenegro', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматология Dental Montenegro (Бечичи)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Alekse Šantića 1', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Алексе Шантића 1', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Bečići', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Бечићи', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85310', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38233472935;+38267211777', phone),
	email = IF(email IS NULL OR email = '', 'dentalmontenegro@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.dentalmontenegro.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/centar-za-implantologiju-i-estetsku-stomatologiju-137164939630773', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@dental_montenegro', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.dentalmontenegro.com/images/dental-montenegro-budva.svg', logo_url),
	latitude = COALESCE(latitude, 42.28351500),
	longitude = COALESCE(longitude, 18.86054750)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = '„Dental Montenegro“ (Center for Dental Implantology and Cosmetic Dentistry) nalazi se u Bečićima (Budva), u Ulici Alekse Šantića 1; druga ordinacija klinike, Splendid Dental, radi u hotelu Splendid SPA u Bečićima. Klinika je osnovana 2004. godine u hotelu „Maestral“ u Pržnu kao centar dentalne implantologije i estetske stomatologije i bavi se i dentalnim turizmom — za pacijente iz inostranstva organizuje smještaj i transfere. Ugrađuje isključivo implantate Nobel Biocare, uključujući imedijatnu ugradnju, radi fiksne ortodontske aparate, keramičke fasete i tretmane diodnim laserom Biolase EZlase, a za dijagnostiku koristi digitalni intraoralni rendgen Cefla i digitalni ortopan RayScan by Samsung. Pregled sa predračunom, konsultacije i savjet su besplatni.',
	description_sr_cyrl = '„Dental Montenegro“ (Center for Dental Implantology and Cosmetic Dentistry) налази се у Бечићима (Будва), у Улици Алексе Шантића 1; друга ординација клинике, Splendid Dental, ради у хотелу Splendid SPA у Бечићима. Клиника је основана 2004. године у хотелу „Maestral“ у Пржну као центар денталне имплантологије и естетске стоматологије и бави се и денталним туризмом — за пацијенте из иностранства организује смјештај и трансфере. Уграђује искључиво имплантате Nobel Biocare, укључујући имедијатну уградњу, ради фиксне ортодонтске апарате, керамичке фасете и третмане диодним ласером Biolase EZlase, а за дијагностику користи дигитални интраорални рендген Cefla и дигитални ортопан RayScan by Samsung. Преглед са предрачуном, консултације и савјет су бесплатни.',
	description_ru = '«Dental Montenegro» (Center for Dental Implantology and Cosmetic Dentistry) находится в Бечичи (Будва), на улице Алексы Шантича, 1; второй кабинет клиники, Splendid Dental, работает в отеле Splendid SPA в Бечичи. Клиника основана в 2004 году в отеле «Maestral» в Пржно как центр дентальной имплантологии и эстетической стоматологии и занимается также стоматологическим туризмом — организует для иностранных пациентов проживание и трансферы. Устанавливает только имплантаты Nobel Biocare, в том числе по методике одномоментной имплантации, ставит брекет-системы и керамические виниры, проводит лечение диодным лазером Biolase EZlase; для диагностики используются цифровой интраоральный рентген Cefla и цифровой ортопантомограф RayScan by Samsung. Осмотр с составлением сметы, консультации и рекомендации бесплатны.',
	description_en = 'Dental Montenegro (Center for Dental Implantology and Cosmetic Dentistry) is located in Bečići (Budva), at Alekse Šantića 1; the clinic''s second practice, Splendid Dental, operates at the Splendid SPA hotel in Bečići. The clinic was founded in 2004 at the Maestral hotel in Pržno as a centre for dental implantology and cosmetic dentistry and also works in dental tourism, arranging accommodation and transfers for patients from abroad. It places Nobel Biocare implants exclusively, including immediate implant placement, and offers fixed braces, ceramic veneers and treatments with a Biolase EZlase diode laser; diagnostics use a Cefla digital intraoral X-ray and a RayScan by Samsung digital panoramic unit. Examination with a cost estimate, consultations and advice are free of charge.',
	description_de = 'Dental Montenegro (Center for Dental Implantology and Cosmetic Dentistry) befindet sich in Bečići (Budva), Alekse Šantića 1; die zweite Praxis der Klinik, Splendid Dental, liegt im Hotel Splendid SPA in Bečići. Die Klinik wurde 2004 im Hotel Maestral in Pržno als Zentrum für Implantologie und ästhetische Zahnheilkunde gegründet und ist auch im Dentaltourismus tätig – für Patienten aus dem Ausland organisiert sie Unterkunft und Transfers. Sie setzt ausschließlich Nobel-Biocare-Implantate ein, auch als Sofortimplantation, und bietet feste Zahnspangen, Keramikveneers sowie Behandlungen mit dem Diodenlaser Biolase EZlase an; für die Diagnostik stehen ein digitales Intraoral-Röntgengerät von Cefla und ein digitales Panoramagerät RayScan by Samsung zur Verfügung. Untersuchung mit Kostenvoranschlag, Beratung und Empfehlungen sind kostenlos.',
	description_tr = 'Dental Montenegro (Center for Dental Implantology and Cosmetic Dentistry), Bečići''de (Budva) Alekse Šantića 1 adresindedir; kliniğin ikinci muayenehanesi Splendid Dental, Bečići''deki Splendid SPA otelinde hizmet verir. Klinik 2004''te Pržno''daki Maestral otelinde bir implantoloji ve estetik diş hekimliği merkezi olarak kuruldu; diş turizmiyle de ilgilenir ve yurt dışından gelen hastalar için konaklama ve transfer ayarlar. Yalnızca Nobel Biocare implantları uygulanır (anında implantasyon dahil); sabit diş telleri, seramik lamina ve Biolase EZlase diyot lazerle tedaviler sunulur; teşhiste Cefla dijital intraoral röntgen ve RayScan by Samsung dijital panoramik cihaz kullanılır. Maliyet tahminli muayene, konsültasyon ve danışmanlık ücretsizdir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: /me/kontakt и /me/dental-montenegro: «Pon - Pet: 09h - 18h, Sub: zatvoreno, Ned: zatvoreno».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "18:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3)
-- Состав — /me/o-nama «Naš tim» + страницы врачей: 3 врача. Сайт не делит команду между Dental Montenegro и Splendid
-- Dental — все трое привязаны к обеим ординациям. Bojana Ivanović уже в БД (id 467, Vadis) — тот же человек
-- (то же фото), только привязка. Branko Atanasovski и Dragana Stevović Bjelica есть лишь в старом sitemap
-- (dental.creatiwwwa.me) — на текущем сайте их нет, не заводятся.
-- Специальности: 74 = ORAL_SURGERY, 78 = DENTISTRY, 93 = ORTHODONTIST. Языки: 1 = SR, 3 = EN, 6 = DE.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Prof. dr Zoran Lazić — Specijalista oralne hirurgije (implantologija)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Zoran Lazić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lazić Zoran' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zoran-lazic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-lazic', 'Zoran Lazić', 'Зоран Лазић', 'Зоран Лазич', 'Zoran Lazic', 'Prof. dr',
	'https://www.dentalmontenegro.com/fajlovi/o_1f1v0qj6m614rbi139m3kq21na.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista oralne hirurgije od 1993. godine, doktor nauka iz oblasti oralne implantologije i faktora rasta (2004). Rođen je 1963. godine; diplomirao je na Stomatološkom fakultetu u Beogradu. Od početka karijere radi na odjeljenju za implantologiju Vojnomedicinske akademije u Beogradu, a trenutno je načelnik Klinike za stomatologiju VMA. Predavač je na postdiplomskim studijama Medicinskog fakulteta Univerziteta odbrane i na stomatološkim fakultetima u Kosovskoj Mitrovici i Kragujevcu. Član je Akademije medicinskih nauka Srpskog lekarskog društva i bivši predsjednik sekcije za oralnu implantologiju SLD, zvanični predavač implantatnih sistema Nobel Biocare, Zimmer Biomet, Implant Direct i B&B Dental i član Evropske asocijacije za oseointegraciju.',
	description_sr_cyrl = 'Специјалиста оралне хирургије од 1993. године, доктор наука из области оралне имплантологије и фактора раста (2004). Рођен је 1963. године; дипломирао је на Стоматолошком факултету у Београду. Од почетка каријере ради на одјељењу за имплантологију Војномедицинске академије у Београду, а тренутно је начелник Клинике за стоматологију VMA. Предавач је на постдипломским студијама Медицинског факултета Универзитета одбране и на стоматолошким факултетима у Косовској Митровици и Крагујевцу. Члан је Академије медицинских наука Српског лекарског друштва и бивши предсједник секције за оралну имплантологију SLD, званични предавач имплантатних система Nobel Biocare, Zimmer Biomet, Implant Direct и B&B Dental и члан Европске асоцијације за осеоинтеграцију.',
	description_ru = 'Специалист по хирургической стоматологии с 1993 года, доктор наук в области дентальной имплантологии и факторов роста (2004). Родился в 1963 году; окончил стоматологический факультет в Белграде. С начала карьеры работает в отделении имплантологии Военно-медицинской академии в Белграде, сейчас руководит стоматологической клиникой ВМА. Преподаёт на последипломных программах медицинского факультета Университета обороны и на стоматологических факультетах в Косовска-Митровице и Крагуеваце. Член Академии медицинских наук Сербского врачебного общества, бывший председатель его секции оральной имплантологии, официальный лектор имплантационных систем Nobel Biocare, Zimmer Biomet, Implant Direct и B&B Dental, член Европейской ассоциации остеоинтеграции.',
	description_en = 'Oral surgery specialist since 1993, with a doctorate in oral implantology and growth factors (2004). Born in 1963, he graduated from the School of Dentistry in Belgrade. Since the start of his career he has worked in the implantology department of the Military Medical Academy (VMA) in Belgrade and currently heads the VMA Dental Clinic. He lectures on postgraduate programmes at the Faculty of Medicine of the University of Defence and at the dental schools in Kosovska Mitrovica and Kragujevac. He is a member of the Academy of Medical Sciences of the Serbian Medical Society and former president of its oral implantology section, an official lecturer for the Nobel Biocare, Zimmer Biomet, Implant Direct and B&B Dental implant systems, and a member of the European Association for Osseointegration.',
	description_de = 'Facharzt für Oralchirurgie seit 1993, promoviert im Bereich orale Implantologie und Wachstumsfaktoren (2004). Geboren 1963, studierte er Zahnmedizin in Belgrad. Seit Beginn seiner Laufbahn arbeitet er in der Implantologie-Abteilung der Militärmedizinischen Akademie (VMA) in Belgrad und leitet derzeit deren Zahnklinik. Er lehrt in Postgraduiertenprogrammen der Medizinischen Fakultät der Universität der Verteidigung sowie an den zahnmedizinischen Fakultäten in Kosovska Mitrovica und Kragujevac. Er ist Mitglied der Akademie der medizinischen Wissenschaften der Serbischen Ärztegesellschaft und ehemaliger Vorsitzender ihrer Sektion für orale Implantologie, offizieller Referent für die Implantatsysteme Nobel Biocare, Zimmer Biomet, Implant Direct und B&B Dental sowie Mitglied der European Association for Osseointegration.',
	description_tr = '1993''ten beri ağız cerrahisi uzmanı; oral implantoloji ve büyüme faktörleri alanında doktora sahibi (2004). 1963''te doğdu, Belgrad Diş Hekimliği Fakültesinden mezun oldu. Kariyerinin başından beri Belgrad Askeri Tıp Akademisinin (VMA) implantoloji bölümünde çalışıyor ve şu anda VMA Diş Kliniğinin başhekimidir. Savunma Üniversitesi Tıp Fakültesinin lisansüstü programlarında ve Kosovska Mitrovica ile Kragujevac diş hekimliği fakültelerinde ders verir. Sırp Tabipler Derneği Tıp Bilimleri Akademisi üyesi ve derneğin oral implantoloji bölümünün eski başkanı; Nobel Biocare, Zimmer Biomet, Implant Direct ve B&B Dental implant sistemlerinin resmi eğitmeni ve Avrupa Osseointegrasyon Derneği üyesidir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije (implantologija)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr spec. Bojan Škufca — Specijalista ortopedije vilica
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Bojan Škufca' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Škufca Bojan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'bojan-skufca' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bojan-skufca', 'Bojan Škufca', 'Бојан Шкуфца', 'Боян Шкуфца', 'Bojan Skufca', 'Dr spec.',
	'https://www.dentalmontenegro.com/fajlovi/p1ab7611su1v481she1ot6kit1io01.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista ortopedije vilica. Rođen je 1962. u Ljubljani. Stomatološki fakultet završio je u Beogradu; specijalista ortopedije vilica je od 2000. godine, a od 2004. načelnik odjeljenja za ortopediju vilica na Vojnomedicinskoj akademiji u Beogradu. Autor je više od 12 stručnih radova; član je Udruženja ortodonata Srbije, Balkanskog udruženja stomatologa i Ljekarske komore Slovenije.',
	description_sr_cyrl = 'Специјалиста ортопедије вилица. Рођен је 1962. у Љубљани. Стоматолошки факултет завршио је у Београду; специјалиста ортопедије вилица је од 2000. године, а од 2004. начелник одјељења за ортопедију вилица на Војномедицинској академији у Београду. Аутор је више од 12 стручних радова; члан је Удружења ортодоната Србије, Балканског удружења стоматолога и Љекарске коморе Словеније.',
	description_ru = 'Специалист-ортодонт. Родился в 1962 году в Любляне. Окончил стоматологический факультет в Белграде; специалист по ортодонтии с 2000 года, с 2004 года руководит отделением ортодонтии Военно-медицинской академии в Белграде. Автор более 12 научных работ; член Ассоциации ортодонтов Сербии, Балканской ассоциации стоматологов и Врачебной палаты Словении.',
	description_en = 'Orthodontist. Born in 1962 in Ljubljana, he graduated from the School of Dentistry in Belgrade. He has been an orthodontic specialist since 2000 and since 2004 has headed the orthodontics department of the Military Medical Academy in Belgrade. He has authored more than 12 professional papers and is a member of the Serbian Orthodontic Society, the Balkan Stomatological Society and the Medical Chamber of Slovenia.',
	description_de = 'Facharzt für Kieferorthopädie. Geboren 1962 in Ljubljana, studierte er Zahnmedizin in Belgrad. Seit 2000 ist er Facharzt für Kieferorthopädie und leitet seit 2004 die kieferorthopädische Abteilung der Militärmedizinischen Akademie in Belgrad. Er ist Autor von mehr als 12 Fachpublikationen und Mitglied der Serbischen Kieferorthopädischen Gesellschaft, der Balkanischen Zahnärztlichen Gesellschaft und der Ärztekammer Sloweniens.',
	description_tr = 'Ortodonti uzmanı. 1962''de Ljubljana''da doğdu, Belgrad Diş Hekimliği Fakültesinden mezun oldu. 2000''den beri ortodonti uzmanıdır ve 2004''ten beri Belgrad Askeri Tıp Akademisinin ortodonti bölümünü yönetmektedir. 12''den fazla mesleki yayının yazarıdır; Sırbistan Ortodontistler Derneği, Balkan Diş Hekimleri Derneği ve Slovenya Tabip Odası üyesidir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Bojana Ivanović — Konzervativna stomatologija, endodoncija, estetska stomatologija, protetika
-- ───────────────────────────────────────────────────────────────
-- Уже в БД: id 467, стоматолог (78), клиника vadis-stomatologija-podgorica (#33, сайт vadis.me в режиме
-- обслуживания). Фото в БД (/uploads/doctors/0f3978f6-….webp, 430×700) — тот же снимок, что
-- /fajlovi/o_1c97ka5ccqlt1q1k105l1vcftc5a.jpg на dentalmontenegro.com (размер = превью tumber.php w=430&h=700),
-- т.е. карточку изначально заводили по этому сайту. Тот же человек; только привязка, поля не трогаем (языки
-- RU/EN у неё уже есть).
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'bojana-ivanovic' LIMIT 1);
SELECT IF(@doctor_id IS NULL, 'WARNING: врач bojana-ivanovic не найден — привязка пропущена', CONCAT('OK: bojana-ivanovic = ', @doctor_id)) AS doctor_check;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @doctor_id, @clinic_id, 'Konzervativna stomatologija, endodoncija, estetska stomatologija, protetika' FROM dual WHERE @doctor_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 3, status = published, clinic_languages = 1, clinic_types = 2, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3 врач(а/ей): zoran-lazic, bojan-skufca, bojana-ivanovic.
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

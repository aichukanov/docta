-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Dr Vuksanović (Bar) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-dr-vuksanovic-bar.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/poliklinika-dr-vuksanovic-bar.json):
--   * https://drvuksanovic.me/ — WordPress, WP REST: pages (naslovna 2026-08-29, o-nama 2026-06-27, kontakt/bar
--     2024-12-01, kontakt/ulcinj 2021-04, preporuke 2020-08), posts (7).
--   * https://drvuksanovic.me/wp-content/uploads/dokumenti/Raspored-zdravstvenih-radnika.pdf
--     («Godina: 2026», подписан 07.09.2026) — состав; «Mjesecni-raspored-rada.pdf» (октябрь 2026),
--     «Odluka-o-radnom-vremenu.pdf» (10.09.2025). ⚠️ Шрифт PDF теряет ć/Ć/đ/Đ, č/š/ž → c/s/z.
--   * data/google-places/bar/poliklinika-dr-vuksanovic.json — place_id, координаты, телефон.
--
-- Сеть: Бар (лаборатория + медицина труда) и лаборатория в Ульцине — у нас отдельными клиниками;
-- Ulcinj — server/sql/insert-clinic-poliklinika-dr-vuksanovic-ulcinj.sql (без врачей: PDF их по Ульциню не разносит).
-- Сверка: адрес «Poslovni centar “Topolica” G-9, 85000 Bar» (/kontakt/bar/) = Google «Topolica G9».
-- Телефоны: +382 30 315 900 (сайт + Google), лаборатория +382 69 038 130, медицина труда +382 68 896 900.
--
-- Идемпотентно и самоисправляюще: клиника по google_place_id → slug; врачи по name_sr / перевёрнутому
-- имени / slug. Пустые поля существующих записей дозаполняются, непустые не трогаются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJWw0mSQB0ThMRp5kv75bb8rg';
SET @clinic_slug = 'poliklinika-dr-vuksanovic-bar';

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
	7, -- CityId.BAR
	'Poliklinika Dr Vuksanović Bar',
	'Поликлиника Др Вуксановић (Бар)',
	'Поликлиника Dr Vuksanović (Бар)',
	'Poslovni centar Topolica G-9',
	'Пословни центар Тополица Г-9',
	'',
	'',
	'85000',
	42.09946440,
	19.09468850,
	'+38230315900;+38269038130;+38268896900',
	'info@drvuksanovic.me',
	'https://drvuksanovic.me/',
	'',
	'',
	'',
	'',
	'',
	'https://drvuksanovic.me/wp-content/uploads/2020/09/Poliklinika-Dr-Vuksanovic-Logo.jpg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Др Вуксановић (Бар)', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Dr Vuksanović (Бар)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Poslovni centar Topolica G-9', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Пословни центар Тополица Г-9', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38230315900;+38269038130;+38268896900', phone),
	email = IF(email IS NULL OR email = '', 'info@drvuksanovic.me', email),
	website = IF(website IS NULL OR website = '', 'https://drvuksanovic.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://drvuksanovic.me/wp-content/uploads/2020/09/Poliklinika-Dr-Vuksanovic-Logo.jpg', logo_url),
	latitude = COALESCE(latitude, 42.09946440),
	longitude = COALESCE(longitude, 19.09468850)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Poliklinika u Baru, u Poslovnom centru Topolica. Osnovana je 1999. godine kao biohemijska laboratorija; mikrobiološka laboratorija radi od 2003, a služba medicine rada od 2016. godine. Laboratorija radi hematološke, biohemijske, imunološke i alergološke analize, analize hormona i tumorskih markera i mikrobiološka ispitivanja na automatizovanim analizatorima, uz sopstveni laboratorijski informacioni sistem. Medicina rada obavlja preglede radi izdavanja ljekarskih uvjerenja — za zasnivanje radnog odnosa, vozače svih kategorija i instruktore, upravljanje čamcem, spasioce i ronioce, nabavku i nošenje vatrenog oružja, sportiste i pomorce — kao i sistematske, prethodne i periodične preglede radnika. Osnivačica i direktorica je prim. dr sci. med. Milica Vuksanović, specijalista medicinske biohemije. Poliklinika od maja 2025. ima sertifikat MEST EN ISO 9001:2016, a laboratorija radi i u Ulcinju.',
	description_sr_cyrl = 'Поликлиника у Бару, у Пословном центру Тополица. Основана је 1999. године као биохемијска лабораторија; микробиолошка лабораторија ради од 2003, а служба медицине рада од 2016. године. Лабораторија ради хематолошке, биохемијске, имунолошке и алерголошке анализе, анализе хормона и туморских маркера и микробиолошка испитивања на аутоматизованим анализаторима, уз сопствени лабораторијски информациони систем. Медицина рада обавља прегледе ради издавања љекарских увјерења — за заснивање радног односа, возаче свих категорија и инструкторе, управљање чамцем, спасиоце и рониоце, набавку и ношење ватреног оружја, спортисте и поморце — као и систематске, претходне и периодичне прегледе радника. Оснивачица и директорица је прим. др сци. мед. Милица Вуксановић, специјалиста медицинске биохемије. Поликлиника од маја 2025. има сертификат MEST EN ISO 9001:2016, а лабораторија ради и у Улцињу.',
	description_ru = 'Поликлиника в Баре, в бизнес-центре «Тополица». Основана в 1999 году как биохимическая лаборатория; микробиологическая лаборатория работает с 2003 года, служба медицины труда — с 2016 года. Лаборатория выполняет гематологические, биохимические, иммунологические и аллергологические анализы, исследования гормонов и онкомаркеров, микробиологические исследования на автоматических анализаторах с собственной лабораторной информационной системой. Служба медицины труда проводит осмотры для выдачи медицинских справок — для трудоустройства, водителей всех категорий и инструкторов, управления лодкой, спасателей и дайверов, приобретения и ношения оружия, спортсменов и моряков, — а также профилактические, предварительные и периодические осмотры работников. Основатель и директор — примариус доктор медицинских наук Милица Вуксанович, специалист по медицинской биохимии. С мая 2025 года у поликлиники есть сертификат MEST EN ISO 9001:2016; лаборатория работает и в Ульцине.',
	description_en = 'A polyclinic in Bar, in the Topolica business centre. It was founded in 1999 as a biochemistry laboratory; a microbiology laboratory has operated since 2003 and an occupational medicine service since 2016. The laboratory performs haematology, biochemistry, immunology and allergy tests, hormone and tumour marker tests and microbiological testing on automated analysers, with its own laboratory information system. The occupational medicine service carries out examinations for medical certificates — for employment, drivers of all categories and driving instructors, boat operation, lifeguards and divers, purchasing and carrying firearms, athletes and seafarers — as well as routine, pre-employment and periodic examinations of workers. The founder and director is Prim. Dr Milica Vuksanović, PhD, a specialist in medical biochemistry. Since May 2025 the polyclinic has held MEST EN ISO 9001:2016 certification, and the laboratory also operates in Ulcinj.',
	description_de = 'Poliklinik in Bar im Geschäftszentrum Topolica. Sie wurde 1999 als biochemisches Labor gegründet; seit 2003 gibt es ein mikrobiologisches Labor, seit 2016 einen arbeitsmedizinischen Dienst. Das Labor führt hämatologische, biochemische, immunologische und allergologische Untersuchungen, Hormon- und Tumormarkeranalysen sowie mikrobiologische Untersuchungen auf automatisierten Analysegeräten mit eigenem Laborinformationssystem durch. Der arbeitsmedizinische Dienst nimmt Untersuchungen für ärztliche Bescheinigungen vor — für die Arbeitsaufnahme, Fahrer aller Klassen und Fahrlehrer, das Führen von Booten, Rettungsschwimmer und Taucher, Erwerb und Tragen von Schusswaffen, Sportler und Seeleute — sowie Vorsorge-, Einstellungs- und periodische Untersuchungen von Arbeitnehmern. Gründerin und Direktorin ist Prim. Dr. sc. med. Milica Vuksanović, Fachärztin für medizinische Biochemie. Seit Mai 2025 ist die Poliklinik nach MEST EN ISO 9001:2016 zertifiziert; das Labor ist auch in Ulcinj tätig.',
	description_tr = 'Bar''da Topolica iş merkezinde bir poliklinik. 1999''da biyokimya laboratuvarı olarak kuruldu; mikrobiyoloji laboratuvarı 2003''ten, iş sağlığı birimi 2016''dan beri faaliyettedir. Laboratuvar; hematoloji, biyokimya, immünoloji ve alerji testleri, hormon ve tümör belirteci analizleri ile mikrobiyolojik incelemeleri kendi laboratuvar bilgi sistemine bağlı otomatik analizörlerde yapar. İş sağlığı birimi; işe giriş, her sınıftan sürücüler ve sürücü eğitmenleri, tekne kullanımı, cankurtaran ve dalgıçlar, ateşli silah edinme ve taşıma, sporcular ve denizciler için sağlık raporu muayeneleri ile çalışanların genel, işe giriş ve periyodik muayenelerini yapar. Kurucusu ve müdürü tıbbi biyokimya uzmanı Prim. Dr. Milica Vuksanović''tir. Poliklinik Mayıs 2025''ten beri MEST EN ISO 9001:2016 sertifikasına sahiptir; laboratuvar Ulcinj''de de hizmet verir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 (лаборатория + медицина труда), DIAGNOSTIC_LABORATORY = 4
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1), (@clinic_id, 4);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт (латиница/кириллица) других языков не заявляет → только SR.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- «Odluka o radnom vremenu» (PDF, 10.09.2025): «Laboratorija Bar Ponedjeljak – Petak 07 – 16, Subota 07 – 14»; «Medicina rada Bar Ponedjeljak – Petak 07 – 15» (на /kontakt/bar/ — 08–14). В карточку — часы лаборатории.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "14:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (7)
-- Состав — PDF «Raspored zdravstvenih radnika» (2026): 6 врачей-специалистов + психолог; техники, сёстры,
-- гигиенистка — не заводятся. Специальности: 39 = CLINICAL_BIOCHEMISTRY, 40 = MICROBIOLOGY,
-- 50 = OCCUPATIONAL_MEDICINE, 21 = PSYCHIATRY, 22 = PSYCHOLOGY. Языки: 1 = SR. Фото и био на сайте нет.
-- Найдены в БД (2): aleksandar-macic, andrija-cetkovic. Новые (5): milica-vuksanovic, savo-vuksanovic,
-- slobodan-dukic, miodrag-bulatovic, mersiha-fetahovic (прод-API 204 по обоим порядкам имени; djukic-* — тоже 204).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Prim. dr sci. med. Milica Vuksanović — specijalista medicinske biohemije, osnivačica i direktorica
-- /o-nama/: «Osnivačica i direktorica je Prim. dr sci. med. Milica Vuksanović, specijalistkinja medicinske biohemije».
-- Медицинской биохимии в enum нет → CLINICAL_BIOCHEMISTRY (39), как у остальных биохимиков в БД.
-- Однофамилица Aleksandra Vuksanović Božarić (гинеколог, Natal) — другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milica Vuksanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vuksanović Milica' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milica-vuksanovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milica-vuksanovic', 'Milica Vuksanović', 'Милица Вуксановић', 'Милица Вуксанович', 'Milica Vuksanovic', 'Prim. dr sci. med.',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 39);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Osnivačica i direktorica; specijalista medicinske biohemije (Biohemijska laboratorija)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Savo Vuksanović — specijalista kliničke biohemije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Savo Vuksanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vuksanović Savo' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'savo-vuksanovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'savo-vuksanovic', 'Savo Vuksanović', 'Саво Вуксановић', 'Саво Вуксанович', 'Savo Vuksanovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 39);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista kliničke biohemije (Biohemijska laboratorija)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Slobodan Dukić — specijalista mikrobiologije
-- ⚠️ Восстановлено из PDF, где шрифт теряет ć/đ: «Slobodan Duki». В тех же PDF č→c, š→s, ž→z,
-- а ć/Ć/đ/Đ выпадают целиком («Vuksanovi», «orije Sorovi» = Đorđije Šorović, «Skraenice»). Значит,
-- «D» — настоящая D (Đ бы выпала); сокращение в «Mjesečni raspored rada» — «S. D.» (у Đorđija —
-- «. S.»). Итог: Dukić, не Đukić (site-checks предполагал Đukić). В БД/проде нет ни того, ни другого.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Slobodan Dukić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Dukić Slobodan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'slobodan-dukic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'slobodan-dukic', 'Slobodan Dukić', 'Слободан Дукић', 'Слободан Дукич', 'Slobodan Dukic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 40);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista mikrobiologije (Mikrobiološka laboratorija)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Miodrag Bulatović — specijalista medicine rada
-- PDF: «Miodrag Bulatovi» — выпала только конечная ć, восстановление однозначно.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Miodrag Bulatović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bulatović Miodrag' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'miodrag-bulatovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'miodrag-bulatovic', 'Miodrag Bulatović', 'Миодраг Булатовић', 'Миодраг Булатович', 'Miodrag Bulatovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 50);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista medicine rada')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Aleksandar Mačić — specijalista psihijatrije (Medicina rada)
-- PDF: «Aleksandar Maci» — по правилам шрифта (č→c, ć выпадает) это Mačić или Macić. В БД есть
-- aleksandar-macic «Aleksandar Mačić», психиатр, ДЗ Котор (прод id 1140) — то же имя + та же специальность
-- (вместе с ним в ДЗ Котор и Andrija Ćetković, оба — психиатры медицины труда здесь) → привязка.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Mačić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mačić Aleksandar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aleksandar-macic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-macic', 'Aleksandar Mačić', 'Александар Мачић', 'Александар Мачич', 'Aleksandar Macic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista psihijatrije (Medicina rada)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Andrija Ćetković — specijalista psihijatrije (Medicina rada)
-- PDF: «Andrija etkovi» — первая буква выпала, значит Ć (Č шрифт даёт как C). В БД есть andrija-cetkovic
-- «Andrija Ćetković», психиатр, ДЗ Котор (прод id 1141) → привязка.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Andrija Ćetković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ćetković Andrija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'andrija-cetkovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andrija-cetkovic', 'Andrija Ćetković', 'Андрија Ћетковић', 'Андрия Четкович', 'Andrija Cetkovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista psihijatrije (Medicina rada)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Mersiha Fetahović — psihološkinja (Medicina rada)
-- PDF: «Mersiha Fetahovi, Psiholoskinja, Medicina rada». Психологи в БД заводятся карточками со
-- специальностью 22 и пустым титулом (jelena-pejovic, tijana-stanic …). Fehmija Fetahović-Feko (гинеколог) —
-- другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mersiha Fetahović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Fetahović Mersiha' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mersiha-fetahovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mersiha-fetahovic', 'Mersiha Fetahović', 'Мерсиха Фетаховић', 'Мерсиха Фетахович', 'Mersiha Fetahovic', NULL,
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 22);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Psiholog (Medicina rada)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 7, status = published, clinic_languages = 1, clinic_types = 1,4, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 7 карточек: aleksandar-macic и andrija-cetkovic — существующие; 5 новых, без фото и био.
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

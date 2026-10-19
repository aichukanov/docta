-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Mela Sana (Podgorica, Stari Aerodrom) — клиника + 13 врачей
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-mela-sana-podgorica.sql
-- Затем: server/sql/insert-clinic-poliklinika-mela-sana-podgorica-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://www.melasana.me/ — статический HTML-шаблон «MedService» (Jthemes), без CMS.
--     Прочитаны все внутренние страницы: index, about-us, who-we-are, all-services,
--     all-departments, all-doctors, faqs, contacts-1, gallery (about.html, service-1/2 — 404).
--     ⚠️ Last-Modified всех страниц — 29–30.06.2022: сайт не обновлялся ~4 года,
--     состав врачей и перечень услуг могли устареть.
--   * data/google-places/podgorica/mela-sana.json — place_id, координаты, телефон
--     (Google не перезапрашивался).
--
-- Сверка фактов:
--   * Адрес: сайт «Admirala Zmajevića 61, 81110 Podgorica» («na Starom Aerodromu»),
--     Google «61 Admirala Zmajevića, Podgorica 81000» — дом совпадает; индекс взят с сайта
--     (81110 — Stari Aerodrom).
--   * Координаты 42.4292745 / 19.2729261 — Google Places, единственный источник.
--   * Телефоны: шапка «067-344-888 | 069-134-888 | 020-26 11 48», FAQ «020-261-148»;
--     Google подтверждает первый. Ночные номера санитетского транспорта (069 220 743,
--     069 261 299) — только для транспорта после 20:00, в карточку не взяты.
--   * Email office@melasana.me, Facebook MelaSana-107724957745827, Instagram
--     @melasanapodgorica — футер всех страниц.
--   * Часы: «Pon - Sub: 8:00 - 20:00 / Nedelja: Zatvoreno» (все страницы).
--   * Языки клиники: только SR. Переключатель «EN» в шапке — пустая ссылка «#»,
--     приём на других языках сайт не заявляет.
--   * Тип: POLYCLINIC (1) — «Poliklinika Mela Sana», «ordinacija je 2022. godina prerasla
--     u polikliniku». «Laboratorija» есть только строкой в списке odjeljenja — тип
--     лаборатории не ставим (без перечня анализов, как у Feniks Medika).
--   * Логотип — images/logo.png (шапка).
--   * Партнёры «Naši partneri» — логотипы Sava osiguranje и Generali (файл delta.png):
--     связки «клиника ↔ страховая» в схеме нет, факт в описании.
--
-- Врачи — «Naš tim» (all-doctors.html), 13 врачей. НЕ заводятся: Milica Pušonjić и
-- mr Dragana Tvrdišić (dječiji psiholozi), Olga Popović (defektolog/logoped),
-- Vasilisa Maričević (medicinska sestra) — не врачи.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания клиники
-- пишутся безусловным UPDATE (правки из админки следующий прогон перезатрёт — вносить
-- сюда), языки и часы синхронизируются. Поля уже существующих врачей не перезаписываются:
-- фото — только если пусто, специальности — INSERT IGNORE (добавляются, не удаляются).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJz2FctqnrTRMRclWJwV6YtEM';
SET @clinic_slug = 'poliklinika-mela-sana-podgorica';

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
	'Poliklinika Mela Sana',
	'Поликлиника Мела Сана',
	'Поликлиника Мела Сана',
	'Admirala Zmajevića 61',
	'Адмирала Змајевића 61',
	'',
	'',
	'81110',
	42.42927450,
	19.27292610,
	'+38267344888;+38269134888;+38220261148',
	'office@melasana.me',
	'https://www.melasana.me/',
	'facebook.com/MelaSana-107724957745827',
	'@melasanapodgorica',
	'',
	'',
	'',
	'https://www.melasana.me/images/logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Мела Сана', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Мела Сана', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Admirala Zmajevića 61', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Адмирала Змајевића 61', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81110', postal_code),
	latitude        = COALESCE(latitude, 42.42927450),
	longitude       = COALESCE(longitude, 19.27292610),
	phone           = IF(phone IS NULL OR phone = '', '+38267344888;+38269134888;+38220261148', phone),
	email           = IF(email IS NULL OR email = '', 'office@melasana.me', email),
	website         = IF(website IS NULL OR website = '', 'https://www.melasana.me/', website),
	facebook        = IF(facebook IS NULL OR facebook = '', 'facebook.com/MelaSana-107724957745827', facebook),
	instagram       = IF(instagram IS NULL OR instagram = '', '@melasanapodgorica', instagram),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://www.melasana.me/images/logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что клиника пишет о себе: index
-- («Dobrodošli na Mela Sana»), about-us, who-we-are, вкладки all-services, all-departments,
-- блок «Naši partneri». Маркетинговые превосходные степени («sam vrh privatne medicinske
-- prakse», «najsavremenija oprema») не переносятся.
UPDATE clinics SET
	description_sr = 'Privatna zdravstvena ustanova na Starom Aerodromu u Podgorici, osnovana 2020. godine kao ordinacija opšte prakse, koja je 2022. godine prerasla u polikliniku sa specijalistima iz više oblasti. U poliklinici se obavljaju pregledi opšte prakse (sa snimanjem i očitavanjem EKG-a), hirurgija — uključujući male hirurške zahvate u lokalnoj anesteziji: uklanjanje mladeža, ateroma, fibroma, lipoma i ožiljaka — pedijatrija, mentalno zdravlje djece, interna medicina, neurologija, urologija, psihijatrija, onkologija i ORL. Ultrazvučna dijagnostika obuhvata abdomen i malu karlicu, urotrakt, dojke i pazušne jame, vrat i štitnu žlijezdu, meka tkiva, periferne regije i kolor dopler krvnih sudova; među odjeljenjima poliklinika navodi i rendgen dijagnostiku, kardiologiju i laboratoriju. Za odrasle su dostupne kućne posjete od 00 do 24h (pregled doktora opšte medicine, EKG, previjanje, skidanje konaca, zamjena katetera, infuzije i injekcije), a poliklinika organizuje i sanitetski transport pacijenata po Crnoj Gori i u inostranstvu. U ponudi su i Majersov koktel (intravenska infuzija vitamina i minerala) i sklerozacija kapilara. Kao partnere poliklinika navodi osiguravajuće kuće Sava osiguranje i Generali.',
	description_sr_cyrl = 'Приватна здравствена установа на Старом Аеродрому у Подгорици, основана 2020. године као ординација опште праксе, која је 2022. године прерасла у поликлинику са специјалистима из више области. У поликлиници се обављају прегледи опште праксе (са снимањем и очитавањем ЕКГ-а), хирургија — укључујући мале хируршке захвате у локалној анестезији: уклањање младежа, атерома, фиброма, липома и ожиљака — педијатрија, ментално здравље дјеце, интерна медицина, неурологија, урологија, психијатрија, онкологија и ОРЛ. Ултразвучна дијагностика обухвата абдомен и малу карлицу, уротракт, дојке и пазушне јаме, врат и штитну жлијезду, мека ткива, периферне регије и колор доплер крвних судова; међу одјељењима поликлиника наводи и рендген дијагностику, кардиологију и лабораторију. За одрасле су доступне кућне посјете од 00 до 24х (преглед доктора опште медицине, ЕКГ, превијање, скидање конаца, замјена катетера, инфузије и ињекције), а поликлиника организује и санитетски транспорт пацијената по Црној Гори и у иностранству. У понуди су и Мајерсов коктел (интравенска инфузија витамина и минерала) и склерозација капилара. Као партнере поликлиника наводи осигуравајуће куће Sava osiguranje и Generali.',
	description_ru = 'Частное медицинское учреждение в районе Стари Аэродром в Подгорице: основано в 2020 году как кабинет общей практики, а в 2022 году выросло в поликлинику со специалистами разных профилей. В поликлинике ведут приём врач общей практики (с записью и расшифровкой ЭКГ), хирург — в том числе малые операции под местной анестезией: удаление родинок, атером, фибром, липом и рубцов, — педиатр, специалисты по психическому здоровью детей, терапевт-интернист, невролог, уролог, психиатр, онколог и ЛОР. Ультразвуковая диагностика включает УЗИ брюшной полости и малого таза, мочевыводящих путей, молочных желёз и подмышечных областей, шеи и щитовидной железы, мягких тканей, периферических областей и цветное допплеровское исследование сосудов; среди отделений поликлиника называет также рентгенодиагностику, кардиологию и лабораторию. Для взрослых доступны выезды на дом круглосуточно (осмотр врача общей практики, ЭКГ, перевязки, снятие швов, замена катетера, капельницы и уколы), поликлиника также организует санитарную перевозку пациентов по Черногории и за рубеж. В числе услуг — коктейль Майерса (внутривенная инфузия витаминов и минералов) и склеротерапия капилляров. Партнёрами поликлиника называет страховые компании Sava osiguranje и Generali.',
	description_en = 'A private healthcare institution in the Stari Aerodrom district of Podgorica, founded in 2020 as a general practice and grown into a polyclinic with specialists from several fields in 2022. The polyclinic offers general practice consultations (including ECG recording and reading), surgery — among it minor procedures under local anaesthesia: removal of moles, atheromas, fibromas, lipomas and scars — paediatrics, child mental health, internal medicine, neurology, urology, psychiatry, oncology and ENT. Ultrasound diagnostics cover the abdomen and pelvis, urinary tract, breasts and armpits, neck and thyroid, soft tissues, peripheral regions and colour Doppler of blood vessels; the polyclinic also lists X-ray diagnostics, cardiology and a laboratory among its departments. Home visits for adults are available around the clock (GP examination, ECG, wound dressing, suture removal, catheter change, infusions and injections), and the polyclinic arranges medical transport of patients within Montenegro and abroad. Myers'' cocktail (an intravenous vitamin and mineral infusion) and capillary sclerotherapy are also offered. The polyclinic names the insurers Sava osiguranje and Generali as its partners.',
	description_de = 'Eine private Gesundheitseinrichtung im Stadtteil Stari Aerodrom in Podgorica, 2020 als allgemeinmedizinische Praxis gegründet und 2022 zur Poliklinik mit Fachärzten mehrerer Gebiete erweitert. Angeboten werden allgemeinmedizinische Untersuchungen (einschließlich EKG-Aufzeichnung und -Befundung), Chirurgie — darunter kleine Eingriffe in örtlicher Betäubung: Entfernung von Muttermalen, Atheromen, Fibromen, Lipomen und Narben —, Kinderheilkunde, psychische Gesundheit von Kindern, Innere Medizin, Neurologie, Urologie, Psychiatrie, Onkologie und HNO. Die Ultraschalldiagnostik umfasst Abdomen und kleines Becken, Harnwege, Brust und Achselhöhlen, Hals und Schilddrüse, Weichteile, periphere Regionen sowie Farbdoppler der Blutgefäße; als weitere Abteilungen nennt die Poliklinik Röntgendiagnostik, Kardiologie und ein Labor. Für Erwachsene gibt es Hausbesuche rund um die Uhr (allgemeinärztliche Untersuchung, EKG, Verbandswechsel, Fadenziehen, Katheterwechsel, Infusionen und Injektionen), außerdem organisiert die Poliklinik Krankentransporte innerhalb Montenegros und ins Ausland. Angeboten werden auch der Myers-Cocktail (intravenöse Vitamin- und Mineralstoffinfusion) und die Sklerotherapie von Besenreisern. Als Partner nennt die Poliklinik die Versicherer Sava osiguranje und Generali.',
	description_tr = 'Podgorica''nın Stari Aerodrom semtinde yer alan özel sağlık kuruluşu; 2020''de aile hekimliği muayenehanesi olarak kurulmuş, 2022''de birçok alandan uzmanların çalıştığı bir polikliniğe dönüşmüştür. Poliklinikte genel pratisyen muayenesi (EKG çekimi ve yorumu dahil), cerrahi — lokal anestezi altında küçük cerrahi girişimler: ben, aterom, fibrom, lipom ve yara izi alınması dahil —, çocuk sağlığı, çocuk ruh sağlığı, iç hastalıkları, nöroloji, üroloji, psikiyatri, onkoloji ve KBB hizmetleri verilir. Ultrason tanısı batın ve pelvis, idrar yolları, meme ve koltuk altı, boyun ve tiroid, yumuşak doku, periferik bölgeler ile damarların renkli Doppler incelemesini kapsar; poliklinik bölümleri arasında röntgen tanısı, kardiyoloji ve laboratuvarı da sayar. Yetişkinler için 24 saat ev ziyareti yapılır (pratisyen hekim muayenesi, EKG, pansuman, dikiş alınması, sonda değişimi, serum ve enjeksiyonlar); poliklinik ayrıca Karadağ içinde ve yurt dışına hasta nakli organize eder. Myers kokteyli (damar yoluyla vitamin ve mineral infüzyonu) ve kılcal damar skleroterapisi de sunulmaktadır. Poliklinik, Sava osiguranje ve Generali sigorta şirketlerini iş ortakları olarak belirtmektedir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- «Pon - Sub: 8:00 - 20:00 / Nedelja: Zatvoreno»
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "20:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS — «Naš tim» (all-doctors.html), 13 врачей.
-- Специальности: 2 INTERNAL_MEDICINE, 3 GENERAL_SURGERY, 4 PEDIATRICS, 8 NEUROLOGY,
--   9 UROLOGY, 10 RADIOLOGY, 11 OTORHINOLARYNGOLOGY, 21 PSYCHIATRY, 47 ONCOLOGY,
--   48 EMERGENCY_MEDICINE, 49 THORACIC_SURGERY, 77 ONCOLOGIC_SURGERY.
-- Язык — только SR (1). Фото — внешние URL melasana.me (https работает).
-- 10 из 13 уже есть в БД (у КЦЦГ, Codra, ДЗ Подгорица и др.) — для них только привязка,
-- position, специальность сайта (INSERT IGNORE) и фото, если пусто.
-- Фото НЕ взяты: Rakočević («dr radomir rakočević.jpg»), Brnović («Nebojša.png»),
-- Šiljak («dr Ivana Šiljak.jpg») — на самом сайте 404 (имена файлов с диакритикой);
-- Uskoković — «slike/m.png», это заглушка-силуэт.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Dimitrije Burzan — Direktor / Specijalista opšte hirurgije
-- В БД уже есть: slug dimitrije-burzan (локально id 360; Codra, Hirurgija dr Eli).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dimitrije Burzan' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Burzan Dimitrije' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dimitrije-burzan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dimitrije-burzan', 'Dimitrije Burzan', 'Димитрије Бурзан', 'Димитрие Бурзан', 'Dimitrije Burzan', 'Dr',
	'https://www.melasana.me/images/slike/MelaSana-21.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/slike/MelaSana-21.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Direktor, specijalista opšte hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Nikola Bašić — Specijalista urgentne medicine (новый)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nikola Bašić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bašić Nikola' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nikola-basic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-basic', 'Nikola Bašić', 'Никола Башић', 'Никола Башич', 'Nikola Basic', 'Dr',
	'https://www.melasana.me/images/slike/MelaSana-16.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/slike/MelaSana-16.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 48);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista urgentne medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Radomir Rakočević — specijalista radiologije
-- В БД уже есть: slug radomir-rakocevic (локально id 456; Kerber, Diagnostica).
-- Фото сайта — 404, у записи в БД фото уже есть.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Radomir Rakočević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Rakočević Radomir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'radomir-rakocevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'radomir-rakocevic', 'Radomir Rakočević', 'Радомир Ракочевић', 'Радомир Ракочевич', 'Radomir Rakocevic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Primarijus dr Edita Bašović — Specijalista pedijatrije
-- В БД уже есть: slug edita-basovic (локально id 1233; ДЗ Подгорица, ZO Stari Aerodrom;
-- ДЗ Даниловград). Титул в БД «Dr» не трогаем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Edita Bašović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bašović Edita' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'edita-basovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'edita-basovic', 'Edita Bašović', 'Едита Башовић', 'Эдита Башович', 'Edita Basovic', 'Prim. dr',
	'https://www.melasana.me/images/slike/Edita%20Basovic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/slike/Edita%20Basovic.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 4);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista pedijatrije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Sandra Vujović — Neurolog
-- В БД уже есть: slug sandra-vujovic (локально id 773; КЦЦГ).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sandra Vujović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vujović Sandra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sandra-vujovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sandra-vujovic', 'Sandra Vujović', 'Сандра Вујовић', 'Сандра Вуйович', 'Sandra Vujovic', 'Dr',
	'https://www.melasana.me/images/sandra.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/sandra.png' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 8);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Neurolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Vanja Karađinović — Onkolog
-- В БД уже есть: slug vanja-karadjinovic (локально id 889; КЦЦГ).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vanja Karađinović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Karađinović Vanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vanja-karadjinovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vanja-karadjinovic', 'Vanja Karađinović', 'Вања Карађиновић', 'Ваня Караджинович', 'Vanja Karadjinovic', 'Dr',
	'https://www.melasana.me/images/vanja.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/vanja.png' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 47);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Onkolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Nebojša Brnović — Internista
-- В БД уже есть: slug nebojsa-brnovic (локально id 2684; КЦЦГ, «Urgentni centar, direktor»,
-- специальность 48). Сайт называет его интернистом — добавляется 2 INTERNAL_MEDICINE.
-- Фото сайта — 404.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nebojša Brnović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Brnović Nebojša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nebojsa-brnovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nebojsa-brnovic', 'Nebojša Brnović', 'Небојша Брновић', 'Небойша Брнович', 'Nebojsa Brnovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Internista')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Prim. dr Ivan Đorđević — specijalista ORL (новый)
-- Список команды: «Dr Ivan Đorđević / ORL»; вкладка ORL на all-services: «konsultanske
-- preglede obavlja prim dr IVAN DJORDJEVIĆ, spec. ORL, direktor bolnice za ORL, KBC
-- Dragiša Mišović, Dedinje, dugogodišnji stručni konsultant u Institutu za bolesti djece
-- u KCCG Podgorica». Описание — только из этой фразы (данные 2022 года).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivan Đorđević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đorđević Ivan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivan-djordjevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-djordjevic', 'Ivan Đorđević', 'Иван Ђорђевић', 'Иван Джорджевич', 'Ivan Djordjevic', 'Prim. dr',
	'https://www.melasana.me/images/IVAN.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/IVAN.png' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
-- Описание — только если пусто (врач мог появиться в БД из другого импорта).
UPDATE doctors SET
	description_sr = 'Specijalista otorinolaringologije, direktor bolnice za ORL KBC „Dragiša Mišović“ (Dedinje, Beograd) i dugogodišnji stručni konsultant Instituta za bolesti djece KCCG u Podgorici. U Poliklinici Mela Sana obavlja konsultativne ORL preglede.',
	description_sr_cyrl = 'Специјалиста оториноларингологије, директор болнице за ОРЛ КБЦ „Драгиша Мишовић“ (Дедиње, Београд) и дугогодишњи стручни консултант Института за болести дјеце КЦЦГ у Подгорици. У Поликлиници Мела Сана обавља консултативне ОРЛ прегледе.',
	description_ru = 'Врач-оториноларинголог, директор ЛОР-больницы КБЦ «Драгиша Мишович» (Дедине, Белград) и многолетний консультант Института детских болезней Клинического центра Черногории в Подгорице. В поликлинике Mela Sana проводит консультативные ЛОР-приёмы.',
	description_en = 'Otorhinolaryngologist, director of the ENT hospital of the Dragiša Mišović Clinical Hospital Centre (Dedinje, Belgrade) and long-standing consultant to the Institute for Children''s Diseases of the Clinical Centre of Montenegro in Podgorica. At Mela Sana Polyclinic he provides consultative ENT examinations.',
	description_de = 'Facharzt für Hals-Nasen-Ohren-Heilkunde, Direktor der HNO-Klinik des Klinisch-Krankenhauszentrums „Dragiša Mišović“ (Dedinje, Belgrad) und langjähriger fachlicher Berater des Instituts für Kinderkrankheiten des Klinischen Zentrums Montenegros in Podgorica. In der Poliklinik Mela Sana führt er konsiliarische HNO-Untersuchungen durch.',
	description_tr = 'Kulak burun boğaz uzmanı; Dragiša Mišović Klinik Hastane Merkezi (Dedinje, Belgrad) KBB hastanesi müdürü ve Podgorica''daki Karadağ Klinik Merkezi Çocuk Hastalıkları Enstitüsü''nün uzun süreli danışmanı. Mela Sana Polikliniği''nde konsültasyon amaçlı KBB muayeneleri yapmaktadır.'
WHERE id = @doctor_id AND (description_sr IS NULL OR description_sr = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 11);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ORL, konsultant')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Vlado Vučelić — Specijalista hirurgije / Onko hirurg dojke
-- В БД уже есть как Vladimir Vučeljić: slug vladimir-vuceljic (локально id 317; КЦЦГ,
-- Bonomedica; специальности 3, 76 MAMMOLOGY, 77 ONCOLOGIC_SURGERY — тот же профиль
-- «онкохирург молочной железы»). Vlado — бытовая форма имени Vladimir; файл фото на
-- самом сайте называется «dr vlado vuceljic.jpg» — то есть написание с «lj». Поиск
-- по имени с сайта не найдёт, поэтому явный фолбэк на slug vladimir-vuceljic.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vlado Vučelić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vučelić Vlado' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vlado-vucelic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vladimir-vuceljic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vladimir-vuceljic', 'Vladimir Vučeljić', 'Владимир Вучељић', 'Владимир Вучелич', 'Vladimir Vuceljic', 'Dr',
	'https://www.melasana.me/images/dr%20vlado%20vuceljic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/dr%20vlado%20vuceljic.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3), (@doctor_id, 77);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista hirurgije, onkohirurg dojke')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Filip Uskoković — Specijalista grudne hirurgije
-- В БД уже есть: slug uskokovic-filip, name_sr «Uskoković Filip» (локально id 392;
-- Codra, КЦЦГ; специальности 3, 49). Фото сайта — заглушка, не берём.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Filip Uskoković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Uskoković Filip' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'filip-uskokovic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'uskokovic-filip' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'filip-uskokovic', 'Filip Uskoković', 'Филип Ускоковић', 'Филип Ускокович', 'Filip Uskokovic', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 49);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista grudne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Marko Vuković — Specijalista urologije
-- В БД уже есть: slug vukovic-marko (локально id 355; Codra, КЦЦГ; урология). ⚠️ name_sr
-- в БД — «Vuković Marko» с хвостовым TAB, поиск по имени его не находит → явный фолбэк
-- на slug vukovic-marko.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marko Vuković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vuković Marko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marko-vukovic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vukovic-marko' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-vukovic', 'Marko Vuković', 'Марко Вуковић', 'Марко Вукович', 'Marko Vukovic', 'Dr',
	'https://www.melasana.me/images/dr%20Marko%20Vukovic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/dr%20Marko%20Vukovic.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista urologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Ivan Krgović — Specijalista dječije psihijatrije (новый)
-- Отдельной специальности «детская психиатрия» в enums/specialty.ts нет — 21 PSYCHIATRY,
-- детский профиль — в position. (Vladimir Krgović, радиолог Konzilijum, — другой человек.)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivan Krgović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Krgović Ivan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivan-krgovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-krgovic', 'Ivan Krgović', 'Иван Крговић', 'Иван Кргович', 'Ivan Krgovic', 'Dr',
	'https://www.melasana.me/images/dr%20ivan%20krgovic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://www.melasana.me/images/dr%20ivan%20krgovic.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dječije psihijatrije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Ivana Šiljak — Specijalista psihijatrije
-- В БД уже есть: slug ivana-siljak (локально id 2951; ДЗ Подгорица, Centar za mentalno
-- zdravlje). Фото сайта — 404.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivana Šiljak' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Šiljak Ivana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivana-siljak' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-siljak', 'Ivana Šiljak', 'Ивана Шиљак', 'Ивана Шиляк', 'Ivana Siljak', 'Dr', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista psihijatrije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, languages = 1, types = 1, working_hours = 1.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

SELECT clinic_id, monday, saturday, sunday FROM clinic_working_hours WHERE clinic_id = @clinic_id;

-- Ожидается 13 строк, у каждой непустая position и непустой список специальностей.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	(d.photo_url IS NOT NULL AND d.photo_url <> '') AS has_photo
FROM doctor_clinics dc
JOIN doctors d ON d.id = dc.doctor_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
WHERE dc.clinic_id = @clinic_id
GROUP BY d.id, d.slug, d.name_sr, d.professional_title, dc.position, d.photo_url
ORDER BY d.id;

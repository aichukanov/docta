-- ═══════════════════════════════════════════════════════════════════════════
-- Ana Medica (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ana-medica-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/ana-medica-podgorica.json):
--   * https://anamedica.me/ — WordPress + Brizy, wp-json/wp/v2/pages (11 страниц, рабочие modified 2026-03-14):
--     pocetna (футер: адрес, часы, телефон, email), o-nama (команда с фото), usluge (перечень услуг),
--     contact-2 (текст о клинике), oblasti (просветительские тексты о болезнях — не перечень услуг).
--   * data/google-places/podgorica/ana-medica.json — place_id, координаты, телефон (49 отзывов — pending).
-- Сверка: адрес «Marka Radovića 95, 81000 Podgorica» — сайт = Google; телефон +382 68 686 883 — сайт = Google.
-- Email anamedicamne@gmail.com — футер сайта (mailto на info@tvojdomen.com в кнопке — заглушка шаблона, не взят).
--
-- Идемпотентно и самоисправляюще: клиника по google_place_id → slug; врачи по slug / name_sr / перевёрнутому имени
-- (тёзки — только по slug, см. блоки). Пустые поля существующих записей дозаполняются, непустые не трогаются.
-- description_* клиники — БЕЗУСЛОВНЫЙ UPDATE. Подволна 2d, агент R.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJA5G1lTTrTRMRz1RQ8FugQoI';
SET @clinic_slug = 'ana-medica-podgorica';

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
	'Ana Medica',
	'Ana Medica',
	'Ana Medica',
	'Marka Radovića 95',
	'Марка Радовића 95',
	'',
	'',
	'81000',
	42.43841230,
	19.23922210,
	'+38268686883',
	'anamedicamne@gmail.com',
	'https://anamedica.me/',
	'',
	'',
	'',
	'',
	'',
	'https://anamedica.me/wp-content/uploads/2026/03/1772578088820-ec4f1d4e-4097-4c42-9e49-3fab71f69371_1.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Ana Medica', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Ana Medica', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Marka Radovića 95', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Марка Радовића 95', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38268686883', phone),
	email = IF(email IS NULL OR email = '', 'anamedicamne@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://anamedica.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://anamedica.me/wp-content/uploads/2026/03/1772578088820-ec4f1d4e-4097-4c42-9e49-3fab71f69371_1.png', logo_url),
	latitude = COALESCE(latitude, 42.43841230),
	longitude = COALESCE(longitude, 19.23922210)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Klinika za kožne i polne bolesti u Podgorici, u ulici Marka Radovića 95. Bavi se opštom i estetskom dermatologijom — dijagnostikom i liječenjem oboljenja kože, kose, noktiju i sluzokože — alergijskim i zapaljenskim dermatozama (ekcemi, atopijski dermatitis, psorijaza, urtikarija), polno prenosivim infekcijama (savjetovanje, diskretno testiranje i liječenje) te preventivnim pregledima mladeža i ranim otkrivanjem tumora kože. U klinici se rade dermatološki pregled, dermoskopija sa čuvanjem i poređenjem snimaka kroz vrijeme, elektrohirurgija radiotalasima, kriohirurgija tečnim azotom, hemijski pilinzi, liječenje hiperhidroze, dijagnostička biopsija kože u lokalnoj anesteziji i alergološki testovi — prick i epikutani (patch) testovi.',
	description_sr_cyrl = 'Клиника за кожне и полне болести у Подгорици, у улици Марка Радовића 95. Бави се општом и естетском дерматологијом — дијагностиком и лијечењем обољења коже, косе, ноктију и слузокоже — алергијским и запаљенским дерматозама (екцеми, атопијски дерматитис, псоријаза, уртикарија), полно преносивим инфекцијама (савјетовање, дискретно тестирање и лијечење) те превентивним прегледима младежа и раним откривањем тумора коже. У клиници се раде дерматолошки преглед, дермоскопија са чувањем и поређењем снимака кроз вријеме, електрохирургија радиоталасима, криохирургија течним азотом, хемијски пилинзи, лијечење хиперхидрозе, дијагностичка биопсија коже у локалној анестезији и алерголошки тестови — прик и епикутани (patch) тестови.',
	description_ru = 'Клиника кожных и венерических болезней в Подгорице, на улице Марка Радовича, 95. Направления: общая и эстетическая дерматология — диагностика и лечение заболеваний кожи, волос, ногтей и слизистых, — аллергические и воспалительные дерматозы (экзема, атопический дерматит, псориаз, крапивница), инфекции, передающиеся половым путём (консультации, анонимное тестирование и лечение), профилактические осмотры родинок и раннее выявление опухолей кожи. В клинике проводят осмотр дерматолога, дерматоскопию с сохранением и сравнением снимков в динамике, радиоволновую электрохирургию, криохирургию жидким азотом, химические пилинги, лечение гипергидроза, диагностическую биопсию кожи под местной анестезией и аллергопробы — прик-тесты и аппликационные (патч) тесты.',
	description_en = 'A clinic for skin and sexually transmitted diseases in Podgorica, at Marka Radovića 95. It covers general and aesthetic dermatology — diagnosis and treatment of diseases of the skin, hair, nails and mucous membranes — allergic and inflammatory dermatoses (eczema, atopic dermatitis, psoriasis, urticaria), sexually transmitted infections (counselling, discreet testing and treatment), and preventive mole checks with early detection of skin tumours. Services include dermatological examination, dermoscopy with image storage and comparison over time, radiowave electrosurgery, liquid-nitrogen cryosurgery, chemical peels, hyperhidrosis treatment, diagnostic skin biopsy under local anaesthesia and allergy testing — prick and patch tests.',
	description_de = 'Klinik für Haut- und Geschlechtskrankheiten in Podgorica, Marka Radovića 95. Schwerpunkte sind allgemeine und ästhetische Dermatologie — Diagnostik und Behandlung von Erkrankungen der Haut, Haare, Nägel und Schleimhäute —, allergische und entzündliche Dermatosen (Ekzeme, atopische Dermatitis, Psoriasis, Urtikaria), sexuell übertragbare Infektionen (Beratung, diskrete Tests und Behandlung) sowie Muttermal-Vorsorge und Früherkennung von Hauttumoren. Angeboten werden dermatologische Untersuchung, Dermatoskopie mit Speicherung und Verlaufsvergleich der Aufnahmen, Radiowellen-Elektrochirurgie, Kryochirurgie mit flüssigem Stickstoff, chemische Peelings, Behandlung der Hyperhidrose, diagnostische Hautbiopsie in örtlicher Betäubung sowie Allergietests — Prick- und Epikutantests (Patch-Tests).',
	description_tr = 'Podgorica''da, Marka Radovića 95 adresinde deri ve cinsel yolla bulaşan hastalıklar kliniği. Genel ve estetik dermatoloji — deri, saç, tırnak ve mukoza hastalıklarının tanı ve tedavisi —, alerjik ve iltihabi dermatozlar (egzama, atopik dermatit, sedef hastalığı, ürtiker), cinsel yolla bulaşan enfeksiyonlar (danışmanlık, gizli test ve tedavi) ile ben kontrolleri ve deri tümörlerinin erken tespiti alanlarında hizmet verir. Klinikte dermatolojik muayene, görüntülerin saklanıp zaman içinde karşılaştırıldığı dermoskopi, radyofrekans elektrocerrahi, sıvı azotla kriyocerrahi, kimyasal peeling, hiperhidroz tedavisi, lokal anestezi altında tanısal deri biyopsisi ve alerji testleri — prick ve yama (patch) testleri — yapılır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DERMATOLOGY_CLINIC = 10 — «KLINIKA ZA KOŽNE I POLNE BOLESTI», все врачи дерматовенерологи
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 10);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Футер anamedica.me: «Radno vrijeme: Ponedjeljak – Petak: od 15:00h do 21:00h, Subotaom od 09:00h do 14:00 h». Блок «Zakazivanje termina» (15–20, сб 10–14) — часы записи по телефону, не взяты. Воскресенье не упомянуто → закрыто.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "15:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "15:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "15:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "15:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "15:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "14:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3) — блок «Upoznajte naš tim» (/o-nama/, главная). Lazar Popović (izvršni direktor, pravnik)
-- и Jovana Vujošević (recepcija, medicinska sestra) — не врачи, не заводятся.
-- Найдены в БД (2): ana-popovic, milena-djurovic (дерматологи КЦЦГ — те же люди). Новый (1): marija-bijelic
-- (прод-API 204 по обоим порядкам имени). Фото — настоящие портреты с сайта (проверены). Языки — SR.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr sc. med. Ana Popović — specijalista dermatovenerologije, uži specijalista onkologije
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: ana-popovic (локаль и прод id 852, «dr sc. med.», DERMATOVENEROLOGY + ONCOLOGY, КЦЦГ) —
-- тот же врач: совпадают титул и обе специальности. ⚠️ Поиск ТОЛЬКО по slug: в БД ещё две тёзки —
-- ana-popovic-2 (GP, ДЗ Херцег-Нови) и ana-popovic-3 (педиатр, ДЗ Беране); по name_sr прилипло бы к первой найденной.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'ana-popovic' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ana-popovic', 'Ana Popović', 'Ана Поповић', 'Ана Попович', 'Ana Popovic', 'dr sc. med.',
	'https://anamedica.me/wp-content/uploads/2026/03/1773494729359160.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: фото только если пустое.
UPDATE doctors SET photo_url = 'https://anamedica.me/wp-content/uploads/2026/03/1773494729359160.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7), (@doctor_id, 47);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatovenerologije, uži specijalista onkologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Prof. dr Milena Đurović — specijalista dermatovenerologije (на сайте опечатка «Pror. dr»)
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: milena-djurovic (локаль и прод id 846, «prof. dr.», DERMATOVENEROLOGY, КЦЦГ) — тот же врач.
-- Однофамилицы Đurović в БД (Marija, Dragan) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'milena-djurovic' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Milena Đurović' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đurović Milena' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-djurovic', 'Milena Đurović', 'Милена Ђуровић', 'Милена Джурович', 'Milena Djurovic', 'prof. dr',
	'https://anamedica.me/wp-content/uploads/2026/03/1773494720792783.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: фото только если пустое.
UPDATE doctors SET photo_url = 'https://anamedica.me/wp-content/uploads/2026/03/1773494720792783.png' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatovenerologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Marija Bijelić — specijalista dermatovenerologije
-- Новая. Однофамилица Gordana Bijelić (педиатр, ДЗ Подгорица) — другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'marija-bijelic' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Marija Bijelić' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bijelić Marija' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-bijelic', 'Marija Bijelić', 'Марија Бијелић', 'Мария Биелич', 'Marija Bijelic', 'Dr',
	'https://anamedica.me/wp-content/uploads/2026/03/1773494721609761.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: фото только если пустое.
UPDATE doctors SET photo_url = 'https://anamedica.me/wp-content/uploads/2026/03/1773494721609761.png' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatovenerologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 10, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3 врача.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;

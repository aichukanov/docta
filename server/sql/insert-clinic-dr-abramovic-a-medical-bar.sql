-- ═══════════════════════════════════════════════════════════════════════════
-- Dr Abramović — A Medical (Bar) — клиника + врач
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dr-abramovic-a-medical-bar.sql
-- Затем: server/sql/insert-clinic-dr-abramovic-a-medical-bar-services.sql
-- Запись импорта: data/clinic-imports/dr-abramovic-a-medical-bar.json. Подволна 2e, агент Z.
-- 
-- Название: сайт — «Dr Med Abramović» + «A Medical» (юрлицо «PZU A Medical», title «Dr.Abramovic»), Google — «dr Abramović»
-- → «Dr Abramović — A Medical» (оба имени, под которыми клинику ищут).
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://www.drabramovic.com/ — WordPress, 4 страницы (wp-json modified 2022-03-11), футер «© 2020». Цен нет, email нет.
--   * data/google-places/bar/dr-abramovic.json — place_id, координаты 42.0993856 / 19.0946728, +382 69 062 316,
--     «33XV+QV3, Ulica Jovana Tomasevica, Bar», 6 отзывов (rating 5) — не импортировались.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ87q7SAB0ThMRIed9XD0ALgs';
SET @clinic_slug = 'dr-abramovic-a-medical-bar';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Dr Abramović — A Medical', 'dr Abramović', 'Dr Abramović', 'A Medical', 'PZU A Medical', 'Dr Med Abramović') AND city_id = 7 LIMIT 1));

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
	'Dr Abramović — A Medical',
	'Др Абрамовић — A Medical',
	'Доктор Абрамович — A Medical',
	'Jovana Tomaševića G9 (Poslovni centar G9)',
	'Јована Томашевића G9 (Пословни центар G9)',
	'',
	'',
	'85000',
	42.09938560,
	19.09467280,
	'+38269062316;+38269062317',
	'',
	'https://www.drabramovic.com/',
	'',
	'',
	'',
	'',
	'',
	'https://www.drabramovic.com/wp-content/uploads/2020/04/Logo-vektorski-primer-tri-PNG-FILE.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.09938560, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.09467280, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Др Абрамовић — A Medical', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Доктор Абрамович — A Medical', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Jovana Tomaševića G9 (Poslovni centar G9)', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Јована Томашевића G9 (Пословни центар G9)', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269062316;+38269062317', phone),
	website = IF(website IS NULL OR website = '', 'https://www.drabramovic.com/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.drabramovic.com/wp-content/uploads/2020/04/Logo-vektorski-primer-tri-PNG-FILE.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Privatna zdravstvena ustanova A Medical (dr Abramović) u Baru, osnovana 1995. godine, pruža usluge radiološke i ultrazvučne dijagnostike i specijalističke konsultacije uz detaljnu analizu laboratorijskih i drugih nalaza. U ustanovi ordinira dr med. Žarko Abramović, specijalista radiologije. Ustanova se nalazi u centru Bara, u Poslovnom centru G9 u ulici Jovana Tomaševića, između Robne kuće i Doma zdravlja. Usluge: digitalni rendgen — snimanje grudnog koša (pluća i srca), kostiju tijela, kičme i glave, sinusa i pasaža jednjaka i gastroduodenuma; 4D ultrazvuk — pregledi trbušnog i grudnog prostora (jetra, žučna kesa, pankreas, bubrezi, bešika i prostata), 4D pregledi trudnoće, materice i jajnika, kolor dopler krvnih sudova, ultrazvuk dojke i štitne žlijezde i ultrazvuk dječjih kukova; specijalistički pregledi — konsultacije s analizom laboratorijskih i drugih nalaza i savjetovanje u vezi s drugim pregledima i terapijom. Radno vrijeme: ponedjeljak–petak od 9 do 20 časova.',
	description_sr_cyrl = 'Приватна здравствена установа A Medical (др Абрамовић) у Бару, основана 1995. године, пружа услуге радиолошке и ултразвучне дијагностике и специјалистичке консултације уз детаљну анализу лабораторијских и других налаза. У установи ординира др мед. Жарко Абрамовић, специјалиста радиологије. Установа се налази у центру Бара, у Пословном центру G9 у улици Јована Томашевића, између Робне куће и Дома здравља. Услуге: дигитални рендген — снимање грудног коша (плућа и срца), костију тијела, кичме и главе, синуса и пасажа једњака и гастродуоденума; 4D ултразвук — прегледи трбушног и грудног простора (јетра, жучна кеса, панкреас, бубрези, бешика и простата), 4D прегледи трудноће, материце и јајника, колор доплер крвних судова, ултразвук дојке и штитне жлијезде и ултразвук дјечјих кукова; специјалистички прегледи — консултације с анализом лабораторијских и других налаза и савјетовање у вези с другим прегледима и терапијом. Радно вријеме: понедјељак–петак од 9 до 20 часова.',
	description_ru = 'Частное медицинское учреждение A Medical (доктор Абрамович) в Баре, основано в 1995 году, оказывает услуги рентгеновской и ультразвуковой диагностики и консультации специалиста с подробным разбором лабораторных и других результатов. Приём ведёт д-р мед. Жарко Абрамович, специалист по радиологии. Учреждение находится в центре Бара, в бизнес-центре G9 на улице Jovana Tomaševića, между универмагом и Домом здоровья. Услуги: цифровой рентген — снимки грудной клетки (лёгкие и сердце), костей, позвоночника и головы, пазух носа, рентгеноскопия пищевода, желудка и двенадцатиперстной кишки; 4D УЗИ — исследование органов брюшной и грудной полости (печень, желчный пузырь, поджелудочная железа, почки, мочевой пузырь и простата), 4D УЗИ при беременности, матки и яичников, цветовой допплер сосудов, УЗИ молочных желёз и щитовидной железы, УЗИ тазобедренных суставов у детей; консультации специалиста с разбором анализов и других результатов и советы по дальнейшим обследованиям и лечению. Часы работы: пн–пт с 9 до 20.',
	description_en = 'A Medical (Dr Abramović) is a private healthcare institution in Bar, founded in 1995, offering X-ray and ultrasound diagnostics and specialist consultations with a detailed review of laboratory and other results. Dr med. Žarko Abramović, a specialist radiologist, sees patients there. It is located in the centre of Bar, in the G9 business centre on Jovana Tomaševića street, between the department store and the Health Centre. Services: digital X-ray — chest (lungs and heart), bones, spine and head, sinuses, and barium swallow of the oesophagus and gastroduodenum; 4D ultrasound — abdominal and chest examinations (liver, gallbladder, pancreas, kidneys, bladder and prostate), 4D pregnancy, uterus and ovary scans, colour Doppler of blood vessels, breast and thyroid ultrasound, and infant hip ultrasound; specialist consultations with a review of laboratory and other findings and advice on further tests and treatment. Opening hours: Monday–Friday 9:00–20:00.',
	description_de = 'A Medical (Dr. Abramović) ist eine private Gesundheitseinrichtung in Bar, gegründet 1995, mit Röntgen- und Ultraschalldiagnostik sowie fachärztlichen Beratungen mit ausführlicher Auswertung von Labor- und anderen Befunden. Hier praktiziert Dr. med. Žarko Abramović, Facharzt für Radiologie. Die Einrichtung befindet sich im Zentrum von Bar im Geschäftszentrum G9 in der Straße Jovana Tomaševića, zwischen Kaufhaus und Gesundheitszentrum. Leistungen: digitales Röntgen — Thorax (Lunge und Herz), Knochen, Wirbelsäule und Kopf, Nasennebenhöhlen sowie Breischluck von Speiseröhre und Gastroduodenum; 4D-Ultraschall — Untersuchungen von Bauch- und Brustraum (Leber, Gallenblase, Bauchspeicheldrüse, Nieren, Blase und Prostata), 4D-Untersuchungen in der Schwangerschaft, von Gebärmutter und Eierstöcken, Farbdoppler der Blutgefäße, Ultraschall von Brust und Schilddrüse sowie Hüftultraschall bei Kindern; fachärztliche Beratungen mit Auswertung von Labor- und anderen Befunden und Beratung zu weiteren Untersuchungen und Therapien. Öffnungszeiten: Montag–Freitag 9–20 Uhr.',
	description_tr = 'A Medical (Dr. Abramović), Bar''da 1995 yılında kurulmuş özel bir sağlık kuruluşudur; röntgen ve ultrason tanı hizmetleri ile laboratuvar ve diğer sonuçların ayrıntılı değerlendirildiği uzman konsültasyonları sunar. Burada radyoloji uzmanı Dr. med. Žarko Abramović hasta kabul eder. Kuruluş Bar merkezinde, Jovana Tomaševića caddesindeki G9 iş merkezinde, büyük mağaza ile Sağlık Merkezi arasında yer alır. Hizmetler: dijital röntgen — göğüs (akciğer ve kalp), kemikler, omurga ve baş, sinüsler ile yemek borusu ve gastroduodenum pasajı; 4D ultrason — karın ve göğüs boşluğu incelemeleri (karaciğer, safra kesesi, pankreas, böbrekler, mesane ve prostat), gebelik, rahim ve yumurtalıkların 4D incelemesi, damarların renkli Doppler incelemesi, meme ve tiroid ultrasonu, çocuklarda kalça ultrasonu; laboratuvar ve diğer bulguların değerlendirildiği uzman konsültasyonları ve ileri tetkik ile tedavi konusunda danışmanlık. Çalışma saatleri: pazartesi–cuma 9:00–20:00.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- POLYCLINIC = 1 — рентген + УЗИ, кабинет лучевой диагностики (решение владельца каталога для radio-medic: отдельного типа радиологии нет, DIAGNOSTIC_LAB вводит в заблуждение).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском (английские остатки шаблона «Our clinic», «Lorem ipsum» — не заявление), другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — главная и /kako-do-nas/: «Radno vrijeme Ponedjeljak - Petak 09:00 - 20:00». Сб/Вс не названы → closed (как в прошлых импортах).
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "closed"}',
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
-- Источник: /o-nama/ — единственный врач сайта.
-- Привязки врач↔услуга — все услуги к единственному врачу, см. services-SQL.

-- ───────────────────────────────────────────────────────────────
-- «U centru ordinira dr med. Žarko Abramović, specijalista radiologije, s dugogodišnjim iskustvom …»; подпись «Dr med Žarko Abramović Spec Radiolog» (/o-nama/).
-- В БД не найден (локаль: Abramović — Marija (радиолог КЦЦГ/Moj Lab) и Renata (дерматолог ДЗ Бар) — другие люди; zarko-abramovic нет; прод-API 204) — новый.
-- Фото на сайте нет (на /o-nama/ — снимок рентген-кабинета). Языки не заявлены → SR.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Žarko Abramović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Abramović Žarko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zarko-abramovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zarko-abramovic', 'Žarko Abramović', 'Жарко Абрамовић', 'Жарко Абрамович', 'Zarko Abramovic', 'dr med.',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Биографии на сайте нет — описание не пишем.

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista radiologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 7, status = published, clinic_languages = '1', clinic_types = '1', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: zarko-abramovic (10).
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

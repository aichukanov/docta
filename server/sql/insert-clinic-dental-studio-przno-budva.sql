-- ═══════════════════════════════════════════════════════════════════════════
-- Dental Studio Pržno (Glušica), Sveti Stefan — Budva — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-studio-przno-budva.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/dental-studio-przno-budva.json):
--   * https://dentalstudioglusica.me/ — WordPress (тема Phlox, TranslatePress me/en/ru). Прочитаны главная, /o-nama/, /kontakt/ и
--     10 страниц меню «USLUGE». ⚠️ На главной остатки демо-шаблона (lorem ipsum, «Plumbing/Architecture», «Andrea Flock CEO»,
--     «Nikola Glušica — Marketing & SEO») — проигнорированы; состав и должности — только со страницы /o-nama/.
--   * data/google-places/budva/dental-studio-przno.json — place_id, координаты, телефон.
-- Адрес: сайт «Pržno BB, Sveti Stefan, Budva» = Google «b.b Stefana Mitrovica St, Sveti Stefan 85315». Почтовый индекс — Google.
-- Телефоны — /kontakt/ (+382 67 244 418 = Google). Email на сайте не указан. Facebook/Instagram — футер сайта.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ1S6cCobVTRMRKa9sXal5EB4';
SET @clinic_slug = 'dental-studio-przno-budva';

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
	3, -- CityId.BUDVA
	'Dental Studio Pržno',
	'Dental Studio Pržno',
	'Стоматологический кабинет Dental Studio Pržno',
	'Pržno bb',
	'Пржно бб',
	'Sveti Stefan',
	'Свети Стефан',
	'85315',
	42.26719260,
	18.89388270,
	'+38267244418;+38269244418',
	'',
	'https://dentalstudioglusica.me/',
	'facebook.com/profile.php?id=100066662723999',
	'@dental_studio_przno',
	'',
	'',
	'',
	'https://dentalstudioglusica.me/wp-content/uploads/2020/10/dental-studio-PRZNO-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Dental Studio Pržno', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Dental Studio Pržno', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Pržno bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Пржно бб', address_sr_cyrl),
	town_sr = IF(town_sr IS NULL OR town_sr = '', 'Sveti Stefan', town_sr),
	town_sr_cyrl = IF(town_sr_cyrl IS NULL OR town_sr_cyrl = '', 'Свети Стефан', town_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85315', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267244418;+38269244418', phone),
	website = IF(website IS NULL OR website = '', 'https://dentalstudioglusica.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/profile.php?id=100066662723999', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@dental_studio_przno', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://dentalstudioglusica.me/wp-content/uploads/2020/10/dental-studio-PRZNO-logo.png', logo_url),
	latitude = COALESCE(latitude, 42.26719260),
	longitude = COALESCE(longitude, 18.89388270)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Dental Studio Pržno“ (Dental Studio Glušica) nalazi se u srcu Pržna kod Svetog Stefana, u neposrednoj blizini hotela Maestral, Miločer i Sveti Stefan. Ordinaciju su u septembru 2020. godine otvorili doktori stomatologije Nikola i Nikolina Glušica, nastavljajući višegodišnju porodičnu tradiciju. Ordinacija je opremljena savremenom opremom i pruža kompletnu stomatološku uslugu: kompozitne plombe, liječenje kanala korijena uz mašinsku obradu i lasersku terapiju kanala, krunice (bezmetalne na bazi cirkona i metalokeramičke) i keramičke fasete rađene CAD/CAM tehnikom, zubne implante, akrilatne, skeletirane, Valplast i BioHPP proteze, mobilne i fiksne ortodontske aparate, kućno, profesionalno i lasersko izbjeljivanje zuba, dječiju i preventivnu stomatologiju. Dentalni laser koristi se u liječenju parodontopatije, obradi parodontalnog džepa, uklanjanju frenuluma i cirkumciziji umnjaka. Na raspolaganju je i RTG dijagnostika: mali RA snimak, ortopan (OPT) i 3D CBCT snimak.',
	description_sr_cyrl = 'Стоматолошка ординација „Dental Studio Pržno“ (Dental Studio Glušica) налази се у срцу Пржна код Светог Стефана, у непосредној близини хотела Маестрал, Милочер и Свети Стефан. Ординацију су у септембру 2020. године отворили доктори стоматологије Никола и Николина Глушица, настављајући вишегодишњу породичну традицију. Ординација је опремљена савременом опремом и пружа комплетну стоматолошку услугу: композитне пломбе, лијечење канала коријена уз машинску обраду и ласерску терапију канала, крунице (безметалне на бази циркона и металокерамичке) и керамичке фасете рађене CAD/CAM техником, зубне импланте, акрилатне, скелетиране, Valplast и BioHPP протезе, мобилне и фиксне ортодонтске апарате, кућно, професионално и ласерско избјељивање зуба, дјечију и превентивну стоматологију. Дентални ласер користи се у лијечењу пародонтопатије, обради пародонталног џепа, уклањању френулума и циркумцизији умњака. На располагању је и РТГ дијагностика: мали РА снимак, ортопан (ОПТ) и 3Д CBCT снимак.',
	description_ru = 'Стоматологический кабинет «Dental Studio Pržno» (Dental Studio Glušica) находится в самом центре Пржно у Свети-Стефана, рядом с отелями Maestral, Miločer и Sveti Stefan. Кабинет открыли в сентябре 2020 года врачи-стоматологи Никола и Николина Глушица, продолжая многолетнюю семейную традицию. Кабинет оснащён современным оборудованием и оказывает полный спектр стоматологических услуг: композитные пломбы, лечение корневых каналов с машинной обработкой и лазерной обработкой каналов, коронки (безметалловые на основе циркония и металлокерамические) и керамические виниры, изготовленные по технологии CAD/CAM, зубные импланты, акриловые, бюгельные, Valplast и BioHPP протезы, съёмные и несъёмные ортодонтические аппараты, домашнее, профессиональное и лазерное отбеливание зубов, детская и профилактическая стоматология. Стоматологический лазер применяется для лечения пародонтита, обработки пародонтальных карманов, удаления уздечки и иссечения капюшона над зубом мудрости. Есть рентгенодиагностика: прицельный снимок, ортопантомограмма (OPT) и 3D-снимок CBCT.',
	description_en = 'Dental Studio Pržno (Dental Studio Glušica) is a dental practice in the heart of Pržno near Sveti Stefan, close to the Maestral, Miločer and Sveti Stefan hotels. It was opened in September 2020 by dentists Nikola and Nikolina Glušica, continuing a long-standing family tradition. The practice is equipped with modern equipment and offers a full range of dental care: composite fillings, root canal treatment with rotary instrumentation and laser canal therapy, crowns (zirconia-based metal-free and metal-ceramic) and CAD/CAM ceramic veneers, dental implants, acrylic, cast partial, Valplast and BioHPP dentures, removable and fixed orthodontic appliances, at-home, in-office and laser teeth whitening, and paediatric and preventive dentistry. A dental laser is used to treat periodontitis, periodontal pockets, frenulum removal and wisdom tooth operculum excision. X-ray diagnostics are available on site: intraoral, panoramic (OPT) and 3D CBCT imaging.',
	description_de = 'Dental Studio Pržno (Dental Studio Glušica) ist eine Zahnarztpraxis im Zentrum von Pržno bei Sveti Stefan, in unmittelbarer Nähe der Hotels Maestral, Miločer und Sveti Stefan. Die Zahnärzte Nikola und Nikolina Glušica eröffneten die Praxis im September 2020 und führen damit eine langjährige Familientradition fort. Die Praxis ist modern ausgestattet und bietet das gesamte Spektrum der Zahnmedizin: Kompositfüllungen, Wurzelkanalbehandlung mit maschineller Aufbereitung und Laserbehandlung der Kanäle, Kronen (metallfrei auf Zirkonbasis und Metallkeramik) und im CAD/CAM-Verfahren gefertigte Keramikveneers, Zahnimplantate, Acryl-, Modellguss-, Valplast- und BioHPP-Prothesen, herausnehmbare und festsitzende kieferorthopädische Apparaturen, Zahnaufhellung für zu Hause, in der Praxis und mit Laser sowie Kinder- und Präventivzahnheilkunde. Der Dentallaser wird zur Behandlung von Parodontitis und Zahnfleischtaschen, zur Entfernung des Lippenbändchens und zur Exzision der Schleimhautkapuze über Weisheitszähnen eingesetzt. Vor Ort gibt es Röntgendiagnostik: Zahnfilm, Panoramaaufnahme (OPT) und 3D-DVT (CBCT).',
	description_tr = 'Dental Studio Pržno (Dental Studio Glušica), Sveti Stefan yakınındaki Pržno''nun merkezinde, Maestral, Miločer ve Sveti Stefan otellerinin hemen yanında bulunan bir diş muayenehanesidir. Muayenehaneyi Eylül 2020''de diş hekimleri Nikola ve Nikolina Glušica, uzun yıllara dayanan aile geleneğini sürdürerek açtı. Modern ekipmanla donatılmış muayenehane diş hekimliğinin tüm hizmetlerini sunar: kompozit dolgular, makine ile kanal şekillendirme ve kanalların lazerle tedavisiyle kanal tedavisi, kronlar (zirkonyum esaslı metalsiz ve metal-seramik) ve CAD/CAM ile üretilen seramik laminalar, diş implantları, akrilik, iskelet, Valplast ve BioHPP protezler, hareketli ve sabit ortodontik apareyler, evde, muayenehanede ve lazerle diş beyazlatma, çocuk ve koruyucu diş hekimliği. Diş lazeri periodontitis ve diş eti cebi tedavisinde, frenulum alınmasında ve yirmi yaş dişi üzerindeki diş eti kapüşonunun kesilmesinde kullanılır. Muayenehanede röntgen teşhisi de mevcuttur: periapikal, panoramik (OPT) ve 3D CBCT görüntüleme.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (en/ru версии TranslatePress — не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: /kontakt/: «RADNO VRIJEME — PON-PET: 10h - 19h, SUB: 10h - 15h, NED: Ne radimo».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "15:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (2)
-- Состав — /o-nama/ («Naš tim»): Nikola Glušica и Nikolina Glušica — «DR stomatologije»; Zorka Grujičić — «MEDICINSKA SESTRA» (не врач,
-- не заводится). В БД никого с фамилией Glušica нет (поиск по name_sr, перевёрнутому имени и slug, 2026-10-09).
-- Специальность 78 = DENTISTRY, язык 1 = SR. Фото — внешние URL сайта (проверено: 200 image/jpeg). Биографий на сайте нет.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Nikola Glušica — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
-- На главной в блоке демо-шаблона подписан «Marketing & SEO» — остаток шаблона; должность — по /o-nama/ «DR stomatologije».
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nikola Glušica' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Glušica Nikola' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nikola-glusica' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'nikola-glusica', 'Nikola Glušica', 'Никола Глушица', 'Никола Глушица', 'Nikola Glusica', 'dr',
	'https://dentalstudioglusica.me/wp-content/uploads/2020/10/Nikola-Glusica.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Nikolina Glušica — Doktor stomatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nikolina Glušica' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Glušica Nikolina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nikolina-glusica' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'nikolina-glusica', 'Nikolina Glušica', 'Николина Глушица', 'Николина Глушица', 'Nikolina Glusica', 'dr',
	'https://dentalstudioglusica.me/wp-content/uploads/2020/10/Nikolina-Glusica.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
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

-- Ожидается 2 врач(а/ей): nikola-glusica, nikolina-glusica.
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

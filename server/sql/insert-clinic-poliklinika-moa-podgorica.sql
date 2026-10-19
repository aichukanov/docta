-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika MOA — Ministry of Aesthetics (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-moa-podgorica.sql
-- Затем: server/sql/insert-clinic-poliklinika-moa-podgorica-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://moa.clinic/ — naslovna (состав «Upoznajte naš tim», контакты, часы),
--     /o-nama, /kontakt, страницы направлений, блог (wp-json /wp/v2/posts).
--     WordPress + Brizy, читается через curl, текст в HTML.
--   * data/google-places/podgorica/moa-clinic.json — place_id, координаты.
--
-- Сверка фактов:
--   * Адрес: сайт «Šeika Zaida 19/7 Podgorica» + «The Capital Plaza» (o-nama, блог),
--     Google «19 Šeika Zaida, Podgorica 81000» — согласованы. Записан с сайта.
--   * Координаты 42.4403134 / 19.2434827 — Google Places, единственный источник.
--   * Телефоны: сайт «+382 67 941 941 i +382 20 257 259»; Google подтверждает первый.
--     Короткий номер колл-центра 19979 в phone не пишем — международно не набирается.
--   * Часы: «Ponedjeljak - Subota: 09h - 20h» (naslovna). Воскресенье сайт не называет,
--     записано как closed — пн–сб явно перечислены как рабочие.
--   * Email: «info@moa.clinic» (разбит на три span на naslovna и kontakt).
--   * Языки клиники: только SR. Сайт двуязычный (TranslatePress me/en), но это язык
--     сайта, не заявление о сопровождении на английском.
--   * Тип: POLYCLINIC (1) — клиника сама называет себя poliklinika; AESTHETIC_CLINIC (14)
--     — «Ministry of Aesthetics», эстетика и лазеры составляют большую часть прайса.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей, описания
-- клиники и новых врачей пишутся безусловным UPDATE (правки из админки следующий
-- прогон перезатрёт — вносить сюда). Существующих врачей (id 329, 978, 1128, 1313)
-- файл не переименовывает и их описания не трогает; фото дозаполняет, только если пусто.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJXX2p6ZAhsGgRFH7ibUguCr8';
SET @clinic_slug = 'poliklinika-moa-podgorica';

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
	'Poliklinika MOA',
	'Поликлиника MOA', -- латинскую аббревиатуру бренда не транслитерируем
	'Поликлиника MOA',
	'Šeika Zaida 19/7',
	'Шеика Заида 19/7',
	'',
	'',
	'81000',
	42.44031340,
	19.24348270,
	'+38267941941;+38220257259',
	'info@moa.clinic',
	'https://moa.clinic/',
	'facebook.com/profile.php?id=61564788040550',
	'@moa.clinic',
	'',
	'',
	'',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/WhatsApp_Image_2024-12-06_at_21.34.03_037f4b4a-removebg-preview-486x156x0x0x486x156x1753441686.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника MOA', name_sr_cyrl),
	name_ru      = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника MOA', name_ru),
	address_sr   = IF(address_sr IS NULL OR address_sr = '', 'Šeika Zaida 19/7', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Шеика Заида 19/7', address_sr_cyrl),
	postal_code  = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude     = COALESCE(latitude, 42.44031340),
	longitude    = COALESCE(longitude, 19.24348270),
	phone        = IF(phone IS NULL OR phone = '', '+38267941941;+38220257259', phone),
	email        = IF(email IS NULL OR email = '', 'info@moa.clinic', email),
	website      = IF(website IS NULL OR website = '', 'https://moa.clinic/', website),
	facebook     = IF(facebook IS NULL OR facebook = '', 'facebook.com/profile.php?id=61564788040550', facebook),
	instagram    = IF(instagram IS NULL OR instagram = '', '@moa.clinic', instagram)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись (см. шапку). Только то, что клиника пишет о себе:
-- o-nama, страницы направлений, карточка «Stomatologija (u osnivanju)», пост блога
-- «Uzorkovanje krvi Moj Lab u MOA Poliklinici od 10. februara» (2026-02-17).
UPDATE clinics SET
	description_sr = 'Poliklinika MOA (Ministry of Aesthetics) nalazi se u kompleksu The Capital Plaza u Podgorici. Rad poliklinike obuhvata pet oblasti: opštu hirurgiju (manji ambulantni zahvati, obrada i previjanje rana, uklanjanje kožnih i potkožnih promjena), dermatovenerologiju (pregledi, dermoskopija mladeža, radiotalasno uklanjanje promjena, krioterapija), estetsku medicinu i antiaging (botoks, hijaluronski fileri, skinboosteri, PRP, mezoterapija, hemijski piling), fizikalnu medicinu i rehabilitaciju, te laserske i inovativne tretmane. Poliklinika koristi BTL uređaje Exion, EMface i Emsculpt Neo, kao i Alma lasere Soprano Titanium Special Edition za lasersku epilaciju i Harmony XL Pro sa ClearSkin modulom. Stomatologija je u osnivanju. Od februara 2026. u poliklinici radi i punkt za uzorkovanje krvi laboratorije Moj Lab.',
	description_sr_cyrl = 'Поликлиника MOA (Ministry of Aesthetics) налази се у комплексу The Capital Plaza у Подгорици. Рад поликлинике обухвата пет области: општу хирургију (мањи амбулантни захвати, обрада и превијање рана, уклањање кожних и поткожних промјена), дерматовенерологију (прегледи, дермоскопија младежа, радиоталасно уклањање промјена, криотерапија), естетску медицину и антиагинг (ботокс, хијалуронски филери, скинбоостери, PRP, мезотерапија, хемијски пилинг), физикалну медицину и рехабилитацију, те ласерске и иновативне третмане. Поликлиника користи BTL уређаје Exion, EMface и Emsculpt Neo, као и Alma ласере Soprano Titanium Special Edition за ласерску епилацију и Harmony XL Pro са ClearSkin модулом. Стоматологија је у оснивању. Од фебруара 2026. у поликлиници ради и пункт за узорковање крви лабораторије Moj Lab.',
	description_ru = 'Поликлиника MOA (Ministry of Aesthetics) находится в комплексе The Capital Plaza в Подгорице. Поликлиника работает в пяти направлениях: общая хирургия (небольшие амбулаторные вмешательства, обработка и перевязка ран, удаление кожных и подкожных образований), дерматовенерология (приёмы, дерматоскопия родинок, радиоволновое удаление образований, криотерапия), эстетическая медицина и антиэйдж (ботокс, филлеры на основе гиалуроновой кислоты, скинбустеры, PRP, мезотерапия, химический пилинг), физическая медицина и реабилитация, а также лазерные и аппаратные процедуры. В поликлинике работают аппараты BTL Exion, EMface и Emsculpt Neo, а также лазеры Alma Soprano Titanium Special Edition для лазерной эпиляции и Harmony XL Pro с модулем ClearSkin. Стоматологическое отделение находится в стадии открытия. С февраля 2026 года в поликлинике работает пункт забора крови лаборатории Moj Lab.',
	description_en = 'MOA Polyclinic (Ministry of Aesthetics) is located in The Capital Plaza complex in Podgorica. It works in five areas: general surgery (minor outpatient procedures, wound care and dressing, removal of skin and subcutaneous lesions), dermatovenereology (consultations, dermoscopy of moles, radiowave lesion removal, cryotherapy), aesthetic and anti-ageing medicine (Botox, hyaluronic fillers, skin boosters, PRP, mesotherapy, chemical peels), physical medicine and rehabilitation, and laser and device-based treatments. The polyclinic uses BTL Exion, EMface and Emsculpt Neo devices, as well as Alma Soprano Titanium Special Edition lasers for hair removal and Harmony XL Pro with the ClearSkin module. A dental department is being set up. Since February 2026 the polyclinic has also hosted a Moj Lab blood sampling point.',
	description_de = 'Die Poliklinik MOA (Ministry of Aesthetics) befindet sich im Komplex The Capital Plaza in Podgorica. Sie ist in fünf Bereichen tätig: Allgemeinchirurgie (kleinere ambulante Eingriffe, Wundversorgung und Verbände, Entfernung von Haut- und Unterhautveränderungen), Dermatovenerologie (Untersuchungen, Dermatoskopie von Muttermalen, Radiowellen-Entfernung von Hautveränderungen, Kryotherapie), ästhetische Medizin und Anti-Aging (Botox, Hyaluronfiller, Skinbooster, PRP, Mesotherapie, chemische Peelings), physikalische Medizin und Rehabilitation sowie Laser- und gerätegestützte Behandlungen. Eingesetzt werden die BTL-Geräte Exion, EMface und Emsculpt Neo sowie die Alma-Laser Soprano Titanium Special Edition für die Haarentfernung und Harmony XL Pro mit ClearSkin-Modul. Eine zahnmedizinische Abteilung befindet sich im Aufbau. Seit Februar 2026 gibt es in der Poliklinik außerdem eine Blutentnahmestelle des Labors Moj Lab.',
	description_tr = 'MOA Polikliniği (Ministry of Aesthetics), Podgorica''daki The Capital Plaza kompleksinde yer alır. Poliklinik beş alanda hizmet verir: genel cerrahi (küçük ayakta cerrahi müdahaleler, yara bakımı ve pansuman, deri ve deri altı lezyonlarının çıkarılması), dermatoveneroloji (muayeneler, ben dermoskopisi, radyofrekans ile lezyon giderme, kriyoterapi), estetik tıp ve yaşlanma karşıtı uygulamalar (botoks, hyaluronik dolgular, cilt güçlendiriciler, PRP, mezoterapi, kimyasal peeling), fiziksel tıp ve rehabilitasyon ile lazer ve cihaz destekli uygulamalar. Poliklinikte BTL Exion, EMface ve Emsculpt Neo cihazlarının yanı sıra lazer epilasyon için Alma Soprano Titanium Special Edition ve ClearSkin modüllü Harmony XL Pro lazerleri kullanılır. Diş hekimliği bölümü kuruluş aşamasındadır. Şubat 2026''dan bu yana poliklinikte Moj Lab laboratuvarının kan alma noktası da bulunmaktadır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1, ClinicType.AESTHETIC_CLINIC = 14
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1), (@clinic_id, 14);

-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- «Ponedjeljak - Subota: 09h - 20h»
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS — состав «Upoznajte naš tim» (naslovna, o-nama), 9 врачей + 1 гость.
-- Специальности: 3 GENERAL_SURGERY, 7 DERMATOVENEROLOGY, 20 FAMILY_MEDICINE,
--                42 PHYSICAL_MEDICINE, 44 AESTHETIC_MEDICINE. Язык — только SR (1).
-- Фото — внешние URL moa.clinic (квадратный 408×408 кроп Brizy, 2x из srcset).
-- + prof. dr Miloš Nikolić — гостевой дерматовенеролог из блога, привязан по решению
-- юзера 2026-10-08 (регулярные визиты). Остальные гостевые врачи из блога (dr Iva
-- Ćirović, dr Milica Milenović, dr Sava Latinović, dr Alexander Konovalov, dr Giovanni
-- Angiolini) и присоединявшиеся в 2025 (dr Predrag Milošević, dr Nikolina Ostojić),
-- которых нет в нынешнем составе, НЕ привязаны — см. excluded в data/clinic-imports/poliklinika-moa-podgorica.json.
-- ═══════════════════════════════════════════════════════════════


-- ───────────────────────────────────────────────────────────────
-- dr Đorđe Kaluđerović — Specijalista porodične medicine, sertifikovani doktor estetske medicine
-- В БД уже есть: slug djordjije-kaludjerovic (id 978 локально и на проде).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Đorđe Kaluđerović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kaluđerović Đorđe' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'djordje-kaludjerovic' LIMIT 1));
-- Đorđe = бытовая форма Đorđije: тот же семейный врач из ДЗ Даниловград (подтверждено юзером 2026-10-08).
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'djordjije-kaludjerovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'djordje-kaludjerovic', 'Đorđe Kaluđerović', 'Ђорђе Калуђеровић', 'Джордже Калуджерович', 'Djordje Kaludjerovic', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Dorde-Kaluderovic-408x408x0x0x408x408x1753441686.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://moa.clinic/wp-content/uploads/brizy/imgs/Dorde-Kaluderovic-408x408x0x0x408x408x1753441686.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 20), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista porodične medicine, sertifikovani doktor estetske medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Edin Kulović — Specijalista opšte hirurgije, doktor estetske medicine
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Edin Kulović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Kulović Edin' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'edin-kulovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'edin-kulovic', 'Edin Kulović', 'Един Куловић', 'Эдин Кулович', 'Edin Kulovic', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/WhatsApp-Image-2024-12-17-at-22.16.12_1568e75d-554x740x68x128x408x408x1753441689.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista opšte hirurgije, doktor estetske medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Erna Topalović — Doktor medicine, sertifikovani doktor estetske medicine
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Erna Topalović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Topalović Erna' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'erna-topalovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'erna-topalovic', 'Erna Topalović', 'Ерна Топаловић', 'Эрна Топалович', 'Erna Topalovic', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Erna-Topalovic-scaled-408x612x0x102x408x408x1753441691.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor medicine, sertifikovani doktor estetske medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Marina Vuković — Specijalista fizikalne medicine i rehabilitacije
-- В БД уже есть: slug marina-vukovic (id 1313 локально и на проде).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marina Vuković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vuković Marina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marina-vukovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marina-vukovic', 'Marina Vuković', 'Марина Вуковић', 'Марина Вукович', 'Marina Vukovic', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Marina-Vukovic-408x544x0x68x408x408x1753441689.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://moa.clinic/wp-content/uploads/brizy/imgs/Marina-Vukovic-408x544x0x68x408x408x1753441689.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 42);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista fizikalne medicine i rehabilitacije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Petar Milić — Specijalista opšte hirurgije
-- В БД уже есть: slug milic-petar (id 329 локально и на проде).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Petar Milić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Milić Petar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milic-petar' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milic-petar', 'Petar Milić', 'Петар Милић', 'Петар Милич', 'Petar Milic', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Petar-Milic-408x408x0x0x408x408x1753441685.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://moa.clinic/wp-content/uploads/brizy/imgs/Petar-Milic-408x408x0x0x408x408x1753441685.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista opšte hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Milan Đorđević — Specijalista opšte hirurgije, doktor estetske i antiejdžing medicine
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milan Đorđević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đorđević Milan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milan-djordjevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milan-djordjevic', 'Milan Đorđević', 'Милан Ђорђевић', 'Милан Джорджевич', 'Milan Djordjevic', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Milan-Dordevic-408x462x0x0x408x408x1753441686.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista opšte hirurgije, doktor estetske i antiejdžing medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Natalia Shamenkova — Specijalista dermatologije, doktor estetske medicine
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Natalia Shamenkova' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Shamenkova Natalia' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'natalia-shamenkova' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natalia-shamenkova', 'Natalia Shamenkova', 'Наталија Шаменкова', 'Наталья Шаменкова', 'Natalia Shamenkova', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Natalia-Shamenkova-408x612x0x132x408x408x1753441691.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET
	description_sr = 'Specijalista dermatologije i doktor estetske medicine. Bavi se tretmanima botoksom, dermalnim filerima i PRP terapijom za regeneraciju i revitalizaciju kože, s fokusom na prirodno podmlađivanje i očuvanje prirodnih crta lica.',
	description_sr_cyrl = 'Специјалиста дерматологије и доктор естетске медицине. Бави се третманима ботоксом, дермалним филерима и PRP терапијом за регенерацију и ревитализацију коже, с фокусом на природно подмлађивање и очување природних црта лица.',
	description_ru = 'Дерматолог и врач эстетической медицины. Проводит процедуры с ботоксом, дермальными филлерами и PRP-терапию для регенерации и восстановления кожи, делая акцент на естественном омоложении и сохранении природных черт лица.',
	description_en = 'Dermatologist and aesthetic medicine doctor. She performs Botox treatments, dermal fillers and PRP therapy for skin regeneration and revitalisation, with a focus on natural rejuvenation and preserving natural facial features.',
	description_de = 'Fachärztin für Dermatologie und Ärztin für ästhetische Medizin. Sie führt Botox-Behandlungen, dermale Filler und PRP-Therapie zur Regeneration und Revitalisierung der Haut durch, mit Schwerpunkt auf natürlicher Verjüngung und dem Erhalt natürlicher Gesichtszüge.',
	description_tr = 'Dermatoloji uzmanı ve estetik tıp hekimi. Cildin yenilenmesi ve canlandırılması için botoks, dermal dolgu ve PRP tedavisi uygular; doğal gençleşmeye ve yüzün doğal hatlarının korunmasına odaklanır.'
WHERE id = @doctor_id;
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatologije, doktor estetske medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Sanja Vujanović — Specijalista dermatovenerologije
-- В БД уже есть: slug sanja-vujanovic (id 1128 локально и на проде).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sanja Vujanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vujanović Sanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sanja-vujanovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-vujanovic', 'Sanja Vujanović', 'Сања Вујановић', 'Саня Вуянович', 'Sanja Vujanovic', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Sanja-Vujanovic-456x408x48x0x408x408x1753441689.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://moa.clinic/wp-content/uploads/brizy/imgs/Sanja-Vujanovic-456x408x48x0x408x408x1753441689.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatovenerologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Bilal Albeik — Specijalista estetske dermatologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Bilal Albeik' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Albeik Bilal' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'bilal-albeik' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bilal-albeik', 'Bilal Albeik', 'Билал Албеик', 'Билал Албейк', 'Bilal Albeik', 'dr',
	'https://moa.clinic/wp-content/uploads/brizy/imgs/Bilal-Albeik-min-scaled-408x612x0x0x408x408x1753441689.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET
	description_sr = 'Specijalista estetske dermatologije. Bavi se liječenjem akni i ožiljaka od akni, uklanjanjem hiperpigmentacija, tretmanima rozacee i anti-age procedurama (botoks, fileri i laserski tretmani), s posebnim fokusom na probleme s aknama i njihove posljedice.',
	description_sr_cyrl = 'Специјалиста естетске дерматологије. Бави се лијечењем акни и ожиљака од акни, уклањањем хиперпигментација, третманима розацее и анти-аге процедурама (ботокс, филери и ласерски третмани), с посебним фокусом на проблеме с акнама и њихове посљедице.',
	description_ru = 'Специалист по эстетической дерматологии. Занимается лечением акне и постакне, устранением гиперпигментации, лечением розацеа и антивозрастными процедурами (ботокс, филлеры и лазерные процедуры), уделяя особое внимание проблемам акне и их последствиям.',
	description_en = 'Aesthetic dermatology specialist. He treats acne and acne scars, hyperpigmentation and rosacea and performs anti-ageing procedures (Botox, fillers and laser treatments), with a particular focus on acne and its after-effects.',
	description_de = 'Facharzt für ästhetische Dermatologie. Er behandelt Akne und Aknenarben, Hyperpigmentierungen und Rosazea und führt Anti-Aging-Behandlungen durch (Botox, Filler und Laserbehandlungen), mit besonderem Schwerpunkt auf Akne und ihren Folgen.',
	description_tr = 'Estetik dermatoloji uzmanı. Akne ve akne izleri, hiperpigmentasyon ve rozasea tedavisi ile yaşlanma karşıtı işlemler (botoks, dolgu ve lazer uygulamaları) yapar; özellikle akne ve sonrasında kalan sorunlara odaklanır.'
WHERE id = @doctor_id;
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista estetske dermatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Miloš Nikolić — Specijalista dermatovenerologije, gostujući doktor
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Miloš Nikolić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Nikolić Miloš' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milos-nikolic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milos-nikolic', 'Miloš Nikolić', 'Милош Николић', 'Милош Николич', 'Milos Nikolic', 'Prof. dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET
	description_sr = 'Specijalista dermatovenerologije (MD, PhD, FRCP (Edin)). Predsjednik je Katedre za dermatovenerologiju Medicinskog fakulteta Univerziteta u Beogradu i načelnik Odjeljenja za pedijatrijsku i adolescentnu dermatologiju Klinike za dermatovenerologiju Univerzitetskog kliničkog centra Srbije. Bavi se širokim spektrom dermatoloških stanja, s posebnim akcentom na pedijatrijsku i adolescentnu dermatologiju.',
	description_sr_cyrl = 'Специјалиста дерматовенерологије (MD, PhD, FRCP (Edin)). Предсједник је Катедре за дерматовенерологију Медицинског факултета Универзитета у Београду и начелник Одјељења за педијатријску и адолесцентну дерматологију Клинике за дерматовенерологију Универзитетског клиничког центра Србије. Бави се широким спектром дерматолошких стања, с посебним акцентом на педијатријску и адолесцентну дерматологију.',
	description_ru = 'Дерматовенеролог (MD, PhD, FRCP (Edin)). Заведует кафедрой дерматовенерологии медицинского факультета Белградского университета и возглавляет отделение детской и подростковой дерматологии Клиники дерматовенерологии Университетского клинического центра Сербии. Занимается широким спектром кожных заболеваний, с особым акцентом на детскую и подростковую дерматологию.',
	description_en = 'Dermatovenereologist (MD, PhD, FRCP (Edin)). He chairs the Department of Dermatovenereology at the Faculty of Medicine, University of Belgrade, and heads the Paediatric and Adolescent Dermatology Unit of the Clinic of Dermatovenereology at the University Clinical Centre of Serbia. He treats a wide range of skin conditions, with a particular focus on paediatric and adolescent dermatology.',
	description_de = 'Facharzt für Dermatovenerologie (MD, PhD, FRCP (Edin)). Er leitet den Lehrstuhl für Dermatovenerologie der Medizinischen Fakultät der Universität Belgrad sowie die Abteilung für pädiatrische und Adoleszentendermatologie der Klinik für Dermatovenerologie des Universitätsklinikums Serbien. Er behandelt ein breites Spektrum von Hauterkrankungen mit besonderem Schwerpunkt auf der Kinder- und Jugenddermatologie.',
	description_tr = 'Dermatoveneroloji uzmanı (MD, PhD, FRCP (Edin)). Belgrad Üniversitesi Tıp Fakültesi Dermatoveneroloji Anabilim Dalı başkanı ve Sırbistan Üniversite Klinik Merkezi Dermatoveneroloji Kliniği Çocuk ve Ergen Dermatolojisi Bölümü şefidir. Çocuk ve ergen dermatolojisine özel önem vererek geniş bir yelpazede cilt hastalıklarını tedavi eder.'
WHERE id = @doctor_id;
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 7);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dermatovenerologije, gostujući doktor')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, languages = 1, types = 1,14,
-- working_hours = 1.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 10 врачей. Существующие (created_at старше сегодняшнего): milic-petar,
-- marina-vukovic, sanja-vujanovic, djordjije-kaludjerovic. Остальные 6 — новые
-- (включая гостя milos-nikolic, у него NO PHOTO — отдельного портрета на сайте нет).
SELECT d.id, d.slug, d.name_sr, dc.position,
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

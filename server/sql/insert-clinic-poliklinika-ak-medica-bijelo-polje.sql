-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika AK Medica (Bijelo Polje) — клиника + 13 врачей
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-ak-medica-bijelo-polje.sql
-- Затем: server/sql/insert-clinic-poliklinika-ak-medica-bijelo-polje-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://akmedica.me/ — WordPress + Elementor, читается через wp-json /wp/v2/pages (46 страниц,
--     правки 2025-08…2026-08-24) и /wp/v2/posts (3 новости 2026-08-24), плюс HTML /nas-tim/ (фото).
--   * data/google-places/bijelo-polje/poliklinika-ak-medica.json — place_id, координаты, адрес.
--
-- Сверка фактов:
--   * Адрес: на сайте только «Bijelo Polje 84000» (/kontakt). Улица — из Google:
--     «47 Voja Lješnjaka, Бијело Поље 84000». Записан как «Voja Lješnjaka 47».
--   * Координаты 43.0394365 / 19.7556464 — Google Places, единственный источник.
--   * Телефон: сайт «+382 68 955 555» (шапка, /kontakt), Google — тот же.
--   * Email: «info@akmedica.me» — текст шапки, футер, /kontakt. ⚠️ mailto в шапке ведёт на
--     info@akmedica.com — опечатка ссылки, видимый текст и остальные места дают .me.
--   * Соцсетей на сайте нет.
--   * Часы: /kontakt «Ponedjeljak – Subota: 09-21h, Nedjelja: Zatvoreno».
--   * Языки клиники: только SR — сайт только на черногорском, о других языках ничего.
--   * Тип: POLYCLINIC (1) — «Poliklinika AK MEDICA je privatna zdravstvena ustanova».
--   * Логотип — site icon WordPress 270×270.
--
-- Врачи: 13 со страницы /nas-tim/. Фото — внешние URL akmedica.me (средний размер из srcset,
-- 768 px; у Dapčević — оригинал, другого нет). У трёх врачей (Zlajić, Salković, Metić) вместо фото
-- заглушка 2025/05/images.png, которая отдаёт 404 — photo_url NULL. 8 врачей уже есть в БД —
-- существующих файл не переименовывает и их описания не трогает; фото дозаполняет, только если пусто.
-- Биографий на сайте нет (кроме новостей: Muhović — делегат ESBGH, у врача уже есть запись).
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей, описание клиники пишется
-- безусловным UPDATE (правки из админки следующий прогон перезатрёт — вносить сюда).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════


SET @google_place_id = 'ChIJp_rPsp2lUhMRAP5YnLNnO7I';
SET @clinic_slug = 'poliklinika-ak-medica-bijelo-polje';

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
	12, -- CityId.BELO_POLJE
	'Poliklinika AK Medica',
	'Поликлиника AK Medica',
	'Поликлиника AK Medica',
	'Voja Lješnjaka 47',
	'Воја Љешњака 47',
	'',
	'',
	'84000',
	43.03943650,
	19.75564640,
	'+38268955555',
	'info@akmedica.me',
	'https://akmedica.me/',
	'', -- на сайте нет
	'', -- на сайте нет
	'',
	'',
	'',
	'https://akmedica.me/wp-content/uploads/2025/05/cropped-AK-Medica-Ikonica-270x270.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника AK Medica', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника AK Medica', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Voja Lješnjaka 47', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Воја Љешњака 47', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '84000', postal_code),
	latitude = COALESCE(latitude, 43.03943650),
	longitude = COALESCE(longitude, 19.75564640),
	phone = IF(phone IS NULL OR phone = '', '+38268955555', phone),
	email = IF(email IS NULL OR email = '', 'info@akmedica.me', email),
	website = IF(website IS NULL OR website = '', 'https://akmedica.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://akmedica.me/wp-content/uploads/2025/05/cropped-AK-Medica-Ikonica-270x270.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись (правки из админки следующий прогон перезатрёт — вносить сюда).
UPDATE clinics SET
	description_sr = 'Poliklinika AK MEDICA je privatna zdravstvena ustanova u Bijelom Polju, osnovana s ciljem da građanima Bijelog Polja i okoline pruži kvalitetnu zdravstvenu uslugu. U poliklinici ordiniraju ljekari iz oblasti kardiologije, gastroenterohepatologije, pulmologije, reumatologije, hematologije, endokrinologije, neurologije, alergologije, urologije i psihijatrije, a radi se i terapija bola. Dijagnostika obuhvata EKG, ultrazvuk srca, Holter EKG-a i Holter krvnog pritiska, ultrazvuk abdomena, štitaste žlijezde, vrata, pazušnih jama i preponske regije, pluća, zglobova i mekih tkiva, urološki ultrazvuk, kolor dopler krvnih sudova vrata i ekstremiteta, EEG i EMNG, kao i gastroskopiju i kolonoskopiju sa ili bez analgosedacije, uz endoskopske intervencije (biopsije, polipektomija, EMR i ESD). Poliklinika radi od ponedjeljka do subote, od 9 do 21 čas.',
	description_sr_cyrl = 'Поликлиника AK MEDICA је приватна здравствена установа у Бијелом Пољу, основана с циљем да грађанима Бијелог Поља и околине пружи квалитетну здравствену услугу. У поликлиници ординирају љекари из области кардиологије, гастроентерохепатологије, пулмологије, реуматологије, хематологије, ендокринологије, неурологије, алергологије, урологије и психијатрије, а ради се и терапија бола. Дијагностика обухвата ЕКГ, ултразвук срца, Холтер ЕКГ-а и Холтер крвног притиска, ултразвук абдомена, штитасте жлијезде, врата, пазушних јама и препонске регије, плућа, зглобова и меких ткива, уролошки ултразвук, колор доплер крвних судова врата и екстремитета, ЕЕГ и ЕМНГ, као и гастроскопију и колоноскопију са или без аналгоседације, уз ендоскопске интервенције (биопсије, полипектомија, EMR и ESD). Поликлиника ради од понедјељка до суботе, од 9 до 21 час.',
	description_ru = 'Поликлиника AK MEDICA — частное медицинское учреждение в Биело-Поле, созданное, чтобы жители Биело-Поле и окрестностей могли получать качественную медицинскую помощь. В поликлинике принимают кардиолог, гастроэнтеролог-гепатолог, пульмонолог, ревматолог, гематолог, эндокринолог, невролог, аллерголог, уролог и психиатр, проводится терапия боли. Диагностика включает ЭКГ, УЗИ сердца, холтеровское мониторирование ЭКГ и артериального давления, УЗИ брюшной полости, щитовидной железы, шеи, подмышечных и паховых областей, лёгких, суставов и мягких тканей, урологическое УЗИ, цветное допплеровское исследование сосудов шеи и конечностей, ЭЭГ и ЭМНГ, а также гастроскопию и колоноскопию с седацией или без неё и эндоскопические вмешательства (биопсии, полипэктомия, EMR и ESD). Поликлиника работает с понедельника по субботу с 9 до 21 часа.',
	description_en = 'AK MEDICA is a private polyclinic in Bijelo Polje, founded to provide quality healthcare to the people of Bijelo Polje and the surrounding area. Its doctors cover cardiology, gastroenterology and hepatology, pulmonology, rheumatology, haematology, endocrinology, neurology, allergology, urology and psychiatry, and the polyclinic also offers pain therapy. Diagnostics include ECG, echocardiography, Holter ECG and ambulatory blood pressure monitoring, ultrasound of the abdomen, thyroid, neck, armpits and groin, lungs, joints and soft tissues, urological ultrasound, colour Doppler of the neck and limb vessels, EEG and EMNG, as well as gastroscopy and colonoscopy with or without sedation and endoscopic procedures (biopsies, polypectomy, EMR and ESD). The polyclinic is open Monday to Saturday, 9:00 to 21:00.',
	description_de = 'Die Poliklinik AK MEDICA ist eine private Gesundheitseinrichtung in Bijelo Polje, gegründet, um den Bürgern von Bijelo Polje und Umgebung eine hochwertige medizinische Versorgung zu bieten. Hier praktizieren Ärzte der Kardiologie, Gastroenterologie und Hepatologie, Pneumologie, Rheumatologie, Hämatologie, Endokrinologie, Neurologie, Allergologie, Urologie und Psychiatrie; außerdem wird Schmerztherapie angeboten. Die Diagnostik umfasst EKG, Herzultraschall, Langzeit-EKG und Langzeitblutdruckmessung, Ultraschall von Abdomen, Schilddrüse, Hals, Achselhöhlen und Leistenregion, Lunge, Gelenken und Weichteilen, urologischen Ultraschall, Farbdoppler der Hals- und Extremitätengefäße, EEG und EMNG sowie Gastroskopie und Koloskopie mit oder ohne Sedierung mit endoskopischen Eingriffen (Biopsien, Polypektomie, EMR und ESD). Die Poliklinik ist von Montag bis Samstag von 9 bis 21 Uhr geöffnet.',
	description_tr = 'AK MEDICA Polikliniği, Bijelo Polje ve çevresinde yaşayanlara kaliteli sağlık hizmeti sunmak amacıyla kurulmuş, Bijelo Polje''de özel bir sağlık kuruluşudur. Poliklinikte kardiyoloji, gastroenteroloji ve hepatoloji, göğüs hastalıkları, romatoloji, hematoloji, endokrinoloji, nöroloji, alerji, üroloji ve psikiyatri alanlarında hekimler muayene eder; ağrı tedavisi de yapılır. Tanı hizmetleri arasında EKG, ekokardiyografi, Holter EKG ve Holter tansiyon takibi, karın, tiroid, boyun, koltuk altı ve kasık bölgesi, akciğer, eklem ve yumuşak doku ultrasonu, ürolojik ultrason, boyun ve ekstremite damarlarının renkli Doppler''i, EEG ve EMNG ile sedasyonlu veya sedasyonsuz gastroskopi ve kolonoskopi ve endoskopik girişimler (biyopsi, polipektomi, EMR ve ESD) yer alır. Poliklinik pazartesiden cumartesiye 09:00–21:00 saatleri arasında açıktır.'
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

-- «Ponedjeljak – Subota: 09-21h, Nedjelja: Zatvoreno»
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "21:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS — состав /nas-tim/, 13 врачей.
-- Специальности: 1 CARDIOLOGY, 8 NEUROLOGY, 9 UROLOGY, 12 ENDOCRINOLOGY, 13 GASTROENTEROLOGY,
--                15 HEMATOLOGY, 16 RHEUMATOLOGY, 21 PSYCHIATRY, 79 ALLERGOLOGY, 80 IMMUNOLOGY.
-- Язык — только SR (1). Титул на сайте у всех «dr».
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Ivan Božović — Endokrinolog
-- В БД есть: ivan-bozovic (Opšta bolnica Bijelo Polje, интернист-эндокринолог) — тот же город.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivan Božović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Božović Ivan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivan-bozovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-bozovic', 'Ivan Božović', 'Иван Божовић', 'Иван Божович', 'Ivan Bozovic', 'dr',
	'https://akmedica.me/wp-content/uploads/2026/08/dr-Ivan-Bozovic-endokrinolog-768x1269.png', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2026/08/dr-Ivan-Bozovic-endokrinolog-768x1269.png' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 12);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Endokrinolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Milena Dapčević — Hematolog
-- В БД есть: milena-dapcevic (KCCG, Luča, гематолог, с био) — описание не трогаем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milena Dapčević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Dapčević Milena' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milena-dapcevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milena-dapcevic', 'Milena Dapčević', 'Милена Дапчевић', 'Милена Дапчевич', 'Milena Dapcevic', 'dr',
	'https://akmedica.me/wp-content/uploads/2026/08/dr-Milena-Dapcevic-hematolog.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2026/08/dr-Milena-Dapcevic-hematolog.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 15);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Hematolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Almir Rebronja — Urolog
-- В БД есть: almir-rebronja (KCCG). Тот же врач — в Poliklinika Da Vinci (Podgorica).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Almir Rebronja' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Rebronja Almir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'almir-rebronja' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'almir-rebronja', 'Almir Rebronja', 'Алмир Реброња', 'Алмир Ребронья', 'Almir Rebronja', 'dr',
	'https://akmedica.me/wp-content/uploads/2026/08/Untitled-3-768x1109.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2026/08/Untitled-3-768x1109.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Urolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Nataša Bogavac — Endokrinolog
-- Новая. В БД есть natasa-tmusic-bogavac (izabrani doktor za odrasle, ДЗ) — другая специальность
-- и двойная фамилия, не сопоставляем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nataša Bogavac' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bogavac Nataša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'natasa-bogavac' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'natasa-bogavac', 'Nataša Bogavac', 'Наташа Богавац', 'Наташа Богавац', 'Natasa Bogavac', 'dr',
	'https://akmedica.me/wp-content/uploads/2025/10/10-768x1141.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2025/10/10-768x1141.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 12);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Endokrinolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Damir Muhović — Gastroenterohepatolog
-- В БД есть: damir-muhovic (KCCG, Moj Lab, A3 Medical).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Damir Muhović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Muhović Damir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'damir-muhovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'damir-muhovic', 'Damir Muhović', 'Дамир Муховић', 'Дамир Мухович', 'Damir Muhovic', 'dr',
	'https://akmedica.me/wp-content/uploads/2025/09/04-768x1141.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2025/09/04-768x1141.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 13);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Gastroenterohepatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Milan Madžgalj — Neurolog
-- В БД есть: milan-madzgalj (ДЗ и Opšta bolnica Bijelo Polje).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milan Madžgalj' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Madžgalj Milan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milan-madzgalj' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milan-madzgalj', 'Milan Madžgalj', 'Милан Маџгаљ', 'Милан Маджгаль', 'Milan Madzgalj', 'dr',
	'https://akmedica.me/wp-content/uploads/2025/10/05-768x1141.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2025/10/05-768x1141.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 8);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Neurolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Nikola Delević — Alergolog i klinički imunolog
-- В БД есть: nikola-delevic (KCCG, Kerber). «alergolog» (nas-tim), «alergologa i kliničkog imunologa» (новость).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nikola Delević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Delević Nikola' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nikola-delevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-delevic', 'Nikola Delević', 'Никола Делевић', 'Никола Делевич', 'Nikola Delevic', 'dr',
	'https://akmedica.me/wp-content/uploads/2025/10/09-768x1141.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2025/10/09-768x1141.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 79), (@doctor_id, 80);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Alergolog i klinički imunolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Erol Muratović — Kardiolog
-- В БД есть: erol-muratovic (Opšta bolnica Bijelo Polje).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Erol Muratović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Muratović Erol' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'erol-muratovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'erol-muratovic', 'Erol Muratović', 'Ерол Муратовић', 'Эрол Муратович', 'Erol Muratovic', 'dr',
	'https://akmedica.me/wp-content/uploads/2025/10/07-768x1141.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2025/10/07-768x1141.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Kardiolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Ivan Vučetić — Reumatolog
-- Новый. На сайте «Vuče­tić» с мягким переносом (U+00AD) — снят.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivan Vučetić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vučetić Ivan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivan-vucetic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-vucetic', 'Ivan Vučetić', 'Иван Вучетић', 'Иван Вучетич', 'Ivan Vucetic', 'dr',
	'https://akmedica.me/wp-content/uploads/2025/10/08-768x1141.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2025/10/08-768x1141.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 16);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Reumatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Stefan Stojković — Gastroenterohepatolog
-- Новый.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Stefan Stojković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Stojković Stefan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'stefan-stojkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stefan-stojkovic', 'Stefan Stojković', 'Стефан Стојковић', 'Стефан Стойкович', 'Stefan Stojkovic', 'dr',
	'https://akmedica.me/wp-content/uploads/2025/10/06-768x1141.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://akmedica.me/wp-content/uploads/2025/10/06-768x1141.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 13);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Gastroenterohepatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Aleksandar Zlajić — Psihijatar
-- В БД есть: aleksandar-zlajic (Opšta bolnica Bijelo Polje). Фото на сайте — битая заглушка
-- (2025/05/images.png → 404).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Zlajić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Zlajić Aleksandar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aleksandar-zlajic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-zlajic', 'Aleksandar Zlajić', 'Александар Злајић', 'Александар Злаич', 'Aleksandar Zlajic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Psihijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Enes Salković — Psihijatar
-- Новый. Фото — битая заглушка (404), photo_url NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Enes Salković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Salković Enes' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'enes-salkovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'enes-salkovic', 'Enes Salković', 'Енес Салковић', 'Энес Салкович', 'Enes Salkovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Psihijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Mersija Metić — Neurolog
-- Новая. Фото — битая заглушка (404), photo_url NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mersija Metić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Metić Mersija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mersija-metic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mersija-metic', 'Mersija Metić', 'Мерсија Метић', 'Мерсия Метич', 'Mersija Metic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 8);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Neurolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: status = published, languages = 1, types = 1, working_hours = 1.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 13 врачей.
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

-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Da Vinci (Podgorica) — клиника + 18 врачей
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-da-vinci-podgorica.sql
-- Затем: server/sql/insert-clinic-poliklinika-da-vinci-podgorica-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://davincipoliklinika.me/ — WordPress + Elementor, читается curl'ом (HTML страниц) и
--     wp-json /wp/v2/pages (16 страниц) / posts (6 записей). В Google указан старый домен
--     poliklinikadavinci.me — не отвечает (соединение висит), его не пишем.
--     Главная (контакты, часы, направления), /tim-davinci/ (состав), /neven-vavic/ (био),
--     8 страниц направлений из меню.
--   * data/google-places/podgorica/poliklinika-davinci.json — place_id, координаты.
--
-- Сверка фактов:
--   * Адрес: сайт «4. jula bb, 81000 Podgorica» (шапка всех страниц), Google «bb 4. Jul, Podgorica» —
--     согласованы. Записан с сайта.
--   * Координаты 42.4261178 / 19.2570443 — Google Places, единственный источник.
--   * Телефоны: сайт «+38269059359 +38267059359 +38268059359» (шапка), Google подтверждает первый.
--   * Email: на сайте «infopoliklinikadavinci.me» — без @, и домен poliklinikadavinci.me мёртв.
--     Не записан (см. openQuestions записи импорта).
--   * Соцсети: шапка — instagram.com/poliklinikadavinci, facebook.com/PoliklinikaDaVinciOfficial.
--     Viber/WhatsApp сайт упоминает без номера — поля не заполняем.
--   * Часы: «Radno vrijeme Pon-Sub od 08h do 20h» (главная). Воскресенье не названо — записано
--     closed: пн–сб перечислены как рабочие явно (как MOA).
--   * Языки клиники: только SR — сайт только на черногорском, о других языках ничего.
--   * Тип: POLYCLINIC (1) — «zdravstvena ustanova organizovana po principu poliklinike sa dnevnom
--     bolnicom». HOSPITAL (3) не ставим — см. openQuestions.
--   * /cjenovnik/ — ЗАГЛУШКА темы («Operacija 1 2589eur», Lorem ipsum ×3) — цены не берутся.
--   * /contact/ — заглушка темы (Florida, Netherlands) — не источник.
--   * Отзывы-цитаты на главной («Milić Maljević, IT Tehničar» и др.) и часть постов блога — шаблонные,
--     в описание не переносятся.
--
-- Врачи: 18 со страницы /tim-davinci/. У всех, кроме dr Vavića, вместо фото — плейсхолдер
-- темы (Image_Placeholder-13122021.jpg), photo_url NULL. 10 уже есть в БД (KCCG и др.) — существующих
-- врачей файл не переименовывает и их описания не трогает; position у этой клиники — с сайта.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей, описания пишутся безусловным
-- UPDATE (правки из админки следующий прогон перезатрёт — вносить сюда), языки клиники синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════


SET @google_place_id = 'ChIJkc08ut3rTRMRWn6Gc02KfjM';
SET @clinic_slug = 'poliklinika-da-vinci-podgorica';

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
	'Poliklinika Da Vinci',
	'Поликлиника Da Vinci',
	'Поликлиника Da Vinci',
	'4. jula bb',
	'4. јула бб',
	'',
	'',
	'81000',
	42.42611780,
	19.25704430,
	'+38269059359;+38267059359;+38268059359',
	'', -- на сайте «infopoliklinikadavinci.me» без @, домен poliklinikadavinci.me мёртв — не пишем
	'https://davincipoliklinika.me/',
	'facebook.com/PoliklinikaDaVinciOfficial',
	'@poliklinikadavinci',
	'',
	'',
	'',
	'https://davincipoliklinika.me/wp-content/uploads/2024/08/cropped-DaVinciOriginal.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Da Vinci', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Da Vinci', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', '4. jula bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', '4. јула бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude = COALESCE(latitude, 42.42611780),
	longitude = COALESCE(longitude, 19.25704430),
	phone = IF(phone IS NULL OR phone = '', '+38269059359;+38267059359;+38268059359', phone),
	website = IF(website IS NULL OR website = '', 'https://davincipoliklinika.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/PoliklinikaDaVinciOfficial', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@poliklinikadavinci', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://davincipoliklinika.me/wp-content/uploads/2024/08/cropped-DaVinciOriginal.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись (правки из админки следующий прогон перезатрёт — вносить сюда).
UPDATE clinics SET
	description_sr = 'Poliklinika Da Vinci u Podgorici je zdravstvena ustanova organizovana po principu poliklinike sa dnevnom bolnicom i savremeno opremljenom operacionom salom. Osnovali su je ljekari koji su ujedno i okosnica njenog rada. Poliklinika pruža usluge iz oblasti urologije (sa akcentom na laparoskopske metode), nefrologije, hematologije, hirurgije, ginekologije, onkologije, kardiologije i endokrinologije. Hirurški tim izvodi minimalno invazivne, laparoskopske zahvate: uklanjanje žučne kese, slijepog crijeva, operacije kila i resekcije crijeva. Konsultanti su ljekari Kliničkog centra Crne Gore i Vojnomedicinske akademije u Beogradu, mahom načelnici klinika i odjeljenja; poliklinika navodi da pacijentima stoji na raspolaganju preko 20 konsultanata sa VMA. Pregled se zakazuje preko kol centra, dostupnog kod sva tri mobilna operatera u Crnoj Gori, ili putem aplikacija Viber i WhatsApp.',
	description_sr_cyrl = 'Поликлиника Da Vinci у Подгорици је здравствена установа организована по принципу поликлинике са дневном болницом и савремено опремљеном операционом салом. Основали су је љекари који су уједно и окосница њеног рада. Поликлиника пружа услуге из области урологије (са акцентом на лапароскопске методе), нефрологије, хематологије, хирургије, гинекологије, онкологије, кардиологије и ендокринологије. Хируршки тим изводи минимално инвазивне, лапароскопске захвате: уклањање жучне кесе, слијепог цријева, операције кила и ресекције цријева. Консултанти су љекари Клиничког центра Црне Горе и Војномедицинске академије у Београду, махом начелници клиника и одјељења; поликлиника наводи да пацијентима стоји на располагању преко 20 консултаната са ВМА. Преглед се заказује преко кол центра, доступног код сва три мобилна оператера у Црној Гори, или путем апликација Viber и WhatsApp.',
	description_ru = 'Поликлиника Da Vinci в Подгорице — медицинское учреждение, организованное как поликлиника с дневным стационаром и современной операционной. Её основали врачи, которые и составляют основу её работы. Поликлиника работает по направлениям урология (с упором на лапароскопические методы), нефрология, гематология, хирургия, гинекология, онкология, кардиология и эндокринология. Хирургическая команда выполняет малоинвазивные лапароскопические вмешательства: удаление желчного пузыря и аппендикса, операции при грыжах и резекции кишечника. Консультируют врачи Клинического центра Черногории и Военно-медицинской академии (VMA) в Белграде, в основном заведующие клиниками и отделениями; по словам поликлиники, пациентам доступны более 20 консультантов из VMA. Записаться на приём можно через колл-центр, доступный у всех трёх мобильных операторов Черногории, а также через Viber и WhatsApp.',
	description_en = 'Da Vinci Polyclinic in Podgorica is a healthcare facility organised as a polyclinic with a day hospital and a modern operating theatre. It was founded by doctors who also form the core of its work. The polyclinic covers urology (with an emphasis on laparoscopic methods), nephrology, haematology, surgery, gynaecology, oncology, cardiology and endocrinology. The surgical team performs minimally invasive laparoscopic procedures: gallbladder and appendix removal, hernia repair and bowel resection. Consultants are doctors from the Clinical Centre of Montenegro and the Military Medical Academy (VMA) in Belgrade, mostly heads of clinics and departments; the polyclinic states that more than 20 VMA consultants are available to patients. Appointments are booked through a call centre reachable on all three mobile networks in Montenegro, as well as via Viber and WhatsApp.',
	description_de = 'Die Poliklinik Da Vinci in Podgorica ist eine Gesundheitseinrichtung, die als Poliklinik mit Tagesklinik und modern ausgestattetem Operationssaal organisiert ist. Gegründet wurde sie von Ärzten, die zugleich den Kern ihrer Arbeit bilden. Die Poliklinik deckt Urologie (mit Schwerpunkt auf laparoskopischen Methoden), Nephrologie, Hämatologie, Chirurgie, Gynäkologie, Onkologie, Kardiologie und Endokrinologie ab. Das chirurgische Team führt minimalinvasive laparoskopische Eingriffe durch: Entfernung von Gallenblase und Blinddarm, Hernienoperationen und Darmresektionen. Als Konsiliarärzte arbeiten Ärzte des Klinischen Zentrums Montenegro und der Militärmedizinischen Akademie (VMA) in Belgrad, überwiegend Leiter von Kliniken und Abteilungen; nach Angaben der Poliklinik stehen den Patienten über 20 Konsiliarärzte der VMA zur Verfügung. Termine werden über ein Callcenter vereinbart, das in allen drei Mobilfunknetzen Montenegros erreichbar ist, sowie über Viber und WhatsApp.',
	description_tr = 'Podgorica''daki Da Vinci Polikliniği, günübirlik hastanesi ve modern donanımlı ameliyathanesi bulunan bir poliklinik olarak örgütlenmiş bir sağlık kuruluşudur. Kliniği, aynı zamanda çalışmalarının temelini oluşturan hekimler kurmuştur. Poliklinik üroloji (laparoskopik yöntemlere ağırlık vererek), nefroloji, hematoloji, cerrahi, jinekoloji, onkoloji, kardiyoloji ve endokrinoloji alanlarında hizmet verir. Cerrahi ekip minimal invaziv laparoskopik girişimler yapar: safra kesesi ve apandis alınması, fıtık ameliyatları ve bağırsak rezeksiyonları. Konsültan olarak Karadağ Klinik Merkezi ile Belgrad Askeri Tıp Akademisi (VMA) hekimleri, çoğunlukla klinik ve bölüm şefleri çalışır; poliklinik hastaların 20''den fazla VMA konsültanına ulaşabildiğini belirtmektedir. Randevular Karadağ''daki üç mobil operatörün hepsinden ulaşılabilen çağrı merkezi ile Viber ve WhatsApp üzerinden alınır.'
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

-- «Radno vrijeme Pon-Sub od 08h do 20h»
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
-- PART 3: DOCTORS — состав /tim-davinci/, 18 врачей.
-- Специальности: 1 CARDIOLOGY, 2 INTERNAL_MEDICINE, 3 GENERAL_SURGERY, 9 UROLOGY, 12 ENDOCRINOLOGY,
--                15 HEMATOLOGY, 34 VASCULAR_SURGERY, 46 NEPHROLOGY, 47 ONCOLOGY, 90 GASTROINTESTINAL_SURGERY.
-- Язык — только SR (1). Титулы — как на сайте; у кого титула нет — «dr».
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Aleksandar Magdelinić — Urolog, direktor Klinike za urologiju KCCG
-- В БД есть: aleksandar-magdelinic (KCCG, Novi Cenex).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Magdelinić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Magdelinić Aleksandar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aleksandar-magdelinic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-magdelinic', 'Aleksandar Magdelinić', 'Александар Магделинић', 'Александар Магделинич', 'Aleksandar Magdelinic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Urolog, direktor Klinike za urologiju KCCG')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Prof Predrag Aleksić — Urolog, načelnik Klinike za urologiju VMA
-- Новый.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Predrag Aleksić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Aleksić Predrag' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'predrag-aleksic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-aleksic', 'Predrag Aleksić', 'Предраг Алексић', 'Предраг Алексич', 'Predrag Aleksic', 'Prof. dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Urolog, načelnik Klinike za urologiju VMA')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Eldin Šabović — Urolog, načelnik Odjeljenja za endoskopiju Klinike za urologiju KCCG
-- В БД есть: eldin-sabovic (KCCG, Natal).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Eldin Šabović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Šabović Eldin' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'eldin-sabovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'eldin-sabovic', 'Eldin Šabović', 'Елдин Шабовић', 'Элдин Шабович', 'Eldin Sabovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Urolog, načelnik Odjeljenja za endoskopiju Klinike za urologiju KCCG')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Almir Rebronja — Urolog, načelnik Odjeljenja za onkologiju Klinike za urologiju KCCG
-- В БД есть: almir-rebronja (KCCG). Тот же врач — в AK Medica (Bijelo Polje).
-- На сайте «Almir rebronja» со строчной — опечатка.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Almir Rebronja' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Rebronja Almir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'almir-rebronja' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'almir-rebronja', 'Almir Rebronja', 'Алмир Реброња', 'Алмир Ребронья', 'Almir Rebronja', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Urolog, načelnik Odjeljenja za onkologiju Klinike za urologiju KCCG')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Aleksandar Spasić — Urolog
-- В БД есть: aleksandar-spasic (Konzilijum, уролог). На сайте подписи нет — только раздел «Urolozi».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Spasić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Spasić Aleksandar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aleksandar-spasic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-spasic', 'Aleksandar Spasić', 'Александар Спасић', 'Александар Спасич', 'Aleksandar Spasic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Urolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Saša Uskoković — Subspecijalista interventne radiologije
-- Отдельная карточка, НЕ uskokovic-sasa из Codra (решение юзера 2026-10-08: специальность
-- примерно совпадает — один врач, нет — две карточки). Codra пишет «Hirurgija» (general_surgery),
-- Da Vinci — субспециалист интервенционной радиологии; поиск в сети ничего не дал. Поэтому
-- ищем только по своему slug и ставим радиологию.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'sasa-uskokovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sasa-uskokovic', 'Saša Uskoković', 'Саша Ускоковић', 'Саша Ускокович', 'Sasa Uskokovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10); -- radiology
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Subspecijalista interventne radiologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Ass. dr Mihajlo Bezmarević — Specijalista opšte hirurgije
-- Новый. Сайт пишет имя двояко: «Mihajlo» (tim-davinci) и «Mihailo» (hirurgija).
-- Координатор 2026-10-08: взято «Mihajlo» — написание основного списка состава (/tim-davinci/);
-- требует подтверждения, см. openQuestions. Поиск в БД — по обоим вариантам.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mihailo Bezmarević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bezmarević Mihailo' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mihailo-bezmarevic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mihajlo Bezmarević' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Bezmarević Mihajlo' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mihajlo-bezmarevic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mihajlo-bezmarevic', 'Mihajlo Bezmarević', 'Михајло Безмаревић', 'Михайло Безмаревич', 'Mihajlo Bezmarevic', 'Ass. dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista opšte hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Dragan Sekulić — Specijalista vaskularne hirurgije
-- Новый.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dragan Sekulić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Sekulić Dragan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dragan-sekulic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragan-sekulic', 'Dragan Sekulić', 'Драган Секулић', 'Драган Секулич', 'Dragan Sekulic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 34);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista vaskularne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Milan Petrović — Specijalista hirurgije
-- Новый. На сайте «Petrovič» (č вместо ć) — опечатка, сербская фамилия на -ović.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milan Petrović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Petrović Milan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milan-petrovic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Milan Petrovič' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Petrovič Milan' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milan-petrovic', 'Milan Petrović', 'Милан Петровић', 'Милан Петрович', 'Milan Petrovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Srđan Dedić — Subspecijalista digestivne hirurgije
-- В БД есть: srdjan-dedic (KCCG).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Srđan Dedić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Dedić Srđan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'srdjan-dedic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-dedic', 'Srđan Dedić', 'Срђан Дедић', 'Срджан Дедич', 'Srdjan Dedic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3), (@doctor_id, 90);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Subspecijalista digestivne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Vladimir Vučeljić — Specijalista hirurgije
-- В БД есть: vladimir-vuceljic (KCCG, BonoMedica).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vladimir Vučeljić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vučeljić Vladimir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vladimir-vuceljic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vladimir-vuceljic', 'Vladimir Vučeljić', 'Владимир Вучељић', 'Владимир Вучелич', 'Vladimir Vuceljic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Prof. Zoran Hajduković — Endokrinolog, dugogodišnji načelnik Klinike za endokrinologiju VMA
-- Новый.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Zoran Hajduković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Hajduković Zoran' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zoran-hajdukovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-hajdukovic', 'Zoran Hajduković', 'Зоран Хајдуковић', 'Зоран Хайдукович', 'Zoran Hajdukovic', 'Prof. dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 12);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Endokrinolog, dugogodišnji načelnik Klinike za endokrinologiju VMA')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Dragana Stamatović — Hematolog, dugogodišnja načelnica Klinike za hematologiju VMA
-- Новая.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Dragana Stamatović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Stamatović Dragana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'dragana-stamatovic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-stamatovic', 'Dragana Stamatović', 'Драгана Стаматовић', 'Драгана Стаматович', 'Dragana Stamatovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 15);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Hematolog, dugogodišnja načelnica Klinike za hematologiju VMA')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Prof. Nemanja Đenić — Kardiolog, načelnik Klinike za urgentnu medicinu VMA
-- Новый. На сайте в разделе «Kardiologija»; ургентная медицина — место работы, специальность не ставим.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nemanja Đenić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đenić Nemanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nemanja-djenic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nemanja-djenic', 'Nemanja Đenić', 'Немања Ђенић', 'Неманья Дженич', 'Nemanja Djenic', 'Prof. dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Kardiolog, načelnik Klinike za urgentnu medicinu VMA')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Sinan Ećo — Kardiolog, Klinika za kardiologiju KCCG
-- В БД есть: eco-sinan («Ećo Sinan», KCCG, Zejnilović), ловится перевёрнутым именем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sinan Ećo' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ećo Sinan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sinan-eco' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sinan-eco', 'Sinan Ećo', 'Синан Ећо', 'Синан Эчо', 'Sinan Eco', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Kardiolog, Klinika za kardiologiju KCCG')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Nevenka Lukovac Janjić — Onkolog, Institut za onkologiju KCCG
-- В БД есть: nevenka-lukovac-janjic (KCCG, SmartMed; internista-onkolog). Сайт Da Vinci пишет
-- «Nevenka Lutovac Janjić» — та же врач Instituta za onkologiju KCCG; написание БД (Lukovac,
-- как у KCCG и SmartMed) не меняем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nevenka Lukovac Janjić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lukovac Janjić Nevenka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nevenka-lukovac-janjic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Nevenka Lutovac Janjić' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lutovac Janjić Nevenka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nevenka-lukovac-janjic' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nevenka-lutovac-janjic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nevenka-lukovac-janjic', 'Nevenka Lukovac Janjić', 'Невенка Луковац Јањић', 'Невенка Луковац Янич', 'Nevenka Lukovac Janjic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 47);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Onkolog, Institut za onkologiju KCCG')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Primarijus dr sc med Neven Vavić — Nefrolog, dugogodišnji načelnik Klinike za nefrologiju VMA
-- Новый. Единственный врач с фото и страницей-биографией (/neven-vavic/). Био — с этой страницы,
-- экавица источника приведена к иекавице.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Neven Vavić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vavić Neven' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'neven-vavic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'neven-vavic', 'Neven Vavić', 'Невен Вавић', 'Невен Вавич', 'Neven Vavic', 'Prim. dr sc. med.',
	'https://davincipoliklinika.me/wp-content/uploads/2024/09/Vavic-2.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = 'https://davincipoliklinika.me/wp-content/uploads/2024/09/Vavic-2.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');
UPDATE doctors SET
	description_sr = 'Specijalista interne medicine i klinički nefrolog. Osnovnu školu i gimnaziju završio je u Podgorici, a specijalizaciju iz interne medicine na Univerzitetu u Beogradu. Radni vijek proveo je kao klinički nefrolog, posljednjih godina kao načelnik Klinike za nefrologiju VMA i docent za oblast nefrologije na Medicinskom fakultetu Univerziteta odbrane u Beogradu. Bavi se svim vrstama bolesti bubrega, hroničnom bubrežnom slabošću, dijalizom, povišenim krvnim pritiskom, infekcijama mokraćnih kanala i kamencem u bubrezima, kao i ultrazvučnim i doplerskim pregledima bubrega. Posebno polje rada mu je transplantacija bubrega i imunosupresivna terapija, iz čega je doktorirao; autor je više objavljenih radova i koautor udžbenika za osnovne i poslijediplomske studije iz ove oblasti. Ima ekspertsko iskustvo u pripremi pacijenata i donora za transplantaciju bubrega, kao i u kasnijoj kontroli i praćenju ovih pacijenata.',
	description_sr_cyrl = 'Специјалиста интерне медицине и клинички нефролог. Основну школу и гимназију завршио је у Подгорици, а специјализацију из интерне медицине на Универзитету у Београду. Радни вијек провео је као клинички нефролог, посљедњих година као начелник Клинике за нефрологију ВМА и доцент за област нефрологије на Медицинском факултету Универзитета одбране у Београду. Бави се свим врстама болести бубрега, хроничном бубрежном слабошћу, дијализом, повишеним крвним притиском, инфекцијама мокраћних канала и каменцем у бубрезима, као и ултразвучним и доплерским прегледима бубрега. Посебно поље рада му је трансплантација бубрега и имуносупресивна терапија, из чега је докторирао; аутор је више објављених радова и коаутор уџбеника за основне и послиједипломске студије из ове области. Има експертско искуство у припреми пацијената и донора за трансплантацију бубрега, као и у каснијој контроли и праћењу ових пацијената.',
	description_ru = 'Специалист по внутренним болезням, клинический нефролог. Окончил школу и гимназию в Подгорице, специализацию по внутренним болезням — в Белградском университете. Всю карьеру работал клиническим нефрологом, в последние годы — заведующим Клиникой нефрологии Военно-медицинской академии (VMA) и доцентом по нефрологии медицинского факультета Университета обороны в Белграде. Занимается всеми видами заболеваний почек, хронической почечной недостаточностью, диализом, повышенным давлением, инфекциями мочевых путей и мочекаменной болезнью, а также УЗИ и допплерографией почек. Особая область — трансплантация почки и иммуносупрессивная терапия, по этой теме защитил докторскую диссертацию; автор ряда научных работ и соавтор учебников для студентов и аспирантов. Имеет экспертный опыт подготовки пациентов и доноров к трансплантации почки и последующего наблюдения за ними.',
	description_en = 'Specialist in internal medicine and clinical nephrologist. He finished primary school and grammar school in Podgorica and specialised in internal medicine at the University of Belgrade. He spent his career as a clinical nephrologist, most recently as head of the Nephrology Clinic of the Military Medical Academy (VMA) and assistant professor of nephrology at the Faculty of Medicine of the University of Defence in Belgrade. He treats all kinds of kidney disease, chronic kidney failure, dialysis patients, high blood pressure, urinary tract infections and kidney stones, and performs kidney ultrasound and Doppler examinations. His special field is kidney transplantation and immunosuppressive therapy, the subject of his doctorate; he has published a number of papers and co-authored textbooks for undergraduate and postgraduate studies. He has expert experience in preparing patients and donors for kidney transplantation and in their subsequent follow-up.',
	description_de = 'Facharzt für Innere Medizin und klinischer Nephrologe. Grundschule und Gymnasium absolvierte er in Podgorica, die Facharztausbildung in Innerer Medizin an der Universität Belgrad. Sein gesamtes Berufsleben arbeitete er als klinischer Nephrologe, zuletzt als Leiter der Klinik für Nephrologie der Militärmedizinischen Akademie (VMA) und Dozent für Nephrologie an der Medizinischen Fakultät der Universität der Verteidigung in Belgrad. Er behandelt alle Arten von Nierenerkrankungen, chronische Niereninsuffizienz, Dialysepatienten, Bluthochdruck, Harnwegsinfektionen und Nierensteine und führt Ultraschall- und Doppleruntersuchungen der Nieren durch. Sein besonderes Fachgebiet ist die Nierentransplantation und immunsuppressive Therapie, worüber er promovierte; er hat zahlreiche Arbeiten veröffentlicht und ist Mitautor von Lehrbüchern für das Grund- und Aufbaustudium. Er verfügt über Expertenerfahrung in der Vorbereitung von Patienten und Spendern auf die Nierentransplantation sowie in deren Nachsorge.',
	description_tr = 'İç hastalıkları uzmanı ve klinik nefrolog. İlkokulu ve liseyi Podgorica''da bitirdi, iç hastalıkları uzmanlığını Belgrad Üniversitesi''nde tamamladı. Meslek hayatı boyunca klinik nefrolog olarak çalıştı; son yıllarda Askeri Tıp Akademisi (VMA) Nefroloji Kliniği şefi ve Belgrad Savunma Üniversitesi Tıp Fakültesi''nde nefroloji doçenti olarak görev yaptı. Her türlü böbrek hastalığı, kronik böbrek yetmezliği, diyaliz, yüksek tansiyon, idrar yolu enfeksiyonları ve böbrek taşlarıyla ilgilenir; böbrek ultrasonu ve Doppler incelemeleri yapar. Özel ilgi alanı, doktora tezini de yazdığı böbrek nakli ve immünosüpresif tedavidir; çok sayıda yayını vardır ve lisans ile lisansüstü eğitim için ders kitaplarının ortak yazarıdır. Hastaların ve donörlerin böbrek nakline hazırlanması ile sonrasındaki kontrol ve takipleri konusunda uzman deneyime sahiptir.'
WHERE id = @doctor_id;
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 46), (@doctor_id, 2);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Nefrolog, dugogodišnji načelnik Klinike za nefrologiju VMA')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Elvir Mučić — Nefrolog, načelnik Klinike za nefrologiju KCCG
-- В БД есть: elvir-mucic (KCCG, Medicus Tim, с био) — описание не трогаем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Elvir Mučić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mučić Elvir' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'elvir-mucic' LIMIT 1));
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'elvir-mucic', 'Elvir Mučić', 'Елвир Мучић', 'Эльвир Мучич', 'Elvir Mucic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 46);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Nefrolog, načelnik Klinike za nefrologiju KCCG')
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

-- Ожидается 18 врачей.
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

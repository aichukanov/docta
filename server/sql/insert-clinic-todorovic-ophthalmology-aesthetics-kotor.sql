-- ═══════════════════════════════════════════════════════════════════════════
-- Todorović Ophthalmology & Aesthetics (Kotor) — клиника + врач (офтальмология и эстетическая медицина)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-todorovic-ophthalmology-aesthetics-kotor.sql
-- Затем: server/sql/insert-clinic-todorovic-ophthalmology-aesthetics-kotor-services.sql
-- Запись импорта: data/clinic-imports/todorovic-ophthalmology-aesthetics-kotor.json. Подволна 2e, агент Y.
-- 
-- Источники (собрано 2026-10-09):
--   * https://drtodorovic.com/me/ — WordPress; wp-json /wp/v2/pages (50 страниц me + en; страницы услуг modified 2025-08-24…2025-09-04,
--     главная — 2026-09-11) + сырой HTML главной (часы, контакты, логотип). 22 страницы услуг /me/ прочитаны все. Цен нет нигде.
--   * data/google-places/kotor/todorovic-ophthalmology-aesthetics-medicine.json — place_id, координаты 42.4409085 / 18.7681222,
--     +382 68 863 508, «21. maj, III put, Kotor 85330» (Google не перезапрашивался; 15 отзывов — не импортируются).
-- 
-- Адрес — с сайта: «Studentska bb, Kotor»; Google — «21. maj, III put». Координаты — из Google (по OSM точка в Dobroti, Plagente;
-- улицы Studentska в OSM нет — сверить нечем, телефон совпадает → то же место). Индекс 85330 — из Google.
-- Телефон: на сайте tel:+382683508 (опечатка в ссылке), текст «+382 68/863 - 508» = Google → +38268863508.
-- Instagram — @dr_nenad_todorovic (ссылка сайта клиники). LinkedIn врача в карточку не пишем.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJN_zVzNMzTBMRGfsXFs-82Xs';
SET @clinic_slug = 'todorovic-ophthalmology-aesthetics-kotor';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Todorović Ophthalmology & Aesthetics', 'Todorovic Ophthalmology & Aesthetics Medicine', 'Todorović Ophthalmology & Aesthetic', 'Todorović ophthalmology and aesthetics') AND city_id = 6 LIMIT 1));

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
	6, -- CityId.KOTOR (точка Google — Dobrota, opština Kotor)
	'Todorović Ophthalmology & Aesthetics',
	'Тодоровић Ophthalmology & Aesthetics',
	'Todorović Ophthalmology & Aesthetics',
	'Studentska bb',
	'Студентска бб',
	'',
	'',
	'85330',
	42.44090850,
	18.76812220,
	'+38268863508',
	'info@drtodorovic.com',
	'https://drtodorovic.com/me/',
	'',
	'@dr_nenad_todorovic',
	'',
	'',
	'',
	'https://drtodorovic.com/wp-content/uploads/2025/08/logo-original-scaled.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.44090850, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 18.76812220, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Тодоровић Ophthalmology & Aesthetics', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Todorović Ophthalmology & Aesthetics', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Studentska bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Студентска бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85330', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38268863508', phone),
	email = IF(email IS NULL OR email = '', 'info@drtodorovic.com', email),
	website = IF(website IS NULL OR website = '', 'https://drtodorovic.com/me/', website),
	instagram = IF(instagram IS NULL OR instagram = '', '@dr_nenad_todorovic', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://drtodorovic.com/wp-content/uploads/2025/08/logo-original-scaled.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Todorović Ophthalmology & Aesthetics je ordinacija oftalmologije i nehirurške estetske medicine u Kotoru, u Studentskoj ulici, u kojoj radi dr Nenad Todorović, specijalista oftalmologije sa edukacijom iz estetske medicine. Ordinacija se bavi dijagnostikom, prevencijom i liječenjem očnih bolesti: oftalmološki pregled odraslih i djece sa određivanjem dioptrije za daljinu i blizinu, snimanje očnog dna na OCT aparatu, pregledi pacijenata sa glaukomom, dijabetskom retinopatijom i senilnom degeneracijom žute mrlje, uklanjanje stranog tijela na biomikroskopu sa procjepnom lampom i fitovanje i određivanje kontaktnih sočiva. Iz nehirurške estetske medicine dostupni su hijaluronski fileri (i za korekciju usana), botulinski toksin (i kod prekomjernog znojenja), PRP tretman lica i kose, mezoterapija i biorevitalizacija preparatima Jalupro (Classic, HMW, Super Hydro, Young Eye), Profhilo, polinukleotidi Newest, Plinest i Plinest Eye, Viscoderm Hydrobooster, hemijski pilinzi, PRX-T33, microneedling, lipoliza i COG i mono niti.',
	description_sr_cyrl = 'Тодоровић Ophthalmology & Aesthetics је ординација офталмологије и нехируршке естетске медицине у Котору, у Студентској улици, у којој ради др Ненад Тодоровић, специјалиста офталмологије са едукацијом из естетске медицине. Ординација се бави дијагностиком, превенцијом и лијечењем очних болести: офталмолошки преглед одраслих и дјеце са одређивањем диоптрије за даљину и близину, снимање очног дна на OCT апарату, прегледи пацијената са глаукомом, дијабетском ретинопатијом и сенилном дегенерацијом жуте мрље, уклањање страног тијела на биомикроскопу са процјепном лампом и фитовање и одређивање контактних сочива. Из нехируршке естетске медицине доступни су хијалуронски филери (и за корекцију усана), ботулински токсин (и код прекомјерног знојења), PRP третман лица и косе, мезотерапија и биоревитализација препаратима Jalupro (Classic, HMW, Super Hydro, Young Eye), Profhilo, полинуклеотиди Newest, Plinest и Plinest Eye, Viscoderm Hydrobooster, хемијски пилинзи, PRX-T33, microneedling, липолиза и COG и моно нити.',
	description_ru = 'Todorović Ophthalmology & Aesthetics — кабинет офтальмологии и нехирургической эстетической медицины в Которе, на улице Studentska, где принимает dr Ненад Тодорович, офтальмолог с подготовкой по эстетической медицине. Кабинет занимается диагностикой, профилактикой и лечением болезней глаз: офтальмологический осмотр взрослых и детей с определением рефракции для дали и близи, исследование глазного дна на аппарате OCT, обследование пациентов с глаукомой, диабетической ретинопатией и возрастной макулярной дегенерацией, удаление инородного тела на щелевой лампе, подбор контактных линз. Из нехирургической эстетической медицины доступны филлеры на основе гиалуроновой кислоты (в том числе коррекция губ), ботулотоксин (в том числе при повышенной потливости), PRP-терапия лица и волос, мезотерапия и биоревитализация препаратами Jalupro (Classic, HMW, Super Hydro, Young Eye), Profhilo, полинуклеотиды Newest, Plinest и Plinest Eye, Viscoderm Hydrobooster, химические пилинги, PRX-T33, микронидлинг, липолиз, нити COG и мононити.',
	description_en = 'Todorović Ophthalmology & Aesthetics is an ophthalmology and non-surgical aesthetic medicine practice in Kotor, on Studentska Street, run by Dr Nenad Todorović, an ophthalmologist with training in aesthetic medicine. The practice provides diagnosis, prevention and treatment of eye diseases: eye examinations for adults and children with refraction for distance and near, OCT imaging of the fundus, examinations of patients with glaucoma, diabetic retinopathy and age-related macular degeneration, foreign body removal at the slit lamp, and contact lens fitting. Non-surgical aesthetic treatments include hyaluronic fillers (including lip correction), botulinum toxin (also for excessive sweating), PRP for the face and hair, mesotherapy and biorevitalisation with Jalupro (Classic, HMW, Super Hydro, Young Eye), Profhilo, Newest, Plinest and Plinest Eye polynucleotides, Viscoderm Hydrobooster, chemical peels, PRX-T33, microneedling, lipolysis and COG and mono threads.',
	description_de = 'Todorović Ophthalmology & Aesthetics ist eine Praxis für Augenheilkunde und nichtchirurgische ästhetische Medizin in Kotor, Studentska-Straße, geführt von Dr. Nenad Todorović, Augenarzt mit Ausbildung in ästhetischer Medizin. Die Praxis bietet Diagnostik, Prävention und Behandlung von Augenerkrankungen: augenärztliche Untersuchung von Erwachsenen und Kindern mit Refraktionsbestimmung für Ferne und Nähe, OCT-Aufnahmen des Augenhintergrunds, Untersuchungen bei Glaukom, diabetischer Retinopathie und altersbedingter Makuladegeneration, Fremdkörperentfernung an der Spaltlampe sowie Anpassung von Kontaktlinsen. In der nichtchirurgischen ästhetischen Medizin werden Hyaluronfiller (auch zur Lippenkorrektur), Botulinumtoxin (auch bei übermäßigem Schwitzen), PRP für Gesicht und Haare, Mesotherapie und Biorevitalisierung mit Jalupro (Classic, HMW, Super Hydro, Young Eye), Profhilo, die Polynukleotide Newest, Plinest und Plinest Eye, Viscoderm Hydrobooster, chemische Peelings, PRX-T33, Microneedling, Lipolyse sowie COG- und Monofäden angeboten.',
	description_tr = 'Todorović Ophthalmology & Aesthetics, Kotor''da Studentska Caddesi''nde, estetik tıp eğitimi almış göz hastalıkları uzmanı Dr. Nenad Todorović''in çalıştığı bir göz hastalıkları ve cerrahi olmayan estetik tıp muayenehanesidir. Muayenehane göz hastalıklarının tanı, önleme ve tedavisini sunar: uzak ve yakın için kırma kusuru ölçümüyle yetişkin ve çocuk göz muayenesi, OCT cihazıyla göz dibi görüntüleme, glokom, diyabetik retinopati ve yaşa bağlı makula dejenerasyonu olan hastaların muayenesi, yarık lamba ile yabancı cisim çıkarma ve kontakt lens uygulaması. Cerrahi olmayan estetik tıpta hiyalüronik dolgular (dudak düzeltme dahil), botulinum toksini (aşırı terleme dahil), yüz ve saç için PRP, Jalupro (Classic, HMW, Super Hydro, Young Eye) ile mezoterapi ve biyorevitalizasyon, Profhilo, Newest, Plinest ve Plinest Eye polinükleotidleri, Viscoderm Hydrobooster, kimyasal peeling, PRX-T33, mikro iğneleme, lipoliz ile COG ve mono ipler sunulur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- OPHTHALMOLOGY_CLINIC = 9 (офтальмологические осмотры и диагностика) + AESTHETIC_CLINIC = 14 (раздел «Tretmani nehirurške estetske medicine»).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 9), (@clinic_id, 14);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт me/en, приём на других языках прямо не заявлен → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — блок «RADNO VRIJEME» сайта (и шапка «Monday, Wednesday, Friday 08:00 - 16:00; Tuesday, Thursday 12:00 - 20:00»): Пн/Ср/Пт 8–16, Вт/Чт 12–20, Сб/Вс «ne radimo».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "16:00"}]}',
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
-- Источник: /me/o-nama («Doktor Nenad Todorović … Specijalizaciju iz oftamologije završio je na Medicinskom fakultetu Univerziteta u Beogradu …
-- U oblasti estetske medicine, školovao se kod doktora Brada Hermana u Majamiju»).
-- НЕ заводится: Adriana Lagator — medicinska sestra-tehničar (решение юзера).

-- ───────────────────────────────────────────────────────────────
-- Nenad Todorović — oftalmolog + estetska medicina.
-- НАЙДЕН в БД: nenad-todorovic (локаль id 609, спец. 6 + 44, фото /uploads/…, описание sr: «završio je Srednju medicinsku školu u Podgorici,
-- smjer laboratorijski tehničar … Medicinski fakultet u Foči» — дословно как /o-nama), клиники poliklinika-natal-podgorica и dom-zdravlja-kotor —
-- тот же человек. Карточку не перезаписываем (фото и описание уже есть), только привязка к клинике.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nenad Todorović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Todorović Nenad' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nenad-todorovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nenad-todorovic', 'Nenad Todorović', 'Ненад Тодоровић', 'Ненад Тодорович', 'Nenad Todorovic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описание существующей карточки (sr, по тексту того же био) не трогаем.

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 6), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Oftalmolog, estetska medicina')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 6, status = published, clinic_languages = '1', clinic_types = '9,14', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1: nenad-todorovic (6,44).
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

-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Pat Lab (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-pat-lab-podgorica.sql
-- Затем: server/sql/insert-clinic-pat-lab-podgorica-services.sql
-- Запись импорта: data/clinic-imports/pat-lab-podgorica.json. Подволна 2d, агент V.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://patlab.me/ — WordPress (Kadence). wp-json pages: «Početna» modified 2025-04-07, «Kontakt» 2026-09-14, «Pitanja & Odgovori» 2025-03-31.
--     /services, /about, /warranty, /new-patients, /news и все посты (стоматологический блог 2022) — демо-контент темы («Dr. Betty Wible»), игнорировались.
--     Цен нет.
--   * data/google-places/podgorica/pat-lab.json — place_id, координаты 42.4356665 / 19.2412269, +382 67 334 337,
--     «108 Dr Vukašina Markovića, Podgorica 81000» (Google не перезапрашивался).
-- 
-- Email: на /contact видимый текст «patlabpg@gmail.com», ссылка mailto — info@patlab.me → оба.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ7wtduerrTRMRbP8KNitEJW4';
SET @clinic_slug = 'pat-lab-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Pat Lab', 'PAT LAB', 'PZU Pat Lab', 'Patlab') AND city_id = 1 LIMIT 1));

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
	'Pat Lab',
	'Pat Lab',
	'Pat Lab',
	'Dr Vukašina Markovića 108',
	'Др Вукашина Марковића 108',
	'',
	'',
	'81000',
	42.43566650,
	19.24122690,
	'+38267334337',
	'patlabpg@gmail.com;info@patlab.me',
	'https://patlab.me/',
	'facebook.com/profile.php?id=61572568719233',
	'@pzu_pat_lab',
	'',
	'',
	'',
	'https://patlab.me/wp-content/uploads/2025/02/cropped-logo_horizontalni.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.43566650, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.24122690, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Pat Lab', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Pat Lab', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Dr Vukašina Markovića 108', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Др Вукашина Марковића 108', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267334337', phone),
	email = IF(email IS NULL OR email = '', 'patlabpg@gmail.com;info@patlab.me', email),
	website = IF(website IS NULL OR website = '', 'https://patlab.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/profile.php?id=61572568719233', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@pzu_pat_lab', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://patlab.me/wp-content/uploads/2025/02/cropped-logo_horizontalni.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'PAT LAB je moderna zdravstvena ustanova u Podgorici sa dva segmenta rada: patohistološkom dijagnostikom i psihijatrijskom ambulantom. Patohistološka dijagnostika osnovana je sa vizijom novog razvoja ovog vida dijagnostike u Crnoj Gori — da pacijentima omogući pouzdane, kvalitetne i blagovremene patohistološke nalaze, što je od posebnog značaja za pacijente sa malignim bolestima. Laboratorija radi citološke analize, među kojima konvencionalni PAPA test i PAPA test na tečnoj podlozi (likvidni PAPA test – ThinPrep), sa rezultatom za 24–48 h; patohistološku analizu biopsija (rezultat za 3–5 dana) uz standardno hematoksilin-eozin bojenje; imunohistohemijske analize, koje omogućavaju utvrđivanje vrste i porijekla tumora i daju podatke za hormonoterapiju i imunoterapiju; i molekularne analize — određivanje mutacija u tumoru za primjenu ciljane terapije. Psihijatrijska ambulanta pruža odraslima i djeci stručne konsultacije, terapijske sesije i podršku pacijentima. Ordiniraju dr Tijana Brandmajer, psihijatar, i dr Ivan Krgović, dječiji psihijatar.',
	description_sr_cyrl = 'PAT LAB је модерна здравствена установа у Подгорици са два сегмента рада: патохистолошком дијагностиком и психијатријском амбулантом. Патохистолошка дијагностика основана је са визијом новог развоја овог вида дијагностике у Црној Гори — да пацијентима омогући поуздане, квалитетне и благовремене патохистолошке налазе, што је од посебног значаја за пацијенте са малигним болестима. Лабораторија ради цитолошке анализе, међу којима конвенционални PAPA тест и PAPA тест на течној подлози (ликвидни PAPA тест – ThinPrep), са резултатом за 24–48 х; патохистолошку анализу биопсија (резултат за 3–5 дана) уз стандардно хематоксилин-еозин бојење; имунохистохемијске анализе, које омогућавају утврђивање врсте и поријекла тумора и дају податке за хормонотерапију и имунотерапију; и молекуларне анализе — одређивање мутација у тумору за примјену циљане терапије. Психијатријска амбуланта пружа одраслима и дјеци стручне консултације, терапијске сесије и подршку пацијентима. Ординирају др Тијана Брандмајер, психијатар, и др Иван Крговић, дјечији психијатар.',
	description_ru = 'PAT LAB — современное медицинское учреждение в Подгорице с двумя направлениями: патогистологическая диагностика и психиатрическая амбулатория. Патогистологическая лаборатория создана, чтобы дать пациентам надёжные, качественные и своевременные патогистологические заключения, что особенно важно для пациентов со злокачественными заболеваниями. Лаборатория выполняет цитологические исследования, в том числе обычный ПАП-тест и ПАП-тест на жидкой основе (жидкостная цитология ThinPrep) с результатом за 24–48 часов; патогистологическое исследование биопсий (результат за 3–5 дней) со стандартной окраской гематоксилином и эозином; иммуногистохимические исследования, которые позволяют определить тип и происхождение опухоли и дают данные для гормоно- и иммунотерапии; молекулярные исследования — определение мутаций в опухоли для таргетной терапии. Психиатрическая амбулатория принимает взрослых и детей: консультации специалистов, терапевтические сессии и поддержка пациентов. Принимают д-р Тияна Брандмайер, психиатр, и д-р Иван Кргович, детский психиатр.',
	description_en = 'PAT LAB is a modern healthcare facility in Podgorica with two lines of work: histopathology diagnostics and a psychiatric outpatient clinic. The histopathology laboratory was founded to give patients reliable, high-quality and timely histopathology reports, which is especially important for patients with malignant diseases. The laboratory performs cytology, including the conventional Pap test and liquid-based Pap test (ThinPrep), with results in 24–48 hours; histopathological analysis of biopsies (results in 3–5 days) with standard haematoxylin and eosin staining; immunohistochemistry, which identifies the type and origin of a tumour and provides data for hormone therapy and immunotherapy; and molecular analysis — detection of tumour mutations for targeted therapy. The psychiatric outpatient clinic offers adults and children specialist consultations, therapy sessions and patient support. Dr Tijana Brandmajer, psychiatrist, and Dr Ivan Krgović, child psychiatrist, see patients.',
	description_de = 'PAT LAB ist eine moderne Gesundheitseinrichtung in Podgorica mit zwei Bereichen: histopathologische Diagnostik und psychiatrische Ambulanz. Das histopathologische Labor wurde gegründet, um Patienten zuverlässige, qualitativ hochwertige und zeitnahe histopathologische Befunde zu liefern – besonders wichtig für Patienten mit bösartigen Erkrankungen. Das Labor führt zytologische Untersuchungen durch, darunter den konventionellen Pap-Test und den flüssigkeitsbasierten Pap-Test (ThinPrep) mit Ergebnis in 24–48 Stunden; die histopathologische Untersuchung von Biopsien (Ergebnis in 3–5 Tagen) mit Standard-Hämatoxylin-Eosin-Färbung; Immunhistochemie, die Art und Herkunft eines Tumors bestimmt und Daten für Hormon- und Immuntherapie liefert; sowie molekulare Analysen – den Nachweis von Tumormutationen für zielgerichtete Therapien. Die psychiatrische Ambulanz bietet Erwachsenen und Kindern fachärztliche Beratung, Therapiesitzungen und Unterstützung. Es behandeln Dr. Tijana Brandmajer, Psychiaterin, und Dr. Ivan Krgović, Kinderpsychiater.',
	description_tr = 'PAT LAB, Podgorica''da iki alanda hizmet veren modern bir sağlık kuruluşudur: histopatolojik tanı ve psikiyatri polikliniği. Histopatoloji laboratuvarı, hastalara güvenilir, kaliteli ve zamanında histopatoloji raporları sunmak amacıyla kurulmuştur; bu özellikle kötü huylu hastalığı olan hastalar için önemlidir. Laboratuvar, 24–48 saatte sonuçlanan konvansiyonel Pap testi ve sıvı bazlı Pap testi (ThinPrep) dahil sitolojik incelemeler; standart hematoksilen-eozin boyamasıyla biyopsilerin histopatolojik incelemesi (sonuç 3–5 gün); tümörün türünü ve kökenini belirleyen, hormon tedavisi ve immünoterapi için veri sağlayan immünohistokimya; ve hedefe yönelik tedavi için tümör mutasyonlarının belirlenmesi gibi moleküler analizler yapar. Psikiyatri polikliniği yetişkinlere ve çocuklara uzman danışmanlığı, terapi seansları ve hasta desteği sunar. Psikiyatrist Dr. Tijana Brandmajer ve çocuk psikiyatristi Dr. Ivan Krgović hasta kabul eder.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- DIAGNOSTIC_LABORATORY = 4 (патогистологическая лаборатория, как in-vitro-podgorica) + PSYCHIATRIC_CLINIC = 15 (психиатрическая амбулатория).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 4), (@clinic_id, 15);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском, другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы НЕ заполняются: на сайте их нет («24/7 Posvećenost» — слоган, не часы).

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (2)
-- ═══════════════════════════════════════════════════════════════
-- Источник: блок врачей главной (2 психиатра с фото). Патологи лаборатории не названы — не заводятся.

-- ───────────────────────────────────────────────────────────────
-- Главная: «Dr. Tijana Brandmajer — Psihijatar» (фото wp-content/uploads/2025/03/Dr-Tijana.jpg).
-- В БД есть: tijana-brandmajer (локаль id 789, specialty 21 PSYCHIATRY, klinicki-centar-crne-gore-podgorica, фото нет; прод-API 200) → привязка, фото — дозаполнение.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'tijana-brandmajer' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tijana-brandmajer', 'Tijana Brandmajer', 'Тијана Брандмајер', 'Тияна Брандмайер', 'Tijana Brandmajer', 'Dr',
	'https://patlab.me/wp-content/uploads/2025/03/Dr-Tijana.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://patlab.me/wp-content/uploads/2025/03/Dr-Tijana.jpg', photo_url) WHERE id = @doctor_id;

-- Врач уже в БД: дозаполнение пустых имён (ru/en), существующие не трогаем.
UPDATE doctors SET
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Тияна Брандмайер', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Tijana Brandmajer', name_en)
WHERE id = @doctor_id;

-- Описание врача не задаём: на сайте только «Psihijatar».

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Psihijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Главная: «Dr. Ivan Krgović — Dječiji psihijatar».
-- В БД есть: ivan-krgovic (локаль id 3243, specialty 21, poliklinika-mela-sana-podgorica «Specijalista dječije psihijatrije»; прод-API 200) → привязка.
-- Отдельной специальности «детская психиатрия» в enum нет — 21 PSYCHIATRY. Фото в БД уже есть (melasana.me) — не трогаем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'ivan-krgovic' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-krgovic', 'Ivan Krgović', 'Иван Крговић', 'Иван Кргович', 'Ivan Krgovic', 'Dr',
	'https://patlab.me/wp-content/uploads/2025/03/dr-ivan-krgovic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://patlab.me/wp-content/uploads/2025/03/dr-ivan-krgovic.jpg', photo_url) WHERE id = @doctor_id;

-- Описание врача не задаём: на сайте только «Dječiji psihijatar».

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 21);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Dječiji psihijatar')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '4,15', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2: tijana-brandmajer (21), ivan-krgovic (21).
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

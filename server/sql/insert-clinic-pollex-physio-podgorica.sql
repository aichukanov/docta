-- ═══════════════════════════════════════════════════════════════════════════
-- Pollex Physio (Podgorica) — клиника без названных специалистов
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-pollex-physio-podgorica.sql
-- Затем: server/sql/insert-clinic-pollex-physio-podgorica-services.sql
-- Запись импорта: data/clinic-imports/pollex-physio-podgorica.json. Подволна 2e, агент Y.
-- 
-- Источники (собрано 2026-10-09):
--   * https://pollexphysio.com/ — новый сайт (Lovable / Vite SPA): сырой HTML пустой (<div id=root>), контент — словари i18n
--     MNE/EN в бандле /assets/index-CuY2Jtws.js. Старый pollexphysio.me — домен на продаже (GoDaddy lander).
--     Цен нет: 4 пакета без цен, /shop — цифровые PDF-заглушки (placeholder.svg, «Povežite Lovable Cloud…») — не прайс.
--   * data/google-places/podgorica/pzu-pollex-physio.json — place_id, координаты 42.4424779 / 19.2194562, +382 67 270 793,
--     «Vinogradska, Podgorica 81000» (без номера дома; Google не перезапрашивался; 25 отзывов — не импортируются).
-- 
-- Адрес и координаты — по адресу сайта «Ul. Majevička 29, Podgorica» (решение координатора 2026-10-09): точка 42.4416319 / 19.2141759 —
-- ось улицы Majevička по OSM (номера дома 29 в OSM нет). Точка места Google на Vinogradska (~430 м) — вероятно, прежний адрес;
-- google_place_id оставлен (тот же телефон +382 67 270 793 → то же учреждение).
-- Соцсетей на сайте нет. Логотип — /assets/logo-JPSBtqTK.png из бандла (200).
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJfaGYgC3rTRMRHWWeeXeO6Wo';
SET @clinic_slug = 'pollex-physio-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Pollex Physio', 'PZU POLLEX PHYSIO', 'PZU Pollex Physio', 'POLLEX PHYSIO', 'PollexPhysio') AND city_id = 1 LIMIT 1));

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
	'Pollex Physio',
	'Pollex Physio',
	'Pollex Physio',
	'Majevička 29',
	'Мајевичка 29',
	'',
	'',
	'81000',
	42.44163190,
	19.21417590,
	'+38267270793',
	'pollexphysio@gmail.com',
	'https://pollexphysio.com/',
	'',
	'',
	'',
	'',
	'',
	'https://pollexphysio.com/assets/logo-JPSBtqTK.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.44163190, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.21417590, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Pollex Physio', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Pollex Physio', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Majevička 29', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Мајевичка 29', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267270793', phone),
	email = IF(email IS NULL OR email = '', 'pollexphysio@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://pollexphysio.com/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://pollexphysio.com/assets/logo-JPSBtqTK.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Pollex Physio je privatna zdravstvena ustanova za fizikalnu terapiju u Podgorici, u ulici Majevička 29. Iza prakse je više od 15 godina iskustva u fizioterapiji i rehabilitaciji, sa usmjerenjem na sportske povrede, postoperativnu njegu i liječenje hroničnog bola; pristup zasnovan na dokazima kombinuje manualnu terapiju, terapeutske vježbe i edukaciju pacijenata. U ponudi su kineziterapija, manualna terapija, elektroterapija, akupunktura, individualni trening i grupne vježbe u grupama od 2 do 4 osobe, masaže, kiropraktika i patronažna fizioterapija u kućnom okruženju. Ustanova radi rehabilitaciju sportskih povreda i nudi pakete tretmana (Family Box, Sport Recovery Box, Relax Business Box, Master Reset Box) koji kombinuju terapeutsku i sportsku masažu, spinalne manipulacije, Tecar dijatermiju, akupunkturu iglama i dry cupping; cijene paketa nisu objavljene.',
	description_sr_cyrl = 'Pollex Physio је приватна здравствена установа за физикалну терапију у Подгорици, у улици Мајевичка 29. Иза праксе је више од 15 година искуства у физиотерапији и рехабилитацији, са усмјерењем на спортске повреде, постоперативну његу и лијечење хроничног бола; приступ заснован на доказима комбинује мануалну терапију, терапеутске вјежбе и едукацију пацијената. У понуди су кинезитерапија, мануална терапија, електротерапија, акупунктура, индивидуални тренинг и групне вјежбе у групама од 2 до 4 особе, масаже, киропрактика и патронажна физиотерапија у кућном окружењу. Установа ради рехабилитацију спортских повреда и нуди пакете третмана (Family Box, Sport Recovery Box, Relax Business Box, Master Reset Box) који комбинују терапеутску и спортску масажу, спиналне манипулације, Tecar дијатермију, акупунктуру иглама и dry cupping; цијене пакета нису објављене.',
	description_ru = 'Pollex Physio — частное медицинское учреждение физиотерапии в Подгорице, на улице Majevička, 29. За практикой — более 15 лет опыта в физиотерапии и реабилитации, основные направления — спортивные травмы, послеоперационное восстановление и лечение хронической боли; подход, основанный на доказательной медицине, сочетает мануальную терапию, лечебные упражнения и обучение пациентов. В перечне услуг — кинезитерапия, мануальная терапия, электротерапия, акупунктура, индивидуальные тренировки и групповые занятия в группах по 2–4 человека, массаж, хиропрактика и физиотерапия на дому. Учреждение занимается реабилитацией спортивных травм и предлагает пакеты процедур (Family Box, Sport Recovery Box, Relax Business Box, Master Reset Box), сочетающие лечебный и спортивный массаж, спинальные манипуляции, Tecar-диатермию, иглоукалывание и сухие банки; цены пакетов не опубликованы.',
	description_en = 'Pollex Physio is a private physiotherapy facility in Podgorica, at Majevička 29. The practice draws on more than 15 years of experience in physiotherapy and rehabilitation, focusing on sports injuries, post-operative care and chronic pain management; its evidence-based approach combines manual therapy, therapeutic exercise and patient education. Services include exercise therapy, manual therapy, electrotherapy, acupuncture, individual training and group exercise in groups of 2 to 4, massage, chiropractic and home physiotherapy. The facility rehabilitates sports injuries and offers treatment packages (Family Box, Sport Recovery Box, Relax Business Box, Master Reset Box) combining therapeutic and sports massage, spinal manipulation, Tecar diathermy, needle acupuncture and dry cupping; package prices are not published.',
	description_de = 'Pollex Physio ist eine private Einrichtung für Physiotherapie in Podgorica, Majevička 29. Hinter der Praxis stehen mehr als 15 Jahre Erfahrung in Physiotherapie und Rehabilitation mit Schwerpunkt auf Sportverletzungen, postoperativer Versorgung und Behandlung chronischer Schmerzen; der evidenzbasierte Ansatz verbindet manuelle Therapie, therapeutische Übungen und Patientenschulung. Angeboten werden Bewegungstherapie, manuelle Therapie, Elektrotherapie, Akupunktur, Einzeltraining und Gruppenübungen in Gruppen von 2 bis 4 Personen, Massagen, Chiropraktik und Physiotherapie zu Hause. Die Einrichtung rehabilitiert Sportverletzungen und bietet Behandlungspakete (Family Box, Sport Recovery Box, Relax Business Box, Master Reset Box) an, die therapeutische und Sportmassage, spinale Manipulation, Tecar-Diathermie, Nadelakupunktur und trockenes Schröpfen kombinieren; Paketpreise sind nicht veröffentlicht.',
	description_tr = 'Pollex Physio, Podgorica''da Majevička 29 adresinde özel bir fizik tedavi kuruluşudur. Uygulamanın arkasında fizyoterapi ve rehabilitasyonda 15 yılı aşkın deneyim vardır; spor yaralanmaları, ameliyat sonrası bakım ve kronik ağrı yönetimine odaklanır. Kanıta dayalı yaklaşımı manuel terapi, terapötik egzersiz ve hasta eğitimini birleştirir. Hizmetler arasında egzersiz tedavisi, manuel terapi, elektroterapi, akupunktur, bireysel antrenman ve 2–4 kişilik gruplarda grup egzersizleri, masaj, kayropraktik ve evde fizyoterapi bulunur. Kurum spor yaralanmalarının rehabilitasyonunu yapar ve terapötik ve spor masajı, spinal manipülasyon, Tecar diatermi, iğne akupunkturu ve kuru kupa uygulamasını birleştiren tedavi paketleri (Family Box, Sport Recovery Box, Relax Business Box, Master Reset Box) sunar; paket fiyatları yayımlanmamıştır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24: Google «PZU POLLEX PHYSIO», сайт — физиотерапия и реабилитация.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт me/en, приём на других языках не заявлен → только SR (1), правило юзера.
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы НЕ заполняются: ни на сайте (словари бандла), ни в файле Google их нет.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- ═══════════════════════════════════════════════════════════════
-- Специалистов не заводим: имён на сайте нет. «O Našoj Praksi» написан от первого лица без имени; блок сертификатов
-- (DPT, McKenzie, FMS, «Institut za Suvo Iglovanje») — шаблонный, без имени. «Fizioterapeut Aleksandar» — только в отзыве
-- (без фамилии) → не заводится (решение юзера: без имени — не заводить, отзыв не источник).

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '24', hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 0: .
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

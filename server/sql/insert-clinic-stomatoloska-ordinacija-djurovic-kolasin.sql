-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Đurović (Kolašin) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-djurovic-kolasin.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/stomatoloska-ordinacija-djurovic-kolasin.json):
--   * https://ordinacijadjurovic.me/ — WordPress на стартовом шаблоне темы (wp-json /pages изменены 2023-03-16): Početna, Dentalni turizam,
--     Galerija, Blog (пусто). Пункты меню O nama/Usluge/Kontakt — якоря главной. Реальны: блок «Stomatološka ordinacija "Đurović"»,
--     6 блоков «Naše Usluge», «Kako do nas», страница Dentalni turizam. Демо темы игнорируется: «Dr. Michael Martinez — Master of
--     Dentistry», «+(888) 695-9859», «(007) 567-8976», «$100 OFF», «Dental X-Rays / Exams & Cleanings / …» с «This is a short
--     description…», отзывы lorem ipsum (Dorothy Palmer и др.). EN /en/ — тот же состав.
--   * Место Google ChIJ1UEIXoF9TRMRmL9j1wA5KOY лежит в двух файлах — data/google-places/berane/stomatoloska-ordinacija-djurovic.json и
--     data/google-places/kolasin/stomatoloska-ordinacija-djurovic.json; place id, адрес, телефон и координаты идентичны → одна карточка в Колашине.
-- Адрес: сайт «Boška Rašovića, 81210 Kolašin» = Google «Boška Rašovića, Kolašin» (номера дома нет → bb). Телефон и email — сайт (= Google).
-- Facebook — ссылка в подвале сайта. Логотип (logo-icon.png 64×64) — иконка стартового шаблона темы, не заполняется. Сайт 2023 — состав мог устареть.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ1UEIXoF9TRMRmL9j1wA5KOY';
SET @clinic_slug = 'stomatoloska-ordinacija-djurovic-kolasin';

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
	13, -- CityId.KOLASIN
	'Stomatološka ordinacija Đurović',
	'Стоматолошка ординација Đurović',
	'Стоматологический кабинет Đurović',
	'Boška Rašovića bb',
	'Бошка Рашовића бб',
	'',
	'',
	'81210',
	42.82317320,
	19.52863940,
	'+38267271423',
	'djurovicdanilo@yahoo.com',
	'https://ordinacijadjurovic.me/',
	'https://www.facebook.com/profile.php?id=100008484588786',
	'',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Đurović', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Đurović', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Boška Rašovića bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Бошка Рашовића бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81210', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267271423', phone),
	email = IF(email IS NULL OR email = '', 'djurovicdanilo@yahoo.com', email),
	website = IF(website IS NULL OR website = '', 'https://ordinacijadjurovic.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'https://www.facebook.com/profile.php?id=100008484588786', facebook),
	latitude = COALESCE(latitude, 42.82317320),
	longitude = COALESCE(longitude, 19.52863940)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Đurović“ nalazi se u Kolašinu, u ulici Boška Rašovića. Ordinacija se već godinama bavi svim granama stomatologije i svoju praksu zasniva na visokokvalitetnim materijalima, digitalnoj tehnologiji i savremenim pristupima. Radi svakog dana osim nedjelje, a svakom pacijentu obezbjeđuje besplatan pregled uz preciznu analizu zdravlja usta i zuba; nakon sanacije urgentnih problema predočava se plan daljeg liječenja. U ordinaciji se rade implanti (Nobel Biocare, Bredent), protetika (totalne i parcijalne proteze), ortopedija vilica kod djece i odraslih, oralna hirurgija u lokalnoj anesteziji, liječenje bolesti zuba i usta i izbjeljivanje zuba. Ordinacija ima pacijente iz inostranstva i za dentalni turizam obezbjeđuje besplatan apartmanski smještaj, prevoz od i do aerodroma i vodiča; plan i cijenu liječenja priprema na osnovu ortopan snimka poslatog e-mailom.',
	description_sr_cyrl = 'Стоматолошка ординација „Đurović“ налази се у Колашину, у улици Бошка Рашовића. Ординација се већ годинама бави свим гранама стоматологије и своју праксу заснива на висококвалитетним материјалима, дигиталној технологији и савременим приступима. Ради сваког дана осим недјеље, а сваком пацијенту обезбјеђује бесплатан преглед уз прецизну анализу здравља уста и зуба; након санације ургентних проблема предочава се план даљег лијечења. У ординацији се раде импланти (Nobel Biocare, Bredent), протетика (тоталне и парцијалне протезе), ортопедија вилица код дјеце и одраслих, орална хирургија у локалној анестезији, лијечење болести зуба и уста и избјељивање зуба. Ординација има пацијенте из иностранства и за дентални туризам обезбјеђује бесплатан апартмански смјештај, превоз од и до аеродрома и водича; план и цијену лијечења припрема на основу ортопан снимка послатог е-маилом.',
	description_ru = 'Стоматологический кабинет «Đurović» находится в Колашине, на улице Бошка Рашовича. Кабинет много лет работает во всех направлениях стоматологии, используя высококачественные материалы, цифровые технологии и современные подходы. Работает ежедневно, кроме воскресенья; каждому пациенту проводится бесплатный осмотр с подробной оценкой состояния полости рта и зубов, а после устранения неотложных проблем предлагается план дальнейшего лечения. В кабинете проводятся имплантация (Nobel Biocare, Bredent), протезирование (полные и частичные протезы), ортодонтия у детей и взрослых, хирургическая стоматология под местной анестезией, лечение заболеваний зубов и слизистой рта и отбеливание зубов. У кабинета есть иностранные пациенты: для стоматологического туризма предоставляются бесплатное проживание в апартаментах, трансфер из аэропорта и гид; план и стоимость лечения готовят по ортопантомограмме, присланной по e-mail.',
	description_en = 'Đurović is a dental practice in Kolasin, on Boška Rašovića street. For years the practice has worked in all branches of dentistry, relying on high-quality materials, digital technology and modern approaches. It is open every day except Sunday and offers every patient a free examination with a detailed assessment of oral and dental health; once urgent problems are dealt with, a plan for further treatment is presented. The practice offers implants (Nobel Biocare, Bredent), prosthodontics (complete and partial dentures), orthodontics for children and adults, oral surgery under local anaesthesia, treatment of dental and oral diseases, and teeth whitening. It has patients from abroad and, for dental tourism, provides free apartment accommodation, airport transfers and a guide; the treatment plan and price are prepared from a panoramic X-ray sent by email.',
	description_de = 'Đurović ist eine Zahnarztpraxis in Kolasin, Straße Boška Rašovića. Die Praxis ist seit Jahren in allen Bereichen der Zahnmedizin tätig und setzt auf hochwertige Materialien, digitale Technik und moderne Behandlungsansätze. Sie ist täglich außer sonntags geöffnet und bietet jedem Patienten eine kostenlose Untersuchung mit genauer Beurteilung der Mund- und Zahngesundheit; nach Behebung akuter Beschwerden wird ein Plan für die weitere Behandlung vorgestellt. Angeboten werden Implantate (Nobel Biocare, Bredent), Prothetik (Voll- und Teilprothesen), Kieferorthopädie für Kinder und Erwachsene, Oralchirurgie in Lokalanästhesie, Behandlung von Zahn- und Mundkrankheiten sowie Zahnaufhellung. Die Praxis hat Patienten aus dem Ausland und bietet im Rahmen des Dentaltourismus kostenlose Unterkunft in Apartments, Flughafentransfer und einen Reiseführer; Behandlungsplan und Preis werden anhand einer per E-Mail gesendeten Panoramaaufnahme erstellt.',
	description_tr = 'Đurović, Kolasin''de Boška Rašovića caddesinde bulunan bir diş muayenehanesidir. Muayenehane yıllardır diş hekimliğinin tüm dallarında yüksek kaliteli malzeme, dijital teknoloji ve modern yaklaşımlarla çalışır. Pazar hariç her gün açıktır ve her hastaya ağız ve diş sağlığının ayrıntılı değerlendirildiği ücretsiz muayene sunar; acil sorunlar giderildikten sonra ileri tedavi planı sunulur. İmplantlar (Nobel Biocare, Bredent), protez (tam ve kısmi protezler), çocuk ve yetişkinlerde ortodonti, lokal anestezi altında ağız cerrahisi, diş ve ağız hastalıklarının tedavisi ve diş beyazlatma yapılır. Muayenehanenin yurt dışından hastaları vardır; diş turizmi için ücretsiz apart konaklama, havalimanı transferi ve rehber sağlanır; tedavi planı ve fiyat e-postayla gönderilen panoramik filme göre hazırlanır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. EN-версия сайта и пациенты «iz celog sveta, Rusija, Njemačka …» на странице Dentalni turizam — не заявление о приёме на этих языках → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: главная: «Ordinacija radi svakog radnog dana osim nedelje» — дни есть, часов нет (у Google тоже нет); интервалы не выдумываем — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- Врачей по именам на сайте нет: «Dr. Michael Martinez — Master of Dentistry» — демо темы (игнорируется).
-- Поиск в БД (Đurović, клиники Колашина, 2026-10-09): стоматологов Đurović в Колашине нет — Dragan Đurović (9 = UROLOGY) и Ivan Đurović
-- (5 = GYNECOLOGY) из ДЗ Колашин — другие специальности; Nina Đurović (78) — Подгорица, dr-raznatovic, другой человек.
-- Врач заведён ПО КОСВЕННЫМ ПРИЗНАКАМ (решение координатора 2026-10-09): название «Stomatološka ordinacija Đurović» + email ординации
-- djurovicdanilo@yahoo.com (сайт, «Kako do nas» и /dentalni-turizam/) → Danilo Đurović, стоматолог (78). Сайт врачом его прямо не называет;
-- фото и био нет. Slug danilo-djurovic свободен (локально и на проде — 204). Только привязка к клинике, без услуг.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Danilo Đurović — Stomatolog
-- ───────────────────────────────────────────────────────────────
-- Косвенно: название «Stomatološka ordinacija Đurović» + email djurovicdanilo@yahoo.com. Сайт имени врача не называет.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Danilo Đurović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đurović Danilo' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'danilo-djurovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'danilo-djurovic', 'Danilo Đurović', 'Данило Ђуровић', 'Данило Джурович', 'Danilo Djurovic', 'dr',
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 13, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 1 врач(а/ей): danilo-djurovic.
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

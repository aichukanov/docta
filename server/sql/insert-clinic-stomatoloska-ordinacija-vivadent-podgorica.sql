-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija VIVAdent (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-vivadent-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/stomatoloska-ordinacija-vivadent-podgorica.json):
--   * https://vivadent.me/ — WordPress (Divi), версии me/en/ru. Текст — wp-json/wp/v2/pages (content с шорткодами Divi, очищен):
--     /o-nama/, /savremena-dijagnostika/, /estetska-stomatologija/, /implantologija/, /oralna-hirurgija/, /ortodoncija/,
--     /lijecenje-parodontopatije/, /protetika-2/, /dental-plan-za-firme/, /dentalni-turizam-2/, /kontakt/, /mediji/. Страницы 2024-08.
--   * data/google-places/podgorica/stomatoloska-ordinacija-vivadent.json — place_id, координаты, телефон.
-- Адрес: сайт «Ul. Kralja Nikole 47, prvi sprat, 81 000 Podgorica» = Google «47 Kralja Nikole». Телефоны и email — /kontakt/
-- (+382 67 210 663 = Google). Соцсетей на сайте нет. Часы работы на сайте не указаны.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJW6ohrkDrTRMRp0sMhQl0oFc';
SET @clinic_slug = 'stomatoloska-ordinacija-vivadent-podgorica';

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
	'Stomatološka ordinacija VIVAdent',
	'Стоматолошка ординација VIVAdent',
	'Стоматологический кабинет VIVAdent',
	'Kralja Nikole 47, prvi sprat',
	'Краља Николе 47, први спрат',
	'',
	'',
	'81000',
	42.43455030,
	19.25994120,
	'+38220623519;+38267210663;+38267224524',
	'vivadent@t-com.me',
	'https://vivadent.me/',
	'',
	'',
	'',
	'',
	'',
	'https://vivadent.me/wp-content/uploads/2024/07/cropped-vivadent4-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација VIVAdent', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет VIVAdent', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Kralja Nikole 47, prvi sprat', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Краља Николе 47, први спрат', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220623519;+38267210663;+38267224524', phone),
	email = IF(email IS NULL OR email = '', 'vivadent@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://vivadent.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://vivadent.me/wp-content/uploads/2024/07/cropped-vivadent4-logo.png', logo_url),
	latitude = COALESCE(latitude, 42.43455030),
	longitude = COALESCE(longitude, 19.25994120)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „VIVAdent“ nalazi se u Podgorici, u Ulici Kralja Nikole 47, na prvom spratu. Ordinacija pruža stomatološke usluge na specijalističkom nivou, po savremenim svjetskim standardima, sa svim stomatološkim uslugama na jednom mjestu. U ordinaciji rade dr Jovanka Lekić, specijalista ortodoncije, i dr Stefan Lekić, specijalista oralne hirurgije. Ordinacija nudi digitalnu radiografiju (ortopan, telerendgen, retroalveolarni snimci, snimci paranazalnih sinusa, temporomandibularnog zgloba i šake) uz 70–90% manje zračenja, estetsku stomatologiju (keramičke i kompozitne fasete, bezmetalne krunice, izbjeljivanje zuba kod kuće), implantologiju, oralnu hirurgiju, ortodonciju fiksnim aparatima Damon system, liječenje parodontopatije i protetiku od bezmetalne keramike. Za firme postoji dentalni plan sa plaćanjem u tri do šest mjesečnih rata, a za pacijente iz inostranstva — organizacija smještaja, prevoza i prevodioca.',
	description_sr_cyrl = 'Стоматолошка ординација „VIVAdent“ налази се у Подгорици, у Улици Краља Николе 47, на првом спрату. Ординација пружа стоматолошке услуге на специјалистичком нивоу, по савременим свјетским стандардима, са свим стоматолошким услугама на једном мјесту. У ординацији раде др Јованка Лекић, специјалиста ортодонције, и др Стефан Лекић, специјалиста оралне хирургије. Ординација нуди дигиталну радиографију (ортопан, телерендген, ретроалвеоларни снимци, снимци параназалних синуса, темпоромандибуларног зглоба и шаке) уз 70–90% мање зрачења, естетску стоматологију (керамичке и композитне фасете, безметалне крунице, избјељивање зуба код куће), имплантологију, оралну хирургију, ортодонцију фиксним апаратима Damon сyстем, лијечење пародонтопатије и протетику од безметалне керамике. За фирме постоји дентални план са плаћањем у три до шест мјесечних рата, а за пацијенте из иностранства — организација смјештаја, превоза и преводиоца.',
	description_ru = 'Стоматологический кабинет «VIVAdent» находится в Подгорице, на улице Краля Николы, 47, на втором этаже. Кабинет оказывает стоматологические услуги на специализированном уровне по современным мировым стандартам, все виды стоматологической помощи — в одном месте. Принимают Йованка Лекич, специалист по ортодонтии, и Стефан Лекич, специалист по хирургической стоматологии. Кабинет предлагает цифровую рентгенографию (ортопантомограмма, телерентгенограмма, прицельные снимки, снимки околоносовых пазух, височно-нижнечелюстного сустава и кисти) с облучением на 70–90% ниже обычного, эстетическую стоматологию (керамические и композитные виниры, безметалловые коронки, домашнее отбеливание), имплантологию, хирургическую стоматологию, ортодонтию брекет-системой Damon, лечение пародонтита и протезирование безметалловой керамикой. Для компаний есть стоматологический план с оплатой в рассрочку на три–шесть месяцев, для иностранных пациентов — организация проживания, трансфера и переводчика.',
	description_en = 'VIVAdent is a dental practice in Podgorica, at Kralja Nikole 47, first floor. The practice provides specialist-level dental care to modern international standards, with all dental services in one place. The dentists are Dr Jovanka Lekić, an orthodontics specialist, and Dr Stefan Lekić, an oral surgery specialist. Services include digital radiography (panoramic, cephalometric, periapical, paranasal sinus, temporomandibular joint and hand X-rays) with 70–90% less radiation, cosmetic dentistry (ceramic and composite veneers, metal-free crowns, at-home teeth whitening), implantology, oral surgery, orthodontics with Damon System fixed braces, periodontal treatment and metal-free ceramic prosthodontics. A dental plan for companies allows payment in three to six monthly instalments, and for patients from abroad the practice can arrange accommodation, transport and an interpreter.',
	description_de = 'VIVAdent ist eine Zahnarztpraxis in Podgorica, Kralja Nikole 47, erster Stock. Die Praxis bietet zahnmedizinische Versorgung auf Facharztniveau nach modernen internationalen Standards, alle Leistungen an einem Ort. Es behandeln Dr. Jovanka Lekić, Fachärztin für Kieferorthopädie, und Dr. Stefan Lekić, Facharzt für Oralchirurgie. Angeboten werden digitales Röntgen (Panoramaaufnahme, Fernröntgen, Zahnfilme, Aufnahmen der Nasennebenhöhlen, des Kiefergelenks und der Hand) mit 70–90 % weniger Strahlung, ästhetische Zahnheilkunde (Keramik- und Kompositveneers, metallfreie Kronen, Zahnaufhellung für zu Hause), Implantologie, Oralchirurgie, Kieferorthopädie mit festsitzenden Damon-System-Apparaturen, Parodontitisbehandlung und Prothetik aus metallfreier Keramik. Für Unternehmen gibt es einen Dentalplan mit Zahlung in drei bis sechs Monatsraten; für Patienten aus dem Ausland organisiert die Praxis Unterkunft, Transfer und Dolmetscher.',
	description_tr = 'VIVAdent, Podgorica''da Kralja Nikole 47 adresinde, birinci katta bulunan bir diş muayenehanesidir. Muayenehane çağdaş uluslararası standartlarda, uzman düzeyinde ve tüm diş hizmetlerini tek çatı altında sunar. Ortodonti uzmanı Dr. Jovanka Lekić ve ağız cerrahisi uzmanı Dr. Stefan Lekić hasta kabul eder. %70–90 daha az radyasyonla dijital radyografi (panoramik, sefalometrik, periapikal, paranazal sinüs, temporomandibular eklem ve el röntgeni), estetik diş hekimliği (seramik ve kompozit lamina, metalsiz kron, evde diş beyazlatma), implantoloji, ağız cerrahisi, Damon System sabit apareylerle ortodonti, periodontitis tedavisi ve metalsiz seramik protez hizmetleri sunulur. Şirketler için üç ila altı aylık taksitle ödeme imkânı veren bir diş planı vardır; yurt dışından gelen hastalar için konaklama, ulaşım ve tercüman ayarlanabilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (me/en/ru версии — не заявление; «mogućnost organizovanja … prevodioca» на /dentalni-turizam-2/ — переводчик, т. е. сами не говорят) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: на сайте не указаны — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (2)
-- Состав — /o-nama/ («U VIVAdent-u ordiniraju»): Dr Jovanka Lekić — «stomatolog specijalista ortodoncije», Dr Stefan Lekić — «stomatolog
-- specijalista oralne hirurgije». В БД их нет (Lekić — только envera/zvezdan/sanja/radojka, другие люди; поиск 2026-10-09).
-- Специальности: 78 = DENTISTRY, 93 = ORTHODONTIST, 74 = ORAL_SURGERY. Фото: на /o-nama/ нет; фото Stefan на /mediji/
-- (wp-content/uploads/2017/05/dr-stefan-lekic1.jpg) отдаёт 404 — без фото.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Jovanka Lekić — Specijalista ortodoncije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jovanka Lekić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lekić Jovanka' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jovanka-lekic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'jovanka-lekic', 'Jovanka Lekić', 'Јованка Лекић', 'Йованка Лекич', 'Jovanka Lekic', 'dr',
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog specijalista ortodoncije. Osnovne studije završila je na Stomatološkom fakultetu Univerziteta u Beogradu, a specijalističke studije iz ortopedije vilica na Klinici za ortopediju vilica Stomatološkog fakulteta u Beogradu. Učesnik je brojnih domaćih i inostranih seminara i predavanja iz svih oblasti stomatologije, posebno fiksne ortodoncije.',
	description_sr_cyrl = 'Стоматолог специјалиста ортодонције. Основне студије завршила је на Стоматолошком факултету Универзитета у Београду, а специјалистичке студије из ортопедије вилица на Клиници за ортопедију вилица Стоматолошког факултета у Београду. Учесник је бројних домаћих и иностраних семинара и предавања из свих области стоматологије, посебно фиксне ортодонције.',
	description_ru = 'Стоматолог, специалист по ортодонтии. Окончила стоматологический факультет Белградского университета, специализацию по ортодонтии прошла в клинике ортодонтии стоматологического факультета в Белграде. Участник многочисленных семинаров и лекций в стране и за рубежом по всем областям стоматологии, особенно по несъёмной ортодонтии.',
	description_en = 'Dentist and orthodontics specialist. She graduated from the School of Dentistry, University of Belgrade, and completed her specialist training in orthodontics at the Orthodontics Clinic of the School of Dentistry in Belgrade. She has attended numerous seminars and lectures at home and abroad on all fields of dentistry, especially fixed orthodontics.',
	description_de = 'Zahnärztin und Fachärztin für Kieferorthopädie. Sie studierte an der Zahnmedizinischen Fakultät der Universität Belgrad und absolvierte die Facharztausbildung in Kieferorthopädie an der Klinik für Kieferorthopädie der Zahnmedizinischen Fakultät in Belgrad. Sie nahm an zahlreichen Seminaren und Vorträgen im In- und Ausland zu allen Bereichen der Zahnmedizin teil, insbesondere zur festsitzenden Kieferorthopädie.',
	description_tr = 'Diş hekimi ve ortodonti uzmanı. Belgrad Üniversitesi Diş Hekimliği Fakültesinden mezun oldu, ortodonti uzmanlığını Belgrad Diş Hekimliği Fakültesi Ortodonti Kliniğinde tamamladı. Yurt içinde ve yurt dışında diş hekimliğinin tüm alanlarında, özellikle sabit ortodonti konusunda çok sayıda seminer ve derse katıldı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortodoncije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Stefan Lekić — Specijalista oralne hirurgije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Stefan Lekić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lekić Stefan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'stefan-lekic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'stefan-lekic', 'Stefan Lekić', 'Стефан Лекић', 'Стефан Лекич', 'Stefan Lekic', 'dr',
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog specijalista oralne hirurgije. Osnovne studije završio je na Stomatološkom fakultetu Univerziteta u Beogradu, a specijalističke studije iz oralne hirurgije na Klinici za oralnu i maksilofacijalnu hirurgiju Stomatološkog fakulteta u Beogradu. Učesnik je brojnih domaćih i inostranih seminara i kongresa iz oralne hirurgije, implantologije, protetike i estetske stomatologije.',
	description_sr_cyrl = 'Стоматолог специјалиста оралне хирургије. Основне студије завршио је на Стоматолошком факултету Универзитета у Београду, а специјалистичке студије из оралне хирургије на Клиници за оралну и максилофацијалну хирургију Стоматолошког факултета у Београду. Учесник је бројних домаћих и иностраних семинара и конгреса из оралне хирургије, имплантологије, протетике и естетске стоматологије.',
	description_ru = 'Стоматолог, специалист по хирургической стоматологии. Окончил стоматологический факультет Белградского университета, специализацию по хирургической стоматологии прошёл в клинике челюстно-лицевой хирургии стоматологического факультета в Белграде. Участник многочисленных семинаров и конгрессов в стране и за рубежом по хирургической стоматологии, имплантологии, протезированию и эстетической стоматологии.',
	description_en = 'Dentist and oral surgery specialist. He graduated from the School of Dentistry, University of Belgrade, and completed his specialist training in oral surgery at the Clinic for Oral and Maxillofacial Surgery of the School of Dentistry in Belgrade. He has attended numerous seminars and congresses at home and abroad on oral surgery, implantology, prosthodontics and cosmetic dentistry.',
	description_de = 'Zahnarzt und Facharzt für Oralchirurgie. Er studierte an der Zahnmedizinischen Fakultät der Universität Belgrad und absolvierte die Facharztausbildung in Oralchirurgie an der Klinik für Mund-, Kiefer- und Gesichtschirurgie der Zahnmedizinischen Fakultät in Belgrad. Er nahm an zahlreichen Seminaren und Kongressen im In- und Ausland zu Oralchirurgie, Implantologie, Prothetik und ästhetischer Zahnmedizin teil.',
	description_tr = 'Diş hekimi ve ağız cerrahisi uzmanı. Belgrad Üniversitesi Diş Hekimliği Fakültesinden mezun oldu, ağız cerrahisi uzmanlığını Belgrad Diş Hekimliği Fakültesi Ağız ve Çene-Yüz Cerrahisi Kliniğinde tamamladı. Yurt içinde ve yurt dışında ağız cerrahisi, implantoloji, protez ve estetik diş hekimliği konularında çok sayıda seminer ve kongreye katıldı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2 врач(а/ей): jovanka-lekic, stefan-lekic.
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

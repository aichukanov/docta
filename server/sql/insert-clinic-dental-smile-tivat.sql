-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dental Smile (Tivat) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-smile-tivat.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/dental-smile-tivat.json):
--   * https://www.dentalsmiletivat.com/ — статический сайт (© 2023, me/en/ru). Прочитаны главная, /o_nama, /kontakt и 26 страниц
--     меню «Usluge». /estetska.html, /akcija.html, /dentalni-turizam.html, /galerija.html — 404. Страница /otp («OPT») содержит
--     копию текста парадонтологии — услуга взята только из заголовка меню. «Akcija u toku» без цифр — не цена.
--   * data/google-places/tivat/dental-smile.json — place_id, координаты, телефон.
-- Адрес: сайт «Stari put 5/2 - Kalimanj, 85230 Tivat» (индекс на сайте с опечаткой, у Тивата 85320) = Google «CMJX+MVQ, Stari Put».
-- Телефоны: сайт +382 32 672 588, +382 69 670 892; Google +382 68 466 142 (на сайте его нет) — все три. Соцсетей на сайте нет.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJydO23XcxTBMRzyYOeS5QKa4';
SET @clinic_slug = 'dental-smile-tivat';

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
	4, -- CityId.TIVAT
	'Stomatološka ordinacija Dental Smile',
	'Стоматолошка ординација Dental Smile',
	'Стоматологический кабинет Dental Smile',
	'Stari put 5/2, Kalimanj',
	'Стари пут 5/2, Калимањ',
	'',
	'',
	'85320',
	42.43171870,
	18.69974340,
	'+38232672588;+38269670892;+38268466142',
	'office@dentalsmiletivat.com',
	'https://www.dentalsmiletivat.com/',
	'',
	'',
	'',
	'',
	'',
	'https://www.dentalsmiletivat.com/images/logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Dental Smile', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Dental Smile', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Stari put 5/2, Kalimanj', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Стари пут 5/2, Калимањ', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85320', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38232672588;+38269670892;+38268466142', phone),
	email = IF(email IS NULL OR email = '', 'office@dentalsmiletivat.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.dentalsmiletivat.com/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.dentalsmiletivat.com/images/logo.png', logo_url),
	latitude = COALESCE(latitude, 42.43171870),
	longitude = COALESCE(longitude, 18.69974340)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Dental Smile“ nalazi se u Tivtu, na adresi Stari put 5/2 (Kalimanj). Ordinacija je posvećena pružanju savremenih opštih, ortodontskih i porodičnih stomatoloških usluga i predstavlja modernu stomatološku ustanovu za tretman gubitka zuba, stomatološku kozmetiku i naprednu rekonstruktivnu stomatologiju; među prvim je kvalifikovanim ordinacijama za ugradnju implanta u Crnoj Gori, sa preko 16 godina iskustva u implantologiji. U ordinaciji rade dr Danijela Sindik, specijalista ortopedije vilica, i dr Nevena Đuričić. Ordinacija nudi kompozitne ispune, endodonciju, inleje i onleje, keramičke i kompozitne ljuspice i Lumineers, lasersko bijeljenje zuba, peskarenje Air-Flow metodom i zubni nakit, Invisalign, fiksne (metalne, estetske, lingvalne i Damon samoligirajuće), funkcionalne i mobilne ortodontske aparate, splintove za TMZ, parodontologiju, digitalni RTG i OPT snimak, implante Nobel Biocare i sistem All-on-4, metalokeramičke i bezmetalne (cirkon) krunice i mostove, totalne, skeletirane i proteze sa atečmenima i na implantima, kao i tretmane hijaluronskom kiselinom za lice. U radu koristi dentalni laser TurboWaterlase MD (Biolase) za terapiju parodontopatije, frenektomiju, gingivoplastiku, terapiju afti i desenzibilizaciju zuba.',
	description_sr_cyrl = 'Стоматолошка ординација „Dental Smile“ налази се у Тивту, на адреси Стари пут 5/2 (Калимањ). Ординација је посвећена пружању савремених општих, ортодонтских и породичних стоматолошких услуга и представља модерну стоматолошку установу за третман губитка зуба, стоматолошку козметику и напредну реконструктивну стоматологију; међу првим је квалификованим ординацијама за уградњу импланта у Црној Гори, са преко 16 година искуства у имплантологији. У ординацији раде др Данијела Синдик, специјалиста ортопедије вилица, и др Невена Ђуричић. Ординација нуди композитне испуне, ендодонцију, инлеје и онлеје, керамичке и композитне љуспице и Lumineers, ласерско бијељење зуба, пескарење Air-Flow методом и зубни накит, Invisalign, фиксне (металне, естетске, лингвалне и Damon самолигирајуће), функционалне и мобилне ортодонтске апарате, сплинтове за ТМЗ, пародонтологију, дигитални РТГ и ОПТ снимак, импланте Nobel Biocare и систем All-on-4, металокерамичке и безметалне (циркон) крунице и мостове, тоталне, скелетиране и протезе са атечменима и на имплантима, као и третмане хијалуронском киселином за лице. У раду користи дентални ласер TurboWaterlase МД (Biolase) за терапију пародонтопатије, френектомију, гингивопластику, терапију афти и десензибилизацију зуба.',
	description_ru = 'Стоматологический кабинет «Dental Smile» находится в Тивате, по адресу Стари-пут 5/2 (Калимань). Кабинет оказывает современные общие, ортодонтические и семейные стоматологические услуги и представляет собой современное стоматологическое учреждение для восстановления утраченных зубов, эстетической и реконструктивной стоматологии; он одним из первых в Черногории получил квалификацию для имплантации, опыт в имплантологии — более 16 лет. Принимают Даниела Синдик, специалист по ортодонтии, и Невена Джуричич. Кабинет предлагает композитные пломбы, эндодонтию, вкладки инлей и онлей, керамические и композитные виниры и Lumineers, лазерное отбеливание зубов, чистку Air-Flow и украшения для зубов, Invisalign, несъёмные (металлические, эстетические, лингвальные и самолигирующие Damon), функциональные и съёмные ортодонтические аппараты, сплинты при заболеваниях ВНЧС, пародонтологию, цифровой рентген и ортопантомограмму, импланты Nobel Biocare и систему All-on-4, металлокерамические и безметалловые (цирконий) коронки и мосты, полные, бюгельные протезы, протезы с аттачменами и на имплантах, а также процедуры с гиалуроновой кислотой для лица. Используется стоматологический лазер TurboWaterlase MD (Biolase) — для лечения пародонтита, френэктомии, гингивопластики, лечения афт и снижения чувствительности зубов.',
	description_en = 'Dental Smile is a dental practice in Tivat, at Stari put 5/2 (Kalimanj). The practice provides modern general, orthodontic and family dentistry and is a modern facility for treating tooth loss, cosmetic dentistry and advanced reconstructive dentistry; it was among the first practices in Montenegro qualified for implant placement and has more than 16 years of implant experience. The dentists are Dr Danijela Sindik, an orthodontics specialist, and Dr Nevena Đuričić. Services include composite fillings, endodontics, inlays and onlays, ceramic and composite veneers and Lumineers, laser teeth whitening, Air-Flow polishing and tooth jewellery, Invisalign, fixed (metal, aesthetic, lingual and Damon self-ligating), functional and removable orthodontic appliances, TMJ splints, periodontology, digital intraoral and panoramic X-rays, Nobel Biocare implants and All-on-4, metal-ceramic and metal-free (zirconia) crowns and bridges, complete, cast partial, attachment-retained and implant-supported dentures, and hyaluronic acid treatments for the face. The practice uses a TurboWaterlase MD dental laser (Biolase) for periodontal therapy, frenectomy, gingivoplasty, treatment of mouth ulcers and tooth desensitisation.',
	description_de = 'Dental Smile ist eine Zahnarztpraxis in Tivat, Stari put 5/2 (Kalimanj). Die Praxis bietet moderne allgemeine, kieferorthopädische und Familienzahnheilkunde und ist eine moderne Einrichtung für die Versorgung von Zahnverlust, kosmetische und rekonstruktive Zahnmedizin; sie gehörte zu den ersten in Montenegro für Implantationen qualifizierten Praxen und hat mehr als 16 Jahre Erfahrung in der Implantologie. Es behandeln Dr. Danijela Sindik, Fachärztin für Kieferorthopädie, und Dr. Nevena Đuričić. Angeboten werden Kompositfüllungen, Endodontie, Inlays und Onlays, Keramik- und Kompositveneers sowie Lumineers, Laser-Zahnaufhellung, Air-Flow-Reinigung und Zahnschmuck, Invisalign, festsitzende (Metall-, ästhetische, linguale und selbstligierende Damon-Brackets), funktionelle und herausnehmbare kieferorthopädische Apparaturen, Aufbissschienen bei CMD, Parodontologie, digitales Röntgen und Panoramaaufnahme, Implantate von Nobel Biocare und All-on-4, Metallkeramik- und metallfreie Zirkonkronen und -brücken, Total-, Modellguss-, Geschiebe- und implantatgetragene Prothesen sowie Hyaluronsäurebehandlungen im Gesicht. Die Praxis setzt den Dentallaser TurboWaterlase MD (Biolase) für Parodontitistherapie, Frenektomie, Gingivoplastik, Aphthenbehandlung und Desensibilisierung empfindlicher Zähne ein.',
	description_tr = 'Dental Smile, Tivat''ta Stari put 5/2 (Kalimanj) adresinde bulunan bir diş muayenehanesidir. Muayenehane modern genel, ortodontik ve aile diş hekimliği hizmetleri sunar; diş kaybı tedavisi, kozmetik ve ileri rekonstrüktif diş hekimliği için modern bir kurumdur. Karadağ''da implant uygulaması için yetkilendirilen ilk muayenehanelerden biridir ve implantolojide 16 yılı aşkın deneyime sahiptir. Ortodonti uzmanı Dr. Danijela Sindik ve Dr. Nevena Đuričić hasta kabul eder. Kompozit dolgu, endodonti, inley ve onley, seramik ve kompozit lamina ile Lumineers, lazerle diş beyazlatma, Air-Flow temizliği ve diş takısı, Invisalign, sabit (metal, estetik, lingual ve Damon kendinden bağlamalı), fonksiyonel ve hareketli ortodontik apareyler, TME splintleri, periodontoloji, dijital röntgen ve panoramik film, Nobel Biocare implantları ve All-on-4, metal-seramik ve metalsiz (zirkonyum) kron ve köprüler, tam, iskelet, ataşmanlı ve implant üstü protezler ile yüz için hiyalüronik asit uygulamaları sunulur. Periodontitis tedavisi, frenektomi, gingivoplasti, aft tedavisi ve diş hassasiyetinin giderilmesi için TurboWaterlase MD (Biolase) diş lazeri kullanılır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (EN/RU переключатель — не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: на сайте два противоречащих графика: главная «ponedeljak-srijeda 13:00 - 20:00, cetvrtak i petak 09:00 - 17:00, subota i nedelja neradni», футер всех страниц «Ponedeljak–Petak: 09:00 - 20:00» — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (2)
-- Состав — /o_nama («Upoznajte nas tim»): Dr. Danijela Sindik («Doktor specijalista», «somatolog i specijalista ortopedije vilica»),
-- Dr. Nevena Đuričić («Zubar»). Danica Krunić — «Medicinska sestra», Jelena Milenković — «Menadžer ordinacije» — не врачи, не заводятся.
-- В БД ни Sindik, ни Đuričić нет (поиск по name_sr, перевёрнутому имени и slug, 2026-10-09). Специальности: 78 = DENTISTRY, 93 = ORTHODONTIST.
-- Фото — внешние URL сайта /images/team/*.jpg (проверено: 200 image/jpeg).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Danijela Sindik — Specijalista ortopedije vilica
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Danijela Sindik' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Sindik Danijela' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'danijela-sindik' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'danijela-sindik', 'Danijela Sindik', 'Данијела Синдик', 'Даниела Синдик', 'Danijela Sindik', 'dr',
	'https://www.dentalsmiletivat.com/images/team/danijela.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog i specijalista ortopedije vilica. Rođena je u Splitu. Stomatologiju je završila 2000. godine u Beogradu, a specijalizaciju iz ortopedije vilica 2008. godine. Ubrzo poslije završetka studija počela je da radi u stomatološkoj praksi.',
	description_sr_cyrl = 'Стоматолог и специјалиста ортопедије вилица. Рођена је у Сплиту. Стоматологију је завршила 2000. године у Београду, а специјализацију из ортопедије вилица 2008. године. Убрзо послије завршетка студија почела је да ради у стоматолошкој пракси.',
	description_ru = 'Стоматолог, специалист по ортодонтии. Родилась в Сплите. В 2000 году окончила стоматологический факультет в Белграде, в 2008 году — специализацию по ортодонтии. Вскоре после окончания учёбы начала работать в стоматологической практике.',
	description_en = 'Dentist and orthodontics specialist. She was born in Split, graduated in dentistry in Belgrade in 2000 and completed her specialisation in orthodontics in 2008. She began working in dental practice soon after graduating.',
	description_de = 'Zahnärztin und Fachärztin für Kieferorthopädie. Sie wurde in Split geboren, schloss 2000 das Zahnmedizinstudium in Belgrad ab und beendete 2008 die Facharztausbildung in Kieferorthopädie. Kurz nach dem Studium begann sie in der zahnärztlichen Praxis zu arbeiten.',
	description_tr = 'Diş hekimi ve ortodonti uzmanı. Split''te doğdu; 2000''de Belgrad''da diş hekimliğinden mezun oldu, 2008''de ortodonti uzmanlığını tamamladı. Mezuniyetinden kısa süre sonra diş hekimliği pratiğinde çalışmaya başladı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Nevena Đuričić — Stomatolog
-- ───────────────────────────────────────────────────────────────
-- Сайт: «Zubar»; «Edukovala se iz oblasti oralne higijene i oralne protetike» — обучение, не специализация → только 78.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nevena Đuričić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đuričić Nevena' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nevena-djuricic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'nevena-djuricic', 'Nevena Đuričić', 'Невена Ђуричић', 'Невена Джуричич', 'Nevena Djuricic', 'dr',
	'https://www.dentalsmiletivat.com/images/team/nevena.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog. U ordinaciji „Dental Smile“ radi od 2014. godine. Edukovala se iz oblasti oralne higijene i oralne protetike.',
	description_sr_cyrl = 'Стоматолог. У ординацији „Dental Smile“ ради од 2014. године. Едуковала се из области оралне хигијене и оралне протетике.',
	description_ru = 'Стоматолог. Работает в кабинете «Dental Smile» с 2014 года. Прошла обучение в области гигиены полости рта и протезирования.',
	description_en = 'Dentist. She has worked at Dental Smile since 2014 and has completed training in oral hygiene and prosthodontics.',
	description_de = 'Zahnärztin. Sie arbeitet seit 2014 in der Praxis Dental Smile und hat Fortbildungen in Mundhygiene und Prothetik absolviert.',
	description_tr = 'Diş hekimi. 2014''ten beri Dental Smile''da çalışıyor; ağız hijyeni ve protez alanlarında eğitim aldı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 4, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2 врач(а/ей): danijela-sindik, nevena-djuricic.
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

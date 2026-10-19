-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Omnidental (Bar) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-omnidental-bar.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/omnidental-bar.json):
--   * https://www.omnidental.me/ — сайт на Wix (sitemap: главная + 4 подстраницы, lastmod 2025-10-05). Реальный текст — только на главной
--     (O nama, «Naše usluge» 4 группами, контакты, часы); подстраницы /opsta-stomatologija, /djecja-stomatologija, /hitna-stanja,
--     /estetska-stomatologija — шаблонный текст Wix («This is your About Page…») + копия перечня. EN-версия /en — тот же состав.
--   * data/google-places/bar/omnidental.json — place_id, координаты.
-- Адрес: сайт «Kraljice Jelene Anzujske 2, 85000 Bar» (без диакритики; верно — Anžujske) = Google «2 Jelene Anzujske». Телефон и email — сайт.
-- Логотип — картинка Wix без устойчивого имени, не заполняется. Соцсетей на сайте нет.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJNyvgJdZzThMRHMKtcvw2gvo';
SET @clinic_slug = 'omnidental-bar';

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
	7, -- CityId.BAR
	'Stomatološka ordinacija Omnidental',
	'Стоматолошка ординација Omnidental',
	'Стоматологический кабинет Omnidental',
	'Kraljice Jelene Anžujske 2',
	'Краљице Јелене Анжујске 2',
	'',
	'',
	'85000',
	42.09423600,
	19.09887130,
	'+38267624395',
	'omnidental.me@gmail.com',
	'https://www.omnidental.me/',
	'',
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
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Omnidental', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Omnidental', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Kraljice Jelene Anžujske 2', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Краљице Јелене Анжујске 2', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267624395', phone),
	email = IF(email IS NULL OR email = '', 'omnidental.me@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.omnidental.me/', website),
	latitude = COALESCE(latitude, 42.09423600),
	longitude = COALESCE(longitude, 19.09887130)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Omnidental“ nalazi se u Baru, u ulici Kraljice Jelene Anžujske 2. Nova, moderna praksa okrenuta najnovijim trendovima i tehnološkim dostignućima, sa individualnim pristupom svakom pacijentu; tim redovno učestvuje u edukacijama, seminarima i konferencijama. Opšta stomatologija obuhvata pregled i digitalno snimanje, uklanjanje zubnog kamenca, Airflow poliranje, „svjež dah“ koncept, probleme sa desnima i osjetljivost zuba, estetske plombe, liječenje kanala korijena, krunice i mostove, proteze, vađenje zuba i implantate. Dječja stomatologija obuhvata fluorizaciju, zalivanje fisura, uklanjanje naslaga, liječenje karijesa i kanala korijena mliječnih i stalnih zuba, vađenje zuba i ispravljanje nepravilnosti mobilnim i fiksnim aparatima. U estetskoj stomatologiji nudi izbjeljivanje zuba, kompozitne i porcelanske fasete (vinire), smile makeover i Invisalign, a zbrinjava i hitna stanja — bol, otok i frakturu zuba.',
	description_sr_cyrl = 'Стоматолошка ординација „Omnidental“ налази се у Бару, у улици Краљице Јелене Анжујске 2. Нова, модерна пракса окренута најновијим трендовима и технолошким достигнућима, са индивидуалним приступом сваком пацијенту; тим редовно учествује у едукацијама, семинарима и конференцијама. Општа стоматологија обухвата преглед и дигитално снимање, уклањање зубног каменца, Airflow полирање, „свјеж дах“ концепт, проблеме са деснима и осјетљивост зуба, естетске пломбе, лијечење канала коријена, крунице и мостове, протезе, вађење зуба и имплантате. Дјечја стоматологија обухвата флуоризацију, заливање фисура, уклањање наслага, лијечење каријеса и канала коријена млијечних и сталних зуба, вађење зуба и исправљање неправилности мобилним и фиксним апаратима. У естетској стоматологији нуди избјељивање зуба, композитне и порцеланске фасете (винире), smile makeover и Invisalign, а збрињава и хитна стања — бол, оток и фрактуру зуба.',
	description_ru = 'Стоматологический кабинет «Omnidental» находится в Баре, на улице Кралице Елене Анжуйске, 2. Это новая современная практика, ориентированная на новейшие тенденции и технологии, с индивидуальным подходом к каждому пациенту; команда регулярно участвует в обучении, семинарах и конференциях. Общая стоматология включает осмотр и цифровые снимки, удаление зубного камня, полировку Airflow, концепцию «свежего дыхания», лечение проблем с дёснами и чувствительности зубов, эстетические пломбы, лечение корневых каналов, коронки и мосты, протезы, удаление зубов и импланты. Детская стоматология — фторирование, герметизация фиссур, удаление налёта, лечение кариеса и каналов молочных и постоянных зубов, удаление зубов и исправление прикуса съёмными и несъёмными аппаратами. В эстетической стоматологии — отбеливание зубов, композитные и керамические виниры, smile makeover и Invisalign; кабинет также помогает при неотложных состояниях — боли, отёке и переломе зуба.',
	description_en = 'Omnidental is a dental practice in Bar, at Kraljice Jelene Anžujske 2. It is a new, modern practice that follows the latest trends and technology, with an individual approach to every patient; the team regularly attends courses, seminars and conferences. General dentistry covers examination and digital imaging, scaling, Airflow polishing, a “fresh breath” concept, gum problems and tooth sensitivity, cosmetic fillings, root canal treatment, crowns and bridges, dentures, extractions and implants. Paediatric dentistry covers fluoride treatment, fissure sealing, plaque removal, treatment of caries and root canals in primary and permanent teeth, extractions and correction of irregularities with removable and fixed appliances. Cosmetic dentistry includes teeth whitening, composite and porcelain veneers, smile makeovers and Invisalign, and the practice also handles emergencies — pain, swelling and tooth fractures.',
	description_de = 'Omnidental ist eine Zahnarztpraxis in Bar, Kraljice Jelene Anžujske 2. Die neue, moderne Praxis orientiert sich an den neuesten Trends und Technologien und betreut jeden Patienten individuell; das Team nimmt regelmäßig an Fortbildungen, Seminaren und Kongressen teil. Die allgemeine Zahnheilkunde umfasst Untersuchung und digitale Aufnahmen, Zahnsteinentfernung, Airflow-Politur, ein „Frischer Atem“-Konzept, Zahnfleischprobleme und empfindliche Zähne, ästhetische Füllungen, Wurzelkanalbehandlung, Kronen und Brücken, Prothesen, Zahnentfernung und Implantate. Die Kinderzahnheilkunde umfasst Fluoridierung, Fissurenversiegelung, Belagentfernung, Behandlung von Karies und Wurzelkanälen an Milch- und bleibenden Zähnen, Zahnentfernung und Korrektur von Fehlstellungen mit herausnehmbaren und festsitzenden Apparaturen. In der ästhetischen Zahnheilkunde bietet die Praxis Zahnaufhellung, Komposit- und Keramikveneers, Smile Makeover und Invisalign; sie hilft auch bei Notfällen – Schmerzen, Schwellungen und Zahnfrakturen.',
	description_tr = 'Omnidental, Bar''da Kraljice Jelene Anžujske 2 adresinde bulunan bir diş muayenehanesidir. En yeni eğilimleri ve teknolojileri takip eden, her hastaya bireysel yaklaşan yeni ve modern bir muayenehanedir; ekip düzenli olarak eğitim, seminer ve konferanslara katılır. Genel diş hekimliği muayene ve dijital görüntüleme, diş taşı temizliği, Airflow parlatma, «taze nefes» konsepti, diş eti sorunları ve diş hassasiyeti, estetik dolgular, kanal tedavisi, kron ve köprüler, protezler, diş çekimi ve implantları kapsar. Çocuk diş hekimliği florür uygulaması, fissür örtücü, plak temizliği, süt ve daimi dişlerde çürük ve kanal tedavisi, diş çekimi ile hareketli ve sabit apareylerle düzensizliklerin düzeltilmesini kapsar. Estetik diş hekimliğinde diş beyazlatma, kompozit ve porselen lamina, smile makeover ve Invisalign sunulur; muayenehane ağrı, şişlik ve diş kırığı gibi acil durumlarda da yardımcı olur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. EN-версия сайта — не заявление о приёме → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: главная, «Radno Vrijeme»: «Ponedeljak, Cetvrtak, Petak: 07:00 – 15:00; Utorak, Srijeda: 13:00 - 21:00»; выходные не указаны → закрыто.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "15:00"}]}',
	'{"type": "regular", "intervals": [{"start": "13:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "13:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "15:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "15:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- Врачей на сайте нет — ни в me, ни в en версии (только «Naš tim redovno učestvuje u edukacijama…»). Привязывать некого.
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 7, status = published, clinic_languages = 1, clinic_types = 2, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Врачей в этом импорте нет — ожидается 0 строк.
SELECT COUNT(*) AS doctors FROM doctor_clinics WHERE clinic_id = @clinic_id;

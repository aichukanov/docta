-- ═══════════════════════════════════════════════════════════════════════════
-- Dental Implant Centar — Dr Keković (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-implant-centar-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/dental-implant-centar-podgorica.json):
--   * https://www.drkekovic.com/dental-implant-centar.html — статическая страница «Dental Implant Centar» (© 2019, Last-Modified 2024-08-14).
--     Корень сайта — выбор города BEOGRAD / PODGORICA; белградская страница (kekovic.html, +381 62 109 8182) не заводится.
--     Ссылки меню (about, contact, gallery) — 404. Перечня услуг нет, только проза; цен нет.
--   * data/google-places/podgorica/dental-implant-centar.json — место «Dental Implant Centar», «F736+G47, Podgorica», +382 69 055 040.
--     Место подтверждено самим сайтом: встроенная карта Google на странице указывает на то же место (cid 0x89702603987de93a =
--     9903457377472866618 = cid из файла места), телефон совпадает. Координаты — из места Google, не примерные.
-- Адрес: сайт «Sedma omladinska bb (žuta zgrada)» (у Google только plus-код). Email, соцсетей и часов на сайте нет.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJwYoB47WUTRMROul9mAMmcIk';
SET @clinic_slug = 'dental-implant-centar-podgorica';

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
	'Dental Implant Centar',
	'Dental Implant Centar',
	'Dental Implant Centar',
	'Sedma omladinska bb (žuta zgrada)',
	'Седма омладинска бб (жута зграда)',
	'',
	'',
	'81000',
	42.45378850,
	19.26030220,
	'+38269055040',
	'',
	'https://www.drkekovic.com/dental-implant-centar.html',
	'',
	'',
	'',
	'',
	'',
	'https://www.drkekovic.com/img/dental-implant-centar-header-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Dental Implant Centar', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Dental Implant Centar', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Sedma omladinska bb (žuta zgrada)', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Седма омладинска бб (жута зграда)', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269055040', phone),
	website = IF(website IS NULL OR website = '', 'https://www.drkekovic.com/dental-implant-centar.html', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.drkekovic.com/img/dental-implant-centar-header-logo.png', logo_url),
	latitude = COALESCE(latitude, 42.45378850),
	longitude = COALESCE(longitude, 19.26030220)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Dental Implant Centar je stomatološka ordinacija u Podgorici, u ulici Sedma omladinska bb (žuta zgrada). Ordinacija pokriva čitav spektar stomatoloških usluga, a posebno je specijalizovana za oblast implantologije i implanto-protetike, uključujući i visokozahtjevne implantološke slučajeve. Ordinira dr spec. Vladan Keković, specijalista maksilofacijalne hirurgije. Pored konvencionalne implantologije, sinus-lift procedura i vođene regeneracije kosti, koje se rutinski rade, obavljaju se i napredni hirurški zahvati kao što su transplantacija kosti, transplantacija mekih tkiva i ugradnja pterigoidnih i zigomatičnih implantata kod pacijenata kojima je to usljed nedostatka kosti potrebno. Ordinacija sarađuje sa dentalnim laboratorijama u Beogradu i Podgorici.',
	description_sr_cyrl = 'Dental Implant Centar је стоматолошка ординација у Подгорици, у улици Седма омладинска бб (жута зграда). Ординација покрива читав спектар стоматолошких услуга, а посебно је специјализована за област имплантологије и импланто-протетике, укључујући и високозахтјевне имплантолошке случајеве. Ординира др спец. Владан Кековић, специјалиста максилофацијалне хирургије. Поред конвенционалне имплантологије, синус-лифт процедура и вођене регенерације кости, које се рутински раде, обављају се и напредни хируршки захвати као што су трансплантација кости, трансплантација меких ткива и уградња птеригоидних и зигоматичних имплантата код пацијената којима је то усљед недостатка кости потребно. Ординација сарађује са денталним лабораторијама у Београду и Подгорици.',
	description_ru = 'Dental Implant Centar — стоматологический кабинет в Подгорице, на улице Седма омладинска б/н (жёлтое здание). Кабинет оказывает весь спектр стоматологических услуг и специализируется на имплантологии и протезировании на имплантах, в том числе в сложных клинических случаях. Принимает Владан Кекович, специалист по челюстно-лицевой хирургии. Помимо классической имплантации, синус-лифтинга и направленной регенерации кости, которые выполняются регулярно, проводятся и сложные хирургические вмешательства: пересадка кости, пересадка мягких тканей, установка птеригоидных и скуловых имплантов пациентам с недостатком костной ткани. Кабинет сотрудничает с зуботехническими лабораториями в Белграде и Подгорице.',
	description_en = 'Dental Implant Centar is a dental practice in Podgorica, at Sedma omladinska bb (the yellow building). The practice covers the full range of dental services and specialises in implantology and implant prosthetics, including highly demanding implant cases. The practitioner is Dr Vladan Keković, a maxillofacial surgery specialist. Besides conventional implant placement, sinus lifts and guided bone regeneration, which are performed routinely, the practice carries out advanced procedures such as bone grafting, soft tissue grafting and placement of pterygoid and zygomatic implants for patients who lack sufficient bone. The practice works with dental laboratories in Belgrade and Podgorica.',
	description_de = 'Dental Implant Centar ist eine Zahnarztpraxis in Podgorica, Sedma omladinska bb (gelbes Gebäude). Die Praxis deckt das gesamte Spektrum zahnärztlicher Leistungen ab und ist auf Implantologie und Implantatprothetik spezialisiert, auch bei sehr anspruchsvollen Fällen. Es behandelt Dr. Vladan Keković, Facharzt für Mund-, Kiefer- und Gesichtschirurgie. Neben konventioneller Implantologie, Sinuslift und gesteuerter Knochenregeneration, die routinemäßig durchgeführt werden, bietet die Praxis anspruchsvolle Eingriffe wie Knochentransplantation, Weichgewebstransplantation sowie pterygoidale und zygomatische Implantate für Patienten mit Knochenmangel. Die Praxis arbeitet mit Dentallaboren in Belgrad und Podgorica zusammen.',
	description_tr = 'Dental Implant Centar, Podgorica''da Sedma omladinska bb (sarı bina) adresinde bulunan bir diş muayenehanesidir. Muayenehane diş hekimliği hizmetlerinin tamamını sunar ve özellikle implantoloji ile implant üstü protezlerde, zorlu implant vakaları dahil, uzmanlaşmıştır. Çene-yüz cerrahisi uzmanı Dr. Vladan Keković hasta kabul eder. Rutin olarak yapılan klasik implant uygulaması, sinüs lifting ve yönlendirilmiş kemik rejenerasyonunun yanı sıra kemik nakli, yumuşak doku nakli ve kemik yetersizliği olan hastalara pterigoid ve zigomatik implant uygulaması gibi ileri cerrahi işlemler yapılır. Muayenehane Belgrad ve Podgorica''daki diş laboratuvarlarıyla çalışır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на me, другие языки не заявлены → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: на сайте и в месте Google часов нет — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- Врач один — заголовок страницы «Dr spec. Vladan Keković»: «je specijalista maksilofacijalne hirurgije. Specijalizaciju je završio na Klinici
-- za maksilofacijalnu hirurgiju Stomatološkog fakulteta Univerziteta u Beogradu». В БД нет (поиск Keković / kekovic — только Svetlana Keković,
-- медицина труда, ДЗ Подгорица — другой человек; 2026-10-09). Slug vladan-kekovic на проде свободен (204).
-- Специальности: 91 = MAXILLOFACIAL_SURGERY (сайт) + 78 = DENTISTRY (специализация на стоматологическом факультете — врач-стоматолог;
-- страница посвящена имплантологии). Фото — CSS-фон блока биографии img/dr-kekovic-bio.jpg (проверено: 200 image/jpeg).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Vladan Keković — Specijalista maksilofacijalne hirurgije, implantolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vladan Keković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Keković Vladan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vladan-kekovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'vladan-kekovic', 'Vladan Keković', 'Владан Кековић', 'Владан Кекович', 'Vladan Kekovic', 'dr',
	'https://www.drkekovic.com/img/dr-kekovic-bio.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista maksilofacijalne hirurgije. Specijalizaciju je završio na Klinici za maksilofacijalnu hirurgiju Stomatološkog fakulteta Univerziteta u Beogradu, gdje je i na završnoj godini doktorskih studija. Tokom školovanja dobio je pet međunarodnih stipendija, u okviru kojih je proveo četiri godine kliničke prakse na univerzitetima u regionu i inostranstvu. Autor je i koautor više međunarodno publikovanih naučnih radova iz maksilofacijalne hirurgije. U oblasti implantologije usavršavao se u inostranstvu, objavio je radove iz te oblasti i dobitnik je stipendije ITI (International Team for Implantology).',
	description_sr_cyrl = 'Специјалиста максилофацијалне хирургије. Специјализацију је завршио на Клиници за максилофацијалну хирургију Стоматолошког факултета Универзитета у Београду, гдје је и на завршној години докторских студија. Током школовања добио је пет међународних стипендија, у оквиру којих је провео четири године клиничке праксе на универзитетима у региону и иностранству. Аутор је и коаутор више међународно публикованих научних радова из максилофацијалне хирургије. У области имплантологије усавршавао се у иностранству, објавио је радове из те области и добитник је стипендије ITI (International Team for Implantology).',
	description_ru = 'Специалист по челюстно-лицевой хирургии. Специализацию прошёл в Клинике челюстно-лицевой хирургии стоматологического факультета Белградского университета, где учится на последнем году докторантуры. За время учёбы получил пять международных стипендий и провёл четыре года клинической практики в университетах региона и за рубежом. Автор и соавтор ряда международных научных публикаций по челюстно-лицевой хирургии. Совершенствовался в имплантологии за рубежом, публиковал работы в этой области, обладатель стипендии ITI (International Team for Implantology).',
	description_en = 'Maxillofacial surgery specialist. He completed his specialisation at the Clinic for Maxillofacial Surgery of the School of Dental Medicine, University of Belgrade, where he is in the final year of doctoral studies. During his training he received five international scholarships and spent four years in clinical practice at universities in the region and abroad. He is the author and co-author of several internationally published papers in maxillofacial surgery. He trained in implantology abroad, has published in the field and holds an ITI (International Team for Implantology) scholarship.',
	description_de = 'Facharzt für Mund-, Kiefer- und Gesichtschirurgie. Die Facharztausbildung absolvierte er an der Klinik für Kieferchirurgie der Zahnmedizinischen Fakultät der Universität Belgrad, wo er sich im letzten Jahr des Doktoratsstudiums befindet. Während der Ausbildung erhielt er fünf internationale Stipendien und verbrachte vier Jahre in der klinischen Praxis an Universitäten in der Region und im Ausland. Er ist Autor und Mitautor mehrerer international veröffentlichter Fachartikel zur Kieferchirurgie. In der Implantologie bildete er sich im Ausland fort, publizierte auf diesem Gebiet und ist Stipendiat des ITI (International Team for Implantology).',
	description_tr = 'Çene-yüz cerrahisi uzmanı. Uzmanlığını Belgrad Üniversitesi Diş Hekimliği Fakültesi Çene-Yüz Cerrahisi Kliniği''nde tamamladı; aynı yerde doktora eğitiminin son yılındadır. Eğitimi sırasında beş uluslararası burs aldı ve bölgedeki ve yurt dışındaki üniversitelerde dört yıl klinik pratik yaptı. Çene-yüz cerrahisi alanında uluslararası yayımlanmış birçok bilimsel makalenin yazarı ve ortak yazarıdır. İmplantoloji alanında yurt dışında kendini geliştirdi, bu alanda yayınlar yaptı ve ITI (International Team for Implantology) bursu sahibidir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 91), (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista maksilofacijalne hirurgije, implantolog')
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

-- Ожидается 1 врач(а/ей): vladan-kekovic.
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

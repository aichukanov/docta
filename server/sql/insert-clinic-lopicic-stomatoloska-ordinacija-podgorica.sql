-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Lopičić (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-lopicic-stomatoloska-ordinacija-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/lopicic-stomatoloska-ordinacija-podgorica.json):
--   * https://www.stomatoloskaordinacija.me/ — главная, /o-nama (NAŠ TIM), /kontakt, 10 страниц
--     услуг, /cjenovnik (в меню нет);
--   * data/google-places/podgorica/stomatoloska-ordinacija-lopicic.json — place_id,
--     координаты 42.4445427 / 19.248795, телефон +382 67 244 778, адрес.
--
-- Сверка: адрес «Moskovska 135 (dvorišna strana zgrade Maksim)» — сайт и Google
-- совпадают. Телефоны: оба с сайта, первый подтверждён Google; второй сайт пишет и
-- рядом с именем dr Aleksandra Lopičića → он же записан врачу.
--
-- ФОТО ВРАЧЕЙ НЕ ЗАПИСАНЫ: три портрета на /o-nama лежат по адресам с диакритикой
-- (…/1711445813-aleksandar-lopičić.webp и т.п.), сервер на них отдаёт HTML-заглушку
-- вместо картинки — и в UTF-8, и в %-кодировке. Файл без диакритики
-- (milena_rosandic.webp, медсестра) отдаётся нормально — битые именно ссылки врачей.
--
-- Медсёстры/ассистенты (Katarina Nikolić, Nikola Popović, Milena Rosandić) не
-- заводятся — doctors только для врачей.
--
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug, врачи
-- по name_sr / перевёрнутому имени / slug; пустые поля существующей записи
-- дозаполняются, непустые не трогаются (status тоже). description_* клиники и
-- врачей пишутся БЕЗУСЛОВНЫМ UPDATE — правки описаний вносить сюда, иначе
-- следующий прогон их перезапишет. Языки клиники и часы синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJT3m0yTHrTRMRTG-Eba4IBHo';
SET @clinic_slug = 'lopicic-stomatoloska-ordinacija-podgorica';

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
	'Stomatološka ordinacija Lopičić',
	'Стоматолошка ординација Лопичић',
	'Стоматологическая клиника Лопичич',
	'Moskovska 135 (dvorišna strana zgrade Maksim)',
	'Московска 135 (дворишна страна зграде Максим)',
	'',
	'',
	'81000',
	42.44454270,
	19.24879500,
	'+38267244778;+38269380724',
	'drlopicic@stomatoloskaordinacija.me',
	'https://www.stomatoloskaordinacija.me/',
	'facebook.com/studio.lopicic',
	'@studio_za_dentalnu_estetiku_',
	'',
	'',
	'',
	'https://www.stomatoloskaordinacija.me/uploads/useruploads/Photos/logo_lopicic_stomatoloska_ordinacija.svg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Лопичић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая клиника Лопичич', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Moskovska 135 (dvorišna strana zgrade Maksim)', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Московска 135 (дворишна страна зграде Максим)', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude = COALESCE(latitude, 42.44454270),
	longitude = COALESCE(longitude, 19.24879500),
	phone = IF(phone IS NULL OR phone = '', '+38267244778;+38269380724', phone),
	email = IF(email IS NULL OR email = '', 'drlopicic@stomatoloskaordinacija.me', email),
	website = IF(website IS NULL OR website = '', 'https://www.stomatoloskaordinacija.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/studio.lopicic', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@studio_za_dentalnu_estetiku_', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.stomatoloskaordinacija.me/uploads/useruploads/Photos/logo_lopicic_stomatoloska_ordinacija.svg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (см. шапку). Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija i studio za dentalnu estetiku u Podgorici, u Moskovskoj ulici 135 (dvorišna strana zgrade Maksim). Studio za dentalnu estetiku Lopičić osnovao je 2013. godine dr Aleksandar Lopičić, specijalista stomatološke protetike. Ordinacija se bavi preventivnom i dječijom stomatologijom, liječenjem karijesa i bolesti desni, skidanjem kamenca, mašinskom endodoncijom uz digitalno mjerenje dužine kanala, oralnom hirurgijom i ugradnjom implantata, protetikom, ortodoncijom (mobilni i fiksni aparati, folije za ispravljanje zuba) i estetskom stomatologijom (izbjeljivanje zuba, fasete, zubni nakit). Otisci se uzimaju digitalno, 3D skenerom, a bezmetalne keramičke krunice i fasete izrađuju se CAD/CAM sistemom. Rendgen dijagnostika je digitalna: RTG, ortopan i 3D snimci. U ordinaciji se radi i mezoterapija lica.',
	description_sr_cyrl = 'Стоматолошка ординација и студио за денталну естетику у Подгорици, у Московској улици 135 (дворишна страна зграде Максим). Студио за денталну естетику Лопичић основао је 2013. године др Александар Лопичић, специјалиста стоматолошке протетике. Ординација се бави превентивном и дјечијом стоматологијом, лијечењем каријеса и болести десни, скидањем каменца, машинском ендодонцијом уз дигитално мјерење дужине канала, оралном хирургијом и уградњом имплантата, протетиком, ортодонцијом (мобилни и фиксни апарати, фолије за исправљање зуба) и естетском стоматологијом (избјељивање зуба, фасете, зубни накит). Отисци се узимају дигитално, 3D скенером, а безметалне керамичке крунице и фасете израђују се CAD/CAM системом. Рендген дијагностика је дигитална: RTG, ортопан и 3D снимци. У ординацији се ради и мезотерапија лица.',
	description_ru = 'Стоматологическая клиника и студия эстетической стоматологии в Подгорице, на улице Московска, 135 (со стороны двора здания «Максим»). Студию эстетической стоматологии «Лопичич» в 2013 году основал доктор Александар Лопичич, специалист по стоматологической ортопедии. Клиника занимается профилактической и детской стоматологией, лечением кариеса и заболеваний дёсен, удалением зубного камня, машинной эндодонтией с цифровым измерением длины каналов, хирургической стоматологией и имплантацией, протезированием, ортодонтией (съёмные и несъёмные аппараты, элайнеры) и эстетической стоматологией (отбеливание, виниры, украшения для зубов). Слепки снимаются цифровым 3D-сканером, а безметалловые керамические коронки и виниры изготавливаются по технологии CAD/CAM. Рентгенодиагностика цифровая: прицельные снимки, ортопантомограмма и 3D-снимки. В клинике также делают мезотерапию лица.',
	description_en = 'A dental practice and dental aesthetics studio in Podgorica, at Moskovska 135 (courtyard side of the Maksim building). The Lopičić dental aesthetics studio was founded in 2013 by Dr Aleksandar Lopičić, a specialist in prosthodontics. The practice provides preventive and paediatric dentistry, treatment of caries and gum disease, scaling, rotary endodontics with digital root canal length measurement, oral surgery and dental implants, prosthodontics, orthodontics (removable and fixed appliances, clear aligners) and cosmetic dentistry (teeth whitening, veneers, tooth jewellery). Impressions are taken digitally with a 3D scanner, and metal-free ceramic crowns and veneers are made with a CAD/CAM system. X-ray diagnostics are digital: dental X-rays, panoramic and 3D scans. Facial mesotherapy is also offered.',
	description_de = 'Zahnarztpraxis und Studio für ästhetische Zahnmedizin in Podgorica, Moskovska 135 (Hofseite des Gebäudes Maksim). Das Studio für ästhetische Zahnmedizin Lopičić wurde 2013 von Dr. Aleksandar Lopičić, Fachzahnarzt für Prothetik, gegründet. Die Praxis bietet Prophylaxe und Kinderzahnheilkunde, Behandlung von Karies und Zahnfleischerkrankungen, Zahnsteinentfernung, maschinelle Endodontie mit digitaler Längenmessung der Wurzelkanäle, Oralchirurgie und Implantologie, Prothetik, Kieferorthopädie (herausnehmbare und feste Apparaturen, Aligner) sowie ästhetische Zahnmedizin (Bleaching, Veneers, Zahnschmuck). Abformungen erfolgen digital mit einem 3D-Scanner, metallfreie Keramikkronen und Veneers werden im CAD/CAM-Verfahren hergestellt. Die Röntgendiagnostik ist digital: Einzelaufnahmen, Panorama- und 3D-Aufnahmen. Außerdem wird Mesotherapie des Gesichts angeboten.',
	description_tr = 'Podgorica''da, Moskovska 135 adresinde (Maksim binasının avlu tarafı) bulunan diş kliniği ve estetik diş hekimliği stüdyosu. Lopičić estetik diş hekimliği stüdyosu, 2013 yılında protetik diş tedavisi uzmanı Dr. Aleksandar Lopičić tarafından kuruldu. Klinikte koruyucu ve çocuk diş hekimliği, çürük ve diş eti hastalıkları tedavisi, diş taşı temizliği, kanal boyunun dijital ölçümüyle makine destekli endodonti, ağız cerrahisi ve implant, protez, ortodonti (hareketli ve sabit apareyler, şeffaf plaklar) ve estetik diş hekimliği (diş beyazlatma, lamina, diş takısı) hizmetleri sunulmaktadır. Ölçüler 3D tarayıcı ile dijital olarak alınır, metal desteksiz seramik kronlar ve laminalar CAD/CAM sistemiyle üretilir. Röntgen tanısı dijitaldir: diş röntgeni, panoramik ve 3D çekimler. Klinikte yüz mezoterapisi de yapılmaktadır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет
-- приём на других языках → только SR (LanguageId.SR = 1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: футер всех страниц «Pon - Sub: 9:30 - 16:30»; воскресенье в перечне нет → closed.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "16:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "16:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "16:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "16:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "16:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "16:30"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Специальность 78 = DENTISTRY. Язык 1 = SR (других сайт не заявляет).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Aleksandar Lopičić — spec. stomatološke protetike, osnivač
-- Протетики в enums/specialty.ts нет → только DENTISTRY; специализация — в position и био.
-- Фото на сайте битое (см. шапку).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Lopičić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Lopičić Aleksandar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aleksandar-lopicic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'aleksandar-lopicic', 'Aleksandar Lopičić', 'Александар Лопичић', 'Александар Лопичич', 'Aleksandar Lopicic', 'Dr',
	NULL, '+38269380724', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET phone = IF(phone IS NULL OR phone = '', '+38269380724', phone) WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Specijalista stomatološke protetike, rođen 1977. godine u Podgorici. Stomatološki fakultet u Beogradu upisao je 1996. i diplomirao 2002. godine, a specijalizaciju iz stomatološke protetike završio je 2007, takođe u Beogradu. Radio je na Stomatološkoj poliklinici i kao asistent na Stomatološkom fakultetu u Podgorici na predmetima Gnatologija i Protetika. Od 2013. godine vodi Studio za dentalnu estetiku Lopičić i posvećen je privatnoj praksi. Više od deset godina koristi CAD/CAM tehnologije i usavršava se iz implantologije i digitalne stomatologije. U ordinaciji je uveo protokol kompjuterski vođenog dizajna i izrade bezmetalnih keramičkih krunica i faseta, kao i standarde mašinske endodoncije i implantologije, i obučava mlađe kolege.',
	description_sr_cyrl = 'Специјалиста стоматолошке протетике, рођен 1977. године у Подгорици. Стоматолошки факултет у Београду уписао је 1996. и дипломирао 2002. године, а специјализацију из стоматолошке протетике завршио је 2007, такође у Београду. Радио је на Стоматолошкој поликлиници и као асистент на Стоматолошком факултету у Подгорици на предметима Гнатологија и Протетика. Од 2013. године води Студио за денталну естетику Лопичић и посвећен је приватној пракси. Више од десет година користи CAD/CAM технологије и усавршава се из имплантологије и дигиталне стоматологије. У ординацији је увео протокол компјутерски вођеног дизајна и израде безметалних керамичких круница и фасета, као и стандарде машинске ендодонције и имплантологије, и обучава млађе колеге.',
	description_ru = 'Специалист по стоматологической ортопедии, родился в 1977 году в Подгорице. В 1996 году поступил на стоматологический факультет в Белграде и окончил его в 2002 году; специализацию по ортопедической стоматологии завершил в 2007 году, также в Белграде. Работал в Стоматологической поликлинике и ассистентом на стоматологическом факультете в Подгорице по предметам «Гнатология» и «Протезирование». С 2013 года руководит студией эстетической стоматологии «Лопичич» и полностью посвятил себя частной практике. Более десяти лет работает с технологиями CAD/CAM и совершенствуется в имплантологии и цифровой стоматологии. Внедрил в клинике протокол компьютерного проектирования и изготовления безметалловых керамических коронок и виниров, а также стандарты машинной эндодонтии и имплантологии; обучает молодых коллег.',
	description_en = 'A specialist in prosthodontics, born in 1977 in Podgorica. He enrolled at the School of Dental Medicine in Belgrade in 1996 and graduated in 2002, and completed his specialisation in prosthodontics in 2007, also in Belgrade. He worked at the Dental Polyclinic and as a teaching assistant at the School of Dentistry in Podgorica in gnathology and prosthodontics. Since 2013 he has run the Lopičić dental aesthetics studio and devoted himself to private practice. He has used CAD/CAM technology for more than ten years and has trained further in implantology and digital dentistry. At the practice he introduced a protocol for computer-aided design and manufacture of metal-free ceramic crowns and veneers, as well as standards for rotary endodontics and implantology, and he trains younger colleagues.',
	description_de = 'Fachzahnarzt für Prothetik, 1977 in Podgorica geboren. Er begann 1996 das Studium an der Zahnmedizinischen Fakultät in Belgrad, schloss es 2002 ab und beendete 2007, ebenfalls in Belgrad, seine Fachausbildung in Prothetik. Er arbeitete an der Zahnmedizinischen Poliklinik und als Assistent an der Zahnmedizinischen Fakultät in Podgorica in den Fächern Gnathologie und Prothetik. Seit 2013 leitet er das Studio für ästhetische Zahnmedizin Lopičić und widmet sich ganz der Privatpraxis. Seit mehr als zehn Jahren arbeitet er mit CAD/CAM-Technologie und bildet sich in Implantologie und digitaler Zahnmedizin weiter. In der Praxis führte er ein Protokoll für die computergestützte Konstruktion und Fertigung metallfreier Keramikkronen und Veneers sowie Standards für maschinelle Endodontie und Implantologie ein; er bildet jüngere Kollegen aus.',
	description_tr = 'Protetik diş tedavisi uzmanı, 1977 yılında Podgorica''da doğdu. 1996 yılında Belgrad Diş Hekimliği Fakültesine girdi ve 2002 yılında mezun oldu; protetik diş tedavisi uzmanlığını 2007 yılında yine Belgrad''da tamamladı. Diş Polikliniğinde ve Podgorica Diş Hekimliği Fakültesinde gnatoloji ve protez derslerinde asistan olarak çalıştı. 2013 yılından bu yana Lopičić estetik diş hekimliği stüdyosunu yönetmekte ve kendini özel muayenehaneye adamış durumdadır. On yılı aşkın süredir CAD/CAM teknolojilerini kullanmakta, implantoloji ve dijital diş hekimliği alanlarında kendini geliştirmektedir. Klinikte metal desteksiz seramik kron ve laminaların bilgisayar destekli tasarım ve üretim protokolünü, ayrıca makine destekli endodonti ve implantoloji standartlarını uygulamaya koydu; genç meslektaşlarını yetiştirmektedir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista stomatološke protetike')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Amra Amidović Hamzić — doktor stomatologije
-- Био на сайте нет; фото битое.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Amra Amidović Hamzić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Amidović Hamzić Amra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'amra-amidovic-hamzic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'amra-amidovic-hamzic', 'Amra Amidović Hamzić', 'Амра Амидовић Хамзић', 'Амра Амидович Хамзич', 'Amra Amidovic Hamzic', 'Dr',
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Anđela Đurišić — doktor stomatologije
-- Био на сайте нет; фото битое.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Anđela Đurišić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Đurišić Anđela' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'andjela-djurisic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'andjela-djurisic', 'Anđela Đurišić', 'Анђела Ђуришић', 'Анджела Джуришич', 'Andjela Djurisic', 'Dr',
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Katarina Nikolić (stomatološka sestra), Nikola Popović (dentalni asistent), Milena Rosandić (stomatološka sestra) — не врачи, не заводятся.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '2', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3 врач(а); created_at сильно раньше запуска = переиспользован
-- существующий врач — убедиться, что это тот же человек.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	IF(d.description_sr IS NULL, 'NO BIO', 'ok') AS bio,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;

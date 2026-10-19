-- ═══════════════════════════════════════════════════════════════════════════
-- AXON Fizikalna Terapija (Podgorica) — клиника + физиотерапевты/врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-axon-fizikalna-terapija-podgorica.sql
-- Затем: server/sql/insert-clinic-axon-fizikalna-terapija-podgorica-services.sql
-- Запись импорта: data/clinic-imports/axon-fizikalna-terapija-podgorica.json. Подволна 2c, агент P.
--
-- Источники (собрано 2026-10-08, сырой HTML curl'ом):
--   * https://www.fizioaxon.com/ — статический сайт (index, o-nama, specijalizacije, usluge,
--     rezultati, kontakt; sitemap.xml), © 2025, Last-Modified страниц 30.09–06.10.2026.
--     В карточке Google сайта нет — там https://linktr.ee/axonpodgorica (WhatsApp
--     +38267080890, Instagram, карта); сайт подсказан координатором.
--   * data/google-places/podgorica/axon-fizikalna-terapija.json — place_id, координаты
--     42.4355206 / 19.2412116, телефон +382 67 080 890 (35 отзывов — не импортируются).
--
-- Сверка: адрес «Dr Vukašina Markovića 114, 81000 Podgorica» — сайт и Google совпадают.
-- Телефон +382 67 080 890 — сайт, Google и WhatsApp в linktr.ee.
-- Соцсети: Instagram @axon_fizikalna_terapija; ссылка «Facebook» в футере ведёт на
-- https://www.facebook.com (заглушка) — не заполняем.
-- Цен на сайте нет. «Zakažite besplatne konsultacije» — в услуги не заведено (см. запись).
-- Языки клиники: только SR.
--
-- Врачи: Dr Aleksandra Savić уже в базе (aleksandra-savic: физиатр, КЦЦГ / ДЗ Колашин /
-- Spa Medica; сайт AXON тоже пишет «…pacijenata u KCCG») — привязка + дозаполнение пустых
-- полей (фото, name_ru/en, описания). Четыре физиотерапевта — новые.
--
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr;
-- пустые поля существующей записи дозаполняются, непустые не трогаются. description_*
-- клиники и НОВЫХ физиотерапевтов пишутся безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJNWX6KgDrTRMRskpO74r8428';
SET @clinic_slug = 'axon-fizikalna-terapija-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('AXON Fizikalna Terapija', 'Axon fizikalna terapija') AND city_id = 1 LIMIT 1));

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
	'AXON Fizikalna Terapija',
	'AXON Физикална Терапија',
	'AXON — физиотерапия и реабилитация',
	'Dr Vukašina Markovića 114',
	'Др Вукашина Марковића 114',
	'',
	'',
	'81000',
	42.43552060,
	19.24121160,
	'+38267080890',
	'axonpodgorica@gmail.com',
	'https://www.fizioaxon.com/',
	'',
	'@axon_fizikalna_terapija',
	'',
	'+38267080890',
	'',
	'https://www.fizioaxon.com/images/axon-logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'AXON Физикална Терапија', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'AXON — физиотерапия и реабилитация', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Dr Vukašina Markovića 114', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Др Вукашина Марковића 114', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude        = COALESCE(latitude, 42.43552060),
	longitude       = COALESCE(longitude, 19.24121160),
	phone           = IF(phone IS NULL OR phone = '', '+38267080890', phone),
	email           = IF(email IS NULL OR email = '', 'axonpodgorica@gmail.com', email),
	website         = IF(website IS NULL OR website = '', 'https://www.fizioaxon.com/', website),
	instagram       = IF(instagram IS NULL OR instagram = '', '@axon_fizikalna_terapija', instagram),
	whatsapp        = IF(whatsapp IS NULL OR whatsapp = '', '+38267080890', whatsapp),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://www.fizioaxon.com/images/axon-logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что клиника пишет о себе; оценочное не переносится.
UPDATE clinics SET
	description_sr = 'Klinika za fizikalnu terapiju i rehabilitaciju u Podgorici, na adresi Dr Vukašina Markovića 114. U timu su specijalista fizikalne medicine i rehabilitacije i četiri fizioterapeuta. Najtraženija usluga su poluindividualni treninzi pod nadzorom fizioterapeuta, u grupama od tri do četiri osobe, sa individualnim planom za svakog polaznika. Klinika se bavi liječenjem bolova u kičmi i diskus hernije, Schroth terapijom skolioze i drugih deformiteta kičme kod djece i odraslih, rehabilitacijom sportskih povreda, postoperativnom rehabilitacijom, rehabilitacijom neuroloških stanja (moždani udar, multipla skleroza, Parkinsonova bolest, periferne neuropatije) i terapijom vrtoglavica i poremećaja ravnoteže. Na raspolaganju su pregled fizijatra, TEKAR, shockwave, elektroterapija, laser, magnetoterapija, ultrazvučna terapija, akupunktura i elektroakupunktura, dry needling, kiropraktika, Mulligan mobilizacije, medicinska, sportska i relaks masaža, limfna drenaža i presoterapija.',
	description_sr_cyrl = 'Клиника за физикалну терапију и рехабилитацију у Подгорици, на адреси Др Вукашина Марковића 114. У тиму су специјалиста физикалне медицине и рехабилитације и четири физиотерапеута. Најтраженија услуга су полуиндивидуални тренинзи под надзором физиотерапеута, у групама од три до четири особе, са индивидуалним планом за сваког полазника. Клиника се бави лијечењем болова у кичми и дискус херније, Schroth терапијом сколиозе и других деформитета кичме код дјеце и одраслих, рехабилитацијом спортских повреда, постоперативном рехабилитацијом, рехабилитацијом неуролошких стања (мождани удар, мултипла склероза, Паркинсонова болест, периферне неуропатије) и терапијом вртоглавица и поремећаја равнотеже. На располагању су преглед физијатра, ТЕКАР, shockwave, електротерапија, ласер, магнетотерапија, ултразвучна терапија, акупунктура и електроакупунктура, dry needling, киропрактика, Mulligan мобилизације, медицинска, спортска и релакс масажа, лимфна дренажа и пресотерапија.',
	description_ru = 'Клиника физиотерапии и реабилитации в Подгорице, по адресу Dr Vukašina Markovića 114. В команде — врач физической медицины и реабилитации и четыре физиотерапевта. Самая востребованная услуга — полуиндивидуальные тренировки под контролем физиотерапевта в группах по три–четыре человека, с индивидуальным планом для каждого. Клиника занимается лечением боли в спине и грыж межпозвонковых дисков, терапией по методу Шрота при сколиозе и других деформациях позвоночника у детей и взрослых, реабилитацией после спортивных травм и операций, реабилитацией при неврологических заболеваниях (инсульт, рассеянный склероз, болезнь Паркинсона, периферические нейропатии), а также лечением головокружений и нарушений равновесия. Доступны осмотр физиатра, TECAR-терапия, ударно-волновая терапия, электротерапия, лазер, магнитотерапия, ультразвуковая терапия, акупунктура и электроакупунктура, dry needling, хиропрактика, мобилизации по Mulligan, лечебный, спортивный и расслабляющий массаж, лимфодренаж и прессотерапия.',
	description_en = 'A physical therapy and rehabilitation clinic in Podgorica, at Dr Vukašina Markovića 114. The team includes a specialist in physical medicine and rehabilitation and four physiotherapists. The most requested service is semi-individual training supervised by a physiotherapist, in groups of three to four people with an individual plan for each participant. The clinic treats back pain and disc herniation, offers Schroth therapy for scoliosis and other spinal deformities in children and adults, rehabilitation after sports injuries and surgery, rehabilitation for neurological conditions (stroke, multiple sclerosis, Parkinson''s disease, peripheral neuropathies) and treatment of vertigo and balance disorders. Available treatments include a physiatrist examination, TECAR, shockwave, electrotherapy, laser, magnetic therapy, ultrasound therapy, acupuncture and electroacupuncture, dry needling, chiropractic, Mulligan mobilisations, medical, sports and relaxation massage, lymphatic drainage and pressotherapy.',
	description_de = 'Eine Klinik für Physiotherapie und Rehabilitation in Podgorica, Dr Vukašina Markovića 114. Zum Team gehören eine Fachärztin für physikalische Medizin und Rehabilitation und vier Physiotherapeuten. Am gefragtesten ist das halbindividuelle Training unter physiotherapeutischer Aufsicht in Gruppen von drei bis vier Personen mit einem individuellen Plan für jeden Teilnehmer. Die Klinik behandelt Rückenschmerzen und Bandscheibenvorfälle, bietet Schroth-Therapie bei Skoliose und anderen Wirbelsäulendeformitäten bei Kindern und Erwachsenen, Rehabilitation nach Sportverletzungen und Operationen, Rehabilitation bei neurologischen Erkrankungen (Schlaganfall, Multiple Sklerose, Parkinson, periphere Neuropathien) sowie Therapie von Schwindel und Gleichgewichtsstörungen. Verfügbar sind eine Untersuchung durch die Fachärztin für physikalische Medizin, TECAR, Stoßwellentherapie, Elektrotherapie, Laser, Magnetfeldtherapie, Ultraschalltherapie, Akupunktur und Elektroakupunktur, Dry Needling, Chiropraktik, Mulligan-Mobilisationen, medizinische, Sport- und Entspannungsmassage, Lymphdrainage und Pressotherapie.',
	description_tr = 'Podgorica''da, Dr Vukašina Markovića 114 adresinde bulunan fizik tedavi ve rehabilitasyon kliniği. Ekipte bir fiziksel tıp ve rehabilitasyon uzmanı ile dört fizyoterapist yer alır. En çok talep gören hizmet, fizyoterapist gözetiminde, üç-dört kişilik gruplarda ve her katılımcıya bireysel planla yapılan yarı bireysel antrenmanlardır. Klinik bel ve boyun ağrısı ile disk hernisi tedavisi, çocuk ve yetişkinlerde skolyoz ve diğer omurga deformiteleri için Schroth terapisi, spor yaralanmaları ve ameliyat sonrası rehabilitasyon, nörolojik durumlar (inme, multipl skleroz, Parkinson hastalığı, periferik nöropatiler) için rehabilitasyon ile baş dönmesi ve denge bozukluklarının tedavisiyle ilgilenir. Fiziksel tıp uzmanı muayenesi, TECAR, şok dalga, elektroterapi, lazer, manyetoterapi, ultrason tedavisi, akupunktur ve elektroakupunktur, dry needling, kayropraktik, Mulligan mobilizasyonları, medikal, spor ve rahatlatıcı masaj, lenf drenajı ve presoterapi sunulmaktadır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24 (как endorfin-fizio-centar-*, fizikalna-terapija-vertebra-podgorica, spa-medica-podgorica)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE, только SR (1).
SET @keep_lang_id = (
	SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND (language_id <> 1 OR id <> @keep_lang_id);

INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (
	SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1
);

-- Часы работы: «Radno Vrijeme: Pon – Pet: 08:00 – 22:00, Subota: 08:00 – 18:00, Nedjelja: Zatvoreno» (футер всех страниц, /kontakt.html)
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "18:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (5)
-- Физиотерапевты — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врачи),
-- как jelena-klikovac (OrthoExpert), valentina-buha (ДЗ Херцег-Нови), dijana-bozovic (ДЗ Котор).
-- 42 = PHYSICAL_MEDICINE (физиатр). Языки: 1 = SR (другие не заявлены).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Aleksandra Savić — Specijalista fizikalne medicine i rehabilitacije
-- УЖЕ В БАЗЕ: slug aleksandra-savic (локально и на проде id 1312), физиатр (42), КЦЦГ / ДЗ Колашин / Spa Medica. Сайт AXON: «Specijalista fizikalne medicine i rehabilitacije … rehabilitaciji … pacijenata u KCCG» — тот же человек. Только привязка + дозаполнение пустых полей (фото, name_ru, name_en, описания пусты и на проде).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'aleksandra-savic' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Aleksandra Savić' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Savić Aleksandra' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'aleksandra-savic', 'Aleksandra Savić', 'Александра Савић', 'Александра Савич', 'Aleksandra Savic', 'Dr',
	'https://www.fizioaxon.com/images/Aleksandra.png', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая запись: только пустые поля.
UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.fizioaxon.com/images/Aleksandra.png', photo_url),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Александра Савич', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Aleksandra Savic', name_en),
	description_sr = IF(description_sr IS NULL OR description_sr = '', 'Specijalista fizikalne medicine i rehabilitacije. Medicinski fakultet i specijalizaciju iz fizikalne medicine i rehabilitacije završila je u Beogradu. U Kliničkom centru Crne Gore radi na sveobuhvatnoj rehabilitaciji ortopedskih, reumatoloških, neuroloških i neurohirurških pacijenata i na ranoj postoperativnoj rehabilitaciji. Usavršavala se u ortopedskoj i onkološkoj rehabilitaciji i tretmanu limfedema; završila je sertifikovani kurs manuelne limfne drenaže po metodi dr Voddera (Dr Vodder Academy) i Školu akupunkture (SUIM).', description_sr),
	description_sr_cyrl = IF(description_sr_cyrl IS NULL OR description_sr_cyrl = '', 'Специјалиста физикалне медицине и рехабилитације. Медицински факултет и специјализацију из физикалне медицине и рехабилитације завршила је у Београду. У Клиничком центру Црне Горе ради на свеобухватној рехабилитацији ортопедских, реуматолошких, неуролошких и неурохируршких пацијената и на раној постоперативној рехабилитацији. Усавршавала се у ортопедској и онколошкој рехабилитацији и третману лимфедема; завршила је сертификовани курс мануелне лимфне дренаже по методи др Воддера (Dr Vodder Academy) и Школу акупунктуре (SUIM).', description_sr_cyrl),
	description_ru = IF(description_ru IS NULL OR description_ru = '', 'Врач физической медицины и реабилитации. Окончила медицинский факультет и специализацию по физической медицине и реабилитации в Белграде. В Клиническом центре Черногории занимается комплексной реабилитацией ортопедических, ревматологических, неврологических и нейрохирургических пациентов и ранней послеоперационной реабилитацией. Повышала квалификацию в ортопедической и онкологической реабилитации и лечении лимфедемы; прошла сертифицированный курс ручного лимфодренажа по методу доктора Фоддера (Dr Vodder Academy) и школу акупунктуры (SUIM).', description_ru),
	description_en = IF(description_en IS NULL OR description_en = '', 'A specialist in physical medicine and rehabilitation. She completed medical school and her residency in physical medicine and rehabilitation in Belgrade. At the Clinical Centre of Montenegro she works on comprehensive rehabilitation of orthopaedic, rheumatological, neurological and neurosurgical patients and on early postoperative rehabilitation. She has further training in orthopaedic and oncological rehabilitation and lymphoedema treatment, a certified course in manual lymphatic drainage by the Dr Vodder method (Dr Vodder Academy) and the School of Acupuncture (SUIM).', description_en),
	description_de = IF(description_de IS NULL OR description_de = '', 'Fachärztin für physikalische Medizin und Rehabilitation. Medizinstudium und Facharztausbildung absolvierte sie in Belgrad. Am Klinischen Zentrum Montenegros arbeitet sie in der umfassenden Rehabilitation orthopädischer, rheumatologischer, neurologischer und neurochirurgischer Patienten sowie in der frühen postoperativen Rehabilitation. Sie hat sich in orthopädischer und onkologischer Rehabilitation und in der Behandlung von Lymphödemen weitergebildet, einen zertifizierten Kurs in manueller Lymphdrainage nach Dr. Vodder (Dr Vodder Academy) sowie die Akupunkturschule (SUIM) abgeschlossen.', description_de),
	description_tr = IF(description_tr IS NULL OR description_tr = '', 'Fiziksel tıp ve rehabilitasyon uzmanı. Tıp fakültesini ve fiziksel tıp ve rehabilitasyon uzmanlığını Belgrad''da tamamlamıştır. Karadağ Klinik Merkezi''nde ortopedik, romatolojik, nörolojik ve nöroşirürjik hastaların kapsamlı rehabilitasyonu ile erken ameliyat sonrası rehabilitasyon alanında çalışmaktadır. Ortopedik ve onkolojik rehabilitasyon ile lenfödem tedavisi konularında kendini geliştirmiş; Dr Vodder yöntemiyle manuel lenf drenajı sertifika kursunu (Dr Vodder Academy) ve Akupunktur Okulu''nu (SUIM) bitirmiştir.', description_tr)
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 42);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista fizikalne medicine i rehabilitacije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Srđan Mijović — Diplomirani fizioterapeut, ISST Schroth terapeut
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Srđan Mijović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mijović Srđan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'srdjan-mijovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'srdjan-mijovic', 'Srđan Mijović', 'Срђан Мијовић', 'Срджан Миёвич', 'Srdjan Mijovic', NULL,
	'https://www.fizioaxon.com/images/Srdja.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.fizioaxon.com/images/Srdja.jpg', photo_url)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Diplomirani fizioterapeut i ISST Schroth terapeut, specijalizovan za tretman deformiteta kičmenog stuba, posebno skolioza. Usavršavao se kroz edukacije iz Schroth metode, dry needlinga, electric needlinga, sportske medicine i HVLA manipulacija.',
	description_sr_cyrl = 'Дипломирани физиотерапеут и ISST Schroth терапеут, специјализован за третман деформитета кичменог стуба, посебно сколиоза. Усавршавао се кроз едукације из Schroth методе, dry needlinga, electric needlinga, спортске медицине и HVLA манипулација.',
	description_ru = 'Дипломированный физиотерапевт и терапевт по методу Шрота (ISST Schroth), специализируется на лечении деформаций позвоночника, прежде всего сколиоза. Проходил обучение по методу Шрота, dry needling, electric needling, спортивной медицине и HVLA-манипуляциям.',
	description_en = 'A graduate physiotherapist and ISST Schroth therapist specialising in the treatment of spinal deformities, especially scoliosis. He has trained in the Schroth method, dry needling, electric needling, sports medicine and HVLA manipulation.',
	description_de = 'Diplomierter Physiotherapeut und ISST-Schroth-Therapeut, spezialisiert auf die Behandlung von Wirbelsäulendeformitäten, insbesondere Skoliose. Er hat Weiterbildungen in der Schroth-Methode, Dry Needling, Electric Needling, Sportmedizin und HVLA-Manipulation absolviert.',
	description_tr = 'Omurga deformitelerinin, özellikle skolyozun tedavisinde uzmanlaşmış diplomalı fizyoterapist ve ISST Schroth terapisti. Schroth yöntemi, dry needling, electric needling, spor hekimliği ve HVLA manipülasyonları konularında eğitim almıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Diplomirani fizioterapeut, ISST Schroth terapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Marko Mićković — Diplomirani fizioterapeut
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marko Mićković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mićković Marko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marko-mickovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'marko-mickovic', 'Marko Mićković', 'Марко Мићковић', 'Марко Мичкович', 'Marko Mickovic', NULL,
	'https://www.fizioaxon.com/images/Marko.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.fizioaxon.com/images/Marko.jpg', photo_url)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Diplomirani fizioterapeut, specijalizovan za rehabilitaciju pacijenata sa diskus hernijom, bolnim stanjima kičmenog stuba i problemima sa vrtoglavicama. Iskustvo obuhvata sportsku, ortopedsku i neurološku rehabilitaciju. Završio je dodatne edukacije iz fizioterapije kod vertiga, iThrust HVLA manipulacija, akupunkture i cupping terapije.',
	description_sr_cyrl = 'Дипломирани физиотерапеут, специјализован за рехабилитацију пацијената са дискус хернијом, болним стањима кичменог стуба и проблемима са вртоглавицама. Искуство обухвата спортску, ортопедску и неуролошку рехабилитацију. Завршио је додатне едукације из физиотерапије код вертига, iThrust HVLA манипулација, акупунктуре и cupping терапије.',
	description_ru = 'Дипломированный физиотерапевт, специализируется на реабилитации пациентов с грыжами межпозвонковых дисков, болевыми синдромами позвоночника и головокружениями. Опыт охватывает спортивную, ортопедическую и неврологическую реабилитацию. Прошёл дополнительное обучение по физиотерапии при вертиго, HVLA-манипуляциям iThrust, акупунктуре и баночной терапии (cupping).',
	description_en = 'A graduate physiotherapist specialising in rehabilitation of patients with disc herniation, painful spinal conditions and vertigo. His experience covers sports, orthopaedic and neurological rehabilitation. He has additional training in physiotherapy for vertigo, iThrust HVLA manipulation, acupuncture and cupping therapy.',
	description_de = 'Diplomierter Physiotherapeut, spezialisiert auf die Rehabilitation von Patienten mit Bandscheibenvorfall, schmerzhaften Wirbelsäulenbeschwerden und Schwindel. Seine Erfahrung umfasst Sport-, orthopädische und neurologische Rehabilitation. Er hat zusätzliche Weiterbildungen in Physiotherapie bei Vertigo, iThrust-HVLA-Manipulation, Akupunktur und Schröpftherapie (Cupping) absolviert.',
	description_tr = 'Disk hernisi, ağrılı omurga sorunları ve baş dönmesi olan hastaların rehabilitasyonunda uzmanlaşmış diplomalı fizyoterapist. Deneyimi spor, ortopedik ve nörolojik rehabilitasyonu kapsar. Vertigoda fizyoterapi, iThrust HVLA manipülasyonları, akupunktur ve kupa (cupping) tedavisi konularında ek eğitimler almıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Diplomirani fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Đorđe Barović — Fizioterapeut
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Đorđe Barović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Barović Đorđe' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'djordje-barovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'djordje-barovic', 'Đorđe Barović', 'Ђорђе Баровић', 'Джордже Барович', 'Djordje Barovic', NULL,
	'https://www.fizioaxon.com/images/Djordje.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.fizioaxon.com/images/Djordje.jpg', photo_url)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Fizioterapeut sa iskustvom u radu sa sportistima svih nivoa, u procjeni, rehabilitaciji i pripremi sportista za povratak na teren. Završio je CFSC edukaciju (Certified Functional Strength Coach) i specijalizovao se za limfnu drenažu.',
	description_sr_cyrl = 'Физиотерапеут са искуством у раду са спортистима свих нивоа, у процјени, рехабилитацији и припреми спортиста за повратак на терен. Завршио је CFSC едукацију (Certified Functional Strength Coach) и специјализовао се за лимфну дренажу.',
	description_ru = 'Физиотерапевт с опытом работы со спортсменами всех уровней — в оценке состояния, реабилитации и подготовке к возвращению в спорт. Прошёл обучение CFSC (Certified Functional Strength Coach), специализируется на лимфодренаже.',
	description_en = 'A physiotherapist experienced in working with athletes of all levels — assessment, rehabilitation and preparing athletes to return to play. He has completed the CFSC (Certified Functional Strength Coach) programme and specialises in lymphatic drainage.',
	description_de = 'Physiotherapeut mit Erfahrung in der Arbeit mit Sportlern aller Leistungsstufen — bei Befundung, Rehabilitation und Vorbereitung auf die Rückkehr in den Sport. Er hat die CFSC-Ausbildung (Certified Functional Strength Coach) absolviert und ist auf Lymphdrainage spezialisiert.',
	description_tr = 'Her seviyeden sporcuyla değerlendirme, rehabilitasyon ve sahaya dönüşe hazırlık alanında deneyimli fizyoterapist. CFSC (Certified Functional Strength Coach) eğitimini tamamlamış ve lenf drenajında uzmanlaşmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Andrija Golubović — Fizioterapeut
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Andrija Golubović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Golubović Andrija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'andrija-golubovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'andrija-golubovic', 'Andrija Golubović', 'Андрија Голубовић', 'Андрия Голубович', 'Andrija Golubovic', NULL,
	'https://www.fizioaxon.com/images/Andrija.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.fizioaxon.com/images/Andrija.jpg', photo_url)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Fizioterapeut, specijalizovan za sportske masaže, oporavak nakon povreda i grupne treninge za snagu i kondiciju.',
	description_sr_cyrl = 'Физиотерапеут, специјализован за спортске масаже, опоравак након повреда и групне тренинге за снагу и кондицију.',
	description_ru = 'Физиотерапевт, специализируется на спортивном массаже, восстановлении после травм и групповых тренировках на силу и выносливость.',
	description_en = 'A physiotherapist specialising in sports massage, recovery after injuries and group strength and conditioning training.',
	description_de = 'Physiotherapeut mit Schwerpunkt Sportmassage, Erholung nach Verletzungen und Gruppentraining für Kraft und Kondition.',
	description_tr = 'Spor masajı, sakatlık sonrası iyileşme ile kuvvet ve kondisyon odaklı grup antrenmanlarında uzmanlaşmış fizyoterapist.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '24', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 5: aleksandra-savic (42), srdjan-mijovic (94), marko-mickovic (94), djordje-barovic (94), andrija-golubovic (94).
-- Если created_at нового физиотерапевта старше даты прогона — запись уже была: проверить, тот ли человек.
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

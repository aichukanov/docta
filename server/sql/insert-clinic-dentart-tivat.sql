-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija DentArt (Tivat) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dentart-tivat.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/dentart-tivat.json):
--   * https://dentart.me/ — главная (блок «Naš tim»), /o-nama/, /stomatoloske-usluge/,
--     /estetska-stomatologija/, /rendgen-dijagnostika/, /dentalni-turizam/, /mezoterapija/,
--     /hijaluronski-fileri/, /botox/, /laserska-epilacija/, /kontakt/, /cenovnik/ (в меню нет;
--     wp-json: modified 2022-03-19, © 2022);
--   * data/google-places/tivat/dentart.json — place_id, координаты 42.4195315 / 18.7169773,
--     телефон +382 32 672 210, адрес «ul. Dumidran, bb, Tivat 85320».
--
-- Сверка: адрес Dumidran bb — сайт и Google совпадают. Телефоны: три с сайта
-- (+382 69 358 322, +382 69 047 183, +382 32 671 120) + Google +382 32 672 210, которого
-- на сайте нет (стационарный 671 120 ≠ 672 210) — оставлен последним, см. openQuestions.
--
-- Milica Lutovac Radonjić — stomatološka sestra, не заводится.
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

SET @google_place_id = 'ChIJFyjGiygyTBMROATKetg5SU8';
SET @clinic_slug = 'dentart-tivat';

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
	'Stomatološka ordinacija DentArt',
	'Стоматолошка ординација DentArt',
	'Стоматологическая клиника DentArt',
	'Dumidran bb',
	'Думидран бб',
	'',
	'',
	'85320',
	42.41953150,
	18.71697730,
	'+38269358322;+38269047183;+38232671120;+38232672210',
	'ordinacija@dentart.me',
	'https://dentart.me/',
	'facebook.com/dentart.dentart.7',
	'@dentart_tivat',
	'',
	'',
	'',
	'https://dentart.me/wp-content/uploads/dentart_logo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација DentArt', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая клиника DentArt', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Dumidran bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Думидран бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85320', postal_code),
	latitude = COALESCE(latitude, 42.41953150),
	longitude = COALESCE(longitude, 18.71697730),
	phone = IF(phone IS NULL OR phone = '', '+38269358322;+38269047183;+38232671120;+38232672210', phone),
	email = IF(email IS NULL OR email = '', 'ordinacija@dentart.me', email),
	website = IF(website IS NULL OR website = '', 'https://dentart.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/dentart.dentart.7', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@dentart_tivat', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://dentart.me/wp-content/uploads/dentart_logo.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (см. шапку). Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija u Tivtu, u ulici Dumidran, koju je 2007. godine osnovala dr Sandra Stanišić. U ordinaciji rade dva doktora stomatologije, a za složenije zahvate ordinacija angažuje specijaliste iz svih oblasti stomatologije. Ordinacija se bavi liječenjem karijesa i bolesti zuba, dječijom i preventivnom stomatologijom, protetikom (metalokeramičke i bezmetalne krunice, mostovi, keramičke fasete, akrilatne, skeletirane i fleksibilne proteze), ortodoncijom sa mobilnim i fiksnim aparatima, oralnom hirurgijom, liječenjem parodontopatije, implantologijom i estetskom stomatologijom (izbjeljivanje zuba, zubni nakit). Svi rendgen snimci su digitalni, a ortopan i retroalveolarni snimak rade se u ordinaciji. Pored stomatologije, ordinacija nudi mezoterapiju, hijaluronske filere, botoks i lasersku epilaciju. Stomatološki pregled i dijagnostika se ne naplaćuju. Pacijentima iz inostranstva ordinacija nudi dentalni turizam: plan terapije na osnovu poslatog ortopan snimka, smještaj i prevoz od aerodroma.',
	description_sr_cyrl = 'Стоматолошка ординација у Тивту, у улици Думидран, коју је 2007. године основала др Сандра Станишић. У ординацији раде два доктора стоматологије, а за сложеније захвате ординација ангажује специјалисте из свих области стоматологије. Ординација се бави лијечењем каријеса и болести зуба, дјечијом и превентивном стоматологијом, протетиком (металокерамичке и безметалне крунице, мостови, керамичке фасете, акрилатне, скелетиране и флексибилне протезе), ортодонцијом са мобилним и фиксним апаратима, оралном хирургијом, лијечењем пародонтопатије, имплантологијом и естетском стоматологијом (избјељивање зуба, зубни накит). Сви рендген снимци су дигитални, а ортопан и ретроалвеоларни снимак раде се у ординацији. Поред стоматологије, ординација нуди мезотерапију, хијалуронске филере, ботокс и ласерску епилацију. Стоматолошки преглед и дијагностика се не наплаћују. Пацијентима из иностранства ординација нуди дентални туризам: план терапије на основу послатог ортопан снимка, смјештај и превоз од аеродрома.',
	description_ru = 'Стоматологическая клиника в Тивате, на улице Думидран, основанная в 2007 году доктором Сандрой Станишич. В клинике работают два стоматолога, а для сложных вмешательств привлекаются специалисты всех направлений стоматологии. Клиника занимается лечением кариеса и заболеваний зубов, детской и профилактической стоматологией, протезированием (металлокерамические и безметалловые коронки, мосты, керамические виниры, акриловые, бюгельные и гибкие протезы), ортодонтией со съёмными и несъёмными аппаратами, хирургической стоматологией, лечением пародонтоза, имплантацией и эстетической стоматологией (отбеливание, украшения для зубов). Все рентгеновские снимки цифровые; ортопантомограмму и прицельный снимок делают прямо в клинике. Помимо стоматологии, клиника предлагает мезотерапию, филлеры на основе гиалуроновой кислоты, ботокс и лазерную эпиляцию. Стоматологический осмотр и диагностика бесплатны. Для пациентов из-за рубежа клиника организует стоматологический туризм: план лечения по присланному ортопантомограмме, проживание и трансфер из аэропорта.',
	description_en = 'A dental practice in Tivat, on Dumidran street, founded in 2007 by Dr Sandra Stanišić. Two dentists work at the practice, and for more complex procedures it brings in specialists from all fields of dentistry. The practice treats caries and dental disease and provides paediatric and preventive dentistry, prosthodontics (metal-ceramic and metal-free crowns, bridges, ceramic veneers, acrylic, cast-metal and flexible dentures), orthodontics with removable and fixed appliances, oral surgery, periodontal treatment, implantology and cosmetic dentistry (teeth whitening, tooth jewellery). All X-rays are digital, and panoramic and periapical images are taken on site. Besides dentistry, the practice offers mesotherapy, hyaluronic fillers, Botox and laser hair removal. The dental check-up and diagnostics are free of charge. For patients from abroad the practice offers dental tourism: a treatment plan based on a panoramic X-ray sent in advance, accommodation and airport transfers.',
	description_de = 'Zahnarztpraxis in Tivat in der Straße Dumidran, 2007 von Dr. Sandra Stanišić gegründet. In der Praxis arbeiten zwei Zahnärzte; für komplexere Eingriffe zieht die Praxis Fachzahnärzte aller Bereiche hinzu. Behandelt werden Karies und Zahnerkrankungen; angeboten werden Kinder- und Präventivzahnheilkunde, Prothetik (Metallkeramik- und metallfreie Kronen, Brücken, Keramikveneers, Kunststoff-, Modellguss- und flexible Prothesen), Kieferorthopädie mit herausnehmbaren und festen Apparaturen, Oralchirurgie, Parodontitisbehandlung, Implantologie und ästhetische Zahnmedizin (Zahnaufhellung, Zahnschmuck). Alle Röntgenaufnahmen sind digital, Panorama- und Einzelzahnaufnahmen werden direkt in der Praxis angefertigt. Neben der Zahnmedizin bietet die Praxis Mesotherapie, Hyaluronfiller, Botox und Laser-Haarentfernung an. Zahnärztliche Untersuchung und Diagnostik sind kostenlos. Für Patienten aus dem Ausland organisiert die Praxis Dentaltourismus: Behandlungsplan anhand eines vorab gesendeten Panoramaröntgenbilds, Unterkunft und Flughafentransfer.',
	description_tr = 'Tivat''ta Dumidran sokağında bulunan, 2007 yılında Dr. Sandra Stanišić tarafından kurulan diş kliniği. Klinikte iki diş hekimi çalışmakta, daha karmaşık işlemler için diş hekimliğinin tüm alanlarından uzmanlarla çalışılmaktadır. Klinikte çürük ve diş hastalıklarının tedavisi, çocuk ve koruyucu diş hekimliği, protez (metal seramik ve metal desteksiz kronlar, köprüler, seramik lamina, akrilik, iskelet ve esnek protezler), hareketli ve sabit apareylerle ortodonti, ağız cerrahisi, periodontal tedavi, implantoloji ve estetik diş hekimliği (diş beyazlatma, diş takısı) hizmetleri sunulmaktadır. Tüm röntgen çekimleri dijitaldir; panoramik ve periapikal röntgen klinikte çekilir. Diş hekimliğinin yanı sıra klinik mezoterapi, hyaluronik dolgu, botoks ve lazer epilasyon da sunmaktadır. Diş muayenesi ve teşhis ücretsizdir. Yurt dışından gelen hastalar için klinik diş turizmi düzenler: önceden gönderilen panoramik röntgene göre tedavi planı, konaklama ve havalimanı transferi.'
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

-- Часы: шапка и футер всех страниц: «PON - PET 9 - 20 h; subotom i nedjeljom ne radimo».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "closed"}',
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
-- Dr Sandra Stanišić — doktor stomatologije, vlasnica (rođ. Alavanja)
-- Курс мезотерапии — не специальность; AESTHETIC_MEDICINE не ставится.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Sandra Stanišić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Stanišić Sandra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Sandra Alavanja' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Alavanja Sandra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'sandra-stanisic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'sandra-stanisic', 'Sandra Stanišić', 'Сандра Станишић', 'Сандра Станишич', 'Sandra Stanisic', 'Dr',
	'https://dentart.me/wp-content/uploads/portret-sandra-stanisic2.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://dentart.me/wp-content/uploads/portret-sandra-stanisic2.jpg', photo_url) WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Doktor stomatologije (rođ. Alavanja), osnivač ordinacije DentArt. Osnovnu školu i tri razreda matematičke gimnazije završila je u Zadru, a četvrtu godinu u Kaliforniji, u SAD. Diplomirala je na Stomatološkom fakultetu u Beogradu, a stručni staž obavila u Domu zdravlja u Tivtu i u Kliničkom bolničkom centru u Podgorici. Završila je kurs iz implantologije i mezoterapije i posjeduje niz sertifikata sa stručnih kongresa i simpozijuma. Pet godina je radila u Domu zdravlja u Tivtu i godinu dana u privatnoj ordinaciji, a ordinaciju DentArt u Tivtu osnovala je 2007. godine.',
	description_sr_cyrl = 'Доктор стоматологије (рођ. Алавања), оснивач ординације DentArt. Основну школу и три разреда математичке гимназије завршила је у Задру, а четврту годину у Калифорнији, у САД. Дипломирала је на Стоматолошком факултету у Београду, а стручни стаж обавила у Дому здравља у Тивту и у Клиничком болничком центру у Подгорици. Завршила је курс из имплантологије и мезотерапије и посједује низ сертификата са стручних конгреса и симпозијума. Пет година је радила у Дому здравља у Тивту и годину дана у приватној ординацији, а ординацију DentArt у Тивту основала је 2007. године.',
	description_ru = 'Врач-стоматолог (урождённая Алаванья), основательница клиники DentArt. Начальную школу и три класса математической гимназии окончила в Задаре, а последний год — в Калифорнии (США). Окончила стоматологический факультет в Белграде, профессиональную стажировку прошла в Доме здоровья в Тивате и в Клиническом больничном центре в Подгорице. Прошла курсы по имплантологии и мезотерапии, имеет ряд сертификатов профессиональных конгрессов и симпозиумов. Пять лет работала в Доме здоровья в Тивате и год — в частной клинике, а в 2007 году основала клинику DentArt в Тивате.',
	description_en = 'A dentist (née Alavanja) and founder of the DentArt practice. She completed primary school and three years of a mathematics grammar school in Zadar, and her final year in California, USA. She graduated from the School of Dental Medicine in Belgrade and did her professional internship at the Tivat Health Centre and the Clinical Hospital Centre in Podgorica. She has completed courses in implantology and mesotherapy and holds a number of certificates from professional congresses and symposia. She worked for five years at the Tivat Health Centre and for one year in a private practice, and founded the DentArt practice in Tivat in 2007.',
	description_de = 'Zahnärztin (geb. Alavanja) und Gründerin der Praxis DentArt. Grundschule und drei Jahre eines mathematischen Gymnasiums absolvierte sie in Zadar, das letzte Schuljahr in Kalifornien (USA). Sie studierte Zahnmedizin in Belgrad und absolvierte ihr Pflichtpraktikum im Gesundheitszentrum Tivat und im Klinischen Krankenhauszentrum Podgorica. Sie hat Kurse in Implantologie und Mesotherapie abgeschlossen und besitzt zahlreiche Zertifikate von Fachkongressen und Symposien. Fünf Jahre arbeitete sie im Gesundheitszentrum Tivat und ein Jahr in einer Privatpraxis; 2007 gründete sie die Praxis DentArt in Tivat.',
	description_tr = 'Diş hekimi (kızlık soyadı Alavanja), DentArt kliniğinin kurucusu. İlkokulu ve matematik lisesinin ilk üç yılını Zadar''da, son yılını ise ABD''de Kaliforniya''da tamamladı. Belgrad Diş Hekimliği Fakültesinden mezun oldu; stajını Tivat Sağlık Merkezinde ve Podgorica Klinik Hastane Merkezinde yaptı. İmplantoloji ve mezoterapi kurslarını tamamladı, mesleki kongre ve sempozyumlardan çok sayıda sertifikası vardır. Beş yıl Tivat Sağlık Merkezinde, bir yıl özel bir muayenehanede çalıştı ve 2007 yılında Tivat''ta DentArt kliniğini kurdu.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije, osnivač ordinacije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Zorica Popović — opšti stomatolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Zorica Popović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Popović Zorica' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zorica-popovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'zorica-popovic', 'Zorica Popović', 'Зорица Поповић', 'Зорица Попович', 'Zorica Popovic', 'Dr',
	'https://dentart.me/wp-content/uploads/portret-zorica-popovic.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://dentart.me/wp-content/uploads/portret-zorica-popovic.jpg', photo_url) WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = 'Opšti stomatolog. Završila je Opštu gimnaziju u Tivtu, a studije stomatologije na Medicinskom fakultetu u Podgorici 2018. godine. Pripravnički staž obavila je na Stomatološkoj poliklinici i u PZU „Dr Šobić“ u Podgorici. U ordinaciji DentArt radi od 2019. godine.',
	description_sr_cyrl = 'Општи стоматолог. Завршила је Општу гимназију у Тивту, а студије стоматологије на Медицинском факултету у Подгорици 2018. године. Приправнички стаж обавила је на Стоматолошкој поликлиници и у ПЗУ „Др Шобић“ у Подгорици. У ординацији DentArt ради од 2019. године.',
	description_ru = 'Стоматолог общей практики. Окончила общую гимназию в Тивате, а в 2018 году — стоматологическое отделение медицинского факультета в Подгорице. Стажировку прошла в Стоматологической поликлинике и в частном учреждении «Dr Šobić» в Подгорице. В клинике DentArt работает с 2019 года.',
	description_en = 'A general dentist. She finished the general grammar school in Tivat and graduated in dentistry from the Faculty of Medicine in Podgorica in 2018. She did her internship at the Dental Polyclinic and at the private practice “Dr Šobić” in Podgorica. She has worked at DentArt since 2019.',
	description_de = 'Allgemeinzahnärztin. Sie besuchte das allgemeine Gymnasium in Tivat und schloss 2018 das Studium der Zahnmedizin an der Medizinischen Fakultät in Podgorica ab. Ihr Praktikum absolvierte sie an der Zahnmedizinischen Poliklinik und in der Privatpraxis „Dr Šobić“ in Podgorica. Seit 2019 arbeitet sie in der Praxis DentArt.',
	description_tr = 'Genel diş hekimi. Tivat Genel Lisesini bitirdi ve 2018 yılında Podgorica Tıp Fakültesinde diş hekimliği eğitimini tamamladı. Stajını Podgorica''da Diş Polikliniğinde ve özel “Dr Šobić” kurumunda yaptı. 2019 yılından bu yana DentArt kliniğinde çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Opšti stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Milica Lutovac Radonjić — stomatološka sestra, не врач, не заводится.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 4, status = published, clinic_languages = '1', clinic_types = '2', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2 врач(а); created_at сильно раньше запуска = переиспользован
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

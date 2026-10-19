-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Dr Janković — Montenegro Dental Care (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-dr-jankovic-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/ordinacija-dr-jankovic-podgorica.json):
--   * https://www.montenegrodentalcare.com/ — одностраничный PHP-сайт «Montenegro Dental Care» (me; en — /indexen.php, тот же состав).
--     Прочитаны блоки «O nama», «Zubni implanti», «Bolesti zuba», «Dječja i preventivna stomatologija», «Oralna hirurgija»,
--     «Estetska stomatologija», «Dentalni turizam», «Naš tim», «Kontakt». Дат на сайте нет (© не указан).
--   * data/google-places/podgorica/ordinacija-dr-jankovic.json — place_id, координаты, телефон.
-- Адрес: сайт «Vijenac kosovskih junaka 6.» = Google «6 Vijenac Kosovskih Junaka, Podgorica 81000». Телефоны, email, часы — блок
-- «KONTAKT» (+382 69 227 279 = Google). Соцсетей и логотипа-картинки на сайте нет (логотип — текст).
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJlytQ7C7rTRMRDPUgGS8McXQ';
SET @clinic_slug = 'ordinacija-dr-jankovic-podgorica';

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
	'Stomatološka ordinacija Dr Janković',
	'Стоматолошка ординација Др Јанковић',
	'Стоматологический кабинет Dr Janković',
	'Vijenac kosovskih junaka 6',
	'Вијенац косовских јунака 6',
	'',
	'',
	'81000',
	42.44602140,
	19.24359390,
	'+38220218557;+38269227279',
	'dentalcaremontenegro@gmail.com',
	'https://www.montenegrodentalcare.com/',
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
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Др Јанковић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Dr Janković', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vijenac kosovskih junaka 6', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Вијенац косовских јунака 6', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220218557;+38269227279', phone),
	email = IF(email IS NULL OR email = '', 'dentalcaremontenegro@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.montenegrodentalcare.com/', website),
	latitude = COALESCE(latitude, 42.44602140),
	longitude = COALESCE(longitude, 19.24359390)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Dr Janković“ (Montenegro Dental Care) nalazi se u Podgorici, na adresi Vijenac kosovskih junaka 6. Ordinacija prati savremene tokove svjetske stomatologije i predstavlja porodičnu priču koja traje više od decenije; svakom pacijentu nudi individualni pristup. U ordinaciji rade dr Petar Janković, doktor stomatologije, i dr Marija Janković, specijalista oralne hirurgije – implantolog. Ordinacija pruža liječenje kanala korijena (apex-locator, rendgen Gendex), kompozitne i glasjonomerne ispune, inleje, zalivanje fisura i fluorizaciju, zbrinjavanje trauma zuba kod djece, štitnike za zube, oralnu hirurgiju (komplikovano i hirurško vađenje zuba, apikotomija, cistektomija, frenektomija, vađenje impaktiranih zuba, preprotetska hirurgija), zubne implante, kao i estetsku stomatologiju: izbjeljivanje zuba, kompozitne i keramičke vinire, luminire, bezmetalne krunice i mostove, profesionalno čišćenje zuba i nakit za zube. Za pacijente iz inostranstva ordinacija planira terapiju na osnovu ortopana ili CBCT snimka.',
	description_sr_cyrl = 'Стоматолошка ординација „Др Јанковић“ (Montenegro Dental Care) налази се у Подгорици, на адреси Вијенац косовских јунака 6. Ординација прати савремене токове свјетске стоматологије и представља породичну причу која траје више од деценије; сваком пацијенту нуди индивидуални приступ. У ординацији раде др Петар Јанковић, доктор стоматологије, и др Марија Јанковић, специјалиста оралне хирургије – имплантолог. Ординација пружа лијечење канала коријена (апеx-лоцатор, рендген Gendex), композитне и гласјономерне испуне, инлеје, заливање фисура и флуоризацију, збрињавање траума зуба код дјеце, штитнике за зубе, оралну хирургију (компликовано и хируршко вађење зуба, апикотомија, цистектомија, френектомија, вађење импактираних зуба, препротетска хирургија), зубне импланте, као и естетску стоматологију: избјељивање зуба, композитне и керамичке винире, луминире, безметалне крунице и мостове, професионално чишћење зуба и накит за зубе. За пацијенте из иностранства ординација планира терапију на основу ортопана или CBCT снимка.',
	description_ru = 'Стоматологический кабинет «Dr Janković» (Montenegro Dental Care) находится в Подгорице, по адресу Виенац косовских юнака, 6. Кабинет следит за современными тенденциями мировой стоматологии и представляет собой семейную историю длиной более десяти лет; к каждому пациенту — индивидуальный подход. Принимают Петар Янкович, врач-стоматолог, и Мария Янкович, специалист по хирургической стоматологии и имплантолог. Кабинет проводит лечение корневых каналов (апекслокатор, рентген Gendex), композитные и стеклоиономерные пломбы, вкладки, герметизацию фиссур и фторирование, лечение травм зубов у детей, изготовление защитных кап, хирургическую стоматологию (сложное и хирургическое удаление зубов, резекция верхушки корня, цистэктомия, френэктомия, удаление ретинированных зубов, предпротезная хирургия), имплантацию, а также эстетическую стоматологию: отбеливание, композитные и керамические виниры, люминиры, безметалловые коронки и мосты, профессиональную чистку зубов и украшения для зубов. Для иностранных пациентов план лечения составляют по ортопантомограмме или снимку CBCT.',
	description_en = 'Dr Janković (Montenegro Dental Care) is a dental practice in Podgorica, at Vijenac kosovskih junaka 6. The practice follows current trends in world dentistry and is a family story spanning more than a decade, with an individual approach to every patient. The dentists are Dr Petar Janković, doctor of dental medicine, and Dr Marija Janković, an oral surgery specialist and implantologist. Services include root canal treatment (apex locator, Gendex X-ray), composite and glass ionomer fillings, inlays, fissure sealing and fluoride treatment, care of dental trauma in children, mouthguards, oral surgery (complicated and surgical extractions, apicoectomy, cystectomy, frenectomy, removal of impacted teeth, pre-prosthetic surgery), dental implants and cosmetic dentistry: teeth whitening, composite and ceramic veneers, Lumineers, metal-free crowns and bridges, professional teeth cleaning and tooth jewellery. For patients from abroad the practice plans treatment from a panoramic or CBCT image.',
	description_de = 'Dr Janković (Montenegro Dental Care) ist eine Zahnarztpraxis in Podgorica, Vijenac kosovskih junaka 6. Die Praxis folgt den aktuellen Entwicklungen der Zahnmedizin und ist eine Familiengeschichte, die seit mehr als zehn Jahren andauert; jeder Patient wird individuell betreut. Es behandeln Dr. Petar Janković, Zahnarzt, und Dr. Marija Janković, Fachärztin für Oralchirurgie und Implantologin. Angeboten werden Wurzelkanalbehandlung (Apex-Lokator, Gendex-Röntgen), Komposit- und Glasionomerfüllungen, Inlays, Fissurenversiegelung und Fluoridierung, Versorgung von Zahnverletzungen bei Kindern, Zahnschutz, Oralchirurgie (komplizierte und chirurgische Zahnentfernung, Wurzelspitzenresektion, Zystektomie, Frenektomie, Entfernung retinierter Zähne, präprothetische Chirurgie), Zahnimplantate sowie ästhetische Zahnheilkunde: Zahnaufhellung, Komposit- und Keramikveneers, Lumineers, metallfreie Kronen und Brücken, professionelle Zahnreinigung und Zahnschmuck. Für Patienten aus dem Ausland plant die Praxis die Behandlung anhand einer Panoramaaufnahme oder eines DVT (CBCT).',
	description_tr = 'Dr Janković (Montenegro Dental Care), Podgorica''da Vijenac kosovskih junaka 6 adresinde bulunan bir diş muayenehanesidir. Muayenehane dünya diş hekimliğindeki güncel gelişmeleri takip eder ve on yılı aşkın bir aile hikâyesidir; her hastaya bireysel yaklaşım sunar. Diş hekimi Dr. Petar Janković ile ağız cerrahisi uzmanı ve implantolog Dr. Marija Janković hasta kabul eder. Kanal tedavisi (apeks bulucu, Gendex röntgen), kompozit ve cam iyonomer dolgular, inleyler, fissür örtücü ve florlama, çocuklarda diş travmalarının tedavisi, diş koruyucular, ağız cerrahisi (komplike ve cerrahi diş çekimi, apikal rezeksiyon, kistektomi, frenektomi, gömülü diş çekimi, protez öncesi cerrahi), diş implantları ve estetik diş hekimliği sunulur: diş beyazlatma, kompozit ve seramik lamina, Lumineers, metalsiz kron ve köprüler, profesyonel diş temizliği ve diş takısı. Yurt dışından gelen hastalar için tedavi, panoramik film veya CBCT görüntüsüne göre planlanır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (EN-версия /indexen.php — не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: блок «KONTAKT»: «Radno vrijeme: Ponedjeljak-Petak: 09:00-12:30 i 17:00-20:30, Subota: 09:00-14:00» (воскресенье не указано → выходной).
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "12:30"}, {"start": "17:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "12:30"}, {"start": "17:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "12:30"}, {"start": "17:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "12:30"}, {"start": "17:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "12:30"}, {"start": "17:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "14:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (2)
-- Состав — блок «NAŠ TIM»: dr Petar Janković — «Doktor stomatologije, Specijalizant stomatološke protetike» (специализант, специальность
-- протетики не ставим, только 78); dr Marija Janković — «Doktor stomatologije, Specijalista oralne hirurgije – implantolog» (78 + 74);
-- Slađana Golović — «Stomatološka sestra - asistent» (не врач, не заводится). В БД обоих нет (Janković — только nada/aleksandra/vjera/bosko,
-- другие люди; поиск 2026-10-09). Фото — assets/img/doctors/tim1.jpg, tim2.jpg (проверено: 200 image/jpeg). Биографий нет.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Petar Janković — Doktor stomatologije; specijalizant stomatološke protetike
-- ───────────────────────────────────────────────────────────────
-- «Specijalizant stomatološke protetike» — специализация не завершена; в каталоге специальностей протетики нет → только 78.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Petar Janković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Janković Petar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'petar-jankovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'petar-jankovic', 'Petar Janković', 'Петар Јанковић', 'Петар Янкович', 'Petar Jankovic', 'dr',
	'https://www.montenegrodentalcare.com/assets/img/doctors/tim1.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije; specijalizant stomatološke protetike')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Marija Janković — Specijalista oralne hirurgije – implantolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marija Janković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Janković Marija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marija-jankovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'marija-jankovic', 'Marija Janković', 'Марија Јанковић', 'Мария Янкович', 'Marija Jankovic', 'dr',
	'https://www.montenegrodentalcare.com/assets/img/doctors/tim2.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije – implantolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 2, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2 врач(а/ей): petar-jankovic, marija-jankovic.
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

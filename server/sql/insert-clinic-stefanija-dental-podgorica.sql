-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Stefanija Dental (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stefanija-dental-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/stefanija-dental-podgorica.json):
--   * https://stefanijadental.me/ — WordPress (me + en), wp-json /pages: 11 me-страниц изменены 2026-02-09…2026-03-02. Прочитаны
--     Početna, O nama, Dr Stefanija, Kontakt и 7 страниц услуг (opšta stomatologija, protetika, implantologija, oralna hirurgija,
--     parodontologija, RTG dijagnostika, estetska stomatologija). Цен нет ни на одной странице.
--   * data/google-places/podgorica/stomatoloska-ordinacija-stefanija-dental.json — place_id, координаты, телефон.
-- Адрес: сайт «Central Point, Marka Radovića 95, Podgorica» = Google «Central Point, 95 Marka Radovića». Телефон +382 67 009 072 —
-- сайт = Google. Email на сайте нет; Instagram — ссылка в блоке контактов.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJGfZDbdTrTRMRgSNa8wqx50s';
SET @clinic_slug = 'stefanija-dental-podgorica';

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
	'Stomatološka ordinacija Stefanija Dental',
	'Стоматолошка ординација Stefanija Dental',
	'Стоматологический кабинет Stefanija Dental',
	'Marka Radovića 95 (Central Point)',
	'Марка Радовића 95 (Central Point)',
	'',
	'',
	'81000',
	42.43800480,
	19.23925610,
	'+38267009072',
	'',
	'https://stefanijadental.me/',
	'',
	'https://www.instagram.com/stefanijadental/',
	'',
	'',
	'',
	'https://stefanijadental.me/wp-content/uploads/2025/11/stefanija_dental_Podgorica-removebg-preview-1.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка ординација Stefanija Dental', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Stefanija Dental', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Marka Radovića 95 (Central Point)', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Марка Радовића 95 (Central Point)', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267009072', phone),
	website = IF(website IS NULL OR website = '', 'https://stefanijadental.me/', website),
	instagram = IF(instagram IS NULL OR instagram = '', 'https://www.instagram.com/stefanijadental/', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://stefanijadental.me/wp-content/uploads/2025/11/stefanija_dental_Podgorica-removebg-preview-1.png', logo_url),
	latitude = COALESCE(latitude, 42.43800480),
	longitude = COALESCE(longitude, 19.23925610)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija „Stefanija Dental“ nalazi se u Podgorici, u naselju Central Point, na adresi Marka Radovića 95. Specijalizovana je za estetsku stomatologiju, oralnu hirurgiju i kompletnu stomatološku njegu i prepoznatljiva je prvenstveno po potpunim transformacijama osmijeha. Ordinaciju je osnovala dr Stefanija Pantović, specijalista oralne hirurgije. Prvi stomatološki pregled obuhvata klinički pregled, anamnezu, RTG dijagnostiku, fotografisanje i 3D skeniranje zuba; ordinacija posjeduje digitalni rendgen (retroalveolarni i ortopan snimci) i 3D intraoralni digitalni skener. U ponudi su uklanjanje zubnog kamenca i pjeskarenje, kompozitne plombe, mašinska endodoncija i nadogradnja zuba, bezmetalne i metalo-keramičke krunice, keramičke ljuskice (prep i non-prep), keramičke plombe, mobilne proteze i proteze na implantatima, ugradnja implantata, oralna hirurgija (hirurško vađenje zuba, vađenje impaktiranih zuba, apikotomija, gingivektomija, režanj operacije, augmentacija kosti i sinus lift), parodontologija sa korekcijom gingivalnog osmijeha (gummy smile), kao i izbjeljivanje zuba Flash sistemom u ordinaciji, kućno izbjeljivanje individualnim folijama i izbjeljivanje avitalnog zuba.',
	description_sr_cyrl = 'Стоматолошка ординација „Stefanija Dental“ налази се у Подгорици, у насељу Central Point, на адреси Марка Радовића 95. Специјализована је за естетску стоматологију, оралну хирургију и комплетну стоматолошку његу и препознатљива је првенствено по потпуним трансформацијама осмијеха. Ординацију је основала др Стефанија Пантовић, специјалиста оралне хирургије. Први стоматолошки преглед обухвата клинички преглед, анамнезу, РТГ дијагностику, фотографисање и 3D скенирање зуба; ординација посједује дигитални рендген (ретроалвеоларни и ортопан снимци) и 3D интраорални дигитални скенер. У понуди су уклањање зубног каменца и пјескарење, композитне пломбе, машинска ендодонција и надоградња зуба, безметалне и метало-керамичке крунице, керамичке љускице (prep и non-prep), керамичке пломбе, мобилне протезе и протезе на имплантатима, уградња имплантата, орална хирургија (хируршко вађење зуба, вађење импактираних зуба, апикотомија, гингивектомија, режањ операције, аугментација кости и синус лифт), пародонтологија са корекцијом гингивалног осмијеха (gummy smile), као и избјељивање зуба Flash системом у ординацији, кућно избјељивање индивидуалним фолијама и избјељивање авиталног зуба.',
	description_ru = 'Стоматологический кабинет «Stefanija Dental» находится в Подгорице, в районе Central Point, по адресу Марка Радовича, 95. Кабинет специализируется на эстетической стоматологии, хирургической стоматологии и комплексном стоматологическом лечении и известен прежде всего полным преображением улыбки. Основательница — Стефания Пантович, специалист по хирургической стоматологии. Первичный осмотр включает клинический осмотр, анамнез, рентгенодиагностику, фотографирование и 3D-сканирование зубов; в кабинете есть цифровой рентген (прицельные снимки и ортопантомограмма) и 3D-интраоральный сканер. Кабинет предлагает удаление зубного камня и чистку Air-Flow, композитные пломбы, машинное эндодонтическое лечение и восстановление зубов, безметалловые и металлокерамические коронки, керамические виниры (с препарированием и без), керамические вкладки, съёмные протезы и протезы на имплантах, имплантацию, хирургическую стоматологию (хирургическое удаление зубов, удаление ретинированных зубов, резекция верхушки корня, гингивэктомия, лоскутные операции, наращивание кости и синус-лифтинг), пародонтологию, в том числе коррекцию «десневой улыбки», а также отбеливание зубов системой Flash в кабинете, домашнее отбеливание с индивидуальными капами и отбеливание депульпированного зуба.',
	description_en = 'Stefanija Dental is a dental practice in Podgorica, in the Central Point neighbourhood at Marka Radovića 95. It specialises in cosmetic dentistry, oral surgery and comprehensive dental care and is known above all for complete smile makeovers. The practice was founded by Dr Stefanija Pantović, an oral surgery specialist. The first dental examination includes a clinical examination, medical history, X-ray diagnostics, photographs and a 3D scan of the teeth; the practice has digital X-ray (periapical and panoramic images) and a 3D intraoral digital scanner. Services include scaling and air polishing, composite fillings, rotary endodontics and tooth build-ups, metal-free and metal-ceramic crowns, ceramic veneers (prep and no-prep), ceramic inlays, removable dentures and implant-supported dentures, dental implants, oral surgery (surgical and impacted tooth extraction, apicoectomy, gingivectomy, flap surgery, bone augmentation and sinus lift), periodontology including gummy smile correction, as well as in-office teeth whitening with the Flash system, home whitening with custom trays and whitening of non-vital teeth.',
	description_de = 'Stefanija Dental ist eine Zahnarztpraxis in Podgorica, im Viertel Central Point, Marka Radovića 95. Die Praxis ist auf ästhetische Zahnheilkunde, Oralchirurgie und umfassende zahnärztliche Versorgung spezialisiert und vor allem für vollständige Lächeln-Transformationen bekannt. Gegründet wurde sie von Dr. Stefanija Pantović, Fachärztin für Oralchirurgie. Die erste Untersuchung umfasst klinische Untersuchung, Anamnese, Röntgendiagnostik, Fotos und einen 3D-Scan der Zähne; die Praxis verfügt über digitales Röntgen (Einzelzahn- und Panoramaaufnahmen) und einen 3D-Intraoralscanner. Angeboten werden Zahnsteinentfernung und Pulverstrahlreinigung, Kompositfüllungen, maschinelle Wurzelkanalbehandlung und Zahnaufbauten, metallfreie und Metallkeramikkronen, Keramikveneers (mit und ohne Präparation), Keramikinlays, herausnehmbare und implantatgetragene Prothesen, Zahnimplantate, Oralchirurgie (chirurgische Zahnentfernung, Entfernung retinierter Zähne, Wurzelspitzenresektion, Gingivektomie, Lappenoperationen, Knochenaufbau und Sinuslift), Parodontologie einschließlich Korrektur des Gummy Smile sowie Zahnaufhellung in der Praxis mit dem Flash-System, Home-Bleaching mit individuellen Schienen und Aufhellung devitaler Zähne.',
	description_tr = 'Stefanija Dental, Podgorica''da Central Point semtinde, Marka Radovića 95 adresinde bulunan bir diş muayenehanesidir. Estetik diş hekimliği, ağız cerrahisi ve kapsamlı diş bakımında uzmanlaşmıştır ve özellikle gülüşün tamamen yenilenmesiyle tanınır. Muayenehaneyi ağız cerrahisi uzmanı Dr. Stefanija Pantović kurmuştur. İlk diş muayenesi klinik muayene, anamnez, röntgen tanısı, fotoğraf çekimi ve dişlerin 3D taramasını kapsar; muayenehanede dijital röntgen (periapikal ve panoramik film) ve 3D ağız içi dijital tarayıcı bulunur. Diş taşı temizliği ve kumlama, kompozit dolgu, döner aletlerle kanal tedavisi ve diş yapılandırması, metalsiz ve metal-seramik kronlar, seramik laminalar (preparasyonlu ve preparasyonsuz), seramik inleyler, hareketli protezler ve implant üstü protezler, implant uygulaması, ağız cerrahisi (cerrahi diş çekimi, gömülü diş çekimi, apikal rezeksiyon, gingivektomi, flep operasyonları, kemik ogmentasyonu ve sinüs lifting), diş eti gülüşü düzeltmesi dahil periodontoloji ile muayenehanede Flash sistemiyle diş beyazlatma, kişiye özel plaklarla evde beyazlatma ve devital diş beyazlatma sunulur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (EN-версия сайта — не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: /kontakt/: «Radno vrijeme pon - pet : 10:00h –18:00h, sub - ned : ne radimo».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "18:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "18:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (1)
-- Врач один — /dr-stefanija/ («O dr Stefaniji»): «Dr Stefanija Pantović postala je specijalista oralne hirurgije sa samo 29 godina … odlučila je
-- da osnuje sopstvenu stomatološku ordinaciju u Podgorici». Других имён на сайте нет.
-- В БД уже есть: stefanija-pantovic (специальность 78, клиника sotir-dental-centar-podgorica) — та же специальность, привязка (решение юзера:
-- «врач уже есть в БД и специальность примерно совпадает — привязка»). Добавляется специальность 74 = ORAL_SURGERY (сайт: «specijalista oralne
-- hirurgije»). Связь с Sotir dental centar НЕ трогаем (чужая клиника) — см. вопрос в записи импорта.
-- Фото — внешний URL сайта (проверено: 200 image/png).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Stefanija Pantović — Specijalista oralne hirurgije; osnivač ordinacije
-- ───────────────────────────────────────────────────────────────
-- Существующая карточка id 471 (локально): name_ru/name_en/photo/био пустые — дозаполняются; заполненное не перезаписывается.
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Stefanija Pantović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Pantović Stefanija' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'stefanija-pantovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'stefanija-pantovic', 'Stefanija Pantović', 'Стефанија Пантовић', 'Стефания Пантович', 'Stefanija Pantovic', 'dr',
	'https://stefanijadental.me/wp-content/uploads/2026/01/938246EF-6178-45F6-ACD1-DD80C515C7B8__2_-removebg-preview_upscaled-819x1024.png', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Врач уже в БД: дозаполняем только пустые поля, заполненное не трогаем.
UPDATE doctors SET
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стефанија Пантовић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стефания Пантович', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Stefanija Pantovic', name_en),
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://stefanijadental.me/wp-content/uploads/2026/01/938246EF-6178-45F6-ACD1-DD80C515C7B8__2_-removebg-preview_upscaled-819x1024.png', photo_url),
	professional_title = IF(professional_title IS NULL OR professional_title = '', 'dr', professional_title)
WHERE id = @doctor_id;

-- Биография — только если у карточки её ещё нет.
UPDATE doctors SET
	description_sr = 'Specijalista oralne hirurgije — specijalizaciju je završila sa 29 godina. Nakon višegodišnjeg rada u privatnoj stomatološkoj praksi osnovala je sopstvenu ordinaciju Stefanija Dental u Podgorici. Kontinuirano se usavršava u zemlji i regionu, kao i na međunarodnim simpozijumima i edukacijama u Švajcarskoj i Italiji. Posebno je usmjerena na implantologiju, estetsku stomatologiju, protetsko-hirurške tretmane i rekonstrukciju osmijeha. Stekla je zvanje iTOP instruktora i zalaže se za digitalizaciju u svim granama stomatologije.',
	description_sr_cyrl = 'Специјалиста оралне хирургије — специјализацију је завршила са 29 година. Након вишегодишњег рада у приватној стоматолошкој пракси основала је сопствену ординацију Stefanija Dental у Подгорици. Континуирано се усавршава у земљи и региону, као и на међународним симпозијумима и едукацијама у Швајцарској и Италији. Посебно је усмјерена на имплантологију, естетску стоматологију, протетско-хируршке третмане и реконструкцију осмијеха. Стекла је звање iTOP инструктора и залаже се за дигитализацију у свим гранама стоматологије.',
	description_ru = 'Специалист по хирургической стоматологии — специализацию получила в 29 лет. После нескольких лет работы в частной стоматологической практике основала собственный кабинет Stefanija Dental в Подгорице. Постоянно повышает квалификацию в Черногории и регионе, на международных симпозиумах и курсах в Швейцарии и Италии. Основные направления — имплантология, эстетическая стоматология, ортопедо-хирургическое лечение и реконструкция улыбки. Имеет звание инструктора iTOP и выступает за цифровизацию во всех областях стоматологии.',
	description_en = 'Oral surgery specialist, having completed her specialisation at the age of 29. After several years in private dental practice she founded her own practice, Stefanija Dental, in Podgorica. She continuously trains in Montenegro and the region and at international symposia and courses in Switzerland and Italy. Her main interests are implantology, cosmetic dentistry, prosthetic-surgical treatment and smile reconstruction. She is a certified iTOP instructor and an advocate of digital workflows in all fields of dentistry.',
	description_de = 'Fachärztin für Oralchirurgie; die Facharztausbildung schloss sie mit 29 Jahren ab. Nach mehreren Jahren in einer privaten Zahnarztpraxis gründete sie in Podgorica ihre eigene Praxis Stefanija Dental. Sie bildet sich laufend im In- und Ausland fort, unter anderem bei internationalen Symposien und Kursen in der Schweiz und in Italien. Schwerpunkte sind Implantologie, ästhetische Zahnheilkunde, prothetisch-chirurgische Behandlungen und Rekonstruktion des Lächelns. Sie ist zertifizierte iTOP-Instruktorin und setzt sich für die Digitalisierung in allen Bereichen der Zahnmedizin ein.',
	description_tr = 'Ağız cerrahisi uzmanı; uzmanlığını 29 yaşında tamamladı. Özel diş hekimliği pratiğinde uzun yıllar çalıştıktan sonra Podgorica''da kendi muayenehanesi Stefanija Dental''ı kurdu. Karadağ''da, bölgede ve İsviçre ile İtalya''daki uluslararası sempozyum ve eğitimlerde sürekli kendini geliştirir. Başlıca ilgi alanları implantoloji, estetik diş hekimliği, protetik-cerrahi tedaviler ve gülüş rekonstrüksiyonudur. iTOP eğitmeni unvanına sahiptir ve diş hekimliğinin tüm alanlarında dijitalleşmeyi savunur.'
WHERE id = @doctor_id AND (description_sr IS NULL OR description_sr = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije; osnivač ordinacije')
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

-- Ожидается 1 врач(а/ей): stefanija-pantovic.
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

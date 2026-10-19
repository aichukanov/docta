-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Dental & Estetic Centar (Podgorica, Zabjelo) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-estetic-centar-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/dental-estetic-centar-podgorica.json):
--   * https://www.dentalesteticcentar.com/ — статический HTML (me + en/de/fr/it/ru/tr/uk/zh), Last-Modified 2026-10-06…09.
--     Прочитаны: главная, /stomatolog-podgorica.html, /o-nama.html, /kontakt.html, /dentalni-turizam.html, 4 SEO-страницы
--     (zubni-implanti-, viniri-, hollywood-smile-, estetska-stomatologija-podgorica), /usluge/stomatoloske-usluge.html и все её
--     подстраницы (15 услуг + 4 вида протезов), /usluge/estetika-lica.html и 8 её подстраниц, блог (3 записи). /galerija.html — фото.
--   * data/google-places/podgorica/stomatoloska-ordinacija-dental-estetic-centar.json — place_id, координаты.
-- Адрес: сайт «ul. Jerevanska br. 12, Zabjelo, Podgorica» = Google «12 Jerevanska». Телефон, email, часы — /kontakt/. Facebook/Instagram —
-- ссылки в js/layout.js (шапка/подвал сайта). Логотип — баннер-картинка из шапки.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ2UUYSb3rTRMRCFwiFhxaskc';
SET @clinic_slug = 'dental-estetic-centar-podgorica';

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
	'Dental & Estetic Centar',
	'Dental & Estetic Centar',
	'Dental & Estetic Centar',
	'Jerevanska 12, Zabjelo',
	'Јереванска 12, Забјело',
	'',
	'',
	'81000',
	42.42226070,
	19.25137590,
	'+38268602648',
	'pzudentalesteticcentar@gmail.com',
	'https://www.dentalesteticcentar.com/',
	'https://www.facebook.com/profile.php?id=100054388485792',
	'https://www.instagram.com/dental_estetic_centar/',
	'',
	'',
	'',
	'https://www.dentalesteticcentar.com/images/site/stomatolog-dental-estetc-centar.webp',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Dental & Estetic Centar', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Dental & Estetic Centar', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Jerevanska 12, Zabjelo', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Јереванска 12, Забјело', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38268602648', phone),
	email = IF(email IS NULL OR email = '', 'pzudentalesteticcentar@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.dentalesteticcentar.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'https://www.facebook.com/profile.php?id=100054388485792', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', 'https://www.instagram.com/dental_estetic_centar/', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.dentalesteticcentar.com/images/site/stomatolog-dental-estetc-centar.webp', logo_url),
	latitude = COALESCE(latitude, 42.42226070),
	longitude = COALESCE(longitude, 19.25137590)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'PZU „Dental & Estetic Centar“ je centar za savremenu stomatologiju i estetiku lica i vrata u Podgorici, na Zabjelu (Jerevanska 12), u poslovnom prostoru stambene zgrade sa besplatnim parkingom. Doktori i tehničari sticali su znanje i iskustvo u Njemačkoj; ordinacija koristi kvalitetne materijale i savremenu tehnologiju za skraćenje izrade protetskih radova, a cjelokupnu rekonstrukciju lica i vilica moguće je uraditi za 7 do 10 dana. Prvi pregled je besplatan. U ponudi su izbjeljivanje zuba, sve vrste plombi (kompozitne, amalgamske, keramičke, zlatne), inleji i onleji, metalkeramičke i bezmetalne (keramičke i cirkonijumske) krunice, viniri, koncepti Hollywood smile i Natural smile, kompletna restauracija i anti-aging stomatologija, „zubi za 24h“, detox usne duplje (temeljno čišćenje), korekcija gingivalnog osmijeha (gummy smile), radovi na implantima i proteze (akrilatne, fleksibilne, skeletirane i na teleskop krunicama). Estetika lica obuhvata hijaluronske filere, botox, PRP, COG niti, mezoniti, hemijski piling, mezoterapiju i Profhilo. Ordinacija ima razvijen dentalni turizam: pacijentima iz inostranstva plan terapije i cijenu priprema na osnovu OPT snimka i pomaže oko smještaja i prevoza.',
	description_sr_cyrl = 'ПЗУ „Dental & Estetic Centar“ је центар за савремену стоматологију и естетику лица и врата у Подгорици, на Забјелу (Јереванска 12), у пословном простору стамбене зграде са бесплатним паркингом. Доктори и техничари стицали су знање и искуство у Њемачкој; ординација користи квалитетне материјале и савремену технологију за скраћење израде протетских радова, а цјелокупну реконструкцију лица и вилица могуће је урадити за 7 до 10 дана. Први преглед је бесплатан. У понуди су избјељивање зуба, све врсте пломби (композитне, амалгамске, керамичке, златне), инлеји и онлеји, металкерамичке и безметалне (керамичке и цирконијумске) крунице, винири, концепти Hollywood smile и Natural smile, комплетна рестаурација и анти-агинг стоматологија, „зуби за 24h“, детокс усне дупље (темељно чишћење), корекција гингивалног осмијеха (gummy smile), радови на имплантима и протезе (акрилатне, флексибилне, скелетиране и на телескоп круницама). Естетика лица обухвата хијалуронске филере, botox, PRP, COG нити, мезонити, хемијски пилинг, мезотерапију и Profhilo. Ординација има развијен дентални туризам: пацијентима из иностранства план терапије и цијену припрема на основу OPT снимка и помаже око смјештаја и превоза.',
	description_ru = 'PZU «Dental & Estetic Centar» — центр современной стоматологии и эстетики лица и шеи в Подгорице, в районе Забело (Ереванска, 12), в помещении жилого дома с бесплатной парковкой. Врачи и техники получали знания и опыт в Германии; кабинет использует качественные материалы и современные технологии, чтобы сократить сроки изготовления протезов, а полную реконструкцию лица и челюстей можно провести за 7–10 дней. Первичный осмотр бесплатный. Кабинет предлагает отбеливание зубов, все виды пломб (композитные, амальгамовые, керамические, золотые), вкладки инлей и онлей, металлокерамические и безметалловые (керамические и циркониевые) коронки, виниры, концепции Hollywood smile и Natural smile, полную реставрацию и anti-age стоматологию, «зубы за 24 часа», детокс полости рта (тщательную профессиональную чистку), коррекцию «десневой улыбки», работы на имплантах и протезы (акриловые, гибкие, бюгельные и на телескопических коронках). Эстетика лица включает филлеры гиалуроновой кислоты, ботокс, PRP, нити COG, мезонити, химический пилинг, мезотерапию и Profhilo. В кабинете развит стоматологический туризм: иностранным пациентам план лечения и стоимость готовят по ортопантомограмме и помогают с жильём и трансфером.',
	description_en = 'PZU Dental & Estetic Centar is a centre for modern dentistry and facial and neck aesthetics in Podgorica, in Zabjelo (Jerevanska 12), located in a residential building with free parking. Its doctors and technicians gained their knowledge and experience in Germany; the practice uses quality materials and modern technology to shorten the time needed for prosthetic work, and a complete reconstruction of the face and jaws can be done in 7 to 10 days. The first examination is free. Services include teeth whitening, all types of fillings (composite, amalgam, ceramic, gold), inlays and onlays, metal-ceramic and metal-free (ceramic and zirconia) crowns, veneers, Hollywood smile and Natural smile concepts, complete restoration and anti-ageing dentistry, “teeth in 24 hours”, an oral detox (thorough professional cleaning), gummy smile correction, implant work and dentures (acrylic, flexible, cast partial and telescopic). Facial aesthetics include hyaluronic acid fillers, Botox, PRP, COG threads, mesothreads, chemical peels, mesotherapy and Profhilo. The practice has an established dental tourism service: for patients from abroad it prepares a treatment plan and quote from a panoramic X-ray (OPT) and helps with accommodation and transfers.',
	description_de = 'PZU Dental & Estetic Centar ist ein Zentrum für moderne Zahnmedizin sowie Gesichts- und Halsästhetik in Podgorica, im Stadtteil Zabjelo (Jerevanska 12), in einem Wohngebäude mit kostenlosen Parkplätzen. Die Ärzte und Techniker haben ihr Wissen und ihre Erfahrung in Deutschland erworben; die Praxis nutzt hochwertige Materialien und moderne Technik, um die Herstellung von Zahnersatz zu verkürzen, und eine komplette Rekonstruktion von Gesicht und Kiefer ist in 7 bis 10 Tagen möglich. Die erste Untersuchung ist kostenlos. Angeboten werden Zahnaufhellung, alle Arten von Füllungen (Komposit, Amalgam, Keramik, Gold), Inlays und Onlays, Metallkeramik- und metallfreie (Keramik- und Zirkon-)Kronen, Veneers, die Konzepte Hollywood Smile und Natural Smile, Komplettrestauration und Anti-Aging-Zahnmedizin, „Zähne in 24 Stunden“, eine Mundhöhlen-Detox-Behandlung (gründliche professionelle Reinigung), Korrektur des Gummy Smile, Implantatarbeiten und Prothesen (Acryl-, flexible, Modellguss- und Teleskopprothesen). Die Gesichtsästhetik umfasst Hyaluronsäure-Filler, Botox, PRP, COG-Fäden, Mesofäden, chemisches Peeling, Mesotherapie und Profhilo. Die Praxis bietet Dentaltourismus: Für Patienten aus dem Ausland erstellt sie Behandlungsplan und Kostenvoranschlag anhand einer Panoramaaufnahme (OPT) und hilft bei Unterkunft und Transfer.',
	description_tr = 'PZU Dental & Estetic Centar, Podgorica''nın Zabjelo semtinde (Jerevanska 12), ücretsiz otoparkı olan bir konut binasında yer alan modern diş hekimliği ile yüz ve boyun estetiği merkezidir. Doktorlar ve teknisyenler bilgi ve deneyimlerini Almanya''da edinmiştir; muayenehane protez yapım süresini kısaltmak için kaliteli malzeme ve modern teknoloji kullanır ve yüz ile çenelerin tam rekonstrüksiyonu 7–10 günde yapılabilir. İlk muayene ücretsizdir. Diş beyazlatma, her tür dolgu (kompozit, amalgam, seramik, altın), inley ve onleyler, metal-seramik ve metalsiz (seramik ve zirkonyum) kronlar, lamina, Hollywood smile ve Natural smile konseptleri, tam restorasyon ve anti-aging diş hekimliği, «24 saatte diş», ağız detoksu (kapsamlı profesyonel temizlik), diş eti gülüşü düzeltmesi, implant üstü çalışmalar ve protezler (akrilik, esnek, iskelet ve teleskop kronlu) sunulur. Yüz estetiği hiyalüronik asit dolguları, Botox, PRP, COG ipleri, mezo ipler, kimyasal peeling, mezoterapi ve Profhilo''yu kapsar. Muayenehanede gelişmiş bir diş turizmi hizmeti vardır: yurt dışından gelen hastalar için panoramik filme (OPT) göre tedavi planı ve fiyat hazırlanır, konaklama ve transferde yardımcı olunur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Языковые версии сайта (en/de/fr/it/ru/tr/uk/zh) и «Ako tražite … stomatologa … na engleskom, njemačkom, ruskom ili drugom jeziku, otvorite jezične verzije sajta» — про версии сайта, не заявление о приёме на этих языках → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: /kontakt.html: «Radno vrijeme Pon - Pet 9.00 - 13.00 i 17.00 - 20.00» (то же на /stomatolog-podgorica.html); выходные не указаны → закрыто.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "17:00", "end": "20:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- Врачей по именам на сайте нет (главная, o-nama, kontakt, все страницы услуг; /tim.html — 404). «Doktori i tehničari su sticali znanje i iskustvo u
-- Njemačkoj» — без имён. Привязывать некого.
-- ═══════════════════════════════════════════════════════════════

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

-- Врачей в этом импорте нет — ожидается 0 строк.
SELECT COUNT(*) AS doctors FROM doctor_clinics WHERE clinic_id = @clinic_id;

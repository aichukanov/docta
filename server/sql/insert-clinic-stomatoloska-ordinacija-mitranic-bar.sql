-- ═══════════════════════════════════════════════════════════════════════════
-- Opšta stomatološka ordinacija Mitranić (Bar) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-ordinacija-mitranic-bar.sql
--
-- Источники (curl с браузерным UA — без него 406, 2026-10-09; запись импорта — data/clinic-imports/stomatoloska-ordinacija-mitranic-bar.json):
--   * https://mitranicdental.com/ — WordPress (BeTheme). Список страниц — wp-json/wp/v2/pages (content в REST пустой — конструктор),
--     текст — из HTML: главная, /o-nama/, /kontakt/ и 16 страниц меню «Usluge». Email на сайте закрыт Cloudflare (data-cfemail) — раскодирован.
--   * ⚠️ Большинство страниц услуг созданы/изменены в 2016–2018 (стоматология), эстетика — 2020, Morpheus8 и главная — 2024-05:
--     состав и перечень могли устареть.
--   * data/google-places/bar/opsta-stomatoloska-ordinacija-mitranic.json — place_id, координаты, телефон.
-- Адрес: сайт «Poslovni Centar Topolica, Ul. Jovana Tomaševića G9, III SPRAT, 85000-Bar» = Google «G9 Ulica Jovana Tomasevica, Bar».
-- Телефоны — сайт (+382 69 228 089 = Google). Facebook/Instagram — шапка сайта.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJB0JfTwB0ThMRXHNR6Zb9OVU';
SET @clinic_slug = 'stomatoloska-ordinacija-mitranic-bar';

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
	'Opšta stomatološka ordinacija Mitranić',
	'Општа стоматолошка ординација Митранић',
	'Стоматологический кабинет Mitranić',
	'Jovana Tomaševića G9, Poslovni centar Topolica, III sprat',
	'Јована Томашевића Г9, Пословни центар Тополица, ИИИ спрат',
	'',
	'',
	'85000',
	42.09921630,
	19.09429960,
	'+38269228089;+38268447245',
	'info@mitranicdental.com',
	'https://mitranicdental.com/',
	'facebook.com/Op%C5%A1ta-stomatolo%C5%A1ka-ordinacija-Mitrani%C4%87-494528703918257',
	'@mitranic_dental',
	'',
	'',
	'',
	'https://mitranicdental.com/wp-content/uploads/2015/12/stomatoloskaordinacija_mitranic_retinalogo.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Општа стоматолошка ординација Митранић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологический кабинет Mitranić', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Jovana Tomaševića G9, Poslovni centar Topolica, III sprat', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Јована Томашевића Г9, Пословни центар Тополица, ИИИ спрат', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269228089;+38268447245', phone),
	email = IF(email IS NULL OR email = '', 'info@mitranicdental.com', email),
	website = IF(website IS NULL OR website = '', 'https://mitranicdental.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/Op%C5%A1ta-stomatolo%C5%A1ka-ordinacija-Mitrani%C4%87-494528703918257', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@mitranic_dental', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://mitranicdental.com/wp-content/uploads/2015/12/stomatoloskaordinacija_mitranic_retinalogo.png', logo_url),
	latitude = COALESCE(latitude, 42.09921630),
	longitude = COALESCE(longitude, 19.09429960)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Opšta stomatološka ordinacija „Mitranić“ nalazi se u samom centru Bara, u Poslovnom centru Topolica (Jovana Tomaševića G9, III sprat), na glavnom trgu, 100 m od obale mora. Ordinacija je savremeno opremljena, a zaposleni se stalno stručno usavršavaju. U ordinaciji rade stomatolozi dr Janko Mitranić i dr Tamara Mitranić. Ordinacija pruža preventivnu i dječju stomatologiju (zalivanje fisura, fluorizacija, uklanjanje mekih i čvrstih naslaga, poliranje), konzervativnu stomatologiju (kompozitni ispuni, liječenje kanala korijena, zatvaranje dijasteme kompozitom), fiksnu protetiku (metalokeramičke, bezmetalne i cirkonijum krunice i mostovi), mobilnu protetiku (skeletirane vizil, pločaste i totalne akrilatne proteze, kombinovani radovi), ortodonciju fiksnim i mobilnim aparatima, izbjeljivanje zuba, implante Straumann i Sweden & Martina i digitalnu radiografiju (Sirona). Dr Tamara Mitranić bavi se i nehirurškom estetskom medicinom lica: hijaluronski fileri, Botox, mezoterapija, mezoniti, PRP i Morpheus8.',
	description_sr_cyrl = 'Општа стоматолошка ординација „Митранић“ налази се у самом центру Бара, у Пословном центру Тополица (Јована Томашевића Г9, ИИИ спрат), на главном тргу, 100 м од обале мора. Ординација је савремено опремљена, а запослени се стално стручно усавршавају. У ординацији раде стоматолози др Јанко Митранић и др Тамара Митранић. Ординација пружа превентивну и дјечју стоматологију (заливање фисура, флуоризација, уклањање меких и чврстих наслага, полирање), конзервативну стоматологију (композитни испуни, лијечење канала коријена, затварање дијастеме композитом), фиксну протетику (металокерамичке, безметалне и цирконијум крунице и мостови), мобилну протетику (скелетиране визил, плочасте и тоталне акрилатне протезе, комбиновани радови), ортодонцију фиксним и мобилним апаратима, избјељивање зуба, импланте Straumann и Sweden & Martina и дигиталну радиографију (Sirona). Др Тамара Митранић бави се и нехируршком естетском медицином лица: хијалуронски филери, Botox, мезотерапија, мезонити, PRP и Morpheus8.',
	description_ru = 'Стоматологический кабинет «Mitranić» находится в самом центре Бара, в бизнес-центре Topolica (ул. Йована Томашевича G9, 3-й этаж), на главной площади в 100 м от моря. Кабинет оснащён современным оборудованием, сотрудники постоянно повышают квалификацию. Принимают стоматологи Янко Митранич и Тамара Митранич. Кабинет оказывает услуги профилактической и детской стоматологии (герметизация фиссур, фторирование, удаление мягкого и твёрдого зубного налёта, полировка), терапевтической стоматологии (композитные пломбы, лечение корневых каналов, закрытие диастемы композитом), несъёмного протезирования (металлокерамические, безметалловые и циркониевые коронки и мосты), съёмного протезирования (бюгельные, пластиночные и полные акриловые протезы, комбинированные конструкции), ортодонтии несъёмными и съёмными аппаратами, отбеливания зубов, имплантации Straumann и Sweden & Martina и цифровой рентгенографии (Sirona). Тамара Митранич также занимается нехирургической эстетической медициной лица: гиалуроновые филлеры, Botox, мезотерапия, мезонити, PRP и Morpheus8.',
	description_en = 'Mitranić is a general dental practice in the very centre of Bar, in the Topolica business centre (Jovana Tomaševića G9, 3rd floor), on the main square 100 m from the seafront. The practice is equipped with modern equipment and its staff continuously pursue professional training. The dentists are Dr Janko Mitranić and Dr Tamara Mitranić. Services include preventive and paediatric dentistry (fissure sealing, fluoride treatment, removal of soft and hard deposits, polishing), restorative dentistry (composite fillings, root canal treatment, composite diastema closure), fixed prosthodontics (metal-ceramic, metal-free and zirconia crowns and bridges), removable prosthodontics (cast partial, acrylic plate and complete acrylic dentures, combined fixed-removable work), orthodontics with fixed and removable appliances, teeth whitening, Straumann and Sweden & Martina implants and digital radiography (Sirona). Dr Tamara Mitranić also practises non-surgical facial aesthetic medicine: hyaluronic fillers, Botox, mesotherapy, mesothreads, PRP and Morpheus8.',
	description_de = 'Mitranić ist eine allgemeine Zahnarztpraxis im Zentrum von Bar, im Geschäftszentrum Topolica (Jovana Tomaševića G9, 3. Stock), am Hauptplatz 100 m vom Meer entfernt. Die Praxis ist modern ausgestattet, das Team bildet sich laufend fort. Es behandeln die Zahnärzte Dr. Janko Mitranić und Dr. Tamara Mitranić. Angeboten werden Präventiv- und Kinderzahnheilkunde (Fissurenversiegelung, Fluoridierung, Entfernung weicher und harter Beläge, Politur), konservierende Zahnheilkunde (Kompositfüllungen, Wurzelkanalbehandlung, Lückenschluss mit Komposit), festsitzende Prothetik (Metallkeramik-, metallfreie und Zirkonkronen und -brücken), herausnehmbare Prothetik (Modellguss-, Kunststoffplatten- und Acryl-Totalprothesen, kombinierte Arbeiten), Kieferorthopädie mit festsitzenden und herausnehmbaren Apparaturen, Zahnaufhellung, Implantate von Straumann und Sweden & Martina sowie digitales Röntgen (Sirona). Dr. Tamara Mitranić ist außerdem in der nichtchirurgischen ästhetischen Gesichtsmedizin tätig: Hyaluronfiller, Botox, Mesotherapie, Mesofäden, PRP und Morpheus8.',
	description_tr = 'Mitranić, Bar''ın tam merkezinde, Topolica iş merkezinde (Jovana Tomaševića G9, 3. kat), ana meydanda ve denize 100 m mesafede bulunan genel bir diş muayenehanesidir. Muayenehane modern ekipmanla donatılmıştır ve çalışanları sürekli mesleki eğitim alır. Diş hekimleri Dr. Janko Mitranić ve Dr. Tamara Mitranić hasta kabul eder. Koruyucu ve çocuk diş hekimliği (fissür örtücü, florlama, yumuşak ve sert diş birikintilerinin temizlenmesi, cilalama), restoratif diş hekimliği (kompozit dolgu, kanal tedavisi, kompozitle diastema kapatma), sabit protez (metal-seramik, metalsiz ve zirkonyum kron ve köprüler), hareketli protez (iskelet, akrilik plak ve tam akrilik protezler, kombine çalışmalar), sabit ve hareketli apareylerle ortodonti, diş beyazlatma, Straumann ve Sweden & Martina implantları ve dijital radyografi (Sirona) hizmetleri sunulur. Dr. Tamara Mitranić ayrıca cerrahi olmayan yüz estetiği alanında çalışır: hiyalüronik dolgular, Botox, mezoterapi, mezo ipler, PRP ve Morpheus8.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (страницы «News», «Новости», «Kонтакт» — остатки версий сайта, не заявление) → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: на сайте не указаны — не заполняются.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (2)
-- Состав — /o-nama/ и главная («Naš tim»): dr Mitranić Janko — «Stomatolog», dr Mitranić Tamara — «Stomatolog»; Sabotić Senada — «Stomatološka
-- sestra» (не врач, не заводится). В БД Mitranić нет (поиск по name_sr, перевёрнутому имени и slug, 2026-10-09).
-- Специальности: 78 = DENTISTRY; у Tamara + 44 = AESTHETIC_MEDICINE — /estetska-medicina-2/: «Dr Tamara Mitranić je licencirani ljekar u
-- različitim oblastima nehirurške facijalne estetske medicine». Фото: Janko — 2016, Tamara — 2024 с главной (на /o-nama/ — старое 2016).
-- ⚠️ Ортодонтия: /ortodoncija/ (2018) — «saradnju sa vrhunskim Stojković Ortodoncija timom iz Beograda» (Dr Ivana Stojković Golac, Prim. Dr
-- Miodrag Stojković) — внешние партнёры из Белграда, не сотрудники; не заводятся, см. openQuestions записи импорта.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Janko Mitranić — Stomatolog
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Janko Mitranić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mitranić Janko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'janko-mitranic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'janko-mitranic', 'Janko Mitranić', 'Јанко Митранић', 'Янко Митранич', 'Janko Mitranic', 'dr',
	'https://mitranicdental.com/wp-content/uploads/2016/01/mitranic_dental_mitranic_janko.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Tamara Mitranić — Stomatolog; estetska medicina
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Tamara Mitranić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mitranić Tamara' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'tamara-mitranic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, phone, created_at)
SELECT 'tamara-mitranic', 'Tamara Mitranić', 'Тамара Митранић', 'Тамара Митранич', 'Tamara Mitranic', 'dr',
	'https://mitranicdental.com/wp-content/uploads/2024/04/tamara-mitranic.jpg', NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Stomatolog i licencirani ljekar u različitim oblastima nehirurške facijalne estetske medicine, u kojoj se godinama kontinuirano edukuje kroz brojne internacionalne stručne skupove. Osnivač je i predsjednik Crnogorskog udruženja doktora za estetiku lica i pokretač inicijative da se intervencije estetske medicine urede jasnim zakonskim okvirom. Organizator je prvog međunarodnog simpozijuma „Dani nehirurške estetske medicine“ CUDEL 2019, potpisnik stručnih članaka i predavač na temu estetske medicine. Zastupa pristup „manje je više“ i prirodan rezultat.',
	description_sr_cyrl = 'Стоматолог и лиценцирани љекар у различитим областима нехируршке фацијалне естетске медицине, у којој се годинама континуирано едукује кроз бројне интернационалне стручне скупове. Оснивач је и предсједник Црногорског удружења доктора за естетику лица и покретач иницијативе да се интервенције естетске медицине уреде јасним законским оквиром. Организатор је првог међународног симпозијума „Дани нехируршке естетске медицине“ ЦУДЕЛ 2019, потписник стручних чланака и предавач на тему естетске медицине. Заступа приступ „мање је више“ и природан резултат.',
	description_ru = 'Стоматолог и лицензированный врач в разных областях нехирургической эстетической медицины лица, в которой много лет регулярно повышает квалификацию на международных профессиональных конференциях. Основатель и президент Черногорской ассоциации врачей эстетики лица, инициатор правового регулирования процедур эстетической медицины. Организатор первого международного симпозиума «Дни нехирургической эстетической медицины» CUDEL 2019, автор профессиональных статей и лектор по эстетической медицине. Придерживается принципа «меньше — значит больше» и естественного результата.',
	description_en = 'Dentist and licensed practitioner in various fields of non-surgical facial aesthetic medicine, in which she has trained continuously for years at international professional meetings. She is the founder and president of the Montenegrin Association of Doctors for Facial Aesthetics and initiated a clear legal framework for aesthetic medicine procedures. She organised the first international symposium "Days of Non-Surgical Aesthetic Medicine" (CUDEL 2019), has authored professional articles and lectures on aesthetic medicine. She favours a "less is more" approach and natural results.',
	description_de = 'Zahnärztin und lizenzierte Ärztin in verschiedenen Bereichen der nichtchirurgischen ästhetischen Gesichtsmedizin, in denen sie sich seit Jahren auf internationalen Fachtagungen fortbildet. Sie ist Gründerin und Präsidentin der Montenegrinischen Vereinigung der Ärzte für Gesichtsästhetik und initiierte einen klaren rechtlichen Rahmen für ästhetisch-medizinische Eingriffe. Sie organisierte das erste internationale Symposium „Tage der nichtchirurgischen ästhetischen Medizin“ (CUDEL 2019), ist Autorin von Fachartikeln und Referentin zur ästhetischen Medizin. Sie vertritt den Ansatz „weniger ist mehr“ und natürliche Ergebnisse.',
	description_tr = 'Diş hekimi ve cerrahi olmayan yüz estetiği tıbbının çeşitli alanlarında lisanslı hekim; bu alanda yıllardır uluslararası mesleki toplantılarda düzenli olarak eğitim alıyor. Karadağ Yüz Estetiği Hekimleri Derneği''nin kurucusu ve başkanıdır ve estetik tıp uygulamalarının açık bir yasal çerçeveye kavuşturulması girişimini başlatmıştır. İlk uluslararası ''Cerrahi Olmayan Estetik Tıp Günleri'' sempozyumunu (CUDEL 2019) düzenledi; mesleki makalelerin yazarı ve estetik tıp konusunda konuşmacıdır. ''Az çoktur'' yaklaşımını ve doğal sonucu savunur.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog; estetska medicina')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 7, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2 врач(а/ей): janko-mitranic, tamara-mitranic.
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

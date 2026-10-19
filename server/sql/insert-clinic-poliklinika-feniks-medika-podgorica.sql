-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Feniks Medika (Podgorica) — клиника (врачей нет)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-feniks-medika-podgorica.sql
-- Затем: server/sql/insert-clinic-poliklinika-feniks-medika-podgorica-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://feniks-medika.me/ — WordPress (тема Medical Circle), 9 страниц через
--     wp-json /wp/v2/pages (все modified 2023-03-06…10) + 1 запись блога; шапка
--     и футер — из HTML главной.
--   * DOCX-прайс «CJENOVNIK USLUGA PZU POLIKLINIKE “FENIKS MEDIKA”» (Podgorica,
--     04.11.2022) — в services-файле.
--   * data/google-places/podgorica/klinika-podgorica-feniks-medika.json — place_id,
--     координаты, телефон (Google не перезапрашивался).
--
-- Сверка фактов:
--   * Адрес: сайт «Bul . Ivana Crnojevica 58/3» (главная) и «Naša adresa Bulevar …»
--     (шапка); Google — «50-60 Bulevar Ivana Crnojevića» (диапазон домов). Записан
--     с сайта: «Bulevar Ivana Crnojevića 58/3».
--   * Координаты 42.4432743 / 19.2654579 — Google Places, единственный источник.
--   * Телефоны: главная «020 511 888, 069 120 015, 069 120 016, 067 373 414»;
--     Google подтверждает первый (+382 20 511 888).
--   * Email: шапка «e-mail feniksmedika@t-com.me».
--   * Соцсетей на сайте нет.
--   * Часы: главная «Radni dani – 7:30h – 20h / Subota – 7:30h -14h», /zakazivanje-pregleda/
--     «Radnim danima od 7:30h do 20h, Subotom od 7:30h do 14h». Воскресенье не названо —
--     записано closed (рабочие дни перечислены явно).
--   * Языки клиники: только SR (html lang en-CA — это тема WordPress, текст весь на
--     черногорском; других языков приёма сайт не заявляет).
--   * Тип: POLYCLINIC (1) — «Privatna zdravstvena ustanova poliklinika Feniks medika»,
--     в прайсе «PZU POLIKLINIKE». Своя лаборатория есть, но тип лаборатории не ставим:
--     это поликлиника с лабораторией, как у остальных многопрофильных поликлиник.
--   * Врачей НЕТ: имён врачей нет ни на одной из 9 страниц, ни в DOCX (в прайсе только
--     специальности).
--   * Логотип — custom-logo темы (горизонтальный, 300×113).
--   * Имя: Google «Klinika Podgorica | Feniks Medika» — это SEO-название; клиника сама
--     называет себя «PZU poliklinika Feniks medika» → «Poliklinika Feniks Medika».
--
-- Маркетинговые формулировки («Najmodernija oprema») в описание не переносятся,
-- оставлено проверяемое: аппараты Siemens, протočna histeroskopija.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания
-- пишутся безусловным UPDATE (правки из админки следующий прогон перезатрёт —
-- вносить сюда), языки и часы синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJGyTHrE7rTRMRgB1yl3q_vK8';
SET @clinic_slug = 'poliklinika-feniks-medika-podgorica';

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
	'Poliklinika Feniks Medika',
	'Поликлиника Феникс Медика',
	'Поликлиника Феникс Медика',
	'Bulevar Ivana Crnojevića 58/3',
	'Булевар Ивана Црнојевића 58/3',
	'',
	'',
	'81000',
	42.44327430,
	19.26545790,
	'+38220511888;+38269120015;+38269120016;+38267373414',
	'feniksmedika@t-com.me',
	'https://feniks-medika.me/',
	'', -- на сайте нет
	'', -- на сайте нет
	'',
	'',
	'',
	'https://feniks-medika.me/wp-content/uploads/2023/03/cropped-feniks-medika-logo-1.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Феникс Медика', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Феникс Медика', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Bulevar Ivana Crnojevića 58/3', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Булевар Ивана Црнојевића 58/3', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude        = COALESCE(latitude, 42.44327430),
	longitude       = COALESCE(longitude, 19.26545790),
	phone           = IF(phone IS NULL OR phone = '', '+38220511888;+38269120015;+38269120016;+38267373414', phone),
	email           = IF(email IS NULL OR email = '', 'feniksmedika@t-com.me', email),
	website         = IF(website IS NULL OR website = '', 'https://feniks-medika.me/', website),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://feniks-medika.me/wp-content/uploads/2023/03/cropped-feniks-medika-logo-1.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что клиника пишет о себе: главная,
-- /radioloski-kabinet-u-podgorici/, /mamograf/, /medicina-rada/, /ginekologija/,
-- /pedijatrija-u-podgorici/, /fizijatrija/, /laboratorijska-dijagnostika-u-podgorici/,
-- /zakazivanje-pregleda/ и перечень специальностей прайса.
UPDATE clinics SET
	description_sr = 'Privatna poliklinika Feniks Medika na Bulevaru Ivana Crnojevića u Podgorici. Ima sopstvenu laboratoriju i radiološki kabinet sa rendgenom (nativni i kontrastni snimci kostiju, zglobova, pluća i abdomena), ultrazvukom i mamografom; dijagnostički aparati su iz porodice Siemens. U poliklinici rade interna medicina i opšta praksa, ginekologija (kolposkopija, ultrazvuk, protočna dijagnostička i interventna histeroskopija), pedijatrija (pregled zdrave i bolesne djece do 18. godine, ultrazvuk glave i kukova kod novorođenčadi), hirurgija, urologija, ORL, fizijatrija, neurologija, kardiologija, reumatologija, endokrinologija, dermatovenerologija, pulmologija, hematologija i psihijatrija. Medicina rada obavlja sistematske preglede i preglede za ljekarska uvjerenja: za vozače svih kategorija, držanje i nošenje oružja, procjenu radne sposobnosti i upis u školu. Poliklinika nudi i kućne posjete i prevoz pacijenata, a kada je potrebno više pregleda, nastoji da ih poveže u jedan dolazak. Radi radnim danima od 7:30 do 20 h i subotom od 7:30 do 14 h.',
	description_sr_cyrl = 'Приватна поликлиника Феникс Медика на Булевару Ивана Црнојевића у Подгорици. Има сопствену лабораторију и радиолошки кабинет са рендгеном (нативни и контрастни снимци костију, зглобова, плућа и абдомена), ултразвуком и мамографом; дијагностички апарати су из породице Siemens. У поликлиници раде интерна медицина и општа пракса, гинекологија (колпоскопија, ултразвук, проточна дијагностичка и интервентна хистероскопија), педијатрија (преглед здраве и болесне дјеце до 18. године, ултразвук главе и кукова код новорођенчади), хирургија, урологија, ОРЛ, физијатрија, неурологија, кардиологија, реуматологија, ендокринологија, дерматовенерологија, пулмологија, хематологија и психијатрија. Медицина рада обавља систематске прегледе и прегледе за љекарска увјерења: за возаче свих категорија, држање и ношење оружја, процјену радне способности и упис у школу. Поликлиника нуди и кућне посјете и превоз пацијената, а када је потребно више прегледа, настоји да их повеже у један долазак. Ради радним данима од 7:30 до 20 h и суботом од 7:30 до 14 h.',
	description_ru = 'Частная поликлиника «Феникс Медика» на бульваре Ивана Црноевича в Подгорице. Есть собственная лаборатория и рентгенологический кабинет с рентгеном (обзорные и контрастные снимки костей, суставов, лёгких и брюшной полости), УЗИ и маммографом; диагностическое оборудование — Siemens. В поликлинике работают терапевты-интернисты и врачи общей практики, гинекология (кольпоскопия, УЗИ, проточная диагностическая и оперативная гистероскопия), педиатрия (осмотр здоровых и больных детей до 18 лет, УЗИ головы и тазобедренных суставов у новорождённых), хирургия, урология, ЛОР, физиатрия, неврология, кардиология, ревматология, эндокринология, дерматовенерология, пульмонология, гематология и психиатрия. Служба медицины труда проводит комплексные медосмотры и осмотры для медицинских справок: для водителей всех категорий, на хранение и ношение оружия, для оценки трудоспособности и поступления в школу. Поликлиника также выезжает на дом и перевозит пациентов, а если нужно несколько обследований, старается провести их за один визит. Работает в будни с 7:30 до 20:00, в субботу с 7:30 до 14:00.',
	description_en = 'Feniks Medika is a private polyclinic on Ivana Crnojevića Boulevard in Podgorica. It has its own laboratory and a radiology unit with X-ray (plain and contrast imaging of bones, joints, lungs and abdomen), ultrasound and a mammography unit; the diagnostic equipment is by Siemens. The polyclinic covers internal and general medicine, gynaecology (colposcopy, ultrasound, diagnostic and operative flow hysteroscopy), paediatrics (check-ups of healthy and sick children up to 18, head and hip ultrasound in newborns), surgery, urology, ENT, physical medicine, neurology, cardiology, rheumatology, endocrinology, dermatovenereology, pulmonology, haematology and psychiatry. Its occupational medicine service performs routine check-ups and examinations for medical certificates: for drivers of all categories, firearms possession, work ability assessment and school enrolment. The polyclinic also offers home visits and patient transport, and when several examinations are needed, it tries to combine them into one visit. Open on weekdays from 7:30 to 20:00 and on Saturdays from 7:30 to 14:00.',
	description_de = 'Feniks Medika ist eine private Poliklinik am Ivana-Crnojevića-Boulevard in Podgorica. Sie verfügt über ein eigenes Labor und eine Radiologie mit Röntgen (Nativ- und Kontrastaufnahmen von Knochen, Gelenken, Lunge und Abdomen), Ultraschall und Mammographie; die Diagnostikgeräte stammen von Siemens. Vertreten sind Innere und Allgemeinmedizin, Gynäkologie (Kolposkopie, Ultraschall, diagnostische und operative Durchfluss-Hysteroskopie), Pädiatrie (Untersuchung gesunder und kranker Kinder bis 18 Jahre, Kopf- und Hüftultraschall bei Neugeborenen), Chirurgie, Urologie, HNO, physikalische Medizin, Neurologie, Kardiologie, Rheumatologie, Endokrinologie, Dermatovenerologie, Pneumologie, Hämatologie und Psychiatrie. Die Arbeitsmedizin führt Vorsorgeuntersuchungen und Untersuchungen für ärztliche Bescheinigungen durch: für Fahrer aller Klassen, für Waffenbesitz und -tragen, zur Beurteilung der Arbeitsfähigkeit und für die Schulanmeldung. Die Poliklinik bietet außerdem Hausbesuche und Patiententransport an und versucht, mehrere Untersuchungen auf einen Termin zu legen. Geöffnet werktags von 7:30 bis 20:00 Uhr und samstags von 7:30 bis 14:00 Uhr.',
	description_tr = 'Feniks Medika, Podgorica''da Ivana Crnojevića Bulvarı üzerinde bulunan özel bir polikliniktir. Kendi laboratuvarı ile röntgen (kemik, eklem, akciğer ve karın bölgesinin direkt ve kontrastlı çekimleri), ultrason ve mamografi cihazına sahip bir radyoloji birimi bulunur; tanı cihazları Siemens markadır. Poliklinikte dahiliye ve genel pratisyenlik, kadın hastalıkları (kolposkopi, ultrason, tanısal ve girişimsel akışlı histeroskopi), çocuk hastalıkları (18 yaşına kadar sağlıklı ve hasta çocukların muayenesi, yenidoğanlarda baş ve kalça ultrasonu), cerrahi, üroloji, KBB, fizik tedavi, nöroloji, kardiyoloji, romatoloji, endokrinoloji, dermatoveneroloji, göğüs hastalıkları, hematoloji ve psikiyatri hizmet verir. İş sağlığı birimi check-up muayeneleri ile her sınıftan sürücüler, silah bulundurma ve taşıma, çalışma kapasitesi değerlendirmesi ve okul kaydı için sağlık raporu muayeneleri yapar. Poliklinik ayrıca ev ziyareti ve hasta nakli hizmeti sunar; birden fazla muayene gerektiğinde bunları tek ziyarette birleştirmeye çalışır. Hafta içi 7:30–20:00, cumartesi 7:30–14:00 saatleri arasında açıktır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- «Radni dani – 7:30h – 20h / Subota – 7:30h -14h»
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "14:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, languages = 1, types = 1, working_hours = 1.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

SELECT clinic_id, monday, friday, saturday, sunday FROM clinic_working_hours WHERE clinic_id = @clinic_id;

-- Ожидается 0 врачей.
SELECT COUNT(*) AS doctors_linked FROM doctor_clinics WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════════════════
-- Ital-Dent (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ital-dent-podgorica.sql
--
-- Источники (curl с браузерным UA, 2026-10-09; запись импорта — data/clinic-imports/ital-dent-podgorica.json):
--   * https://www.ital-dent.com/ — WordPress, только итальянский (для пациентов из Италии); wp-json /pages: Home (2018-10-09),
--     Clinica (2018-05-14), FAQs (2018-05-24) — прочитаны все три. Цены только по запросу («Chiedi un preventivo gratuito» — форма
--     со снимком), кроме двух бесплатных снимков на главной.
--   * data/google-places/podgorica/ital-dent.json — place_id, координаты.
-- Адрес: сайт «Ul. Peta Proleterska 36/a, 81000 Podgorica» = Google «36a Pete Proleterske Brigade». Телефоны: сайт «Tel: 0038 220 62-13-32»
-- (= +382 20 621 332, Google), «Cell: 0038 268 81-55-55» (= +382 68 815 555). Email и часы — подвал сайта. Соцсетей нет.
-- Сайт 2018 — состав и перечень могли устареть.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJWZaIIQrrTRMRgnAL_yZDUcA';
SET @clinic_slug = 'ital-dent-podgorica';

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
	'Ital-Dent',
	'Ital-Dent',
	'Ital-Dent',
	'Peta proleterska 36a',
	'Пета пролетерска 36а',
	'',
	'',
	'81000',
	42.43730340,
	19.26767950,
	'+38220621332;+38268815555',
	'info@ital-dent.com',
	'https://www.ital-dent.com/',
	'',
	'',
	'',
	'',
	'',
	'https://www.ital-dent.com/wp-content/uploads/2018/03/logo_1.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Ital-Dent', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Ital-Dent', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Peta proleterska 36a', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Пета пролетерска 36а', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220621332;+38268815555', phone),
	email = IF(email IS NULL OR email = '', 'info@ital-dent.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.ital-dent.com/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.ital-dent.com/wp-content/uploads/2018/03/logo_1.png', logo_url),
	latitude = COALESCE(latitude, 42.43730340),
	longitude = COALESCE(longitude, 19.26767950)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Ital-Dent je stomatološka klinika u Podgorici, u ulici Peta proleterska 36a, koju su osnovali italijanski doktori stomatologije upisani u Ljekarsku komoru Crne Gore; namijenjena je prije svega pacijentima iz Italije. Stomatolozi imaju dvadesetogodišnje iskustvo, a klinika navodi cijene i do 50% niže nego kod stomatologa u Italiji. Koristi materijale i opremu evropskih proizvođača, certifikovane po ISO normama, a izdati računi važe za poreske olakšice u Italiji i prihvataju ih osiguranja koja refundiraju stomatološke troškove. Klinika radi intervencije u sedaciji uz prisustvo anesteziologa, implantologiju (i tehnikom Piezosurgery), sinus lift i koštane graftove, izbjeljivanje zuba laserom ili plazma lampom, konzervativno liječenje, keramičke i kompozitne fasete, parodontologiju, fiksne i mobilne proteze, nevidljivu ortodonciju i digitalna RTG snimanja; digitalni ortopan i retroalveolarni snimci su besplatni. Za pacijente iz Italije nudi besplatan smještaj za dvije osobe, besplatan prevoz od i do aerodroma Podgorica i luke Bar, a za predračune preko 10.000 € i besplatan avionski prevoz.',
	description_sr_cyrl = 'Ital-Dent је стоматолошка клиника у Подгорици, у улици Пета пролетерска 36а, коју су основали италијански доктори стоматологије уписани у Љекарску комору Црне Горе; намијењена је прије свега пацијентима из Италије. Стоматолози имају двадесетогодишње искуство, а клиника наводи цијене и до 50% ниже него код стоматолога у Италији. Користи материјале и опрему европских произвођача, цертификоване по ISO нормама, а издати рачуни важе за пореске олакшице у Италији и прихватају их осигурања која рефундирају стоматолошке трошкове. Клиника ради интервенције у седацији уз присуство анестезиолога, имплантологију (и техником Piezosurgery), синус лифт и коштане графтове, избјељивање зуба ласером или плазма лампом, конзервативно лијечење, керамичке и композитне фасете, пародонтологију, фиксне и мобилне протезе, невидљиву ортодонцију и дигитална РТГ снимања; дигитални ортопан и ретроалвеоларни снимци су бесплатни. За пацијенте из Италије нуди бесплатан смјештај за двије особе, бесплатан превоз од и до аеродрома Подгорица и луке Бар, а за предрачуне преко 10.000 € и бесплатан авионски превоз.',
	description_ru = 'Ital-Dent — стоматологическая клиника в Подгорице, на улице Пета пролетерска, 36а, основанная итальянскими стоматологами, состоящими в Медицинской палате Черногории; клиника ориентирована прежде всего на пациентов из Италии. Врачи имеют двадцатилетний опыт, а цены, по словам клиники, до 50% ниже, чем у стоматологов в Италии. Используются материалы и оборудование европейских производителей, сертифицированные по ISO; выдаваемые счета дают право на налоговый вычет в Италии и принимаются страховыми, возмещающими стоматологические расходы. Клиника проводит вмешательства под седацией в присутствии анестезиолога, имплантацию (в том числе по технике Piezosurgery), синус-лифтинг и костную пластику, отбеливание зубов лазером или плазменной лампой, терапевтическое лечение, керамические и композитные виниры, пародонтологию, несъёмные и съёмные протезы, невидимую ортодонтию и цифровую рентгенодиагностику; цифровая ортопантомограмма и прицельные снимки — бесплатно. Пациентам из Италии предлагаются бесплатное проживание для двух человек, бесплатный трансфер из аэропорта Подгорицы и порта Бар, а при смете свыше 10 000 € — бесплатный авиаперелёт.',
	description_en = 'Ital-Dent is a dental clinic in Podgorica, at Peta proleterska 36a, founded by Italian dentists registered with the Medical Chamber of Montenegro; it mainly serves patients from Italy. The dentists have twenty years of experience, and the clinic says its prices are up to 50% lower than those of dentists in Italy. It uses materials and equipment from European manufacturers, ISO-certified, and its invoices are valid for tax deductions in Italy and accepted by insurers that reimburse dental costs. The clinic performs procedures under sedation with an anaesthetist present, implantology (including the Piezosurgery technique), sinus lifts and bone grafts, teeth whitening with laser or plasma lamp, restorative treatment, ceramic and composite veneers, periodontology, fixed and removable dentures, invisible orthodontics and digital X-rays; digital panoramic and periapical X-rays are free. For patients from Italy it offers free accommodation for two, free transfers from Podgorica airport and the port of Bar, and a free flight for quotes over €10,000.',
	description_de = 'Ital-Dent ist eine Zahnklinik in Podgorica, Peta proleterska 36a, gegründet von italienischen Zahnärzten, die bei der Ärztekammer Montenegros eingetragen sind; sie richtet sich vor allem an Patienten aus Italien. Die Zahnärzte haben zwanzig Jahre Erfahrung, und die Klinik gibt an, bis zu 50 % günstiger zu sein als Zahnärzte in Italien. Verwendet werden ISO-zertifizierte Materialien und Geräte europäischer Hersteller; die Rechnungen sind in Italien steuerlich absetzbar und werden von Versicherungen anerkannt, die Zahnarztkosten erstatten. Die Klinik führt Eingriffe unter Sedierung im Beisein eines Anästhesisten durch, Implantologie (auch mit der Piezosurgery-Technik), Sinuslift und Knochentransplantate, Zahnaufhellung mit Laser oder Plasmalampe, konservierende Behandlung, Keramik- und Kompositveneers, Parodontologie, festsitzenden und herausnehmbaren Zahnersatz, unsichtbare Kieferorthopädie und digitales Röntgen; digitale Panorama- und Einzelzahnaufnahmen sind kostenlos. Patienten aus Italien erhalten kostenlose Unterkunft für zwei Personen, kostenlosen Transfer vom Flughafen Podgorica und vom Hafen Bar sowie bei Kostenvoranschlägen über 10.000 € einen kostenlosen Flug.',
	description_tr = 'Ital-Dent, Podgorica''da Peta proleterska 36a adresinde, Karadağ Tabipler Odası''na kayıtlı İtalyan diş hekimlerinin kurduğu bir diş kliniğidir; öncelikle İtalya''dan gelen hastalara hizmet verir. Diş hekimlerinin yirmi yıllık deneyimi vardır ve klinik fiyatlarının İtalya''daki diş hekimlerine göre %50''ye kadar daha düşük olduğunu belirtir. ISO sertifikalı Avrupa üretimi malzeme ve ekipman kullanılır; kesilen faturalar İtalya''da vergi indirimi için geçerlidir ve diş masraflarını karşılayan sigortalarca kabul edilir. Klinik anestezi uzmanı eşliğinde sedasyon altında müdahaleler, implantoloji (Piezosurgery tekniği dahil), sinüs lifting ve kemik greftleri, lazer veya plazma lambası ile diş beyazlatma, koruyucu tedavi, seramik ve kompozit lamina, periodontoloji, sabit ve hareketli protezler, görünmez ortodonti ve dijital röntgen sunar; dijital panoramik ve periapikal filmler ücretsizdir. İtalya''dan gelen hastalara iki kişilik ücretsiz konaklama, Podgorica havalimanı ve Bar limanından ücretsiz transfer, 10.000 € üzerindeki tekliflerde ücretsiz uçak bileti sunulur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE (языки 1, 8). SR (1) + IT (8): главная «La Ital-Dent è una società fondata da medici stomatologi italiani iscritti all'Ordine dei Medici di Montenegro», FAQ «Siamo medici italiani», подвал «fondata e gestita da medici italiani» — заявление о врачах-итальянцах (решение юзера: тогда итальянский можно). Сайт только на итальянском, для пациентов из Италии.
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id NOT IN (1, 8);
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1 AND id <> @keep_lang_id;
INSERT INTO clinic_languages (clinic_id, language_id) SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 8);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 8 AND id <> @keep_lang_id;
INSERT INTO clinic_languages (clinic_id, language_id) SELECT @clinic_id, 8 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 8);

-- Часы работы: подвал: «Lun – Ven: 9:00 – 13:00 / 15:00 – 19:00»; выходные не указаны → закрыто.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "15:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "15:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "15:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "15:00", "end": "19:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "15:00", "end": "19:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- Врачей по именам на сайте нет («medici stomatologi italiani», «I nostri dentisti hanno un'esperienza ventennale» — без имён). Привязывать некого.
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1,8, clinic_types = 2, hours = 1
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

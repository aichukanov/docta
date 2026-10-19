-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija za ultrazvučnu dijagnostiku dr Rahović (Bijelo Polje) — клиника (врачей нет)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-dr-rahovic-bijelo-polje.sql
-- Затем: server/sql/insert-clinic-ordinacija-dr-rahovic-bijelo-polje-services.sql
-- Запись импорта: data/clinic-imports/ordinacija-dr-rahovic-bijelo-polje.json. Подволна 2e, агент Z.
-- 
-- Название — как на сайте (title, H1, футер): «Ordinacija za ultrazvučnu dijagnostiku Dr Rahović»; Google — «Specijalistička ordinacija dr Rahović» (в nameVariants).
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://www.drrahovic.com/ — одностраничник (Next.js, sitemap 1 URL, lastmod 2026-01-17): 14 видов УЗИ, часы, телефон, адрес. Цен нет.
--   * data/google-places/bijelo-polje/specijalisticka-ordinacija-dr-rahovic.json — place_id, координаты 43.0344299 / 19.750138,
--     5 отзывов (rating 5) — не импортировались. ⚠️ formattedAddress в файле места битый («https://goo.gl/maps, …») — адрес взят с сайта.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJf5_pUe2jUhMRCQ-FegySUig';
SET @clinic_slug = 'ordinacija-dr-rahovic-bijelo-polje';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Ordinacija za ultrazvučnu dijagnostiku dr Rahović', 'Ordinacija za ultrazvučnu dijagnostiku Dr Rahović', 'Specijalistička ordinacija dr Rahović', 'Ordinacija dr Rahović') AND city_id = 12 LIMIT 1));

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
	12, -- CityId.BELO_POLJE
	'Ordinacija za ultrazvučnu dijagnostiku dr Rahović',
	'Ординација за ултразвучну дијагностику др Раховић',
	'Кабинет ультразвуковой диагностики доктора Раховича',
	'Voja Lješnjaka bb',
	'Воја Љешњака бб',
	'',
	'',
	'84000',
	43.03442990,
	19.75013800,
	'+38269050055',
	'',
	'https://www.drrahovic.com/',
	'',
	'',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 43.03442990, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.75013800, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Ординација за ултразвучну дијагностику др Раховић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Кабинет ультразвуковой диагностики доктора Раховича', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Voja Lješnjaka bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Воја Љешњака бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '84000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269050055', phone),
	website = IF(website IS NULL OR website = '', 'https://www.drrahovic.com/', website)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Ordinacija za ultrazvučnu dijagnostiku dr Rahović nalazi se u Bijelom Polju, u ulici Voja Lješnjaka bb. Radi ultrazvučne (eho) preglede abdomena, urotrakta, bubrega, mokraćne bešike i prostate, testisa, dojki, mekih tkiva vrata i ostalih mekih tkiva i kukova kod djece, kao i kolor dopler krvnih sudova vrata, donjih i gornjih ekstremiteta, renalnih arterija i splenoportalnog sistema. Radno vrijeme: od ponedjeljka do petka od 7:30 do 15:30. Zakazivanje i informacije na telefon 069 050 055 radnim danima od 8 do 16 časova.',
	description_sr_cyrl = 'Ординација за ултразвучну дијагностику др Раховић налази се у Бијелом Пољу, у улици Воја Љешњака бб. Ради ултразвучне (ехо) прегледе абдомена, уротракта, бубрега, мокраћне бешике и простате, тестиса, дојки, меких ткива врата и осталих меких ткива и кукова код дјеце, као и колор доплер крвних судова врата, доњих и горњих екстремитета, реналних артерија и спленопорталног система. Радно вријеме: од понедјељка до петка од 7:30 до 15:30. Заказивање и информације на телефон 069 050 055 радним данима од 8 до 16 часова.',
	description_ru = 'Кабинет ультразвуковой диагностики доктора Раховича находится в Биело-Поле, на улице Voja Lješnjaka bb. Здесь делают УЗИ (эхографию) брюшной полости, мочевыводящих путей, почек, мочевого пузыря и простаты, яичек, молочных желёз, мягких тканей шеи и других мягких тканей, тазобедренных суставов у детей, а также цветовое допплеровское исследование сосудов шеи, верхних и нижних конечностей, почечных артерий и спленопортальной системы. Часы работы: с понедельника по пятницу с 7:30 до 15:30. Запись и справки по телефону 069 050 055 в будни с 8 до 16 часов.',
	description_en = 'The Dr Rahović ultrasound diagnostics practice is located in Bijelo Polje at Voja Lješnjaka bb. It performs ultrasound (echo) examinations of the abdomen, urinary tract, kidneys, bladder and prostate, testicles, breasts, neck soft tissues and other soft tissues, and paediatric hips, as well as colour Doppler of the neck vessels, lower and upper limb vessels, renal arteries and the splenoportal system. Opening hours: Monday to Friday 7:30–15:30. Appointments and information by phone at 069 050 055 on weekdays from 8:00 to 16:00.',
	description_de = 'Die Praxis für Ultraschalldiagnostik Dr. Rahović befindet sich in Bijelo Polje, Voja Lješnjaka bb. Angeboten werden Ultraschall-(Echo-)Untersuchungen von Abdomen, Harnwegen, Nieren, Harnblase und Prostata, Hoden, Brust, Halsweichteilen und anderen Weichteilen sowie der Hüften bei Kindern, außerdem Farbdoppler der Halsgefäße, der Gefäße der unteren und oberen Extremitäten, der Nierenarterien und des splenoportalen Systems. Öffnungszeiten: Montag bis Freitag 7:30–15:30 Uhr. Termine und Auskunft telefonisch unter 069 050 055 werktags von 8 bis 16 Uhr.',
	description_tr = 'Dr. Rahović ultrason tanı muayenehanesi Bijelo Polje''de, Voja Lješnjaka bb adresindedir. Karın, idrar yolları, böbrekler, mesane ve prostat, testisler, meme, boyun yumuşak dokuları ve diğer yumuşak dokular ile çocuklarda kalça ultrason (eko) incelemelerinin yanı sıra boyun damarları, alt ve üst ekstremite damarları, renal arterler ve splenoportal sistemin renkli Doppler incelemesi yapılır. Çalışma saatleri: pazartesiden cumaya 7:30–15:30. Randevu ve bilgi için hafta içi 8:00–16:00 arasında 069 050 055 numaralı telefon aranabilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- POLYCLINIC = 1 — кабинет УЗИ-диагностики (решение владельца каталога для radio-medic: отдельного типа радиологии нет, DIAGNOSTIC_LAB вводит в заблуждение).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском, другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — сайт: «Radno vrijeme: Od ponedeljka do petka od 7:30 - 15:30h». Сб/Вс не названы → closed. «Zakazivanje … radnim danima od 8h do 16h» — часы телефона, в описании.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "15:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "15:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "15:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "15:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "15:30"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday),
	tuesday = VALUES(tuesday),
	wednesday = VALUES(wednesday),
	thursday = VALUES(thursday),
	friday = VALUES(friday),
	saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (0)
-- ═══════════════════════════════════════════════════════════════
-- Имя врача на сайте не указано («Dr Rahović»). Поиск в БД: Rahović / Rahovic / rahovic — нет ни одного врача (локаль), → по правилу юзера не заводим.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 12, status = published, clinic_languages = '1', clinic_types = '1', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 0: .
-- Если created_at нового врача старше даты прогона — запись уже была: проверить, тот ли человек.
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

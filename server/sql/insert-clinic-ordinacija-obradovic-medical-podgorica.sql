-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija Obradović Medical (Podgorica) — клиника + врач
-- Щитовидная железа, ядерная медицина. Один врач — основатель.
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-obradovic-medical-podgorica.sql
-- Затем: server/sql/insert-clinic-ordinacija-obradovic-medical-podgorica-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://obradovicmedical.me/ — одностраничный сайт, сырой HTML curl'ом:
--     «O ordinaciji» (био врача), «Šta mi to radimo» (перечень услуг), «Kontakti».
--   * https://obradovicmedical.me/Cjenovnik_Obradovic_jun_2026.pdf — скан, 1 страница
--     (услуги — в отдельном файле).
--   * data/google-places/podgorica/ordinacija-obradovic-medical.json — place_id,
--     координаты, телефон (Google НЕ перезапрашивался).
--
-- Сверка фактов:
--   * Адрес: сайт «Ulica 4. jula 56a, Zgrada Euro Pact-a, Zabjelo»; Google «56a 4. Jul,
--     Podgorica». Совпадают. Почтового индекса нет ни там, ни там — не заполняем.
--   * Координаты 42.4280788 / 19.2586901 — Google; ссылка «PRIKAŽI PUTANJU» на сайте
--     ведёт на 42.42818, 19.2587905 — то же здание.
--   * Телефоны: сайт +382 20/651-116, +382 63/22-01-22, +382 67/37-80-37; Google
--     подтверждает +382 63 220 122.
--   * Email, Facebook, Instagram — блок «Kontakti» и футер сайта.
--   * Логотип — img/medical220.png (круглый знак «Ordinacija Obradović Medical»).
--   * Часы: «Ponedjeljak - Srijeda od 10:00 do 20:00h; Petak od 10:00 do 20:00h;
--     Pauza: 15:30-16:30h; Četvrtak i dani vikenda su neradni dani».
--
-- На сайте есть шаблонные заглушки (раздел «Team»: «Jenn Gwapa, CEO / Founder», галерея
-- «Logo Design / Branding») — игнорируются. Объявление «neće raditi 4-10 MAJ i 1-7 JUN
-- 2026» — разовое, в часы не переносится. «Preko 2150 zadovoljnih klijenata» — оценочное,
-- в описание не идёт.
--
-- Тип клиники: POLYCLINIC (1) — решение юзера (ENDOCRINOLOGY_CLINIC нет в публичном фильтре).
-- Языки клиники: только SR.
-- Идемпотентно и самоисправляющееся (как insert-clinic-radio-medic.sql).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ2ZTShGXrTRMRLnoTvuA3lrg';
SET @clinic_slug = 'ordinacija-obradovic-medical-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr = 'Ordinacija Obradović Medical' LIMIT 1));

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
	'Ordinacija Obradović Medical',
	'Ординација Obradović Medical', -- латинский бренд «Obradović Medical» не транслитерируем
	'Кабинет Obradović Medical',
	'4. jula 56a, zgrada Euro Pact, Zabjelo',
	'4. јула 56а, зграда Euro Pact, Забјело',
	'',
	'',
	'',
	42.42807880,
	19.25869010,
	'+38220651116;+38263220122;+38267378037',
	'obradovicmedical@gmail.com',
	'https://obradovicmedical.me/',
	'facebook.com/obradovicmedical',
	'@obradovicmedical',
	'',
	'',
	'',
	'https://obradovicmedical.me/img/medical220.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Ординација Obradović Medical', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Кабинет Obradović Medical', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', '4. jula 56a, zgrada Euro Pact, Zabjelo', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', '4. јула 56а, зграда Euro Pact, Забјело', address_sr_cyrl),
	latitude        = COALESCE(latitude, 42.42807880),
	longitude       = COALESCE(longitude, 19.25869010),
	phone           = IF(phone IS NULL OR phone = '', '+38220651116;+38263220122;+38267378037', phone),
	email           = IF(email IS NULL OR email = '', 'obradovicmedical@gmail.com', email),
	website         = IF(website IS NULL OR website = '', 'https://obradovicmedical.me/', website),
	facebook        = IF(facebook IS NULL OR facebook = '', 'facebook.com/obradovicmedical', facebook),
	instagram       = IF(instagram IS NULL OR instagram = '', '@obradovicmedical', instagram),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://obradovicmedical.me/img/medical220.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись (правки из админки вносить сюда).
UPDATE clinics SET
	description_sr = 'Privatna ordinacija u Podgorici posvećena bolestima štitaste žlijezde, u ulici 4. jula 56a (zgrada Euro Pact), Zabjelo. Radi od 15. oktobra 2019. godine; osnovao ju je dr Mlađen Obradović, specijalista nuklearne medicine. Ordinacija se bavi dijagnostikom i liječenjem hipertireoze i hipotireoze. Radi ultrazvučne preglede štitaste žlijezde i vrata (paraštitaste i pljuvačne žlijezde, limfni čvorovi vrata) sa kolor dopler analizom i TIRADS procjenom čvorova, ultrazvuk abdomena i urotrakta i kolor dopler krvnih sudova vrata, ruku i nogu. Izvodi ultrazvučno vođenu aspiracionu punkciju (FNAB) štitaste žlijezde i skleroziranje cista štitaste žlijezde sterilnim alkoholom. Priprema pacijente za operaciju štitaste žlijezde i za liječenje terapijskom dozom joda I-131, prati pacijente nakon operacije karcinoma štitaste žlijezde i nudi konsultacije putem interneta i drugo mišljenje. Radi ponedjeljkom, utorkom, srijedom i petkom od 10 do 20 časova, sa pauzom od 15:30 do 16:30; četvrtkom i vikendom ne radi.',
	description_sr_cyrl = 'Приватна ординација у Подгорици посвећена болестима штитасте жлијезде, у улици 4. јула 56а (зграда Euro Pact), Забјело. Ради од 15. октобра 2019. године; основао ју је др Млађен Обрадовић, специјалиста нуклеарне медицине. Ординација се бави дијагностиком и лијечењем хипертиреозе и хипотиреозе. Ради ултразвучне прегледе штитасте жлијезде и врата (параштитасте и пљувачне жлијезде, лимфни чворови врата) са колор доплер анализом и TIRADS процјеном чворова, ултразвук абдомена и уротракта и колор доплер крвних судова врата, руку и ногу. Изводи ултразвучно вођену аспирациону пункцију (FNAB) штитасте жлијезде и склерозирање циста штитасте жлијезде стерилним алкохолом. Припрема пацијенте за операцију штитасте жлијезде и за лијечење терапијском дозом јода I-131, прати пацијенте након операције карцинома штитасте жлијезде и нуди консултације путем интернета и друго мишљење. Ради понедјељком, уторком, сриједом и петком од 10 до 20 часова, са паузом од 15:30 до 16:30; четвртком и викендом не ради.',
	description_ru = 'Частный кабинет в Подгорице, специализирующийся на заболеваниях щитовидной железы, по адресу ул. 4. jula 56a (здание Euro Pact), район Забьело. Работает с 15 октября 2019 года; основан доктором Младженом Обрадовичем, специалистом по ядерной медицине. Кабинет занимается диагностикой и лечением гипертиреоза и гипотиреоза. Проводит УЗИ щитовидной железы и шеи (паращитовидные и слюнные железы, лимфатические узлы шеи) с цветным допплеровским картированием и оценкой узлов по TIRADS, УЗИ брюшной полости и мочевыводящих путей, цветное допплеровское исследование сосудов шеи, рук и ног. Выполняет тонкоигольную аспирационную биопсию (FNAB) щитовидной железы под контролем УЗИ и склерозирование кист щитовидной железы стерильным спиртом. Готовит пациентов к операции на щитовидной железе и к лечению терапевтической дозой йода I-131, наблюдает пациентов после операции по поводу рака щитовидной железы, проводит онлайн-консультации и даёт второе мнение. Работает в понедельник, вторник, среду и пятницу с 10:00 до 20:00, перерыв с 15:30 до 16:30; в четверг и выходные закрыт.',
	description_en = 'A private practice in Podgorica dedicated to thyroid disease, at 4. jula 56a (Euro Pact building), Zabjelo. It has been open since 15 October 2019 and was founded by Dr Mlađen Obradović, a specialist in nuclear medicine. The practice diagnoses and treats hyperthyroidism and hypothyroidism. It performs ultrasound of the thyroid and neck (parathyroid and salivary glands, cervical lymph nodes) with colour Doppler analysis and TIRADS scoring of nodules, abdominal and urinary tract ultrasound, and colour Doppler of the blood vessels of the neck, arms and legs. It carries out ultrasound-guided fine needle aspiration biopsy (FNAB) of the thyroid and sclerotherapy of thyroid cysts with sterile alcohol. It prepares patients for thyroid surgery and for treatment with a therapeutic dose of radioactive iodine I-131, follows up patients after thyroid cancer surgery, and offers online consultations and second opinions. Open Monday, Tuesday, Wednesday and Friday from 10:00 to 20:00 with a break from 15:30 to 16:30; closed on Thursdays and at weekends.',
	description_de = 'Eine private Praxis in Podgorica für Erkrankungen der Schilddrüse, in der 4. jula 56a (Gebäude Euro Pact), Zabjelo. Sie ist seit dem 15. Oktober 2019 geöffnet und wurde von Dr. Mlađen Obradović, Facharzt für Nuklearmedizin, gegründet. Die Praxis diagnostiziert und behandelt Hyper- und Hypothyreose. Sie führt Ultraschalluntersuchungen der Schilddrüse und des Halses (Nebenschilddrüsen, Speicheldrüsen, Halslymphknoten) mit Farbdoppler-Analyse und TIRADS-Bewertung von Knoten durch, außerdem Ultraschall von Abdomen und Harntrakt sowie Farbdoppler der Blutgefäße von Hals, Armen und Beinen. Sie bietet die ultraschallgesteuerte Feinnadelaspiration (FNAB) der Schilddrüse und die Sklerosierung von Schilddrüsenzysten mit sterilem Alkohol an. Patienten werden auf Schilddrüsenoperationen und auf die Behandlung mit einer therapeutischen Dosis Radiojod I-131 vorbereitet und nach Operationen wegen Schilddrüsenkrebs nachbetreut; außerdem gibt es Online-Konsultationen und Zweitmeinungen. Geöffnet Montag, Dienstag, Mittwoch und Freitag von 10:00 bis 20:00 Uhr mit Pause von 15:30 bis 16:30 Uhr; donnerstags und am Wochenende geschlossen.',
	description_tr = 'Podgorica''da, 4. jula 56a (Euro Pact binası), Zabjelo adresinde bulunan, tiroid hastalıklarına odaklanan özel muayenehane. 15 Ekim 2019''dan beri hizmet vermektedir; nükleer tıp uzmanı Dr. Mlađen Obradović tarafından kurulmuştur. Muayenehanede hipertiroidi ve hipotiroidinin tanı ve tedavisi yapılır. Tiroid ve boyun ultrasonu (paratiroid ve tükürük bezleri, boyun lenf düğümleri) renkli Doppler analizi ve nodüllerin TIRADS değerlendirmesiyle, karın ve idrar yolu ultrasonu ile boyun, kol ve bacak damarlarının renkli Doppler incelemesi yapılır. Ultrason eşliğinde tiroid ince iğne aspirasyon biyopsisi (FNAB) ve tiroid kistlerinin steril alkolle skleroterapisi uygulanır. Hastalar tiroid ameliyatına ve terapötik dozda radyoaktif iyot I-131 tedavisine hazırlanır, tiroid kanseri ameliyatı sonrası takip edilir; ayrıca çevrim içi konsültasyon ve ikinci görüş hizmeti sunulur. Pazartesi, salı, çarşamba ve cuma günleri 10:00-20:00 arası açık, 15:30-16:30 arası öğle arası; perşembe ve hafta sonları kapalı.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 — решение юзера 2026-10-08 (ENDOCRINOLOGY_CLINIC = 20 нет в
-- FILTERABLE_CLINIC_TYPES). Самоисправление: снимаем 20, если его поставила первая версия файла.
DELETE FROM clinic_clinic_types WHERE clinic_id = @clinic_id AND clinic_type_id = 20;
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация, только SR (1).
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

-- Пн, вт, ср, пт 10:00–20:00 с перерывом 15:30–16:30; чт, сб, вс закрыто.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "15:30"}, {"start": "16:30", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "15:30"}, {"start": "16:30", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "15:30"}, {"start": "16:30", "end": "20:00"}]}',
	'{"type": "closed"}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "15:30"}, {"start": "16:30", "end": "20:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTOR
-- dr Mlađen Obradović — specijalista nuklearne medicine (88). Язык: SR.
-- Фото: img/dmladjo.jpg из блока «O ordinaciji» (портрет врача).
-- Из био НЕ перенесены дата и место рождения и школа (личные данные, к практике
-- не относятся). В отзыве на сайте он назван «ljekar onkolog KCCG» — это слова
-- пациентки, онкологию как специальность не ставим.
-- ═══════════════════════════════════════════════════════════════
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mlađen Obradović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Obradović Mlađen' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mladjen-obradovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mladjen-obradovic', 'Mlađen Obradović', 'Млађен Обрадовић', 'Младжен Обрадович', 'Mladjen Obradovic', 'Dr',
	'https://obradovicmedical.me/img/dmladjo.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista nuklearne medicine sa više od 25 godina stručne prakse u nuklearnoj medicini i tiroidologiji. Medicinski fakultet završio je u Novom Sadu, a specijalizaciju iz nuklearne medicine na VMA u Beogradu. Od januara 1991. do maja 2008. radio je u Institutu za štitastu žlijezdu i metabolizam „Čigota” na Zlatiboru, gdje je od 2000. do 2008. bio zamjenik direktora. Od maja 2008. do oktobra 2019. bio je načelnik Centra za nuklearnu medicinu Kliničkog centra Crne Gore. U oktobru 2019. osnovao je ordinaciju Obradović Medical u Podgorici.',
	description_sr_cyrl = 'Специјалиста нуклеарне медицине са више од 25 година стручне праксе у нуклеарној медицини и тироидологији. Медицински факултет завршио је у Новом Саду, а специјализацију из нуклеарне медицине на VMA у Београду. Од јануара 1991. до маја 2008. радио је у Институту за штитасту жлијезду и метаболизам „Чигота” на Златибору, гдје је од 2000. до 2008. био замјеник директора. Од маја 2008. до октобра 2019. био је начелник Центра за нуклеарну медицину Клиничког центра Црне Горе. У октобру 2019. основао је ординацију Obradović Medical у Подгорици.',
	description_ru = 'Специалист по ядерной медицине с более чем 25-летним опытом в ядерной медицине и тиреоидологии. Окончил медицинский факультет в Нови-Саде, специализацию по ядерной медицине прошёл в Военно-медицинской академии (VMA) в Белграде. С января 1991 по май 2008 года работал в Институте щитовидной железы и метаболизма «Чигота» на Златиборе, где в 2000–2008 годах был заместителем директора. С мая 2008 по октябрь 2019 года руководил Центром ядерной медицины Клинического центра Черногории. В октябре 2019 года основал кабинет Obradović Medical в Подгорице.',
	description_en = 'A specialist in nuclear medicine with more than 25 years of practice in nuclear medicine and thyroidology. He graduated from the Faculty of Medicine in Novi Sad and completed his residency in nuclear medicine at the Military Medical Academy (VMA) in Belgrade. From January 1991 to May 2008 he worked at the Institute for Thyroid Gland and Metabolism “Čigota” on Zlatibor, serving as deputy director from 2000 to 2008. From May 2008 to October 2019 he was head of the Centre for Nuclear Medicine at the Clinical Centre of Montenegro. In October 2019 he founded the Obradović Medical practice in Podgorica.',
	description_de = 'Facharzt für Nuklearmedizin mit mehr als 25 Jahren Berufserfahrung in Nuklearmedizin und Thyreoidologie. Er studierte Medizin in Novi Sad und absolvierte die Facharztausbildung in Nuklearmedizin an der Militärmedizinischen Akademie (VMA) in Belgrad. Von Januar 1991 bis Mai 2008 arbeitete er am Institut für Schilddrüse und Stoffwechsel „Čigota“ auf dem Zlatibor, von 2000 bis 2008 als stellvertretender Direktor. Von Mai 2008 bis Oktober 2019 leitete er das Zentrum für Nuklearmedizin des Klinischen Zentrums Montenegros. Im Oktober 2019 gründete er die Praxis Obradović Medical in Podgorica.',
	description_tr = 'Nükleer tıp ve tiroidoloji alanında 25 yılı aşkın deneyime sahip nükleer tıp uzmanı. Tıp fakültesini Novi Sad''da bitirmiş, nükleer tıp uzmanlığını Belgrad''daki Askeri Tıp Akademisi''nde (VMA) tamamlamıştır. Ocak 1991''den Mayıs 2008''e kadar Zlatibor''daki “Čigota” Tiroid ve Metabolizma Enstitüsü''nde çalışmış, 2000-2008 yılları arasında enstitünün müdür yardımcılığını yapmıştır. Mayıs 2008''den Ekim 2019''a kadar Karadağ Klinik Merkezi Nükleer Tıp Merkezi''nin başkanıydı. Ekim 2019''da Podgorica''da Obradović Medical muayenehanesini kurmuştur.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 88);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Osnivač ordinacije');

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '1'
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается: пн/вт/ср/пт два интервала, чт/сб/вс closed
SELECT clinic_id, monday, thursday, friday, sunday FROM clinic_working_hours WHERE clinic_id = @clinic_id;

-- Ожидается 1 врач: mladjen-obradovic, specialties 88, photo ok.
SELECT d.id, d.slug, d.name_sr, d.professional_title,
	GROUP_CONCAT(DISTINCT ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	dc.position, d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position;

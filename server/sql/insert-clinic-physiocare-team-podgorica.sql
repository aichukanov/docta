-- ═══════════════════════════════════════════════════════════════════════════
-- PhysioCare Team (Podgorica) — клиника + физиотерапевты
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-physiocare-team-podgorica.sql
-- Затем: server/sql/insert-clinic-physiocare-team-podgorica-services.sql
-- Запись импорта: data/clinic-imports/physiocare-team-podgorica.json. Подволна 2d, агент T.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://physiocareteam.me/ — самописный PHP: главная, /o-nama, /kontakt, 12 страниц услуг/техник,
--     /tamara-mijanovic, /iva-tomkovic, /mitar-adrovic (на личных страницах только звание, блоки «O meni» пустые).
--     © 2026, даты обновления нет. Цен нет нигде. Пункты Scolio art (Deformiteti kičmenog stuba, Pregled i analiza
--     posture, Schroth metoda, Edukacija roditelja) — пункты меню без страниц. /neurocinetic — заглушка «Tekst».
--   * data/google-places/podgorica/physiocare-team.json — place_id, координаты 42.4394885 / 19.2318547,
--     телефон +382 69 204 224, «Lamela 3/1 Vojvode Maša Đurovića» (Google не перезапрашивался, отзывов 0).
-- 
-- Телефон: на сайте видимый текст «+382 (0)69 204 224», но ссылка tel:+38269223024 — заведён номер, совпадающий с Google.
-- Название: Google «PhysioCare Team», сайт «PhysioCare» (studio / ambulanta), домен physiocareteam.me.
-- Индекс 81000 — Podgorica (CITY_POSTAL_CODES). Языки клиники: только SR.
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ5QD3ZCfrTRMR9QOV5UrtnyM';
SET @clinic_slug = 'physiocare-team-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('PhysioCare Team', 'PhysioCare', 'Physio Care') AND city_id = 1 LIMIT 1));

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
	'PhysioCare Team',
	'PhysioCare Team',
	'PhysioCare Team',
	'Vojvode Maša Đurovića, Lamela L3-1',
	'Војводе Маша Ђуровића, Ламела Л3-1',
	'',
	'',
	'81000',
	42.43948850,
	19.23185470,
	'+38269204224',
	'info@physiocareteam.me',
	'https://physiocareteam.me/',
	'facebook.com/PhysioCarestudio',
	'',
	'',
	'',
	'',
	'https://physiocareteam.me/img/physiocare-logo.svg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.43948850, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.23185470, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'PhysioCare Team', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'PhysioCare Team', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vojvode Maša Đurovića, Lamela L3-1', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Војводе Маша Ђуровића, Ламела Л3-1', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269204224', phone),
	email = IF(email IS NULL OR email = '', 'info@physiocareteam.me', email),
	website = IF(website IS NULL OR website = '', 'https://physiocareteam.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/PhysioCarestudio', facebook),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://physiocareteam.me/img/physiocare-logo.svg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Studio za fizikalnu terapiju, rehabilitaciju i posturalnu korekciju u Podgorici, na adresi Vojvode Maša Đurovića, Lamela L3-1, osnovan jula 2015. godine. Tim čine visokoobrazovani fizioterapeuti — osnovne i specijalističke studije završili su na Fakultetu primijenjene fizioterapije u Igalu, a radili su u državnoj praksi i na projektima za djecu sa smetnjama u razvoju i osobe sa multiplom sklerozom; dvije specijalistkinje fizioterapije su Schroth BSPTS terapeuti. Rad počinje fizioterapeutskom procjenom: anamneza, analiza posture, aktivne i pasivne pokretljivosti i snage mišića, ortopedski, neurološki i funkcionalni testovi. U ponudi su fizikalna terapija (elektroterapija — TNS, dijadinamičke i interferentne struje, galvanizacija, elektrostimulacija — magnetoterapija, terapijski ultrazvuk i laser, krioterapija, termoterapija), kineziterapija, medicinski fitnes individualno i u malim grupama od 2 do 4 člana, vježbe za trudnice i fizioterapeutska masaža, kao i posebne tehnike: Mulligan, Kinematic tape, Neurocinetic, PNF, miofascijalno opuštanje trigger tačaka i dry needling (suva punkcija). Posebna pažnja posvećuje se posturalnim disbalansima i deformitetima kičmenog stuba kod djece — program Scolio art: pregled i analiza posture, Schroth metoda i edukacija roditelja. Za firme postoji program PhysioCare office sa edukacijom zaposlenih, konsultacijama i tretmanima tokom radnog vremena. Radno vrijeme: ponedjeljak–petak od 8 do 21 h, pauze 12:00–12:30 i 16:00–16:30.',
	description_sr_cyrl = 'Студио за физикалну терапију, рехабилитацију и постуралну корекцију у Подгорици, на адреси Војводе Маша Ђуровића, Ламела Л3-1, основан јула 2015. године. Тим чине високообразовани физиотерапеути — основне и специјалистичке студије завршили су на Факултету примијењене физиотерапије у Игалу, а радили су у државној пракси и на пројектима за дјецу са сметњама у развоју и особе са мултиплом склерозом; двије специјалисткиње физиотерапије су Schroth BSPTS терапеути. Рад почиње физиотерапеутском процјеном: анамнеза, анализа постуре, активне и пасивне покретљивости и снаге мишића, ортопедски, неуролошки и функционални тестови. У понуди су физикална терапија (електротерапија — TNS, дијадинамичке и интерферентне струје, галванизација, електростимулација — магнетотерапија, терапијски ултразвук и ласер, криотерапија, термотерапија), кинезитерапија, медицински фитнес индивидуално и у малим групама од 2 до 4 члана, вјежбе за труднице и физиотерапеутска масажа, као и посебне технике: Mulligan, Kinematic tape, Neurocinetic, PNF, миофасцијално опуштање триггер тачака и dry needling (сува пункција). Посебна пажња посвећује се постуралним дисбалансима и деформитетима кичменог стуба код дјеце — програм Scolio art: преглед и анализа постуре, Schroth метода и едукација родитеља. За фирме постоји програм PhysioCare office са едукацијом запослених, консултацијама и третманима током радног времена. Радно вријеме: понедјељак–петак од 8 до 21 х, паузе 12:00–12:30 и 16:00–16:30.',
	description_ru = 'Студия физиотерапии, реабилитации и коррекции осанки в Подгорице, по адресу Vojvode Maša Đurovića, Lamela L3-1, основана в июле 2015 года. В команде — физиотерапевты с высшим образованием: базовое обучение и специализацию они прошли на факультете прикладной физиотерапии в Игало, работали в государственной системе и в проектах для детей с нарушениями развития и людей с рассеянным склерозом; два специалиста по физиотерапии — терапевты Schroth BSPTS. Работа начинается с физиотерапевтической оценки: сбор анамнеза, анализ осанки, активной и пассивной подвижности и силы мышц, ортопедические, неврологические и функциональные тесты. Доступны физиотерапия (электротерапия — TNS, диадинамические и интерференционные токи, гальванизация, электростимуляция, — магнитотерапия, терапевтический ультразвук и лазер, криотерапия, термотерапия), кинезиотерапия, медицинский фитнес индивидуально и в мини-группах по 2–4 человека, упражнения для беременных и физиотерапевтический массаж, а также специальные техники: Mulligan, Kinematic tape, Neurocinetic, PNF, миофасциальное расслабление триггерных точек и dry needling (сухая пункция). Особое внимание уделяется нарушениям осанки и деформациям позвоночника у детей — программа Scolio art: осмотр и анализ осанки, метод Шрота и обучение родителей. Для компаний есть программа PhysioCare office: обучение сотрудников, консультации и процедуры в рабочее время. Часы работы: понедельник–пятница с 8 до 21, перерывы 12:00–12:30 и 16:00–16:30.',
	description_en = 'A studio for physical therapy, rehabilitation and postural correction in Podgorica, at Vojvode Maša Đurovića, Lamela L3-1, founded in July 2015. The team consists of university-educated physiotherapists who completed their undergraduate and specialist studies at the Faculty of Applied Physiotherapy in Igalo and worked in the public health system and on projects for children with developmental disabilities and people with multiple sclerosis; two specialists in physiotherapy are Schroth BSPTS therapists. Treatment starts with a physiotherapy assessment: medical history, analysis of posture, active and passive mobility and muscle strength, and orthopaedic, neurological and functional tests. Services include physical therapy (electrotherapy — TNS, diadynamic and interferential currents, galvanisation, electrical stimulation — magnetotherapy, therapeutic ultrasound and laser, cryotherapy, thermotherapy), kinesiotherapy, medical fitness individually and in small groups of 2–4 people, exercises for pregnant women and physiotherapy massage, as well as special techniques: Mulligan, Kinematic tape, Neurocinetic, PNF, myofascial trigger point release and dry needling. Particular attention is paid to postural imbalances and spinal deformities in children — the Scolio art programme: posture examination and analysis, the Schroth method and parent education. For companies there is the PhysioCare office programme with staff education, consultations and treatments during working hours. Opening hours: Monday–Friday 8:00–21:00, breaks 12:00–12:30 and 16:00–16:30.',
	description_de = 'Ein Studio für Physiotherapie, Rehabilitation und Haltungskorrektur in Podgorica, Vojvode Maša Đurovića, Lamela L3-1, gegründet im Juli 2015. Das Team besteht aus akademisch ausgebildeten Physiotherapeuten, die Grund- und Fachstudium an der Fakultät für angewandte Physiotherapie in Igalo absolviert und im öffentlichen Gesundheitswesen sowie in Projekten für Kinder mit Entwicklungsstörungen und Menschen mit Multipler Sklerose gearbeitet haben; zwei Fachphysiotherapeutinnen sind Schroth-BSPTS-Therapeutinnen. Die Behandlung beginnt mit einer physiotherapeutischen Befundung: Anamnese, Analyse von Haltung, aktiver und passiver Beweglichkeit und Muskelkraft sowie orthopädische, neurologische und funktionelle Tests. Angeboten werden physikalische Therapie (Elektrotherapie — TNS, diadynamische und Interferenzströme, Galvanisation, Elektrostimulation — Magnetfeldtherapie, therapeutischer Ultraschall und Laser, Kryotherapie, Thermotherapie), Bewegungstherapie, medizinisches Fitness einzeln und in Kleingruppen von 2–4 Personen, Schwangerschaftsgymnastik und physiotherapeutische Massage sowie spezielle Techniken: Mulligan, Kinematic Tape, Neurocinetic, PNF, myofasziale Triggerpunkt-Behandlung und Dry Needling. Besonderes Augenmerk gilt Haltungsschwächen und Wirbelsäulendeformitäten bei Kindern — Programm Scolio art: Untersuchung und Haltungsanalyse, Schroth-Methode und Elternschulung. Für Unternehmen gibt es das Programm PhysioCare office mit Mitarbeiterschulung, Beratung und Behandlungen während der Arbeitszeit. Öffnungszeiten: Montag–Freitag 8–21 Uhr, Pausen 12:00–12:30 und 16:00–16:30.',
	description_tr = 'Podgorica''da, Vojvode Maša Đurovića, Lamela L3-1 adresinde, Temmuz 2015''te kurulmuş fizik tedavi, rehabilitasyon ve postür düzeltme stüdyosu. Ekip, lisans ve uzmanlık eğitimini Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nde tamamlamış, kamu sağlık sisteminde ve gelişimsel bozukluğu olan çocuklar ile multipl skleroz hastalarına yönelik projelerde çalışmış üniversite mezunu fizyoterapistlerden oluşur; iki fizyoterapi uzmanı Schroth BSPTS terapistidir. Tedavi fizyoterapi değerlendirmesiyle başlar: anamnez, postür, aktif ve pasif hareketlilik ve kas gücü analizi, ortopedik, nörolojik ve fonksiyonel testler. Fizik tedavi (elektroterapi — TNS, diadinamik ve enterferansiyel akımlar, galvanizasyon, elektrostimülasyon — manyetoterapi, terapötik ultrason ve lazer, kriyoterapi, termoterapi), kinezyoterapi, bireysel ve 2–4 kişilik küçük gruplarda medikal fitness, hamile egzersizleri ve fizyoterapi masajının yanı sıra özel teknikler sunulur: Mulligan, Kinematic tape, Neurocinetic, PNF, miyofasyal tetik nokta gevşetme ve dry needling. Çocuklarda postür bozuklukları ve omurga deformitelerine özel önem verilir — Scolio art programı: postür muayenesi ve analizi, Schroth yöntemi ve ebeveyn eğitimi. Şirketler için çalışan eğitimi, danışmanlık ve mesai saatinde tedavi içeren PhysioCare office programı vardır. Çalışma saatleri: pazartesi–cuma 8:00–21:00, molalar 12:00–12:30 ve 16:00–16:30.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24 (как fizio-pg-podgorica, axon-fizikalna-terapija-podgorica).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: подвал всех страниц «Radno vrijeme: Ponedjeljak - Petak 8h do 21h, Pauza: 12:00 do 12:30 i 16:00 do 16:30». Сб/Вс не названы → closed.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "12:00"}, {"start": "12:30", "end": "16:00"}, {"start": "16:30", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "12:00"}, {"start": "12:30", "end": "16:00"}, {"start": "16:30", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "12:00"}, {"start": "12:30", "end": "16:00"}, {"start": "16:30", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "12:00"}, {"start": "12:30", "end": "16:00"}, {"start": "16:30", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "08:00", "end": "12:00"}, {"start": "12:30", "end": "16:00"}, {"start": "16:30", "end": "21:00"}]}',
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
-- PART 3: DOCTORS (3)
-- ═══════════════════════════════════════════════════════════════
-- Физиотерапевты — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врачи), как в fizio-pg-podgorica.
-- Источник: главная «Upoznajte fizioterapeutski tim PhysioCare» + личные страницы (там только звание, био пустые → описаний нет).
-- Все трое в БД не найдены (локаль, прод-API 204) — новые. Языки: 1 = SR (другие не заявлены). Фото — внешние URL сайта (200).

-- ───────────────────────────────────────────────────────────────
-- Tamara Mijanović — «spec. Fizioterapije - Schroth BSPTS terapeut»; /tamara-mijanovic: «Specijalizovane oblasti: Schroth BSPTS terapeut».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Tamara Mijanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Mijanović Tamara' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'tamara-mijanovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tamara-mijanovic', 'Tamara Mijanović', 'Тамара Мијановић', 'Тамара Миянович', 'Tamara Mijanovic', NULL,
	'https://physiocareteam.me/images/web/team/tamara-447x400.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://physiocareteam.me/images/web/team/tamara-447x400.jpg', photo_url) WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista fizioterapije, Schroth BSPTS terapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Iva Tomković — «spec. Fizioterapije - Schroth BSPTS terapeut».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Iva Tomković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Tomković Iva' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'iva-tomkovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'iva-tomkovic', 'Iva Tomković', 'Ива Томковић', 'Ива Томкович', 'Iva Tomkovic', NULL,
	'https://physiocareteam.me/images/web/team/iva--447x400.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://physiocareteam.me/images/web/team/iva--447x400.jpg', photo_url) WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista fizioterapije, Schroth BSPTS terapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Mitar Adrović — «Bečelor prim. fizioterapije». Тёзок-фамилий в БД (Oliver/Alma/Denis Adrović) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mitar Adrović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Adrović Mitar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mitar-adrovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mitar-adrovic', 'Mitar Adrović', 'Митар Адровић', 'Митар Адрович', 'Mitar Adrovic', NULL,
	'https://physiocareteam.me/images/web/team/mitar--477x400.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://physiocareteam.me/images/web/team/mitar--477x400.jpg', photo_url) WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Bečelor primijenjene fizioterapije')
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

-- Ожидается 3: tamara-mijanovic (94), iva-tomkovic (94), mitar-adrovic (94).
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

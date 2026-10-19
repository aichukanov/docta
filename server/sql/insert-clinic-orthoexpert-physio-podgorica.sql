-- ═══════════════════════════════════════════════════════════════════════════
-- OrthoExpert Physio Podgorica — клиника + врачи (ортопедия, физиатрия, физиотерапия)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-orthoexpert-physio-podgorica.sql
-- Затем: server/sql/insert-clinic-orthoexpert-physio-podgorica-services.sql
--
-- Источники (собрано 2026-10-08, сырой HTML curl'ом):
--   * https://www.orthoexpert.me/ — общий сайт сербской сети OrthoExpert (Beograd, Niš,
--     Podgorica). Берётся ТОЛЬКО филиал в Подгорице.
--   * /o-nama/lekari-fizioterapeuti (фильтр «Podgorica») и профили врачей.
--   * /cenovnik — блок «Ordinacija OrthoExpert Physio Podgorica» (услуги в отдельном файле).
--   * data/google-places/podgorica/orthoexpert-physio-podgorica.json — place_id,
--     координаты, адрес, телефон (Google НЕ перезапрашивался).
--
-- Сверка фактов:
--   * Адрес: сайт «Ankarski bulevar 35 L1, Podgorica», Google «Ankarski bulevar,
--     35 Lamela 1, Podgorica 81101» — совпадают. Почтовый индекс 81101 — из Google.
--   * Телефон: сайт «(068) 107-241», Google +382 68 107 241 — совпадают.
--   * Email office@orthoexpert.me — футер всех страниц, строка «Podgorica».
--   * Координаты 42.439211 / 19.2399208 — только Google.
--
-- Чего НЕТ (не заполняем):
--   * facebook / instagram: соцсети в футере (r.orthoexpert.rs/facebook, /instagram)
--     редиректят на аккаунты Белграда (OrthoExpertBeograd, orthoexpert_beograd).
--   * Часы работы Подгорицы: openingHours в JSON-LD («Mo-Fr 09:00-17:00») относится
--     к Белграду (address Svetog Save 32/8). Для Подгорицы часов на сайте нет.
--   * Логотип — общий логотип сети (logo-300x60.png из JSON-LD), отдельного у
--     филиала нет.
--
-- Языки клиники: только SR. У сайта есть /en/, но приём на других языках не заявлен.
--
-- Идемпотентно и самоисправляющееся: повторный прогон не плодит дублей, не трогает
-- непустые поля существующей клиники; description_* клиники и НОВЫХ врачей
-- пишутся безусловно (правки из админки следующий прогон перезатрёт — вносить сюда).
-- У Sonja Nejkov (запись из импорта КЦЦГ) дозаполняются только пустые поля.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJhfDvLo_rTRMRosr6ahUrUwI';
SET @clinic_slug = 'orthoexpert-physio-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr = 'OrthoExpert Physio Podgorica' LIMIT 1));

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
	'OrthoExpert Physio Podgorica',
	'OrthoExpert Physio Подгорица', -- латинский бренд не транслитерируем
	'OrthoExpert Physio Подгорица',
	'Ankarski bulevar 35, lamela 1',
	'Анкарски булевар 35, ламела 1',
	'',
	'',
	'81101',
	42.43921100,
	19.23992080,
	'+38268107241',
	'office@orthoexpert.me',
	'https://www.orthoexpert.me/',
	'', -- соцсети сети ведут на белградские аккаунты
	'',
	'',
	'',
	'',
	'https://www.orthoexpert.me/images/_system/logo-300x60.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'OrthoExpert Physio Подгорица', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'OrthoExpert Physio Подгорица', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Ankarski bulevar 35, lamela 1', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Анкарски булевар 35, ламела 1', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81101', postal_code),
	latitude        = COALESCE(latitude, 42.43921100),
	longitude       = COALESCE(longitude, 19.23992080),
	phone           = IF(phone IS NULL OR phone = '', '+38268107241', phone),
	email           = IF(email IS NULL OR email = '', 'office@orthoexpert.me', email),
	website         = IF(website IS NULL OR website = '', 'https://www.orthoexpert.me/', website),
	logo_url        = IF(logo_url IS NULL OR logo_url = '', 'https://www.orthoexpert.me/images/_system/logo-300x60.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что сайт пишет о себе и о филиале
-- (прайс Подгорицы, состав врачей, способы оплаты). Превосходные степени не переносятся.
UPDATE clinics SET
	description_sr = 'Ordinacija za ortopediju, fizijatriju i fizikalnu terapiju u Podgorici, na adresi Ankarski bulevar 35, lamela 1. Dio je mreže OrthoExpert, koja ima ordinacije i u Beogradu i Nišu. U Podgorici primaju ortoped-traumatolog, fizijatar i fizioterapeut. Ordinacija obavlja specijalističke i subspecijalističke preglede, ultrazvučne preglede i blokade pod kontrolom ultrazvuka, intraartikularnu primjenu hijalurona, preoperativnu i postoperativnu rehabilitaciju i fizikalnu terapiju sa klasičnim fizikalnim agensima, SIS i TECAR terapijom. Tu su i individualna kineziterapija, uključujući vježbe po Schroth metodi, shockwave terapija, kineziotejping, akupunktura, manuelna i aparaturna limfna drenaža, terapeutske masaže i TECAR Beauty tretmani lica, vrata i dekoltea. Plaćanje je moguće gotovinom, platnim karticama i uplatom na račun.',
	description_sr_cyrl = 'Ординација за ортопедију, физијатрију и физикалну терапију у Подгорици, на адреси Анкарски булевар 35, ламела 1. Дио је мреже OrthoExpert, која има ординације и у Београду и Нишу. У Подгорици примају ортопед-трауматолог, физијатар и физиотерапеут. Ординација обавља специјалистичке и субспецијалистичке прегледе, ултразвучне прегледе и блокаде под контролом ултразвука, интраартикуларну примјену хијалурона, преоперативну и постоперативну рехабилитацију и физикалну терапију са класичним физикалним агенсима, SIS и TECAR терапијом. Ту су и индивидуална кинезитерапија, укључујући вјежбе по Schroth методи, shockwave терапија, кинезиотејпинг, акупунктура, мануелна и апаратурна лимфна дренажа, терапеутске масаже и TECAR Beauty третмани лица, врата и деколтеа. Плаћање је могуће готовином, платним картицама и уплатом на рачун.',
	description_ru = 'Кабинет ортопедии, физиатрии и физиотерапии в Подгорице, по адресу Ankarski bulevar 35, ламела 1. Входит в сеть OrthoExpert, у которой есть кабинеты также в Белграде и Нише. В Подгорице принимают ортопед-травматолог, физиатр и физиотерапевт. Здесь проводят осмотры специалистов и узких специалистов, УЗИ и блокады под контролем УЗИ, внутрисуставное введение гиалуроновой кислоты, предоперационную и послеоперационную реабилитацию и физиотерапию с классическими физическими факторами, SIS- и TECAR-терапией. Также доступны индивидуальная кинезиотерапия, в том числе упражнения по методу Шрота, ударно-волновая терапия, кинезиотейпирование, акупунктура, ручной и аппаратный лимфодренаж, лечебный массаж и процедуры TECAR Beauty для лица, шеи и зоны декольте. Оплата наличными, банковскими картами и переводом на счёт.',
	description_en = 'An orthopaedics, physiatry and physical therapy practice in Podgorica, at Ankarski bulevar 35, lamela 1. It is part of the OrthoExpert network, which also has practices in Belgrade and Niš. In Podgorica, patients are seen by an orthopaedic trauma surgeon, a physiatrist and a physiotherapist. The practice offers specialist and subspecialist consultations, ultrasound examinations and ultrasound-guided blocks, intra-articular hyaluronic acid injections, pre- and postoperative rehabilitation, and physical therapy with conventional physical agents, SIS and TECAR therapy. Also available are individual kinesiotherapy, including Schroth method exercises, shockwave therapy, kinesio taping, acupuncture, manual and device-assisted lymphatic drainage, therapeutic massages and TECAR Beauty treatments for the face, neck and décolletage. Payment is accepted in cash, by card or by bank transfer.',
	description_de = 'Eine Praxis für Orthopädie, physikalische Medizin und Physiotherapie in Podgorica, Ankarski bulevar 35, lamela 1. Sie gehört zum Netzwerk OrthoExpert, das auch Praxen in Belgrad und Niš betreibt. In Podgorica behandeln ein Orthopäde und Unfallchirurg, eine Fachärztin für physikalische Medizin und eine Physiotherapeutin. Angeboten werden fachärztliche und subspezialisierte Untersuchungen, Ultraschalluntersuchungen und ultraschallgesteuerte Blockaden, intraartikuläre Hyaluronsäure-Injektionen, prä- und postoperative Rehabilitation sowie physikalische Therapie mit klassischen physikalischen Anwendungen, SIS- und TECAR-Therapie. Dazu kommen Einzel-Bewegungstherapie einschließlich Übungen nach der Schroth-Methode, Stoßwellentherapie, Kinesio-Taping, Akupunktur, manuelle und apparative Lymphdrainage, therapeutische Massagen sowie TECAR-Beauty-Behandlungen für Gesicht, Hals und Dekolleté. Bezahlt werden kann bar, mit Karte oder per Überweisung.',
	description_tr = 'Podgorica''da, Ankarski bulevar 35, lamela 1 adresinde bulunan ortopedi, fiziksel tıp ve fizik tedavi muayenehanesi. Belgrad ve Niş''te de muayenehaneleri olan OrthoExpert ağının bir parçasıdır. Podgorica''da bir ortopedi ve travmatoloji uzmanı, bir fiziksel tıp uzmanı ve bir fizyoterapist hasta kabul etmektedir. Muayenehanede uzman ve yan dal uzmanı muayeneleri, ultrason incelemeleri ve ultrason eşliğinde blokajlar, eklem içi hyaluronik asit enjeksiyonu, ameliyat öncesi ve sonrası rehabilitasyon ile klasik fiziksel ajanlar, SIS ve TECAR terapisiyle fizik tedavi uygulanır. Ayrıca Schroth yöntemi egzersizleri dahil bireysel kinezyoterapi, şok dalga tedavisi, kinezyo bantlama, akupunktur, manuel ve cihazla lenf drenajı, terapötik masajlar ile yüz, boyun ve dekolte için TECAR Beauty uygulamaları sunulur. Ödeme nakit, kart veya banka havalesiyle yapılabilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES & LANGUAGES
-- ═══════════════════════════════════════════════════════════════

-- ORTHOPEDIC_CLINIC = 22, PHYSIOTHERAPY_CLINIC = 24 (как health-clinic-cg-podgorica, spa-medica-podgorica)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 22), (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE, только SR (1).
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

-- Рабочее время НЕ заполняется: для Подгорицы на сайте его нет (см. шапку).

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Источник: /o-nama/lekari-fizioterapeuti, фильтр «Podgorica» — ровно три человека.
-- Специальности: 17 = ORTHOPEDICS_TRAUMATOLOGY, 42 = PHYSICAL_MEDICINE_REHABILITATION,
--                94 = PHYSIOTHERAPY. Языки: 1 = SR (другие не заявлены).
-- Личные цены не заводятся: прайс разбит по рангу врача (specijalista /
-- subspecijalista / profesor / inostrani konsultant), а не по именам.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr med Srđan Živanović — ortoped / ortopedski hirurg / traumatolog
-- Принимает в Beograd, Niš, Podgorica (карточка на /lekari-fizioterapeuti).
-- В шапке профиля фото /images/team/srdjan-zivanovic.webp.
-- Из био НЕ перенесено: «najbolji ortoped u Srbiji…» (оценочное).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Srđan Živanović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Živanović Srđan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'srdjan-zivanovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-zivanovic', 'Srđan Živanović', 'Срђан Живановић', 'Срджан Живанович', 'Srdjan Zivanovic', 'Dr med',
	'https://www.orthoexpert.me/images/team/srdjan-zivanovic.webp', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Ortoped i ortopedski hirurg, specijalista ortopedije od 2002. godine. Od 2008. bavi se prvenstveno hirurgijom ramena i lakta: pokriva kompletnu patologiju ramena i lakta, primjenjuje otvorene hirurške metode i artroskopiju ramena i lakta, ugrađuje kompletne, djelimične i reverzne proteze ramena i bavi se traumatologijom ramena i lakta kod djece i odraslih. U oblasti hirurgije ramena i lakta izveo je više od 4500 operativnih zahvata. Radi na Odjeljenju ortopedije i traumatologije Regionalne bolnice u Viborgu (Danska), na Klinici za rame i lakat; od 2019. je načelnik Odjeljenja za hirurgiju ramena i lakta, a od 2020. klinički lektor iz ortopedije na Medicinskom fakultetu Univerziteta u Aarhusu. Godinu dana (2014) usavršavao se na Klinici za ortopediju ramena i lakta Univerzitetske bolnice u Aalborgu. Član je danskog udruženja za rame i lakat i Udruženja za rame i lakat Srbije i osnivač udruženja OrthoExpert Education, koje organizuje kurseve ultrazvuka ramena i lakta i fizikalne terapije kod bolesti ramena u Srbiji i Crnoj Gori. Prima pacijente u ordinacijama OrthoExpert u Beogradu, Nišu i Podgorici.',
	description_sr_cyrl = 'Ортопед и ортопедски хирург, специјалиста ортопедије од 2002. године. Од 2008. бави се првенствено хирургијом рамена и лакта: покрива комплетну патологију рамена и лакта, примјењује отворене хируршке методе и артроскопију рамена и лакта, уграђује комплетне, дјелимичне и реверзне протезе рамена и бави се трауматологијом рамена и лакта код дјеце и одраслих. У области хирургије рамена и лакта извео је више од 4500 оперативних захвата. Ради на Одјељењу ортопедије и трауматологије Регионалне болнице у Виборгу (Данска), на Клиници за раме и лакат; од 2019. је начелник Одјељења за хирургију рамена и лакта, а од 2020. клинички лектор из ортопедије на Медицинском факултету Универзитета у Аархусу. Годину дана (2014) усавршавао се на Клиници за ортопедију рамена и лакта Универзитетске болнице у Аалборгу. Члан је данског удружења за раме и лакат и Удружења за раме и лакат Србије и оснивач удружења OrthoExpert Education, које организује курсеве ултразвука рамена и лакта и физикалне терапије код болести рамена у Србији и Црној Гори. Прима пацијенте у ординацијама OrthoExpert у Београду, Нишу и Подгорици.',
	description_ru = 'Ортопед и ортопедический хирург, специалист по ортопедии с 2002 года. С 2008 года занимается прежде всего хирургией плеча и локтя: охватывает всю патологию плечевого и локтевого суставов, применяет открытые хирургические методы и артроскопию плеча и локтя, устанавливает тотальные, частичные и реверсивные эндопротезы плечевого сустава, занимается травматологией плеча и локтя у детей и взрослых. Выполнил более 4500 операций в области хирургии плеча и локтя. Работает в отделении ортопедии и травматологии Региональной больницы Виборга (Дания), в клинике плеча и локтя; с 2019 года руководит отделением хирургии плеча и локтя, с 2020 года — клинический преподаватель ортопедии на медицинском факультете Орхусского университета. В 2014 году год стажировался в клинике ортопедии плеча и локтя Университетской больницы Ольборга. Член Датского общества плеча и локтя и Сербской ассоциации плеча и локтя, основатель ассоциации OrthoExpert Education, которая проводит курсы УЗИ плеча и локтя и физиотерапии при заболеваниях плеча в Сербии и Черногории. Принимает пациентов в кабинетах OrthoExpert в Белграде, Нише и Подгорице.',
	description_en = 'An orthopaedic surgeon, specialist in orthopaedics since 2002. Since 2008 his main field has been shoulder and elbow surgery: he covers the full range of shoulder and elbow pathology, uses both open surgical techniques and shoulder and elbow arthroscopy, performs total, partial and reverse shoulder replacements, and treats shoulder and elbow trauma in children and adults. He has performed more than 4,500 shoulder and elbow operations. He works at the Department of Orthopaedics and Traumatology of Regional Hospital Viborg (Denmark), in the Shoulder and Elbow Clinic; since 2019 he has headed its Shoulder and Elbow Surgery Unit, and since 2020 he has been a clinical lecturer in orthopaedics at the Faculty of Health, Aarhus University. In 2014 he spent a year of further training at the Shoulder and Elbow Orthopaedic Clinic of Aalborg University Hospital. He is a member of the Danish Shoulder and Elbow Society and the Serbian Shoulder and Elbow Association, and the founder of OrthoExpert Education, which runs courses in shoulder and elbow ultrasound and in physical therapy for shoulder disorders in Serbia and Montenegro. He sees patients at the OrthoExpert practices in Belgrade, Niš and Podgorica.',
	description_de = 'Orthopäde und orthopädischer Chirurg, Facharzt für Orthopädie seit 2002. Seit 2008 liegt sein Schwerpunkt auf der Schulter- und Ellenbogenchirurgie: Er deckt das gesamte Spektrum der Schulter- und Ellenbogenerkrankungen ab, wendet offene Operationsverfahren sowie die Schulter- und Ellenbogenarthroskopie an, implantiert totale, partielle und inverse Schulterprothesen und behandelt Verletzungen von Schulter und Ellenbogen bei Kindern und Erwachsenen. Er hat mehr als 4500 Eingriffe an Schulter und Ellenbogen durchgeführt. Er arbeitet in der Abteilung für Orthopädie und Traumatologie des Regionalkrankenhauses Viborg (Dänemark) in der Schulter- und Ellenbogenklinik; seit 2019 leitet er dort die Abteilung für Schulter- und Ellenbogenchirurgie, seit 2020 ist er klinischer Dozent für Orthopädie an der Medizinischen Fakultät der Universität Aarhus. 2014 bildete er sich ein Jahr lang an der Klinik für Schulter- und Ellenbogenorthopädie des Universitätskrankenhauses Aalborg fort. Er ist Mitglied der dänischen Schulter- und Ellenbogengesellschaft und der serbischen Schulter- und Ellenbogenvereinigung sowie Gründer des Vereins OrthoExpert Education, der in Serbien und Montenegro Kurse zum Ultraschall von Schulter und Ellenbogen und zur Physiotherapie bei Schultererkrankungen veranstaltet. Er empfängt Patienten in den OrthoExpert-Praxen in Belgrad, Niš und Podgorica.',
	description_tr = '2002''den beri ortopedi uzmanı olan ortopedi cerrahı. 2008''den bu yana ana alanı omuz ve dirsek cerrahisidir: omuz ve dirsek hastalıklarının tamamıyla ilgilenir, açık cerrahi yöntemler ile omuz ve dirsek artroskopisi uygular, total, parsiyel ve ters omuz protezleri takar, çocuklarda ve yetişkinlerde omuz ve dirsek travmalarını tedavi eder. Omuz ve dirsek cerrahisi alanında 4500''den fazla ameliyat yapmıştır. Viborg Bölge Hastanesi (Danimarka) Ortopedi ve Travmatoloji Bölümü''nün Omuz ve Dirsek Kliniği''nde çalışmaktadır; 2019''dan beri Omuz ve Dirsek Cerrahisi Birimi''nin başkanı, 2020''den beri Aarhus Üniversitesi Tıp Fakültesi''nde ortopedi klinik öğretim görevlisidir. 2014''te bir yıl boyunca Aalborg Üniversite Hastanesi Omuz ve Dirsek Ortopedi Kliniği''nde eğitim almıştır. Danimarka Omuz ve Dirsek Derneği ile Sırbistan Omuz ve Dirsek Derneği üyesidir ve Sırbistan ile Karadağ''da omuz ve dirsek ultrasonu ve omuz hastalıklarında fizik tedavi kursları düzenleyen OrthoExpert Education derneğinin kurucusudur. Belgrad, Niş ve Podgorica''daki OrthoExpert muayenehanelerinde hasta kabul etmektedir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 17);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Prim. dr Sonja Nejkov — fizijatar / spec. fizikalne medicine i rehabilitacije
-- УЖЕ В БАЗЕ: slug sonja-nejkov (локально id 2702), импорт состава КЦЦГ 2026-10-06,
-- KCCG «Centar za fizikalnu medicinu i rehabilitaciju, direktorica». Профиль на
-- orthoexpert.me называет то же место работы и должность — это тот же человек.
-- Только привязка + дозаполнение пустых полей (фото, описания). professional_title
-- в базе «Dr», сайт пишет «Prim. dr» — не перезаписываем (см. openQuestions).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'sonja-nejkov' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Sonja Nejkov' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Nejkov Sonja' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sonja-nejkov', 'Sonja Nejkov', 'Соња Нејков', 'Соня Нейков', 'Sonja Nejkov', 'Prim. dr',
	'https://www.orthoexpert.me/images/team/sonja-nejkov.webp', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.orthoexpert.me/images/team/sonja-nejkov.webp', photo_url)
WHERE id = @doctor_id;

UPDATE doctors SET
	description_sr = IF(description_sr IS NULL OR description_sr = '', 'Specijalista fizikalne medicine i rehabilitacije i subspecijalista medicine bola. Stalno je zaposlena u Kliničkom centru Crne Gore, gdje je direktorica Centra za fizikalnu medicinu i rehabilitaciju; nakon renoviranja Centra 2023. godine vodi njegovu modernizaciju, u okviru koje je Centar dobio novu opremu i infrastrukturu. Prije toga radila je u privatnoj i akademskoj praksi, na procjeni i terapiji složenih tegoba mišićno-koštanog sistema i pratećih bolova. Medicinski fakultet završila je u Nišu, a specijalizaciju iz fizikalne medicine i rehabilitacije u Kliničkom centru Crne Gore. Autor je i koautor naučnih radova iz kardiopulmonalne rehabilitacije (rana postoperativna terapija nakon kardiohirurških intervencija), neurorehabilitacije nakon moždanog udara i akutnih neuroloških stanja i prevencije padova i liječenja pacijenata sa dijabetičkom polineuropatijom. U radu ističe individualne planove rehabilitacije i smjernice za samostalan nastavak oporavka.', description_sr),
	description_sr_cyrl = IF(description_sr_cyrl IS NULL OR description_sr_cyrl = '', 'Специјалиста физикалне медицине и рехабилитације и субспецијалиста медицине бола. Стално је запослена у Клиничком центру Црне Горе, гдје је директорица Центра за физикалну медицину и рехабилитацију; након реновирања Центра 2023. године води његову модернизацију, у оквиру које је Центар добио нову опрему и инфраструктуру. Прије тога радила је у приватној и академској пракси, на процјени и терапији сложених тегоба мишићно-коштаног система и пратећих болова. Медицински факултет завршила је у Нишу, а специјализацију из физикалне медицине и рехабилитације у Клиничком центру Црне Горе. Аутор је и коаутор научних радова из кардиопулмоналне рехабилитације (рана постоперативна терапија након кардиохируршких интервенција), неурорехабилитације након можданог удара и акутних неуролошких стања и превенције падова и лијечења пацијената са дијабетичком полинеуропатијом. У раду истиче индивидуалне планове рехабилитације и смјернице за самосталан наставак опоравка.', description_sr_cyrl),
	description_ru = IF(description_ru IS NULL OR description_ru = '', 'Специалист по физической медицине и реабилитации, субспециалист по медицине боли. Работает в Клиническом центре Черногории, где возглавляет Центр физической медицины и реабилитации; после реконструкции Центра в 2023 году руководит его модернизацией, в ходе которой Центр получил новое оборудование и инфраструктуру. До этого работала в частной и академической практике, занималась оценкой и лечением сложных нарушений опорно-двигательного аппарата и сопутствующей боли. Окончила медицинский факультет в Нише, специализацию по физической медицине и реабилитации прошла в Клиническом центре Черногории. Автор и соавтор научных работ по кардиопульмональной реабилитации (ранняя послеоперационная терапия после кардиохирургических вмешательств), нейрореабилитации после инсульта и острых неврологических состояний, профилактике падений и лечению пациентов с диабетической полинейропатией. В работе делает упор на индивидуальные планы реабилитации и рекомендации для самостоятельного продолжения восстановления.', description_ru),
	description_en = IF(description_en IS NULL OR description_en = '', 'A specialist in physical medicine and rehabilitation and a subspecialist in pain medicine. She is permanently employed at the Clinical Centre of Montenegro, where she is director of the Centre for Physical Medicine and Rehabilitation; after the Centre was renovated in 2023 she has led its modernisation, which brought new equipment and infrastructure. Before that she worked in private and academic practice, assessing and treating complex musculoskeletal problems and the pain that accompanies them. She graduated from the Faculty of Medicine in Niš and completed her residency in physical medicine and rehabilitation at the Clinical Centre of Montenegro. She is the author and co-author of research papers on cardiopulmonary rehabilitation (early postoperative therapy after cardiac surgery), neurorehabilitation after stroke and acute neurological conditions, and fall prevention and treatment of patients with diabetic polyneuropathy. Her work emphasises individual rehabilitation plans and guidance for continuing recovery independently.', description_en),
	description_de = IF(description_de IS NULL OR description_de = '', 'Fachärztin für physikalische Medizin und Rehabilitation mit Subspezialisierung in Schmerzmedizin. Sie ist fest am Klinischen Zentrum Montenegros angestellt und leitet dort das Zentrum für physikalische Medizin und Rehabilitation; nach der Renovierung des Zentrums 2023 führt sie dessen Modernisierung, mit der das Zentrum neue Ausstattung und Infrastruktur erhielt. Zuvor war sie in privater und akademischer Praxis tätig und befasste sich mit der Beurteilung und Behandlung komplexer Beschwerden des Bewegungsapparats und begleitender Schmerzen. Sie studierte Medizin in Niš und absolvierte die Facharztausbildung in physikalischer Medizin und Rehabilitation am Klinischen Zentrum Montenegros. Sie ist Autorin und Mitautorin wissenschaftlicher Arbeiten zur kardiopulmonalen Rehabilitation (frühe postoperative Therapie nach herzchirurgischen Eingriffen), zur Neurorehabilitation nach Schlaganfall und akuten neurologischen Zuständen sowie zur Sturzprävention und Behandlung von Patienten mit diabetischer Polyneuropathie. In ihrer Arbeit setzt sie auf individuelle Rehabilitationspläne und Anleitungen zur selbstständigen Fortsetzung der Genesung.', description_de),
	description_tr = IF(description_tr IS NULL OR description_tr = '', 'Fiziksel tıp ve rehabilitasyon uzmanı, ağrı tıbbı yan dal uzmanı. Karadağ Klinik Merkezi''nde kadrolu olarak çalışmakta ve Fiziksel Tıp ve Rehabilitasyon Merkezi''nin direktörlüğünü yürütmektedir; Merkez''in 2023''teki yenilenmesinin ardından yeni ekipman ve altyapı kazandıran modernizasyon sürecini yönetmektedir. Daha önce özel ve akademik pratikte, kas-iskelet sisteminin karmaşık sorunlarının ve eşlik eden ağrıların değerlendirilmesi ve tedavisi üzerine çalışmıştır. Tıp fakültesini Niş''te bitirmiş, fiziksel tıp ve rehabilitasyon uzmanlığını Karadağ Klinik Merkezi''nde tamamlamıştır. Kardiyopulmoner rehabilitasyon (kalp cerrahisi sonrası erken postoperatif tedavi), inme ve akut nörolojik durumlar sonrası nörorehabilitasyon ile düşmelerin önlenmesi ve diyabetik polinöropatili hastaların tedavisi konularında bilimsel çalışmaların yazarı ve ortak yazarıdır. Çalışmalarında bireysel rehabilitasyon planlarına ve iyileşmenin bağımsız olarak sürdürülmesine yönelik yönlendirmelere önem verir.', description_tr)
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 42);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Jelena Klikovac — fizioterapeut (не врач: professional_title NULL, как у других
-- физиотерапевтов в базе со специальностью 94).
-- ⚠️ Степень расходится: карточка списка — «BSc primijenjene fizioterapije»,
-- шапка профиля — «master primijenjene fizioterapije». В описании уровень не указан.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jelena Klikovac' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Klikovac Jelena' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jelena-klikovac' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-klikovac', 'Jelena Klikovac', 'Јелена Кликовац', 'Елена Кликовац', 'Jelena Klikovac', NULL,
	'https://www.orthoexpert.me/images/team/jelena-klikovac.webp', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Fizioterapeut, diplomirala primijenjenu fizioterapiju. Specijalizovana je za primjenu elektroterapije i drugih procedura fizikalne terapije i za postoperativnu akutnu rehabilitaciju pacijenata.',
	description_sr_cyrl = 'Физиотерапеут, дипломирала примијењену физиотерапију. Специјализована је за примјену електротерапије и других процедура физикалне терапије и за постоперативну акутну рехабилитацију пацијената.',
	description_ru = 'Физиотерапевт с образованием в области прикладной физиотерапии. Специализируется на электротерапии и других процедурах физиотерапии, а также на ранней послеоперационной реабилитации пациентов.',
	description_en = 'A physiotherapist with a degree in applied physiotherapy. She specialises in electrotherapy and other physical therapy procedures and in acute postoperative rehabilitation.',
	description_de = 'Physiotherapeutin mit Abschluss in angewandter Physiotherapie. Sie ist auf Elektrotherapie und andere physiotherapeutische Verfahren sowie auf die akute postoperative Rehabilitation spezialisiert.',
	description_tr = 'Uygulamalı fizyoterapi alanında eğitim almış fizyoterapist. Elektroterapi ve diğer fizik tedavi uygulamaları ile ameliyat sonrası akut rehabilitasyon konusunda uzmanlaşmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '22,24'
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 3: srdjan-zivanovic (17), sonja-nejkov (42; created_at 2026-10-06 — КЦЦГ),
-- jelena-klikovac (94). Если created_at Živanović/Klikovac старше даты прогона —
-- врач уже был в базе: проверить, что это тот же человек.
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

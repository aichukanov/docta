-- ═══════════════════════════════════════════════════════════════════════════
-- Očna bolnica Oftalens Dr Koturović (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ocna-bolnica-oftalens-dr-koturovic-podgorica.sql
-- Затем: server/sql/insert-clinic-ocna-bolnica-oftalens-dr-koturovic-podgorica-services.sql
-- Запись импорта: data/clinic-imports/ocna-bolnica-oftalens-dr-koturovic-podgorica.json. Подволна 2d, агент V.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://drkoturovic.me/ — статический сайт, 7 страниц по sitemap.xml (index, onama, usluge, infozapacijente, faq, novosti, kontakt), © 2026.
--     Услуги — аккордеон usluge.html (14 пунктов + блок «Sočiva»: torična, multifokalna, EDOF). Цен нет.
--     Email на страницах пуст — собирается скриптом assets/theme/js/email.js: user «kotur», domain «t-com.me».
--   * data/google-places/podgorica/ocna-bolnica-oftalens-dr-koturovic.json — place_id, координаты 42.4353783 / 19.2636988,
--     +382 67 323 655, «C7P7+5F4, Bratstva i Jedinstva» (Google не перезапрашивался).
-- 
-- «Prihvatamo većinu velikih osiguravajućih planova» (infozapacijente) — в описание, без привязки страховых.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJHfHowEbrTRMRkoGZRCr1aVE';
SET @clinic_slug = 'ocna-bolnica-oftalens-dr-koturovic-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Očna bolnica Oftalens Dr Koturović', 'Oftalens Dr Koturović', 'Očna bolnica - Oftalens Dr Koturović', 'Oftalens') AND city_id = 1 LIMIT 1));

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
	'Očna bolnica Oftalens Dr Koturović',
	'Очна болница Офталенс Др Котуровић',
	'Глазная больница Oftalens Dr Koturović',
	'Stara varoš, blok 7 (Bratstva i Jedinstva bb, vojna zgrada)',
	'Стара варош, блок 7 (Братства и Јединства бб, војна зграда)',
	'',
	'',
	'81000',
	42.43537830,
	19.26369880,
	'+38267323655;+38269855909',
	'kotur@t-com.me',
	'https://drkoturovic.me/',
	'facebook.com/drKoturovic',
	'@oftalens_dr_koturovic',
	'',
	'',
	'',
	'https://drkoturovic.me/assets/images/favicon-navbar-black-480.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.43537830, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.26369880, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Очна болница Офталенс Др Котуровић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Глазная больница Oftalens Dr Koturović', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Stara varoš, blok 7 (Bratstva i Jedinstva bb, vojna zgrada)', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Стара варош, блок 7 (Братства и Јединства бб, војна зграда)', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267323655;+38269855909', phone),
	email = IF(email IS NULL OR email = '', 'kotur@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://drkoturovic.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/drKoturovic', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@oftalens_dr_koturovic', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://drkoturovic.me/assets/images/favicon-navbar-black-480.png', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Očna bolnica Oftalens Dr Koturović iz Podgorice pruža njegu očiju već više od 20 godina, spajajući najnoviju medicinsku tehnologiju sa brižnom njegom pacijenata. Savremena je očna bolnica sa fokusom na preciznu dijagnostiku, laserske zahvate i očnu hirurgiju. Usluge: OCT dijagnostika oka; operacija katarakte uz izbor intraokularnih sočiva (torična, multifokalna, EDOF); liječenje glaukoma — kapi, laser, operacija; određivanje dioptrije za naočare i kontaktna sočiva; operacije ablacije retine, žute mrlje i promjena u sklopu šećerne bolesti; pars plana vitrektomija; ultrazvučna dijagnostika oka (B-scan) i ultrazvučna biomikroskopija (UBM, A-scan); anti-VEGF injekcije; operacija pterigijuma; estetska hirurgija kapaka (blefaroplastika) i operacija čmička; laser fotokoagulacija. Na operaciju katarakte dolaze i pacijenti iz Budve i drugih gradova Crne Gore. Ordiniraju dr sci. med. Zoran Koturović i dr Haris Kujundžić, specijalisti oftalmologije. Bolnica prihvata većinu velikih osiguravajućih planova; plaćanje gotovinom, kreditnom karticom ili bankovnim transferom.',
	description_sr_cyrl = 'Очна болница Офталенс Др Котуровић из Подгорице пружа његу очију већ више од 20 година, спајајући најновију медицинску технологију са брижном његом пацијената. Савремена је очна болница са фокусом на прецизну дијагностику, ласерске захвате и очну хирургију. Услуге: OCT дијагностика ока; операција катаракте уз избор интраокуларних сочива (торична, мултифокална, EDOF); лијечење глаукома — капи, ласер, операција; одређивање диоптрије за наочаре и контактна сочива; операције аблације ретине, жуте мрље и промјена у склопу шећерне болести; парс плана витректомија; ултразвучна дијагностика ока (B-scan) и ултразвучна биомикроскопија (UBM, A-scan); anti-VEGF ињекције; операција птеригијума; естетска хирургија капака (блефаропластика) и операција чмичка; ласер фотокоагулација. На операцију катаракте долазе и пацијенти из Будве и других градова Црне Горе. Ординирају др сци. мед. Зоран Котуровић и др Харис Кујунџић, специјалисти офталмологије. Болница прихвата већину великих осигуравајућих планова; плаћање готовином, кредитном картицом или банковним трансфером.',
	description_ru = 'Глазная больница Oftalens Dr Koturović в Подгорице заботится о здоровье глаз более 20 лет, сочетая новейшие медицинские технологии с внимательным отношением к пациентам. Это современная глазная больница с акцентом на точную диагностику, лазерные вмешательства и глазную хирургию. Услуги: ОКТ-диагностика глаза; операция катаракты с выбором интраокулярных линз (торические, мультифокальные, EDOF); лечение глаукомы — капли, лазер, операция; подбор очков и контактных линз; операции при отслойке сетчатки, на макуле и при диабетических изменениях; витрэктомия pars plana; УЗИ глаза (B-скан) и ультразвуковая биомикроскопия (UBM, A-скан); анти-VEGF-инъекции; удаление птеригиума; эстетическая хирургия век (блефаропластика) и удаление ячменя; лазерная фотокоагуляция. На операцию катаракты приезжают пациенты из Будвы и других городов Черногории. Принимают д-р мед. наук Зоран Котурович и д-р Харис Куюнджич, офтальмологи. Больница принимает большинство крупных страховых программ; оплата наличными, кредитной картой или банковским переводом.',
	description_en = 'Oftalens Dr Koturović Eye Hospital in Podgorica has provided eye care for more than 20 years, combining the latest medical technology with attentive patient care. It is a modern eye hospital focused on precise diagnostics, laser procedures and eye surgery. Services: OCT eye diagnostics; cataract surgery with a choice of intraocular lenses (toric, multifocal, EDOF); glaucoma treatment — drops, laser, surgery; prescriptions for glasses and contact lenses; surgery for retinal detachment, macular disease and diabetic eye changes; pars plana vitrectomy; ocular ultrasound (B-scan) and ultrasound biomicroscopy (UBM, A-scan); anti-VEGF injections; pterygium surgery; aesthetic eyelid surgery (blepharoplasty) and stye surgery; laser photocoagulation. Patients from Budva and other Montenegrin towns come here for cataract surgery. Dr Sci. Med. Zoran Koturović and Dr Haris Kujundžić, specialists in ophthalmology, see patients. The hospital accepts most major insurance plans; payment in cash, by credit card or bank transfer.',
	description_de = 'Die Augenklinik Oftalens Dr Koturović in Podgorica betreut seit über 20 Jahren Patienten und verbindet modernste Medizintechnik mit zugewandter Patientenversorgung. Sie ist eine moderne Augenklinik mit Schwerpunkt auf präziser Diagnostik, Lasereingriffen und Augenchirurgie. Leistungen: OCT-Diagnostik; Kataraktoperation mit Auswahl an Intraokularlinsen (torisch, multifokal, EDOF); Glaukombehandlung — Tropfen, Laser, Operation; Bestimmung der Brillen- und Kontaktlinsenwerte; Operationen bei Netzhautablösung, Makulaerkrankungen und diabetischen Veränderungen; Pars-plana-Vitrektomie; Augenultraschall (B-Scan) und Ultraschallbiomikroskopie (UBM, A-Scan); Anti-VEGF-Injektionen; Pterygium-Operation; ästhetische Lidchirurgie (Blepharoplastik) und Gerstenkorn-Operation; Laserkoagulation. Zur Kataraktoperation kommen auch Patienten aus Budva und anderen Städten Montenegros. Es behandeln Dr. sc. med. Zoran Koturović und Dr. Haris Kujundžić, Fachärzte für Augenheilkunde. Die Klinik akzeptiert die meisten großen Versicherungstarife; Zahlung bar, per Kreditkarte oder Banküberweisung.',
	description_tr = 'Podgorica''daki Oftalens Dr Koturović Göz Hastanesi, en yeni tıbbi teknolojiyi özenli hasta bakımıyla birleştirerek 20 yılı aşkın süredir göz sağlığı hizmeti vermektedir. Hassas tanı, lazer işlemleri ve göz cerrahisine odaklanan modern bir göz hastanesidir. Hizmetler: OCT göz tanısı; göz içi lens seçenekli katarakt ameliyatı (torik, multifokal, EDOF); glokom tedavisi — damlalar, lazer, ameliyat; gözlük ve kontakt lens numarası belirleme; retina dekolmanı, makula hastalıkları ve diyabetik değişiklikler için ameliyatlar; pars plana vitrektomi; göz ultrasonu (B-scan) ve ultrason biyomikroskopi (UBM, A-scan); anti-VEGF enjeksiyonları; pterjiyum ameliyatı; estetik göz kapağı cerrahisi (blefaroplasti) ve arpacık ameliyatı; lazer fotokoagülasyon. Katarakt ameliyatı için Budva ve Karadağ''ın diğer şehirlerinden de hastalar gelir. Göz hastalıkları uzmanları Dr. Sci. Med. Zoran Koturović ve Dr. Haris Kujundžić hasta kabul eder. Hastane büyük sigorta planlarının çoğunu kabul eder; ödeme nakit, kredi kartı veya banka havalesiyle.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- OPHTHALMOLOGY_CLINIC = 9 (как dnevna-bolnica-optimal-podgorica, oftalmoloski-centar-dr-raonic-podgorica). «Očna bolnica» — дневной стационар, тип HOSPITAL (3) не ставим.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 9);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском (og:locale sr_ME), другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: все страницы и /kontakt.html — «Ponedjeljak - Petak: 10-14 h, 17-21 h» (две смены). Сб/Вс не названы → closed.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "14:00"}, {"start": "17:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "14:00"}, {"start": "17:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "14:00"}, {"start": "17:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "14:00"}, {"start": "17:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "14:00"}, {"start": "17:00", "end": "21:00"}]}',
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
-- PART 3: DOCTORS (2)
-- ═══════════════════════════════════════════════════════════════
-- Источник: /onama.html «Naše stručno osoblje» — 2 врача. Других сотрудников (оптометристов, сестёр) сайт не называет.

-- ───────────────────────────────────────────────────────────────
-- /onama.html: «Dr Zoran Koturović — Specijalista oftalmologije · Doktor medicinskih nauka … Od 2015. godine radi kao oftalmolog – očni hirurg u Dnevnoj bolnici za oftalmologiju OFTALENS DR KOTUROVIĆ».
-- В БД не найден (локаль: zoran-koturovic / koturovic-zoran нет; Zdenka Koturović — гинеколог, другой человек; прод-API 204) — новый.
-- 6 = OPHTHALMOLOGY + 81 = OPHTHALMIC_SURGERY («očni hirurg», «preko 8000 izvedenih operacija»). Титул «Doktor medicinskih nauka» → «Dr sci. med.».
-- Фото на сайте нет (onama.html — только общий кадр Oftalens-3.jpg).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Zoran Koturović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Koturović Zoran' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zoran-koturovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-koturovic', 'Zoran Koturović', 'Зоран Котуровић', 'Зоран Котурович', 'Zoran Koturovic', 'Dr sci. med.',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Specijalista oftalmologije, doktor medicinskih nauka. Oftalmološka znanja i iskustva sticao je u vodećim oftalmološkim centrima u Srbiji i inostranstvu, među kojima su Univerzitetska bolnica za oftalmologiju u Upsali (Švedska), Univerzitet Goethe u Frankfurtu na Majni (Njemačka), Klinički centar Ljubljana (Slovenija) i bolnica „Dr Agarwal“ u Čenaju (Indija). Profesionalni angažman u Crnoj Gori započeo je 1999. godine na Očnoj klinici „Kraljica Jelena“ na Cetinju, a od 2005. godine deset godina je radio u Kliničkom centru Crne Gore u Podgorici. Posebno se istakao u hirurgiji prednjeg segmenta oka i hirurgiji katarakte sa preko 8000 izvedenih operacija; fakoemulzifikaciju — savremenu operaciju katarakte ultrazvukom — među prvima je uveo kao rutinsku proceduru u Crnoj Gori. Od 2015. godine radi kao oftalmolog – očni hirurg u Dnevnoj bolnici za oftalmologiju Oftalens Dr Koturović. Član stručnih udruženja COFD, UOS, SOE, ESCRS, SEESO i AAO.',
	description_sr_cyrl = 'Специјалиста офталмологије, доктор медицинских наука. Офталмолошка знања и искуства стицао је у водећим офталмолошким центрима у Србији и иностранству, међу којима су Универзитетска болница за офталмологију у Упсали (Шведска), Универзитет Goethe у Франкфурту на Мајни (Њемачка), Клинички центар Љубљана (Словенија) и болница „Dr Agarwal“ у Ченају (Индија). Професионални ангажман у Црној Гори започео је 1999. године на Очној клиници „Краљица Јелена“ на Цетињу, а од 2005. године десет година је радио у Клиничком центру Црне Горе у Подгорици. Посебно се истакао у хирургији предњег сегмента ока и хирургији катаракте са преко 8000 изведених операција; факоемулзификацију — савремену операцију катаракте ултразвуком — међу првима је увео као рутинску процедуру у Црној Гори. Од 2015. године ради као офталмолог – очни хирург у Дневној болници за офталмологију Офталенс Др Котуровић. Члан стручних удружења COFD, UOS, SOE, ESCRS, SEESO и AAO.',
	description_ru = 'Офтальмолог, доктор медицинских наук. Опыт получал в ведущих офтальмологических центрах Сербии и за рубежом, в том числе в Университетской офтальмологической больнице Уппсалы (Швеция), Университете имени Гёте во Франкфурте-на-Майне (Германия), Клиническом центре Любляны (Словения) и больнице «Dr Agarwal» в Ченнаи (Индия). В Черногории начал работать в 1999 году в Глазной клинике «Королева Елена» в Цетине, с 2005 года десять лет работал в Клиническом центре Черногории в Подгорице. Особенно известен в хирургии переднего отрезка глаза и хирургии катаракты — более 8000 операций; одним из первых в Черногории ввёл факоэмульсификацию (современную ультразвуковую операцию катаракты) как рутинную процедуру. С 2015 года — офтальмолог и глазной хирург дневного стационара Oftalens Dr Koturović. Член профессиональных обществ COFD, UOS, SOE, ESCRS, SEESO и AAO.',
	description_en = 'Specialist in ophthalmology, Doctor of Medical Sciences. He gained his ophthalmological knowledge and experience at leading eye centres in Serbia and abroad, including the University Eye Hospital in Uppsala (Sweden), Goethe University in Frankfurt am Main (Germany), the Ljubljana Clinical Centre (Slovenia) and the Dr Agarwal hospital in Chennai (India). He began his career in Montenegro in 1999 at the "Kraljica Jelena" Eye Clinic in Cetinje and from 2005 worked for ten years at the Clinical Centre of Montenegro in Podgorica. He is particularly known for anterior segment and cataract surgery, with more than 8,000 operations performed, and was among the first to introduce phacoemulsification — modern ultrasound cataract surgery — as a routine procedure in Montenegro. Since 2015 he has worked as an ophthalmologist and eye surgeon at the Oftalens Dr Koturović day hospital for ophthalmology. Member of COFD, UOS, SOE, ESCRS, SEESO and AAO.',
	description_de = 'Facharzt für Augenheilkunde, Doktor der medizinischen Wissenschaften. Seine Kenntnisse und Erfahrungen erwarb er an führenden Augenzentren in Serbien und im Ausland, darunter die Universitätsaugenklinik Uppsala (Schweden), die Goethe-Universität Frankfurt am Main (Deutschland), das Klinische Zentrum Ljubljana (Slowenien) und das Dr-Agarwal-Krankenhaus in Chennai (Indien). In Montenegro begann er 1999 an der Augenklinik „Kraljica Jelena“ in Cetinje und arbeitete ab 2005 zehn Jahre am Klinischen Zentrum Montenegro in Podgorica. Besonders hervorgetreten ist er in der Vorderabschnitts- und Kataraktchirurgie mit über 8.000 Operationen; als einer der Ersten führte er die Phakoemulsifikation – die moderne Ultraschall-Kataraktoperation – in Montenegro als Routineverfahren ein. Seit 2015 arbeitet er als Augenarzt und Augenchirurg in der Tagesklinik für Augenheilkunde Oftalens Dr Koturović. Mitglied von COFD, UOS, SOE, ESCRS, SEESO und AAO.',
	description_tr = 'Göz hastalıkları uzmanı, tıp bilimleri doktoru. Bilgi ve deneyimini Sırbistan''daki ve yurt dışındaki önde gelen göz merkezlerinde edindi; bunlar arasında Uppsala Üniversite Göz Hastanesi (İsveç), Frankfurt am Main''daki Goethe Üniversitesi (Almanya), Ljubljana Klinik Merkezi (Slovenya) ve Chennai''deki Dr Agarwal hastanesi (Hindistan) bulunur. Karadağ''daki mesleki kariyerine 1999''da Cetinje''deki "Kraljica Jelena" Göz Kliniği''nde başladı; 2005''ten itibaren on yıl Podgorica''daki Karadağ Klinik Merkezi''nde çalıştı. Ön segment ve katarakt cerrahisinde 8.000''den fazla ameliyatla öne çıkar; fakoemülsifikasyonu (modern ultrasonik katarakt ameliyatı) Karadağ''da rutin işlem olarak ilk uygulayanlardandır. 2015''ten beri Oftalens Dr Koturović göz günübirlik hastanesinde göz hekimi ve göz cerrahı olarak çalışmaktadır. COFD, UOS, SOE, ESCRS, SEESO ve AAO üyesidir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 6), (@doctor_id, 81);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Osnivač, specijalista oftalmologije, očni hirurg')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- /onama.html: «Dr Haris Kujundžić — Specijalista oftalmologije … Na Klinici za očne bolesti Kliničkog centra Crne Gore radi od 2008. godine, gdje trenutno obavlja funkciju načelnika Odjeljenja oftalmohirurgije».
-- В БД есть: haris-kujundzic (локаль id 814, specialties 6,81, klinicki-centar-crne-gore-podgorica; прод-API 200) — тот же человек (КЦЦГ подтверждён сайтом) → привязка.
-- Описание — только если пусто (сейчас пусто). Фото на сайте нет.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'haris-kujundzic' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'haris-kujundzic', 'Haris Kujundžić', 'Харис Кујунџић', 'Харис Куюнджич', 'Haris Kujundzic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Врач уже в БД: дозаполнение пустых имён (ru/en), существующие не трогаем.
UPDATE doctors SET
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Харис Куюнджич', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Haris Kujundzic', name_en)
WHERE id = @doctor_id;

-- Врач уже в БД (другие клиники): описание по тексту сайта — только если пусто (description_sr), чужое не перезаписываем.
UPDATE doctors SET
	description_sr_cyrl = IF(description_sr IS NULL OR description_sr = '', 'Специјалиста офталмологије. Дипломирао је на Медицинском факултету Универзитета Црне Горе 2006. године као студент генерације. Специјалистички испит из офталмологије положио је 2012. године, а међународно признати испит International Council of Ophthalmology 2014. године. На Клиници за очне болести Клиничког центра Црне Горе ради од 2008. године, гдје обавља функцију начелника Одјељења офталмохирургије. Посебне области интересовања су хирургија катаракте и предњег сегмента ока, као и конзервативно и хируршко лијечење мрежњаче, жуте мрље и стакластог тијела. Професионално се усавршавао у Штокхолму, Бечу, Љубљани, Загребу, Београду и Ротердаму.', description_sr_cyrl),
	description_ru = IF(description_sr IS NULL OR description_sr = '', 'Офтальмолог. В 2006 году окончил медицинский факультет Университета Черногории как лучший студент своего выпуска. Специализацию по офтальмологии получил в 2012 году, а в 2014 году сдал международный экзамен International Council of Ophthalmology. С 2008 года работает в Клинике глазных болезней Клинического центра Черногории, где возглавляет отделение офтальмохирургии. Профессиональные интересы — хирургия катаракты и переднего отрезка глаза, а также консервативное и хирургическое лечение сетчатки, макулы и стекловидного тела. Стажировался в Стокгольме, Вене, Любляне, Загребе, Белграде и Роттердаме.', description_ru),
	description_en = IF(description_sr IS NULL OR description_sr = '', 'Specialist in ophthalmology. He graduated from the Faculty of Medicine of the University of Montenegro in 2006 as the best student of his year. He passed the specialist exam in ophthalmology in 2012 and the internationally recognised International Council of Ophthalmology exam in 2014. He has worked at the Eye Clinic of the Clinical Centre of Montenegro since 2008, where he heads the Department of Ophthalmic Surgery. His particular interests are cataract and anterior segment surgery and the conservative and surgical treatment of the retina, macula and vitreous. He has trained in Stockholm, Vienna, Ljubljana, Zagreb, Belgrade and Rotterdam.', description_en),
	description_de = IF(description_sr IS NULL OR description_sr = '', 'Facharzt für Augenheilkunde. Er schloss 2006 als Jahrgangsbester an der Medizinischen Fakultät der Universität Montenegro ab, legte 2012 die Facharztprüfung in Augenheilkunde und 2014 die international anerkannte Prüfung des International Council of Ophthalmology ab. Seit 2008 arbeitet er an der Augenklinik des Klinischen Zentrums Montenegro, wo er die Abteilung für Augenchirurgie leitet. Seine Schwerpunkte sind die Katarakt- und Vorderabschnittschirurgie sowie die konservative und chirurgische Behandlung von Netzhaut, Makula und Glaskörper. Fortbildungen absolvierte er in Stockholm, Wien, Ljubljana, Zagreb, Belgrad und Rotterdam.', description_de),
	description_tr = IF(description_sr IS NULL OR description_sr = '', 'Göz hastalıkları uzmanı. 2006''da Karadağ Üniversitesi Tıp Fakültesi''nden dönem birincisi olarak mezun oldu. 2012''de oftalmoloji uzmanlık sınavını, 2014''te uluslararası geçerli International Council of Ophthalmology sınavını geçti. 2008''den beri Karadağ Klinik Merkezi Göz Hastalıkları Kliniği''nde çalışmakta ve Göz Cerrahisi Bölümü''nün başkanlığını yürütmektedir. Özel ilgi alanları katarakt ve ön segment cerrahisi ile retina, makula ve vitreusun konservatif ve cerrahi tedavisidir. Stockholm, Viyana, Ljubljana, Zagreb, Belgrad ve Rotterdam''da mesleki eğitim aldı.', description_tr),
	description_sr = IF(description_sr IS NULL OR description_sr = '', 'Specijalista oftalmologije. Diplomirao je na Medicinskom fakultetu Univerziteta Crne Gore 2006. godine kao student generacije. Specijalistički ispit iz oftalmologije položio je 2012. godine, a međunarodno priznati ispit International Council of Ophthalmology 2014. godine. Na Klinici za očne bolesti Kliničkog centra Crne Gore radi od 2008. godine, gdje obavlja funkciju načelnika Odjeljenja oftalmohirurgije. Posebne oblasti interesovanja su hirurgija katarakte i prednjeg segmenta oka, kao i konzervativno i hirurško liječenje mrežnjače, žute mrlje i staklastog tijela. Profesionalno se usavršavao u Štokholmu, Beču, Ljubljani, Zagrebu, Beogradu i Roterdamu.', description_sr)
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 6), (@doctor_id, 81);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oftalmologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '9', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2: zoran-koturovic (6,81), haris-kujundzic (6,81).
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

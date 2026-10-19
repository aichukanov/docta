-- ═══════════════════════════════════════════════════════════════════════════
-- V Dental Centar Budva — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-v-dental-centar-budva.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/v-dental-centar-budva.json):
--   * https://www.vdental.me/ — Wix: /, /budva, /doktori, /usluge, страницы врачей (lastmod 2022-12-30).
--   * data/google-places/budva/v-dental-centar.json — place_id, координаты, телефон.
--
-- Филиал сети V Dental Centar; Podgorica — server/sql/insert-clinic-v-dental-centar-podgorica.sql.
-- Dr Aleksandar Vukotić («Ordinacija Podgorica/Budva») заводится/ищется в обоих файлах (find-or-create).
--
-- ⚠️ Адрес: сайт «Jadranski sajam bb, Tre canne, I sprat, Budva», Google — «Slovenska obala bb,
-- Будва 85315». Записан адрес сайта, координаты — точка места Google 42.286165 / 18.8428254.
-- Индекс: сайт пишет «Budva 30 000» (явная ошибка), Google 85315 — записан стандартный 85310,
-- как у остальных клиник Будвы в БД. Телефоны: сайт 067 455 838 + Google 033 455 838.
-- Email v.dentalbd@t-com.me — сайт. Описание: «osnovana je 2005 godine» (/budva) + /usluge.
--
-- Идемпотентно и самоисправляюще (см. файл Подгорицы).
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJg_lkyoTUTRMRCKjZP3Y_mxo';
SET @clinic_slug = 'v-dental-centar-budva';

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
	3, -- CityId.BUDVA
	'V Dental Centar Budva',
	'V Dental Центар (Будва)',
	'Стоматология V Dental Centar (Будва)',
	'Jadranski sajam bb, Tre canne, I sprat',
	'Јадрански сајам бб, Tre canne, I спрат',
	'',
	'',
	'85310',
	42.28616500,
	18.84282540,
	'+38267455838;+38233455838',
	'v.dentalbd@t-com.me',
	'https://www.vdental.me/',
	'',
	'',
	'',
	'',
	'',
	'https://static.wixstatic.com/media/1b0103_22391fcdbda64f518668910451ea564a.jpg',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'V Dental Центар (Будва)', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматология V Dental Centar (Будва)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Jadranski sajam bb, Tre canne, I sprat', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Јадрански сајам бб, Tre canne, I спрат', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85310', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267455838;+38233455838', phone),
	email = IF(email IS NULL OR email = '', 'v.dentalbd@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://www.vdental.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://static.wixstatic.com/media/1b0103_22391fcdbda64f518668910451ea564a.jpg', logo_url),
	latitude = COALESCE(latitude, 42.28616500),
	longitude = COALESCE(longitude, 18.84282540)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija V Dental Centar u Budvi, na Jadranskom sajmu (objekat Tre canne, prvi sprat), osnovana je 2005. godine; ustanova ima i ordinaciju u Podgorici. Pacijentima su na raspolaganju stomatolozi različitih specijalnosti koji zajedno sprovode plan terapije. Ordinacija pruža usluge oralne hirurgije, implantologije i kompjuterom vođene implantologije, protetike, Digital Smile Design, ortopedije vilica, estetske stomatologije, PRP i PRF tretmana, kao i dječije i preventivne stomatologije. Za dijagnostiku ustanova koristi ciljane, ortopantomografske i telerentgen snimke, kao i trodimenzionalni CBCT snimak vilica.',
	description_sr_cyrl = 'Стоматолошка ординација V Dental Centar у Будви, на Јадранском сајму (објекат Tre canne, први спрат), основана је 2005. године; установа има и ординацију у Подгорици. Пацијентима су на располагању стоматолози различитих специјалности који заједно спроводе план терапије. Ординација пружа услуге оралне хирургије, имплантологије и компјутером вођене имплантологије, протетике, Digital Smile Design, ортопедије вилица, естетске стоматологије, PRP и PRF третмана, као и дјечије и превентивне стоматологије. За дијагностику установа користи циљане, ортопантомографске и телерентген снимке, као и тродимензионални CBCT снимак вилица.',
	description_ru = 'Стоматологическая клиника V Dental Centar в Будве (Ядранский саем, здание Tre canne, второй этаж) открыта в 2005 году; у учреждения есть также клиника в Подгорице. Пациентов принимают стоматологи разных специальностей, которые совместно ведут план лечения. Здесь выполняют хирургическую стоматологию, имплантацию, в том числе навигационную, протезирование, Digital Smile Design, ортодонтию, эстетическую стоматологию, процедуры PRP и PRF, детскую и профилактическую стоматологию. Для диагностики учреждение использует прицельные снимки зубов, ортопантомограммы, телерентгенограммы и трёхмерную КЛКТ (CBCT).',
	description_en = 'V Dental Centar in Budva, at the Jadranski sajam complex (Tre canne building, first floor), was founded in 2005; the practice also has a clinic in Podgorica. Patients are treated by dentists of different specialities who carry out the treatment plan together. The clinic provides oral surgery, implantology including computer-guided implant placement, prosthodontics, Digital Smile Design, orthodontics, cosmetic dentistry, PRP and PRF treatments, and paediatric and preventive dentistry. Diagnostics include periapical, panoramic and cephalometric X-rays as well as 3D CBCT imaging of the jaws.',
	description_de = 'Die Zahnarztpraxis V Dental Centar in Budva im Komplex Jadranski sajam (Gebäude Tre canne, erster Stock) wurde 2005 gegründet; die Einrichtung betreibt auch eine Praxis in Podgorica. Die Patienten werden von Zahnärzten verschiedener Fachrichtungen betreut, die den Behandlungsplan gemeinsam umsetzen. Angeboten werden Oralchirurgie, Implantologie einschließlich computergeführter Implantation, Prothetik, Digital Smile Design, Kieferorthopädie, ästhetische Zahnmedizin, PRP- und PRF-Behandlungen sowie Kinder- und Präventivzahnheilkunde. Zur Diagnostik stehen Einzelzahn-, Panorama- und Fernröntgenaufnahmen sowie 3D-CBCT-Aufnahmen der Kiefer zur Verfügung.',
	description_tr = 'Budva''da Jadranski sajam kompleksindeki (Tre canne binası, birinci kat) V Dental Centar diş kliniği 2005''te kuruldu; kurumun Podgorica''da da bir kliniği vardır. Hastalar, tedavi planını birlikte yürüten farklı uzmanlık alanlarından diş hekimlerince karşılanır. Klinikte ağız cerrahisi, bilgisayar destekli implant uygulaması dahil implantoloji, protez, Digital Smile Design, ortodonti, estetik diş hekimliği, PRP ve PRF uygulamaları ile çocuk ve koruyucu diş hekimliği hizmetleri sunulur. Teşhiste periapikal, panoramik ve sefalometrik röntgenler ile 3D CBCT çene görüntülemesi kullanılır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт (me/en) не заявляет приём на других языках → только SR (LanguageId.SR = 1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Рабочее время (clinic_working_hours) НЕ заполняем: ни сайт, ни файл места Google его не публикуют.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (4)
-- Размещение по /doktori: «Ordinacija Budva» — Miladinović, Stanjević, Srzentić;
-- «Ordinacija Podgorica/Budva» — Vukotić. Состав /budva совпадает.
-- Специальности: 78 = DENTISTRY, 74 = ORAL_SURGERY, 93 = ORTHODONTIST. Языки: 1 = SR.
-- Все 4 — новые (локально и прод-API: 204). Сёстры (Jelena Rašković, Ana Martinović, Ana Jovanović,
-- Jelena Vujović) и техник Nenad Radosavović — не врачи, не заводятся.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Aleksandar Vukotić — specijalista oralne hirurgije (Ordinacija Podgorica/Budva)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Vukotić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vukotić Aleksandar' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aleksandar-vukotic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-vukotic', 'Aleksandar Vukotić', 'Александар Вукотић', 'Александр Вукотич', 'Aleksandar Vukotic', 'Dr',
	'https://static.wixstatic.com/media/1b0103_3990d1759d114665a86fad98875cf47a.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista oralne hirurgije, osnivač i vlasnik PZU „V Dental Centar“ u Podgorici i Budvi. Rođen je 1968. godine u Mostaru, a osnovnu i srednju školu završio je u Nikšiću. Diplomirao je na Stomatološkom fakultetu u Beogradu 1995. godine, gdje je 2004. završio i specijalističke studije iz oralne hirurgije. Iskustvo je sticao radom u zdravstvenim ustanovama u zemlji i inostranstvu; bavi se prvenstveno hirurgijom i implantologijom, a sa Straumann implantnim sistemom radi od 1999. godine.',
	description_sr_cyrl = 'Специјалиста оралне хирургије, оснивач и власник ПЗУ „V Dental Centar“ у Подгорици и Будви. Рођен је 1968. године у Мостару, а основну и средњу школу завршио је у Никшићу. Дипломирао је на Стоматолошком факултету у Београду 1995. године, гдје је 2004. завршио и специјалистичке студије из оралне хирургије. Искуство је стицао радом у здравственим установама у земљи и иностранству; бави се првенствено хирургијом и имплантологијом, а са Straumann имплантним системом ради од 1999. године.',
	description_ru = 'Специалист по хирургической стоматологии, основатель и владелец частного учреждения «V Dental Centar» в Подгорице и Будве. Родился в 1968 году в Мостаре, школу окончил в Никшиче. В 1995 году окончил стоматологический факультет в Белграде, где в 2004 году завершил специализацию по хирургической стоматологии. Опыт получил в медицинских учреждениях Черногории и за рубежом; занимается прежде всего хирургией и имплантологией, с имплантатами Straumann работает с 1999 года.',
	description_en = 'Oral surgery specialist, founder and owner of the private healthcare facility V Dental Centar in Podgorica and Budva. Born in 1968 in Mostar, he completed primary and secondary school in Nikšić. He graduated from the School of Dentistry in Belgrade in 1995 and completed his specialisation in oral surgery there in 2004. He gained experience in healthcare facilities in Montenegro and abroad; his work focuses on surgery and implantology, and he has worked with the Straumann implant system since 1999.',
	description_de = 'Facharzt für Oralchirurgie, Gründer und Inhaber der privaten Gesundheitseinrichtung V Dental Centar in Podgorica und Budva. Geboren 1968 in Mostar, besuchte er die Grund- und Mittelschule in Nikšić. 1995 schloss er das Zahnmedizinstudium in Belgrad ab, wo er 2004 auch die Fachausbildung in Oralchirurgie absolvierte. Berufserfahrung sammelte er in Gesundheitseinrichtungen im In- und Ausland; Schwerpunkt seiner Arbeit sind Chirurgie und Implantologie, mit dem Straumann-Implantatsystem arbeitet er seit 1999.',
	description_tr = 'Ağız cerrahisi uzmanı; Podgorica ve Budva''daki özel sağlık kuruluşu V Dental Centar''ın kurucusu ve sahibi. 1968''de Mostar''da doğdu, ilk ve ortaöğrenimini Nikšić''te tamamladı. 1995''te Belgrad Diş Hekimliği Fakültesinden mezun oldu ve 2004''te aynı yerde ağız cerrahisi uzmanlığını tamamladı. Mesleki deneyimini yurt içi ve yurt dışındaki sağlık kuruluşlarında edindi; ağırlıklı olarak cerrahi ve implantoloji ile ilgilenir, 1999''dan beri Straumann implant sistemiyle çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije; osnivač i vlasnik PZU „V Dental Centar“')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Bojan Miladinović — doktor stomatologije (Ordinacija Budva)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Bojan Miladinović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Miladinović Bojan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'bojan-miladinovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'bojan-miladinovic', 'Bojan Miladinović', 'Бојан Миладиновић', 'Боян Миладинович', 'Bojan Miladinovic', 'Dr',
	'https://static.wixstatic.com/media/1b0103_bf6b4da3a28a463c9b923ab1593fa590.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Doktor stomatologije. Rođen je 1985. godine u Nikšiću. Srednju medicinsku školu, smjer zubni tehničar, završio je u Podgorici, a osnovne akademske studije upisao je 2003. godine na Stomatološkom fakultetu u Foči (Univerzitet Istočno Sarajevo). Pripravnički staž odradio je u Nikšiću. U ordinaciji „V Dental Centar“ u Budvi radi od oktobra 2013. godine i redovno pohađa seminare i kurseve iz različitih oblasti stomatologije.',
	description_sr_cyrl = 'Доктор стоматологије. Рођен је 1985. године у Никшићу. Средњу медицинску школу, смјер зубни техничар, завршио је у Подгорици, а основне академске студије уписао је 2003. године на Стоматолошком факултету у Фочи (Универзитет Источно Сарајево). Приправнички стаж одрадио је у Никшићу. У ординацији „V Dental Centar“ у Будви ради од октобра 2013. године и редовно похађа семинаре и курсеве из различитих области стоматологије.',
	description_ru = 'Врач-стоматолог. Родился в 1985 году в Никшиче. Окончил медицинское училище в Подгорице по специальности «зубной техник», в 2003 году поступил на стоматологический факультет в Фоче (Университет Восточного Сараева). Интернатуру проходил в Никшиче. В клинике «V Dental Centar» в Будве работает с октября 2013 года, регулярно посещает семинары и курсы по разным разделам стоматологии.',
	description_en = 'Doctor of dental medicine. Born in 1985 in Nikšić, he completed secondary medical school in Podgorica as a dental technician and in 2003 enrolled at the Faculty of Dentistry in Foča (University of East Sarajevo). He completed his internship in Nikšić. He has worked at V Dental Centar in Budva since October 2013 and regularly attends seminars and courses in various fields of dentistry.',
	description_de = 'Zahnarzt. Geboren 1985 in Nikšić, absolvierte er die medizinische Mittelschule in Podgorica in der Fachrichtung Zahntechnik und nahm 2003 das Studium an der Zahnmedizinischen Fakultät in Foča (Universität Ost-Sarajevo) auf. Das Pflichtpraktikum leistete er in Nikšić ab. Seit Oktober 2013 arbeitet er in der Praxis V Dental Centar in Budva und besucht regelmäßig Seminare und Kurse aus verschiedenen Bereichen der Zahnmedizin.',
	description_tr = 'Diş hekimi. 1985''te Nikšić''te doğdu; Podgorica''da sağlık meslek lisesinin diş teknisyenliği bölümünü bitirdi ve 2003''te Foča Diş Hekimliği Fakültesine (Doğu Saraybosna Üniversitesi) kaydoldu. Stajını Nikšić''te yaptı. Ekim 2013''ten beri Budva''daki V Dental Centar''da çalışmakta ve diş hekimliğinin farklı alanlarındaki seminer ve kurslara düzenli olarak katılmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Iva Stanjević — specijalista oralne hirurgije (Ordinacija Budva)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Iva Stanjević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Stanjević Iva' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'iva-stanjevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'iva-stanjevic', 'Iva Stanjević', 'Ива Стањевић', 'Ива Станевич', 'Iva Stanjevic', 'Dr',
	'https://static.wixstatic.com/media/1b0103_f55e4a2e7020497886833ad7f4462ba7.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista oralne hirurgije i implantologije, vlasnica PZU „V Dental Centar“ u Budvi. Rođena je 1979. godine u Kotoru, gdje je 1997. završila opštu gimnaziju sa diplomom „Luča“. Stomatološki fakultet u Beogradu završila je 2003. godine, nakon čega je četiri godine radila kao opšti stomatolog. Specijalističke studije iz oralne hirurgije i implantologije završila je 2010. godine. Posjeduje licencu za primjenu PRP i PRF metoda u stomatološke i estetske svrhe.',
	description_sr_cyrl = 'Специјалиста оралне хирургије и имплантологије, власница ПЗУ „V Dental Centar“ у Будви. Рођена је 1979. године у Котору, гдје је 1997. завршила општу гимназију са дипломом „Луча“. Стоматолошки факултет у Београду завршила је 2003. године, након чега је четири године радила као општи стоматолог. Специјалистичке студије из оралне хирургије и имплантологије завршила је 2010. године. Посједује лиценцу за примјену PRP и PRF метода у стоматолошке и естетске сврхе.',
	description_ru = 'Специалист по хирургической стоматологии и имплантологии, владелица частного учреждения «V Dental Centar» в Будве. Родилась в 1979 году в Которе, где в 1997 году окончила гимназию с дипломом «Луча». В 2003 году окончила стоматологический факультет в Белграде, затем четыре года работала стоматологом общей практики. В 2010 году завершила специализацию по хирургической стоматологии и имплантологии. Имеет лицензию на применение методов PRP и PRF в стоматологии и эстетической медицине.',
	description_en = 'Specialist in oral surgery and implantology, owner of the private healthcare facility V Dental Centar in Budva. Born in 1979 in Kotor, she finished grammar school there in 1997 with the "Luča" diploma. She graduated from the School of Dentistry in Belgrade in 2003 and then worked as a general dentist for four years. In 2010 she completed her specialisation in oral surgery and implantology. She is licensed to use PRP and PRF methods for dental and aesthetic purposes.',
	description_de = 'Fachärztin für Oralchirurgie und Implantologie, Inhaberin der privaten Gesundheitseinrichtung V Dental Centar in Budva. Geboren 1979 in Kotor, schloss sie dort 1997 das Gymnasium mit dem Diplom „Luča“ ab. 2003 beendete sie das Zahnmedizinstudium in Belgrad und arbeitete anschließend vier Jahre als Allgemeinzahnärztin. 2010 schloss sie die Fachausbildung in Oralchirurgie und Implantologie ab. Sie besitzt eine Lizenz für die Anwendung der PRP- und PRF-Methoden in der Zahnmedizin und Ästhetik.',
	description_tr = 'Ağız cerrahisi ve implantoloji uzmanı; Budva''daki özel sağlık kuruluşu V Dental Centar''ın sahibi. 1979''da Kotor''da doğdu ve 1997''de buradaki genel liseyi "Luča" diplomasıyla bitirdi. 2003''te Belgrad Diş Hekimliği Fakültesinden mezun oldu ve ardından dört yıl genel diş hekimi olarak çalıştı. 2010''da ağız cerrahisi ve implantoloji uzmanlığını tamamladı. Diş hekimliği ve estetik amaçlı PRP ve PRF yöntemlerini uygulama lisansına sahiptir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije; vlasnica PZU „V Dental Centar“ u Budvi')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Ivana Srzentić — specijalista ortopedije vilica (Ordinacija Budva)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivana Srzentić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Srzentić Ivana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivana-srzentic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivana-srzentic', 'Ivana Srzentić', 'Ивана Срзентић', 'Ивана Срзентич', 'Ivana Srzentic', 'Dr',
	'https://static.wixstatic.com/media/1b0103_c142d47166214ac4aa2f2a2a61fa8634.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista ortopedije vilica (ortodont). Rođena je 1982. godine u Beogradu, gdje je 2001. završila gimnaziju, a 2007. godine diplomirala na Stomatološkom fakultetu. Nakon diplomiranja nekoliko godina je radila u ordinaciji „V Dental Centar“ kao opšti stomatolog. Specijalističke studije iz ortopedije vilica završila je početkom 2015. godine na Stomatološkom fakultetu u Beogradu.',
	description_sr_cyrl = 'Специјалиста ортопедије вилица (ортодонт). Рођена је 1982. године у Београду, гдје је 2001. завршила гимназију, а 2007. године дипломирала на Стоматолошком факултету. Након дипломирања неколико година је радила у ординацији „V Dental Centar“ као општи стоматолог. Специјалистичке студије из ортопедије вилица завршила је почетком 2015. године на Стоматолошком факултету у Београду.',
	description_ru = 'Специалист-ортодонт. Родилась в 1982 году в Белграде, где в 2001 году окончила гимназию, а в 2007 году — стоматологический факультет. Несколько лет после окончания учёбы работала в клинике «V Dental Centar» стоматологом общей практики. В начале 2015 года завершила специализацию по ортодонтии на стоматологическом факультете в Белграде.',
	description_en = 'Orthodontist. Born in 1982 in Belgrade, she finished grammar school there in 2001 and graduated from the School of Dentistry in 2007. For several years after graduating she worked at V Dental Centar as a general dentist. In early 2015 she completed her specialisation in orthodontics at the School of Dentistry in Belgrade.',
	description_de = 'Fachärztin für Kieferorthopädie. Geboren 1982 in Belgrad, schloss sie dort 2001 das Gymnasium und 2007 das Zahnmedizinstudium ab. Danach arbeitete sie mehrere Jahre in der Praxis V Dental Centar als Allgemeinzahnärztin. Anfang 2015 schloss sie die Fachausbildung in Kieferorthopädie an der Zahnmedizinischen Fakultät in Belgrad ab.',
	description_tr = 'Ortodonti uzmanı. 1982''de Belgrad''da doğdu; 2001''de burada liseyi bitirdi, 2007''de Diş Hekimliği Fakültesinden mezun oldu. Mezuniyetten sonra birkaç yıl V Dental Centar''da genel diş hekimi olarak çalıştı. 2015 başında Belgrad Diş Hekimliği Fakültesinde ortodonti uzmanlığını tamamladı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 3, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 4 врача (Vukotić — тот же id, что и в клинике Подгорицы), у всех фото и био.
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

-- ═══════════════════════════════════════════════════════════════════════════
-- V Dental Centar Podgorica — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-v-dental-centar-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/v-dental-centar-podgorica.json):
--   * https://www.vdental.me/ — Wix, сырой HTML: /, /podgorica, /doktori, /usluge, 8 страниц врачей
--     (pages-sitemap lastmod у всех страниц 2022-12-30).
--   * data/google-places/podgorica/v-dental-centar.json — place_id, координаты, телефон.
--
-- Сеть из двух ординаций, у нас — отдельными клиниками (как Milmedika Podgorica/Budva):
-- Budva — server/sql/insert-clinic-v-dental-centar-budva.sql. Dr Aleksandar Vukotić («Ordinacija
-- Podgorica/Budva») привязан к обеим.
--
-- ⚠️ Адрес: сайт «Bulevar Džordža Vašingtona 13/3, Podgorica 81 000», Google — «49 Bulevar Džordža
-- Vašingtona». Записан адрес сайта (решение координатора), координаты — точка места Google
-- 42.4433479 / 19.2458143 (другого источника нет). Расхождение — в записи импорта.
-- Телефон 067 228 008 — сайт и Google совпадают. Email vdental.pg@gmail.com — сайт.
-- Описание: «osnovana je 2009. godine u Podgorici» (/podgorica) + разделы /usluge.
--
-- Идемпотентно и самоисправляюще: клиника по google_place_id → slug, врачи по name_sr /
-- перевёрнутому имени / slug; пустые поля существующей записи дозаполняются, непустые не
-- трогаются (status тоже). description_* клиники и новых врачей — БЕЗУСЛОВНЫЙ UPDATE.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJq0zUMS7rTRMRx6_IYy9YQZo';
SET @clinic_slug = 'v-dental-centar-podgorica';

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
	'V Dental Centar Podgorica',
	'V Dental Центар (Подгорица)',
	'Стоматология V Dental Centar (Подгорица)',
	'Bulevar Džordža Vašingtona 13/3',
	'Булевар Џорџа Вашингтона 13/3',
	'',
	'',
	'81000',
	42.44334790,
	19.24581430,
	'+38267228008',
	'vdental.pg@gmail.com',
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
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'V Dental Центар (Подгорица)', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматология V Dental Centar (Подгорица)', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Bulevar Džordža Vašingtona 13/3', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Булевар Џорџа Вашингтона 13/3', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267228008', phone),
	email = IF(email IS NULL OR email = '', 'vdental.pg@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.vdental.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://static.wixstatic.com/media/1b0103_22391fcdbda64f518668910451ea564a.jpg', logo_url),
	latitude = COALESCE(latitude, 42.44334790),
	longitude = COALESCE(longitude, 19.24581430)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Stomatološka ordinacija V Dental Centar u Podgorici, na Bulevaru Džordža Vašingtona, osnovana je 2009. godine; ustanova ima i ordinaciju u Budvi. Ordinacija pruža usluge oralne hirurgije, implantologije i kompjuterom vođene implantologije, protetike, Digital Smile Design, ortopedije vilica, estetske stomatologije, PRP i PRF tretmana, kao i dječije i preventivne stomatologije. Poseban akcenat stavlja se na prvi pregled, nakon kojeg se pacijentu objašnjava plan terapije. Za dijagnostiku se koriste ciljani, ortopantomografski i telerentgen snimci, kao i trodimenzionalni CBCT snimak vilica, sa kojim ustanova radi od 2011. godine. Prema navodima ustanove, ovdje je 2010. godine prvi put u Crnoj Gori primijenjeno trodimenzionalno planiranje i kompjuterom vođena ugradnja implantata, a 2015. godine i 3D štampa vodiča za ugradnju.',
	description_sr_cyrl = 'Стоматолошка ординација V Dental Centar у Подгорици, на Булевару Џорџа Вашингтона, основана је 2009. године; установа има и ординацију у Будви. Ординација пружа услуге оралне хирургије, имплантологије и компјутером вођене имплантологије, протетике, Digital Smile Design, ортопедије вилица, естетске стоматологије, PRP и PRF третмана, као и дјечије и превентивне стоматологије. Посебан акценат ставља се на први преглед, након којег се пацијенту објашњава план терапије. За дијагностику се користе циљани, ортопантомографски и телерентген снимци, као и тродимензионални CBCT снимак вилица, са којим установа ради од 2011. године. Према наводима установе, овдје је 2010. године први пут у Црној Гори примијењено тродимензионално планирање и компјутером вођена уградња имплантата, а 2015. године и 3Д штампа водича за уградњу.',
	description_ru = 'Стоматологическая клиника V Dental Centar в Подгорице на бульваре Джорджа Вашингтона открыта в 2009 году; у учреждения есть также клиника в Будве. Здесь выполняют хирургическую стоматологию, имплантацию, в том числе навигационную (компьютерную), протезирование, Digital Smile Design, ортодонтию, эстетическую стоматологию, процедуры PRP и PRF, детскую и профилактическую стоматологию. Особое внимание уделяется первичному осмотру, после которого пациенту объясняют план лечения. Для диагностики используются прицельные снимки зубов, ортопантомограммы, телерентгенограммы и трёхмерная КЛКТ (CBCT), с которой клиника работает с 2011 года. По данным клиники, в 2010 году здесь впервые в Черногории применили трёхмерное планирование и навигационную установку имплантатов, а в 2015 году — 3D-печать хирургических шаблонов.',
	description_en = 'V Dental Centar in Podgorica, on Bulevar Džordža Vašingtona, was founded in 2009; the practice also has a clinic in Budva. It provides oral surgery, implantology including computer-guided implant placement, prosthodontics, Digital Smile Design, orthodontics, cosmetic dentistry, PRP and PRF treatments, and paediatric and preventive dentistry. Particular emphasis is placed on the first examination, after which the treatment plan is explained to the patient. Diagnostics include periapical, panoramic and cephalometric X-rays as well as 3D CBCT imaging of the jaws, which the practice has used since 2011. According to the practice, in 2010 it was the first in Montenegro to use 3D planning and computer-guided implant placement, and in 2015 it introduced 3D-printed surgical guides.',
	description_de = 'Die Zahnarztpraxis V Dental Centar in Podgorica am Bulevar Džordža Vašingtona wurde 2009 gegründet; die Einrichtung betreibt auch eine Praxis in Budva. Angeboten werden Oralchirurgie, Implantologie einschließlich computergeführter Implantation, Prothetik, Digital Smile Design, Kieferorthopädie, ästhetische Zahnmedizin, PRP- und PRF-Behandlungen sowie Kinder- und Präventivzahnheilkunde. Besonderer Wert wird auf die Erstuntersuchung gelegt, nach der dem Patienten der Behandlungsplan erläutert wird. Zur Diagnostik stehen Einzelzahn-, Panorama- und Fernröntgenaufnahmen sowie 3D-CBCT-Aufnahmen der Kiefer zur Verfügung, mit denen die Praxis seit 2011 arbeitet. Nach Angaben der Praxis wurden hier 2010 erstmals in Montenegro 3D-Planung und computergeführte Implantation eingesetzt, 2015 folgten 3D-gedruckte Bohrschablonen.',
	description_tr = 'Podgorica''da Bulevar Džordža Vašingtona üzerindeki V Dental Centar diş kliniği 2009''da kuruldu; kurumun Budva''da da bir kliniği vardır. Klinikte ağız cerrahisi, bilgisayar destekli (rehberli) implant uygulaması dahil implantoloji, protez, Digital Smile Design, ortodonti, estetik diş hekimliği, PRP ve PRF uygulamaları ile çocuk ve koruyucu diş hekimliği hizmetleri sunulur. İlk muayeneye özel önem verilir; ardından hastaya tedavi planı açıklanır. Teşhiste periapikal, panoramik ve sefalometrik röntgenlerin yanı sıra klinikte 2011''den beri kullanılan 3D CBCT çene görüntülemesinden yararlanılır. Kliniğin belirttiğine göre 2010''da Karadağ''da ilk kez burada 3D planlama ve bilgisayar destekli implant yerleştirme uygulanmış, 2015''te ise 3D baskılı cerrahi rehberler kullanılmaya başlanmıştır.'
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
-- PART 3: DOCTORS (5)
-- Размещение по /doktori: «Ordinacija Podgorica» — Vlahović, Martinović, Vuković, Pavličić;
-- «Ordinacija Podgorica/Budva» — Vukotić (привязан к обеим клиникам). Состав /podgorica совпадает.
-- Специальности: 78 = DENTISTRY, 74 = ORAL_SURGERY, 87 = PEDIATRIC_DENTISTRY, 93 = ORTHODONTIST.
-- Языки: 1 = SR (других сайт ни у кого не заявляет). Фото — портреты /doktori (static.wixstatic.com,
-- оригинал без Wix-трансформации). Все 5 — новые (проверено локально и прод-API: 204 по обоим порядкам имени).
-- Сёстры (Biljana Popović, Anđela Janković, Jadranka Jaramaz, Milica Muminović) — не врачи, не заводятся.
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
-- Dr sci. Zoran Vlahović — specijalista oralne hirurgije (Ordinacija Podgorica)
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Zoran Vlahović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vlahović Zoran' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zoran-vlahovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zoran-vlahovic', 'Zoran Vlahović', 'Зоран Влаховић', 'Зоран Влахович', 'Zoran Vlahovic', 'Dr sci.',
	'https://static.wixstatic.com/media/1b0103_764de95e6a2945a1924b4295e41f0405.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista oralne hirurgije i doktor stomatoloških nauka. Rođen je 1971. godine u Prištini, gdje je 1997. završio Odsjek stomatologije Medicinskog fakulteta. Specijalista oralne hirurgije je od 2010. godine. Znanja iz implantologije sticao je na jednogodišnjoj praksi na Vojnomedicinskoj akademiji u Beogradu i na kursevima u regionu i inostranstvu; od 2013. godine je doktor stomatoloških nauka iz oblasti dentalne implantologije. Predavač je za Bredent implantatni sistem i za kompaniju Planmeca iz oblasti trodimenzionalne radiologije, a radi i sa Straumann i Zimmer implantatnim sistemima.',
	description_sr_cyrl = 'Специјалиста оралне хирургије и доктор стоматолошких наука. Рођен је 1971. године у Приштини, гдје је 1997. завршио Одсјек стоматологије Медицинског факултета. Специјалиста оралне хирургије је од 2010. године. Знања из имплантологије стицао је на једногодишњој пракси на Војномедицинској академији у Београду и на курсевима у региону и иностранству; од 2013. године је доктор стоматолошких наука из области денталне имплантологије. Предавач је за Bredent имплантатни систем и за компанију Planmeca из области тродимензионалне радиологије, а ради и са Straumann и Zimmer имплантатним системима.',
	description_ru = 'Специалист по хирургической стоматологии, доктор стоматологических наук. Родился в 1971 году в Приштине, где в 1997 году окончил стоматологическое отделение медицинского факультета. Специалист по хирургической стоматологии с 2010 года. Знания в имплантологии получил во время годичной практики в Военно-медицинской академии в Белграде и на курсах в регионе и за рубежом; с 2013 года — доктор стоматологических наук в области дентальной имплантологии. Лектор по имплантатной системе Bredent и компании Planmeca в области трёхмерной рентгенодиагностики, работает также с имплантатами Straumann и Zimmer.',
	description_en = 'Oral surgery specialist with a doctorate in dental sciences. Born in 1971 in Priština, he graduated from the Department of Dentistry of the Faculty of Medicine there in 1997 and has been an oral surgery specialist since 2010. He trained in implantology during a one-year placement at the Military Medical Academy in Belgrade and at courses in the region and abroad, and in 2013 obtained his doctorate in dental implantology. He lectures for the Bredent implant system and for Planmeca in 3D imaging, and also works with the Straumann and Zimmer implant systems.',
	description_de = 'Facharzt für Oralchirurgie mit Doktortitel in Zahnmedizin. Geboren 1971 in Priština, schloss er dort 1997 die Abteilung für Zahnmedizin der Medizinischen Fakultät ab; seit 2010 ist er Facharzt für Oralchirurgie. Seine Kenntnisse in Implantologie erwarb er während eines einjährigen Praktikums an der Militärmedizinischen Akademie in Belgrad sowie in Kursen in der Region und im Ausland; 2013 promovierte er im Bereich der dentalen Implantologie. Er ist Referent für das Bredent-Implantatsystem und für Planmeca im Bereich der 3D-Radiologie und arbeitet zudem mit Straumann- und Zimmer-Implantaten.',
	description_tr = 'Ağız cerrahisi uzmanı ve diş hekimliği bilimleri doktoru. 1971''de Priştine''de doğdu, 1997''de buradaki Tıp Fakültesi Diş Hekimliği Bölümünden mezun oldu; 2010''dan beri ağız cerrahisi uzmanıdır. İmplantoloji bilgisini Belgrad Askeri Tıp Akademisinde bir yıllık staj ve bölgede ve yurt dışındaki kurslarda edindi; 2013''te dental implantoloji alanında doktorasını tamamladı. Bredent implant sistemi ve 3D radyoloji alanında Planmeca şirketi için eğitmenlik yapmakta, Straumann ve Zimmer implant sistemleriyle de çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Milan Martinović — doktor stomatologije (Ordinacija Podgorica)
-- Био лежит на странице /dr-aleksandar-stanisic (Wix-копия старой карточки), портрет — /doktori.
-- В БД однофамильцы Martinović (Jovo — орал. хирург, Milena/Havka/Marina/Adisa) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milan Martinović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Martinović Milan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milan-martinovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milan-martinovic', 'Milan Martinović', 'Милан Мартиновић', 'Милан Мартинович', 'Milan Martinovic', 'Dr',
	'https://static.wixstatic.com/media/1b0103_f949f29fc9d54a808b4cfc7917aa50b1~mv2.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Doktor stomatologije. Rođen je 1987. godine u Nikšiću, gdje je završio osnovnu i srednju školu kao nosilac diplome „Luča“. Studije stomatologije na Medicinskom fakultetu u Podgorici završio je 2011. godine. Radi kao asistent na predmetu Bolesti zuba – predklinika na odsjeku Stomatologija Medicinskog fakulteta u Podgorici i student je doktorskih studija. Posjeduje sertifikate sa edukacija iz endodoncije, protetike i estetske stomatologije; sertifikovani je iTop instruktor (gold level).',
	description_sr_cyrl = 'Доктор стоматологије. Рођен је 1987. године у Никшићу, гдје је завршио основну и средњу школу као носилац дипломе „Луча“. Студије стоматологије на Медицинском факултету у Подгорици завршио је 2011. године. Ради као асистент на предмету Болести зуба – предклиника на одсјеку Стоматологија Медицинског факултета у Подгорици и студент је докторских студија. Посједује сертификате са едукација из ендодонције, протетике и естетске стоматологије; сертификовани је iTop инструктор (голд левел).',
	description_ru = 'Врач-стоматолог. Родился в 1987 году в Никшиче, где окончил школу с дипломом «Луча». В 2011 году окончил стоматологическое отделение медицинского факультета в Подгорице. Работает ассистентом на кафедре болезней зубов (доклинический курс) стоматологического отделения медицинского факультета в Подгорице, обучается в докторантуре. Имеет сертификаты обучения по эндодонтии, протезированию и эстетической стоматологии; сертифицированный инструктор iTop (gold level).',
	description_en = 'Doctor of dental medicine. Born in 1987 in Nikšić, where he completed primary and secondary school with the "Luča" diploma. He graduated in dentistry from the Faculty of Medicine in Podgorica in 2011. He works as a teaching assistant in pre-clinical dental diseases at the Department of Dentistry of the Faculty of Medicine in Podgorica and is a PhD student. He holds certificates from training in endodontics, prosthodontics and cosmetic dentistry and is a certified iTop instructor (gold level).',
	description_de = 'Zahnarzt. Geboren 1987 in Nikšić, wo er die Grund- und Mittelschule mit dem Diplom „Luča“ abschloss. 2011 schloss er das Zahnmedizinstudium an der Medizinischen Fakultät in Podgorica ab. Er ist Assistent im Fach vorklinische Zahnerkrankungen an der Abteilung für Zahnmedizin der Medizinischen Fakultät in Podgorica und Doktorand. Er verfügt über Zertifikate aus Fortbildungen in Endodontie, Prothetik und ästhetischer Zahnmedizin und ist zertifizierter iTop-Instruktor (Gold-Level).',
	description_tr = 'Diş hekimi. 1987''de Nikšić''te doğdu ve ilk ve ortaöğrenimini burada "Luča" diplomasıyla tamamladı. 2011''de Podgorica Tıp Fakültesi Diş Hekimliği Bölümünden mezun oldu. Podgorica Tıp Fakültesi Diş Hekimliği Bölümünde klinik öncesi diş hastalıkları dersinde asistan olarak çalışmakta ve doktora eğitimine devam etmektedir. Endodonti, protez ve estetik diş hekimliği eğitimlerinden sertifikaları vardır; sertifikalı iTop eğitmenidir (gold level).'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Anđela Vuković — specijalista preventivne i dječije stomatologije (Ordinacija Podgorica)
-- В био имя записано «Andjela T. Vuković»; на /doktori и /podgorica — «Anđela Vuković».
-- В БД однофамильцы Vuković (Anđa Bulajić Vuković — психиатр и др.) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Anđela Vuković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Vuković Anđela' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'andjela-vukovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andjela-vukovic', 'Anđela Vuković', 'Анђела Вуковић', 'Анджела Вукович', 'Andjela Vukovic', 'Dr',
	'https://static.wixstatic.com/media/1b0103_9f7af91114b544508944e01d703ba418.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista dječije i preventivne stomatologije. Rođena je 1972. godine u Nikšiću, gdje je završila osnovnu i srednju školu. Na Stomatološkom fakultetu u Beogradu diplomirala je 1997. godine, a specijalističke studije iz preventivne i dječije stomatologije završila je 2007. godine, takođe u Beogradu. Autor je 13 i koautor 10 stručnih radova prezentovanih na kongresima i simpozijumima u zemlji i inostranstvu. Od 2003. godine je član sudskih vještaka Crne Gore.',
	description_sr_cyrl = 'Специјалиста дјечије и превентивне стоматологије. Рођена је 1972. године у Никшићу, гдје је завршила основну и средњу школу. На Стоматолошком факултету у Београду дипломирала је 1997. године, а специјалистичке студије из превентивне и дјечије стоматологије завршила је 2007. године, такође у Београду. Аутор је 13 и коаутор 10 стручних радова презентованих на конгресима и симпозијумима у земљи и иностранству. Од 2003. године је члан судских вјештака Црне Горе.',
	description_ru = 'Специалист по детской и профилактической стоматологии. Родилась в 1972 году в Никшиче, где окончила школу. В 1997 году окончила стоматологический факультет в Белграде, в 2007 году там же завершила специализацию по профилактической и детской стоматологии. Автор 13 и соавтор 10 профессиональных работ, представленных на конгрессах и симпозиумах в стране и за рубежом. С 2003 года входит в число судебных экспертов Черногории.',
	description_en = 'Specialist in paediatric and preventive dentistry. Born in 1972 in Nikšić, where she completed primary and secondary school, she graduated from the School of Dentistry in Belgrade in 1997 and completed her specialisation in preventive and paediatric dentistry there in 2007. She is the author of 13 and co-author of 10 professional papers presented at congresses and symposia in Montenegro and abroad. Since 2003 she has been a court expert in Montenegro.',
	description_de = 'Fachärztin für Kinder- und Präventivzahnheilkunde. Geboren 1972 in Nikšić, wo sie die Grund- und Mittelschule besuchte, schloss sie 1997 das Zahnmedizinstudium in Belgrad ab und absolvierte dort 2007 die Fachausbildung in Präventiv- und Kinderzahnheilkunde. Sie ist Autorin von 13 und Mitautorin von 10 Fachbeiträgen, die auf Kongressen und Symposien im In- und Ausland vorgestellt wurden. Seit 2003 ist sie gerichtliche Sachverständige in Montenegro.',
	description_tr = 'Çocuk ve koruyucu diş hekimliği uzmanı. 1972''de Nikšić''te doğdu ve ilk ve ortaöğrenimini burada tamamladı. 1997''de Belgrad Diş Hekimliği Fakültesinden mezun oldu, 2007''de yine Belgrad''da koruyucu ve çocuk diş hekimliği uzmanlığını tamamladı. Yurt içi ve yurt dışındaki kongre ve sempozyumlarda sunulan 13 bilimsel çalışmanın yazarı ve 10 çalışmanın ortak yazarıdır. 2003''ten beri Karadağ''da bilirkişidir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 87);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista preventivne i dječije stomatologije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Tijana Pavličić — specijalista ortopedije vilica (Ordinacija Podgorica)
-- Био — Wix-страница /copy-of-dr-bojan-miladinovic (заголовок «Dr Tijana Pavličić»).
-- В БД однофамильцы Pavličić (Nevenka — уролог, Dejan — ортопед, Miodrag — хирург, Natalija — психиатр) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Tijana Pavličić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Pavličić Tijana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'tijana-pavlicic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tijana-pavlicic', 'Tijana Pavličić', 'Тијана Павличић', 'Тияна Павличич', 'Tijana Pavlicic', 'Dr',
	'https://static.wixstatic.com/media/1b0103_7d4241a3f50243b0b42e4a42fa78e63e~mv2.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista ortopedije vilica (ortodont). Rođena je 1977. godine u Podgorici, gdje je završila osnovnu i srednju školu. Osnovne stomatološke studije završila je 2002. godine u Beogradu, a diplomu specijaliste ortopedije vilica stekla je 2007. godine, takođe u Beogradu. Učesnica je brojnih kurseva, simpozijuma i kongresa u zemlji i inostranstvu.',
	description_sr_cyrl = 'Специјалиста ортопедије вилица (ортодонт). Рођена је 1977. године у Подгорици, гдје је завршила основну и средњу школу. Основне стоматолошке студије завршила је 2002. године у Београду, а диплому специјалисте ортопедије вилица стекла је 2007. године, такође у Београду. Учесница је бројних курсева, симпозијума и конгреса у земљи и иностранству.',
	description_ru = 'Специалист-ортодонт. Родилась в 1977 году в Подгорице, где окончила школу. В 2002 году окончила стоматологический факультет в Белграде, в 2007 году там же получила диплом специалиста по ортодонтии. Участница многочисленных курсов, симпозиумов и конгрессов в стране и за рубежом.',
	description_en = 'Orthodontist. Born in 1977 in Podgorica, where she completed primary and secondary school, she graduated in dentistry in Belgrade in 2002 and obtained her specialist diploma in orthodontics there in 2007. She has taken part in numerous courses, symposia and congresses in Montenegro and abroad.',
	description_de = 'Fachärztin für Kieferorthopädie. Geboren 1977 in Podgorica, wo sie die Grund- und Mittelschule besuchte, schloss sie 2002 das Zahnmedizinstudium in Belgrad ab und erwarb dort 2007 das Facharztdiplom für Kieferorthopädie. Sie nahm an zahlreichen Kursen, Symposien und Kongressen im In- und Ausland teil.',
	description_tr = 'Ortodonti uzmanı. 1977''de Podgorica''da doğdu ve ilk ve ortaöğrenimini burada tamamladı. 2002''de Belgrad''da diş hekimliği eğitimini bitirdi, 2007''de yine Belgrad''da ortodonti uzmanlık diplomasını aldı. Yurt içi ve yurt dışında çok sayıda kurs, sempozyum ve kongreye katılmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 93);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista ortopedije vilica')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 2, hours = 0
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 5 врачей, все новые (created_at сегодня), у всех фото и био.
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

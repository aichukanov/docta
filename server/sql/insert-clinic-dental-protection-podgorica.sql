-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka poliklinika Dental Protection (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-protection-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/dental-protection-podgorica.json):
--   * https://dentalprotection.me/ — WordPress + WPML. WP REST: /our-clinic/about/, /departments/ (Sektori),
--     /contact/, /our-clinic/team/ и 5 страниц /portfolio-item/dr-*-popovic/. ⚠️ Сайт не обновлялся с 2017–2019
--     (modified: Team 2017-11-23, Sektori 2017-12-04, главная 2019-02-21) — состав и био по состоянию на 2017.
--   * data/google-places/podgorica/dental-protection.json — place_id, координаты, телефон.
-- Адрес: сайт «Ulica 4. Jul 105/3, 81000 Podgorica» / «Ulica 4.Jula, Lamela Zetagradnje 105/3» = Google «105/3, 4. Jul».
-- Телефон +382 20 622 703 — сайт и Google совпадают. Email/соцсети/логотип — шапка сайта.
--
-- Идемпотентно и самоисправляюще: повторный прогон приводит клинику к тому же состоянию; непустые
-- поля существующей записи не перезаписываются (кроме description_*), status не трогается.
-- ⚠️ Описания клиники и новых врачей пишутся безусловным UPDATE — правки из админки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJR1VVqhTrTRMR8AW3tk2L5Lo';
SET @clinic_slug = 'dental-protection-podgorica';

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
	'Stomatološka poliklinika Dental Protection',
	'Стоматолошка поликлиника Dental Protection',
	'Стоматологическая поликлиника Dental Protection',
	'4. jula 105/3',
	'4. јула 105/3',
	'',
	'',
	'81000',
	42.42582900,
	19.26003100,
	'+38220622703',
	'info@dentalprotection.me',
	'https://dentalprotection.me/',
	'facebook.com/stomatologijapg',
	'@dentalprotection.me',
	'',
	'',
	'',
	'https://dentalprotection.me/wp-content/uploads/2017/11/lo22go.fw_-1.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Стоматолошка поликлиника Dental Protection', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Стоматологическая поликлиника Dental Protection', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', '4. jula 105/3', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', '4. јула 105/3', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220622703', phone),
	email = IF(email IS NULL OR email = '', 'info@dentalprotection.me', email),
	website = IF(website IS NULL OR website = '', 'https://dentalprotection.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/stomatologijapg', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@dentalprotection.me', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://dentalprotection.me/wp-content/uploads/2017/11/lo22go.fw_-1.png', logo_url),
	latitude = COALESCE(latitude, 42.42582900),
	longitude = COALESCE(longitude, 19.26003100)
WHERE id = @clinic_id;

-- Описания — безусловно. Только то, что клиника пишет о себе.
UPDATE clinics SET
	description_sr = 'Stomatološka poliklinika „Dental Protection“ nalazi se u Podgorici, u Ulici 4. jula 105/3. Privatnu stomatološku ordinaciju „Dental Protection“ otvorio je 1999. godine dr Novak Popović, specijalista dječije i preventivne stomatologije, a u junu 2013. registrovana je poliklinika — porodična ustanova u kojoj rade i njegovi sinovi i snaha, specijalisti. Poliklinika pruža usluge oralne hirurgije i implantologije, ortopedije vilica, dječije i preventivne stomatologije, parodontologije i oralne medicine, restaurativne i estetske stomatologije, endodoncije i protetike. U sastavu poliklinike su hirurška sala za oralno-hirurške i parodontološke intervencije i rendgen kabinet sa digitalnim aparatima, uključujući 3D snimanje. Protetske radove izrađuje zubotehnička laboratorija „Medodent“ iz Podgorice, sa kojom poliklinika sarađuje.',
	description_sr_cyrl = 'Стоматолошка поликлиника „Dental Protection“ налази се у Подгорици, у Улици 4. јула 105/3. Приватну стоматолошку ординацију „Dental Protection“ отворио је 1999. године др Новак Поповић, специјалиста дјечије и превентивне стоматологије, а у јуну 2013. регистрована је поликлиника — породична установа у којој раде и његови синови и снаха, специјалисти. Поликлиника пружа услуге оралне хирургије и имплантологије, ортопедије вилица, дјечије и превентивне стоматологије, пародонтологије и оралне медицине, рестауративне и естетске стоматологије, ендодонције и протетике. У саставу поликлинике су хируршка сала за орално-хируршке и пародонтолошке интервенције и рендген кабинет са дигиталним апаратима, укључујући 3D снимање. Протетске радове израђује зуботехничка лабораторија „Medodent“ из Подгорице, са којом поликлиника сарађује.',
	description_ru = 'Стоматологическая поликлиника «Dental Protection» находится в Подгорице, на улице 4 Июля, 105/3. Частный стоматологический кабинет «Dental Protection» в 1999 году открыл доктор Новак Попович, специалист по детской и профилактической стоматологии, а в июне 2013 года была зарегистрирована поликлиника — семейное учреждение, где работают также его сыновья и невестка, врачи-специалисты. Поликлиника оказывает услуги хирургической стоматологии и имплантологии, ортодонтии, детской и профилактической стоматологии, пародонтологии и лечения заболеваний слизистой полости рта, терапевтической и эстетической стоматологии, эндодонтии и протезирования. В поликлинике есть операционная для хирургических и пародонтологических вмешательств и рентген-кабинет с цифровыми аппаратами, включая 3D-съёмку. Протезы изготавливает подгорицкая зуботехническая лаборатория «Medodent», с которой сотрудничает поликлиника.',
	description_en = 'Dental Protection is a dental polyclinic in Podgorica, at 4. jula Street 105/3. Dr Novak Popović, a specialist in paediatric and preventive dentistry, opened the private Dental Protection practice in 1999, and in June 2013 the polyclinic was registered as a family practice where his sons and daughter-in-law, all specialists, also work. The polyclinic provides oral surgery and implantology, orthodontics, paediatric and preventive dentistry, periodontology and oral medicine, restorative and cosmetic dentistry, endodontics and prosthodontics. It has an operating room for oral surgery and periodontal procedures and an X-ray suite with digital equipment, including 3D imaging. Prosthetic work is made by the Medodent dental laboratory in Podgorica, which the polyclinic works with.',
	description_de = 'Dental Protection ist eine Zahnpoliklinik in Podgorica, Straße 4. jula 105/3. Die private Zahnarztpraxis Dental Protection eröffnete 1999 Dr. Novak Popović, Facharzt für Kinder- und Präventivzahnheilkunde; im Juni 2013 wurde die Poliklinik als Familienbetrieb registriert, in dem auch seine Söhne und seine Schwiegertochter als Fachärzte arbeiten. Angeboten werden Oralchirurgie und Implantologie, Kieferorthopädie, Kinder- und Präventivzahnheilkunde, Parodontologie und Oralmedizin, restaurative und ästhetische Zahnheilkunde, Endodontie und Prothetik. Die Poliklinik verfügt über einen OP-Raum für oralchirurgische und parodontologische Eingriffe sowie einen Röntgenraum mit digitalen Geräten einschließlich 3D-Aufnahmen. Zahnersatz fertigt das Dentallabor Medodent aus Podgorica, mit dem die Poliklinik zusammenarbeitet.',
	description_tr = 'Dental Protection, Podgorica''da 4. jula Caddesi 105/3 adresinde bulunan bir diş polikliniğidir. Özel Dental Protection muayenehanesini 1999''da çocuk ve koruyucu diş hekimliği uzmanı Dr. Novak Popović açtı; poliklinik ise Haziran 2013''te, oğulları ve gelininin de uzman olarak çalıştığı bir aile kurumu olarak tescil edildi. Poliklinikte ağız cerrahisi ve implantoloji, ortodonti, çocuk ve koruyucu diş hekimliği, periodontoloji ve ağız hastalıkları, restoratif ve estetik diş hekimliği, endodonti ve protez hizmetleri sunulur. Ağız cerrahisi ve periodontal girişimler için bir ameliyathane ile 3D görüntüleme dahil dijital cihazlara sahip bir röntgen odası bulunur. Protezler, polikliniğin birlikte çalıştığı Podgorica''daki Medodent diş laboratuvarında üretilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.DENTAL_CLINIC = 2
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 2);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы работы: «Radno vrijeme — Ponedeljak – Petak: 9:00-20:00, Subota: 9:00-13:00» (футер всех страниц). Воскресенье в перечне не названо — выходной.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (5)
-- Состав — /our-clinic/team/ (2017-11-23): 5 карточек «Dr». Сайт-чек насчитал 4, исключив Dr Milovan Popović
-- как «specijalista farmacije»; но его био: «diplomira 2009 … zvanje doktor stomatologije … Pored svakodnevnog
-- rada sa pacijentima uporedo obavlja i funkciju izvršnog direktora» — практикующий стоматолог, заводится
-- со специальностью 78 (фармация в enums/specialty.ts нет). Языки — только явно заявленные в био.
-- Специальности: 74 = ORAL_SURGERY, 78 = DENTISTRY, 87 = PEDIATRIC_DENTISTRY, 93 = ORTHODONTIST, 95 = PERIODONTOLOGY. Языки: 1 = SR, 3 = EN, 6 = DE.
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Novak Popović — Specijalista dječije i preventivne stomatologije; osnivač i vlasnik
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Novak Popović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Popović Novak' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'novak-popovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'novak-popovic', 'Novak Popović', 'Новак Поповић', 'Новак Попович', 'Novak Popovic', 'Dr',
	'https://dentalprotection.me/wp-content/uploads/2017/11/novak.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista dječije i preventivne stomatologije, osnivač i vlasnik Stomatološke poliklinike „Dental Protection“. Rođen je 1943. u Kolašinu. Stomatološki fakultet u Beogradu završio je 1968, a specijalizaciju iz dječije i preventivne stomatologije 1984. godine. Radio je u prvoj školskoj stomatološkoj ambulanti u Crnoj Gori (Titograd, 1971–1973), kao kantonalni školski zubni ljekar u Švajcarskoj (kanton Glarus, 1973–1975) i u privatnoj ordinaciji u Cirihu (1975–1979). Bio je načelnik dječije i preventivne stomatologije Doma zdravlja Kolašin, inspektor za stomatologiju za Crnu Goru i specijalista u Stomatološkoj poliklinici KBC Crne Gore. Privatnu ordinaciju „Dental Protection“ otvorio je 1999, a 2013. godine Stomatološku polikliniku „Dental Protection“, u kojoj radi kao konsultant. Autor je i koautor više stručnih radova.',
	description_sr_cyrl = 'Специјалиста дјечије и превентивне стоматологије, оснивач и власник Стоматолошке поликлинике „Dental Protection“. Рођен је 1943. у Колашину. Стоматолошки факултет у Београду завршио је 1968, а специјализацију из дјечије и превентивне стоматологије 1984. године. Радио је у првој школској стоматолошкој амбуланти у Црној Гори (Титоград, 1971–1973), као кантонални школски зубни љекар у Швајцарској (кантон Гларус, 1973–1975) и у приватној ординацији у Цириху (1975–1979). Био је начелник дјечије и превентивне стоматологије Дома здравља Колашин, инспектор за стоматологију за Црну Гору и специјалиста у Стоматолошкој поликлиници KBC Црне Горе. Приватну ординацију „Dental Protection“ отворио је 1999, а 2013. године Стоматолошку поликлинику „Dental Protection“, у којој ради као консултант. Аутор је и коаутор више стручних радова.',
	description_ru = 'Специалист по детской и профилактической стоматологии, основатель и владелец стоматологической поликлиники «Dental Protection». Родился в 1943 году в Колашине. В 1968 году окончил стоматологический факультет в Белграде, в 1984 году — специализацию по детской и профилактической стоматологии. Работал в первом школьном стоматологическом кабинете Черногории (Титоград, 1971–1973), кантональным школьным стоматологом в Швейцарии (кантон Гларус, 1973–1975) и в частной клинике в Цюрихе (1975–1979). Руководил службой детской и профилактической стоматологии Дома здоровья Колашина, был инспектором по стоматологии Черногории и специалистом стоматологической поликлиники Клинического центра Черногории. В 1999 году открыл частный кабинет «Dental Protection», в 2013 году — стоматологическую поликлинику «Dental Protection», где работает консультантом. Автор и соавтор ряда научных работ.',
	description_en = 'Specialist in paediatric and preventive dentistry, founder and owner of the Dental Protection dental polyclinic. Born in 1943 in Kolašin, he graduated from the School of Dentistry in Belgrade in 1968 and completed his specialisation in paediatric and preventive dentistry in 1984. He worked at the first school dental surgery in Montenegro (Titograd, 1971–1973), as a cantonal school dentist in Switzerland (canton of Glarus, 1973–1975) and at a private practice in Zurich (1975–1979). He headed paediatric and preventive dentistry at the Kolašin health centre, served as dental inspector for Montenegro and worked as a specialist at the dental polyclinic of the Clinical Centre of Montenegro. He opened the private Dental Protection practice in 1999 and the Dental Protection polyclinic in 2013, where he works as a consultant. He has authored and co-authored a number of professional papers.',
	description_de = 'Facharzt für Kinder- und Präventivzahnheilkunde, Gründer und Inhaber der Zahnpoliklinik Dental Protection. Geboren 1943 in Kolašin, schloss er 1968 das Zahnmedizinstudium in Belgrad und 1984 die Fachausbildung in Kinder- und Präventivzahnheilkunde ab. Er arbeitete in der ersten Schulzahnklinik Montenegros (Titograd, 1971–1973), als Kantonsschulzahnarzt in der Schweiz (Kanton Glarus, 1973–1975) und in einer Privatpraxis in Zürich (1975–1979). Er leitete die Kinder- und Präventivzahnheilkunde des Gesundheitszentrums Kolašin, war Zahnmedizin-Inspektor für Montenegro und Facharzt an der Zahnpoliklinik des Klinischen Zentrums Montenegros. 1999 eröffnete er die Privatpraxis Dental Protection und 2013 die Zahnpoliklinik Dental Protection, in der er als Berater tätig ist. Er ist Autor und Mitautor mehrerer Fachpublikationen.',
	description_tr = 'Çocuk ve koruyucu diş hekimliği uzmanı; Dental Protection diş polikliniğinin kurucusu ve sahibi. 1943''te Kolašin''de doğdu; 1968''de Belgrad Diş Hekimliği Fakültesinden mezun oldu, 1984''te çocuk ve koruyucu diş hekimliği uzmanlığını tamamladı. Karadağ''ın ilk okul diş kliniğinde (Titograd, 1971–1973), İsviçre''de kanton okul diş hekimi olarak (Glarus kantonu, 1973–1975) ve Zürih''te özel bir muayenehanede (1975–1979) çalıştı. Kolašin Sağlık Merkezinde çocuk ve koruyucu diş hekimliği birimini yönetti, Karadağ diş hekimliği müfettişi ve Karadağ Klinik Merkezi diş polikliniğinde uzman olarak görev yaptı. 1999''da özel Dental Protection muayenehanesini, 2013''te ise danışman olarak çalıştığı Dental Protection diş polikliniğini açtı. Çok sayıda mesleki yayının yazarı ve ortak yazarıdır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 87);
-- SR + DE: «Govori Njemački jezik.» (/portfolio-item/dr-novak-popovic/)
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 6);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista dječije i preventivne stomatologije; osnivač i vlasnik')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Žana Popović — Specijalista parodontologije i oralne medicine
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Žana Popović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Popović Žana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'zana-popovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zana-popovic', 'Žana Popović', 'Жана Поповић', 'Жана Попович', 'Zana Popovic', 'Dr',
	'https://dentalprotection.me/wp-content/uploads/2017/11/zana.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista parodontologije i oralne medicine. Rođena je 1980. u Sarajevu. Stomatološki fakultet Univerziteta u Beogradu završila je 2006. godine; nakon pripravničkog staža i stručnog ispita dvije godine je radila u privatnoj ordinaciji „Dental Protection“. Specijalističke studije iz parodontologije i oralne medicine na Vojnomedicinskoj akademiji u Beogradu upisala je 2009, a zvanje specijaliste stekla je 2012. godine. Od 2013. je stalni član tima Stomatološke poliklinike „Dental Protection“. Autor je dva naučna rada iz parodontologije i oralne medicine objavljena u inostranim časopisima.',
	description_sr_cyrl = 'Специјалиста пародонтологије и оралне медицине. Рођена је 1980. у Сарајеву. Стоматолошки факултет Универзитета у Београду завршила је 2006. године; након приправничког стажа и стручног испита двије године је радила у приватној ординацији „Dental Protection“. Специјалистичке студије из пародонтологије и оралне медицине на Војномедицинској академији у Београду уписала је 2009, а звање специјалисте стекла је 2012. године. Од 2013. је стални члан тима Стоматолошке поликлинике „Dental Protection“. Аутор је два научна рада из пародонтологије и оралне медицине објављена у иностраним часописима.',
	description_ru = 'Специалист по пародонтологии и заболеваниям слизистой оболочки полости рта. Родилась в 1980 году в Сараеве. В 2006 году окончила стоматологический факультет Белградского университета; после интернатуры и профессионального экзамена два года работала в частном кабинете «Dental Protection». В 2009 году поступила на специализацию по пародонтологии и оральной медицине в Военно-медицинскую академию в Белграде, звание специалиста получила в 2012 году. С 2013 года работает в стоматологической поликлинике «Dental Protection». Автор двух научных работ по пародонтологии и оральной медицине, опубликованных в зарубежных журналах.',
	description_en = 'Specialist in periodontology and oral medicine. Born in 1980 in Sarajevo, she graduated from the School of Dentistry of the University of Belgrade in 2006; after her internship and licensing exam she worked for two years at the private Dental Protection practice. In 2009 she began her specialisation in periodontology and oral medicine at the Military Medical Academy in Belgrade and qualified as a specialist in 2012. She has been a permanent member of the Dental Protection polyclinic team since 2013. She has authored two research papers in periodontology and oral medicine published in international journals.',
	description_de = 'Fachärztin für Parodontologie und Oralmedizin. Geboren 1980 in Sarajevo, schloss sie 2006 das Zahnmedizinstudium an der Universität Belgrad ab; nach Praktikum und Fachprüfung arbeitete sie zwei Jahre in der Privatpraxis Dental Protection. 2009 begann sie die Fachausbildung in Parodontologie und Oralmedizin an der Militärmedizinischen Akademie in Belgrad, 2012 erwarb sie den Facharzttitel. Seit 2013 gehört sie fest zum Team der Zahnpoliklinik Dental Protection. Sie ist Autorin zweier in internationalen Fachzeitschriften veröffentlichter Arbeiten zur Parodontologie und Oralmedizin.',
	description_tr = 'Periodontoloji ve ağız hastalıkları uzmanı. 1980''de Saraybosna''da doğdu; 2006''da Belgrad Üniversitesi Diş Hekimliği Fakültesinden mezun oldu, stajı ve mesleki sınavın ardından iki yıl özel Dental Protection muayenehanesinde çalıştı. 2009''da Belgrad Askeri Tıp Akademisinde periodontoloji ve ağız hastalıkları uzmanlığına başladı ve 2012''de uzman unvanını aldı. 2013''ten beri Dental Protection diş polikliniği ekibinin daimi üyesidir. Periodontoloji ve ağız hastalıkları alanında uluslararası dergilerde yayımlanmış iki bilimsel makalenin yazarıdır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 95);
-- SR + EN: «Govori engleski jezik.»
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 3);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista parodontologije i oralne medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Marko Popović — Specijalista oralne hirurgije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Marko Popović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Popović Marko' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'marko-popovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marko-popovic', 'Marko Popović', 'Марко Поповић', 'Марко Попович', 'Marko Popovic', 'Dr',
	'https://dentalprotection.me/wp-content/uploads/2017/11/marko.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista oralne hirurgije. Rođen je 1979. u Podgorici. Stomatološki fakultet Univerziteta u Beogradu završio je 2007. godine. Nakon dvije godine rada u ordinaciji „Dental Protection“ upisao je specijalističke studije iz oralne hirurgije na Vojnomedicinskoj akademiji u Beogradu, a zvanje specijaliste stekao je 2012. godine. Stalni je član tima Stomatološke poliklinike „Dental Protection“ i redovno se usavršava na kongresima iz oralne hirurgije, implantologije, endodoncije i estetske stomatologije.',
	description_sr_cyrl = 'Специјалиста оралне хирургије. Рођен је 1979. у Подгорици. Стоматолошки факултет Универзитета у Београду завршио је 2007. године. Након двије године рада у ординацији „Dental Protection“ уписао је специјалистичке студије из оралне хирургије на Војномедицинској академији у Београду, а звање специјалисте стекао је 2012. године. Стални је члан тима Стоматолошке поликлинике „Dental Protection“ и редовно се усавршава на конгресима из оралне хирургије, имплантологије, ендодонције и естетске стоматологије.',
	description_ru = 'Специалист по хирургической стоматологии. Родился в 1979 году в Подгорице. В 2007 году окончил стоматологический факультет Белградского университета. После двух лет работы в кабинете «Dental Protection» поступил на специализацию по хирургической стоматологии в Военно-медицинскую академию в Белграде и в 2012 году получил звание специалиста. Работает в стоматологической поликлинике «Dental Protection», регулярно участвует в конгрессах по хирургической стоматологии, имплантологии, эндодонтии и эстетической стоматологии.',
	description_en = 'Oral surgery specialist. Born in 1979 in Podgorica, he graduated from the School of Dentistry of the University of Belgrade in 2007. After two years at the Dental Protection practice he began his specialisation in oral surgery at the Military Medical Academy in Belgrade and qualified as a specialist in 2012. He is a permanent member of the Dental Protection polyclinic team and regularly attends congresses on oral surgery, implantology, endodontics and cosmetic dentistry.',
	description_de = 'Facharzt für Oralchirurgie. Geboren 1979 in Podgorica, schloss er 2007 das Zahnmedizinstudium an der Universität Belgrad ab. Nach zwei Jahren in der Praxis Dental Protection begann er die Fachausbildung in Oralchirurgie an der Militärmedizinischen Akademie in Belgrad und erwarb 2012 den Facharzttitel. Er gehört fest zum Team der Zahnpoliklinik Dental Protection und besucht regelmäßig Kongresse zu Oralchirurgie, Implantologie, Endodontie und ästhetischer Zahnheilkunde.',
	description_tr = 'Ağız cerrahisi uzmanı. 1979''da Podgorica''da doğdu; 2007''de Belgrad Üniversitesi Diş Hekimliği Fakültesinden mezun oldu. Dental Protection muayenehanesinde iki yıl çalıştıktan sonra Belgrad Askeri Tıp Akademisinde ağız cerrahisi uzmanlığına başladı ve 2012''de uzman unvanını aldı. Dental Protection diş polikliniği ekibinin daimi üyesidir ve ağız cerrahisi, implantoloji, endodonti ve estetik diş hekimliği kongrelerine düzenli olarak katılır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 74);
-- SR + EN: «Govori engleski jezik.»
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 3);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista oralne hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Petar Popović — Specijalista ortopedije vilica
-- ───────────────────────────────────────────────────────────────
-- Уже в БД: id 1012, ортодонт (93), клиника kulusic-dental-clinic-niksic (#99). Био в БД дословно совпадает с
-- /portfolio-item/dr-petar-popovic/ (год диплома 2010, специализация 2016) — тот же человек. Только привязка,
-- поля врача не трогаем.
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'petar-popovic' LIMIT 1);
SELECT IF(@doctor_id IS NULL, 'WARNING: врач petar-popovic не найден — привязка пропущена', CONCAT('OK: petar-popovic = ', @doctor_id)) AS doctor_check;
-- EN: «Govori engleski jezik.» — добавляется INSERT IGNORE к уже имеющемуся SR
INSERT IGNORE INTO doctor_languages (doctor_id, language_id)
SELECT @doctor_id, l FROM (SELECT 3 AS l) x WHERE @doctor_id IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position)
SELECT @doctor_id, @clinic_id, 'Specijalista ortopedije vilica' FROM dual WHERE @doctor_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Milovan Popović — Doktor stomatologije, specijalista farmacije; izvršni direktor
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Milovan Popović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Popović Milovan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'milovan-popovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milovan-popovic', 'Milovan Popović', 'Милован Поповић', 'Милован Попович', 'Milovan Popovic', 'Dr',
	'https://dentalprotection.me/wp-content/uploads/2017/11/milovan-1.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Doktor stomatologije i specijalista farmacije. Rođen je 1978. u Cirihu. Stomatološki fakultet Univerziteta u Beogradu završio je 2009. godine, a nakon pripravničkog staža i stručnog ispita priključio se timu ordinacije „Dental Protection“, gdje pored rada sa pacijentima obavlja i funkciju izvršnog direktora. Specijalizaciju iz farmacije na Farmaceutskom fakultetu Univerziteta u Beogradu završio je 2016. godine. Od 2013. radi i kao stručni saradnik farmaceutske kompanije „KRKA“ i odgovorno lice za farmakovigilancu u Crnoj Gori.',
	description_sr_cyrl = 'Доктор стоматологије и специјалиста фармације. Рођен је 1978. у Цириху. Стоматолошки факултет Универзитета у Београду завршио је 2009. године, а након приправничког стажа и стручног испита прикључио се тиму ординације „Dental Protection“, гдје поред рада са пацијентима обавља и функцију извршног директора. Специјализацију из фармације на Фармацеутском факултету Универзитета у Београду завршио је 2016. године. Од 2013. ради и као стручни сарадник фармацеутске компаније „KRKA“ и одговорно лице за фармаковигиланцу у Црној Гори.',
	description_ru = 'Врач-стоматолог и специалист по фармации. Родился в 1978 году в Цюрихе. В 2009 году окончил стоматологический факультет Белградского университета, после интернатуры и профессионального экзамена присоединился к команде «Dental Protection», где наряду с приёмом пациентов занимает должность исполнительного директора. В 2016 году окончил специализацию по фармации на фармацевтическом факультете Белградского университета. С 2013 года также работает экспертом фармацевтической компании KRKA и отвечает за фармаконадзор в Черногории.',
	description_en = 'Doctor of dental medicine and pharmacy specialist. Born in 1978 in Zurich, he graduated from the School of Dentistry of the University of Belgrade in 2009 and, after his internship and licensing exam, joined the Dental Protection team, where besides treating patients he serves as executive director. He completed his specialisation in pharmacy at the Faculty of Pharmacy of the University of Belgrade in 2016. Since 2013 he has also worked as a medical adviser for the pharmaceutical company KRKA and as the person responsible for pharmacovigilance in Montenegro.',
	description_de = 'Zahnarzt und Facharzt für Pharmazie. Geboren 1978 in Zürich, schloss er 2009 das Zahnmedizinstudium an der Universität Belgrad ab und kam nach Praktikum und Fachprüfung in das Team von Dental Protection, wo er neben der Patientenbehandlung als Geschäftsführer tätig ist. 2016 schloss er die Fachausbildung in Pharmazie an der Pharmazeutischen Fakultät der Universität Belgrad ab. Seit 2013 arbeitet er zudem als Fachberater für das Pharmaunternehmen KRKA und als Verantwortlicher für Pharmakovigilanz in Montenegro.',
	description_tr = 'Diş hekimi ve eczacılık uzmanı. 1978''de Zürih''te doğdu; 2009''da Belgrad Üniversitesi Diş Hekimliği Fakültesinden mezun oldu, stajı ve mesleki sınavın ardından Dental Protection ekibine katıldı ve burada hasta tedavisinin yanı sıra icra direktörlüğü görevini yürütüyor. 2016''da Belgrad Üniversitesi Eczacılık Fakültesinde eczacılık uzmanlığını tamamladı. 2013''ten beri KRKA ilaç şirketinde uzman danışman ve Karadağ''da farmakovijilans sorumlusu olarak da çalışmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
-- SR + EN: «Govori engleski jezik.»
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 3);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije, specijalista farmacije; izvršni direktor')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 2, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id, c.latitude, c.longitude,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 5 врач(а/ей): novak-popovic, zana-popovic, marko-popovic, petar-popovic, milovan-popovic.
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

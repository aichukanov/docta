-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Dr Fatić Medical (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-dr-fatic-medical-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/poliklinika-dr-fatic-medical-podgorica.json):
--   * https://drfaticmedical.com/ — WordPress (REST закрыт), все 33 URL sitemap.xml: главная (блок «NAŠ TIM»),
--     /o-nama/, /kontakt/, 21 страница направлений, /dr-nikola-fatic-biografija/, 7 постов (в т.ч. RU-перечень
--     услуг 2023-02 и посты 2026-05 про EVLA/склеротерапию). Email — из JS-обфускации (eeb-скрипт).
--   * https://vaskularnahirurgija.me/ — персональный сайт Dr Nikola Fatić (WP REST, 68 страниц): тот же врач,
--     тот же адрес «Poliklinika Dr Fatić MEDICAL - Dr Vukašina Markovića 178» и телефон 067 006 115 → ОДНА
--     клиника; сайт — в описании и записи импорта.
--   * data/google-places/podgorica/poliklinika-dr-fatic-medical.json — place_id, координаты, телефон.
--     Второе место Google «Vaskularna hirurgija Dr Fatic Medical» (ChIJo4WevlXrTRMRhKuZovjs9nc, тот же адрес
--     178 и телефон, те же координаты) — дубль той же клиники, в запись импорта (отзывы — при выгрузке).
--
-- Сверка: адрес «Dr Vukašina Markovića 178» — сайт (футер, /kontakt/) = Google (второе место — с номером 178).
-- Телефоны: +382 67 006 115 (сайт + Google), +382 20 615 115 (сайт); +382 20 615 333 — факс, не записан.
--
-- Идемпотентно и самоисправляюще: клиника по google_place_id → slug; врачи по name_sr / перевёрнутому
-- имени / slug (Dejan Maraš и Redžeb — только по slug, см. блоки). Пустые поля существующих записей
-- дозаполняются, непустые не трогаются. description_* клиники и новых врачей — БЕЗУСЛОВНЫЙ UPDATE.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJR3tem2HrTRMRa4Lw8UHmfL0';
SET @clinic_slug = 'poliklinika-dr-fatic-medical-podgorica';

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
	'Poliklinika Dr Fatić Medical',
	'Поликлиника Др Фатић Medical',
	'Поликлиника Dr Fatić Medical',
	'Dr Vukašina Markovića 178',
	'Др Вукашина Марковића 178',
	'',
	'',
	'81000',
	42.43613590,
	19.24032120,
	'+38267006115;+38220615115',
	'drfaticmedical.info@gmail.com',
	'https://drfaticmedical.com/',
	'facebook.com/dr.nikola.fatic',
	'@poliklinika.drfaticmedical',
	'',
	'',
	'',
	'https://drfaticmedical.com/wp-content/uploads/2023/02/logo-novi-fatic2.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Др Фатић Medical', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Dr Fatić Medical', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Dr Vukašina Markovića 178', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Др Вукашина Марковића 178', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38267006115;+38220615115', phone),
	email = IF(email IS NULL OR email = '', 'drfaticmedical.info@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://drfaticmedical.com/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/dr.nikola.fatic', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', '@poliklinika.drfaticmedical', instagram),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://drfaticmedical.com/wp-content/uploads/2023/02/logo-novi-fatic2.png', logo_url),
	latitude = COALESCE(latitude, 42.43613590),
	longitude = COALESCE(longitude, 19.24032120)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Poliklinika u Podgorici, u ulici Dr Vukašina Markovića 178, u neposrednoj blizini Kliničkog centra Crne Gore (kod Krivog mosta). Osnovao ju je 2023. godine vaskularni hirurg dr Nikola Fatić. Poliklinika se bavi vaskularnom hirurgijom — uključujući endovensku lasersku ablaciju proširenih vena (EVLA) laserom Biolitec Leonardo talasne dužine 1470 nm, skleroterapiju i kolor dupleks pregled krvnih sudova — kao i estetskom i antiaging medicinom (botoks, hijaluronski fileri, mezoterapija, Dermapen, biorevitalizacija), laserskim tretmanima kože, stomatologijom i protetikom, opštom hirurgijom, urologijom, internom medicinom i kardiologijom, ultrazvučnom dijagnostikom i nutricionizmom. Laserska operacija vena radi se ambulantno, u lokalnoj anesteziji, a godišnje kontrole uključene su u cijenu paketa. Patohistološke i citološke analize obavljaju se u saradnji sa laboratorijom IGA lab. Dr Fatić o vaskularnoj hirurgiji piše i na sajtu vaskularnahirurgija.me, preko kojeg se mogu zakazati i online konsultacije.',
	description_sr_cyrl = 'Поликлиника у Подгорици, у улици Др Вукашина Марковића 178, у непосредној близини Клиничког центра Црне Горе (код Кривог моста). Основао ју је 2023. године васкуларни хирург др Никола Фатић. Поликлиника се бави васкуларном хирургијом — укључујући ендовенску ласерску аблацију проширених вена (EVLA) ласером Biolitec Leonardo таласне дужине 1470 nm, склеротерапију и колор дуплекс преглед крвних судова — као и естетском и антиагинг медицином (ботокс, хијалуронски филери, мезотерапија, Dermapen, биоревитализација), ласерским третманима коже, стоматологијом и протетиком, општом хирургијом, урологијом, интерном медицином и кардиологијом, ултразвучном дијагностиком и нутриционизмом. Ласерска операција вена ради се амбулантно, у локалној анестезији, а годишње контроле укључене су у цијену пакета. Патохистолошке и цитолошке анализе обављају се у сарадњи са лабораторијом IGA lab. Др Фатић о васкуларној хирургији пише и на сајту vaskularnahirurgija.me, преко којег се могу заказати и онлине консултације.',
	description_ru = 'Поликлиника в Подгорице на улице Доктора Вукашина Марковича, 178, рядом с Клиническим центром Черногории (у Кривого моста). Основана в 2023 году сосудистым хирургом доктором Николой Фатичем. Поликлиника работает в области сосудистой хирургии — в том числе эндовенозная лазерная абляция варикозных вен (EVLA) лазером Biolitec Leonardo с длиной волны 1470 nm, склеротерапия и цветное дуплексное сканирование сосудов, — а также эстетической и anti-age медицины (ботокс, гиалуроновые филлеры, мезотерапия, Dermapen, биоревитализация), лазерных процедур для кожи, стоматологии и протезирования, общей хирургии, урологии, терапии и кардиологии, ультразвуковой диагностики и нутрициологии. Лазерная операция на венах проводится амбулаторно под местной анестезией, ежегодные контрольные осмотры включены в стоимость пакета. Патогистологические и цитологические исследования выполняются совместно с лабораторией IGA lab. О сосудистой хирургии доктор Фатич пишет и на сайте vaskularnahirurgija.me, где можно записаться на онлайн-консультацию.',
	description_en = 'A polyclinic in Podgorica at Dr Vukašina Markovića 178, close to the Clinical Centre of Montenegro (near Krivi most). It was founded in 2023 by the vascular surgeon Dr Nikola Fatić. The polyclinic covers vascular surgery — including endovenous laser ablation of varicose veins (EVLA) with a 1470 nm Biolitec Leonardo laser, sclerotherapy and colour duplex scanning of blood vessels — as well as aesthetic and anti-ageing medicine (Botox, hyaluronic fillers, mesotherapy, Dermapen, biorevitalisation), laser skin treatments, dentistry and prosthodontics, general surgery, urology, internal medicine and cardiology, ultrasound diagnostics and nutrition. Laser vein surgery is performed as an outpatient procedure under local anaesthesia, and annual follow-ups are included in the package price. Histopathology and cytology are carried out in cooperation with the IGA lab laboratory. Dr Fatić also writes about vascular surgery on vaskularnahirurgija.me, where online consultations can be booked.',
	description_de = 'Poliklinik in Podgorica, Dr Vukašina Markovića 178, in unmittelbarer Nähe des Klinischen Zentrums Montenegros (beim Krivi most). Gegründet wurde sie 2023 vom Gefäßchirurgen Dr. Nikola Fatić. Die Poliklinik bietet Gefäßchirurgie — darunter endovenöse Laserablation von Krampfadern (EVLA) mit dem Biolitec-Leonardo-Laser (1470 nm), Sklerotherapie und farbkodierte Duplexsonografie der Gefäße — sowie ästhetische und Anti-Aging-Medizin (Botox, Hyaluronfiller, Mesotherapie, Dermapen, Biorevitalisierung), Laserbehandlungen der Haut, Zahnmedizin und Prothetik, Allgemeinchirurgie, Urologie, Innere Medizin und Kardiologie, Ultraschalldiagnostik und Ernährungsberatung. Die Laser-Venenoperation erfolgt ambulant in örtlicher Betäubung; jährliche Kontrollen sind im Paketpreis enthalten. Histopathologische und zytologische Untersuchungen erfolgen in Zusammenarbeit mit dem Labor IGA lab. Über Gefäßchirurgie schreibt Dr. Fatić auch auf vaskularnahirurgija.me, wo Online-Konsultationen gebucht werden können.',
	description_tr = 'Podgorica''da Dr Vukašina Markovića 178 adresinde, Karadağ Klinik Merkezinin hemen yakınında (Krivi most yanında) bir poliklinik. 2023''te damar cerrahı Dr. Nikola Fatić tarafından kuruldu. Poliklinik; 1470 nm Biolitec Leonardo lazeriyle varislerde endovenöz lazer ablasyon (EVLA), skleroterapi ve damarların renkli dupleks incelemesi dahil damar cerrahisi ile estetik ve anti-aging tıp (botoks, hiyalüronik dolgu, mezoterapi, Dermapen, biyorevitalizasyon), lazer cilt uygulamaları, diş hekimliği ve protez, genel cerrahi, üroloji, dahiliye ve kardiyoloji, ultrason tanısı ve beslenme danışmanlığı hizmetleri sunar. Lazerle varis ameliyatı ayakta, lokal anestezi altında yapılır; yıllık kontroller paket fiyatına dahildir. Histopatoloji ve sitoloji incelemeleri IGA lab laboratuvarıyla iş birliği içinde yapılır. Dr. Fatić damar cerrahisi hakkında vaskularnahirurgija.me sitesinde de yazmaktadır; bu site üzerinden online konsültasyon randevusu alınabilir.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках (русский пост 2023 — перевод перечня услуг, не обещание приёма) → только SR.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Футер drfaticmedical.com: «Ponedeljak-petak: 09.00 - 13.00 i 16.00 - 20.00, Subotom i nedeljom: Zatvoreno». ⚠️ vaskularnahirurgija.me/zakazite-pregled (2024-07) пишет «Pon-Petak: 10-14, 16-20h, Subotom: 9-14h» — взят основной сайт.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "09:00", "end": "13:00"}, {"start": "16:00", "end": "20:00"}]}',
	'{"type": "closed"}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (8)
-- Состав: блок «NAŠ TIM» главной (7) + уролог со страницы /urologija/ (1).
-- Специальности: 34 = VASCULAR_SURGERY, 78 = DENTISTRY, 44 = AESTHETIC_MEDICINE, 3 = GENERAL_SURGERY,
-- 2 = INTERNAL_MEDICINE, 1 = CARDIOLOGY, 9 = UROLOGY. Языки: SR всем; EN+RU — только Nikola Fatić (CV).
-- Фото: настоящий портрет только у Nikola Fatić; у остальных на сайте заглушки m.jpg/f.jpg → NULL.
-- Найдены в БД (3): nikola-fatic, srdjan-perazic, redzeb-zeinalagic. Новые (5): andjela-fatic, ivan-drobnjak,
-- dejan-maras-2, jaksa-radovic, rade-stanisavljevic (прод-API 204 по обоим порядкам имени).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Doc. Dr Nikola Fatić — spec. vaskularne hirurgije, osnivač Poliklinike
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: nikola-fatic (локаль и прод id 737, VASCULAR_SURGERY, КЦЦГ) — тот же врач,
-- в CV на сайте КЦЦГ указан как место работы. Титул в БД («prim. dr sc. med.») не трогаем.
-- Фото: в БД пусто → портрет с сайта (wp-content/uploads/2025/07/DR2.jpg). Языки из CV
-- (/dr-nikola-fatic-biografija/): «Engleski — Tečno, Ruski — Komunikacijski nivo» → EN (3), RU (2).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nikola Fatić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Fatić Nikola' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nikola-fatic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikola-fatic', 'Nikola Fatić', 'Никола Фатић', 'Никола Фатич', 'Nikola Fatic', 'prim. dr sc. med.',
	'https://drfaticmedical.com/wp-content/uploads/2025/07/DR2.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: фото только если пустое.
UPDATE doctors SET photo_url = 'https://drfaticmedical.com/wp-content/uploads/2025/07/DR2.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');

-- Существующая карточка: био пишется, только если его ещё нет.
UPDATE doctors SET
	description_sr = 'Vaskularni hirurg i doktor medicinskih nauka, osnivač Poliklinike Dr Fatić Medical (2023). Rođen je 1984. godine u Nikšiću. Medicinski fakultet u Beogradu završio je 2009. godine kao prvi u generaciji, a doktorsku tezu o faktorima rizika za bolničku smrtnost kod akutne disekcije aorte tipa III odbranio je na Medicinskom fakultetu u Kragujevcu. Specijalizaciju iz vaskularne hirurgije obavljao je u Kliničkom centru Crne Gore, Kliničkom centru Srbije, Institutu „Dedinje“ i na vaskularnom odjeljenju bolnice St Mary (Imperial College London). Radio je kao vaskularni hirurg u Kliničkom centru Crne Gore i kao načelnik centra za vaskularnu hirurgiju klinike „Novi Cenex Medical“; asistent je iz oblasti vaskularne hirurgije na Medicinskom fakultetu u Podgorici i docent na Farmaceutskom fakultetu Univerziteta EDUKONS. Bavi se endovenskom laserskom ablacijom proširenih vena (EVLA). Govori engleski, a ruski na komunikacijskom nivou.',
	description_sr_cyrl = 'Васкуларни хирург и доктор медицинских наука, оснивач Поликлинике Др Фатић Medical (2023). Рођен је 1984. године у Никшићу. Медицински факултет у Београду завршио је 2009. године као први у генерацији, а докторску тезу о факторима ризика за болничку смртност код акутне дисекције аорте типа III одбранио је на Медицинском факултету у Крагујевцу. Специјализацију из васкуларне хирургије обављао је у Клиничком центру Црне Горе, Клиничком центру Србије, Институту „Дедиње“ и на васкуларном одјељењу болнице St Mary (Imperial College London). Радио је као васкуларни хирург у Клиничком центру Црне Горе и као начелник центра за васкуларну хирургију клинике „Novi Cenex Medical“; асистент је из области васкуларне хирургије на Медицинском факултету у Подгорици и доцент на Фармацеутском факултету Универзитета EDUKONS. Бави се ендовенском ласерском аблацијом проширених вена (EVLA). Говори енглески, а руски на комуникацијском нивоу.',
	description_ru = 'Сосудистый хирург, доктор медицинских наук, основатель поликлиники Dr Fatić Medical (2023). Родился в 1984 году в Никшиче. В 2009 году первым в своём выпуске окончил медицинский факультет в Белграде, защитил докторскую диссертацию о факторах риска госпитальной смертности при острой расслаивающей аневризме аорты III типа на медицинском факультете в Крагуеваце. Специализацию по сосудистой хирургии проходил в Клиническом центре Черногории, Клиническом центре Сербии, Институте «Дединье» и в сосудистом отделении больницы St Mary (Imperial College London). Работал сосудистым хирургом в Клиническом центре Черногории и руководителем центра сосудистой хирургии клиники «Novi Cenex Medical»; ассистент кафедры хирургии (сосудистая хирургия) медицинского факультета в Подгорице, доцент фармацевтического факультета Университета EDUKONS. Выполняет эндовенозную лазерную абляцию варикозных вен (EVLA). Владеет английским, русским — на разговорном уровне.',
	description_en = 'Vascular surgeon with a doctorate in medical sciences and founder of the Dr Fatić Medical polyclinic (2023). Born in 1984 in Nikšić, he graduated top of his class from the Faculty of Medicine in Belgrade in 2009 and defended his doctoral thesis on risk factors for in-hospital mortality in acute type III aortic dissection at the Faculty of Medicine in Kragujevac. He trained in vascular surgery at the Clinical Centre of Montenegro, the Clinical Centre of Serbia, the Dedinje Institute and the vascular unit of St Mary''s Hospital (Imperial College London). He has worked as a vascular surgeon at the Clinical Centre of Montenegro and as head of the vascular surgery centre at the Novi Cenex Medical clinic; he is a teaching assistant in vascular surgery at the Faculty of Medicine in Podgorica and an assistant professor at the Faculty of Pharmacy of EDUKONS University. He performs endovenous laser ablation of varicose veins (EVLA). He speaks English and conversational Russian.',
	description_de = 'Gefäßchirurg mit Doktortitel in Medizin und Gründer der Poliklinik Dr Fatić Medical (2023). Geboren 1984 in Nikšić, schloss er 2009 das Medizinstudium in Belgrad als Jahrgangsbester ab und verteidigte an der Medizinischen Fakultät in Kragujevac seine Dissertation über Risikofaktoren der Krankenhaussterblichkeit bei akuter Aortendissektion Typ III. Seine Facharztausbildung in Gefäßchirurgie absolvierte er am Klinischen Zentrum Montenegros, am Klinischen Zentrum Serbiens, am Institut „Dedinje“ und in der Gefäßabteilung des St Mary''s Hospital (Imperial College London). Er arbeitete als Gefäßchirurg am Klinischen Zentrum Montenegros und als Leiter des Zentrums für Gefäßchirurgie der Klinik Novi Cenex Medical; er ist Assistent für Gefäßchirurgie an der Medizinischen Fakultät in Podgorica und Dozent an der Pharmazeutischen Fakultät der Universität EDUKONS. Er führt die endovenöse Laserablation von Krampfadern (EVLA) durch. Er spricht Englisch und Russisch auf Konversationsniveau.',
	description_tr = 'Damar cerrahı, tıp bilimleri doktoru ve Dr Fatić Medical polikliniğinin kurucusu (2023). 1984''te Nikšić''te doğdu; 2009''da Belgrad Tıp Fakültesinden dönem birincisi olarak mezun oldu ve Kragujevac Tıp Fakültesinde akut tip III aort diseksiyonunda hastane içi ölüm risk faktörleri üzerine doktora tezini savundu. Damar cerrahisi uzmanlık eğitimini Karadağ Klinik Merkezi, Sırbistan Klinik Merkezi, Dedinje Enstitüsü ve St Mary Hastanesi damar ünitesinde (Imperial College London) aldı. Karadağ Klinik Merkezinde damar cerrahı ve Novi Cenex Medical kliniğinde damar cerrahisi merkezi başkanı olarak çalıştı; Podgorica Tıp Fakültesinde damar cerrahisi asistanı ve EDUKONS Üniversitesi Eczacılık Fakültesinde doçenttir. Varis tedavisinde endovenöz lazer ablasyon (EVLA) uygulamaktadır. İngilizce ve konuşma düzeyinde Rusça bilmektedir.'
WHERE id = @doctor_id AND (description_sr IS NULL OR description_sr = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 34);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1), (@doctor_id, 2), (@doctor_id, 3);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista vaskularne hirurgije, osnivač Poliklinike')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Anđela Fatić — doktor stomatologije, ljekar estetske i antiaging medicine
-- Фото на сайте — общая заглушка «f.jpg» (wp-content/uploads/2023/03/f.jpg) → photo_url NULL.
-- Страницы Antiaging и Laserski tretmani: «zadužena je dr stom. ANĐELA FATIĆ» → привязки к услугам.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Anđela Fatić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Fatić Anđela' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'andjela-fatic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andjela-fatic', 'Anđela Fatić', 'Анђела Фатић', 'Анджела Фатич', 'Andjela Fatic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78), (@doctor_id, 44);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor stomatologije i sertifikovani ljekar estetske i antiaging medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Ivan Drobnjak — specijalista opšte hirurgije
-- Фото — заглушка «m.jpg» → NULL. Однофамилица Tanja Drobnjak (ДЗ Будва) — другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ivan Drobnjak' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Drobnjak Ivan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ivan-drobnjak' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivan-drobnjak', 'Ivan Drobnjak', 'Иван Дробњак', 'Иван Дробняк', 'Ivan Drobnjak', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 3);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista opšte hirurgije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Dejan Maraš — specijalista interne medicine
-- ⚠️ Отдельная карточка с новым slug dejan-maras-2 (правило юзера: тёзка с другой специальностью —
-- отдельная карточка). В БД/проде уже есть dejan-maras (прод id 2012, ANESTHESIOLOGY, Mićunović Medical) —
-- поиск ТОЛЬКО по slug, чтобы не прилипнуть к нему по имени. Фото — заглушка «m.jpg» → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'dejan-maras-2' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dejan-maras-2', 'Dejan Maraš', 'Дејан Мараш', 'Деян Мараш', 'Dejan Maras', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista interne medicine')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Srđan Perazić — kardiolog
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: srdjan-perazic (прод id 1722, CARDIOLOGY + INTERNAL_MEDICINE; ДЗ Подгорица,
-- Moj Doktor Nikšić, Novi Cenex) — тот же кардиолог. Фото на сайте — заглушка, у карточки фото нет.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Srđan Perazić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Perazić Srđan' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'srdjan-perazic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'srdjan-perazic', 'Srđan Perazić', 'Срђан Перазић', 'Срджан Перазич', 'Srdjan Perazic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Kardiolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Redžeb Zejnelagić (в БД — Zeinalagić) — nutricionista
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ (по slug): redzeb-zeinalagic (прод id 1918) — «Redžeb Zeinalagić», ДЗ Никшич,
-- Higijensko-epidemiološka služba, спец. 52. Сайт пишет «Zejnelagić» — транслитерационный вариант
-- того же имени (Zejnel/Zeinal); специальность совпадает по сути (гигиена ↔ нутрициология). Имя в БД
-- не меняем, вариант — в openQuestions записи импорта. Фото на сайте — заглушка.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'redzeb-zeinalagic' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'redzeb-zeinalagic', 'Redžeb Zeinalagić', 'Реџеб Зеиналагић', 'Реджеб Зейналагич', 'Redzeb Zeinalagic', 'dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Nutricionista')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Jakša Radović — stomatolog
-- Фото — заглушка «m.jpg» → NULL. Однофамильцы Radović в БД — другие люди (Jakše нет).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jakša Radović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Radović Jakša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jaksa-radovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jaksa-radovic', 'Jakša Radović', 'Јакша Радовић', 'Якша Радович', 'Jaksa Radovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 78);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Stomatolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dr Rade Stanisavljević — spec. urolog
-- Нет в блоке «NAŠ TIM»; на /urologija/: «zadužen je dr Rade Stanisavljević, spec. urolog».
-- Фото нет. Привязан к урологическим услугам.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Rade Stanisavljević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Stanisavljević Rade' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'rade-stanisavljevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'rade-stanisavljevic', 'Rade Stanisavljević', 'Раде Станисављевић', 'Раде Станиславлевич', 'Rade Stanisavljevic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista urolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = 1, clinic_types = 1, hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 8 врачей. Существующие (created_at старше сегодня): nikola-fatic (теперь с фото, био, языки 1,2,3), srdjan-perazic, redzeb-zeinalagic; dejan-maras-2 — НОВЫЙ id, не 2012/3254.
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

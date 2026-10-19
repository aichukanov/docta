-- ═══════════════════════════════════════════════════════════════════════════
-- Dr Radunović – kiropraktika i fizioterapija (Podgorica) — клиника + специалисты
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dr-radunovic-kiropraktika-podgorica.sql
-- Затем: server/sql/insert-clinic-dr-radunovic-kiropraktika-podgorica-services.sql
-- Запись импорта: data/clinic-imports/dr-radunovic-kiropraktika-podgorica.json. Подволна 2d, агент U.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://kiropraktika.me/ — GoDaddy Website Builder, © 2022, sitemap lastmod 2025-05-25 у всех 29 страниц.
--     Прочитаны: главная, /o-nama, /kiropraktika, 6 страниц меню «Usluge» (Vježbe, Masaže, Jontoforeza, Graston tehnika,
--     Spinalna dekompresija, Plavi koktel), /video и 18 страниц состояний (diskus hernija, skolioza, spondiloza …).
--     Цен нет нигде. Email на сайте нет (пустой mailto). Логотипа-картинки нет (текстовый).
--   * data/google-places/podgorica/dr-radunovic-chiropractic-physical-therapy.json — place_id, координаты
--     42.4440357 / 19.2639713, +382 69 317 317, «BB Vaka Đurovića, Podgorica 81000» (Google не перезапрашивался; 82 отзыва).
-- 
-- Название: Google «Dr Radunovic - Chiropractic & Physical Therapy», юрлицо «PZU DR RADUNOVIĆ», шапка сайта
-- «Kiropraktika Fizioterapija Rehabilitacija» → name_sr «Dr Radunović – kiropraktika i fizioterapija».
-- Адрес: Google «BB Vaka Đurovića» + сайт «Stadion pod Goricom - Trg Argentina, Podgorica». Индекс 81000.
-- Соцсети/WhatsApp — ссылки сайта (facebook.com/drradunovic, instagram.com/drsavo, wa.me/38269317317).
-- 
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr; пустые поля дозаполняются,
-- описание клиники пишется безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJR59Y3w_rTRMRQvdUlNg7kZM';
SET @clinic_slug = 'dr-radunovic-kiropraktika-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Dr Radunović – kiropraktika i fizioterapija', 'Dr Radunovic - Chiropractic & Physical Therapy', 'PZU Dr Radunović', 'Dr Radunović') AND city_id = 1 LIMIT 1));

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
	'Dr Radunović – kiropraktika i fizioterapija',
	'Др Радуновић – киропрактика и физиотерапија',
	'Хиропрактика и физиотерапия Dr Radunović',
	'Vaka Đurovića bb (Stadion pod Goricom – Trg Argentina)',
	'Вака Ђуровића бб (Стадион под Горицом – Трг Аргентина)',
	'',
	'',
	'81000',
	42.44403570,
	19.26397130,
	'+38269317317',
	'',
	'https://kiropraktika.me/',
	'facebook.com/drradunovic',
	'instagram.com/drsavo',
	'',
	'+38269317317',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.44403570, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.26397130, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Др Радуновић – киропрактика и физиотерапија', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Хиропрактика и физиотерапия Dr Radunović', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vaka Đurovića bb (Stadion pod Goricom – Trg Argentina)', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Вака Ђуровића бб (Стадион под Горицом – Трг Аргентина)', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269317317', phone),
	website = IF(website IS NULL OR website = '', 'https://kiropraktika.me/', website),
	facebook = IF(facebook IS NULL OR facebook = '', 'facebook.com/drradunovic', facebook),
	instagram = IF(instagram IS NULL OR instagram = '', 'instagram.com/drsavo', instagram),
	whatsapp = IF(whatsapp IS NULL OR whatsapp = '', '+38269317317', whatsapp)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Privatna zdravstvena ustanova PZU Dr Radunović u Podgorici, kod Stadiona pod Goricom (Trg Argentina), bavi se kiropraktikom, fizioterapijom i rehabilitacijom. U ordinaciji radi dr Savo Radunović, doktor kiropraktike — prema navodima ustanove, za sada jedini doktor kiropraktike u Crnoj Gori — koji je zvanje stekao na Cleveland Chiropractic College u Los Anđelesu i privatnu praksu u Podgorici vodi od 2010. godine, i sportski fizioterapeut Ljubo Radunović sa skoro 40 godina iskustva u radu sa profesionalnim sportistima. Ustanova liječi stanja neuro-mišićno-koštanog sistema: diskus herniju, skoliozu, spondilozu i spondilolistezu, faset sindrom, piriformis sindrom, glavobolje i vrtoglavice porijeklom iz vrata, gonartrozu, povrede ligamenata, meniskusa i mišića, skočnog zgloba, Ahilove tetive i lakta. U ponudi su kiropraktičko namještanje, kompjuterizovana spinalna dekompresija, Graston tehnika, jontoforeza za hiperhidrozu, laser visokog intenziteta, Tecar terapija, magnetoterapija, terapijski ultrazvuk, Schroth metoda, grupne vježbe za zdravu kičmu i individualne vježbe sa terapeutom, kao i relaks, parcijalna, sportska i terapeutska masaža i masaža lica i dekoltea. Kiropraktika i fizioterapija se često kombinuju u istom planu liječenja. Konsultacije se zakazuju telefonom, najbolje dan unaprijed; za prvi pregled snimak nije potreban. Radno vrijeme: ponedjeljak–petak od 12 do 20 h, vikendom od 10 do 13 h.',
	description_sr_cyrl = 'Приватна здравствена установа ПЗУ Др Радуновић у Подгорици, код Стадиона под Горицом (Трг Аргентина), бави се киропрактиком, физиотерапијом и рехабилитацијом. У ординацији ради др Саво Радуновић, доктор киропрактике — према наводима установе, за сада једини доктор киропрактике у Црној Гори — који је звање стекао на Cleveland Chiropractic College у Лос Анђелесу и приватну праксу у Подгорици води од 2010. године, и спортски физиотерапеут Љубо Радуновић са скоро 40 година искуства у раду са професионалним спортистима. Установа лијечи стања неуро-мишићно-коштаног система: дискус хернију, сколиозу, спондилозу и спондилолистезу, фасет синдром, пириформис синдром, главобоље и вртоглавице поријеклом из врата, гонартрозу, повреде лигамената, менискуса и мишића, скочног зглоба, Ахилове тетиве и лакта. У понуди су киропрактичко намјештање, компјутеризована спинална декомпресија, Грастон техника, јонтофореза за хиперхидрозу, ласер високог интензитета, Tecar терапија, магнетотерапија, терапијски ултразвук, Schroth метода, групне вјежбе за здраву кичму и индивидуалне вјежбе са терапеутом, као и релакс, парцијална, спортска и терапеутска масажа и масажа лица и деколтеа. Киропрактика и физиотерапија се често комбинују у истом плану лијечења. Консултације се заказују телефоном, најбоље дан унапријед; за први преглед снимак није потребан. Радно вријеме: понедјељак–петак од 12 до 20 х, викендом од 10 до 13 х.',
	description_ru = 'Частное медицинское учреждение PZU Dr Radunović в Подгорице, у стадиона «Под Горицей» (Trg Argentina), занимается хиропрактикой, физиотерапией и реабилитацией. Здесь принимает доктор хиропрактики Саво Радунович — по словам клиники, пока единственный доктор хиропрактики в Черногории; степень он получил в Cleveland Chiropractic College в Лос-Анджелесе и ведёт частную практику в Подгорице с 2010 года. Вместе с ним работает спортивный физиотерапевт Любо Радунович, почти 40 лет работающий с профессиональными спортсменами. Клиника лечит заболевания нервно-мышечно-скелетной системы: грыжи межпозвонковых дисков, сколиоз, спондилёз и спондилолистез, фасеточный синдром, синдром грушевидной мышцы, головные боли и головокружения шейного происхождения, гонартроз, травмы связок, менисков и мышц, голеностопа, ахиллова сухожилия и локтя. Доступны хиропрактическое вправление, компьютеризированная декомпрессия позвоночника, техника Graston, ионофорез при гипергидрозе, высокоинтенсивная лазерная терапия, Tecar-терапия, магнитотерапия, терапевтический ультразвук, метод Шрота, групповые упражнения для здоровья позвоночника и индивидуальные занятия с терапевтом, а также расслабляющий, частичный, спортивный и лечебный массаж и массаж лица и зоны декольте. Хиропрактику и физиотерапию часто сочетают в одном плане лечения. Консультации записываются по телефону, лучше за день; снимки для первого приёма не нужны. Часы работы: понедельник–пятница с 12 до 20, в выходные с 10 до 13.',
	description_en = 'The private health facility PZU Dr Radunović in Podgorica, by the Pod Goricom stadium (Trg Argentina), provides chiropractic care, physiotherapy and rehabilitation. Dr Savo Radunović, a doctor of chiropractic — according to the practice, so far the only one in Montenegro — earned his degree at Cleveland Chiropractic College in Los Angeles and has run his private practice in Podgorica since 2010; he works alongside sports physiotherapist Ljubo Radunović, who has almost 40 years of experience with professional athletes. The practice treats conditions of the neuromusculoskeletal system: disc herniation, scoliosis, spondylosis and spondylolisthesis, facet syndrome, piriformis syndrome, cervicogenic headaches and vertigo, knee osteoarthritis, and injuries of ligaments, menisci, muscles, the ankle, the Achilles tendon and the elbow. Treatments include chiropractic adjustments, computerised spinal decompression, the Graston technique, iontophoresis for hyperhidrosis, high-intensity laser therapy, Tecar therapy, magnetic therapy, therapeutic ultrasound, the Schroth method, group exercises for a healthy spine and individual exercises with a therapist, as well as relaxation, partial, sports and therapeutic massage and face and décolleté massage. Chiropractic and physiotherapy are often combined in one treatment plan. Consultations are booked by phone, ideally a day in advance; no imaging is needed for the first visit. Opening hours: Monday–Friday 12:00–20:00, weekends 10:00–13:00.',
	description_de = 'Die private Gesundheitseinrichtung PZU Dr Radunović in Podgorica, am Stadion Pod Goricom (Trg Argentina), bietet Chiropraktik, Physiotherapie und Rehabilitation. Hier praktiziert Dr. Savo Radunović, Doktor der Chiropraktik — nach Angaben der Praxis bislang der einzige in Montenegro —, der seinen Abschluss am Cleveland Chiropractic College in Los Angeles erworben hat und seit 2010 eine Privatpraxis in Podgorica führt; mit ihm arbeitet der Sportphysiotherapeut Ljubo Radunović, der seit fast 40 Jahren Profisportler betreut. Behandelt werden Erkrankungen des neuromuskuloskelettalen Systems: Bandscheibenvorfälle, Skoliose, Spondylose und Spondylolisthesis, Facettensyndrom, Piriformis-Syndrom, zervikogene Kopfschmerzen und Schwindel, Gonarthrose sowie Verletzungen von Bändern, Menisken und Muskeln, des Sprunggelenks, der Achillessehne und des Ellenbogens. Angeboten werden chiropraktische Justierungen, computergesteuerte Wirbelsäulendekompression, Graston-Technik, Iontophorese bei Hyperhidrose, Hochintensitätslaser, Tecar-Therapie, Magnetfeldtherapie, therapeutischer Ultraschall, Schroth-Methode, Gruppenübungen für eine gesunde Wirbelsäule und Einzeltraining mit dem Therapeuten sowie Entspannungs-, Teil-, Sport- und Heilmassage und Gesichts- und Dekolletémassage. Chiropraktik und Physiotherapie werden oft in einem Behandlungsplan kombiniert. Beratungstermine werden telefonisch vereinbart, am besten einen Tag im Voraus; für den ersten Termin sind keine Aufnahmen nötig. Öffnungszeiten: Montag–Freitag 12–20 Uhr, am Wochenende 10–13 Uhr.',
	description_tr = 'Podgorica''da, Pod Goricom stadyumu yanında (Trg Argentina) bulunan özel sağlık kuruluşu PZU Dr Radunović kayropraktik, fizyoterapi ve rehabilitasyon hizmeti verir. Kurumda, kliniğin ifadesine göre şimdilik Karadağ''daki tek kayropraktik doktoru olan, unvanını Los Angeles''taki Cleveland Chiropractic College''da alan ve 2010''dan beri Podgorica''da özel muayenehane işleten Dr. Savo Radunović ile profesyonel sporcularla yaklaşık 40 yıllık deneyime sahip spor fizyoterapisti Ljubo Radunović çalışır. Kurum nöro-kas-iskelet sistemi rahatsızlıklarını tedavi eder: disk hernisi, skolyoz, spondiloz ve spondilolistezis, faset sendromu, piriformis sendromu, boyun kaynaklı baş ağrısı ve baş dönmesi, diz osteoartriti ile bağ, menisküs, kas, ayak bileği, Aşil tendonu ve dirsek yaralanmaları. Kayropraktik düzeltme, bilgisayarlı spinal dekompresyon, Graston tekniği, hiperhidroz için iyontoforez, yüksek yoğunluklu lazer, Tecar tedavisi, manyetoterapi, terapötik ultrason, Schroth yöntemi, sağlıklı omurga için grup egzersizleri ve terapistle bireysel egzersizlerin yanı sıra rahatlatıcı, bölgesel, spor ve terapötik masaj ile yüz ve dekolte masajı sunulur. Kayropraktik ve fizyoterapi çoğu zaman aynı tedavi planında birleştirilir. Konsültasyonlar telefonla, tercihen bir gün önceden alınır; ilk muayene için görüntüleme gerekmez. Çalışma saatleri: pazartesi–cuma 12:00–20:00, hafta sonu 10:00–13:00.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24 (как axon-fizikalna-terapija-podgorica, physiocare-team-podgorica): кабинет хиропрактики и физиотерапии.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: подвал всех страниц «Radno vrijeme — Ponedeljak - petak: 12 - 8, Vikendom: 10 - 1» → 12:00–20:00 и 10:00–13:00 (12-часовая запись; «8» после «12» = 20 ч, «1» после «10» = 13 ч). Сб и Вс — «Vikendom».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "12:00", "end": "20:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "13:00"}]}',
	'{"type": "regular", "intervals": [{"start": "10:00", "end": "13:00"}]}'
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
-- Специалисты — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врачи-медики), как у других хиропрактиков в БД
-- (aleksandar-vidic, janko-stojovic — 94, title пуст). Своей специальности «хиропрактика» в enum нет; Savo Radunović к тому же
-- диплом. физиотерапевт (Visoka zdravstvena škola, Beograd). Источник: /o-nama («naša misija...vaše zdravlje»).
-- Оба в БД не найдены (локаль: Radunović — только врачи-медики других специальностей; прод-API 204) — новые.
-- Языки: 1 = SR (другие не заявлены; учёба в США — не заявление о приёме на английском). Фото — внешние URL сайта (200).
-- Медсёстры из отзывов не заводятся (решение юзера 2026-10-08).

-- ───────────────────────────────────────────────────────────────
-- Savo Radunović — /o-nama «DR SAVO RADUNOVIĆ — doktor kiropraktike»; title NULL: «Dr» здесь — Doctor of Chiropractic, не врач-медик (звание — в position).
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Savo Radunović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Radunović Savo' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'savo-radunovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'savo-radunovic', 'Savo Radunović', 'Саво Радуновић', 'Саво Радунович', 'Savo Radunovic', NULL,
	'https://img1.wsimg.com/isteam/ip/7ef11ffa-485e-45b2-b785-7c4940387c6b/84EA90F9-EC41-4F4D-BA35-51B097429CBF.jpeg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://img1.wsimg.com/isteam/ip/7ef11ffa-485e-45b2-b785-7c4940387c6b/84EA90F9-EC41-4F4D-BA35-51B097429CBF.jpeg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Doktor kiropraktike. Rođen je u Podgorici 1982. godine, gdje je 2001. završio srednju medicinsku školu, a do 2004. studirao je na Visokoj zdravstvenoj školi strukovnih studija u Beogradu, smjer diplomirani fizioterapeut. Od 2004. do 2006. studirao je biologiju (anatomija i fiziologija čovjeka) i pre-med na Grand Canyon University u Feniksu (SAD), a zatim upisao postdiplomske studije na Cleveland Chiropractic College u Los Anđelesu, gdje je stekao zvanje doktora kiropraktike. U decembru 2010. vratio se u Podgoricu i, kao prvi doktor kiropraktike u Crnoj Gori, započeo privatnu praksu.',
	description_sr_cyrl = 'Доктор киропрактике. Рођен је у Подгорици 1982. године, гдје је 2001. завршио средњу медицинску школу, а до 2004. студирао је на Високој здравственој школи струковних студија у Београду, смјер дипломирани физиотерапеут. Од 2004. до 2006. студирао је биологију (анатомија и физиологија човјека) и pre-med на Grand Canyon University у Фениксу (САД), а затим уписао постдипломске студије на Cleveland Chiropractic College у Лос Анђелесу, гдје је стекао звање доктора киропрактике. У децембру 2010. вратио се у Подгорицу и, као први доктор киропрактике у Црној Гори, започео приватну праксу.',
	description_ru = 'Доктор хиропрактики. Родился в Подгорице в 1982 году; в 2001 году окончил там среднюю медицинскую школу, до 2004 года учился в Высшей школе здравоохранения профессиональных исследований в Белграде по специальности «дипломированный физиотерапевт». С 2004 по 2006 год изучал биологию (анатомия и физиология человека) и pre-med в Grand Canyon University в Финиксе (США), затем поступил в аспирантуру Cleveland Chiropractic College в Лос-Анджелесе, где получил степень доктора хиропрактики. В декабре 2010 года вернулся в Подгорицу и открыл частную практику как первый доктор хиропрактики в Черногории.',
	description_en = 'Doctor of chiropractic. Born in Podgorica in 1982, he finished secondary medical school there in 2001 and until 2004 studied at the College of Health Professional Studies in Belgrade, majoring in physiotherapy. From 2004 to 2006 he studied biology (human anatomy and physiology) and pre-med at Grand Canyon University in Phoenix, USA, then enrolled in postgraduate studies at Cleveland Chiropractic College in Los Angeles, where he earned his Doctor of Chiropractic degree. In December 2010 he returned to Podgorica and opened a private practice as the first doctor of chiropractic in Montenegro.',
	description_de = 'Doktor der Chiropraktik. Geboren 1982 in Podgorica, schloss er dort 2001 die medizinische Fachoberschule ab und studierte bis 2004 an der Hochschule für Gesundheitsberufe in Belgrad, Fachrichtung Physiotherapie. Von 2004 bis 2006 studierte er Biologie (Anatomie und Physiologie des Menschen) und Pre-Med an der Grand Canyon University in Phoenix (USA) und anschließend am Cleveland Chiropractic College in Los Angeles, wo er den Titel Doctor of Chiropractic erwarb. Im Dezember 2010 kehrte er nach Podgorica zurück und eröffnete als erster Doktor der Chiropraktik in Montenegro eine Privatpraxis.',
	description_tr = 'Kayropraktik doktoru. 1982''de Podgorica''da doğdu; 2001''de burada sağlık meslek lisesini bitirdi, 2004''e kadar Belgrad''daki Mesleki Sağlık Yüksekokulu''nda fizyoterapi okudu. 2004–2006 yıllarında ABD''de Phoenix''teki Grand Canyon University''de biyoloji (insan anatomisi ve fizyolojisi) ve pre-med eğitimi aldı, ardından Los Angeles''taki Cleveland Chiropractic College''da lisansüstü eğitimle kayropraktik doktoru unvanını kazandı. Aralık 2010''da Podgorica''ya dönerek Karadağ''ın ilk kayropraktik doktoru olarak özel muayenehanesini açtı.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Doktor kiropraktike (DC)')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Ljubo Radunović — /o-nama «LJUBO RADUNOVIĆ — sportski fizioterapeut».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Ljubo Radunović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Radunović Ljubo' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'ljubo-radunovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljubo-radunovic', 'Ljubo Radunović', 'Љубо Радуновић', 'Любо Радунович', 'Ljubo Radunovic', NULL,
	'https://img1.wsimg.com/isteam/ip/7ef11ffa-485e-45b2-b785-7c4940387c6b/fb2229fcce4cefdd975038762e71a122.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://img1.wsimg.com/isteam/ip/7ef11ffa-485e-45b2-b785-7c4940387c6b/fb2229fcce4cefdd975038762e71a122.jpg', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Sportski fizioterapeut sa skoro 40 godina iskustva u radu sa profesionalnim sportistima. Radio je u FK Budućnost od 1976. do 2000. godine, a od 1988. do 2006. bio je član stručnog tima fudbalske reprezentacije Jugoslavije, kasnije Srbije i Crne Gore; od tada se posvećuje privatnoj praksi. U radu sa sportistima razvio je sopstveni pristup sportskim povredama, od dijagnostike do liječenja, a posebno se izdvojio u liječenju povreda koljena.',
	description_sr_cyrl = 'Спортски физиотерапеут са скоро 40 година искуства у раду са професионалним спортистима. Радио је у ФК Будућност од 1976. до 2000. године, а од 1988. до 2006. био је члан стручног тима фудбалске репрезентације Југославије, касније Србије и Црне Горе; од тада се посвећује приватној пракси. У раду са спортистима развио је сопствени приступ спортским повредама, од дијагностике до лијечења, а посебно се издвојио у лијечењу повреда кољена.',
	description_ru = 'Спортивный физиотерапевт, почти 40 лет работающий с профессиональными спортсменами. С 1976 по 2000 год работал в ФК «Будучност», с 1988 по 2006 год входил в штаб футбольной сборной Югославии, затем Сербии и Черногории; после этого посвятил себя частной практике. В работе со спортсменами выработал собственный подход к спортивным травмам — от диагностики до лечения; особенно известен лечением травм колена.',
	description_en = 'Sports physiotherapist with almost 40 years of experience working with professional athletes. He worked at FK Budućnost from 1976 to 2000 and from 1988 to 2006 was part of the staff of the national football team of Yugoslavia, later Serbia and Montenegro, after which he devoted himself to private practice. Working with athletes, he developed his own approach to sports injuries, from diagnosis to treatment, and is particularly known for treating knee injuries.',
	description_de = 'Sportphysiotherapeut mit fast 40 Jahren Erfahrung in der Arbeit mit Profisportlern. Von 1976 bis 2000 arbeitete er beim FK Budućnost, von 1988 bis 2006 gehörte er zum Betreuerstab der Fußballnationalmannschaft Jugoslawiens, später Serbiens und Montenegros; seitdem widmet er sich seiner Privatpraxis. In der Arbeit mit Sportlern entwickelte er einen eigenen Ansatz bei Sportverletzungen, von der Diagnostik bis zur Behandlung, und ist besonders für die Behandlung von Knieverletzungen bekannt.',
	description_tr = 'Profesyonel sporcularla yaklaşık 40 yıllık deneyime sahip spor fizyoterapisti. 1976–2000 yılları arasında FK Budućnost''ta çalıştı, 1988–2006 arasında Yugoslavya, sonra Sırbistan-Karadağ milli futbol takımının sağlık ekibinde yer aldı; o tarihten beri özel muayenehanesinde çalışıyor. Sporcularla çalışırken teşhisten tedaviye kadar spor yaralanmalarına kendine özgü bir yaklaşım geliştirdi ve özellikle diz yaralanmalarının tedavisiyle tanınır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Sportski fizioterapeut')
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

-- Ожидается 2: savo-radunovic (94), ljubo-radunovic (94).
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

-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Mercur Nera (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-mercur-nera-podgorica.sql
--
-- Источники (curl, 2026-10-08; запись импорта — data/clinic-imports/poliklinika-mercur-nera-podgorica.json):
--   * https://mercurnera.me/ (http://www.mercurnera.me/ редиректит туда же) — Joomla 1.5/K2, футер «© Mercurnera 2013».
--     Прочитаны главная, все статьи меню (id 71 O nama, 72 Kontakt, 73 Stručni tim, 74 Ambulantno liječenje,
--     75 Interna medicina, 76 Ginekologija, 77 Pedijatrija, 78 Laboratorija, 79 Mikrobiologija, 80 Konsultativni
--     pregledi, 81 Sistematski pregledi, 87 Reumatologija — пустая, 90 Kapilaroskopija) и блог (3 записи).
--     ⚠️ САЙТ СТАРЫЙ (~2013): состав врачей и перечень услуг могли устареть. Отзыв Google 2026-01 подтверждает,
--     что dr Predrag Rakočević (в отзыве «Radočević») ведёт беременности здесь.
--     Email спрятан Joomla-cloak — раскодирован: mercurnera@t-com.me.
--   * data/google-places/podgorica/mercur-nera.json — place_id, координаты, телефон +382 20 230 330 (23 отзыва — pending).
-- Сверка: адрес «Vojvode Maša Đurovića 21» — сайт («City kvart») = Google. Телефоны: 020 230 300 (сайт),
-- 020 230 330 («tel i fax», сайт = Google), 067 358 880 (сайт).
-- Логотип: templates/mercurnera/images/logo.png — белый на прозрачном фоне, на светлой карточке невидим → logo_url NULL.
--
-- Идемпотентно и самоисправляюще: клиника по google_place_id → slug; врачи по slug / name_sr / перевёрнутому имени
-- (тёзки — только по slug, см. блоки). Пустые поля существующих записей дозаполняются, непустые не трогаются.
-- description_* клиники — БЕЗУСЛОВНЫЙ UPDATE. Подволна 2d, агент R.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJARdxydjqTRMRs1L64zL89Gw';
SET @clinic_slug = 'poliklinika-mercur-nera-podgorica';

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
	'Poliklinika Mercur Nera',
	'Поликлиника Mercur Nera',
	'Поликлиника Mercur Nera',
	'Vojvode Maša Đurovića 21',
	'Војводе Маша Ђуровића 21',
	'',
	'',
	'81000',
	42.44013680,
	19.23464830,
	'+38220230300;+38220230330;+38267358880',
	'mercurnera@t-com.me',
	'https://mercurnera.me/',
	'',
	'',
	'',
	'',
	'',
	NULL,
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Поликлиника Mercur Nera', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Поликлиника Mercur Nera', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Vojvode Maša Đurovića 21', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Војводе Маша Ђуровића 21', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38220230300;+38220230330;+38267358880', phone),
	email = IF(email IS NULL OR email = '', 'mercurnera@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://mercurnera.me/', website),
	latitude = COALESCE(latitude, 42.44013680),
	longitude = COALESCE(longitude, 19.23464830)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то,
-- что клиника пишет о себе. ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'Privatna poliklinika u Podgorici, u naselju City kvart (ulica Vojvode Maša Đurovića 21). Rad je počela 7. januara 1994. godine kao prva internistička ordinacija sa biohemijskom laboratorijom; osnovala ju je dr Snežana Ćorac, internista hematolog. Od aprila 2013. godine radi kao poliklinika. Obavlja internističke, pedijatrijske i ginekološke preglede i konsultativne preglede specijalista drugih grana medicine (urolog, onkolog, neurolog, ortoped, psihijatar, fizijatar, radiolog, neurohirurg, hirurg), laboratorijsku i mikrobiološku dijagnostiku, ultrazvučnu dijagnostiku, test opterećenja srca, stres ehokardiografiju, 24-časovni Holter EKG-a i krvnog pritiska, kapilaroskopiju, kao i sistematske preglede djece i odraslih — pojedinačne i za kompanije. Nudi i ambulantno (jednodnevno) liječenje sa infuzionom terapijom, oksigenoterapijom i inhalacijama, kućne posjete doktora i medicinskih sestara i uzimanje uzoraka krvi i urina na kućnoj adresi. Ispred poliklinike je parking, ulaz je prilagođen osobama sa invaliditetom, a pedijatrijska ambulanta ima odvojenu čekaonicu i zaseban ulaz.',
	description_sr_cyrl = 'Приватна поликлиника у Подгорици, у насељу City kvart (улица Војводе Маша Ђуровића 21). Рад је почела 7. јануара 1994. године као прва интернистичка ординација са биохемијском лабораторијом; основала ју је др Снежана Ћорац, интерниста хематолог. Од априла 2013. године ради као поликлиника. Обавља интернистичке, педијатријске и гинеколошке прегледе и консултативне прегледе специјалиста других грана медицине (уролог, онколог, неуролог, ортопед, психијатар, физијатар, радиолог, неурохирург, хирург), лабораторијску и микробиолошку дијагностику, ултразвучну дијагностику, тест оптерећења срца, стрес ехокардиографију, 24-часовни Холтер ЕКГ-а и крвног притиска, капилароскопију, као и систематске прегледе дјеце и одраслих — појединачне и за компаније. Нуди и амбулантно (једнодневно) лијечење са инфузионом терапијом, оксигенотерапијом и инхалацијама, кућне посјете доктора и медицинских сестара и узимање узорака крви и урина на кућној адреси. Испред поликлинике је паркинг, улаз је прилагођен особама са инвалидитетом, а педијатријска амбуланта има одвојену чекаоницу и засебан улаз.',
	description_ru = 'Частная поликлиника в Подгорице, в квартале City kvart (улица Воеводы Маша Джуровича, 21). Начала работу 7 января 1994 года как первый кабинет терапевта с биохимической лабораторией; основательница — доктор Снежана Чорац, терапевт-гематолог. С апреля 2013 года работает как поликлиника. Здесь принимают терапевты, педиатры и гинекологи, консультируют специалисты других направлений (уролог, онколог, невролог, ортопед, психиатр, физиатр, радиолог, нейрохирург, хирург); проводятся лабораторная и микробиологическая диагностика, УЗИ, нагрузочный тест (эргометрия), стресс-эхокардиография, суточный холтер-мониторинг ЭКГ и артериального давления, капилляроскопия, а также профилактические медосмотры детей и взрослых — индивидуальные и корпоративные. Есть дневной стационар с инфузионной терапией, кислородотерапией и ингаляциями, выезды врачей и медсестёр на дом и забор крови и мочи на дому. Перед поликлиникой есть парковка, вход приспособлен для людей с инвалидностью, у детского кабинета — отдельная зона ожидания и собственный вход.',
	description_en = 'A private polyclinic in Podgorica, in the City kvart district (Vojvode Maša Đurovića 21). It opened on 7 January 1994 as the first internal-medicine practice with a biochemistry laboratory, founded by Dr Snežana Ćorac, an internist and haematologist, and has operated as a polyclinic since April 2013. It offers internal medicine, paediatric and gynaecological examinations, consultations with specialists in other fields (urologist, oncologist, neurologist, orthopaedist, psychiatrist, physiatrist, radiologist, neurosurgeon, surgeon), laboratory and microbiology testing, ultrasound diagnostics, cardiac stress testing, stress echocardiography, 24-hour Holter ECG and blood-pressure monitoring, capillaroscopy, and health check-ups for children and adults, both individual and corporate. It also provides same-day outpatient treatment with infusion therapy, oxygen therapy and inhalations, home visits by doctors and nurses, and home collection of blood and urine samples. There is parking in front of the polyclinic, the entrance is wheelchair-accessible, and the paediatric unit has a separate waiting room and its own entrance.',
	description_de = 'Private Poliklinik in Podgorica, im Viertel City kvart (Vojvode Maša Đurovića 21). Sie wurde am 7. Januar 1994 als erste internistische Praxis mit biochemischem Labor von Dr. Snežana Ćorac, Internistin und Hämatologin, gegründet und arbeitet seit April 2013 als Poliklinik. Angeboten werden internistische, pädiatrische und gynäkologische Untersuchungen, Konsultationen von Fachärzten weiterer Disziplinen (Urologe, Onkologe, Neurologe, Orthopäde, Psychiater, Physiater, Radiologe, Neurochirurg, Chirurg), Labor- und mikrobiologische Diagnostik, Ultraschalldiagnostik, Belastungs-EKG (Ergometrie), Stressechokardiografie, 24-Stunden-Holter-EKG und -Blutdruckmessung, Kapillarmikroskopie sowie Vorsorgeuntersuchungen für Kinder und Erwachsene, einzeln und für Firmen. Außerdem gibt es ambulante Tagesbehandlung mit Infusionstherapie, Sauerstofftherapie und Inhalationen, Hausbesuche von Ärzten und Pflegekräften sowie Blut- und Urinentnahme zu Hause. Vor der Poliklinik gibt es Parkplätze, der Eingang ist barrierefrei, und die Kinderambulanz hat ein eigenes Wartezimmer und einen separaten Eingang.',
	description_tr = 'Podgorica''da City kvart semtinde (Vojvode Maša Đurovića 21) özel bir poliklinik. 7 Ocak 1994''te dahiliye uzmanı ve hematolog Dr. Snežana Ćorac tarafından biyokimya laboratuvarına sahip ilk dahiliye muayenehanesi olarak kuruldu; Nisan 2013''ten beri poliklinik olarak hizmet veriyor. Dahiliye, çocuk ve kadın hastalıkları muayeneleri, diğer branşlardan uzman konsültasyonları (üroloji, onkoloji, nöroloji, ortopedi, psikiyatri, fizik tedavi, radyoloji, beyin cerrahisi, genel cerrahi), laboratuvar ve mikrobiyoloji tetkikleri, ultrason tanısı, efor testi, stres ekokardiyografi, 24 saatlik Holter EKG ve tansiyon takibi, kapilaroskopi ile çocuk ve yetişkinler için bireysel ve kurumsal check-up hizmetleri sunar. Ayrıca infüzyon tedavisi, oksijen tedavisi ve inhalasyon içeren günübirlik ayakta tedavi, doktor ve hemşirelerin ev ziyaretleri ile evde kan ve idrar örneği alma hizmetleri vardır. Polikliniğin önünde otopark bulunur, giriş engelli erişimine uygundur ve çocuk ünitesinin ayrı bekleme salonu ve ayrı girişi vardır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 — «PZU Poliklinika Mercur Nera»
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт не заявляет приём на других языках → только SR.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Главная mercurnera.me: «Radno vrijeme: Ponedjeljek - petak 07:30 - 19:30, Subota 07:30 - 12:00». ⚠️ Сайт 2013 г. Воскресенье не упомянуто → закрыто.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "19:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "19:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "19:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "19:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "19:30"}]}',
	'{"type": "regular", "intervals": [{"start": "07:30", "end": "12:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (3) — страница «Stručni tim» (id 73). Специальности: 2 = INTERNAL_MEDICINE, 15 = HEMATOLOGY,
-- 16 = RHEUMATOLOGY, 5 = GYNECOLOGY_OBSTETRICS. Языки — SR. Фото — с сайта (images/tim/*.jpg, проверены).
-- Найден в БД (1): svetlana-aligrudic. Новые (2): snezana-corac, predrag-rakocevic (прод-API 204 по обоим порядкам имени).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- dr Snežana Ćorac — internista hematolog, osnivač (O nama: «Mercur Neru je 1994. godine osnovala dr Snežana Ćorac»)
-- Новая. Однофамилица Zorica Ćorac (гинеколог, Natal) — другой человек.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'snezana-corac' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Snežana Ćorac' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ćorac Snežana' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snezana-corac', 'Snežana Ćorac', 'Снежана Ћорац', 'Снежана Чорац', 'Snezana Corac', 'dr',
	'https://mercurnera.me/images/tim/dr_snezana_corac.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: фото только если пустое.
UPDATE doctors SET photo_url = 'https://mercurnera.me/images/tim/dr_snezana_corac.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 15);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Internista hematolog, osnivač Poliklinike')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr sci med Predrag Rakočević — ginekolog akušer
-- Новый. Однофамильцы Rakočević в БД (Nataša, Radomir, Lidija, Mina) — другие люди.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'predrag-rakocevic' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Predrag Rakočević' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Rakočević Predrag' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'predrag-rakocevic', 'Predrag Rakočević', 'Предраг Ракочевић', 'Предраг Ракочевич', 'Predrag Rakocevic', 'dr sci. med.',
	'https://mercurnera.me/images/tim/dr_predrag_rakocevic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: фото только если пустое.
UPDATE doctors SET photo_url = 'https://mercurnera.me/images/tim/dr_predrag_rakocevic.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Ginekolog akušer')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- dr Svetlana Aligrudić — internista reumatolog (блог: «internista reumatolog dr Svetlana Aligrudić iz Poliklinike Mercur Nera»)
-- НАЙДЁТСЯ СУЩЕСТВУЮЩИЙ: svetlana-aligrudic (прод id 1826, INTERNAL_MEDICINE + RHEUMATOLOGY, консультант
-- Poliklinika Dr Masoničić, Bar) — тот же врач, специальности совпадают.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'svetlana-aligrudic' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Svetlana Aligrudić' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Aligrudić Svetlana' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'svetlana-aligrudic', 'Svetlana Aligrudić', 'Светлана Алигрудић', 'Светлана Алигрудич', 'Svetlana Aligrudic', 'dr',
	'https://mercurnera.me/images/tim/dr_Svetlana_Aligrudic.jpg', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Существующая карточка: фото только если пустое.
UPDATE doctors SET photo_url = 'https://mercurnera.me/images/tim/dr_Svetlana_Aligrudic.jpg' WHERE id = @doctor_id AND (photo_url IS NULL OR photo_url = '');

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 2), (@doctor_id, 16);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Internista reumatolog')
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

-- Ожидается 3 врача.
SELECT d.id, d.slug, d.name_sr, d.professional_title, dc.position,
	GROUP_CONCAT(DISTINCT ds.specialty_id ORDER BY ds.specialty_id) AS specialties,
	GROUP_CONCAT(DISTINCT dl.language_id ORDER BY dl.language_id) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
GROUP BY d.id, dc.position
ORDER BY d.name_sr;

-- ═══════════════════════════════════════════════════════════════════════════
-- Fizio PG (Podgorica) — клиника + физиотерапевты/врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-fizio-pg-podgorica.sql
-- Затем: server/sql/insert-clinic-fizio-pg-podgorica-services.sql
-- Запись импорта: data/clinic-imports/fizio-pg-podgorica.json. Подволна 2c, агент P.
--
-- Источники (собрано 2026-10-08, сырой HTML curl'ом):
--   * https://www.fiziopg.me/ — самописный одностраничник; команда и терапии подгружаются JS
--     из https://www.fiziopg.me/api.php?action=load (JSON: employees 7, therapies 14,
--     partners 12, gallery 12), те же данные продублированы в инлайн-скрипте страницы.
--     JSON-LD MedicalBusiness: адрес, индекс 81000, часы, соцсети, «paymentAccepted».
--   * data/google-places/podgorica/fizio.json — place_id, координаты 42.4509845 / 19.2360855,
--     телефон +382 69 026 947 (Google НЕ перезапрашивался; 18 отзывов — не импортируются).
--
-- Сверка: адрес сайта «Sava Čelebića 35, Blok IX, Podgorica», «ugao ulice Sava Čelebića i
-- Milutina Vučinića» — Google даёт тот же угол. Телефоны: сайт +382 69 026 947 и
-- +382 67 513 575, первый подтверждён Google.
--
-- Название: Google «Fizio», сайт «FizioPG» / «Fizio PG» (логотип), юрлицо «PZU Fizio».
-- Заведено «Fizio PG» — «Fizio» без города неотличимо от других «Fizio…».
--
-- Чего НЕТ: фото физиотерапевтов (на сайте только data:-URI внутри JSON, внешних URL нет →
-- photo_url NULL); логотипа (JSON-LD image /wp-content/uploads/2020/10/Fizio-logo.png → 404);
-- цен (ни в HTML, ни в JSON); версии /en (ссылка есть, страница 404).
-- Языки клиники: только SR.
--
-- Идемпотентно и самоисправляюще: клиника ищется по google_place_id → slug → name_sr;
-- пустые поля существующей записи дозаполняются, непустые не трогаются. description_*
-- клиники и НОВЫХ физиотерапевтов пишутся безусловно — правки вносить сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJCU-J5kLrTRMRvx5Ou2CKSfo';
SET @clinic_slug = 'fizio-pg-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Fizio PG', 'FizioPG', 'Fizio') AND city_id = 1 LIMIT 1));

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
	'Fizio PG',
	'Физио PG',
	'Физио PG',
	'Sava Čelebića 35, Blok IX',
	'Сава Челебића 35, Блок IX',
	'',
	'',
	'81000',
	42.45098450,
	19.23608550,
	'+38269026947;+38267513575',
	'office@fiziopg.me',
	'https://www.fiziopg.me/',
	'facebook.com/fiziocg',
	'@fizio_zu',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Физио PG', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Физио PG', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Sava Čelebića 35, Blok IX', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Сава Челебића 35, Блок IX', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude        = COALESCE(latitude, 42.45098450),
	longitude       = COALESCE(longitude, 19.23608550),
	phone           = IF(phone IS NULL OR phone = '', '+38269026947;+38267513575', phone),
	email           = IF(email IS NULL OR email = '', 'office@fiziopg.me', email),
	website         = IF(website IS NULL OR website = '', 'https://www.fiziopg.me/', website),
	facebook        = IF(facebook IS NULL OR facebook = '', 'facebook.com/fiziocg', facebook),
	instagram       = IF(instagram IS NULL OR instagram = '', '@fizio_zu', instagram)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что клиника пишет о себе; оценочное не переносится.
UPDATE clinics SET
	description_sr = 'Ambulanta za fizikalnu terapiju u Podgorici, u Bloku IX, na adresi Sava Čelebića 35 (ugao sa ulicom Milutina Vučinića); parking je ispred objekta. Tim čine specijalisti primijenjene fizioterapije i fizioterapeuti. Terapija počinje specijalističkim pregledom sa detaljnom procjenom i individualnim planom tretmana. U ponudi su INDIBA radiofrekventna terapija, K Laser (terapijski laser klase IV), MLS laser M-Hi i laseri male snage, Compex i druge vrste elektrostimulacije, BTL SIS (super induktivni sistem), ShockWave terapija, trakcija kičme, limfna drenaža, magnetoforeza, krioterapija hladnim vazduhom (Enraf-Nonius CryoOne), Guna kolagen i rana rehabilitacija pasivnim pokretima na Kinetec CPM aparatu, koji se može iznajmiti i za kućnu rehabilitaciju. Ambulanta prihvata dobrovoljno zdravstveno osiguranje; među partnerima na sajtu su Sava, Lovćen, UNIQA, Grawe, Generali, Dunav, Wiener Städtische i Veder osiguranje. Plaćanje gotovinom ili karticom. Termin je obavezno zakazati unaprijed.',
	description_sr_cyrl = 'Амбуланта за физикалну терапију у Подгорици, у Блоку IX, на адреси Сава Челебића 35 (угао са улицом Милутина Вучинића); паркинг је испред објекта. Тим чине специјалисти примијењене физиотерапије и физиотерапеути. Терапија почиње специјалистичким прегледом са детаљном процјеном и индивидуалним планом третмана. У понуди су INDIBA радиофреквентна терапија, K Laser (терапијски ласер класе IV), MLS ласер M-Hi и ласери мале снаге, Compex и друге врсте електростимулације, BTL SIS (супер индуктивни систем), ShockWave терапија, тракција кичме, лимфна дренажа, магнетофореза, криотерапија хладним ваздухом (Enraf-Nonius CryoOne), Guna колаген и рана рехабилитација пасивним покретима на Kinetec CPM апарату, који се може изнајмити и за кућну рехабилитацију. Амбуланта прихвата добровољно здравствено осигурање; међу партнерима на сајту су Сава, Ловћен, UNIQA, Grawe, Generali, Дунав, Wiener Städtische и Ведер осигурање. Плаћање готовином или картицом. Термин је обавезно заказати унапријед.',
	description_ru = 'Кабинет физиотерапии в Подгорице, в квартале Блок IX, по адресу Sava Čelebića 35 (угол с улицей Milutina Vučinića); перед зданием есть парковка. В команде — специалисты прикладной физиотерапии и физиотерапевты. Лечение начинается с осмотра специалиста с подробной оценкой состояния и индивидуальным планом. Доступны радиочастотная терапия INDIBA, K Laser (терапевтический лазер класса IV), лазер MLS M-Hi и низкоинтенсивные лазеры, электростимуляция Compex и другие виды электростимуляции, магнитотерапия BTL SIS (Super Inductive System), ударно-волновая терапия, вытяжение позвоночника, лимфодренаж, магнитофорез, криотерапия холодным воздухом (Enraf-Nonius CryoOne), коллагеновые препараты Guna и ранняя реабилитация пассивными движениями на аппарате Kinetec CPM, который можно взять в аренду для домашней реабилитации. Принимаются полисы добровольного медицинского страхования; среди партнёров на сайте — Sava, Lovćen, UNIQA, Grawe, Generali, Dunav, Wiener Städtische и Veder. Оплата наличными или картой. Запись на процедуры обязательна.',
	description_en = 'A physical therapy practice in Podgorica, in Blok IX at Sava Čelebića 35 (corner of Milutina Vučinića street), with parking in front of the building. The team consists of specialists in applied physiotherapy and physiotherapists. Treatment starts with a specialist assessment and an individual treatment plan. Services include INDIBA radiofrequency therapy, K Laser (class IV therapeutic laser), the MLS M-Hi laser and low-level lasers, Compex and other electrical muscle stimulation, BTL SIS (Super Inductive System), shockwave therapy, spinal traction, lymphatic drainage, magnetophoresis, cold-air cryotherapy (Enraf-Nonius CryoOne), Guna collagen and early rehabilitation with passive motion on a Kinetec CPM device, which can also be rented for home rehabilitation. The practice accepts voluntary health insurance; partners listed on the website include Sava, Lovćen, UNIQA, Grawe, Generali, Dunav, Wiener Städtische and Veder. Payment in cash or by card. Appointments must be booked in advance.',
	description_de = 'Eine Praxis für Physiotherapie in Podgorica, im Block IX, Sava Čelebića 35 (Ecke Milutina Vučinića); Parkplätze vor dem Gebäude. Das Team besteht aus Fachphysiotherapeuten für angewandte Physiotherapie und Physiotherapeuten. Die Behandlung beginnt mit einer fachlichen Untersuchung, einer ausführlichen Befundung und einem individuellen Behandlungsplan. Angeboten werden INDIBA-Radiofrequenztherapie, K Laser (therapeutischer Laser der Klasse IV), der MLS-Laser M-Hi und Low-Level-Laser, Compex und weitere Elektrostimulation, BTL SIS (Super Inductive System), Stoßwellentherapie, Wirbelsäulentraktion, Lymphdrainage, Magnetophorese, Kaltluft-Kryotherapie (Enraf-Nonius CryoOne), Guna-Kollagen sowie Frührehabilitation mit passiven Bewegungen auf einer Kinetec-CPM-Motorschiene, die auch für die Rehabilitation zu Hause gemietet werden kann. Die Praxis akzeptiert private Zusatzversicherungen; auf der Website sind unter anderem Sava, Lovćen, UNIQA, Grawe, Generali, Dunav, Wiener Städtische und Veder als Partner genannt. Bezahlung bar oder mit Karte. Termine nur nach vorheriger Vereinbarung.',
	description_tr = 'Podgorica''da, Blok IX''da Sava Čelebića 35 adresinde (Milutina Vučinića sokağı köşesi) bulunan fizik tedavi muayenehanesi; binanın önünde otopark vardır. Ekip, uygulamalı fizyoterapi uzmanları ve fizyoterapistlerden oluşur. Tedavi, ayrıntılı değerlendirme ve bireysel tedavi planı içeren bir uzman muayenesiyle başlar. INDIBA radyofrekans tedavisi, K Laser (IV. sınıf terapötik lazer), MLS M-Hi lazeri ve düşük güçlü lazerler, Compex ve diğer elektriksel kas stimülasyonu, BTL SIS (Super Inductive System), şok dalga tedavisi, omurga traksiyonu, lenf drenajı, manyetoforez, soğuk hava kriyoterapisi (Enraf-Nonius CryoOne), Guna kolajen ve evde rehabilitasyon için kiralanabilen Kinetec CPM cihazıyla pasif hareketlerle erken rehabilitasyon sunulur. Muayenehane gönüllü sağlık sigortasını kabul eder; web sitesinde partner olarak Sava, Lovćen, UNIQA, Grawe, Generali, Dunav, Wiener Städtische ve Veder sigorta şirketleri yer alır. Ödeme nakit veya kartla yapılabilir. Randevu almak zorunludur.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- PHYSIOTHERAPY_CLINIC = 24 (как endorfin-fizio-centar-*, fizikalna-terapija-vertebra-podgorica, spa-medica-podgorica)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 24);

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

-- Часы работы: «Radno Vrijeme: Ponedeljak – Petak 07:00 – 22:00, Subota 07:00 – 22:00, Nedjelja Zatvoreno» (блок контактов; JSON-LD openingHoursSpecification совпадает)
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "22:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "22:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS (7)
-- Физиотерапевты — специальность 94 = PHYSIOTHERAPY, professional_title NULL (не врачи),
-- как jelena-klikovac (OrthoExpert), valentina-buha (ДЗ Херцег-Нови), dijana-bozovic (ДЗ Котор).
-- 42 = PHYSICAL_MEDICINE (физиатр). Языки: 1 = SR (другие не заявлены).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Jugoslav Tošković — Specijalista primijenjene fizioterapije
-- Фото: на сайте только data:-URI, внешнего URL нет → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Jugoslav Tošković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Tošković Jugoslav' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'jugoslav-toskovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'jugoslav-toskovic', 'Jugoslav Tošković', 'Југослав Тошковић', 'Югослав Тошкович', 'Jugoslav Toskovic', NULL,
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije. Osim u PZU Fizio, od 1993. godine radi na Klinici za fizikalnu medicinu i rehabilitaciju Kliničkog centra Crne Gore. Osnovne studije fizioterapije završio je na Beogradskom univerzitetu 1988. godine, a u Beogradu i specijalističke studije primijenjene fizioterapije. Karijeru je počeo kao fizioterapeut u košarkaškom klubu Budućnost.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије. Осим у ПЗУ Физио, од 1993. године ради на Клиници за физикалну медицину и рехабилитацију Клиничког центра Црне Горе. Основне студије физиотерапије завршио је на Београдском универзитету 1988. године, а у Београду и специјалистичке студије примијењене физиотерапије. Каријеру је почео као физиотерапеут у кошаркашком клубу Будућност.',
	description_ru = 'Специалист прикладной физиотерапии. Помимо PZU Fizio, с 1993 года работает в Клинике физической медицины и реабилитации Клинического центра Черногории. Окончил базовое обучение по физиотерапии в Белградском университете в 1988 году, там же прошёл специализацию по прикладной физиотерапии. Начинал карьеру физиотерапевтом баскетбольного клуба «Будучност».',
	description_en = 'A specialist in applied physiotherapy. Besides PZU Fizio, he has worked at the Clinic for Physical Medicine and Rehabilitation of the Clinical Centre of Montenegro since 1993. He completed his undergraduate physiotherapy studies at the University of Belgrade in 1988 and his specialist studies in applied physiotherapy in Belgrade as well. He began his career as a physiotherapist at Budućnost basketball club.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie. Neben der PZU Fizio arbeitet er seit 1993 an der Klinik für physikalische Medizin und Rehabilitation des Klinischen Zentrums Montenegros. Das Grundstudium der Physiotherapie schloss er 1988 an der Universität Belgrad ab, ebenfalls in Belgrad das Fachstudium der angewandten Physiotherapie. Seine Laufbahn begann er als Physiotherapeut beim Basketballklub Budućnost.',
	description_tr = 'Uygulamalı fizyoterapi uzmanı. PZU Fizio''nun yanı sıra 1993''ten beri Karadağ Klinik Merkezi Fiziksel Tıp ve Rehabilitasyon Kliniği''nde çalışmaktadır. Fizyoterapi lisans eğitimini 1988''de Belgrad Üniversitesi''nde, uygulamalı fizyoterapi uzmanlık eğitimini de Belgrad''da tamamlamıştır. Kariyerine Budućnost basketbol kulübünde fizyoterapist olarak başlamıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Dragana Knežević — Specijalista primijenjene fizioterapije
-- Тёзка в БД: dragana-knezevic (педиатр, ДЗ Херцег-Нови) — другой человек; ищем ТОЛЬКО по своему slug, не по имени.
-- Фото: на сайте только data:-URI, внешнего URL нет → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'dragana-knezevic-fizioterapeut' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'dragana-knezevic-fizioterapeut', 'Dragana Knežević', 'Драгана Кнежевић', 'Драгана Кнежевич', 'Dragana Knezevic', NULL,
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije. Osnovne i specijalističke studije (2019) završila je na Fakultetu primijenjene fizioterapije u Igalu, a prethodno Srednju medicinsku školu u Podgorici, smjer fizioterapeutski tehničar (2013). Pripravnički staž obavila je u Kliničkom centru Crne Gore.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије. Основне и специјалистичке студије (2019) завршила је на Факултету примијењене физиотерапије у Игалу, а претходно Средњу медицинску школу у Подгорици, смјер физиотерапеутски техничар (2013). Приправнички стаж обавила је у Клиничком центру Црне Горе.',
	description_ru = 'Специалист прикладной физиотерапии. Окончила факультет прикладной физиотерапии в Игало (базовое обучение и специализация, 2019), до этого — медицинское училище в Подгорице по направлению «техник-физиотерапевт» (2013). Интернатуру проходила в Клиническом центре Черногории.',
	description_en = 'A specialist in applied physiotherapy. She completed her undergraduate and specialist studies (2019) at the Faculty of Applied Physiotherapy in Igalo, after the Secondary Medical School in Podgorica, physiotherapy technician programme (2013). She did her internship at the Clinical Centre of Montenegro.',
	description_de = 'Fachphysiotherapeutin für angewandte Physiotherapie. Grund- und Fachstudium (2019) schloss sie an der Fakultät für angewandte Physiotherapie in Igalo ab, zuvor die medizinische Fachschule in Podgorica, Fachrichtung Physiotherapietechnikerin (2013). Ihr Praktikum absolvierte sie am Klinischen Zentrum Montenegros.',
	description_tr = 'Uygulamalı fizyoterapi uzmanı. Lisans ve uzmanlık eğitimini (2019) Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nde, daha önce Podgorica Sağlık Meslek Lisesi''nin fizyoterapi teknisyenliği bölümünü (2013) bitirmiştir. Stajını Karadağ Klinik Merkezi''nde yapmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Suad Nikočević — Specijalista primijenjene fizioterapije
-- Фото: на сайте только data:-URI, внешнего URL нет → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Suad Nikočević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Nikočević Suad' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'suad-nikocevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'suad-nikocevic', 'Suad Nikočević', 'Суад Никочевић', 'Суад Никочевич', 'Suad Nikocevic', NULL,
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije. Osnovne studije završio je 2019. godine, a zvanje specijaliste primijenjene fizioterapije stekao 2021. godine na Fakultetu primijenjene fizioterapije u Igalu. Završio je Srednju medicinsku školu u Podgorici, smjer fizioterapeutski tehničar; pripravnički staž obavio je u Institutu „Dr Simo Milošević“ u Igalu.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије. Основне студије завршио је 2019. године, а звање специјалисте примијењене физиотерапије стекао 2021. године на Факултету примијењене физиотерапије у Игалу. Завршио је Средњу медицинску школу у Подгорици, смјер физиотерапеутски техничар; приправнички стаж обавио је у Институту „Др Симо Милошевић“ у Игалу.',
	description_ru = 'Специалист прикладной физиотерапии. Окончил базовое обучение в 2019 году, а звание специалиста прикладной физиотерапии получил в 2021 году на факультете прикладной физиотерапии в Игало. До этого — медицинское училище в Подгорице по направлению «техник-физиотерапевт»; интернатуру проходил в Институте «Д-р Симо Милошевич» в Игало.',
	description_en = 'A specialist in applied physiotherapy. He completed his undergraduate studies in 2019 and obtained the title of specialist in applied physiotherapy in 2021, both at the Faculty of Applied Physiotherapy in Igalo. He attended the Secondary Medical School in Podgorica (physiotherapy technician programme) and did his internship at the "Dr Simo Milošević" Institute in Igalo.',
	description_de = 'Fachphysiotherapeut für angewandte Physiotherapie. Das Grundstudium schloss er 2019 ab, den Titel des Fachphysiotherapeuten erwarb er 2021, beides an der Fakultät für angewandte Physiotherapie in Igalo. Er besuchte die medizinische Fachschule in Podgorica (Fachrichtung Physiotherapietechniker) und absolvierte sein Praktikum am Institut „Dr Simo Milošević“ in Igalo.',
	description_tr = 'Uygulamalı fizyoterapi uzmanı. Lisans eğitimini 2019''da tamamlamış, uygulamalı fizyoterapi uzmanlık unvanını 2021''de Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nde almıştır. Podgorica Sağlık Meslek Lisesi''nin fizyoterapi teknisyenliği bölümünü bitirmiş, stajını Igalo''daki "Dr Simo Milošević" Enstitüsü''nde yapmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Anđela Golubović — Fizioterapeut
-- Тёзка в БД: andjela-golubovic (психолог, КЦЦГ / Smartmed) — другая специальность, другой человек; ищем ТОЛЬКО по своему slug.
-- Фото: на сайте только data:-URI, внешнего URL нет → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'andjela-golubovic-fizioterapeut' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'andjela-golubovic-fizioterapeut', 'Anđela Golubović', 'Анђела Голубовић', 'Анджела Голубович', 'Andjela Golubovic', NULL,
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Fizioterapeut. Osnovne studije završila je 2021. godine na Fakultetu primijenjene fizioterapije u Igalu, a prethodno Srednju medicinsku školu u Podgorici, smjer zdravstveni tehničar. Pripravnički staž obavila je u Kliničkom centru Crne Gore.',
	description_sr_cyrl = 'Физиотерапеут. Основне студије завршила је 2021. године на Факултету примијењене физиотерапије у Игалу, а претходно Средњу медицинску школу у Подгорици, смјер здравствени техничар. Приправнички стаж обавила је у Клиничком центру Црне Горе.',
	description_ru = 'Физиотерапевт. В 2021 году окончила факультет прикладной физиотерапии в Игало, до этого — медицинское училище в Подгорице по направлению «медицинский техник». Интернатуру проходила в Клиническом центре Черногории.',
	description_en = 'A physiotherapist. She graduated from the Faculty of Applied Physiotherapy in Igalo in 2021, after the Secondary Medical School in Podgorica (health technician programme). She did her internship at the Clinical Centre of Montenegro.',
	description_de = 'Physiotherapeutin. Sie schloss 2021 das Studium an der Fakultät für angewandte Physiotherapie in Igalo ab, zuvor die medizinische Fachschule in Podgorica (Fachrichtung Gesundheitstechnikerin). Ihr Praktikum absolvierte sie am Klinischen Zentrum Montenegros.',
	description_tr = 'Fizyoterapist. 2021''de Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nden mezun olmuş, daha önce Podgorica Sağlık Meslek Lisesi''nin sağlık teknisyenliği bölümünü bitirmiştir. Stajını Karadağ Klinik Merkezi''nde yapmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Tijana Knežević — Fizioterapeut
-- Фото: на сайте только data:-URI, внешнего URL нет → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Tijana Knežević' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Knežević Tijana' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'tijana-knezevic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'tijana-knezevic', 'Tijana Knežević', 'Тијана Кнежевић', 'Тияна Кнежевич', 'Tijana Knezevic', NULL,
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Fizioterapeut. Osnovne studije završila je 2018. godine na Fakultetu primijenjene fizioterapije u Igalu, a pripravnički staž 2019. godine u Institutu „Dr Simo Milošević“ u Igalu. Završila je Srednju medicinsku školu u Beranama, smjer zdravstveni tehničar.',
	description_sr_cyrl = 'Физиотерапеут. Основне студије завршила је 2018. године на Факултету примијењене физиотерапије у Игалу, а приправнички стаж 2019. године у Институту „Др Симо Милошевић“ у Игалу. Завршила је Средњу медицинску школу у Беранама, смјер здравствени техничар.',
	description_ru = 'Физиотерапевт. В 2018 году окончила факультет прикладной физиотерапии в Игало, в 2019 году прошла интернатуру в Институте «Д-р Симо Милошевич» в Игало. Окончила медицинское училище в Беране по направлению «медицинский техник».',
	description_en = 'A physiotherapist. She graduated from the Faculty of Applied Physiotherapy in Igalo in 2018 and completed her internship at the "Dr Simo Milošević" Institute in Igalo in 2019. She attended the Secondary Medical School in Berane (health technician programme).',
	description_de = 'Physiotherapeutin. Sie schloss 2018 das Studium an der Fakultät für angewandte Physiotherapie in Igalo ab und absolvierte 2019 ihr Praktikum am Institut „Dr Simo Milošević“ in Igalo. Sie besuchte die medizinische Fachschule in Berane (Fachrichtung Gesundheitstechnikerin).',
	description_tr = 'Fizyoterapist. 2018''de Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nden mezun olmuş, 2019''da stajını Igalo''daki "Dr Simo Milošević" Enstitüsü''nde tamamlamıştır. Berane Sağlık Meslek Lisesi''nin sağlık teknisyenliği bölümünü bitirmiştir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Fizioterapeut')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Balša Garić — Master student primijenjene fizioterapije
-- Фото: на сайте только data:-URI, внешнего URL нет → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Balša Garić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Garić Balša' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'balsa-garic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'balsa-garic', 'Balša Garić', 'Балша Гарић', 'Бальша Гарич', 'Balsa Garic', NULL,
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Fizioterapeut (BApp Physio), student master studija primijenjene fizioterapije u Igalu od 2023. godine. Osnovne studije završio je na Fakultetu primijenjene fizioterapije u Igalu (2020–2023), a prethodno Srednju medicinsku školu u Podgorici, smjer fizioterapeutski tehničar (2016–2020). U Institutu „Dr Simo Milošević“ u Igalu učestvovao je u rehabilitaciji pacijenata sa neurološkim i ortopedskim oboljenjima.',
	description_sr_cyrl = 'Физиотерапеут (BApp Physio), студент мастер студија примијењене физиотерапије у Игалу од 2023. године. Основне студије завршио је на Факултету примијењене физиотерапије у Игалу (2020–2023), а претходно Средњу медицинску школу у Подгорици, смјер физиотерапеутски техничар (2016–2020). У Институту „Др Симо Милошевић“ у Игалу учествовао је у рехабилитацији пацијената са неуролошким и ортопедским обољењима.',
	description_ru = 'Физиотерапевт (BApp Physio), с 2023 года — магистрант по прикладной физиотерапии в Игало. Окончил факультет прикладной физиотерапии в Игало (2020–2023), до этого — медицинское училище в Подгорице по направлению «техник-физиотерапевт» (2016–2020). В Институте «Д-р Симо Милошевич» в Игало участвовал в реабилитации пациентов с неврологическими и ортопедическими заболеваниями.',
	description_en = 'A physiotherapist (BApp Physio) and, since 2023, a master''s student in applied physiotherapy in Igalo. He completed his undergraduate studies at the Faculty of Applied Physiotherapy in Igalo (2020–2023), after the Secondary Medical School in Podgorica, physiotherapy technician programme (2016–2020). At the "Dr Simo Milošević" Institute in Igalo he assisted in the rehabilitation of patients with neurological and orthopaedic conditions.',
	description_de = 'Physiotherapeut (BApp Physio), seit 2023 Masterstudent der angewandten Physiotherapie in Igalo. Das Grundstudium absolvierte er an der Fakultät für angewandte Physiotherapie in Igalo (2020–2023), zuvor die medizinische Fachschule in Podgorica, Fachrichtung Physiotherapietechniker (2016–2020). Am Institut „Dr Simo Milošević“ in Igalo wirkte er an der Rehabilitation von Patienten mit neurologischen und orthopädischen Erkrankungen mit.',
	description_tr = 'Fizyoterapist (BApp Physio); 2023''ten beri Igalo''da uygulamalı fizyoterapi yüksek lisans öğrencisi. Lisans eğitimini Igalo''daki Uygulamalı Fizyoterapi Fakültesi''nde (2020–2023), daha önce Podgorica Sağlık Meslek Lisesi''nin fizyoterapi teknisyenliği bölümünde (2016–2020) tamamlamıştır. Igalo''daki "Dr Simo Milošević" Enstitüsü''nde nörolojik ve ortopedik hastalıkları olan hastaların rehabilitasyonunda görev almıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Master student primijenjene fizioterapije')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- Nina Tošković — Specijalista primijenjene fizioterapije
-- Фото: на сайте только data:-URI, внешнего URL нет → NULL.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Nina Tošković' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Tošković Nina' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'nina-toskovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, instagram, created_at)
SELECT 'nina-toskovic', 'Nina Tošković', 'Нина Тошковић', 'Нина Тошкович', 'Nina Toskovic', NULL,
	NULL, NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista primijenjene fizioterapije. Osnovne studije završila je 2021. godine na VZS „Visan“ u Beogradu, a specijalističke 2022. godine u Beogradu. Pripravnički staž obavila je u Kliničkom centru Crne Gore.',
	description_sr_cyrl = 'Специјалиста примијењене физиотерапије. Основне студије завршила је 2021. године на ВЗС „Висан“ у Београду, а специјалистичке 2022. године у Београду. Приправнички стаж обавила је у Клиничком центру Црне Горе.',
	description_ru = 'Специалист прикладной физиотерапии. В 2021 году окончила высшую медицинскую школу «Визан» в Белграде, в 2022 году там же, в Белграде, — специализацию. Интернатуру проходила в Клиническом центре Черногории.',
	description_en = 'A specialist in applied physiotherapy. She completed her undergraduate studies at the "Visan" College of Health Studies in Belgrade in 2021 and her specialist studies in Belgrade in 2022. She did her internship at the Clinical Centre of Montenegro.',
	description_de = 'Fachphysiotherapeutin für angewandte Physiotherapie. Das Grundstudium schloss sie 2021 an der Hochschule „Visan“ in Belgrad ab, das Fachstudium 2022 ebenfalls in Belgrad. Ihr Praktikum absolvierte sie am Klinischen Zentrum Montenegros.',
	description_tr = 'Uygulamalı fizyoterapi uzmanı. Lisans eğitimini 2021''de Belgrad''daki "Visan" Sağlık Yüksekokulu''nda, uzmanlık eğitimini 2022''de yine Belgrad''da tamamlamıştır. Stajını Karadağ Klinik Merkezi''nde yapmıştır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 94);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Specijalista primijenjene fizioterapije')
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

-- Ожидается 7: jugoslav-toskovic (94), dragana-knezevic-fizioterapeut (94), suad-nikocevic (94), andjela-golubovic-fizioterapeut (94), tijana-knezevic (94), balsa-garic (94), nina-toskovic (94).
-- Если created_at нового физиотерапевта старше даты прогона — запись уже была: проверить, тот ли человек.
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

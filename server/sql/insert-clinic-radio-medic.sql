-- ═══════════════════════════════════════════════════════════════════════════
-- Radio Medic (Podgorica) — центр радиологической диагностики
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-radio-medic.sql
--
-- Источники данных:
--   * https://radiomedic.me/ — страницы home, o-nama, magnetna-rezonanca,
--     skener, rentgen, ultrazvuk, kontakt (собрано 2026-09-03 через
--     WP REST API /wp/v2/pages, чтобы не парсить Divi-разметку)
--   * data/google-places/podgorica/radio-medic.json — place_id, координаты,
--     нормализованный адрес, телефон (Google Maps НЕ перезапрашивался)
--   * instagram.com/radiomedic.me — bio (адрес, два телефона, сайт) и посты
--     «NAŠ TIM» с составом врачей: единственный источник по команде, на сайте
--     страницы команды нет
--
-- Сверка фактов:
--   * Адрес: сайт «ul Husinjskih Rudara 2/1» (home, /skener, /rentgen,
--     /magnetna-rezonanca, /ultrazvuk) и «Husinjskih rudara br 2/1, Podgorica»
--     (/kontakt); Google — «UL, 2/1 Husinjskih Rudara, Podgorica 81000».
--     Совпадают. Записан в сербской орфографии: «Husinjskih rudara 2/1».
--   * Координаты 42.43067270 / 19.29123490 — Google Places (единственный
--     источник).
--   * Телефоны: 067 081-222 и 060 020-022 с сайта; Google подтверждает
--     первый (+382 67 081 222).
--   * Facebook и Instagram найдены только на /kontakt (в футере остальных
--     страниц у соц-иконок Divi нет href). Instagram-хэндл @radiomedic.me
--     подтверждён bio самого аккаунта.
--   * Телефоны и адрес независимо подтверждены bio в Instagram
--     («060 020 022 / 067 081 222», «UL, 2/1 Husinjskih Rudara, Podgorica 81000»)
--     — совпадают с сайтом и Google.
--   * Рабочее время: «Ponedeljak - Subota 07 – 21h, Nedeljom ne radimo» —
--     повторяется в футере всех страниц.
--   * Оборудование названо моделями: Philips MR 5300, Philips Incisive CT,
--     Siemens MULTIX Impact, Siemens ACUSON Juniper.
--
-- Чего в источниках НЕТ (не заполняем, добавить после уточнения у клиники):
--   * email — ни адреса, ни формы обратной связи, ни в bio Instagram;
--   * прайс-листа как такового нет. Из открытых источников удалось взять одну
--     обычную цену (MR цијеле кичме, 255 €) — подробности в PART 5;
--   * логотип отдельным файлом не найден (в постах Instagram он вшит в
--     картинку);
--   * фото врачей: карточки «NAŠ TIM» — изображения постов, стабильных
--     внешних URL под portrait нет, photo_url оставлен NULL;
--   * рентгеновские позиции: клиника называет только области применения
--     аппарата, ни одной конкретной проекции — см. PART 5.
--
-- Маркетинговые превосходные степени с сайта («jedini u Crnoj Gori»,
-- «najmoderniji», «najbolji») в описание НЕ переносятся: это заявление
-- клиники, а не проверяемый факт. Остались модели аппаратов и их
-- характеристики.
--
-- Идемпотентно: повторный запуск не создаёт дублей и не перезатирает
-- непустые поля уже существующей клиники (status тоже не трогается).
-- description_* пишутся БЕЗУСЛОВНЫМ UPDATE, чтобы правки текста доезжали до
-- уже импортированной клиники.
-- ⚠️ Цена этого: правки описаний из админки следующий прогон файла
-- перезатрёт — вносить их сюда, а не только в БД.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJ-fDjmKTtTRMRm7C_ZAf5_uA';
SET @clinic_slug = 'radio-medic';

-- Поиск существующей клиники: по google_place_id → по slug → по name_sr
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr = 'Radio Medic' LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
-- description_* сознательно НЕ здесь: их пишет безусловный UPDATE ниже.
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	1, -- CityId.PODGORICA
	'Radio Medic',
	'Radio Medic', -- латинский бренд в кириллическом варианте не транслитерируем (как Codra Hospital, In Vitro, Tesla Medical)
	'Radio Medic',
	'Husinjskih rudara 2/1',
	'Хусињских рудара 2/1',
	'',
	'',
	'81000',
	42.43067270,
	19.29123490,
	'+38267081222;+38260020022',
	'', -- на сайте нет
	'https://radiomedic.me/',
	'facebook.com/profile.php?id=61583620962680',
	'@radiomedic.me',
	'',
	'',
	'',
	'',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение: только пустые/NULL поля уже существующей записи.
-- Непустые значения (в т.ч. правки из админки) не трогаем. status не меняем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl    = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Radio Medic', name_sr_cyrl),
	name_ru         = IF(name_ru IS NULL OR name_ru = '', 'Radio Medic', name_ru),
	address_sr      = IF(address_sr IS NULL OR address_sr = '', 'Husinjskih rudara 2/1', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Хусињских рудара 2/1', address_sr_cyrl),
	postal_code     = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	latitude        = COALESCE(latitude, 42.43067270),
	longitude       = COALESCE(longitude, 19.29123490),
	phone           = IF(phone IS NULL OR phone = '', '+38267081222;+38260020022', phone),
	website         = IF(website IS NULL OR website = '', 'https://radiomedic.me/', website),
	facebook        = IF(facebook IS NULL OR facebook = '', 'facebook.com/profile.php?id=61583620962680', facebook),
	instagram       = IF(instagram IS NULL OR instagram = '', '@radiomedic.me', instagram)
WHERE id = @clinic_id;

-- Описания — БЕЗУСЛОВНАЯ перезапись (см. шапку файла).
UPDATE clinics SET
	description_sr = 'Privatni centar za radiološku dijagnostiku u Podgorici, u ulici Husinjskih rudara 2/1. Obavlja snimanja magnetnom rezonancom, CT skenerom, digitalnim rendgenom i ultrazvukom. Magnetna rezonanca je Philips MR 5300 sa tunelom širine 70 cm i tokom rada podržanim vještačkom inteligencijom, što pregled olakšava klaustrofobičnim i korpulentnijim pacijentima. CT skener Philips Incisive radi snimanja glave, grudnog koša, abdomena, karlice, kičme, sinusa i krvnih sudova (angio CT), sa slojevitim i 3D rekonstrukcijama i smanjenom dozom zračenja. Digitalni rendgen Siemens MULTIX Impact koristi se za snimanje pluća, kostiju, kičme, ekstremiteta i sinusa, a snimci se obrađuju odmah. Ultrazvučni aparat Siemens ACUSON Juniper pokriva abdomen i opštu radiologiju, kardiologiju, vaskularne preglede, mišićno-koštani sistem, ginekologiju i fetalnu medicinu (uključujući 3D/4D) i pedijatriju. Radi od ponedjeljka do subote, nedjeljom ne radi.',
	description_sr_cyrl = 'Приватни центар за радиолошку дијагностику у Подгорици, у улици Хусињских рудара 2/1. Обавља снимања магнетном резонанцом, CT скенером, дигиталним рендгеном и ултразвуком. Магнетна резонанца је Philips MR 5300 са тунелом ширине 70 cm и током рада подржаним вјештачком интелигенцијом, што преглед олакшава клаустрофобичним и корпулентнијим пацијентима. CT скенер Philips Incisive ради снимања главе, грудног коша, абдомена, карлице, кичме, синуса и крвних судова (ангио CT), са слојевитим и 3D реконструкцијама и смањеном дозом зрачења. Дигитални рендген Siemens MULTIX Impact користи се за снимање плућа, костију, кичме, екстремитета и синуса, а снимци се обрађују одмах. Ултразвучни апарат Siemens ACUSON Juniper покрива абдомен и општу радиологију, кардиологију, васкуларне прегледе, мишићно-коштани систем, гинекологију и феталну медицину (укључујући 3D/4D) и педијатрију. Ради од понедјељка до суботе, недјељом не ради.',
	description_ru = 'Частный центр радиологической диагностики в Подгорице, на улице Husinjskih rudara 2/1. Выполняет исследования на магнитно-резонансном томографе, компьютерном томографе, цифровом рентгене и УЗИ-аппарате. МРТ — Philips MR 5300 с диаметром туннеля 70 см и рабочим процессом с поддержкой искусственного интеллекта, что облегчает обследование пациентам с клаустрофобией и крупного телосложения. КТ Philips Incisive выполняет исследования головы, грудной клетки, брюшной полости, малого таза, позвоночника, пазух и сосудов (ангио-КТ) с послойными и 3D-реконструкциями при сниженной дозе облучения. Цифровой рентген Siemens MULTIX Impact используется для снимков лёгких, костей, позвоночника, конечностей и пазух, снимки обрабатываются сразу. УЗИ-аппарат Siemens ACUSON Juniper охватывает брюшную полость и общую радиологию, кардиологию, исследования сосудов, мышечно-скелетную систему, гинекологию и фетальную медицину (включая 3D/4D) и педиатрию. Работает с понедельника по субботу, в воскресенье закрыт.',
	description_en = 'A private radiology centre in Podgorica, at Husinjskih rudara 2/1. It performs MRI, CT, digital X-ray and ultrasound imaging. The MRI unit is a Philips MR 5300 with a 70 cm bore and an AI-assisted workflow, which makes the examination easier for claustrophobic and larger patients. The Philips Incisive CT scanner covers the head, chest, abdomen, pelvis, spine, sinuses and blood vessels (CT angiography), with multi-slice and 3D reconstructions at a reduced radiation dose. The Siemens MULTIX Impact digital X-ray unit is used for the lungs, bones, spine, extremities and sinuses, and the images are processed immediately. The Siemens ACUSON Juniper ultrasound system covers the abdomen and general radiology, cardiology, vascular studies, the musculoskeletal system, obstetrics, gynaecology and fetal medicine (including 3D/4D) and paediatrics. Open Monday to Saturday; closed on Sundays.',
	description_de = 'Ein privates radiologisches Zentrum in Podgorica, in der Husinjskih rudara 2/1. Es führt Untersuchungen mit MRT, CT, digitalem Röntgen und Ultraschall durch. Das MRT ist ein Philips MR 5300 mit einer Tunnelweite von 70 cm und einem KI-gestützten Arbeitsablauf, was die Untersuchung für Patienten mit Klaustrophobie und für korpulentere Patienten erleichtert. Der CT-Scanner Philips Incisive erfasst Kopf, Brustkorb, Bauchraum, Becken, Wirbelsäule, Nasennebenhöhlen und Blutgefäße (CT-Angiographie), mit Schicht- und 3D-Rekonstruktionen bei reduzierter Strahlendosis. Das digitale Röntgengerät Siemens MULTIX Impact wird für Lunge, Knochen, Wirbelsäule, Extremitäten und Nasennebenhöhlen eingesetzt, die Aufnahmen werden sofort verarbeitet. Das Ultraschallsystem Siemens ACUSON Juniper deckt Abdomen und allgemeine Radiologie, Kardiologie, Gefäßuntersuchungen, den Bewegungsapparat, Gynäkologie und Fetalmedizin (einschließlich 3D/4D) sowie Pädiatrie ab. Geöffnet von Montag bis Samstag, sonntags geschlossen.',
	description_tr = 'Podgorica''da, Husinjskih rudara 2/1 adresinde bulunan özel bir radyoloji merkezi. MR, BT, dijital röntgen ve ultrason görüntülemeleri yapılmaktadır. MR cihazı, 70 cm tünel genişliğine ve yapay zekâ destekli iş akışına sahip Philips MR 5300 olup, bu özellikler klostrofobisi olan ve daha kilolu hastalar için muayeneyi kolaylaştırır. Philips Incisive BT cihazı baş, göğüs, karın, pelvis, omurga, sinüsler ve kan damarlarının (BT anjiyografi) görüntülemesini, katmanlı ve 3D rekonstrüksiyonlarla ve azaltılmış radyasyon dozuyla yapar. Siemens MULTIX Impact dijital röntgen cihazı akciğer, kemik, omurga, ekstremite ve sinüs çekimlerinde kullanılır ve görüntüler anında işlenir. Siemens ACUSON Juniper ultrason sistemi karın ve genel radyoloji, kardiyoloji, damar incelemeleri, kas-iskelet sistemi, kadın hastalıkları ve fetal tıp (3D/4D dahil) ile pediatriyi kapsar. Pazartesiden cumartesiye kadar açık, pazar günü kapalı.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CLINIC TYPES & LANGUAGES
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 — решение владельца каталога.
-- Отдельного типа «радиологический центр» в enums/clinic-type.ts нет;
-- альтернатива DIAGNOSTIC_LAB (4, им помечены Moj Lab, In Vitro, Lab Medical)
-- отклонена, потому что подпись «Диагностическая лаборатория» для МРТ/КТ-центра
-- вводит в заблуждение, а в POLYCLINIC уже 51 клиника и фасет самый ходовой.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- clinic_languages — языки СОПРОВОЖДЕНИЯ, которые клиника заявляет сама,
-- а не сумма языков персонала. radiomedic.me сайт только на сербском и о
-- других языках не пишет → только LanguageId.SR = 1.
-- (В отзывах есть русский и английский, но это языки пациентов, не заявление
-- клиники — см. правило «языки клиники ≠ языки врачей».)
--
-- ⚠️ `clinic_languages` — единственная junction-таблица схемы без составного
-- UNIQUE, поэтому `INSERT IGNORE` здесь НЕ дедуплицирует и каждый прогон
-- добавлял бы новую строку. Отсюда полная синхронизация вместо INSERT IGNORE.
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

-- ═══════════════════════════════════════════════════════════════
-- PART 3: WORKING HOURS
-- ═══════════════════════════════════════════════════════════════
-- Источник: футер всех страниц radiomedic.me —
-- «Ponedeljak - Subota / Nedeljom ne radimo / 07 – 21h».

INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "closed"}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 4: DOCTORS
-- Специальности: 10 = RADIOLOGY, 76 = MAMMOLOGY
-- Языки: 1 = SR
--
-- Источник — посты «NAŠ TIM» в instagram.com/radiomedic.me. Сводная карточка
-- «NAŠ TIM — SPECIJALISTA RADIOLOGIJE» перечисляет ровно этих трёх, поэтому
-- считаем список полным на дату сбора (2026-09-03).
--
-- Схема на каждого врача: find-or-create (без description_*) → безусловный
-- UPDATE описаний, чтобы правка био доезжала и до уже импортированного врача.
-- ⚠️ Правки описаний из админки следующий прогон файла перезатрёт — вносить
-- их сюда.
--
-- Ни один из трёх не упомянут в отзывах Google, привязка отзывов к врачам
-- не делается (см. server/sql/reviews-google/radio-medic-podgorica.sql).
-- ═══════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────
-- Dr Mersida Ćosović — specijalista radiologije
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Mersida Ćosović' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Ćosović Mersida' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'mersida-cosovic' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mersida-cosovic', 'Mersida Ćosović', 'Мерсида Ћосовић', 'Мерсида Чосович', 'Mersida Cosovic', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista radiologije. Doktor medicine — osnovne studije i specijalizaciju iz radiologije završila je na Medicinskom fakultetu u Beogradu. Stručna usavršavanja nastavlja u zemlji i regionu.',
	description_sr_cyrl = 'Специјалиста радиологије. Доктор медицине — основне студије и специјализацију из радиологије завршила је на Медицинском факултету у Београду. Стручна усавршавања наставља у земљи и региону.',
	description_ru = 'Специалист по радиологии. Врач; базовое образование и специализацию по радиологии получила на медицинском факультете в Белграде. Продолжает повышать квалификацию в стране и регионе.',
	description_en = 'A specialist in radiology. She holds a medical degree and completed both her studies and her radiology residency at the School of Medicine in Belgrade. She continues her professional training in Montenegro and the wider region.',
	description_de = 'Fachärztin für Radiologie. Sie ist Ärztin und absolvierte sowohl ihr Studium als auch ihre Facharztausbildung in Radiologie an der Medizinischen Fakultät in Belgrad. Ihre Fortbildungen setzt sie im Land und in der Region fort.',
	description_tr = 'Radyoloji uzmanı. Tıp doktoru olup lisans eğitimini ve radyoloji uzmanlık eğitimini Belgrad Tıp Fakültesinde tamamlamıştır. Mesleki eğitimlerine ülkede ve bölgede devam etmektedir.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Dr Aleksandra Jarić — specijalista patologije dojke
--
-- Две специальности: RADIOLOGY (10) — 20+ лет радиологической диагностики
-- в Институте онкологии и радиологии Сербии, и MAMMOLOGY (76) — «patologija
-- dojke» с карточки. Отдельной специальности «онкология» не ставим:
-- диагностика злокачественных заболеваний — не лечение, ONCOLOGY (47) была бы
-- заявкой сверх источника.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Aleksandra Jarić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Jarić Aleksandra' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'aleksandra-jaric' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandra-jaric', 'Aleksandra Jarić', 'Александра Јарић', 'Александра Ярич', 'Aleksandra Jaric', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista patologije dojke. Više od 20 godina posvećena je radiološkoj dijagnostici u Institutu za onkologiju i radiologiju Srbije, sa bogatim iskustvom u dijagnostici malignih oboljenja. Od 2012. do 2014. godine bila je nacionalni koordinator za skrining raka dojke u Srbiji, a učestvovala je i u projektu podržanom fondovima Evropske unije. Posvećena je ranoj i preciznoj dijagnostici patologije dojke.',
	description_sr_cyrl = 'Специјалиста патологије дојке. Више од 20 година посвећена је радиолошкој дијагностици у Институту за онкологију и радиологију Србије, са богатим искуством у дијагностици малигних обољења. Од 2012. до 2014. године била је национални координатор за скрининг рака дојке у Србији, а учествовала је и у пројекту подржаном фондовима Европске уније. Посвећена је раној и прецизној дијагностици патологије дојке.',
	description_ru = 'Специалист по патологии молочной железы. Более 20 лет занимается радиологической диагностикой в Институте онкологии и радиологии Сербии, имеет большой опыт диагностики злокачественных заболеваний. С 2012 по 2014 год была национальным координатором скрининга рака молочной железы в Сербии, участвовала в проекте, поддержанном фондами Европейского союза. Занимается ранней и точной диагностикой патологии молочной железы.',
	description_en = 'A specialist in breast pathology. For more than 20 years she has been devoted to radiological diagnostics at the Institute for Oncology and Radiology of Serbia, with extensive experience in diagnosing malignant disease. From 2012 to 2014 she was the national coordinator for breast cancer screening in Serbia, and she also took part in a project supported by European Union funds. Her focus is the early and precise diagnosis of breast pathology.',
	description_de = 'Fachärztin für Brustpathologie. Mehr als 20 Jahre widmete sie sich der radiologischen Diagnostik am Institut für Onkologie und Radiologie Serbiens und verfügt über umfangreiche Erfahrung in der Diagnostik bösartiger Erkrankungen. Von 2012 bis 2014 war sie nationale Koordinatorin für das Brustkrebs-Screening in Serbien und wirkte zudem in einem von EU-Fonds geförderten Projekt mit. Ihr Schwerpunkt ist die frühe und präzise Diagnostik der Brustpathologie.',
	description_tr = 'Meme patolojisi uzmanı. Yirmi yılı aşkın süredir Sırbistan Onkoloji ve Radyoloji Enstitüsünde radyolojik teşhise adanmış olup malign hastalıkların teşhisinde geniş deneyime sahiptir. 2012-2014 yılları arasında Sırbistan''da meme kanseri taramasının ulusal koordinatörlüğünü yapmış, ayrıca Avrupa Birliği fonlarıyla desteklenen bir projede yer almıştır. Meme patolojisinin erken ve kesin teşhisine odaklanmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10), (@doctor_id, 76);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- Dr Oliver Radmili — specijalista radiologije, subspecijalista angiologije
--
-- Только RADIOLOGY (10): ангиологии в enums/specialty.ts нет, а
-- VASCULAR_SURGERY (34) была бы ошибкой — он радиолог, а не хирург;
-- «Klinika za vaskularnu i endovaskularnu hirurgiju UKC Srbije» — место
-- работы, а не его специальность. Субспециализация описана в био.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Oliver Radmili' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Radmili Oliver' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'oliver-radmili' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'oliver-radmili', 'Oliver Radmili', 'Оливер Радмили', 'Оливер Радмили', 'Oliver Radmili', 'Dr',
	NULL, NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

UPDATE doctors SET
	description_sr = 'Specijalista radiologije i subspecijalista angiologije, usmjeren na MDCT dijagnostiku kardiovaskularnog sistema. Zaposlen je na Klinici za vaskularnu i endovaskularnu hirurgiju Univerzitetskog kliničkog centra Srbije. Edukacije i stručna usavršavanja stekao je u evropskim centrima i redovan je učesnik međunarodnih edukacija iz kardiovaskularne radiologije.',
	description_sr_cyrl = 'Специјалиста радиологије и супспецијалиста ангиологије, усмјерен на MDCT дијагностику кардиоваскуларног система. Запослен је на Клиници за васкуларну и ендоваскуларну хирургију Универзитетског клиничког центра Србије. Едукације и стручна усавршавања стекао је у европским центрима и редован је учесник међународних едукација из кардиоваскуларне радиологије.',
	description_ru = 'Специалист по радиологии и субспециалист по ангиологии, специализируется на MDCT-диагностике сердечно-сосудистой системы. Работает в Клинике васкулярной и эндоваскулярной хирургии Университетского клинического центра Сербии. Проходил обучение и повышение квалификации в европейских центрах, регулярно участвует в международных образовательных программах по кардиоваскулярной радиологии.',
	description_en = 'A specialist in radiology and subspecialist in angiology, focused on MDCT imaging of the cardiovascular system. He works at the Clinic for Vascular and Endovascular Surgery of the University Clinical Centre of Serbia. He trained and took further qualifications at European centres and regularly attends international courses in cardiovascular radiology.',
	description_de = 'Facharzt für Radiologie und Subspezialist für Angiologie mit Schwerpunkt auf der MDCT-Diagnostik des Herz-Kreislauf-Systems. Er ist an der Klinik für vaskuläre und endovaskuläre Chirurgie des Universitätsklinischen Zentrums Serbiens tätig. Seine Ausbildung und Weiterbildungen absolvierte er an europäischen Zentren und nimmt regelmäßig an internationalen Fortbildungen der kardiovaskulären Radiologie teil.',
	description_tr = 'Radyoloji uzmanı ve anjiyoloji yan dal uzmanı olup kardiyovasküler sistemin MDCT görüntülemesine odaklanmıştır. Sırbistan Üniversite Klinik Merkezinin Vasküler ve Endovasküler Cerrahi Kliniğinde çalışmaktadır. Eğitim ve uzmanlık çalışmalarını Avrupa merkezlerinde yapmış olup kardiyovasküler radyoloji alanındaki uluslararası eğitimlere düzenli olarak katılmaktadır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 10);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (@doctor_id, @clinic_id);

-- ───────────────────────────────────────────────────────────────
-- НЕ привязаны — упомянуты только в отзывах, клиника их не заявляет
-- ───────────────────────────────────────────────────────────────
-- ⚠️ Mirela Kalić. Решение «завести минимальную карточку» принималось до того,
-- как нашлись посты «NAŠ TIM», и его посылка изменилась дважды:
--   1) она УЖЕ есть в базе — doctors.id = 1359, slug mirela-kalic, radiology,
--      привязана к клинике 138 «Opšta Bolnica Berane» (импорт 2026-07-20).
--      То есть это было бы не создание, а привязка второй клиники;
--   2) сводная карточка «NAŠ TIM — SPECIJALISTA RADIOLOGIJE» перечисляет
--      только Ćosović / Jarić / Radmili — Mirela Kalić в состав не входит.
-- Единственный источник на неё — отзыв пациента трёхмесячной давности
-- («Doktorica Mirela Kalic strucna i preljubazna»). Утверждать по нему, что
-- беранский радиолог работает и здесь, не стали. Если знаете, что это тот же
-- человек и он здесь читает снимки — раскомментировать одну строку:
-- INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id) VALUES (1359, @clinic_id);
--
-- Vanja Matović («nasmijana, harizmatična i pozitivna») и Dunja («Dunja je
-- odlicna!») — роли в отзывах не указаны, в составе врачей их нет.
-- Скорее всего техники или администраторы; таблица doctors только для врачей.

-- ═══════════════════════════════════════════════════════════════
-- PART 5: SERVICES
-- ═══════════════════════════════════════════════════════════════
-- Источник — посты и Stories instagram.com/radiomedic.me (2026-09-03).
-- В каталог попадают ТОЛЬКО те позиции, которые клиника назвала явно.
-- Рекламные обороты сайта («snimanja svih regija tijela», «rendgenско
-- snimanje pluća, kostiju, kičme, ekstremiteta i sinusa») в конкретные
-- позиции НЕ разворачиваются — это перечисление возможностей аппарата,
-- а не заявленный прайс.
--
-- ЦЕНЫ. Заполнена одна: MR цијеле кичме = 255 € — это зачёркнутая ОБЫЧНАЯ
-- цена с карточки «AKCIJA» (255 € → 160 € до 15. septembra). Акционные цены
-- сознательно НЕ импортируются (решение владельца каталога: следить за
-- акциями клиник мы не будем), поэтому:
--   * 160 € за MR кичме не пишем;
--   * «SPECIJALNA CIJENA / DOPLER donjih ekstremiteta i vrata / 60 €» не
--     пишем — это акция, а не прайс, и цена на пару услуг, её нельзя
--     разложить на две позиции каталога;
--   * «CT -40% / MAGNET -30% do 15. septembra» в clinic_coupons не заводим:
--     схема купона хранит один discount_percent на весь applies_to, две
--     разные скидки по модальностям в неё не укладываются.
-- Остальные позиции — без цены (клиника их не публикует).
--
-- Идемпотентно: INSERT IGNORE по составному уникальному ключу
-- unique_clinic_service (clinic_id, medical_service_id).

-- ───────────────────────────────────────────────────────────────
-- Магнитна резонанца (Philips MR 5300)
-- ───────────────────────────────────────────────────────────────
-- 3804 MR cijele kičme                        — пост «AKCIJA MR KOMPLETNE KIČME»
-- 3141 MR pregled mozga                       — Stories «MR mozga», «Kada je potrebno uraditi MR glave?»
-- 3167 MR pregled jednog (zgloba) koljena     — Stories «Kada je potrebno uraditi MR KOLJENA?»
-- 4921 MR pregled osteomuskularnog sistema    — Stories «MR zglobno-koštanih struktura»
-- 3812 MR male karlice                        — Stories «MR male karlice»
-- 3174 MR pregled prostate (multiparametarska) — Stories «MR PROSTATE»
--      ⚠️ источник говорит просто «MR prostate»; уточнение «многопараметрическая»
--      взято из названия позиции каталога, клиника протокол не называет.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max) VALUES
	(@clinic_id, 3804, 255, NULL, NULL),
	(@clinic_id, 3141, NULL, NULL, NULL),
	(@clinic_id, 3167, NULL, NULL, NULL),
	(@clinic_id, 4921, NULL, NULL, NULL),
	(@clinic_id, 3812, NULL, NULL, NULL),
	(@clinic_id, 3174, NULL, NULL, NULL);

-- ───────────────────────────────────────────────────────────────
-- CT (Philips Incisive CT)
-- ───────────────────────────────────────────────────────────────
-- 3180 MSCT pregled toraksa (grudni koš) bez kontrasta — Stories «CT PLUĆA»
-- 3177 MSCT pregled paranazalnih šupljina (sinusa) bez kontrasta — пост «CT SNIMAK SINUSA»
--      Оба «bez kontrasta»: контрастные протоколы клиника отдельно не заявляла.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max) VALUES
	(@clinic_id, 3180, NULL, NULL, NULL),
	(@clinic_id, 3177, NULL, NULL, NULL);

-- ───────────────────────────────────────────────────────────────
-- Ултразвук (Siemens ACUSON Juniper)
-- Источник — Stories «Koje se sve regije mogu snimiti ultrazvukom?»:
-- Abdomen · Štitasta žlijezda · Dojke · Krvni sudovi · Meki dijelovi ·
-- Zglobovi, mišići i tetive · Urogenitalna regija
-- ───────────────────────────────────────────────────────────────
-- 2105 Ultrazvuk abdomena          ← Abdomen
-- 1543 Ultrazvuk štitne žlezde     ← Štitasta žlijezda
-- 2000 Ultrazvuk dojki             ← Dojke
-- 2104 Dopler krvnih sudova        ← Krvni sudovi
-- 1998 Ultrazvuk mekih tkiva       ← Meki dijelovi
-- 4573 Mišićno-skeletni ultrazvuk  ← Zglobovi, mišići i tetive
-- 1999 Ultrazvuk urotrakta         ← Urogenitalna regija
--      ⚠️ ближайшая позиция каталога: «урогенитальная область» шире
--      уротракта. Отдельной позиции под неё в каталоге нет.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max) VALUES
	(@clinic_id, 2105, NULL, NULL, NULL),
	(@clinic_id, 1543, NULL, NULL, NULL),
	(@clinic_id, 2000, NULL, NULL, NULL),
	(@clinic_id, 2104, NULL, NULL, NULL),
	(@clinic_id, 1998, NULL, NULL, NULL),
	(@clinic_id, 4573, NULL, NULL, NULL),
	(@clinic_id, 1999, NULL, NULL, NULL);

-- ───────────────────────────────────────────────────────────────
-- Доплер отдельными позициями
-- Источник — карточка «SPECIJALNA CIJENA / DOPLER donjih ekstremiteta i
-- vrata». Сами услуги клиника заявляет, цену не берём (см. выше).
-- ───────────────────────────────────────────────────────────────
-- 2004 Dopler donjih ekstremiteta
-- 2002 Dopler vrata
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max) VALUES
	(@clinic_id, 2004, NULL, NULL, NULL),
	(@clinic_id, 2002, NULL, NULL, NULL);

-- Рентген (Siemens MULTIX Impact) отдельными позициями НЕ заводим: клиника
-- называет только области применения аппарата («kosti, pluća»), ни одной
-- конкретной проекции или снимка в постах нет.

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1' (только SR),
-- clinic_types = '4'
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone,
	c.google_place_id, c.instagram, c.facebook,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается: 6 рабочих дней 07:00–21:00 + closed в воскресенье
SELECT clinic_id, monday, saturday, sunday
FROM clinic_working_hours WHERE clinic_id = @clinic_id;

-- Ожидается 3 врача: Ćosović (radiology), Jarić (radiology + mammology),
-- Radmili (radiology); языки sr; photo — NO PHOTO у всех трёх.
-- ⚠️ Если created_at сильно старше даты запуска — врач уже был в базе,
-- убедиться, что это тот же человек (проверка на однофамильцев).
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, d.professional_title,
	GROUP_CONCAT(DISTINCT s.name ORDER BY s.name) AS specialties,
	GROUP_CONCAT(DISTINCT l.code ORDER BY l.code) AS languages,
	IF(d.photo_url IS NULL OR d.photo_url = '', 'NO PHOTO', 'ok') AS photo,
	d.created_at
FROM doctors d
JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
LEFT JOIN doctor_specialties ds ON ds.doctor_id = d.id
LEFT JOIN specialties s ON s.id = ds.specialty_id
LEFT JOIN doctor_languages dl ON dl.doctor_id = d.id
LEFT JOIN languages l ON l.id = dl.language_id
GROUP BY d.id
ORDER BY d.name_sr;

-- Ожидается 17 услуг, цена только у «MR cijele kičme» = 255.00
SELECT COUNT(*) AS services_total, SUM(cms.price IS NOT NULL) AS with_price
FROM clinic_medical_services cms WHERE cms.clinic_id = @clinic_id;

SELECT ms.id, ms.name_sr, ms.name_en, cms.price
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY cms.price IS NULL, ms.name_sr;

SELECT @clinic_id AS use_this_clinic_id_for_reviews_import;

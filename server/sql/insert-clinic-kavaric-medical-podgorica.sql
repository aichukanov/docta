-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Kavarić Medical (Podgorica) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-kavaric-medical-podgorica.sql
-- Затем: server/sql/insert-clinic-kavaric-medical-podgorica-services.sql
-- Запись импорта: data/clinic-imports/kavaric-medical-podgorica.json. Подволна 2d, агент V.
-- 
-- Источники (собрано 2026-10-09, сырой HTML curl с браузерным UA):
--   * https://www.kavaricmedical.me/ — статический сайт из 2 страниц (index.html, usluge.html), ISO-8859-1, © 2016, в подвале шаблонный
--     «Text o kompaniji …» → ⚠️ САЙТ 2016 г.: состав, часы и перечень услуг могли устареть. Цен нет.
--   * data/google-places/podgorica/kavaric-medical.json — place_id, координаты 42.4485514 / 19.2448652, +382 69 012 826,
--     «58 Далматинска улица, Подгорица 81000», отзывов 0 (Google не перезапрашивался).
-- 
-- Это НЕ сеть K-med (Nebojša/Igor Kavarić, Бар/Ульцинь) — разные клиники, не связываются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJt_kc5UjrTRMROG5wvBFbn8w';
SET @clinic_slug = 'kavaric-medical-podgorica';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr IN ('Kavarić Medical', 'PZU Kavarić Medical', 'Kavaric Medical') AND city_id = 1 LIMIT 1));

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
	'Kavarić Medical',
	'Kavarić Medical',
	'Kavarić Medical',
	'Dalmatinska 58',
	'Далматинска 58',
	'',
	'',
	'81000',
	42.44855140,
	19.24486520,
	'+38269012826;+38220671132',
	'kavaricmedical@gmail.com',
	'https://www.kavaricmedical.me/',
	'',
	'',
	'',
	'',
	'',
	'https://www.kavaricmedical.me/images/Logo-Kavaric-Medical-01.gif',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи. status не меняем; координаты — если пусты или 0.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = IF(latitude IS NULL OR latitude = 0, 42.44855140, latitude),
	longitude = IF(longitude IS NULL OR longitude = 0, 19.24486520, longitude),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Kavarić Medical', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Kavarić Medical', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Dalmatinska 58', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Далматинска 58', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81000', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38269012826;+38220671132', phone),
	email = IF(email IS NULL OR email = '', 'kavaricmedical@gmail.com', email),
	website = IF(website IS NULL OR website = '', 'https://www.kavaricmedical.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://www.kavaricmedical.me/images/Logo-Kavaric-Medical-01.gif', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловно (правки текстов доезжают до уже созданной клиники). Только то, что клиника пишет о себе.
-- ⚠️ Правки из админки следующий прогон перезапишет — вносить сюда.
UPDATE clinics SET
	description_sr = 'PZU Kavarić Medical je privatna ordinacija za ginekologiju i urologiju u Podgorici, u Dalmatinskoj ulici 58 (iza Bazara). Osnivači su dr sci. Petar Kavarić, specijalista urolog, i dr Vesna Globarević Kavarić, specijalista ginekologije i akušerstva. Usluge: ginekološki i urološki pregledi; ultrazvuk u ginekologiji i urologiji; ultrazvuk i pregledi u trudnoći, CTG; 3D ultrazvuk, kolor dopler, folikulometrija; dijagnostika i liječenje urogenitalnih infekcija i kondiloma; rana dijagnostika premalignih i malignih lezija grlića materice (PAPA bris, HPV brisevi, kolposkopija, biopsija); ginekološke intervencije (polipi, eksplorativna kiretaža); ugradnja i vađenje spirale i kontracepcija; dijagnostika i liječenje steriliteta kod žena i muškaraca, spermogram, IUI i IVF; cistoskopija i bužiranje; cirkumcizija i dorzalna incizija; rana dijagnostika karcinoma prostate (TRUS biopsija prostate s patohistološkim nalazom); kateterizacija mokraćne bešike; liječenje stresne inkontinencije kod žena. Zakazivanje telefonom od 8 do 20 h.',
	description_sr_cyrl = 'ПЗУ Kavarić Medical је приватна ординација за гинекологију и урологију у Подгорици, у Далматинској улици 58 (иза Базара). Оснивачи су др сци. Петар Каварић, специјалиста уролог, и др Весна Глобаревић Каварић, специјалиста гинекологије и акушерства. Услуге: гинеколошки и уролошки прегледи; ултразвук у гинекологији и урологији; ултразвук и прегледи у трудноћи, CTG; 3D ултразвук, колор доплер, фоликулометрија; дијагностика и лијечење урогениталних инфекција и кондилома; рана дијагностика премалигних и малигних лезија грлића материце (PAPA брис, HPV брисеви, колпоскопија, биопсија); гинеколошке интервенције (полипи, експлоративна киретажа); уградња и вађење спирале и контрацепција; дијагностика и лијечење стерилитета код жена и мушкараца, спермограм, IUI и IVF; цистоскопија и бужирање; циркумцизија и дорзална инцизија; рана дијагностика карцинома простате (TRUS биопсија простате с патохистолошким налазом); катетеризација мокраћне бешике; лијечење стресне инконтиненције код жена. Заказивање телефоном од 8 до 20 х.',
	description_ru = 'PZU Kavarić Medical — частный кабинет гинекологии и урологии в Подгорице, улица Dalmatinska 58 (за рынком «Базар»). Основатели — д-р наук Петар Каварич, уролог, и д-р Весна Глобаревич Каварич, специалист по гинекологии и акушерству. Услуги: гинекологические и урологические осмотры; УЗИ в гинекологии и урологии; УЗИ и осмотры при беременности, КТГ; 3D УЗИ, цветовой допплер, фолликулометрия; диагностика и лечение урогенитальных инфекций и кондилом; ранняя диагностика предраковых и злокачественных изменений шейки матки (мазок ПАП, мазки на ВПЧ, кольпоскопия, биопсия); гинекологические вмешательства (полипы, диагностическое выскабливание); установка и удаление спирали, контрацепция; диагностика и лечение бесплодия у женщин и мужчин, спермограмма, ВМИ и ЭКО; цистоскопия и бужирование; циркумцизия и дорсальное рассечение; ранняя диагностика рака простаты (TRUS-биопсия простаты с гистологией); катетеризация мочевого пузыря; лечение стрессового недержания мочи у женщин. Запись по телефону с 8 до 20 часов.',
	description_en = 'PZU Kavarić Medical is a private gynaecology and urology practice in Podgorica at Dalmatinska 58 (behind the Bazar market). It was founded by Dr Sci. Petar Kavarić, specialist urologist, and Dr Vesna Globarević Kavarić, specialist in gynaecology and obstetrics. Services: gynaecological and urological examinations; ultrasound in gynaecology and urology; pregnancy ultrasound and check-ups, CTG; 3D ultrasound, colour Doppler, folliculometry; diagnosis and treatment of urogenital infections and condylomas; early diagnosis of premalignant and malignant cervical lesions (Pap smear, HPV swabs, colposcopy, biopsy); gynaecological procedures (polyps, exploratory curettage); IUD insertion and removal, contraception; diagnosis and treatment of female and male infertility, semen analysis, IUI and IVF; cystoscopy and urethral bougienage; circumcision and dorsal slit; early diagnosis of prostate cancer (TRUS prostate biopsy with histopathology); bladder catheterisation; treatment of stress urinary incontinence in women. Appointments by phone from 8:00 to 20:00.',
	description_de = 'Die PZU Kavarić Medical ist eine private Praxis für Gynäkologie und Urologie in Podgorica, Dalmatinska 58 (hinter dem Markt Bazar). Gegründet wurde sie von Dr. sc. Petar Kavarić, Facharzt für Urologie, und Dr. Vesna Globarević Kavarić, Fachärztin für Gynäkologie und Geburtshilfe. Leistungen: gynäkologische und urologische Untersuchungen; Ultraschall in Gynäkologie und Urologie; Schwangerschaftsultraschall und -vorsorge, CTG; 3D-Ultraschall, Farbdoppler, Follikelmonitoring; Diagnose und Behandlung urogenitaler Infektionen und Kondylome; Früherkennung prämaligner und maligner Veränderungen des Gebärmutterhalses (Pap-Abstrich, HPV-Abstriche, Kolposkopie, Biopsie); gynäkologische Eingriffe (Polypen, diagnostische Kürettage); Einsetzen und Entfernen der Spirale, Verhütung; Diagnose und Behandlung von Unfruchtbarkeit bei Frauen und Männern, Spermiogramm, IUI und IVF; Zystoskopie und Bougierung; Zirkumzision und dorsale Inzision; Früherkennung von Prostatakrebs (TRUS-Prostatabiopsie mit Histopathologie); Blasenkatheterisierung; Behandlung der Belastungsinkontinenz bei Frauen. Terminvereinbarung telefonisch von 8 bis 20 Uhr.',
	description_tr = 'PZU Kavarić Medical, Podgorica''da Dalmatinska 58 adresinde (Bazar pazarının arkasında) bulunan özel bir kadın hastalıkları ve üroloji muayenehanesidir. Kurucuları üroloji uzmanı Dr. Sci. Petar Kavarić ve kadın hastalıkları ve doğum uzmanı Dr. Vesna Globarević Kavarić''tir. Hizmetler: jinekolojik ve ürolojik muayeneler; jinekoloji ve ürolojide ultrason; gebelikte ultrason ve muayeneler, KTG; 3D ultrason, renkli Doppler, folikül takibi; ürogenital enfeksiyonların ve kondilomların teşhis ve tedavisi; rahim ağzındaki kanser öncesi ve kötü huylu lezyonların erken teşhisi (Pap smear, HPV sürüntüleri, kolposkopi, biyopsi); jinekolojik müdahaleler (polipler, tanısal küretaj); spiral takılması ve çıkarılması, doğum kontrolü; kadın ve erkekte kısırlığın teşhis ve tedavisi, sperm analizi, IUI ve tüp bebek (IVF); sistoskopi ve bujinaj; sünnet ve dorsal kesi; prostat kanserinin erken teşhisi (histopatolojili TRUS prostat biyopsisi); mesane kateterizasyonu; kadınlarda stres idrar kaçırmanın tedavisi. Telefonla randevu: 8:00–20:00.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- GYNECOLOGICAL_CLINIC = 7 + UROLOGICAL_CLINIC = 8 (главная: «Ginekologija, Urologija, Ultrazvuk, Pregledi, Konsultacije»).
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 7), (@clinic_id, 8);

-- clinic_languages без UNIQUE: синхронизация вместо INSERT IGNORE. Сайт только на сербском, другие языки не заявлены → только SR (1).
SET @keep_lang_1 = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages
WHERE clinic_id = @clinic_id
  AND NOT (id <=> @keep_lang_1);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы — главная index.html (решение координатора 2026-10-09): «Radno vrijeme 9:30-13h i 16-20:30, Subota: 9:30-13h». Вс не назван → closed. «Radno vrijeme 08 do 21h» на usluge.html — общая фраза, не берём; «zvati od 8h do 20h» — часы телефона, в описании. ⚠️ Сайт © 2016.
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "13:00"}, {"start": "16:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "13:00"}, {"start": "16:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "13:00"}, {"start": "16:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "13:00"}, {"start": "16:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "13:00"}, {"start": "16:00", "end": "20:30"}]}',
	'{"type": "regular", "intervals": [{"start": "09:30", "end": "13:00"}]}',
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
-- Источник: блок «Osnivači» главной (фото — images/slike limuzine/demo/*.gif, 125×125). Других врачей на сайте нет.
-- Привязки врач↔услуга — по профилю (урология → Petar, гинекология → Vesna), см. services-SQL.

-- ───────────────────────────────────────────────────────────────
-- «dr. sci Petar Kavarić, urolog — Specijalista urolog od 1994 godine. Radi u KCCG na Klinici za urologiju i nefrologiju od 1990 godine.» (Osnivači).
-- В БД есть: petar-kavaric (локаль id 667, specialty 9 UROLOGY, novi-cenex-medical-podgorica, фото нет; прод-API 200) — тот же уролог в Подгорице → привязка.
-- К КЦЦГ в БД не привязан; сайт 2016 г. («radi u KCCG») — привязку к КЦЦГ не добавляем (не наш импорт, данные могли устареть).
-- Это НЕ семья K-med (Nebojša/Igor Kavarić) — не связываем. Фото с сайта (125×125 gif) — дозаполнение, в БД фото нет.
-- Титул на сайте «dr. sci» — существующий professional_title не трогаем.
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE slug = 'petar-kavaric' LIMIT 1);

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'petar-kavaric', 'Petar Kavarić', 'Петар Каварић', 'Петар Каварич', 'Petar Kavaric', 'Dr',
	'https://www.kavaricmedical.me/images/slike%20limuzine/demo/petar.gif', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.kavaricmedical.me/images/slike%20limuzine/demo/petar.gif', photo_url) WHERE id = @doctor_id;

-- Врач уже в БД: дозаполнение пустых имён (ru/en), существующие не трогаем.
UPDATE doctors SET
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Петар Каварич', name_ru),
	name_en = IF(name_en IS NULL OR name_en = '', 'Petar Kavaric', name_en)
WHERE id = @doctor_id;

-- Врач уже в БД (другие клиники): описание по тексту сайта — только если пусто (description_sr), чужое не перезаписываем.
UPDATE doctors SET
	description_sr_cyrl = IF(description_sr IS NULL OR description_sr = '', 'Специјалиста уролог од 1994. године. На Клиници за урологију и нефрологију Клиничког центра Црне Горе ради од 1990. године. Оснивач ПЗУ Kavarić Medical у Подгорици.', description_sr_cyrl),
	description_ru = IF(description_sr IS NULL OR description_sr = '', 'Уролог, специалист с 1994 года. С 1990 года работает в Клинике урологии и нефрологии Клинического центра Черногории. Основатель PZU Kavarić Medical в Подгорице.', description_ru),
	description_en = IF(description_sr IS NULL OR description_sr = '', 'Specialist urologist since 1994. He has worked at the Clinic of Urology and Nephrology of the Clinical Centre of Montenegro since 1990. Founder of PZU Kavarić Medical in Podgorica.', description_en),
	description_de = IF(description_sr IS NULL OR description_sr = '', 'Facharzt für Urologie seit 1994. Seit 1990 arbeitet er an der Klinik für Urologie und Nephrologie des Klinischen Zentrums Montenegro. Gründer der PZU Kavarić Medical in Podgorica.', description_de),
	description_tr = IF(description_sr IS NULL OR description_sr = '', '1994''ten beri üroloji uzmanı. 1990''dan bu yana Karadağ Klinik Merkezi Üroloji ve Nefroloji Kliniği''nde çalışmaktadır. Podgorica''daki PZU Kavarić Medical''in kurucusudur.', description_tr),
	description_sr = IF(description_sr IS NULL OR description_sr = '', 'Specijalista urolog od 1994. godine. Na Klinici za urologiju i nefrologiju Kliničkog centra Crne Gore radi od 1990. godine. Osnivač PZU Kavarić Medical u Podgorici.', description_sr)
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 9);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Osnivač, specijalista urolog')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ───────────────────────────────────────────────────────────────
-- «dr. Vesna Globarević Kavarić, ginekolog — Specijalista ginekologije i akušetsva od 1996 godine. Radila je u Domu zdravlja u Podgorici, Centru za humanu reprodukciju Opšte bolnice "Danilo I" na Cetinju i PZU Codra. Bavi se opštom ginekologijom, dijagnostikom infertiliteta i savremenim procedurama asistirane reproduktivne tehnologije …».
-- В БД не найдена (локаль: vesna-globarevic-kavaric, vesna-kavaric, kavaric-vesna — нет; Globarević есть только Ljiljana (педиатр) и Gordana Globarević Vukčević — другие люди; прод-API 204) — новая.
-- 5 = GYNECOLOGY_OBSTETRICS. 38 REPRODUCTIVE_MEDICINE не ставим: специализация по репродуктологии не заявлена, только «bavi se … asistirane reproduktivne tehnologije».
-- ───────────────────────────────────────────────────────────────
SET @doctor_id = (SELECT id FROM doctors WHERE name_sr = 'Vesna Globarević Kavarić' LIMIT 1);
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE name_sr = 'Globarević Kavarić Vesna' LIMIT 1));
SET @doctor_id = COALESCE(@doctor_id, (SELECT id FROM doctors WHERE slug = 'vesna-globarevic-kavaric' LIMIT 1));

INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-globarevic-kavaric', 'Vesna Globarević Kavarić', 'Весна Глобаревић Каварић', 'Весна Глобаревич Каварич', 'Vesna Globarevic Kavaric', 'Dr',
	'https://www.kavaricmedical.me/images/slike%20limuzine/demo/vesna.gif', NOW()
FROM dual WHERE @doctor_id IS NULL;
SET @doctor_id = COALESCE(@doctor_id, LAST_INSERT_ID());

-- Фото: дозаполнение, если пусто (существующее фото не трогаем).
UPDATE doctors SET photo_url = IF(photo_url IS NULL OR photo_url = '', 'https://www.kavaricmedical.me/images/slike%20limuzine/demo/vesna.gif', photo_url) WHERE id = @doctor_id;

-- Описание — безусловно, только по тексту сайта клиники.
UPDATE doctors SET
	description_sr = 'Specijalista ginekologije i akušerstva od 1996. godine. Radila je u Domu zdravlja u Podgorici, Centru za humanu reprodukciju Opšte bolnice „Danilo I“ na Cetinju i PZU Codra. Bavi se opštom ginekologijom, dijagnostikom infertiliteta i savremenim procedurama asistirane reproduktivne tehnologije, kao što su inseminacija i vantjelesna oplodnja. Suosnivač PZU Kavarić Medical.',
	description_sr_cyrl = 'Специјалиста гинекологије и акушерства од 1996. године. Радила је у Дому здравља у Подгорици, Центру за хуману репродукцију Опште болнице „Данило И“ на Цетињу и ПЗУ Codra. Бави се општом гинекологијом, дијагностиком инфертилитета и савременим процедурама асистиране репродуктивне технологије, као што су инсеминација и вантјелесна оплодња. Суоснивач ПЗУ Kavarić Medical.',
	description_ru = 'Специалист по гинекологии и акушерству с 1996 года. Работала в Доме здоровья Подгорицы, Центре репродукции человека Общей больницы «Данило I» в Цетине и PZU Codra. Занимается общей гинекологией, диагностикой бесплодия и современными методами вспомогательных репродуктивных технологий — инсеминацией и ЭКО. Соучредитель PZU Kavarić Medical.',
	description_en = 'Specialist in gynaecology and obstetrics since 1996. She has worked at the Podgorica Health Centre, the Human Reproduction Centre of the "Danilo I" General Hospital in Cetinje and PZU Codra. She practises general gynaecology, infertility diagnostics and modern assisted reproductive technology procedures such as insemination and in vitro fertilisation. Co-founder of PZU Kavarić Medical.',
	description_de = 'Fachärztin für Gynäkologie und Geburtshilfe seit 1996. Sie arbeitete im Gesundheitszentrum Podgorica, im Zentrum für Humanreproduktion des Allgemeinkrankenhauses „Danilo I“ in Cetinje und in der PZU Codra. Sie befasst sich mit allgemeiner Gynäkologie, Unfruchtbarkeitsdiagnostik und modernen Verfahren der assistierten Reproduktion wie Insemination und In-vitro-Fertilisation. Mitgründerin der PZU Kavarić Medical.',
	description_tr = '1996''dan beri kadın hastalıkları ve doğum uzmanı. Podgorica Sağlık Merkezi''nde, Cetinje''deki "Danilo I" Genel Hastanesi İnsan Üreme Merkezi''nde ve PZU Codra''da çalıştı. Genel jinekoloji, kısırlık tanısı ve inseminasyon ile tüp bebek gibi modern yardımcı üreme teknikleriyle ilgilenmektedir. PZU Kavarić Medical''in kurucu ortağıdır.'
WHERE id = @doctor_id;

INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) VALUES (@doctor_id, 5);
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) VALUES (@doctor_id, 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) VALUES (@doctor_id, @clinic_id, 'Osnivač, specijalista ginekologije i akušerstva')
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 1, status = published, clinic_languages = '1', clinic_types = '7,8', hours = 1
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.email, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 2: petar-kavaric (9), vesna-globarevic-kavaric (5).
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

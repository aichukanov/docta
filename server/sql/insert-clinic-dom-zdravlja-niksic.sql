-- ═══════════════════════════════════════════════════════════════════════════
-- ZU Dom zdravlja Nikšić (Nikšić, Šavnik, Plužine) — клиника + врачи
-- Подволна 2b (дома здоровья), агент F. Сгенерировано 2026-10-08.
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-niksic.sql
-- Затем: server/sql/insert-clinic-dom-zdravlja-niksic-services.sql
--
-- Источники (curl, сырой HTML и wp-json, 2026-10-08):
--   * https://domzdravljaniksic.me/ — WordPress. САЙТ ВЗЛОМАН: в шаблон страниц
--     внедрены скрытые блоки онлайн-казино (casinia, kenspin, spinkings и др.,
--     венгерский/английский/литовский/болгарский текст). Их текст игнорировался;
--     content.rendered из wp-json разделов врачей и служб спама не содержит.
--   * /izabrani-doktor/, /izabrani-doktor-za-djecu/, /izabrani-doktor-za-zene/,
--     /centri-za-podrsku/, /sluzba-medicine-rada-i-sporta-zu-dom-zdravlja-niksic/,
--     /jedinica-za-fizikalnu-terapiju-primarnog-nivoa/, /jedinica-za-patronazu/,
--     /osnovne-informacije/, /ambulante-ispostave/, /menadzment/, /kontakt/;
--   * PDF «Raspored doktora po ambulantama 05.10.–09.10.2026» (odrasli и djeca);
--   * DOCX «Dopunski rad zaposlenih» апрель и июнь 2026 — специальности врачей;
--   * data/google-places/niksic/zu-dom-zdravlja-niksic.json — place_id,
--     координаты, адрес, телефон.
--
-- Решения:
--   * Тип POLYCLINIC (1), язык только SR — как у всех ДЗ в БД.
--   * Место Google «Nikšić General Hospital» — это ОБ Никшич (клиника 141), к ДЗ
--     не относится и не используется.
--   * clinic_working_hours НЕ заполняется: сайт даёт только «две смены 07–14 и
--     14–21» без явного режима выходных (см. openQuestions в записи импорта).
--   * Специальности: IDO — general_medicine, «spec. porodične medicine» —
--     family_medicine, ХЭС — infectious_diseases (единые правила ДЗ,
--     data/clinic-teams/decisions/domovi-zdravlja.md).
--   * Не заведены: Rada Adžić и Mirjana Orbović (колонка «Izabrani doktor» в
--     таблице Plužine без «dr», а страница пишет «radi jedan ID»); dr Jela Knežević
--     (страница 2022 г.; в графике педиатров 05–09.10.2026 её нет, а в БД она
--     педиатр ДЗ Подгорица); директор dr Radovan Vušović (стоматолог,
--     администрация); психологи, соцработники, логопед, медсёстры.
--   * dr Dragana Radunović (IDO, амбулатория Straševina) — НЕ запись
--     dragana-radunovic: та — физиатр ДЗ Подгорица (био: вся карьера в Подгорице).
--     Новая запись dragana-radunovic-2, поиск только по slug.
--   * dr Ljiljana Adžić — slug ljiljana-adzic, поиск только по slug (согласовано
--     с агентом K, клиника Moj Doktor Nikšić).
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания
-- пишутся безусловным UPDATE, языки клиники синхронизируются.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJpxHe9q2pTRMRPnJUfQGgX_s';
SET @clinic_slug = 'dom-zdravlja-niksic';

-- Поиск существующей клиники: google_place_id → slug → name_sr.
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE name_sr = 'Dom zdravlja Nikšić' LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id,
	name_sr, name_sr_cyrl, name_ru,
	address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code,
	latitude, longitude,
	phone, email, website, facebook, instagram, telegram, whatsapp, viber,
	logo_url, created_at
)
SELECT
	@clinic_slug, @google_place_id, 'published', 2, -- CityId.NIKSIC
	'Dom zdravlja Nikšić', 'Дом здравља Никшић', 'Дом здоровья Никшич',
	'Radoja Dakića bb', 'Радоја Дакића бб', '', '', '81400',
	42.77734210, 18.94527910,
	'+38240231202;+38240227722', 'dzniksic1@t-com.me', 'https://domzdravljaniksic.me/', '', '', '', '', '',
	'https://domzdravljaniksic.me/wp-content/uploads/2022/07/logo-veliki.jpg', NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));

-- Дозаполнение только пустых полей уже существующей записи; status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	latitude = COALESCE(latitude, 42.77734210),
	longitude = COALESCE(longitude, 18.94527910),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Дом здравља Никшић', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Дом здоровья Никшич', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Radoja Dakića bb', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Радоја Дакића бб', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '81400', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38240231202;+38240227722', phone),
	email = IF(email IS NULL OR email = '', 'dzniksic1@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://domzdravljaniksic.me/', website),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://domzdravljaniksic.me/wp-content/uploads/2022/07/logo-veliki.jpg', logo_url)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись (самоисправляемость). Правки из админки
-- следующий прогон файла перезатрёт — вносить их сюда.
UPDATE clinics SET
	description_sr = 'ZU Dom zdravlja Nikšić je ustanova primarne zdravstvene zaštite za opštine Nikšić, Šavnik i Plužine. Pored centralne zgrade u Ulici Radoja Dakića, izabrani doktori rade u ambulantama Kličevo, Miolje Polje, Dragova Luka, Vidrovan, Straševina, Krstac, Bogetići i Velimlje (sa terenskim ambulantama Crkvice, Vraćenovići, Petrovići, Grahovo i Vilusi), kao i u zdravstvenim stanicama u Šavniku i Plužinama. U ustanovi rade izabrani doktori za odrasle, djecu i žene, internistička ambulanta, Centar za plućne bolesti i TBC, mikrobiološka laboratorija, Centar za mentalno zdravlje, Centar za djecu sa posebnim potrebama, savjetovališta, higijensko-epidemiološka služba, jedinica za patronažu, jedinica za fizikalnu terapiju i Služba medicine rada i sporta, koja izdaje ljekarska uvjerenja i obavlja sportsko-medicinske preglede. Ambulante izabranih doktora u Nikšiću rade u dvije smjene, od 07:00 do 21:00. Pregled kod izabranog doktora zakazuje se telefonom, na broj 040 22 77 22.',
	description_sr_cyrl = 'ЗУ Дом здравља Никшић је установа примарне здравствене заштите за општине Никшић, Шавник и Плужине. Поред централне зграде у Улици Радоја Дакића, изабрани доктори раде у амбулантама Кличево, Миоље Поље, Драгова Лука, Видрован, Страшевина, Крстац, Богетићи и Велимље (са теренским амбулантама Црквице, Враћеновићи, Петровићи, Грахово и Вилуси), као и у здравственим станицама у Шавнику и Плужинама. У установи раде изабрани доктори за одрасле, дјецу и жене, интернистичка амбуланта, Центар за плућне болести и ТБЦ, микробиолошка лабораторија, Центар за ментално здравље, Центар за дјецу са посебним потребама, савјетовалишта, хигијенско-епидемиолошка служба, јединица за патронажу, јединица за физикалну терапију и Служба медицине рада и спорта, која издаје љекарска увјерења и обавља спортско-медицинске прегледе. Амбуланте изабраних доктора у Никшићу раде у двије смјене, од 07:00 до 21:00. Преглед код изабраног доктора заказује се телефоном, на број 040 22 77 22.',
	description_ru = 'Дом здоровья Никшич — государственное учреждение первичной медицинской помощи для общин Никшич, Шавник и Плужине. Помимо главного здания на улице Радоя Дакича, избранные врачи принимают в амбулаториях Кличево, Миоле-Поле, Драгова-Лука, Видрован, Страшевина, Крстац, Богетичи и Велимле (с выездными амбулаториями в Црквице, Враченовичах, Петровичах, Грахово и Вилуси), а также в медпунктах Шавника и Плужине. В учреждении работают избранные врачи для взрослых, детей и женщин, кабинет интерниста, Центр лёгочных болезней и туберкулёза, микробиологическая лаборатория, Центр психического здоровья, Центр для детей с особыми потребностями, консультации, санитарно-эпидемиологическая служба, патронажная служба, отделение физиотерапии и служба медицины труда и спорта, которая выдаёт медицинские справки и проводит спортивно-медицинские осмотры. Амбулатории избранных врачей в Никшиче работают в две смены, с 07:00 до 21:00. Записаться к избранному врачу можно по телефону 040 22 77 22.',
	description_en = 'The Nikšić Health Centre (ZU Dom zdravlja Nikšić) is the public primary healthcare institution for the municipalities of Nikšić, Šavnik and Plužine. Besides the main building on Radoja Dakića Street, chosen doctors work in the outpatient clinics of Kličevo, Miolje Polje, Dragova Luka, Vidrovan, Straševina, Krstac, Bogetići and Velimlje (with field clinics in Crkvice, Vraćenovići, Petrovići, Grahovo and Vilusi), as well as in the health stations in Šavnik and Plužine. The centre has chosen doctors for adults, children and women, an internal medicine clinic, a Centre for Lung Diseases and TB, a microbiology laboratory, a Mental Health Centre, a Centre for Children with Special Needs, counselling services, a hygiene and epidemiology service, a home-visiting nursing unit, a physical therapy unit and an occupational and sports medicine service that issues medical certificates and performs sports medical examinations. The chosen doctors'' clinics in Nikšić work in two shifts, from 07:00 to 21:00. Appointments with a chosen doctor are made by phone on 040 22 77 22.',
	description_de = 'Das Gesundheitszentrum Nikšić (ZU Dom zdravlja Nikšić) ist die öffentliche Einrichtung der primären Gesundheitsversorgung für die Gemeinden Nikšić, Šavnik und Plužine. Neben dem Hauptgebäude in der Straße Radoja Dakića praktizieren die gewählten Ärzte in den Ambulanzen Kličevo, Miolje Polje, Dragova Luka, Vidrovan, Straševina, Krstac, Bogetići und Velimlje (mit Außenambulanzen in Crkvice, Vraćenovići, Petrovići, Grahovo und Vilusi) sowie in den Gesundheitsstationen Šavnik und Plužine. Im Zentrum arbeiten gewählte Ärzte für Erwachsene, Kinder und Frauen, eine internistische Ambulanz, ein Zentrum für Lungenkrankheiten und Tuberkulose, ein mikrobiologisches Labor, ein Zentrum für psychische Gesundheit, ein Zentrum für Kinder mit besonderen Bedürfnissen, Beratungsstellen, ein hygienisch-epidemiologischer Dienst, ein Hauspflegedienst, eine Physiotherapie-Einheit sowie ein Dienst für Arbeits- und Sportmedizin, der ärztliche Bescheinigungen ausstellt und sportmedizinische Untersuchungen durchführt. Die Ambulanzen der gewählten Ärzte in Nikšić arbeiten in zwei Schichten von 07:00 bis 21:00 Uhr. Termine beim gewählten Arzt werden telefonisch unter 040 22 77 22 vereinbart.',
	description_tr = 'Nikšić Sağlık Merkezi (ZU Dom zdravlja Nikšić), Nikšić, Šavnik ve Plužine belediyeleri için birinci basamak sağlık hizmeti veren kamu kurumudur. Radoja Dakića Caddesi''ndeki ana binanın yanı sıra seçilmiş doktorlar Kličevo, Miolje Polje, Dragova Luka, Vidrovan, Straševina, Krstac, Bogetići ve Velimlje polikliniklerinde (Crkvice, Vraćenovići, Petrovići, Grahovo ve Vilusi saha ambulanslarıyla birlikte) ve Šavnik ile Plužine sağlık istasyonlarında hizmet verir. Merkezde yetişkinler, çocuklar ve kadınlar için seçilmiş doktorlar, dahiliye polikliniği, Akciğer Hastalıkları ve Tüberküloz Merkezi, mikrobiyoloji laboratuvarı, Ruh Sağlığı Merkezi, Özel Gereksinimli Çocuklar Merkezi, danışma birimleri, hijyen ve epidemiyoloji servisi, evde bakım hemşireliği birimi, fizik tedavi birimi ile sağlık raporları düzenleyen ve sporcu sağlık muayeneleri yapan İş ve Spor Hekimliği servisi bulunur. Nikšić''teki seçilmiş doktor poliklinikleri 07:00–21:00 saatleri arasında iki vardiyada çalışır. Seçilmiş doktordan randevu 040 22 77 22 numaralı telefondan alınır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPE, LANGUAGES, HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 — как у всех 11 ДЗ в БД.
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) SELECT @clinic_id, 1 FROM dual WHERE @clinic_id IS NOT NULL;

-- clinic_languages без UNIQUE → синхронизация: оставить ровно одну строку SR.
-- Сайт о сопровождении на других языках не пишет.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE @clinic_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Рабочее время (clinic_working_hours) НЕ заполняется: сайт пишет «Ambulante
-- izabranih doktora … u Nikšiću rade u dvije smjene; prva smjena 07:00–14:00,
-- druga 14:00–21:00», но режим субботы и воскресенья не называет (только для
-- детей: «vikendom … Hitna medicinska pomoć»). См. openQuestions.

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Существующие — только привязка по slug. Новые — find-or-create:
-- slug → name_sr → перевёрнутое имя; специальности по specialties.name.
-- Фото на сайте нет → photo_url NULL.
-- ═══════════════════════════════════════════════════════════════

-- Страховка: slug существующих врачей, которых нет в этой БД. Ожидается ПУСТО.
SELECT x.s AS missing_existing_doctor FROM (SELECT 'colakovic-slavka' AS s UNION ALL SELECT 'ognjenovic-lidija' UNION ALL SELECT 'lalatovic-milena' UNION ALL SELECT 'nada-krivokapic' UNION ALL SELECT 'sturanovic-marijana' UNION ALL SELECT 'jovanovic-tijana' UNION ALL SELECT 'visnjic-stanislava' UNION ALL SELECT 'raicevic-dragoljub' UNION ALL SELECT 'glusac-milica' UNION ALL SELECT 'utjesinovic-jovan' UNION ALL SELECT 'jelica-zivkovic') x LEFT JOIN doctors d ON d.slug = x.s WHERE d.id IS NULL;

-- Vjera Bojović — family_medicine, occupational_medicine. /izabrani-doktor/ #1; Dopunski rad apr 2026: «Spec.porodične i med.rada»
SET @d = (SELECT id FROM doctors WHERE slug = 'vjera-bojovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vjera Bojović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bojović Vjera' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vjera-bojovic', 'Vjera Bojović', 'Вјера Бојовић', 'Вера Бойович', 'Vjera Bojovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vjera-bojovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('family_medicine', 'occupational_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Sonja Draganić — general_medicine. /izabrani-doktor/ #2
SET @d = (SELECT id FROM doctors WHERE slug = 'sonja-draganic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Sonja Draganić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Draganić Sonja' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sonja-draganic', 'Sonja Draganić', 'Соња Драганић', 'Соня Драганич', 'Sonja Draganic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sonja-draganic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Tanja Pješčić — general_medicine. /izabrani-doktor/ #3
SET @d = (SELECT id FROM doctors WHERE slug = 'tanja-pjescic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tanja Pješčić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Pješčić Tanja' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tanja-pjescic', 'Tanja Pješčić', 'Тања Пјешчић', 'Таня Пешчич', 'Tanja Pjescic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tanja-pjescic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Anđa Rutešić — internal_medicine. /izabrani-doktor/ #4; Dopunski rad jun 2026: «Spec.interne medicine»
SET @d = (SELECT id FROM doctors WHERE slug = 'andja-rutesic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Anđa Rutešić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Rutešić Anđa' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'andja-rutesic', 'Anđa Rutešić', 'Анђа Рутешић', 'Анджа Рутешич', 'Andja Rutesic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'andja-rutesic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Suzana Golubović — general_medicine. /izabrani-doktor/ #5
SET @d = (SELECT id FROM doctors WHERE slug = 'suzana-golubovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Suzana Golubović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Golubović Suzana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'suzana-golubovic', 'Suzana Golubović', 'Сузана Голубовић', 'Сузана Голубович', 'Suzana Golubovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'suzana-golubovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Tatjana Karadžić — general_medicine. /izabrani-doktor/ #6
SET @d = (SELECT id FROM doctors WHERE slug = 'tatjana-karadzic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tatjana Karadžić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Karadžić Tatjana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tatjana-karadzic', 'Tatjana Karadžić', 'Татјана Караџић', 'Татьяна Караджич', 'Tatjana Karadzic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tatjana-karadzic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Slavka Čolaković — существует в БД (colakovic-slavka), только привязка. /izabrani-doktor/ #7; raspored 05–09.10.2026: Ambulanta Kličevo
SET @d = (SELECT id FROM doctors WHERE slug = 'colakovic-slavka' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Vesna Zelović — general_medicine. /izabrani-doktor/ #8
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-zelovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vesna Zelović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Zelović Vesna' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-zelovic', 'Vesna Zelović', 'Весна Зеловић', 'Весна Зелович', 'Vesna Zelovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-zelovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Dragana Radunović — general_medicine. /izabrani-doktor/ #9; raspored 05–09.10.2026: Ambulanta Straševina
SET @d = (SELECT id FROM doctors WHERE slug = 'dragana-radunovic-2' LIMIT 1);
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragana-radunovic-2', 'Dragana Radunović', 'Драгана Радуновић', 'Драгана Радунович', 'Dragana Radunovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dragana-radunovic-2' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Lidija Ognjenović — существует в БД (ognjenovic-lidija), только привязка. /izabrani-doktor/ #10
SET @d = (SELECT id FROM doctors WHERE slug = 'ognjenovic-lidija' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Jelena Koprivica — general_medicine. /izabrani-doktor/ #11
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-koprivica' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jelena Koprivica' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Koprivica Jelena' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-koprivica', 'Jelena Koprivica', 'Јелена Копривица', 'Елена Копривица', 'Jelena Koprivica', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-koprivica' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Milena Lalatović — существует в БД (lalatovic-milena), только привязка. /izabrani-doktor/ #12; /menadzment/
SET @d = (SELECT id FROM doctors WHERE slug = 'lalatovic-milena' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle; pomoćnik direktora za medicinska pitanja' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Stana Simić — general_medicine. /izabrani-doktor/ #13
SET @d = (SELECT id FROM doctors WHERE slug = 'stana-simic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stana Simić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Simić Stana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'stana-simic', 'Stana Simić', 'Стана Симић', 'Стана Симич', 'Stana Simic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'stana-simic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ljiljana Adžić — general_medicine. /izabrani-doktor/ #14; mojdoktor.co.me: «specijalista opšte medicine». Slug согласован с агентом K (Moj Doktor)
SET @d = (SELECT id FROM doctors WHERE slug = 'ljiljana-adzic' LIMIT 1);
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljiljana-adzic', 'Ljiljana Adžić', 'Љиљана Аџић', 'Лиляна Аджич', 'Ljiljana Adzic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ljiljana-adzic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Svetlana Drašković — general_medicine. /izabrani-doktor/ #15
SET @d = (SELECT id FROM doctors WHERE slug = 'svetlana-draskovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Svetlana Drašković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Drašković Svetlana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'svetlana-draskovic', 'Svetlana Drašković', 'Светлана Драшковић', 'Светлана Драшкович', 'Svetlana Draskovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'svetlana-draskovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Nada Krivokapić — существует в БД (nada-krivokapic), только привязка. /izabrani-doktor/ #16
SET @d = (SELECT id FROM doctors WHERE slug = 'nada-krivokapic' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Amela Rastoder Čelebić — general_medicine. /izabrani-doktor/ #17
SET @d = (SELECT id FROM doctors WHERE slug = 'amela-rastoder-celebic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Amela Rastoder Čelebić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Rastoder Čelebić Amela' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'amela-rastoder-celebic', 'Amela Rastoder Čelebić', 'Амела Растодер Челебић', 'Амела Растодер Челебич', 'Amela Rastoder Celebic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'amela-rastoder-celebic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Aleksandar Ždrale — general_medicine. /izabrani-doktor/ #18
SET @d = (SELECT id FROM doctors WHERE slug = 'aleksandar-zdrale' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Aleksandar Ždrale' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ždrale Aleksandar' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'aleksandar-zdrale', 'Aleksandar Ždrale', 'Александар Ждрале', 'Александар Ждрале', 'Aleksandar Zdrale', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'aleksandar-zdrale' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Marijana Šturanović — существует в БД (sturanovic-marijana), только привязка. /izabrani-doktor/ #19
SET @d = (SELECT id FROM doctors WHERE slug = 'sturanovic-marijana' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ljubica Todorović — general_medicine. /izabrani-doktor/ #20
SET @d = (SELECT id FROM doctors WHERE slug = 'ljubica-todorovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ljubica Todorović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Todorović Ljubica' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ljubica-todorovic', 'Ljubica Todorović', 'Љубица Тодоровић', 'Любица Тодорович', 'Ljubica Todorovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ljubica-todorovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Jelena Kolak — general_medicine. /izabrani-doktor/ #21
SET @d = (SELECT id FROM doctors WHERE slug = 'jelena-kolak' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Jelena Kolak' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kolak Jelena' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jelena-kolak', 'Jelena Kolak', 'Јелена Колак', 'Елена Колак', 'Jelena Kolak', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jelena-kolak' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Milica Tabaković — general_medicine. /izabrani-doktor/ Punkt MZ Kličevo
SET @d = (SELECT id FROM doctors WHERE slug = 'milica-tabakovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milica Tabaković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tabaković Milica' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milica-tabakovic', 'Milica Tabaković', 'Милица Табаковић', 'Милица Табакович', 'Milica Tabakovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milica-tabakovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, punkt MZ Kličevo' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Goran Kosić — family_medicine. /izabrani-doktor/ Punkt MZ Vidrovan; raspored 05–09.10.2026: Ambulanta Vidrovan; post 2025-11-18 «specijalista porodične medicine dr Goran Kosić»
SET @d = (SELECT id FROM doctors WHERE slug = 'goran-kosic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Goran Kosić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kosić Goran' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'goran-kosic', 'Goran Kosić', 'Горан Косић', 'Горан Косич', 'Goran Kosic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'goran-kosic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('family_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, punkt MZ Vidrovan' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Sanja Bušaj — general_medicine. /izabrani-doktor/ Lokacija: Opština Šavnik
SET @d = (SELECT id FROM doctors WHERE slug = 'sanja-busaj' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Sanja Bušaj' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Bušaj Sanja' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanja-busaj', 'Sanja Bušaj', 'Сања Бушај', 'Саня Бушай', 'Sanja Busaj', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sanja-busaj' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor, Zdravstvena stanica Šavnik' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Vuk Dubak — general_medicine. raspored-za-ID-odrasle-5-oktobar.pdf (05–09.10.2026): «Dr Vuk Dubak, Amb. 11»
SET @d = (SELECT id FROM doctors WHERE slug = 'vuk-dubak' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vuk Dubak' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dubak Vuk' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vuk-dubak', 'Vuk Dubak', 'Вук Дубак', 'Вук Дубак', 'Vuk Dubak', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vuk-dubak' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Marija Đorđević — general_medicine. post 2025-09-05 «medicinski tim ZS Plužine na čelu sa dr Marijom Đorđević»
SET @d = (SELECT id FROM doctors WHERE slug = 'marija-djordjevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marija Đorđević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Đorđević Marija' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marija-djordjevic', 'Marija Đorđević', 'Марија Ђорђевић', 'Мария Джорджевич', 'Marija Djordjevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marija-djordjevic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Zdravstvena stanica Plužine' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Mirjana Brajičić — general_medicine. Dopunski rad apr+jun 2026: «Dr Mirjana Brajičić, Doktor medicine»
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-brajicic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mirjana Brajičić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Brajičić Mirjana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirjana-brajicic', 'Mirjana Brajičić', 'Мирјана Брајичић', 'Мирьяна Брайичич', 'Mirjana Brajicic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mirjana-brajicic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('general_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, NULL FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Mirjana Šljivančanin — pediatrics. /izabrani-doktor-za-djecu/ #1; raspored ID djeca 05–09.10.2026
SET @d = (SELECT id FROM doctors WHERE slug = 'mirjana-sljivancanin' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mirjana Šljivančanin' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Šljivančanin Mirjana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mirjana-sljivancanin', 'Mirjana Šljivančanin', 'Мирјана Шљиванчанин', 'Мирьяна Шливанчанин', 'Mirjana Sljivancanin', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mirjana-sljivancanin' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Snježana Dašić — pediatrics. /izabrani-doktor-za-djecu/ #2; /centri-za-podrsku/ «specijalista pedijatar»
SET @d = (SELECT id FROM doctors WHERE slug = 'snjezana-dasic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Snježana Dašić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dašić Snježana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'snjezana-dasic', 'Snježana Dašić', 'Сњежана Дашић', 'Снежана Дашич', 'Snjezana Dasic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'snjezana-dasic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu; Centar za djecu sa posebnim potrebama' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Tijana Jovanović — существует в БД (jovanovic-tijana), только привязка. /izabrani-doktor-za-djecu/ #3; /centri-za-podrsku/
SET @d = (SELECT id FROM doctors WHERE slug = 'jovanovic-tijana' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu; Centar za djecu sa posebnim potrebama' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Biljana Vučić — pediatrics. /izabrani-doktor-za-djecu/ #4; /centri-za-podrsku/
SET @d = (SELECT id FROM doctors WHERE slug = 'biljana-vucic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Biljana Vučić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vučić Biljana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'biljana-vucic', 'Biljana Vučić', 'Биљана Вучић', 'Биляна Вучич', 'Biljana Vucic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'biljana-vucic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu; Centar za djecu sa posebnim potrebama' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Zorica Mušikić — pediatrics. /izabrani-doktor-za-djecu/ #5
SET @d = (SELECT id FROM doctors WHERE slug = 'zorica-musikic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Zorica Mušikić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mušikić Zorica' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zorica-musikic', 'Zorica Mušikić', 'Зорица Мушикић', 'Зорица Мушикич', 'Zorica Musikic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zorica-musikic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Marta Kontić — pediatrics. raspored-ID-za-djecu-5-oktobar.pdf (05–09.10.2026): «Dr Marta Kontić» u koloni IZABRANI DR ZA DJECU
SET @d = (SELECT id FROM doctors WHERE slug = 'marta-kontic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marta Kontić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kontić Marta' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'marta-kontic', 'Marta Kontić', 'Марта Контић', 'Марта Контич', 'Marta Kontic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'marta-kontic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pediatrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Stanislava Višnjić — существует в БД (visnjic-stanislava), только привязка. /izabrani-doktor-za-djecu/ #7
SET @d = (SELECT id FROM doctors WHERE slug = 'visnjic-stanislava' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Tamara Mijušković — gynecology_obstetrics. /izabrani-doktor-za-zene/ #1
SET @d = (SELECT id FROM doctors WHERE slug = 'tamara-mijuskovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Tamara Mijušković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Mijušković Tamara' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'tamara-mijuskovic', 'Tamara Mijušković', 'Тамара Мијушковић', 'Тамара Миюшкович', 'Tamara Mijuskovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'tamara-mijuskovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Dragoljub Raičević — существует в БД (raicevic-dragoljub), только привязка. /izabrani-doktor-za-zene/ #2
SET @d = (SELECT id FROM doctors WHERE slug = 'raicevic-dragoljub' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Milica Glušac — существует в БД (glusac-milica), только привязка. Dopunski rad apr+jun 2026: «Spec.ginekologije i akušerstva»; post 2026-02-04 «četiri ljekara specijalista ginekologije»
SET @d = (SELECT id FROM doctors WHERE slug = 'glusac-milica' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Adrijana Stanović Varajić — gynecology_obstetrics. Dopunski rad jun 2026: «Spec.ginekologije i akušerstva»; post 2026-02-04 «četiri ljekara specijalista ginekologije»
SET @d = (SELECT id FROM doctors WHERE slug = 'adrijana-stanovic-varajic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Adrijana Stanović Varajić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Stanović Varajić Adrijana' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'adrijana-stanovic-varajic', 'Adrijana Stanović Varajić', 'Адријана Становић Варајић', 'Адриана Станович Вараич', 'Adrijana Stanovic Varajic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'adrijana-stanovic-varajic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('gynecology_obstetrics') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Vesna Marojević — pulmonology. /centri-za-podrsku/ «2 doktora – spec. pneumoftiziologa, 1 doktor spec. interne medicine»; Utješinović — pneumoftiziolog, Račić — internista-pulmolog (Dopunski rad) ⇒ Marojević pneumoftiziolog
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-marojevic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vesna Marojević' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Marojević Vesna' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-marojevic', 'Vesna Marojević', 'Весна Маројевић', 'Весна Мароевич', 'Vesna Marojevic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-marojevic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('pulmonology') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Jovan Utješinović — существует в БД (utjesinovic-jovan), только привязка. /centri-za-podrsku/; Dopunski rad apr 2026: «Spec.pneumoziolog», Codra i Moj Lab — kao u BP
SET @d = (SELECT id FROM doctors WHERE slug = 'utjesinovic-jovan' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Milan Račić — internal_medicine, pulmonology. /centri-za-podrsku/; Dopunski rad jun 2026: «spec.inter. medicine-pulmolog»
SET @d = (SELECT id FROM doctors WHERE slug = 'milan-racic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milan Račić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Račić Milan' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milan-racic', 'Milan Račić', 'Милан Рачић', 'Милан Рачич', 'Milan Racic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milan-racic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('internal_medicine', 'pulmonology') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Nikolina Račić — microbiology. /centri-za-podrsku/ «2 doktora spec. mikrobiologa»
SET @d = (SELECT id FROM doctors WHERE slug = 'nikolina-racic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Nikolina Račić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Račić Nikolina' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nikolina-racic', 'Nikolina Račić', 'Николина Рачић', 'Николина Рачич', 'Nikolina Racic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nikolina-racic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('microbiology') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za dijagnostiku — mikrobiološka laboratorija' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Milica Kankaraš — microbiology. /centri-za-podrsku/; Dopunski rad jun 2026: «Spec.mikrobiologije»
SET @d = (SELECT id FROM doctors WHERE slug = 'milica-kankaras' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milica Kankaraš' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Kankaraš Milica' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'milica-kankaras', 'Milica Kankaraš', 'Милица Канкараш', 'Милица Канкараш', 'Milica Kankaras', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'milica-kankaras' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('microbiology') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za dijagnostiku — mikrobiološka laboratorija' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Vesna Svorcan Joksimović — psychiatry. /centri-za-podrsku/ «dr Vesna Joksimović – doktor specijalista»; Dopunski rad jun 2026: «Dr Vesna Svorcan Joksimović, Spec.psihijatar»
SET @d = (SELECT id FROM doctors WHERE slug = 'vesna-svorcan-joksimovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Vesna Svorcan Joksimović' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Svorcan Joksimović Vesna' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-joksimovic' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'joksimovic-vesna' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vesna-svorcan-joksimovic', 'Vesna Svorcan Joksimović', 'Весна Сворцан Јоксимовић', 'Весна Сворцан Йоксимович', 'Vesna Svorcan Joksimovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vesna-svorcan-joksimovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Dragica Minić — psychiatry, neurology. /centri-za-podrsku/; Dopunski rad jun 2026: «Spec.neuropsihijatar»
SET @d = (SELECT id FROM doctors WHERE slug = 'dragica-minic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Dragica Minić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Minić Dragica' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dragica-minic', 'Dragica Minić', 'Драгица Минић', 'Драгица Минич', 'Dragica Minic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dragica-minic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('psychiatry', 'neurology') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Jelica Živković — существует в БД (jelica-zivkovic), только привязка. /centri-za-podrsku/; Dopunski rad jun 2026: «Spec.psihijatrije i sud.psihijatrije», Cenex medical Podgorica — kao u BP
SET @d = (SELECT id FROM doctors WHERE slug = 'jelica-zivkovic' LIMIT 1);
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ivona Drašković — infectious_diseases. /centri-za-podrsku/; Dopunski rad jun 2026: «Specijalista epidemiologije»
SET @d = (SELECT id FROM doctors WHERE slug = 'ivona-draskovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ivona Drašković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Drašković Ivona' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ivona-draskovic', 'Ivona Drašković', 'Ивона Драшковић', 'Ивона Драшкович', 'Ivona Draskovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ivona-draskovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('infectious_diseases') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Higijensko-epidemiološka služba' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Redžeb Zeinalagić — infectious_diseases. /centri-za-podrsku/
SET @d = (SELECT id FROM doctors WHERE slug = 'redzeb-zeinalagic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Redžeb Zeinalagić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Zeinalagić Redžeb' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'redzeb-zeinalagic', 'Redžeb Zeinalagić', 'Реџеб Зеиналагић', 'Реджеб Зейналагич', 'Redzeb Zeinalagic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'redzeb-zeinalagic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('infectious_diseases') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Higijensko-epidemiološka služba' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Branka Eraković — infectious_diseases. /centri-za-podrsku/
SET @d = (SELECT id FROM doctors WHERE slug = 'branka-erakovic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Branka Eraković' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Eraković Branka' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'branka-erakovic', 'Branka Eraković', 'Бранка Ераковић', 'Бранка Эракович', 'Branka Erakovic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'branka-erakovic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('infectious_diseases') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Higijensko-epidemiološka služba' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- Ema Milić — occupational_medicine. /sluzba-medicine-rada-i-sporta…/ «Rukovodilac službe: dr Ema Milić»; «kojim koordinira specijalista medicine rada»
SET @d = (SELECT id FROM doctors WHERE slug = 'ema-milic' LIMIT 1);
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Ema Milić' LIMIT 1));
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE name_sr = 'Milić Ema' LIMIT 1));
SET @created = (@d IS NULL);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'ema-milic', 'Ema Milić', 'Ема Милић', 'Эма Милич', 'Ema Milic', 'dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'ema-milic' LIMIT 1));
-- Специальности и язык — только новой записи; у найденной поля не трогаем.
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name IN ('occupational_medicine') AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @created = 1 AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Rukovodilac Službe medicine rada i sporta' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT c.id, c.slug, c.city_id, c.google_place_id, c.status,
	(SELECT GROUP_CONCAT(clinic_type_id) FROM clinic_clinic_types WHERE clinic_id = c.id) AS types,
	(SELECT GROUP_CONCAT(language_id) FROM clinic_languages WHERE clinic_id = c.id) AS langs,
	(SELECT COUNT(*) FROM clinic_working_hours WHERE clinic_id = c.id) AS hours
FROM clinics c WHERE c.id = @clinic_id;

-- Ожидается 50 врачей (11 существующих + 39 новых).
SELECT COUNT(*) AS doctors_linked FROM doctor_clinics WHERE clinic_id = @clinic_id;

-- У каждого врача должна быть хотя бы одна специальность.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, dc.position,
	(SELECT GROUP_CONCAT(s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specs
FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @clinic_id ORDER BY dc.position, d.name_sr;

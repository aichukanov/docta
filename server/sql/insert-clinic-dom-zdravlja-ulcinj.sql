-- ═══════════════════════════════════════════════════════════════════════════
-- Dom zdravlja Ulcinj (JZU Dom zdravlja „Bogdan Vujošević“) — клиника + врачи
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dom-zdravlja-ulcinj.sql
-- Затем: server/sql/insert-clinic-dom-zdravlja-ulcinj-services.sql
--
-- Источники (собрано 2026-10-08):
--   * https://domzdravljaulcinj.me/ — WordPress (Avada), wp-json /wp/v2/pages (26 страниц) и
--     /wp/v2/posts (337 записей). Страницы врачей: /izabrani-doktori-za-odrasle/ (modified
--     2025-05-16), /izabrani-doktori-za-djecu/ (2025-05-16), /izabrani-doktori-za-zene/ (2026-01-29),
--     /doktori-na-specijalizaciji/ (2025-05-16), /centar-za-prevenciju/ (2022-08-17),
--     /centar-za-plucne-bolesti-i-tbc/ (2022-08-17), /centar-za-dijagnostiku/ (2025-02-07),
--     /centar-za-mentalno-zdravlje/ (2025-02-07), /direktor/ (2025-03-24), /kontakt/ (2025-05-21).
--   * Еженедельные «Raspored rada ljekara» 28.09.–04.10.2026 и 05.10.–11.10.2026 (PDF из Word,
--     текстовый слой): Opšta medicina, Pedijatrija, Ginekologija — самый свежий состав;
--     «RASPORED RADA SPECIALISTA» (/2025/10/, прикреплён к тем же постам октября 2026).
--   * data/google-places/ulcinj/health-center-ulcinj.json — place_id, координаты, адрес, телефон.
--     Место «Maternity hospital Ulcinj» (ChIJZw4EDmQTThMR505Lnn-T_fE) — porodilište этого же ДЗ,
--     отдельной клиникой не заводится.
--
-- Сверка фактов:
--   * Адрес: сайт не называет; Google «W6H9+HMF, Boška Strugara, Ulcinj 85360».
--   * Телефоны: Google +382 30 412 433; сайт — Opšta medicina +38267-147-320, Pedijatrija
--     +38267-147-319, Izabrani doktori za žene +382 67-016-493 (главная и страница IDŽ).
--     Номер +38267-237-444 главная подписывает и «Izabrani doktori za žene», и (/kontakt/)
--     «Porodilište» — он же у места Google роддома; в карточку не взят.
--   * Email: /direktor/ «policlinicul@t-com.me» (служебный ящик ДЗ; личный hotmail директора
--     не взят). Соцсетей на сайте нет.
--   * Часы: см. PART 2.
--   * Тип: POLYCLINIC (1), как у всех ДЗ. Языки: только SR.
--   * Взлома сайта (скрытые блоки казино и т. п.) нет.
--
-- Врачи (26): состав по графикам сентября–октября 2026 + страницы центров. Новых 25,
-- найден в БД 1 (Gordana Jelušić). Не заводятся: 9 специализантов (/doktori-na-specijalizaciji/;
-- Sellaj и Salaj есть и в графиках, но без смен), Hysni Myrteza и Sabrije Taipi (на странице IDO
-- 2025-05, в графиках 2026 нет), координаторы савjetovališta со страницы 2022 года, которых нет
-- ни в одном свежем источнике (Adem Mustafa, Olivera Poček, Pavle Marinković, Srećko Hajduković,
-- Milan Rolović), логопед и психолог (не врачи), медсёстры и менеджмент. Подробно — в записи импорта.
--
-- Идемпотентно и самоисправляюще: повторный прогон не плодит дублей; описания пишутся
-- безусловным UPDATE (правки из админки следующий прогон перезатрёт — вносить сюда), языки
-- клиники синхронизируются, position привязки к этой клинике обновляется.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: CLINIC
-- ═══════════════════════════════════════════════════════════════

SET @google_place_id = 'ChIJkVrkFGQTThMRiBnsu9NYcLM';
SET @clinic_slug = 'dom-zdravlja-ulcinj';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = @clinic_slug LIMIT 1));

INSERT INTO clinics (
	slug, google_place_id, status, city_id, name_sr, name_sr_cyrl, name_ru, address_sr, address_sr_cyrl, town_sr, town_sr_cyrl, postal_code, latitude, longitude, phone, email, website, doctor_schedule_url, facebook, instagram, telegram, whatsapp, viber, logo_url, created_at
)
SELECT
	@clinic_slug,
	@google_place_id,
	'published',
	5, -- CityId.ULCINJ
	'Dom zdravlja Ulcinj',
	'Дом здравља Улцињ',
	'Дом здоровья Ульцинь',
	'Boška Strugara',
	'Бошка Стругара',
	'',
	'',
	'85360',
	41.92894080,
	19.21917670,
	'+38230412433;+38267147320;+38267147319;+38267016493',
	'policlinicul@t-com.me',
	'https://domzdravljaulcinj.me/',
	'https://domzdravljaulcinj.me/category/obavjestenja/raspored-radnog-vremena-lijekara/',
	'',
	'',
	'',
	'',
	'',
	'https://domzdravljaulcinj.me/wp-content/uploads/2022/08/logo-domzdravlja-ulcinj.png',
	NOW()
FROM dual WHERE @clinic_id IS NULL;

SET @clinic_id = COALESCE(@clinic_id, LAST_INSERT_ID());

-- Дозаполнение пустых полей уже существующей записи; непустые и status не трогаем.
UPDATE clinics SET
	google_place_id = COALESCE(google_place_id, @google_place_id),
	name_sr_cyrl = IF(name_sr_cyrl IS NULL OR name_sr_cyrl = '', 'Дом здравља Улцињ', name_sr_cyrl),
	name_ru = IF(name_ru IS NULL OR name_ru = '', 'Дом здоровья Ульцинь', name_ru),
	address_sr = IF(address_sr IS NULL OR address_sr = '', 'Boška Strugara', address_sr),
	address_sr_cyrl = IF(address_sr_cyrl IS NULL OR address_sr_cyrl = '', 'Бошка Стругара', address_sr_cyrl),
	postal_code = IF(postal_code IS NULL OR postal_code = '', '85360', postal_code),
	phone = IF(phone IS NULL OR phone = '', '+38230412433;+38267147320;+38267147319;+38267016493', phone),
	email = IF(email IS NULL OR email = '', 'policlinicul@t-com.me', email),
	website = IF(website IS NULL OR website = '', 'https://domzdravljaulcinj.me/', website),
	doctor_schedule_url = IF(doctor_schedule_url IS NULL OR doctor_schedule_url = '', 'https://domzdravljaulcinj.me/category/obavjestenja/raspored-radnog-vremena-lijekara/', doctor_schedule_url),
	logo_url = IF(logo_url IS NULL OR logo_url = '', 'https://domzdravljaulcinj.me/wp-content/uploads/2022/08/logo-domzdravlja-ulcinj.png', logo_url),
	latitude = COALESCE(latitude, 41.92894080),
	longitude = COALESCE(longitude, 19.21917670)
WHERE id = @clinic_id;

-- Описания — безусловная перезапись. Только то, что ДЗ пишет о себе: /o-nama/ (2022), главная
-- (2026-01), /izabrani-doktor/, страницы центров, /medicina-rada/, /kontakt/, еженедельные
-- «Raspored rada ljekara» (сентябрь–октябрь 2026) и «Raspored rada specijalista» (2025-10).
-- Численность и кадровые жалобы со страницы «O nama» (2017) не переносятся — устарели.
UPDATE clinics SET
	description_sr = 'Dom zdravlja Ulcinj (JZU Dom zdravlja „Bogdan Vujošević“) je ustanova primarne zdravstvene zaštite u Ulcinju. Izabrani doktori za odrasle, za djecu i za žene rade u dvije smjene, od 07 do 21 čas, a vikendom radi dežurni ljekar; izabrani doktor za odrasle radi i u Zdravstvenoj stanici Vladimir. Izabranom timu podršku pružaju Centar za prevenciju (savjetovališta za mlade, za dijabetes i za reproduktivno zdravlje, sa programom „Škola za trudnice“), Centar za plućne bolesti i TBC, Centar za dijagnostiku (mikrobiološka laboratorija, koja izdaje i sanitarne knjižice) i Centar za mentalno zdravlje. Specijalisti interne medicine, psihijatrije, radiologije i oftalmologije rade radnim danima od 07 do 15 časova, uz higijensko-epidemiološku službu, logopeda, psihologa i biohemijsku laboratoriju. Služba medicine rada izdaje ljekarska uvjerenja o sposobnosti za rad, za vozače, voditelje čamca, pomorce i nošenje oružja. Dom zdravlja pruža i stacionarnu zaštitu iz ginekologije i akušerstva — u sastavu radi porodilište. Raspored rada ljekara objavljuje se sedmično na sajtu.',
	description_sr_cyrl = 'Дом здравља Улцињ (ЈЗУ Дом здравља „Богдан Вујошевић“) је установа примарне здравствене заштите у Улцињу. Изабрани доктори за одрасле, за дјецу и за жене раде у двије смјене, од 07 до 21 час, а викендом ради дежурни љекар; изабрани доктор за одрасле ради и у Здравственој станици Владимир. Изабраном тиму подршку пружају Центар за превенцију (савјетовалишта за младе, за дијабетес и за репродуктивно здравље, са програмом „Школа за труднице“), Центар за плућне болести и TBC, Центар за дијагностику (микробиолошка лабораторија, која издаје и санитарне књижице) и Центар за ментално здравље. Специјалисти интерне медицине, психијатрије, радиологије и офталмологије раде радним данима од 07 до 15 часова, уз хигијенско-епидемиолошку службу, логопеда, психолога и биохемијску лабораторију. Служба медицине рада издаје љекарска увјерења о способности за рад, за возаче, водитеље чамца, поморце и ношење оружја. Дом здравља пружа и стационарну заштиту из гинекологије и акушерства — у саставу ради породилиште. Распоред рада љекара објављује се седмично на сајту.',
	description_ru = 'Дом здоровья Ульцинь (JZU Dom zdravlja «Bogdan Vujošević») — учреждение первичной медицинской помощи в Ульцине. Выбранные врачи для взрослых, детей и женщин принимают в две смены, с 7 до 21 часа, в выходные работает дежурный врач; выбранный врач для взрослых принимает и в медпункте Владимир (Zdravstvena stanica Vladimir). Работу выбранных врачей поддерживают Центр профилактики (консультации для молодёжи, по диабету и по репродуктивному здоровью, с программой «Школа для беременных»), Центр лёгочных болезней и туберкулёза, Диагностический центр (микробиологическая лаборатория, которая также оформляет санитарные книжки) и Центр психического здоровья. Терапевт-интернист, психиатр, рентгенолог и офтальмолог принимают по будним дням с 7 до 15 часов; есть также гигиено-эпидемиологическая служба, логопед, психолог и биохимическая лаборатория. Служба медицины труда выдаёт медицинские справки о профпригодности, для водителей, судоводителей, моряков и для владения оружием. Дом здоровья оказывает и стационарную помощь по гинекологии и акушерству — в его составе работает родильное отделение. График приёма врачей публикуется на сайте еженедельно.',
	description_en = 'Dom zdravlja Ulcinj (JZU Dom zdravlja "Bogdan Vujošević") is the primary health care centre in Ulcinj. The chosen doctors for adults, children and women work in two shifts from 7 am to 9 pm, with a doctor on duty at weekends; a chosen doctor for adults also works at the Vladimir health station. They are supported by the Prevention Centre (counselling for young people, for diabetes and for reproductive health, including a "School for pregnant women" programme), the Centre for Lung Diseases and TB, the Diagnostic Centre (a microbiology laboratory that also issues sanitary booklets) and the Mental Health Centre. Specialists in internal medicine, psychiatry, radiology and ophthalmology see patients on weekdays from 7 am to 3 pm, alongside the hygiene and epidemiology service, a speech therapist, a psychologist and a biochemistry laboratory. The occupational medicine service issues medical certificates of fitness for work and for drivers, boat operators, seafarers and firearms holders. The centre also provides inpatient gynaecology and obstetrics care and has a maternity ward. The doctors'' schedule is published weekly on the website.',
	description_de = 'Dom zdravlja Ulcinj (JZU Dom zdravlja „Bogdan Vujošević“) ist das Zentrum der primären Gesundheitsversorgung in Ulcinj. Die gewählten Ärzte für Erwachsene, Kinder und Frauen arbeiten in zwei Schichten von 7 bis 21 Uhr, am Wochenende gibt es einen diensthabenden Arzt; ein gewählter Arzt für Erwachsene praktiziert auch in der Gesundheitsstation Vladimir. Unterstützt werden sie vom Zentrum für Prävention (Beratungsstellen für Jugendliche, für Diabetes und für reproduktive Gesundheit mit dem Programm „Schule für Schwangere“), dem Zentrum für Lungenkrankheiten und Tuberkulose, dem Diagnostikzentrum (ein mikrobiologisches Labor, das auch Gesundheitsbücher für den Hygienenachweis ausstellt) und dem Zentrum für psychische Gesundheit. Fachärzte für Innere Medizin, Psychiatrie, Radiologie und Augenheilkunde behandeln werktags von 7 bis 15 Uhr; außerdem gibt es den hygienisch-epidemiologischen Dienst, Logopädie, Psychologie und ein biochemisches Labor. Der arbeitsmedizinische Dienst stellt ärztliche Bescheinigungen über die Arbeitsfähigkeit sowie für Fahrer, Bootsführer, Seeleute und Waffenbesitzer aus. Das Gesundheitszentrum bietet auch stationäre Versorgung in Gynäkologie und Geburtshilfe – dazu gehört eine Entbindungsstation. Der Dienstplan der Ärzte wird wöchentlich auf der Website veröffentlicht.',
	description_tr = 'Dom zdravlja Ulcinj (JZU Dom zdravlja "Bogdan Vujošević"), Ulcinj''deki birinci basamak sağlık kuruluşudur. Yetişkinler, çocuklar ve kadınlar için seçilmiş hekimler 07.00–21.00 saatleri arasında iki vardiya halinde çalışır, hafta sonu nöbetçi hekim bulunur; yetişkinler için seçilmiş hekim Vladimir sağlık istasyonunda da hasta kabul eder. Seçilmiş hekimlere Önleme Merkezi (gençler, diyabet ve üreme sağlığı danışmanlıkları ile "Gebe Okulu" programı), Akciğer Hastalıkları ve Tüberküloz Merkezi, Tanı Merkezi (sağlık karnesi de düzenleyen mikrobiyoloji laboratuvarı) ve Ruh Sağlığı Merkezi destek verir. Dahiliye, psikiyatri, radyoloji ve göz hastalıkları uzmanları hafta içi 07.00–15.00 saatleri arasında hasta kabul eder; ayrıca hijyen ve epidemiyoloji servisi, dil ve konuşma terapisi, psikolog ve biyokimya laboratuvarı bulunur. İş sağlığı servisi işe uygunluk ile sürücüler, tekne kullananlar, denizciler ve silah ruhsatı için sağlık raporları düzenler. Sağlık merkezi kadın hastalıkları ve doğum alanında yatarak tedavi de sunar; bünyesinde doğumhane bulunur. Hekimlerin çalışma çizelgesi her hafta web sitesinde yayımlanır.'
WHERE id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: TYPES, LANGUAGES, WORKING HOURS
-- ═══════════════════════════════════════════════════════════════

-- ClinicType.POLYCLINIC = 1 (как у всех ДЗ в БД)
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id) VALUES (@clinic_id, 1);

-- Языки клиники: только SR. Сайт двуязычный (me + sq), графики врачей — на черногорском и
-- албанском, но приём на албанском прямо не заявлен; албанского в справочнике languages нет.
-- clinic_languages без составного UNIQUE: синхронизация вместо INSERT IGNORE.
SET @keep_lang_id = (SELECT MIN(id) FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);
DELETE FROM clinic_languages WHERE clinic_id = @clinic_id AND (language_id <> 1 OR id <> @keep_lang_id);
INSERT INTO clinic_languages (clinic_id, language_id)
SELECT @clinic_id, 1 FROM dual
WHERE NOT EXISTS (SELECT 1 FROM clinic_languages WHERE clinic_id = @clinic_id AND language_id = 1);

-- Часы: главная «Izabrani doktori … Radno vrijeme: od 07h-21h»; «Raspored rada ljekara 05.10.–11.10.2026»:
-- subota «Dežurni ljekar 07:00 – 21:00», nedjelja «Dežurni ljekar 07:00 – 14:00».
INSERT INTO clinic_working_hours (clinic_id, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
VALUES (
	@clinic_id,
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "21:00"}]}',
	'{"type": "regular", "intervals": [{"start": "07:00", "end": "14:00"}]}'
)
ON DUPLICATE KEY UPDATE
	monday = VALUES(monday), tuesday = VALUES(tuesday), wednesday = VALUES(wednesday),
	thursday = VALUES(thursday), friday = VALUES(friday), saturday = VALUES(saturday),
	sunday = VALUES(sunday);

-- ═══════════════════════════════════════════════════════════════
-- PART 3: DOCTORS
-- Существующие — только привязка; новые — «найти или создать» по slug.
-- Специальности: izabrani doktor za odrasle → general_medicine, za djecu → pediatrics,
-- za žene → gynecology_obstetrics, эпидемиолог → infectious_diseases (правила ДЗ).
-- photo_url: только у директора (портрет со страницы /direktor/); на страницах IDO — стоковые.
-- ═══════════════════════════════════════════════════════════════

-- ── 3.1 Уже в БД — только привязка (1) ──

-- Gordana Jelušić — /centar-za-dijagnostiku/ (2025-02) «Koordinatori: Dr Gordana Jelušić» (mikrobiološka laboratorija). В БД — microbiology, Moj Lab Laboratorija Podgorica (Moskovska), «Načelnica Mikrobiološke laboratorije»: полная тёзка с той же специальностью → только привязка
SET @d = (SELECT id FROM doctors WHERE slug = 'gordana-jelusic' LIMIT 1);
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za dijagnostiku – mikrobiološka dijagnostika' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ── 3.2 Новые (25) ──

-- Kreshnik Mustafa — /direktor/ «Dr. KRESHNIK MUSTAFA» (фото оттуда), RASPORED RADA SPECIJALISTA «Dr spec. Kreshnik Mustafa - Epidemiolog», пост «Pripravnost HES» 2025 «dr Kreshnik Mustafa specijalista epidemiologije», эпидемиолог → infectious_diseases (правило ДЗ)
SET @d = (SELECT id FROM doctors WHERE slug = 'kreshnik-mustafa' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'kreshnik-mustafa', 'Kreshnik Mustafa', 'Крешник Мустафа', 'Крешник Мустафа', 'Kreshnik Mustafa', 'Dr', 'https://domzdravljaulcinj.me/wp-content/uploads/2025/03/dr-Kreshnik-scaled.jpg', NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'kreshnik-mustafa' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'infectious_diseases' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Direktor; specijalista epidemiologije, Higijensko-epidemiološka služba' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Jasmin Hodžić — IDO (/izabrani-doktori-za-odrasle/) + графики 28.09 и 05.10.2026 «Dr spec. Hodžić Jasmin» (специальность не названа)
SET @d = (SELECT id FROM doctors WHERE slug = 'jasmin-hodzic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'jasmin-hodzic', 'Jasmin Hodžić', 'Јасмин Хоџић', 'Ясмин Ходжич', 'Jasmin Hodzic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'jasmin-hodzic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Mahbub Ljamović — IDO + графики («Dr Ljamović Mahbub», 28.09 — опечатка «Lamović»)
SET @d = (SELECT id FROM doctors WHERE slug = 'mahbub-ljamovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mahbub-ljamovic', 'Mahbub Ljamović', 'Махбуб Љамовић', 'Махбуб Лямович', 'Mahbub Ljamovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mahbub-ljamovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Iva Hajduković — IDO + графики
SET @d = (SELECT id FROM doctors WHERE slug = 'iva-hajdukovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'iva-hajdukovic', 'Iva Hajduković', 'Ива Хајдуковић', 'Ива Хайдукович', 'Iva Hajdukovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'iva-hajdukovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Teuta Đečbitrić — IDO + графики
SET @d = (SELECT id FROM doctors WHERE slug = 'teuta-djecbitric' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'teuta-djecbitric', 'Teuta Đečbitrić', 'Теута Ђечбитрић', 'Теута Джечбитрич', 'Teuta Djecbitric', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'teuta-djecbitric' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Blendi Çapriqi — графики 28.09 и 05.10.2026 «Dr Çapriqi Blendi» (на странице IDO 2025-05 его ещё нет), slug вручную: generateSlug выбросил бы «ç»
SET @d = (SELECT id FROM doctors WHERE slug = 'blendi-capriqi' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'blendi-capriqi', 'Blendi Çapriqi', 'Бленди Чаприћи', 'Бленди Чапричи', 'Blendi Capriqi', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'blendi-capriqi' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Majlinda Đenašević-Maraj — IDO «Dr Majlinda Đenašević – Maraj» + график 05.10.2026
SET @d = (SELECT id FROM doctors WHERE slug = 'majlinda-djenasevic-maraj' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'majlinda-djenasevic-maraj', 'Majlinda Đenašević-Maraj', 'Мајлинда Ђенашевић-Марај', 'Майлинда Дженашевич-Марай', 'Majlinda Djenasevic-Maraj', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'majlinda-djenasevic-maraj' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Maida Gjoni — IDO + графики «Dr Gjoni Maida»
SET @d = (SELECT id FROM doctors WHERE slug = 'maida-gjoni' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'maida-gjoni', 'Maida Gjoni', 'Маида Ђони', 'Маида Джони', 'Maida Gjoni', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'maida-gjoni' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Rialda Resulbegović — графики 28.09 и 05.10.2026 «Dr Resulbegović Rialda»
SET @d = (SELECT id FROM doctors WHERE slug = 'rialda-resulbegovic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'rialda-resulbegovic', 'Rialda Resulbegović', 'Риалда Ресулбеговић', 'Риалда Ресулбегович', 'Rialda Resulbegovic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'rialda-resulbegovic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sanela Abazović-Hot — график 28.09–04.10.2026 «Dr Sanela Abazović-Hot» (в графике 05.10 на её месте Majlinda Đenašević-Maraj)
SET @d = (SELECT id FROM doctors WHERE slug = 'sanela-abazovic-hot' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sanela-abazovic-hot', 'Sanela Abazović-Hot', 'Санела Абазовић-Хот', 'Санела Абазович-Хот', 'Sanela Abazovic-Hot', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sanela-abazovic-hot' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Dorijana Mećikukić — графики, блок «ID za odrasle zdravstvena ustanova Vladimir»
SET @d = (SELECT id FROM doctors WHERE slug = 'dorijana-mecikukic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'dorijana-mecikukic', 'Dorijana Mećikukić', 'Доријана Мећикукић', 'Дорияна Мечикукич', 'Dorijana Mecikukic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'dorijana-mecikukic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ZS Vladimir' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Mevluda Đenčić — IDO + графики, блок ZS Vladimir
SET @d = (SELECT id FROM doctors WHERE slug = 'mevluda-djencic' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mevluda-djencic', 'Mevluda Đenčić', 'Мевлуда Ђенчић', 'Мевлуда Дженчич', 'Mevluda Djencic', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mevluda-djencic' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'general_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za odrasle, ZS Vladimir' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Isat Jakupi — RASPORED RADA SPECIJALISTA «Dr spec. Isat Jakupi – Internista», на странице IDO (2025-05) ещё числится izabranim doktorom, в графиках IDO 2026 его нет
SET @d = (SELECT id FROM doctors WHERE slug = 'isat-jakupi' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'isat-jakupi', 'Isat Jakupi', 'Исат Јакупи', 'Исат Якупи', 'Isat Jakupi', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'isat-jakupi' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'internal_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Internista' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Teuta Leskovac — RASPORED RADA SPECIJALISTA «Dr spec. Teuta Leskovac – Internista»
SET @d = (SELECT id FROM doctors WHERE slug = 'teuta-leskovac' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'teuta-leskovac', 'Teuta Leskovac', 'Теута Лесковац', 'Теута Лесковац', 'Teuta Leskovac', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'teuta-leskovac' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'internal_medicine' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Internista' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Vlora Duraku-Kurti — /izabrani-doktori-za-djecu/ «Dr Vlora Kurti», графики «Dr spec. Duraku-Kurti Vlora» — имя по графику (полная фамилия)
SET @d = (SELECT id FROM doctors WHERE slug = 'vlora-duraku-kurti' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'vlora-duraku-kurti', 'Vlora Duraku-Kurti', 'Влора Дураку-Курти', 'Влора Дураку-Курти', 'Vlora Duraku-Kurti', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'vlora-duraku-kurti' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sabaheta Čapuni-Paračka — графики, Pedijatrija «Dr spec. Čapuni-Paračka Sabaheta»
SET @d = (SELECT id FROM doctors WHERE slug = 'sabaheta-capuni-paracka' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sabaheta-capuni-paracka', 'Sabaheta Čapuni-Paračka', 'Сабахета Чапуни-Парачка', 'Сабахета Чапуни-Парачка', 'Sabaheta Capuni-Paracka', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sabaheta-capuni-paracka' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Mohamed Yahia Mouhsen — графики, Pedijatrija «Dr spec. Mohamed Yahia Mouhsen, spec pediatrije – sub spec neonatolog», порядок слов имени — как в графике
SET @d = (SELECT id FROM doctors WHERE slug = 'mohamed-yahia-mouhsen' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'mohamed-yahia-mouhsen', 'Mohamed Yahia Mouhsen', 'Мохамед Јахија Моухсен', 'Мохамед Яхья Моухсен', 'Mohamed Yahia Mouhsen', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'mohamed-yahia-mouhsen' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pediatrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'neonatology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za djecu; spec. pedijatrije – subspec. neonatolog' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Teuta Hodža — /izabrani-doktori-za-zene/ (2026-01) «Dr Teuta Hodža», графики «Dr spec. Hoxha Teuta»
SET @d = (SELECT id FROM doctors WHERE slug = 'teuta-hodza' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'teuta-hodza', 'Teuta Hodža', 'Теута Хоџа', 'Теута Ходжа', 'Teuta Hodza', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'teuta-hodza' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Zulfije Duraku — /centar-za-prevenciju/ «Dr Zulfije Duraku» (savjetovalište za reproduktivno zdravlje), график 05.10.2026, Ginekologija «Dr spec. Duraku Zylfije»
SET @d = (SELECT id FROM doctors WHERE slug = 'zulfije-duraku' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'zulfije-duraku', 'Zulfije Duraku', 'Зулфије Дураку', 'Зульфие Дураку', 'Zulfije Duraku', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'zulfije-duraku' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Sadije Holaj — /izabrani-doktori-za-zene/ «Dr Sadije Holaj», график 28.09.2026 «Dr spec. Hollaj Sadije»
SET @d = (SELECT id FROM doctors WHERE slug = 'sadije-holaj' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'sadije-holaj', 'Sadije Holaj', 'Садије Холај', 'Садие Холай', 'Sadije Holaj', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'sadije-holaj' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'gynecology_obstetrics' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Izabrani doktor za žene' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Basri Muja — /centar-za-mentalno-zdravlje/ «Dr Basri Muja (psihijatar)», RASPORED RADA SPECIJALISTA
SET @d = (SELECT id FROM doctors WHERE slug = 'basri-muja' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'basri-muja', 'Basri Muja', 'Басри Муја', 'Басри Муя', 'Basri Muja', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'basri-muja' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'psychiatry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Psihijatar, Centar za mentalno zdravlje' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Selim Ismaili — RASPORED RADA SPECIJALISTA «Dr spec. Selim Ismaili - Radiolog»
SET @d = (SELECT id FROM doctors WHERE slug = 'selim-ismaili' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'selim-ismaili', 'Selim Ismaili', 'Селим Исмаили', 'Селим Исмаили', 'Selim Ismaili', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'selim-ismaili' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'radiology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Radiolog' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Nita Hoxha — RASPORED RADA SPECIJALISTA «Dr spec. Nita Hoxha - Oftamolog», написание фамилии — как в источнике
SET @d = (SELECT id FROM doctors WHERE slug = 'nita-hoxha' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'nita-hoxha', 'Nita Hoxha', 'Нита Хоџа', 'Нита Ходжа', 'Nita Hoxha', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'nita-hoxha' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'ophthalmology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Oftalmolog' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Angelina Vračar — RASPORED RADA SPECIJALISTA «Biohemijska Laboratorija – Dr spec. Angelina Vračar» → clinical_biochemistry
SET @d = (SELECT id FROM doctors WHERE slug = 'angelina-vracar' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'angelina-vracar', 'Angelina Vračar', 'Ангелина Врачар', 'Ангелина Врачар', 'Angelina Vracar', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'angelina-vracar' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'clinical_biochemistry' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Biohemijska laboratorija' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- Redžep Kraja — /centar-za-plucne-bolesti-i-tbc/ (2022-08) «Koordinatori: Dr Redžep Kraja», специальность сайт не называет — по службе (pulmonology)
SET @d = (SELECT id FROM doctors WHERE slug = 'redzep-kraja' LIMIT 1);
INSERT INTO doctors (slug, name_sr, name_sr_cyrl, name_ru, name_en, professional_title, photo_url, created_at)
SELECT 'redzep-kraja', 'Redžep Kraja', 'Реџеп Краја', 'Реджеп Края', 'Redzep Kraja', 'Dr', NULL, NOW() FROM dual WHERE @d IS NULL;
SET @d = COALESCE(@d, (SELECT id FROM doctors WHERE slug = 'redzep-kraja' LIMIT 1));
INSERT IGNORE INTO doctor_specialties (doctor_id, specialty_id) SELECT @d, id FROM specialties WHERE name = 'pulmonology' AND @d IS NOT NULL;
INSERT IGNORE INTO doctor_languages (doctor_id, language_id) SELECT @d, id FROM languages WHERE code = 'sr' AND @d IS NOT NULL;
INSERT INTO doctor_clinics (doctor_id, clinic_id, position) SELECT @d, @clinic_id, 'Centar za plućne bolesti i TBC' FROM dual WHERE @d IS NOT NULL AND @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE position = VALUES(position);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: city_id = 5, status = published, languages = 1, types = 1, hours = 1.
SELECT c.id AS clinic_id, c.slug, c.name_sr, c.city_id, c.status, c.phone, c.google_place_id,
	GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id) AS clinic_languages,
	GROUP_CONCAT(DISTINCT cct.clinic_type_id ORDER BY cct.clinic_type_id) AS clinic_types,
	(SELECT COUNT(*) FROM clinic_working_hours w WHERE w.clinic_id = c.id) AS working_hours
FROM clinics c
LEFT JOIN clinic_languages cl ON cl.clinic_id = c.id
LEFT JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
WHERE c.id = @clinic_id
GROUP BY c.id;

-- Ожидается 26 врачей; у каждого есть специальность и язык sr.
SELECT d.id, d.slug, d.name_sr, d.name_sr_cyrl, dc.position,
	(SELECT GROUP_CONCAT(s.name) FROM doctor_specialties ds JOIN specialties s ON s.id = ds.specialty_id WHERE ds.doctor_id = d.id) AS specialties,
	(SELECT GROUP_CONCAT(l.code) FROM doctor_languages dl JOIN languages l ON l.id = dl.language_id WHERE dl.doctor_id = d.id) AS languages,
	(SELECT GROUP_CONCAT(c2.slug) FROM doctor_clinics dc2 JOIN clinics c2 ON c2.id = dc2.clinic_id WHERE dc2.doctor_id = d.id) AS clinics
FROM doctor_clinics dc JOIN doctors d ON d.id = dc.doctor_id
WHERE dc.clinic_id = @clinic_id
ORDER BY dc.position, d.name_sr;

-- Страховка: slug из этого файла, которых нет у клиники. Ожидается ПУСТО.
SELECT s.slug AS missing_doctor FROM (
	SELECT 'kreshnik-mustafa' AS slug
	UNION ALL SELECT 'jasmin-hodzic' AS slug
	UNION ALL SELECT 'mahbub-ljamovic' AS slug
	UNION ALL SELECT 'iva-hajdukovic' AS slug
	UNION ALL SELECT 'teuta-djecbitric' AS slug
	UNION ALL SELECT 'blendi-capriqi' AS slug
	UNION ALL SELECT 'majlinda-djenasevic-maraj' AS slug
	UNION ALL SELECT 'maida-gjoni' AS slug
	UNION ALL SELECT 'rialda-resulbegovic' AS slug
	UNION ALL SELECT 'sanela-abazovic-hot' AS slug
	UNION ALL SELECT 'dorijana-mecikukic' AS slug
	UNION ALL SELECT 'mevluda-djencic' AS slug
	UNION ALL SELECT 'isat-jakupi' AS slug
	UNION ALL SELECT 'teuta-leskovac' AS slug
	UNION ALL SELECT 'vlora-duraku-kurti' AS slug
	UNION ALL SELECT 'sabaheta-capuni-paracka' AS slug
	UNION ALL SELECT 'mohamed-yahia-mouhsen' AS slug
	UNION ALL SELECT 'teuta-hodza' AS slug
	UNION ALL SELECT 'zulfije-duraku' AS slug
	UNION ALL SELECT 'sadije-holaj' AS slug
	UNION ALL SELECT 'basri-muja' AS slug
	UNION ALL SELECT 'selim-ismaili' AS slug
	UNION ALL SELECT 'nita-hoxha' AS slug
	UNION ALL SELECT 'angelina-vracar' AS slug
	UNION ALL SELECT 'gordana-jelusic' AS slug
	UNION ALL SELECT 'redzep-kraja' AS slug
) s
LEFT JOIN doctors d ON d.slug = s.slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

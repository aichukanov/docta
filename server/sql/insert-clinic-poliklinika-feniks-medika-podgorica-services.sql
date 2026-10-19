-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Feniks Medika (Podgorica) — услуги, анализы, цены
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-feniks-medika-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-poliklinika-feniks-medika-podgorica.sql.
-- Клиника — по google_place_id/slug, услуги и анализы — по slug, литеральных id нет.
--
-- Источник цен: DOCX https://feniks-medika.me/wp-content/uploads/2023/03/CJENOVNIK-USLUGA-PZU-POLIKLINIKE-2022-2023.docx
-- («CJENOVNIK USLUGA PZU POLIKLINIKE “FENIKS MEDIKA”», подпись «Podgorica, 04.11.2022.godine»;
-- docProps created 2023-01-17, modified 2023-03-10; ссылка на странице /zakazivanje-pregleda/).
-- Прочитан как word/document.xml (zip), собрано 2026-10-08. ~300 строк, формат «40,00 eur»,
-- диапазон «30-100 eur» → price + price_max.
-- Без цены — только конкретные услуги со страниц сайта, которых нет в прайсе:
-- «RTG OBJE ŠAKE» (/radioloski-kabinet-u-podgorici/), «triple test» (/ginekologija/).
--
-- Правила сопоставления (подробно — data/clinic-imports/poliklinika-feniks-medika-podgorica.json):
--   * одна запись каталога на несколько строк прайса с разной ценой → price … price_max
--     (детский радиолог / общий радиолог / уролог для УЗИ; варианты анестезии; первичный /
--     контрольный приём в комбинациях пульмолога);
--   * «bris na bakterije i gljivice 15 eur» — одна цена на пару исследований: в каталоге
--     бактерии и грибы — разные записи, обеим поставлено 15;
--   * «+ ph nalaz 50,00 eur» — отдельные гистологические анализы (clinic_lab_tests);
--   * лаборатория (~130 строк) — clinic_lab_tests; «VAĐENJE KRVI» — услуга (процедура).
-- is_price_outdated не ставится (решение юзера 2026-10-08), хотя прайс от 2022 года.
--
-- Самоисправляющийся: канонические списки в TEMPORARY TABLE, цены пишутся
-- ON DUPLICATE KEY UPDATE, лишнее от прошлых прогонов удаляется. ⚠️ Услуги и анализы,
-- добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJGyTHrE7rTRMRgB1yl3q_vK8' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-feniks-medika-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-feniks-medika-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (17) — идемпотентно по slug
-- Категории: 3 XRAY, 4 ULTRASOUND, 7 GYNECOLOGY, 9 GENERAL_MEDICINE, 11 ENT, 12 PULMONOLOGY,
-- 15 AMBULATORY_SURGERY, 19 PAIN_THERAPY, 22 UROLOGY,
-- 29 INJECTIONS_INFUSIONS, 30 HOME_VISITS. Специальности — авто по категориям
-- (7→5, 9→45, 11→11, 12→14, 22→9).
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'trigger-point-injection', 'Trigger Point Injection', 'Infiltracija anestetika u mišić u terapiji bola', 'Инфилтрација анестетика у мишић у терапији бола',
	'Инъекция в триггерную точку мышцы', 'Triggerpunkt-Injektion', 'Tetik nokta enjeksiyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'trigger-point-injection' OR name_en = 'Trigger Point Injection');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'bursa-or-cyst-puncture-with-drug-infiltration', 'Bursa or Cyst Puncture with Drug Infiltration', 'Punkcija burze ili ciste sa evakuacijom i infiltracijom lijeka', 'Пункција бурзе или цисте са евакуацијом и инфилтрацијом лијека',
	'Пункция бурсы или кисты с эвакуацией и введением лекарства', 'Punktion eines Schleimbeutels oder einer Zyste mit Medikamenteninfiltration', 'Bursa veya kist ponksiyonu ve ilaç enjeksiyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'bursa-or-cyst-puncture-with-drug-infiltration' OR name_en = 'Bursa or Cyst Puncture with Drug Infiltration');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'blood-pressure-and-bmi-measurement', 'Blood Pressure and BMI Measurement', 'Mjerenje BMI i arterijskog pritiska', 'Мјерење BMI и артеријског притиска',
	'Измерение артериального давления и ИМТ', 'Blutdruck- und BMI-Messung', 'Tansiyon ve VKİ ölçümü', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'blood-pressure-and-bmi-measurement' OR name_en = 'Blood Pressure and BMI Measurement');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'expert-gynecological-ultrasound', 'Expert Gynecological Ultrasound', 'Ekspertski ginekološki ultrazvuk', 'Експертски гинеколошки ултразвук',
	'Экспертное гинекологическое УЗИ', 'Gynäkologischer Experten-Ultraschall', 'Uzman jinekolojik ultrason', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'expert-gynecological-ultrasound' OR name_en = 'Expert Gynecological Ultrasound');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'tonsil-lavage', 'Tonsil Lavage', 'Ispiranje krajnika', 'Испирање крајника',
	'Промывание миндалин', 'Mandelspülung', 'Bademcik yıkama', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'tonsil-lavage' OR name_en = 'Tonsil Lavage');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'sinus-lavage', 'Sinus Lavage', 'Ispiranje sinusa', 'Испирање синуса',
	'Промывание пазух носа', 'Nasennebenhöhlenspülung', 'Sinüs yıkama', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'sinus-lavage' OR name_en = 'Sinus Lavage');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pulmonologist-examination-with-chest-x-ray', 'Pulmonologist Examination with Chest X-Ray', 'Pregled pulmologa sa RTG snimkom pluća', 'Преглед пулмолога са РТГ снимком плућа',
	'Приём пульмонолога с рентгеном лёгких', 'Pneumologische Untersuchung mit Röntgen der Lunge', 'Akciğer röntgeni ile göğüs hastalıkları muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pulmonologist-examination-with-chest-x-ray' OR name_en = 'Pulmonologist Examination with Chest X-Ray');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pulmonologist-examination-with-chest-x-ray-and-spirometry', 'Pulmonologist Examination with Chest X-Ray and Spirometry', 'Pregled pulmologa sa RTG snimkom pluća i spirometrijom', 'Преглед пулмолога са РТГ снимком плућа и спирометријом',
	'Приём пульмонолога с рентгеном лёгких и спирометрией', 'Pneumologische Untersuchung mit Röntgen der Lunge und Spirometrie', 'Akciğer röntgeni ve spirometri ile göğüs hastalıkları muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pulmonologist-examination-with-chest-x-ray-and-spirometry' OR name_en = 'Pulmonologist Examination with Chest X-Ray and Spirometry');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pulmonologist-examination-with-spirometry', 'Pulmonologist Examination with Spirometry', 'Pregled pulmologa sa spirometrijom', 'Преглед пулмолога са спирометријом',
	'Приём пульмонолога со спирометрией', 'Pneumologische Untersuchung mit Spirometrie', 'Spirometri ile göğüs hastalıkları muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pulmonologist-examination-with-spirometry' OR name_en = 'Pulmonologist Examination with Spirometry');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pulmonologist-examination-with-x-ray-reading', 'Pulmonologist Examination with X-Ray Reading', 'Pregled pulmologa sa očitavanjem snimka', 'Преглед пулмолога са очитавањем снимка',
	'Приём пульмонолога с описанием снимка', 'Pneumologische Untersuchung mit Befundung einer Aufnahme', 'Film değerlendirmesi ile göğüs hastalıkları muayenesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pulmonologist-examination-with-x-ray-reading' OR name_en = 'Pulmonologist Examination with X-Ray Reading');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'expert-breast-ultrasound', 'Expert Breast Ultrasound', 'Ekspertski ultrazvuk dojki', 'Експертски ултразвук дојки',
	'Экспертное УЗИ молочных желёз', 'Experten-Ultraschall der Brust', 'Uzman meme ultrasonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'expert-breast-ultrasound' OR name_en = 'Expert Breast Ultrasound');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'systematic-examination-for-women-type-a', 'Systematic Examination for Women Type A', 'Sistematski pregled za žene tip A', 'Систематски преглед за жене тип А',
	'Комплексный медосмотр для женщин, тип A', 'Vorsorgeuntersuchung für Frauen Typ A', 'Kadınlar için check-up A tipi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'systematic-examination-for-women-type-a' OR name_en = 'Systematic Examination for Women Type A');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'systematic-examination-for-women-type-b', 'Systematic Examination for Women Type B', 'Sistematski pregled za žene tip B', 'Систематски преглед за жене тип Б',
	'Комплексный медосмотр для женщин, тип B', 'Vorsorgeuntersuchung für Frauen Typ B', 'Kadınlar için check-up B tipi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'systematic-examination-for-women-type-b' OR name_en = 'Systematic Examination for Women Type B');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'systematic-examination-for-men', 'Systematic Examination for Men', 'Sistematski pregled za muškarce', 'Систематски преглед за мушкарце',
	'Комплексный медосмотр для мужчин', 'Vorsorgeuntersuchung für Männer', 'Erkekler için check-up', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'systematic-examination-for-men' OR name_en = 'Systematic Examination for Men');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'intramuscular-injection-home-visit', 'Intramuscular Injection Home Visit', 'Intramuskularna injekcija u kućnoj posjeti', 'Интрамускуларна инјекција у кућној посјети',
	'Внутримышечная инъекция на дому', 'Intramuskuläre Injektion beim Hausbesuch', 'Evde kas içi enjeksiyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'intramuscular-injection-home-visit' OR name_en = 'Intramuscular Injection Home Visit');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'infusion-therapy-home-visit', 'Infusion Therapy Home Visit', 'Infuzija u kućnoj posjeti', 'Инфузија у кућној посјети',
	'Капельница на дому', 'Infusionstherapie beim Hausbesuch', 'Evde serum (infüzyon) tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'infusion-therapy-home-visit' OR name_en = 'Infusion Therapy Home Visit');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'urinary-catheter-placement-home-visit', 'Urinary Catheter Placement Home Visit', 'Postavljanje ili zamjena urinarnog katetera u kućnoj posjeti', 'Постављање или замјена уринарног катетера у кућној посјети',
	'Установка или замена мочевого катетера на дому', 'Legen oder Wechsel eines Blasenkatheters beim Hausbesuch', 'Evde idrar sondası takılması veya değiştirilmesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'urinary-catheter-placement-home-visit' OR name_en = 'Urinary Catheter Placement Home Visit');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 3 FROM medical_services WHERE slug IN ('pulmonologist-examination-with-chest-x-ray', 'pulmonologist-examination-with-chest-x-ray-and-spirometry');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('expert-gynecological-ultrasound', 'expert-breast-ultrasound');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('expert-gynecological-ultrasound', 'expert-breast-ultrasound', 'systematic-examination-for-women-type-a', 'systematic-examination-for-women-type-b');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 9 FROM medical_services WHERE slug IN ('blood-pressure-and-bmi-measurement', 'systematic-examination-for-women-type-a', 'systematic-examination-for-women-type-b', 'systematic-examination-for-men');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 11 FROM medical_services WHERE slug IN ('tonsil-lavage', 'sinus-lavage');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 12 FROM medical_services WHERE slug IN ('pulmonologist-examination-with-chest-x-ray', 'pulmonologist-examination-with-chest-x-ray-and-spirometry', 'pulmonologist-examination-with-spirometry', 'pulmonologist-examination-with-x-ray-reading');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 15 FROM medical_services WHERE slug IN ('bursa-or-cyst-puncture-with-drug-infiltration');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 19 FROM medical_services WHERE slug IN ('trigger-point-injection');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 22 FROM medical_services WHERE slug IN ('urinary-catheter-placement-home-visit');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 29 FROM medical_services WHERE slug IN ('trigger-point-injection', 'bursa-or-cyst-puncture-with-drug-infiltration', 'intramuscular-injection-home-visit', 'infusion-therapy-home-visit');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 30 FROM medical_services WHERE slug IN ('intramuscular-injection-home-visit', 'infusion-therapy-home-visit', 'urinary-catheter-placement-home-visit');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('expert-gynecological-ultrasound', 'expert-breast-ultrasound', 'systematic-examination-for-women-type-a', 'systematic-examination-for-women-type-b');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 9 FROM medical_services WHERE slug IN ('urinary-catheter-placement-home-visit');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 11 FROM medical_services WHERE slug IN ('tonsil-lavage', 'sinus-lavage');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 14 FROM medical_services WHERE slug IN ('pulmonologist-examination-with-chest-x-ray', 'pulmonologist-examination-with-chest-x-ray-and-spirometry', 'pulmonologist-examination-with-spirometry', 'pulmonologist-examination-with-x-ray-reading');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 45 FROM medical_services WHERE slug IN ('blood-pressure-and-bmi-measurement', 'systematic-examination-for-women-type-a', 'systematic-examination-for-women-type-b', 'systematic-examination-for-men');

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Triger tačka injekcija', 'sr' FROM medical_services WHERE slug = 'trigger-point-injection'
UNION ALL SELECT id, 'Тригер тачка ињекција', 'sr-cyrl' FROM medical_services WHERE slug = 'trigger-point-injection'
UNION ALL SELECT id, 'TPI', 'en' FROM medical_services WHERE slug = 'trigger-point-injection'
UNION ALL SELECT id, 'Блокада триггерной точки', 'ru' FROM medical_services WHERE slug = 'trigger-point-injection'
UNION ALL SELECT id, 'Mjerenje pritiska', 'sr' FROM medical_services WHERE slug = 'blood-pressure-and-bmi-measurement'
UNION ALL SELECT id, 'Мјерење притиска', 'sr-cyrl' FROM medical_services WHERE slug = 'blood-pressure-and-bmi-measurement'
UNION ALL SELECT id, 'Измерение давления', 'ru' FROM medical_services WHERE slug = 'blood-pressure-and-bmi-measurement'
UNION ALL SELECT id, 'Ispiranje tonzila', 'sr' FROM medical_services WHERE slug = 'tonsil-lavage'
UNION ALL SELECT id, 'Испирање тонзила', 'sr-cyrl' FROM medical_services WHERE slug = 'tonsil-lavage'
UNION ALL SELECT id, 'Промывание гланд', 'ru' FROM medical_services WHERE slug = 'tonsil-lavage'
UNION ALL SELECT id, 'Ispiranje paranazalnih šupljina', 'sr' FROM medical_services WHERE slug = 'sinus-lavage'
UNION ALL SELECT id, 'Испирање параназалних шупљина', 'sr-cyrl' FROM medical_services WHERE slug = 'sinus-lavage'
UNION ALL SELECT id, 'Промывание гайморовых пазух', 'ru' FROM medical_services WHERE slug = 'sinus-lavage'
UNION ALL SELECT id, 'Infuzija kod kuće', 'sr' FROM medical_services WHERE slug = 'infusion-therapy-home-visit'
UNION ALL SELECT id, 'Инфузија код куће', 'sr-cyrl' FROM medical_services WHERE slug = 'infusion-therapy-home-visit'
UNION ALL SELECT id, 'Home IV Drip', 'en' FROM medical_services WHERE slug = 'infusion-therapy-home-visit'
UNION ALL SELECT id, 'Инфузия на дому', 'ru' FROM medical_services WHERE slug = 'infusion-therapy-home-visit'
UNION ALL SELECT id, 'Укол на дому', 'ru' FROM medical_services WHERE slug = 'intramuscular-injection-home-visit'
UNION ALL SELECT id, 'Operativna histeroskopija', 'sr' FROM medical_services WHERE slug = 'surgical-hysteroscopy'
UNION ALL SELECT id, 'Оперативна хистероскопија', 'sr-cyrl' FROM medical_services WHERE slug = 'surgical-hysteroscopy'
UNION ALL SELECT id, 'Operative Hysteroscopy', 'en' FROM medical_services WHERE slug = 'surgical-hysteroscopy'
UNION ALL SELECT id, 'Оперативная гистероскопия', 'ru' FROM medical_services WHERE slug = 'surgical-hysteroscopy'
UNION ALL SELECT id, 'Check-up za žene tip A', 'sr' FROM medical_services WHERE slug = 'systematic-examination-for-women-type-a'
UNION ALL SELECT id, 'Check-up za žene tip B', 'sr' FROM medical_services WHERE slug = 'systematic-examination-for-women-type-b'
UNION ALL SELECT id, 'Check-up za muškarce', 'sr' FROM medical_services WHERE slug = 'systematic-examination-for-men';

-- Категории существующим записям каталога, у которых их нет совсем (используются здесь).
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 13 FROM medical_services WHERE slug = 'medical-transport-per-km';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 14 FROM lab_tests WHERE slug = 'gad-antibodies';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'chlamydia-genital-swab';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'mycoplasma-ureaplasma-genital-swab';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'ear-swab-bacteria';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'eye-swab-bacteria';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: УСЛУГИ КЛИНИКИ (144, с ценой 143)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_feniks_services;
CREATE TEMPORARY TABLE tmp_feniks_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_feniks_services (slug, price, price_min, price_max) VALUES
-- ── opšta i interna medicina ──────────────────────────────────────────────
('internist-examination-with-ecg', 40.00, NULL, NULL), -- OPŠTI INTERNISTIČKI PREGLED SA URAĐENIM EKG-om 40,00 eur
('internist-examination', 35.00, NULL, NULL), -- OPŠTI INTERNISTIČKI PREGLED BEZ EKG-a 35,00 eur
('general-practitioner-examination', 35.00, NULL, NULL), -- PREGLED DOKTORA OPŠTE PRAKSE 35,00 eur
('ecg', 15.00, NULL, NULL), -- EKG (bez komletnog ljekarskog pregleda) 15,00 eur
('spirometry', 20.00, NULL, NULL), -- SPIROMETRIJA 20,00 eur
('follow-up-internist-examination', 25.00, NULL, NULL), -- KONTROLNI PREGLED INTERNISTE 25,00 eur
('follow-up-general-practitioner-examination', 20.00, NULL, NULL), -- KONTROLNI PREGLED DOKTORA OPŠTE PRAKSE 20,00 eur
('intramuscular-injection', 5.00, NULL, NULL), -- PARENTERALNA TERAPIJA, intramuskularno 5,00 eur
('intravenous-medication-application', 8.00, NULL, NULL), -- PARENTERALNA TERAPIJA … intravenozno 8,00 eur
('small-wound-dressing', 10.00, NULL, NULL), -- PREVIJANJE MALO 10,00 eur
('ambulatory-medium-dressing', 15.00, NULL, NULL), -- PREVIJANJE SREDNJE 15,00 eur
('large-wound-dressing', 20.00, NULL, NULL), -- PREVIJANJE VELIKO 20,00 eur
('trigger-point-injection', 25.00, NULL, NULL), -- INFILTRACIJA ANESTETIKA U MIŠIĆ U TERAPIJI BOLA SA LIJEKOM I ANESTETIKOM 25,00 eur (новая запись)
('bursa-or-cyst-puncture-with-drug-infiltration', 25.00, NULL, NULL), -- PUNKCIJA BURSI I CISTA SA EVAUKACIJOMI INFILTRACIJOM MEDIKAMENATA 25,00 eur (новая запись)
('blood-pressure-and-bmi-measurement', 2.00, NULL, NULL), -- MJERENJE BMI I ARTERIJSKOG PRITISKA 2,00 eur (новая запись)
('urinary-catheter-placement', 25.00, NULL, NULL), -- POSTAVLJANJE URINARNOG KATETERA 25,00 eur
('indwelling-urinary-catheter-replacement', 30.00, NULL, NULL), -- ZAMJENA URINARNOG KATETERA 30,00 eur
-- ── hirurgija ─────────────────────────────────────────────────────────────
('surgical-examination', 50.00, NULL, NULL), -- HIRURŠKI PREGLED 50,00 eur; повтор в блоке хирурга: PREGLED HIRURGA 50,00 eur
('follow-up-surgical-examination', 30.00, NULL, NULL), -- KONTROLNI HIRURŠKI PREGLED 30,00 eur; повтор: KONTROLA HIRURGA 30,00 eur
('suture-removal', 20.00, NULL, NULL), -- SKIDANJE KONACA POSLE HIRURŠKOG ZAHVATA 20,00 eur
('ingrown-toenail-surgery', 160.00, NULL, NULL), -- INTERVENCIJA URASLI NOKAT 160,00 eur
('lipoma-removal', 130.00, NULL, NULL), -- INTERVENCIJA UKLANJANJE MASNOG TKIVA 130,00 eur
('foot-callus-surgical-removal', 115.00, NULL, NULL), -- INTERVENCIJA “KURJE OKO” 115,00 eur
-- ── ginekologija ──────────────────────────────────────────────────────────
('gynecological-specialist-examination', 25.00, NULL, NULL), -- PREGLED SPECIJALISTE GINEKOLOGA 25,00 eur
('gynecological-ultrasound', 30.00, NULL, NULL), -- ULTRAZVUČNI PREGLED MALE KARLICE 30,00 eur; ULTRAZVUČNI PREGLED VAGINALNOM SONDOM 30,00 eur
('expert-gynecological-ultrasound', 50.00, NULL, NULL), -- EXPERTSKI ULTRAZVUK-GINEKOLOŠKI 50,00 eur (новая запись)
('4d-pregnancy-ultrasound', 60.00, NULL, NULL), -- 4D ULTRAZVUK 60,00 eur
('colposcopy', 40.00, NULL, NULL), -- KOLPOSKOPIJA 40,00 eur
('ctg-fetal-monitoring', 15.00, NULL, NULL), -- CTG 15,00 eur
('diagnostic-hysteroscopy', 250.00, NULL, NULL), -- HISTEROSKOPIJA (dijagnostika) 250,00 eur
('surgical-hysteroscopy', 800.00, NULL, NULL), -- HISTEROSKOPIJA (operativna) 800,00 eur
('first-trimester-surgical-abortion-curettage', 120.00, NULL, 240.00), -- KIRETAŽA U LOKALNOJ ANESTEZIJI 120,00 eur; KIRETAŽA U OPŠTOJ ANESTEZIJI (do 8 nedelje trudnoće) 200,00 eur; (preko 8 nedelja trudnoće) 240,00 eur
('exploratory-curettage', 120.00, NULL, 180.00), -- EKSPLORATIVNA KIRETAŽA U LOKALNOJ ANESTEZIJI 120,00. eur; … U OPŠTOJ ANESTEZIJI 180,00 eur (+ ph nalaz 50,00 eur)
('condyloma-radio-wave-removal', 30.00, NULL, 100.00), -- UKLANJANJE KONDILOMA RADIO HIR. NOŽEM (zavisno od broja) 30-100 eur
('cervical-conization', 200.00, NULL, 260.00), -- KONIZACIJA GRLIĆA MATERICE U LOKALNOJ 200,00 eur; … U OPŠTOJ ANESTEZIJI 260,00 eur (+ ph nalaz 50,00 eur)
('leep-excision', 170.00, NULL, NULL), -- LOOP EKSCIZIJA GRLIĆA MATERICE 170,00 eur (+ ph nalaz 50,00 eur)
('cervical-biopsy', 30.00, NULL, NULL), -- BIOPSIJA GRLIĆA MATERICE 30,00 eur (+ ph nalaz 50,00 eur)
('bartholin-gland-incision-and-marsupialization', 90.00, NULL, NULL), -- MARSUPIJALIZACIJA BERTOLINIJEVE ŽLIJEZDE U LOKALNOJ ANESTEZIJI 90,00 eur
('iud-insertion', 30.00, NULL, NULL), -- POSTAVLJANJE SPIRALE 30,00 eur + cijena spirale
('iud-removal', 30.00, NULL, NULL), -- UKLANJANJE SPIRALE 30,00 eur
-- ── pedijatrija ───────────────────────────────────────────────────────────
('pediatric-examination', 30.00, NULL, NULL), -- PREGLED SPECIJLISTE PEDIJATRA 30,00 eur; PREGLED NOVOROĐENČADI DO 12. MJESECI 30,00 eur
('follow-up-pediatric-examination', 15.00, NULL, NULL), -- KONTROLNI PREGLED 15,00 eur (pedijatrija)
('inhalation-therapy', 8.00, NULL, 15.00), -- INHALACIJA ZA DJECU 8,00 eur (pedijatrija); INHALACIONA TERAPIJA 15,00 eur (pulmolog)
('pediatric-hip-ultrasound', 30.00, NULL, NULL), -- ULTRAZVUK KUKOVA 30,00 eur (pedijatrija)
('infant-brain-ultrasound-neurosonography', 30.00, NULL, NULL), -- ULTRAZVUK GLAVE KOD BEBA 30,00 eur
('well-child-preventive-check-up', 20.00, NULL, NULL), -- SAVJETOVALIŠTE ZA BEBE 20,00 eur
-- ── eho dijagnostika ──────────────────────────────────────────────────────
('abdomen-ultrasound', 35.00, NULL, 40.00), -- EHO PREGLED ABDOMENA 35,00 eur (dječiji radiolog); EHO PREGLED ABDOMENA kod opšteg radiologa 40,00 eur
('urinary-tract-ultrasound', 30.00, NULL, 40.00), -- EHO PREGLED UROTRAKTA 35,00 eur (dječiji radiolog); ULTRAZVUČNI PREGLED UROTRAKTA 30,00 eur (urologija); EHO PREGLED UROTRAKTA (bubrega, mokracne bešike/sa rezidualnim urinom, prostate) 40,00 eur
('neck-ultrasound', 35.00, NULL, NULL), -- EHO PREGLED VRATA 35,00 eur (dječiji radiolog)
('follow-up-ultrasound-examination', 30.00, NULL, NULL), -- KONTROLNI EHO PREGLED 30,00 eur
('breast-ultrasound', 40.00, NULL, NULL), -- EHO PREGLED DOJKI 40,00 eur
('expert-breast-ultrasound', 50.00, NULL, NULL), -- EXPERTSKI ULTRAZVUK DOJKI 50,00 eur (новая запись)
('thyroid-ultrasound', 40.00, NULL, NULL), -- EHO ŠTITASTE ŽLIJEZDE 40,00 eur
('ultrasound-lymph-nodes', 40.00, NULL, NULL), -- EHO PREGLED REGIONALNIH LIMFATIKA 40.00 eur
('doppler-neck-blood-vessels', 45.00, NULL, NULL), -- COLOR DOPLER KRVNIH SUDOVA VRATA 45,00 eur
('doppler-lower-extremity-blood-vessels', 45.00, NULL, NULL), -- COLOR DOPLER KRVINH SUDOVA DONJIH EKSTREMITETA 45,00 eur
('doppler-upper-extremity-blood-vessels', 45.00, NULL, NULL), -- COLOR DOPLER KRVNIH SUDOVA GORNJIH EKSTREMITETA 45,00 eur
('doppler-renal-arteries', 45.00, NULL, NULL), -- COLOR DOPLER RENALNIH ARTERIJA 45,00 eur
('doppler-portal-vein', 50.00, NULL, NULL), -- COLOR DOPLER PORTNOG SISTEMA 50,00 eur
('musculoskeletal-ultrasound', 45.00, NULL, NULL), -- EHO MEKIH TKIVA (mišići, nervi, tetive, ligamenti itd.) 45,00 eur
-- ── hematologija ──────────────────────────────────────────────────────────
('hematologist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE HEMATOLOGA 40,00 eur
('follow-up-hematologist-examination', 35.00, NULL, NULL), -- KONTROLNI PREGLED 35,00 eur (hematologija)
-- ── urologija ─────────────────────────────────────────────────────────────
('urologist-examination', 30.00, NULL, NULL), -- PREGLED SPECIJALISTE UROLOGA 30,00 eur
('testicular-ultrasound', 35.00, NULL, NULL), -- ULTRAZVUČNI PREGLED TESTISA 35,00 eur
('urologist-examination-with-ultrasound', 50.00, NULL, NULL), -- ULTRAZVUČNI PREGLED SA PREGLEDOM SPECIJALISTE 50,00 eur (urologija)
('follow-up-urologist-examination', 25.00, NULL, NULL), -- KONTROLNI PREGLED 25,00 eur (urologija)
('electrocoagulation-or-excision-of-condyloma-acuminata', 140.00, NULL, NULL), -- KONDILOMI 140,00 eur (u ovu cijenu je uračunata kontrola i sve eventualne komplikacije u roku od mjesec dana) — urologija
('circumcision-local-anesthesia', 250.00, NULL, NULL), -- FIMOZA 250,00 eur — urologija
-- ── orl ───────────────────────────────────────────────────────────────────
('ent-specialist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE ORL 40,00 eur
('follow-up-ent-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED 30,00 eur (ORL)
('tympanometry', 15.00, NULL, NULL), -- TIMPANOMETRIJA 15,00 eur
('audiometry', 10.00, NULL, NULL), -- AUDIOMETRIJA 10,00 eur
('cerumen-ear-irrigation', 15.00, NULL, NULL), -- ISPIRANJE UHA 15,00 eur
('tonsil-lavage', 15.00, NULL, NULL), -- ISPIRANJE KRAJNIKA 15,00 eur (новая запись)
('sinus-lavage', 15.00, NULL, NULL), -- ISPIRANJE SINUSA 15,00 eur (новая запись)
-- ── fizijatar ─────────────────────────────────────────────────────────────
('first-physiatrist-examination', 35.00, NULL, NULL), -- PREGLED SPECIJALISTE FIZIJATRA 35,00 eur
('follow-up-physiatrist-examination', 25.00, NULL, NULL), -- KONTROLNI PREGLED 25,00 eur (fizijatar)
('physical-therapy-per-therapy-day', 15.00, NULL, 25.00), -- FIZIKALNA TERAPIJA 15,00eur, 20,00eur,25,00 eur
-- ── neurolog ──────────────────────────────────────────────────────────────
('first-neurologist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE NEUROLOGA 40,00 eur
('follow-up-neurologist-examination', 25.00, NULL, NULL), -- KONTROLNI PREGLED 25,00 eur (neurolog)
-- ── kardiolog ─────────────────────────────────────────────────────────────
('cardiologist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE KARDIOLOGA 40,00 eur
('echocardiography-heart-ultrasound', 50.00, NULL, NULL), -- EHO (ultrazvučni) PREGLED SRCA(u cijenu uračunat EKG) 50,00 eur
('cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound', 70.00, NULL, NULL), -- PREGLED KARDIOLOGA SA EHO PREGLEDOM SRCA (plus EKG) 70,00 eur
-- ── reumatolog ────────────────────────────────────────────────────────────
('rheumatologist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE REUMATOLOGA 40,00 eur
('follow-up-rheumatologist-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED 30,00 eur (reumatolog)
('medication-infiltration', 30.00, NULL, NULL), -- INFILTRACIJA LIJEKA 30,00 eur (reumatolog)
-- ── endokrinolog ──────────────────────────────────────────────────────────
('endocrinologist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE ENDOKRINOLOGA 40,00 eur
('follow-up-endocrinologist-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED 30,00 eur (endokrinolog)
('endocrinologist-examination-with-thyroid-ultrasound', 60.00, NULL, NULL), -- PREGLED ENDOKRINOLOGA SA UZ PREGLEDOM ŠTITASTE ŽLIJEZDE 60,00 eur
-- ── dermatovenerolog ──────────────────────────────────────────────────────
('dermatologist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE DERMATOVENEROLOGA 40,00 eur
('follow-up-dermatologist-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED 30,00 eur (dermatovenerolog)
('dermatologist-examination-with-dermatoscopy', 50.00, NULL, NULL), -- PREGLED SA DERMATOSKOPIJOM 50,00 eur
-- ── pulmolog ──────────────────────────────────────────────────────────────
('pulmonologist-examination', 40.00, NULL, NULL), -- PRVI PREGLED LJEKARA SPECIJALISTE 40,00 eur (pulmolog)
('follow-up-pulmonologist-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED LJEKARA SPECIJALISTE 30,00 eur; KONTRONI PREGLED PACIJENATA NA DUGOTRAJNOJ OKSIGENOTERAPIJI 30,00 eur
('home-visit-examination', 40.00, NULL, 80.00), -- PRVI PREGLED LJEKARA SPECIJALISTE-KUĆNA POSJETA 80,00 eur; KONTROLNI PREGLED PACIJENATA NA DUGOTRAJNOJ OKSIGENOTERAPIIJ-KUĆNA POSJETA 40,00 eur (pulmolog)
('pulmonologist-examination-with-chest-x-ray', 55.00, NULL, 65.00), -- PRVI PREGLED … SA RTG SNIMKOM PLUCA 65,00 eur; KONTROLNI … SA RTG SNIMKOM PLUĆA 55,00 eur (новая запись)
('pulmonologist-examination-with-chest-x-ray-and-spirometry', 65.00, NULL, 75.00), -- PRVI PREGLED … SA RTG SNIMKOM PLUCA+SPIROMETRIJA 75,00 eur; KONTROLA PULMOLOGA SA RTG SNIMKOM+SPIROMETRIJA 65,00 eur (новая запись)
('pulmonologist-examination-with-spirometry', 55.00, NULL, NULL), -- KONTROLNI PREGLED LJEKARA SPECIJALISTE+SPIROMETRIJA 55,00 eur (новая запись)
('pulmonologist-examination-with-x-ray-reading', 40.00, NULL, 45.00), -- PRVI PREGLED … SA OCITAVANJEM SNIMKA 45,00eu; KONTROLNI … SA OCITAVANJEM SNIMKA 40,00eur (новая запись)
('bronchodilator-test', 25.00, NULL, NULL), -- BRONHODILATACIJSKI TEST SA OPISOM NALAZA 25,00 eur
('pulse-oximetry', 5.00, NULL, NULL), -- ODREĐIVANJE SATURACIJE KISEONIKA 5,00 eur
-- ── psihijatar ────────────────────────────────────────────────────────────
('first-psychiatrist-examination', 40.00, NULL, NULL), -- PREGLED SPECIJALISTE PSIHIJATRA 40,00 eur
('follow-up-psychiatrist-examination', 30.00, NULL, NULL), -- KONTROLNI PREGLED 30,00 eur (psihijatar)
-- ── rtg ───────────────────────────────────────────────────────────────────
('x-ray-chest-heart', 30.00, NULL, NULL), -- RTG PLUĆA I SRCA (PA projekcija) 30,00 eur; RTG PLUĆA I SRCA (PA i profilna projekcija) 30,00 eur
('x-ray-per-segment', 30.00, NULL, NULL), -- RTG KOSTIJU U DVA PRAVCA 30,00 eur; RTG ZGLOBOVA U DVA PRAVCA 30,00 eur
('x-ray-head-craniogram', 30.00, NULL, NULL), -- KRANIOGRAM 30,00 eur
('x-ray-mastoid-shuller', 30.00, NULL, NULL), -- SPECIJALNI SNIMCI GLAVE (mastoidi, piramide) 30,00 eur
('x-ray-temporal-bones', 30.00, NULL, NULL), -- SPECIJALNI SNIMCI GLAVE (mastoidi, piramide) 30,00 eur
('x-ray-paranasal-sinuses', 30.00, NULL, NULL), -- RTG PARANAZALNIH ŠUPLJINA 30,00 eur
('x-ray-hand', 30.00, NULL, NULL), -- RTG SNIMCI ŠAKE,KOLJENA, RAMENA (cijena se odnosi na jedan snimak) 30,00 eur
('x-ray-knee', 30.00, NULL, NULL), -- RTG SNIMCI ŠAKE,KOLJENA, RAMENA (cijena se odnosi na jedan snimak) 30,00 eur
('x-ray-shoulder', 30.00, NULL, NULL), -- RTG SNIMCI ŠAKE,KOLJENA, RAMENA (cijena se odnosi na jedan snimak) 30,00 eur
('x-ray-lower-leg', 30.00, NULL, NULL), -- RTG JEDNE NOGE, STOPALA 30,00 eur
('x-ray-foot', 30.00, NULL, NULL), -- RTG JEDNE NOGE, STOPALA 30,00 eur
('x-ray-pelvis', 30.00, NULL, NULL), -- RTG KARLICA SA KUKOVIMA 30,00 eur
('x-ray-cervical-spine', 30.00, NULL, NULL), -- RTG KIČME (kičma se snima iz tri dijela-cijena se odnosi na jedan snimak) 30,00 eur
('x-ray-thoracic-spine', 30.00, NULL, NULL), -- RTG KIČME (kičma se snima iz tri dijela-cijena se odnosi na jedan snimak) 30,00 eur
('x-ray-lumbar-spine-and-sacrum', 30.00, NULL, NULL), -- RTG KIČME (kičma se snima iz tri dijela-cijena se odnosi na jedan snimak) 30,00 eur
('x-ray-abdomen-native', 35.00, NULL, NULL), -- RTG PREGLED ABDOMENA- NATIVNO 35,00 eur
('x-ray-urinary-tract-native', 35.00, NULL, NULL), -- RTG PREGLED UROTRAKTA-NATIVNO 35,00 eur
('x-ray-both-hands', NULL, NULL, NULL), -- RTG OBJE ŠAKE (страница /radioloski-kabinet-u-podgorici/, в прайсе отдельной строки нет)
('mammography', 50.00, NULL, NULL), -- MAMOGRAFIJA 50,00 eur
('breast-biopsy', 500.00, NULL, NULL), -- BIOPSIJA DOJKE 500,00 eur (sa PH nalazom)
('breast-cyst-puncture', 120.00, NULL, NULL), -- PUNKCIJA CISTI(DOJKA) sa PH nalazom 120,00 eur
-- ── laboratorija ──────────────────────────────────────────────────────────
('venous-blood-draw', 1.00, NULL, NULL), -- VAĐENJE KRVI 1,00 eur
-- ── sistematski pregledi ──────────────────────────────────────────────────
('systematic-examination-for-women-type-a', 170.00, NULL, NULL), -- SISTEMATSKI PREGLED TIP “A” ZA ŽENE … 170,00 eur (новая запись)
('systematic-examination-for-women-type-b', 200.00, NULL, NULL), -- SISTEMATSKI PREGLED TIP “B” ZA ŽENE … 200,00 eur (новая запись)
('systematic-examination-for-men', 170.00, NULL, NULL), -- SISTEMATSKI PREGLED ZA MUŠKARCE … 170,00 eur (новая запись)
-- ── kućne posjete ─────────────────────────────────────────────────────────
('intramuscular-injection-home-visit', 8.00, NULL, NULL), -- INTRAMUSKULARNA INJEKCIJA U KUĆNOJ POSJETI (jednom dnevno vise davanja) 8,00 eur (новая запись)
('intravenous-therapy-home-visit-city', 10.00, NULL, NULL), -- INTRAVENSKA INJEKCIJA U KUĆNOJ POSJETI 10,00 eur
('infusion-therapy-home-visit', 15.00, NULL, 30.00), -- INFUZIJSKI RASTVOR U KUĆNOJ POSJETI DO 30 MINUTA 15,00 eur; DO 60 MINUTA 30,00 eur (новая запись)
('urinary-catheter-placement-home-visit', 35.00, NULL, NULL), -- URINARNI KATETER U KUĆNOJ POSJETI (postavljanje ili zamjena) 35,00 eur (новая запись)
-- ── transport ─────────────────────────────────────────────────────────────
('medical-transport-per-km', 3.00, NULL, NULL), -- TRANSPORT PACIJENTA NA TERITORIJI PODGORICE (bez pratnje ljekara) 3,00 eur/km
('medical-transport-with-gp-per-km', 4.00, NULL, NULL), -- TRANSPORT PACIJENTA NA TERITORIJI PODGORICE (sa pratnjom ljekara) 4,00 eur/km
-- ── ljekarska uvjerenja ───────────────────────────────────────────────────
('medical-certificate-for-general-work', 20.00, NULL, NULL), -- LJEKARSKO UVJERENJE ZA ZASNIVANJE RADNOG ODNOSA(za sve poslove koji ne podrazumijevaju rad u otezanim uslovima rada) 20,00eur
('medical-certificate-for-university-enrollment', 20.00, NULL, NULL), -- LJEKARSKO UVJERENJE ZA UPIS NA FAKULTET 20,00eur
('medical-certificate-for-residence-and-work-in-montenegro', 25.00, NULL, NULL), -- LJEKARSKO UVJERENJE ZA BORAVAK I RAD U CRNOJ GORI 25,00eur
('medical-certificate-for-security-personnel', 45.00, NULL, NULL), -- LJEKARSKO UVJERENJE ZA ZASTITARA LICA I IMOVINE 45,00eur
('medical-certificate-for-firearms-possession', 40.00, NULL, NULL), -- LJEKARSKO UVJERENJE REGULISANJE ORUZANOG LISTA 40,00eur
('medical-certificate-for-high-risk-and-difficult-working-conditions', 45.00, NULL, NULL), -- LJEKARSKO UVJERENJE U OTEZANIM USLOVIMA RADA(RAD NA VISINI) 45,00eur
('medical-certificate-for-boat-operation-up-to-12-meters', 35.00, NULL, NULL), -- LJEKARSKO UVJERENJE ZA VODITELJA CAMCA 35,00eur
('medical-certificate-for-professional-drivers', 45.00, NULL, NULL), -- LJEKARSKO UVJERENJE ZA PROFESIONALNOG VOZACA 45,00eur
('medical-certificate-for-driving-license-category-a-b-c-d-e', 20.00, NULL, NULL), -- LJEKARSKO UVJERENJE ZA POLAGANJE VOZACKOG ISPITA 20,00eur
('medical-certificate-for-driving-license-renewal-category-a-b-c-d-e', 25.00, NULL, NULL); -- LJEKARSKO UVJERENJE ZA PRODUZENJE VOZACKE DOZVOLE 25,00eur

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service FROM tmp_feniks_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_feniks_services t
JOIN medical_services ms ON ms.slug = t.slug
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_feniks_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: АНАЛИЗЫ КЛИНИКИ (154, с ценой 153) — clinic_lab_tests
-- Раздел прайса «HEMATOLOŠKE ANALIZE» на деле содержит всю лабораторию (биохимия,
-- электролиты, коагуляция, витамины) до «TUMOR MARKERI»; секции ниже — наша разбивка.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_feniks_lab;
CREATE TEMPORARY TABLE tmp_feniks_lab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_feniks_lab (slug, price, price_max) VALUES
-- ── hematološke analize ───────────────────────────────────────────────────
('complete-blood-count', 5.00, NULL), -- KRVNA SLIKA 5,00 eur
('erythrocyte-sedimentation-rate', 3.00, NULL), -- SEDIMENTACIJA 3,00 eur (строка повторяется дважды)
('prothrombin-time-pt-inr', 5.00, NULL), -- INR (gustina krvi) 5,00 eur; PROTROMBINSKO VRIJEME/INR 5,00 eur
-- ── biohemija ─────────────────────────────────────────────────────────────
('glucose', 3.00, NULL), -- GLUKOZA 3,00 eur
('urea', 3.00, NULL), -- UREA 3,00 eur
('creatinine', 3.00, NULL), -- KREATININ 3,00 eur
('uric-acid', 3.00, NULL), -- MOKRAĆNA KISELINA 3,00 eur
('total-protein', 3.00, NULL), -- PROTEINI (bjelančevine) 3,00 eur
('albumin', 3.00, NULL), -- ALBUMIN 3,00 eur
('total-bilirubin', 4.00, NULL), -- UKUPNI BILIRUBIN 4,00 eur
('direct-bilirubin', 4.00, NULL), -- DIREKTNI BILIRUBIN 4,00 eur
('cholesterol', 3.00, NULL), -- HOLESTEROL 3,00 eur
('hdl-cholesterol', 3.00, NULL), -- HDL-holesterol 3,00 eur
('ldl-cholesterol', 3.00, NULL), -- LDL-holesterol 3,00 eur
('triglycerides', 3.00, NULL), -- TRIGLICERIDI 3,00 eur
('ast', 3.00, NULL), -- AST 3,00 eur
('alt', 3.00, NULL), -- ALT 3,00 eur
('alkaline-phosphatase', 3.00, NULL), -- ALP 3,00 eur
('gamma-gt', 3.00, NULL), -- GGT 3,00 eur
('amylase', 3.00, NULL), -- AMILAZA 3,00 eur
('lipase', 3.00, NULL), -- LIPAZA 3,00 eur
('ldh', 3.00, NULL), -- LDH 3,00 eur
('iron', 4.00, NULL), -- GVOŽĐE 4,00 eur
('tibc', 5.00, NULL), -- TIBC 5,00 eur
('uibc', 5.00, NULL), -- UIBC 5,00 eur
('c-reactive-protein', 5.00, NULL), -- CRP 5,00 eur
('complete-urinalysis', 5.00, NULL), -- URIN 5,00 eur
('urine-culture', 10.00, NULL), -- URINOKULTURA 10.00 eur
-- ── elektroliti ───────────────────────────────────────────────────────────
('sodium', 4.00, NULL), -- NATRIJUM 4,00 eur
('potassium', 4.00, NULL), -- KALIJUM 4,00 eur
('chloride', 4.00, NULL), -- HLORIDI 4,00 eur
('phosphorus', 4.00, NULL), -- FOSFOR 4,00 eur
('calcium', 4.00, NULL), -- KALCIJUM 4,00 eur
('calcium-in-urine', 5.00, NULL), -- KALCIJUM (U URINU) 5,00 eur
('magnesium', 4.00, NULL), -- MAGNEZIJUM 4,00 eur
('copper-in-serum', 10.00, NULL), -- BAKAR 10,00 eur
('zinc-in-serum', 10.00, NULL), -- CINK 10,00 eur
-- ── biohemija ─────────────────────────────────────────────────────────────
('ck', 3.00, NULL), -- CK 3,00 eur
('ck-mb', 3.00, NULL), -- CK-MB 3,00 eur
-- ── vitamini ──────────────────────────────────────────────────────────────
('vitamin-b12', 15.00, NULL), -- VITAMIN B12 15,00 eur
('vitamin-d-25-oh', 25.00, NULL), -- VITAMIN D 25,00 eur
-- ── koagulacija ───────────────────────────────────────────────────────────
('activated-partial-thromboplastin-time', 12.00, NULL), -- Apt 12,00 eur
('d-dimer', 15.00, NULL), -- D-DIMER 15,00 eur
('fibrinogen', 5.00, NULL), -- FIBRINOGEN 5,00 eur
('protein-c', 15.00, NULL), -- PROTEIN C 15,00 eur
('protein-s', 15.00, NULL), -- PROTEIN S 15,00 eur
('lupus-anticoagulant', 15.00, NULL), -- LA1 15,00 eur
('antithrombin-iii', 15.00, NULL), -- ANTITROMBIN III 15,00 eur
('bleeding-time', 3.00, NULL), -- VRIJEME KRVARENJA 3,00 eur
('coagulation-time', 3.00, NULL), -- VRIJEME KOAGULACIJE 3,00 eur
-- ── stolica ───────────────────────────────────────────────────────────────
('fecal-occult-blood', 15.00, NULL), -- TEST NA OKULTNO KRVARENJE 15,00 eur
('helicobacter-pylori-antigen-in-feces', 10.00, NULL), -- TEST NA HELIKO BAKTERIJU PYLORI 10,00 eur
-- ── biohemija ─────────────────────────────────────────────────────────────
('transferrin', 13.00, NULL), -- TRANSFERIN,,,, 13,00 eur
('ferritin', 13.00, NULL), -- FERITIN 13,00 eur
('homocysteine', 30.00, NULL), -- HOMOCISTEIN 30,00 eur
-- ── vitamini ──────────────────────────────────────────────────────────────
('folic-acid', 30.00, NULL), -- FOLNA KISELINA 30,00 eur
-- ── biohemija ─────────────────────────────────────────────────────────────
('hba1c', 14.00, NULL), -- HbA1c 14,00 eur
-- ── tumor markeri ─────────────────────────────────────────────────────────
('afp', 15.00, NULL), -- AFP 15,00 eur
('cea', 15.00, NULL), -- CEA 15,00 eur
('ca-15-3', 15.00, NULL), -- CA 15-3 15,00 eur
('ca-19-9', 15.00, NULL), -- CA 19-9 15,00 eur
('ca-125', 15.00, NULL), -- CA 125 15,00 eur
('cyfra-21-1', 15.00, NULL), -- CYFRA 21-1 15,00 eur
('nse', 15.00, NULL), -- NSE 15,00 eur
('protein-s-100', 25.00, NULL), -- S 100 25,00 eur
('ca-72-4', 20.00, NULL), -- CA 72-4 20,00 eur
('he4', 26.00, NULL), -- HE-4 26,00 eur
('chromogranin-a', 40.00, NULL), -- HROMOGRANIN A 40,00 eur
('roma-index', 40.00, NULL), -- ROMA INDEX(CA-125+HE-4) 40,00 eur
-- ── tumor markeri za prostatu ─────────────────────────────────────────────
('psa', 14.00, NULL), -- PSA (ukupni) 14,00 eur
('free-psa', 15.00, NULL), -- PSA (slobodni) 15,00 eur
-- ── hormoni štitaste žlijezde ─────────────────────────────────────────────
('t3', 6.00, NULL), -- T3 (ukupni T3) 6,00 eur
('t4', 6.00, NULL), -- T4 (ukupni T4) 6,00 eur
('tsh', 6.00, NULL), -- TSH 6,00 eur
('free-t3', 10.00, NULL), -- FT3 (slobodni T3) 10,00 eur
('free-t4', 10.00, NULL), -- FT4 (slobodni T4) 10,00 eur
('anti-tpo', 15.00, NULL), -- Anti TPO-Antitijela 15,00 eur
('anti-thyroglobulin-antibodies', 15.00, NULL), -- Anti TG-Antitijela 15,00 eur
('anti-tshr', 25.00, NULL), -- Anti TSHR 25,00 eur
('thyroglobulin', 12.00, NULL), -- TIREOGLOBULIN 12,00 eur
('calcitonin', 15.00, NULL), -- KALCITONIN 15,00 eur
-- ── polni hormoni ─────────────────────────────────────────────────────────
('fsh', 8.00, NULL), -- FSH 8,00 eur
('lh', 8.00, NULL), -- LH 8,00 eur
('prolactin', 8.00, NULL), -- PROLAKTIN 8,00 eur
('estradiol', 9.00, NULL), -- ESTRADIOL 9,00 eur
('free-estriol', 10.00, NULL), -- ESTRIOL 10,00 eur
('progesterone', 9.00, NULL), -- PROGESTERON 9,00 eur
('testosterone', 10.00, NULL), -- TESTOSTERON 10,00 eur
('dhea-s', 13.00, NULL), -- DHEAS 13,00 eur
('shbg', 15.00, NULL), -- SHBG 15,00 eur
('androstenedione', 17.00, NULL), -- ANDROSTENDION 17,00 eur
('anti-mullerian-hormone', 30.00, NULL), -- ANTIMILEROV HORMON 30,00 eur
('inhibin-b', 21.00, NULL), -- INHIBIN B 21,00 eur
('inhibin-a', 21.00, NULL), -- INHIBIN A 21,00 eur
('17-hydroxyprogesterone', 16.00, NULL), -- 17-OHP 16,00 eur
('free-testosterone', 26.00, NULL), -- FREE TESTOSTERON 26,00 eur
('bioavailable-testosterone', 26.00, NULL), -- BIO RASPOLOŽIVI TESTOSTERON 26,00 eur
('beta-hcg', 15.00, NULL), -- BETA Hcg 15,00 eur
-- ── ostali hormoni ────────────────────────────────────────────────────────
('cortisol', 11.00, NULL), -- KORTIZOL 11,00 eur
('pth', 17.00, NULL), -- PTH 17,00 eur
('insulin', 13.00, NULL), -- INSULIN 13,00 eur
('c-peptide', 13.00, NULL), -- C-PEPTID 13,00 eur
('acth', 19.00, NULL), -- ACTH 19,00 eur
('renin', 30.00, NULL), -- RENIN 30,00 eur
('torch-panel', 110.00, NULL), -- TORCH TEST 110,00 eur
('double-test-first-trimester-screening', 40.00, NULL), -- DOUBLE TEST 40,00 eur
-- ── ginekologija ──────────────────────────────────────────────────────────
('triple-test-second-trimester-screening', NULL, NULL), -- страница /ginekologija/: «double i triple test u trudnoći» — в прайсе только DOUBLE TEST
-- ── imunologija ───────────────────────────────────────────────────────────
('rheumatoid-factor', 5.00, NULL), -- REUMA FAKTOR 5,00 eur
('asto', 5.00, NULL), -- ASTO 5,00 eur
('waaler-rose-test', 5.00, NULL), -- WALLER ROSE 5,00 eur
('ana-antinuclear-antibodies', 20.00, NULL), -- ANA(antinuklearna antitijela) 20,00 eur
('dsdna-igm-antibodies', 15.00, NULL), -- Da DNA-M 15,00 eur (опечатка «Da» = ds)
('dsdna-igg-antibodies', 15.00, NULL), -- Ds DNA-G 15,00 eur
('transglutaminase-iga-antibodies', 15.00, NULL), -- AT NA TKIVNU TRANSGLUTAMINAZU IgA 15,00 eur
('transglutaminase-igg-antibodies', 15.00, NULL), -- AT NA TKIVNU TRANSGLUTAMINAZU IgG 15,00 eur
('anticardiolipin-igm', 15.00, NULL), -- CARDIOLIPINSKA ANTITIJELA IgM 15,00 eur
('anticardiolipin-igg', 15.00, NULL), -- CARDIOLIPINSKA ANTITIJELA IgG 15,00 eur
('gliadin-iga-antibodies', 15.00, NULL), -- GLIADIN-A 15,00 eur
('gliadin-igg-antibodies', 15.00, NULL), -- GLIADIN-G 15,00 eur
('beta-2-glycoprotein-i-igm', 15.00, NULL), -- Beta 2 GLIKOPROTEIN-M 15,00 eur
('beta-2-glycoprotein-i-igg', 15.00, NULL), -- Beta 2 GLIKOPROTEIN-G 15,00 eur
('gad-antibodies', 20.00, NULL), -- At na GLUTAMAT DEKARBROKSILAZU (GAD) IgG 20,00 eur
('ia-2-antibodies', 20.00, NULL), -- At na TIROZIN FOSFATAZU (IA2) IgG 20,00 eur
('ovarian-antibodies', 20.00, NULL), -- ANTI OVARIJALNA AT 20,00 eur
('spermatozoa-antibodies-asa', 35.00, NULL), -- ANTI SPERMATOZOIDNA AT 35,00 eur
('iga', 5.00, NULL), -- IMUNOGLOBIN A 5,00 eur
('igm', 5.00, NULL), -- IMUNOGLOBIN M 5,00 eur
('igg', 11.00, NULL), -- IMUNOGLOBIN G 11,00 eur
('c3-complement', 5.00, NULL), -- C-3 5,00 eur
('c4-complement', 5.00, NULL), -- C-4 5,00 eur
-- ── testovi na psihoaktivne supstance ─────────────────────────────────────
('drug-panel-10-ii', 40.00, NULL), -- KOMPLET TESTOVA SE RADI PO CIJENI OD 40,00 eur (KOKAIN, AMFETAMIN, METAMFETAMIN, MARIHUANA, METADON, OPIJATI (OPI), MDMA, BARBITURATI, BENZODIAZEPINI, OPIJATI (MOP)) — «od»: в clinic_lab_tests нет price_min, записано 40
('drug-panel-5-new', 25.00, NULL), -- PALETA OD 5(PET) ANALIZA 25,00 eur
-- ── ginekologija ──────────────────────────────────────────────────────────
('hpv-genotyping-pcr', 120.00, NULL), -- HPV TIPIZACIJA 120,00 eur
('cervical-swab-bacteria', 15.00, NULL), -- CERVIKALNI BRIS NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('cervical-swab-fungi', 15.00, NULL), -- CERVIKALNI BRIS NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('vaginal-swab-bacteria', 15.00, NULL), -- VAGINALNI BRIS NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('vaginal-swab-fungi', 15.00, NULL), -- VAGINALNI BRIS NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('vaginal-discharge-dmp', 10.00, NULL), -- STEPEN ČISTOĆE 10,00 eur
('amine-test', 8.00, NULL), -- AMINSKI TEST 8,00 eur
('chlamydia-genital-swab', 25.00, NULL), -- CERVIKALNI BRIS NA HLAMIDIJU 25,00 eur
('mycoplasma-ureaplasma-genital-swab', 25.00, NULL), -- CERVIKALNI BRIS NA UREAPLAZMU I MIKOPLAZMU 25,00 eur
('pap-papanicolaou-test', 17.00, NULL), -- PAPA BRIS 17,00 eur
('vulvar-swab-bacteria', 15.00, NULL), -- BRIS SPOLJNIH GENITALIJA 15,00 eur
('histopathology-curettage', 50.00, NULL), -- + ph nalaz 50,00 eur (к EKSPLORATIVNA KIRETAŽA в общей и в местной анестезии)
('histopathology-conization-specimen', 50.00, NULL), -- + ph nalaz 50,00 eur (к KONIZACIJA GRLIĆA MATERICE в общей/местной анестезии и LOOP EKSCIZIJA)
('histopathology-cervical-biopsy', 50.00, NULL), -- + ph nalaz 50,00 eur (к BIOPSIJA GRLIĆA MATERICE)
-- ── hirurgija ─────────────────────────────────────────────────────────────
('histopathology-standard-skin-and-organ-biopsy', 30.00, NULL), -- PH Nalaz 30,00 eur (блок хирурга, после INTERVENCIJA UKLANJANJE MASNOG TKIVA)
-- ── orl ───────────────────────────────────────────────────────────────────
('throat-swab-bacteria', 15.00, NULL), -- BRIS GRLA A BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('throat-swab-fungi', 15.00, NULL), -- BRIS GRLA A BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('ear-swab-bacteria', 15.00, NULL), -- BRIS UHA NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('ear-swab-fungi', 15.00, NULL), -- BRIS UHA NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('nose-swab-bacteria', 15.00, NULL), -- BRIS NOSA NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('nose-swab-fungi', 15.00, NULL), -- BRIS NOSA NA BAKTERIJE I GLJIVICE 15,00 eur (одна цена на пару)
('eye-swab-bacteria', 15.00, NULL); -- BRIS OKA 15,00 eur

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_test FROM tmp_feniks_lab t
LEFT JOIN lab_tests lt ON lt.slug = t.slug WHERE lt.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, lt.id, t.price, t.price_max, NULL
FROM tmp_feniks_lab t
JOIN lab_tests lt ON lt.slug = t.slug
ON DUPLICATE KEY UPDATE price = VALUES(price), price_max = VALUES(price_max);

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests lt ON lt.id = clt.lab_test_id
LEFT JOIN tmp_feniks_lab t ON t.slug = lt.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 144 услуг, с ценой 143.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 154 анализов, с ценой 153.
SELECT COUNT(*) AS lab_tests_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

-- Ожидается 17 новых записей каталога, у каждой категория.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties sp WHERE sp.medical_service_id = ms.id) AS specs
FROM medical_services ms WHERE ms.slug IN ('trigger-point-injection', 'bursa-or-cyst-puncture-with-drug-infiltration', 'blood-pressure-and-bmi-measurement', 'expert-gynecological-ultrasound', 'tonsil-lavage', 'sinus-lavage', 'pulmonologist-examination-with-chest-x-ray', 'pulmonologist-examination-with-chest-x-ray-and-spirometry', 'pulmonologist-examination-with-spirometry', 'pulmonologist-examination-with-x-ray-reading', 'expert-breast-ultrasound', 'systematic-examination-for-women-type-a', 'systematic-examination-for-women-type-b', 'systematic-examination-for-men', 'intramuscular-injection-home-visit', 'infusion-therapy-home-visit', 'urinary-catheter-placement-home-visit');

DROP TEMPORARY TABLE IF EXISTS tmp_feniks_services;
DROP TEMPORARY TABLE IF EXISTS tmp_feniks_lab;

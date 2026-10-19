-- ═══════════════════════════════════════════════════════════════════════════
-- Ginekološka ordinacija Vita Feminae (Dobrota, Kotor) — услуги и анализы
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ginekoloska-ordinacija-vita-feminae-kotor-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ginekoloska-ordinacija-vita-feminae-kotor.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/ginekoloska-ordinacija-vita-feminae-kotor.json.
-- 
-- Услуг: 12, анализов: 1, с ценой: 0 (на сайте цен нет). 7 блоков «Naše usluge» раскрыты до записей каталога.
-- Новые записи каталога: menopause-consultation, infertility-consultation — общие для порции V (Filia, Kavarić Medical),
-- создаются идемпотентно в каждом services-SQL; список — data/clinic-imports/_wave2d-new-catalog-V.json. is_price_outdated не ставится.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги/анализы прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJs2drV3kzTBMRGL56vSwCVSQ' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ginekoloska-ordinacija-vita-feminae-kotor' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ginekoloska-ordinacija-vita-feminae-kotor.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Vita Feminae: «Menopauza — Ublažavanje tegoba menopauzalnog perioda»; Filia: «Menopauza – hormonska supstituciona terapija (HRT)». Записи о менопаузе/HRT в каталоге нет ни под одним названием (поиск menopaus|climacter|hormone replacement — пусто). Общая услуга гинекологических кабинетов. Категория 7 GYNECOLOGY, специальность 5. HRT — синонимом, не отдельной записью.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'menopause-consultation', 'Menopause Consultation', 'Konsultacija o menopauzi', 'Консултација о менопаузи',
	'Консультация по менопаузе', 'Beratung zu den Wechseljahren', 'Menopoz danışmanlığı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'menopause-consultation' OR name_en = 'Menopause Consultation');

-- Vita Feminae: «Bračna neplodnost — Folikulometrija, priprema za IVF …»; Filia: «Ispitivanje i liječenje steriliteta»; Kavarić Medical: «Dijagnostika i liječenje steriliteta (kod žena i muškaraca)». В каталоге только fertility-couple-subspecialist-examination (субспециалистический осмотр пары, тариф уровня субспециалиста) и психологическое консультирование при бесплодии — консультации специалиста по бесплодию нет. Категория 7, специальности 5 + 38 REPRODUCTIVE_MEDICINE.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'infertility-consultation', 'Infertility Consultation', 'Konsultacija o neplodnosti', 'Консултација о неплодности',
	'Консультация по бесплодию', 'Kinderwunschberatung', 'İnfertilite danışmanlığı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'infertility-consultation' OR name_en = 'Infertility Consultation');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('menopause-consultation', 'infertility-consultation');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('menopause-consultation', 'infertility-consultation');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 38 FROM medical_services WHERE slug IN ('infertility-consultation');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Menopauza', 'sr' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Менопауза', 'sr-cyrl' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Климакс', 'ru' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Hormonska supstituciona terapija', 'sr' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Хормонска супституциона терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Hormone Replacement Therapy', 'en' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Заместительная гормональная терапия', 'ru' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Hormonersatztherapie', 'de' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Hormon replasman tedavisi', 'tr' FROM medical_services WHERE slug = 'menopause-consultation'
UNION ALL SELECT id, 'Bračna neplodnost', 'sr' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Брачна неплодност', 'sr-cyrl' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Sterilitet', 'sr' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Стерилитет', 'sr-cyrl' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Priprema za IVF', 'sr' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Припрема за IVF', 'sr-cyrl' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Fertility Consultation', 'en' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'IVF Preparation', 'en' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Лечение бесплодия', 'ru' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Подготовка к ЭКО', 'ru' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Unfruchtbarkeit', 'de' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, 'Kısırlık danışmanlığı', 'tr' FROM medical_services WHERE slug = 'infertility-consultation'
UNION ALL SELECT id, '3D ultrazvuk', 'sr' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D ултразвук', 'sr-cyrl' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D Ultrasound', 'en' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, 'УЗИ 3D', 'ru' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, 'УЗИ 3D/4D', 'ru' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D-Ultraschall', 'de' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D ultrason', 'tr' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, 'Videokolposkopija', 'sr' FROM medical_services WHERE slug = 'video-colposcopy'
UNION ALL SELECT id, 'Видеокольпоскопия', 'ru' FROM medical_services WHERE slug = 'video-colposcopy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_ginekoloska_ordinacija_vita_feminae_kotor;
CREATE TEMPORARY TABLE tmp_ginekoloska_ordinacija_vita_feminae_kotor (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ginekoloska_ordinacija_vita_feminae_kotor (slug, price, price_min, price_max) VALUES
('gynecological-specialist-examination', NULL, NULL, NULL), -- EN: «Consultations and examinations are performed by Med. Dr. Predrag Đurović, Specialist in Gynecology and Obstetrics», «pružamo usluge iz svih oblasti ginekologije i akušerstva»
('pregnancy-specialist-examination', NULL, NULL, NULL), -- «Kontrola trudnoće — Praćenje trudnoće i savjetovanje tokom svih njenih faza»
('gynecological-ultrasound', NULL, NULL, NULL), -- «Ultrazvučna dijagnostika — Detaljni ultrazvučni pregledi savremenom opremom (2D,3D,4D)»
('pregnancy-ultrasound', NULL, NULL, NULL), -- «Ultrazvučna dijagnostika … (2D,3D,4D)» + «Kontrola trudnoće»
('4d-pregnancy-ultrasound', NULL, NULL, NULL), -- «… (2D,3D,4D)» — 3D/4D УЗИ, запись каталога «4D ultrazvuk», синоним «3D ultrazvuk» добавлен
('video-colposcopy', NULL, NULL, NULL), -- «Rano otkrivanje premalignih bolesti — Video kolposkopija, …» — метод «video» сохранён (есть отдельная запись)
('pap-test-with-smear-collection', NULL, NULL, NULL), -- «… Papanicolau test, …» — взятие мазка в кабинете (услуга, цитология — в лаборатории)
('contraception-consultation', NULL, NULL, NULL), -- «Kontracepcija — Savjetovanje i propisivanje kontracepcije»
('menopause-consultation', NULL, NULL, NULL), -- «Menopauza — Ublažavanje tegoba menopauzalnog perioda»
('std-testing-package', NULL, NULL, NULL), -- «Polno prenosive bolesti — Dijagnostika i liječenje polno prenosivih infekcija» (как у ana-medica-podgorica)
('folliculometry', NULL, NULL, NULL), -- «Bračna neplodnost — Folikulometrija, …»
('infertility-consultation', NULL, NULL, NULL); -- «Bračna neplodnost — …, priprema za IVF u koordinaciji sa poznatim Evropskim IVF centrima»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_ginekoloska_ordinacija_vita_feminae_kotor t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_ginekoloska_ordinacija_vita_feminae_kotor t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_ginekoloska_ordinacija_vita_feminae_kotor t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 1b: АНАЛИЗЫ КЛИНИКИ (clinic_lab_tests, цены NULL): 1
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_ginekoloska_ordinacija_vita_feminae_kotor_lab;
CREATE TEMPORARY TABLE tmp_ginekoloska_ordinacija_vita_feminae_kotor_lab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ginekoloska_ordinacija_vita_feminae_kotor_lab (slug, price) VALUES
('hpv-genotyping-pcr', NULL); -- «… HPV genotipizacija» — запись «Genotipizacija HPV - PCR» (генотипирование = ПЦР-метод, анализ по правилам CLINIC_SERVICES_IMPORT)

-- Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_test
FROM tmp_ginekoloska_ordinacija_vita_feminae_kotor_lab t
LEFT JOIN lab_tests l ON l.slug = t.slug
WHERE l.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, l.id, t.price, NULL, NULL
FROM lab_tests l
JOIN tmp_ginekoloska_ordinacija_vita_feminae_kotor_lab t ON t.slug = l.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_max = NULL;

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
LEFT JOIN tmp_ginekoloska_ordinacija_vita_feminae_kotor_lab t ON t.slug = l.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 3
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_ginekoloska_ordinacija_vita_feminae_kotor_ds;
CREATE TEMPORARY TABLE tmp_ginekoloska_ordinacija_vita_feminae_kotor_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ginekoloska_ordinacija_vita_feminae_kotor_ds (doctor_slug, service_slug) VALUES
('predrag-djurovic', 'gynecological-specialist-examination'), -- «Consultations and examinations are performed by Med. Dr. Predrag Đurović»
('predrag-djurovic', 'pregnancy-specialist-examination'), -- основной врач кабинета, ведение беременности (отзывы)
('antonia-mihaljevic', 'gynecological-specialist-examination'); -- гостующий гинеколог, отдельная запись по телефону

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_ginekoloska_ordinacija_vita_feminae_kotor_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_ginekoloska_ordinacija_vita_feminae_kotor_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 12 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 3 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 2: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('menopause-consultation', 'infertility-consultation');

-- Ожидается 1 анализов, с ценой 0.
SELECT COUNT(*) AS lab_tests_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

SELECT l.slug, l.name_en, clt.price
FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
WHERE clt.clinic_id = @clinic_id
ORDER BY l.name_en;

DROP TEMPORARY TABLE IF EXISTS tmp_ginekoloska_ordinacija_vita_feminae_kotor;
DROP TEMPORARY TABLE IF EXISTS tmp_ginekoloska_ordinacija_vita_feminae_kotor_ds;
DROP TEMPORARY TABLE IF EXISTS tmp_ginekoloska_ordinacija_vita_feminae_kotor_lab;

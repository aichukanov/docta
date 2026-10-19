-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Kavarić Medical (Podgorica) — услуги и анализы
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-kavaric-medical-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-kavaric-medical-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/kavaric-medical-podgorica.json.
-- 
-- Услуг: 31, анализов: 2, с ценой: 0 (цен нет). Источник — 16 пунктов usluge.html (© 2016 — перечень мог устареть).
-- Новые записи каталога: infertility-consultation (общая с Vita Feminae / Filia), in-vitro-fertilization-ivf, dorsal-slit-of-the-foreskin,
-- female-stress-urinary-incontinence-treatment — идемпотентно по slug. Удаление кондилом не заводится (метод не назван, кандидатов несколько; решение координатора 2026-10-09).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги/анализы прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJt_kc5UjrTRMROG5wvBFbn8w' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'kavaric-medical-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-kavaric-medical-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Vita Feminae: «Bračna neplodnost — Folikulometrija, priprema za IVF …»; Filia: «Ispitivanje i liječenje steriliteta»; Kavarić Medical: «Dijagnostika i liječenje steriliteta (kod žena i muškaraca)». В каталоге только fertility-couple-subspecialist-examination (субспециалистический осмотр пары, тариф уровня субспециалиста) и психологическое консультирование при бесплодии — консультации специалиста по бесплодию нет. Категория 7, специальности 5 + 38 REPRODUCTIVE_MEDICINE.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'infertility-consultation', 'Infertility Consultation', 'Konsultacija o neplodnosti', 'Консултација о неплодности',
	'Консультация по бесплодию', 'Kinderwunschberatung', 'İnfertilite danışmanlığı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'infertility-consultation' OR name_en = 'Infertility Consultation');

-- Kavarić Medical: «IUI i IVF»; dr Vesna Globarević Kavarić «… procedurama asistirane reproduktivne tehnologije, kao što su inseminacija i vantjelesna oplodnja». Общей записи «ЭКО» в каталоге нет — только этапы больничного тарифа (follicle-aspiration, embryo-transfer, ivf-laboratory-procedure, ivf-anesthesia), а у IVF-центров (in-vitro-podgorica и др.) услуги ЭКО не заведены. Категория 7, специальности 5 + 38.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'in-vitro-fertilization-ivf', 'In Vitro Fertilization (IVF)', 'Vantjelesna oplodnja (IVF)', 'Вантјелесна оплодња (IVF)',
	'Экстракорпоральное оплодотворение (ЭКО)', 'In-vitro-Fertilisation (IVF)', 'Tüp bebek tedavisi (IVF)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'in-vitro-fertilization-ivf' OR name_en = 'In Vitro Fertilization (IVF)');

-- Kavarić Medical: «Cirkumcizija + dorzalna incizija». Дорсального рассечения крайней плоти в каталоге нет (есть только циркумцизия трёх видов анестезии и репозиция парафимоза). Категория 22 UROLOGY, специальность 9.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dorsal-slit-of-the-foreskin', 'Dorsal Slit of the Foreskin', 'Dorzalna incizija prepucijuma', 'Дорзална инцизија препуцијума',
	'Дорсальное рассечение крайней плоти', 'Dorsale Inzision der Vorhaut', 'Sünnet derisine dorsal kesi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dorsal-slit-of-the-foreskin' OR name_en = 'Dorsal Slit of the Foreskin');

-- Kavarić Medical: «Liječenje nekontrolisanog mokrenja kod žena (stresne inkontinencije)» — метод не назван. В каталоге только хирургия: transvaginal-incontinence-correction-tottvt-tape (TOT/TVT) и male-incontinence-correction — приписывать операцию нельзя. Категории 22 UROLOGY + 7 GYNECOLOGY, специальности 9 + 5.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'female-stress-urinary-incontinence-treatment', 'Female Stress Urinary Incontinence Treatment', 'Liječenje stresne urinarne inkontinencije kod žena', 'Лијечење стресне уринарне инконтиненције код жена',
	'Лечение стрессового недержания мочи у женщин', 'Behandlung der Belastungsinkontinenz bei Frauen', 'Kadınlarda stres üriner inkontinans tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment' OR name_en = 'Female Stress Urinary Incontinence Treatment');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('infertility-consultation', 'in-vitro-fertilization-ivf', 'female-stress-urinary-incontinence-treatment');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 22 FROM medical_services WHERE slug IN ('dorsal-slit-of-the-foreskin', 'female-stress-urinary-incontinence-treatment');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('infertility-consultation', 'in-vitro-fertilization-ivf', 'female-stress-urinary-incontinence-treatment');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 9 FROM medical_services WHERE slug IN ('dorsal-slit-of-the-foreskin', 'female-stress-urinary-incontinence-treatment');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 38 FROM medical_services WHERE slug IN ('infertility-consultation', 'in-vitro-fertilization-ivf');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Bračna neplodnost', 'sr' FROM medical_services WHERE slug = 'infertility-consultation'
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
UNION ALL SELECT id, 'VTO', 'sr' FROM medical_services WHERE slug = 'in-vitro-fertilization-ivf'
UNION ALL SELECT id, 'ВТО', 'sr-cyrl' FROM medical_services WHERE slug = 'in-vitro-fertilization-ivf'
UNION ALL SELECT id, 'Künstliche Befruchtung', 'de' FROM medical_services WHERE slug = 'in-vitro-fertilization-ivf'
UNION ALL SELECT id, 'Dorzalna incizija', 'sr' FROM medical_services WHERE slug = 'dorsal-slit-of-the-foreskin'
UNION ALL SELECT id, 'Дорзална инцизија', 'sr-cyrl' FROM medical_services WHERE slug = 'dorsal-slit-of-the-foreskin'
UNION ALL SELECT id, 'Dorsal Incision', 'en' FROM medical_services WHERE slug = 'dorsal-slit-of-the-foreskin'
UNION ALL SELECT id, 'Nekontrolisano mokrenje', 'sr' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, 'Неконтролисано мокрење', 'sr-cyrl' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, 'Stresna inkontinencija', 'sr' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, 'Стресна инконтиненција', 'sr-cyrl' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, 'Недержание мочи', 'ru' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, 'Stress Incontinence', 'en' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, 'Harninkontinenz', 'de' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, 'İdrar kaçırma', 'tr' FROM medical_services WHERE slug = 'female-stress-urinary-incontinence-treatment'
UNION ALL SELECT id, '3D ultrazvuk', 'sr' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D ултразвук', 'sr-cyrl' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D Ultrasound', 'en' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, 'УЗИ 3D', 'ru' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D-Ultraschall', 'de' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, '3D ultrason', 'tr' FROM medical_services WHERE slug = '4d-pregnancy-ultrasound'
UNION ALL SELECT id, 'Bužiranje uretre', 'sr' FROM medical_services WHERE slug = 'urethral-stricture-dilatation'
UNION ALL SELECT id, 'Бужирање уретре', 'sr-cyrl' FROM medical_services WHERE slug = 'urethral-stricture-dilatation'
UNION ALL SELECT id, 'Бужирование уретры', 'ru' FROM medical_services WHERE slug = 'urethral-stricture-dilatation'
UNION ALL SELECT id, 'Urethral Bougienage', 'en' FROM medical_services WHERE slug = 'urethral-stricture-dilatation'
UNION ALL SELECT id, 'HPV bris', 'sr' FROM medical_services WHERE slug = 'hpv-test'
UNION ALL SELECT id, 'HPV брис', 'sr-cyrl' FROM medical_services WHERE slug = 'hpv-test'
UNION ALL SELECT id, 'Мазок на ВПЧ', 'ru' FROM medical_services WHERE slug = 'hpv-test'
UNION ALL SELECT id, 'HPV Swab', 'en' FROM medical_services WHERE slug = 'hpv-test';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_kavaric_medical_podgorica;
CREATE TEMPORARY TABLE tmp_kavaric_medical_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_kavaric_medical_podgorica (slug, price, price_min, price_max) VALUES
('gynecological-specialist-examination', NULL, NULL, NULL), -- «Ginekološki i urološki pregledi»
('urologist-examination', NULL, NULL, NULL), -- «Ginekološki i urološki pregledi»
('gynecological-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk u ginekologiji i urologiji»
('urinary-tract-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk u ginekologiji i urologiji»
('pregnancy-ultrasound', NULL, NULL, NULL), -- «Ultrazvuk i pregledi u trudnoći, CTG»
('pregnancy-specialist-examination', NULL, NULL, NULL), -- «Ultrazvuk i pregledi u trudnoći, …»
('ctg-fetal-monitoring', NULL, NULL, NULL), -- «… CTG»
('4d-pregnancy-ultrasound', NULL, NULL, NULL), -- «3D UZ, …» — отдельной 3D-записи нет, запись «4D ultrazvuk» (синоним «3D ultrazvuk» ставит Vita Feminae-SQL и этот файл)
('pelvic-color-doppler', NULL, NULL, NULL), -- «… Color doppler, …» (в строке с 3D UZ и folikulometrijom — гинекологический допплер малого таза)
('folliculometry', NULL, NULL, NULL), -- «… folikulometrija»
('std-testing-package', NULL, NULL, NULL), -- «Dijagnostika i liječenje urogenitalnih infekcija …» (как ana-medica «Polno prenosive bolesti»)
('pap-test-with-smear-collection', NULL, NULL, NULL), -- «Rana dijagnostika premalignih i malignih lezija na grliću materice (PAPA bris, …)»
('hpv-test', NULL, NULL, NULL), -- «(… HPV brisevi, …)» — метод не назван, запись услуги «HPV test» (взятие мазка), не ПЦР-анализ
('colposcopy', NULL, NULL, NULL), -- «(… kolposkopija, …)»
('cervical-biopsy', NULL, NULL, NULL), -- «(… biopsija)» — в контексте грлића материце
('cervical-or-uterine-polypectomy', NULL, NULL, NULL), -- «Ginekološke intervencije: polipi, …»
('exploratory-curettage', NULL, NULL, NULL), -- «… curettage expl.»
('iud-insertion', NULL, NULL, NULL), -- «Ugradnja / skidanje spirale i kontracepcija»
('iud-removal', NULL, NULL, NULL), -- «Ugradnja / skidanje spirale …»
('contraception-consultation', NULL, NULL, NULL), -- «… i kontracepcija»
('infertility-consultation', NULL, NULL, NULL), -- «Dijagnostika i liječenje steriliteta (kod žena i muškaraca)»
('intrauterine-insemination-iui', NULL, NULL, NULL), -- «IUI i IVF»
('in-vitro-fertilization-ivf', NULL, NULL, NULL), -- «IUI i IVF», dr Vesna: «… inseminacija i vantjelesna oplodnja»
('cystoscopy-male', NULL, NULL, NULL), -- «Cistoskopije, …» — пол не указан → обе записи
('cystoscopy-female', NULL, NULL, NULL), -- «Cistoskopije, …»
('urethral-stricture-dilatation', NULL, NULL, NULL), -- «…, bužiranje» (бужирование уретры = дилатация стриктуры уретры, синоним добавлен)
('circumcision-local-anesthesia', NULL, NULL, NULL), -- «Cirkumcizija + …» — анестезия не названа, амбулаторный кабинет → вариант под местной анестезией (спинальной/общей у кабинета нет)
('dorsal-slit-of-the-foreskin', NULL, NULL, NULL), -- «… + dorzalna incizija»
('trus-guided-prostate-biopsy', NULL, NULL, NULL), -- «Rana dijagnostika Carcinoma prostate (TRUS biopsija prostate + PH)»
('urinary-catheter-placement', NULL, NULL, NULL), -- «Kateterizacija mokraćne bešike»
('female-stress-urinary-incontinence-treatment', NULL, NULL, NULL); -- «Liječenje nekontrolisanog mokrenja kod žena (stresne inkontinencije)»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_kavaric_medical_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_kavaric_medical_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_kavaric_medical_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 1b: АНАЛИЗЫ КЛИНИКИ (clinic_lab_tests, цены NULL): 2
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_kavaric_medical_podgorica_lab;
CREATE TEMPORARY TABLE tmp_kavaric_medical_podgorica_lab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_kavaric_medical_podgorica_lab (slug, price) VALUES
('spermogram', NULL), -- «spermogrami»
('histopathology-trus-prostate', NULL); -- «(TRUS biopsija prostate + PH)» — запись «PH TRUS prostate»

-- Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_test
FROM tmp_kavaric_medical_podgorica_lab t
LEFT JOIN lab_tests l ON l.slug = t.slug
WHERE l.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, l.id, t.price, NULL, NULL
FROM lab_tests l
JOIN tmp_kavaric_medical_podgorica_lab t ON t.slug = l.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_max = NULL;

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
LEFT JOIN tmp_kavaric_medical_podgorica_lab t ON t.slug = l.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 33
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_kavaric_medical_podgorica_ds;
CREATE TEMPORARY TABLE tmp_kavaric_medical_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_kavaric_medical_podgorica_ds (doctor_slug, service_slug) VALUES
('petar-kavaric', 'urologist-examination'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'urinary-tract-ultrasound'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'cystoscopy-male'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'cystoscopy-female'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'urethral-stricture-dilatation'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'circumcision-local-anesthesia'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'dorsal-slit-of-the-foreskin'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'trus-guided-prostate-biopsy'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'urinary-catheter-placement'), -- урологическая услуга → единственный уролог
('petar-kavaric', 'female-stress-urinary-incontinence-treatment'), -- урологический блок перечня (после катетеризации) → уролог
('petar-kavaric', 'std-testing-package'), -- урогенитальные инфекции — у обоих (уролог и гинеколог)
('petar-kavaric', 'infertility-consultation'), -- стерилитет «kod žena i muškaraca» — у обоих
('vesna-globarevic-kavaric', 'gynecological-specialist-examination'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'gynecological-ultrasound'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'pregnancy-ultrasound'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'pregnancy-specialist-examination'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'ctg-fetal-monitoring'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', '4d-pregnancy-ultrasound'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'pelvic-color-doppler'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'folliculometry'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'std-testing-package'), -- урогенитальные инфекции — у обоих (уролог и гинеколог)
('vesna-globarevic-kavaric', 'pap-test-with-smear-collection'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'hpv-test'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'colposcopy'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'cervical-biopsy'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'cervical-or-uterine-polypectomy'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'exploratory-curettage'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'iud-insertion'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'iud-removal'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'contraception-consultation'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'infertility-consultation'), -- стерилитет «kod žena i muškaraca» — у обоих
('vesna-globarevic-kavaric', 'intrauterine-insemination-iui'), -- гинекологическая услуга → единственный гинеколог
('vesna-globarevic-kavaric', 'in-vitro-fertilization-ivf'); -- гинекологическая услуга → единственный гинеколог

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_kavaric_medical_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_kavaric_medical_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 31 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 33 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 4: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('infertility-consultation', 'in-vitro-fertilization-ivf', 'dorsal-slit-of-the-foreskin', 'female-stress-urinary-incontinence-treatment');

-- Ожидается 2 анализов, с ценой 0.
SELECT COUNT(*) AS lab_tests_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

SELECT l.slug, l.name_en, clt.price
FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
WHERE clt.clinic_id = @clinic_id
ORDER BY l.name_en;

DROP TEMPORARY TABLE IF EXISTS tmp_kavaric_medical_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_kavaric_medical_podgorica_ds;
DROP TEMPORARY TABLE IF EXISTS tmp_kavaric_medical_podgorica_lab;

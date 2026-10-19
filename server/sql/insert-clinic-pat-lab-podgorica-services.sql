-- ═══════════════════════════════════════════════════════════════════════════
-- PZU Pat Lab (Podgorica) — услуги и анализы
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-pat-lab-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-pat-lab-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/pat-lab-podgorica.json.
-- 
-- Услуг: 3 (психиатрия), анализов: 4 (патогистология/цитология), с ценой: 0 (цен нет). Новых записей каталога нет.
-- Деление по правилам CLINIC_SERVICES_IMPORT: PAPA-цитология, ПГ биопсии, ИГХ — анализы (clinic_lab_tests, как у in-vitro-*/Moj Lab);
-- психиатрические приёмы — услуги. «Molekularne analize» без конкретных мутаций — не заведены (excluded).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги/анализы прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ7wtduerrTRMRbP8KNitEJW4' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'pat-lab-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-pat-lab-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_pat_lab_podgorica;
CREATE TEMPORARY TABLE tmp_pat_lab_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_pat_lab_podgorica (slug, price, price_min, price_max) VALUES
('first-psychiatrist-examination', NULL, NULL, NULL), -- Usluge iz oblasti psihijatrije: «psihijatrijska ambulanta nudi stručne konsultacije, …» (взрослые — dr Tijana Brandmajer, «Psihijatar»)
('child-psychiatrist-examination', NULL, NULL, NULL), -- «… planiramo i odraslima i djeci pružiti visoko kvalitetnu uslugu», «Dr. Ivan Krgović — Dječiji psihijatar»
('individual-supportive-psychotherapy-and-counseling', NULL, NULL, NULL); -- «… terapijske sesije i podršku pacijentima» — запись «Površna individualna psihoterapija, savjetovanje» (психиатрическая, спец. 21)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_pat_lab_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_pat_lab_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_pat_lab_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 1b: АНАЛИЗЫ КЛИНИКИ (clinic_lab_tests, цены NULL): 4
-- ═══════════════════════════════════════════════════════════════

-- Синонимы анализов: формулировки сайта к существующим записям (язык sr — и для латиницы, и для кириллицы).
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT id, 'Patohistološka analiza biopsije', 'sr' FROM lab_tests WHERE slug = 'histopathology-standard-skin-and-organ-biopsy'
UNION ALL SELECT id, 'Likvidni PAPA test', 'sr' FROM lab_tests WHERE slug = 'liquid-based-cytology'
UNION ALL SELECT id, 'PAPA test na tečnoj podlozi', 'sr' FROM lab_tests WHERE slug = 'liquid-based-cytology'
UNION ALL SELECT id, 'Imunohistohemijske analize', 'sr' FROM lab_tests WHERE slug = 'immunohistochemistry-per-antibody';

DROP TEMPORARY TABLE IF EXISTS tmp_pat_lab_podgorica_lab;
CREATE TEMPORARY TABLE tmp_pat_lab_podgorica_lab (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_pat_lab_podgorica_lab (slug, price) VALUES
('pap-papanicolaou-test', NULL), -- «PAPA test … Pored konvencionalnog PAPA testa, …» — цитология в лаборатории (анализ). Rezultat 24h – 48h
('liquid-based-cytology', NULL), -- «… PAPA test na tečnoj podlozi (likvidni PAPA test – ThinPrep)» (ThinPrep уже синоним записи)
('histopathology-standard-skin-and-organ-biopsy', NULL), -- «Patohistološka analiza biopsije … Analiza biopsija: 3-5 dana» — орган не назван, запись «PH standardne biopsije kože i drugih organa» (ближе всего к общей «биопсии», histopathology-standard-diagnostics / -other-biopsies — менее точные)
('immunohistochemistry-per-antibody', NULL); -- «Imunohistohemijske analize» — число антител не названо, базовая единица «Imunohistohemijska analiza po jednom antitijelu» (наборы 5–10 и >10 не заводили)

-- Ожидается ПУСТО.
SELECT t.slug AS unmatched_lab_test
FROM tmp_pat_lab_podgorica_lab t
LEFT JOIN lab_tests l ON l.slug = t.slug
WHERE l.id IS NULL;

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, l.id, t.price, NULL, NULL
FROM lab_tests l
JOIN tmp_pat_lab_podgorica_lab t ON t.slug = l.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_max = NULL;

DELETE clt FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
LEFT JOIN tmp_pat_lab_podgorica_lab t ON t.slug = l.slug
WHERE clt.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 4
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_pat_lab_podgorica_ds;
CREATE TEMPORARY TABLE tmp_pat_lab_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_pat_lab_podgorica_ds (doctor_slug, service_slug) VALUES
('tijana-brandmajer', 'first-psychiatrist-examination'), -- «Psihijatar» — взрослый приём
('tijana-brandmajer', 'individual-supportive-psychotherapy-and-counseling'), -- «terapijske sesije»
('ivan-krgovic', 'child-psychiatrist-examination'), -- «Dječiji psihijatar»
('ivan-krgovic', 'individual-supportive-psychotherapy-and-counseling'); -- «terapijske sesije»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_pat_lab_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_pat_lab_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 3 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 4 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 4 анализов, с ценой 0.
SELECT COUNT(*) AS lab_tests_total, SUM(price IS NOT NULL) AS with_price
FROM clinic_lab_tests WHERE clinic_id = @clinic_id;

SELECT l.slug, l.name_en, clt.price
FROM clinic_lab_tests clt
JOIN lab_tests l ON l.id = clt.lab_test_id
WHERE clt.clinic_id = @clinic_id
ORDER BY l.name_en;

DROP TEMPORARY TABLE IF EXISTS tmp_pat_lab_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_pat_lab_podgorica_ds;
DROP TEMPORARY TABLE IF EXISTS tmp_pat_lab_podgorica_lab;

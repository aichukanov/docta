SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Дополнение к update-clinics-2026-10-pricelist-map.sql (решения юзера 2026-10-02):
--   1. A3 Medical: вместо is_obsolete — is_price_outdated;
--   2. SmartMed Kotor: тип Polyclinic → Diagnostic Laboratory (филиал теперь только лаборатория).
--
-- ═══ 1. A3 Medical ═══
--
--
-- update-clinics-2026-10-pricelist-map.sql пометил 348 услуг + 3 анализа A3 как
-- is_obsolete: цены сняты с /me/pricelist/. Но услуги клиника по-прежнему
-- перечисляет (на той же странице, без цен) — is_obsolete убрал их из списков
-- клиники. Правильный флаг — «цена устарела» (+X% с подсказкой): позиция видна,
-- цена помечена как старая.
--
-- Тот же предикат, что и в исходной пометке: строки A3 с ценой, кроме 36 услуг и
-- PAP-теста, цены которых сайт ещё показывает на страницах специальностей.
-- До той пометки у A3 is_obsolete не было ни у одной строки — снимаем только свою.

SET @a3 = (SELECT id FROM clinics WHERE slug = 'a3-medical-sutomore');

UPDATE clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
SET cms.is_obsolete = 0, cms.is_price_outdated = 1
WHERE cms.clinic_id = @a3
	AND (cms.is_obsolete = 1 OR cms.is_price_outdated = 0)
	AND (cms.price IS NOT NULL OR cms.price_min IS NOT NULL OR cms.price_max IS NOT NULL)
	AND ms.slug NOT IN (
	'gynecological-specialist-examination',
	'follow-up-gynecological-examination',
	'gynecological-ultrasound',
	'expert-pregnancy-ultrasound',
	'pap-test-liquid-cytology',
	'colposcopy',
	'iud-insertion',
	'iud-removal',
	'cervical-biopsy',
	'vulvar-biopsy-under-local-anesthesia',
	'vaginal-biopsy-under-local-anesthesia',
	'cervical-polypectomy',
	'endometrial-polypectomy',
	'leep-excision-with-histopathology-under-local-anesthesia',
	'exploratory-fractional-curettage-under-local-anesthesia',
	'endocervical-curettage-ecc',
	'rcui-under-local-anesthesia',
	'ctg-fetal-monitoring',
	'condyloma-and-benign-growth-removal-vulva-vagina',
	'benign-growth-and-cyst-removal-vulva-vagina-under-sedation',
	'folliculometry',
	'hymenotomy',
	'pessary-insertion',
	'laparoscopic-oophorectomy',
	'laparoscopic-ovarian-cystectomy',
	'laparoscopic-salpingectomy',
	'laparoscopic-salpingo-oophorectomy',
	'vulvectomy',
	'cardiologist-examination',
	'follow-up-cardiologist-examination',
	'echocardiography-heart-ultrasound',
	'ergometry-stress-test',
	'holter-ecg-24h',
	'holter-blood-pressure-24h',
	'urological-ultrasound-male',
	'urological-ultrasound-female'
	);

UPDATE clinic_lab_tests clt
JOIN lab_tests lt ON lt.id = clt.lab_test_id
SET clt.is_obsolete = 0, clt.is_price_outdated = 1
WHERE clt.clinic_id = @a3
	AND (clt.is_obsolete = 1 OR clt.is_price_outdated = 0)
	AND (clt.price IS NOT NULL OR clt.price_max IS NOT NULL)
	AND lt.slug NOT IN ('pap-papanicolaou-test');

-- ═══ 2. SmartMed Kotor: только лаборатория ═══

SET @smk = (SELECT id FROM clinics WHERE slug = 'smartmed-kotor');
SET @t_lab = (SELECT id FROM clinic_types WHERE name = 'Diagnostic Laboratory');
INSERT IGNORE INTO clinic_clinic_types (clinic_id, clinic_type_id)
SELECT @smk, @t_lab FROM dual WHERE @smk IS NOT NULL AND @t_lab IS NOT NULL;
DELETE cct FROM clinic_clinic_types cct
JOIN clinic_types ct ON ct.id = cct.clinic_type_id
WHERE cct.clinic_id = @smk AND ct.name = 'Polyclinic' AND @t_lab IS NOT NULL;

-- ═══ VERIFICATION ═══

SELECT 'a3 services' AS what,
	SUM(is_obsolete = 1) AS obsolete,
	SUM(is_price_outdated = 1) AS outdated,
	SUM(is_obsolete = 0 AND is_price_outdated = 0 AND (price IS NOT NULL OR price_min IS NOT NULL)) AS fresh_priced
FROM clinic_medical_services WHERE clinic_id = @a3
UNION ALL
SELECT 'a3 lab tests', SUM(is_obsolete = 1), SUM(is_price_outdated = 1),
	SUM(is_obsolete = 0 AND is_price_outdated = 0 AND price IS NOT NULL)
FROM clinic_lab_tests WHERE clinic_id = @a3;
-- ожидание: services 0 / 348 / 36, lab tests 0 / 3 / 1

SELECT c.slug, GROUP_CONCAT(ct.name) AS types FROM clinics c
JOIN clinic_clinic_types cct ON cct.clinic_id = c.id
JOIN clinic_types ct ON ct.id = cct.clinic_type_id
WHERE c.slug = 'smartmed-kotor' GROUP BY c.slug;
-- ожидание: Diagnostic Laboratory

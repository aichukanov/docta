SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Правки по карте прайс-листов (data/clinic-pricelists/, проверка 2026-10-02).
-- Клиники и записи каталога — только по slug (id локально и на проде расходятся).
--
-- 1. A3 Medical: с /me/pricelist/ цены сняты (в Wayback 2026-05-14 было ~400,
--    сейчас только названия). Цены остались на страницах специальностей
--    /me/specialty/gynecology|cardiology|urology/ — 51 позиция; из них в нашей БД
--    36 услуг и 1 анализ (PAP test). Все остальные строки A3 с ценой →
--    is_obsolete = 1 (локально: 348 услуг + 3 анализа). Строки без цены не трогаем.
-- 2. ДЗ Котор: www.dzkotor.me припаркован у Sedo, сайт — domzdravljakotor.me.
-- 3. Buntić: montenegrodentistry.me продаётся, нового сайта нет → website = ''
--    (пустой сайт в clinics хранится как '', не NULL).
-- 4. SmartMed Kotor: теперь только лаборатория, врачей нет → отвязать всех врачей
--    (локально 19). Olivera Miketić после этого не привязана ни к одной клинике.

-- ═══ 1. A3 Medical: цены, которых больше нет на сайте ═══

SET @a3 = (SELECT id FROM clinics WHERE slug = 'a3-medical-sutomore');

UPDATE clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
SET cms.is_obsolete = 1
WHERE cms.clinic_id = @a3
	AND cms.is_obsolete = 0
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
SET clt.is_obsolete = 1
WHERE clt.clinic_id = @a3
	AND clt.is_obsolete = 0
	AND (clt.price IS NOT NULL OR clt.price_max IS NOT NULL)
	AND lt.slug NOT IN ('pap-papanicolaou-test');

-- ═══ 2. ДЗ Котор: новый сайт ═══

UPDATE clinics SET website = 'https://domzdravljakotor.me/'
WHERE slug = 'dom-zdravlja-kotor' AND website = 'www.dzkotor.me';

-- ═══ 3. Buntić: домен продаётся ═══

UPDATE clinics SET website = ''
WHERE slug = 'buntic-stomatoloska-ordinacija-bar' AND website = 'http://www.montenegrodentistry.me/';

-- ═══ 4. SmartMed Kotor: отвязать врачей ═══

DELETE dc FROM doctor_clinics dc
JOIN clinics c ON c.id = dc.clinic_id
WHERE c.slug = 'smartmed-kotor';

-- ═══ VERIFICATION ═══

SELECT 'a3 services' AS what,
	SUM(is_obsolete = 0 AND (price IS NOT NULL OR price_min IS NOT NULL)) AS active_priced,
	SUM(is_obsolete = 1) AS obsolete
FROM clinic_medical_services WHERE clinic_id = @a3
UNION ALL
SELECT 'a3 lab tests', SUM(is_obsolete = 0 AND price IS NOT NULL), SUM(is_obsolete = 1)
FROM clinic_lab_tests WHERE clinic_id = @a3;
-- ожидание (локально): services 36 / 348, lab tests 1 / 3

SELECT slug, website FROM clinics
WHERE slug IN ('dom-zdravlja-kotor', 'buntic-stomatoloska-ordinacija-bar');

SELECT COUNT(*) AS smartmed_kotor_doctors FROM doctor_clinics dc
JOIN clinics c ON c.id = dc.clinic_id WHERE c.slug = 'smartmed-kotor';
-- ожидание: 0

SELECT d.slug AS doctors_without_clinic FROM doctors d
WHERE d.slug IN ('olivera-miketic')
	AND NOT EXISTS (SELECT 1 FROM doctor_clinics dc WHERE dc.doctor_id = d.id);

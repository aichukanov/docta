-- ═══════════════════════════════════════════════════════════════════════════
-- SeaStars edukativni centar (Herceg Novi) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-seastars-herceg-novi-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-seastars-herceg-novi.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/seastars-herceg-novi.json.
-- 
-- Услуг: 10, с ценой: 0 (цен на сайте нет). Новые записи каталога (4): dynamic-neuromuscular-stabilization, vojta-therapy, bobath-therapy, infant-massage —
-- дублируются в data/clinic-imports/_wave2d-new-catalog-U.json (dynamic-neuromuscular-stabilization — также в insert-clinic-fizio-tim-podgorica-services.sql).
-- is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJL79BQtA7TBMRcOIzlP2p4sA' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'seastars-herceg-novi' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-seastars-herceg-novi.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Именная методика (Пражская школа, DNS): SeaStars /tretmani «Dinamička neuromuskularna stabilizacija», Fizio Tim /kineziterapija «DNS (Dinamička neuromuskularna stabilizacija)». В каталоге записи нет (kinesiotherapy — общая ЛФК, PNF заведён синонимом к ней, но DNS — отдельный метод, сайты называют его отдельно). Кат. 5 PHYSIOTHERAPY, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dynamic-neuromuscular-stabilization', 'Dynamic Neuromuscular Stabilization', 'Dinamička neuromuskularna stabilizacija', 'Динамичка неуромускуларна стабилизација',
	'Динамическая нейромышечная стабилизация (DNS)', 'Dynamische neuromuskuläre Stabilisation (DNS)', 'Dinamik nöromüsküler stabilizasyon (DNS)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization' OR name_en = 'Dynamic Neuromuscular Stabilization');

-- Именная методика: seastarscentar.me /tretmani «Vojta metoda je refleksna lokomotorna tehnika koja stimuliše urođene motoričke reakcije». В каталоге нет; cns-sensorimotor-development-stimulation («specifične metode», FZOCG) — зонтик без названия метода, бренд/метод не теряем. Кат. 5, спец. 42 (применяется и у взрослых, педиатрию не ставим).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'vojta-therapy', 'Vojta Therapy', 'Vojta metoda', 'Војта метода',
	'Войта-терапия', 'Vojta-Therapie', 'Vojta terapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'vojta-therapy' OR name_en = 'Vojta Therapy');

-- Именная методика: seastarscentar.me /tretmani «Bobath koncept integriše specifične senzomotorne stimulacije». В каталоге нет (см. vojta-therapy — тот же довод). Кат. 5, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'bobath-therapy', 'Bobath Therapy', 'Bobath koncept', 'Бобатх концепт',
	'Бобат-терапия', 'Bobath-Therapie', 'Bobath terapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'bobath-therapy' OR name_en = 'Bobath Therapy');

-- seastarscentar.me /tretmani «Masaža za bebe koristi nežne, strukturirane taktilne stimulacije koje podržavaju sazrevanje nervnog sistema». Массажа для младенцев в каталоге нет. Кат. 5 + 25 PEDIATRICS (как high-risk-infant-stimulation-exercises), спец. 42 + 4 (авто).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'infant-massage', 'Infant Massage', 'Masaža za bebe', 'Масажа за бебе',
	'Массаж для младенцев', 'Babymassage', 'Bebek masajı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'infant-massage' OR name_en = 'Infant Massage');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('dynamic-neuromuscular-stabilization', 'vojta-therapy', 'bobath-therapy', 'infant-massage');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 25 FROM medical_services WHERE slug IN ('infant-massage');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('infant-massage');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN ('dynamic-neuromuscular-stabilization', 'vojta-therapy', 'bobath-therapy', 'infant-massage');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'DNS', 'en' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'DNS', 'sr' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'DNS', 'ru' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Динамичка неуромускуларна стабилизација', 'sr-cyrl' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Dinamička neuromišićna stabilizacija', 'sr' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Prague School of Rehabilitation', 'en' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Vojta', 'en' FROM medical_services WHERE slug = 'vojta-therapy'
UNION ALL SELECT id, 'Vojta terapija', 'sr' FROM medical_services WHERE slug = 'vojta-therapy'
UNION ALL SELECT id, 'Војта метода', 'sr-cyrl' FROM medical_services WHERE slug = 'vojta-therapy'
UNION ALL SELECT id, 'Војта терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'vojta-therapy'
UNION ALL SELECT id, 'Refleksna lokomocija', 'sr' FROM medical_services WHERE slug = 'vojta-therapy'
UNION ALL SELECT id, 'Reflex Locomotion', 'en' FROM medical_services WHERE slug = 'vojta-therapy'
UNION ALL SELECT id, 'Метод Войта', 'ru' FROM medical_services WHERE slug = 'vojta-therapy'
UNION ALL SELECT id, 'Bobath', 'en' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Bobath Concept', 'en' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'NDT', 'en' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Neurodevelopmental Treatment', 'en' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Bobath terapija', 'sr' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Neurorazvojni tretman', 'sr' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Bobath концепт', 'sr-cyrl' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Неуроразвојни третман', 'sr-cyrl' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Бобат-концепция', 'ru' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Bobath-Konzept', 'de' FROM medical_services WHERE slug = 'bobath-therapy'
UNION ALL SELECT id, 'Baby Massage', 'en' FROM medical_services WHERE slug = 'infant-massage'
UNION ALL SELECT id, 'Masaža beba', 'sr' FROM medical_services WHERE slug = 'infant-massage'
UNION ALL SELECT id, 'Масажа за бебе', 'sr-cyrl' FROM medical_services WHERE slug = 'infant-massage'
UNION ALL SELECT id, 'Детский массаж', 'ru' FROM medical_services WHERE slug = 'infant-massage'
UNION ALL SELECT id, 'Säuglingsmassage', 'de' FROM medical_services WHERE slug = 'infant-massage'
UNION ALL SELECT id, 'ISST Schroth', 'en' FROM medical_services WHERE slug = 'schroth-method'
UNION ALL SELECT id, 'Schroth terapija', 'sr' FROM medical_services WHERE slug = 'schroth-method'
UNION ALL SELECT id, 'Korektivna gimnastika', 'sr' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Корективна гимнастика', 'sr-cyrl' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Corrective Exercises', 'en' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Корригирующая гимнастика', 'ru' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Korrekturgymnastik', 'de' FROM medical_services WHERE slug = 'postural-exercises'
UNION ALL SELECT id, 'Baby handling', 'en' FROM medical_services WHERE slug = 'parental-developmental-stimulation-training'
UNION ALL SELECT id, 'Baby handling', 'sr' FROM medical_services WHERE slug = 'parental-developmental-stimulation-training'
UNION ALL SELECT id, 'Baby handling', 'ru' FROM medical_services WHERE slug = 'parental-developmental-stimulation-training'
UNION ALL SELECT id, 'Tretman neurorizičnih beba', 'sr' FROM medical_services WHERE slug = 'high-risk-infant-stimulation-exercises'
UNION ALL SELECT id, 'Третман неуроризичних беба', 'sr-cyrl' FROM medical_services WHERE slug = 'high-risk-infant-stimulation-exercises'
UNION ALL SELECT id, 'Neurorizične bebe', 'sr' FROM medical_services WHERE slug = 'high-risk-infant-stimulation-exercises';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_seastars_herceg_novi;
CREATE TEMPORARY TABLE tmp_seastars_herceg_novi (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_seastars_herceg_novi (slug, price, price_min, price_max) VALUES
('schroth-method', NULL, NULL, NULL), -- /tretmani — «Schroth terapija je prilagođeni trodimenzionalni tretman skolioze sa specifičnim obrascem disanja», tim — «ISST Schroth terapeut»
('dynamic-neuromuscular-stabilization', NULL, NULL, NULL), -- /tretmani — «Dinamička neuromuskularna stabilizacija koristi principe razvojne neurobiomehanike»
('postural-exercises', NULL, NULL, NULL), -- /tretmani — «Korektivna gimnastika obuhvata ciljane vežbe za ispravljanje posturalnih odstupanja»
('vojta-therapy', NULL, NULL, NULL), -- /tretmani — «Vojta metoda je refleksna lokomotorna tehnika»
('bobath-therapy', NULL, NULL, NULL), -- /tretmani — «Bobath koncept integriše specifične senzomotorne stimulacije»
('parental-developmental-stimulation-training', NULL, NULL, NULL), -- /tretmani — «Baby handling podučava roditelje sigurnim i razvojnim principima rukovanja bebom … podstiču optimalan neuromotorički razvoj» (= обучение родителей стимуляции развития, бренд-термин — синоним)
('infant-massage', NULL, NULL, NULL), -- /tretmani — «Masaža za bebe»
('high-risk-infant-stimulation-exercises', NULL, NULL, NULL), -- главная — «Tretmani za neurorizične bebe — namenjeni bebama sa povećanim neurorazvojnim rizikom. Kroz nežne, ciljane pokrete i vođenje roditelja…»
('kinesiotherapy-for-children-with-deformities', NULL, NULL, NULL), -- главная — «Termini za decu sa posturalnim deformitetima — Program je namenjen deci sa skoliozom, kifozom, lordozom … Kroz specifične korektivne vežbe»
('pediatric-rehabilitation', NULL, NULL, NULL); -- главная — «Termini za decu sa grubim motoričkim smetnjama — namenjeni deci koja imaju poteškoće u hodu, stajanju, ravnoteži»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_seastars_herceg_novi t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_seastars_herceg_novi t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_seastars_herceg_novi t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 2
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_seastars_herceg_novi_ds;
CREATE TEMPORARY TABLE tmp_seastars_herceg_novi_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_seastars_herceg_novi_ds (doctor_slug, service_slug) VALUES
('dragana-popovic', 'schroth-method'), -- «neurorazvojni i ISST Schroth terapeut»
('dragana-popovic', 'bobath-therapy'); -- косвенно: «neurorazvojni terapeut» = NDT (Bobath)

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_seastars_herceg_novi_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_seastars_herceg_novi_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 10 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 2 привязок врач↔услуга.
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
WHERE ms.slug IN ('dynamic-neuromuscular-stabilization', 'vojta-therapy', 'bobath-therapy', 'infant-massage');

DROP TEMPORARY TABLE IF EXISTS tmp_seastars_herceg_novi;
DROP TEMPORARY TABLE IF EXISTS tmp_seastars_herceg_novi_ds;

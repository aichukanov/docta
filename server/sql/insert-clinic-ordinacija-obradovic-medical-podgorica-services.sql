-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija Obradović Medical — услуги, цены, привязка к врачу
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-obradovic-medical-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ordinacija-obradovic-medical-podgorica.sql. Клиника — по google_place_id, врач — по slug.
--
-- Источник цен: https://obradovicmedical.me/Cjenovnik_Obradovic_jun_2026.pdf — скан, одна
-- страница: «Novi cjenovnik zdravstvenih usluga u PZU OBRADOVIĆ MEDICAL (od 01.06.2026.god)»,
-- штамп «Broj 07/2026, Datum 27.05.2026». Текстовый слой мусорный — прочитан глазами по
-- рендеру страницы (pypdfium2, scale 2.5). Все 12 цен читаются уверенно, NULL нет.
-- Дата прайса: 2026-06-01 (заголовок PDF). is_price_outdated не ставится.
--
-- Решения по сопоставлению:
--   * Осмотр врача — записи «Nuclear Medicine Specialist Examination» (врач — специалист
--     ядерной медицины). Два контрольных осмотра (>15 дней — 50, ≤15 дней — 30) — одна
--     запись каталога с диапазоном 30–50.
--   * Комбо «осмотр + УЗИ щитовидки» (90 первичный / 80 контрольный) → Thyroid Examination
--     with Ultrasound («Pregled i ultrazvuk štitaste žlijezde») — образец в каталоге есть,
--     диапазон 80–90.
--   * Комбо «осмотр + УЗИ шеи» (100 / 90) → Specialist Examination with Ultrasound
--     (общая запись «Specijalistički pregled sa ultrazvukom»): отдельной записи
--     «осмотр + УЗИ шеи» в каталоге нет. Диапазон 90–100. См. openQuestions.
--   * «UZV pregled vrata sa CD» → Neck Ultrasound (id 2113 локально). В каталоге есть
--     почти-дубль «Ultrasound Neck Thyroid Parathyroid Salivary Glands» (1 клиника, без
--     категорий) — выбрана основная запись.
--   * FNAB (п. 10) → Thyroid Biopsy: синонимы записи — «Biopsija štitaste žlijezde tankom
--     iglom», «Thyroid Fine Needle Biopsy». Цитология (CP-analiza) в цену не входит —
--     мазки отправляются патологу.
--   * П. 11 (FNAB + склерозирование кисты) — новая запись каталога (PART 0).
--   * П. 12 «Konsultacija putem interneta / „drugo“ mišljenje» → E-Consultation with
--     Specialist («E-konsultacija sa drugim specijalistom»).
--   * УЗИ брюшной полости и мочевых путей и цветной доплер сосудов шеи, рук, ног —
--     заявлены на главной («Šta mi to radimo»), цены в PDF нет → NULL.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишнее от прошлых прогонов
-- удаляется. ⚠️ Услуги, добавленные вручную, следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @google_place_id = 'ChIJ2ZTShGXrTRMRLnoTvuA3lrg';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ordinacija-obradovic-medical-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВАЯ УСЛУГА КАТАЛОГА
-- Категории: 26 = ENDOCRINOLOGY, 15 = AMBULATORY_SURGERY (как у Thyroid Biopsy).
-- Специальности: 12 = ENDOCRINOLOGY (к кат. 26), 88 = NUCLEAR_MEDICINE.
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'thyroid-fnab-with-cyst-sclerotherapy', 'Thyroid FNAB with Cyst Sclerotherapy', 'FNAB štitaste žlijezde sa skleroziranjem ciste', 'FNAB штитасте жлијезде са склерозирањем цисте',
	'Тонкоигольная аспирационная биопсия щитовидной железы со склерозированием кисты', 'Feinnadelaspiration der Schilddrüse mit Zystensklerosierung', 'Tiroid ince iğne aspirasyon biyopsisi ve kist skleroterapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy' OR name_en = 'Thyroid FNAB with Cyst Sclerotherapy');



INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 15 FROM medical_services WHERE slug IN (
	'thyroid-fnab-with-cyst-sclerotherapy'
);

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 26 FROM medical_services WHERE slug IN (
	'thyroid-fnab-with-cyst-sclerotherapy'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 12 FROM medical_services WHERE slug IN (
	'thyroid-fnab-with-cyst-sclerotherapy'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 88 FROM medical_services WHERE slug IN (
	'thyroid-fnab-with-cyst-sclerotherapy'
);

-- Синонимы
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Skleroziranje ciste štitaste žlijezde', 'sr' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Склерозирање цисте штитасте жлијезде', 'sr-cyrl' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Alkoholna skleroterapija ciste štitaste žlijezde', 'sr' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Thyroid Cyst Ethanol Ablation', 'en' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Склеротерапия кисты щитовидной железы', 'ru' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Этаноловая склеротерапия кисты щитовидной железы', 'ru' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Sklerosierung einer Schilddrüsenzyste', 'de' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Tiroid kisti skleroterapisi', 'tr' FROM medical_services WHERE slug = 'thyroid-fnab-with-cyst-sclerotherapy'
UNION ALL SELECT id, 'Online konsultacija', 'sr' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Онлајн консултација', 'sr-cyrl' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Online consultation', 'en' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Онлайн-консультация', 'ru' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Online-Konsultation', 'de' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Online konsültasyon', 'tr' FROM medical_services WHERE slug = 'e-consultation-with-specialist';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ С ЦЕНАМИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_obradovic_services;
CREATE TEMPORARY TABLE tmp_obradovic_services (
	name_en VARCHAR(255) NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_obradovic_services (name_en, price, price_min, price_max) VALUES
('First Nuclear Medicine Specialist Examination', 70, NULL, NULL), -- 1. Prvi pregled specijaliste — 70 e
('Follow-up Nuclear Medicine Specialist Examination', 30, NULL, 50), -- 2. Kontrolni pregled specijaliste, nakon više od 15 dana — 50 e; 3. Kontrolni pregled specijaliste, unutar 15 dana od inicijalnog pregleda — 30 e
('Thyroid Ultrasound', 50, NULL, NULL), -- 4. UZV pregled štitaste žlijezde sa CD* analizom — 50 e (CD = Color Doppler, TIRADS skor)
('Neck Ultrasound', 60, NULL, NULL), -- 5. UZV pregled vrata sa CD* analizom — 60 e (štitasta, paraštitaste, zaušne i podvilične pljuvačne žlijezde, limfni čvorovi vrata)
('Thyroid Examination with Ultrasound', 80, NULL, 90), -- 6. Prvi specijalistički pregled + UZV pregled štitaste žlijezde — 90 e; 7. Kontrolni specijalistički pregled + UZV pregled štitaste žlijezde — 80 e
('Specialist Examination with Ultrasound', 90, NULL, 100), -- 8. Prvi specijalistički pregled + UZV vrata — 100 e; 9. Kontrolni specijalistički pregled + UZV vrata — 90 e
('Thyroid Biopsy', 90, NULL, NULL), -- 10. UZV vođena aspiraciona punkcija (FNAB*) štitaste žlijezde sa pravljenjem razmaza — 90 e
('Thyroid FNAB with Cyst Sclerotherapy', 110, NULL, NULL), -- 11. FNAB štitaste žlijezde sa pravljenjem razmaza i skleroziranjem ciste — 110 e
('E-Consultation with Specialist', 40, NULL, NULL), -- 12. Konsultacija putem interneta / „drugo“ mišljenje... — 40 e
('Abdomen and Urinary Tract Ultrasound', NULL, NULL, NULL), -- naslovna, «Šta mi to radimo»: «UZV abdomena, urotrakta» — cijene u PDF nema
('Doppler Neck Blood Vessels', NULL, NULL, NULL), -- naslovna: «Color Doppler krvnih sudova vrata, ruku, nogu» — cijene u PDF nema
('Doppler Upper Extremity Blood Vessels', NULL, NULL, NULL), -- naslovna: «Color Doppler krvnih sudova vrata, ruku, nogu» — cijene u PDF nema
('Doppler Lower Extremity Blood Vessels', NULL, NULL, NULL); -- naslovna: «Color Doppler krvnih sudova vrata, ruku, nogu» — cijene u PDF nema

-- Ожидается ПУСТО.
SELECT t.name_en AS unmatched_service
FROM tmp_obradovic_services t
LEFT JOIN medical_services ms ON ms.name_en = t.name_en
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_obradovic_services t ON t.name_en = ms.name_en
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_obradovic_services t ON t.name_en = ms.name_en
WHERE cms.clinic_id = @clinic_id AND t.name_en IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГИ
-- Единственный врач ординации — все услуги его. Цены живут на уровне клиники
-- (clinic_medical_services), здесь NULL: строка нужна ради связи на странице услуги.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_obradovic_doctor_services;
CREATE TEMPORARY TABLE tmp_obradovic_doctor_services (
	doctor_slug VARCHAR(255) NOT NULL,
	name_en VARCHAR(255) NOT NULL,
	PRIMARY KEY (doctor_slug, name_en)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_obradovic_doctor_services (doctor_slug, name_en) VALUES
('mladjen-obradovic', 'First Nuclear Medicine Specialist Examination'),
('mladjen-obradovic', 'Follow-up Nuclear Medicine Specialist Examination'),
('mladjen-obradovic', 'Thyroid Ultrasound'),
('mladjen-obradovic', 'Neck Ultrasound'),
('mladjen-obradovic', 'Thyroid Examination with Ultrasound'),
('mladjen-obradovic', 'Specialist Examination with Ultrasound'),
('mladjen-obradovic', 'Thyroid Biopsy'),
('mladjen-obradovic', 'Thyroid FNAB with Cyst Sclerotherapy'),
('mladjen-obradovic', 'E-Consultation with Specialist'),
('mladjen-obradovic', 'Abdomen and Urinary Tract Ultrasound'),
('mladjen-obradovic', 'Doppler Neck Blood Vessels'),
('mladjen-obradovic', 'Doppler Upper Extremity Blood Vessels'),
('mladjen-obradovic', 'Doppler Lower Extremity Blood Vessels');

DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id AND d.slug = 'mladjen-obradovic';

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_obradovic_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.name_en = t.name_en
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 13 услуг, с ценой 9.
SELECT COUNT(*) AS services_total,
	SUM(cms.price IS NOT NULL OR cms.price_min IS NOT NULL) AS with_price
FROM clinic_medical_services cms WHERE cms.clinic_id = @clinic_id;

SELECT ms.name_en, ms.slug, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 13 привязок у mladjen-obradovic.
SELECT d.slug, COUNT(*) AS linked_services
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id
GROUP BY d.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_obradovic_services;
DROP TEMPORARY TABLE IF EXISTS tmp_obradovic_doctor_services;

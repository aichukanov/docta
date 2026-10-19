-- ═══════════════════════════════════════════════════════════════════════════
-- Medcontour Institute (Budva) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-medcontour-institute-budva-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-medcontour-institute-budva.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/medcontour-institute-budva.json.
-- 
-- Услуг: 37, с ценой: 0 (цен на сайте нет). Новые записи каталога (агент Y, идемпотентно по slug):
--   med-contour-plus-body-contouring, hydradermabrasion (также в insert-clinic-ordinacija-fontis-podgorica-services.sql), microdermabrasion.
-- Диодная эпиляция по зонам: 22 зоны сопоставлены с существующими записями по зонам (laser-hair-removal-*-women/-men; зона сайта
-- без пола → обе записи), остальные зоны и «Full body» — общая laser-hair-removal.
-- Спорные (не заведены): «Hyaluronic treatment», «Fibroma Removal». Исключены: косметический уход (Deep cleansing facial,
-- Face Up hydration, Facials, Acne Therapy, Rosacea Care, Biological Treatments), wellness-программы, пакеты без цен.
-- is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ-2WsBQDVTRMRVEi1vkLXjaw' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'medcontour-institute-budva' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-medcontour-institute-budva.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Именной аппарат: Medcontour Institute /services «BODY SHAPING - MED CONTOUR PLUS», главная «Med Contour Plus — A painless, non-surgical method for body contouring, skin tightening, and localized fat reduction». В каталоге аналога этого аппарата нет (emsculpt-neo — другая технология, exilis/ultraformer — другие бренды, generic-кавитации нет); технологию сайт не называет — generic не приписываем. По схеме emsculpt-neo-body-contouring: кат. 18, спец. 18 + 44. Зоны (большая/комбинированная/малая/ягодицы) и пакеты из 5 без цен — одна запись, зоны в источнике.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'med-contour-plus-body-contouring', 'Med Contour Plus Body Contouring', 'Med Contour Plus oblikovanje tijela', 'Med Contour Plus обликовање тијела',
	'Med Contour Plus — моделирование тела', 'Med Contour Plus Körperformung', 'Med Contour Plus vücut şekillendirme', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'med-contour-plus-body-contouring' OR name_en = 'Med Contour Plus Body Contouring');

-- Общая процедура (аппаратная гидродермабразия: вакуумное очищение + пилинг + инфузия сывороток). Medcontour Institute: «Hydra Clear … combines deep hydration, gentle exfoliation, and firming technologies»; Fontis: «Hydrafacial je neinvazivan, višestepeni tretman … Hydrafacial važi za najnježniju hidrodermoabraziju». В каталоге записи нет (есть только dermabrasion — глубокая дермабразия, и diamond-microdermabrasion). Два разных аппарата одной сути → одна общая запись, бренды HydraFacial и Hydra Clear — синонимами (решение юзера: брендовый дубль не заводить). Кат. 24 DERMATOLOGY, спец. 7 + 44 (как skin-hydration-treatment / facial-biorevitalization).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'hydradermabrasion', 'Hydradermabrasion', 'Hidrodermoabrazija', 'Хидродермоабразија',
	'Гидродермабразия', 'Hydrodermabrasion', 'Hidrodermabrazyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'hydradermabrasion' OR name_en = 'Hydradermabrasion');

-- Общая услуга: Medcontour /services «Face Up microdermabrasion» («Face Up mikrodermoabrazija»); Fontis /services/tretmani-lica-fontis «Mikrodermoabrazija lica i leđa (Reviderm)». В каталоге есть только diamond-microdermabrasion (конкретный метод — алмазная насадка, сайт метод не называет) и dermabrasion (глубокая дермабразия — другая процедура). Схема — как diamond-microdermabrasion: кат. 18 + 24, спец. 7 + 18.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'microdermabrasion', 'Microdermabrasion', 'Mikrodermoabrazija', 'Микродермоабразија',
	'Микродермабразия', 'Mikrodermabrasion', 'Mikrodermabrazyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'microdermabrasion' OR name_en = 'Microdermabrasion');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('med-contour-plus-body-contouring', 'microdermabrasion');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 24 FROM medical_services WHERE slug IN ('hydradermabrasion', 'microdermabrasion');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('hydradermabrasion', 'microdermabrasion');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('med-contour-plus-body-contouring', 'microdermabrasion');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 44 FROM medical_services WHERE slug IN ('med-contour-plus-body-contouring', 'hydradermabrasion');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Med Contour', 'en' FROM medical_services WHERE slug = 'med-contour-plus-body-contouring'
UNION ALL SELECT id, 'Med Contour', 'sr' FROM medical_services WHERE slug = 'med-contour-plus-body-contouring'
UNION ALL SELECT id, 'Med Contour Plus oblikovanje tela', 'sr' FROM medical_services WHERE slug = 'med-contour-plus-body-contouring'
UNION ALL SELECT id, 'Med Contour Plus обликовање тела', 'sr-cyrl' FROM medical_services WHERE slug = 'med-contour-plus-body-contouring'
UNION ALL SELECT id, 'Med Contour Plus Body Shaping', 'en' FROM medical_services WHERE slug = 'med-contour-plus-body-contouring'
UNION ALL SELECT id, 'Мед Контур Плюс', 'ru' FROM medical_services WHERE slug = 'med-contour-plus-body-contouring'
UNION ALL SELECT id, 'HydraFacial', 'en' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Hydrafacial', 'sr' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Hydrafacial tretman', 'sr' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Hydrafacial третман', 'sr-cyrl' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Хидродермоабразија', 'sr-cyrl' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Гидрафейшл', 'ru' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'HydraFacial', 'ru' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'HydraFacial-Behandlung', 'de' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'HydraFacial', 'tr' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Hydrodermabrasion Facial', 'en' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Hydra Clear', 'en' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Hydra Clear', 'sr' FROM medical_services WHERE slug = 'hydradermabrasion'
UNION ALL SELECT id, 'Face Up mikrodermoabrazija', 'sr' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'Mikrodermabrazija', 'sr' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'Микродермабразија', 'sr-cyrl' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'Skin booster', 'en' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Skin booster', 'sr' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Skin boosteri', 'sr' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Скин бустер', 'sr-cyrl' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Скин-бустер', 'ru' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Skinbooster', 'de' FROM medical_services WHERE slug = 'biorevitalization'
UNION ALL SELECT id, 'Jessner piling', 'sr' FROM medical_services WHERE slug = 'chemical-peel'
UNION ALL SELECT id, 'Џеснер пилинг', 'sr-cyrl' FROM medical_services WHERE slug = 'chemical-peel'
UNION ALL SELECT id, 'Jessner Peel', 'en' FROM medical_services WHERE slug = 'chemical-peel'
UNION ALL SELECT id, 'Hollywood Peel', 'en' FROM medical_services WHERE slug = 'chemical-peel'
UNION ALL SELECT id, 'Пилинг Джесснера', 'ru' FROM medical_services WHERE slug = 'chemical-peel'
UNION ALL SELECT id, 'Jessner-Peeling', 'de' FROM medical_services WHERE slug = 'chemical-peel'
UNION ALL SELECT id, 'Tretman strija i ožiljaka', 'sr' FROM medical_services WHERE slug = 'stretch-mark-treatment'
UNION ALL SELECT id, 'Третман стрија и ожиљака', 'sr-cyrl' FROM medical_services WHERE slug = 'stretch-mark-treatment'
UNION ALL SELECT id, 'Diodna laserska epilacija', 'sr' FROM medical_services WHERE slug = 'laser-hair-removal'
UNION ALL SELECT id, 'Диодна ласерска епилација', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-hair-removal'
UNION ALL SELECT id, 'Diode Laser Hair Removal', 'en' FROM medical_services WHERE slug = 'laser-hair-removal'
UNION ALL SELECT id, 'Диодная лазерная эпиляция', 'ru' FROM medical_services WHERE slug = 'laser-hair-removal'
UNION ALL SELECT id, 'Trajno uklanjanje dlaka', 'sr' FROM medical_services WHERE slug = 'laser-hair-removal'
UNION ALL SELECT id, 'Трајно уклањање длака', 'sr-cyrl' FROM medical_services WHERE slug = 'laser-hair-removal'
UNION ALL SELECT id, 'Permanent Hair Removal', 'en' FROM medical_services WHERE slug = 'laser-hair-removal';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_medcontour_institute_budva;
CREATE TEMPORARY TABLE tmp_medcontour_institute_budva (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_medcontour_institute_budva (slug, price, price_min, price_max) VALUES
('med-contour-plus-body-contouring', NULL, NULL, NULL), -- /services «BODY SHAPING - MED CONTOUR PLUS» — «One treatment of a large area (thighs or abdomen)», «One treatment of a combined area (abdomen + thighs)», «Gluteal region treatment (buttocks)», «One treatment of a small area (lower abdomen, knees, calves, upper arms, lower back)» (+3 пакета по 5 — в excluded)
('hydradermabrasion', NULL, NULL, NULL), -- /services «FACIAL AND SKIN TREATMENTS» — «Hydra Clear», главная — «Hydra Clear is an advanced skin treatment that combines deep hydration, gentle exfoliation, and firming technologies»
('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- /services — «Facial mesotherapy» («Mezoterapija lica»), главная Aesthetic Medicine — «Mesotherapy – Skin & hair revitalization»
('dermapen-microneedling', NULL, NULL, NULL), -- /services — «Dermapen (face + neck)»
('biorevitalization', NULL, NULL, NULL), -- /services — «Biorevitalization», «Biorevitalization RRS + under-eye mesotherapy», главная — «Skin Boosters – Hydration and glow» (skin booster — синоним)
('scalp-mesotherapy', NULL, NULL, NULL), -- /services — «Hair mesotherapy» («Mezoterapija kose»), главная Trichology — «Hair Growth Mesotherapy – Stimulates follicles and improves circulation»
('chemical-peel', NULL, NULL, NULL), -- /services — «Chemical peel», «Jessner (Hollywood) peel», главная — «Chemical Peels – Pigmentation, acne, skin tone» (Jessner — синоним, зона не указана — generic)
('microdermabrasion', NULL, NULL, NULL), -- /services — «Face Up microdermabrasion»
('stretch-mark-treatment', NULL, NULL, NULL), -- /services — «Stretch mark and scar treatment» («Tretman strija i ožiljaka»), главная — «Stretch Mark & Scar Removal – Skin smoothing»
('botox-injection', NULL, NULL, NULL), -- Главная, Aesthetic Medicine — «Botox – Wrinkle reduction»
('hyaluronic-acid-filler', NULL, NULL, NULL), -- Главная, Aesthetic Medicine — «Fillers – Volume and contour enhancement» (generic-запись филлеров, синоним Dermal Filler)
('nutritionist-specialist-examination', NULL, NULL, NULL), -- Главная, Nutrition & Wellness — «One-on-One Nutrition Consultations» («Individualne konsultacije sa nutricionistom», синоним «Konsultacija nutricioniste»)
('personalized-nutrition-plan', NULL, NULL, NULL), -- Главная — «Custom Meal Plans – For weight loss/gain or medical needs» («Planovi ishrane po meri»)
('laser-hair-removal', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Full body hair removal» и зоны без точной записи в каталоге: «Chin (women)», «Full face (men)», «Abdomen (women)», «Chest and abdomen (men)», «Bikini and pubic area (deep bikini)», «Half back (upper or lower)», «Full back and shoulders»
('laser-hair-removal-upper-lip-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Upper lip»
('laser-hair-removal-chin-and-upper-lip-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Upper lip and chin (women)»
('laser-hair-removal-full-face-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Full face (women)»
('laser-hair-removal-sideburns-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Sideburns or ears»
('laser-hair-removal-sideburns-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Sideburns or ears»
('laser-hair-removal-ears-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Sideburns or ears»
('laser-hair-removal-neck-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Neck»
('laser-hair-removal-underarms-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Underarms»
('laser-hair-removal-underarms-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Underarms»
('laser-hair-removal-forearms-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Half arms (including fingers)»
('laser-hair-removal-forearms-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Half arms (including fingers)»
('laser-hair-removal-full-arms-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Full arms»
('laser-hair-removal-full-arms-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Full arms»
('laser-hair-removal-abdomen-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Abdomen (men)»
('laser-hair-removal-chest-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Chest (men)»
('laser-hair-removal-bikini-line-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Bikini line»
('laser-hair-removal-lower-legs-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Lower legs (including toes)»
('laser-hair-removal-lower-legs-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Lower legs (including toes)»
('laser-hair-removal-full-legs-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Full legs»
('laser-hair-removal-full-legs-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Full legs»
('laser-hair-removal-full-legs-and-bikini-women', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Legs and bikini»
('laser-hair-removal-full-back-men', NULL, NULL, NULL), -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Full back»
('laser-hair-removal-shoulders-men', NULL, NULL, NULL); -- /services «PERMANENT HAIR REMOVAL - DIODE LASER» — «Shoulders»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_medcontour_institute_budva t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_medcontour_institute_budva t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_medcontour_institute_budva t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 37 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 3: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('med-contour-plus-body-contouring', 'hydradermabrasion', 'microdermabrasion');

DROP TEMPORARY TABLE IF EXISTS tmp_medcontour_institute_budva;

-- Podology: services catalogue (specialty PODIATRY = 85, category PODOLOGY = 36)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-podology-services.sql
--
-- ПРЕРЕКВИЗИТ: сначала применить server/sql/migrations/021-add-podology.sql
-- (создаёт clinic_types.25 и medical_service_categories.36).
--
-- Услуг клиникам этот скрипт НЕ привязывает — только пополняет каталог
-- и правит привязки четырёх уже существующих подологических услуг.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @cat_podology = 36;
SET @cat_dermatology = 24;
SET @cat_orthopedics = 10;
SET @cat_endocrinology = 26;

SET @spec_podiatry = 85;
SET @spec_dermatovenerology = 7;
SET @spec_orthopedics = 17;
SET @spec_endocrinology = 12;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: NEW MEDICAL SERVICES
-- ═══════════════════════════════════════════════════════════════
-- Уже существуют и здесь НЕ создаются (созданы под clinic 29 Kerber):
--   7831 podologist-examination, 7832 diabetic-foot-care,
--   7833 fungal-nail-treatment, 7834 heel-fissure-treatment
-- Хирургические аналоги существуют отдельно и не дублируются:
--   2128/3511/3598 (урастао нокат), 3364 (клавус), 3363 (вирусне брадавице)

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Medical Pedicure', 'medical-pedicure', 'Medicinski pedikir', 'Медицински педикир', 'Медицинский педикюр', 'Medizinische Fußpflege', 'Medikal pedikür'),
('Conservative Ingrown Toenail Treatment', 'conservative-ingrown-toenail-treatment', 'Konzervativni tretman uraslog nokta', 'Конзервативни третман ураслог нокта', 'Консервативное лечение вросшего ногтя', 'Konservative Behandlung des eingewachsenen Nagels', 'Batık tırnağın konservatif tedavisi'),
('Nail Bracing for Ingrown Toenail', 'nail-bracing-for-ingrown-toenail', 'Korekcija uraslog nokta skobicom', 'Корекција ураслог нокта скобицом', 'Коррекция вросшего ногтя скобой', 'Nagelspange bei eingewachsenem Nagel', 'Batık tırnak için tırnak teli'),
('Callus and Hyperkeratosis Treatment', 'callus-and-hyperkeratosis-treatment', 'Tretman kalusa i hiperkeratoze', 'Третман калуса и хиперкератозе', 'Обработка мозолей и гиперкератоза', 'Behandlung von Hornhaut und Hyperkeratose', 'Nasır ve hiperkeratoz tedavisi'),
('Nail Prosthetics', 'nail-prosthetics', 'Protetika nokta', 'Протетика нокта', 'Протезирование ногтя', 'Nagelprothetik', 'Tırnak protezi'),
('Plantar Wart Treatment', 'plantar-wart-treatment', 'Tretman plantarnih bradavica', 'Третман плантарних брадавица', 'Лечение подошвенных бородавок', 'Behandlung von Plantarwarzen', 'Plantar siğil tedavisi'),
('Custom Orthopedic Insoles', 'custom-orthopedic-insoles', 'Individualni ortopedski ulošci', 'Индивидуални ортопедски улошци', 'Индивидуальные ортопедические стельки', 'Individuelle orthopädische Einlagen', 'Kişiye özel ortopedik tabanlık')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- Осмотр — sort_order = 1 (первичный приём наверху категории)
UPDATE medical_services SET sort_order = 1 WHERE name_en = 'Podologist Examination';

-- ═══════════════════════════════════════════════════════════════
-- PART 2: CATEGORY RELATIONS
-- ═══════════════════════════════════════════════════════════════

-- 2.1 Все подологические услуги → категория PODOLOGY (36)
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_podology FROM medical_services WHERE name_en IN (
    'Podologist Examination',
    'Diabetic Foot Care',
    'Fungal Nail Treatment',
    'Heel Fissure Treatment',
    'Medical Pedicure',
    'Conservative Ingrown Toenail Treatment',
    'Nail Bracing for Ingrown Toenail',
    'Callus and Hyperkeratosis Treatment',
    'Nail Prosthetics',
    'Plantar Wart Treatment',
    'Custom Orthopedic Insoles'
);

-- 2.2 Вирусная бородавка — ещё и дерматология (кожная патология)
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_dermatology FROM medical_services WHERE name_en = 'Plantar Wart Treatment';

-- 2.3 Стельки — ещё и ортопедия
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_orthopedics FROM medical_services WHERE name_en = 'Custom Orthopedic Insoles';

-- 2.4 Диабетическая стопа — ещё и эндокринология (перелинковка с диабетом)
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, @cat_endocrinology FROM medical_services WHERE name_en = 'Diabetic Foot Care';

-- ═══════════════════════════════════════════════════════════════
-- PART 3: SPECIALTY RELATIONS
-- ═══════════════════════════════════════════════════════════════
-- Существующие привязки к дерматовенерологии (7) у 7831-7834 СОХРАНЯЮТСЯ:
-- онихомикоз и трещины пят — законная дерматология, и услуги уже
-- показываются в фильтрах дерматологов. Здесь только добавляется 85.

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_podiatry FROM medical_services WHERE name_en IN (
    'Podologist Examination',
    'Diabetic Foot Care',
    'Fungal Nail Treatment',
    'Heel Fissure Treatment',
    'Medical Pedicure',
    'Conservative Ingrown Toenail Treatment',
    'Nail Bracing for Ingrown Toenail',
    'Callus and Hyperkeratosis Treatment',
    'Nail Prosthetics',
    'Plantar Wart Treatment',
    'Custom Orthopedic Insoles'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_dermatovenerology FROM medical_services WHERE name_en = 'Plantar Wart Treatment';

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_orthopedics FROM medical_services WHERE name_en = 'Custom Orthopedic Insoles';

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, @spec_endocrinology FROM medical_services WHERE name_en = 'Diabetic Foot Care';

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

SELECT ms.id, ms.slug, ms.sort_order,
       GROUP_CONCAT(DISTINCT mscr.medical_service_category_id ORDER BY 1) AS cats,
       GROUP_CONCAT(DISTINCT mss.specialty_id ORDER BY 1) AS specs
FROM medical_services ms
LEFT JOIN medical_service_categories_relations mscr ON mscr.medical_service_id = ms.id
LEFT JOIN medical_services_specialties mss ON mss.medical_service_id = ms.id
WHERE ms.name_en IN (
    'Podologist Examination', 'Diabetic Foot Care', 'Fungal Nail Treatment',
    'Heel Fissure Treatment', 'Medical Pedicure',
    'Conservative Ingrown Toenail Treatment', 'Nail Bracing for Ingrown Toenail',
    'Callus and Hyperkeratosis Treatment', 'Nail Prosthetics',
    'Plantar Wart Treatment', 'Custom Orthopedic Insoles'
)
GROUP BY ms.id ORDER BY ms.id;

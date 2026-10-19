-- ═══════════════════════════════════════════════════════════════════════════
-- VRMAC Health & Wellbeing Retreat de’MAR (Kotor) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-vrmac-health-wellbeing-retreat-kotor-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-vrmac-health-wellbeing-retreat-kotor.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/vrmac-health-wellbeing-retreat-kotor.json.
-- 
-- Услуг: 44, с ценой: 1 — у отдельных услуг цен нет; из 6 многодневных программ заведена одна, Pure Breath →
-- pulmonary-rehabilitation от 550 €, остальные 5 — wellness, не заведены. Новых записей каталога: 2 (pulmonary-rehabilitation,
-- hifem-therapy) — решения координатора 2026-10-09. Foot Reflexology не заведена (комплементарная техника). Исключены: Aroma/Epsom Bath, Herbal Packing, косметические
-- facials, Neolifting, Neoderma, Hydrofacial. is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJAQAAZAo0TBMRgstKSiF85iY' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'vrmac-health-wellbeing-retreat-kotor' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-vrmac-health-wellbeing-retreat-kotor.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en) — добавлено координатором 2026-10-09
-- ═══════════════════════════════════════════════════════════════

-- «Pure Breath Experience — Respiratory Support Program», от 5 дней, 550 € без проживания: функциональные тесты лёгких,
-- ЭКГ, тест 6-минутной ходьбы, дыхательная кинезиотерапия, ингаляции, постуральный дренаж, осмотры физиатра-пульмолога.
-- Лёгочной реабилитации в каталоге нет (есть только кардио-, нейро-, вестибулярная и т.п.) → общая запись. Кат. 5 + 12, спец. 42 + 14.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pulmonary-rehabilitation', 'Pulmonary Rehabilitation', 'Plućna rehabilitacija', 'Плућна рехабилитација',
	'Легочная реабилитация', 'Pneumologische Rehabilitation', 'Pulmoner rehabilitasyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pulmonary-rehabilitation' OR name_en = 'Pulmonary Rehabilitation');

-- «HIFEM/HIFM Therapy — High-Intensity Focused Electromagnetic technology used for muscle strengthening, rehabilitation…».
-- Отдельная технология: super-inductive-system-therapy (BTL SIS) — другой аппарат, high-inductive-magnet-therapy — магнит без
-- фокусировки, emsculpt-neo — эстетика с RF. Аппарат сайт не называет → общая запись. Кат. 5, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'hifem-therapy', 'HIFEM Therapy', 'HIFEM terapija', 'HIFEM терапија',
	'HIFEM-терапия', 'HIFEM-Therapie', 'HIFEM terapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'hifem-therapy' OR name_en = 'HIFEM Therapy');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('pulmonary-rehabilitation', 'hifem-therapy')
UNION ALL SELECT id, 12 FROM medical_services WHERE slug = 'pulmonary-rehabilitation';

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN ('pulmonary-rehabilitation', 'hifem-therapy')
UNION ALL SELECT id, 14 FROM medical_services WHERE slug = 'pulmonary-rehabilitation';

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Respiratorna rehabilitacija', 'sr' FROM medical_services WHERE slug = 'pulmonary-rehabilitation'
UNION ALL SELECT id, 'Респираторна рехабилитација', 'sr-cyrl' FROM medical_services WHERE slug = 'pulmonary-rehabilitation'
UNION ALL SELECT id, 'Respiratory Rehabilitation', 'en' FROM medical_services WHERE slug = 'pulmonary-rehabilitation'
UNION ALL SELECT id, 'Дыхательная реабилитация', 'ru' FROM medical_services WHERE slug = 'pulmonary-rehabilitation'
UNION ALL SELECT id, 'Atemwegsrehabilitation', 'de' FROM medical_services WHERE slug = 'pulmonary-rehabilitation'
UNION ALL SELECT id, 'Solunum rehabilitasyonu', 'tr' FROM medical_services WHERE slug = 'pulmonary-rehabilitation'
UNION ALL SELECT id, 'High-Intensity Focused Electromagnetic Therapy', 'en' FROM medical_services WHERE slug = 'hifem-therapy'
UNION ALL SELECT id, 'HIFM', 'en' FROM medical_services WHERE slug = 'hifem-therapy'
UNION ALL SELECT id, 'Visokointenzivno fokusirano elektromagnetno polje', 'sr' FROM medical_services WHERE slug = 'hifem-therapy'
UNION ALL SELECT id, 'Высокоинтенсивная фокусированная электромагнитная терапия', 'ru' FROM medical_services WHERE slug = 'hifem-therapy'
UNION ALL SELECT id, 'BIA', 'en' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'BIA', 'sr' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Bioelectrical Impedance Analysis', 'en' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Analiza bioelektrične impedancije', 'sr' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'Биоимпедансометрия', 'ru' FROM medical_services WHERE slug = 'body-composition-analysis'
UNION ALL SELECT id, 'BDT', 'en' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'BDT', 'sr' FROM medical_services WHERE slug = 'bronchodilator-test'
UNION ALL SELECT id, 'Diffusion Capacity Test', 'en' FROM medical_services WHERE slug = 'diffusion-test'
UNION ALL SELECT id, 'Difuzijski kapacitet pluća', 'sr' FROM medical_services WHERE slug = 'diffusion-test'
UNION ALL SELECT id, 'Vitamin Cocktail Infusion', 'en' FROM medical_services WHERE slug = 'vitamin-or-anti-aging-tad-infusion'
UNION ALL SELECT id, 'Vitaminski koktel infuzija', 'sr' FROM medical_services WHERE slug = 'vitamin-or-anti-aging-tad-infusion'
UNION ALL SELECT id, 'Витаминная капельница', 'ru' FROM medical_services WHERE slug = 'vitamin-or-anti-aging-tad-infusion'
UNION ALL SELECT id, 'Immuno Boost Infusion', 'en' FROM medical_services WHERE slug = 'immune-booster-iv'
UNION ALL SELECT id, 'Hidrokineziterapija', 'sr' FROM medical_services WHERE slug = 'active-assisted-exercises-in-water'
UNION ALL SELECT id, 'Хидрокинезитерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'active-assisted-exercises-in-water'
UNION ALL SELECT id, 'Hydrokinesiotherapy', 'en' FROM medical_services WHERE slug = 'active-assisted-exercises-in-water'
UNION ALL SELECT id, 'Гидрокинезиотерапия', 'ru' FROM medical_services WHERE slug = 'active-assisted-exercises-in-water'
UNION ALL SELECT id, 'Grupna kineziterapija', 'sr' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Group Kinesiotherapy', 'en' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Групповая кинезиотерапия', 'ru' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'CuMan', 'en' FROM medical_services WHERE slug = 'cupping-therapy'
UNION ALL SELECT id, 'CuMan terapija', 'sr' FROM medical_services WHERE slug = 'cupping-therapy'
UNION ALL SELECT id, 'Vibro masaža', 'sr' FROM medical_services WHERE slug = 'apparatus-assisted-massage'
UNION ALL SELECT id, 'Вибро масажа', 'sr-cyrl' FROM medical_services WHERE slug = 'apparatus-assisted-massage'
UNION ALL SELECT id, 'Vibration Massage', 'en' FROM medical_services WHERE slug = 'apparatus-assisted-massage'
UNION ALL SELECT id, 'Вибромассаж', 'ru' FROM medical_services WHERE slug = 'apparatus-assisted-massage'
UNION ALL SELECT id, 'Bubble Bath', 'en' FROM medical_services WHERE slug = 'pearl-bath-therapy'
UNION ALL SELECT id, 'Thermo Herbal Packing', 'en' FROM medical_services WHERE slug = 'thermotherapy-thermo-pack'
UNION ALL SELECT id, 'Termo biljna obloga', 'sr' FROM medical_services WHERE slug = 'thermotherapy-thermo-pack'
UNION ALL SELECT id, 'Underwater Shower Massage', 'en' FROM medical_services WHERE slug = 'hydrotherapy-underwater-massage';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_vrmac_health_wellbeing_retreat_kotor;
CREATE TEMPORARY TABLE tmp_vrmac_health_wellbeing_retreat_kotor (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_vrmac_health_wellbeing_retreat_kotor (slug, price, price_min, price_max) VALUES
('specialist-examination', NULL, NULL, NULL), -- Medical Services — «Examination by a Specialist Doctor — Comprehensive medical evaluation by a specialist physician…» (me: «Pregled kod specijalista»)
('follow-up-specialist-examination', NULL, NULL, NULL), -- «Control Examination — Follow-up medical assessment…» (me: «Kontrolni pregled»)
('physiotherapist-examination', NULL, NULL, NULL), -- «Examination by a Physiotherapist — Professional assessment of posture, movement, pain, muscle function, and mobility…» (me: «Fizioterapeutski pregled»)
('body-composition-analysis', NULL, NULL, NULL), -- «BIA (Body Impedance Analiser) — Non-invasive body composition analysis measuring body fat, muscle mass, hydration…»
('ecg', NULL, NULL, NULL), -- «ECG (Electrocardiogram)»
('spirometry', NULL, NULL, NULL), -- Lung Function Tests — «Spirometry»
('bronchodilator-test', NULL, NULL, NULL), -- «BDT (Bronhodilatator Test) — Respiratory test performed before and after bronchodilator medication…»
('body-plethysmography', NULL, NULL, NULL), -- «Bodyplethysmographya — Advanced lung function testing that measures total lung volume and airway resistance…»
('diffusion-test', NULL, NULL, NULL), -- «Diffusion Capacity Testing — Diagnostic test evaluating how efficiently oxygen passes from the lungs into the bloodstream.»
('intramuscular-injection', NULL, NULL, NULL), -- Injection Therapy — «Intramuscular Injection»
('infusion-therapy', NULL, NULL, NULL), -- «Infusion with Medication — Intravenous therapy that delivers medications and fluids…»
('vitamin-or-anti-aging-tad-infusion', NULL, NULL, NULL), -- «Vitamins Cocktail Infusion — Intravenous vitamin and nutrient therapy…» (единственная generic-запись витаминной капельницы, Myers — конкретная формула, сайт её не называет)
('immune-booster-iv', NULL, NULL, NULL), -- «Immuno Boost Infusion — Specialized IV infusion of vitamins, minerals, and antioxidants aimed at supporting immune system function»
('wound-care', NULL, NULL, NULL), -- «Interventions (Wound Care, etc.) — … wound treatment, dressing changes, minor interventions…»
('inhalation-therapy', NULL, NULL, NULL), -- «Inhalation with Medicine — Respiratory therapy using medicated inhalation…»
('individual-kinesiotherapy', NULL, NULL, NULL), -- Physical Therapy — «Individual Kinesiotherapy 30 - 60 min»
('group-exercises-type-b', NULL, NULL, NULL), -- «Group Kinesiotherapy - (up to 6 people) 45 min» («Grupne vježbe, po osobi»)
('active-assisted-exercises-in-water', NULL, NULL, NULL), -- «Hidrokinesiotherapy 30 min — Therapeutic exercises performed in water…» (единственная запись упражнений в воде)
('electrotherapy', NULL, NULL, NULL), -- «Electrotherapy»
('ultrasound-therapy', NULL, NULL, NULL), -- «Ultrasound Therapy»
('magnetic-therapy', NULL, NULL, NULL), -- «Magnetotherapy 30 min — Low-frequency magnetic field therapy…»
('hilt-laser-therapy', NULL, NULL, NULL), -- «HILT – High Intensity Laser»
('shock-wave-therapy', NULL, NULL, NULL), -- «Shock Wave Therapy»
('tecar-therapy', NULL, NULL, NULL), -- «TECAR Therapy — Radiofrequency therapy…»
('manual-therapy', NULL, NULL, NULL), -- Manual Therapy — «Holistic Manual Treatments 45 - 90 min», «Regenerative Therapeutic Manual Treatments 30 - 90 min», «Target Manual Treatment 20 - 30 min»
('cupping-therapy', NULL, NULL, NULL), -- «CuMan Therapy (Cupping and Manual Therapy) 30 - 90 min»
('pressotherapy', NULL, NULL, NULL), -- «Lymphatic Drainage by Apparatus 30 - 40 min — Mechanical lymphatic stimulation…»
('lymphatic-drainage-complete', NULL, NULL, NULL), -- «Manual Lymphatic Drainage 30 - 60 min» (длительность диапазоном — generic-запись, синоним Manual Lymphatic Drainage)
('apparatus-assisted-massage', NULL, NULL, NULL), -- «Vibro Massage 20 - 30 min — Therapeutic vibration massage…» («Aparaturna masaža»)
('hydrotherapy-underwater-massage', NULL, NULL, NULL), -- «Underwater Shower Massage 20 min»
('pearl-bath-therapy', NULL, NULL, NULL), -- «Bubble Bath 20 min — Relaxing hydrotherapy bath with warm, bubbling water» («Terapija bisernim kupkama»)
('thermotherapy-thermo-pack', NULL, NULL, NULL), -- «Thermo Herbal Packing 30 min — Warm herbal compress therapy that combines heat and medicinal herbs to relieve pain…»
('taping-application', NULL, NULL, NULL), -- «Kinesio Taping»
('dry-needling', NULL, NULL, NULL), -- «Dry Needling»
('botox-injection', NULL, NULL, NULL), -- Beauty Treatments — «Botox Non-Surgical Injectable Treatment»
('hyaluronic-acid-filler', NULL, NULL, NULL), -- «Hyaluronic Acid Fillers»
('profhilo-treatment', NULL, NULL, NULL), -- «Profhilo®»
('exosome-therapy', NULL, NULL, NULL), -- «Exosome Therapy» (топические экзосомы после микронидлинга/лазера)
('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- «Mesotherapy Skin Rejuvenation Treatment … microinjections» (зоны: лицо, под глазами, шея, руки…)
('scalp-mesotherapy', NULL, NULL, NULL), -- Mesotherapy — «What Areas Can Mesotherapy Treat? … Scalp and hair thinning areas»
('dermapen-microneedling', NULL, NULL, NULL), -- Facial Treatments — «Dermapen Face + Booster 75 Minutes», «Dermapen Face, Neck & Décolleté + Booster 75 Minutes»
('emface-facial-treatment', NULL, NULL, NULL), -- «Emface 1 Area 30 Minutes», «Emface 2 Areas 45 Minutes»
('hifem-therapy', NULL, NULL, NULL), -- Physical Therapy — «HIFEM/HIFM Therapy» (координатор 2026-10-09)
('pulmonary-rehabilitation', NULL, 550.00, NULL); -- «Pure Breath Experience — Respiratory Support Program», «Duration: From 5 Days», «€550,00» («Standalone package not including accommodations») → от 550 €. Остальные 5 программ — wellness (детокс-голодание, антистресс, иммунитет, healthy aging, менеджеры), не заведены (координатор 2026-10-09)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_vrmac_health_wellbeing_retreat_kotor t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_vrmac_health_wellbeing_retreat_kotor t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_vrmac_health_wellbeing_retreat_kotor t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 3
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_vrmac_health_wellbeing_retreat_kotor_ds;
CREATE TEMPORARY TABLE tmp_vrmac_health_wellbeing_retreat_kotor_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_vrmac_health_wellbeing_retreat_kotor_ds (doctor_slug, service_slug) VALUES
('marina-delic', 'specialist-examination'), -- единственный названный врач, Head Doctor — «initial consultation is conducted by our … doctors»
('marina-delic', 'follow-up-specialist-examination'), -- Head Doctor
('marina-delic', 'pulmonary-rehabilitation'); -- физиатр с субспециализацией по пульмонологии; программа — «Initial/Final Medical Check-up with Written Medical Report»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_vrmac_health_wellbeing_retreat_kotor_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_vrmac_health_wellbeing_retreat_kotor_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 44 услуг, с ценой 1 (pulmonary-rehabilitation, price_min 550).
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

DROP TEMPORARY TABLE IF EXISTS tmp_vrmac_health_wellbeing_retreat_kotor;
DROP TEMPORARY TABLE IF EXISTS tmp_vrmac_health_wellbeing_retreat_kotor_ds;

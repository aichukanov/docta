-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija Fontis (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-fontis-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ordinacija-fontis-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/ordinacija-fontis-podgorica.json.
-- 
-- Услуг: 26, с ценой: 0 (цен на сайте нет). Новые записи каталога: radiofrequency-skin-tightening (только здесь); hydradermabrasion и microdermabrasion (агент Y, те же,
-- что в insert-clinic-medcontour-institute-budva-services.sql, идемпотентно по slug — порядок применения двух файлов не важен).
-- Интерна (17) — все с привязкой к predrag-maras; УЗИ и допплер — существующие записи + kidney-ultrasound (запись агента Z, PART 0 как в insert-clinic-ordinacija-dr-rahovic-bijelo-polje-services.sql).
-- Из «Tretmani lica» (решение координатора 2026-10-09) заведены медэстетические процедуры: хим. пилинг лица и спины, микродермабразия
-- (Reviderm), мезотерапия, RF Bipolar → radiofrequency-skin-tightening (новая), Ballancer Pro → pressotherapy; без привязки к врачу (эстетику ведут косметологи).
-- Не заведены: BICOM biorezonanca (альтернативная медицина), косметический уход «Tretmani lica» и «Njega kože», препараты (товары).
-- is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJeemPdTrrTRMRDf_15muQOhc' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ordinacija-fontis-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ordinacija-fontis-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Запись агента Z (2026-10-09, впервые — ordinacija-dr-rahovic-bijelo-polje); создаётся идемпотентно по slug теми же значениями, что и в insert-clinic-ordinacija-dr-rahovic-bijelo-polje-services.sql. Fontis: «ultrazvučni pregledi (… bubrezi …)».
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'kidney-ultrasound', 'Kidney Ultrasound', 'Ultrazvuk bubrega', 'Ултразвук бубрега',
	'УЗИ почек', 'Nierenultraschall', 'Böbrek ultrasonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'kidney-ultrasound' OR name_en = 'Kidney Ultrasound');

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

-- Решение координатора 2026-10-09. Fontis /services/tretmani-lica-fontis — «RF Bipolar tretman – radiofrekventna tehnologija za poboljšanje tonusa, zatezanje kože i stimulaciju kolagena». Общей RF-записи без бренда в каталоге нет (exilis-*, ultraformer-*, renuvion — бренды; morpheus8 — RF-микронидлинг; face-and-body-skin-tightening — метод не указан). Категории как у exilis/morpheus8: 18 + 24, спец. 7 + 18 + 44.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'radiofrequency-skin-tightening', 'Radiofrequency Skin Tightening', 'Radiofrekventno zatezanje kože', 'Радиофреквентно затезање коже',
	'Радиочастотный лифтинг кожи', 'Radiofrequenz-Hautstraffung', 'Radyofrekans cilt sıkılaştırma', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'radiofrequency-skin-tightening' OR name_en = 'Radiofrequency Skin Tightening');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('kidney-ultrasound');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('microdermabrasion', 'radiofrequency-skin-tightening');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 24 FROM medical_services WHERE slug IN ('hydradermabrasion', 'microdermabrasion', 'radiofrequency-skin-tightening');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('hydradermabrasion', 'microdermabrasion', 'radiofrequency-skin-tightening');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug IN ('kidney-ultrasound');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 18 FROM medical_services WHERE slug IN ('microdermabrasion', 'radiofrequency-skin-tightening');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 44 FROM medical_services WHERE slug IN ('hydradermabrasion', 'radiofrequency-skin-tightening');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Eho bubrega', 'sr' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Ехо бубрега', 'sr-cyrl' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'UZ bubrega', 'sr' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'УЗ бубрега', 'sr-cyrl' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Renal Ultrasound', 'en' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Ультразвук почек', 'ru' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Nierensonographie', 'de' FROM medical_services WHERE slug = 'kidney-ultrasound'
UNION ALL SELECT id, 'Böbrek USG', 'tr' FROM medical_services WHERE slug = 'kidney-ultrasound'
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
UNION ALL SELECT id, 'Dermapen 4', 'en' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Dermapen 4', 'sr' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Dermapen 4 mikronidling', 'sr' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Dermapen 4 микронидлинг', 'sr-cyrl' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Микронидлинг Dermapen 4', 'ru' FROM medical_services WHERE slug = 'dermapen-microneedling'
UNION ALL SELECT id, 'Alma Soprano Titanium', 'en' FROM medical_services WHERE slug = 'alma-soprano-titanium-special-edition-hair-removal'
UNION ALL SELECT id, 'Alma Soprano Titanium laserska epilacija', 'sr' FROM medical_services WHERE slug = 'alma-soprano-titanium-special-edition-hair-removal'
UNION ALL SELECT id, 'Alma Soprano Titanium ласерска епилација', 'sr-cyrl' FROM medical_services WHERE slug = 'alma-soprano-titanium-special-edition-hair-removal'
UNION ALL SELECT id, 'Alma Soprano Titanium Laser Hair Removal', 'en' FROM medical_services WHERE slug = 'alma-soprano-titanium-special-edition-hair-removal'
UNION ALL SELECT id, 'Alma Soprano Titanium Laser-Haarentfernung', 'de' FROM medical_services WHERE slug = 'alma-soprano-titanium-special-edition-hair-removal'
UNION ALL SELECT id, 'Alma Soprano Titanium lazer epilasyon', 'tr' FROM medical_services WHERE slug = 'alma-soprano-titanium-special-edition-hair-removal'
UNION ALL SELECT id, 'Reviderm', 'en' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'Reviderm', 'sr' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'Reviderm mikrodermoabrazija', 'sr' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'Reviderm микродермоабразија', 'sr-cyrl' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'Микродермабразия Reviderm', 'ru' FROM medical_services WHERE slug = 'microdermabrasion'
UNION ALL SELECT id, 'RF Bipolar', 'en' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'RF Bipolar', 'sr' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'RF Bipolar tretman', 'sr' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'RF Bipolar третман', 'sr-cyrl' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'Bipolarna radiofrekvencija', 'sr' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'Биполарна радиофреквенција', 'sr-cyrl' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'Радиофреквентно затезање коже', 'sr-cyrl' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'RF Skin Tightening', 'en' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'RF-лифтинг', 'ru' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'RF-Lifting', 'de' FROM medical_services WHERE slug = 'radiofrequency-skin-tightening'
UNION ALL SELECT id, 'Ballancer Pro', 'en' FROM medical_services WHERE slug = 'pressotherapy'
UNION ALL SELECT id, 'Ballancer Pro', 'sr' FROM medical_services WHERE slug = 'pressotherapy'
UNION ALL SELECT id, 'Ballancer Pro limfna drenaža', 'sr' FROM medical_services WHERE slug = 'pressotherapy'
UNION ALL SELECT id, 'Ballancer Pro лимфна дренажа', 'sr-cyrl' FROM medical_services WHERE slug = 'pressotherapy'
UNION ALL SELECT id, 'Прессотерапия Ballancer Pro', 'ru' FROM medical_services WHERE slug = 'pressotherapy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_fontis_podgorica;
CREATE TEMPORARY TABLE tmp_ordinacija_fontis_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ordinacija_fontis_podgorica (slug, price, price_min, price_max) VALUES
('internist-examination', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «opšti internistički pregled»
('ecg', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «EKG»
('holter-blood-pressure-24h', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «24-časovni Holter monitoring krvnog pritiska»
('endocrinologist-examination', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «pregledi iz oblasti endokrinologije» (en: «endocrinology consultations»)
('thyroid-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — štitasta žlijezda
('neck-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — vrat
('breast-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — dojke
('abdomen-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — abdomen
('lower-abdomen-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — mala karlica
('kidney-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — bubrezi (запись агента Z, впервые — ordinacija-dr-rahovic-bijelo-polje, решение координатора 2026-10-09)
('urinary-tract-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — mokraćna bešika (названа отдельно от почек, отдельной записи УЗИ только мочевого пузыря нет, ultrasound-bladder-with-prostate — для «prostata»)
('ultrasound-bladder-with-prostate', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — prostata (трансабдоминально, вместе с мочевым пузырём, трансректальное TRUS сайт не называет)
('testicular-ultrasound', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «ultrazvučni pregledi (štitasta žlijezda, vrat, dojke, abdomen, mala karlica, bubrezi, prostata, mokraćna bešika, testisi)» — testisi
('doppler-neck-blood-vessels', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «color dopler pregledi arterija vrata, ruku i nogu» — vrat
('doppler-upper-extremity-blood-vessels', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «color dopler pregledi arterija vrata, ruku i nogu» — ruke
('doppler-lower-extremity-blood-vessels', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «color dopler pregledi arterija vrata, ruku i nogu» — noge
('nutritionist-specialist-examination', NULL, NULL, NULL), -- /services/ordinacija-za-internu-medicinu «Usluge ordinacije» — «savjeti iz oblasti nutricionizma» (en: «nutritional counselling», синоним «Konsultacija nutricioniste»)
('dermapen-microneedling', NULL, NULL, NULL), -- /services/dermapen-4-mikronidling — «Dermapen 4™ mikronidling je savremeni regenerativni tretman … stvaranjem kontrolisanih mikrokanala»
('hydradermabrasion', NULL, NULL, NULL), -- /services/hydrafacial-tretman — «Hydrafacial je neinvazivan, višestepeni tretman … Hydrafacial važi za najnježniju hidrodermoabraziju» (VORTEX-FUSION™, бустеры — оригинальный аппарат HydraFacial, бренд — синоним)
('alma-soprano-titanium-special-edition-hair-removal', NULL, NULL, NULL), -- /services/laserska-epilacija — «U Fontisu se za lasersku epilaciju koristi Alma Soprano Titanium … PRVI U CRNOJ GORI» (единственная разовая запись этого аппарата, пакеты MOA — не то)
('chemical-peeling-face', NULL, NULL, NULL), -- /services/tretmani-lica-fontis — «Hemijski piling lica i leđa – ciljani tretman za ujednačavanje tena, smanjenje ožiljaka, akni i teksturalnih nepravilnosti» — lice (решение координатора 2026-10-09)
('chemical-peeling-back', NULL, NULL, NULL), -- /services/tretmani-lica-fontis — «Hemijski piling lica i leđa» — leđa
('microdermabrasion', NULL, NULL, NULL), -- /services/tretmani-lica-fontis — «Mikrodermoabrazija lica i leđa (Reviderm) – kontrolisani mehanički piling … Indikacije: akne, ožiljci, pigmentacije, UV oštećenja, strije i bore» (Reviderm — синоним, зона лицо и спина — одна общая запись)
('facial-mesotherapy-single-treatment', NULL, NULL, NULL), -- /services/tretmani-lica-fontis — «Mezoterapija – ciljano unošenje aktivnih supstanci prema indikacijama i stanju kože, za hidrataciju, regeneraciju i revitalizaciju»
('radiofrequency-skin-tightening', NULL, NULL, NULL), -- /services/tretmani-lica-fontis — «RF Bipolar tretman – radiofrekventna tehnologija za poboljšanje tonusa, zatezanje kože i stimulaciju kolagena, idealna za bore, gubitak elastičnosti i slabiju cirkulaciju kože» (RF Bipolar — синоним)
('pressotherapy', NULL, NULL, NULL); -- /services/tretmani-lica-fontis — «Ballancer® Pro – limfna drenaža – aparativni tretman koji podstiče limfnu cirkulaciju … smanjenje otoka» (Ballancer Pro — синоним)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_ordinacija_fontis_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_ordinacija_fontis_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_ordinacija_fontis_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 17
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_fontis_podgorica_ds;
CREATE TEMPORARY TABLE tmp_ordinacija_fontis_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ordinacija_fontis_podgorica_ds (doctor_slug, service_slug) VALUES
('predrag-maras', 'internist-examination'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'ecg'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'holter-blood-pressure-24h'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'endocrinologist-examination'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'thyroid-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'neck-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'breast-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'abdomen-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'lower-abdomen-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'kidney-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'urinary-tract-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'ultrasound-bladder-with-prostate'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'testicular-ultrasound'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'doppler-neck-blood-vessels'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'doppler-upper-extremity-blood-vessels'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'doppler-lower-extremity-blood-vessels'), -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»
('predrag-maras', 'nutritionist-specialist-examination'); -- единственный врач ординации: «Specijalističku internističku djelatnost u Ordinaciji Fontis obavlja dr mr sci. med. Predrag Maraš» + перечень «Usluge ordinacije»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_ordinacija_fontis_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_ordinacija_fontis_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 26 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 17 привязок врач↔услуга.
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
WHERE ms.slug IN ('kidney-ultrasound', 'hydradermabrasion', 'microdermabrasion', 'radiofrequency-skin-tightening');

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_fontis_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_fontis_podgorica_ds;

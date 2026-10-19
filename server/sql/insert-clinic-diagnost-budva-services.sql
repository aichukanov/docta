-- ═══════════════════════════════════════════════════════════════════════════
-- Diagnost — ordinacija za ultrazvučnu dijagnostiku (Budva) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-diagnost-budva-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-diagnost-budva.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/diagnost-budva.json.
-- 
-- Услуг: 14, анализов: 0, с ценой: 0 (цен на сайте нет). Источник — меню и 11 страниц исследований (2021-07).
-- Новые записи каталога: infant-spinal-ultrasound, voiding-urosonography — идемпотентно по slug.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJKQtwIC_VTRMRbjpsrWfQwiI' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'diagnost-budva' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-diagnost-budva.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Diagnost: «UZ pregled kičme kod beba» — «ultrazvuk kičme kod novorođenčadi i mlađe odojčadi zbog dijagnostike spine bifide». В каталоге есть УЗИ мозга и бёдер младенцев, УЗИ позвоночника (спинного мозга) у младенцев нет ни под одним названием (поиск spin|kičm + ultra). Схема категорий/специальностей — как у infant-brain-ultrasound-neurosonography: 4 ULTRASOUND + 25 PEDIATRICS; 10 RADIOLOGY, 4 PEDIATRICS, 68 NEONATOLOGY.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'infant-spinal-ultrasound', 'Infant Spinal Ultrasound', 'Ultrazvuk kičme kod beba', 'Ултразвук кичме код беба',
	'УЗИ позвоночника у младенцев', 'Ultraschall der Wirbelsäule bei Säuglingen', 'Bebeklerde omurga ultrasonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'infant-spinal-ultrasound' OR name_en = 'Infant Spinal Ultrasound');

-- Diagnost: «UZ mikciona cistografija» — «zamenjuje pregled koji se doskora radio pod snopom rendgenskih zraka … utvrđuje postojanje refluksa». В каталоге только рентгеновская voiding-cystourethrography (категория 3 XRAY) — другая модальность, ставить её нельзя. Категории 4 ULTRASOUND + 25 PEDIATRICS (исследование детское), специальности 10 RADIOLOGY + 9 UROLOGY (как у VCUG) + 4 PEDIATRICS.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'voiding-urosonography', 'Voiding Urosonography', 'Ultrazvučna mikciona cistografija', 'Ултразвучна микциона цистографија',
	'Микционная уросонография (УЗИ-цистография)', 'Miktionsurosonographie', 'İşeme ürosonografisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'voiding-urosonography' OR name_en = 'Voiding Urosonography');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('infant-spinal-ultrasound', 'voiding-urosonography');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 25 FROM medical_services WHERE slug IN ('infant-spinal-ultrasound', 'voiding-urosonography');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('infant-spinal-ultrasound', 'voiding-urosonography');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 9 FROM medical_services WHERE slug IN ('voiding-urosonography');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug IN ('infant-spinal-ultrasound', 'voiding-urosonography');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 68 FROM medical_services WHERE slug IN ('infant-spinal-ultrasound');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'UZ kičme kod beba', 'sr' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'УЗ кичме код беба', 'sr-cyrl' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'Ultrazvuk kičme kod novorođenčadi', 'sr' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'Ултразвук кичме код новорођенчади', 'sr-cyrl' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'Spinal Ultrasound in Newborns', 'en' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'Neonatal Spine Ultrasound', 'en' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'УЗИ спинного мозга у новорождённых', 'ru' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'Wirbelsäulensonographie beim Neugeborenen', 'de' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'Yenidoğan spinal ultrasonu', 'tr' FROM medical_services WHERE slug = 'infant-spinal-ultrasound'
UNION ALL SELECT id, 'UZ mikciona cistografija', 'sr' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'УЗ микциона цистографија', 'sr-cyrl' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'Ultrazvučna mikcijska cistografija', 'sr' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'VUS', 'en' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'Ultrasound Voiding Cystography', 'en' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'Contrast-Enhanced Voiding Urosonography', 'en' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'Ультразвуковая микционная цистография', 'ru' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'Ultraschall-Miktionszystographie', 'de' FROM medical_services WHERE slug = 'voiding-urosonography'
UNION ALL SELECT id, 'Ultrason ile işeme sistografisi', 'tr' FROM medical_services WHERE slug = 'voiding-urosonography';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_diagnost_budva;
CREATE TEMPORARY TABLE tmp_diagnost_budva (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_diagnost_budva (slug, price, price_min, price_max) VALUES
('pediatric-hip-ultrasound', NULL, NULL, NULL), -- «UZ pregled kukova kod beba» — «Ultrazvuk kukova je pregled koji se obavezno radi kod svakog deteta u uzrastu do 3 meseca …»
('infant-brain-ultrasound-neurosonography', NULL, NULL, NULL), -- «UZ pregled mozga beba», главная: «ultrazvuk centralnog nervnog sistema (CNS) kod novorodjenčadi i odojčadi»
('infant-spinal-ultrasound', NULL, NULL, NULL), -- «UZ pregled kičme kod beba» — «ultrazvuk kičme kod novorodjenčadi i mladje odojčadi zbog dijagnostike spine bifide» (НОВАЯ)
('gynecological-ultrasound', NULL, NULL, NULL), -- «UZ pregled male karlice» — главная: «ultrazvuk male karlice kod dece kod sumnje na ginekološke anomalije i preuranjeni pubertet kod devojčica», страница: и у мальчиков, и у взрослых. «Ultrazvuk male karlice» в каталоге — синоним gynecological-ultrasound, отдельной записи УЗИ малого таза нет
('abdomen-ultrasound', NULL, NULL, NULL), -- «UZ pregled abdomena» — «jetre, žučne kese, žučnih puteva, pankreasa, slezine, bubrega, nadbubrežnih žlezda, mokraćne bešike, aorte, retroperitonealnog prostora»
('breast-ultrasound', NULL, NULL, NULL), -- «UZ pregled dojki» / «ultrazvučni pregled dojki»
('urinary-tract-ultrasound', NULL, NULL, NULL), -- «UZ pregled urinarnog trakta kod dece» — «kod ponavljanih urinarnih infekcija, sumnje na urodjene anomalije urotrakta …»
('voiding-urosonography', NULL, NULL, NULL), -- «UZ mikciona cistografija» — «zamenjuje pregled koji se doskora radio pod snopom rendgenskih zraka … Naša ordinacija je jedina ustanova u Crnoj Gori u kojoj se vrši ovaj pregled» (НОВАЯ)
('thyroid-ultrasound', NULL, NULL, NULL), -- «UZ pregled štitaste žlezde», главная: «ultrazvuk štitaste žlezde i mekih tkiva vrata dece i odraslih»
('ultrasound-neck-glands-and-soft-tissue', NULL, NULL, NULL), -- главная: «… i mekih tkiva vrata», страница щитовидки: «prikazuju se i limfni čvorovi na vratu, kao i pljuvačne žlezde» (у записи синоним «Ultrazvuk mekih tkiva vrata»)
('testicular-ultrasound', NULL, NULL, NULL), -- «UZ pregled testisa» — «dece i odraslih i uz pregled nespuštenih testisa kod dečaka»
('doppler-renal-arteries', NULL, NULL, NULL), -- «Color dopler ultrazvuk»: «krvnim sudovima … bubrega (najčešće kod povišenog krvnog pritiska)», главная: «kolor dopler (CD) pregled krvnih sudova bubrega i portnog sistema»
('doppler-portal-vein', NULL, NULL, NULL), -- «Color dopler»: «krvnim sudovima jetre (kod raznih hroničnih bolesti jetre)», главная: «… i portnog sistema … sumnje na portnu hipertenziju»
('doppler-neck-blood-vessels', NULL, NULL, NULL); -- «Color dopler»: «… kao i na krvnim sudovima vrata»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_diagnost_budva t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_diagnost_budva t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_diagnost_budva t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 14
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_diagnost_budva_ds;
CREATE TEMPORARY TABLE tmp_diagnost_budva_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_diagnost_budva_ds (doctor_slug, service_slug) VALUES
('marija-mandic', 'pediatric-hip-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'infant-brain-ultrasound-neurosonography'), -- единственный врач кабинета
('marija-mandic', 'infant-spinal-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'gynecological-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'abdomen-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'breast-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'urinary-tract-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'voiding-urosonography'), -- единственный врач кабинета
('marija-mandic', 'thyroid-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'ultrasound-neck-glands-and-soft-tissue'), -- единственный врач кабинета
('marija-mandic', 'testicular-ultrasound'), -- единственный врач кабинета
('marija-mandic', 'doppler-renal-arteries'), -- единственный врач кабинета
('marija-mandic', 'doppler-portal-vein'), -- единственный врач кабинета
('marija-mandic', 'doppler-neck-blood-vessels'); -- единственный врач кабинета

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_diagnost_budva_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_diagnost_budva_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 14 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 14 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 2: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('infant-spinal-ultrasound', 'voiding-urosonography');

DROP TEMPORARY TABLE IF EXISTS tmp_diagnost_budva;
DROP TEMPORARY TABLE IF EXISTS tmp_diagnost_budva_ds;

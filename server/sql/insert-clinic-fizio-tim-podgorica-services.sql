-- ═══════════════════════════════════════════════════════════════════════════
-- Fizio Tim (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-fizio-tim-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-fizio-tim-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/fizio-tim-podgorica.json.
-- 
-- Услуг: 30, с ценой: 0 (цен на сайте нет). Записи каталога, создаваемые здесь идемпотентно по slug:
--   dynamic-neuromuscular-stabilization (агент U, также в insert-clinic-seastars-herceg-novi-services.sql),
--   thermotherapy (запись координатора 2026-10-09, блок как в insert-clinic-physiocare-team-podgorica-services.sql).
-- Акупунктура сопоставлена с acupuncture: сайт называет её «medicinska akupunktura» (метод физиотерапевтов), это не альтернативная
-- медицина в смысле Healing Centar. Не заведены: Yumeiho, visceralne manipulacije (альтернативная медицина), vibroterapija
-- (только в перечне аппаратов, записи нет), kineziterapija na domu (в каталоге только выезды по километражу).
-- is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJhRgbph3rTRMR6FfMAsrhluk' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'fizio-tim-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-fizio-tim-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Именная методика (Пражская школа, DNS): SeaStars /tretmani «Dinamička neuromuskularna stabilizacija», Fizio Tim /kineziterapija «DNS (Dinamička neuromuskularna stabilizacija)». В каталоге записи нет (kinesiotherapy — общая ЛФК, PNF заведён синонимом к ней, но DNS — отдельный метод, сайты называют его отдельно). Кат. 5 PHYSIOTHERAPY, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dynamic-neuromuscular-stabilization', 'Dynamic Neuromuscular Stabilization', 'Dinamička neuromuskularna stabilizacija', 'Динамичка неуромускуларна стабилизација',
	'Динамическая нейромышечная стабилизация (DNS)', 'Dynamische neuromuskuläre Stabilisation (DNS)', 'Dinamik nöromüsküler stabilizasyon (DNS)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization' OR name_en = 'Dynamic Neuromuscular Stabilization');

-- Запись координатора (2026-10-09, впервые — physiocare-team-podgorica); создаётся идемпотентно по slug теми же значениями, что и в insert-clinic-physiocare-team-podgorica-services.sql.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'thermotherapy', 'Thermotherapy', 'Termoterapija', 'Термотерапија',
	'Термотерапия', 'Thermotherapie', 'Termoterapi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'thermotherapy' OR name_en = 'Thermotherapy');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('dynamic-neuromuscular-stabilization', 'thermotherapy');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN ('dynamic-neuromuscular-stabilization', 'thermotherapy');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'DNS', 'en' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'DNS', 'sr' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'DNS', 'ru' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Динамичка неуромускуларна стабилизација', 'sr-cyrl' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Dinamička neuromišićna stabilizacija', 'sr' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Prague School of Rehabilitation', 'en' FROM medical_services WHERE slug = 'dynamic-neuromuscular-stabilization'
UNION ALL SELECT id, 'Toplotna terapija', 'sr' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Топлотна терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Heat Therapy', 'en' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Тепловая терапия', 'ru' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Wärmetherapie', 'de' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Sıcak tedavisi', 'tr' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Limfna drenaža po Vodderu', 'sr' FROM medical_services WHERE slug = 'lymphatic-drainage-complete'
UNION ALL SELECT id, 'Лимфна дренажа по Водеру', 'sr-cyrl' FROM medical_services WHERE slug = 'lymphatic-drainage-complete'
UNION ALL SELECT id, 'Vodder Lymphatic Drainage', 'en' FROM medical_services WHERE slug = 'lymphatic-drainage-complete'
UNION ALL SELECT id, 'Лимфодренаж по Воддеру', 'ru' FROM medical_services WHERE slug = 'lymphatic-drainage-complete'
UNION ALL SELECT id, 'Lymphdrainage nach Vodder', 'de' FROM medical_services WHERE slug = 'lymphatic-drainage-complete'
UNION ALL SELECT id, 'EMS', 'en' FROM medical_services WHERE slug = 'muscle-electrical-stimulation'
UNION ALL SELECT id, 'EMS', 'sr' FROM medical_services WHERE slug = 'muscle-electrical-stimulation'
UNION ALL SELECT id, 'Elektromišićna stimulacija', 'sr' FROM medical_services WHERE slug = 'muscle-electrical-stimulation'
UNION ALL SELECT id, 'Електромишићна стимулација', 'sr-cyrl' FROM medical_services WHERE slug = 'muscle-electrical-stimulation'
UNION ALL SELECT id, 'Электромиостимуляция', 'ru' FROM medical_services WHERE slug = 'muscle-electrical-stimulation'
UNION ALL SELECT id, 'Cupping masaža', 'sr' FROM medical_services WHERE slug = 'cupping-therapy'
UNION ALL SELECT id, 'Cupping масажа', 'sr-cyrl' FROM medical_services WHERE slug = 'cupping-therapy'
UNION ALL SELECT id, 'Cupping Massage', 'en' FROM medical_services WHERE slug = 'cupping-therapy'
UNION ALL SELECT id, 'Баночный массаж', 'ru' FROM medical_services WHERE slug = 'cupping-therapy'
UNION ALL SELECT id, 'Suva punkcija', 'sr' FROM medical_services WHERE slug = 'dry-needling'
UNION ALL SELECT id, 'Сува пункција', 'sr-cyrl' FROM medical_services WHERE slug = 'dry-needling'
UNION ALL SELECT id, 'Сухая пункция', 'ru' FROM medical_services WHERE slug = 'dry-needling'
UNION ALL SELECT id, 'Medicinska akupunktura', 'sr' FROM medical_services WHERE slug = 'acupuncture'
UNION ALL SELECT id, 'Медицинска акупунктура', 'sr-cyrl' FROM medical_services WHERE slug = 'acupuncture'
UNION ALL SELECT id, 'Medical Acupuncture', 'en' FROM medical_services WHERE slug = 'acupuncture'
UNION ALL SELECT id, 'Mišićno skeletni ultrazvuk', 'sr' FROM medical_services WHERE slug = 'musculoskeletal-ultrasound'
UNION ALL SELECT id, 'MSK ultrazvuk', 'sr' FROM medical_services WHERE slug = 'musculoskeletal-ultrasound'
UNION ALL SELECT id, 'MSK ултразвук', 'sr-cyrl' FROM medical_services WHERE slug = 'musculoskeletal-ultrasound'
UNION ALL SELECT id, 'Mobilizacije i manipulacije', 'sr' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Мобилизације и манипулације', 'sr-cyrl' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Spinal Manipulation', 'en' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Miofascijalna relaksacija', 'sr' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Kinesiotaping', 'sr' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'HILT laser', 'sr' FROM medical_services WHERE slug = 'hilt-laser-therapy'
UNION ALL SELECT id, 'Sportska rehabilitacija', 'sr' FROM medical_services WHERE slug = 'sports-injury-rehabilitation'
UNION ALL SELECT id, 'Спортска рехабилитација', 'sr-cyrl' FROM medical_services WHERE slug = 'sports-injury-rehabilitation'
UNION ALL SELECT id, 'Sports Rehabilitation', 'en' FROM medical_services WHERE slug = 'sports-injury-rehabilitation'
UNION ALL SELECT id, 'Спортивная реабилитация', 'ru' FROM medical_services WHERE slug = 'sports-injury-rehabilitation';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_tim_podgorica;
CREATE TEMPORARY TABLE tmp_fizio_tim_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_fizio_tim_podgorica (slug, price, price_min, price_max) VALUES
('sports-injury-rehabilitation', NULL, NULL, NULL), -- Usluge → Sportska rehabilitacija — «Uža specijalnost naše ustanove je REHABILITACIJA SPORTSKIH POVREDA»
('first-physiatrist-examination', NULL, NULL, NULL), -- Sportska rehabilitacija — «možete zakazati: – Pregled specijaliste fizijatra ili specijaliste primijenjene fizioterapije»
('physiotherapist-examination', NULL, NULL, NULL), -- Sportska rehabilitacija — «… ili specijaliste primijenjene fizioterapije», Elektroterapija — «Prije svakog tretmana, potrebno je izvršiti specijalistički pregled … i izvršiti posebna testiranja»
('musculoskeletal-ultrasound', NULL, NULL, NULL), -- Usluge → Mišićno skeletni ultrazvuk — «dijagnostički (mišićno-skeletni) ultrazvuk … FIZIO TIM sarađuje sa više stručnjaka iz ove oblasti, koji su specijalisti radiologije, fizikalne medicine ili ortopedije»
('preoperative-rehabilitation', NULL, NULL, NULL), -- Sportska rehabilitacija — «Preoperativnu pripremu i postoperativni oporavak nakon raznih operacija koljena i ramena»
('postoperative-locomotor-system-rehabilitation', NULL, NULL, NULL), -- Sportska rehabilitacija — «… postoperativni oporavak nakon raznih operacija koljena i ramena i dr (ligamentoplastika prednjeg ukrštenog ligamenta, povrede meniskusa …)»
('tecar-therapy', NULL, NULL, NULL), -- Usluge → Indiba - Tecar terapija — «Tecar terapiju radimo sa najboljim i najprodavanijim TECAR uređajem u svijetu – Indibom» (INDIBA — уже синоним)
('electrotherapy', NULL, NULL, NULL), -- Usluge → Elektroterapija — «korišćenje neke vrste električne struje u terapijske svrhe … (INTERFERENTNE STRUJE, TENS, GALVANIZACIJA, ELEKTROFOREZA, DIJADINAMIK i dr.)»
('shock-wave-therapy', NULL, NULL, NULL), -- Usluge → Shockwave — «SHOCKWAVE ili terapija udarnim talasom»
('lymphatic-drainage-complete', NULL, NULL, NULL), -- Usluge → Limfna drenaža — «specijalna manuelna tehnika … sertifikate po Voderu» (зона не указана — общая запись, как у большинства клиник)
('muscle-electrical-stimulation', NULL, NULL, NULL), -- Usluge → Elektromišićna stimulacija — «EMS ili ELEKTROMIŠIĆNA STIMULACIJA … Aparat za EMS – COMPEX» (Compex — уже синоним)
('cupping-therapy', NULL, NULL, NULL), -- Usluge → Cupping masaža — «CUPPING terapija (vakum) … plasiraju se ventuze ili čašice»
('dry-needling', NULL, NULL, NULL), -- Usluge → Dry needling i akupunktura — «DRY NEEDLING-MEDICINSKA AKUPUNKTURA je tehnika kojom se iglice, plasiraju u mišiće … TRIGGER POINTS»
('acupuncture', NULL, NULL, NULL), -- Usluge → «Dry needling i akupunktura — Liječenje putem igala – akupunktura …», /nas-tim — «MEDICINSKA AKUPUNKTURA»
('electroacupuncture', NULL, NULL, NULL), -- Dry needling i akupunktura — «iglice stimulisati putem određenih električnih impulsa i ta tehnika se zove ELEKTROAKUPUNKTURA … se kod nas uspješno sprovode»
('thermotherapy', NULL, NULL, NULL), -- Dry needling i akupunktura — «kombinovati sa … TERAPIJA TOPLOTOM … Sve ove pobrojane metode … se kod nas uspješno sprovode», Cupping — «pripremna procedura (masaža, terapija toplotom)» (запись координатора 2026-10-09)
('manual-therapy', NULL, NULL, NULL), -- /nas-tim — «manuelne tehnike … (masaža, limfna drenaža, mobilizacije, manipulacije …)», Dry needling — «MIOFASCIJALNA RELAKSACIJA»
('therapeutic-massage-complete', NULL, NULL, NULL), -- /nas-tim — «manuelne tehnike koje sprovodimo preventivno i o cilju oporavka (masaža …)» (зона и длительность не указаны — generic)
('kinesiotherapy', NULL, NULL, NULL), -- Usluge → Kineziterapija — «KINEZITERAPIJA … ili medicinske vježbe … aktivne, aktivno-potpomognute, pasivne … PNF (Proprioceptivna neuromuskularna facilitacija)» (PNF — уже синоним)
('individual-kinesiotherapy', NULL, NULL, NULL), -- Kineziterapija — «za djecu i odrasle, trudnice i porodilje, grupno ili individualno»
('group-exercises-type-b', NULL, NULL, NULL), -- Kineziterapija — «… grupno ili individualno»
('pregnancy-exercises', NULL, NULL, NULL), -- Kineziterapija — «za djecu i odrasle, trudnice i porodilje», «da se pripremite ili oporavite nakon porođaja»
('schroth-method', NULL, NULL, NULL), -- Kineziterapija — «– SCHROTH (za korekciju posturalnih deformiteta)»
('dynamic-neuromuscular-stabilization', NULL, NULL, NULL), -- Kineziterapija — «– DNS (Dinamička neuromuskularna stabilizacija)»
('hilt-laser-therapy', NULL, NULL, NULL), -- /nas-tim — «uz opremu koju posjedujemo (INDIBA- TECAR, SHOCKWAVE, HILT LASER …)»
('ultrasound-therapy', NULL, NULL, NULL), -- /nas-tim — «kombinovani aparati za … terapiju ultrazvukom»
('magnetic-therapy', NULL, NULL, NULL), -- /nas-tim — «… magnetoterapiju»
('laser-therapy', NULL, NULL, NULL), -- /nas-tim — «… laseroterapiju» (отдельно от HILT LASER)
('iastm-therapy', NULL, NULL, NULL), -- /nas-tim — «nove tehnike (ERGON IASTM …)», сертификаты обоих «ERGON IASTM-oba levela» (Ergon — уже синоним)
('taping-application', NULL, NULL, NULL); -- /nas-tim — «KINESIOTAPING», сертификаты обоих «Kinesiotaping-oba levela»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_fizio_tim_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_fizio_tim_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_fizio_tim_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 22
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_tim_podgorica_ds;
CREATE TEMPORARY TABLE tmp_fizio_tim_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_fizio_tim_podgorica_ds (doctor_slug, service_slug) VALUES
('srdjan-kojic', 'sports-injury-rehabilitation'), -- смер «sportska fizioterapija», «najviše se bavi sportskim povredama» / опыт со сборными
('alen-pepic', 'sports-injury-rehabilitation'), -- смер «sportska fizioterapija», «najviše se bavi sportskim povredama» / опыт со сборными
('srdjan-kojic', 'physiotherapist-examination'), -- косвенно: оба «specijalista primijenjene fizioterapije» — сайт предлагает «pregled … specijaliste primijenjene fizioterapije»
('alen-pepic', 'physiotherapist-examination'), -- косвенно: оба «specijalista primijenjene fizioterapije» — сайт предлагает «pregled … specijaliste primijenjene fizioterapije»
('srdjan-kojic', 'shock-wave-therapy'), -- «prvi sertifikovani SHOCKWAVE terapeut» / «prvi SHOCKWAVE praktičar u Crnoj Gori»
('alen-pepic', 'shock-wave-therapy'), -- «prvi sertifikovani SHOCKWAVE terapeut» / «prvi SHOCKWAVE praktičar u Crnoj Gori»
('srdjan-kojic', 'tecar-therapy'), -- «Sertifikovani INDIBA-TECAR terapeut»
('alen-pepic', 'tecar-therapy'), -- «Sertifikovani INDIBA-TECAR terapeut»
('srdjan-kojic', 'dry-needling'), -- сертификат «Dry needling i elektroakupunktura-oba levela»
('alen-pepic', 'dry-needling'), -- сертификат «Dry needling i elektroakupunktura-oba levela»
('srdjan-kojic', 'electroacupuncture'), -- сертификат «Dry needling i elektroakupunktura-oba levela»
('alen-pepic', 'electroacupuncture'), -- сертификат «Dry needling i elektroakupunktura-oba levela»
('srdjan-kojic', 'iastm-therapy'), -- сертификат «ERGON IASTM-oba levela»
('alen-pepic', 'iastm-therapy'), -- сертификат «ERGON IASTM-oba levela»
('srdjan-kojic', 'taping-application'), -- сертификат «Kinesiotaping-oba levela»
('alen-pepic', 'taping-application'), -- сертификат «Kinesiotaping-oba levela»
('srdjan-kojic', 'cupping-therapy'), -- сертификат «Dry&wet cupping» / «Dry-wet cupping»
('alen-pepic', 'cupping-therapy'), -- сертификат «Dry&wet cupping» / «Dry-wet cupping»
('srdjan-kojic', 'manual-therapy'), -- сертификат «Spinalne (i periferne) manipulacije»
('alen-pepic', 'manual-therapy'), -- сертификат «Spinalne (i periferne) manipulacije»
('srdjan-kojic', 'dynamic-neuromuscular-stabilization'), -- сертификат «DNS» (только у Kojić)
('srdjan-kojic', 'postoperative-locomotor-system-rehabilitation'); -- «najviše se bavi … postoperativnom rehabilitacijom»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_fizio_tim_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_fizio_tim_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 30 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 22 привязок врач↔услуга.
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
WHERE ms.slug IN ('dynamic-neuromuscular-stabilization', 'thermotherapy');

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_tim_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_fizio_tim_podgorica_ds;

-- ═══════════════════════════════════════════════════════════════════════════
-- Dr Radunović – kiropraktika i fizioterapija (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dr-radunovic-kiropraktika-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-dr-radunovic-kiropraktika-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/dr-radunovic-kiropraktika-podgorica.json.
-- 
-- Услуг: 17, с ценой: 0 (цен на сайте нет). Новые записи каталога (5): chiropractor-examination, relaxing-massage, sports-massage, face-and-decollete-massage, iontophoresis-for-hyperhidrosis —
-- дублируются в data/clinic-imports/_wave2d-new-catalog-U.json. is_price_outdated не ставится (решение юзера 2026-10-08).
-- Не заведены: Plavi koktel (крем, товар), Refleksologija-masaža stopala (альтернативная медицина), «mehanički stolovi» (без описания).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJR59Y3w_rTRMRQvdUlNg7kZM' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dr-radunovic-kiropraktika-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dr-radunovic-kiropraktika-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- kiropraktika.me: FAQ «Inicijalna analiza pacijenta i funkcionalni pregled može da bude odradjen bez snimka», «Konsultacije se zakazuju», /kiropraktika «Doktor kiropraktike prvo uzima detaljnu anamnezu … pristupa fizikalnom pregledu, ortopedskim i neurološkim testovima, čitanju snimaka». Осмотр доктора хиропрактики ≠ physiotherapist-examination (другая профессия) и ≠ chiropractic-treatment (процедура). Кат. 5, спец. 42, sort_order 1 (осмотр).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'chiropractor-examination', 'Chiropractor Examination', 'Pregled kiropraktičara', 'Преглед киропрактичара',
	'Осмотр хиропрактика', 'Untersuchung beim Chiropraktiker', 'Kayropraktör muayenesi', 1
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'chiropractor-examination' OR name_en = 'Chiropractor Examination');

-- kiropraktika.me /masaže: «Relax masaža … Primarna svrha ove masaže je opuštanje organizma» — длительность не указана. В каталоге только relaxing-massage-60-min; общая запись без длительности (по схеме therapeutic-massage-complete). Кат. 5, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'relaxing-massage', 'Relaxing Massage', 'Relaks masaža', 'Релакс масажа',
	'Расслабляющий массаж', 'Entspannungsmassage', 'Rahatlatıcı masaj', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'relaxing-massage' OR name_en = 'Relaxing Massage');

-- kiropraktika.me /masaže: «Sportska masaža služi za ublažavanje stresa i napetosti … intenzivnija masaža» — длительность не указана. В каталоге только sports-massage-30/45/60-min; общая запись без длительности. Кат. 5, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'sports-massage', 'Sports Massage', 'Sportska masaža', 'Спортска масажа',
	'Спортивный массаж', 'Sportmassage', 'Spor masajı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'sports-massage' OR name_en = 'Sports Massage');

-- kiropraktika.me /masaže: «Masaža lica i dekoltea — Masaža lica služi za opuštanje mišića lica i očiju, ublažava glavobolje i stres». Массажа лица в каталоге нет (есть только аппаратные/инъекционные процедуры лица). Кат. 5 (массаж, делает физиотерапевт), спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'face-and-decollete-massage', 'Face and Decollete Massage', 'Masaža lica i dekoltea', 'Масажа лица и деколтеа',
	'Массаж лица и зоны декольте', 'Gesichts- und Dekolletémassage', 'Yüz ve dekolte masajı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'face-and-decollete-massage' OR name_en = 'Face and Decollete Massage');

-- kiropraktika.me /jontoforeza: «jontoforeza za hiperhidrozu … uređaj koji generiše jednosmjernu struju … stavljanje ruku i/ili stopala u dvije plitke posude napunjene sa vodom sa česme. Tretman traje 10-20 minuta». Водопроводный ионофорез без лекарства — не electrophoresis (введение препарата током) и не botox. Кат. 5 PHYSIOTHERAPY + 24 DERMATOLOGY (показание — гипергидроз), спец. 42 + 7 (авто по категориям).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'iontophoresis-for-hyperhidrosis', 'Iontophoresis for Hyperhidrosis', 'Jontoforeza za hiperhidrozu', 'Јонтофореза за хиперхидрозу',
	'Ионофорез при гипергидрозе', 'Iontophorese bei Hyperhidrose', 'Hiperhidroz için iyontoforez', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'iontophoresis-for-hyperhidrosis' OR name_en = 'Iontophoresis for Hyperhidrosis');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('chiropractor-examination', 'relaxing-massage', 'sports-massage', 'face-and-decollete-massage', 'iontophoresis-for-hyperhidrosis');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 24 FROM medical_services WHERE slug IN ('iontophoresis-for-hyperhidrosis');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 7 FROM medical_services WHERE slug IN ('iontophoresis-for-hyperhidrosis');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN ('chiropractor-examination', 'relaxing-massage', 'sports-massage', 'face-and-decollete-massage', 'iontophoresis-for-hyperhidrosis');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Konsultacija kiropraktičara', 'sr' FROM medical_services WHERE slug = 'chiropractor-examination'
UNION ALL SELECT id, 'Консултација киропрактичара', 'sr-cyrl' FROM medical_services WHERE slug = 'chiropractor-examination'
UNION ALL SELECT id, 'Chiropractic Consultation', 'en' FROM medical_services WHERE slug = 'chiropractor-examination'
UNION ALL SELECT id, 'Консультация хиропрактика', 'ru' FROM medical_services WHERE slug = 'chiropractor-examination'
UNION ALL SELECT id, 'Chiropraktische Untersuchung', 'de' FROM medical_services WHERE slug = 'chiropractor-examination'
UNION ALL SELECT id, 'Relax masaža', 'sr' FROM medical_services WHERE slug = 'relaxing-massage'
UNION ALL SELECT id, 'Релакс масажа', 'sr-cyrl' FROM medical_services WHERE slug = 'relaxing-massage'
UNION ALL SELECT id, 'Relaxation Massage', 'en' FROM medical_services WHERE slug = 'relaxing-massage'
UNION ALL SELECT id, 'Релакс-массаж', 'ru' FROM medical_services WHERE slug = 'relaxing-massage'
UNION ALL SELECT id, 'Спортска масажа', 'sr-cyrl' FROM medical_services WHERE slug = 'sports-massage'
UNION ALL SELECT id, 'Masaža lica', 'sr' FROM medical_services WHERE slug = 'face-and-decollete-massage'
UNION ALL SELECT id, 'Масажа лица', 'sr-cyrl' FROM medical_services WHERE slug = 'face-and-decollete-massage'
UNION ALL SELECT id, 'Facial Massage', 'en' FROM medical_services WHERE slug = 'face-and-decollete-massage'
UNION ALL SELECT id, 'Массаж лица', 'ru' FROM medical_services WHERE slug = 'face-and-decollete-massage'
UNION ALL SELECT id, 'Gesichtsmassage', 'de' FROM medical_services WHERE slug = 'face-and-decollete-massage'
UNION ALL SELECT id, 'Yüz masajı', 'tr' FROM medical_services WHERE slug = 'face-and-decollete-massage'
UNION ALL SELECT id, 'Jontoforeza', 'sr' FROM medical_services WHERE slug = 'iontophoresis-for-hyperhidrosis'
UNION ALL SELECT id, 'Јонтофореза', 'sr-cyrl' FROM medical_services WHERE slug = 'iontophoresis-for-hyperhidrosis'
UNION ALL SELECT id, 'Tap Water Iontophoresis', 'en' FROM medical_services WHERE slug = 'iontophoresis-for-hyperhidrosis'
UNION ALL SELECT id, 'Лечение потливости током', 'ru' FROM medical_services WHERE slug = 'iontophoresis-for-hyperhidrosis'
UNION ALL SELECT id, 'Leitungswasser-Iontophorese', 'de' FROM medical_services WHERE slug = 'iontophoresis-for-hyperhidrosis'
UNION ALL SELECT id, 'Graston', 'en' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Graston Technique', 'en' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Graston tehnika', 'sr' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Грастон техника', 'sr-cyrl' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Техника Грастона', 'ru' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Graston-Technik', 'de' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Kiropraktičko namještanje', 'sr' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Киропрактичко намјештање', 'sr-cyrl' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Namještanje kičme', 'sr' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Намјештање кичме', 'sr-cyrl' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Chiropractic Adjustment', 'en' FROM medical_services WHERE slug = 'chiropractic-treatment'
UNION ALL SELECT id, 'Vježbe za zdravu kičmu', 'sr' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Вјежбе за здраву кичму', 'sr-cyrl' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Individualne vježbe sa terapeutom', 'sr' FROM medical_services WHERE slug = 'individual-kinesiotherapy'
UNION ALL SELECT id, 'Индивидуалне вјежбе са терапеутом', 'sr-cyrl' FROM medical_services WHERE slug = 'individual-kinesiotherapy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_dr_radunovic_kiropraktika_podgorica;
CREATE TEMPORARY TABLE tmp_dr_radunovic_kiropraktika_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dr_radunovic_kiropraktika_podgorica (slug, price, price_min, price_max) VALUES
('chiropractor-examination', NULL, NULL, NULL), -- FAQ — «Inicijalna analiza pacijenta i funkcionalni pregled može da bude odradjen bez snimka», «Konsultacije se zakazuju, najidealnije je jedan dan unaprijed», /kiropraktika — «Doktor kiropraktike prvo uzima detaljnu anamnezu … fizikalnom pregledu, ortopedskim i neurološkim testovima, čitanju snimaka»
('chiropractic-treatment', NULL, NULL, NULL), -- /kiropraktika — «Kiropraktika», «kiropraktičko namještanje», «od brzih namještanja do takozvanih dekompresivnih terapija»
('spinal-decompression', NULL, NULL, NULL), -- Usluge → Spinalna dekompresija — «kompjuterizovana spinalna dekompresija … kompjuterski kontrolisana mehanička trakcija»
('iastm-therapy', NULL, NULL, NULL), -- Usluge → Graston tehnika — «sastoji se od 6 instrumenata od kojih je svaki izrađen od nerđajuceg čelika» (Graston = бренд IASTM, синоним)
('iontophoresis-for-hyperhidrosis', NULL, NULL, NULL), -- Usluge → Jontoforeza — «jontoforeza za hiperhidrozu … Tretman traje 10-20 minuta. Obično je potrebno 10 tretmana»
('group-exercises-type-b', NULL, NULL, NULL), -- Usluge → Vježbe — «vježbe za zdravu kičmu … organizujemo grupne vježbe za sve one koji nemaju problema sa kičmom»
('individual-kinesiotherapy', NULL, NULL, NULL), -- Usluge → Vježbe — «Individualne vježbe sa terapeutom», /diskus-hernija-1 — «Individualizovanu kineziterapiju primjenjujemo»
('relaxing-massage', NULL, NULL, NULL), -- Usluge → Masaže — «Relax masaža»
('therapeutic-massage-partial', NULL, NULL, NULL), -- Usluge → Masaže — «Parcijalna masaža je masaža jednog dijela tijela. Može se raditi masaža leđa, ruku, nogu»
('sports-massage', NULL, NULL, NULL), -- Usluge → Masaže — «Sportska masaža»
('therapeutic-massage-complete', NULL, NULL, NULL), -- Usluge → Masaže — «Terapeutska masaža — Ova masaža poboljšava cirkulaciju, ubrzava proces izliječenja»
('face-and-decollete-massage', NULL, NULL, NULL), -- Usluge → Masaže — «Masaža lica i dekoltea»
('hilt-laser-therapy', NULL, NULL, NULL), -- /diskus-hernija-1 — «Dodatne terapije aparatima posljednje generacije u fizioterapiji, poput lasera visokog intenziteta, Tacar terapije …»
('tecar-therapy', NULL, NULL, NULL), -- /diskus-hernija-1 — «… Tacar terapije …» (Tacar = Tecar, опечатка сайта)
('magnetic-therapy', NULL, NULL, NULL), -- /golferski-lakat — «Radi se fizikalna terapija u okviru koje se radi masaža, magnetoterapija, ultrazvučna masaža», /faset-sindrom — «korištenje magneto terapije»
('ultrasound-therapy', NULL, NULL, NULL), -- /golferski-lakat — «… ultrazvučna masaža» (= терапевтический ультразвук)
('schroth-method', NULL, NULL, NULL); -- /skolioza — «korištenjem svjetski najpoznatijeg Schroth-ovog metoda»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_dr_radunovic_kiropraktika_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_dr_radunovic_kiropraktika_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_dr_radunovic_kiropraktika_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 3
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_dr_radunovic_kiropraktika_podgorica_ds;
CREATE TEMPORARY TABLE tmp_dr_radunovic_kiropraktika_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_dr_radunovic_kiropraktika_podgorica_ds (doctor_slug, service_slug) VALUES
('savo-radunovic', 'chiropractor-examination'), -- «Doktor kiropraktike prvo uzima detaljnu anamnezu …»
('savo-radunovic', 'chiropractic-treatment'), -- единственный доктор хиропрактики клиники («jedini doktor kiropraktike u Crnoj gori, dr Savo Radunović, ordinira u našoj ordinaciji»)
('savo-radunovic', 'iastm-therapy'); -- косвенно: «Graston tehniku obavljaju samo oni doktori koji imaju specijalno obrazovanje» — доктор в клинике один

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_dr_radunovic_kiropraktika_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_dr_radunovic_kiropraktika_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 17 услуг, с ценой 0.
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

-- Ожидается 5: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('chiropractor-examination', 'relaxing-massage', 'sports-massage', 'face-and-decollete-massage', 'iontophoresis-for-hyperhidrosis');

DROP TEMPORARY TABLE IF EXISTS tmp_dr_radunovic_kiropraktika_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_dr_radunovic_kiropraktika_podgorica_ds;

-- ═══════════════════════════════════════════════════════════════════════════
-- Očna bolnica Oftalens Dr Koturović (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ocna-bolnica-oftalens-dr-koturovic-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ocna-bolnica-oftalens-dr-koturovic-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/ocna-bolnica-oftalens-dr-koturovic-podgorica.json.
-- 
-- Услуг: 22, с ценой: 0 (цен нет). Анализов: 0. 14 пунктов аккордеона usluge.html + 3 типа ИОЛ + осмотр (FAQ).
-- Новые записи каталога: cataract-surgery-with-toric-iol, macular-surgery, ultrasound-biomicroscopy-ubm — идемпотентно по slug.
-- Привязки врач↔услуга — по био на onama.html (комментарий у каждой строки).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJHfHowEbrTRMRkoGZRCr1aVE' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ocna-bolnica-oftalens-dr-koturovic-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ocna-bolnica-oftalens-dr-koturovic-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Oftalens Dr Koturović: «Torična intraokularna sočiva … ugrađuju se tokom operacije katarakte kako bi se istovremeno uklonila siva mrena i ispravio astigmatizam» — бренд линзы не назван. В каталоге торические только брендовые/комбинированные: Toric IQ (AcrySof), Toric Vivity, Toric Eyhance, Toric Multifocal — общей «с торической ИОЛ» нет (мультифокальная и EDOF общие есть). Категория 33 OPHTHALMIC_SURGERY, специальность 81.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'cataract-surgery-with-toric-iol', 'Cataract Surgery with Toric IOL', 'Operacija katarakte sa toričnim sočivom', 'Операција катаракте са торичним сочивом',
	'Операция катаракты с торической ИОЛ', 'Kataraktoperation mit torischer IOL', 'Torik göz içi lensi ile katarakt ameliyatı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'cataract-surgery-with-toric-iol' OR name_en = 'Cataract Surgery with Toric IOL');

-- Oftalens Dr Koturović: «Operacije žute mrlje (makule) … makularna rupa, epiretinalna membrana …». Операций на макуле (макулярное отверстие, эпиретинальная мембрана) в каталоге нет ни под одним названием; vitrectomy заведена отдельно — у клиники это отдельный пункт «Pars plana vitrektomija». Категория 33, специальность 81.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'macular-surgery', 'Macular Surgery', 'Operacija žute mrlje (makule)', 'Операција жуте мрље (макуле)',
	'Операция на макуле', 'Makulachirurgie', 'Makula cerrahisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'macular-surgery' OR name_en = 'Macular Surgery');

-- Oftalens Dr Koturović: «Ultrazvučna biomikroskopija (UBM) … veoma detaljnu sliku prednjeg segmenta oka». В каталоге есть B-scan и A-scan биометрия, UBM нет. Категории 23 OPHTHALMOLOGY + 4 ULTRASOUND (как у остальных УЗИ глаза), специальность 6.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'ultrasound-biomicroscopy-ubm', 'Ultrasound Biomicroscopy (UBM)', 'Ultrazvučna biomikroskopija (UBM)', 'Ултразвучна биомикроскопија (UBM)',
	'Ультразвуковая биомикроскопия глаза (УБМ)', 'Ultraschallbiomikroskopie (UBM)', 'Ultrason biyomikroskopi (UBM)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'ultrasound-biomicroscopy-ubm' OR name_en = 'Ultrasound Biomicroscopy (UBM)');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('ultrasound-biomicroscopy-ubm');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 23 FROM medical_services WHERE slug IN ('ultrasound-biomicroscopy-ubm');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 33 FROM medical_services WHERE slug IN ('cataract-surgery-with-toric-iol', 'macular-surgery');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 6 FROM medical_services WHERE slug IN ('ultrasound-biomicroscopy-ubm');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 81 FROM medical_services WHERE slug IN ('cataract-surgery-with-toric-iol', 'macular-surgery');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Torično intraokularno sočivo', 'sr' FROM medical_services WHERE slug = 'cataract-surgery-with-toric-iol'
UNION ALL SELECT id, 'Торично интраокуларно сочиво', 'sr-cyrl' FROM medical_services WHERE slug = 'cataract-surgery-with-toric-iol'
UNION ALL SELECT id, 'Торическая линза', 'ru' FROM medical_services WHERE slug = 'cataract-surgery-with-toric-iol'
UNION ALL SELECT id, 'Toric Lens', 'en' FROM medical_services WHERE slug = 'cataract-surgery-with-toric-iol'
UNION ALL SELECT id, 'Makularna rupa', 'sr' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Макуларна рупа', 'sr-cyrl' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Epiretinalna membrana', 'sr' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Епиретинална мембрана', 'sr-cyrl' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Macular Hole Surgery', 'en' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Epiretinal Membrane Peeling', 'en' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Макулярный разрыв', 'ru' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Эпиретинальная мембрана', 'ru' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Makulaforamen', 'de' FROM medical_services WHERE slug = 'macular-surgery'
UNION ALL SELECT id, 'Ultrazvuk prednjeg segmenta oka', 'sr' FROM medical_services WHERE slug = 'ultrasound-biomicroscopy-ubm'
UNION ALL SELECT id, 'Ултразвук предњег сегмента ока', 'sr-cyrl' FROM medical_services WHERE slug = 'ultrasound-biomicroscopy-ubm'
UNION ALL SELECT id, 'Pars plana vitrektomija', 'sr' FROM medical_services WHERE slug = 'vitrectomy'
UNION ALL SELECT id, 'Парс плана витректомија', 'sr-cyrl' FROM medical_services WHERE slug = 'vitrectomy'
UNION ALL SELECT id, 'Pars Plana Vitrectomy', 'en' FROM medical_services WHERE slug = 'vitrectomy'
UNION ALL SELECT id, 'PPV', 'en' FROM medical_services WHERE slug = 'vitrectomy'
UNION ALL SELECT id, 'Dijabetička vitrektomija', 'sr' FROM medical_services WHERE slug = 'vitrectomy'
UNION ALL SELECT id, 'Витрэктомия pars plana', 'ru' FROM medical_services WHERE slug = 'vitrectomy'
UNION ALL SELECT id, 'Operacija čmička', 'sr' FROM medical_services WHERE slug = 'surgical-treatment-of-hordeolum-abscess-or-phlegmon'
UNION ALL SELECT id, 'Операција чмичка', 'sr-cyrl' FROM medical_services WHERE slug = 'surgical-treatment-of-hordeolum-abscess-or-phlegmon'
UNION ALL SELECT id, 'Удаление ячменя', 'ru' FROM medical_services WHERE slug = 'surgical-treatment-of-hordeolum-abscess-or-phlegmon'
UNION ALL SELECT id, 'Stye Surgery', 'en' FROM medical_services WHERE slug = 'surgical-treatment-of-hordeolum-abscess-or-phlegmon'
UNION ALL SELECT id, 'Estetska hirurgija kapaka', 'sr' FROM medical_services WHERE slug = 'blepharoplasty'
UNION ALL SELECT id, 'Естетска хирургија капака', 'sr-cyrl' FROM medical_services WHERE slug = 'blepharoplasty';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica;
CREATE TEMPORARY TABLE tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica (slug, price, price_min, price_max) VALUES
('ophthalmological-examination', NULL, NULL, NULL), -- faq.html: «Koliko traje kompletan pregled u klinici? Standardni pregled obično traje 20–30 minuta», главная «Zakaži pregled!»
('optical-coherence-tomography-oct', NULL, NULL, NULL), -- «OCT dijagnostika oka»
('cataract-surgery-with-standard-iol', NULL, NULL, NULL), -- «Operacija katarakte … zamućeno sočivo se uklanja, a ugrađuje se novo, providno veštačko sočivo» (базовая операция, типы линз — отдельными записями)
('cataract-surgery-with-toric-iol', NULL, NULL, NULL), -- Sočiva: «Torična intraokularna sočiva … ugrađuju se tokom operacije katarakte … ispravio astigmatizam»
('cataract-surgery-with-multifocal-iol', NULL, NULL, NULL), -- Sočiva: «Multifokalna intraokularna sočiva … ugrađuju se tokom operacije katarakte»
('cataract-surgery-with-edof-iol', NULL, NULL, NULL), -- Sočiva: «EDOF sočiva (produženi fokus) … ugrađuju se tokom operacije katarakte»
('complete-glaucoma-examination', NULL, NULL, NULL), -- «Liječenje glaukoma … Redovni pregledi omogućavaju rano otkrivanje i pravovremeno liječenje», «1. Kapi za oči»
('laser-trabeculoplasty', NULL, NULL, NULL), -- Glaukom: «2. Laser — … laserski tretman koji pomaže boljem oticanju očne tečnosti i snižavanju pritiska»
('glaucoma-filtering-surgery', NULL, NULL, NULL), -- Glaukom: «3. Operacija — … operativni zahvat kojim se stvara novi put za oticanje očne tečnosti» (фильтрующая операция, трабекулэктомия сайтом не названа)
('eyeglass-prescription-for-adults', NULL, NULL, NULL), -- «Naočare i kontaktna sočiva — Određivanje dioptrije za naočare …»
('contact-lens-fitting', NULL, NULL, NULL), -- «Pregled za kontaktna sočiva: … određivanje vrste i jačine sočiva — proba kontaktnih sočiva»
('retinal-detachment-surgery-with-vitrectomy-and-silicone-oil', NULL, NULL, NULL), -- «Operacija ablacije retine (odvajanja mrežnjače) … uklanjanjem tečnosti ispod mrežnjače i njenim učvršćivanjem posebnim gasom, uljem ili laserskim tretmanom»
('macular-surgery', NULL, NULL, NULL), -- «Operacije žute mrlje (makule) … makularna rupa, epiretinalna membrana …»
('vitrectomy', NULL, NULL, NULL), -- «Pars plana vitrektomija», «Operacije kod promjena u sklopu šećerne bolesti — uklanjanje krvi iz oka, uklanjanje ožiljnog tkiva, ponovno pripajanje mrežnjače» (= витрэктомия, синоним добавлен)
('b-scan-ocular-ultrasound', NULL, NULL, NULL), -- «Ultrazvučna dijagnostika oka (B-scan)»
('ultrasound-biomicroscopy-ubm', NULL, NULL, NULL), -- «Ultrazvučna biomikroskopija (UBM) (A-scan)»
('a-scan-biometry', NULL, NULL, NULL), -- заголовок «… (UBM) (A-scan)»
('anti-vegf-injection', NULL, NULL, NULL), -- «Anti-VEGF injekcije»
('pterygium-removal', NULL, NULL, NULL), -- «Operacija pterigijuma»
('blepharoplasty', NULL, NULL, NULL), -- «Estetska hirurgija kapaka … poznata i kao blefaroplastika»
('surgical-treatment-of-hordeolum-abscess-or-phlegmon', NULL, NULL, NULL), -- «Operacija čmička — Čmičak je bolna, crvena kvržica na kapku koja nastaje zbog infekcije žlezde … hirurško uklanjanje» (čmičak = hordeolum, запись «Hirurško zbrinjavanje hordeoluma»)
('focal-laser-photocoagulation-single-eye', NULL, NULL, NULL); -- «Laser fotokoagulacija — … dijabetička retinopatija, rupture mrežnjače …» — запись «Laser fotokoagulacija mrežnjače jedno oko» (панретинальная — отдельной записью, сайт техники не различает)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 15
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica_ds;
CREATE TEMPORARY TABLE tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica_ds (doctor_slug, service_slug) VALUES
('zoran-koturovic', 'ophthalmological-examination'), -- офтальмолог клиники
('zoran-koturovic', 'cataract-surgery-with-standard-iol'), -- био: «hirurgija prednjeg segmenta oka i hirurgija katarakte sa preko 8000 izvedenih operacija»
('zoran-koturovic', 'cataract-surgery-with-toric-iol'), -- био: «hirurgija prednjeg segmenta oka i hirurgija katarakte sa preko 8000 izvedenih operacija»
('zoran-koturovic', 'cataract-surgery-with-multifocal-iol'), -- био: «hirurgija prednjeg segmenta oka i hirurgija katarakte sa preko 8000 izvedenih operacija»
('zoran-koturovic', 'cataract-surgery-with-edof-iol'), -- био: «hirurgija prednjeg segmenta oka i hirurgija katarakte sa preko 8000 izvedenih operacija»
('haris-kujundzic', 'ophthalmological-examination'), -- офтальмолог клиники
('haris-kujundzic', 'cataract-surgery-with-standard-iol'), -- био: «hirurgija katarakte i prednjeg segmenta oka»
('haris-kujundzic', 'cataract-surgery-with-toric-iol'), -- био: «hirurgija katarakte i prednjeg segmenta oka»
('haris-kujundzic', 'cataract-surgery-with-multifocal-iol'), -- био: «hirurgija katarakte i prednjeg segmenta oka»
('haris-kujundzic', 'cataract-surgery-with-edof-iol'), -- био: «hirurgija katarakte i prednjeg segmenta oka»
('haris-kujundzic', 'retinal-detachment-surgery-with-vitrectomy-and-silicone-oil'), -- био: «hirurško liječenje mrežnjače, žute mrlje i staklastog tijela»
('haris-kujundzic', 'macular-surgery'), -- био: «hirurško liječenje mrežnjače, žute mrlje i staklastog tijela»
('haris-kujundzic', 'vitrectomy'), -- био: «hirurško liječenje mrežnjače, žute mrlje i staklastog tijela»
('haris-kujundzic', 'anti-vegf-injection'), -- био: «konzervativno … liječenje mrežnjače, žute mrlje» (вывод по профилю)
('haris-kujundzic', 'focal-laser-photocoagulation-single-eye'); -- био: «konzervativno … liječenje mrežnjače, žute mrlje» (вывод по профилю)

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 22 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 15 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 3: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('cataract-surgery-with-toric-iol', 'macular-surgery', 'ultrasound-biomicroscopy-ubm');

DROP TEMPORARY TABLE IF EXISTS tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_ocna_bolnica_oftalens_dr_koturovic_podgorica_ds;

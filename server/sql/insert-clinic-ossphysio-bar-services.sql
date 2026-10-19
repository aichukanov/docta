-- ═══════════════════════════════════════════════════════════════════════════
-- OssPhysio (Čeluga, Bar) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ossphysio-bar-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ossphysio-bar.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/ossphysio-bar.json.
-- 
-- Услуг: 12, с ценой: 0 (блок «Cjenovnik» без чисел). Новых записей каталога: 0.
-- «Masaža — opuštajuća, sportska i medicinska» → relaxing-massage + sports-massage + therapeutic-massage-complete
-- (длительности 30/60 — только в ключах словаря, не на странице). Хиджама и акупунктура заведены (записи есть, решение юзера).
-- is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJW28rHgB1ThMRAFhjsoLtkI0' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ossphysio-bar' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ossphysio-bar.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_ossphysio_bar;
CREATE TEMPORARY TABLE tmp_ossphysio_bar (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ossphysio_bar (slug, price, price_min, price_max) VALUES
('relaxing-massage', NULL, NULL, NULL), -- services.massage «Masaža» — «Opuštajuća, sportska i medicinska masaža za relaksaciju i rehabilitaciju»
('sports-massage', NULL, NULL, NULL), -- services.massage — «… sportska … masaža»
('therapeutic-massage-complete', NULL, NULL, NULL), -- services.massage — «… i medicinska masaža za … rehabilitaciju» (зона не указана — generic)
('kinesiotherapy', NULL, NULL, NULL), -- services.kinesitherapy — «Kineziterapija — Terapeutske vježbe za vraćanje pokretljivosti i snage»
('electrotherapy', NULL, NULL, NULL), -- services.electrotherapy — «Elektroterapija — Moderna terapija električnim stimulacijama za brži oporavak», equipment.electro «BTL 4825SL – ELEKTRO I ULTRAZVUČNA TERAPIJA»
('ultrasound-therapy', NULL, NULL, NULL), -- equipment.electro — «BTL 4825SL – ELEKTRO I ULTRAZVUČNA TERAPIJA … objedinjuje elektroterapiju, ultrazvučnu terapiju i kombinovanu terapiju. Koristi se … za smanjenje bola»
('tecar-therapy', NULL, NULL, NULL), -- services.tecar «Tecar terapija» — «Napredna radiofrekventna terapija …», equipment.tecar «BTL TECAR TERAPIJA»
('shock-wave-therapy', NULL, NULL, NULL), -- services.shockwave «Shockwave terapija» — «Visokoenergetski akustični talasi …», equipment.shockwave «BTL SHOCKWAVE TERAPIJA»
('cupping-therapy', NULL, NULL, NULL), -- services.cupping «Hidžama (Cupping)» — «Tradicionalna terapija vakuum čašicama» (Hidžama — уже синоним, вид — сухая/влажная — не указан)
('chiropractic-treatment', NULL, NULL, NULL), -- services.chiropractic «Kiropraktika» — «Manualna terapija za korekciju kičme i zglobova»
('acupuncture', NULL, NULL, NULL), -- services.acupuncture «Akupunktura» — «Tradicionalna metoda za ublažavanje bola, poboljšanje cirkulacije i opšteg zdravlja»
('taping-application', NULL, NULL, NULL); -- services.kinesioTaping «Kinesio Taping» — «Elastični flasteri za podršku mišićima …» (Kinesio taping — уже синоним)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_ossphysio_bar t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_ossphysio_bar t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_ossphysio_bar t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 12 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

DROP TEMPORARY TABLE IF EXISTS tmp_ossphysio_bar;

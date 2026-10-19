-- ═══════════════════════════════════════════════════════════════════════════
-- Ordinacija dr Kaluđerović (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-ordinacija-dr-kaludjerovic-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-ordinacija-dr-kaludjerovic-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/ordinacija-dr-kaludjerovic-podgorica.json.
-- 
-- Услуг: 4, анализов: 0, с ценой: 1 (теледерматология — бесплатно, 0 €). Прайс заявлен («u prilogu»), но вложения нет.
-- Новых записей каталога нет. Синоним «Teledermatologija» к e-consultation-with-specialist.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJuQhy-znrTRMRvowiO4-vZg0' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'ordinacija-dr-kaludjerovic-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-ordinacija-dr-kaludjerovic-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Teledermatologija', 'sr' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Теледерматологија', 'sr-cyrl' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Teledermatology', 'en' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Теледерматология', 'ru' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Teledermatologie', 'de' FROM medical_services WHERE slug = 'e-consultation-with-specialist'
UNION ALL SELECT id, 'Teledermatoloji', 'tr' FROM medical_services WHERE slug = 'e-consultation-with-specialist';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_dr_kaludjerovic_podgorica;
CREATE TEMPORARY TABLE tmp_ordinacija_dr_kaludjerovic_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ordinacija_dr_kaludjerovic_podgorica (slug, price, price_min, price_max) VALUES
('dermatologist-examination', NULL, NULL, NULL), -- «Specijalisticka ambulanta za KOŽNE I POLNE BOLESTI»
('allergist-examination', NULL, NULL, NULL), -- «Subspecijalisticka ambulanta za ALERGOLOGIJU»
('prick-test-nutritive-and-inhalation-allergens', NULL, NULL, NULL), -- «Kompletno ALERGOLOŠKO TESTIRANJE» — метод не назван, «kompletno» → комбинированная запись кожных прик-тестов (пищевые + ингаляционные). patch-тест не заводится (сайт не называет, решение координатора 2026-10-09)
('e-consultation-with-specialist', 0.00, NULL, NULL); -- «TELEDERMATOLOGIJA … Usluge su besplatne i obavljaju se radnim danom od 16H-18H, adekvatno pripremljeni upiti u Wordu šalju se na mejl: kalve@t-com.me» — бесплатно → 0 €

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_ordinacija_dr_kaludjerovic_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_ordinacija_dr_kaludjerovic_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_ordinacija_dr_kaludjerovic_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 4
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_dr_kaludjerovic_podgorica_ds;
CREATE TEMPORARY TABLE tmp_ordinacija_dr_kaludjerovic_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_ordinacija_dr_kaludjerovic_podgorica_ds (doctor_slug, service_slug) VALUES
('velimir-kaludjerovic', 'dermatologist-examination'), -- единственный врач кабинета
('velimir-kaludjerovic', 'allergist-examination'), -- единственный врач кабинета
('velimir-kaludjerovic', 'prick-test-nutritive-and-inhalation-allergens'), -- единственный врач кабинета
('velimir-kaludjerovic', 'e-consultation-with-specialist'); -- единственный врач кабинета

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_ordinacija_dr_kaludjerovic_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_ordinacija_dr_kaludjerovic_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 4 услуг, с ценой 1.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 4 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_dr_kaludjerovic_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_ordinacija_dr_kaludjerovic_podgorica_ds;

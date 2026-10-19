-- ═══════════════════════════════════════════════════════════════════════════
-- Dental Implant Centar — Dr Keković (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-dental-implant-centar-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-dental-implant-centar-podgorica-services.sql
--
-- Источник: https://www.drkekovic.com/dental-implant-centar.html, блок «Ordinacija Dental implant centar» (проза), curl 2026-10-09.
-- Прайса нет; все позиции price = NULL. Заведены только процедуры, прямо названные в тексте; направления без процедуры — в excluded.
--
-- Итого: 7 услуг (0 с ценой), новых записей каталога — 2 (zygomatic-implant, pterygoid-implant). Анализов нет.
-- Привязок врач↔услуга: 7.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJwYoB47WUTRMROul9mAMmcIk' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'dental-implant-centar-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-dental-implant-centar-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- drkekovic.com: «… ugradnja pterigoidnih i zigomatičnih implantata kod pacijenata kojima je to usled nedostatka kosti potrebno».
-- В каталоге нет (zygom/zigomat — только рентген). Методика, не бренд. Категория 20; специальности 74, 78, 91 (как dental-sinus-lift).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'zygomatic-implant', 'Zygomatic Implant', 'Zigomatični implantat', 'Зигоматични имплантат',
	'Скуловой имплант', 'Zygomatisches Implantat', 'Zigomatik implant', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'zygomatic-implant' OR name_en = 'Zygomatic Implant');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 74 FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 91 FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zygoma implant', 'en' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zygomatic implant placement', 'en' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Zigomatični implant', 'sr' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ugradnja zigomatičnog implantata', 'sr' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Уградња зигоматичног имплантата', 'sr-cyrl' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Зигоматический имплант', 'ru' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Скуловая имплантация', 'ru' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Jochbeinimplantat', 'de' FROM medical_services WHERE slug = 'zygomatic-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Elmacık kemiği implantı', 'tr' FROM medical_services WHERE slug = 'zygomatic-implant';

-- drkekovic.com: «… ugradnja pterigoidnih i zigomatičnih implantata».
-- В каталоге нет (pteryg/pterig — только птеригиум). Методика, не бренд. Категория 20; специальности 74, 78, 91.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pterygoid-implant', 'Pterygoid Implant', 'Pterigoidni implantat', 'Птеригоидни имплантат',
	'Птеригоидный имплант', 'Pterygoid-Implantat', 'Pterigoid implant', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pterygoid-implant' OR name_en = 'Pterygoid Implant');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 74 FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 91 FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pterygoid implant placement', 'en' FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pterygomaxillary implant', 'en' FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pterigoidni implant', 'sr' FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ugradnja pterigoidnog implantata', 'sr' FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Уградња птеригоидног имплантата', 'sr-cyrl' FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Птеригоидная имплантация', 'ru' FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pterygoidimplantat', 'de' FROM medical_services WHERE slug = 'pterygoid-implant';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pterigoid implant uygulaması', 'tr' FROM medical_services WHERE slug = 'pterygoid-implant';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- bone-graft-with-membrane: drkekovic.com /dental-implant-centar.html: «sinus-lift procedura i vođene regeneracije kosti koje se u našoj ordinaciji rutinski rade». Вођена регенерация кости (GBR) = костная пластика с барьерной мембраной — единственная подходящая запись bone-graft-with-membrane («Koštana plastika sa membranom»); guided-tissue-regeneration (GTR) — пародонтологическая, другая. Название GBR — синонимом, без дубля.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Vođena regeneracija kosti', 'sr' FROM medical_services WHERE slug = 'bone-graft-with-membrane';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Вођена регенерација кости', 'sr-cyrl' FROM medical_services WHERE slug = 'bone-graft-with-membrane';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Guided bone regeneration (GBR)', 'en' FROM medical_services WHERE slug = 'bone-graft-with-membrane';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Направленная регенерация кости', 'ru' FROM medical_services WHERE slug = 'bone-graft-with-membrane';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gesteuerte Knochenregeneration (GBR)', 'de' FROM medical_services WHERE slug = 'bone-graft-with-membrane';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Yönlendirilmiş kemik rejenerasyonu', 'tr' FROM medical_services WHERE slug = 'bone-graft-with-membrane';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (7)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_dic_services;
CREATE TEMPORARY TABLE tmp_x_dic_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_dic_services (slug, price, price_min, price_max) VALUES
	('dental-implant-placement', NULL, NULL, NULL), -- «posebno je specijalizovana za oblast implantologije … Pored konvencionalne implantologije» — бренд имплантов не назван
	('dental-sinus-lift', NULL, NULL, NULL), -- «sinus-lift procedura … koje se u našoj ordinaciji rutinski rade»
	('bone-graft-with-membrane', NULL, NULL, NULL), -- «vođene regeneracije kosti koje se u našoj ordinaciji rutinski rade» (GBR) → синоним
	('bone-augmentation', NULL, NULL, NULL), -- «obavljaju se i napredni hirurški zahvati kao što su transplantacija kosti» — источник кости не назван, единственная общая запись
	('mucosal-autograft', NULL, NULL, NULL), -- «… transplantacija mekih tkiva» — слизистый/соединительнотканный трансплантат, единственная запись (Slobodni mukozni autotransplantat)
	('pterygoid-implant', NULL, NULL, NULL), -- «ugradnja pterigoidnih … implantata kod pacijenata kojima je to usled nedostatka kosti potrebno» (НОВАЯ запись) (НОВАЯ запись каталога)
	('zygomatic-implant', NULL, NULL, NULL); -- «ugradnja … zigomatičnih implantata kod pacijenata kojima je to usled nedostatka kosti potrebno» (НОВАЯ запись) (НОВАЯ запись каталога)

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_dic_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_dic_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_dic_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 7
-- Врач на странице один — dr spec. Vladan Keković, имплантолог и челюстно-лицевой хирург; страница описывает только имплантологию и
-- хирургию → все 7 услуг на него.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_x_dic_ds;
CREATE TEMPORARY TABLE tmp_x_dic_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
);
INSERT INTO tmp_x_dic_ds (doctor_slug, service_slug) VALUES
	('vladan-kekovic', 'dental-implant-placement'),
	('vladan-kekovic', 'dental-sinus-lift'),
	('vladan-kekovic', 'bone-graft-with-membrane'),
	('vladan-kekovic', 'bone-augmentation'),
	('vladan-kekovic', 'mucosal-autograft'),
	('vladan-kekovic', 'pterygoid-implant'),
	('vladan-kekovic', 'zygomatic-implant');

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_x_dic_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_x_dic_ds;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 7, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 7 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Новые записи каталога: категории, специальности, синонимы.
SELECT ms.id, ms.slug, ms.name_sr,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specs,
	(SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
FROM medical_services ms WHERE ms.slug IN ('zygomatic-implant', 'pterygoid-implant');

DROP TEMPORARY TABLE IF EXISTS tmp_x_dic_services;
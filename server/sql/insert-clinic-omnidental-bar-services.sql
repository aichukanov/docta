-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka ordinacija Omnidental (Bar) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-omnidental-bar.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-omnidental-bar-services.sql
--
-- Источник: https://www.omnidental.me/ (главная), блок «NAŠE USLUGE» — 4 группы через дефис, curl 2026-10-09. Прайса нет; все price = NULL.
-- Подстраницы — шаблон Wix, процедур сверх перечня не дают. Направления без процедуры и пункты без материала — в excluded.
--
-- Итого: 25 услуг (0 с ценой), новых записей каталога — 2 (halitosis-treatment, smile-makeover), повторено из других импортов агента X — gingivitis-treatment. Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJNyvgJdZzThMRHMKtcvw2gvo' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'omnidental-bar' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-omnidental-bar.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА И СИНОНИМЫ (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- (запись заведена в insert-clinic-stefanija-dental-podgorica-services.sql; повторена идемпотентно — файл не зависит от порядка применения)
-- stefanijadental.me /parodontologija/: «Bavimo se terapijom gingivitisa, uklanjanjem zubnog kamenca …».
-- В каталоге нет (поиск gingivit); periodontal-scaling-root-planing — пародонтит. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'gingivitis-treatment', 'Gingivitis Treatment', 'Terapija gingivitisa', 'Терапија гингивитиса',
	'Лечение гингивита', 'Gingivitisbehandlung', 'Diş eti iltihabı (gingivitis) tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'gingivitis-treatment' OR name_en = 'Gingivitis Treatment');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Liječenje gingivitisa', 'sr' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Liječenje upale desni', 'sr' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лијечење упале десни', 'sr-cyrl' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gum inflammation treatment', 'en' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Лечение воспаления дёсен', 'ru' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Behandlung von Zahnfleischentzündung', 'de' FROM medical_services WHERE slug = 'gingivitis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Diş eti iltihabı tedavisi', 'tr' FROM medical_services WHERE slug = 'gingivitis-treatment';

-- omnidental.me: «svjez dah koncept» (группа «Opšta Stomatologija»).
-- В каталоге нет (halit/breath/zadah — только дыхательные тесты). Общая запись. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'halitosis-treatment', 'Halitosis Treatment', 'Liječenje zadaha (halitoze)', 'Лијечење задаха (халитозе)',
	'Лечение неприятного запаха изо рта (галитоза)', 'Behandlung von Mundgeruch (Halitosis)', 'Ağız kokusu (halitozis) tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'halitosis-treatment' OR name_en = 'Halitosis Treatment');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Bad breath treatment', 'en' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Fresh breath treatment', 'en' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Svjež dah', 'sr' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Liječenje lošeg zadaha', 'sr' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Халитоза', 'sr-cyrl' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Свјеж дах', 'sr-cyrl' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Галитоз', 'ru' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Запах изо рта', 'ru' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Mundgeruch', 'de' FROM medical_services WHERE slug = 'halitosis-treatment';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ağız kokusu', 'tr' FROM medical_services WHERE slug = 'halitosis-treatment';

-- omnidental.me «Estetska Stomatologija»: «… porcelanske fasete (viniri) - smile makeover - Invisalign».
-- В каталоге нет: digital-smile-design — план, hollywood-smile-zirconia-crown — конкретные коронки. Общая запись. Категория 20, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'smile-makeover', 'Smile Makeover', 'Smile makeover (kompletno uređenje osmijeha)', 'Smile makeover (комплетно уређење осмијеха)',
	'Smile makeover (комплексное преображение улыбки)', 'Smile Makeover (Komplettgestaltung des Lächelns)', 'Smile makeover (gülüş tasarımı ve yenileme)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'smile-makeover' OR name_en = 'Smile Makeover');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Smile makeover', 'sr' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Uređenje osmijeha', 'sr' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kompletna estetska rekonstrukcija osmijeha', 'sr' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Уређење осмијеха', 'sr-cyrl' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Full smile makeover', 'en' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Преображение улыбки', 'ru' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Эстетическая реставрация улыбки', 'ru' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Lächeln-Makeover', 'de' FROM medical_services WHERE slug = 'smile-makeover';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gülüş yenileme', 'tr' FROM medical_services WHERE slug = 'smile-makeover';

-- Синонимы к существующим записям: бренд/система, названные сайтом, без бренд-дубля в каталоге.
-- dental-air-polishing: omnidental.me (главная, «Opšta Stomatologija»): «Airflow poliranje». Air-Flow — название метода/аппарата (EMS) для пескоструйной чистки; это та же dental-air-polishing («Pjeskarenje zuba»), у которой синонима Air-Flow нет. Бренд-дубль не заводим — синонимом.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Airflow poliranje', 'sr' FROM medical_services WHERE slug = 'dental-air-polishing';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Airflow полирање', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-air-polishing';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Air-Flow polishing', 'en' FROM medical_services WHERE slug = 'dental-air-polishing';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Чистка Air-Flow', 'ru' FROM medical_services WHERE slug = 'dental-air-polishing';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Air-Flow-Reinigung', 'de' FROM medical_services WHERE slug = 'dental-air-polishing';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Air-Flow parlatma', 'tr' FROM medical_services WHERE slug = 'dental-air-polishing';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (25)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_x_omd_services;
CREATE TEMPORARY TABLE tmp_x_omd_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_x_omd_services (slug, price, price_min, price_max) VALUES
	('dental-consultation', NULL, NULL, NULL), -- «Opšta Stomatologija: pregled i digitalno snimanje …» — «pregled»
	('intraoral-x-ray', NULL, NULL, NULL), -- «Opšta Stomatologija: pregled i digitalno snimanje …» — «digitalno snimanje», вид снимка не назван; решение координатора 2026-10-09
	('plaque-and-calculus-removal', NULL, NULL, NULL), -- «Opšta Stomatologija: … uklanjanje zubnog kamenca …»; «Dječja Stomatologija: … uklanjanje naslaga …»
	('dental-air-polishing', NULL, NULL, NULL), -- «Opšta Stomatologija: … Airflow poliranje …» → синоним Airflow
	('halitosis-treatment', NULL, NULL, NULL), -- «Opšta Stomatologija: … svjez dah koncept …» (НОВАЯ запись) (НОВАЯ запись каталога)
	('gingivitis-treatment', NULL, NULL, NULL), -- «Opšta Stomatologija: … problemi sa desnima …» — решение координатора 2026-10-09 (запись заведена импортом stefanija-dental-podgorica) (НОВАЯ запись каталога)
	('dentin-hypersensitivity-treatment', NULL, NULL, NULL), -- «Opšta Stomatologija: … osjetiljivost zuba …»
	('composite-filling', NULL, NULL, NULL), -- «Opšta Stomatologija: … estetske plombe …» — эстетическая пломба = композит
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- «Opšta Stomatologija: … tretman kanala korijena zuba …»; «Dječja: … tretman kanala korijena … stalnih zuba» — число каналов не названо
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- там же
	('tooth-extraction', NULL, NULL, NULL), -- «Opšta Stomatologija: … vadjenje zuba …»; «Dječja: … vadjenje … stalnih zuba»
	('dental-implant-placement', NULL, NULL, NULL), -- «Opšta Stomatologija: … implantati» — бренд не назван
	('topical-fluoride-treatment', NULL, NULL, NULL), -- «Dječja Stomatologija: ojacavanje zuba fluoridima …»
	('dental-fissure-sealant', NULL, NULL, NULL), -- «Dječja Stomatologija: … zastita zuba zalivanjem fisura …»
	('pediatric-caries-treatment', NULL, NULL, NULL), -- «Dječja Stomatologija: … terapija zubnog karijesa mlijecnih i stalnih zzuba …»
	('primary-tooth-pulp-treatment', NULL, NULL, NULL), -- «Dječja Stomatologija: … tretman kanala korijena mlijecnih … zuba …»
	('primary-tooth-extraction', NULL, NULL, NULL), -- «Dječja Stomatologija: … vadjenje mlijecnih … zuba …»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- «Dječja Stomatologija: … ispravljanje nepravilnosti mobilnim … aparatima»
	('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL), -- «Dječja Stomatologija: … ispravljanje nepravilnosti … fiksnim aparatima» — тип брекетов не назван, общая запись
	('teeth-whitening', NULL, NULL, NULL), -- «Estetska Stomatologija: izbijeljivanje zuba …» — метод не назван
	('direct-composite-veneer', NULL, NULL, NULL), -- «Estetska Stomatologija: … kompozitne fasete …»
	('ceramic-veneer', NULL, NULL, NULL), -- «Estetska Stomatologija: … porcelanske fasete (viniri) …»
	('smile-makeover', NULL, NULL, NULL), -- «Estetska Stomatologija: … smile makeover …» (НОВАЯ запись) (НОВАЯ запись каталога)
	('invisalign-aligner', NULL, NULL, NULL), -- «Estetska Stomatologija: … Invisalign»
	('dental-first-aid', NULL, NULL, NULL); -- «Hitna Stanja: bol - otok - fraktura zuba»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_x_omd_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_x_omd_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_x_omd_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Врачей в импорте нет → привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 25, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 0 привязок врач↔услуга.
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
FROM medical_services ms WHERE ms.slug IN ('gingivitis-treatment', 'halitosis-treatment', 'smile-makeover');

DROP TEMPORARY TABLE IF EXISTS tmp_x_omd_services;
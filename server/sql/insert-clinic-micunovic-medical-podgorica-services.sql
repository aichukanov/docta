-- ═══════════════════════════════════════════════════════════════════════════
-- Mićunović Medical (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-micunovic-medical-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-micunovic-medical-podgorica-services.sql
--
-- Источник: проза трёх страниц услуг (WP REST, modified 2026-07-17, curl 2026-10-08):
--   /stomatoloske-usluge/, /ginekoloske-usluge/, /usluge-ultrazvucne-dijagnostike/.
-- Прайса нет: ни одной цены (€/EUR) на сайте → все позиции price = NULL.
-- Заведены только процедуры, прямо названные в тексте; направления («Oralna hirurgija»,
-- «Sve oralno-hirurške indikacije», «liječenje ginekoloških stanja») — не услуги.
-- FAQ (/faqs/) — общепросветительский текст, перечнем услуг не считается (см. excluded
-- в записи импорта). Пломбы на сайте НЕ названы нигде.
--
-- Итого в клинике: 19 услуг (0 с ценой), из них новых в каталоге: 4.
-- Анализов нет. Привязок врач↔услуга нет: страницы услуг не называют врачей.
-- is_price_outdated не ставится (цен нет).
--
-- Самоисправляющийся: канонический список лежит во временной таблице, по ней идут
-- upsert и DELETE лишнего. ⚠️ Услуги, добавленные клинике вручную (админка, кабинет),
-- следующий прогон снесёт — вносить их сюда.
-- Сопоставление «фраза сайта → slug» — data/clinic-imports/micunovic-medical-podgorica.json.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @google_place_id = 'ChIJ1VxH0hTrTRMRyy8OYWPH7kU';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'micunovic-medical-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-micunovic-medical-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (4, идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Импланты по брендам: сайт называет «Nobel Biocare / Sweden & Martina / Camlog i JDental Care».
-- Nobel Biocare в каталоге есть (dental-implant-nobel-biocare), три остальных — нет.
-- Схема и переводы — как у dental-implant-nobel-biocare / -straumann; категория 20, спец. 74 + 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-implant-sweden-martina', 'Dental Implant Sweden & Martina', 'Ugradnja implantata Sweden & Martina', 'Уградња имплантата Sweden & Martina',
	'Установка имплантата Sweden & Martina', 'Zahnimplantat Sweden & Martina', 'Diş İmplantı Sweden & Martina', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-implant-sweden-martina' OR name_en = 'Dental Implant Sweden & Martina');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-implant-camlog', 'Dental Implant Camlog', 'Ugradnja implantata Camlog', 'Уградња имплантата Camlog',
	'Установка имплантата Camlog', 'Zahnimplantat Camlog', 'Diş İmplantı Camlog', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-implant-camlog' OR name_en = 'Dental Implant Camlog');

-- Бренд записан, как на сайте («JDental Care»); официальное написание JDentalCare — в синонимы.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'dental-implant-jdental-care', 'Dental Implant JDental Care', 'Ugradnja implantata JDental Care', 'Уградња имплантата JDental Care',
	'Установка имплантата JDental Care', 'Zahnimplantat JDental Care', 'Diş İmplantı JDental Care', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'dental-implant-jdental-care' OR name_en = 'Dental Implant JDental Care');

-- «postavljanje keramičkih krunica i mostova»: керамическая коронка есть (all-ceramic-crown),
-- моста как изделия в каталоге нет — только Maryland, временный мост 4 члена, опора и
-- металлокерамический промежуточный элемент. Категория 20, спец. 78 (как all-ceramic-crown).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'ceramic-dental-bridge', 'Ceramic Dental Bridge', 'Keramički most', 'Керамички мост',
	'Керамический мостовидный протез', 'Keramikbrücke', 'Seramik köprü', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'ceramic-dental-bridge' OR name_en = 'Ceramic Dental Bridge');

-- Категория 20 = DENTISTRY
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 20 FROM medical_services WHERE slug IN (
	'dental-implant-sweden-martina',
	'dental-implant-camlog',
	'dental-implant-jdental-care',
	'ceramic-dental-bridge'
);

-- Специальность 78 = DENTISTRY
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 78 FROM medical_services WHERE slug IN (
	'dental-implant-sweden-martina',
	'dental-implant-camlog',
	'dental-implant-jdental-care',
	'ceramic-dental-bridge'
);

-- Специальность 74 = ORAL_SURGERY (как у dental-implant-nobel-biocare)
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 74 FROM medical_services WHERE slug IN (
	'dental-implant-sweden-martina',
	'dental-implant-camlog',
	'dental-implant-jdental-care'
);

-- Синонимы: бренды кириллицей, официальное написание бренда, бытовое название моста.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Имплант Свиден энд Мартина', 'ru' FROM medical_services WHERE slug = 'dental-implant-sweden-martina'
UNION ALL SELECT id, 'Sweden Martina implant', 'en' FROM medical_services WHERE slug = 'dental-implant-sweden-martina'
UNION ALL SELECT id, 'Имплант Камлог', 'ru' FROM medical_services WHERE slug = 'dental-implant-camlog'
UNION ALL SELECT id, 'Имплантат Камлог', 'sr-cyrl' FROM medical_services WHERE slug = 'dental-implant-camlog'
UNION ALL SELECT id, 'JDentalCare', 'en' FROM medical_services WHERE slug = 'dental-implant-jdental-care'
UNION ALL SELECT id, 'Implantat JDentalCare', 'sr' FROM medical_services WHERE slug = 'dental-implant-jdental-care'
UNION ALL SELECT id, 'Keramički zubni most', 'sr' FROM medical_services WHERE slug = 'ceramic-dental-bridge'
UNION ALL SELECT id, 'Керамички зубни мост', 'sr-cyrl' FROM medical_services WHERE slug = 'ceramic-dental-bridge'
UNION ALL SELECT id, 'Керамический мост', 'ru' FROM medical_services WHERE slug = 'ceramic-dental-bridge'
UNION ALL SELECT id, 'Ceramic bridge', 'en' FROM medical_services WHERE slug = 'ceramic-dental-bridge'
UNION ALL SELECT id, 'Vollkeramikbrücke', 'de' FROM medical_services WHERE slug = 'ceramic-dental-bridge';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (19, все без цены)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_micunovic_services;
CREATE TEMPORARY TABLE tmp_micunovic_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_micunovic_services (slug, price, price_min, price_max) VALUES
	-- /stomatoloske-usluge/
	('dental-consultation', NULL, NULL, NULL), -- «Preventiva i liječenje: Redovni pregledi»
	('complete-dental-cleaning', NULL, NULL, NULL), -- «profesionalno čišćenje zuba»
	('endodontic-treatment-single-canal-tooth', NULL, NULL, NULL), -- «liječenje korijena zuba (endonocija)» — generic-записи нет, каталог делит по типу зуба
	('endodontic-treatment-multi-canal-tooth', NULL, NULL, NULL), -- то же
	('tooth-extraction', NULL, NULL, NULL), -- «vađenje zuba kada je to neophodno»
	('teeth-whitening', NULL, NULL, NULL), -- «Estetska stomatologija: Profesionalno izbjeljivanje zuba»
	('all-ceramic-crown', NULL, NULL, NULL), -- «postavljanje keramičkih krunica»
	('ceramic-dental-bridge', NULL, NULL, NULL), -- «… i mostova» (НОВАЯ)
	('ceramic-veneer', NULL, NULL, NULL), -- «izrada visokoestetskih faseta (vinira)»
	('dental-implant-nobel-biocare', NULL, NULL, NULL), -- «Vrhunski implantološki sistemi: Nobel Biocare»
	('dental-implant-sweden-martina', NULL, NULL, NULL), -- «Sweden & Martina» (НОВАЯ)
	('dental-implant-camlog', NULL, NULL, NULL), -- «Camlog i JDental Care» (НОВАЯ)
	('dental-implant-jdental-care', NULL, NULL, NULL), -- «Camlog i JDental Care» (НОВАЯ)
	-- /ginekoloske-usluge/
	('gynecological-specialist-examination', NULL, NULL, NULL), -- «Ginekološki pregledi i liječenje»
	('contraception-consultation', NULL, NULL, NULL), -- «Savjetovanje i planiranje porodice: Stručni savjeti o kontracepciji»
	('family-planning-and-pregnancy-counseling', NULL, NULL, NULL), -- «… planiranju trudnoće i očuvanju reproduktivnog zdravlja»
	-- /ginekoloske-usluge/ + /usluge-ultrazvucne-dijagnostike/
	('gynecological-ultrasound', NULL, NULL, NULL), -- «Specijalizovani ginekološki ultrazvuk»; «detaljan uvid u zdravlje reproduktivnih organa»
	('pregnancy-ultrasound', NULL, NULL, NULL), -- «precizno praćenje trudnoće»; «praćenje svih faza trudnoće»
	('4d-pregnancy-ultrasound', NULL, NULL, NULL); -- «2D, 3D i 4D ultrazvučni pregledi»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_micunovic_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: СИНХРОНИЗАЦИЯ clinic_medical_services
-- ═══════════════════════════════════════════════════════════════

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_micunovic_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_micunovic_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 19, with_price = 0.
SELECT COUNT(*) AS total, SUM(price IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_sr, cms.price, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_sr;

-- Новые записи каталога: ожидается 4 строки, у каждой категория и специальность.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	GROUP_CONCAT(DISTINCT r.medical_service_category_id) AS categories,
	GROUP_CONCAT(DISTINCT s.specialty_id) AS specialties
FROM medical_services ms
LEFT JOIN medical_service_categories_relations r ON r.medical_service_id = ms.id
LEFT JOIN medical_services_specialties s ON s.medical_service_id = ms.id
WHERE ms.slug IN (
	'dental-implant-sweden-martina',
	'dental-implant-camlog',
	'dental-implant-jdental-care',
	'ceramic-dental-bridge'
)
GROUP BY ms.id;

DROP TEMPORARY TABLE IF EXISTS tmp_micunovic_services;

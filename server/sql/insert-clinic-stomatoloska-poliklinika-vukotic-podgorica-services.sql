-- ═══════════════════════════════════════════════════════════════════════════
-- Stomatološka poliklinika Vukotić (Podgorica) — перечень услуг (без цен)
-- Run ПОСЛЕ server/sql/insert-clinic-stomatoloska-poliklinika-vukotic-podgorica.sql:
-- mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-stomatoloska-poliklinika-vukotic-podgorica-services.sql
--
-- Источник: https://dentalclinicvukotic.com/, curl 2026-10-08. Прайса нет; все позиции price = NULL.
-- Заведены только процедуры, прямо названные на сайте; направления и оборудование — в excluded записи импорта.
-- Сайт не делит услуги по ординациям сети — список одинаковый для всех филиалов.
--
-- Итого: 31 услуг (0 с ценой), новых записей каталога — 1 (inhalation-sedation). Анализов нет.
-- Привязок врач↔услуга: 0.
--
-- Самоисправляющийся: канонический список во временной таблице, upsert + DELETE лишнего.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJD4HEq07rTRMRt07EFEmcmMw' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'stomatoloska-poliklinika-vukotic-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-stomatoloska-poliklinika-vukotic-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ ЗАПИСИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- dentalclinicvukotic.com /sedacija/: «Inhalaciona Sedacija — Upotrebom posebne opreme … omogućava se udisanje
-- smješe gasova preko maske za nos … ostaje u svjesnom stanju». Единственная седация в каталоге —
-- conscious-sedation, и она внутривенная («Analgosedacija (kratkotrajna venska anestezija)»), это другая
-- процедура. Категория 20 DENTISTRY, специальность 78.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'inhalation-sedation', 'Inhalation Sedation', 'Inhalaciona sedacija', 'Инхалациона седација',
	'Ингаляционная седация', 'Inhalationssedierung', 'İnhalasyon sedasyonu', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'inhalation-sedation' OR name_en = 'Inhalation Sedation');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 20 FROM medical_services WHERE slug = 'inhalation-sedation';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 78 FROM medical_services WHERE slug = 'inhalation-sedation';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Nitrous Oxide Sedation', 'en' FROM medical_services WHERE slug = 'inhalation-sedation';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Седация закисью азота', 'ru' FROM medical_services WHERE slug = 'inhalation-sedation';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Sedacija preko maske za nos', 'sr' FROM medical_services WHERE slug = 'inhalation-sedation';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (31)
-- Рядом с каждой — фраза сайта, которой она обоснована.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_q_vkp_services;
CREATE TEMPORARY TABLE tmp_q_vkp_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
);

INSERT INTO tmp_q_vkp_services (slug, price, price_min, price_max) VALUES
	('aesthetic-tooth-restoration', NULL, NULL, NULL), -- /usluge/: «Estetsko rekonstruktivna stomatologija — … vrhunska estetika materijala koje primjenjujemo. (3M, GC, DENSPLY)»
	('machine-root-canal-treatment-per-canal', NULL, NULL, NULL), -- «Zubno liječenje — … Mašinska obrada kanala korijena, adekvatni preparati tokom tretmana (SEPTODONT)»
	('complete-denture', NULL, NULL, NULL), -- Protetika: «izradu svih vrsta mobilnih protetskih nadoknada ( IVOCLAR )»
	('partial-denture', NULL, NULL, NULL), -- то же
	('metal-ceramic-crown', NULL, NULL, NULL), -- «kao i fiksnih metalo-keramičkih (VITA , NORITAKE) … krunica» — две марки керамики через запятую, бренд-дубль не заводим
	('metal-ceramic-bridge-pontic', NULL, NULL, NULL), -- «… metalo-keramičkih … mostova»
	('all-ceramic-crown', NULL, NULL, NULL), -- «i čisto keramičkih krunica»
	('ceramic-dental-bridge', NULL, NULL, NULL), -- «… i mostova»
	('partial-denture-with-precision-attachment', NULL, NULL, NULL), -- «i kombinacije fiksnih i mobilnih protetskih nadoknada»
	('soft-dental-deposit-removal', NULL, NULL, NULL), -- Parodontologija: «konzervativno liječenje kao uklanjanje mekih naslaga»
	('dental-calculus-removal-and-air-flow', NULL, NULL, NULL), -- «ultrazvučno čišćenje zubnog kamenca, peskiranje i poliranje zuba»
	('flap-surgery-periodontal', NULL, NULL, NULL), -- «a u težim slučajevima hirurški tretman desni»
	('bone-augmentation-biooss', NULL, NULL, NULL), -- «i ugradnju vještačke kosti. (BIO-OSS , BIO-GIDE)»
	('resorbable-membrane', NULL, NULL, NULL), -- то же — Geistlich Bio-Gide = резорбируемая мембрана (как у Mušura)
	('apicoectomy', NULL, NULL, NULL), -- Oralna hirurgija: «operativni tremani zubnih granuloma»
	('cystectomy', NULL, NULL, NULL), -- «viličnih cista»
	('surgical-tooth-extraction', NULL, NULL, NULL), -- «hirurško vađenje zuba»
	('pre-prosthetic-soft-and-hard-tissue-correction', NULL, NULL, NULL), -- «predprotetski hirurški tretmani mekih tkiva» — единственный кандидат
	('dental-implant-straumann', NULL, NULL, NULL), -- Implantologija: «Ugradnjom implantata (STRAUMANN , BIOHORIZONS)»
	('dental-implant-biohorizons', NULL, NULL, NULL), -- то же
	('implant-suprastructure', NULL, NULL, NULL), -- «… funkcionalnost krunica i mostova na implantatima»
	('orthodontic-treatment-planning', NULL, NULL, NULL), -- Ortopedija vilica: «Pažljivim planiranjem terapije»
	('orthodontic-removable-plate-appliance', NULL, NULL, NULL), -- «izradom mobilnih i fiksnih aparata (DENTAURUM)»
	('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL), -- то же — материал брекетов не назван
	('fixed-orthodontic-check-up', NULL, NULL, NULL), -- «i kontrolama pacijenata kroz određeni vremenski period»
	('orthodontic-follow-up-of-removable-appliance', NULL, NULL, NULL), -- то же
	('pediatric-dental-adaptation', NULL, NULL, NULL), -- Dječija i preventivna: «Posebnu pažnju posvećujemo radu sa djecom što podrazumjeva oslobađanje od straha»
	('inhalation-sedation', NULL, NULL, NULL), -- /sedacija/: «Inhalaciona Sedacija — … udisanje smješe gasova preko maske za nos» (НОВАЯ запись каталога)
	('intraoral-x-ray', NULL, NULL, NULL), -- /rendgen-kabinet/: «tehnologijom digitalne radiografije za snimanje zuba (KODAK)», /usluge/: «Digitalna radioviziografija»
	('panoramic-x-ray', NULL, NULL, NULL), -- «digitalnim ortopantomograf aparatom (PLANMECA) za snimanje kompletnih vilica, sinusa i viličnih zglobova»
	('dental-first-aid', NULL, NULL, NULL); -- Главная: «Za hitne intervencije klijentima smo na raspolaganju 24 časa dnevno»

-- Страховка: slug, которого нет в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_slug
FROM tmp_q_vkp_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_q_vkp_services t
JOIN medical_services ms ON ms.slug = t.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE
	price = t.price,
	price_min = t.price_min,
	price_max = t.price_max;

-- Снятие услуг клиники, которых нет в каноническом списке. Только эта клиника.
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_q_vkp_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- Сайт не называет врачей у услуг — привязок нет.
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается: total = 31, with_price = 0.
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
FROM medical_services ms WHERE ms.slug IN ('inhalation-sedation');

DROP TEMPORARY TABLE IF EXISTS tmp_q_vkp_services;

-- ═══════════════════════════════════════════════════════════════════════════
-- Pollex Physio (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-pollex-physio-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-pollex-physio-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/pollex-physio-podgorica.json.
-- 
-- Услуг: 9, с ценой: 0 (цен нет). Новая запись каталога (идемпотентно по slug): physiotherapist-home-visit (агент Y).
-- Не заведены: Visceralna manipulacija (альтернативная медицина, решение юзера); 4 пакета без цен (упомянуты в описании);
-- Tecar, dry cupping, YUMEIHO akupresura, OMT spinalne manipulacije — только в составе пакетов; /shop — цифровые товары-заглушки.
-- is_price_outdated не ставится (решение юзера 2026-10-08).
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJfaGYgC3rTRMRHWWeeXeO6Wo' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'pollex-physio-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-pollex-physio-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Общая запись «физиотерапия на дому» без километража. Pollex Physio: «Fizioterapija — Patronažna terapija je oblik fizikalne terapije sprovedene van zdravstvene ustanove u kućnom okruženju», расстояний и цен нет. В каталоге только physiotherapist-home-visit-up-to-5-km / -5-to-15-km / -over-15-km (тарифы по расстоянию) — ни один не подходит без расстояния. Кат. 5 PHYSIOTHERAPY + 30 HOME_VISITS, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'physiotherapist-home-visit', 'Physiotherapist Home Visit', 'Kućna posjeta fizioterapeuta', 'Кућна посјета физиотерапеута',
	'Визит физиотерапевта на дом', 'Physiotherapeuten-Hausbesuch', 'Fizyoterapist ev ziyareti', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'physiotherapist-home-visit' OR name_en = 'Physiotherapist Home Visit');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('physiotherapist-home-visit');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 30 FROM medical_services WHERE slug IN ('physiotherapist-home-visit');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN ('physiotherapist-home-visit');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Patronažna fizioterapija', 'sr' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Патронажна физиотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Fizioterapija u kućnim uslovima', 'sr' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Физиотерапија у кућним условима', 'sr-cyrl' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Home Physiotherapy', 'en' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Физиотерапия на дому', 'ru' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Physiotherapie zu Hause', 'de' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Evde fizyoterapi', 'tr' FROM medical_services WHERE slug = 'physiotherapist-home-visit'
UNION ALL SELECT id, 'Individualni trening', 'sr' FROM medical_services WHERE slug = 'individual-kinesiotherapy'
UNION ALL SELECT id, 'Индивидуални тренинг', 'sr-cyrl' FROM medical_services WHERE slug = 'individual-kinesiotherapy'
UNION ALL SELECT id, 'Grupne vježbe', 'sr' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Групне вјежбе', 'sr-cyrl' FROM medical_services WHERE slug = 'group-exercises-type-b';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_pollex_physio_podgorica;
CREATE TEMPORARY TABLE tmp_pollex_physio_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_pollex_physio_podgorica (slug, price, price_min, price_max) VALUES
('kinesiotherapy', NULL, NULL, NULL), -- services.kinesitherapy — «Kineziterapija je najvažniji oblik fizikalne terapije. Odnosi se na upotrebu pokreta i vježbi kao terapeutski postupak u rehabilitaciji pacijenata»
('manual-therapy', NULL, NULL, NULL), -- services.manual — «Manualna Terapija … upotrebu specijalnih manuelnih tehnika i vještina koje fizioterapeut sprovodi rukama»
('electrotherapy', NULL, NULL, NULL), -- services.electrotherapy — «Elektroterapija … primjenu strujnih modaliteta u terapeutske svrhe uz pomoć specijalne opreme»
('acupuncture', NULL, NULL, NULL), -- services.acupuncture — «Akupunktura je primjena veoma tankih sterilnih igala u mišićne strukture ili tetive u cilju eliminacije mišićne napetosti i bola»
('individual-kinesiotherapy', NULL, NULL, NULL), -- services.exercises «Grupne i Individualne Vježbe» — «Individualni trening ima za cilj jačanje ciljanih mišića, ispravljanje deformiteta i stabilizaciju kičmenog stuba»
('group-exercises-type-b', NULL, NULL, NULL), -- services.exercises — «Grupne vježbe radimo u broju od 2 do 4 osobe»
('therapeutic-massage-complete', NULL, NULL, NULL), -- services.massage — «Masaže su oblik fizikalne terapije koji podrazumjeva primjenu specijalnih tehnika masaže za opuštanje i rehabilitaciju mišića» (зона и длительность не указаны — generic)
('physiotherapist-home-visit', NULL, NULL, NULL), -- services.visiting «Fizioterapija» — «Patronažna terapija je oblik fizikalne terapije sprovedene van zdravstvene ustanove u kućnom okruženju»
('chiropractic-treatment', NULL, NULL, NULL); -- services.chiropractic «Kiropraktika» (описание на сайте — копия текста patronažne terapije, ошибка вёрстки, название услуги однозначно)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_pollex_physio_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_pollex_physio_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_pollex_physio_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 0
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 9 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 1: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('physiotherapist-home-visit');

DROP TEMPORARY TABLE IF EXISTS tmp_pollex_physio_podgorica;

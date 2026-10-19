-- ═══════════════════════════════════════════════════════════════════════════
-- K-med Ambulanta i Pedijatrijska Ambulanta Bar — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-k-med-ambulanta-bar-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-k-med-ambulanta-bar.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/k-med-ambulanta-bar.json.
-- 
-- Услуг: 14, с ценой: 0 (на сайте цен нет). Анализов: 0 — «Sve vrste analiza» без перечня, заведён только забор крови.
-- Новая запись каталога: telephone-medical-consultation — общая для обеих карточек K-med (вторая: insert-clinic-k-med-ambulanta-stoj-ulcinj-services.sql),
-- дублируется в data/clinic-imports/_wave2d-new-catalog-T.json. is_price_outdated не ставится (решение юзера 2026-10-08).
-- Перечень услуг на сайте общий для сети, точки не различаются — у обеих карточек одинаковый список.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJq2ERcwB1ThMRmxfuKUAW7sA' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'k-med-ambulanta-bar' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-k-med-ambulanta-bar.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- K-med «Savjetovanje — Mogućnost savjetovanja i putem telefona», «sa mogućnošću konsultacija telefonom». В каталоге нет консультации по телефону (e-consultation-with-specialist — консилиум ДЗ со специалистом, brief-doctor-visit-consultation — очный визит). Категория 9 GENERAL_MEDICINE, специальность 45.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'telephone-medical-consultation', 'Telephone Medical Consultation', 'Savjetovanje ljekara putem telefona', 'Савјетовање љекара путем телефона',
	'Консультация врача по телефону', 'Telefonische ärztliche Beratung', 'Telefonla doktor danışmanlığı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'telephone-medical-consultation' OR name_en = 'Telephone Medical Consultation');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 9 FROM medical_services WHERE slug IN ('telephone-medical-consultation');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 45 FROM medical_services WHERE slug IN ('telephone-medical-consultation');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Telefonska konsultacija', 'sr' FROM medical_services WHERE slug = 'telephone-medical-consultation'
UNION ALL SELECT id, 'Телефонска консултација', 'sr-cyrl' FROM medical_services WHERE slug = 'telephone-medical-consultation'
UNION ALL SELECT id, 'Phone Consultation', 'en' FROM medical_services WHERE slug = 'telephone-medical-consultation'
UNION ALL SELECT id, 'Телефонная консультация', 'ru' FROM medical_services WHERE slug = 'telephone-medical-consultation'
UNION ALL SELECT id, 'Telefonberatung', 'de' FROM medical_services WHERE slug = 'telephone-medical-consultation'
UNION ALL SELECT id, 'Telefon danışmanlığı', 'tr' FROM medical_services WHERE slug = 'telephone-medical-consultation'
UNION ALL SELECT id, 'Posjeta hotelskoj sobi', 'sr' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Посјета хотелској соби', 'sr-cyrl' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Hotel Room Visit', 'en' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Вызов врача в отель', 'ru' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Arztbesuch im Hotel', 'de' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Otel odasında muayene', 'tr' FROM medical_services WHERE slug = 'home-visit-examination'
UNION ALL SELECT id, 'Infuzija za rehidrataciju', 'sr' FROM medical_services WHERE slug = 'infusion-therapy'
UNION ALL SELECT id, 'Rehydration Infusion', 'en' FROM medical_services WHERE slug = 'infusion-therapy'
UNION ALL SELECT id, 'Капельница при обезвоживании', 'ru' FROM medical_services WHERE slug = 'infusion-therapy'
UNION ALL SELECT id, 'Glukometrija', 'sr' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Глукометрија', 'sr-cyrl' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Глюкометрия', 'ru' FROM medical_services WHERE slug = 'rapid-blood-glucose-test'
UNION ALL SELECT id, 'Oksimetrija', 'sr' FROM medical_services WHERE slug = 'pulse-oximetry'
UNION ALL SELECT id, 'Оксиметрија', 'sr-cyrl' FROM medical_services WHERE slug = 'pulse-oximetry';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_k_med_ambulanta_bar;
CREATE TEMPORARY TABLE tmp_k_med_ambulanta_bar (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_k_med_ambulanta_bar (slug, price, price_min, price_max) VALUES
('general-practitioner-examination', NULL, NULL, NULL), -- Pregledi — «Mogućnost pregleda u ambulanti ili na Vašoj lokaciji.» (ljekari bez navedene specijalizacije, ambulanta «namijenjena i djeci i odraslima»)
('pediatric-examination', NULL, NULL, NULL), -- FAQ «Da li možemo dovesti djecu na pregled? Mi smo ambulanta koja je namijenjena i djeci i odraslima.», direktor — pedijatar (Google: «… i Pedijatrijska Ambulanta»)
('home-visit-examination', NULL, NULL, NULL), -- «… ili na Vašoj lokaciji», «Posjete hotelskoj sobi», FAQ «mi dolazimo u roku od sat vremena na adresu»
('infusion-therapy-home-visit', NULL, NULL, NULL), -- Posjete hotelskoj sobi — «Uz mogućnost uključivanja infuzione terapije na smještaju.»
('intramuscular-injection', NULL, NULL, NULL), -- Terapije — «Injekciona, …» (O nama: «Injekciona terapija») — generic injekcija ambulante
('inhalation-therapy', NULL, NULL, NULL), -- Terapije — «… Inhalaciona, …»
('infusion-therapy', NULL, NULL, NULL), -- Terapije — «… Infuziona.», FAQ «Da li imate infuzionu terapiju za rehidrataciju? Da …»
('telephone-medical-consultation', NULL, NULL, NULL), -- Savjetovanje — «Mogućnost savjetovanja i putem telefona.»
('venous-blood-draw', NULL, NULL, NULL), -- Laboratorija — «Sve vrste analiza …», FAQ «Kod nas se mogu uzeti laboratorijske analize i šalju se pacijentima putem SMS-a ili mejla»
('rapid-blood-glucose-test', NULL, NULL, NULL), -- Laboratorija — «… glukometrija …»
('pulse-oximetry', NULL, NULL, NULL), -- Laboratorija — «… oksimetrija.»
('ecg', NULL, NULL, NULL), -- «EKG pregledi»
('wound-care', NULL, NULL, NULL), -- «Obrada i previjanje rana»
('wound-dressing', NULL, NULL, NULL); -- «Obrada i previjanje rana» (previjanje)

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_k_med_ambulanta_bar t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_k_med_ambulanta_bar t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_k_med_ambulanta_bar t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 1
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_k_med_ambulanta_bar_ds;
CREATE TEMPORARY TABLE tmp_k_med_ambulanta_bar_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_k_med_ambulanta_bar_ds (doctor_slug, service_slug) VALUES
('nebojsa-kavaric', 'pediatric-examination'); -- единственный педиатр, «Specijalista je pedijatrije»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_k_med_ambulanta_bar_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_k_med_ambulanta_bar_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 14 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 1 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 1: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('telephone-medical-consultation');

DROP TEMPORARY TABLE IF EXISTS tmp_k_med_ambulanta_bar;
DROP TEMPORARY TABLE IF EXISTS tmp_k_med_ambulanta_bar_ds;

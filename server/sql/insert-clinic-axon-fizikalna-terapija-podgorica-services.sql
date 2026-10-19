-- ═══════════════════════════════════════════════════════════════════════════
-- AXON Fizikalna Terapija (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-axon-fizikalna-terapija-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-axon-fizikalna-terapija-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/axon-fizikalna-terapija-podgorica.json.
--
-- Услуг: 22, с ценой: 0. Новых записей каталога: 2 (electroacupuncture, vestibular-rehabilitation) —
-- дублируются в data/clinic-imports/_wave2c-new-catalog-P.json для сверки координатором.
-- is_price_outdated не ставится (решение юзера 2026-10-08).
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены обновляются
-- ON DUPLICATE KEY UPDATE, лишние услуги и привязки врач↔услуга прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJNWX6KgDrTRMRskpO74r8428' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'axon-fizikalna-terapija-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-axon-fizikalna-terapija-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- Категория 5 = PHYSIOTHERAPY; специальность 42 = PHYSICAL_MEDICINE (авто-привязка кат. 5).
-- ═══════════════════════════════════════════════════════════════

-- Fizio Centar Nikšić «AKUPUNKTURU / ELEKTROAKUPUNKTURU»; AXON «Elektroakupunktura — Nadogradnja klasične akupunkture blagom električnom stimulacijom kroz igle». В каталоге только Acupuncture. Категория как у acupuncture (5).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'electroacupuncture', 'Electroacupuncture', 'Elektroakupunktura', 'Електроакупунктура',
	'Электроакупунктура', 'Elektroakupunktur', 'Elektroakupunktur', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'electroacupuncture' OR name_en = 'Electroacupuncture');

-- AXON /specijalizacije.html: «Vrtoglavice i poremećaji ravnoteže — Benigni paroksizmalni vertigo (BPPV), Vestibularni neuritis, Cervikalni vertigo, Poremećaji ravnoteže i hoda»; Marko Mićković — «fizioterapije kod vertiga». Решение координатора 2026-10-08 — завести. Категория/специальность как у соседних реабилитационных записей (5 / 42).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'vestibular-rehabilitation', 'Vestibular Rehabilitation', 'Vestibularna rehabilitacija', 'Вестибуларна рехабилитација',
	'Вестибулярная реабилитация', 'Vestibuläre Rehabilitation', 'Vestibüler rehabilitasyon', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'vestibular-rehabilitation' OR name_en = 'Vestibular Rehabilitation');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN (
	'electroacupuncture',
	'vestibular-rehabilitation'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN (
	'electroacupuncture',
	'vestibular-rehabilitation'
);

-- Синонимы: новые записи + бренды и формулировки сайтов к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Electro-acupuncture', 'en' FROM medical_services WHERE slug = 'electroacupuncture'
UNION ALL SELECT id, 'Электропунктура', 'ru' FROM medical_services WHERE slug = 'electroacupuncture'
UNION ALL SELECT id, 'Rehabilitacija kod vrtoglavice', 'sr' FROM medical_services WHERE slug = 'vestibular-rehabilitation'
UNION ALL SELECT id, 'Рехабилитација код вртоглавице', 'sr-cyrl' FROM medical_services WHERE slug = 'vestibular-rehabilitation'
UNION ALL SELECT id, 'Vertigo Rehabilitation', 'en' FROM medical_services WHERE slug = 'vestibular-rehabilitation'
UNION ALL SELECT id, 'Лечение головокружения', 'ru' FROM medical_services WHERE slug = 'vestibular-rehabilitation'
UNION ALL SELECT id, 'Schwindeltherapie', 'de' FROM medical_services WHERE slug = 'vestibular-rehabilitation'
UNION ALL SELECT id, 'Vertigo rehabilitasyonu', 'tr' FROM medical_services WHERE slug = 'vestibular-rehabilitation'
UNION ALL SELECT id, 'Poluindividualni treninzi', 'sr' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Полуиндивидуални тренинзи', 'sr-cyrl' FROM medical_services WHERE slug = 'group-exercises-type-b';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_axon_fizikalna_terapija_podgorica;
CREATE TEMPORARY TABLE tmp_axon_fizikalna_terapija_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_axon_fizikalna_terapija_podgorica (slug, price, price_min, price_max) VALUES
('group-exercises-type-b', NULL, NULL, NULL), -- «Poluindividualni treninzi pod nadzorom fizioterapeuta — Treninzi se održavaju u grupama do 3 osobe po terapeutu…»; FAQ «svaka grupa broji 3 do najviše 4 člana»
('first-physiatrist-examination', NULL, NULL, NULL), -- «Pregled fizijatra — Detaljan specijalistički pregled podrazumijeva procjenu posture, pokretljivosti, mišićne snage i funkcionalnog statusa…»
('schroth-method', NULL, NULL, NULL), -- «Schroth metoda — Trodimenzionalna terapija za korekciju skolioze i deformiteta kičme…»
('spinal-discopathy-and-stenosis-rehabilitation', NULL, NULL, NULL), -- «Liječenje diskus hernije i bolova u kičmi — Program obuhvata kombinaciju manuelnih tehnika, aparaturnih terapija i specifičnih stabilizacionih vježbi.»
('tecar-therapy', NULL, NULL, NULL), -- «TEKAR terapija — …putem radiofrekventne energije»
('shock-wave-therapy', NULL, NULL, NULL), -- «Shockwave terapija»
('electrotherapy', NULL, NULL, NULL), -- «Elektroterapija — Primjena različitih vrsta terapijskih struja…»
('laser-therapy', NULL, NULL, NULL), -- «Laser terapija — Biostimulativna terapija…»
('magnetic-therapy', NULL, NULL, NULL), -- «Magnetoterapija — Koristi pulsirajuće magnetno polje…»
('ultrasound-therapy', NULL, NULL, NULL), -- «Ultrazvučna terapija — Dubinska mikromasaža tkiva putem zvučnih talasa.»
('acupuncture', NULL, NULL, NULL), -- «Akupunktura»
('electroacupuncture', NULL, NULL, NULL), -- «Elektroakupunktura — Nadogradnja klasične akupunkture blagom električnom stimulacijom kroz igle.»
('dry-needling', NULL, NULL, NULL), -- specijalizacije «Dry Needling»; FAQ «Takođe koristimo dry needling i elektroakupunkturu»
('chiropractic-treatment', NULL, NULL, NULL), -- «Kiropraktika — Manuelna tehnika… Kroz kontrolisane manipulacije zglobova…»
('manual-therapy', NULL, NULL, NULL), -- specijalizacije «Manuelna terapija i mobilizacija»; FAQ «manuelne terapijske tehnike poput kiropraktike, masaže i Mulligan mobilizacija»
('therapeutic-massage-complete', NULL, NULL, NULL), -- «Medicinska masaža — Terapijska masaža usmjerena na smanjenje napetosti…» (зона и длительность не указаны — generic Complete Therapeutic Massage)
('lymphatic-drainage-complete', NULL, NULL, NULL), -- FAQ «sprovodimo relaks, terapeutske i sportske masaže, kao i limfnu drenažu»
('pressotherapy', NULL, NULL, NULL), -- «Presoterapija — savremena metoda limfne drenaže…»
('sports-injury-rehabilitation', NULL, NULL, NULL), -- specijalizacije «Sportske povrede — Ruptura ligamenata i mišića, Povrede koljena (LCA, meniskus)…»
('postoperative-locomotor-system-rehabilitation', NULL, NULL, NULL), -- specijalizacije «Postoperativna stanja — Rana rehabilitacija nakon operacije…»
('vestibular-rehabilitation', NULL, NULL, NULL), -- specijalizacije «Vrtoglavice i poremećaji ravnoteže — Vrtoglavice su čest, ali rijetko pravilno tretiran problem… Benigni paroksizmalni vertigo (BPPV), Vestibularni neuritis, Cervikalni vertigo, Poremećaji ravnoteže i hoda»
('central-and-peripheral-nervous-system-disease-rehabilitation', NULL, NULL, NULL); -- specijalizacije «Neurološka stanja — Moždani udar, Multipla skleroza, Parkinsonova bolest, Periferne neuropatije»

-- Ожидается ПУСТО: slug, не найденные в каталоге.
SELECT t.slug AS unmatched_service
FROM tmp_axon_fizikalna_terapija_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_axon_fizikalna_terapija_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_axon_fizikalna_terapija_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL)
-- Только то, что сайт прямо связывает с человеком (FAQ, био, теги карточек) — см. запись импорта.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_axon_fizikalna_terapija_podgorica_ds;
CREATE TEMPORARY TABLE tmp_axon_fizikalna_terapija_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_axon_fizikalna_terapija_podgorica_ds (doctor_slug, service_slug) VALUES
('aleksandra-savic', 'first-physiatrist-examination'), -- единственный физиатр; «Pregled fizijatra»
('aleksandra-savic', 'acupuncture'), -- теги: «Akupunktura»; bio «Školu akupunkture (SUIM)»
('aleksandra-savic', 'lymphatic-drainage-complete'), -- теги: «Limfna drenaža»; bio «kurs manuelne limfne drenaže po metodi dr Voddera»
('srdjan-mijovic', 'schroth-method'), -- теги: «SCHROTH metoda», «Skolioza»
('srdjan-mijovic', 'dry-needling'), -- теги: «Dry Needling»
('marko-mickovic', 'spinal-discopathy-and-stenosis-rehabilitation'), -- теги: «Diskus hernija»
('marko-mickovic', 'vestibular-rehabilitation'), -- теги: «Vrtoglavice»; bio «fizioterapije kod vertiga»
('marko-mickovic', 'sports-injury-rehabilitation'), -- теги: «Sportska rehab.»
('djordje-barovic', 'sports-injury-rehabilitation'), -- теги: «Sportska rehab.»
('djordje-barovic', 'lymphatic-drainage-complete'), -- теги: «Limfna drenaža»
('andrija-golubovic', 'group-exercises-type-b'); -- теги: «Grupni treninzi»

-- Ожидается ПУСТО: врач не найден или не привязан к клинике.
SELECT t.doctor_slug AS unmatched_doctor
FROM tmp_axon_fizikalna_terapija_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_axon_fizikalna_terapija_podgorica_ds t
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

-- Ожидается 11 привязок.
SELECT d.slug, GROUP_CONCAT(ms.slug ORDER BY ms.slug) AS services
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
GROUP BY d.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_axon_fizikalna_terapija_podgorica_ds;

-- Ожидается 2: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(s.specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('electroacupuncture', 'vestibular-rehabilitation');

DROP TEMPORARY TABLE IF EXISTS tmp_axon_fizikalna_terapija_podgorica;

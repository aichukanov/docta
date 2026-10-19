-- ═══════════════════════════════════════════════════════════════════════════
-- PhysioCare Team (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-physiocare-team-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-physiocare-team-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/physiocare-team-podgorica.json.
-- 
-- Услуг: 21, с ценой: 0 (цен на сайте нет). Новые записи каталога: pregnancy-exercises, thermotherapy (координатор 2026-10-09) —
-- дублируются в data/clinic-imports/_wave2d-new-catalog-T.json. is_price_outdated не ставится (решение юзера 2026-10-08).
-- Не заведены (координатор 2026-10-09): Neurocinetic — страница-заглушка «Tekst», содержание не известно; Edukacija roditelja —
-- пункт меню без страницы, обучение родителей внутри программы Schroth, не отдельная услуга.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJ5QD3ZCfrTRMR9QOV5UrtnyM' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'physiocare-team-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-physiocare-team-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- PhysioCare /medicinski-fitnes: «Vjžbe za trudnice» (так на сайте). В каталоге для беременных есть только массаж (Pregnancy Massage 30/45 min) — упражнений нет ни под одним названием. Категория 5 PHYSIOTHERAPY, специальность 42 (авто-привязка кат. 5).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pregnancy-exercises', 'Pregnancy Exercises', 'Vježbe za trudnice', 'Вјежбе за труднице',
	'Гимнастика для беременных', 'Schwangerschaftsgymnastik', 'Hamile egzersizleri', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pregnancy-exercises' OR name_en = 'Pregnancy Exercises');

-- Fizikalna terapija — «-Termoterapija» отдельной строкой рядом с «- Krioterapija»: тепловая процедура без указания вида.
-- В каталоге только конкретные виды (Parafango, Thermo Pack, Cryotherapy) → общая запись (координатор 2026-10-09). Кат. 5, спец. 42.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'thermotherapy', 'Thermotherapy', 'Termoterapija', 'Термотерапија',
	'Термотерапия', 'Thermotherapie', 'Termoterapi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'thermotherapy' OR name_en = 'Thermotherapy');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN ('pregnancy-exercises', 'thermotherapy');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN ('pregnancy-exercises', 'thermotherapy');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Toplotna terapija', 'sr' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Топлотна терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Heat Therapy', 'en' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Тепловая терапия', 'ru' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Wärmetherapie', 'de' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Sıcak tedavisi', 'tr' FROM medical_services WHERE slug = 'thermotherapy'
UNION ALL SELECT id, 'Prenatalne vježbe', 'sr' FROM medical_services WHERE slug = 'pregnancy-exercises'
UNION ALL SELECT id, 'Пренаталне вјежбе', 'sr-cyrl' FROM medical_services WHERE slug = 'pregnancy-exercises'
UNION ALL SELECT id, 'Prenatal Exercise', 'en' FROM medical_services WHERE slug = 'pregnancy-exercises'
UNION ALL SELECT id, 'ЛФК для беременных', 'ru' FROM medical_services WHERE slug = 'pregnancy-exercises'
UNION ALL SELECT id, 'Schwangerschaftsübungen', 'de' FROM medical_services WHERE slug = 'pregnancy-exercises'
UNION ALL SELECT id, 'Doğum öncesi egzersiz', 'tr' FROM medical_services WHERE slug = 'pregnancy-exercises'
UNION ALL SELECT id, 'Mulligan', 'en' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Mulligan terapija', 'sr' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Mulligan-Konzept', 'de' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Терапия по Маллигану', 'ru' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'IMTT', 'en' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Miofascijalno opuštanje', 'sr' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Миофасцијално опуштање', 'sr-cyrl' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Myofascial Release', 'en' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'Миофасциальный релиз', 'ru' FROM medical_services WHERE slug = 'manual-therapy'
UNION ALL SELECT id, 'PNF', 'en' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'PNF', 'sr' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Proprioceptivna neuromišićna facilitacija', 'sr' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Proprioceptive Neuromuscular Facilitation', 'en' FROM medical_services WHERE slug = 'kinesiotherapy'
UNION ALL SELECT id, 'Kinematic Tape', 'en' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'Kinematic tape', 'sr' FROM medical_services WHERE slug = 'taping-application'
UNION ALL SELECT id, 'BSPTS', 'en' FROM medical_services WHERE slug = 'schroth-method'
UNION ALL SELECT id, 'Medicinski fitnes', 'sr' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Медицински фитнес', 'sr-cyrl' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Medical Fitness', 'en' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Analiza posture', 'sr' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Анализа постуре', 'sr-cyrl' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Posture Analysis', 'en' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'TNS', 'sr' FROM medical_services WHERE slug = 'tens-therapy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_physiocare_team_podgorica;
CREATE TEMPORARY TABLE tmp_physiocare_team_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_physiocare_team_podgorica (slug, price, price_min, price_max) VALUES
('physiotherapist-examination', NULL, NULL, NULL), -- Fizioterapeutska procjena — «prvi kontakt sa pacjentom/klijentom podrazumijeva fizioterapeutska procjena … analiziramo Vašu posturu, aktivnu i pasivnu pokretljivost uz testiranje snage mišića», Scolio art «Pregled i analiza posture»
('tens-therapy', NULL, NULL, NULL), -- Fizikalna terapija — «-Elektroterapija ( TNS, …» (TNS = TENS)
('diadynamic-currents', NULL, NULL, NULL), -- Fizikalna terapija — «… diadinamičke struje …»
('interferential-currents', NULL, NULL, NULL), -- Fizikalna terapija — «… interferentne struje …»
('galvanic-therapy', NULL, NULL, NULL), -- Fizikalna terapija — «… galvanizacija …»
('muscle-electrical-stimulation', NULL, NULL, NULL), -- Fizikalna terapija — «… elektostimulacija)»
('magnetic-therapy', NULL, NULL, NULL), -- Fizikalna terapija — «- Magnetoterapija»
('ultrasound-therapy', NULL, NULL, NULL), -- Fizikalna terapija — «-Terapijski ultrazvuk»
('laser-therapy', NULL, NULL, NULL), -- Fizikalna terapija — «-Terapijski laser»
('thermotherapy-cryotherapy', NULL, NULL, NULL), -- Fizikalna terapija — «- Krioterapija»
('thermotherapy', NULL, NULL, NULL), -- Fizikalna terapija — «-Termoterapija» (координатор 2026-10-09)
('kinesiotherapy', NULL, NULL, NULL), -- Kineziterapija — «Pokret ( vježba) je neizostavni dio rehabilitacije … Program vježbi kreira se u skladu sa vašim problemom», PNF — «Ovaj koncept vježbanja naročito je pogodan kod ortopedskih i neuroloških pacjenata»
('individual-kinesiotherapy', NULL, NULL, NULL), -- Medicinski fitnes — «Individualno vježbanje»
('group-exercises-type-b', NULL, NULL, NULL), -- Medicinski fitnes — «Vježbanje u grupi — Grupno vježbanje sprovodi se u individualizovanim grupama ( 2-4 člana)»
('pregnancy-exercises', NULL, NULL, NULL), -- Medicinski fitnes — «Vjžbe za trudnice»
('therapeutic-massage-complete', NULL, NULL, NULL), -- Fizioterapeutska masaža — «nudimo vam fizioterapeutski masažu kojom se ciljano rešavaju problemi svakog pacijenta» (зона и длительность не указаны — generic, как в axon)
('manual-therapy', NULL, NULL, NULL), -- Mulligan terapija — «manuelna tepaijska tehnika koja integriše mobilizaciju sa pokretom», Miofascijalno opuštanje trigger tačaka — «IMTT metoda …» (обе — ручные техники, бренд/метод — синонимы)
('taping-application', NULL, NULL, NULL), -- Kinematic Tape — «Kinematic taping je specifičan i jedinstven način lijepljenja trake na tijelo» (как KINESIOTAPE у fizio-centar-niksic)
('dry-needling', NULL, NULL, NULL), -- Dry needling (suva punkcija) — «primjenu veoma malih iglica za jednokratnu upotrebu, koje se aplikuju u određene tačke u mišiću ( triger tačke)»
('schroth-method', NULL, NULL, NULL), -- Scolio art — «Schroth metoda», tim «Schroth BSPTS terapeut»
('kinesiotherapy-for-spine-deformities', NULL, NULL, NULL); -- Scolio art — «Deformiteti kičmenog stuba», O nama «Posebnu pažnju poklanjamo posturalnom disbalansima i deformitetima kičmenog stuba kod djece»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_physiocare_team_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_physiocare_team_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_physiocare_team_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 2
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_physiocare_team_podgorica_ds;
CREATE TEMPORARY TABLE tmp_physiocare_team_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_physiocare_team_podgorica_ds (doctor_slug, service_slug) VALUES
('tamara-mijanovic', 'schroth-method'), -- «Schroth BSPTS terapeut»
('iva-tomkovic', 'schroth-method'); -- «Schroth BSPTS terapeut»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_physiocare_team_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_physiocare_team_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 21 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 2 привязок врач↔услуга.
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
WHERE ms.slug IN ('pregnancy-exercises');

DROP TEMPORARY TABLE IF EXISTS tmp_physiocare_team_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_physiocare_team_podgorica_ds;

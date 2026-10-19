-- ═══════════════════════════════════════════════════════════════════════════
-- Razvojni centar Integra (Podgorica) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-razvojni-centar-integra-podgorica-services.sql
-- 
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-razvojni-centar-integra-podgorica.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта: data/clinic-imports/razvojni-centar-integra-podgorica.json.
-- 
-- Услуг: 8 (все 8 страниц /usluge/), с ценой: 0 — цен на сайте нет. Новых записей каталога: 5 (couples-therapy, child-psychotherapy, adolescent-psychotherapy, online-psychotherapy, group-psychotherapy).
-- Новые записи — без категории, как все психиатрические/психологические записи каталога; детская и подростковая — категория 25 PEDIATRICS.
-- 
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишние услуги и привязки прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJhf2cS1jtTRMRDmrZU-NvYao' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'razvojni-centar-integra-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-razvojni-centar-integra-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- ═══════════════════════════════════════════════════════════════

-- Integra: «Terapija parova» (/usluge/terapija-parova/). Терапии пар в каталоге нет ни под одним названием (поиск couple|parov|partner — только генетическое консультирование пар). Спец. 22 PSYCHOLOGY + 51 PSYCHOTHERAPY. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'couples-therapy', 'Couples Therapy', 'Terapija parova', 'Терапија парова',
	'Психотерапия для пар', 'Paartherapie', 'Çift terapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'couples-therapy' OR name_en = 'Couples Therapy');

-- Integra: «Psihoterapija djece školskog uzrasta». В каталоге для детей есть только осмотры/тесты (child-psychologist-consultation, child-psychiatrist-examination), психотерапии детей нет. Категория 25 PEDIATRICS (как child-psychologist-consultation) → спец. 4 (авто) + 22 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'child-psychotherapy', 'Child Psychotherapy', 'Psihoterapija djece', 'Психотерапија дјеце',
	'Детская психотерапия', 'Kinderpsychotherapie', 'Çocuk psikoterapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'child-psychotherapy' OR name_en = 'Child Psychotherapy');

-- Integra: «Psihoterapija adolescenata» — отдельная страница-услуга рядом с детской. В каталоге нет. Категория 25 PEDIATRICS (подростковый возраст, как first-pediatric-and-adolescent-gynecology-examination) → спец. 4 + 22 + 51.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'adolescent-psychotherapy', 'Adolescent Psychotherapy', 'Psihoterapija adolescenata', 'Психотерапија адолесцената',
	'Психотерапия подростков', 'Psychotherapie für Jugendliche', 'Ergen psikoterapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'adolescent-psychotherapy' OR name_en = 'Adolescent Psychotherapy');

-- Integra: «Online psihoterapija … putem video poziva (Zoom, Google Meet …)». Онлайн-приёмов психотерапевта в каталоге нет (есть только telephone-medical-consultation — врачебная консультация по телефону). Спец. 22 + 51. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'online-psychotherapy', 'Online Psychotherapy', 'Online psihoterapija', 'Онлајн психотерапија',
	'Онлайн-психотерапия', 'Online-Psychotherapie', 'Online psikoterapi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'online-psychotherapy' OR name_en = 'Online Psychotherapy');

-- Integra: «Grupna psihoterapija … iskustveno-terapijske grupe, 6-10 učesnika»; MonteRehab: «Group therapy online». В каталоге групповая психотерапия есть только как тарифные позиции FZOCG с конкретным профилем (…for-addictions, …anxiety-depression-or-psychotic-disorders, group-psychodynamic-and-sociodynamic-therapy) — общей записи нет. Спец. 21 + 22 + 51. Без категории — как все психиатрические/психологические записи каталога (first-psychiatrist-examination, psychotherapy, psychological-counseling): категории «психиатрия» в enum нет.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'group-psychotherapy', 'Group Psychotherapy', 'Grupna psihoterapija', 'Групна психотерапија',
	'Групповая психотерапия', 'Gruppenpsychotherapie', 'Grup psikoterapisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'group-psychotherapy' OR name_en = 'Group Psychotherapy');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 25 FROM medical_services WHERE slug IN ('child-psychotherapy', 'adolescent-psychotherapy');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('child-psychotherapy', 'adolescent-psychotherapy');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 21 FROM medical_services WHERE slug IN ('group-psychotherapy');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 22 FROM medical_services WHERE slug IN ('couples-therapy', 'child-psychotherapy', 'adolescent-psychotherapy', 'online-psychotherapy', 'group-psychotherapy');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 51 FROM medical_services WHERE slug IN ('couples-therapy', 'child-psychotherapy', 'adolescent-psychotherapy', 'online-psychotherapy', 'group-psychotherapy');

-- Синонимы: новые записи + формулировки и бренды сайта к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Psihoterapija za parove', 'sr' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Психотерапија за парове', 'sr-cyrl' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Terapija za parove', 'sr' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Терапија парова', 'sr-cyrl' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Couples Counseling', 'en' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Marriage Counseling', 'en' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Терапия пар', 'ru' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Paarberatung', 'de' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Evlilik terapisi', 'tr' FROM medical_services WHERE slug = 'couples-therapy'
UNION ALL SELECT id, 'Psihoterapija djece školskog uzrasta', 'sr' FROM medical_services WHERE slug = 'child-psychotherapy'
UNION ALL SELECT id, 'Психотерапија дјеце школског узраста', 'sr-cyrl' FROM medical_services WHERE slug = 'child-psychotherapy'
UNION ALL SELECT id, 'Dječija psihoterapija', 'sr' FROM medical_services WHERE slug = 'child-psychotherapy'
UNION ALL SELECT id, 'Дјечија психотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'child-psychotherapy'
UNION ALL SELECT id, 'Психотерапия для детей', 'ru' FROM medical_services WHERE slug = 'child-psychotherapy'
UNION ALL SELECT id, 'Psychotherapy for Children', 'en' FROM medical_services WHERE slug = 'child-psychotherapy'
UNION ALL SELECT id, 'Psihoterapija za adolescente', 'sr' FROM medical_services WHERE slug = 'adolescent-psychotherapy'
UNION ALL SELECT id, 'Психотерапија за адолесценте', 'sr-cyrl' FROM medical_services WHERE slug = 'adolescent-psychotherapy'
UNION ALL SELECT id, 'Подростковая психотерапия', 'ru' FROM medical_services WHERE slug = 'adolescent-psychotherapy'
UNION ALL SELECT id, 'Teen Therapy', 'en' FROM medical_services WHERE slug = 'adolescent-psychotherapy'
UNION ALL SELECT id, 'Jugendpsychotherapie', 'de' FROM medical_services WHERE slug = 'adolescent-psychotherapy'
UNION ALL SELECT id, 'Onlajn psihoterapija', 'sr' FROM medical_services WHERE slug = 'online-psychotherapy'
UNION ALL SELECT id, 'Online психотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'online-psychotherapy'
UNION ALL SELECT id, 'Online Therapy', 'en' FROM medical_services WHERE slug = 'online-psychotherapy'
UNION ALL SELECT id, 'Video Therapy', 'en' FROM medical_services WHERE slug = 'online-psychotherapy'
UNION ALL SELECT id, 'Психотерапия онлайн', 'ru' FROM medical_services WHERE slug = 'online-psychotherapy'
UNION ALL SELECT id, 'Онлайн-психолог', 'ru' FROM medical_services WHERE slug = 'online-psychotherapy'
UNION ALL SELECT id, 'Grupna terapija', 'sr' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Групна терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Group Therapy', 'en' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Групповая терапия', 'ru' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Gruppentherapie', 'de' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Grup terapisi', 'tr' FROM medical_services WHERE slug = 'group-psychotherapy'
UNION ALL SELECT id, 'Individualna psihoterapija', 'sr' FROM medical_services WHERE slug = 'psychotherapy'
UNION ALL SELECT id, 'Индивидуална психотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'psychotherapy'
UNION ALL SELECT id, 'Individual Psychotherapy', 'en' FROM medical_services WHERE slug = 'psychotherapy'
UNION ALL SELECT id, 'Индивидуальная психотерапия', 'ru' FROM medical_services WHERE slug = 'psychotherapy'
UNION ALL SELECT id, 'Psihoterapijsko savjetovanje', 'sr' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Психотерапијско савјетовање', 'sr-cyrl' FROM medical_services WHERE slug = 'psychological-counseling'
UNION ALL SELECT id, 'Porodična terapija', 'sr' FROM medical_services WHERE slug = 'family-psychotherapy-session'
UNION ALL SELECT id, 'Породична терапија', 'sr-cyrl' FROM medical_services WHERE slug = 'family-psychotherapy-session'
UNION ALL SELECT id, 'Sistemska porodična psihoterapija', 'sr' FROM medical_services WHERE slug = 'family-psychotherapy-session'
UNION ALL SELECT id, 'Системска породична психотерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'family-psychotherapy-session'
UNION ALL SELECT id, 'Family Therapy', 'en' FROM medical_services WHERE slug = 'family-psychotherapy-session'
UNION ALL SELECT id, 'Семейная терапия', 'ru' FROM medical_services WHERE slug = 'family-psychotherapy-session';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_razvojni_centar_integra_podgorica;
CREATE TEMPORARY TABLE tmp_razvojni_centar_integra_podgorica (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_razvojni_centar_integra_podgorica (slug, price, price_min, price_max) VALUES
('psychotherapy', NULL, NULL, NULL), -- /usluge/individualna-psihoterapija/: «Individualna psihoterapija» (Za odrasle) — общая запись «Psihoterapija» (спец. 51)
('psychological-counseling', NULL, NULL, NULL), -- /usluge/psihoterapijsko-savjetovanje/: «Psihoterapijsko savjetovanje … kraći, strukturisaniji i konkretnije usmjeren rad» — запись «Psihološko savjetovanje»
('couples-therapy', NULL, NULL, NULL), -- /usluge/terapija-parova/: «Terapija parova … Susreti se odvijaju uživo ili online»
('family-psychotherapy-session', NULL, NULL, NULL), -- /usluge/porodicna-terapija/: «Porodična terapija se temelji na sistemskom pristupu» — запись «Seansa porodične psihoterapije» (единственная общая семейная психотерапия, family-psychological-treatment — «psihološki tretman porodice» тарифа, менее точна)
('adolescent-psychotherapy', NULL, NULL, NULL), -- /usluge/psihoterapija-adolescenata/: «Psihoterapija adolescenata»
('child-psychotherapy', NULL, NULL, NULL), -- /usluge/psihoterapija-djece-skolskog-uzrasta/: «Psihoterapija djece školskog uzrasta»
('online-psychotherapy', NULL, NULL, NULL), -- /usluge/online-psihoterapija/: «Online psihoterapija … putem video poziva (Zoom, Google Meet ili druga bezbjedna platforma)»
('group-psychotherapy', NULL, NULL, NULL); -- /usluge/grupna-psihoterapija/: «Grupna psihoterapija … Grupe su poluzatvorenog tipa, obično broje od 6-10 učesnika»

-- Ожидается ПУСТО (в сухом прогоне без shadow — только новые записи каталога этого файла).
SELECT t.slug AS unmatched_service
FROM tmp_razvojni_centar_integra_podgorica t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_razvojni_centar_integra_podgorica t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_razvojni_centar_integra_podgorica t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL): 7
-- ═══════════════════════════════════════════════════════════════

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

DROP TEMPORARY TABLE IF EXISTS tmp_razvojni_centar_integra_podgorica_ds;
CREATE TEMPORARY TABLE tmp_razvojni_centar_integra_podgorica_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_razvojni_centar_integra_podgorica_ds (doctor_slug, service_slug) VALUES
('marko-minic', 'psychotherapy'), -- «radi kao psihoterapeut u Razvojnom centru Integra»
('ljubica-anicic', 'psychotherapy'), -- «licencirani psihoterapeut … Radi sa odraslima»
('ljubica-anicic', 'adolescent-psychotherapy'), -- «Radi sa odraslima, adolescentima i djecom»
('ljubica-anicic', 'child-psychotherapy'), -- «Radi sa odraslima, adolescentima i djecom»
('dragana-zivkovic', 'psychological-counseling'), -- «angažovana je kao savjetnik u psihoterapiji» — savjetovanje
('dragana-zivkovic', 'couples-therapy'), -- «Radi sa pojedincima, parovima i porodicama»
('dragana-zivkovic', 'family-psychotherapy-session'); -- «savjetnik u sistemskoj porodičnoj psihoterapiji … Radi sa … porodicama»

-- Страховка: врач не привязан к клинике или slug не найден. Ожидается ПУСТО (в сухом прогоне клиники ещё нет — строки ожидаемы).
SELECT t.doctor_slug AS unlinked_doctor
FROM tmp_razvojni_centar_integra_podgorica_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_razvojni_centar_integra_podgorica_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 8 услуг, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

SELECT ms.slug, ms.name_en, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 7 привязок врач↔услуга.
SELECT d.slug, ms.slug AS service
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
JOIN medical_services ms ON ms.id = cmsd.medical_service_id
WHERE cmsd.clinic_id = @clinic_id
ORDER BY d.slug, ms.slug;

-- Ожидается 5: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(x.specialty_id) FROM medical_services_specialties x WHERE x.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('couples-therapy', 'child-psychotherapy', 'adolescent-psychotherapy', 'online-psychotherapy', 'group-psychotherapy');

DROP TEMPORARY TABLE IF EXISTS tmp_razvojni_centar_integra_podgorica;
DROP TEMPORARY TABLE IF EXISTS tmp_razvojni_centar_integra_podgorica_ds;

-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Mela Sana (Podgorica) — перечень услуг (без цен) + привязки врач ↔ услуга
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-mela-sana-podgorica-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-poliklinika-mela-sana-podgorica.sql.
-- Клиника — по google_place_id/slug, услуги и врачи — по slug, литеральных id нет.
--
-- Источник: https://www.melasana.me/all-services.html (вкладки «Naše usluge»), index.html,
-- all-departments.html, faqs.html; собрано 2026-10-08, Last-Modified страниц — 29–30.06.2022.
-- ЦЕН НА САЙТЕ НЕТ (cjenovnik/cijene — 404, ни одного «€»/«EUR»): все услуги NULL по дизайну.
-- Новых записей каталога НЕТ — всё сопоставлено с существующими.
--
-- Правила сопоставления (подробно — data/clinic-imports/poliklinika-mela-sana-podgorica.json):
--   * вкладка-направление с описанием приёма и врачом этой специальности в команде →
--     осмотр специалиста (Urologija → Urologist Examination и т. п.);
--   * конкретные процедуры, названные в тексте вкладок (7 видов УЗИ, мелкие операции,
--     кućne posjete, Myers' Cocktail, sklerozacija kapilara) → отдельные позиции;
--   * отделения без описания и без врача («X-Ray Diagnostic», «Kardiologija»,
--     «Laboratorija» на all-departments/faqs) — не услуги, в excluded записи импорта.
-- Привязки врач ↔ услуга (clinic_medical_service_doctors, цены NULL) — только осмотры
-- своей специальности и мелкая хирургия у dr Burzan («Hirurški tim Mela Sane predvodi
-- dr Dimitrije Burzan»). УЗИ ни к кому не привязаны: сайт не говорит, кто их делает.
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, лишнее от прошлых прогонов
-- удаляется. ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJz2FctqnrTRMRclWJwV6YtEM' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-mela-sana-podgorica' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-mela-sana-podgorica.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: ПРАВКИ СУЩЕСТВУЮЩИХ ЗАПИСЕЙ КАТАЛОГА (идемпотентно)
-- ═══════════════════════════════════════════════════════════════

-- «UZ abdomena i male karlice» (ultrasound-abdomen-and-pelvis) заведён без категории и
-- специальности — ставим как у остальных УЗИ: 4 ULTRASOUND, 10 RADIOLOGY.
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 4 FROM medical_services WHERE slug = 'ultrasound-abdomen-and-pelvis';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug = 'ultrasound-abdomen-and-pelvis';

-- Синонимы из формулировок сайта: «Sklerozacija kapilara» → Skleroterapija vena
-- (отдельной записи под склеротерапию капилляров в каталоге нет, лазерная — другая услуга);
-- «Majersov koktel» — написание сайта (в name_sr «Mayersov koktel infuzija»).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Sklerozacija kapilara', 'sr' FROM medical_services WHERE slug = 'sclerotherapy-veins'
UNION ALL SELECT id, 'Склерозација капилара', 'sr-cyrl' FROM medical_services WHERE slug = 'sclerotherapy-veins'
UNION ALL SELECT id, 'Spider Vein Sclerotherapy', 'en' FROM medical_services WHERE slug = 'sclerotherapy-veins'
UNION ALL SELECT id, 'Склеротерапия капилляров', 'ru' FROM medical_services WHERE slug = 'sclerotherapy-veins'
UNION ALL SELECT id, 'Склеротерапия сосудистых звёздочек', 'ru' FROM medical_services WHERE slug = 'sclerotherapy-veins'
UNION ALL SELECT id, 'Majersov koktel', 'sr' FROM medical_services WHERE slug = 'myers-cocktail-iv'
UNION ALL SELECT id, 'Мајерсов коктел', 'sr-cyrl' FROM medical_services WHERE slug = 'myers-cocktail-iv';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: УСЛУГИ КЛИНИКИ (34, все без цены)
-- ═══════════════════════════════════════════════════════════════

-- Координатор 2026-10-08: «перевязка на дому» — запись wound-dressing-home-visit (её заводит и
-- импорт Moj Doktor, подволна 2c; схема *-home-visit из 2a). Создание продублировано здесь
-- идемпотентно, чтобы порядок применения файлов не имел значения.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'wound-dressing-home-visit', 'Wound Dressing Home Visit', 'Previjanje rane u kućnoj posjeti', 'Превијање ране у кућној посјети',
	'Перевязка раны на дому', 'Wundverband beim Hausbesuch', 'Evde yara pansumanı', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'wound-dressing-home-visit' OR name_en = 'Wound Dressing Home Visit');
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 30 FROM medical_services WHERE slug = 'wound-dressing-home-visit'
UNION ALL SELECT id, 31 FROM medical_services WHERE slug = 'wound-dressing-home-visit';

DROP TEMPORARY TABLE IF EXISTS tmp_melasana_services;
CREATE TEMPORARY TABLE tmp_melasana_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_melasana_services (slug) VALUES
-- Pregledi opšte prakse
('general-practitioner-examination'),                        -- «Pregledi opšte prakse … Pregled podrazumijeva: … Snimanje i očitavanje EKGa …»
-- Hirurgija
('surgical-examination'),                                    -- «Osim opštog hirurškog pregleda pacijenta …»
('pigmented-nevus-surgical-removal'),                        -- «Mladeži … mogu se jednostavno i bezbolno ukloniti … malih hirurških zahvata»
('atheroma-removal'),                                        -- «… ateromi …» (isto)
('excision-of-small-benign-tumor-scars-fibromas-or-cysts'),  -- «… fibromi … ili ožiljci …» (isto)
('lipoma-removal'),                                          -- «… lipomi …» (isto)
-- Pedijatrija, mentalno zdravlje djece
('pediatric-examination'),                                   -- «Pregled pedijatra podrazumijeva mjerenje tjelesne težine …»
('child-psychiatrist-examination'),                          -- «Mentalno zdravlje djece» / «Dispanzer za mentalno zdravlje djece» + dr Krgović, spec. dječije psihijatrije
-- Ultrazvuk: «U ORDINACIJI MELA SANA MOŽETE OBAVITI SLEDEĆE ULTRAZVUČNE PREGLEDE»
('ultrasound-abdomen-and-pelvis'),                           -- «ABDOMENA I MALE KARLICE»
('urinary-tract-ultrasound'),                                -- «ULTRAZVUK UROTRAKTA»
('breast-ultrasound-with-axilla'),                           -- «ULTRAZVUK DOJKI I PAZUŠNIH JAMA»
('neck-ultrasound'),                                         -- «ULTRAZVUK VRATA I ŠTITNE ŽLIJEZDE» (vrat)
('thyroid-ultrasound'),                                      -- «ULTRAZVUK VRATA I ŠTITNE ŽLIJEZDE» (štitna žlijezda)
('soft-tissue-ultrasound'),                                  -- «ULTRAZVUK MEKIH TKIVA»
('peripheral-region-ultrasound'),                            -- «ULTRAZVUK PERIFERNIH REGIJA»
('blood-vessels-doppler'),                                   -- «KOLOR DOPLER KRVNIH SUDOVA»
-- Specijalistički pregledi
('urologist-examination'),                                   -- «Urologija … razlozi zbog kojih se pacijenti obraćaju urologu»
('first-psychiatrist-examination'),                          -- «Psihijatrija … Prvi pregled traje oko sat vremena …»
('follow-up-psychiatrist-examination'),                      -- «… dok su kontrolni pregledi kraći»
('first-neurologist-examination'),                           -- «Neurologija … Pregled kod neurologa je bezbolan» (общей записи «осмотр невролога» в каталоге нет)
('internist-examination'),                                   -- «Interna medicina … Ljekar čija je specijalnost interna medicina, naziva se internistom»
('oncologist-examination'),                                  -- «Onkologija … Onkolog objašnjava pacijentu dijagnozu …»
('ent-specialist-examination'),                              -- «ORL … Pregled otorinolaringologa … konsultanske pregled obavlja prim dr Ivan Djordjević»
-- Sanitetski transport
('medical-transport-per-km'),                                -- «Tranport pacijenata (sanitetski transport) … na području Podgorice i Crne Gore, tako i u inostranstvu»
-- Kućne posjete: «u periodu od 00-24h za odrasle … usluge pregleda doktora opšte medicine,
-- EKG dijagnostika, sve vrste previjanja, skidanja konaca, zamjena katetera, davanje terapije
-- (infuzije, intravenske i intramuskularne injekcije)»
('home-visit-examination'),                                  -- «pregleda doktora opšte medicine»
('ecg-home-visit'),                                          -- «EKG dijagnostika»
('wound-dressing-home-visit'),                               -- «sve vrste previjanja» (кућне посјете)
('suture-removal'),                                          -- «skidanja konaca» (отдельного «снятия швов на дому» нет)
('urinary-catheter-placement-home-visit'),                   -- «zamjena katetera»
('infusion-therapy-home-visit'),                             -- «davanje terapije (infuzije …)»
('intramuscular-injection-home-visit'),                      -- «… intramuskularne injekcije»
('home-therapy-administration'),                             -- «… intravenske … injekcije» (Aplikacija terapije u kućnim uslovima)
-- Ostalo
('myers-cocktail-iv'),                                       -- «MYERS' Cocktail … intravenozna infuzija (vitamina i minerala)»
('sclerotherapy-veins');                                     -- «*NOVO* Sklerozacija kapilara … ubacivanjem aktivne supstance direktno u krvni sud»

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service FROM tmp_melasana_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, NULL, NULL, NULL, NULL
FROM tmp_melasana_services t
JOIN medical_services ms ON ms.slug = t.slug
ON DUPLICATE KEY UPDATE price = NULL, price_min = NULL, price_max = NULL;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_melasana_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_melasana_doctor_services;
CREATE TEMPORARY TABLE tmp_melasana_doctor_services (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Врачи — по slug из clinic-файла; для найденных под другим slug — их slug в БД
-- (vladimir-vuceljic, uskokovic-filip, vukovic-marko).
INSERT INTO tmp_melasana_doctor_services (doctor_slug, service_slug) VALUES
('dimitrije-burzan', 'surgical-examination'),
('dimitrije-burzan', 'pigmented-nevus-surgical-removal'),
('dimitrije-burzan', 'atheroma-removal'),
('dimitrije-burzan', 'excision-of-small-benign-tumor-scars-fibromas-or-cysts'),
('dimitrije-burzan', 'lipoma-removal'),
('vladimir-vuceljic', 'surgical-examination'),
('uskokovic-filip', 'surgical-examination'),
('edita-basovic', 'pediatric-examination'),
('ivan-krgovic', 'child-psychiatrist-examination'),
('vukovic-marko', 'urologist-examination'),
('ivana-siljak', 'first-psychiatrist-examination'),
('ivana-siljak', 'follow-up-psychiatrist-examination'),
('sandra-vujovic', 'first-neurologist-examination'),
('nebojsa-brnovic', 'internist-examination'),
('vanja-karadjinovic', 'oncologist-examination'),
('ivan-djordjevic', 'ent-specialist-examination');

-- Страховка: врачи из списка, которых нет в БД или нет в составе клиники. Ожидается ПУСТО.
SELECT DISTINCT t.doctor_slug AS unmatched_doctor FROM tmp_melasana_doctor_services t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_melasana_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 34 услуги, с ценой 0.
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 16 привязок у 11 врачей (без привязок: Bašić — urgentna medicina, Rakočević — УЗИ не закреплены).
SELECT d.slug, COUNT(*) AS linked_services
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id
GROUP BY d.slug
ORDER BY d.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_melasana_services;
DROP TEMPORARY TABLE IF EXISTS tmp_melasana_doctor_services;

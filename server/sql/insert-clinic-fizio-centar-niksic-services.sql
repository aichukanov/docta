-- ═══════════════════════════════════════════════════════════════════════════
-- Fizio Centar Nikšić (Nikšić) — услуги
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-fizio-centar-niksic-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-fizio-centar-niksic.sql. Клиника резолвится по google_place_id → slug.
-- Запись импорта (источник каждой строки, спорные, исключённые): data/clinic-imports/fizio-centar-niksic.json.
--
-- Услуг: 28, с ценой: 1. Новых записей каталога: 4 (physiotherapist-examination, therapeutic-massage-with-electrotherapy-40-min, electroacupuncture, game-ready-cryo-compression-therapy) —
-- дублируются в data/clinic-imports/_wave2c-new-catalog-P.json для сверки координатором.
-- is_price_outdated не ставится (решение юзера 2026-10-08).
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены обновляются
-- ON DUPLICATE KEY UPDATE, лишние услуги и привязки врач↔услуга прошлых прогонов удаляются.
-- ⚠️ Услуги, добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJQ3xVS22pTRMRqiUQtvA-Pf0' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'fizio-centar-niksic' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-fizio-centar-niksic.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (идемпотентно по slug / name_en)
-- Категория 5 = PHYSIOTHERAPY; специальность 42 = PHYSICAL_MEDICINE (авто-привязка кат. 5).
-- ═══════════════════════════════════════════════════════════════

-- Осмотр физиотерапевта (не врача): Fizio Centar Nikšić — «Pregled obuhvata komunikaciju pacijenta i terapeuta, upoznavanje sa problemom, testiranja kroz određene vježbe, određivanje protokola, a trajanje pregleda je od 45 min do 1h»; Fizio PG — «Specijalistički pregled — Detaljna procjena i individualni plan tretmana» (в штате только физиотерапевты). В каталоге есть осмотры физиатра (врача), осмотра физиотерапевта нет. sort_order = 1, как у первичных осмотров.
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'physiotherapist-examination', 'Physiotherapist Examination', 'Pregled fizioterapeuta', 'Преглед физиотерапеута',
	'Осмотр физиотерапевта', 'Physiotherapeutische Untersuchung', 'Fizyoterapist muayenesi', 1
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'physiotherapist-examination' OR name_en = 'Physiotherapist Examination');

-- Fizio Centar Nikšić /usluge/: «Terapeutska masaža — Kombinacija relax masaže i elektroterapije u trajanju od 40 minuta po cijeni od 25e.» Единственная цена на сайте; комбинированная процедура с длительностью, в каталоге нет (ср. Anti-Cellulite Shockwave Therapy with Lymphatic Drainage).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'therapeutic-massage-with-electrotherapy-40-min', 'Therapeutic Massage with Electrotherapy 40 min', 'Terapeutska masaža sa elektroterapijom 40 min', 'Терапеутска масажа са електротерапијом 40 мин',
	'Лечебный массаж с электротерапией 40 мин', 'Therapeutische Massage mit Elektrotherapie 40 Min.', 'Elektroterapili terapötik masaj 40 dk', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'therapeutic-massage-with-electrotherapy-40-min' OR name_en = 'Therapeutic Massage with Electrotherapy 40 min');

-- Fizio Centar Nikšić «AKUPUNKTURU / ELEKTROAKUPUNKTURU»; AXON «Elektroakupunktura — Nadogradnja klasične akupunkture blagom električnom stimulacijom kroz igle». В каталоге только Acupuncture. Категория как у acupuncture (5).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'electroacupuncture', 'Electroacupuncture', 'Elektroakupunktura', 'Електроакупунктура',
	'Электроакупунктура', 'Elektroakupunktur', 'Elektroakupunktur', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'electroacupuncture' OR name_en = 'Electroacupuncture');

-- Fizio Centar Nikšić «GAME READY»; /oprema/: «AKTIVNA KRIOTERAPIJA … NAIZMJENIČNA KOMPRESIJA». Аппарат назван по имени; это крио + перемежающаяся компрессия, не то же, что Thermotherapy: Cryotherapy (одно охлаждение).
INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'game-ready-cryo-compression-therapy', 'Game Ready Cryo-Compression Therapy', 'Game Ready krioterapija sa kompresijom', 'Game Ready криотерапија са компресијом',
	'Криокомпрессионная терапия Game Ready', 'Game Ready Kryo-Kompressionstherapie', 'Game Ready kriyo-kompresyon tedavisi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'game-ready-cryo-compression-therapy' OR name_en = 'Game Ready Cryo-Compression Therapy');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 5 FROM medical_services WHERE slug IN (
	'physiotherapist-examination',
	'therapeutic-massage-with-electrotherapy-40-min',
	'electroacupuncture',
	'game-ready-cryo-compression-therapy'
);

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 42 FROM medical_services WHERE slug IN (
	'physiotherapist-examination',
	'therapeutic-massage-with-electrotherapy-40-min',
	'electroacupuncture',
	'game-ready-cryo-compression-therapy'
);

-- Синонимы: новые записи + бренды и формулировки сайтов к существующим (код языка sr-cyrl — через дефис).
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Fizioterapeutska procjena', 'sr' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Физиотерапеутска процјена', 'sr-cyrl' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Physiotherapy Assessment', 'en' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Консультация физиотерапевта', 'ru' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Physiotherapeutischer Befund', 'de' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Fizyoterapi değerlendirmesi', 'tr' FROM medical_services WHERE slug = 'physiotherapist-examination'
UNION ALL SELECT id, 'Electro-acupuncture', 'en' FROM medical_services WHERE slug = 'electroacupuncture'
UNION ALL SELECT id, 'Электропунктура', 'ru' FROM medical_services WHERE slug = 'electroacupuncture'
UNION ALL SELECT id, 'Krio-kompresija', 'sr' FROM medical_services WHERE slug = 'game-ready-cryo-compression-therapy'
UNION ALL SELECT id, 'Крио-компресија', 'sr-cyrl' FROM medical_services WHERE slug = 'game-ready-cryo-compression-therapy'
UNION ALL SELECT id, 'Криокомпрессия', 'ru' FROM medical_services WHERE slug = 'game-ready-cryo-compression-therapy'
UNION ALL SELECT id, 'Cryo-Compression Therapy', 'en' FROM medical_services WHERE slug = 'game-ready-cryo-compression-therapy'
UNION ALL SELECT id, 'Kompjuterizovana spinalna dekompresija', 'sr' FROM medical_services WHERE slug = 'spinal-decompression'
UNION ALL SELECT id, 'Компјутеризована спинална декомпресија', 'sr-cyrl' FROM medical_services WHERE slug = 'spinal-decompression'
UNION ALL SELECT id, 'Компьютерная декомпрессия позвоночника', 'ru' FROM medical_services WHERE slug = 'spinal-decompression'
UNION ALL SELECT id, 'Progresivna kineziterapija', 'sr' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'Прогресивна кинезитерапија', 'sr-cyrl' FROM medical_services WHERE slug = 'group-exercises-type-b'
UNION ALL SELECT id, 'IFS', 'en' FROM medical_services WHERE slug = 'interferential-currents'
UNION ALL SELECT id, 'IFS', 'sr' FROM medical_services WHERE slug = 'interferential-currents'
UNION ALL SELECT id, 'Ergon', 'en' FROM medical_services WHERE slug = 'iastm-therapy'
UNION ALL SELECT id, 'Ergon tehnika', 'sr' FROM medical_services WHERE slug = 'iastm-therapy';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ (EUR)
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_centar_niksic;
CREATE TEMPORARY TABLE tmp_fizio_centar_niksic (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_fizio_centar_niksic (slug, price, price_min, price_max) VALUES
('physiotherapist-examination', NULL, NULL, NULL), -- FAQ «Šta sve obuhvata pregled?» — «Pregled obuhvata komunikaciju pacijenta i terapeuta, upoznavanje sa problemom, testiranja kroz određene vježbe, određivanje protokola, a trajanje pregleda je od 45 min do 1h.»; /usluge/ «Individualni pristup započinje pregledom»
('therapeutic-massage-with-electrotherapy-40-min', 25, NULL, NULL), -- /usluge/ «Terapeutska masaža — Kombinacija relax masaže i elektroterapije u trajanju od 40 minuta po cijeni od 25e.»
('tecar-therapy', NULL, NULL, NULL), -- /usluge/ «TEKAR»; /oprema/ «BTL Tecar terapija … BTL-6000 TR-Therapy»
('spinal-decompression', NULL, NULL, NULL), -- /usluge/ «KOMPJUTERIZOVANU SPINALNU DEKOMPRESIJU»; /oprema/ «DTS - Kompjuterizovana spinalna dekompresija» (Triton)
('shock-wave-therapy', NULL, NULL, NULL), -- /usluge/ «SHOCKWAVE»; «Shockwave, Kiropraktika, SCHROTH, Kinezitejp»
('super-inductive-system-therapy', NULL, NULL, NULL), -- /usluge/ «VISOKOFREKVENTNI MAGNET»; /oprema/ «BTL Visokofrekventni magnet … elektromagnetskom polju visokog intenziteta» (картинка блока — BTL-Super-induktivni-sistem.png)
('kinesiotherapy', NULL, NULL, NULL), -- /usluge/ «KINEZITERAPIJU»; пакеты «Kineziterapijske tehnike (PNF, DNS)»
('acupuncture', NULL, NULL, NULL), -- /usluge/ «AKUPUNKTURU / ELEKTROAKUPUNKTURU»; пакеты «Akupunktura»
('electroacupuncture', NULL, NULL, NULL), -- /usluge/ «AKUPUNKTURU / ELEKTROAKUPUNKTURU»; protokol za artrozu ramena «elektroakupunktura»
('manual-therapy', NULL, NULL, NULL), -- /usluge/ «MANIPULATIVNE TEHNIKE»
('chiropractic-treatment', NULL, NULL, NULL), -- /usluge/ «Kiropraktika podrazumijeva ručno namještanje i manipulaciju kičme, pršljenova, velikih i malih zglobova i mekih tkiva.»
('ultrasound-therapy', NULL, NULL, NULL), -- /usluge/ «ULTRAZVUK»; пакеты «Terapijski ultrazvuk»
('electrotherapy', NULL, NULL, NULL), -- /usluge/ «ELEKTROTERAPIJU I LASEROTERAPIJU»; /oprema/ «Kombinovana terapija - BTL-4825S»
('laser-therapy', NULL, NULL, NULL), -- /usluge/ «ELEKTROTERAPIJU I LASEROTERAPIJU»
('interferential-currents', NULL, NULL, NULL), -- protokol za artrozu ramena «IFS»; ACL «Četvoropolarne interferentne struje za smanjenje bola»
('tens-therapy', NULL, NULL, NULL), -- ACL protokol «TENS (transkutana električna nervna stimulacija)»
('muscle-electrical-stimulation', NULL, NULL, NULL), -- ACL protokol «Elektrostimulacija mišića kvadricepsa sa Compex-om»
('electrophoresis', NULL, NULL, NULL), -- PDF пакетов «Jontoforeza + Ljekovi za stimulaciju smanjenja upalnih procesa»
('iastm-therapy', NULL, NULL, NULL), -- PDF PAKET STANDARD (cervikalni, lumbalna) «Ergon terapija za miofascijalnu relaksaciju»
('thermotherapy-cryotherapy', NULL, NULL, NULL), -- protokol za artrozu ramena «krioterapija»; PDF PAKET STANDARD (koljeno, rame) «Krioterapija»; ACL «Krioterapija za smanjenje otoka i upale»
('game-ready-cryo-compression-therapy', NULL, NULL, NULL), -- /usluge/ «GAME READY»; /oprema/ «Game Ready … AKTIVNA KRIOTERAPIJA … NAIZMJENIČNA KOMPRESIJA»
('exercises-on-equipment-pulley-ergocycle-cpm-suspension', NULL, NULL, NULL), -- /usluge/ «СР MOTION» (в источнике кириллические С и Р); /oprema/ «BTL CPMotion … za povećanje opsega pokreta zglobova nakon operacija»
('taping-application', NULL, NULL, NULL), -- /usluge/ «KINESIOTAPE»; «Kinezitejp se koristi za podršku mišića i zglobova…»
('therapeutic-massage-complete', NULL, NULL, NULL), -- /usluge/ «MANUELNE MASAŽE» (generic «terapijska masaža» без длительности и зоны — Complete Therapeutic Massage)
('schroth-method', NULL, NULL, NULL), -- /usluge/ «Schroth metoda je dobra za deformitete koji se javljaju kod djece uzrasta od 13 do 17 godina…»
('group-exercises-type-b', NULL, NULL, NULL), -- /usluge/ «Progresivna kineziterapija … Maksimalan broj vježbača u jednom terminu je osam i uvijek su prisutna dva trenera.»
('spinal-discopathy-and-stenosis-rehabilitation', NULL, NULL, NULL), -- «Protokol za cervikalni sindrom» и «Protokol za lumbalni sindrom» («bol u donjem dijelu ledja ili diskus hernia»), пакеты STANDARD / INTENSIVE A / INTENSIVE + STANDARD — без цен
('postoperative-locomotor-system-rehabilitation', NULL, NULL, NULL); -- «PAKET OPORAVKA ACL-A NAKON OPERACIJE … CIJENA – na upit, zavisi od stanja pacijenta (protokol obično traje 41 terapijski dan…)»

-- Ожидается ПУСТО: slug, не найденные в каталоге.
SELECT t.slug AS unmatched_service
FROM tmp_fizio_centar_niksic t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM medical_services ms
JOIN tmp_fizio_centar_niksic t ON t.slug = ms.slug
WHERE @clinic_id IS NOT NULL
ON DUPLICATE KEY UPDATE price = t.price, price_min = t.price_min, price_max = t.price_max;

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_fizio_centar_niksic t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ВРАЧ ↔ УСЛУГА (clinic_medical_service_doctors, цены NULL)
-- Только то, что сайт прямо связывает с человеком (FAQ, био, теги карточек) — см. запись импорта.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_centar_niksic_ds;
CREATE TEMPORARY TABLE tmp_fizio_centar_niksic_ds (
	doctor_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	service_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	PRIMARY KEY (doctor_slug, service_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_fizio_centar_niksic_ds (doctor_slug, service_slug) VALUES
('alessandra-quartulli', 'physiotherapist-examination'), -- FAQ: «Alessandra Quartulli Matijašević pruža pedijatrijske i neurološke preglede»
('alessandra-quartulli', 'iastm-therapy'), -- bio: «Ergon (IASTM) tehnici»
('petar-matijasevic', 'physiotherapist-examination'), -- FAQ: «Na čelu sa Petrom Matijaševićem i Krstom Kovačevićem, koji su specijalizovani za pregled prema … Protokolima»
('petar-matijasevic', 'schroth-method'), -- bio: «SCHROTH metodi (I i II nivo)»
('petar-matijasevic', 'postoperative-locomotor-system-rehabilitation'), -- bio: «rehabilitaciji ACL-a»
('krsto-kovacevic-fizioterapeut', 'physiotherapist-examination'), -- FAQ: см. выше
('predrag-calic', 'physiotherapist-examination'), -- FAQ: «posvećen je pregledima i tretmanima koji se tiču koljena, lumbalne kičme, skočnog zgloba i kuka»
('predrag-calic', 'postoperative-locomotor-system-rehabilitation'), -- bio: «rehabilitaciju ACL (prednjeg ukrštenog ligamenta)»
('vojin-kostic', 'physiotherapist-examination'), -- FAQ: «sa svojom specijalizacijom za pregled ramena, vrata, deformiteta stopala»
('vojin-kostic', 'iastm-therapy'), -- bio: «primjeni Ergon (IASTM) tehnike»
('zilha-kojcin', 'therapeutic-massage-complete'); -- bio: «terapeutske i sportske masaže»

-- Ожидается ПУСТО: врач не найден или не привязан к клинике.
SELECT t.doctor_slug AS unmatched_doctor
FROM tmp_fizio_centar_niksic_ds t
LEFT JOIN doctors d ON d.slug = t.doctor_slug
LEFT JOIN doctor_clinics dc ON dc.doctor_id = d.id AND dc.clinic_id = @clinic_id
WHERE dc.id IS NULL;

DELETE FROM clinic_medical_service_doctors WHERE clinic_id = @clinic_id;

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_fizio_centar_niksic_ds t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.slug = t.service_slug
JOIN clinic_medical_services cms ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 28 услуг, с ценой 1.
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

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_centar_niksic_ds;

-- Ожидается 4: новые записи каталога с категорией и специальностью.
SELECT ms.slug, ms.sort_order,
	(SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(s.specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specs
FROM medical_services ms
WHERE ms.slug IN ('physiotherapist-examination', 'therapeutic-massage-with-electrotherapy-40-min', 'electroacupuncture', 'game-ready-cryo-compression-therapy');

DROP TEMPORARY TABLE IF EXISTS tmp_fizio_centar_niksic;

-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Medicus Tim (Podgorica) — услуги + привязка услуг к врачам
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-medicus-tim-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-medicus-tim.sql (клиника и 11 врачей).
-- Клиника и врачи здесь резолвятся по google_place_id и slug, литеральных id нет.
--
-- Источник: Instagram @medicus_tim (скриншоты постов), 2026-09-03.
--
-- ВСЕ ЦЕНЫ NULL ПО ДИЗАЙНУ. Клиника не публикует прейскурант нигде: под постом
-- «Dopler donjih ekstremiteta» три человека спрашивают цену, ответа нет.
--
-- ═══ РЕШЕНИЯ ПО СОПОСТАВЛЕНИЮ С КАТАЛОГОМ (нужно ревью) ═══
--
--   1. Контраст. Источник называет области («CT abdomena», «CT grudnog koša»,
--      «CT endokranijuma»), а каталог делит их на native/with contrast. Заведены
--      ОБА варианта: клиника заявляет исследования, без контраста невозможные
--      (CT koronarografija, CT angiografija, CT urografija), значит контраст
--      применяется. Гранулярность каталога тоньше источника — это компромисс.
--
--   2. Две НОВЫЕ услуги (PART 0). Generic-записей под них в каталоге нет:
--        * MSCT Angiography — источник заявляет «CT angiografija» без региона
--          («detaljan prikaz krvnih sudova cijelog tijela»). В каталоге 12
--          региональных MSCT Angiography *, но ни одной общей; выбирать регионы
--          за клинику — додумывание.
--        * HRCT Lungs — «HRCT pluća». Ближайшее в каталоге, MSCT Lungs Covid
--          Post-Covid, это другое исследование.
--
--   3. «Body CT dijagnostika» (пост dr Mandarić) → MSCT Chest Abdomen Pelvis
--      Native/with Contrast. Body CT — устоявшееся название КТ туловища;
--      точного эквивалента «cijelog tijela» в каталоге нет.
--
--   4. «CT kičme i zglobova» → три отдела позвоночника названы поимённо
--      (vratne, grudne, slabinske), поэтому три отдельные записи, а не
--      MSCT Full Spine. Суставы → MSCT Joint Pair, единственная generic-запись.
--
--   5. Пост «Radiologija» (УЗИ мягких тканей, плеча, колена, ахиллова
--      сухожилия, мышц) врача не называет → услуги заведены клинике, но НЕ
--      привязаны ни к кому в clinic_medical_service_doctors.
--
-- ═══ ЧЕГО ЗДЕСЬ НЕТ ═══
--
--   * Анализы (clinic_lab_tests). Лаборатория заявлена, но перечень дан
--     группами: «Šećer», «Hormoni», «Vitamini», «Tumor markeri», «Sistematski
--     paketi». Конкретных анализов источник не называет.
--   * «Hipertenzija», «Koronarne bolesti», «Srčana slabost», «Hormonski
--     poremećaji i menopauza», «Prevencija i rana dijagnostika» — это показания
--     и темы, а не услуги каталога.
--   * «Drugo mišljenje» (второе мнение) у обоих онкологов — generic-услуги
--     «второе мнение» в каталоге нет, есть только Pediatric Second Opinion
--     Consultation и CT Radiology Second Opinion X-Ray, оба не подходят.
--   * «Konzilijarni pregled» (dr Kovčin) — эквивалента в каталоге нет.
--   * Хирургические удаления у dr Nikolića: блок в его посте озаглавлен
--     «SPECIJALISTIČKI PREGLEDI I KONSULTACIJE», то есть все семь пунктов —
--     осмотры, а не операции. Заведён только приём онколога.
--
-- Самоисправляющийся и идемпотентный: канонический список живёт в TEMPORARY
-- TABLE, по ней идут и INSERT, и DELETE лишнего от прошлых прогонов. Один и тот
-- же файл приводит клинику ровно к этому состоянию.
-- ⚠️ Цена этого: услуги и привязки врачей, добавленные клинике ВРУЧНУЮ (админка,
-- кабинет клиники), следующий прогон файла снесёт. Вносить их сюда.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @google_place_id = 'ChIJpa36GwCTTRMR4xp8dn6lX_Q';
SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = @google_place_id LIMIT 1);

-- Страховка: без клиники дальше идти нельзя, иначе DELETE отработает по NULL.
SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-medicus-tim.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (обоснование — п. 2 в шапке)
-- Категория 2 = MSCT, специальность 10 = RADIOLOGY.
-- Латинские аббревиатуры (MSCT, HRCT, CT) в кириллице НЕ транслитерируются.
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'msct-angiography', 'MSCT Angiography', 'MSCT angiografija', 'MSCT ангиографија',
	'МСКТ-ангиография', 'MSCT-Angiographie', 'MSCT Anjiyografi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE name_en = 'MSCT Angiography');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'hrct-lungs', 'HRCT Lungs', 'HRCT pluća', 'HRCT плућа',
	'КТВР лёгких', 'HRCT der Lunge', 'Akciğer HRCT', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE name_en = 'HRCT Lungs');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 2 FROM medical_services WHERE name_en IN ('MSCT Angiography', 'HRCT Lungs');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE name_en IN ('MSCT Angiography', 'HRCT Lungs');

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_medicus_services;
CREATE TEMPORARY TABLE tmp_medicus_services (
	name_en VARCHAR(255) NOT NULL PRIMARY KEY
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_medicus_services (name_en) VALUES
-- ── КТ: пост «CT dijagnostika (Philips CT 128)» + пост «CT tipovi» ──────────
('MSCT Coronary Angiography'),              -- CT koronarografija
('MSCT Angiography'),                       -- CT angiografija (новая, PART 0)
('MSCT Head (Endocranium) without Contrast'), -- CT endokranijuma / CT glave i mozga
('MSCT Head (Endocranium) with Contrast'),
('MSCT Thorax (Chest) without Contrast'),   -- CT grudnog koša
('MSCT Thorax (Chest) with Contrast'),
('MSCT Abdomen Native'),                    -- CT abdomena (uključujući CT želuca)
('MSCT Abdomen with Contrast'),
('MSCT Abdomen and Pelvis Native'),         -- CT abdomena i karlice
('MSCT Abdomen and Pelvis with Contrast'),
('MSCT Cervical Spine'),                    -- CT kičme: vratne
('MSCT Thoracic Spine'),                    -- CT kičme: grudne
('MSCT Lumbosacral Spine'),                 -- CT kičme: slabinske
('MSCT Joint Pair'),                        -- CT zglobova
('MSCT IVU (Intravenous Urography)'),       -- CT urografija
('MSCT Colonography'),                      -- CT kolonografija
('HRCT Lungs'),                             -- HRCT pluća (новая, PART 0)
('MSCT Chest Abdomen Pelvis Native'),       -- Body CT dijagnostika
('MSCT Chest Abdomen Pelvis with Contrast'),
('CT Contrast Agent'),                      -- контраст для перечисленного выше
-- ── УЗИ и доплер ───────────────────────────────────────────────────────────
('Echocardiography'),                       -- (ekspertski) ultrazvuk srca
('Abdomen Ultrasound'),                     -- ultrazvuk abdomena
('Breast Ultrasound'),                      -- ultrazvuk dojke
('Thyroid Ultrasound'),                     -- ultrazvuk štitaste žlijezde
('Peripheral Region Ultrasound'),           -- ultrazvuk perifernih regija
('Soft Tissue Ultrasound'),                 -- ultrazvučni pregled mekih tkiva
('Soft Tissue Ultrasound Muscle'),          -- ultrazvučni pregled mišića
('Musculoskeletal Ultrasound'),             -- ultrazvučni pregled ahilove tetive
('Orthopedic Ultrasound Single Joint'),     -- ultrazvučni pregled ramena / koljena
('Doppler Neck Blood Vessels'),             -- (color) dopler krvnih sudova vrata
('Doppler Upper Extremity Blood Vessels'),  -- dopler sudova gornjih ekstremiteta
('Doppler Lower Extremity Blood Vessels'),  -- dopler sudova donjih ekstremiteta
('Blood Vessels Doppler'),                  -- dopler perifernih krvnih sudova
-- ── Кардиология ────────────────────────────────────────────────────────────
('Cardiologist Examination'),               -- kardiološki pregled
('ECG'),                                    -- procjena poremećaja ritma i provođenja
('Holter ECG Monitoring'),                  -- Holter EKG
('Holter Blood Pressure Monitoring'),       -- Holter pritiska
-- ── Терапия, нефрология, эндокринология ────────────────────────────────────
('Internist Examination'),                  -- internistički pregled
('First Nephrologist Examination'),         -- nefrološki pregled (bare-записи нет)
('Follow-up Nephrologist Examination'),
('Endocrinologist Examination'),            -- endokrinološki pregled
-- ── Гинекология ────────────────────────────────────────────────────────────
('Gynecological Specialist Examination'),   -- ginekološki pregledi i konsultacije
('PAP Test with Smear Collection'),         -- PAPA test
('Colposcopy'),                             -- kolposkopija
('Pregnancy Preventive Examination by Calendar'), -- praćenje trudnoće
-- ── Радиология и онкология: приёмы ─────────────────────────────────────────
('Radiologist Examination'),                -- konsultacije (dr Radinović)
('Oncologist Examination');                 -- dr Nikolić, dr Kovčin

-- Страховка: имена, не сматчившиеся с каталогом (опечатка или запись удалена).
-- Ожидается ПУСТО.
SELECT t.name_en AS unmatched_service
FROM tmp_medicus_services t
LEFT JOIN medical_services ms ON ms.name_en = t.name_en
WHERE ms.id IS NULL;

-- Страховка: имена, под которые в каталоге больше одной записи (иначе клинике
-- прилетят полудубли). Ожидается ПУСТО.
SELECT ms.name_en, COUNT(*) AS cnt
FROM medical_services ms
JOIN tmp_medicus_services t ON t.name_en = ms.name_en
GROUP BY ms.name_en HAVING cnt > 1;

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, NULL, NULL, NULL, NULL
FROM medical_services ms
JOIN tmp_medicus_services t ON t.name_en = ms.name_en;

-- Снятие услуг, оставшихся от прошлых прогонов файла (см. оговорку в шапке).
DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_medicus_services t ON t.name_en = ms.name_en
WHERE cms.clinic_id = @clinic_id AND t.name_en IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- PART 2: ПРИВЯЗКА УСЛУГ К ВРАЧАМ
-- Таблица clinic_medical_service_doctors (doctor_id, clinic_id,
-- medical_service_id, price, price_max) — колонки сверены по
-- server/api/doctors/add.ts и admin-details.ts.
-- ⚠️ docs/import/CLINIC_DOCTORS_IMPORT.md описывает эту таблицу с колонкой
-- clinic_medical_service_id — документация устарела, в схеме её нет.
--
-- Цены NULL: строка нужна ради связи «врач ↔ услуга» на странице услуги.
-- Заполняется только то, что источник приписывает конкретному врачу.
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_medicus_doctor_services;
CREATE TEMPORARY TABLE tmp_medicus_doctor_services (
	doctor_slug VARCHAR(255) NOT NULL,
	name_en VARCHAR(255) NOT NULL,
	PRIMARY KEY (doctor_slug, name_en)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_medicus_doctor_services (doctor_slug, name_en) VALUES
-- Dr Aida Kovačević — «Savremena kardiološka dijagnostika i liječenje»
('aida-kovacevic', 'Cardiologist Examination'),
-- Dr Miroslav Rabrenović — Ultrazvuk srca, Holter EKG, Holter pritiska
('miroslav-rabrenovic', 'Cardiologist Examination'),
('miroslav-rabrenovic', 'Echocardiography'),
('miroslav-rabrenovic', 'Holter ECG Monitoring'),
('miroslav-rabrenovic', 'Holter Blood Pressure Monitoring'),
-- Dr Nebojša Ninković — kardiološki pregled i ekspertski ultrazvuk srca,
-- dopler arterija i vena ruku i nogu, dopler krvnih sudova vrata,
-- procjena poremećaja ritma i provođenja
('nebojsa-ninkovic', 'Cardiologist Examination'),
('nebojsa-ninkovic', 'Echocardiography'),
('nebojsa-ninkovic', 'Doppler Upper Extremity Blood Vessels'),
('nebojsa-ninkovic', 'Doppler Lower Extremity Blood Vessels'),
('nebojsa-ninkovic', 'Doppler Neck Blood Vessels'),
('nebojsa-ninkovic', 'ECG'),
-- Dr Elvir Mučić — nefrologija + komplikovana internistička stanja
('elvir-mucic', 'First Nephrologist Examination'),
('elvir-mucic', 'Follow-up Nephrologist Examination'),
('elvir-mucic', 'Internist Examination'),
-- Dr Valentina Kalinić — Internistički pregled, Endokrinološki pregled
('valentina-kalinic', 'Internist Examination'),
('valentina-kalinic', 'Endocrinologist Examination'),
-- Dr Gordana Globarević Vukčević — ginekološki pregledi i konsultacije,
-- PAPA test i kolposkopija, praćenje trudnoće
('gordana-globarevic-vukcevic', 'Gynecological Specialist Examination'),
('gordana-globarevic-vukcevic', 'PAP Test with Smear Collection'),
('gordana-globarevic-vukcevic', 'Colposcopy'),
('gordana-globarevic-vukcevic', 'Pregnancy Preventive Examination by Calendar'),
-- Spec. dr Darko Radinović — konsultacije, ultrazvuk perifernih regija,
-- abdomena, štitaste žlijezde, dopler vrata / gornjih / donjih ekstremiteta,
-- dopler perifernih krvnih sudova
('darko-radinovic', 'Radiologist Examination'),
('darko-radinovic', 'Peripheral Region Ultrasound'),
('darko-radinovic', 'Abdomen Ultrasound'),
('darko-radinovic', 'Thyroid Ultrasound'),
('darko-radinovic', 'Doppler Neck Blood Vessels'),
('darko-radinovic', 'Doppler Upper Extremity Blood Vessels'),
('darko-radinovic', 'Doppler Lower Extremity Blood Vessels'),
('darko-radinovic', 'Blood Vessels Doppler'),
-- Dr Sanja Vrbica — ultrazvuk abdomena, dojki, štitaste žlijezde,
-- dopler krvnih sudova
('sanja-vrbica', 'Abdomen Ultrasound'),
('sanja-vrbica', 'Breast Ultrasound'),
('sanja-vrbica', 'Thyroid Ultrasound'),
('sanja-vrbica', 'Blood Vessels Doppler'),
-- Dr Marina Mandarić — ultrazvuk dojke, abdomena, štitaste žlijezde,
-- Body CT dijagnostika
('marina-mandaric', 'Breast Ultrasound'),
('marina-mandaric', 'Abdomen Ultrasound'),
('marina-mandaric', 'Thyroid Ultrasound'),
('marina-mandaric', 'MSCT Chest Abdomen Pelvis Native'),
('marina-mandaric', 'MSCT Chest Abdomen Pelvis with Contrast'),
-- Prof. dr Dejan Nikolić — specijalistički pregledi i konsultacije
('dejan-nikolic', 'Oncologist Examination'),
-- Prof. dr Vladimir Kovčin — onkološke konsultacije, konzilijarni pregled
('vladimir-kovcin', 'Oncologist Examination'),
('vladimir-kovcin', 'Internist Examination');

-- Полная пересборка привязок ТОЛЬКО для врачей этого импорта и только в этой
-- клинике: DELETE перед INSERT делает файл идемпотентным независимо от того,
-- есть ли на таблице UNIQUE (в схеме он не гарантирован).
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id
	AND d.slug IN (
		'aida-kovacevic', 'miroslav-rabrenovic', 'nebojsa-ninkovic', 'elvir-mucic',
		'valentina-kalinic', 'gordana-globarevic-vukcevic', 'darko-radinovic',
		'sanja-vrbica', 'marina-mandaric', 'dejan-nikolic', 'vladimir-kovcin'
	);

INSERT INTO clinic_medical_service_doctors (doctor_id, clinic_id, medical_service_id, price, price_max, created_at)
SELECT d.id, @clinic_id, ms.id, NULL, NULL, NOW()
FROM tmp_medicus_doctor_services t
JOIN doctors d ON d.slug = t.doctor_slug
JOIN medical_services ms ON ms.name_en = t.name_en
JOIN clinic_medical_services cms
	ON cms.clinic_id = @clinic_id AND cms.medical_service_id = ms.id;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 47.
SELECT COUNT(*) AS services_total FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 47 строк, price/price_min/price_max везде NULL.
SELECT ms.name_en, ms.slug, cms.price, cms.price_min, cms.price_max
FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
WHERE cms.clinic_id = @clinic_id
ORDER BY ms.name_en;

-- Ожидается 11 врачей, сумма привязок 40.
SELECT d.slug, d.name_sr, COUNT(*) AS linked_services
FROM clinic_medical_service_doctors cmsd
JOIN doctors d ON d.id = cmsd.doctor_id
WHERE cmsd.clinic_id = @clinic_id
GROUP BY d.slug, d.name_sr
ORDER BY d.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_medicus_services;
DROP TEMPORARY TABLE IF EXISTS tmp_medicus_doctor_services;

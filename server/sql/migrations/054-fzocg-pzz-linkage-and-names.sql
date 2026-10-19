SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 054: привязки тарифов ФЗОЦГ PZZ к каталогу услуг и названия записей с ошибками распознавания.
--
-- Источник истины: тарифы PZZ (medical_service_tariffs.name_sr_latin), PDF «PZZ od 01.05.2026»
-- (data/pricelists/fzocg/…, построчный OCR data/fzocg/primarna-zdravstvena-zastita/paddleocr), текстовый
-- PDF ДЗ Ульцинь (data/clinic-pricelists/sources/dom-zdravlja-ulcinj/2026-10-08.cijenovnik-pzz-treca-lica.pdf)
-- и сканы прайсов ДЗ Херцег-Нови (data/pricelists/herceg novi dz/CJENOVNIK.pdf) и ДЗ Мойковац
-- (data/pricelists/mojkovac dz/02.10.2025.pdf): в них коды PZZ и названия напечатаны дословно.
-- Импорты ДЗ Херцег-Нови и Мойковац (2026-05) читали сканы «на глаз»: коды у строк без префикса HN_ верны,
-- а названия заведённых ими записей местами выдуманы — отсюда «трудница по календарю» на A01010,
-- «Fiksacija» на X01020 и сдвиг H02010–H02013. Мойковац ставил строки на записи ХН по коду.
--
-- Что делает (всё по slug / (tariff_source, code) / slug клиники, литеральных id нет):
--   1. 4 новые записи: A01010, H02010 (REVISK), H04011, I02005.
--   2. Переименования 27 записей (slug не меняется): ошибки распознавания H01005, H02018, H02012 (Viti — «preko 14»),
--      H09001–H09006 («asertivnog tima»), X01020 («Frikcije»), A02008, C01006, G01002, I01007, I03004, I03011, I03020,
--      H04004/H04006–H04009, X01024, X01017 (gyn), M01021; кириллица «W-Б» → «W-B».
--   3. Строки клиник ДЗ Херцег-Нови / Мойковац с кодами A01010, H02010–H02013, H04001, H04010, H04011, H02025, I02005
--      переносятся на правильные записи; C01002 (кариотип) — в анализ karyotype-from-amniotic-fluid.
--   4. PZZ: 18 исправленных привязок + 46 новых привязок ранее непривязанных строк (L02–L04, M01, X01–X03:
--      название совпадает, та же запись у импорта ДЗ Ульцинь по тексту PDF).
--   5. Имена тарифов PZZ H02012/H02013 (в FINAL было «W-B skala» и «W-B skala (alt)», в PDF — «Viti test» и «W-B skala»).
--
-- После переносов без клиник и без тарифов остаются записи-ошибки импорта ХН (не удаляются — решение отдельно,
-- удаление = 301 через medical_service_redirects): gynecological-preventive-visit, expert-organized-assessment,
-- social-worker-counseling-and-intervention, individual-preventive-therapy, wechsler-bellevue-test-variant-for-special-needs-over-14.
--
-- Идемпотентно: новые записи — ON DUPLICATE KEY / INSERT IGNORE, переименования — присваивание, переносы строк —
-- по (клиника, код, исходная запись), после первого прогона исходная запись уже не совпадает.
-- Применять ДО server/sql/insert-clinic-dom-zdravlja-ulcinj-services.sql (тот ссылается на новые slug).

-- ═══ 0. Ссылки ═══

SET @hn = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-herceg-novi');
SET @mo = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-bosko-dedeic-mojkovac');
SET @lt_karyotype = (SELECT id FROM lab_tests WHERE slug = 'karyotype-from-amniotic-fluid');
SELECT @hn AS hn_clinic_id, @mo AS mo_clinic_id, @lt_karyotype AS karyotype_lab_test_id;

DROP TEMPORARY TABLE IF EXISTS tmp_pzz_links;
CREATE TEMPORARY TABLE tmp_pzz_links (
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	lab_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	kind VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_pzz_links (code, slug, lab_slug, kind) VALUES
('A01010', 'preventive-examination-of-children-under-15-during-epidemic', NULL, 'fix'),
('C01002', NULL, 'karyotype-from-amniotic-fluid', 'fix'),
('H01005', 'additional-individual-therapy', NULL, 'fix'),
('H01015', 'brief-adult-intellectual-status-test', NULL, 'fix'),
('H01019', 'adult-individual-function-clinical-testing', NULL, 'fix'),
('H02010', 'revisk-intelligence-test-for-special-needs-children-under-14', NULL, 'fix'),
('H02011', 'progressive-matrices-test-for-special-needs-children-under-14', NULL, 'fix'),
('H02012', 'viti-test-for-special-needs-children-under-14', NULL, 'fix'),
('H02013', 'wechsler-bellevue-test-for-special-needs-children-over-14', NULL, 'fix'),
('H04010', 'legal-responsibility-assessment', NULL, 'fix'),
('H04011', 'cooperation-with-social-protection-and-healthcare-services', NULL, 'fix'),
('I02005', 'school-or-kindergarten-pedagogue-consultation-pediatrics', NULL, 'fix'),
('J07005', 'joint-and-soft-tissue-ultrasound', NULL, 'fix'),
('J07006', 'ultrasound-lymph-nodes', NULL, 'fix'),
('X01004', 'local-anesthesia-administration', NULL, 'fix'),
('X01020', 'fixation', NULL, 'fix'),
('X01024', 'cervical-drug-application', NULL, 'fix'),
('X02015', 'evacuation-pleural-puncture', NULL, 'fix'),
('L02001', 'chronic-patient-patronage-visit', NULL, 'new'),
('L02002', 'active-tb-patient-patronage-visit', NULL, 'new'),
('L02003', 'immobile-patient-patronage-visit', NULL, 'new'),
('L02004', 'family-health-social-problem-patronage-visit', NULL, 'new'),
('L02005', 'family-with-elderly-or-disabled-member-patronage-visit', NULL, 'new'),
('L03001', 'patronage-nurse-treatment-visit-up-to-5-km', NULL, 'new'),
('L03002', 'patronage-nurse-treatment-visit-5-to-15-km', NULL, 'new'),
('L03003', 'patronage-nurse-treatment-visit-over-15-km', NULL, 'new'),
('L03004', 'patronage-nurse-infusion-visit-up-to-5-km', NULL, 'new'),
('L03005', 'patronage-nurse-infusion-visit-5-to-15-km', NULL, 'new'),
('L03006', 'patronage-nurse-infusion-visit-over-15-km', NULL, 'new'),
('L04001', 'preventive-action-participation', NULL, 'new'),
('L04002', 'health-education-group-work', NULL, 'new'),
('M01003', 'apparatus-assisted-massage', NULL, 'new'),
('M01005', 'manual-muscle-test-per-extremity', NULL, 'new'),
('M01006', 'infrared-ultraviolet-and-bioptron-lamp-irradiation', NULL, 'new'),
('M01009', 'electrophoresis', NULL, 'new'),
('M01010', 'diadynamic-currents', NULL, 'new'),
('M01011', 'transcutaneous-electrical-nerve-stimulation-tens', NULL, 'new'),
('M01012', 'ktd-diathermy', NULL, 'new'),
('M01013', 'microwave-diathermy', NULL, 'new'),
('M01016', 'activities-of-daily-living-training', NULL, 'new'),
('M01017', 'gait-exercises', NULL, 'new'),
('M01021', 'group-exercises-type-b', NULL, 'new'),
('M01022', 'high-risk-infant-stimulation-exercises', NULL, 'new'),
('M01023', 'pediatric-play-therapy', NULL, 'new'),
('M01026', 'segmental-isometric-exercises', NULL, 'new'),
('M01027', 'kinesiotherapy-for-spine-deformities', NULL, 'new'),
('M01028', 'cns-sensorimotor-development-stimulation', NULL, 'new'),
('M01032', 'physiotherapist-home-visit-up-to-5-km', NULL, 'new'),
('M01033', 'physiotherapist-home-visit-5-to-15-km', NULL, 'new'),
('M01034', 'physiotherapist-home-visit-over-15-km', NULL, 'new'),
('X01003', 'foreign-body-removal-from-skin-and-subcutaneous-tissue', NULL, 'new'),
('X02004', 'eye-foreign-body-removal-cornea', NULL, 'new'),
('X02006', 'urinary-catheter-placement', NULL, 'new'),
('X02007', 'enema', NULL, 'new'),
('X02009', 'intravenous-cannula-placement', NULL, 'new'),
('X02010', 'ecg', NULL, 'new'),
('X02018', 'vulvar-and-vaginal-condyloma-abrasion', NULL, 'new'),
('X03003', 'endotracheal-intubation', NULL, 'new'),
('X03005', 'vulva-biopsy-with-lab-analysis', NULL, 'new'),
('X03006', 'cervical-biopsy-with-lab-analysis', NULL, 'new'),
('X03007', 'endometrial-biopsy-with-lab-analysis', NULL, 'new'),
('X03008', 'cervical-or-uterine-polypectomy', NULL, 'new'),
('X03010', 'gynecological-ultrasound', NULL, 'new'),
('X03013', 'pregnancy-cardiotocography-ctg', NULL, 'new');

DROP TEMPORARY TABLE IF EXISTS tmp_moves;
CREATE TEMPORARY TABLE tmp_moves (
	base_code VARCHAR(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	from_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	to_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_moves (base_code, from_slug, to_slug) VALUES
('A01010', 'pregnancy-preventive-examination-by-calendar', 'preventive-examination-of-children-under-15-during-epidemic'),
('H02010', 'progressive-matrices-test-for-special-needs-children-under-14', 'revisk-intelligence-test-for-special-needs-children-under-14'),
('H02011', 'viti-test-for-special-needs-children-under-14', 'progressive-matrices-test-for-special-needs-children-under-14'),
('H02012', 'wechsler-bellevue-test-for-special-needs-children-over-14', 'viti-test-for-special-needs-children-under-14'),
('H02013', 'wechsler-bellevue-test-variant-for-special-needs-over-14', 'wechsler-bellevue-test-for-special-needs-children-over-14'),
('H04011', 'legal-responsibility-assessment', 'cooperation-with-social-protection-and-healthcare-services'),
('H04010', 'expert-organized-assessment', 'legal-responsibility-assessment'),
('H04001', 'social-worker-counseling-and-intervention', 'social-worker-expert-assessment'),
('H02025', 'individual-preventive-therapy', 'individual-supportive-therapy'),
('I02005', 'pediatric-counseling', 'school-or-kindergarten-pedagogue-consultation-pediatrics'),
('C01002', 'gynecological-preventive-visit', '(анализ) karyotype-from-amniotic-fluid');

-- ═══ ДО: привязки PZZ, которые меняются (current_slug — сейчас, target — после) ═══
SELECT l.kind, l.code, ms.slug AS current_slug, t.lab_test_id AS current_lab_test_id,
	COALESCE(l.slug, CONCAT('lab:', l.lab_slug)) AS target
FROM tmp_pzz_links l
LEFT JOIN medical_service_tariffs t ON t.tariff_source = 'fzocg-pzz' AND t.code = l.code
LEFT JOIN medical_services ms ON ms.id = t.medical_service_id
ORDER BY l.kind, l.code;

-- ДО: строки клиник ДЗ, которые переносятся (ожидается 18: ХН 10 + Мойковац 8, из них C01002 — 2)
SELECT c.slug AS clinic, cms.code, ms.slug AS current_slug, m.to_slug, cms.price
FROM clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
JOIN medical_services ms ON ms.id = cms.medical_service_id
JOIN tmp_moves m ON m.from_slug = ms.slug AND m.base_code = REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}')
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad')
ORDER BY m.base_code, c.slug;

SELECT (SELECT COUNT(*) FROM medical_services) AS medical_services_total,
	x.pzz_linked_services, x.pzz_linked_lab_tests,
	(SELECT COUNT(*) FROM clinic_medical_services) AS clinic_medical_services_total,
	(SELECT COUNT(*) FROM clinic_lab_tests) AS clinic_lab_tests_total
FROM (SELECT SUM(medical_service_id IS NOT NULL) AS pzz_linked_services, SUM(lab_test_id IS NOT NULL) AS pzz_linked_lab_tests
	FROM medical_service_tariffs WHERE tariff_source = 'fzocg-pzz') x;

-- Страховка: новые name_en не заняты ДРУГИМИ записями. Ожидается ПУСТО.
SELECT ms.slug AS owner, ms.name_en FROM medical_services ms WHERE (ms.name_en = 'Depth Individual Therapy (Counseling Therapy)' AND ms.slug <> 'additional-individual-therapy')
   OR (ms.name_en = 'Special Needs Child Personality Tests: Sentence Completion Test' AND ms.slug <> 'special-needs-child-personality-tests-underdeveloped')
   OR (ms.name_en = 'Viti Test for Special Needs Children Over 14' AND ms.slug <> 'viti-test-for-special-needs-children-under-14')
   OR (ms.name_en = 'First Assertive Team Home Visit Up to 5 km' AND ms.slug <> 'first-discharge-team-home-visit-up-to-5-km')
   OR (ms.name_en = 'First Assertive Team Home Visit 5 to 15 km' AND ms.slug <> 'first-discharge-team-home-visit-5-to-15-km')
   OR (ms.name_en = 'First Assertive Team Home Visit Over 15 km' AND ms.slug <> 'first-discharge-team-home-visit-over-15-km')
   OR (ms.name_en = 'Follow-up Assertive Team Home Visit Up to 5 km' AND ms.slug <> 'follow-up-discharge-team-home-visit-up-to-5-km')
   OR (ms.name_en = 'Follow-up Assertive Team Home Visit 5 to 15 km' AND ms.slug <> 'follow-up-discharge-team-home-visit-5-to-15-km')
   OR (ms.name_en = 'Follow-up Assertive Team Home Visit Over 15 km' AND ms.slug <> 'follow-up-discharge-team-home-visit-over-15-km')
   OR (ms.name_en = 'Frictions (Rubbing Massage)' AND ms.slug <> 'fixation')
   OR (ms.name_en = 'Home Visit Follow-up Curative Examination Up to 5 km' AND ms.slug <> 'home-visit-brief-doctor-visit-up-to-5-km')
   OR (ms.name_en = 'Examination of Persons with Registered TB' AND ms.slug <> 'adult-examination-for-registered-tb')
   OR (ms.name_en = 'Individual Health Education Work (Parent, Educator, Teacher)' AND ms.slug <> 'family-health-education-work')
   OR (ms.name_en = 'Speech Therapy Assessment of Specific Learning Disorders' AND ms.slug <> 'specific-reading-disorder-assessment')
   OR (ms.name_en = 'Individual Defectology or Speech Therapy Treatment for a Child with Increased Impulsivity' AND ms.slug <> 'individual-defectology-speech-therapy-treatment-for-spp')
   OR (ms.name_en = 'School or Kindergarten Pedagogue Consultation (Defectologist)' AND ms.slug <> 'pedagogical-assessment')
   OR (ms.name_en = 'Sociotherapy for Treated Patients' AND ms.slug <> 'individual-sociotherapy')
   OR (ms.name_en = 'Social Treatment: Family Member' AND ms.slug <> 'family-group-sociotherapy')
   OR (ms.name_en = 'Social Treatment: Family, Field Visit' AND ms.slug <> 'family-sociotherapy')
   OR (ms.name_en = 'Sociotherapy: Individual Session' AND ms.slug <> 'individual-stress-sociotherapy')
   OR (ms.name_en = 'Social Treatment: Workplace' AND ms.slug <> 'organized-sociotherapy')
   OR (ms.name_en = 'Local Drug Application (Vaginal and Cervical)' AND ms.slug <> 'cervical-drug-application')
   OR (ms.name_en = 'Group Exercises (per Person)' AND ms.slug <> 'group-exercises-type-b')
   OR (ms.name_en = 'Preventive Examination of Children Under 15 During an Epidemic' AND ms.slug <> 'preventive-examination-of-children-under-15-during-epidemic')
   OR (ms.name_en = 'REVISK Intelligence Test for Special Needs Children Under 14' AND ms.slug <> 'revisk-intelligence-test-for-special-needs-children-under-14')
   OR (ms.name_en = 'Cooperation with Social Protection Services and Other Healthcare Institutions' AND ms.slug <> 'cooperation-with-social-protection-and-healthcare-services')
   OR (ms.name_en = 'School or Kindergarten Pedagogue Consultation (Pediatrician)' AND ms.slug <> 'school-or-kindergarten-pedagogue-consultation-pediatrics');

-- ═══ 1. Новые записи каталога ═══

-- A01010 — как preventive-examination-at-age-4 (категория 25, педиатрия)
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Preventive Examination of Children Under 15 During an Epidemic', 'preventive-examination-of-children-under-15-during-epidemic', 'Preventivni pregled djece do 15 godina u slučaju epidemije zarazne bolesti', 'Превентивни преглед дјеце до 15 година у случају епидемије заразне болести', 'Профилактический осмотр детей до 15 лет при эпидемии инфекционного заболевания', 'Vorsorgeuntersuchung von Kindern unter 15 Jahren bei einer Epidemie', 'Salgın durumunda 15 yaş altı çocukların koruyucu muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 25 FROM medical_services WHERE slug = 'preventive-examination-of-children-under-15-during-epidemic';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 4 FROM medical_services WHERE slug = 'preventive-examination-of-children-under-15-during-epidemic';

-- H02010 — как соседи H02008–H02013 (категория 25, специальность 22)
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('REVISK Intelligence Test for Special Needs Children Under 14', 'revisk-intelligence-test-for-special-needs-children-under-14', 'Procjena intelektualnih sposobnosti djeteta SPP do 14 godina REVISK', 'Процјена интелектуалних способности дјетета СПП до 14 година РЕВИСК', 'Тест REVISK SPP до 14 лет', 'REVISK-Test für SPP unter 14', 'REVISK testi 14 yaş altı SPP')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 25 FROM medical_services WHERE slug = 'revisk-intelligence-test-for-special-needs-children-under-14';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 22 FROM medical_services WHERE slug = 'revisk-intelligence-test-for-special-needs-children-under-14';

-- H04011 — у соседей H04001–H04010 категорий и специальностей нет
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Cooperation with Social Protection Services and Other Healthcare Institutions', 'cooperation-with-social-protection-and-healthcare-services', 'Saradnja sa službama socijalne zaštite i drugim zdravstvenim ustanovama', 'Сарадња са службама социјалне заштите и другим здравственим установама', 'Взаимодействие со службами социальной защиты и другими медицинскими учреждениями', 'Zusammenarbeit mit Sozialschutzdiensten und anderen Gesundheitseinrichtungen', 'Sosyal koruma hizmetleri ve diğer sağlık kuruluşlarıyla işbirliği')
ON DUPLICATE KEY UPDATE name_en = name_en;

-- I02005 — как pediatric-multidisciplinary-patient-workup (I02004)
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('School or Kindergarten Pedagogue Consultation (Pediatrician)', 'school-or-kindergarten-pedagogue-consultation-pediatrics', 'Savjet pedagogu škole ili vrtića (pedijatar)', 'Савјет педагогу школе или вртића (педијатар)', 'Консультация педагогу школы или детского сада (педиатр)', 'Beratung für Schul- oder Kindergartenpädagogen (Kinderarzt)', 'Okul veya anaokulu pedagoguna danışmanlık (çocuk doktoru)')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 25 FROM medical_services WHERE slug = 'school-or-kindergarten-pedagogue-consultation-pediatrics';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 4 FROM medical_services WHERE slug = 'school-or-kindergarten-pedagogue-consultation-pediatrics';

-- ═══ 2. Переименования (slug не меняется) ═══

-- H01005: «Dodatna … (verzodvalna)» — ошибка распознавания
UPDATE medical_services SET name_en = 'Depth Individual Therapy (Counseling Therapy)', name_sr = 'Dubinska individualna terapija (savjetodavna terapija)', name_sr_cyrl = 'Дубинска индивидуална терапија (савјетодавна терапија)', name_ru = 'Глубинная индивидуальная терапия (консультативная терапия)', name_de = 'Tiefgehende Einzeltherapie (beratende Therapie)', name_tr = 'Derinlemesine bireysel terapi (danışmanlık terapisi)' WHERE slug = 'additional-individual-therapy';
-- H02018: «testovi nedovoljno razloženi» → «testovi nedovršenih rečenica»
UPDATE medical_services SET name_en = 'Special Needs Child Personality Tests: Sentence Completion Test', name_sr = 'Testovi ličnosti djeteta SPP - testovi nedovršenih rečenica', name_sr_cyrl = 'Тестови личности дјетета СПП - тестови недовршених реченица', name_ru = 'Тест незаконченных предложений SPP', name_de = 'Satzergänzungstest SPP', name_tr = 'Cümle tamamlama testi SPP' WHERE slug = 'special-needs-child-personality-tests-underdeveloped';
-- H02012: Viti test — «preko 14 godina», не «do 14»
UPDATE medical_services SET name_en = 'Viti Test for Special Needs Children Over 14', name_sr = 'Procjena intelektualnih sposobnosti djeteta SPP preko 14 godina Viti test', name_sr_cyrl = 'Процјена интелектуалних способности дјетета СПП преко 14 година Вити тест', name_ru = 'Тест Вити SPP старше 14 лет', name_de = 'Viti-Test für SPP über 14', name_tr = 'Viti testi 14 yaş üstü SPP' WHERE slug = 'viti-test-for-special-needs-children-under-14';
-- кириллица: латинская аббревиатура W-B
UPDATE medical_services SET name_sr_cyrl = 'Процјена интелектуалних способности дјетета СПП преко 14 година W-B скала' WHERE slug = 'wechsler-bellevue-test-for-special-needs-children-over-14';
-- кириллица: латинская аббревиатура W-B
UPDATE medical_services SET name_sr_cyrl = 'Процјена интелектуалних способности дјетета СПП преко 14 година W-B скала (алт)' WHERE slug = 'wechsler-bellevue-test-variant-for-special-needs-over-14';
-- H09: «otpustnog tima» → «asertivnog tima»
UPDATE medical_services SET name_en = 'First Assertive Team Home Visit Up to 5 km', name_sr = 'Prva posjeta asertivnog tima u kući osiguranika do 5 km od Doma zdravlja', name_sr_cyrl = 'Прва посјета асертивног тима у кући осигураника до 5 км од Дома здравља', name_ru = 'Первичный визит ассертивной команды до 5 км', name_de = 'Erster Hausbesuch des assertiven Teams bis 5 km', name_tr = '5 km''ye kadar ilk asertif ekip ev ziyareti' WHERE slug = 'first-discharge-team-home-visit-up-to-5-km';
-- H09: «otpustnog tima» → «asertivnog tima»
UPDATE medical_services SET name_en = 'First Assertive Team Home Visit 5 to 15 km', name_sr = 'Prva posjeta asertivnog tima 5-15 km od Doma zdravlja', name_sr_cyrl = 'Прва посјета асертивног тима 5-15 км од Дома здравља', name_ru = 'Первичный визит ассертивной команды 5-15 км', name_de = 'Erster Hausbesuch des assertiven Teams 5-15 km', name_tr = '5-15 km arası ilk asertif ekip ev ziyareti' WHERE slug = 'first-discharge-team-home-visit-5-to-15-km';
-- H09: «otpustnog tima» → «asertivnog tima»
UPDATE medical_services SET name_en = 'First Assertive Team Home Visit Over 15 km', name_sr = 'Prva posjeta asertivnog tima preko 15 km od Doma zdravlja', name_sr_cyrl = 'Прва посјета асертивног тима преко 15 км од Дома здравља', name_ru = 'Первичный визит ассертивной команды свыше 15 км', name_de = 'Erster Hausbesuch des assertiven Teams über 15 km', name_tr = '15 km üzeri ilk asertif ekip ev ziyareti' WHERE slug = 'first-discharge-team-home-visit-over-15-km';
-- H09: «otpustnog tima» → «asertivnog tima»
UPDATE medical_services SET name_en = 'Follow-up Assertive Team Home Visit Up to 5 km', name_sr = 'Ponovna posjeta asertivnog tima do 5 km od Doma zdravlja', name_sr_cyrl = 'Поновна посјета асертивног тима до 5 км од Дома здравља', name_ru = 'Повторный визит ассертивной команды до 5 км', name_de = 'Folgehausbesuch des assertiven Teams bis 5 km', name_tr = '5 km''ye kadar tekrar asertif ekip ev ziyareti' WHERE slug = 'follow-up-discharge-team-home-visit-up-to-5-km';
-- H09: «otpustnog tima» → «asertivnog tima»
UPDATE medical_services SET name_en = 'Follow-up Assertive Team Home Visit 5 to 15 km', name_sr = 'Ponovna posjeta asertivnog tima 5-15 km od Doma zdravlja', name_sr_cyrl = 'Поновна посјета асертивног тима 5-15 км од Дома здравља', name_ru = 'Повторный визит ассертивной команды 5-15 км', name_de = 'Folgehausbesuch des assertiven Teams 5-15 km', name_tr = '5-15 km arası tekrar asertif ekip ev ziyareti' WHERE slug = 'follow-up-discharge-team-home-visit-5-to-15-km';
-- H09: «otpustnog tima» → «asertivnog tima»
UPDATE medical_services SET name_en = 'Follow-up Assertive Team Home Visit Over 15 km', name_sr = 'Ponovna posjeta asertivnog tima preko 15 km od Doma zdravlja', name_sr_cyrl = 'Поновна посјета асертивног тима преко 15 км од Дома здравља', name_ru = 'Повторный визит ассертивной команды свыше 15 км', name_de = 'Folgehausbesuch des assertiven Teams über 15 km', name_tr = '15 km üzeri tekrar asertif ekip ev ziyareti' WHERE slug = 'follow-up-discharge-team-home-visit-over-15-km';
-- X01020: «Fiksacija» — ошибка распознавания «frikcije» (ДЗ Херцег-Нови/Мойковац)
UPDATE medical_services SET name_en = 'Frictions (Rubbing Massage)', name_sr = 'Frikcije', name_sr_cyrl = 'Фрикције', name_ru = 'Фрикции (растирания)', name_de = 'Friktionen (Einreibungen)', name_tr = 'Friksiyon (ovma)' WHERE slug = 'fixation';
-- A02008: «Kratka posjeta doktoru u kući…» → «Ponovni kurativni pregled (kontrolni) u kući… do 5 km»
UPDATE medical_services SET name_en = 'Home Visit Follow-up Curative Examination Up to 5 km', name_sr = 'Ponovni kurativni pregled u kući osiguranika do 5 km od ambulante', name_sr_cyrl = 'Поновни куративни преглед у кући осигураника до 5 км од амбуланте', name_ru = 'Повторный лечебный осмотр на дому до 5 км', name_de = 'Kurative Folge-Hausuntersuchung bis 5 km', name_tr = '5 km''ye kadar evde tekrar küratif muayene' WHERE slug = 'home-visit-brief-doctor-visit-up-to-5-km';
-- C01006: «ekstrauterine gravidarne» → «ekstrauterinog graviditeta»
UPDATE medical_services SET name_sr = 'Pregled i savjetovanje nakon ekstrauterinog graviditeta', name_sr_cyrl = 'Преглед и савјетовање након екстраутериног гравидитета' WHERE slug = 'post-ectopic-pregnancy-examination-and-counseling';
-- G01002: «odraslih po registrovanim» → «osoba sa registrovanom TBC»
UPDATE medical_services SET name_en = 'Examination of Persons with Registered TB', name_sr = 'Pregled osoba sa registrovanom TBC', name_sr_cyrl = 'Преглед особа са регистрованом ТБЦ', name_ru = 'Осмотр лиц с зарегистрированным ТБ', name_de = 'Untersuchung von Personen mit registrierter TB', name_tr = 'Kayıtlı TB hastalarının muayenesi' WHERE slug = 'adult-examination-for-registered-tb';
-- I01007: «sa porodicom» → «sa pojedincem (roditelj, vaspitač, nastavnik)»
UPDATE medical_services SET name_en = 'Individual Health Education Work (Parent, Educator, Teacher)', name_sr = 'Zdravstveno vaspitni rad sa pojedincem (roditelj, vaspitač, nastavnik)', name_sr_cyrl = 'Здравствено васпитни рад са појединцем (родитељ, васпитач, наставник)', name_ru = 'Санитарно-просветительная работа с отдельным человеком (родитель, воспитатель, учитель)', name_de = 'Gesundheitsbildung mit Einzelpersonen (Eltern, Erzieher, Lehrer)', name_tr = 'Bireysel sağlık eğitimi çalışması (ebeveyn, eğitmen, öğretmen)' WHERE slug = 'family-health-education-work';
-- I03004: «problema čitanja» → «poremećaja učenja» (ДЗ Херцег-Нови и Рисан)
UPDATE medical_services SET name_en = 'Speech Therapy Assessment of Specific Learning Disorders', name_sr = 'Logopedska procjena specifičnih poremećaja učenja', name_sr_cyrl = 'Логопедска процјена специфичних поремећаја учења', name_ru = 'Логопедическая оценка специфических расстройств обучения', name_de = 'Logopädische Beurteilung spezifischer Lernstörungen', name_tr = 'Spesifik öğrenme bozukluklarının logopedik değerlendirmesi' WHERE slug = 'specific-reading-disorder-assessment';
-- I03011: «…tretman SPP» → «…djeteta sa povišenom impulsivnošću»
UPDATE medical_services SET name_en = 'Individual Defectology or Speech Therapy Treatment for a Child with Increased Impulsivity', name_sr = 'Defektološki/logopedski individualni tretman djeteta sa povišenom impulsivnošću', name_sr_cyrl = 'Дефектолошки/логопедски индивидуални третман дјетета са повишеном импулсивношћу', name_ru = 'Индивидуальные дефектологические или логопедические занятия с ребёнком с повышенной импульсивностью', name_de = 'Individuelle defektologische oder logopädische Behandlung eines Kindes mit erhöhter Impulsivität', name_tr = 'Dürtüselliği artmış çocuk için bireysel defektoloji veya konuşma terapisi' WHERE slug = 'individual-defectology-speech-therapy-treatment-for-spp';
-- I03020: «Pedagoška procjena» → «Savjet pedagogu škole ili vrtića» (ДЗ Херцег-Нови и Рисан)
UPDATE medical_services SET name_en = 'School or Kindergarten Pedagogue Consultation (Defectologist)', name_sr = 'Savjet pedagogu škole ili vrtića (defektolog)', name_sr_cyrl = 'Савјет педагогу школе или вртића (дефектолог)', name_ru = 'Консультация педагогу школы или детского сада (дефектолог)', name_de = 'Beratung für Schul- oder Kindergartenpädagogen (Defektologe)', name_tr = 'Okul veya anaokulu pedagoguna danışmanlık (defektolog)' WHERE slug = 'pedagogical-assessment';
-- H04004: «Socio terapija individualna» → «Socio terapija - liječeni pacijenti»
UPDATE medical_services SET name_en = 'Sociotherapy for Treated Patients', name_sr = 'Socio terapija - liječeni pacijenti', name_sr_cyrl = 'Социо терапија - лијечени пацијенти', name_ru = 'Социотерапия пролеченных пациентов', name_de = 'Soziotherapie für behandelte Patienten', name_tr = 'Tedavi görmüş hastalar için sosyo terapi' WHERE slug = 'individual-sociotherapy';
-- H04006: «porodična grupna» → «Socio tretman - član porodice»
UPDATE medical_services SET name_en = 'Social Treatment: Family Member', name_sr = 'Socio tretman - član porodice', name_sr_cyrl = 'Социо третман - члан породице', name_ru = 'Социальная работа с членом семьи', name_de = 'Soziale Behandlung eines Familienmitglieds', name_tr = 'Sosyal tedavi: aile üyesi' WHERE slug = 'family-group-sociotherapy';
-- H04007: «Socio terapija porodična» → «Socio tretman - porodica, teren»
UPDATE medical_services SET name_en = 'Social Treatment: Family, Field Visit', name_sr = 'Socio tretman - porodica, teren', name_sr_cyrl = 'Социо третман - породица, терен', name_ru = 'Социальная работа с семьёй на выезде', name_de = 'Soziale Behandlung der Familie vor Ort', name_tr = 'Sosyal tedavi: aile, saha ziyareti' WHERE slug = 'family-sociotherapy';
-- H04008: «individualna stresna» — ошибка распознавания «individualna seansa»
UPDATE medical_services SET name_en = 'Sociotherapy: Individual Session', name_sr = 'Socio terapija - individualna seansa', name_sr_cyrl = 'Социо терапија - индивидуална сеанса', name_ru = 'Социотерапия, индивидуальный сеанс', name_de = 'Soziotherapie, Einzelsitzung', name_tr = 'Sosyo terapi: bireysel seans' WHERE slug = 'individual-stress-sociotherapy';
-- H04009: «organizovana» — ошибка распознавания «radna organizacija»
UPDATE medical_services SET name_en = 'Social Treatment: Workplace', name_sr = 'Socio tretman - radna organizacija', name_sr_cyrl = 'Социо третман - радна организација', name_ru = 'Социальная работа с трудовым коллективом', name_de = 'Soziale Behandlung am Arbeitsplatz', name_tr = 'Sosyal tedavi: iş yeri' WHERE slug = 'organized-sociotherapy';
-- X01024: «…na grlić materice» → «(vaginalno i cervikalno)», по прайсу ДЗ Херцег-Нови и тарифу
UPDATE medical_services SET name_en = 'Local Drug Application (Vaginal and Cervical)', name_sr = 'Lokalno apliciranje lijeka (vaginalno i cervikalno)', name_sr_cyrl = 'Локално аплицирање лијека (вагинално и цервикално)', name_ru = 'Местное введение лекарства (вагинально и в шейку матки)', name_de = 'Lokale Arzneimittelapplikation (vaginal und zervikal)', name_tr = 'Lokal ilaç uygulaması (vajinal ve servikal)' WHERE slug = 'cervical-drug-application';
-- X01017 (gyn): «maternalnog» — ошибка распознавания «mehaničkog»
UPDATE medical_services SET name_sr = 'Kontrola mehaničkog kontraceptivnog sredstva', name_sr_cyrl = 'Контрола механичког контрацептивног средства' WHERE slug = 'contraceptive-device-check';
-- M01021: «Grupne vježbe (tip B)» → «Grupne vježbe, po osobi»
UPDATE medical_services SET name_en = 'Group Exercises (per Person)', name_sr = 'Grupne vježbe, po osobi', name_sr_cyrl = 'Групне вјежбе, по особи', name_ru = 'Групповые упражнения (за одного человека)', name_de = 'Gruppenübungen (pro Person)', name_tr = 'Grup egzersizleri (kişi başı)' WHERE slug = 'group-exercises-type-b';

-- Синонимы, совпавшие с новым названием на том же языке (их завёл импорт Рисана), больше не нужны
DELETE syn FROM medical_service_synonyms syn
JOIN medical_services ms ON ms.id = syn.medical_service_id
WHERE ms.slug IN ('specific-reading-disorder-assessment', 'pedagogical-assessment')
  AND ((syn.language = 'sr' AND syn.another_name = ms.name_sr)
    OR (syn.language = 'sr-cyrl' AND syn.another_name = ms.name_sr_cyrl)
    OR (syn.language = 'ru' AND syn.another_name = ms.name_ru)
    OR (syn.language = 'en' AND syn.another_name = ms.name_en)
    OR (syn.language = 'de' AND syn.another_name = ms.name_de)
    OR (syn.language = 'tr' AND syn.another_name = ms.name_tr));

-- ═══ 3. Строки клиник ДЗ: перенос на правильные записи ═══
-- Порядок важен: H02010→H02013 — цепочка (каждая цель освобождается шагом выше), H04011 раньше H04010.
-- UPDATE IGNORE: если у клиники цель уже есть, строка остаётся на месте и видна в проверке ПОСЛЕ (ожидается пусто).

-- A01010: pregnancy-preventive-examination-by-calendar → preventive-examination-of-children-under-15-during-epidemic
SET @from = (SELECT id FROM medical_services WHERE slug = 'pregnancy-preventive-examination-by-calendar');
SET @to = (SELECT id FROM medical_services WHERE slug = 'preventive-examination-of-children-under-15-during-epidemic');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'A01010' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'A01010' AND @to IS NOT NULL;

-- H02010: progressive-matrices-test-for-special-needs-children-under-14 → revisk-intelligence-test-for-special-needs-children-under-14
SET @from = (SELECT id FROM medical_services WHERE slug = 'progressive-matrices-test-for-special-needs-children-under-14');
SET @to = (SELECT id FROM medical_services WHERE slug = 'revisk-intelligence-test-for-special-needs-children-under-14');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02010' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02010' AND @to IS NOT NULL;

-- H02011: viti-test-for-special-needs-children-under-14 → progressive-matrices-test-for-special-needs-children-under-14
SET @from = (SELECT id FROM medical_services WHERE slug = 'viti-test-for-special-needs-children-under-14');
SET @to = (SELECT id FROM medical_services WHERE slug = 'progressive-matrices-test-for-special-needs-children-under-14');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02011' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02011' AND @to IS NOT NULL;

-- H02012: wechsler-bellevue-test-for-special-needs-children-over-14 → viti-test-for-special-needs-children-under-14
SET @from = (SELECT id FROM medical_services WHERE slug = 'wechsler-bellevue-test-for-special-needs-children-over-14');
SET @to = (SELECT id FROM medical_services WHERE slug = 'viti-test-for-special-needs-children-under-14');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02012' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02012' AND @to IS NOT NULL;

-- H02013: wechsler-bellevue-test-variant-for-special-needs-over-14 → wechsler-bellevue-test-for-special-needs-children-over-14
SET @from = (SELECT id FROM medical_services WHERE slug = 'wechsler-bellevue-test-variant-for-special-needs-over-14');
SET @to = (SELECT id FROM medical_services WHERE slug = 'wechsler-bellevue-test-for-special-needs-children-over-14');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02013' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02013' AND @to IS NOT NULL;

-- H04011: legal-responsibility-assessment → cooperation-with-social-protection-and-healthcare-services
SET @from = (SELECT id FROM medical_services WHERE slug = 'legal-responsibility-assessment');
SET @to = (SELECT id FROM medical_services WHERE slug = 'cooperation-with-social-protection-and-healthcare-services');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H04011' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H04011' AND @to IS NOT NULL;

-- H04010: expert-organized-assessment → legal-responsibility-assessment
SET @from = (SELECT id FROM medical_services WHERE slug = 'expert-organized-assessment');
SET @to = (SELECT id FROM medical_services WHERE slug = 'legal-responsibility-assessment');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H04010' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H04010' AND @to IS NOT NULL;

-- H04001: social-worker-counseling-and-intervention → social-worker-expert-assessment
SET @from = (SELECT id FROM medical_services WHERE slug = 'social-worker-counseling-and-intervention');
SET @to = (SELECT id FROM medical_services WHERE slug = 'social-worker-expert-assessment');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H04001' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H04001' AND @to IS NOT NULL;

-- H02025: individual-preventive-therapy → individual-supportive-therapy
SET @from = (SELECT id FROM medical_services WHERE slug = 'individual-preventive-therapy');
SET @to = (SELECT id FROM medical_services WHERE slug = 'individual-supportive-therapy');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02025' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'H02025' AND @to IS NOT NULL;

-- I02005: pediatric-counseling → school-or-kindergarten-pedagogue-consultation-pediatrics
SET @from = (SELECT id FROM medical_services WHERE slug = 'pediatric-counseling');
SET @to = (SELECT id FROM medical_services WHERE slug = 'school-or-kindergarten-pedagogue-consultation-pediatrics');
UPDATE IGNORE clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
SET cmsd.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'I02005' AND @to IS NOT NULL;
UPDATE IGNORE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
SET cms.medical_service_id = @to
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'I02005' AND @to IS NOT NULL;

-- C01002 «Prenatalno određivanje kariotipa fetusa iz ćelija plodove vode» — анализ, не услуга:
-- строка ХН/Мойковца переезжает из gynecological-preventive-visit в clinic_lab_tests (как в 043)
SET @from = (SELECT id FROM medical_services WHERE slug = 'gynecological-preventive-visit');
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, code, price, price_max, is_price_outdated, is_obsolete)
SELECT cms.clinic_id, @lt_karyotype, cms.code, cms.price, cms.price_max, cms.is_price_outdated, cms.is_obsolete
FROM clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'C01002' AND @lt_karyotype IS NOT NULL;
DELETE cmsd FROM clinic_medical_service_doctors cmsd
JOIN clinic_medical_services cms ON cms.clinic_id = cmsd.clinic_id AND cms.medical_service_id = cmsd.medical_service_id
JOIN clinics c ON c.id = cms.clinic_id
JOIN clinic_lab_tests clt ON clt.clinic_id = cms.clinic_id AND clt.lab_test_id = @lt_karyotype
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'C01002';
DELETE cms FROM clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
JOIN clinic_lab_tests clt ON clt.clinic_id = cms.clinic_id AND clt.lab_test_id = @lt_karyotype
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad') AND cms.medical_service_id = @from AND REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}') = 'C01002';

-- ═══ 4. Привязки тарифов PZZ ═══
-- Комментарии к исправлениям:
--   A01010 → preventive-examination-of-children-under-15-during-epidemic: было pregnancy-preventive-examination-by-calendar (осмотр беременной)
--   C01002 → lab:karyotype-from-amniotic-fluid: было gynecological-preventive-visit; кариотип плода — анализ
--   H01005 → additional-individual-therapy: было NULL; запись переименована
--   H01015 → brief-adult-intellectual-status-test: было clinical-intellectual-status-assessment — это секундарный H01015 «Kliničko ispitivanje…»
--   H01019 → adult-individual-function-clinical-testing: было neuropsychological-examination-… — это секундарный H01019
--   H02010 → revisk-intelligence-test-for-special-needs-children-under-14: было progressive-matrices-… (сдвиг)
--   H02011 → progressive-matrices-test-for-special-needs-children-under-14: было viti-test-… (сдвиг)
--   H02012 → viti-test-for-special-needs-children-under-14: было wechsler-bellevue-… (сдвиг; имя тарифа тоже исправлено)
--   H02013 → wechsler-bellevue-test-for-special-needs-children-over-14: было wechsler-bellevue-test-variant-… «(alt)»
--   H04010 → legal-responsibility-assessment: было expert-organized-assessment
--   H04011 → cooperation-with-social-protection-and-healthcare-services: было legal-responsibility-assessment (это H04010)
--   I02005 → school-or-kindergarten-pedagogue-consultation-pediatrics: было pediatric-counseling («Konsultacija pedijatra» у Natal Kids)
--   J07005 → joint-and-soft-tissue-ultrasound: было soft-tissue-ultrasound; в PZZ — «zglobova i mekih tkiva»
--   J07006 → ultrasound-lymph-nodes: было abdominal-vessels-and-lymph-nodes-ultrasound — это секундарный J07006
--   X01004 → local-anesthesia-administration: было topical-local-anesthesia (поверхностная) — это секундарный X01004
--   X01020 → fixation: было NULL; запись переименована в «Frikcije»
--   X01024 → cervical-drug-application: было vaginal-suppository-application; запись переименована
--   X02015 → evacuation-pleural-puncture: было pleural-puncture-with-lavage («…sa lavažom») — это секундарный X02015
UPDATE medical_service_tariffs t
JOIN tmp_pzz_links l ON l.code = t.code
LEFT JOIN medical_services ms ON ms.slug = l.slug
LEFT JOIN lab_tests lt ON lt.slug = l.lab_slug
SET t.medical_service_id = ms.id,
	t.lab_test_id = IF(l.lab_slug IS NULL, t.lab_test_id, lt.id)
WHERE t.tariff_source = 'fzocg-pzz'
  AND (l.slug IS NULL OR ms.id IS NOT NULL)
  AND (l.lab_slug IS NULL OR lt.id IS NOT NULL);

-- ═══ 5. Имена тарифов PZZ H02012/H02013 (в FINAL съехали: «W-B skala» и «W-B skala (alt)»; PDF: Viti test / W-B skala) ═══
UPDATE medical_service_tariffs SET name_sr_latin = 'Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama preko14 godina-Viti test' WHERE tariff_source = 'fzocg-pzz' AND code = 'H02012' AND name_sr_latin = 'Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama preko14 godina-W-B skala';
UPDATE medical_service_tariffs SET name_sr_latin = 'Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama preko14 godina-W-B skala' WHERE tariff_source = 'fzocg-pzz' AND code = 'H02013' AND name_sr_latin = 'Procjena intelektualnih sposobnosti djeteta sa posebnim potrebama preko14 godina-W-B skala (alt)';

-- ═══ ПОСЛЕ ═══

-- Привязки PZZ не на целевой записи. Ожидается ПУСТО.
SELECT l.kind, l.code, ms.slug AS current_slug, l.slug AS target_slug, t.lab_test_id, l.lab_slug
FROM tmp_pzz_links l
JOIN medical_service_tariffs t ON t.tariff_source = 'fzocg-pzz' AND t.code = l.code
LEFT JOIN medical_services ms ON ms.id = t.medical_service_id
WHERE NOT (ms.slug <=> l.slug)
   OR (l.lab_slug IS NOT NULL AND NOT (t.lab_test_id <=> @lt_karyotype));

-- Строки клиник ДЗ, оставшиеся на исходной записи. Ожидается ПУСТО.
SELECT c.slug AS clinic, cms.code, ms.slug AS still_on
FROM clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
JOIN medical_services ms ON ms.id = cms.medical_service_id
JOIN tmp_moves m ON m.from_slug = ms.slug AND m.base_code = REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}')
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad');

-- Строки ДЗ на новых местах (ожидается 16 услуг) и кариотип (ожидается 2: ХН 16.00, Мойковац 21.51)
SELECT c.slug AS clinic, cms.code, ms.slug, cms.price
FROM clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id
JOIN medical_services ms ON ms.id = cms.medical_service_id
JOIN tmp_moves m ON m.to_slug = ms.slug AND m.base_code = REGEXP_SUBSTR(cms.code, '[A-Z][0-9]{5}')
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad')
ORDER BY m.base_code, c.slug;
SELECT c.slug AS clinic, clt.code, clt.price
FROM clinic_lab_tests clt JOIN clinics c ON c.id = clt.clinic_id
WHERE clt.lab_test_id = @lt_karyotype AND c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac', 'dom-zdravlja-kolasin', 'dom-zdravlja-dimitrije-dika-marenic-danilovgrad');

-- Тарифы H02010–H02013 и записи-сироты (ожидается: у сирот clinics = 0, tariffs = 0)
SELECT t.code, t.name_sr_latin, t.price_eur FROM medical_service_tariffs t
WHERE t.tariff_source = 'fzocg-pzz' AND t.code IN ('H02010', 'H02011', 'H02012', 'H02013');
SELECT ms.slug,
	(SELECT COUNT(*) FROM clinic_medical_services x WHERE x.medical_service_id = ms.id) AS clinics,
	(SELECT COUNT(*) FROM medical_service_tariffs x WHERE x.medical_service_id = ms.id) AS tariffs
FROM medical_services ms
WHERE ms.slug IN ('gynecological-preventive-visit', 'expert-organized-assessment', 'social-worker-counseling-and-intervention',
	'individual-preventive-therapy', 'wechsler-bellevue-test-variant-for-special-needs-over-14');

-- Счётчики: medical_services +4 (кроме повторного прогона), pzz_linked_services: было 246 → 293
-- (+46 новых L/M/X, +2 ранее непривязанных H01005 и X01020, −1 C01002 → анализ), pzz_linked_lab_tests 28 → 29, clinic_medical_services −2, clinic_lab_tests +2
SELECT (SELECT COUNT(*) FROM medical_services) AS medical_services_total,
	x.pzz_linked_services, x.pzz_linked_lab_tests,
	(SELECT COUNT(*) FROM clinic_medical_services) AS clinic_medical_services_total,
	(SELECT COUNT(*) FROM clinic_lab_tests) AS clinic_lab_tests_total
FROM (SELECT SUM(medical_service_id IS NOT NULL) AS pzz_linked_services, SUM(lab_test_id IS NOT NULL) AS pzz_linked_lab_tests
	FROM medical_service_tariffs WHERE tariff_source = 'fzocg-pzz') x;

DROP TEMPORARY TABLE IF EXISTS tmp_pzz_links;
DROP TEMPORARY TABLE IF EXISTS tmp_moves;

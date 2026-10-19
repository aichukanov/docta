SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 056: построчная сверка прайсов ДЗ Херцег-Нови и ДЗ «Boško Dedejić» Мойковац с оригиналами PDF.
--
-- Порядок: ПОСЛЕ 055 (слияния пар и K-тарифы PZZ — здесь используются только выживающие slug), ПОСЛЕ 054.
-- Клиники и записи каталога — только по slug (id клиник на локали и проде различаются).
--
-- Источники (сканы без текстового слоя: OCR RapidOCR по рендеру 200 dpi + сверка каждой страницы глазами):
--   data/pricelists/herceg novi dz/CJENOVNIK.pdf — «Cjenovnik zdravstvenih usluga prema trećim licima», broj 384,
--     01.03.2019, 21 стр., одна колонка цены; 500 позиций (450 с кодом PZZ/DRG + 50 без кода: тесты, справки
--     медицины труда, HES, санитетский превоз, специалисты, холтер).
--   data/pricelists/mojkovac dz/02.10.2025.pdf — «Cjenovnik … trećim licima koja nijesu osiguranici FZOCG»,
--     23 стр., колонки Cijena / Cijena x3 (DRG — x2.50); взята x3 (x2.50 для DRG), как в исходном импорте; 340 позиций.
-- Словарь «код → запись каталога»: medical_service_tariffs (fzocg-pzz, после 054), K-привязки 055 (tmp_k_links),
-- для Z/J07009–012/X14002 — запись, на которой лежат строки с тем же кодом у КЦЦГ, Данило, ОБ Никшич, ДЗ Ульцинь, Рисан.
-- X-коды раздела гинеколога (_GYN) и TBC (_TBC) без своей привязки — на запись базового кода; X01010 TBC —
-- inhalation-tb-center, X02013 TBC — pleural-puncture (как в тарифе X02013_DIAG).
--
-- Что было не так (импорты 2026-05 читали сканы «на глаз»):
--   * коды и цены сдвинуты на соседние строки: X02008–X02011 (катетер / канюля / ЭКГ / спирометрия), X02019/X02020
--     под кодами X02014/X02015, K01011/K01012 (глаз/ухо), K01013/K01014, K01031/K01032, K01043/K01047, Z01024–Z01028,
--     Z01012 → Z01013; у ХН перепутаны цены H01004 (17 вместо 33), H01006 (33 вместо 133), H02014, H02022, H04006,
--     I03014, LDH / CK-MB (26 и 4 наоборот), L03004 (21 вместо 31), J06013/J06014, M01003/M01010/M01014 и др.;
--   * выдуманные записи: X01003 «из носа» вместо «из кожи», X01011, X01012, X02008 «зондирование желудка»,
--     GX01023 «вагинальные свечи» (в PDF такой строки нет), J06002/J06003/J06005–J06007, J11004, M01006/M01017/
--     M01019/M01020/M01026/M01029/M01030, TBC X01006/X01007/X01021/X02013, K01040 «посев спермы», K01051, K01054;
--     у ХН вся «Medicina rada» (MR 1–19 стояли на записях с другими названиями и ценами) и HES 7–8 (бешенство
--     записано как тиф);
--   * лабораторные позиции Z в каталоге услуг (CRP, креатинин, мочевина, амилаза, hCG, скрытая кровь, белок мочи,
--     LDL, КАК) — переносятся в анализы;
--   * у Мойковца цены X01011/X01015/X01018/X01019/X01020/X02007–X02009/X03003, H01013 (217,41 вместо 163,05),
--     H09005 (207,54 вместо 207,51), M02009 (7,83 вместо 8,34) не совпадали с колонкой x3;
--   * позиции PDF, которых у клиник не было: ХН — X03010, X02012, I03019, K01013, K01031, K01038, K01042, K01047,
--     K01053, K02008, Z01007, Z01033, Z01035, Z02004, Ergometrija (MR 21); Мойковац — X01006, X01023, X02012,
--     X02014, X02015, X03010.
-- Позиции, встречающиеся в нескольких разделах PDF (X у врача / гинеколога / TBC, J07004 у Мойковца в двух разделах,
-- Z01040/Z02098 у ХН), — одна строка на запись: price = минимум, price_max = максимум, code — коды через «/».
-- Цены, которых в PDF нет (J07009–J07012, Ergometrija, тест на эргоцикле у ХН; санитетский превоз Мойковца —
-- «26% цены литра топлива x3»), — NULL. Позиции Мойковца с ценой 0 / 0 (Z01007, Z01103, Z01105, Z01106, Z01089,
-- Z01107, Z01108, Z01102, Z01040) не заводятся (строка reticulocytes 0,00 снимается).
-- Коды строк: ХН — код PDF без префикса (как уже было у A/C/G/H/I), позиции без кода — HN_* (HES вместо BES);
-- Мойковац — MO_ + код PDF (без «HN_», «G», «TBC»), DRG — MO_DRG_*. Справки и санитарные осмотры Мойковца
-- (MO_UVJ_*, MO_SAN_*, другие PDF, 2026-10-02) не трогаются. is_price_outdated не меняется; у перенесённой строки
-- флаги берутся со снимаемой строки того же кода.
--
-- Механика: целевой состав прайса — tmp_056_target; недостающие строки добавляются, у имеющихся code/price/price_max
-- приводятся к PDF, строки из tmp_056_remove снимаются (каждая с причиной). Перенос строки на правильную запись =
-- новая строка на правильной записи + снятие старой; привязки врачей переносятся по tmp_056_moves (у этих клиник
-- их нет, на случай прода). Новые записи каталога — 2 (бешенство: вакцина Verorab и иммуноглобулин).
--
-- После переносов без клиник и тарифов остаются 43 записи-ошибки импортов (список — в ПОСЛЕ, не удаляются: удаление =
-- 301 через medical_service_redirects, решение отдельно).
--
-- Идемпотентно: новые записи — ON DUPLICATE KEY / INSERT IGNORE, строки добавляются только отсутствующие (снимок
-- tmp_056_src), обновляются только отличающиеся, снятие — по списку; второй прогон ничего не меняет (проверено на
-- TEMPORARY-копиях таблиц: 055 → 056 → 056, контрольные суммы после 1-го и 2-го прогона совпадают).
-- Временные таблицы не ссылаются сами на себя в одном запросе — файл прогоняется и на сессионных копиях таблиц.

SET @hn = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-herceg-novi');
SET @mo = (SELECT id FROM clinics WHERE slug = 'dom-zdravlja-bosko-dedeic-mojkovac');
SELECT @hn AS hn_clinic_id, @mo AS mo_clinic_id;

-- ═══ 0. Целевой состав прайсов (по PDF), строки на удаление, источники переносов ═══

DROP TEMPORARY TABLE IF EXISTS tmp_056_target;
CREATE TEMPORARY TABLE tmp_056_target (
	clinic_slug VARCHAR(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'S — услуга, L — анализ',
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	price DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL,
	PRIMARY KEY (clinic_slug, kind, slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- dom-zdravlja-herceg-novi: 480 строк (350 услуг, 130 анализов)
INSERT INTO tmp_056_target (clinic_slug, kind, slug, code, price, price_max) VALUES
('dom-zdravlja-herceg-novi', 'S', 'preventive-examination-up-to-age-1', 'A01001', 39.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'preventive-examination-at-age-2', 'A01002', 39.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'preventive-examination-at-age-4', 'A01003', 39.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'preventive-examination-before-primary-school', 'A01004', 47.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'primary-school-preventive-examination', 'A01005', 36.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'secondary-school-preventive-systematic-examination', 'A01006', 36.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'student-systematic-preventive-examination', 'A01007', 36.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'systematic-preventive-examination-for-patients-over-65', 'A01008', 36.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-examination-after-preventive-examination', 'A01009', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'preventive-examination-of-children-under-15-during-epidemic', 'A01010', 36.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-vaccination-and-revaccination-by-schedule', 'A01011', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'influenza-vaccination-for-patients-over-65', 'A01012', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'immunoprophylaxis-and-chemoprophylaxis-for-infectious-disease-prevention', 'A01013', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cardiovascular-risk-preventive-examination-adults-over-40', 'A01014', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'breast-cancer-early-detection-examination', 'A01015', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-curative-examination', 'A02001', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-curative-examination', 'A02002', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pre-operative-outpatient-examination-general-anesthesia', 'A02003', 39.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'brief-doctor-visit-without-examination', 'A02004', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-visit-first-curative-examination-up-to-5-km', 'A02005', 55.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-visit-first-curative-examination-5-to-15-km', 'A02006', 71.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-visit-first-curative-examination-over-15-km', 'A02007', 87.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-visit-brief-doctor-visit-up-to-5-km', 'A02008', 47.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-visit-follow-up-curative-examination-5-to-15-km', 'A02009', 63.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-visit-follow-up-curative-examination-over-15-km', 'A02010', 79.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'doctor-visit-for-ipk-workup', 'A02011', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'mononucleosis-test', 'A02_MONO', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'rapid-strep-a', 'A02_STREP', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'foreign-body-removal-from-ear', 'X01001', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'foreign-body-removal-from-throat', 'X01002', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'foreign-body-removal-from-skin-and-subcutaneous-tissue', 'X01003', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'local-anesthesia-administration', 'X01004', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cerumen-ear-irrigation', 'X01005', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'oxygen-administration', 'X01006', 4.00, 5.00),
('dom-zdravlja-herceg-novi', 'S', 'swab-collection-for-laboratory-analysis', 'X01007', 7.00, 8.00),
('dom-zdravlja-herceg-novi', 'S', 'inhalation-therapy', 'X01010', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'aspiration-puncture-of-abscess-or-hematoma', 'X01011', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'stoma-care', 'X01012', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'artificial-anus-care', 'X01013', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'primary-wound-care-without-sutures', 'X01014', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'suture-removal', 'X01015', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'fixation-bandage', 'X01018', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'immobilization', 'X01019', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'fixation', 'X01020', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'subcutaneous-or-intramuscular-injection', 'X01021', 2.00, 3.00),
('dom-zdravlja-herceg-novi', 'S', 'burn-wound-care', 'X02002', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'abscess-incision', 'X02003', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'eye-foreign-body-removal-cornea', 'X02004', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'anterior-nasal-packing', 'X02005', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'urinary-catheter-placement', 'X02006', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'enema', 'X02007', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'indwelling-catheter-placement', 'X02008', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'intravenous-cannula-placement', 'X02009', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'ecg', 'X02010', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'spirometry', 'X02011', 9.00, 10.00),
('dom-zdravlja-herceg-novi', 'S', 'paraphimosis-reduction', 'X02019', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'incarcerated-hernia-reduction', 'X02020', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'atheroma-cyst-xanthoma-or-small-benign-tumor-excision', 'X02021', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'wound-suturing-under-local-anesthesia', 'X03001', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'external-cardiac-defibrillation', 'X03002', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'endotracheal-intubation', 'X03003', 37.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'gastric-lavage', 'X03004', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pregnancy-preventive-examination-first-trimester', 'C01001', 39.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'karyotype-from-amniotic-fluid', 'C01002', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pregnancy-ultrasound', 'C01003', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'postpartum-examination-at-6-weeks', 'C01004', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'post-abortion-examination-and-counseling', 'C01005', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'post-ectopic-pregnancy-examination-and-counseling', 'C01006', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'reproductive-age-women-preventive-examination-with-pap-test', 'C01007', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-specialist-curative-gynecological-examination', 'C02001', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-specialist-curative-gynecological-examination', 'C02002', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'brief-gynecologist-visit-without-examination', 'C02003', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'mechanical-contraceptive-device-check', 'X01017', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cervical-drug-application', 'X01024', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'iud-insertion', 'X01025', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'iud-removal', 'X01026', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'colposcopy', 'X02016', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'bartholin-gland-and-vulva-incision-and-drainage', 'X02017', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'vulvar-and-vaginal-condyloma-abrasion', 'X02018', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'vulva-biopsy-with-lab-analysis', 'X03005', 19.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cervical-biopsy-with-lab-analysis', 'X03006', 19.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'endometrial-biopsy-with-lab-analysis', 'X03007', 19.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cervical-or-uterine-polypectomy', 'X03008', 19.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'amnioscopy', 'X03009', 19.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'gynecological-ultrasound', 'X03010', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pregnancy-cardiotocography-ctg', 'X03013', 19.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'tuberculin-skin-test', 'G01001', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'adult-examination-for-registered-tb', 'G01002', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'tb-contact-tracing-examination', 'G01003', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patient-examination-with-chemoprophylaxis', 'G01004', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-pulmonologist-curative-examination', 'G02001', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-pulmonologist-curative-examination', 'G02002', 21.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'sputum-collection-for-bacterial-and-fungal-analysis', 'X01008', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'inhalation-tb-center', 'X01010', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'directly-observed-treatment-for-tb-dots', 'X01022', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'prick-test-inhalation-allergens', 'X02001', 22.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'bronchodilator-test', 'X02012', 9.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pleural-puncture', 'X02013', 27.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'thoracentesis', 'X02014', 27.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'evacuation-pleural-puncture', 'X02015', 27.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'sputum-collection-for-cytology', 'X03011', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-psychiatrist-examination', 'H01001', 50.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-psychiatrist-examination', 'H01002', 33.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'brief-psychiatrist-visit-without-examination', 'H01003', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'individual-supportive-psychotherapy-and-counseling', 'H01004', 33.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'additional-individual-therapy', 'H01005', 50.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'group-psychodynamic-and-sociodynamic-therapy', 'H01006', 133.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'group-psychotherapy-session-for-addictions', 'H01007', 133.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'family-psychotherapy-session', 'H01008', 100.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'analytically-oriented-depth-psychotherapy-session', 'H01009', 67.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'behavioral-psychotherapy', 'H01010', 67.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'relaxation-technique', 'H01011', 56.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'brief-psychodiagnostic-interview', 'H01012', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-psychomotor-development-assessment', 'H01013', 100.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'brief-pediatric-intellectual-status-test-under-15', 'H01014', 50.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'brief-adult-intellectual-status-test', 'H01015', 33.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-personality-structure-assessment-under-15', 'H01016', 89.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'personality-structure-assessment-for-adults', 'H01017', 56.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-individual-function-clinical-testing-under-15', 'H01018', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'adult-individual-function-clinical-testing', 'H01019', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'results-processing-integration-and-report-writing', 'H01020', 133.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'heteroanamnesis', 'H01021', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'family-counseling', 'H01022', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'multidisciplinary-team-patient-consultation', 'H01023', 33.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'psychologist-interview', 'H02001', 27.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'psychological-testing-category-a', 'H02002', 27.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'psychological-testing-category-b', 'H02003', 46.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'psychological-testing-category-c', 'H02004', 73.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'psychological-testing-category-d', 'H02005', 109.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'organicity-assessment', 'H02006', 109.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'special-needs-child-diagnostic-interview', 'H02007', 55.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'goodenough-intelligence-test-for-special-needs-children-under-14', 'H02008', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'binet-simon-intelligence-test-for-special-needs-children-under-14', 'H02009', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'revisk-intelligence-test-for-special-needs-children-under-14', 'H02010', 23.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'progressive-matrices-test-for-special-needs-children-under-14', 'H02011', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'viti-test-for-special-needs-children-under-14', 'H02012', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'wechsler-bellevue-test-for-special-needs-children-over-14', 'H02013', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'special-needs-child-psychomotor-development-assessment', 'H02014', 23.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'special-needs-child-social-maturity-assessment', 'H02015', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'multidisciplinary-developmental-disorder-patient-workup', 'H02016', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'play-diagnostic-assessment', 'H02017', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'special-needs-child-personality-tests-underdeveloped', 'H02018', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'special-needs-child-family-drawing-test', 'H02019', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'special-needs-child-ego-perception-test', 'H02020', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'parental-counseling-work', 'H02021', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'school-or-kindergarten-pedagogue-counseling', 'H02022', 15.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'data-processing', 'H02023', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'results-integration-and-report-writing', 'H02024', 109.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'individual-supportive-therapy', 'H02025', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'social-worker-expert-assessment', 'H04001', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'social-worker-interview-social-history', 'H04002', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'field-social-anamnesis', 'H04003', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'individual-sociotherapy', 'H04004', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'marital-sociotherapy', 'H04005', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'family-group-sociotherapy', 'H04006', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'family-sociotherapy', 'H04007', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'individual-stress-sociotherapy', 'H04008', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'organized-sociotherapy', 'H04009', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'legal-responsibility-assessment', 'H04010', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cooperation-with-social-protection-and-healthcare-services', 'H04011', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-discharge-team-home-visit-up-to-5-km', 'H09001', 143.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-discharge-team-home-visit-5-to-15-km', 'H09002', 165.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-discharge-team-home-visit-over-15-km', 'H09003', 187.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-discharge-team-home-visit-up-to-5-km', 'H09004', 110.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-discharge-team-home-visit-5-to-15-km', 'H09005', 132.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'follow-up-discharge-team-home-visit-over-15-km', 'H09006', 154.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'methadone-administration', 'X01023', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'high-risk-neonate-and-infant-preventive-examination', 'I01001', 71.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'high-risk-neonate-and-infant-follow-up-examination', 'I01002', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'high-risk-child-preventive-examination', 'I01003', 53.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'high-risk-child-follow-up-examination', 'I01004', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'developmental-disorder-child-preventive-examination', 'I01005', 71.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'developmental-disorder-child-follow-up-examination', 'I01006', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'family-health-education-work', 'I01007', 53.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'parental-developmental-stimulation-training', 'I01008', 18.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'group-health-education-work', 'I01009', 71.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'visit-to-preschools-and-schools', 'I01010', 53.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-pediatric-curative-examination', 'I02001', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-multidisciplinary-patient-workup', 'I02004', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'school-or-kindergarten-pedagogue-consultation-pediatrics', 'I02005', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-articulation-speech-therapy-assessment', 'I03001', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'speech-fluency-assessment', 'I03002', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'speech-development-assessment', 'I03003', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'specific-reading-disorder-assessment', 'I03004', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'combined-logopedic-somatopedic-oligophrenological-psychomotor-assessment', 'I03005', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'developmental-defectology-assessment-small-child', 'I03006', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'developmental-defectology-assessment-school-child', 'I03007', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'articulation-and-motor-speech-therapy-treatment', 'I03008', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'stuttering-speech-therapy', 'I03009', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'underdeveloped-speech-therapy-treatment', 'I03010', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'individual-defectology-speech-therapy-treatment-for-spp', 'I03011', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'psychomotor-instability-defectology-treatment', 'I03012', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'group-defectology-work-with-parent-and-children', 'I03013', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'individual-defectology-treatment-small-child', 'I03014', 26.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'group-defectology-treatment-small-child', 'I03015', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'individual-defectology-treatment-school-child', 'I03016', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'group-defectology-treatment-school-child', 'I03017', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'defectologist-parental-counseling', 'I03018', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'defectologists-findings-and-opinion', 'I03019', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pedagogical-assessment', 'I03020', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'defectology-multidisciplinary-patient-workup', 'I03021', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'learning-disorder-defectology-speech-therapy', 'I03022', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-radiologist-examination', 'J01001', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-head-craniogram', 'J06001', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-lumbar-spine-and-sacrum', 'J06002', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-pelvis', 'J06003', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'foreign-body-localization-x-ray-except-eye', 'J06004', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pharynx-and-larynx-x-ray', 'J06005', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-sternum', 'J06006', 3.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'lung-fluorography', 'J06007', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-chest', 'J06008', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'mediastinum-x-ray', 'J06009', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'heart-teleradiography', 'J06010', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hepatobiliary-tract-x-ray', 'J06011', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-urinary-tract', 'J06012', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-urinary-tract-native', 'J06013', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'mammography', 'J06014', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'x-ray-abdomen-native', 'J06015', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'upper-abdomen-ultrasound', 'J07001', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'lower-abdomen-ultrasound', 'J07002', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'testicular-ultrasound', 'J07003', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-hip-ultrasound', 'J07004', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'joint-and-soft-tissue-ultrasound', 'J07005', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'ultrasound-lymph-nodes', 'J07006', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'ultrasound-thyroid-and-parathyroid-glands', 'J07007', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'breast-ultrasound', 'J07008', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'doppler-neck-blood-vessels', 'J07009', NULL, NULL),
('dom-zdravlja-herceg-novi', 'S', 'doppler-upper-extremity-blood-vessels', 'J07010', NULL, NULL),
('dom-zdravlja-herceg-novi', 'S', 'doppler-lower-extremity-blood-vessels', 'J07011', NULL, NULL),
('dom-zdravlja-herceg-novi', 'S', 'blood-vessels-doppler', 'J07012', NULL, NULL),
('dom-zdravlja-herceg-novi', 'S', 'echocardiography-heart-ultrasound', 'X14002', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'panoramic-dental-radiography', 'J11001', 3.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'intraoral-x-ray', 'J11002', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'panoramic-x-ray', 'J11003', 27.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cephalometric-x-ray', 'J11004', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'first-microbiologist-examination', 'K01001', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'sample-reception-and-sterile-container-distribution', 'K01002', 1.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'microbiology-sample-collection', 'K01003', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'microscopic-examination-of-swab-for-gonorrhea', 'K01004', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'amine-test', 'K01005', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'microscopic-examination-for-treponema-pallidum', 'K01006', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'throat-swab-bacteria', 'K01007', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'oral-cavity-swab-bacteria', 'K01008', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'tongue-swab-bacteria', 'K01009', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'nose-swab-bacteria', 'K01010', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'eye-swab-bacteria', 'K01011', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'bacteriological-examination-ear-swab', 'K01012', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'wound-swab-bacteria', 'K01013', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'umbilicus-swab-bacteria', 'K01014', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'skin-swab-bacteria', 'K01015', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'breast-swab-bacteria', 'K01016', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'vaginal-swab-bacteria', 'K01017', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'vulvar-swab-bacteria', 'K01018', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'glans-swab-bacteria', 'K01019', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'prepuce-swab-bacteria', 'K01020', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urethral-swab-bacteria', 'K01021', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urine-culture', 'K01022', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'stool-culture', 'K01023', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'perianal-swab', 'K01024', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'vibrio-cholerae-culture', 'K01025', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'sputum-bacteria', 'K01026', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'cervical-swab-bacteria', 'K01027', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'antibiogram', 'K01028', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'mycoplasma-hominis-ureaplasma', 'K01029', 15.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'dermatophytes-nail-scraping', 'K01030', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'dermatophytes-skin-scraping', 'K01031', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'dermatophytes-hair-scraping', 'K01032', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'skin-swab-fungi', 'K01033', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'hair-swab-fungi', 'K01034', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'nail-swab-fungi', 'K01035', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'vaginal-swab-fungi', 'K01036', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'vulvar-swab-fungi', 'K01037', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'glans-swab-fungi', 'K01038', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'prepuce-swab-fungi', 'K01039', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urethral-swab-fungi', 'K01040', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'stool-fungi', 'K01041', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urine-fungi', 'K01042', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'nose-swab-fungi', 'K01043', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'sputum-fungi', 'K01044', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'throat-swab-fungi', 'K01045', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'palate-swab-fungi', 'K01046', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'wound-swab-fungi', 'K01047', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'fungal-identification', 'K01048', 22.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'antimycogram', 'K01049', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'trichomonas-test', 'K01050', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'perianal-cellophane-tape-test-pinworm', 'K01051', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'stool-parasites', 'K01052', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'stool-microscopic-examination-for-protozoa', 'K01053', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'native-microscopic-preparation-for-amebae-with-provocation', 'K01054', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'cryptosporidium-in-stool-ziehl-neelsen', 'K01055', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'malaria', 'K01056', 33.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'skin-ectoparasite-identification', 'K01057', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'demodex-species', 'K01058', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'crp-latex-test', 'K01059', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'vdrl', 'K01060', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'asto', 'K01061', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'monosticon', 'K01062', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'tpha-treponema-pallidum', 'K01063', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'direct-microscopic-preparation', 'K01064', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'crp-turbidimetry', 'K01065', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'aso-turbidimetry', 'K01066', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'rheumatoid-factor', 'K01067', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'rheumatoid-factor-turbidimetry', 'K01068', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'waaler-rose-test', 'K01069', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'tongue-swab-fungi', 'K01070', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'antimicrobial-antibody-detection-by-elisa', 'K02001', 14.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'microbial-antigen-detection-by-elisa', 'K02002', 14.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'antimicrobial-antibody-detection-by-indirect-immunofluorescence', 'K02003', 21.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'microbial-antigen-detection-by-direct-immunofluorescence', 'K02004', 21.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'antimicrobial-antibody-detection-by-complement-fixation', 'K02005', 14.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'antimicrobial-antibody-detection-by-hemagglutination', 'K02006', 14.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'antimicrobial-antibody-detection-by-latex-agglutination', 'K02007', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'microbial-antigen-latex-agglutination-test', 'K02008', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'microbial-nucleic-acid-detection-by-hybridization', 'K02009', 48.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hepatitis-a-test', 'HN_KHEPA', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hepatitis-b-test', 'HN_KHEPB', 15.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hepatitis-c-test', 'HN_KHEPC', 15.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'adenovirus-test', 'HN_KADENO', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'blood-count-selected-parameters', 'Z01003', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'leukocyte-formula', 'Z01006', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'platelet-count-microscopic', 'Z01007', 12.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'reticulocytes', 'Z01103', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'erythrocyte-sedimentation-rate', 'Z01008', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'prothrombin-time-pt-inr', 'Z01009', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'bleeding-time', 'Z01010', 9.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'coagulation-time', 'Z01011', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'fibrinogen', 'Z01013', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'potassium', 'Z01032', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'sodium', 'Z01097', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'chloride', 'Z01098', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'ionized-calcium', 'Z01099', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'calcium', 'Z01033', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'iron', 'Z01035', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'fecal-occult-blood', 'Z01090', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'total-protein', 'Z01014', 3.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'total-bilirubin', 'Z01015', 3.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'glucose', 'Z01016', 3.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'oral-glucose-tolerance-test', 'Z01017', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'triglycerides', 'Z01018', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'cholesterol', 'Z01019', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'alkaline-phosphatase', 'Z01021', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'ast', 'Z01023', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'alt', 'Z01096', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'tibc', 'Z01037', 3.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'uibc', 'Z01066', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'ldh', 'Z01104', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'ck-mb', 'Z01025', 26.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'ck', 'Z01024', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'amylase', 'Z01026', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'gamma-gt', 'Z01027', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urea', 'Z01029', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'creatinine', 'Z01030', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'c-reactive-protein', 'Z01088', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'uric-acid', 'Z01031', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'creatinine-in-urine', 'Z01105', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urea-in-urine', 'Z01106', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urea-clearance', 'Z01089', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'creatinine-clearance', 'Z01100', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'uric-acid-in-urine', 'Z01107', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'calcium-in-urine', 'Z01108', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'phosphorus-in-urine', 'Z01102', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'complete-urinalysis', 'Z01039', 9.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urinary-protein-qualitative', 'Z01109', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'protein-in-urine', 'Z01040/Z02098', 2.00, 7.00),
('dom-zdravlja-herceg-novi', 'L', 'bilirubin-in-urine', 'Z01042', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urobilinogen-in-urine', 'Z01101', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'amylase-in-urine', 'Z01063', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'urine-pregnancy-test-hcg-qualitative', 'Z01052', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'complete-urinalysis-with-flow-cytometry', 'Z01084', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'complete-blood-count-with-leukocyte-formula', 'Z02084', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'activated-partial-thromboplastin-time', 'Z02085', 16.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'hdl-cholesterol', 'Z02001', 7.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'ldl-cholesterol', 'Z02094', 3.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'phosphorus', 'Z02004', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'L', 'chloride-in-urine', 'Z02006', 4.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'newborn-and-family-home-patronage-visit', 'L01001', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-patronage-visit-child-age-2', 'L01002', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'home-patronage-visit-child-age-4', 'L01003', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pregnancy-patronage-visit-birth-and-newborn-care-preparation', 'L01007', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'postpartum-patronage-visit', 'L01008', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patronage-visit-for-women-without-gynecological-visit-3-years', 'L01009', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'senior-patronage-visit-over-65', 'L01012', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'chronic-patient-patronage-visit', 'L02001', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'active-tb-patient-patronage-visit', 'L02002', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'immobile-patient-patronage-visit', 'L02003', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'family-health-social-problem-patronage-visit', 'L02004', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'family-with-elderly-or-disabled-member-patronage-visit', 'L02005', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'preventive-action-participation', 'L04001', 61.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'health-education-group-work', 'L04002', 61.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'chronic-patient-health-education', 'L04003', 61.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patronage-nurse-treatment-visit-up-to-5-km', 'L03001', 21.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patronage-nurse-treatment-visit-5-to-15-km', 'L03002', 26.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patronage-nurse-treatment-visit-over-15-km', 'L03003', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patronage-nurse-infusion-visit-up-to-5-km', 'L03004', 31.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patronage-nurse-infusion-visit-5-to-15-km', 'L03005', 36.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patronage-nurse-infusion-visit-over-15-km', 'L03006', 41.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'manual-segmental-massage', 'M01001', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'lymphatic-drainage-complete', 'M01002', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'apparatus-assisted-massage', 'M01003', 6.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'thermotherapy-cryotherapy', 'M01004', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'manual-muscle-test-per-extremity', 'M01005', 6.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'infrared-ultraviolet-and-bioptron-lamp-irradiation', 'M01006', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'thermotherapy-parafango', 'M01007', 6.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'galvanic-therapy', 'M01008', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'electrophoresis', 'M01009', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'diadynamic-currents', 'M01010', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'transcutaneous-electrical-nerve-stimulation-tens', 'M01011', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'ktd-diathermy', 'M01012', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'microwave-diathermy', 'M01013', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'sonophoresis', 'M01014', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'muscle-electrical-stimulation', 'M01015', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'activities-of-daily-living-training', 'M01016', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'gait-exercises', 'M01017', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'gait-training-with-walking-aid', 'M01018', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'gait-coordination-correction-and-balance-automation-exercises', 'M01019', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'breathing-exercises', 'M01020', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'group-exercises-type-b', 'M01021', 2.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'high-risk-infant-stimulation-exercises', 'M01022', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pediatric-play-therapy', 'M01023', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'passive-and-assisted-exercises', 'M01024', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'active-and-resistance-exercises', 'M01025', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'segmental-isometric-exercises', 'M01026', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'kinesiotherapy-for-spine-deformities', 'M01027', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'cns-sensorimotor-development-stimulation', 'M01028', 22.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'activities-of-daily-living-test', 'M01029', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'patient-training-in-specific-protective-body-positions', 'M01030', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'interferential-currents', 'M01031', 11.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'physiotherapist-home-visit-up-to-5-km', 'M01032', 28.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'physiotherapist-home-visit-5-to-15-km', 'M01033', 33.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'physiotherapist-home-visit-over-15-km', 'M01034', 39.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'magnetic-therapy', 'M02008', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'ultrasound-therapy', 'M02009', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'underwater-ultrasound-therapy', 'M02010', 10.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'laser-therapy', 'M02011', 13.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-transport-per-km', 'HN_SANTRANS', 1.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'specialist-examination-internist-surgeon-ophthalmologist', 'HN_SPECEXAM', 24.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'holter-ecg-24h', 'HN_HOLTEREKG', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'holter-blood-pressure-24h', 'HN_HOLTERBP', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hemodialysis-services', 'L61Z', 185.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pre-employment-medical-certificate', 'HN_MR01', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-general-work', 'HN_MR02', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-high-risk-and-difficult-working-conditions', 'HN_MR03', 70.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-difficult-working-conditions-without-high-risk', 'HN_MR04', 50.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-class-a-and-b-drivers', 'HN_MR05', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'driver-class-c-d-e-health-examination', 'HN_MR06', 50.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-driving-instructor-category-b-c-d-e', 'HN_MR07', 60.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-firearms-possession', 'HN_MR08', 70.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-military-service', 'HN_MR09', 60.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-underage-marriage', 'HN_MR10', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-child-adoption', 'HN_MR11', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-study-abroad-and-visa', 'HN_MR12', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-maritime-workers', 'HN_MR13A', 110.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-divers', 'HN_MR13B', 70.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-lifeguards', 'HN_MR13C', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-ionizing-radiation-workers', 'HN_MR14', 85.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-court-expert', 'HN_MR15', 35.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-life-insurance', 'HN_MR16', 40.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-collective-accommodation', 'HN_MR17', 5.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-athletes', 'HN_MR18', 50.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-other-purposes', 'HN_MR19', 60.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pas-test', 'HN_MR20', 30.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'ergometry-stress-test', 'HN_MR21', NULL, NULL),
('dom-zdravlja-herceg-novi', 'S', 'ergocycle-stress-test-with-complete-ecg', 'HN_MR22', NULL, NULL),
('dom-zdravlja-herceg-novi', 'S', 'sanitary-examination-for-food-service-and-healthcare-workers', 'HN_HES01', 32.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'sanitary-examination-for-hairdressers-and-service-personnel', 'HN_HES02', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'tetanus-vaccination', 'HN_HES03', 8.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hepatitis-b-vaccination', 'HN_HES04', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hepatitis-b-immunoglobulin', 'HN_HES05', 88.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'hepatitis-a-vaccination-avaxim', 'HN_HES06', 38.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'rabies-vaccination-verorab', 'HN_HES07', 25.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'rabies-immunoglobulin', 'HN_HES08', 100.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'meningococcal-meningitis-vaccination', 'HN_HES09', 23.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pneumococcal-vaccination-pneumo-23', 'HN_HES10', 26.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'pneumococcal-vaccination-prevenar-13', 'HN_HES11', 83.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'yellow-fever-vaccination', 'HN_HES12', 50.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'mmr-vaccination-priorix', 'HN_HES13', 17.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'polio-vaccination-imovax', 'HN_HES14', 20.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'haemophilus-influenzae-type-b-vaccination', 'HN_HES15', 18.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'influenza-vaccination', 'HN_HES16', 19.00, NULL),
('dom-zdravlja-herceg-novi', 'S', 'tetanus-immunoglobulin', 'HN_HES17', 20.00, NULL);

-- dom-zdravlja-bosko-dedeic-mojkovac: 311 строк (267 услуг, 44 анализов)
INSERT INTO tmp_056_target (clinic_slug, kind, slug, code, price, price_max) VALUES
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'preventive-examination-up-to-age-1', 'MO_A01001', 53.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'preventive-examination-at-age-2', 'MO_A01002', 53.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'preventive-examination-at-age-4', 'MO_A01003', 53.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'preventive-examination-before-primary-school', 'MO_A01004', 64.50, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'primary-school-preventive-examination', 'MO_A01005', 49.47, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'secondary-school-preventive-systematic-examination', 'MO_A01006', 49.47, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'student-systematic-preventive-examination', 'MO_A01007', 49.47, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'systematic-preventive-examination-for-patients-over-65', 'MO_A01008', 49.47, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-examination-after-preventive-examination', 'MO_A01009', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'preventive-examination-of-children-under-15-during-epidemic', 'MO_A01010', 49.47, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pediatric-vaccination-and-revaccination-by-schedule', 'MO_A01011', 15.06, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'influenza-vaccination-for-patients-over-65', 'MO_A01012', 15.06, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'immunoprophylaxis-and-chemoprophylaxis-for-infectious-disease-prevention', 'MO_A01013', 15.06, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'cardiovascular-risk-preventive-examination-adults-over-40', 'MO_A01014', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'breast-cancer-early-detection-examination', 'MO_A01015', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-curative-examination', 'MO_A02001', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-curative-examination', 'MO_A02002', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pre-operative-outpatient-examination-general-anesthesia', 'MO_A02003', 53.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'brief-doctor-visit-without-examination', 'MO_A02004', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-visit-first-curative-examination-up-to-5-km', 'MO_A02005', 75.27, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-visit-first-curative-examination-5-to-15-km', 'MO_A02006', 96.78, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-visit-first-curative-examination-over-15-km', 'MO_A02007', 118.26, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-visit-brief-doctor-visit-up-to-5-km', 'MO_A02008', 64.50, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-visit-follow-up-curative-examination-5-to-15-km', 'MO_A02009', 86.01, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-visit-follow-up-curative-examination-over-15-km', 'MO_A02010', 107.52, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'doctor-visit-for-ipk-workup', 'MO_A02011', 51.06, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'foreign-body-removal-from-ear', 'MO_X01001', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'foreign-body-removal-from-throat', 'MO_X01002', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'foreign-body-removal-from-skin-and-subcutaneous-tissue', 'MO_X01003', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'local-anesthesia-administration', 'MO_X01004', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'cerumen-ear-irrigation', 'MO_X01005', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'oxygen-administration', 'MO_X01006', 5.37, 5.49),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'swab-collection-for-laboratory-analysis', 'MO_X01007', 10.74, 10.98),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'inhalation-therapy', 'MO_X01010', 5.37, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'aspiration-puncture-of-abscess-or-hematoma', 'MO_X01011', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'stoma-care', 'MO_X01012', 5.37, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'artificial-anus-care', 'MO_X01013', 5.37, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'primary-wound-care-without-sutures', 'MO_X01014', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'suture-removal', 'MO_X01015', 5.37, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'fixation-bandage', 'MO_X01018', 5.37, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'immobilization', 'MO_X01019', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'fixation', 'MO_X01020', 5.37, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'subcutaneous-or-intramuscular-injection', 'MO_X01021', 2.70, 2.76),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'burn-wound-care', 'MO_X02002', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'abscess-incision', 'MO_X02003', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'eye-foreign-body-removal-cornea', 'MO_X02004', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'anterior-nasal-packing', 'MO_X02005', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'urinary-catheter-placement', 'MO_X02006', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'enema', 'MO_X02007', 8.07, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'indwelling-catheter-placement', 'MO_X02008', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'intravenous-cannula-placement', 'MO_X02009', 5.37, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ecg', 'MO_X02010', 13.44, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'spirometry', 'MO_X02011', 13.44, 13.74),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'paraphimosis-reduction', 'MO_X02019', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'incarcerated-hernia-reduction', 'MO_X02020', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'atheroma-cyst-xanthoma-or-small-benign-tumor-excision', 'MO_X02021', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'wound-suturing-under-local-anesthesia', 'MO_X03001', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'external-cardiac-defibrillation', 'MO_X03002', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'endotracheal-intubation', 'MO_X03003', 53.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gastric-lavage', 'MO_X03004', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pediatric-hip-ultrasound', 'MO_J07004', 41.82, 49.05),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pregnancy-preventive-examination-first-trimester', 'MO_C01001', 53.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'karyotype-from-amniotic-fluid', 'MO_C01002', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pregnancy-ultrasound', 'MO_C01003', 43.02, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'postpartum-examination-at-6-weeks', 'MO_C01004', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'post-abortion-examination-and-counseling', 'MO_C01005', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'post-ectopic-pregnancy-examination-and-counseling', 'MO_C01006', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'reproductive-age-women-preventive-examination-with-pap-test', 'MO_C01007', 43.02, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-specialist-curative-gynecological-examination', 'MO_C02001', 32.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-specialist-curative-gynecological-examination', 'MO_C02002', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'brief-gynecologist-visit-without-examination', 'MO_C02003', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'mechanical-contraceptive-device-check', 'MO_X01017', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'cervical-drug-application', 'MO_X01024', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'iud-insertion', 'MO_X01025', 10.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'iud-removal', 'MO_X01026', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'colposcopy', 'MO_X02016', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'bartholin-gland-and-vulva-incision-and-drainage', 'MO_X02017', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'vulvar-and-vaginal-condyloma-abrasion', 'MO_X02018', 21.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'vulva-biopsy-with-lab-analysis', 'MO_X03005', 25.80, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'cervical-biopsy-with-lab-analysis', 'MO_X03006', 25.80, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'endometrial-biopsy-with-lab-analysis', 'MO_X03007', 25.80, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'cervical-or-uterine-polypectomy', 'MO_X03008', 25.80, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'amnioscopy', 'MO_X03009', 25.80, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gynecological-ultrasound', 'MO_X03010', 43.02, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pregnancy-cardiotocography-ctg', 'MO_X03013', 25.80, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'tuberculin-skin-test', 'MO_G01001', 11.34, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'adult-examination-for-registered-tb', 'MO_G01002', 45.33, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'tb-contact-tracing-examination', 'MO_G01003', 45.33, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patient-examination-with-chemoprophylaxis', 'MO_G01004', 45.33, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-pulmonologist-curative-examination', 'MO_G02001', 45.33, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-pulmonologist-curative-examination', 'MO_G02002', 34.02, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'sputum-collection-for-bacterial-and-fungal-analysis', 'MO_X01008', 2.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'inhalation-tb-center', 'MO_X01010', 5.49, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'directly-observed-treatment-for-tb-dots', 'MO_X01022', 2.46, 2.76),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'prick-test-inhalation-allergens', 'MO_X02001', 38.46, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'bronchodilator-test', 'MO_X02012', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pleural-puncture', 'MO_X02013', 43.98, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'thoracentesis', 'MO_X02014', 43.98, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'evacuation-pleural-puncture', 'MO_X02015', 43.98, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'sputum-collection-for-cytology', 'MO_X03011', 2.76, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-psychiatrist-examination', 'MO_H01001', 81.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-psychiatrist-examination', 'MO_H01002', 54.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'brief-psychiatrist-visit-without-examination', 'MO_H01003', 27.18, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'individual-supportive-psychotherapy-and-counseling', 'MO_H01004', 54.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'additional-individual-therapy', 'MO_H01005', 81.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'group-psychodynamic-and-sociodynamic-therapy', 'MO_H01006', 217.41, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'group-psychotherapy-session-for-addictions', 'MO_H01007', 217.41, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'family-psychotherapy-session', 'MO_H01008', 163.05, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'analytically-oriented-depth-psychotherapy-session', 'MO_H01009', 108.69, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'behavioral-psychotherapy', 'MO_H01010', 108.69, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'relaxation-technique', 'MO_H01011', 90.60, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'brief-psychodiagnostic-interview', 'MO_H01012', 27.18, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pediatric-psychomotor-development-assessment', 'MO_H01013', 163.05, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'brief-pediatric-intellectual-status-test-under-15', 'MO_H01014', 81.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'brief-adult-intellectual-status-test', 'MO_H01015', 54.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pediatric-personality-structure-assessment-under-15', 'MO_H01016', 144.93, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'personality-structure-assessment-for-adults', 'MO_H01017', 90.60, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pediatric-individual-function-clinical-testing-under-15', 'MO_H01018', 45.30, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'adult-individual-function-clinical-testing', 'MO_H01019', 25.68, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'results-processing-integration-and-report-writing', 'MO_H01020', 217.41, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'heteroanamnesis', 'MO_H01021', 27.18, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'family-counseling', 'MO_H01022', 27.18, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'multidisciplinary-team-patient-consultation', 'MO_H01023', 54.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'psychologist-interview', 'MO_H02001', 39.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'psychological-testing-category-a', 'MO_H02002', 39.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'psychological-testing-category-b', 'MO_H02003', 65.88, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'psychological-testing-category-c', 'MO_H02004', 105.42, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'psychological-testing-category-d', 'MO_H02005', 158.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'organicity-assessment', 'MO_H02006', 158.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'special-needs-child-diagnostic-interview', 'MO_H02007', 79.05, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'goodenough-intelligence-test-for-special-needs-children-under-14', 'MO_H02008', 29.64, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'binet-simon-intelligence-test-for-special-needs-children-under-14', 'MO_H02009', 37.89, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'revisk-intelligence-test-for-special-needs-children-under-14', 'MO_H02010', 33.75, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'progressive-matrices-test-for-special-needs-children-under-14', 'MO_H02011', 46.11, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'viti-test-for-special-needs-children-under-14', 'MO_H02012', 37.89, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'wechsler-bellevue-test-for-special-needs-children-over-14', 'MO_H02013', 37.89, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'special-needs-child-psychomotor-development-assessment', 'MO_H02014', 33.75, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'special-needs-child-social-maturity-assessment', 'MO_H02015', 29.64, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'multidisciplinary-developmental-disorder-patient-workup', 'MO_H02016', 42.00, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'play-diagnostic-assessment', 'MO_H02017', 29.64, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'special-needs-child-personality-tests-underdeveloped', 'MO_H02018', 37.89, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'special-needs-child-family-drawing-test', 'MO_H02019', 29.64, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'special-needs-child-ego-perception-test', 'MO_H02020', 37.89, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'parental-counseling-work', 'MO_H02021', 42.00, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'school-or-kindergarten-pedagogue-counseling', 'MO_H02022', 21.42, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'data-processing', 'MO_H02023', 29.64, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'results-integration-and-report-writing', 'MO_H02024', 158.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'individual-supportive-therapy', 'MO_H02025', 42.00, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-discharge-team-home-visit-up-to-5-km', 'MO_H09001', 224.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-discharge-team-home-visit-5-to-15-km', 'MO_H09002', 259.41, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-discharge-team-home-visit-over-15-km', 'MO_H09003', 294.00, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-discharge-team-home-visit-up-to-5-km', 'MO_H09004', 172.95, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-discharge-team-home-visit-5-to-15-km', 'MO_H09005', 207.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'follow-up-discharge-team-home-visit-over-15-km', 'MO_H09006', 242.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'methadone-administration', 'MO_X01023', 4.95, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'first-radiologist-examination', 'MO_J01001', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-head-craniogram', 'MO_J06001', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-lumbar-spine-and-sacrum', 'MO_J06002', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-pelvis', 'MO_J06003', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'foreign-body-localization-x-ray-except-eye', 'MO_J06004', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pharynx-and-larynx-x-ray', 'MO_J06005', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-sternum', 'MO_J06006', 2.58, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'lung-fluorography', 'MO_J06007', 5.16, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-chest', 'MO_J06008', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'mediastinum-x-ray', 'MO_J06009', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'heart-teleradiography', 'MO_J06010', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hepatobiliary-tract-x-ray', 'MO_J06011', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-urinary-tract', 'MO_J06012', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-urinary-tract-native', 'MO_J06013', 5.16, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'mammography', 'MO_J06014', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'x-ray-abdomen-native', 'MO_J06015', 7.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'upper-abdomen-ultrasound', 'MO_J07001', 41.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'lower-abdomen-ultrasound', 'MO_J07002', 41.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'testicular-ultrasound', 'MO_J07003', 41.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'joint-and-soft-tissue-ultrasound', 'MO_J07005', 41.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ultrasound-lymph-nodes', 'MO_J07006', 41.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ultrasound-thyroid-and-parathyroid-glands', 'MO_J07007', 41.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'breast-ultrasound', 'MO_J07008', 41.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'panoramic-dental-radiography', 'MO_J11001', 3.93, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'intraoral-x-ray', 'MO_J11002', 3.93, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'panoramic-x-ray', 'MO_J11003', 31.38, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'cephalometric-x-ray', 'MO_J11004', 5.88, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'newborn-and-family-home-patronage-visit', 'MO_L01001', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-patronage-visit-child-age-2', 'MO_L01002', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'home-patronage-visit-child-age-4', 'MO_L01003', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pregnancy-patronage-visit-birth-and-newborn-care-preparation', 'MO_L01007', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'postpartum-patronage-visit', 'MO_L01008', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patronage-visit-for-women-without-gynecological-visit-3-years', 'MO_L01009', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'senior-patronage-visit-over-65', 'MO_L01012', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'chronic-patient-patronage-visit', 'MO_L02001', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'active-tb-patient-patronage-visit', 'MO_L02002', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'immobile-patient-patronage-visit', 'MO_L02003', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'family-health-social-problem-patronage-visit', 'MO_L02004', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'family-with-elderly-or-disabled-member-patronage-visit', 'MO_L02005', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patronage-nurse-treatment-visit-up-to-5-km', 'MO_L03001', 22.26, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patronage-nurse-treatment-visit-5-to-15-km', 'MO_L03002', 27.81, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patronage-nurse-treatment-visit-over-15-km', 'MO_L03003', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patronage-nurse-infusion-visit-up-to-5-km', 'MO_L03004', 33.36, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patronage-nurse-infusion-visit-5-to-15-km', 'MO_L03005', 38.94, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patronage-nurse-infusion-visit-over-15-km', 'MO_L03006', 44.49, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'preventive-action-participation', 'MO_L04001', 66.75, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'health-education-group-work', 'MO_L04002', 66.75, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'chronic-patient-health-education', 'MO_L04003', 66.75, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'manual-segmental-massage', 'MO_M01001', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'lymphatic-drainage-complete', 'MO_M01002', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'apparatus-assisted-massage', 'MO_M01003', 6.87, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'thermotherapy-cryotherapy', 'MO_M01004', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'manual-muscle-test-per-extremity', 'MO_M01005', 6.87, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'infrared-ultraviolet-and-bioptron-lamp-irradiation', 'MO_M01006', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'thermotherapy-parafango', 'MO_M01007', 6.87, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'galvanic-therapy', 'MO_M01008', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'electrophoresis', 'MO_M01009', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'diadynamic-currents', 'MO_M01010', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'transcutaneous-electrical-nerve-stimulation-tens', 'MO_M01011', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ktd-diathermy', 'MO_M01012', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'microwave-diathermy', 'MO_M01013', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'sonophoresis', 'MO_M01014', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'muscle-electrical-stimulation', 'MO_M01015', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'activities-of-daily-living-training', 'MO_M01016', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gait-exercises', 'MO_M01017', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gait-training-with-walking-aid', 'MO_M01018', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gait-coordination-correction-and-balance-automation-exercises', 'MO_M01019', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'breathing-exercises', 'MO_M01020', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'group-exercises-type-b', 'MO_M01021', 2.07, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'high-risk-infant-stimulation-exercises', 'MO_M01022', 30.93, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'pediatric-play-therapy', 'MO_M01023', 20.61, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'passive-and-assisted-exercises', 'MO_M01024', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'active-and-resistance-exercises', 'MO_M01025', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'segmental-isometric-exercises', 'MO_M01026', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'kinesiotherapy-for-spine-deformities', 'MO_M01027', 20.61, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'cns-sensorimotor-development-stimulation', 'MO_M01028', 27.48, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'activities-of-daily-living-test', 'MO_M01029', 20.61, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patient-training-in-specific-protective-body-positions', 'MO_M01030', 20.61, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'interferential-currents', 'MO_M01031', 13.74, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'physiotherapist-home-visit-up-to-5-km', 'MO_M01032', 34.35, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'physiotherapist-home-visit-5-to-15-km', 'MO_M01033', 41.22, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'physiotherapist-home-visit-over-15-km', 'MO_M01034', 48.09, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'magnetic-therapy', 'MO_M02008', 12.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ultrasound-therapy', 'MO_M02009', 8.34, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'underwater-ultrasound-therapy', 'MO_M02010', 10.02, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'laser-therapy', 'MO_M02011', 12.51, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'blood-count-selected-parameters', 'MO_Z01003', 3.81, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'leukocyte-formula', 'MO_Z01006', 12.06, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'erythrocyte-sedimentation-rate', 'MO_Z01008', 5.31, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'prothrombin-time-pt-inr', 'MO_Z01009', 10.47, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'bleeding-time', 'MO_Z01010', 8.67, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'coagulation-time', 'MO_Z01011', 15.69, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'fibrinogen', 'MO_Z01013', 13.26, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'potassium', 'MO_Z01032', 3.78, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'sodium', 'MO_Z01097', 3.78, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'chloride', 'MO_Z01098', 3.78, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'ionized-calcium', 'MO_Z01099', 8.19, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'calcium', 'MO_Z01033', 3.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'iron', 'MO_Z01035', 4.11, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'fecal-occult-blood', 'MO_Z01090', 5.22, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'total-protein', 'MO_Z01014', 3.45, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'total-bilirubin', 'MO_Z01015', 3.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'direct-bilirubin', 'MO_Z01064', 3.54, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'glucose', 'MO_Z01016', 3.48, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'oral-glucose-tolerance-test', 'MO_Z01017', 12.60, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'triglycerides', 'MO_Z01018', 4.08, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'cholesterol', 'MO_Z01019', 3.72, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'alkaline-phosphatase', 'MO_Z01021', 3.78, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'ast', 'MO_Z01023', 3.84, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'alt', 'MO_Z01096', 3.84, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'tibc', 'MO_Z01037', 2.94, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'uibc', 'MO_Z01066', 4.14, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'ldh', 'MO_Z01104', 3.81, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'ck-mb', 'MO_Z01025', 25.80, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'ck', 'MO_Z01024', 4.68, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'amylase', 'MO_Z01026', 5.43, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'gamma-gt', 'MO_Z01027', 4.02, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'urea', 'MO_Z01029', 3.72, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'creatinine', 'MO_Z01030', 3.57, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'c-reactive-protein', 'MO_Z01088', 10.32, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'uric-acid', 'MO_Z01031', 4.20, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'creatinine-clearance', 'MO_Z01100', 4.20, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'complete-urinalysis', 'MO_Z01039', 8.82, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'urinary-protein-qualitative', 'MO_Z01109', 2.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'bilirubin-in-urine', 'MO_Z01042', 2.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'urobilinogen-in-urine', 'MO_Z01101', 2.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'amylase-in-urine', 'MO_Z01063', 5.43, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'urine-pregnancy-test-hcg-qualitative', 'MO_Z01052', 10.50, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'complete-urinalysis-with-flow-cytometry', 'MO_Z01084', 11.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'sample-reception-and-sterile-container-distribution', 'MO_K01002', 1.62, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'microbiology-sample-collection', 'MO_K01003', 2.70, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'medical-transport-per-km', 'MO_SANTRANS_KM', NULL, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-degenerative-nervous-system-disorders-with-moderate-cc', 'MO_DRG_B67B', 3192.75, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-otitis-media-and-upper-respiratory-tract-infection', 'MO_DRG_D63Z', 969.23, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-laryngotracheitis-and-epiglottitis', 'MO_DRG_D64Z', 703.18, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-respiratory-infections-without-cc', 'MO_DRG_E62C', 1539.38, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-bronchitis-and-asthma-without-cc', 'MO_DRG_E69B', 969.23, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-respiratory-infections-with-severe-or-moderate-cc', 'MO_DRG_E62B', 2793.65, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-copd-without-very-severe-or-severe-cc', 'MO_DRG_E65B', 2318.55, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-bronchitis-and-asthma-with-cc', 'MO_DRG_E69A', 2128.50, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-respiratory-neoplasms-with-very-severe-cc', 'MO_DRG_E71A', 4390.05, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-respiratory-neoplasms-without-very-severe-cc', 'MO_DRG_E71B', 2223.53, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-uncomplicated-peptic-ulcer', 'MO_DRG_G63Z', 817.20, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-biliary-system-disorders-without-cc', 'MO_DRG_H64B', 1064.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-minor-skin-disorders', 'MO_DRG_J67A', 1729.40, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-major-skin-disorders-without-very-severe-or-severe-cc', 'MO_DRG_J68B', 2356.55, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-skin-ulcer-without-very-severe-cc', 'MO_DRG_J60B', 3591.85, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-major-skin-disorders-same-day', 'MO_DRG_J68C', 437.10, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-malignant-skin-lesions-with-very-severe-cc', 'MO_DRG_J69A', 5302.25, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-diabetes-without-very-severe-or-severe-cc', 'MO_DRG_K60B', 1786.43, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-kidney-and-urinary-tract-infection-without-very-severe-or-severe-cc', 'MO_DRG_L63B', 1368.33, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-other-kidney-and-urinary-system-disorders-without-very-severe-or-sever', 'MO_DRG_L67B', 874.20, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-male-reproductive-system-malignancy-with-very-severe-or-severe-cc', 'MO_DRG_M60A', 3230.78, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-menstrual-and-other-female-reproductive-disorders', 'MO_DRG_N62Z', 627.15, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-female-reproductive-system-infections', 'MO_DRG_N61Z', 1159.28, NULL),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'hospitalization-for-fever-of-unknown-origin-without-cc', 'MO_DRG_T62B', 1083.25, NULL);

DROP TEMPORARY TABLE IF EXISTS tmp_056_remove;
CREATE TEMPORARY TABLE tmp_056_remove (
	clinic_slug VARCHAR(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	why VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	PRIMARY KEY (clinic_slug, kind, slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
-- dom-zdravlja-herceg-novi: 57
INSERT INTO tmp_056_remove (clinic_slug, kind, slug, why) VALUES
('dom-zdravlja-herceg-novi', 'S', 'ctg-fetal-monitoring', 'HN_GX03013: в PDF X03013 — S:pregnancy-cardiotocography-ctg'),
('dom-zdravlja-herceg-novi', 'S', 'lung-fluoroscopy', 'HN_J06007: в PDF J06007 — S:lung-fluorography'),
('dom-zdravlja-herceg-novi', 'S', 'foreign-body-removal-from-nose', 'HN_X01003: в PDF X01003 — S:foreign-body-removal-from-skin-and-subcutaneous-tissue'),
('dom-zdravlja-herceg-novi', 'S', 'anterior-hematoma-puncture', 'HN_X01011: в PDF X01011 — S:aspiration-puncture-of-abscess-or-hematoma'),
('dom-zdravlja-herceg-novi', 'S', 'gastrostomy-site-care', 'HN_X01012: в PDF X01012 — S:stoma-care'),
('dom-zdravlja-herceg-novi', 'S', 'enema-administration-medium', 'HN_X02007: в PDF X02007 — S:enema'),
('dom-zdravlja-herceg-novi', 'S', 'gastric-sounding-and-lavage', 'HN_X02008: в PDF X02008 — S:indwelling-catheter-placement'),
('dom-zdravlja-herceg-novi', 'S', 'vaginal-suppository-application', 'HN_GX01023: позиции нет в PDF'),
('dom-zdravlja-herceg-novi', 'S', 'enema-administration-tb-center', 'HN_TBCX01006: в PDF X01006 — S:oxygen-administration'),
('dom-zdravlja-herceg-novi', 'S', 'swab-collection-for-tb-analysis', 'HN_TBCX01007: в PDF X01007 — S:swab-collection-for-laboratory-analysis'),
('dom-zdravlja-herceg-novi', 'S', 'local-drug-application-subcutaneous-intramuscular-tb', 'HN_TBCX01021: в PDF X01021 — S:subcutaneous-or-intramuscular-injection'),
('dom-zdravlja-herceg-novi', 'S', 'fluoroscopy-examination', 'HN_TBCX02013D: в PDF X02013 — S:pleural-puncture'),
('dom-zdravlja-herceg-novi', 'S', 'speech-therapy-preventive-examination', 'без кода: позиции нет в PDF'),
('dom-zdravlja-herceg-novi', 'S', 'targeted-skull-region-x-ray-per-image', 'HN_J06002: в PDF J06002 — S:x-ray-lumbar-spine-and-sacrum'),
('dom-zdravlja-herceg-novi', 'S', 'paranasal-sinus-x-ray-per-image', 'HN_J06003: в PDF J06003 — S:x-ray-pelvis'),
('dom-zdravlja-herceg-novi', 'S', 'extremity-x-ray-per-image', 'HN_J06005: в PDF J06005 — S:pharynx-and-larynx-x-ray'),
('dom-zdravlja-herceg-novi', 'S', 'chest-ribs-or-sternum-x-ray-per-view', 'HN_J06006: в PDF J06006 — S:x-ray-sternum'),
('dom-zdravlja-herceg-novi', 'S', 'endodontic-canal-contrast-radiography', 'HN_J11004: в PDF J11004 — S:cephalometric-x-ray'),
('dom-zdravlja-herceg-novi', 'S', 'vaginal-smear-microscopy', 'HN_K01051: в PDF K01051 — L:perianal-cellophane-tape-test-pinworm'),
('dom-zdravlja-herceg-novi', 'S', 'joint-fluid-native-preparation', 'HN_K01054: в PDF K01054 — L:native-microscopic-preparation-for-amebae-with-provocation'),
('dom-zdravlja-herceg-novi', 'S', 'complete-blood-count-with-differential', 'HN_Z01003: в PDF Z01003 — L:blood-count-selected-parameters'),
('dom-zdravlja-herceg-novi', 'S', 'fecal-occult-blood-qualitative', 'HN_Z01103F: в PDF Z01090 — L:fecal-occult-blood'),
('dom-zdravlja-herceg-novi', 'S', 'alpha-amylase-activity', 'HN_Z01028: в PDF Z01026 — L:amylase'),
('dom-zdravlja-herceg-novi', 'S', 'serum-urea-kinetic', 'HN_Z01108S: в PDF Z01029 — L:urea'),
('dom-zdravlja-herceg-novi', 'S', 'serum-creatinine', 'HN_Z01038: в PDF Z01030 — L:creatinine'),
('dom-zdravlja-herceg-novi', 'S', 'c-reactive-protein-crp', 'HN_Z01040S: в PDF Z01088 — L:c-reactive-protein'),
('dom-zdravlja-herceg-novi', 'S', 'urine-protein-qualitative', 'HN_Z01109: в PDF Z01109 — L:urinary-protein-qualitative'),
('dom-zdravlja-herceg-novi', 'S', 'urine-protein-quantitative', 'HN_Z01040U: в PDF Z01040/Z02098 — L:protein-in-urine'),
('dom-zdravlja-herceg-novi', 'S', 'urine-hcg-strip-test', 'HN_Z01072: в PDF Z01052 — L:urine-pregnancy-test-hcg-qualitative'),
('dom-zdravlja-herceg-novi', 'S', 'ldl-cholesterol-calculated', 'HN_Z02094: в PDF Z02094 — L:ldl-cholesterol'),
('dom-zdravlja-herceg-novi', 'S', 'ultraviolet-and-biogenic-lamp-treatment', 'HN_M01006: в PDF M01006 — S:infrared-ultraviolet-and-bioptron-lamp-irradiation'),
('dom-zdravlja-herceg-novi', 'S', 'back-exercises', 'HN_M01017: в PDF M01017 — S:gait-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'coordination-and-balance-exercises', 'HN_M01019: в PDF M01019 — S:gait-coordination-correction-and-balance-automation-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'group-exercises-type-a', 'HN_M01020: в PDF M01020 — S:breathing-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'segmental-isokinetic-exercises', 'HN_M01026: в PDF M01026 — S:segmental-isometric-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'activities-of-daily-living-adl-test', 'HN_M01029: в PDF M01029 — S:activities-of-daily-living-test'),
('dom-zdravlja-herceg-novi', 'S', 'patient-body-posture-training', 'HN_M01030: в PDF M01030 — S:patient-training-in-specific-protective-body-positions'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-low-risk-work', 'HN_MR01: в PDF MR01 — S:pre-employment-medical-certificate'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-low-risk-work-with-examination', 'HN_MR02: в PDF MR02 — S:medical-certificate-for-general-work'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-high-risk-work', 'HN_MR03: в PDF MR03 — S:medical-certificate-for-high-risk-and-difficult-working-conditions'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-significant-risk-work', 'HN_MR04: в PDF MR04 — S:medical-certificate-for-difficult-working-conditions-without-high-risk'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-educational-institutions', 'HN_MR07: в PDF MR07 — S:medical-certificate-for-driving-instructor-category-b-c-d-e'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-visits-montenegro', 'HN_MR08: в PDF MR08 — S:medical-certificate-for-firearms-possession'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-foreign-marriage', 'HN_MR09: в PDF MR09 — S:medical-certificate-for-military-service'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-special-course', 'HN_MR10: в PDF MR10 — S:medical-certificate-for-underage-marriage'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-licensing', 'HN_MR11: в PDF MR11 — S:medical-certificate-for-child-adoption'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-continued-education', 'HN_MR12: в PDF MR12 — S:medical-certificate-for-study-abroad-and-visa'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-pension', 'HN_MR13A: в PDF MR13A — S:medical-certificate-for-maritime-workers'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-disability-suspicion', 'HN_MR13B: в PDF MR13B — S:medical-certificate-for-divers'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-observation', 'HN_MR13C: в PDF MR13C — S:medical-certificate-for-lifeguards'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-psychotropic-work-monitoring', 'HN_MR14: в PDF MR14 — S:medical-certificate-for-ionizing-radiation-workers'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-prison-visit', 'HN_MR15: в PDF MR15 — S:medical-certificate-for-court-expert'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-special-treatment', 'HN_MR17: в PDF MR17 — S:medical-certificate-for-collective-accommodation'),
('dom-zdravlja-herceg-novi', 'S', 'typhoid-vaccination-vivotif', 'HN_BES07: в PDF HN_HES07 — S:rabies-vaccination-verorab'),
('dom-zdravlja-herceg-novi', 'S', 'typhoid-immunoglobulin', 'HN_BES08: в PDF HN_HES08 — S:rabies-immunoglobulin'),
('dom-zdravlja-herceg-novi', 'L', 'sperm-culture-fungi', 'HN_K01040: в PDF K01040 — L:urethral-swab-fungi'),
('dom-zdravlja-herceg-novi', 'L', 'single-psychoactive-substance-test', 'HN_Z02093: позиции нет в PDF');
-- dom-zdravlja-bosko-dedeic-mojkovac: 30
INSERT INTO tmp_056_remove (clinic_slug, kind, slug, why) VALUES
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ctg-fetal-monitoring', 'MO_HN_GX03013: в PDF X03013 — S:pregnancy-cardiotocography-ctg'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'lung-fluoroscopy', 'MO_HN_J06007: в PDF J06007 — S:lung-fluorography'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'foreign-body-removal-from-nose', 'MO_HN_X01003: в PDF X01003 — S:foreign-body-removal-from-skin-and-subcutaneous-tissue'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'anterior-hematoma-puncture', 'MO_HN_X01011: в PDF X01011 — S:aspiration-puncture-of-abscess-or-hematoma'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gastrostomy-site-care', 'MO_HN_X01012: в PDF X01012 — S:stoma-care'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'enema-administration-medium', 'MO_HN_X02007: в PDF X02007 — S:enema'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gastric-sounding-and-lavage', 'MO_HN_X02008: в PDF X02008 — S:indwelling-catheter-placement'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'vaginal-suppository-application', 'MO_HN_GX01023: позиции нет в PDF'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'fluoroscopy-examination', 'MO_HN_TBCX02013D: в PDF X02013 — S:pleural-puncture'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'targeted-skull-region-x-ray-per-image', 'MO_HN_J06002: в PDF J06002 — S:x-ray-lumbar-spine-and-sacrum'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'paranasal-sinus-x-ray-per-image', 'MO_HN_J06003: в PDF J06003 — S:x-ray-pelvis'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'extremity-x-ray-per-image', 'MO_HN_J06005: в PDF J06005 — S:pharynx-and-larynx-x-ray'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'chest-ribs-or-sternum-x-ray-per-view', 'MO_HN_J06006: в PDF J06006 — S:x-ray-sternum'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'complete-blood-count-with-differential', 'MO_HN_Z01003: в PDF Z01003 — L:blood-count-selected-parameters'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'fecal-occult-blood-qualitative', 'MO_HN_Z01103F: в PDF MO_Z01090 — L:fecal-occult-blood'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'alpha-amylase-activity', 'MO_HN_Z01028: в PDF MO_Z01026 — L:amylase'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'serum-urea-kinetic', 'MO_HN_Z01108S: в PDF MO_Z01029 — L:urea'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'serum-creatinine', 'MO_HN_Z01038: в PDF MO_Z01030 — L:creatinine'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'c-reactive-protein-crp', 'MO_HN_Z01040S: в PDF MO_Z01088 — L:c-reactive-protein'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'urine-protein-qualitative', 'MO_HN_Z01109: в PDF Z01109 — L:urinary-protein-qualitative'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'urine-hcg-strip-test', 'MO_HN_Z01072: в PDF MO_Z01052 — L:urine-pregnancy-test-hcg-qualitative'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ultraviolet-and-biogenic-lamp-treatment', 'MO_HN_M01006: в PDF M01006 — S:infrared-ultraviolet-and-bioptron-lamp-irradiation'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'back-exercises', 'MO_HN_M01017: в PDF M01017 — S:gait-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'coordination-and-balance-exercises', 'MO_HN_M01019: в PDF M01019 — S:gait-coordination-correction-and-balance-automation-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'group-exercises-type-a', 'MO_HN_M01020: в PDF M01020 — S:breathing-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'segmental-isokinetic-exercises', 'MO_HN_M01026: в PDF M01026 — S:segmental-isometric-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'activities-of-daily-living-adl-test', 'MO_HN_M01029: в PDF M01029 — S:activities-of-daily-living-test'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patient-body-posture-training', 'MO_HN_M01030: в PDF M01030 — S:patient-training-in-specific-protective-body-positions'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'sanitary-patient-transport-per-kilometer', 'MO_SANTRANS_KM: в PDF SANTRANS_KM — S:medical-transport-per-km'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'L', 'reticulocytes', 'MO_HN_Z01103: в PDF Z01103 с ценой 0 / 0');

-- перенос: со снимаемой записи (from) на правильную (to) — тот же код PDF; нужен для флагов is_price_outdated/is_obsolete
-- новой строки и для привязок врачей (clinic_medical_service_doctors)
DROP TEMPORARY TABLE IF EXISTS tmp_056_moves;
CREATE TEMPORARY TABLE tmp_056_moves (
	clinic_slug VARCHAR(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	from_kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	from_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	to_kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	to_slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	from_id INT NULL,
	to_id INT NULL,
	PRIMARY KEY (clinic_slug, from_kind, from_slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
INSERT INTO tmp_056_moves (clinic_slug, from_kind, from_slug, to_kind, to_slug) VALUES
('dom-zdravlja-herceg-novi', 'S', 'ctg-fetal-monitoring', 'S', 'pregnancy-cardiotocography-ctg'),
('dom-zdravlja-herceg-novi', 'S', 'lung-fluoroscopy', 'S', 'lung-fluorography'),
('dom-zdravlja-herceg-novi', 'S', 'foreign-body-removal-from-nose', 'S', 'foreign-body-removal-from-skin-and-subcutaneous-tissue'),
('dom-zdravlja-herceg-novi', 'S', 'anterior-hematoma-puncture', 'S', 'aspiration-puncture-of-abscess-or-hematoma'),
('dom-zdravlja-herceg-novi', 'S', 'gastrostomy-site-care', 'S', 'stoma-care'),
('dom-zdravlja-herceg-novi', 'S', 'enema-administration-medium', 'S', 'enema'),
('dom-zdravlja-herceg-novi', 'S', 'gastric-sounding-and-lavage', 'S', 'indwelling-catheter-placement'),
('dom-zdravlja-herceg-novi', 'S', 'enema-administration-tb-center', 'S', 'oxygen-administration'),
('dom-zdravlja-herceg-novi', 'S', 'swab-collection-for-tb-analysis', 'S', 'swab-collection-for-laboratory-analysis'),
('dom-zdravlja-herceg-novi', 'S', 'local-drug-application-subcutaneous-intramuscular-tb', 'S', 'subcutaneous-or-intramuscular-injection'),
('dom-zdravlja-herceg-novi', 'S', 'fluoroscopy-examination', 'S', 'pleural-puncture'),
('dom-zdravlja-herceg-novi', 'S', 'targeted-skull-region-x-ray-per-image', 'S', 'x-ray-lumbar-spine-and-sacrum'),
('dom-zdravlja-herceg-novi', 'S', 'paranasal-sinus-x-ray-per-image', 'S', 'x-ray-pelvis'),
('dom-zdravlja-herceg-novi', 'S', 'extremity-x-ray-per-image', 'S', 'pharynx-and-larynx-x-ray'),
('dom-zdravlja-herceg-novi', 'S', 'chest-ribs-or-sternum-x-ray-per-view', 'S', 'x-ray-sternum'),
('dom-zdravlja-herceg-novi', 'S', 'endodontic-canal-contrast-radiography', 'S', 'cephalometric-x-ray'),
('dom-zdravlja-herceg-novi', 'S', 'vaginal-smear-microscopy', 'L', 'perianal-cellophane-tape-test-pinworm'),
('dom-zdravlja-herceg-novi', 'S', 'joint-fluid-native-preparation', 'L', 'native-microscopic-preparation-for-amebae-with-provocation'),
('dom-zdravlja-herceg-novi', 'S', 'complete-blood-count-with-differential', 'L', 'blood-count-selected-parameters'),
('dom-zdravlja-herceg-novi', 'S', 'fecal-occult-blood-qualitative', 'L', 'fecal-occult-blood'),
('dom-zdravlja-herceg-novi', 'S', 'alpha-amylase-activity', 'L', 'amylase'),
('dom-zdravlja-herceg-novi', 'S', 'serum-urea-kinetic', 'L', 'urea'),
('dom-zdravlja-herceg-novi', 'S', 'serum-creatinine', 'L', 'creatinine'),
('dom-zdravlja-herceg-novi', 'S', 'c-reactive-protein-crp', 'L', 'c-reactive-protein'),
('dom-zdravlja-herceg-novi', 'S', 'urine-protein-qualitative', 'L', 'urinary-protein-qualitative'),
('dom-zdravlja-herceg-novi', 'S', 'urine-protein-quantitative', 'L', 'protein-in-urine'),
('dom-zdravlja-herceg-novi', 'S', 'urine-hcg-strip-test', 'L', 'urine-pregnancy-test-hcg-qualitative'),
('dom-zdravlja-herceg-novi', 'S', 'ldl-cholesterol-calculated', 'L', 'ldl-cholesterol'),
('dom-zdravlja-herceg-novi', 'S', 'ultraviolet-and-biogenic-lamp-treatment', 'S', 'infrared-ultraviolet-and-bioptron-lamp-irradiation'),
('dom-zdravlja-herceg-novi', 'S', 'back-exercises', 'S', 'gait-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'coordination-and-balance-exercises', 'S', 'gait-coordination-correction-and-balance-automation-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'group-exercises-type-a', 'S', 'breathing-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'segmental-isokinetic-exercises', 'S', 'segmental-isometric-exercises'),
('dom-zdravlja-herceg-novi', 'S', 'activities-of-daily-living-adl-test', 'S', 'activities-of-daily-living-test'),
('dom-zdravlja-herceg-novi', 'S', 'patient-body-posture-training', 'S', 'patient-training-in-specific-protective-body-positions'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-low-risk-work', 'S', 'pre-employment-medical-certificate'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-low-risk-work-with-examination', 'S', 'medical-certificate-for-general-work'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-high-risk-work', 'S', 'medical-certificate-for-high-risk-and-difficult-working-conditions'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-significant-risk-work', 'S', 'medical-certificate-for-difficult-working-conditions-without-high-risk'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-educational-institutions', 'S', 'medical-certificate-for-driving-instructor-category-b-c-d-e'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-visits-montenegro', 'S', 'medical-certificate-for-firearms-possession'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-foreign-marriage', 'S', 'medical-certificate-for-military-service'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-special-course', 'S', 'medical-certificate-for-underage-marriage'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-licensing', 'S', 'medical-certificate-for-child-adoption'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-continued-education', 'S', 'medical-certificate-for-study-abroad-and-visa'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-pension', 'S', 'medical-certificate-for-maritime-workers'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-disability-suspicion', 'S', 'medical-certificate-for-divers'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-observation', 'S', 'medical-certificate-for-lifeguards'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-psychotropic-work-monitoring', 'S', 'medical-certificate-for-ionizing-radiation-workers'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-prison-visit', 'S', 'medical-certificate-for-court-expert'),
('dom-zdravlja-herceg-novi', 'S', 'medical-certificate-for-special-treatment', 'S', 'medical-certificate-for-collective-accommodation'),
('dom-zdravlja-herceg-novi', 'S', 'typhoid-vaccination-vivotif', 'S', 'rabies-vaccination-verorab'),
('dom-zdravlja-herceg-novi', 'S', 'typhoid-immunoglobulin', 'S', 'rabies-immunoglobulin'),
('dom-zdravlja-herceg-novi', 'L', 'sperm-culture-fungi', 'L', 'urethral-swab-fungi'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ctg-fetal-monitoring', 'S', 'pregnancy-cardiotocography-ctg'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'lung-fluoroscopy', 'S', 'lung-fluorography'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'foreign-body-removal-from-nose', 'S', 'foreign-body-removal-from-skin-and-subcutaneous-tissue'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'anterior-hematoma-puncture', 'S', 'aspiration-puncture-of-abscess-or-hematoma'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gastrostomy-site-care', 'S', 'stoma-care'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'enema-administration-medium', 'S', 'enema'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'gastric-sounding-and-lavage', 'S', 'indwelling-catheter-placement'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'fluoroscopy-examination', 'S', 'pleural-puncture'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'targeted-skull-region-x-ray-per-image', 'S', 'x-ray-lumbar-spine-and-sacrum'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'paranasal-sinus-x-ray-per-image', 'S', 'x-ray-pelvis'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'extremity-x-ray-per-image', 'S', 'pharynx-and-larynx-x-ray'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'chest-ribs-or-sternum-x-ray-per-view', 'S', 'x-ray-sternum'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'complete-blood-count-with-differential', 'L', 'blood-count-selected-parameters'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'fecal-occult-blood-qualitative', 'L', 'fecal-occult-blood'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'alpha-amylase-activity', 'L', 'amylase'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'serum-urea-kinetic', 'L', 'urea'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'serum-creatinine', 'L', 'creatinine'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'c-reactive-protein-crp', 'L', 'c-reactive-protein'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'urine-protein-qualitative', 'L', 'urinary-protein-qualitative'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'urine-hcg-strip-test', 'L', 'urine-pregnancy-test-hcg-qualitative'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'ultraviolet-and-biogenic-lamp-treatment', 'S', 'infrared-ultraviolet-and-bioptron-lamp-irradiation'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'back-exercises', 'S', 'gait-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'coordination-and-balance-exercises', 'S', 'gait-coordination-correction-and-balance-automation-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'group-exercises-type-a', 'S', 'breathing-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'segmental-isokinetic-exercises', 'S', 'segmental-isometric-exercises'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'activities-of-daily-living-adl-test', 'S', 'activities-of-daily-living-test'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'patient-body-posture-training', 'S', 'patient-training-in-specific-protective-body-positions'),
('dom-zdravlja-bosko-dedeic-mojkovac', 'S', 'sanitary-patient-transport-per-kilometer', 'S', 'medical-transport-per-km');

-- ═══ 1. Новые записи каталога (правильной нет вообще) ═══

-- Страховка: name_en новых записей не заняты ДРУГИМИ записями. Ожидается ПУСТО.
SELECT ms.slug AS owner, ms.name_en FROM medical_services ms WHERE (ms.name_en = 'Rabies Vaccination Verorab' AND ms.slug <> 'rabies-vaccination-verorab') OR (ms.name_en = 'Human Rabies Immunoglobulin' AND ms.slug <> 'rabies-immunoglobulin');

-- HES 7 «Vakcinacija protiv bjesnila - "Verorab"» и HES 8 «Imunoglobin ljudski protiv bjesnila» — импорт ХН ставил их
-- на typhoid-vaccination-vivotif / typhoid-immunoglobulin; соседи — hepatitis-a-vaccination-avaxim, hepatitis-b-immunoglobulin
-- (категория 29, специальностей нет)
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Rabies Vaccination Verorab', 'rabies-vaccination-verorab', 'Vakcinacija protiv bjesnila Verorab', 'Вакцинација против бјеснила Verorab', 'Вакцинация против бешенства Verorab', 'Tollwut-Impfung Verorab', 'Kuduz aşısı Verorab')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 29 FROM medical_services WHERE slug = 'rabies-vaccination-verorab';
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Human Rabies Immunoglobulin', 'rabies-immunoglobulin', 'Humani imunoglobulin protiv bjesnila', 'Хумани имуноглобулин против бјеснила', 'Антирабический иммуноглобулин человека', 'Humanes Tollwut-Immunglobulin', 'İnsan kuduz immünoglobulini')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 29 FROM medical_services WHERE slug = 'rabies-immunoglobulin';

-- Страховка: все целевые записи каталога существуют. Ожидается ПУСТО.
SELECT t.clinic_slug, t.kind, t.slug FROM tmp_056_target t
LEFT JOIN medical_services ms ON t.kind = 'S' AND ms.slug = t.slug
LEFT JOIN lab_tests lt ON t.kind = 'L' AND lt.slug = t.slug
WHERE ms.id IS NULL AND lt.id IS NULL;

-- ═══ ДО ═══

SELECT 'before' AS state, c.slug AS clinic,
	(SELECT COUNT(*) FROM clinic_medical_services x WHERE x.clinic_id = c.id) AS services,
	(SELECT COUNT(*) FROM clinic_lab_tests x WHERE x.clinic_id = c.id) AS lab_tests,
	(SELECT COUNT(*) FROM clinic_medical_service_doctors x WHERE x.clinic_id = c.id) AS doctor_links
FROM clinics c WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac') ORDER BY c.slug;

-- ДО: услуги, которые снимаются (ожидается: ХН 55, Мойковац 29), с флагами
SELECT r.clinic_slug, r.slug, x.code, x.price, x.is_price_outdated, x.is_obsolete, r.why
FROM tmp_056_remove r
JOIN clinics c ON c.slug = r.clinic_slug
JOIN medical_services ms ON ms.slug = r.slug
JOIN clinic_medical_services x ON x.clinic_id = c.id AND x.medical_service_id = ms.id
WHERE r.kind = 'S' ORDER BY r.clinic_slug, x.code;

-- ДО: анализы, которые снимаются (ожидается: ХН 2, Мойковац 1)
SELECT r.clinic_slug, r.slug, x.code, x.price, x.is_price_outdated, x.is_obsolete, r.why
FROM tmp_056_remove r
JOIN clinics c ON c.slug = r.clinic_slug
JOIN lab_tests lt ON lt.slug = r.slug
JOIN clinic_lab_tests x ON x.clinic_id = c.id AND x.lab_test_id = lt.id
WHERE r.kind = 'L' ORDER BY r.clinic_slug, x.code;

-- ДО: привязки врачей на снимаемых услугах (переносятся по tmp_056_moves; услуга → анализ перенести нельзя). Ожидается ПУСТО.
SELECT c.slug AS clinic, ms.slug, d.doctor_id
FROM clinic_medical_service_doctors d
JOIN clinics c ON c.id = d.clinic_id
JOIN medical_services ms ON ms.id = d.medical_service_id
JOIN tmp_056_remove r ON r.clinic_slug = c.slug AND r.kind = 'S' AND r.slug = ms.slug;

-- ═══ 2. Снимок текущих строк (флаги) и строки к добавлению ═══

DROP TEMPORARY TABLE IF EXISTS tmp_056_src;
CREATE TEMPORARY TABLE tmp_056_src (
	clinic_slug VARCHAR(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	is_price_outdated TINYINT NOT NULL,
	is_obsolete TINYINT NOT NULL,
	PRIMARY KEY (clinic_slug, kind, slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
INSERT INTO tmp_056_src (clinic_slug, kind, slug, is_price_outdated, is_obsolete)
SELECT c.slug, 'S', ms.slug, x.is_price_outdated, x.is_obsolete
FROM clinic_medical_services x JOIN clinics c ON c.id = x.clinic_id JOIN medical_services ms ON ms.id = x.medical_service_id
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac');
INSERT INTO tmp_056_src (clinic_slug, kind, slug, is_price_outdated, is_obsolete)
SELECT c.slug, 'L', lt.slug, x.is_price_outdated, x.is_obsolete
FROM clinic_lab_tests x JOIN clinics c ON c.id = x.clinic_id JOIN lab_tests lt ON lt.id = x.lab_test_id
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac');

DROP TEMPORARY TABLE IF EXISTS tmp_056_ins;
CREATE TEMPORARY TABLE tmp_056_ins (
	clinic_slug VARCHAR(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	kind CHAR(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
	code VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
	price DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL,
	is_price_outdated TINYINT NOT NULL DEFAULT 0,
	is_obsolete TINYINT NOT NULL DEFAULT 0,
	PRIMARY KEY (clinic_slug, kind, slug)
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
INSERT INTO tmp_056_ins (clinic_slug, kind, slug, code, price, price_max)
SELECT t.clinic_slug, t.kind, t.slug, t.code, t.price, t.price_max
FROM tmp_056_target t
LEFT JOIN tmp_056_src s ON s.clinic_slug = t.clinic_slug AND s.kind = t.kind AND s.slug = t.slug
WHERE s.slug IS NULL;
-- флаги новой строки — со снимаемой строки того же кода PDF (перенос), иначе 0
UPDATE tmp_056_ins i
JOIN tmp_056_moves m ON m.clinic_slug = i.clinic_slug AND m.to_kind = i.kind AND m.to_slug = i.slug
JOIN tmp_056_src s ON s.clinic_slug = m.clinic_slug AND s.kind = m.from_kind AND s.slug = m.from_slug
SET i.is_price_outdated = GREATEST(i.is_price_outdated, s.is_price_outdated), i.is_obsolete = GREATEST(i.is_obsolete, s.is_obsolete);

SELECT 'to insert' AS step, clinic_slug, kind, COUNT(*) AS n FROM tmp_056_ins GROUP BY clinic_slug, kind ORDER BY clinic_slug, kind;

-- ═══ 3. Добавление недостающих строк ═══

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, code, price, price_max, is_price_outdated, is_obsolete)
SELECT c.id, ms.id, i.code, i.price, i.price_max, i.is_price_outdated, i.is_obsolete
FROM tmp_056_ins i JOIN clinics c ON c.slug = i.clinic_slug JOIN medical_services ms ON ms.slug = i.slug
WHERE i.kind = 'S';

INSERT INTO clinic_lab_tests (clinic_id, lab_test_id, code, price, price_max, is_price_outdated, is_obsolete)
SELECT c.id, lt.id, i.code, i.price, i.price_max, i.is_price_outdated, i.is_obsolete
FROM tmp_056_ins i JOIN clinics c ON c.slug = i.clinic_slug JOIN lab_tests lt ON lt.slug = i.slug
WHERE i.kind = 'L';

-- ═══ 4. Привязки врачей: со снимаемой услуги на правильную ═══

UPDATE tmp_056_moves m JOIN medical_services ms ON ms.slug = m.from_slug SET m.from_id = ms.id WHERE m.from_kind = 'S';
UPDATE tmp_056_moves m JOIN medical_services ms ON ms.slug = m.to_slug SET m.to_id = ms.id WHERE m.to_kind = 'S';
UPDATE IGNORE clinic_medical_service_doctors d
JOIN clinics c ON c.id = d.clinic_id
JOIN tmp_056_moves m ON m.clinic_slug = c.slug AND m.from_id = d.medical_service_id AND m.to_id IS NOT NULL
SET d.medical_service_id = m.to_id;
-- остаток (дубль врача на целевой услуге или перенос услуга → анализ) — со снимаемых услуг убирается
DELETE d FROM clinic_medical_service_doctors d
JOIN clinics c ON c.id = d.clinic_id
JOIN medical_services ms ON ms.id = d.medical_service_id
JOIN tmp_056_remove r ON r.clinic_slug = c.slug AND r.kind = 'S' AND r.slug = ms.slug;

-- ═══ 5. Код и цены по PDF (price_min у этих прайсов не бывает) ═══

UPDATE clinic_medical_services x
JOIN clinics c ON c.id = x.clinic_id
JOIN medical_services ms ON ms.id = x.medical_service_id
JOIN tmp_056_target t ON t.clinic_slug = c.slug AND t.kind = 'S' AND t.slug = ms.slug
SET x.code = t.code, x.price = t.price, x.price_max = t.price_max, x.price_min = NULL
WHERE NOT (x.code <=> t.code AND x.price <=> t.price AND x.price_max <=> t.price_max AND x.price_min IS NULL);

UPDATE clinic_lab_tests x
JOIN clinics c ON c.id = x.clinic_id
JOIN lab_tests lt ON lt.id = x.lab_test_id
JOIN tmp_056_target t ON t.clinic_slug = c.slug AND t.kind = 'L' AND t.slug = lt.slug
SET x.code = t.code, x.price = t.price, x.price_max = t.price_max
WHERE NOT (x.code <=> t.code AND x.price <=> t.price AND x.price_max <=> t.price_max);

-- ═══ 6. Снятие строк, которых в PDF нет (или которые стояли на чужой записи) ═══

DELETE x FROM clinic_medical_services x
JOIN clinics c ON c.id = x.clinic_id
JOIN medical_services ms ON ms.id = x.medical_service_id
JOIN tmp_056_remove r ON r.clinic_slug = c.slug AND r.kind = 'S' AND r.slug = ms.slug;

DELETE x FROM clinic_lab_tests x
JOIN clinics c ON c.id = x.clinic_id
JOIN lab_tests lt ON lt.id = x.lab_test_id
JOIN tmp_056_remove r ON r.clinic_slug = c.slug AND r.kind = 'L' AND r.slug = lt.slug;

-- ═══ ПОСЛЕ ═══

SELECT 'after' AS state, c.slug AS clinic,
	(SELECT COUNT(*) FROM clinic_medical_services x WHERE x.clinic_id = c.id) AS services,
	(SELECT COUNT(*) FROM clinic_lab_tests x WHERE x.clinic_id = c.id) AS lab_tests,
	(SELECT COUNT(*) FROM clinic_medical_service_doctors x WHERE x.clinic_id = c.id) AS doctor_links
FROM clinics c WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac') ORDER BY c.slug;
-- ожидается: ХН 350 услуг + 130 анализов (было 364 + 110), Мойковац 290 + 44 (было 296 + 37; из 290 — 23 справки и санитарные осмотры 2026-10-02)

-- ПОСЛЕ: целевые услуги, которых нет или которые отличаются. Ожидается ПУСТО.
SELECT t.clinic_slug, t.slug, t.code, t.price, t.price_max, x.code AS db_code, x.price AS db_price, x.price_max AS db_price_max
FROM tmp_056_target t
JOIN clinics c ON c.slug = t.clinic_slug
LEFT JOIN medical_services ms ON ms.slug = t.slug
LEFT JOIN clinic_medical_services x ON x.clinic_id = c.id AND x.medical_service_id = ms.id
WHERE t.kind = 'S' AND NOT (x.code <=> t.code AND x.price <=> t.price AND x.price_max <=> t.price_max);

-- ПОСЛЕ: целевые анализы, которых нет или которые отличаются. Ожидается ПУСТО.
SELECT t.clinic_slug, t.slug, t.code, t.price, t.price_max, x.code AS db_code, x.price AS db_price, x.price_max AS db_price_max
FROM tmp_056_target t
JOIN clinics c ON c.slug = t.clinic_slug
LEFT JOIN lab_tests lt ON lt.slug = t.slug
LEFT JOIN clinic_lab_tests x ON x.clinic_id = c.id AND x.lab_test_id = lt.id
WHERE t.kind = 'L' AND NOT (x.code <=> t.code AND x.price <=> t.price AND x.price_max <=> t.price_max);

-- ПОСЛЕ: услуги клиник вне целевого состава (кроме справок и санитарных осмотров Мойковца 2026-10-02). Ожидается ПУСТО.
SELECT c.slug AS clinic, x.code, ms.slug, x.price
FROM clinic_medical_services x
JOIN clinics c ON c.id = x.clinic_id
JOIN medical_services ms ON ms.id = x.medical_service_id
LEFT JOIN tmp_056_target t ON t.clinic_slug = c.slug AND t.kind = 'S' AND t.slug = ms.slug
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac') AND t.slug IS NULL
	AND NOT (c.slug = 'dom-zdravlja-bosko-dedeic-mojkovac' AND x.code REGEXP '^MO_(UVJ|SAN)_');

-- ПОСЛЕ: анализы клиник вне целевого состава. Ожидается ПУСТО.
SELECT c.slug AS clinic, x.code, lt.slug, x.price
FROM clinic_lab_tests x
JOIN clinics c ON c.id = x.clinic_id
JOIN lab_tests lt ON lt.id = x.lab_test_id
LEFT JOIN tmp_056_target t ON t.clinic_slug = c.slug AND t.kind = 'L' AND t.slug = lt.slug
WHERE c.slug IN ('dom-zdravlja-herceg-novi', 'dom-zdravlja-bosko-dedeic-mojkovac') AND t.slug IS NULL;

-- ПОСЛЕ: снятые записи каталога, у которых не осталось ни клиник, ни тарифов (сироты; в этой миграции не удаляются)
SELECT r.kind, r.slug,
	(SELECT COUNT(*) FROM medical_service_synonyms y WHERE y.medical_service_id = ms.id) AS synonyms,
	(SELECT COUNT(*) FROM reviews v WHERE v.medical_service_id = ms.id) AS reviews
FROM tmp_056_remove r
JOIN medical_services ms ON r.kind = 'S' AND ms.slug = r.slug
WHERE NOT EXISTS (SELECT 1 FROM clinic_medical_services x WHERE x.medical_service_id = ms.id)
	AND NOT EXISTS (SELECT 1 FROM medical_service_tariffs f WHERE f.medical_service_id = ms.id)
GROUP BY r.kind, r.slug, ms.id ORDER BY r.slug;

-- ПОСЛЕ: снятые анализы, у которых не осталось ни клиник, ни тарифов
SELECT r.kind, r.slug
FROM tmp_056_remove r
JOIN lab_tests lt ON r.kind = 'L' AND lt.slug = r.slug
WHERE NOT EXISTS (SELECT 1 FROM clinic_lab_tests x WHERE x.lab_test_id = lt.id)
	AND NOT EXISTS (SELECT 1 FROM medical_service_tariffs f WHERE f.lab_test_id = lt.id)
ORDER BY r.slug;

DROP TEMPORARY TABLE IF EXISTS tmp_056_target;
DROP TEMPORARY TABLE IF EXISTS tmp_056_remove;
DROP TEMPORARY TABLE IF EXISTS tmp_056_moves;
DROP TEMPORARY TABLE IF EXISTS tmp_056_src;
DROP TEMPORARY TABLE IF EXISTS tmp_056_ins;


SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 048: Milmedika — позиции сайта, которых у филиалов не было (138 строк).
--
-- Источник — milmedika.com/cjenovnik/<филиал> на 2026-10-02 (Тиват =
-- milmedika-porto-montenegro), продолжение 045. Каждая строка сопоставлена с
-- каталогом вручную: 107 — на существующие записи, 31 — на 15 новых.
--
-- Не импортированы (8 строк) — непонятно, чему соответствуют, или
-- строка уже есть:
--   NK «RTG grudnog koša» — у NK строка x-ray-chest уже есть, 35 € = сайт
--   NK «PH hirurgija 2 – dodatni uzorak» — на сайте NK четыре «доп. образца PH» на две наши записи
--   NK «PAPA test – tečna citologija sa uzimanjem brisa» — неясно, как соотносится с PAP-позициями (решение 2026-10-02)
--   NK «Dodatni uzorak za PH analizu 2» — то же
--   NK «Coxsackie B IgM» — у NK строка coxsackie-b-igm уже есть (из «Coxackie IgM»), 18 € = сайт
--   NK «Coxsackie B IgG, IgM» — у NK две похожие панели по 36 €, наша уже занята «Coxackie IgG, Coxackie IgM»
--   NK «Koprokultura – analiza stolice na bakterije (Salmonella, Shigella, E. coli O157)» — у NK на сайте две копрокультуры (12 и 15 €), наша строка уже на первой
--   TV «Mala obrada rane» — у TV на сайте ещё и «Obrada rane – mala» 200 €, наша строка small-wound-care уже на ней
--
-- Записи — по slug, клиники — по slug (id локально и на проде расходятся).
-- INSERT IGNORE / ON DUPLICATE KEY: повторный прогон ничего не ломает.
-- Пересечения с 043/046/047 (переименования и переносы) по slug безопасны:
-- они не меняют slug записей, на которые здесь ставятся строки.

-- ═══ 1. Новые записи каталога ═══

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Basic Lab Panel', 'basic-lab-panel', 'Osnovni laboratorijski nalazi', 'Основни лабораторијски налази', 'Базовый лабораторный пакет', 'Basis-Laborpaket', 'Temel Laboratuvar Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'basic-lab-panel';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'basic-lab-panel';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Osnovni laboratorijski nalazi (glukoza, urea, kreatinin, holesterol, trigliceridi, AST, ALT)', 'sr' FROM lab_tests WHERE slug = 'basic-lab-panel';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Базовая биохимия крови', 'ru' FROM lab_tests WHERE slug = 'basic-lab-panel';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Basic Lab Panel with Cholesterol Fractions', 'basic-lab-panel-with-cholesterol-fractions', 'Osnovni laboratorijski nalazi sa frakcijama holesterola', 'Основни лабораторијски налази са фракцијама холестерола', 'Базовый лабораторный пакет с фракциями холестерина', 'Basis-Laborpaket mit Cholesterinfraktionen', 'Kolesterol Fraksiyonlu Temel Laboratuvar Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'basic-lab-panel-with-cholesterol-fractions';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'basic-lab-panel-with-cholesterol-fractions';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Osnovni laboratorijski nalazi + frakcije holesterola (HDL, LDL)', 'sr' FROM lab_tests WHERE slug = 'basic-lab-panel-with-cholesterol-fractions';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Basic Lab Panel with Urinalysis', 'basic-lab-panel-with-urinalysis', 'Osnovni laboratorijski nalazi sa urinom', 'Основни лабораторијски налази са урином', 'Базовый лабораторный пакет с анализом мочи', 'Basis-Laborpaket mit Urinuntersuchung', 'İdrar Tahlilli Temel Laboratuvar Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'basic-lab-panel-with-urinalysis';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 8 FROM lab_tests WHERE slug = 'basic-lab-panel-with-urinalysis';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'basic-lab-panel-with-urinalysis';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('CBC, CRP, AST, ALT, LDH', 'cbc-crp-ast-alt-ldh', 'KKS, CRP, AST, ALT, LDH', 'ККС, CRP, AST, ALT, LDH', 'ОАК, СРБ, АСТ, АЛТ, ЛДГ', 'Blutbild, CRP, AST, ALT, LDH', 'Tam Kan Sayımı, CRP, AST, ALT, LDH')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 1 FROM lab_tests WHERE slug = 'cbc-crp-ast-alt-ldh';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'cbc-crp-ast-alt-ldh';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 7 FROM lab_tests WHERE slug = 'cbc-crp-ast-alt-ldh';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'cbc-crp-ast-alt-ldh';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('CBC, CRP, D-Dimer', 'cbc-crp-d-dimer', 'KKS, CRP, D-dimer', 'ККС, CRP, D-димер', 'ОАК, СРБ, D-димер', 'Blutbild, CRP, D-Dimer', 'Tam Kan Sayımı, CRP, D-Dimer')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 1 FROM lab_tests WHERE slug = 'cbc-crp-d-dimer';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 2 FROM lab_tests WHERE slug = 'cbc-crp-d-dimer';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 7 FROM lab_tests WHERE slug = 'cbc-crp-d-dimer';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'cbc-crp-d-dimer';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('CBC, Glucose and Urinalysis', 'cbc-glucose-and-urinalysis', 'KKS, glukoza, urin', 'ККС, глукоза, урин', 'ОАК, глюкоза, общий анализ мочи', 'Blutbild, Glukose und Urinuntersuchung', 'Tam Kan Sayımı, Glukoz ve İdrar Tahlili')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 1 FROM lab_tests WHERE slug = 'cbc-glucose-and-urinalysis';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'cbc-glucose-and-urinalysis';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 8 FROM lab_tests WHERE slug = 'cbc-glucose-and-urinalysis';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'cbc-glucose-and-urinalysis';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Cardiology Lab Package', 'cardiology-lab-package', 'Kardiološki paket laboratorijskih nalaza', 'Кардиолошки пакет лабораторијских налаза', 'Кардиологический лабораторный пакет', 'Kardiologisches Laborpaket', 'Kardiyoloji Laboratuvar Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 1 FROM lab_tests WHERE slug = 'cardiology-lab-package';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'cardiology-lab-package';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 4 FROM lab_tests WHERE slug = 'cardiology-lab-package';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'cardiology-lab-package';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'cardiology-lab-package';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Kardiološki paket lab. nalaza', 'sr' FROM lab_tests WHERE slug = 'cardiology-lab-package';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Check-up Lab Package 1', 'check-up-lab-package-1', 'Sistematski paket 1 laboratorijskih nalaza', 'Систематски пакет 1 лабораторијских налаза', 'Лабораторный пакет для чекапа 1', 'Check-up-Laborpaket 1', 'Check-up Laboratuvar Paketi 1')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 1 FROM lab_tests WHERE slug = 'check-up-lab-package-1';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'check-up-lab-package-1';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'check-up-lab-package-1';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 8 FROM lab_tests WHERE slug = 'check-up-lab-package-1';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'check-up-lab-package-1';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Sistematski paket 1 lab. nalaza', 'sr' FROM lab_tests WHERE slug = 'check-up-lab-package-1';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Check-up Lab Package 2', 'check-up-lab-package-2', 'Sistematski paket 2 laboratorijskih nalaza', 'Систематски пакет 2 лабораторијских налаза', 'Лабораторный пакет для чекапа 2', 'Check-up-Laborpaket 2', 'Check-up Laboratuvar Paketi 2')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 1 FROM lab_tests WHERE slug = 'check-up-lab-package-2';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'check-up-lab-package-2';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'check-up-lab-package-2';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 6 FROM lab_tests WHERE slug = 'check-up-lab-package-2';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 8 FROM lab_tests WHERE slug = 'check-up-lab-package-2';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'check-up-lab-package-2';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Sistematski paket 2 lab. nalaza', 'sr' FROM lab_tests WHERE slug = 'check-up-lab-package-2';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('STD Multiplex 8', 'std-multiplex-8', 'STD Multiplex 8 – detekcija 8 patogena', 'STD Multiplex 8 – детекција 8 патогена', 'STD Multiplex 8 – выявление 8 возбудителей ИППП', 'STD Multiplex 8', 'STD Multipleks 8')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'std-multiplex-8';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 22 FROM lab_tests WHERE slug = 'std-multiplex-8';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'STI Multiplex 8', 'en' FROM lab_tests WHERE slug = 'std-multiplex-8';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'ИППП мультиплекс на 8 возбудителей', 'ru' FROM lab_tests WHERE slug = 'std-multiplex-8';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Mycoplasma and Chlamydia Pneumoniae with AVRI Multiplex', 'mycoplasma-chlamydia-pneumoniae-with-avri-multiplex', 'Mycoplasma i Chlamydia pneumoniae + AVRI multiplex', 'Mycoplasma и Chlamydia pneumoniae + AVRI multiplex', 'Mycoplasma и Chlamydia pneumoniae + AVRI мультиплекс', 'Mycoplasma und Chlamydia pneumoniae + AVRI-Multiplex', 'Mycoplasma ve Chlamydia pneumoniae + AVRI Multipleks')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'mycoplasma-chlamydia-pneumoniae-with-avri-multiplex';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 22 FROM lab_tests WHERE slug = 'mycoplasma-chlamydia-pneumoniae-with-avri-multiplex';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'mycoplasma-chlamydia-pneumoniae-with-avri-multiplex';

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Gliadin IgM Antibodies', 'gliadin-igm-antibodies', 'Glijadin IgM antitijela', 'Глијадин IgM антитијела', 'Антитела к глиадину IgM', 'Gliadin-IgM-Antikörper', 'Gliadin IgM Antikorları')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 14 FROM lab_tests WHERE slug = 'gliadin-igm-antibodies';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'AGA IgM', 'en' FROM lab_tests WHERE slug = 'gliadin-igm-antibodies';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 's-AGA-T IgM', 'sr' FROM lab_tests WHERE slug = 'gliadin-igm-antibodies';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Антиглиадиновые антитела IgM', 'ru' FROM lab_tests WHERE slug = 'gliadin-igm-antibodies';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Subspecialist Pediatric Physiatrist Examination', 'subspecialist-pediatric-physiatrist-examination', 'Subspecijalistički pregled dječijeg fizijatra', 'Субспецијалистички преглед дјечијег физијатра', 'Осмотр детского физиотерапевта узкого профиля', 'Subspezialistische Untersuchung Kinder-Physikalische Medizin', 'Çocuk Fizyatrisi Yan Dal Muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 5 FROM medical_services WHERE slug = 'subspecialist-pediatric-physiatrist-examination';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 25 FROM medical_services WHERE slug = 'subspecialist-pediatric-physiatrist-examination';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 42 FROM medical_services WHERE slug = 'subspecialist-pediatric-physiatrist-examination';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 4 FROM medical_services WHERE slug = 'subspecialist-pediatric-physiatrist-examination';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Nasopharyngolaryngoscopy with Video Otoscopy', 'nasopharyngolaryngoscopy-with-video-otoscopy', 'Nazofaringolaringoskopija sa video otoskopijom', 'Назофаринголарингоскопија са видео отоскопијом', 'Назофаринголарингоскопия с видеоотоскопией', 'Nasopharyngolaryngoskopie mit Video-Otoskopie', 'Video Otoskopili Nazofaringolaringoskopi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 11 FROM medical_services WHERE slug = 'nasopharyngolaryngoscopy-with-video-otoscopy';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 11 FROM medical_services WHERE slug = 'nasopharyngolaryngoscopy-with-video-otoscopy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Endoskopski pregled nosa, ždrijela i grkljana sa video pregledom uha', 'sr' FROM medical_services WHERE slug = 'nasopharyngolaryngoscopy-with-video-otoscopy';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Doppler of Lower Extremities and Neck', 'doppler-lower-extremities-and-neck', 'Dopler donjih ekstremiteta i vrata', 'Доплер доњих екстремитета и врата', 'Допплер сосудов нижних конечностей и шеи', 'Doppler untere Extremitäten und Halsgefäße', 'Alt Ekstremite ve Boyun Doppler')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'doppler-lower-extremities-and-neck';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 10 FROM medical_services WHERE slug = 'doppler-lower-extremities-and-neck';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 34 FROM medical_services WHERE slug = 'doppler-lower-extremities-and-neck';

-- ═══ 2. Строки клиник ═══

-- lab:5-hiaa-in-24h-urine
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 30.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = '5-hiaa-in-24h-urine' WHERE c.slug = 'milmedika-podgorica'; -- PG «5-HIAA u 24-časovnom urinu (test za karcinoidni tumor)»

-- lab:acid-phosphatase
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 6.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'acid-phosphatase' WHERE c.slug = 'milmedika-podgorica'; -- PG «Kisela fosfataza»

-- lab:adenovirus-igg
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'adenovirus-igg' WHERE c.slug = 'milmedika-podgorica'; -- PG «ADV IgG (adenovirus IgG)»

-- lab:adenovirus-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'adenovirus-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «ADV IgG, ADV IgM (adenovirus IgG i IgM)»

-- lab:adenovirus-igm
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'adenovirus-igm' WHERE c.slug = 'milmedika-podgorica'; -- PG «ADV IgM (adenovirus IgM)»

-- lab:albumin-creatinine-ratio
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'albumin-creatinine-ratio' WHERE c.slug = 'milmedika-podgorica'; -- PG «ACR analiza (odnos albumin / kreatinin)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'albumin-creatinine-ratio' WHERE c.slug = 'milmedika-budva'; -- BD «ACR analiza (odnos albumin / kreatinin)»

-- lab:aldosterone
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 35.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'aldosterone' WHERE c.slug = 'milmedika-niksic'; -- NK «Aldosteron (hormon nadbubrežne žlijezde)»

-- lab:ana-antinuclear-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'ana-antinuclear-antibodies' WHERE c.slug = 'milmedika-podgorica'; -- PG «s-ANA (antinuklearna antitijela)»

-- lab:anti-gad-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 28.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'anti-gad-antibodies' WHERE c.slug = 'milmedika-niksic'; -- NK «Anti-GAD (marker autoimunog dijabetesa / tip 1)»

-- lab:antithrombin-iii
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'antithrombin-iii' WHERE c.slug = 'milmedika-podgorica'; -- PG «Antitrombin III (test na poremećaje koagulacije, citratna plazma)»

-- lab:apoa-i
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 12.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'apoa-i' WHERE c.slug = 'milmedika-niksic'; -- NK «APO A (Apolipoprotein A1)»

-- lab:apolipoprotein-b
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 12.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'apolipoprotein-b' WHERE c.slug = 'milmedika-niksic'; -- NK «APO B (Apolipoprotein B)»

-- lab:avri-multiplex-16
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 75.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'avri-multiplex-16' WHERE c.slug = 'milmedika-podgorica'; -- PG «AVRI multiplex – detekcija 16 respiratornih virusa»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 75.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'avri-multiplex-16' WHERE c.slug = 'milmedika-budva'; -- BD «AVRI multiplex – detekcija 16 respiratornih virusa»

-- lab:basic-lab-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 14.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «Osnovni laboratorijski nalazi (glukoza, urea, kreatinin, holesterol, trigliceridi, AST, ALT)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel' WHERE c.slug = 'milmedika-niksic'; -- NK «Osnovni laboratorijski nalazi»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 40.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel' WHERE c.slug = 'milmedika-tivat'; -- TV «Osnovni laboratorijski nalazi»

-- lab:basic-lab-panel-with-cholesterol-fractions
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 20.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel-with-cholesterol-fractions' WHERE c.slug = 'milmedika-podgorica'; -- PG «Osnovni laboratorijski nalazi + frakcije holesterola (HDL, LDL)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 34.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel-with-cholesterol-fractions' WHERE c.slug = 'milmedika-niksic'; -- NK «Osnovni laboratorijski nalazi sa frakcijama holesterola»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 56.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel-with-cholesterol-fractions' WHERE c.slug = 'milmedika-tivat'; -- TV «Osnovni laboratorijski nalazi sa frakcijama holesterola»

-- lab:basic-lab-panel-with-urinalysis
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 30.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel-with-urinalysis' WHERE c.slug = 'milmedika-niksic'; -- NK «Osnovni laboratorijski nalazi sa urinom»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 50.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'basic-lab-panel-with-urinalysis' WHERE c.slug = 'milmedika-tivat'; -- TV «Osnovni laboratorijski nalazi sa urinom»

-- lab:beta-2-glycoprotein-1-igg
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'beta-2-glycoprotein-1-igg' WHERE c.slug = 'milmedika-podgorica'; -- PG «Beta-2 GP1 IgG»

-- lab:beta-2-glycoprotein-1-igm
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'beta-2-glycoprotein-1-igm' WHERE c.slug = 'milmedika-podgorica'; -- PG «Beta-2 GP1 IgM»

-- lab:beta-2-microglobulin
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'beta-2-microglobulin' WHERE c.slug = 'milmedika-podgorica'; -- PG «Beta-2 mikroglobulin (marker limfoproliferativnih bolesti)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'beta-2-microglobulin' WHERE c.slug = 'milmedika-budva'; -- BD «Beta-2 mikroglobulin (marker limfoproliferativnih bolesti)»

-- lab:bicarbonates
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'bicarbonates' WHERE c.slug = 'milmedika-podgorica'; -- PG «Bikarbonati (kiselinsko-bazna ravnoteža)»

-- lab:bnp
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 40.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'bnp' WHERE c.slug = 'milmedika-niksic'; -- NK «BNP (marker za srčanu insuficijenciju)»

-- lab:borrelia-burgdorferi-igg
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'borrelia-burgdorferi-igg' WHERE c.slug = 'milmedika-podgorica'; -- PG «Borelija IgG (Lyme bolest)»

-- lab:borrelia-burgdorferi-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'borrelia-burgdorferi-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «Borelija IgG, Borelija IgM (Lyme bolest)»

-- lab:borrelia-burgdorferi-igm
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'borrelia-burgdorferi-igm' WHERE c.slug = 'milmedika-podgorica'; -- PG «Borelija IgM (Lyme bolest)»

-- lab:calcium-in-urine
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 6.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'calcium-in-urine' WHERE c.slug = 'milmedika-podgorica'; -- PG «Kalcijum u urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 6.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'calcium-in-urine' WHERE c.slug = 'milmedika-budva'; -- BD «Kalcijum u urinu»

-- lab:candida-albicans-pcr
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 27.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'candida-albicans-pcr' WHERE c.slug = 'milmedika-podgorica'; -- PG «Candida albicans (Real-Time PCR)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 27.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'candida-albicans-pcr' WHERE c.slug = 'milmedika-budva'; -- BD «Candida albicans (Real-Time PCR)»

-- lab:cardiology-lab-package
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 50.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cardiology-lab-package' WHERE c.slug = 'milmedika-podgorica'; -- PG «Kardiološki paket lab. nalaza (KKS, osnovni lab. nalazi paket 2, sedimentacija, TSH, FT4, kalijum, natrijum)»

-- lab:cbc-crp-ast-alt-ldh
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 22.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-crp-ast-alt-ldh' WHERE c.slug = 'milmedika-podgorica'; -- PG «KKS, CRP, AST, ALT, LDH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-crp-ast-alt-ldh' WHERE c.slug = 'milmedika-niksic'; -- NK «KKS, CRP, AST, ALT, LDH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 40.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-crp-ast-alt-ldh' WHERE c.slug = 'milmedika-tivat'; -- TV «KKS, CRP, AST, ALT, LDH»

-- lab:cbc-crp-d-dimer
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 32.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-crp-d-dimer' WHERE c.slug = 'milmedika-podgorica'; -- PG «KKS, CRP, D-dimer»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 33.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-crp-d-dimer' WHERE c.slug = 'milmedika-niksic'; -- NK «KKS, CRP, D-dimer»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 54.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-crp-d-dimer' WHERE c.slug = 'milmedika-tivat'; -- TV «KKS, CRP, D-dimer»

-- lab:cbc-glucose-and-urinalysis
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 15.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-glucose-and-urinalysis' WHERE c.slug = 'milmedika-podgorica'; -- PG «KKS, glukoza, urin»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 15.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-glucose-and-urinalysis' WHERE c.slug = 'milmedika-niksic'; -- NK «KKS, glukoza, urin»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-glucose-and-urinalysis' WHERE c.slug = 'milmedika-tivat'; -- TV «KKS, glukoza, urin»

-- lab:cbc-with-crp-and-mxa
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-with-crp-and-mxa' WHERE c.slug = 'milmedika-podgorica'; -- PG «KKS + CRP + MxA (immunoturbidimetric rapid determination)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cbc-with-crp-and-mxa' WHERE c.slug = 'milmedika-budva'; -- BD «KKS + CRP + MxA (immunoturbidimetric rapid determination)»

-- lab:check-up-lab-package-1
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 50.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'check-up-lab-package-1' WHERE c.slug = 'milmedika-podgorica'; -- PG «Sistematski paket 1 lab. nalaza (KKS, osnovni lab. nalazi paket 2, sedimentacija, TSH, FT4, urin»

-- lab:check-up-lab-package-2
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 65.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'check-up-lab-package-2' WHERE c.slug = 'milmedika-podgorica'; -- PG «Sistematski paket 2 lab. nalaza (sistematski paket 1 + PSA, specificni antigen prostate)»

-- lab:chromogranin-a
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 48.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'chromogranin-a' WHERE c.slug = 'milmedika-podgorica'; -- PG «Hromogranin A (neuroendokrini marker)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 40.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'chromogranin-a' WHERE c.slug = 'milmedika-budva'; -- BD «Hromogranin A (neuroendokrini marker)»

-- lab:coxsackie-b-igg
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'coxsackie-b-igg' WHERE c.slug = 'milmedika-podgorica'; -- PG «Coxackie IgG»

-- lab:coxsackie-b-igm
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'coxsackie-b-igm' WHERE c.slug = 'milmedika-podgorica'; -- PG «Coxackie IgM»

-- lab:coxsackie-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'coxsackie-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «Coxackie IgG, Coxackie IgM»

-- lab:cytomegalovirus-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'cytomegalovirus-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «CMV IgG, CMV IgM»

-- lab:epstein-barr-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'epstein-barr-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «EBV IgG, EBV IgM (Epstein-Barr virus)»

-- lab:food-allergy-panel-30-allergens
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 60.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'food-allergy-panel-30-allergens' WHERE c.slug = 'milmedika-podgorica'; -- PG «Polycheck Food 30-II – nutritivni panel (30 alergena)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 72.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'food-allergy-panel-30-allergens' WHERE c.slug = 'milmedika-niksic'; -- NK «Food panel (30 alergena)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 60.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'food-allergy-panel-30-allergens' WHERE c.slug = 'milmedika-budva'; -- BD «Polycheck Food 30-II – nutritivni panel (30 alergena)»

-- lab:free-beta-hcg
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'free-beta-hcg' WHERE c.slug = 'milmedika-podgorica'; -- PG «F-BHCG (slobodni beta-HCG)»

-- lab:free-estriol
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'free-estriol' WHERE c.slug = 'milmedika-podgorica'; -- PG «s-Free estriol (slobodni estriol)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'free-estriol' WHERE c.slug = 'milmedika-budva'; -- BD «s-Free estriol (slobodni estriol)»

-- lab:gad-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 48.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'gad-antibodies' WHERE c.slug = 'milmedika-podgorica'; -- PG «GAD (test za dijabetes tip 1)»

-- lab:gliadin-igm-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'gliadin-igm-antibodies' WHERE c.slug = 'milmedika-podgorica'; -- PG «s-AGA-T IgM (antiglijadinska antitijela IgM – celijakija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'gliadin-igm-antibodies' WHERE c.slug = 'milmedika-niksic'; -- NK «s-AGA-T IgM (antiglijadinska antitijela IgM – celijakija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 30.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'gliadin-igm-antibodies' WHERE c.slug = 'milmedika-tivat'; -- TV «s-AGA-T IgM (antiglijadinska antitijela IgM – celijakija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'gliadin-igm-antibodies' WHERE c.slug = 'milmedika-budva'; -- BD «s-AGA-T IgM (antiglijadinska antitijela IgM – celijakija)»

-- lab:hav-total-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'hav-total-antibodies' WHERE c.slug = 'milmedika-niksic'; -- NK «Anti-HAV (hepatitis A)»

-- lab:helicobacter-pylori-igg-iga-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'helicobacter-pylori-igg-iga-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «HBP IgG, HBP IgA (Helicobacter pylori – oba tipa antitijela)»

-- lab:herpes-simplex-i-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'herpes-simplex-i-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «HSV 1 lgG, HSV 1 IgM»

-- lab:herpes-simplex-ii-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'herpes-simplex-ii-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «HSV 2 IgG, HSV 2 lgM»

-- lab:ia-2-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 30.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'ia-2-antibodies' WHERE c.slug = 'milmedika-niksic'; -- NK «Anti-IA2 (marker autoimunog dijabetesa / tip 1)»

-- lab:igf-1
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 40.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'igf-1' WHERE c.slug = 'milmedika-niksic'; -- NK «IGF-I (marker hormona rasta)»

-- lab:immunoglobulins-panel-igg-iga-igm
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'immunoglobulins-panel-igg-iga-igm' WHERE c.slug = 'milmedika-podgorica'; -- PG «lmunoglobulini (IgG, IgA, IgM)»

-- lab:inhalant-allergy-panel-30-allergens
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 60.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'inhalant-allergy-panel-30-allergens' WHERE c.slug = 'milmedika-podgorica'; -- PG «Polycheck Inhalant 30-I – inhalatorni panel (30 alergena)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 72.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'inhalant-allergy-panel-30-allergens' WHERE c.slug = 'milmedika-niksic'; -- NK «Inhalacioni panel ( 30 alergena )»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 60.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'inhalant-allergy-panel-30-allergens' WHERE c.slug = 'milmedika-budva'; -- BD «Polycheck Inhalant 30-I – inhalatorni panel (30 alergena)»

-- lab:inhibin-a
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'inhibin-a' WHERE c.slug = 'milmedika-podgorica'; -- PG «Inhibin A»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'inhibin-a' WHERE c.slug = 'milmedika-budva'; -- BD «Inhibin A»

-- lab:le-cells
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'le-cells' WHERE c.slug = 'milmedika-podgorica'; -- PG «LE ćelije (test na autoimune bolesti, citratna plazma)»

-- lab:lipid-profile
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 10.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'lipid-profile' WHERE c.slug = 'milmedika-podgorica'; -- PG «Lipidni status (holesterol, trigliceridi, HDL, LDL)»

-- lab:lipoprotein-a
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 12.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'lipoprotein-a' WHERE c.slug = 'milmedika-niksic'; -- NK «Lipoprotein A»

-- lab:lupus-anticoagulant
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'lupus-anticoagulant' WHERE c.slug = 'milmedika-podgorica'; -- PG «LA (lupus antikoagulans, citratna plazma)»

-- lab:microalbumin-in-urine
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'microalbumin-in-urine' WHERE c.slug = 'milmedika-podgorica'; -- PG «Mikroalbumini u urinu (rana detekcija oštećenja bubrega)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'microalbumin-in-urine' WHERE c.slug = 'milmedika-budva'; -- BD «Mikroalbumini u urinu (rana detekcija oštećenja bubrega)»

-- lab:mumps-igg
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mumps-igg' WHERE c.slug = 'milmedika-podgorica'; -- PG «Mumps IgG»

-- lab:mumps-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mumps-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «Mumps IgG, Mumps IgM»

-- lab:mumps-igm
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mumps-igm' WHERE c.slug = 'milmedika-podgorica'; -- PG «Mumps IgM»

-- lab:mxa-crp
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 12.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mxa-crp' WHERE c.slug = 'milmedika-niksic'; -- NK «CRP MxA (brza metoda – CRP + virusni marker)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 20.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mxa-crp' WHERE c.slug = 'milmedika-tivat'; -- TV «CRP MxA (brza metoda – CRP + virusni marker)»

-- lab:mycoplasma-chlamydia-pneumoniae-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 55.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mycoplasma-chlamydia-pneumoniae-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «Mycoplasma i Chlamydia pneumoniae – respiratorne infekcije»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 55.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mycoplasma-chlamydia-pneumoniae-panel' WHERE c.slug = 'milmedika-budva'; -- BD «Mycoplasma i Chlamydia pneumoniae – respiratorne infekcije»

-- lab:mycoplasma-chlamydia-pneumoniae-with-avri-multiplex
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 110.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mycoplasma-chlamydia-pneumoniae-with-avri-multiplex' WHERE c.slug = 'milmedika-podgorica'; -- PG «Mycoplasma/Chlamydia pneumoniae + AVRI multiplex»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 110.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'mycoplasma-chlamydia-pneumoniae-with-avri-multiplex' WHERE c.slug = 'milmedika-budva'; -- BD «Mycoplasma/Chlamydia pneumoniae + AVRI multiplex»

-- lab:ovarian-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'ovarian-antibodies' WHERE c.slug = 'milmedika-podgorica'; -- PG «Anti-ovarijalna antitijela»

-- lab:papp-a
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 24.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'papp-a' WHERE c.slug = 'milmedika-podgorica'; -- PG «PAPP-A (plazma protein A povezan s trudnoćom)»

-- lab:parvovirus-b19-iga
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'parvovirus-b19-iga' WHERE c.slug = 'milmedika-podgorica'; -- PG «Parvo B19 IgA»

-- lab:parvovirus-b19-igg
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 18.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'parvovirus-b19-igg' WHERE c.slug = 'milmedika-podgorica'; -- PG «Parvo B19 IgG»

-- lab:parvovirus-b19-igg-iga-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'parvovirus-b19-igg-iga-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «Parvo B19 IgG, Parvo B19 IgA»

-- lab:phosphorus-in-urine
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 6.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'phosphorus-in-urine' WHERE c.slug = 'milmedika-podgorica'; -- PG «Fosfor u urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 6.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'phosphorus-in-urine' WHERE c.slug = 'milmedika-budva'; -- BD «Fosfor u urinu»

-- lab:prolactin-3x-with-iv-cannula
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-3x-with-iv-cannula' WHERE c.slug = 'milmedika-podgorica'; -- PG «Prolaktin (3 puta) sa braunilom»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 30.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-3x-with-iv-cannula' WHERE c.slug = 'milmedika-budva'; -- BD «Prolaktin (3 puta) sa braunilom»

-- lab:protein-c
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 42.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'protein-c' WHERE c.slug = 'milmedika-podgorica'; -- PG «Protein C (citratna plazma)»

-- lab:protein-s
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 42.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'protein-s' WHERE c.slug = 'milmedika-podgorica'; -- PG «Protein S (citratna plazma)»

-- lab:protein-s-100
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 42.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'protein-s-100' WHERE c.slug = 'milmedika-niksic'; -- NK «S100 protein (marker melanoma)»

-- lab:renin
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 32.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'renin' WHERE c.slug = 'milmedika-niksic'; -- NK «Renin (hormon regulacije krvnog pritiska)»

-- lab:rubella-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'rubella-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «Rubela IgG, Rubela IgM»

-- lab:spermatozoa-antibodies-asa
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'spermatozoa-antibodies-asa' WHERE c.slug = 'milmedika-podgorica'; -- PG «Anti-spermatozoidna antitijela»

-- lab:std-multiplex-8
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 125.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'std-multiplex-8' WHERE c.slug = 'milmedika-podgorica'; -- PG «STD Multiplex 8 – detekcija bilo koja 8 navedena patogena»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 125.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'std-multiplex-8' WHERE c.slug = 'milmedika-budva'; -- BD «STD Multiplex 8 – detekcija bilo koja 8 navedena patogena»

-- lab:thyroid-panel-tsh-ft3-ft4
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 26.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'thyroid-panel-tsh-ft3-ft4' WHERE c.slug = 'milmedika-podgorica'; -- PG «TSH, FT3, FT4»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 26.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'thyroid-panel-tsh-ft3-ft4' WHERE c.slug = 'milmedika-budva'; -- BD «TSH, FT3, FT4»

-- lab:toxoplasma-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'toxoplasma-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «TOXO IgG, TOXO IgM»

-- lab:ultra-sensitive-tsh
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 12.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'ultra-sensitive-tsh' WHERE c.slug = 'milmedika-podgorica'; -- PG «Ultra TSH (ultrasenzitivni TSH test)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 12.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'ultra-sensitive-tsh' WHERE c.slug = 'milmedika-budva'; -- BD «Ultra TSH (ultrasenzitivni TSH test)»

-- lab:uric-acid-in-urine
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 6.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'uric-acid-in-urine' WHERE c.slug = 'milmedika-podgorica'; -- PG «Mokraćna kiselina u urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 6.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'uric-acid-in-urine' WHERE c.slug = 'milmedika-budva'; -- BD «Mokraćna kiselina u urinu»

-- lab:varicella-zoster-igg-igm-panel
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 36.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'varicella-zoster-igg-igm-panel' WHERE c.slug = 'milmedika-podgorica'; -- PG «VZV IgG, VZV IgM (Varicella-zoster)»

-- lab:znt8-antibodies
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max)
SELECT c.id, e.id, 54.00, NULL FROM clinics c JOIN lab_tests e ON e.slug = 'znt8-antibodies' WHERE c.slug = 'milmedika-niksic'; -- NK «Anti-ZnT8 (marker autoimunog dijabetesa / tip 1)»

-- svc:crp-turbidimetry
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 10.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'crp-turbidimetry' WHERE c.slug = 'milmedika-podgorica'; -- PG «CRP (immunoturbidimetric rapid determination)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 10.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'crp-turbidimetry' WHERE c.slug = 'milmedika-budva'; -- BD «CRP (immunoturbidimetric rapid determination)»

-- svc:ct-scan-reading
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 50.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'ct-scan-reading' WHERE c.slug = 'milmedika-niksic'; -- NK «Opis CT pregleda»

-- svc:doppler-lower-extremities-and-neck
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 80.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'doppler-lower-extremities-and-neck' WHERE c.slug = 'milmedika-niksic'; -- NK «Dopler donjih ekstremiteta i vrata»

-- svc:ecg
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 15.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'ecg' WHERE c.slug = 'milmedika-budva'; -- BD «EKG»

-- svc:follow-up-specialist-examination
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 40.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'follow-up-specialist-examination' WHERE c.slug = 'milmedika-niksic'; -- NK «Kontrolni specijalistički pregled»

-- svc:follow-up-subspecialist-examination
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 50.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'follow-up-subspecialist-examination' WHERE c.slug = 'milmedika-podgorica'; -- PG «Kontrolni subspecijalistički pregled»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 50.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'follow-up-subspecialist-examination' WHERE c.slug = 'milmedika-budva'; -- BD «Subspecijalistički kontrolni pregled»

-- svc:nasopharyngolaryngoscopy-with-video-otoscopy
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 80.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'nasopharyngolaryngoscopy-with-video-otoscopy' WHERE c.slug = 'milmedika-podgorica'; -- PG «Nazofaringolaringoskopija sa video otoskopijom (kombinovani endoskopski pregled nosa, ždrijela i grkljana, uz video pregled uha)»

-- svc:peripheral-region-ultrasound
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 60.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'peripheral-region-ultrasound' WHERE c.slug = 'milmedika-niksic'; -- NK «Ultrazvuk perifernih regija»

-- svc:specialist-examination
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 50.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'specialist-examination' WHERE c.slug = 'milmedika-niksic'; -- NK «Specijalistički pregled»

-- svc:specialist-examination-with-ultrasound
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 80.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'specialist-examination-with-ultrasound' WHERE c.slug = 'milmedika-niksic'; -- NK «Specijalistički pregled sa ultrazvukom»

-- svc:subspecialist-examination
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 60.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'subspecialist-examination' WHERE c.slug = 'milmedika-podgorica'; -- PG «Subspecijalistički pregled»

-- svc:subspecialist-pediatric-physiatrist-examination
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 60.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'subspecialist-pediatric-physiatrist-examination' WHERE c.slug = 'milmedika-podgorica'; -- PG «Subspecijalisticki pregled dječijeg fizijatra»

-- svc:tympanometry
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 15.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'tympanometry' WHERE c.slug = 'milmedika-podgorica'; -- PG «Timpanometrija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 15.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'tympanometry' WHERE c.slug = 'milmedika-budva'; -- BD «Timpanometrija»

-- svc:ultrasound-infant-cns
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_max)
SELECT c.id, e.id, 40.00, NULL FROM clinics c JOIN medical_services e ON e.slug = 'ultrasound-infant-cns' WHERE c.slug = 'milmedika-niksic'; -- NK «Ultrazvuk CNS»

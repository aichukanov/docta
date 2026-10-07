SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Tesla Medical (Беране, slug tesla-medical-berane): спорные строки лабораторного прайса.
-- Дополняет insert-clinic-prices-tesla-medical-berane-lab.sql, применённый 2026-10-05 локально и на проде.
--
-- Источник: два PDF 2019 «radna verzija», снимки в data/clinic-pricelists/sources/tesla-medical-berane/
--   (cenovnik-biohemija-radna-verzija.pdf, cenovnik-mikrobiologija.pdf; дата 2019-11-26 — Last-Modified и CreationDate).
-- Перед сборкой сверено 2026-10-06: у клиники 882 строки анализов, локально = прод построчно
--   (POST /api/labtests/details по каждому slug, clinicPrices для клиники; на проде totalCount 882).
-- is_price_outdated не ставится (решение юзера 2026-10-05).
--
-- Сводка по 30 спорным строкам (разбор — data/clinic-imports/tesla-medical-berane-prices-2026-10.md, лаборатория, раздел 2):
--   18 новых строк clinic_lab_tests (19 строк прайса: два Aspergillus — одна строка диапазоном 14–15);
--   1 правка существующей строки: chlamydia-genital-swab 11–12 → 10–12 (M009, биопсийный материал);
--   2 строки прайса сведены к уже стоящим строкам с той же ценой: B179 → reticulocytes (без изменений), B246 → anti-bp230-antibodies (только синоним BP230-gC);
--   8 строк в excluded записи импорта (в SQL не попадают).
--   Новых записей каталога lab_tests — 13.
--
-- Клиника и записи каталога — только по slug. INSERT IGNORE / ON DUPLICATE KEY / UPDATE с условием на старую цену:
-- повторный прогон ничего не меняет.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'tesla-medical-berane');

-- ═══ 1. Новые записи каталога (13) ═══

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Aspergillus fumigatus IgE m3', 'aspergillus-fumigatus-ige-m3', 'Plijesan Aspergillus fumigatus IgE m3', 'Плијесан Aspergillus fumigatus IgE m3', 'Плесень Aspergillus fumigatus IgE m3', 'Schimmelpilz Aspergillus fumigatus IgE m3', 'Küf mantarı Aspergillus fumigatus IgE m3'),
('Epstein-Barr Antibody Profile', 'epstein-barr-antibody-profile', 'Profil antitijela na Epstein-Barr virus', 'Профил антитијела на Epstein-Barr вирус', 'Профиль антител к вирусу Эпштейна–Барр', 'Epstein-Barr-Virus-Antikörperprofil', 'Epstein-Barr virüsü antikor profili'),
('Erythromycin IgE', 'erythromycin-ige', 'Eritromicin IgE', 'Еритромицин IgE', 'Эритромицин IgE', 'IgE gegen Erythromycin', 'Eritromisin IgE'),
('Fish Mix fx74', 'fish-mix-fx74', 'Miks riba fx74', 'Микс риба fx74', 'Смесь рыб fx74', 'Fischmischung fx74', 'Balık karışımı fx74'),
('Hantavirus Antibodies', 'hantavirus-antibodies', 'Antitijela na Hanta virus', 'Антитијела на Hanta вирус', 'Антитела к хантавирусу', 'Hantavirus-Antikörper', 'Hantavirüs antikorları'),
('HER2 in Serum', 'her2-in-serum', 'HER2 u serumu', 'HER2 у серуму', 'HER2 в сыворотке', 'HER2 im Serum', 'Serumda HER2'),
('Hereditary Cancer Panel (30 Genes)', 'hereditary-cancer-panel-30-genes', 'Skrining na nasljedne karcinome (30 gena)', 'Скрининг на насљедне карциноме (30 гена)', 'Скрининг наследственных онкологических заболеваний (30 генов)', 'Panel für erbliche Krebserkrankungen (30 Gene)', 'Kalıtsal kanser paneli (30 gen)'),
('Long DNA Test', 'long-dna-test', 'Detekcija Long DNA', 'Детекција Long DNA', 'Тест Long DNA (длинная ДНК)', 'Long-DNA-Test', 'Long DNA testi'),
('Microdeletion Syndromes Panel', 'microdeletion-syndromes-panel', 'Mikrodelecijski sindromi (panel)', 'Микроделецијски синдроми (панел)', 'Панель микроделеционных синдромов', 'Mikrodeletionssyndrome – Panel', 'Mikrodelesyon sendromları paneli'),
('Myotonic Dystrophy Type 1 (DM1) Genetic Test', 'myotonic-dystrophy-type-1-dm1-genetic-test', 'Miotonična distrofija tip 1 (DM1) — genetsko ispitivanje', 'Миотонична дистрофија тип 1 (DM1) — генетско испитивање', 'Миотоническая дистрофия 1 типа (DM1) — генетический тест', 'Myotone Dystrophie Typ 1 (DM1) – Gentest', 'Miyotonik distrofi tip 1 (DM1) genetik testi'),
('Myotonic Dystrophy Type 2 (DM2) Genetic Test', 'myotonic-dystrophy-type-2-dm2-genetic-test', 'Miotonična distrofija tip 2 (DM2) — genetsko ispitivanje', 'Миотонична дистрофија тип 2 (DM2) — генетско испитивање', 'Миотоническая дистрофия 2 типа (DM2) — генетический тест', 'Myotone Dystrophie Typ 2 (DM2) – Gentest', 'Miyotonik distrofi tip 2 (DM2) genetik testi'),
('RSV Antibodies', 'rsv-antibodies', 'Antitijela na RSV', 'Антитијела на RSV', 'Антитела к RS-вирусу', 'RSV-Antikörper', 'RSV antikorları'),
('Total and Free Carnitine', 'total-and-free-carnitine', 'Ukupni i slobodni karnitin', 'Укупни и слободни карнитин', 'Общий и свободный карнитин', 'Gesamt- und freies Carnitin', 'Total ve serbest karnitin')
ON DUPLICATE KEY UPDATE name_en = name_en;

INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT lt.id, v.category_id FROM (
      SELECT 'aspergillus-fumigatus-ige-m3' AS slug, 13 AS category_id
UNION ALL SELECT 'epstein-barr-antibody-profile', 10
UNION ALL SELECT 'epstein-barr-antibody-profile', 24
UNION ALL SELECT 'erythromycin-ige', 13
UNION ALL SELECT 'fish-mix-fx74', 13
UNION ALL SELECT 'hantavirus-antibodies', 10
UNION ALL SELECT 'her2-in-serum', 6
UNION ALL SELECT 'hereditary-cancer-panel-30-genes', 20
UNION ALL SELECT 'hereditary-cancer-panel-30-genes', 24
UNION ALL SELECT 'long-dna-test', 6
UNION ALL SELECT 'long-dna-test', 22
UNION ALL SELECT 'microdeletion-syndromes-panel', 20
UNION ALL SELECT 'microdeletion-syndromes-panel', 24
UNION ALL SELECT 'myotonic-dystrophy-type-1-dm1-genetic-test', 20
UNION ALL SELECT 'myotonic-dystrophy-type-2-dm2-genetic-test', 20
UNION ALL SELECT 'rsv-antibodies', 10
UNION ALL SELECT 'total-and-free-carnitine', 3
) v JOIN lab_tests lt ON lt.slug = v.slug;

-- ═══ 2. Синонимы (19) ═══
-- UNIQUE (another_name, language) глобальный: перед сборкой проверено, что ни один не занят.

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
SELECT lt.id, v.another_name, v.language FROM (
      SELECT 'aspergillus-fumigatus-ige-m3' AS slug, 'Aspergillus IgE' AS another_name, 'en' AS language
UNION ALL SELECT 'aspergillus-fumigatus-ige-m3', 'Aspergillus fumigatus m3', 'sr'
UNION ALL SELECT 'epstein-barr-antibody-profile', 'EBV Profile', 'en'
UNION ALL SELECT 'epstein-barr-antibody-profile', 'EBV profil', 'sr'
UNION ALL SELECT 'fish-mix-fx74', 'Skrining alergena na ribu fx74', 'sr'
UNION ALL SELECT 'hantavirus-antibodies', 'Antitela prema Hanta virusu', 'sr'
UNION ALL SELECT 'her2-in-serum', 'HER-2/neu', 'en'
UNION ALL SELECT 'her2-in-serum', 'Serum HER2', 'en'
UNION ALL SELECT 'hereditary-cancer-panel-30-genes', 'Skrining na nasledne kancere (30 gena)', 'sr'
UNION ALL SELECT 'long-dna-test', 'Fecal Long DNA', 'en'
UNION ALL SELECT 'microdeletion-syndromes-panel', 'Mikrodelecijski sindromi', 'sr'
UNION ALL SELECT 'myotonic-dystrophy-type-1-dm1-genetic-test', 'DMPK', 'en'
UNION ALL SELECT 'myotonic-dystrophy-type-1-dm1-genetic-test', 'Steinert Disease', 'en'
UNION ALL SELECT 'myotonic-dystrophy-type-1-dm1-genetic-test', 'Miotonična distrofija (DMPK gen)', 'sr'
UNION ALL SELECT 'myotonic-dystrophy-type-2-dm2-genetic-test', 'CNBP', 'en'
UNION ALL SELECT 'myotonic-dystrophy-type-2-dm2-genetic-test', 'PROMM', 'en'
UNION ALL SELECT 'total-and-free-carnitine', 'Carnitine Fractions', 'en'
UNION ALL SELECT 'total-and-free-carnitine', 'Diferencijacija karnitina', 'sr'
UNION ALL SELECT 'anti-bp230-antibodies', 'BP230-gC', 'en'
) v JOIN lab_tests lt ON lt.slug = v.slug;

-- ═══ 3. Цены клиники (18 строк) ═══

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code)
SELECT @clinic_id, lt.id, v.price, v.price_max, NULL FROM (
      SELECT 'aspergillus-fumigatus-ige-m3' AS slug, 14.00 AS price, 15.00 AS price_max -- B034 «IgE-RAST-Aspergillus Profil» (14) / B013 «IgE-At Aspergillus screen 3» (15): IgE к Aspergillus по цене одиночного аллергена, не смесь mx4 (49)
UNION ALL SELECT 'erythromycin-ige', 15.00, NULL -- B048 «IgG-RAST Eritromicin»: в блоке лекарственных RAST все строки IgE по 15 €, «IgG» — опечатка
UNION ALL SELECT 'fish-mix-fx74', 49.00, NULL -- B054 «Skrining alergena na ribu (fx74)»: код fx74 ≠ FP2, как у соседних fx2/fx5
UNION ALL SELECT 'psychoactive-substances-panel-5-10-parameters', 25.00, NULL -- B456 «Droge u urinu - kvalitativno»: качественная панель без состава; запись без фиксированного числа веществ (FZOCG Z02091, 26,25 €)
UNION ALL SELECT 'hantavirus-antibodies', 11.00, NULL -- B566 «Antitela prema Hanta virusu»: класс не указан, как у malaria-/enterovirus-antibodies этого прайса
UNION ALL SELECT 'rsv-antibodies', 12.00, NULL -- B639 «RSV Antitela»: класс не указан
UNION ALL SELECT 'long-dna-test', 18.00, NULL -- B665 «Detekcija "Long DNA"»
UNION ALL SELECT 'hereditary-cancer-panel-30-genes', 220.00, NULL -- B687 «Skrining na nasledne kancere (30 gena)»: панели на 30 генов в каталоге нет (HerediGEN 33 — другой продукт)
UNION ALL SELECT 'dihydropyrimidine-dehydrogenase', 140.00, NULL -- B688 «Skipping mutacija u 14. exonu gena za DPD»: DPYD*2A — основной вариант генотипирования DPD; запись каталога генетическая (EDTA)
UNION ALL SELECT 'myotonic-dystrophy-type-1-dm1-genetic-test', 590.00, NULL -- B701 «Dišenova Muskularna Distrofija-Tip 1»: у Дюшенна типов нет, «тип 1/2» — миотоническая дистрофия DM1/DM2
UNION ALL SELECT 'myotonic-dystrophy-type-2-dm2-genetic-test', 590.00, NULL -- B702 «Dišenova Muskularna Distrofija-Tip 2»
UNION ALL SELECT 'microdeletion-syndromes-panel', 110.00, NULL -- B713 «Mikrodelecijski sindromi»: панель без перечня, отдельно от Angelman/Prader-Willi (B711, 130)
UNION ALL SELECT 'hpv-genotyping-pcr', 77.00, NULL -- B780 «Detekcija prisustva i genotipizacija HPV»: число типов не указано — общая запись «Genotipizacija HPV - PCR»
UNION ALL SELECT 'preeclampsia-screening-after-12-weeks', 110.00, NULL -- B807 «Profil Pre-Eklamsije»: лабораторный «профиль» = sFlt-1/PlGF, тест второй половины беременности
UNION ALL SELECT 'total-and-free-carnitine', 29.00, NULL -- B818 «Diferencijacija karnitina»: фракции карнитина, не МС-профиль ацилкарнитинов
UNION ALL SELECT 'her2-in-serum', 34.00, NULL -- B835 «HER-2 receptori»: раздел «Tumor markeri» (сывороточные маркеры), не тканевые рецепторы
UNION ALL SELECT 'epstein-barr-antibody-profile', 75.00, NULL -- B867 «EBV-Profil»: состав не указан, не равен IgG+IgM
UNION ALL SELECT 'cyclosporine-level', 57.00, NULL -- B525 «Cyclosporin A Monoklonalni (Neoral, Sandimmune)»: раздел иммуносупрессантов, ровня такролимусу/эверолимусу (57); B504 (16) — в excluded
) v JOIN lab_tests lt ON lt.slug = v.slug
WHERE @clinic_id IS NOT NULL;

-- ═══ 4. Правка существующей строки ═══
-- M009 «Biopsijski materijal- Chlamidiae trachomatis» (10): по образцу Mycoplasma/Ureaplasma того же прайса,
-- где биопсийный материал вошёл в диапазон записи по возбудителю (10–12). Было 11–12 (M046 / M091).

UPDATE clinic_lab_tests r
  JOIN lab_tests lt ON lt.id = r.lab_test_id
   SET r.price = 10.00
 WHERE r.clinic_id = @clinic_id AND lt.slug = 'chlamydia-genital-swab'
   AND r.price = 11.00 AND r.price_max = 12.00;

-- ═══ VERIFICATION ═══
SELECT @clinic_id AS clinic_id;
SELECT COUNT(*) AS lab_rows, SUM(is_price_outdated) AS outdated, SUM(price_max IS NOT NULL) AS ranges
  FROM clinic_lab_tests WHERE clinic_id = @clinic_id;
-- Ожидается: lab_rows 900 (882 + 18), outdated 0, ranges 13.
SELECT COUNT(*) AS new_catalog_entries FROM lab_tests WHERE slug IN (
  'aspergillus-fumigatus-ige-m3', 'epstein-barr-antibody-profile', 'erythromycin-ige', 'fish-mix-fx74', 'hantavirus-antibodies',
  'her2-in-serum', 'hereditary-cancer-panel-30-genes', 'long-dna-test', 'microdeletion-syndromes-panel',
  'myotonic-dystrophy-type-1-dm1-genetic-test', 'myotonic-dystrophy-type-2-dm2-genetic-test', 'rsv-antibodies', 'total-and-free-carnitine');
-- Ожидается 13.
SELECT COUNT(*) AS new_without_category FROM lab_tests lt
 WHERE lt.slug IN (
  'aspergillus-fumigatus-ige-m3', 'epstein-barr-antibody-profile', 'erythromycin-ige', 'fish-mix-fx74', 'hantavirus-antibodies',
  'her2-in-serum', 'hereditary-cancer-panel-30-genes', 'long-dna-test', 'microdeletion-syndromes-panel',
  'myotonic-dystrophy-type-1-dm1-genetic-test', 'myotonic-dystrophy-type-2-dm2-genetic-test', 'rsv-antibodies', 'total-and-free-carnitine')
   AND NOT EXISTS (SELECT 1 FROM lab_test_categories_relations r WHERE r.lab_test_id = lt.id);
-- Ожидается 0.
SELECT lt.slug, r.price, r.price_max FROM clinic_lab_tests r JOIN lab_tests lt ON lt.id = r.lab_test_id
 WHERE r.clinic_id = @clinic_id AND lt.slug IN (
  'aspergillus-fumigatus-ige-m3', 'erythromycin-ige', 'fish-mix-fx74', 'psychoactive-substances-panel-5-10-parameters',
  'hantavirus-antibodies', 'rsv-antibodies', 'long-dna-test', 'hereditary-cancer-panel-30-genes', 'dihydropyrimidine-dehydrogenase',
  'myotonic-dystrophy-type-1-dm1-genetic-test', 'myotonic-dystrophy-type-2-dm2-genetic-test', 'microdeletion-syndromes-panel',
  'hpv-genotyping-pcr', 'preeclampsia-screening-after-12-weeks', 'total-and-free-carnitine', 'her2-in-serum',
  'epstein-barr-antibody-profile', 'cyclosporine-level', 'chlamydia-genital-swab')
 ORDER BY lt.slug;
-- Ожидается 19 строк; chlamydia-genital-swab 10.00–12.00, aspergillus-fumigatus-ige-m3 14.00–15.00.
SELECT COUNT(*) AS new_synonyms FROM lab_test_synonyms s JOIN lab_tests lt ON lt.id = s.lab_test_id
 WHERE (lt.slug, s.another_name) IN (
  ('aspergillus-fumigatus-ige-m3', 'Aspergillus IgE'), ('aspergillus-fumigatus-ige-m3', 'Aspergillus fumigatus m3'),
  ('epstein-barr-antibody-profile', 'EBV Profile'), ('epstein-barr-antibody-profile', 'EBV profil'),
  ('fish-mix-fx74', 'Skrining alergena na ribu fx74'), ('hantavirus-antibodies', 'Antitela prema Hanta virusu'),
  ('her2-in-serum', 'HER-2/neu'), ('her2-in-serum', 'Serum HER2'),
  ('hereditary-cancer-panel-30-genes', 'Skrining na nasledne kancere (30 gena)'), ('long-dna-test', 'Fecal Long DNA'),
  ('microdeletion-syndromes-panel', 'Mikrodelecijski sindromi'),
  ('myotonic-dystrophy-type-1-dm1-genetic-test', 'DMPK'), ('myotonic-dystrophy-type-1-dm1-genetic-test', 'Steinert Disease'),
  ('myotonic-dystrophy-type-1-dm1-genetic-test', 'Miotonična distrofija (DMPK gen)'),
  ('myotonic-dystrophy-type-2-dm2-genetic-test', 'CNBP'), ('myotonic-dystrophy-type-2-dm2-genetic-test', 'PROMM'),
  ('total-and-free-carnitine', 'Carnitine Fractions'), ('total-and-free-carnitine', 'Diferencijacija karnitina'),
  ('anti-bp230-antibodies', 'BP230-gC'));
-- Ожидается 19.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Poliklinika Diagnostica (Подгорица, slug poliklinika-diagnostica-podgorica) — новый прайс.
--
-- Источник: открытый JSON https://api.diagnostica.me/api/public/pricelist
-- (страница https://diagnostica.me/cjenovnik — SPA, без JS пустая). Срез 2026-10-02, ETag W/"3076b-Su6M3Ps9/t8DYE4GkhRXVBti3hU".
-- Снимок: data/clinic-pricelists/sources/poliklinika-diagnostica-podgorica/2026-10-02.json.
-- Даты прайса в данных нет; на сайте цены «orijentacioni karakter». is_price_outdated = 0.
-- Запись импорта: data/clinic-imports/poliklinika-diagnostica-podgorica.json.
--
-- Позиций в источнике: 634 (lab 469, clinic 165).
-- Строк клиники: анализов 434, услуг 122.
--   на существующие записи: 472, на новые: 84 (новых записей каталога: анализов 67, услуг 17).
-- Не импортировано: спорных 40, исключено 38 — список в записи импорта.
--
-- Код позиции сайта (4 цифры) пишется в code строки клиники — по нему следующий прогон
-- сверяет прайс машинно. Записи каталога и клиника — по slug (id локально и на проде расходятся).
-- Идемпотентно: INSERT IGNORE / ON DUPLICATE KEY. Номер миграции присвоит юзер.

-- ═══ 1. Новые записи каталога ═══

-- lab:abdominal-drain-swab-for-fungi — коды 0739
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Abdominal Drain Swab for Fungi', 'abdominal-drain-swab-for-fungi', 'Bris abdominalnog drena na gljivice', 'Брис абдоминалног дрена на гљивице', 'Мазок из абдоминального дренажа на грибы', 'Bauchdrainageabstrich auf Pilze', 'Karın Dreni Sürüntüsünde Mantar')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'abdominal-drain-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u sadržaju abdominalnog drena', 'sr' FROM lab_tests WHERE slug = 'abdominal-drain-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев содержимого абдоминального дренажа на грибы', 'ru' FROM lab_tests WHERE slug = 'abdominal-drain-swab-for-fungi';

-- lab:adult-helminth-identification — коды 0774
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Adult Helminth Identification', 'adult-helminth-identification', 'Identifikacija adultnih oblika helminta', 'Идентификација адултних облика хелминта', 'Идентификация взрослых форм гельминтов', 'Identifizierung adulter Helminthen', 'Erişkin Helmint Formlarının Tanımlanması')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'adult-helminth-identification';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'adult-helminth-identification';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Worm Identification', 'en' FROM lab_tests WHERE slug = 'adult-helminth-identification';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Определение вида глиста', 'ru' FROM lab_tests WHERE slug = 'adult-helminth-identification';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Identifikacija glista', 'sr' FROM lab_tests WHERE slug = 'adult-helminth-identification';

-- lab:aspiration-catheter-tracheal-aspirate-culture-for-fungi — коды 0756
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Aspiration Catheter Tracheal Aspirate Culture for Fungi', 'aspiration-catheter-tracheal-aspirate-culture-for-fungi', 'Kultura aspiracionog katetera (trahealni aspirat) na gljivice', 'Култура аспирационог катетера (трахеални аспират) на гљивице', 'Посев с аспирационного катетера (трахеальный аспират) на грибы', 'Kultur des Absaugkatheters (Trachealsekret) auf Pilze', 'Aspirasyon Kateterinde (Trakeal Aspirat) Mantar Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'aspiration-catheter-tracheal-aspirate-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u aspiracionom kateteru - trahealni aspirat', 'sr' FROM lab_tests WHERE slug = 'aspiration-catheter-tracheal-aspirate-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Tracheal Aspirate Fungal Culture', 'en' FROM lab_tests WHERE slug = 'aspiration-catheter-tracheal-aspirate-culture-for-fungi';

-- lab:bronchoalveolar-lavage-culture-for-fungi — коды 0955
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Bronchoalveolar Lavage Culture for Fungi', 'bronchoalveolar-lavage-culture-for-fungi', 'Kultura bronhoalveolarnog lavata na gljivice', 'Култура бронхоалвеоларног лавата на гљивице', 'Посев бронхоальвеолярного лаважа на грибы', 'Bronchoalveoläre Lavage auf Pilze', 'Bronkoalveoler Lavajda Mantar Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'bronchoalveolar-lavage-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u bronhoalveolarnom lavatu', 'sr' FROM lab_tests WHERE slug = 'bronchoalveolar-lavage-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'BAL Fungal Culture', 'en' FROM lab_tests WHERE slug = 'bronchoalveolar-lavage-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'БАЛ на грибы', 'ru' FROM lab_tests WHERE slug = 'bronchoalveolar-lavage-culture-for-fungi';

-- lab:central-venous-catheter-culture-for-fungi — коды 0741
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Central Venous Catheter Culture for Fungi', 'central-venous-catheter-culture-for-fungi', 'Kultura centralnog venskog katetera na gljivice', 'Култура централног венског катетера на гљивице', 'Посев с центрального венозного катетера на грибы', 'Kultur des zentralen Venenkatheters auf Pilze', 'Santral Venöz Kateterde Mantar Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'central-venous-catheter-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u centralnom venskom kateteru', 'sr' FROM lab_tests WHERE slug = 'central-venous-catheter-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'CVC Fungal Culture', 'en' FROM lab_tests WHERE slug = 'central-venous-catheter-culture-for-fungi';

-- lab:cervical-swab-culture-anaerobic — коды 0773
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Cervical Swab Culture Anaerobic', 'cervical-swab-culture-anaerobic', 'Bakteriološko ispitivanje cervikalnog brisa - anaerobno', 'Бактериолошко испитивање цервикалног бриса - анаеробно', 'Бактериологическое исследование мазка из шейки матки - анаэробное', 'Anaerobe bakterielle Kultur eines Zervixabstrichs', 'Serviks Sürüntüsünün Anaerobik Bakteri Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'cervical-swab-culture-anaerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Anaerobic Bacterial Culture of Cervical Swab', 'en' FROM lab_tests WHERE slug = 'cervical-swab-culture-anaerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев из шейки матки на анаэробы', 'ru' FROM lab_tests WHERE slug = 'cervical-swab-culture-anaerobic';

-- lab:cf-and-sma-carrier-screening — коды 1118
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('CF and SMA Carrier Screening', 'cf-and-sma-carrier-screening', 'Ispitivanje nosilaštva cistične fibroze i SMA', 'Испитивање носилаштва цистичне фиброзе и SMA', 'Скрининг носительства муковисцидоза и СМА', 'Trägerscreening auf Mukoviszidose und SMA', 'Kistik Fibrozis ve SMA Taşıyıcılık Taraması')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'cf-and-sma-carrier-screening';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'CF & SMA Carrier', 'en' FROM lab_tests WHERE slug = 'cf-and-sma-carrier-screening';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Носительство муковисцидоза и спинальной мышечной атрофии', 'ru' FROM lab_tests WHERE slug = 'cf-and-sma-carrier-screening';

-- lab:clostridium-difficile-gdh-antigen — коды 1115
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Clostridium difficile GDH Antigen', 'clostridium-difficile-gdh-antigen', 'Clostridium difficile GDH antigen', 'Clostridium difficile GDH антиген', 'Антиген GDH Clostridium difficile', 'Clostridium-difficile-GDH-Antigen', 'Clostridium difficile GDH Antijeni')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 9 FROM lab_tests WHERE slug = 'clostridium-difficile-gdh-antigen';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'clostridium-difficile-gdh-antigen';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'C. difficile GDH', 'en' FROM lab_tests WHERE slug = 'clostridium-difficile-gdh-antigen';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glutamate Dehydrogenase Clostridium difficile', 'en' FROM lab_tests WHERE slug = 'clostridium-difficile-gdh-antigen';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Глутаматдегидрогеназа C. difficile', 'ru' FROM lab_tests WHERE slug = 'clostridium-difficile-gdh-antigen';

-- lab:cortisol-11h — коды 0942
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Cortisol 11h', 'cortisol-11h', 'Kortizol 11h', 'Кортизол 11h', 'Кортизол 11ч', 'Cortisol 11h', 'Kortizol 11s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'cortisol-11h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Kortizol u 11h', 'sr' FROM lab_tests WHERE slug = 'cortisol-11h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Кортизол в 11:00', 'ru' FROM lab_tests WHERE slug = 'cortisol-11h';

-- lab:cortisol-8h — коды 0941
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Cortisol 8h', 'cortisol-8h', 'Kortizol 8h', 'Кортизол 8h', 'Кортизол 8ч', 'Cortisol 8h', 'Kortizol 8s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'cortisol-8h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Kortizol u 8h', 'sr' FROM lab_tests WHERE slug = 'cortisol-8h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Кортизол в 8:00', 'ru' FROM lab_tests WHERE slug = 'cortisol-8h';

-- lab:drain-swab-for-fungi — коды 0751
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Drain Swab for Fungi', 'drain-swab-for-fungi', 'Bris drena na gljivice', 'Брис дрена на гљивице', 'Мазок из дренажа на грибы', 'Drainageabstrich auf Pilze', 'Dren Sürüntüsünde Mantar')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'drain-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u brisu drena', 'sr' FROM lab_tests WHERE slug = 'drain-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев из дренажа на грибы', 'ru' FROM lab_tests WHERE slug = 'drain-swab-for-fungi';

-- lab:endometrial-biopsy-culture-aerobic — коды 0725
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Endometrial Biopsy Culture Aerobic', 'endometrial-biopsy-culture-aerobic', 'Bakteriološko ispitivanje bioptata endometrijuma - aerobno', 'Бактериолошко испитивање биоптата ендометријума - аеробно', 'Бактериологическое исследование биоптата эндометрия - аэробное', 'Aerobe bakteriologische Kultur des Endometriumbioptats', 'Endometriyum Biyopsisinin Aerobik Bakteri Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'endometrial-biopsy-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Aerobic Bacterial Culture of Endometrial Biopsy', 'en' FROM lab_tests WHERE slug = 'endometrial-biopsy-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев биоптата эндометрия на аэробы', 'ru' FROM lab_tests WHERE slug = 'endometrial-biopsy-culture-aerobic';

-- lab:endometrial-biopsy-culture-anaerobic — коды 1036
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Endometrial Biopsy Culture Anaerobic', 'endometrial-biopsy-culture-anaerobic', 'Bakteriološko ispitivanje bioptata endometrijuma - anaerobno', 'Бактериолошко испитивање биоптата ендометријума - анаеробно', 'Бактериологическое исследование биоптата эндометрия - анаэробное', 'Anaerobe bakterielle Kultur des Endometriumbioptats', 'Endometriyum Biyopsisinin Anaerobik Bakteri Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'endometrial-biopsy-culture-anaerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Anaerobic Bacterial Culture of Endometrial Biopsy', 'en' FROM lab_tests WHERE slug = 'endometrial-biopsy-culture-anaerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев биоптата эндометрия на анаэробы', 'ru' FROM lab_tests WHERE slug = 'endometrial-biopsy-culture-anaerobic';

-- lab:glucose-12h — коды 0313
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Glucose 12h', 'glucose-12h', 'Glukoza 12h', 'Глукоза 12h', 'Глюкоза 12ч', 'Glukose 12h', 'Glikoz 12s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'glucose-12h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glukoza 12 h', 'sr' FROM lab_tests WHERE slug = 'glucose-12h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Сахар крови в 12 часов', 'ru' FROM lab_tests WHERE slug = 'glucose-12h';

-- lab:glucose-14h — коды 1112
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Glucose 14h', 'glucose-14h', 'Glukoza 14h', 'Глукоза 14h', 'Глюкоза 14ч', 'Glukose 14h', 'Glikoz 14s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'glucose-14h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glukoza 14 h', 'sr' FROM lab_tests WHERE slug = 'glucose-14h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Сахар крови в 14 часов', 'ru' FROM lab_tests WHERE slug = 'glucose-14h';

-- lab:glucose-15h — коды 1097
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Glucose 15h', 'glucose-15h', 'Glukoza 15h', 'Глукоза 15h', 'Глюкоза 15ч', 'Glukose 15h', 'Glikoz 15s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'glucose-15h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glukoza 15 h', 'sr' FROM lab_tests WHERE slug = 'glucose-15h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Сахар крови в 15 часов', 'ru' FROM lab_tests WHERE slug = 'glucose-15h';

-- lab:glucose-1h-after-meal — коды 0757
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Glucose 1h After Meal', 'glucose-1h-after-meal', 'Glukoza 1h poslije obroka', 'Глукоза 1h послије оброка', 'Глюкоза через 1ч после еды', 'Glukose 1h nach dem Essen', 'Yemekten 1 Saat Sonra Glikoz')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'glucose-1h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glukoza 1h nakon obroka', 'sr' FROM lab_tests WHERE slug = 'glucose-1h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Постпрандиальная глюкоза 1ч', 'ru' FROM lab_tests WHERE slug = 'glucose-1h-after-meal';

-- lab:glucose-2h-after-meal — коды 0758
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Glucose 2h After Meal', 'glucose-2h-after-meal', 'Glukoza 2h poslije obroka', 'Глукоза 2h послије оброка', 'Глюкоза через 2ч после еды', 'Glukose 2h nach dem Essen', 'Yemekten 2 Saat Sonra Glikoz')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'glucose-2h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glukoza 2h nakon obroka', 'sr' FROM lab_tests WHERE slug = 'glucose-2h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Постпрандиальная глюкоза 2ч', 'ru' FROM lab_tests WHERE slug = 'glucose-2h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Postprandial Glucose 2h', 'en' FROM lab_tests WHERE slug = 'glucose-2h-after-meal';

-- lab:glucose-after-150-min — коды 1022
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Glucose After 150 min', 'glucose-after-150-min', 'Glukoza poslije 150 min', 'Глукоза послије 150 мин', 'Глюкоза через 150 мин', 'Glukose nach 150 min', 'Glikoz 150 dk Sonrası')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'glucose-after-150-min';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glukoza 150 min', 'sr' FROM lab_tests WHERE slug = 'glucose-after-150-min';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Glu 150 min', 'en' FROM lab_tests WHERE slug = 'glucose-after-150-min';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Глюкоза 150 мин', 'ru' FROM lab_tests WHERE slug = 'glucose-after-150-min';

-- lab:high-sensitivity-c-reactive-protein — коды 0953
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('High-Sensitivity C-Reactive Protein', 'high-sensitivity-c-reactive-protein', 'C-reaktivni protein visoke osjetljivosti', 'Ц-реактивни протеин високе осјетљивости', 'С-реактивный белок высокочувствительный', 'Hochsensitives C-reaktives Protein', 'Yüksek Duyarlıklı C-Reaktif Protein')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 7 FROM lab_tests WHERE slug = 'high-sensitivity-c-reactive-protein';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 18 FROM lab_tests WHERE slug = 'high-sensitivity-c-reactive-protein';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'hsCRP', 'en' FROM lab_tests WHERE slug = 'high-sensitivity-c-reactive-protein';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'hs-CRP', 'sr' FROM lab_tests WHERE slug = 'high-sensitivity-c-reactive-protein';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'вчСРБ', 'ru' FROM lab_tests WHERE slug = 'high-sensitivity-c-reactive-protein';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'hs-CRP', 'de' FROM lab_tests WHERE slug = 'high-sensitivity-c-reactive-protein';

-- lab:human-herpesvirus-6-igg — коды 1085
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Human Herpesvirus 6 IgG', 'human-herpesvirus-6-igg', 'Humani herpesvirus 6 IgG', 'Хумани херпесвирус 6 IgG', 'Антитела к вирусу герпеса человека 6 типа IgG', 'Humanes Herpesvirus 6 IgG-Antikörper', 'İnsan Herpesvirüsü 6 IgG Antikoru')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'human-herpesvirus-6-igg';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'HHV-6 IgG', 'en' FROM lab_tests WHERE slug = 'human-herpesvirus-6-igg';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'HHV 6 IgG', 'sr' FROM lab_tests WHERE slug = 'human-herpesvirus-6-igg';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'ВГЧ-6 IgG', 'ru' FROM lab_tests WHERE slug = 'human-herpesvirus-6-igg';

-- lab:human-herpesvirus-6-igm — коды 1084
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Human Herpesvirus 6 IgM', 'human-herpesvirus-6-igm', 'Humani herpesvirus 6 IgM', 'Хумани херпесвирус 6 IgM', 'Антитела к вирусу герпеса человека 6 типа IgM', 'Humanes Herpesvirus 6 IgM-Antikörper', 'İnsan Herpesvirüsü 6 IgM Antikoru')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'human-herpesvirus-6-igm';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'HHV-6 IgM', 'en' FROM lab_tests WHERE slug = 'human-herpesvirus-6-igm';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'HHV 6 IgM', 'sr' FROM lab_tests WHERE slug = 'human-herpesvirus-6-igm';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'ВГЧ-6 IgM', 'ru' FROM lab_tests WHERE slug = 'human-herpesvirus-6-igm';

-- lab:implant-culture-aerobic — коды 0760
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Implant Culture Aerobic', 'implant-culture-aerobic', 'Bakteriološko ispitivanje implanta - aerobno', 'Бактериолошко испитивање импланта - аеробно', 'Бактериологическое исследование импланта - аэробное', 'Aerobe bakteriologische Kultur eines Implantats', 'İmplantın Aerobik Bakteri Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'implant-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Aerobic Bacterial Culture of Implant', 'en' FROM lab_tests WHERE slug = 'implant-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Prosthesis Culture', 'en' FROM lab_tests WHERE slug = 'implant-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев с импланта на аэробы', 'ru' FROM lab_tests WHERE slug = 'implant-culture-aerobic';

-- lab:insulin-12h — коды 0746
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Insulin 12h', 'insulin-12h', 'Insulin 12h', 'Инсулин 12h', 'Инсулин 12ч', 'Insulin 12h', 'İnsülin 12s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'insulin-12h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Insulin u 12h', 'sr' FROM lab_tests WHERE slug = 'insulin-12h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Инсулин в 12:00', 'ru' FROM lab_tests WHERE slug = 'insulin-12h';

-- lab:insulin-17h — коды 0747
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Insulin 17h', 'insulin-17h', 'Insulin 17h', 'Инсулин 17h', 'Инсулин 17ч', 'Insulin 17h', 'İnsülin 17s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'insulin-17h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Insulin u 17h', 'sr' FROM lab_tests WHERE slug = 'insulin-17h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Инсулин в 17:00', 'ru' FROM lab_tests WHERE slug = 'insulin-17h';

-- lab:insulin-20h — коды 0748
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Insulin 20h', 'insulin-20h', 'Insulin 20h', 'Инсулин 20h', 'Инсулин 20ч', 'Insulin 20h', 'İnsülin 20s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'insulin-20h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Insulin u 20h', 'sr' FROM lab_tests WHERE slug = 'insulin-20h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Инсулин в 20:00', 'ru' FROM lab_tests WHERE slug = 'insulin-20h';

-- lab:insulin-2h-after-meal — коды 0752
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Insulin 2h After Meal', 'insulin-2h-after-meal', 'Insulin 2h poslije obroka', 'Инсулин 2h послије оброка', 'Инсулин через 2ч после еды', 'Insulin 2h nach dem Essen', 'Yemekten 2 Saat Sonra İnsülin')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'insulin-2h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Insulin dva sata nakon obroka', 'sr' FROM lab_tests WHERE slug = 'insulin-2h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Postprandial Insulin', 'en' FROM lab_tests WHERE slug = 'insulin-2h-after-meal';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Постпрандиальный инсулин', 'ru' FROM lab_tests WHERE slug = 'insulin-2h-after-meal';

-- lab:insulin-7h — коды 0745
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Insulin 7h', 'insulin-7h', 'Insulin 7h', 'Инсулин 7h', 'Инсулин 7ч', 'Insulin 7h', 'İnsülin 7s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'insulin-7h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Insulin u 7h', 'sr' FROM lab_tests WHERE slug = 'insulin-7h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Инсулин в 7:00', 'ru' FROM lab_tests WHERE slug = 'insulin-7h';

-- lab:insulin-after-150-min — коды 0051
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Insulin After 150 min', 'insulin-after-150-min', 'Insulin poslije 150 min', 'Инсулин послије 150 мин', 'Инсулин через 150 мин', 'Insulin nach 150 min', 'İnsülin 150 dk Sonrası')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'insulin-after-150-min';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Insulin posle 150 min', 'sr' FROM lab_tests WHERE slug = 'insulin-after-150-min';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Инсулин после 150 мин', 'ru' FROM lab_tests WHERE slug = 'insulin-after-150-min';

-- lab:ldlhdl-ratio — коды 1041
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('LDL/HDL Ratio', 'ldlhdl-ratio', 'Odnos LDL/HDL holesterola', 'Однос LDL/HDL холестерола', 'Соотношение ЛПНП/ЛПВП', 'LDL/HDL-Quotient', 'LDL/HDL Oranı')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'ldlhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'LDL/HDL (indeks ateroskleroze)', 'sr' FROM lab_tests WHERE slug = 'ldlhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Indeks ateroskleroze', 'sr' FROM lab_tests WHERE slug = 'ldlhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Индекс ЛПНП/ЛПВП', 'ru' FROM lab_tests WHERE slug = 'ldlhdl-ratio';

-- lab:lochia-culture-for-fungi — коды 1034
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Lochia Culture for Fungi', 'lochia-culture-for-fungi', 'Kultura lohija na gljivice', 'Култура лохија на гљивице', 'Посев лохий на грибы', 'Lochienkultur auf Pilze', 'Loşi Kültüründe Mantar')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'lochia-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u lohijama', 'sr' FROM lab_tests WHERE slug = 'lochia-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Lochia Fungal Culture', 'en' FROM lab_tests WHERE slug = 'lochia-culture-for-fungi';

-- lab:matsuda-index — коды 1083
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Matsuda Index', 'matsuda-index', 'Matsuda indeks', 'Матсуда индекс', 'Индекс Мацуды', 'Matsuda-Index', 'Matsuda İndeksi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'matsuda-index';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'ISI Matsuda', 'en' FROM lab_tests WHERE slug = 'matsuda-index';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Matsuda Insulin Sensitivity Index', 'en' FROM lab_tests WHERE slug = 'matsuda-index';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Индекс инсулиночувствительности Matsuda', 'ru' FROM lab_tests WHERE slug = 'matsuda-index';

-- lab:mouth-corner-swab-for-bacteria — коды 0335
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Mouth Corner Swab for Bacteria', 'mouth-corner-swab-for-bacteria', 'Bris uglova usana na bakterije', 'Брис углова усана на бактерије', 'Мазок из уголков рта на бактерии', 'Mundwinkelabstrich auf Bakterien', 'Ağız Köşesi Sürüntüsünde Bakteri')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'mouth-corner-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Bakteriološko ispitivanje brisa uglova usana', 'sr' FROM lab_tests WHERE slug = 'mouth-corner-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Angular Cheilitis Swab Culture', 'en' FROM lab_tests WHERE slug = 'mouth-corner-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев из заед на бактерии', 'ru' FROM lab_tests WHERE slug = 'mouth-corner-swab-for-bacteria';

-- lab:mouth-corner-swab-for-fungi — коды 0336
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Mouth Corner Swab for Fungi', 'mouth-corner-swab-for-fungi', 'Bris uglova usana na gljivice', 'Брис углова усана на гљивице', 'Мазок из уголков рта на грибы', 'Mundwinkelabstrich auf Pilze', 'Ağız Köşesi Sürüntüsünde Mantar')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'mouth-corner-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u brisu uglova usana', 'sr' FROM lab_tests WHERE slug = 'mouth-corner-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Angular Cheilitis Fungal Culture', 'en' FROM lab_tests WHERE slug = 'mouth-corner-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев из заед на грибы', 'ru' FROM lab_tests WHERE slug = 'mouth-corner-swab-for-fungi';

-- lab:nail-swab-for-bacteria — коды 1047
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Nail Swab for Bacteria', 'nail-swab-for-bacteria', 'Bris nokta na bakterije', 'Брис нокта на бактерије', 'Мазок с ногтя на бактерии', 'Nagelabstrich auf Bakterien', 'Tırnak Sürüntüsünde Bakteri')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'nail-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Bakteriološko ispitivanje brisa nokta', 'sr' FROM lab_tests WHERE slug = 'nail-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Nail Swab Culture', 'en' FROM lab_tests WHERE slug = 'nail-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев с ногтя на бактерии', 'ru' FROM lab_tests WHERE slug = 'nail-swab-for-bacteria';

-- lab:nipt-fetal-rhd-genotyping — коды 1125
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT Fetal RhD Genotyping', 'nipt-fetal-rhd-genotyping', 'NIPT određivanje RhD statusa ploda', 'NIPT одређивање RhD статуса плода', 'НИПТ определение резус-фактора плода (RhD)', 'NIPT fetale RhD-Bestimmung', 'NIPT Fetal RhD Belirlemesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-fetal-rhd-genotyping';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-fetal-rhd-genotyping';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIPT RH', 'sr' FROM lab_tests WHERE slug = 'nipt-fetal-rhd-genotyping';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Fetal RhD from Maternal Blood', 'en' FROM lab_tests WHERE slug = 'nipt-fetal-rhd-genotyping';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Резус-фактор плода по крови матери', 'ru' FROM lab_tests WHERE slug = 'nipt-fetal-rhd-genotyping';

-- lab:nipt-nifty-basic — коды 0721
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT NIFTY Basic', 'nipt-nifty-basic', 'NIPT NIFTY Basic', 'NIPT NIFTY Basic', 'НИПТ NIFTY базовый', 'NIPT NIFTY Basispaket', 'NIPT NIFTY Temel Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-nifty-basic';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-nifty-basic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIFTY Basic', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-basic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIPT by GenePlanet Basic', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-basic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Нифти базовый', 'ru' FROM lab_tests WHERE slug = 'nipt-nifty-basic';

-- lab:nipt-nifty-plus — коды 0720
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT NIFTY Plus', 'nipt-nifty-plus', 'NIPT NIFTY Plus', 'NIPT NIFTY Plus', 'НИПТ NIFTY плюс', 'NIPT NIFTY Plus-Paket', 'NIPT NIFTY Plus Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-nifty-plus';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-nifty-plus';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIFTY Plus', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-plus';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIPT by GenePlanet Plus', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-plus';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Нифти плюс', 'ru' FROM lab_tests WHERE slug = 'nipt-nifty-plus';

-- lab:nipt-nifty-premium — коды 1105
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT NIFTY Premium', 'nipt-nifty-premium', 'NIPT NIFTY Premium', 'NIPT NIFTY Premium', 'НИПТ NIFTY Premium', 'NIPT NIFTY Premium-Paket', 'NIPT NIFTY Premium Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-nifty-premium';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-nifty-premium';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIFTY Premium', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-premium';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIPT by GenePlanet Premium', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-premium';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Нифти премиум', 'ru' FROM lab_tests WHERE slug = 'nipt-nifty-premium';

-- lab:nipt-nifty-pro — коды 1068
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT NIFTY Pro', 'nipt-nifty-pro', 'NIPT NIFTY Pro', 'NIPT NIFTY Pro', 'НИПТ NIFTY Pro', 'NIPT NIFTY Pro-Paket', 'NIPT NIFTY Pro Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-nifty-pro';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-nifty-pro';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIFTY Pro', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-pro';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIPT by GenePlanet Pro', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-pro';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Нифти про', 'ru' FROM lab_tests WHERE slug = 'nipt-nifty-pro';

-- lab:nipt-nifty-standard — коды 1098
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT NIFTY Standard', 'nipt-nifty-standard', 'NIPT NIFTY Standard', 'NIPT NIFTY Standard', 'НИПТ NIFTY стандартный', 'NIPT NIFTY Standardpaket', 'NIPT NIFTY Standart Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-nifty-standard';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-nifty-standard';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIFTY Standard', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-standard';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIPT by GenePlanet Standard', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-standard';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Нифти стандарт', 'ru' FROM lab_tests WHERE slug = 'nipt-nifty-standard';

-- lab:nipt-nifty-twins-basic — коды 1106
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT NIFTY Twins Basic', 'nipt-nifty-twins-basic', 'NIPT NIFTY za blizance Basic', 'NIPT NIFTY за близанце Basic', 'НИПТ NIFTY для двойни базовый', 'NIPT NIFTY Zwillinge Basispaket', 'NIPT NIFTY İkiz Temel Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-nifty-twins-basic';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-nifty-twins-basic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIFTY Twins Basic', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-twins-basic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Nifty twins basic', 'sr' FROM lab_tests WHERE slug = 'nipt-nifty-twins-basic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Нифти для двойни базовый', 'ru' FROM lab_tests WHERE slug = 'nipt-nifty-twins-basic';

-- lab:nipt-nifty-twins-pro — коды 1107
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('NIPT NIFTY Twins Pro', 'nipt-nifty-twins-pro', 'NIPT NIFTY za blizance Pro', 'NIPT NIFTY за близанце Pro', 'НИПТ NIFTY для двойни Pro', 'NIPT NIFTY Zwillinge Pro-Paket', 'NIPT NIFTY İkiz Pro Paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 19 FROM lab_tests WHERE slug = 'nipt-nifty-twins-pro';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'nipt-nifty-twins-pro';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'NIFTY Twins Pro', 'en' FROM lab_tests WHERE slug = 'nipt-nifty-twins-pro';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Nifty twins pro', 'sr' FROM lab_tests WHERE slug = 'nipt-nifty-twins-pro';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Нифти для двойни про', 'ru' FROM lab_tests WHERE slug = 'nipt-nifty-twins-pro';

-- lab:non-hdl-cholesterol — коды 1042
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Non-HDL Cholesterol', 'non-hdl-cholesterol', 'Non-HDL holesterol', 'Non-HDL холестерол', 'Холестерин не-ЛПВП', 'Non-HDL-Cholesterin', 'HDL Dışı Kolesterol')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'non-hdl-cholesterol';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'non HDL', 'sr' FROM lab_tests WHERE slug = 'non-hdl-cholesterol';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Non-HDL-C', 'en' FROM lab_tests WHERE slug = 'non-hdl-cholesterol';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Не-ЛПВП холестерин', 'ru' FROM lab_tests WHERE slug = 'non-hdl-cholesterol';

-- lab:non-hdlhdl-ratio — коды 1043
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Non-HDL/HDL Ratio', 'non-hdlhdl-ratio', 'Odnos non-HDL/HDL holesterola', 'Однос non-HDL/HDL холестерола', 'Соотношение не-ЛПВП/ЛПВП', 'Non-HDL/HDL-Quotient', 'HDL Dışı Kolesterol/HDL Oranı')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'non-hdlhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'non HDL/HDL', 'sr' FROM lab_tests WHERE slug = 'non-hdlhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Индекс не-ЛПВП/ЛПВП', 'ru' FROM lab_tests WHERE slug = 'non-hdlhdl-ratio';

-- lab:perineal-swab-for-bacteria — коды 0768
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Perineal Swab for Bacteria', 'perineal-swab-for-bacteria', 'Bris perineuma na bakterije', 'Брис перинеума на бактерије', 'Мазок с промежности на бактерии', 'Perinealabstrich auf Bakterien', 'Perine Sürüntüsünde Bakteri')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'perineal-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Bakteriološko ispitivanje brisa perineuma', 'sr' FROM lab_tests WHERE slug = 'perineal-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Perineum Swab Culture', 'en' FROM lab_tests WHERE slug = 'perineal-swab-for-bacteria';

-- lab:perineal-swab-for-fungi — коды 1119
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Perineal Swab for Fungi', 'perineal-swab-for-fungi', 'Bris perineuma na gljivice', 'Брис перинеума на гљивице', 'Мазок с промежности на грибы', 'Perinealabstrich auf Pilze', 'Perine Sürüntüsünde Mantar')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'perineal-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u brisu perineuma', 'sr' FROM lab_tests WHERE slug = 'perineal-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Perineum Fungal Culture', 'en' FROM lab_tests WHERE slug = 'perineal-swab-for-fungi';

-- lab:prolactin-12h — коды 1122
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Prolactin 12h', 'prolactin-12h', 'Prolaktin 12h', 'Пролактин 12h', 'Пролактин 12ч', 'Prolaktin 12h', 'Prolaktin 12s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'prolactin-12h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Prolaktin u 12h', 'sr' FROM lab_tests WHERE slug = 'prolactin-12h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Пролактин в 12:00', 'ru' FROM lab_tests WHERE slug = 'prolactin-12h';

-- lab:prolactin-14h — коды 1040
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Prolactin 14h', 'prolactin-14h', 'Prolaktin 14h', 'Пролактин 14h', 'Пролактин 14ч', 'Prolaktin 14h', 'Prolaktin 14s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'prolactin-14h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Prolaktin u 14h', 'sr' FROM lab_tests WHERE slug = 'prolactin-14h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Пролактин в 14:00', 'ru' FROM lab_tests WHERE slug = 'prolactin-14h';

-- lab:prolactin-15h — коды 1123
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Prolactin 15h', 'prolactin-15h', 'Prolaktin 15h', 'Пролактин 15h', 'Пролактин 15ч', 'Prolaktin 15h', 'Prolaktin 15s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'prolactin-15h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Prolaktin u 15h', 'sr' FROM lab_tests WHERE slug = 'prolactin-15h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Пролактин в 15:00', 'ru' FROM lab_tests WHERE slug = 'prolactin-15h';

-- lab:prolactin-17h — коды 0759
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Prolactin 17h', 'prolactin-17h', 'Prolaktin 17h', 'Пролактин 17h', 'Пролактин 17ч', 'Prolaktin 17h', 'Prolaktin 17s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'prolactin-17h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Prolaktin u 17h', 'sr' FROM lab_tests WHERE slug = 'prolactin-17h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Пролактин в 17:00', 'ru' FROM lab_tests WHERE slug = 'prolactin-17h';

-- lab:prolactin-8h — коды 0128
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Prolactin 8h', 'prolactin-8h', 'Prolaktin 8h', 'Пролактин 8h', 'Пролактин 8ч', 'Prolaktin 8h', 'Prolaktin 8s')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'prolactin-8h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Prolaktin u 8h', 'sr' FROM lab_tests WHERE slug = 'prolactin-8h';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Пролактин в 8:00', 'ru' FROM lab_tests WHERE slug = 'prolactin-8h';

-- lab:puncture-fluid-for-anaerobic-bacteria — коды 0744
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Puncture Fluid for Anaerobic Bacteria', 'puncture-fluid-for-anaerobic-bacteria', 'Punktat na anaerobne bakterije', 'Пунктат на анаеробне бактерије', 'Пунктат на анаэробные бактерии', 'Punktat auf anaerobe Bakterien', 'Ponksiyon Sıvısında Anaerobik Bakteri')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'puncture-fluid-for-anaerobic-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Bakteriološko ispitivanje punktata - anaerobno', 'sr' FROM lab_tests WHERE slug = 'puncture-fluid-for-anaerobic-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Punctate Anaerobic', 'en' FROM lab_tests WHERE slug = 'puncture-fluid-for-anaerobic-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев пунктата на анаэробы', 'ru' FROM lab_tests WHERE slug = 'puncture-fluid-for-anaerobic-bacteria';

-- lab:quicki-insulin-sensitivity-index — коды 1133
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('QUICKI Insulin Sensitivity Index', 'quicki-insulin-sensitivity-index', 'QUICKI indeks insulinske osjetljivosti', 'QUICKI индекс инсулинске осјетљивости', 'Индекс QUICKI (чувствительность к инсулину)', 'QUICKI-Insulinsensitivitätsindex', 'QUICKI İnsülin Duyarlılık İndeksi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 5 FROM lab_tests WHERE slug = 'quicki-insulin-sensitivity-index';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'QUICKI-IR', 'sr' FROM lab_tests WHERE slug = 'quicki-insulin-sensitivity-index';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'QUICKI', 'en' FROM lab_tests WHERE slug = 'quicki-insulin-sensitivity-index';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Индекс КВИКИ', 'ru' FROM lab_tests WHERE slug = 'quicki-insulin-sensitivity-index';

-- lab:renal-pelvis-lavage-culture-aerobic — коды 0734
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Renal Pelvis Lavage Culture Aerobic', 'renal-pelvis-lavage-culture-aerobic', 'Bakteriološko ispitivanje ispirka pijelona - aerobno', 'Бактериолошко испитивање испирка пијелона - аеробно', 'Бактериологическое исследование смыва из почечной лоханки - аэробное', 'Aerobe bakteriologische Kultur der Nierenbeckenspülflüssigkeit', 'Böbrek Pelvisi Lavajının Aerobik Bakteri Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'renal-pelvis-lavage-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Aerobic Bacterial Culture of Renal Pelvis Lavage', 'en' FROM lab_tests WHERE slug = 'renal-pelvis-lavage-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Pyelon Lavage Culture', 'en' FROM lab_tests WHERE slug = 'renal-pelvis-lavage-culture-aerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев смыва из лоханки почки', 'ru' FROM lab_tests WHERE slug = 'renal-pelvis-lavage-culture-aerobic';

-- lab:skin-scraping-for-sarcoptes-scabiei — коды 0369
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Skin Scraping for Sarcoptes scabiei', 'skin-scraping-for-sarcoptes-scabiei', 'Strugotina kože na Sarcoptes scabiei', 'Струготина коже на Sarcoptes scabiei', 'Соскоб кожи на Sarcoptes scabiei', 'Hautgeschabsel auf Sarcoptes scabiei', 'Deri Kazıntısında Sarcoptes scabiei')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'skin-scraping-for-sarcoptes-scabiei';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'skin-scraping-for-sarcoptes-scabiei';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Mikroskopsko ispitivanje strugotine kože/celofan otiska na prisustvo Sarcoptes scabiei', 'sr' FROM lab_tests WHERE slug = 'skin-scraping-for-sarcoptes-scabiei';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Scabies Mite Test', 'en' FROM lab_tests WHERE slug = 'skin-scraping-for-sarcoptes-scabiei';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Анализ на чесотку', 'ru' FROM lab_tests WHERE slug = 'skin-scraping-for-sarcoptes-scabiei';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Соскоб на чесоточного клеща', 'ru' FROM lab_tests WHERE slug = 'skin-scraping-for-sarcoptes-scabiei';

-- lab:sodium-in-urine — коды 1029
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Sodium in Urine', 'sodium-in-urine', 'Natrijum u urinu', 'Натријум у урину', 'Натрий в моче', 'Natrium im Urin', 'İdrarda Sodyum')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 4 FROM lab_tests WHERE slug = 'sodium-in-urine';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 8 FROM lab_tests WHERE slug = 'sodium-in-urine';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Urine Sodium', 'en' FROM lab_tests WHERE slug = 'sodium-in-urine';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Natrijum u mokraći', 'sr' FROM lab_tests WHERE slug = 'sodium-in-urine';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Натрий мочи', 'ru' FROM lab_tests WHERE slug = 'sodium-in-urine';

-- lab:soluble-transferrin-receptor — коды 1128
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Soluble Transferrin Receptor', 'soluble-transferrin-receptor', 'Solubilni transferinski receptor', 'Солубилни трансферински рецептор', 'Растворимые рецепторы трансферрина', 'Löslicher Transferrinrezeptor', 'Çözünür Transferrin Reseptörü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'soluble-transferrin-receptor';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'sTfR', 'en' FROM lab_tests WHERE slug = 'soluble-transferrin-receptor';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Solubilni transferinski receptori', 'sr' FROM lab_tests WHERE slug = 'soluble-transferrin-receptor';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'рТФР', 'ru' FROM lab_tests WHERE slug = 'soluble-transferrin-receptor';

-- lab:sputum-parasites — коды 1061
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Sputum Parasites', 'sputum-parasites', 'Paraziti u sputumu', 'Паразити у спутуму', 'Паразиты в мокроте', 'Parasiten im Sputum', 'Balgamda Parazit')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'sputum-parasites';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'sputum-parasites';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje sputuma na prisustvo parazita', 'sr' FROM lab_tests WHERE slug = 'sputum-parasites';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Sputum Microscopy for Parasites', 'en' FROM lab_tests WHERE slug = 'sputum-parasites';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Исследование мокроты на паразитов', 'ru' FROM lab_tests WHERE slug = 'sputum-parasites';

-- lab:thoracic-drain-swab-for-fungi — коды 1051
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Thoracic Drain Swab for Fungi', 'thoracic-drain-swab-for-fungi', 'Bris torakalnog drena na gljivice', 'Брис торакалног дрена на гљивице', 'Мазок из торакального дренажа на грибы', 'Thoraxdrainageabstrich auf Pilze', 'Göğüs Dreni Sürüntüsünde Mantar')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'thoracic-drain-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u torakalnom drenu', 'sr' FROM lab_tests WHERE slug = 'thoracic-drain-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев из плеврального дренажа на грибы', 'ru' FROM lab_tests WHERE slug = 'thoracic-drain-swab-for-fungi';

-- lab:total-cholesterolhdl-ratio — коды 1044
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Total Cholesterol/HDL Ratio', 'total-cholesterolhdl-ratio', 'Odnos ukupnog holesterola i HDL holesterola', 'Однос укупног холестерола и HDL холестерола', 'Соотношение общий холестерин/ЛПВП', 'Gesamtcholesterin/HDL-Quotient', 'Total Kolesterol/HDL Oranı')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 3 FROM lab_tests WHERE slug = 'total-cholesterolhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Holesterol/HDL', 'sr' FROM lab_tests WHERE slug = 'total-cholesterolhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'TC/HDL', 'en' FROM lab_tests WHERE slug = 'total-cholesterolhdl-ratio';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Коэффициент атерогенности', 'ru' FROM lab_tests WHERE slug = 'total-cholesterolhdl-ratio';

-- lab:urinary-catheter-tip-culture-for-fungi — коды 1038
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Urinary Catheter Tip Culture for Fungi', 'urinary-catheter-tip-culture-for-fungi', 'Kultura vrha urinarnog katetera na gljivice', 'Култура врха уринарног катетера на гљивице', 'Посев с кончика мочевого катетера на грибы', 'Kultur der Harnkatheterspitze auf Pilze', 'İdrar Kateteri Ucunda Mantar Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'urinary-catheter-tip-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica na vrhu urinarnog katetera', 'sr' FROM lab_tests WHERE slug = 'urinary-catheter-tip-culture-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u urinarnom kateteru', 'sr' FROM lab_tests WHERE slug = 'urinary-catheter-tip-culture-for-fungi';

-- lab:vaginal-introitus-and-anal-swab-for-bacteria — коды 0742
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Vaginal Introitus and Anal Swab for Bacteria', 'vaginal-introitus-and-anal-swab-for-bacteria', 'Bris introitusa vagine i anusa na bakterije', 'Брис интроитуса вагине и ануса на бактерије', 'Мазок из преддверия влагалища и ануса на бактерии', 'Abstrich von Scheideneingang und Anus auf Bakterien', 'Vajina Girişi ve Anüs Sürüntüsünde Bakteri')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'vaginal-introitus-and-anal-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Bakteriološko ispitivanje brisa introitusa vagine i anusa', 'sr' FROM lab_tests WHERE slug = 'vaginal-introitus-and-anal-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Vaginal-Anal Swab Culture', 'en' FROM lab_tests WHERE slug = 'vaginal-introitus-and-anal-swab-for-bacteria';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Вагинально-ректальный мазок на флору', 'ru' FROM lab_tests WHERE slug = 'vaginal-introitus-and-anal-swab-for-bacteria';

-- lab:vaginal-introitus-and-anal-swab-for-fungi — коды 0771
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Vaginal Introitus and Anal Swab for Fungi', 'vaginal-introitus-and-anal-swab-for-fungi', 'Bris introitusa vagine i anusa na gljivice', 'Брис интроитуса вагине и ануса на гљивице', 'Мазок из преддверия влагалища и ануса на грибы', 'Abstrich von Scheideneingang und Anus auf Pilze', 'Vajina Girişi ve Anüs Sürüntüsünde Mantar')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'vaginal-introitus-and-anal-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Ispitivanje prisustva gljivica u brisu introitusa vagine i anusa', 'sr' FROM lab_tests WHERE slug = 'vaginal-introitus-and-anal-swab-for-fungi';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Вагинально-ректальный мазок на грибы', 'ru' FROM lab_tests WHERE slug = 'vaginal-introitus-and-anal-swab-for-fungi';

-- lab:vaginal-swab-culture-anaerobic — коды 0772
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Vaginal Swab Culture Anaerobic', 'vaginal-swab-culture-anaerobic', 'Bakteriološko ispitivanje vaginalnog brisa - anaerobno', 'Бактериолошко испитивање вагиналног бриса - анаеробно', 'Бактериологическое исследование мазка из влагалища - анаэробное', 'Anaerobe bakterielle Kultur eines Vaginalabstrichs', 'Vajina Sürüntüsünün Anaerobik Bakteri Kültürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 21 FROM lab_tests WHERE slug = 'vaginal-swab-culture-anaerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Anaerobic Bacterial Culture of Vaginal Swab', 'en' FROM lab_tests WHERE slug = 'vaginal-swab-culture-anaerobic';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Посев из влагалища на анаэробы', 'ru' FROM lab_tests WHERE slug = 'vaginal-swab-culture-anaerobic';

-- lab:venisafe-materna-thrombophilia-panel — коды 1131
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('VeniSafe Materna Thrombophilia Panel', 'venisafe-materna-thrombophilia-panel', 'VeniSafe Materna panel trombofilije', 'VeniSafe Materna панел тромбофилије', 'VeniSafe Materna панель тромбофилии', 'VeniSafe Materna Thrombophilie-Panel', 'VeniSafe Materna Trombofili Paneli')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 20 FROM lab_tests WHERE slug = 'venisafe-materna-thrombophilia-panel';
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 24 FROM lab_tests WHERE slug = 'venisafe-materna-thrombophilia-panel';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Venisafe Materna', 'sr' FROM lab_tests WHERE slug = 'venisafe-materna-thrombophilia-panel';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Генетика тромбофилии при беременности', 'ru' FROM lab_tests WHERE slug = 'venisafe-materna-thrombophilia-panel';

-- lab:yersinia-igg-antibodies — коды 1089
INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Yersinia IgG Antibodies', 'yersinia-igg-antibodies', 'Yersinia IgG antitijela', 'Yersinia IgG антитијела', 'Антитела к Yersinia IgG', 'Yersinia-IgG-Antikörper', 'Yersinia IgG Antikorları')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 10 FROM lab_tests WHERE slug = 'yersinia-igg-antibodies';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Yersinia IgG', 'en' FROM lab_tests WHERE slug = 'yersinia-igg-antibodies';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Yersinia enterocolitica IgG', 'en' FROM lab_tests WHERE slug = 'yersinia-igg-antibodies';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'Иерсиниоз IgG', 'ru' FROM lab_tests WHERE slug = 'yersinia-igg-antibodies';

-- ms:3d4d-uterine-ultrasound-for-anomalies — коды 0851
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('3D/4D Uterine Ultrasound for Anomalies', '3d4d-uterine-ultrasound-for-anomalies', '3D/4D ultrazvučni pregled materice na anomalije', '3D/4D ултразвучни преглед материце на аномалије', '3D/4D УЗИ матки на аномалии развития', '3D/4D-Ultraschall der Gebärmutter auf Fehlbildungen', 'Rahim Anomalileri İçin 3D/4D Ultrason')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = '3d4d-uterine-ultrasound-for-anomalies';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = '3d4d-uterine-ultrasound-for-anomalies';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = '3d4d-uterine-ultrasound-for-anomalies';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, '3D ultrazvuk materice', 'sr' FROM medical_services WHERE slug = '3d4d-uterine-ultrasound-for-anomalies';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, '3D УЗИ матки', 'ru' FROM medical_services WHERE slug = '3d4d-uterine-ultrasound-for-anomalies';

-- ms:antral-follicle-count-ultrasound-afc — коды 0850
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Antral Follicle Count Ultrasound (AFC)', 'antral-follicle-count-ultrasound-afc', 'Ultrazvučno određivanje ovarijalne rezerve (AFC)', 'Ултразвучно одређивање оваријалне резерве (AFC)', 'УЗИ-подсчёт антральных фолликулов (AFC)', 'Ultraschall-Zählung der Antralfollikel (AFC)', 'Antral Folikül Sayımı Ultrasonu (AFC)')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'antral-follicle-count-ultrasound-afc';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'antral-follicle-count-ultrasound-afc';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'antral-follicle-count-ultrasound-afc';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 38 FROM medical_services WHERE slug = 'antral-follicle-count-ultrasound-afc';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'AFC', 'en' FROM medical_services WHERE slug = 'antral-follicle-count-ultrasound-afc';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ovarian Reserve Ultrasound', 'en' FROM medical_services WHERE slug = 'antral-follicle-count-ultrasound-afc';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'УЗИ овариального резерва', 'ru' FROM medical_services WHERE slug = 'antral-follicle-count-ultrasound-afc';

-- ms:breast-abscess-puncture-and-drainage — коды 0873
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Breast Abscess Puncture and Drainage', 'breast-abscess-puncture-and-drainage', 'Punkcija i drenaža apscesa dojke', 'Пункција и дренажа апсцеса дојке', 'Пункция и дренирование абсцесса молочной железы', 'Punktion und Drainage eines Brustabszesses', 'Meme Apsesi Ponksiyonu ve Drenajı')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 15 FROM medical_services WHERE slug = 'breast-abscess-puncture-and-drainage';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 17 FROM medical_services WHERE slug = 'breast-abscess-puncture-and-drainage';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 3 FROM medical_services WHERE slug = 'breast-abscess-puncture-and-drainage';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Breast Abscess Aspiration', 'en' FROM medical_services WHERE slug = 'breast-abscess-puncture-and-drainage';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Пункция абсцесса груди', 'ru' FROM medical_services WHERE slug = 'breast-abscess-puncture-and-drainage';

-- ms:doppler-of-neck-upper-and-lower-extremity-blood-vessels — коды 0818
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Doppler of Neck, Upper and Lower Extremity Blood Vessels', 'doppler-of-neck-upper-and-lower-extremity-blood-vessels', 'Dopler krvnih sudova vrata, gornjih i donjih ekstremiteta', 'Доплер крвних судова врата, горњих и доњих екстремитета', 'Допплер сосудов шеи, верхних и нижних конечностей', 'Doppler-Sonographie der Hals-, Arm- und Beingefäße', 'Boyun, Üst ve Alt Ekstremite Damarlarının Doppler Ultrasonu')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'doppler-of-neck-upper-and-lower-extremity-blood-vessels';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Dopler krvnih sudova vrata, donjih i gornjih ekstremiteta', 'sr' FROM medical_services WHERE slug = 'doppler-of-neck-upper-and-lower-extremity-blood-vessels';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'УЗДГ сосудов шеи и конечностей', 'ru' FROM medical_services WHERE slug = 'doppler-of-neck-upper-and-lower-extremity-blood-vessels';

-- ms:ecg-without-interpretation — коды 0801
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('ECG without Interpretation', 'ecg-without-interpretation', 'EKG bez opisa', 'ЕКГ без описа', 'ЭКГ без расшифровки', 'EKG ohne Befundung', 'Yorumsuz EKG')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 8 FROM medical_services WHERE slug = 'ecg-without-interpretation';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 1 FROM medical_services WHERE slug = 'ecg-without-interpretation';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'EKG bez opisa - samo traka', 'sr' FROM medical_services WHERE slug = 'ecg-without-interpretation';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'ECG Recording Only', 'en' FROM medical_services WHERE slug = 'ecg-without-interpretation';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Запись ЭКГ без описания', 'ru' FROM medical_services WHERE slug = 'ecg-without-interpretation';

-- ms:family-planning-and-pregnancy-counseling — коды 0862
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Family Planning and Pregnancy Counseling', 'family-planning-and-pregnancy-counseling', 'Savjetovanje o planiranju porodice i trudnoće', 'Савјетовање о планирању породице и трудноће', 'Консультация по планированию семьи и беременности', 'Beratung zur Familien- und Schwangerschaftsplanung', 'Aile ve Gebelik Planlaması Danışmanlığı')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'family-planning-and-pregnancy-counseling';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'family-planning-and-pregnancy-counseling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Prekoncepcijsko savjetovanje', 'sr' FROM medical_services WHERE slug = 'family-planning-and-pregnancy-counseling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Preconception Counseling', 'en' FROM medical_services WHERE slug = 'family-planning-and-pregnancy-counseling';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Планирование беременности', 'ru' FROM medical_services WHERE slug = 'family-planning-and-pregnancy-counseling';

-- ms:fetal-echocardiography — коды 1099
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Fetal Echocardiography', 'fetal-echocardiography', 'Fetalna ehokardiografija', 'Фетална ехокардиографија', 'Эхокардиография плода', 'Fetale Echokardiographie', 'Fetal Ekokardiyografi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'fetal-echocardiography';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'fetal-echocardiography';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 8 FROM medical_services WHERE slug = 'fetal-echocardiography';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'fetal-echocardiography';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 1 FROM medical_services WHERE slug = 'fetal-echocardiography';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Fetalni eho srca', 'sr' FROM medical_services WHERE slug = 'fetal-echocardiography';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'УЗИ сердца плода', 'ru' FROM medical_services WHERE slug = 'fetal-echocardiography';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Fetal Echo', 'en' FROM medical_services WHERE slug = 'fetal-echocardiography';

-- ms:glutathione-iv — коды 1114
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Glutathione IV', 'glutathione-iv', 'Glutation infuzija', 'Глутатион инфузија', 'Инфузия глутатиона', 'Glutathion-Infusion', 'Glutatyon İnfüzyonu')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 29 FROM medical_services WHERE slug = 'glutathione-iv';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Glutathione Infusion', 'en' FROM medical_services WHERE slug = 'glutathione-iv';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Капельница с глутатионом', 'ru' FROM medical_services WHERE slug = 'glutathione-iv';

-- ms:home-visit-for-laboratory-sample-collection — коды 0154
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Home Visit for Laboratory Sample Collection', 'home-visit-for-laboratory-sample-collection', 'Kućna posjeta laboratorije (uzimanje uzoraka)', 'Кућна посјета лабораторије (узимање узорака)', 'Выезд лаборанта на дом для забора анализов', 'Hausbesuch zur Laborprobenentnahme', 'Evde Laboratuvar Numunesi Alma Ziyareti')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 30 FROM medical_services WHERE slug = 'home-visit-for-laboratory-sample-collection';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 28 FROM medical_services WHERE slug = 'home-visit-for-laboratory-sample-collection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kućna posjeta - laboratorija', 'sr' FROM medical_services WHERE slug = 'home-visit-for-laboratory-sample-collection';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Забор крови на дому', 'ru' FROM medical_services WHERE slug = 'home-visit-for-laboratory-sample-collection';

-- ms:ovulation-induction-with-folliculometry — коды 0854
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Ovulation Induction with Folliculometry', 'ovulation-induction-with-folliculometry', 'Indukcija ovulacije i folikulometrija', 'Индукција овулације и фоликулометрија', 'Стимуляция овуляции с фолликулометрией', 'Ovulationsinduktion mit Follikelmonitoring', 'Folikülometri ile Ovulasyon İndüksiyonu')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'ovulation-induction-with-folliculometry';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'ovulation-induction-with-folliculometry';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'ovulation-induction-with-folliculometry';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 38 FROM medical_services WHERE slug = 'ovulation-induction-with-folliculometry';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Indukcija/stimulacija ovulacije i folikulometrija', 'sr' FROM medical_services WHERE slug = 'ovulation-induction-with-folliculometry';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Stimulacija ovulacije', 'sr' FROM medical_services WHERE slug = 'ovulation-induction-with-folliculometry';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Индукция овуляции', 'ru' FROM medical_services WHERE slug = 'ovulation-induction-with-folliculometry';

-- ms:pediatric-echocardiography — коды 1056
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Pediatric Echocardiography', 'pediatric-echocardiography', 'Ehokardiografija kod djece', 'Ехокардиографија код дјеце', 'Эхокардиография у детей', 'Echokardiographie bei Kindern', 'Çocuklarda Ekokardiyografi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'pediatric-echocardiography';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 8 FROM medical_services WHERE slug = 'pediatric-echocardiography';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 25 FROM medical_services WHERE slug = 'pediatric-echocardiography';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 1 FROM medical_services WHERE slug = 'pediatric-echocardiography';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 4 FROM medical_services WHERE slug = 'pediatric-echocardiography';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Eho srca - djeca', 'sr' FROM medical_services WHERE slug = 'pediatric-echocardiography';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'УЗИ сердца у детей', 'ru' FROM medical_services WHERE slug = 'pediatric-echocardiography';

-- ms:pediatric-examination-with-spirometry — коды 1010
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Pediatric Examination with Spirometry', 'pediatric-examination-with-spirometry', 'Pregled pedijatra sa spirometrijom', 'Преглед педијатра са спирометријом', 'Осмотр педиатра со спирометрией', 'Kinderärztliche Untersuchung mit Spirometrie', 'Spirometri ile Çocuk Doktoru Muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 25 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 12 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 4 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 14 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Педиатр + спирометрия', 'ru' FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry';

-- ms:pediatric-examination-with-spirometry-and-bronchodilator-test — коды 1011
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Pediatric Examination with Spirometry and Bronchodilator Test', 'pediatric-examination-with-spirometry-and-bronchodilator-test', 'Pregled pedijatra sa spirometrijom i bronhodilatatornim testom', 'Преглед педијатра са спирометријом и бронходилататорним тестом', 'Осмотр педиатра со спирометрией и бронходилатационным тестом', 'Kinderärztliche Untersuchung mit Spirometrie und Bronchodilatationstest', 'Spirometri ve Bronkodilatör Testi ile Çocuk Doktoru Muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 25 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry-and-bronchodilator-test';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 12 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry-and-bronchodilator-test';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 4 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry-and-bronchodilator-test';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 14 FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry-and-bronchodilator-test';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pregled pedijatra sa spirometrijom i BDT', 'sr' FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry-and-bronchodilator-test';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pediatric Examination with Spirometry and BDT', 'en' FROM medical_services WHERE slug = 'pediatric-examination-with-spirometry-and-bronchodilator-test';

-- ms:postpartum-breast-examination — коды 0872
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Postpartum Breast Examination', 'postpartum-breast-examination', 'Pregled dojki poslije porođaja', 'Преглед дојки послије порођаја', 'Осмотр молочных желёз после родов', 'Brustuntersuchung nach der Geburt', 'Doğum Sonrası Meme Muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'postpartum-breast-examination';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'postpartum-breast-examination';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pregled grudi poslije porođaja (zastoj laktacije, upala)', 'sr' FROM medical_services WHERE slug = 'postpartum-breast-examination';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Осмотр при лактостазе и мастите', 'ru' FROM medical_services WHERE slug = 'postpartum-breast-examination';

-- ms:postpartum-gynecological-examination-with-ultrasound — коды 0870
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Postpartum Gynecological Examination with Ultrasound', 'postpartum-gynecological-examination-with-ultrasound', 'Ginekološki pregled sa ultrazvukom poslije porođaja', 'Гинеколошки преглед са ултразвуком послије порођаја', 'Послеродовой гинекологический осмотр с УЗИ', 'Gynäkologische Untersuchung mit Ultraschall nach der Geburt', 'Doğum Sonrası Ultrasonlu Jinekolojik Muayene')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'postpartum-gynecological-examination-with-ultrasound';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'postpartum-gynecological-examination-with-ultrasound';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'postpartum-gynecological-examination-with-ultrasound';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ginekološki pregled + ultrazvučni pregled poslije porođaja', 'sr' FROM medical_services WHERE slug = 'postpartum-gynecological-examination-with-ultrasound';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Осмотр гинеколога после родов с УЗИ', 'ru' FROM medical_services WHERE slug = 'postpartum-gynecological-examination-with-ultrasound';

-- ms:secondary-suture-of-episiotomy-or-perineal-tear — коды 0871
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Secondary Suture of Episiotomy or Perineal Tear', 'secondary-suture-of-episiotomy-or-perineal-tear', 'Sekundarno ušivanje epiziotomije ili rupture međice', 'Секундарно ушивање епизиотомије или руптуре међице', 'Повторное ушивание эпизиотомии или разрыва промежности', 'Sekundärnaht einer Episiotomie oder eines Dammrisses', 'Epizyotomi veya Perine Yırtığının Sekonder Sütürü')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'secondary-suture-of-episiotomy-or-perineal-tear';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 31 FROM medical_services WHERE slug = 'secondary-suture-of-episiotomy-or-perineal-tear';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'secondary-suture-of-episiotomy-or-perineal-tear';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Ponovno ušivanje epiziotomije', 'sr' FROM medical_services WHERE slug = 'secondary-suture-of-episiotomy-or-perineal-tear';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Episiotomy Resuture', 'en' FROM medical_services WHERE slug = 'secondary-suture-of-episiotomy-or-perineal-tear';

-- ms:transvaginal-ovarian-cyst-puncture — коды 0836
INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Transvaginal Ovarian Cyst Puncture', 'transvaginal-ovarian-cyst-puncture', 'Transvaginalna punkcija ciste jajnika', 'Трансвагинална пункција цисте јајника', 'Трансвагинальная пункция кисты яичника', 'Transvaginale Punktion einer Ovarialzyste', 'Transvajinal Over Kisti Ponksiyonu')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 7 FROM medical_services WHERE slug = 'transvaginal-ovarian-cyst-puncture';
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 16 FROM medical_services WHERE slug = 'transvaginal-ovarian-cyst-puncture';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 5 FROM medical_services WHERE slug = 'transvaginal-ovarian-cyst-puncture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Punkcija ciste jajnika transvaginalno', 'sr' FROM medical_services WHERE slug = 'transvaginal-ovarian-cyst-puncture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Transvaginal Ovarian Cyst Aspiration', 'en' FROM medical_services WHERE slug = 'transvaginal-ovarian-cyst-puncture';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Пункция кисты яичника через влагалище', 'ru' FROM medical_services WHERE slug = 'transvaginal-ovarian-cyst-puncture';

-- ═══ 2. Строки клиники ═══

-- ── 2.1 Анализы (clinic_lab_tests)
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0001' FROM clinics c JOIN lab_tests e ON e.slug = 'complete-urinalysis' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0001 «Cjelokupan pregled urina»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0002' FROM clinics c JOIN lab_tests e ON e.slug = 'protein-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0002 «Proteini u urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0003' FROM clinics c JOIN lab_tests e ON e.slug = 'protein-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0003 «Proteini u 24h urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0005' FROM clinics c JOIN lab_tests e ON e.slug = 'microalbumin-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0005 «ALBUMIN u urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0006' FROM clinics c JOIN lab_tests e ON e.slug = 'microalbumin-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0006 «ALBUMIN u 24h urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0007' FROM clinics c JOIN lab_tests e ON e.slug = 'urea-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0007 «UREA U URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0008' FROM clinics c JOIN lab_tests e ON e.slug = 'urea-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0008 «UREA U 24h URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0009' FROM clinics c JOIN lab_tests e ON e.slug = 'urea-clearance' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0009 «KLIRENS UREE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0010' FROM clinics c JOIN lab_tests e ON e.slug = 'creatinine-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0010 «KREATININ U URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0011' FROM clinics c JOIN lab_tests e ON e.slug = 'creatinine-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0011 «KREATININ U 24h URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0012' FROM clinics c JOIN lab_tests e ON e.slug = 'creatinine-clearance' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0012 «KLIRENS KREATININA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0013' FROM clinics c JOIN lab_tests e ON e.slug = 'uric-acid-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0013 «MOKRAĆNA KISELINA U URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0014' FROM clinics c JOIN lab_tests e ON e.slug = 'uric-acid-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0014 «MOKRAĆNA KISELINA U 24h URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0015' FROM clinics c JOIN lab_tests e ON e.slug = 'calcium-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0015 «KALCIJUM U URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0016' FROM clinics c JOIN lab_tests e ON e.slug = 'calcium-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0016 «KALCIJUM U 24h URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0017' FROM clinics c JOIN lab_tests e ON e.slug = 'phosphorus-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0017 «FOSFATI U URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0018' FROM clinics c JOIN lab_tests e ON e.slug = 'phosphorus-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0018 «FOSFATI U 24h URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0019' FROM clinics c JOIN lab_tests e ON e.slug = 'magnesium-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0019 «MAGNEZIJUM U URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0020' FROM clinics c JOIN lab_tests e ON e.slug = 'magnesium-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0020 «MAGNEZIJUM U 24h URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0021' FROM clinics c JOIN lab_tests e ON e.slug = 'amylase-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0021 «AMILAZA U URINU»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0022' FROM clinics c JOIN lab_tests e ON e.slug = 'vma' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0022 «VMA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0023' FROM clinics c JOIN lab_tests e ON e.slug = '5-hiaa' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0023 «5- HIAA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 35.00, NULL, '0025' FROM clinics c JOIN lab_tests e ON e.slug = 'drug-panel-5-new' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0025 «PANEL 5 DROGA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 55.00, NULL, '0026' FROM clinics c JOIN lab_tests e ON e.slug = 'drug-panel-10-ii' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0026 «PANEL 10 DROGA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0027' FROM clinics c JOIN lab_tests e ON e.slug = 'fecal-occult-blood' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0027 «STOLICA NA OKULTNO KRVARENJE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0032' FROM clinics c JOIN lab_tests e ON e.slug = 'erythrocyte-sedimentation-rate' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0032 «SEDIMENTACIJA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.50, NULL, '0033' FROM clinics c JOIN lab_tests e ON e.slug = 'c-reactive-protein' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0033 «C-REAKTIVNI PROTEIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0034' FROM clinics c JOIN lab_tests e ON e.slug = 'fibrinogen' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0034 «FIBRINOGEN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0035' FROM clinics c JOIN lab_tests e ON e.slug = 'bleeding-time' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0035 «VREME KRVARENJA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0036' FROM clinics c JOIN lab_tests e ON e.slug = 'coagulation-time' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0036 «VREME KOAGULACIJE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0038' FROM clinics c JOIN lab_tests e ON e.slug = 'activated-partial-thromboplastin-time' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0038 «a PTT»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0039' FROM clinics c JOIN lab_tests e ON e.slug = 'd-dimer' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0039 «D-DIMER»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0040' FROM clinics c JOIN lab_tests e ON e.slug = 'lupus-anticoagulant' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0040 «LUPUS ANTIKOAGULANS 1»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0041' FROM clinics c JOIN lab_tests e ON e.slug = 'antithrombin-iii' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0041 «ANTITROMBIN III»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0044' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0044 «Glukoza»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0045' FROM clinics c JOIN lab_tests e ON e.slug = 'hba1c' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0045 «Hba1c»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0046' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0046 «Insulin»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0047' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-after-30-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0047 «Insulin posle 30 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0048' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-after-60-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0048 «Insulin posle 60 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0049' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-after-90-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0049 «Insulin posle 90 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0050' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-after-120-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0050 «Insulin posle 120 min»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0051' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-after-150-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0051 «Insulin posle 150 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0052' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-after-180-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0052 «Insulin posle 180 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0053' FROM clinics c JOIN lab_tests e ON e.slug = 'c-peptide' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0053 «C-peptid»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0054' FROM clinics c JOIN lab_tests e ON e.slug = 'c-peptide-after-30-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0054 «C-peptid posle 30 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0055' FROM clinics c JOIN lab_tests e ON e.slug = 'c-peptide-after-60-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0055 «C-peptid posle 60 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0056' FROM clinics c JOIN lab_tests e ON e.slug = 'c-peptide-after-90-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0056 «C-peptid posle 90 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0057' FROM clinics c JOIN lab_tests e ON e.slug = 'c-peptide-after-120-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0057 «C-peptid posle 120 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0058' FROM clinics c JOIN lab_tests e ON e.slug = 'c-peptide-after-150-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0058 «C-peptid posle 150 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0059' FROM clinics c JOIN lab_tests e ON e.slug = 'c-peptide-after-180-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0059 «C-peptid posle 180 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0061' FROM clinics c JOIN lab_tests e ON e.slug = 'cholesterol' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0061 «HOLESTEROL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0062' FROM clinics c JOIN lab_tests e ON e.slug = 'hdl-cholesterol' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0062 «HDL HOLESTEROL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0063' FROM clinics c JOIN lab_tests e ON e.slug = 'ldl-cholesterol' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0063 «LDL HOLESTEROL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0064' FROM clinics c JOIN lab_tests e ON e.slug = 'triglycerides' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0064 «TRIGLICERIDI»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0065' FROM clinics c JOIN lab_tests e ON e.slug = 'albumin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0065 «ALBUMINI»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0066' FROM clinics c JOIN lab_tests e ON e.slug = 'total-protein' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0066 «PROTEINI ukupni»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0067' FROM clinics c JOIN lab_tests e ON e.slug = 'urea' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0067 «UREA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0068' FROM clinics c JOIN lab_tests e ON e.slug = 'creatinine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0068 «KREATININ»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0069' FROM clinics c JOIN lab_tests e ON e.slug = 'uric-acid' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0069 «MOKRAĆNA KISELINA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0070' FROM clinics c JOIN lab_tests e ON e.slug = 'total-bilirubin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0070 «BILIRUBIN ukupni»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0071' FROM clinics c JOIN lab_tests e ON e.slug = 'direct-bilirubin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0071 «BILIRUBIN direktni»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0072' FROM clinics c JOIN lab_tests e ON e.slug = 'alt' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0072 «ALT(SGPT)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0073' FROM clinics c JOIN lab_tests e ON e.slug = 'ast' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0073 «AST(SGOT)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0074' FROM clinics c JOIN lab_tests e ON e.slug = 'ldh' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0074 «LDH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0075' FROM clinics c JOIN lab_tests e ON e.slug = 'gamma-gt' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0075 «GAMA GT»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0076' FROM clinics c JOIN lab_tests e ON e.slug = 'amylase' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0076 «AMILAZA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0077' FROM clinics c JOIN lab_tests e ON e.slug = 'ck' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0077 «CK»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0078' FROM clinics c JOIN lab_tests e ON e.slug = 'ck-mb' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0078 «CK-MB»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0079' FROM clinics c JOIN lab_tests e ON e.slug = 'troponin-t-hs' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0079 «TROP T hs»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0080' FROM clinics c JOIN lab_tests e ON e.slug = 'iron' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0080 «GVOŽĐE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 6.00, NULL, '0081' FROM clinics c JOIN lab_tests e ON e.slug = 'tibc' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0081 «TIBC»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 6.00, NULL, '0082' FROM clinics c JOIN lab_tests e ON e.slug = 'uibc' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0082 «UIBC»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0083' FROM clinics c JOIN lab_tests e ON e.slug = 'ferritin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0083 «FERITIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0084' FROM clinics c JOIN lab_tests e ON e.slug = 'transferrin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0084 «TRANSFERIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0085' FROM clinics c JOIN lab_tests e ON e.slug = 'vitamin-b12' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0085 «VITAMIN B12»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0086' FROM clinics c JOIN lab_tests e ON e.slug = 'homocysteine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0086 «HOMOCYSTEIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0087' FROM clinics c JOIN lab_tests e ON e.slug = 'sodium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0087 «NATRIJUM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0088' FROM clinics c JOIN lab_tests e ON e.slug = 'potassium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0088 «KALIJUM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0089' FROM clinics c JOIN lab_tests e ON e.slug = 'calcium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0089 «KALCIJUM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0090' FROM clinics c JOIN lab_tests e ON e.slug = 'phosphorus' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0090 «FOSFATI»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0091' FROM clinics c JOIN lab_tests e ON e.slug = 'ionized-calcium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0091 «KALCIJUM-jonizovani»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0092' FROM clinics c JOIN lab_tests e ON e.slug = 'lithium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0092 «LITIJUM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0093' FROM clinics c JOIN lab_tests e ON e.slug = 'magnesium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0093 «MAGNEZIJUM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0094' FROM clinics c JOIN lab_tests e ON e.slug = 'ige' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0094 «IgE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0095' FROM clinics c JOIN lab_tests e ON e.slug = 'igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0095 «IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0096' FROM clinics c JOIN lab_tests e ON e.slug = 'iga' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0096 «IgA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0097' FROM clinics c JOIN lab_tests e ON e.slug = 'igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0097 «IgM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0098' FROM clinics c JOIN lab_tests e ON e.slug = 'c3-complement' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0098 «C3-Komplement»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0099' FROM clinics c JOIN lab_tests e ON e.slug = 'c4-complement' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0099 «C4-Komplement»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0100' FROM clinics c JOIN lab_tests e ON e.slug = 'ceruloplasmin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0100 «CERULOPLAZMIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0101' FROM clinics c JOIN lab_tests e ON e.slug = 't3' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0101 «T3»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0102' FROM clinics c JOIN lab_tests e ON e.slug = 't4' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0102 «T4»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0103' FROM clinics c JOIN lab_tests e ON e.slug = 'tsh' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0103 «TSH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0104' FROM clinics c JOIN lab_tests e ON e.slug = 'free-t3' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0104 «FT3»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0105' FROM clinics c JOIN lab_tests e ON e.slug = 'free-t4' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0105 «FT4»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0106' FROM clinics c JOIN lab_tests e ON e.slug = 'thyroglobulin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0106 «TIREOGLOBULIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0107' FROM clinics c JOIN lab_tests e ON e.slug = 'anti-thyroglobulin-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0107 «TG-ANTITELA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0108' FROM clinics c JOIN lab_tests e ON e.slug = 'anti-tpo' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0108 «ANTI TPO»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0109' FROM clinics c JOIN lab_tests e ON e.slug = 'anti-tshr' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0109 «Anti TSHR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0110' FROM clinics c JOIN lab_tests e ON e.slug = 'calcitonin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0110 «KALCITONIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0111' FROM clinics c JOIN lab_tests e ON e.slug = 'acth' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0111 «ACTH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0112' FROM clinics c JOIN lab_tests e ON e.slug = 'cortisol' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0112 «KORTIZOL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0113' FROM clinics c JOIN lab_tests e ON e.slug = 'pth' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0113 «PTH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0114' FROM clinics c JOIN lab_tests e ON e.slug = 'estradiol' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0114 «ESTRADIOL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0115' FROM clinics c JOIN lab_tests e ON e.slug = 'fsh' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0115 «FSH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0116' FROM clinics c JOIN lab_tests e ON e.slug = 'lh' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0116 «LH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0118' FROM clinics c JOIN lab_tests e ON e.slug = 'progesterone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0118 «PROGESTERON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0119' FROM clinics c JOIN lab_tests e ON e.slug = 'testosterone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0119 «TESTOSTERON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0120' FROM clinics c JOIN lab_tests e ON e.slug = 'free-testosterone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0120 «Free TESTOSTERON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0121' FROM clinics c JOIN lab_tests e ON e.slug = 'shbg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0121 «SHBG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0122' FROM clinics c JOIN lab_tests e ON e.slug = 'dhea-s' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0122 «DHEA-S»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0123' FROM clinics c JOIN lab_tests e ON e.slug = 'androstenedione' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0123 «ANDROSTENDION»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0124' FROM clinics c JOIN lab_tests e ON e.slug = '17-hydroxyprogesterone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0124 «17OH - PROGESTERON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0125' FROM clinics c JOIN lab_tests e ON e.slug = 'anti-mullerian-hormone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0125 «ANTI MILEROV HORMON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0126' FROM clinics c JOIN lab_tests e ON e.slug = 'inhibin-b' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0126 «INHIBIN B»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0128' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-8h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0128 «PROLAKTIN 8h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0129' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-11h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0129 «PROLAKTIN 11h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0130' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-13h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0130 «PROLAKTIN 13h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0131' FROM clinics c JOIN lab_tests e ON e.slug = 'cea' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0131 «CEA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0132' FROM clinics c JOIN lab_tests e ON e.slug = 'ca-15-3' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0132 «CA 15.3»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0133' FROM clinics c JOIN lab_tests e ON e.slug = 'ca-125' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0133 «CA 125»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0134' FROM clinics c JOIN lab_tests e ON e.slug = 'ca-19-9' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0134 «CA 19.9»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0135' FROM clinics c JOIN lab_tests e ON e.slug = 'ca-72-4' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0135 «CA 72.4»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0136' FROM clinics c JOIN lab_tests e ON e.slug = 'psa' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0136 «PSA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0137' FROM clinics c JOIN lab_tests e ON e.slug = 'free-psa' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0137 «fPSA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, NULL, NULL, '0138' FROM clinics c JOIN lab_tests e ON e.slug = 'psa-plus-free-psa' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0138 «PSA+fPSA» [note: na upit]
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0139' FROM clinics c JOIN lab_tests e ON e.slug = 'afp' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0139 «AFP»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0140' FROM clinics c JOIN lab_tests e ON e.slug = 'nse' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0140 «NSE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0141' FROM clinics c JOIN lab_tests e ON e.slug = 'cyfra-21-1' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0141 «CYFRA 21 - 1»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0142' FROM clinics c JOIN lab_tests e ON e.slug = 'ace' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0142 «ACE (Angiotenz. K)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0143' FROM clinics c JOIN lab_tests e ON e.slug = 'protein-s-100' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0143 «PROTEIN S 100»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0144' FROM clinics c JOIN lab_tests e ON e.slug = 'chromogranin-a' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0144 «HROMOGRANIN A»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0145' FROM clinics c JOIN lab_tests e ON e.slug = 'valproic-acid' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0145 «VALPORIČNA KISJELINA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0147' FROM clinics c JOIN lab_tests e ON e.slug = 'asto' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0147 «ASTO»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 6.00, NULL, '0148' FROM clinics c JOIN lab_tests e ON e.slug = 'rheumatoid-factor' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0148 «REUMA FAKTOR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 6.00, NULL, '0149' FROM clinics c JOIN lab_tests e ON e.slug = 'waaler-rose-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0149 «WAALER-ROSE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0150' FROM clinics c JOIN lab_tests e ON e.slug = 'anti-ccp-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0150 «ANTI CCP At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0155' FROM clinics c JOIN lab_tests e ON e.slug = 'urine-culture' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0155 «Bakteriološko ispitivanje urina (urinokultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0157' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-before-and-2h-after-meal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0157 «GLUKOZA PRE I POSLE OBROKA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0159' FROM clinics c JOIN lab_tests e ON e.slug = 'stool-culture' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0159 «Bakteriološko ispitivanje stolice (koprokultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0160' FROM clinics c JOIN lab_tests e ON e.slug = 'hbsag' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0160 «HBs Ag»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0161' FROM clinics c JOIN lab_tests e ON e.slug = 'cytomegalovirus-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0161 «CYTOMEGALO VIRUS IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0162' FROM clinics c JOIN lab_tests e ON e.slug = 'spermatozoa-antibodies-asa' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0162 «ANTISPERMATOZOIDNA At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0163' FROM clinics c JOIN lab_tests e ON e.slug = 'cytomegalovirus-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0163 «CYTOMEGALO VIRUS IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0164' FROM clinics c JOIN lab_tests e ON e.slug = 'herpes-simplex-i-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0164 «HERPES SIMPLEX I IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0165' FROM clinics c JOIN lab_tests e ON e.slug = 'herpes-simplex-i-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0165 «HERPES SIMPLEX I IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0166' FROM clinics c JOIN lab_tests e ON e.slug = 'herpes-simplex-ii-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0166 «HERPES SIMPLEX II IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0167' FROM clinics c JOIN lab_tests e ON e.slug = 'herpes-simplex-ii-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0167 «HERPES SIMPLEX II IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0168' FROM clinics c JOIN lab_tests e ON e.slug = 'varicella-zoster-virus-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0168 «VARICELA ZOSTER VIRUS IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0169' FROM clinics c JOIN lab_tests e ON e.slug = 'varicella-zoster-virus-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0169 «VARICELA ZOSTER VIRUS IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0170' FROM clinics c JOIN lab_tests e ON e.slug = 'hbeag' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0170 «HBe Ag»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0171' FROM clinics c JOIN lab_tests e ON e.slug = 'brucella-abortus-antibodies-agglutination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0171 «BRUCELA (BAB)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0172' FROM clinics c JOIN lab_tests e ON e.slug = 'anti-hcv' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0172 «anti HCV»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0173' FROM clinics c JOIN lab_tests e ON e.slug = 'hav-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0173 «HAV IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0174' FROM clinics c JOIN lab_tests e ON e.slug = 'hav-total-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0174 «HAV ukupna At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0175' FROM clinics c JOIN lab_tests e ON e.slug = 'adenovirus-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0175 «ADENOVIRUS IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0176' FROM clinics c JOIN lab_tests e ON e.slug = 'adenovirus-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0176 «ADENOVIRUS IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0177' FROM clinics c JOIN lab_tests e ON e.slug = 'coxsackie-virus-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0177 «COXSACKIE virus IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0178' FROM clinics c JOIN lab_tests e ON e.slug = 'coxsackie-virus-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0178 «COXSACKIE virus IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0179' FROM clinics c JOIN lab_tests e ON e.slug = 'tpha-treponema-pallidum' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0179 «TPHA (Threponema palidum)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0180' FROM clinics c JOIN lab_tests e ON e.slug = 'hiv-ag-ab' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0180 «HIV Ag-Ab»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0181' FROM clinics c JOIN lab_tests e ON e.slug = 'borrelia-burgdorferi-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0181 «BORRELIA burgdorferi IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0182' FROM clinics c JOIN lab_tests e ON e.slug = 'borrelia-burgdorferi-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0182 «BORRELIA burgdorferi IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0183' FROM clinics c JOIN lab_tests e ON e.slug = 'toxoplasma-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0183 «TOXOPLASMA IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0184' FROM clinics c JOIN lab_tests e ON e.slug = 'toxoplasma-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0184 «TOXOPLASMA IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0185' FROM clinics c JOIN lab_tests e ON e.slug = 'rubella-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0185 «RUBELLA IgM At.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0186' FROM clinics c JOIN lab_tests e ON e.slug = 'rubella-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0186 «RUBELLA IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0187' FROM clinics c JOIN lab_tests e ON e.slug = 'epstein-barr-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0187 «EPSTEIN-BARR IGM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0188' FROM clinics c JOIN lab_tests e ON e.slug = 'epstein-barr-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0188 «EPSTEIN-BARR IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0190' FROM clinics c JOIN lab_tests e ON e.slug = 'helicobacter-pylori-iga' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0190 «HELICOBACTER pylori IgA At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0191' FROM clinics c JOIN lab_tests e ON e.slug = 'vdrl' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0191 «VDRL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0192' FROM clinics c JOIN lab_tests e ON e.slug = 'free-beta-hcg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0192 «free BETA HCG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0193' FROM clinics c JOIN lab_tests e ON e.slug = 'free-estriol' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0193 «ESTRIOL Free»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0195' FROM clinics c JOIN lab_tests e ON e.slug = 'transferrin-saturation' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0195 «SATURACIJA TRANSFERINA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0196' FROM clinics c JOIN lab_tests e ON e.slug = 'ovarian-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0196 «ANTIOVARIJALNA At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0199' FROM clinics c JOIN lab_tests e ON e.slug = 'osteocalcin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0199 «OSTEOCALCIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0200' FROM clinics c JOIN lab_tests e ON e.slug = 'beta-crosslaps' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0200 «Beta- CrossLaps»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0201' FROM clinics c JOIN lab_tests e ON e.slug = 'vitamin-d-25-oh' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0201 «VITAMIN D»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0202' FROM clinics c JOIN lab_tests e ON e.slug = 'beta-hcg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0202 «BETA HCG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0203' FROM clinics c JOIN lab_tests e ON e.slug = 'protein-s' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0203 «PROTEIN S»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0204' FROM clinics c JOIN lab_tests e ON e.slug = 'protein-c' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0204 «PROTEIN C»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0205' FROM clinics c JOIN lab_tests e ON e.slug = 'alkaline-phosphatase' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0205 «ALKALNA FOSFATAZA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.50, NULL, '0206' FROM clinics c JOIN lab_tests e ON e.slug = 'complete-blood-count' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0206 «KOMPLETNA KRVNA SLIKA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0207' FROM clinics c JOIN lab_tests e ON e.slug = 'procalcitonin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0207 «PROCALCITONIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, NULL, NULL, '0208' FROM clinics c JOIN lab_tests e ON e.slug = 'roma-index' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0208 «ROMA indeks» [note: na upit]
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0209' FROM clinics c JOIN lab_tests e ON e.slug = 'he4' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0209 «HE4»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0222' FROM clinics c JOIN lab_tests e ON e.slug = 'cocaine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0222 «COCAIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0223' FROM clinics c JOIN lab_tests e ON e.slug = 'marijuana' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0223 «MARIHUANA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0224' FROM clinics c JOIN lab_tests e ON e.slug = 'morphine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0224 «MORPHIUM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0225' FROM clinics c JOIN lab_tests e ON e.slug = 'benzodiazepines' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0225 «BENZODIAZEPINES»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0226' FROM clinics c JOIN lab_tests e ON e.slug = 'phencyclidine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0226 «PHENCIKLIDIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0228' FROM clinics c JOIN lab_tests e ON e.slug = 'throat-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0228 «Bakteriološko ispitivanje brisa grla (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0231' FROM clinics c JOIN lab_tests e ON e.slug = 'throat-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0231 «Ispitivanje prisustva gljivica u brisu grla (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0232' FROM clinics c JOIN lab_tests e ON e.slug = 'urine-first-stream' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0232 «URIN 1.MLAZ»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0233' FROM clinics c JOIN lab_tests e ON e.slug = 'urine-second-stream' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0233 «URIN 2.MLAZ»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0234' FROM clinics c JOIN lab_tests e ON e.slug = 'urine-third-stream' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0234 «URIN 3.MLAZ»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0235' FROM clinics c JOIN lab_tests e ON e.slug = 'nose-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0235 «Bakteriološko ispitivanje brisa nosa (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0236' FROM clinics c JOIN lab_tests e ON e.slug = 'nose-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0236 «Ispitivanje prisustva gljivica u brisu nosa (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0237' FROM clinics c JOIN lab_tests e ON e.slug = 'tongue-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0237 «Bakteriološko ispitivanje brisa jezika (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0238' FROM clinics c JOIN lab_tests e ON e.slug = 'tongue-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0238 «Ispitivanje prisustva gljivica u brisu jezika (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0239' FROM clinics c JOIN lab_tests e ON e.slug = 'oral-cavity-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0239 «Bakteriološko ispitivanje brisa usne šupljine (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0240' FROM clinics c JOIN lab_tests e ON e.slug = 'oral-cavity-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0240 «Ispitivanje prisustva gljivica u brisu usne šupljine (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 9.00, NULL, '0241' FROM clinics c JOIN lab_tests e ON e.slug = 'sputum-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0241 «Bakteriološko ispitivanje ispljuvka (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0242' FROM clinics c JOIN lab_tests e ON e.slug = 'sputum-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0242 «Ispitivanje prisustva gljivica u ispljuvku (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0243' FROM clinics c JOIN lab_tests e ON e.slug = 'wound-swab-aerobic-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0243 «Bakteriološko ispitivanje brisa rane (kultivacija-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0244' FROM clinics c JOIN lab_tests e ON e.slug = 'wound-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0244 «Ispitivanje prisustva gljivica u brisu rane (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0245' FROM clinics c JOIN lab_tests e ON e.slug = 'skin-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0245 «Bakteriološko ispitivanje brisa promjene (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0246' FROM clinics c JOIN lab_tests e ON e.slug = 'skin-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0246 «Ispitivanje prisustva gljivica (kvasnica) u brisu promjene kože (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0247' FROM clinics c JOIN lab_tests e ON e.slug = 'urethral-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0247 «Bakteriološko ispitivanje uretralnog brisa (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0248' FROM clinics c JOIN lab_tests e ON e.slug = 'urethral-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0248 «Ispitivanje prisustva gljivica u uretralnom brisu (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0249' FROM clinics c JOIN lab_tests e ON e.slug = 'vulvar-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0249 «Bakteriološko ispitivanje brisa vulve (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0250' FROM clinics c JOIN lab_tests e ON e.slug = 'vulvar-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0250 «Ispitivanje prisustva gljivica u brisu vulve (kultivacija)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0251' FROM clinics c JOIN lab_tests e ON e.slug = 'vaginal-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0251 «Bakteriološko ispitivanje vaginalnog brisa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0252' FROM clinics c JOIN lab_tests e ON e.slug = 'vaginal-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0252 «Ispitivanje prisustva gljivica u vaginalnom brisu (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0253' FROM clinics c JOIN lab_tests e ON e.slug = 'cervical-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0253 «Bakteriološko ispitivanje cervikalnog brisa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0254' FROM clinics c JOIN lab_tests e ON e.slug = 'cervical-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0254 «Ispitivanje prisustva gljivica u cervikalnom brisu (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0255' FROM clinics c JOIN lab_tests e ON e.slug = 'vaginal-discharge-dmp' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0255 «Grupa vaginalnog sekreta»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 1.00, NULL, '0256' FROM clinics c JOIN lab_tests e ON e.slug = 'amine-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0256 «Aminski test»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0257' FROM clinics c JOIN lab_tests e ON e.slug = 'sperm-culture-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0257 «Bakteriološko ispitivanje sjemene tečnosti»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0262' FROM clinics c JOIN lab_tests e ON e.slug = 'stool-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0262 «Ispitivanje prisustva gljivica u stolici (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0263' FROM clinics c JOIN lab_tests e ON e.slug = 'dermatophytes-skin-scraping' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0263 «Ispitivanje prisustva gljivičnih elemenata u nativnom preparatu strugotine kože»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0264' FROM clinics c JOIN lab_tests e ON e.slug = 'adenovirus-rotavirus-in-stool' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0264 «Imunohromatografski test za dokazivanje Rotavirusa i Adenovirusa u stolici»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0265' FROM clinics c JOIN lab_tests e ON e.slug = 'stool-parasites' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0265 «Ispitivanje prisustva cista crijevnih protozoa i jaja helminata u nativnom preparatu stolice»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0267' FROM clinics c JOIN lab_tests e ON e.slug = 'mycoplasma-hominis-ureaplasma' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0267 «Ispitivanje prisustva genitalnih mikoplazmi-kultura»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0268' FROM clinics c JOIN lab_tests e ON e.slug = 'left-eye-swab' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0268 «Bakteriološko ispitivanje brisa lijevog oka (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0269' FROM clinics c JOIN lab_tests e ON e.slug = 'right-eye-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0269 «Bakteriološko ispitivanje brisa desnog oka (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0270' FROM clinics c JOIN lab_tests e ON e.slug = 'left-eye-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0270 «Ispitivanje prisustva gljivica u brisu lijevog oka (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0271' FROM clinics c JOIN lab_tests e ON e.slug = 'right-eye-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0271 «Ispitivanje prisustva gljivica u brisu desnog oka (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0272' FROM clinics c JOIN lab_tests e ON e.slug = 'glans-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0272 «Bakteriološko ispitivanje brisa glansa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0273' FROM clinics c JOIN lab_tests e ON e.slug = 'glans-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0273 «Ispitivanje prisustva gljivica u brisu glansa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0274' FROM clinics c JOIN lab_tests e ON e.slug = 'trichomonas-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0274 «Ispitivanje prisustva Trichomonas vaginalis-a u nativnom preparatu vaginalnog brisa»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0275' FROM clinics c JOIN lab_tests e ON e.slug = 'wound-swab-culture-anaerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0275 «Bakteriološko ispitivanje brisa rane (kultura-anaerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0276' FROM clinics c JOIN lab_tests e ON e.slug = 'perianal-impression' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0276 «Ispitivanje prisustva jaja Enterobius vermicularis-a u perianalnom otisku»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0278' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0278 «PROLACTIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0279' FROM clinics c JOIN lab_tests e ON e.slug = 'monosticon' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0279 «MONOSTIKON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0282' FROM clinics c JOIN lab_tests e ON e.slug = 'left-ear-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0282 «Bakteriološko ispitivanje brisa lijevog uha (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0283' FROM clinics c JOIN lab_tests e ON e.slug = 'left-ear-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0283 «Ispitivanje prisustva gljivica u brisu lijevog uha (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0284' FROM clinics c JOIN lab_tests e ON e.slug = 'right-ear-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0284 «Bakteriološko ispitivaje brisa desnog uha (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0285' FROM clinics c JOIN lab_tests e ON e.slug = 'right-ear-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0285 «Ispitivanje prisustva gljivica u brisu desnog uha (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0286' FROM clinics c JOIN lab_tests e ON e.slug = 'prepuce-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0286 «Bakteriološko ispitivanje brisa prepucijuma (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0287' FROM clinics c JOIN lab_tests e ON e.slug = 'prepuce-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0287 «Ispitivanje prisustva gljivica u brisu prepucijuma (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0290' FROM clinics c JOIN lab_tests e ON e.slug = 'urine-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0290 «Ispitivanje prisustva gljivica u urinu (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0291' FROM clinics c JOIN lab_tests e ON e.slug = 'dermatophytes-nail-scraping' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0291 «Ispitivanje prisustva gljivičnih elemenata u nativnom preparatu strugotine nokta»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0292' FROM clinics c JOIN lab_tests e ON e.slug = 'dermatophytes-hair-scraping' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0292 «Ispitivanje prisustva gljivičnih elemenata u nativnom preparatu dlake»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0293' FROM clinics c JOIN lab_tests e ON e.slug = 'demodex-species' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0293 «Ispitivanje prisustva Demodex sp u nativnom preparatu strugotine/otisku kože»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0296' FROM clinics c JOIN lab_tests e ON e.slug = 'nipple-discharge-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0296 «Bakteriološko ispitivanje iscjetka iz lijeve dojke (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0298' FROM clinics c JOIN lab_tests e ON e.slug = 'acne-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0298 «Bakteriološko ispitivanje brisa akne (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0299' FROM clinics c JOIN lab_tests e ON e.slug = 'acne-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0299 «Ispitivanje prisustva gljivica u brisu akne (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0302' FROM clinics c JOIN lab_tests e ON e.slug = 'neisseria-gonorrhoeae-culture' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0302 «Ispitivanje prisustva Neisseria gonorrhoeae u uretralnom brisu (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0303' FROM clinics c JOIN lab_tests e ON e.slug = 'lochia-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0303 «Bakteriološko ispitivanje lohija( kultura-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0304' FROM clinics c JOIN lab_tests e ON e.slug = 'punctate-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0304 «Bakteriološko ispitivanje punktata( kultura-aerobno )»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0305' FROM clinics c JOIN lab_tests e ON e.slug = 'sperm-culture-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0305 «Ispitivanje prisustva gljivica u sjemenoj tečnosti (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0307' FROM clinics c JOIN lab_tests e ON e.slug = 'clostridium-difficile-toxin-a-and-b' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0307 «Imunohromatografski test za dokazivanje Clostridium difficile / toxin A / toxin B»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0309' FROM clinics c JOIN lab_tests e ON e.slug = 'endocervical-swab-for-gonorrhea' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0309 «Ispitivanje prisustva Neisseria gonorrhoeae u endocervikalnom brisu ( kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 14.00, NULL, '0311' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-profile' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0311 «profil glukoze»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0312' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-7h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0312 «glukoza 7.h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0313' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-12h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0313 «glukoza 12,h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0314' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-17h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0314 «glukoza 17.h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0315' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-20h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0315 «glukoza 20.h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 3.00, NULL, '0318' FROM clinics c JOIN lab_tests e ON e.slug = 'chloride' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0318 «Hloridi»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0319' FROM clinics c JOIN lab_tests e ON e.slug = 'parvovirus-b19-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0319 «Parvo B19 IgM AT»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0320' FROM clinics c JOIN lab_tests e ON e.slug = 'parvovirus-b19-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0320 «Parvo B19 IgG AT»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0325' FROM clinics c JOIN lab_tests e ON e.slug = 'nipple-discharge-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0325 «Iscjedak lijeve dojke na gljivice (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0327' FROM clinics c JOIN lab_tests e ON e.slug = 'breast-milk-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0327 «Bakteriološko ispitivanje majčinog mlijeka iz lijeve dojke (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0328' FROM clinics c JOIN lab_tests e ON e.slug = 'breast-milk-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0328 «Ispitivanje prisustva gljivica u majčinom mlijeku iz lijeve dojke (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0332' FROM clinics c JOIN lab_tests e ON e.slug = 'punctate-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0332 «Ispitivanje prisustva gljivica u punktatu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0333' FROM clinics c JOIN lab_tests e ON e.slug = 'folic-acid' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0333 «FOLATI»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0334' FROM clinics c JOIN lab_tests e ON e.slug = 'cortisol-17h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0334 «KORTIZOL 17.h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0335' FROM clinics c JOIN lab_tests e ON e.slug = 'mouth-corner-swab-for-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0335 «Bakteriološko ispitivanje brisa uglova usana ( kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0336' FROM clinics c JOIN lab_tests e ON e.slug = 'mouth-corner-swab-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0336 «Ispitivanje prisustva gljivica u brisu uglova usana (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 4.50, NULL, '0339' FROM clinics c JOIN lab_tests e ON e.slug = 'complete-blood-count-with-leukocyte-formula' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0339 «Kompletna KS i leukocitarna formula»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0341' FROM clinics c JOIN lab_tests e ON e.slug = 'coxsackie-b-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0341 «COXSACKIE B IgM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0342' FROM clinics c JOIN lab_tests e ON e.slug = 'coxsackie-b-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0342 «COXSACKIE B IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0343' FROM clinics c JOIN lab_tests e ON e.slug = 'direct-microscopic-preparation-vaginal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0343 «direktan mikroskopski preparat vaginalnog brisa»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0347' FROM clinics c JOIN lab_tests e ON e.slug = 'cortisol-12h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0347 «KORTIZOL 12»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0348' FROM clinics c JOIN lab_tests e ON e.slug = 'cortisol-20h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0348 «KORTIZOL 20h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 40.00, NULL, '0351' FROM clinics c JOIN lab_tests e ON e.slug = 'calprotectin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0351 «FEKALNI KALPROTEKTIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0355' FROM clinics c JOIN lab_tests e ON e.slug = 'nail-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0355 «Ispitivanje prisustva gljivica u brisu nokta (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0356' FROM clinics c JOIN lab_tests e ON e.slug = 'beta-2-microglobulin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0356 «beta 2 mikroglobulin»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0360' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-9h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0360 «PROLAKTIN 9.h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0365' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-10h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0365 «PROLAKTIN 10h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0366' FROM clinics c JOIN lab_tests e ON e.slug = 'helicobacter-pylori-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0366 «Helicobacter pylori IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0367' FROM clinics c JOIN lab_tests e ON e.slug = 'umbilicus-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0367 «Bakteriološko ispitivanje brisa pupka (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0368' FROM clinics c JOIN lab_tests e ON e.slug = 'bartholin-gland-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0368 «Bakteriološko ispitivanje brisa Bartolinijeve žlijezde (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0369' FROM clinics c JOIN lab_tests e ON e.slug = 'skin-scraping-for-sarcoptes-scabiei' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0369 «Mikroskopsko ispitivanje strugotine kože/celofan otiska na prisustvo Sarcoptes scabiei»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 6.00, NULL, '0370' FROM clinics c JOIN lab_tests e ON e.slug = 'lipase' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0370 «LIPAZA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0371' FROM clinics c JOIN lab_tests e ON e.slug = 'transglutaminase-iga-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0371 «At na tkivnu transglutaminazu IgA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0400' FROM clinics c JOIN lab_tests e ON e.slug = 'spermogram' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0400 «SPERMOGRAM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0408' FROM clinics c JOIN lab_tests e ON e.slug = 'pancreatic-amylase' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0408 «AMILAZA-pankreasna»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0415' FROM clinics c JOIN lab_tests e ON e.slug = 'growth-hormone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0415 «HORMON RASTA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0429' FROM clinics c JOIN lab_tests e ON e.slug = 'igf-1' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0429 «IGF-1»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0430' FROM clinics c JOIN lab_tests e ON e.slug = 'copper-in-serum' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0430 «BAKAR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0431' FROM clinics c JOIN lab_tests e ON e.slug = 'zinc-in-serum' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0431 «ZINK»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0432' FROM clinics c JOIN lab_tests e ON e.slug = 'bicarbonates' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0432 «BIKARBONATI»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 40.00, NULL, '0437' FROM clinics c JOIN lab_tests e ON e.slug = 'cystatin-c' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0437 «Cystatin C»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0438' FROM clinics c JOIN lab_tests e ON e.slug = 'lipoprotein-a' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0438 «Lipoprotein (a)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0439' FROM clinics c JOIN lab_tests e ON e.slug = 'mumps-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0439 «MUMPS IgM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0441' FROM clinics c JOIN lab_tests e ON e.slug = 'gliadin-igg-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0441 «ANTIGLIJADINSKA IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 60.00, NULL, '0448' FROM clinics c JOIN lab_tests e ON e.slug = 'acetylcholine-receptor-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0448 «AT NA acetil holin receptore»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0457' FROM clinics c JOIN lab_tests e ON e.slug = 'mumps-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0457 «Mumps IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0458' FROM clinics c JOIN lab_tests e ON e.slug = 'gliadin-iga-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0458 «ANTIGLIJADINSKA At IgA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0461' FROM clinics c JOIN lab_tests e ON e.slug = 'prothrombin-time-pt-inr' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0461 «PROTROMBINSKO VRIJEME I INR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0462' FROM clinics c JOIN lab_tests e ON e.slug = 'oral-glucose-tolerance-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0462 «OGTT»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 31.00, NULL, '0464' FROM clinics c JOIN lab_tests e ON e.slug = 'anca-c-anti-pr3' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0464 «c-ANCA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0466' FROM clinics c JOIN lab_tests e ON e.slug = 'ana-antinuclear-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0466 «Auto-antitijela (IgG) prema antigenima nukleusa - ANA»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 120.00, NULL, '0468' FROM clinics c JOIN lab_tests e ON e.slug = 'torch-panel' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0468 «TORCH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 80.00, NULL, '0473' FROM clinics c JOIN lab_tests e ON e.slug = 'immunoelectrophoresis-protein-serum' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0473 «S-Imunoelektroforeza proteina»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0474' FROM clinics c JOIN lab_tests e ON e.slug = 'influenza-a-plus-b-iht' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0474 «INFLUENCA A+B»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0483' FROM clinics c JOIN lab_tests e ON e.slug = 'measles-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0483 «MORBILI IgM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0484' FROM clinics c JOIN lab_tests e ON e.slug = 'measles-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0484 «MORBILI IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 50.00, NULL, '0486' FROM clinics c JOIN lab_tests e ON e.slug = 'pai-1' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0486 «PAI-I»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0492' FROM clinics c JOIN lab_tests e ON e.slug = 'dsdna-igg-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0492 «Anti ds DNK IgG At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0497' FROM clinics c JOIN lab_tests e ON e.slug = 'renin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0497 «RENIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0499' FROM clinics c JOIN lab_tests e ON e.slug = 'candida-igg-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0499 «Candida IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0500' FROM clinics c JOIN lab_tests e ON e.slug = 'candida-igm-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0500 «Candida IgM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 40.00, NULL, '0503' FROM clinics c JOIN lab_tests e ON e.slug = 'nt-probnp' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0503 «NT-proBNP»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0504' FROM clinics c JOIN lab_tests e ON e.slug = 'indirect-bilirubin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0504 «BILIRUBIN indirektni»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0505' FROM clinics c JOIN lab_tests e ON e.slug = 'aldosterone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0505 «ALDOSTERON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0508' FROM clinics c JOIN lab_tests e ON e.slug = 'transglutaminase-igg-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0508 «At na tkivnu ttransglutaminazu IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0516' FROM clinics c JOIN lab_tests e ON e.slug = 'gastrin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0516 «GASTRIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0565' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-after-180-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0565 «GLUKOZA POSLIJE 180 min»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0566' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-after-30-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0566 «GLUKOZA POSLIJE 30 min»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0567' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-after-90-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0567 «GLUKOZA POSLIJE 90 min»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0574' FROM clinics c JOIN lab_tests e ON e.slug = 'erythropoietin' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0574 «ERITROPOETIN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 35.00, NULL, '0582' FROM clinics c JOIN lab_tests e ON e.slug = 'selenium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0582 «SELEN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0583' FROM clinics c JOIN lab_tests e ON e.slug = 'dihydrotestosterone' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0583 «DIHIDROTESTOSTERON»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 50.00, NULL, '0611' FROM clinics c JOIN lab_tests e ON e.slug = 'immunoelectrophoresis-protein-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0611 «Imunoelektroforeza urina»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0636' FROM clinics c JOIN lab_tests e ON e.slug = 'dsdna-igm-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0636 «Anti ds DNK IgM At»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0681' FROM clinics c JOIN lab_tests e ON e.slug = 'vitamin-e-level' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0681 «VITAMIN E»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0682' FROM clinics c JOIN lab_tests e ON e.slug = 'vitamin-a' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0682 «VITAMIN A»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0719' FROM clinics c JOIN lab_tests e ON e.slug = 'chlamydia-trachomatis-real-time-pcr' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0719 «Hlamidija PCR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 700.00, NULL, '0720' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-nifty-plus' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0720 «nifty plus»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 500.00, NULL, '0721' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-nifty-basic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0721 «Nifty basic»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0723' FROM clinics c JOIN lab_tests e ON e.slug = 'pap-papanicolaou-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0723 «PAPPA BRIS»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0725' FROM clinics c JOIN lab_tests e ON e.slug = 'endometrial-biopsy-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0725 «Bakteriološko ispitivanje bioptata endometrijuma (kultura-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.00, NULL, '0730' FROM clinics c JOIN lab_tests e ON e.slug = 'homa-insulin-resistance' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0730 «HOMA IR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 50.00, NULL, '0731' FROM clinics c JOIN lab_tests e ON e.slug = 'catecholamines-in-plasma' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0731 «Kateholamini-plazma»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0734' FROM clinics c JOIN lab_tests e ON e.slug = 'renal-pelvis-lavage-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0734 «Bakteriološko ispitivanje ispirka pijelona ( kultura - aerobno )»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0735' FROM clinics c JOIN lab_tests e ON e.slug = 'central-venous-catheter-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0735 «Bakteriološko ispitivanje centralnog venskog katetera (aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0738' FROM clinics c JOIN lab_tests e ON e.slug = 'abdominal-drain-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0738 «Bakteriološko ispitivanje sadržaja abdominalnog drena (kultura-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0739' FROM clinics c JOIN lab_tests e ON e.slug = 'abdominal-drain-swab-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0739 «Ispitivanje prisustva gljivica u sadržaju abdominalnog drena»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0740' FROM clinics c JOIN lab_tests e ON e.slug = 'trichomonas-test-urethral' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0740 «Ispitivanje prisustva Trichomonas vaginalis-a u nativnom preparatu uretralnog brisa»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0741' FROM clinics c JOIN lab_tests e ON e.slug = 'central-venous-catheter-culture-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0741 «Ispitivanje prisustva gljivica u centralnom venskom kateteru»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0742' FROM clinics c JOIN lab_tests e ON e.slug = 'vaginal-introitus-and-anal-swab-for-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0742 «Bakteriološko ispitivanje brisa introitusa vagine i anusa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0744' FROM clinics c JOIN lab_tests e ON e.slug = 'puncture-fluid-for-anaerobic-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0744 «Bakteriološko ispitivanje punktata ( kultura - anaerobno )»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0745' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-7h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0745 «Insulin u 7h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0746' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-12h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0746 «Insulin u 12h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0747' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-17h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0747 «Insulin u 17h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 12.00, NULL, '0748' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-20h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0748 «Insulin u 20h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0749' FROM clinics c JOIN lab_tests e ON e.slug = 'tissue-biopsy-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0749 «Bakteriološko ispitivanje tkiva (kultura - aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0750' FROM clinics c JOIN lab_tests e ON e.slug = 'drain-content-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0750 «Bakteriološko ispitivanje brisa drena (kultura - aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0751' FROM clinics c JOIN lab_tests e ON e.slug = 'drain-swab-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0751 «Ispitivanje prisustva gljivica u brisu drena»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 13.00, NULL, '0752' FROM clinics c JOIN lab_tests e ON e.slug = 'insulin-2h-after-meal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0752 «Insulin dva sata nakon obroka»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0753' FROM clinics c JOIN lab_tests e ON e.slug = 'chlamydia-trachomatis-pcr-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0753 «Hlamidija PCR urin»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '0754' FROM clinics c JOIN lab_tests e ON e.slug = 'anti-sars-cov' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0754 «SARS-Cov-2 virus (ukupna antitijela)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0756' FROM clinics c JOIN lab_tests e ON e.slug = 'aspiration-catheter-tracheal-aspirate-culture-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0756 «Ispitivanje prisustva gljivica u aspitacionom kateteru-trahealni aspirat»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0757' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-1h-after-meal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0757 «Glukoza 1h nakon obroka»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '0758' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-2h-after-meal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0758 «Glukoza 2h nakon obroka»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '0759' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-17h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0759 «PROLACTIN U 17h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0760' FROM clinics c JOIN lab_tests e ON e.slug = 'implant-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0760 «Bakteriološko ispitivanje implanta (kultura-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0761' FROM clinics c JOIN lab_tests e ON e.slug = 'covid-19-antigen-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0761 «COVID-19 ANTIGEN»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0762' FROM clinics c JOIN lab_tests e ON e.slug = 'sars-cov-2-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0762 «Anti SARS-COV 2 virus IgM antitijela»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0763' FROM clinics c JOIN lab_tests e ON e.slug = 'sars-cov-2-igg-spike-protein' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0763 «Anti SARS-COV 2 virus IgG antitijela»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0768' FROM clinics c JOIN lab_tests e ON e.slug = 'perineal-swab-for-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0768 «Bakteriološko ispitivanje brisa perineuma»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0769' FROM clinics c JOIN lab_tests e ON e.slug = 'bronchoalveolar-lavage-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0769 «Bakteriološko ispitivanje bronhoalveolarnog lavata (kultura-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0770' FROM clinics c JOIN lab_tests e ON e.slug = 'umbilicus-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0770 «Ispitivanje prisustva gljivica u brisu pupka»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0771' FROM clinics c JOIN lab_tests e ON e.slug = 'vaginal-introitus-and-anal-swab-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0771 «Ispitivanje prisustva gljivica u brisu introitusa vagine i anusa»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0772' FROM clinics c JOIN lab_tests e ON e.slug = 'vaginal-swab-culture-anaerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0772 «Bakteriološko ispitivanje vaginalnog brisa (kultura-anaerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0773' FROM clinics c JOIN lab_tests e ON e.slug = 'cervical-swab-culture-anaerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0773 «Bakteriološko ispitivanje cervikalnog brisa (kultura-anaerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0774' FROM clinics c JOIN lab_tests e ON e.slug = 'adult-helminth-identification' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0774 «Identifikacija adultnih oblika helminta»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 70.00, NULL, '0776' FROM clinics c JOIN lab_tests e ON e.slug = 'hpv-14-types-pcr' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0776 «Ispitivanje prisustva visokorizičnih genotipova HPV»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0925' FROM clinics c JOIN lab_tests e ON e.slug = 'egfr-glomerular-filtration-rate' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0925 «GFR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 70.00, 100.00, '0937' FROM clinics c JOIN lab_tests e ON e.slug = 'sars-cov-2-pcr' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0937 «SARS-COV-2 REAL TIME (STANDARD)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0941' FROM clinics c JOIN lab_tests e ON e.slug = 'cortisol-8h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0941 «KORTIZOL 8h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '0942' FROM clinics c JOIN lab_tests e ON e.slug = 'cortisol-11h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0942 «KORTIZOL 11h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '0953' FROM clinics c JOIN lab_tests e ON e.slug = 'high-sensitivity-c-reactive-protein' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0953 «hsCRP»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 48.00, NULL, '0954' FROM clinics c JOIN lab_tests e ON e.slug = 'interleukin-6' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0954 «IL-6»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0955' FROM clinics c JOIN lab_tests e ON e.slug = 'bronchoalveolar-lavage-culture-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0955 «ispitivanje prisustva gljivica u bronhoalveolarnom lavatu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '0961' FROM clinics c JOIN lab_tests e ON e.slug = 'dermatomycosis-nmp' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0961 «Mikološka obrada nativno»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '1022' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-after-150-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1022 «GLUKOZA POSLIJE 150 min.»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '1026' FROM clinics c JOIN lab_tests e ON e.slug = 'albumin-creatinine-ratio' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1026 «uACR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '1028' FROM clinics c JOIN lab_tests e ON e.slug = 'sodium-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1028 «NATRIJUM u 24h urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 5.00, NULL, '1029' FROM clinics c JOIN lab_tests e ON e.slug = 'sodium-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1029 «NATRIJUM u urinu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '1033' FROM clinics c JOIN lab_tests e ON e.slug = 'abdominal-drain-swab-culture-anaerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1033 «Bakteriološko ispitivanje sadržaja abdominalnog drena (kultura-anaerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '1034' FROM clinics c JOIN lab_tests e ON e.slug = 'lochia-culture-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1034 «Ispitivanje prisustva gljivica u lohijama (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '1036' FROM clinics c JOIN lab_tests e ON e.slug = 'endometrial-biopsy-culture-anaerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1036 «Bakteriološko ispitivanje bioptata endometrijuma (kultura-anaerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '1037' FROM clinics c JOIN lab_tests e ON e.slug = 'urinary-catheter-tip-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1037 «Bakteriološko ispitivanje vrha urinarnog katetera (kultura-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '1038' FROM clinics c JOIN lab_tests e ON e.slug = 'urinary-catheter-tip-culture-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1038 «Ispitivanje prisustva gljivica na vrhu urinarnog katetera»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '1040' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-14h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1040 «PROLACTIN 14h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 1.00, NULL, '1041' FROM clinics c JOIN lab_tests e ON e.slug = 'ldlhdl-ratio' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1041 «LDL/HDL (index ateroskleroze)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 1.00, NULL, '1042' FROM clinics c JOIN lab_tests e ON e.slug = 'non-hdl-cholesterol' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1042 «non HDL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 1.00, NULL, '1043' FROM clinics c JOIN lab_tests e ON e.slug = 'non-hdlhdl-ratio' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1043 «non HDL/HDL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 1.00, NULL, '1044' FROM clinics c JOIN lab_tests e ON e.slug = 'total-cholesterolhdl-ratio' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1044 «Holesterol/HDL»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '1047' FROM clinics c JOIN lab_tests e ON e.slug = 'nail-swab-for-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1047 «Bakteriološko ispitivanje brisa nokta (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '1050' FROM clinics c JOIN lab_tests e ON e.slug = 'thoracic-drain-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1050 «Bakteriološko ispitivanje torakalnog drena (kultura-aerobno)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '1051' FROM clinics c JOIN lab_tests e ON e.slug = 'thoracic-drain-swab-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1051 «Ispitivanje prisustva gljivica u torakalnom drenu»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '1052' FROM clinics c JOIN lab_tests e ON e.slug = 'axillary-region-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1052 «Bakteriološko ispitivanje brisa aksilarne regije»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '1053' FROM clinics c JOIN lab_tests e ON e.slug = 'inguinal-region-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1053 «Bakteriološko ispitivanje brisa ingvinalne regije»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '1061' FROM clinics c JOIN lab_tests e ON e.slug = 'sputum-parasites' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1061 «Ispitivanje sputuma na prisustvo parazita»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 800.00, NULL, '1068' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-nifty-pro' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1068 «Nifty PRO»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '1069' FROM clinics c JOIN lab_tests e ON e.slug = 'nasopharyngeal-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1069 «Bakteriološko ispitivanje brisa nazofarinksa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '1070' FROM clinics c JOIN lab_tests e ON e.slug = 'nasopharyngeal-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1070 «Ispitivanje prisustva gljivica u brizu nazofarinksa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 45.00, NULL, '1073' FROM clinics c JOIN lab_tests e ON e.slug = 'food-allergy-panel-30-allergens' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1073 «Nutritivni panel 30-II»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 45.00, NULL, '1074' FROM clinics c JOIN lab_tests e ON e.slug = 'inhalant-allergy-panel-30-allergens' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1074 «Inhalacioni panel 30-II»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '1075' FROM clinics c JOIN lab_tests e ON e.slug = 'rectal-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1075 «Bakteriološko ispitivanje perirektalnog brisa (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '1076' FROM clinics c JOIN lab_tests e ON e.slug = 'dermatophytes-culture' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1076 «Ispitivanje prisustva gljivica (dermatofita) sa promjene na koži (kultura)»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 45.00, NULL, '1081' FROM clinics c JOIN lab_tests e ON e.slug = 'pediatric-allergy-panel-30-allergens' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1081 «Pediatric panel - 30 I»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.00, NULL, '1083' FROM clinics c JOIN lab_tests e ON e.slug = 'matsuda-index' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1083 «Matsuda index»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 50.00, NULL, '1084' FROM clinics c JOIN lab_tests e ON e.slug = 'human-herpesvirus-6-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1084 «HHV 6 IgM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 50.00, NULL, '1085' FROM clinics c JOIN lab_tests e ON e.slug = 'human-herpesvirus-6-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1085 «HHV 6 IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '1086' FROM clinics c JOIN lab_tests e ON e.slug = 'chlamydia-pneumoniae-igm' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1086 «Chlamydia pneumoniae IgM»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 30.00, NULL, '1087' FROM clinics c JOIN lab_tests e ON e.slug = 'chlamydia-pneumoniae-igg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1087 «Chlamydia pneumoniae IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 80.00, NULL, '1088' FROM clinics c JOIN lab_tests e ON e.slug = 'quantiferon' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1088 «Kvantiferonski test»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '1089' FROM clinics c JOIN lab_tests e ON e.slug = 'yersinia-igg-antibodies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1089 «Yersinia IgG»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 11.00, NULL, '1090' FROM clinics c JOIN lab_tests e ON e.slug = 'rapid-strep-a' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1090 «Imunohromatografski test za dokazivanje Streptococcus beta haemolyticus grupe A»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '1097' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-15h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1097 «GLUKOZA 15h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 590.00, NULL, '1098' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-nifty-standard' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1098 «Nifty standard»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '1100' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-after-60-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1100 «GLUKOZA POSLIJE 60 min»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '1103' FROM clinics c JOIN lab_tests e ON e.slug = 'amphetamine' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1103 «AMPHETAMINE»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 1490.00, NULL, '1105' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-nifty-premium' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1105 «Nifty premium»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 500.00, NULL, '1106' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-nifty-twins-basic' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1106 «Nifty twins basic»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 800.00, NULL, '1107' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-nifty-twins-pro' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1107 «Nifty twins pro»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '1112' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-14h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1112 «GLUKOZA 14h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 25.00, NULL, '1115' FROM clinics c JOIN lab_tests e ON e.slug = 'clostridium-difficile-gdh-antigen' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1115 «Imunohromatografski test za dokazivanje Clostridium difficile GDH antigena»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 180.00, NULL, '1118' FROM clinics c JOIN lab_tests e ON e.slug = 'cf-and-sma-carrier-screening' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1118 «CF & SMA Carrier»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '1119' FROM clinics c JOIN lab_tests e ON e.slug = 'perineal-swab-for-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1119 «Ispitivanje prisustva gljivica u brisu perineuma»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '1122' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-12h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1122 «PROLAKTIN 12h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 8.00, NULL, '1123' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-15h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1123 «PROLAKTIN 15h»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 150.00, NULL, '1125' FROM clinics c JOIN lab_tests e ON e.slug = 'nipt-fetal-rhd-genotyping' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1125 «NIPT RH»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 40.00, NULL, '1128' FROM clinics c JOIN lab_tests e ON e.slug = 'soluble-transferrin-receptor' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1128 «Solubilni transferinski receptori»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 230.00, NULL, '1131' FROM clinics c JOIN lab_tests e ON e.slug = 'venisafe-materna-thrombophilia-panel' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1131 «Venisafe Materna»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.50, NULL, '1132' FROM clinics c JOIN lab_tests e ON e.slug = 'glucose-240-min' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1132 «Glukoza 240 min»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 2.00, NULL, '1133' FROM clinics c JOIN lab_tests e ON e.slug = 'quicki-insulin-sensitivity-index' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1133 «QUICKI-IR»
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 27.00, NULL, 'profil-prolactina' FROM clinics c JOIN lab_tests e ON e.slug = 'prolactin-profile' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- profil-prolactina «PROFIL PROLACTINA»

-- ── 2.2 Услуги (clinic_medical_services)
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 1.00, NULL, NULL, '0152' FROM clinics c JOIN medical_services e ON e.slug = 'venous-blood-draw' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0152 «VAĐENJE KRVI/PRIJEM MATERIJALA»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 15.00, NULL, NULL, '0154' FROM clinics c JOIN medical_services e ON e.slug = 'home-visit-for-laboratory-sample-collection' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0154 «KUĆNA POSJETA-LABORATORIJA»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0733' FROM clinics c JOIN medical_services e ON e.slug = 'endocrinologist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0733 «Endokrinološki pregled»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 10.00, NULL, NULL, '0792' FROM clinics c JOIN medical_services e ON e.slug = 'subconjunctival-injection' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0792 «Subkonjuktivalne injekcije»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '0798' FROM clinics c JOIN medical_services e ON e.slug = 'internist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0798 «Internistički pregled bez EKG-a»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 45.00, NULL, NULL, '0799' FROM clinics c JOIN medical_services e ON e.slug = 'expert-consultation' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0799 «Konsultantski specijalistički pregled»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0800' FROM clinics c JOIN medical_services e ON e.slug = 'follow-up-specialist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0800 «Kontrola poslije 7 do 20 dana od prvog pregleda»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 15.00, NULL, NULL, '0801' FROM clinics c JOIN medical_services e ON e.slug = 'ecg-without-interpretation' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0801 «EKG bez opisa - samo traka»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 30.00, NULL, NULL, '0802' FROM clinics c JOIN medical_services e ON e.slug = 'ecg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0802 «EKG sa opisom»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0803' FROM clinics c JOIN medical_services e ON e.slug = 'ultrasound-lymph-nodes' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0803 «eho limfnih žlijezda»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0804' FROM clinics c JOIN medical_services e ON e.slug = 'soft-tissue-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0804 «Eho mekih struktura»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0805' FROM clinics c JOIN medical_services e ON e.slug = 'neck-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0805 «Eho vrata»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0806' FROM clinics c JOIN medical_services e ON e.slug = 'breast-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0806 «Eho dojki»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0807' FROM clinics c JOIN medical_services e ON e.slug = 'testicular-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0807 «Eho testisa»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0808' FROM clinics c JOIN medical_services e ON e.slug = 'blood-vessels-doppler' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0808 «Eho krvnih sudova»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0809' FROM clinics c JOIN medical_services e ON e.slug = 'abdomen-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0809 «Eho gornjeg i donjeg abdomena»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0810' FROM clinics c JOIN medical_services e ON e.slug = 'urinary-tract-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0810 «Eho bubrega, mokraćne bešike i prostate sa rezidualnim urinom»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0811' FROM clinics c JOIN medical_services e ON e.slug = 'abdomen-and-urinary-tract-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0811 «Ehogornjeg i donjeg abdomena,bubrega, mokraćne bešike i prostate sa rezidualnim urinom»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0812' FROM clinics c JOIN medical_services e ON e.slug = 'echocardiography-heart-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0812 «Eho srca»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0813' FROM clinics c JOIN medical_services e ON e.slug = 'thyroid-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0813 «Eho štitne žlijezde»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 75.00, NULL, NULL, '0814' FROM clinics c JOIN medical_services e ON e.slug = 'specialist-examination-with-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0814 «Specijalistički pregled i eho kod istog ljekara»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0815' FROM clinics c JOIN medical_services e ON e.slug = 'doppler-neck-blood-vessels' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0815 «Dopler krvnih sudova vrata»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0816' FROM clinics c JOIN medical_services e ON e.slug = 'doppler-upper-extremity-blood-vessels' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0816 «Dopler krvnih sudova gornjih ekstremiteta»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0817' FROM clinics c JOIN medical_services e ON e.slug = 'doppler-lower-extremity-blood-vessels' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0817 «Dopler krvnih sudova donjih ekstremiteta»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 100.00, NULL, NULL, '0818' FROM clinics c JOIN medical_services e ON e.slug = 'doppler-of-neck-upper-and-lower-extremity-blood-vessels' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0818 «Dopler krvnih sudova vrata, donjih i gornjih ekstremiteta»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0819' FROM clinics c JOIN medical_services e ON e.slug = 'doppler-renal-arteries' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0819 «Dopler renalnih arterija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0820' FROM clinics c JOIN medical_services e ON e.slug = 'doppler-portal-vein' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0820 «Dopler portnog sistema»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 10.00, NULL, NULL, '0821' FROM clinics c JOIN medical_services e ON e.slug = 'intramuscular-injection' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0821 «Davanje intramuskularne injekcije»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, NULL, '0822' FROM clinics c JOIN medical_services e ON e.slug = 'infusion-therapy' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0822 «Davanje infuzije»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0823' FROM clinics c JOIN medical_services e ON e.slug = 'gynecological-specialist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0823 «Ginekološki pregled»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0824' FROM clinics c JOIN medical_services e ON e.slug = 'gynecological-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0824 «Ultrazvučni pregled (vaginalno i/ili abdominalno)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0825' FROM clinics c JOIN medical_services e ON e.slug = 'colposcopy' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0825 «Kolposkopija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0826' FROM clinics c JOIN medical_services e ON e.slug = 'cervical-biopsy' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0826 «Biopsija grlića materice (PH nalaz nije uračunat)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0827' FROM clinics c JOIN medical_services e ON e.slug = 'endometrial-tissue-sampling-for-histology' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0827 «Biopsija endometrija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0828' FROM clinics c JOIN medical_services e ON e.slug = 'endocervical-curettage-ecc' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0828 «Endocervikalna kiretaža kod pojedinih Kolposkopija (PH nalaz dodatno)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 150.00, NULL, NULL, '0829' FROM clinics c JOIN medical_services e ON e.slug = 'exploratory-curettage' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0829 «Eksplorativna kiretaža (PH nalaz nije uračunat)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 200.00, NULL, 250.00, '0830' FROM clinics c JOIN medical_services e ON e.slug = 'leep-excision' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0830 «LETZ (PH nalaz nije uračunat)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 400.00, NULL, NULL, '0832' FROM clinics c JOIN medical_services e ON e.slug = 'cervical-conization' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0832 «Konizacija grlića materice (PH nalaz nije uračunat)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 200.00, NULL, NULL, '0833' FROM clinics c JOIN medical_services e ON e.slug = 'condyloma-radio-wave-removal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0833 «Odstranjivanje kondiloma RF nožem u lokalnoj anesteziji»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '0835' FROM clinics c JOIN medical_services e ON e.slug = 'polypectomy' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0835 «Odstranjivanje polipa materice (polipektomija)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 150.00, NULL, NULL, '0836' FROM clinics c JOIN medical_services e ON e.slug = 'transvaginal-ovarian-cyst-puncture' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0836 «Punkcija ciste jajnika transvaginalno»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0838' FROM clinics c JOIN medical_services e ON e.slug = 'pessary-insertion' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0838 «Postavljanje pesara kod spada materice»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 350.00, NULL, NULL, '0839' FROM clinics c JOIN medical_services e ON e.slug = 'bartholin-cyst-excision' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0839 «Odstranjivanje Bartolinove ciste»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 100.00, NULL, NULL, '0840' FROM clinics c JOIN medical_services e ON e.slug = 'bartholin-gland-incision' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0840 «Hiruški tretman apscesa Bartolinove žlijezde (incizija i drenaža)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0841' FROM clinics c JOIN medical_services e ON e.slug = 'labial-and-vulval-biopsy' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0841 «Biopsija kože i potkože genitalija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, NULL, '0842' FROM clinics c JOIN medical_services e ON e.slug = 'catheter-placement' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0842 «Postavljanje katetera»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 120.00, NULL, NULL, '0843' FROM clinics c JOIN medical_services e ON e.slug = 'abdominal-fluid-drainage-under-ultrasound-guidance' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0843 «Punkcija trbuha i drenaža ascita pod kontrolom ultrazvuka»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, NULL, '0845' FROM clinics c JOIN medical_services e ON e.slug = 'wound-dressing' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0845 «Previjanje»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 100.00, NULL, NULL, '0849' FROM clinics c JOIN medical_services e ON e.slug = 'folliculometry' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0849 «Folikulometrija (serija UZ pregleda za dokazivanje ovulacije)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0850' FROM clinics c JOIN medical_services e ON e.slug = 'antral-follicle-count-ultrasound-afc' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0850 «Ultrazvučno određivanje ovarijalne rezerve (AFC)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '0851' FROM clinics c JOIN medical_services e ON e.slug = '3d4d-uterine-ultrasound-for-anomalies' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0851 «3D/4D ultrazvučni pregled materice na anomalije»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 250.00, NULL, NULL, '0852' FROM clinics c JOIN medical_services e ON e.slug = 'hysterosalpingography' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0852 «HSG»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '0854' FROM clinics c JOIN medical_services e ON e.slug = 'ovulation-induction-with-folliculometry' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0854 «Indukcija/stimulacija ovulacije i folikulometrija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 200.00, NULL, NULL, '0855' FROM clinics c JOIN medical_services e ON e.slug = 'intrauterine-insemination-iui' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0855 «Inseminacija (AIH)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, NULL, '0858' FROM clinics c JOIN medical_services e ON e.slug = 'contraception-consultation' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0858 «Savjetovanje za kontracepciju»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '0859' FROM clinics c JOIN medical_services e ON e.slug = 'iud-insertion' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0859 «Pregled i postavljanje kupljene spirale»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0860' FROM clinics c JOIN medical_services e ON e.slug = 'iud-removal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0860 «Odstranjivanje spirale stavljene u Diagnostici»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, NULL, '0862' FROM clinics c JOIN medical_services e ON e.slug = 'family-planning-and-pregnancy-counseling' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0862 «Savjetovanje o planiranju porodice i trudnoće»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0863' FROM clinics c JOIN medical_services e ON e.slug = 'pregnancy-specialist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0863 «Ginekološki pregled u trudnoći»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0864' FROM clinics c JOIN medical_services e ON e.slug = 'pregnancy-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0864 «Ultrazvučni pregled u trudnoći»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '0866' FROM clinics c JOIN medical_services e ON e.slug = '4d-pregnancy-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0866 «3D/4D ultrazvuk»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '0867' FROM clinics c JOIN medical_services e ON e.slug = 'expert-pregnancy-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0867 «Ekspertski ultrazvuk»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0869' FROM clinics c JOIN medical_services e ON e.slug = 'ctg-fetal-monitoring' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0869 «CTG u trajanju od 20min»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 75.00, NULL, NULL, '0870' FROM clinics c JOIN medical_services e ON e.slug = 'postpartum-gynecological-examination-with-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0870 «Ginekološki pregled + ultrazvučni pregled poslije porođaja»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 150.00, NULL, NULL, '0871' FROM clinics c JOIN medical_services e ON e.slug = 'secondary-suture-of-episiotomy-or-perineal-tear' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0871 «Ponovno/sekundarno ušivanje epiziotomije ili rupture medice»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 30.00, NULL, NULL, '0872' FROM clinics c JOIN medical_services e ON e.slug = 'postpartum-breast-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0872 «Pregled grudi poslije porođaja (zastoj laktacije, upala)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 100.00, NULL, NULL, '0873' FROM clinics c JOIN medical_services e ON e.slug = 'breast-abscess-puncture-and-drainage' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0873 «Punkcija i drenaža apcesa dojke»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 10.00, NULL, NULL, '0881' FROM clinics c JOIN medical_services e ON e.slug = 'ambulatory-small-dressing' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0881 «Previjanje malo»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 15.00, NULL, NULL, '0882' FROM clinics c JOIN medical_services e ON e.slug = 'ambulatory-medium-dressing' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0882 «Previjanje srednje»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 30.00, NULL, NULL, '0883' FROM clinics c JOIN medical_services e ON e.slug = 'ambulatory-large-dressing' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0883 «Previjanje veliko»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 10.00, NULL, 20.00, '0884' FROM clinics c JOIN medical_services e ON e.slug = 'suture-removal' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0884 «Skidanje konaca (do 5 konaca)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, NULL, '0892' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-general-work' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0892 «Ljekarsko uvjerenje o sposobnosti za rad, prilikom zasnivanja radnog odnosa(rad.mj.bez poveć rizika)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '0893' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-high-risk-work' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0893 «Ljekarsko uvjerenje za rad na mjestima sa povećanim rizikom»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0894' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-high-risk-and-difficult-working-conditions' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0894 «Ljekarsko uvjerenje za rad na mjestima sa povećanim rizikom i otežanim uslovima»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0895' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-difficult-working-conditions-without-high-risk' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0895 «Ljekarsko uvjerenje za rad na mjestima sa otežanim uslovima»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0896' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-class-a-and-b-drivers' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0896 «Ljekarsko uvjerenje za upravljanje motornim vozilom A i B kategorije»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0897' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-professional-drivers' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0897 «Ljekarsko uvjerenje za profesionalne vozače»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0898' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-driving-instructor-category-b-c-d-e' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0898 «Ljekarsko uvjerenje za posao instruktora»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 45.00, NULL, NULL, '0899' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-firearms-possession' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0899 «Ljekarsko uvjerenje o podobnosti za posjedovanje vatrenog oružja»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0900' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-military-service' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0900 «Ljekarsko uvjerenje o sposobnosti za obavljanje službe u Vojsci Crne Gore»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0901' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-underage-marriage' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0901 «Ljekarsko uvjerenje za sklapanje braka za maloljetne osobe»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0902' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-child-adoption' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0902 «Ljekarsko uvjerenje za podobnost za usvajanje djeteta»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0903' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-study-abroad-and-visa' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0903 «Ljekarsko uvjerenje za dalji nastavak školovanja i boravak u inostranstvu/viza»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '0904' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-court-expert' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0904 «Ljekarsko uvjerenje za posao sudskog vještaka»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0905' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-collective-accommodation' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0905 «Ljekarsko uvjerenje za kolektivni smještaj»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0906' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-life-insurance' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0906 «Ljekarsko uvjerenje radi životnog osiguranja»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, 70.00, '0907' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-athletes' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0907 «Ljekarsko uvjerenje za utvrđivanje zdravstvene sposobnosti za sportiste»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 150.00, NULL, NULL, '0908' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-maritime-workers' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0908 «Ljekarsko uvjerenje za pomorce»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0909' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-sports-referees-and-other-purposes' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0909 «Ljekarsko uvjerenje za druge potrebe(sportske sudije i dr.)»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0913' FROM clinics c JOIN medical_services e ON e.slug = 'holter-ecg-24h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0913 «Holter EKG-a»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 55.00, NULL, NULL, '0916' FROM clinics c JOIN medical_services e ON e.slug = 'ergometry-stress-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0916 «ergometrija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '0923' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-residence-and-work-in-montenegro' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0923 «Ljekarsko uvjerenje za radnu i boravisnu dozvolu»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0929' FROM clinics c JOIN medical_services e ON e.slug = 'pulmonologist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0929 «Pregled pulmologa»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '0932' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-boat-operation-up-to-12-meters' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0932 «Ljekarsko uvjerenje za upravitelje čamcem»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '0934' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-lifeguards' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0934 «Ljekarsko uvjerenje za spasioce na vodi»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0938' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-ionizing-radiation-workers' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0938 «Ljekarsko uvjerenje za rad na mjestima sa povećanim rizikom-u zoni jonizujućeg zračenja»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 60.00, NULL, NULL, '0946' FROM clinics c JOIN medical_services e ON e.slug = 'holter-blood-pressure-24h' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0946 «HOLTER KRVNOG PRITISKA»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0949' FROM clinics c JOIN medical_services e ON e.slug = 'ent-specialist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0949 «ORL pregled» [note: na upit]
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 15.00, NULL, 20.00, '0951' FROM clinics c JOIN medical_services e ON e.slug = 'spirometry' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0951 «Spirometrija»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 40.00, NULL, NULL, '0957' FROM clinics c JOIN medical_services e ON e.slug = 'pediatric-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0957 «Pregled pedijatra»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 20.00, NULL, NULL, '0958' FROM clinics c JOIN medical_services e ON e.slug = 'follow-up-pediatric-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0958 «Kontrolni pregled pedijatra»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 260.00, NULL, NULL, '0959' FROM clinics c JOIN medical_services e ON e.slug = 'hycosy-tubal-patency-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 0959 «HyFoSy»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '1010' FROM clinics c JOIN medical_services e ON e.slug = 'pediatric-examination-with-spirometry' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1010 «Pregled pedijatra sa spirometrijom»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '1011' FROM clinics c JOIN medical_services e ON e.slug = 'pediatric-examination-with-spirometry-and-bronchodilator-test' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1011 «Pregled pedijatra sa spirometrijom i BDT»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 5.00, NULL, NULL, '1015' FROM clinics c JOIN medical_services e ON e.slug = 'inhalation-therapy' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1015 «Inhalacije»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '1016' FROM clinics c JOIN medical_services e ON e.slug = 'prick-test-inhalation-allergens' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1016 «Kožne probe na inhalacione alergene»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '1017' FROM clinics c JOIN medical_services e ON e.slug = 'prick-test-nutritive-allergens' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1017 «Kožne probe na nutritivne alergene»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '1018' FROM clinics c JOIN medical_services e ON e.slug = 'intravenous-medication-application' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1018 «Intravenska terapija+lijek»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '1021' FROM clinics c JOIN medical_services e ON e.slug = 'wound-care' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1021 «Obrada rane»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '1039' FROM clinics c JOIN medical_services e ON e.slug = 'home-visit-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1039 «Kućna posjeta sa ljekarom»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '1054' FROM clinics c JOIN medical_services e ON e.slug = 'cardiologist-examination-with-ecg' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1054 «Subspecijalistički kardiološki pregled + EKG»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 75.00, NULL, NULL, '1055' FROM clinics c JOIN medical_services e ON e.slug = 'cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1055 «Subspecijalistički kardiološki pregled +EKG+EHO»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '1056' FROM clinics c JOIN medical_services e ON e.slug = 'pediatric-echocardiography' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1056 «EHO srca -djeca»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 35.00, NULL, NULL, '1057' FROM clinics c JOIN medical_services e ON e.slug = 'general-practitioner-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1057 «Opšti pregled bez EKG-a»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 75.00, NULL, NULL, '1058' FROM clinics c JOIN medical_services e ON e.slug = 'gynecological-specialist-examination-with-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1058 «Ginekološki pregled + EHO»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 75.00, NULL, NULL, '1060' FROM clinics c JOIN medical_services e ON e.slug = 'internist-examination-with-ecg-and-ultrasound' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1060 «Internistički pregled+EKG+EHO»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '1099' FROM clinics c JOIN medical_services e ON e.slug = 'fetal-echocardiography' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1099 «Fetalni eho srca»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '1114' FROM clinics c JOIN medical_services e ON e.slug = 'glutathione-iv' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1114 «GLUTATION INFUZIJA»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '1117' FROM clinics c JOIN medical_services e ON e.slug = 'psychotherapy' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1117 «PSIHOTERAPIJA»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 200.00, NULL, NULL, '1120' FROM clinics c JOIN medical_services e ON e.slug = 'bartholin-gland-incision-and-marsupialization' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1120 «Marsupijelizacija apscesa bartolinijeve žlijezde»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 25.00, NULL, NULL, '1121' FROM clinics c JOIN medical_services e ON e.slug = 'gynecological-swab-collection' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1121 «Uzorkovanje ginekoloških briseva/pappa brisa»
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 70.00, NULL, NULL, '1124' FROM clinics c JOIN medical_services e ON e.slug = 'subspecialist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica'; -- 1124 «Subspecijalistički pregled»

-- ═══ VERIFICATION ═══
SELECT id AS clinic_id, slug FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica';
SELECT 'lab' AS t, COUNT(*) AS rows_total, SUM(price IS NOT NULL) AS priced, SUM(code IS NOT NULL) AS with_code FROM clinic_lab_tests WHERE clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica')
UNION ALL SELECT 'ms', COUNT(*), SUM(price IS NOT NULL OR price_min IS NOT NULL), SUM(code IS NOT NULL) FROM clinic_medical_services WHERE clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica');
-- ожидается: lab 434, ms 122
SELECT 'lab' AS t, COUNT(*) AS new_found FROM lab_tests WHERE slug IN ('abdominal-drain-swab-for-fungi', 'adult-helminth-identification', 'aspiration-catheter-tracheal-aspirate-culture-for-fungi', 'bronchoalveolar-lavage-culture-for-fungi', 'central-venous-catheter-culture-for-fungi', 'cervical-swab-culture-anaerobic', 'cf-and-sma-carrier-screening', 'clostridium-difficile-gdh-antigen', 'cortisol-11h', 'cortisol-8h', 'drain-swab-for-fungi', 'endometrial-biopsy-culture-aerobic', 'endometrial-biopsy-culture-anaerobic', 'glucose-12h', 'glucose-14h', 'glucose-15h', 'glucose-1h-after-meal', 'glucose-2h-after-meal', 'glucose-after-150-min', 'high-sensitivity-c-reactive-protein', 'human-herpesvirus-6-igg', 'human-herpesvirus-6-igm', 'implant-culture-aerobic', 'insulin-12h', 'insulin-17h', 'insulin-20h', 'insulin-2h-after-meal', 'insulin-7h', 'insulin-after-150-min', 'ldlhdl-ratio', 'lochia-culture-for-fungi', 'matsuda-index', 'mouth-corner-swab-for-bacteria', 'mouth-corner-swab-for-fungi', 'nail-swab-for-bacteria', 'nipt-fetal-rhd-genotyping', 'nipt-nifty-basic', 'nipt-nifty-plus', 'nipt-nifty-premium', 'nipt-nifty-pro', 'nipt-nifty-standard', 'nipt-nifty-twins-basic', 'nipt-nifty-twins-pro', 'non-hdl-cholesterol', 'non-hdlhdl-ratio', 'perineal-swab-for-bacteria', 'perineal-swab-for-fungi', 'prolactin-12h', 'prolactin-14h', 'prolactin-15h', 'prolactin-17h', 'prolactin-8h', 'puncture-fluid-for-anaerobic-bacteria', 'quicki-insulin-sensitivity-index', 'renal-pelvis-lavage-culture-aerobic', 'skin-scraping-for-sarcoptes-scabiei', 'sodium-in-urine', 'soluble-transferrin-receptor', 'sputum-parasites', 'thoracic-drain-swab-for-fungi', 'total-cholesterolhdl-ratio', 'urinary-catheter-tip-culture-for-fungi', 'vaginal-introitus-and-anal-swab-for-bacteria', 'vaginal-introitus-and-anal-swab-for-fungi', 'vaginal-swab-culture-anaerobic', 'venisafe-materna-thrombophilia-panel', 'yersinia-igg-antibodies'); -- ожидается 67
SELECT 'ms' AS t, COUNT(*) AS new_found FROM medical_services WHERE slug IN ('3d4d-uterine-ultrasound-for-anomalies', 'antral-follicle-count-ultrasound-afc', 'breast-abscess-puncture-and-drainage', 'doppler-of-neck-upper-and-lower-extremity-blood-vessels', 'ecg-without-interpretation', 'family-planning-and-pregnancy-counseling', 'fetal-echocardiography', 'glutathione-iv', 'home-visit-for-laboratory-sample-collection', 'ovulation-induction-with-folliculometry', 'pediatric-echocardiography', 'pediatric-examination-with-spirometry', 'pediatric-examination-with-spirometry-and-bronchodilator-test', 'postpartum-breast-examination', 'postpartum-gynecological-examination-with-ultrasound', 'secondary-suture-of-episiotomy-or-perineal-tear', 'transvaginal-ovarian-cyst-puncture'); -- ожидается 17
SELECT e.slug FROM lab_tests e WHERE e.slug IN ('abdominal-drain-swab-for-fungi', 'adult-helminth-identification', 'aspiration-catheter-tracheal-aspirate-culture-for-fungi', 'bronchoalveolar-lavage-culture-for-fungi', 'central-venous-catheter-culture-for-fungi', 'cervical-swab-culture-anaerobic', 'cf-and-sma-carrier-screening', 'clostridium-difficile-gdh-antigen', 'cortisol-11h', 'cortisol-8h', 'drain-swab-for-fungi', 'endometrial-biopsy-culture-aerobic', 'endometrial-biopsy-culture-anaerobic', 'glucose-12h', 'glucose-14h', 'glucose-15h', 'glucose-1h-after-meal', 'glucose-2h-after-meal', 'glucose-after-150-min', 'high-sensitivity-c-reactive-protein', 'human-herpesvirus-6-igg', 'human-herpesvirus-6-igm', 'implant-culture-aerobic', 'insulin-12h', 'insulin-17h', 'insulin-20h', 'insulin-2h-after-meal', 'insulin-7h', 'insulin-after-150-min', 'ldlhdl-ratio', 'lochia-culture-for-fungi', 'matsuda-index', 'mouth-corner-swab-for-bacteria', 'mouth-corner-swab-for-fungi', 'nail-swab-for-bacteria', 'nipt-fetal-rhd-genotyping', 'nipt-nifty-basic', 'nipt-nifty-plus', 'nipt-nifty-premium', 'nipt-nifty-pro', 'nipt-nifty-standard', 'nipt-nifty-twins-basic', 'nipt-nifty-twins-pro', 'non-hdl-cholesterol', 'non-hdlhdl-ratio', 'perineal-swab-for-bacteria', 'perineal-swab-for-fungi', 'prolactin-12h', 'prolactin-14h', 'prolactin-15h', 'prolactin-17h', 'prolactin-8h', 'puncture-fluid-for-anaerobic-bacteria', 'quicki-insulin-sensitivity-index', 'renal-pelvis-lavage-culture-aerobic', 'skin-scraping-for-sarcoptes-scabiei', 'sodium-in-urine', 'soluble-transferrin-receptor', 'sputum-parasites', 'thoracic-drain-swab-for-fungi', 'total-cholesterolhdl-ratio', 'urinary-catheter-tip-culture-for-fungi', 'vaginal-introitus-and-anal-swab-for-bacteria', 'vaginal-introitus-and-anal-swab-for-fungi', 'vaginal-swab-culture-anaerobic', 'venisafe-materna-thrombophilia-panel', 'yersinia-igg-antibodies') AND NOT EXISTS (SELECT 1 FROM lab_test_categories_relations r WHERE r.lab_test_id = e.id); -- ожидается пусто
SELECT e.slug FROM medical_services e WHERE e.slug IN ('3d4d-uterine-ultrasound-for-anomalies', 'antral-follicle-count-ultrasound-afc', 'breast-abscess-puncture-and-drainage', 'doppler-of-neck-upper-and-lower-extremity-blood-vessels', 'ecg-without-interpretation', 'family-planning-and-pregnancy-counseling', 'fetal-echocardiography', 'glutathione-iv', 'home-visit-for-laboratory-sample-collection', 'ovulation-induction-with-folliculometry', 'pediatric-echocardiography', 'pediatric-examination-with-spirometry', 'pediatric-examination-with-spirometry-and-bronchodilator-test', 'postpartum-breast-examination', 'postpartum-gynecological-examination-with-ultrasound', 'secondary-suture-of-episiotomy-or-perineal-tear', 'transvaginal-ovarian-cyst-puncture') AND NOT EXISTS (SELECT 1 FROM medical_service_categories_relations r WHERE r.medical_service_id = e.id); -- ожидается пусто

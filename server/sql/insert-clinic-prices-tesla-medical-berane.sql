SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Tesla Medical (Беране, slug tesla-medical-berane) — синхронизация цен услуг с сайтом.
--
-- Источник: https://www.teslamedical.me/cene/ — снят 2026-10-02 curl'ом,
--   data/clinic-pricelists/sources/tesla-medical-berane/2026-10-02-cene.html.
--   Дата прайса: wp-json pages/57 modified 2020-01-13. is_price_outdated не ставится: кроме
--   даты, признаков устаревания нет (в отзывах 2025 — «cijene povoljne»; решение юзера 2026-10-05).
--   Цены на сайте без «€», формат «30.00»; внизу «Sve cene su izražene u evrima».
--
-- Сводка: на сайте 119 строк.
--   76 строк сайта = 75 строк клиники, цена совпадает — не трогаются;
--   43 строк сайта → 42 новых строк клиники (из них 6 на новые записи каталога);
--   три КТ без указания контраста заведены как «с контрастом» (решение юзера 2026-10-05);
--   1 строка клиники пересажена: spinal-decompression → mechanical-spinal-traction («Trakcija»), старая is_obsolete = 1;
--   1 строка клиники не тронута: lower-extremity-color-doppler (дубль каталога).
--   Изменённых цен нет: все совпавшие строки стоят так же, как на сайте.
--   Разбор построчно — data/clinic-imports/tesla-medical-berane-prices-2026-10.md.
--
-- Клиника и записи каталога — только по slug (id локально и на проде расходятся).
-- INSERT IGNORE / ON DUPLICATE KEY / UPDATE с условием на цену: повторный прогон
-- ничего не ломает, строку, поправленную руками, не перезаписывает.

SET @clinic_id = (SELECT id FROM clinics WHERE slug = 'tesla-medical-berane');

-- ═══ 1. Новые записи каталога (6) ═══

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('MRI Contrast Agent', 'mri-contrast-agent', 'MR kontrastno sredstvo', 'МР контрастно средство', 'МРТ контрастное вещество', 'MRT-Kontrastmittel', 'MR Kontrast Maddesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 1 FROM medical_services WHERE slug = 'mri-contrast-agent';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kontrast za magnetnu rezonancu', 'sr' FROM medical_services WHERE slug = 'mri-contrast-agent';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Gadolinium Contrast', 'en' FROM medical_services WHERE slug = 'mri-contrast-agent';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('MSCT Head and Cervical Spine', 'msct-head-and-cervical-spine', 'CT glave i vratnog dijela kičme', 'ЦТ главе и вратног дијела кичме', 'КТ головы и шейного отдела позвоночника', 'CT Kopf und Halswirbelsäule', 'Beyin ve Servikal Omurga BT')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 2 FROM medical_services WHERE slug = 'msct-head-and-cervical-spine';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'CT glave i C kičme', 'sr' FROM medical_services WHERE slug = 'msct-head-and-cervical-spine';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('MSCT Knee', 'msct-knee', 'CT koljena', 'ЦТ кољена', 'КТ коленного сустава', 'CT Kniegelenk', 'Diz BT')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 2 FROM medical_services WHERE slug = 'msct-knee';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Knee CT', 'en' FROM medical_services WHERE slug = 'msct-knee';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Skener koljena', 'sr' FROM medical_services WHERE slug = 'msct-knee';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('MSCT Pelvis with Contrast', 'msct-pelvis-with-contrast', 'CT male karlice sa kontrastom', 'ЦТ мале карлице са контрастом', 'КТ малого таза с контрастом', 'CT Becken mit Kontrastmittel', 'Kontrastlı Pelvis BT')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 2 FROM medical_services WHERE slug = 'msct-pelvis-with-contrast';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pelvic CT with Contrast', 'en' FROM medical_services WHERE slug = 'msct-pelvis-with-contrast';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('MSCT Shoulder', 'msct-shoulder', 'CT ramena', 'ЦТ рамена', 'КТ плечевого сустава', 'CT Schultergelenk', 'Omuz BT')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 2 FROM medical_services WHERE slug = 'msct-shoulder';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Shoulder CT', 'en' FROM medical_services WHERE slug = 'msct-shoulder';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Skener ramena', 'sr' FROM medical_services WHERE slug = 'msct-shoulder';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Pelvic Color Doppler', 'pelvic-color-doppler', 'Kolor dopler krvnih sudova male karlice', 'Колор доплер крвних судова мале карлице', 'Цветное допплеровское исследование сосудов малого таза', 'Farbdopplersonographie der Beckengefäße', 'Pelvik Damarların Renkli Doppler Ultrasonografisi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'pelvic-color-doppler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Kolor dopler karlice', 'sr' FROM medical_services WHERE slug = 'pelvic-color-doppler';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language) SELECT id, 'Pelvic Doppler Ultrasound', 'en' FROM medical_services WHERE slug = 'pelvic-color-doppler';

-- ═══ 2. Новые строки клиники (42) ═══

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, v.price, NULL, NULL, NULL FROM (
      SELECT 'echocardiography-heart-ultrasound' AS slug, 40.00 AS price -- «Eho srca»
UNION ALL SELECT 'mechanical-spinal-traction', 13.00 -- «Trakcija»
UNION ALL SELECT 'mri-brain', 120.00 -- «MR glave»
UNION ALL SELECT 'mri-soft-tissue-neck', 130.00 -- «MR mekih tkiva vrata»
UNION ALL SELECT 'mri-brain-with-mra', 180.00 -- «MR glave sa angiografijom»
UNION ALL SELECT 'mri-pituitary-gland-sella-turcica', 160.00 -- «MR hipofize sa kontrastom»
UNION ALL SELECT 'mri-brain-and-cervical-spine', 200.00 -- «MR glave i vratnog dijela kicme»
UNION ALL SELECT 'mri-thorax-and-mediastinum', 140.00 -- «MR grudnog kosa»
UNION ALL SELECT 'mri-abdomen', 140.00 -- «MR abdomena»
UNION ALL SELECT 'mri-cholangiography-mrcp', 140.00 -- «MRCP»
UNION ALL SELECT 'mri-pelvic-organs', 130.00 -- «MR male karlice»
UNION ALL SELECT 'mri-single-joint', 130.00 -- «MR zglobova»
UNION ALL SELECT 'mri-lumbosacral-spine', 120.00 -- «MR L/S kicme»
UNION ALL SELECT 'mri-two-spine-segments', 200.00 -- «MR LS kicme i TH kicme» / «MR LS kicme i C kicme»
UNION ALL SELECT 'mri-full-spine', 280.00 -- «MR kompletnog kicmenog stuba»
UNION ALL SELECT 'mri-knee-joint', 130.00 -- «MR koljena»
UNION ALL SELECT 'mri-contrast-agent', 35.00 -- «Kontrast»
UNION ALL SELECT 'msct-abdomen-and-pelvis-with-contrast', 160.00 -- «CT abdomena i male karlice»
UNION ALL SELECT 'msct-abdomen-with-contrast', 110.00 -- «CT abdomena sa kontrastom»
UNION ALL SELECT 'msct-angiography-abdominal-aorta-and-lower-extremities', 180.00 -- «CT angiografija abdominalne aorte i donjih ekstremitata»
UNION ALL SELECT 'msct-angiography-head-and-neck-vessels', 140.00 -- «CT angiografija glave i vrata»
UNION ALL SELECT 'msct-angiography-pulmonary-arteries-pte', 130.00 -- «CT angoigrafija pluća»
UNION ALL SELECT 'msct-angiography-aorta', 140.00 -- «CT aortografija»
UNION ALL SELECT 'msct-cervical-spine', 70.00 -- «CT C kičme»
UNION ALL SELECT 'msct-two-spine-segments', 120.00 -- «CT C kičme i LS kičme»
UNION ALL SELECT 'msct-head-and-cervical-spine', 120.00 -- «CT glave i C kicme»
UNION ALL SELECT 'msct-head-endocranium-without-contrast', 70.00 -- «Ct glave nativa»
UNION ALL SELECT 'msct-head-endocranium-with-contrast', 100.00 -- «CT glave sa kontrastom»
UNION ALL SELECT 'msct-knee', 70.00 -- «CT koljena»
UNION ALL SELECT 'msct-coronary-angiography', 180.00 -- «CT koronarografija»
UNION ALL SELECT 'msct-lumbosacral-spine', 70.00 -- «CT LS kicme»
UNION ALL SELECT 'msct-pelvis-with-contrast', 110.00 -- «CT male karlice sa kontrastom»
UNION ALL SELECT 'msct-soft-tissue-neck-with-contrast', 110.00 -- «CT mekih tkiva vrata sa kontrastom»
UNION ALL SELECT 'msct-chest-and-abdomen-with-contrast', 170.00 -- «Ct pluća i abdomena sa kontrastom»
UNION ALL SELECT 'msct-thorax-chest-with-contrast', 100.00 -- «CT pluća sa kontrastom»
UNION ALL SELECT 'msct-shoulder', 70.00 -- «CT ramena»
UNION ALL SELECT 'msct-thoracic-spine', 70.00 -- «CT TH kicme»
UNION ALL SELECT 'msct-ivu-intravenous-urography', 130.00 -- «CT urografija»
UNION ALL SELECT 'msct-chest-abdomen-pelvis-with-contrast', 210.00 -- «CT pluća, abdomena i male karlice»
UNION ALL SELECT 'msct-neck-and-chest-with-contrast', 170.00 -- «CT mekih tkiva vrata i grudnog kosa»
UNION ALL SELECT 'lower-abdomen-ultrasound', 25.00 -- «Ultrazvuk male karlice»
UNION ALL SELECT 'pelvic-color-doppler', 35.00 -- «Kolor dopler karlice»
) v JOIN medical_services ms ON ms.slug = v.slug
WHERE @clinic_id IS NOT NULL;

-- ═══ 3. Пересадка «Trakcija» ═══
-- На сайте «Trakcija» 13 €. Строка клиники висела на spinal-decompression
-- («Spinalna dekompresija»), а такой позиции на сайте нет. Новая строка —
-- mechanical-spinal-traction (раздел 2), старая помечается is_obsolete.
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'spinal-decompression'
   SET r.is_obsolete = 1
 WHERE r.clinic_id = @clinic_id AND r.price = 13.00 AND r.is_obsolete = 0;

-- ═══ Не тронуто ═══
--   lower-extremity-color-doppler: вторая строка под ту же позицию сайта «Kolor dopler d.ekstremiteta» (35 €), рядом с doppler-lower-extremity-blood-vessels (35 €). Записи каталога — дубли друг друга (как и пара upper-extremity-color-doppler / doppler-upper-extremity-blood-vessels); решать слиянием каталога, а не пометкой у одной клиники.

-- ═══ VERIFICATION ═══
SELECT @clinic_id AS clinic_id;
SELECT COUNT(*) AS rows_total, SUM(is_obsolete = 0) AS active, SUM(is_obsolete) AS obsolete,
       SUM(is_price_outdated) AS outdated FROM clinic_medical_services WHERE clinic_id = @clinic_id;
-- Ожидается: rows_total 119, active 118, obsolete 1, outdated 0.
SELECT ms.slug, ms.name_en FROM medical_services ms
 WHERE ms.slug IN ('mri-contrast-agent', 'msct-head-and-cervical-spine', 'msct-knee', 'msct-pelvis-with-contrast', 'msct-shoulder', 'pelvic-color-doppler');
-- Ожидается 6 строк.
SELECT e.slug, r.price, r.is_obsolete
  FROM clinic_medical_services r JOIN medical_services e ON e.id = r.medical_service_id
 WHERE r.clinic_id = @clinic_id AND r.is_obsolete = 1;
-- Ожидается: spinal-decompression.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Poliklinika Diagnostica (Подгорица, slug poliklinika-diagnostica-podgorica): спорные позиции импорта.
--
-- Дополнение к server/sql/insert-clinic-prices-poliklinika-diagnostica-podgorica.sql (применён
-- локально и на проде 2026-10-05). Источник тот же: https://api.diagnostica.me/api/public/pricelist,
-- повторный срез 2026-10-06 совпал со снимком 2026-10-02 байт в байт
-- (sha256 2d0e7d83437236f15389214d3c3e86ab41160e77f9a93e485d80ad06b4d92cb9).
-- Локальная БД и прод для затронутых записей сверены 2026-10-06 по /api/{labtests,services}/details:
-- строки клиники, коды и категории совпадают.
--
-- Из 40 спорных позиций с кодом: в этом файле 18 (новых строк анализов 13, услуг 7, расширение
-- диапазона у 1 строки), в excluded записи импорта 20, вопросом юзеру осталось 2 (CANCER SCREEN).
-- Новых записей каталога нет. Плюс две правки категорий каталога из заметок импорта.
-- Решения и причины — в data/clinic-imports/poliklinika-diagnostica-podgorica.json.
--
-- Клиника и записи — по slug. Идемпотентно: INSERT IGNORE, UPDATE и DELETE с условием на старое
-- значение; повторный прогон ничего не меняет. Номер миграции не занят.

-- ═══ 1. Анализы ═══

-- 0724 «Ph krvi» 20 € — pH крови меряют на газоанализаторе вместе с pCO2/pO2; в каталоге только КЩС.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 20.00, NULL, '0724' FROM clinics c JOIN lab_tests e ON e.slug = 'acid-base-status-ph-pco2-po2' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0601 «KATEHOLAMINI» 50 € — плазма у клиники отдельной строкой (0731), значит это моча.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 50.00, NULL, '0601' FROM clinics c JOIN lab_tests e ON e.slug = 'catecholamines-in-24h-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 1126 «Kappa i Lambda lanci u serumu» 65 € — одна позиция на пару κ+λ (и их соотношение);
-- как у Moj Lab, ставится на все три записи каталога, цена за пару.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 65.00, NULL, '1126' FROM clinics c JOIN lab_tests e ON e.slug = 'kappa-light-chain' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 65.00, NULL, '1126' FROM clinics c JOIN lab_tests e ON e.slug = 'lambda-light-chain' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 65.00, NULL, '1126' FROM clinics c JOIN lab_tests e ON e.slug = 'kappa-lambda-light-chain-index' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 1127 «Slobodni Kappa i Lambda lanci u 24h urinu» 80 € — пара κ+λ в моче, на обе записи, цена за пару.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 80.00, NULL, '1127' FROM clinics c JOIN lab_tests e ON e.slug = 'free-kappa-light-chains-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 80.00, NULL, '1127' FROM clinics c JOIN lab_tests e ON e.slug = 'free-lambda-light-chains-in-urine' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0259 «Ispitivanje prisustva gljivica u brisu čmara (kultura)» 7 € — мазок из ануса = ректальный
-- (перианальный — кожа вокруг); бактериальная пара 0258 сведена в 1075 (тот же rectal-swab-bacteria, 10 €).
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 7.00, NULL, '0259' FROM clinics c JOIN lab_tests e ON e.slug = 'rectal-swab-fungi' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0357 «helicobacter pylori» 16 € — IgG (0366) и IgA (0190) у клиники отдельными строками;
-- оставшийся ходовой тест H. pylori — антиген в кале.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 16.00, NULL, '0357' FROM clinics c JOIN lab_tests e ON e.slug = 'helicobacter-pylori-antigen-in-feces' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0737 «Bakteriološko ispitivanje brisa apscesa lijeve dojke (kultura-aerobno)» 15 € — мазки в каталоге
-- по локализации; сторона и абсцесс не различаются.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0737' FROM clinics c JOIN lab_tests e ON e.slug = 'breast-swab-bacteria' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0743 «Bakteriološko ispitivanje kiretmana kavuma uterusa (kultura - aerobno)» 15 € — единственная
-- аэробная запись полости матки; 0353 (посев материала кюретажа, 15 €) сведена сюда.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0743' FROM clinics c JOIN lab_tests e ON e.slug = 'uterine-cavity-swab-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 1101 «Alkohol test» 10 € — материал не указан, берётся кровь.
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 10.00, NULL, '1101' FROM clinics c JOIN lab_tests e ON e.slug = 'alcohol-in-blood' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0755 «Bakteriološko ispitivanje aspiracionog katetera-trahealni aspirat (kultura-aerobno)» 15 € —
-- совпадает с FZOCG K03064 «vrh aspiracionog katetera - aerobno».
INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code) SELECT c.id, e.id, 15.00, NULL, '0755' FROM clinics c JOIN lab_tests e ON e.slug = 'aspiration-catheter-tip-culture-aerobic' WHERE c.slug = 'poliklinika-diagnostica-podgorica';

INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'pH krvi', 'sr' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2';
INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language) SELECT id, 'pH крви', 'sr-cyrl' FROM lab_tests WHERE slug = 'acid-base-status-ph-pco2-po2';

-- ═══ 2. Услуги ═══

-- 1046 «Konsultacija» 30 € — без осмотра и дешевле осмотров (35–45 €); у клиники отдельно есть
-- «Konsultantski specijalistički pregled» 45 € (expert-consultation).
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 30.00, NULL, NULL, '1046' FROM clinics c JOIN medical_services e ON e.slug = 'brief-doctor-visit-consultation' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0797 «Internistički pregled» 45 € — рядом «Internistički pregled bez EKG-a» 35 € (0798), значит с ЭКГ.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 45.00, NULL, NULL, '0797' FROM clinics c JOIN medical_services e ON e.slug = 'internist-examination-with-ecg' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0846 «Prvi razgovor sa bračnim parom i prvi pregled i ultrazvuk žene» 50 € — первичный приём пары по фертильности.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0846' FROM clinics c JOIN medical_services e ON e.slug = 'fertility-couple-subspecialist-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0834 «Odstranjivanje kondiloma tečnim azotom u lokalnoj anesteziji» 150 € — единственная запись
-- криоудаления (RF-вариант 0833 стоит на condyloma-radio-wave-removal); у Nova Medic там же 150 €.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 150.00, NULL, NULL, '0834' FROM clinics c JOIN medical_services e ON e.slug = 'condyloma-cryotherapy-removal-with-examination' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0837 «Punkcija pseudociste u maloj karlici» 150 € — гинекологическая пункция кистозного образования малого таза (FZOCG X04051).
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 150.00, NULL, NULL, '0837' FROM clinics c JOIN medical_services e ON e.slug = 'transvaginal-douglas-pouch-puncture-of-cystic-mass' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 1008 «Davanje infuzije u kućnim uslovima» 30 € — одна ставка без зоны, клиника в Подгорице → городской выезд.
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 30.00, NULL, NULL, '1008' FROM clinics c JOIN medical_services e ON e.slug = 'intravenous-therapy-home-visit-city' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0936 «Ljekarsko uvjerenje za posao zaštitara» 50 € — «zaštitar» = охрана с оружием (у ДЗ Подгорица
-- «uz nošenje oružja — zaštitari» 50 €, «bez oružja — portiri» отдельно).
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code) SELECT c.id, e.id, 50.00, NULL, NULL, '0936' FROM clinics c JOIN medical_services e ON e.slug = 'medical-certificate-for-security-personnel' WHERE c.slug = 'poliklinika-diagnostica-podgorica';
-- 0853 «SIS (Ispitivanje prolaznosti jajovoda ultrazvukom)» 150 € — та же УЗ-проверка проходимости
-- труб, что HyFoSy 0959 (260 €), с физраствором вместо пены; запись одна → диапазон 150–260 €.
UPDATE clinic_medical_services cms
JOIN clinics c ON c.id = cms.clinic_id AND c.slug = 'poliklinika-diagnostica-podgorica'
JOIN medical_services e ON e.id = cms.medical_service_id AND e.slug = 'hycosy-tubal-patency-ultrasound'
SET cms.price = 150.00, cms.price_max = 260.00
WHERE cms.price = 260.00 AND cms.price_max IS NULL AND cms.price_min IS NULL AND cms.code = '0959';

-- ═══ 3. Категории каталога (заметки импорта) ═══

-- Ultrasound Lymph Nodes без категорий → ULTRASOUND (4).
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 4 FROM medical_services WHERE slug = 'ultrasound-lymph-nodes';
-- PAI-1 — белок (KCCG Z03026, цитратная плазма), а не генотип: генотипы — отдельные записи
-- pai-1-675-4g-5g и pai-1-locus-844. GENETICS (20) → COAGULATION (2).
INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id) SELECT id, 2 FROM lab_tests WHERE slug = 'pai-1';
DELETE r FROM lab_test_categories_relations r JOIN lab_tests t ON t.id = r.lab_test_id WHERE t.slug = 'pai-1' AND r.category_id = 20;

-- ═══ VERIFICATION ═══
SELECT 'lab' AS t, COUNT(*) AS rows_total FROM clinic_lab_tests WHERE clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica')
UNION ALL SELECT 'ms', COUNT(*) FROM clinic_medical_services WHERE clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica');
-- ожидается: lab 447 (было 434), ms 129 (было 122)
SELECT x.code, e.slug, x.price, x.price_max FROM clinic_lab_tests x JOIN lab_tests e ON e.id = x.lab_test_id
WHERE x.clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica')
  AND x.code IN ('0724', '0601', '1126', '1127', '0259', '0357', '0737', '0743', '1101', '0755')
ORDER BY x.code, e.slug; -- ожидается 13 строк
SELECT x.code, e.slug, x.price, x.price_min, x.price_max FROM clinic_medical_services x JOIN medical_services e ON e.id = x.medical_service_id
WHERE x.clinic_id = (SELECT id FROM clinics WHERE slug = 'poliklinika-diagnostica-podgorica')
  AND x.code IN ('1046', '0797', '0846', '0834', '0837', '1008', '0936', '0959')
ORDER BY x.code; -- ожидается 8 строк, у 0959 — 150.00 / NULL / 260.00
SELECT 'ultrasound-lymph-nodes' AS slug, GROUP_CONCAT(r.medical_service_category_id) AS cats FROM medical_service_categories_relations r JOIN medical_services e ON e.id = r.medical_service_id WHERE e.slug = 'ultrasound-lymph-nodes'
UNION ALL SELECT 'pai-1', GROUP_CONCAT(r.category_id) FROM lab_test_categories_relations r JOIN lab_tests e ON e.id = r.lab_test_id WHERE e.slug = 'pai-1';
-- ожидается: ultrasound-lymph-nodes 4; pai-1 2

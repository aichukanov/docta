SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Poliklinika Natal (Подгорица) — синхронизация цен с сайтом.
--
-- Источник — https://poliklinikanatal.me/cjenovnik/ (архив CPT cjenovnik, в меню
-- не стоит), снят 2026-10-02: data/clinic-pricelists/sources/poliklinika-natal-podgorica/2026-10-02.html.
-- Названия, категории и даты правки — wp-json/wp/v2/cjenovnik (130 записей,
-- 2026-10-02.wp-json-p1.json и -p2.json там же). Цен в API нет, они только в HTML.
-- Дата прайса — modified позиций в wp-json: 2025-12-01 … 2026-04-21.
-- Прайс свежий, is_price_outdated = 0.
-- Сравнение построчно — data/clinic-imports/poliklinika-natal-podgorica-prices-2026-10.md.
--
-- На сайте 130 позиций: 86 услуг поликлиники, 26 PCR-мазков, 18 — педиатрия.
-- В БД 86 услуг + 26 анализов, все с ценами; прод = локальная (сверено через API).
--   меняется цена     10  (все позиции, правленные 2026-03-21 / 2026-04-01, кроме созданной тогда же новой)
--   совпадает         73  услуги + 26 анализов (PCR-мазки уже в clinic_lab_tests, все цены совпали)
--   перепривязка       1  orthopedic-ultrasound-single-joint → musculoskeletal-ultrasound
--   новые строки       6  (на существующие записи каталога: 2 позиции + рентген на 4 записи)
--   is_obsolete        2  (digital-dermoscopy-more-than-5-moles, follow-up-specialist-examination)
--   педиатрия         18  НЕ импортирована: это «Pedijatrija Natal Kids» по другому адресу
--                         (Drugog Crnogorskog bataljona 2H) — отдельной клиникой, следующим шагом
--
-- «Rendgen» 40 € на сайте — снимок одной любой области («pluća, kostiju,
-- ekstremiteta, kičme…», /pod-usluge/rendgen/, снимок 2026-10-05.pod-usluge-rendgen.html).
-- Общую запись «рентген» не заводим (решение 2026-10-05): цену получают записи
-- названных областей — лёгкие (x-ray-chest), позвоночник (три отдела),
-- конечности (extremity-x-ray-per-image); «kosti» отдельно не заводим.
-- «Aplikacija lijeka» 10 € остаётся на intramuscular-injection: общей записи
-- «введение лекарства» в каталоге нет, а в/в, инфузия, внутрисуставная и
-- прогестерон в прайсе Natal отдельными строками.
--
-- Новых записей каталога нет; у extremity-x-ray-per-image добавлены категория
-- X-Ray, радиология и синонимы. Слияние дублей УЗИ мозга младенца — отдельным
-- файлом merge-infant-brain-ultrasound-duplicates.sql (порядок с этим файлом не важен).
--
-- Клиника и записи каталога — по slug (id локально и на проде расходятся).
-- Правки цен — с условием на старую цену: строку, поправленную руками, файл
-- не перезапишет. INSERT IGNORE: повторный прогон безопасен.

-- ═══ 1. Цены ═══

-- «Sistematski ginekološki pregled» (modified 2026-03-21)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'systematic-gynecological-examination-package'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 140.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 130.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 130→140

-- «Ultrazvuk štitaste žlijezde» (modified 2026-03-21)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'thyroid-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 50.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 40→50

-- «Ultrazvuk abdomena» (modified 2026-03-21)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'abdomen-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 50.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 40→50

-- «Dermatološki pregled» (modified 2026-03-21)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'dermatologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 60.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 50→60

-- «Dermoskopija» (modified 2026-04-01)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'dermatoscopy'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 70.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 60→70

-- «Digitalna dermoskopija I FotoFinder ATBM digitalnim dermoskopom» (modified 2026-04-01).
-- Slug записи на сайте — …-do-5-mladeza: это бывшая «до 5 родинок», из названия
-- уточнение убрали, позиция «более 5» с сайта исчезла (см. раздел 3).
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'digital-dermoscopy-up-to-5-moles'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 90.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 80→90

-- «ORL pregled» (modified 2026-03-21)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'first-ent-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 50.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 40→50

-- «Punkcija ciste na dojkama» (modified 2026-03-21)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'breast-cyst-puncture'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 90.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 80→90

-- «Intervenska infuzija u ordinaciji» (modified 2026-03-21; запись на сайте с 2025-12-01)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'infusion-therapy'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 35.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 20→35

-- «Rendgen» (modified 2026-03-21) — снимок одной области, см. шапку
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'x-ray-chest'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.price = 40.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 30→40

-- ═══ 2. Перепривязка ═══

-- «Reumatološki ultrazvuk MSK» 50 € стоял на «Ultrazvuk jednog zgloba»; точная
-- запись — «Mišićno-skeletni ultrazvuk». Строка переезжает вместе с ценой; если
-- на цели строка у клиники уже есть, UPDATE IGNORE её не тронет.
SET @natal = (SELECT id FROM clinics WHERE slug = 'poliklinika-natal-podgorica');
SET @remap_from = (SELECT id FROM medical_services WHERE slug = 'orthopedic-ultrasound-single-joint');
SET @remap_to = (SELECT id FROM medical_services WHERE slug = 'musculoskeletal-ultrasound');
UPDATE IGNORE clinic_medical_service_doctors SET medical_service_id = @remap_to
 WHERE clinic_id = @natal AND medical_service_id = @remap_from AND @remap_to IS NOT NULL;
UPDATE IGNORE clinic_medical_services SET medical_service_id = @remap_to
 WHERE clinic_id = @natal AND medical_service_id = @remap_from AND @remap_to IS NOT NULL;

-- ═══ 3. Новые строки клиники ═══

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 30.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'iv-therapy-service' WHERE c.slug = 'poliklinika-natal-podgorica'; -- «Usluga davanje intravenske terapije» 30 € (запись создана 2026-03-21)
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'follow-up-rheumatologist-examination' WHERE c.slug = 'poliklinika-natal-podgorica'; -- «Kontrolni pregled reumatologa» 40 €

-- «Rendgen» 40 € — «Snimanje željene regije (pluća, kostiju, ekstremiteta, kičme…)».
-- Лёгкие — x-ray-chest (раздел 1). Позвоночник — цена за отдел на каждой из трёх
-- записей, как у Milmedika, A3 и ДЗ (J06002 «за сегмент»). Конечности — запись
-- «Snimanje ekstremiteta za svaki snimak». «Kosti» — общее слово, покрыто
-- конечностями и позвоночником, отдельной строки нет (решение 2026-10-05).
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'x-ray-cervical-spine' WHERE c.slug = 'poliklinika-natal-podgorica'; -- «Rendgen» — kičma
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'x-ray-thoracic-spine' WHERE c.slug = 'poliklinika-natal-podgorica'; -- «Rendgen» — kičma
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'x-ray-lumbar-spine-and-sacrum' WHERE c.slug = 'poliklinika-natal-podgorica'; -- «Rendgen» — kičma
INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max)
SELECT c.id, e.id, 40.00, NULL, NULL FROM clinics c JOIN medical_services e ON e.slug = 'extremity-x-ray-per-image' WHERE c.slug = 'poliklinika-natal-podgorica'; -- «Rendgen» — ekstremiteti

-- extremity-x-ray-per-image стояла только в «Ортопедии» (10/17): в разделе рентгена
-- её не было видно. Добавляем категорию X-Ray (3), радиологию (10) и бытовые названия.
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 3 FROM medical_services WHERE slug = 'extremity-x-ray-per-image';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug = 'extremity-x-ray-per-image';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Rendgen ekstremiteta', 'sr' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'RTG ekstremiteta', 'sr' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'Рендген екстремитета', 'sr-cyrl' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'RTG екстремитета', 'sr-cyrl' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'Рентген конечностей', 'ru' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'Extremity X-Ray', 'en' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'Limb X-Ray', 'en' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'Röntgen der Extremitäten', 'de' FROM medical_services WHERE slug = 'extremity-x-ray-per-image'
UNION ALL SELECT id, 'Ekstremite röntgeni', 'tr' FROM medical_services WHERE slug = 'extremity-x-ray-per-image';

-- ═══ 4. Позиции, которых на сайте нет ═══

-- «Digitalna dermoskopija više od 5 mladeža» — на сайте одна цифровая дермоскопия (см. раздел 1).
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'digital-dermoscopy-more-than-5-moles'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.is_obsolete = 1;

-- «Kontrolni specijalistički pregled» — общего контрольного осмотра на сайте нет;
-- это бывший «Kontrolni pregled reumatologa», он теперь своей строкой (раздел 3).
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-specialist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'poliklinika-natal-podgorica'
   SET r.is_obsolete = 1;

-- ═══ VERIFICATION ═══

-- Ожидается 92 строки: 90 с is_obsolete = 0, все с ценой, is_price_outdated = 0.
SELECT ms.slug, cms.price, cms.price_min, cms.price_max, cms.is_price_outdated, cms.is_obsolete
  FROM clinic_medical_services cms
  JOIN medical_services ms ON ms.id = cms.medical_service_id
  JOIN clinics c ON c.id = cms.clinic_id
 WHERE c.slug = 'poliklinika-natal-podgorica'
 ORDER BY ms.slug;

-- Ожидается: total = 92, priced = 92, obsolete = 2.
SELECT COUNT(*) AS total,
       SUM(cms.price IS NOT NULL OR cms.price_min IS NOT NULL) AS priced,
       SUM(cms.is_obsolete) AS obsolete
  FROM clinic_medical_services cms
  JOIN clinics c ON c.id = cms.clinic_id
 WHERE c.slug = 'poliklinika-natal-podgorica';

-- Ожидается 19 строк: рентген 40 на x-ray-chest, трёх отделах позвоночника и
-- extremity-x-ray-per-image; цены 140, 50, 50, 60, 70, 90, 50, 90, 35; новые 30 и 40;
-- MSK-УЗИ 50 на musculoskeletal-ultrasound, orthopedic-ultrasound-single-joint нет;
-- obsolete = 1 у more-than-5 и follow-up-specialist.
SELECT ms.slug, cms.price, cms.is_obsolete
  FROM clinic_medical_services cms
  JOIN medical_services ms ON ms.id = cms.medical_service_id
  JOIN clinics c ON c.id = cms.clinic_id
 WHERE c.slug = 'poliklinika-natal-podgorica'
   AND ms.slug IN ('systematic-gynecological-examination-package', 'thyroid-ultrasound', 'abdomen-ultrasound',
                   'dermatologist-examination', 'dermatoscopy', 'digital-dermoscopy-up-to-5-moles',
                   'first-ent-examination', 'breast-cyst-puncture', 'infusion-therapy', 'x-ray-chest',
                   'x-ray-cervical-spine', 'x-ray-thoracic-spine', 'x-ray-lumbar-spine-and-sacrum', 'extremity-x-ray-per-image',
                   'iv-therapy-service', 'follow-up-rheumatologist-examination',
                   'digital-dermoscopy-more-than-5-moles', 'follow-up-specialist-examination',
                   'musculoskeletal-ultrasound', 'orthopedic-ultrasound-single-joint')
 ORDER BY ms.slug;

-- Анализы не менялись: ожидается 26 строк, все с ценой.
SELECT COUNT(*) AS total, SUM(clt.price IS NOT NULL) AS priced
  FROM clinic_lab_tests clt
  JOIN clinics c ON c.id = clt.clinic_id
 WHERE c.slug = 'poliklinika-natal-podgorica';

-- extremity-x-ray-per-image: ожидается categories 3,10; specialties 10,17; synonyms 9.
SELECT ms.slug,
       (SELECT GROUP_CONCAT(medical_service_category_id ORDER BY medical_service_category_id) FROM medical_service_categories_relations WHERE medical_service_id = ms.id) AS categories,
       (SELECT GROUP_CONCAT(specialty_id ORDER BY specialty_id) FROM medical_services_specialties WHERE medical_service_id = ms.id) AS specialties,
       (SELECT COUNT(*) FROM medical_service_synonyms WHERE medical_service_id = ms.id) AS synonyms
  FROM medical_services ms
 WHERE ms.slug = 'extremity-x-ray-per-image';

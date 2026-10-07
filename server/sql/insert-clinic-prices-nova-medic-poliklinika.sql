SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Nova Medic Poliklinika (Подгорица) — синхронизация цен с сайтом.
--
-- Источник — https://novamedic.me/cjenovnik/, снят 2026-10-02:
--   data/clinic-pricelists/sources/nova-medic-poliklinika/2026-10-02.html (страница),
--   2026-10-02.json (wp-json pages/2148), 2026-10-02.pages.json (все 41 страница сайта).
-- Дата прайса — modified страницы в wp-json: 2026-09-30T11:17:39. Прайс свежий, is_price_outdated = 0.
-- Прежний прайс — снимок Wayback 2026-05-14 (2026-05-14.wayback.html): с него и был
-- первичный импорт 2026-04-16: цены 61 из 62 снятых позиций в БД совпадают с ним.
-- Сравнение построчно — data/clinic-imports/nova-medic-poliklinika-prices-2026-10.md.
--
-- На сайте 115 цен = 103 позиции + 11 дублей (блок Exilis для тела выведен дважды,
-- «Akcijski paketi» повторяют две позиции по той же цене) + 1 сезонная акция (не заводим).
-- В БД было 162 строки, все с ценой; прод = локальная (сверено через API, id на проде 101).
--   совпадает            97
--   меняется цена         3  (100→150, 250→220, 100→120)
--   новые строки          3  (1 на существующую запись каталога, 2 на новые)
--   is_obsolete          62
--
-- Почему у нас на 59 строк больше. 2026-09-30 клиника перешла на дерматологию и
-- эстетику: из прайса и меню убраны терапия, эндокринология, пульмонология, УЗИ,
-- физиатрия, физиотерапия, ЛФК, массаж, хиджама и ботокс Xeomin, а из «Naš tim» —
-- терапевт, физиатры и физиотерапевты. Ещё одна строка (эпиляция всего лица, жен.) не значится
-- ни в текущем, ни в майском прайсе. Страницы услуг проверены (раздел 3 отчёта).
--
-- Новые записи каталога (2): follow-up-dermatologist-examination-with-dermatoscopy, laser-hair-removal-legs-and-intimate-area-package-6-treatments.
--
-- Клиника и записи каталога — по slug (id локально и на проде расходятся).
-- Правки цен — с условием на старую цену: строку, поправленную руками, файл
-- не перезапишет. INSERT IGNORE / ON DUPLICATE KEY: повторный прогон безопасен.

-- ═══ 1. Новые записи каталога ═══

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Follow-up Dermatologist Examination with Dermatoscopy', 'follow-up-dermatologist-examination-with-dermatoscopy', 'Kontrolni pregled dermatologa sa dermatoskopijom', 'Контролни преглед дерматолога са дерматоскопијом', 'Контрольный осмотр дерматолога с дерматоскопией', 'Dermatologische Kontrolluntersuchung mit Dermatoskopie', 'Dermatoskopili Dermatoloji Kontrol Muayenesi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 24 FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 7 FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy';
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Kontrolni dermoskopski pregled', 'sr' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy'
UNION ALL SELECT id, 'Контролни дермоскопски преглед', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy'
UNION ALL SELECT id, 'Kontrolni pregled dermatologa sa dermoskopijom', 'sr' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy'
UNION ALL SELECT id, 'Контролни преглед дерматолога са дермоскопијом', 'sr-cyrl' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy'
UNION ALL SELECT id, 'Follow-up Dermoscopy', 'en' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy'
UNION ALL SELECT id, 'Повторная дерматоскопия', 'ru' FROM medical_services WHERE slug = 'follow-up-dermatologist-examination-with-dermatoscopy';

INSERT INTO medical_services (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Laser Hair Removal Legs and Intimate Area Package 6 Treatments', 'laser-hair-removal-legs-and-intimate-area-package-6-treatments', 'Laserska epilacija nogu i intimne regije – 6 tretmana', 'Ласерска епилација ногу и интимне регије – 6 третмана', 'Лазерная эпиляция ног и интимной зоны пакет 6 процедур', 'Laser-Haarentfernung Beine und Intimbereich Paket 6 Behandlungen', 'Lazer epilasyon bacaklar ve intim bölge 6 seans paketi')
ON DUPLICATE KEY UPDATE name_en = name_en;
INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id) SELECT id, 24 FROM medical_services WHERE slug = 'laser-hair-removal-legs-and-intimate-area-package-6-treatments';
INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id) SELECT id, 7 FROM medical_services WHERE slug = 'laser-hair-removal-legs-and-intimate-area-package-6-treatments';

-- Формулировка клиники — синонимом к существующей записи.
INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Dermatološki pregled sa biopsijom kože', 'sr' FROM medical_services WHERE slug = 'skin-biopsy-with-histopathology-report'
UNION ALL SELECT id, 'Дерматолошки преглед са биопсијом коже', 'sr-cyrl' FROM medical_services WHERE slug = 'skin-biopsy-with-histopathology-report';

-- ═══ 2. Новые строки клиники ═══

INSERT IGNORE INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT c.id, e.id, v.price, NULL, NULL, NULL
  FROM clinics c
  JOIN (
                  SELECT 'follow-up-dermatologist-examination-with-dermatoscopy' AS slug, 50.00 AS price -- «Kontrolni dermoskopski pregled»
        UNION ALL SELECT 'skin-biopsy-with-histopathology-report' AS slug, 150.00 AS price -- «Dermatološki pregled sa biopsijom kože i analizom uzorka»
        UNION ALL SELECT 'laser-hair-removal-legs-and-intimate-area-package-6-treatments' AS slug, 312.00 AS price -- «Laserska epilacija nogu i intimne regije 6 tretmana»
  ) v
  JOIN medical_services e ON e.slug = v.slug
 WHERE c.slug = 'nova-medic-poliklinika';

-- ═══ 3. Цены ═══

-- Uklanjanje kondiloma tečnim azotom sa pregledom → «Uklanjanje kondiloma tečnim azotom sa pregledom»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'condyloma-cryotherapy-removal-with-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nova-medic-poliklinika'
   SET r.price = 150.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 100.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 100→150

-- Skinbuilder – LOLA → «Skinbuilder – LOLA» (то же на /lola-tretman/: «Redovna cijena 220€»; ниже там же устаревший блок «Redovna cijena 250€ / Vaša cijena 225€»)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'skinbuilder-lola-biorevitalization'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nova-medic-poliklinika'
   SET r.price = 220.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 250.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 250→220

-- Presoterapija 30 min. – paket 10 tretmana → «Presoterapija – aparaturna limfna drenaža 30 min.» (в снимке 2026-05-14 тоже 120 €)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pressotherapy-30-min-package-10-treatments'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nova-medic-poliklinika'
   SET r.price = 120.00, r.price_min = NULL, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 100.00 AND r.price_min IS NULL AND r.price_max IS NULL; -- 100→120

-- ═══ 4. Позиции, которых на сайте больше нет → is_obsolete = 1 ═══

-- Botox Xeomin (5)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nova-medic-poliklinika'
   SET r.is_obsolete = 1
 WHERE e.slug IN (
	'botox-xeomin-1-region',
	'botox-xeomin-2-regions',
	'botox-xeomin-3-regions',
	'axillary-hyperhidrosis-botox-xeomin',
	'palmar-hyperhidrosis-botox-xeomin'
 );

-- Физиатрия, физиотерапия, ЛФК, массаж, хиджама (38)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nova-medic-poliklinika'
   SET r.is_obsolete = 1
 WHERE e.slug IN (
	'first-physiatrist-examination',
	'follow-up-physiatrist-examination',
	'physiatrist-consultation',
	'intramuscular-injection',
	'electrotherapy',
	'laser-therapy',
	'ultrasound-therapy',
	'magnetic-therapy',
	'ultrasound-therapy-with-analgesic',
	'dry-needling',
	'shock-wave-therapy',
	'physical-therapy-silver-package-10-treatments',
	'physical-therapy-gold-package-15-treatments',
	'physical-therapy-platinum-package-20-treatments',
	'shockwave-therapy-package-10-treatments',
	'kinesiotherapy-30-min',
	'kinesiotherapy-45-min',
	'schroth-method-45-min',
	'schroth-method-45-min-second-child',
	'kinesiotherapy-30-min-package-10-treatments',
	'kinesiotherapy-45-min-package-10-treatments',
	'schroth-method-package-10-treatments',
	'schroth-method-second-child-package-10-treatments',
	'visceral-osteopathy',
	'swedish-therapeutic-massage-30-min',
	'swedish-therapeutic-massage-45-min',
	'swedish-therapeutic-massage-60-min',
	'pregnancy-massage-30-min',
	'pregnancy-massage-45-min',
	'sports-massage-30-min',
	'sports-massage-45-min',
	'sports-massage-60-min',
	'manual-lymphatic-drainage-30-min',
	'manual-lymphatic-drainage-40-min',
	'manual-lymphatic-drainage-60-min',
	'dry-cupping-back',
	'wet-cupping-back',
	'cupping-full-body'
 );

-- Терапия, эндокринология, пульмология, УЗИ (18)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nova-medic-poliklinika'
   SET r.is_obsolete = 1
 WHERE e.slug IN (
	'internist-examination',
	'internist-examination-with-ecg',
	'follow-up-internist-examination',
	'ecg',
	'endocrinologist-examination',
	'endocrinologist-examination-with-thyroid-ultrasound',
	'follow-up-endocrinologist-examination',
	'pulmonologist-examination',
	'follow-up-pulmonologist-examination',
	'soft-tissue-ultrasound',
	'thyroid-ultrasound',
	'breast-ultrasound',
	'abdomen-and-kidney-ultrasound',
	'lower-abdomen-ultrasound',
	'orthopedic-ultrasound-single-joint',
	'blood-vessels-doppler',
	'follow-up-ultrasound-examination',
	'multi-segment-ultrasound-examination'
 );

-- Эпиляция всего лица (жен.) (1)
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'nova-medic-poliklinika'
   SET r.is_obsolete = 1
 WHERE e.slug IN (
	'laser-hair-removal-full-face-women'
 );

-- ═══ VERIFICATION ═══

-- Ожидается: total = 165, active = 103, obsolete = 62, priced = 165, outdated = 0.
SELECT COUNT(*) AS total,
       SUM(cms.is_obsolete = 0) AS active,
       SUM(cms.is_obsolete = 1) AS obsolete,
       SUM(cms.price IS NOT NULL OR cms.price_min IS NOT NULL) AS priced,
       SUM(cms.is_price_outdated = 1) AS outdated
  FROM clinic_medical_services cms
  JOIN clinics c ON c.id = cms.clinic_id
 WHERE c.slug = 'nova-medic-poliklinika';

-- Изменённые и новые строки: 6 строк, цены как на сайте.
SELECT ms.slug, cms.price, cms.is_obsolete
  FROM clinic_medical_services cms
  JOIN medical_services ms ON ms.id = cms.medical_service_id
  JOIN clinics c ON c.id = cms.clinic_id
 WHERE c.slug = 'nova-medic-poliklinika'
   AND ms.slug IN ('condyloma-cryotherapy-removal-with-examination', 'skinbuilder-lola-biorevitalization', 'pressotherapy-30-min-package-10-treatments', 'follow-up-dermatologist-examination-with-dermatoscopy', 'skin-biopsy-with-histopathology-report', 'laser-hair-removal-legs-and-intimate-area-package-6-treatments')
 ORDER BY ms.slug;

-- Новые записи каталога: 2 строки, категория 24, специальность 7.
SELECT ms.id, ms.slug,
       (SELECT GROUP_CONCAT(s.specialty_id) FROM medical_services_specialties s WHERE s.medical_service_id = ms.id) AS specialties,
       (SELECT GROUP_CONCAT(r.medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS categories,
       (SELECT COUNT(*) FROM medical_service_synonyms y WHERE y.medical_service_id = ms.id) AS synonyms
  FROM medical_services ms
 WHERE ms.slug IN ('follow-up-dermatologist-examination-with-dermatoscopy', 'laser-hair-removal-legs-and-intimate-area-package-6-treatments');

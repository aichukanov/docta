-- ═══════════════════════════════════════════════════════════════════════════
-- Poliklinika Stojanović Medical (Berane) — услуги и цены
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/insert-clinic-poliklinika-stojanovic-medical-berane-services.sql
--
-- ПРЕРЕКВИЗИТ: server/sql/insert-clinic-poliklinika-stojanovic-medical-berane.sql.
-- Клиника — по google_place_id/slug, услуги — по slug, литеральных id нет.
--
-- Источник цен: https://poliklinikastojanovic.me/cjenovnik-2/ — wp-json modified
-- 2024-10-11T15:35:39 (собрано 2026-10-08). Таблицы ElementsKit разобраны по ячейкам:
-- в сыром HTML каждая цена встречается дважды (десктоп/мобайл), в content.rendered —
-- один раз. Разделы: ULTRAZVUČNA DIJAGNOSTIKA (18 строк), RENDGENSKA DIJAGNOSTIKA
-- (20), CT DIJAGNOSTIKA (21 строка, колонки «Nativno» / «Sa IV kontrastom»),
-- MAGNETNA REZONANCA (24 строки, те же две колонки), MAMOGRAFSKA (1),
-- STOMATOLOŠKA DIJAGNOSTIKA (3).
--
-- Две колонки цен:
--   * CT — в каталоге нативные и контрастные исследования заведены ОТДЕЛЬНЫМИ
--     записями («… without Contrast» / «… with Contrast»), так и сопоставлено.
--     Строка, где заполнена только одна колонка, идёт в соответствующую запись.
--   * MR — контрастных вариантов в каталоге нет (есть только MRI Contrast Agent);
--     как у КЦЦГ, Konzilijum и Bolnica Danilo, «Nativno / Sa IV kontrastom» =
--     price / price_max одной записи. Только контрастная колонка → price.
--     Разница колонок везде 20 € = отдельная строка «Kontrasno sredstvo 20€».
--
-- Позиции без цены: MR-регионы из поста «MR Pregledi magnetnom rezonancom»
-- (2024-08-06), которых нет в прайсе; интернист (страница
-- «Internistička ambulanta»); стоматология — только конкретные услуги, названные
-- на страницах направлений и в посте 2024-08-06, и только где в каталоге есть
-- generic-запись без материала/бренда.
-- Лаборатория НЕ импортируется: /laboratorija ведёт на внешнюю BONA LAB.
-- is_price_outdated не ставится (решение юзера 2026-10-08).
--
-- Самоисправляющийся: канонический список в TEMPORARY TABLE, цены пишутся
-- ON DUPLICATE KEY UPDATE, лишнее от прошлых прогонов удаляется. ⚠️ Услуги,
-- добавленные клинике вручную (админка, кабинет), следующий прогон снесёт.
-- ═══════════════════════════════════════════════════════════════════════════

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

SET @clinic_id = (SELECT id FROM clinics WHERE google_place_id = 'ChIJuSXfN7GTUhMRdCC_32memt0' LIMIT 1);
SET @clinic_id = COALESCE(@clinic_id, (SELECT id FROM clinics WHERE slug = 'poliklinika-stojanovic-medical-berane' LIMIT 1));

SELECT IF(@clinic_id IS NULL,
	'FATAL: клиника не найдена — сначала примените insert-clinic-poliklinika-stojanovic-medical-berane.sql',
	CONCAT('OK: clinic_id = ', @clinic_id)) AS precheck;

-- ═══════════════════════════════════════════════════════════════
-- PART 0: НОВЫЕ УСЛУГИ КАТАЛОГА (13) — идемпотентно по slug
-- Категории: 1 MRI, 2 MSCT, 3 XRAY, 4 ULTRASOUND, 25 PEDIATRICS.
-- Специальности: 10 RADIOLOGY (как у рентгена/УЗИ каталога), 34 VASCULAR_SURGERY
-- (как у остальных допплеров конечностей), 4 PEDIATRICS (авто для категории 25).
-- ═══════════════════════════════════════════════════════════════

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'single-extremity-doppler', 'Single Extremity Doppler', 'Kolor dopler krvnih sudova jednog ekstremiteta', 'Колор доплер крвних судова једног екстремитета',
	'Допплер сосудов одной конечности', 'Doppler der Gefäße einer Extremität', 'Tek ekstremite damar Doppler', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'single-extremity-doppler' OR name_en = 'Single Extremity Doppler');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'x-ray-trachea', 'X-Ray Trachea', 'Rendgen traheje', 'Рендген трахеје',
	'Рентген трахеи', 'Röntgen der Luftröhre', 'Trakea röntgeni', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'x-ray-trachea' OR name_en = 'X-Ray Trachea');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'soft-tissue-x-ray', 'Soft Tissue X-Ray', 'Rendgen mekih tkiva', 'Рендген меких ткива',
	'Рентгенография мягких тканей', 'Röntgen der Weichteile', 'Yumuşak doku röntgeni', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'soft-tissue-x-ray' OR name_en = 'Soft Tissue X-Ray');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'barium-swallow-esophagography', 'Barium Swallow (Esophagography)', 'Rendgenski pregled akta gutanja i jednjaka', 'Рендгенски преглед акта гутања и једњака',
	'Рентгеноскопия акта глотания и пищевода', 'Breischluck (Ösophagographie)', 'Baryumlu yutma grafisi (özofagografi)', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'barium-swallow-esophagography' OR name_en = 'Barium Swallow (Esophagography)');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'proctography', 'Proctography', 'Proktografija', 'Проктографија',
	'Проктография', 'Proktographie', 'Proktografi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'proctography' OR name_en = 'Proctography');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pediatric-msct-abdomen-and-pelvis-without-contrast', 'Pediatric MSCT Abdomen and Pelvis without Contrast', 'MSCT abdomena i male karlice kod djece bez kontrasta', 'МСКТ абдомена и мале карлице код дјеце без контраста',
	'МСКТ брюшной полости и малого таза у детей без контраста', 'MSCT Abdomen und Becken bei Kindern ohne Kontrastmittel', 'Çocuklarda kontrastsız abdomen ve pelvis MSCT', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pediatric-msct-abdomen-and-pelvis-without-contrast' OR name_en = 'Pediatric MSCT Abdomen and Pelvis without Contrast');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'pediatric-msct-abdomen-and-pelvis-with-contrast', 'Pediatric MSCT Abdomen and Pelvis with Contrast', 'MSCT abdomena i male karlice kod djece sa kontrastom', 'МСКТ абдомена и мале карлице код дјеце са контрастом',
	'МСКТ брюшной полости и малого таза у детей с контрастом', 'MSCT Abdomen und Becken bei Kindern mit Kontrastmittel', 'Çocuklarda kontrastlı abdomen ve pelvis MSCT', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'pediatric-msct-abdomen-and-pelvis-with-contrast' OR name_en = 'Pediatric MSCT Abdomen and Pelvis with Contrast');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'msct-soft-tissue-neck-without-contrast', 'MSCT Soft Tissue Neck without Contrast', 'MSCT pregled mekih tkiva vrata bez kontrasta', 'МСКТ преглед меких ткива врата без контраста',
	'МСКТ мягких тканей шеи без контраста', 'MSCT Weichteile Hals ohne Kontrastmittel', 'MSCT Boyun Yumuşak Doku Kontrastsız', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'msct-soft-tissue-neck-without-contrast' OR name_en = 'MSCT Soft Tissue Neck without Contrast');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'msct-soft-tissues-without-contrast', 'MSCT Soft Tissues without Contrast', 'MSCT mekih tkiva bez kontrasta', 'МСКТ меких ткива без контраста',
	'МСКТ мягких тканей без контраста', 'MSCT der Weichteile ohne Kontrastmittel', 'Kontrastsız yumuşak doku MSCT', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'msct-soft-tissues-without-contrast' OR name_en = 'MSCT Soft Tissues without Contrast');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'msct-soft-tissues-with-contrast', 'MSCT Soft Tissues with Contrast', 'MSCT mekih tkiva sa kontrastom', 'МСКТ меких ткива са контрастом',
	'МСКТ мягких тканей с контрастом', 'MSCT der Weichteile mit Kontrastmittel', 'Kontrastlı yumuşak doku MSCT', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'msct-soft-tissues-with-contrast' OR name_en = 'MSCT Soft Tissues with Contrast');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'mri-head-and-neck', 'MRI Head and Neck', 'MR glave i vrata', 'МР главе и врата',
	'МРТ головы и шеи', 'MRT Kopf und Hals', 'Baş ve Boyun MR', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'mri-head-and-neck' OR name_en = 'MRI Head and Neck');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'mri-elbow-joint', 'MRI Elbow Joint', 'MR pregled lakatnog zgloba', 'МР преглед лакатног зглоба',
	'МРТ локтевого сустава', 'MRT Ellenbogengelenk', 'Dirsek Eklemi MR', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'mri-elbow-joint' OR name_en = 'MRI Elbow Joint');

INSERT INTO medical_services (slug, name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr, sort_order)
SELECT 'mri-angiography-with-contrast', 'MRI Angiography with Contrast', 'Kontrastna MR angiografija', 'Контрастна МР ангиографија',
	'МР-ангиография с контрастом', 'Kontrastmittelgestützte MR-Angiographie', 'Kontrastlı MR Anjiyografi', NULL
FROM dual WHERE NOT EXISTS (SELECT 1 FROM medical_services WHERE slug = 'mri-angiography-with-contrast' OR name_en = 'MRI Angiography with Contrast');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 1 FROM medical_services WHERE slug IN ('mri-head-and-neck', 'mri-elbow-joint', 'mri-angiography-with-contrast',
	-- существующие MR-записи без категории, которые использует эта клиника
	'mri-full-spine', 'mri-urography');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 2 FROM medical_services WHERE slug IN ('pediatric-msct-abdomen-and-pelvis-without-contrast', 'pediatric-msct-abdomen-and-pelvis-with-contrast',
	'msct-soft-tissue-neck-without-contrast', 'msct-soft-tissues-without-contrast', 'msct-soft-tissues-with-contrast');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 3 FROM medical_services WHERE slug IN ('x-ray-trachea', 'soft-tissue-x-ray', 'barium-swallow-esophagography', 'proctography');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('single-extremity-doppler');

INSERT IGNORE INTO medical_service_categories_relations (medical_service_id, medical_service_category_id)
SELECT id, 25 FROM medical_services WHERE slug IN ('pediatric-msct-abdomen-and-pelvis-without-contrast', 'pediatric-msct-abdomen-and-pelvis-with-contrast');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 10 FROM medical_services WHERE slug IN ('single-extremity-doppler', 'x-ray-trachea', 'soft-tissue-x-ray',
	'barium-swallow-esophagography', 'proctography', 'pediatric-msct-abdomen-and-pelvis-without-contrast', 'pediatric-msct-abdomen-and-pelvis-with-contrast',
	'msct-soft-tissue-neck-without-contrast', 'msct-soft-tissues-without-contrast', 'msct-soft-tissues-with-contrast',
	'mri-head-and-neck', 'mri-elbow-joint', 'mri-angiography-with-contrast');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 34 FROM medical_services WHERE slug IN ('single-extremity-doppler');

INSERT IGNORE INTO medical_services_specialties (medical_service_id, specialty_id)
SELECT id, 4 FROM medical_services WHERE slug IN ('pediatric-msct-abdomen-and-pelvis-without-contrast', 'pediatric-msct-abdomen-and-pelvis-with-contrast');

INSERT IGNORE INTO medical_service_synonyms (medical_service_id, another_name, language)
SELECT id, 'Color duplex scan 1 ekstremiteta', 'sr' FROM medical_services WHERE slug = 'single-extremity-doppler'
UNION ALL SELECT id, 'Колор дуплекс скен једног екстремитета', 'sr-cyrl' FROM medical_services WHERE slug = 'single-extremity-doppler'
UNION ALL SELECT id, 'Color Duplex Scan of One Limb', 'en' FROM medical_services WHERE slug = 'single-extremity-doppler'
UNION ALL SELECT id, 'УЗДС сосудов одной конечности', 'ru' FROM medical_services WHERE slug = 'single-extremity-doppler'
UNION ALL SELECT id, 'Rendgen dušnika', 'sr' FROM medical_services WHERE slug = 'x-ray-trachea'
UNION ALL SELECT id, 'Рендген душника', 'sr-cyrl' FROM medical_services WHERE slug = 'x-ray-trachea'
UNION ALL SELECT id, 'Ezofagografija', 'sr' FROM medical_services WHERE slug = 'barium-swallow-esophagography'
UNION ALL SELECT id, 'Езофагографија', 'sr-cyrl' FROM medical_services WHERE slug = 'barium-swallow-esophagography'
UNION ALL SELECT id, 'Esophagram', 'en' FROM medical_services WHERE slug = 'barium-swallow-esophagography'
UNION ALL SELECT id, 'Эзофагография', 'ru' FROM medical_services WHERE slug = 'barium-swallow-esophagography'
UNION ALL SELECT id, 'Рентген пищевода с барием', 'ru' FROM medical_services WHERE slug = 'barium-swallow-esophagography'
UNION ALL SELECT id, 'MR angiografija sa kontrastom', 'sr' FROM medical_services WHERE slug = 'mri-angiography-with-contrast'
UNION ALL SELECT id, 'МР ангиографија са контрастом', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-angiography-with-contrast'
UNION ALL SELECT id, 'CE-MRA', 'en' FROM medical_services WHERE slug = 'mri-angiography-with-contrast'
UNION ALL SELECT id, 'МР-ангиография с контрастированием', 'ru' FROM medical_services WHERE slug = 'mri-angiography-with-contrast'
UNION ALL SELECT id, 'МРТ локтя', 'ru' FROM medical_services WHERE slug = 'mri-elbow-joint'
UNION ALL SELECT id, 'MR lakta', 'sr' FROM medical_services WHERE slug = 'mri-elbow-joint'
UNION ALL SELECT id, 'МР лакта', 'sr-cyrl' FROM medical_services WHERE slug = 'mri-elbow-joint';

-- ═══════════════════════════════════════════════════════════════
-- PART 1: КАНОНИЧЕСКИЙ СПИСОК УСЛУГ КЛИНИКИ
-- ═══════════════════════════════════════════════════════════════

DROP TEMPORARY TABLE IF EXISTS tmp_stojanovic_services;
CREATE TEMPORARY TABLE tmp_stojanovic_services (
	slug VARCHAR(280) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY,
	price DECIMAL(10,2) NULL,
	price_min DECIMAL(10,2) NULL,
	price_max DECIMAL(10,2) NULL
) ENGINE = MEMORY DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

INSERT INTO tmp_stojanovic_services (slug, price, price_min, price_max) VALUES
-- ── ULTRAZVUČNA DIJAGNOSTIKA ──────────────────────────────────────────────
('ultrasound-thyroid-and-parathyroid-glands', 40.00, NULL, NULL), -- Ultrazvučna dijagnostika štitne i paraštitaste žlijezde 40€
('neck-ultrasound', 40.00, NULL, NULL), -- Ultrazvučna dijagnostika vrata 40€
('abdomen-and-urinary-tract-ultrasound', 40.00, NULL, NULL), -- Ultrazvučna dijagnostika organa gornjeg abdomena i urinarnog trakta 40€
('lower-abdomen-ultrasound', 30.00, NULL, NULL), -- Ultrazvučni pregled organa male karlice 30€
('testicular-ultrasound', 40.00, NULL, NULL), -- Ultrazvučna dijagnostika skrotuma (penisa, uretera) 40€
('breast-ultrasound-with-axilla', 40.00, NULL, NULL), -- Ultrazvučna dijagnostika dojke i aksilla 40€
('hip-ultrasound', 25.00, NULL, NULL), -- Ultrazvučna dijagnostika kukova 25€
('orthopedic-ultrasound-single-joint', 30.00, NULL, NULL), -- Ultrazvučna dijagnostika ramenog, kolenog i talokruralnog zgloba 30€
('soft-tissue-ultrasound', 25.00, NULL, 30.00), -- Ultrazvučna dijagnostika površnih tumora 25€; Ultrazvučni pregled kože i potkožnog tkiva 30€ (обе строки — УЗИ мягких тканей, одна запись диапазоном)
('doppler-neck-blood-vessels', 40.00, NULL, NULL), -- Color duplex scan krvnih sudova vrata 40€
('doppler-upper-extremity-blood-vessels', 50.00, NULL, NULL), -- Color duplex scan krvnih sudova gornjih ekstremiteta 50€
('doppler-lower-extremity-blood-vessels', 50.00, NULL, NULL), -- Color duplex scan krvnih sudova donjih ekstremiteta 50€
('aorta-ultrasound', 35.00, NULL, NULL), -- Color duplex scan velikih krvnih sudova( Abdominalna aorta i VCI- or) 35€
('doppler-renal-arteries', 35.00, NULL, NULL), -- Color duplex scan arterije aa. renales 35€
('lung-base-ultrasound', 30.00, NULL, NULL), -- UZ pregled plućnih baza 30€
('follow-up-ultrasound-examination', 35.00, NULL, NULL), -- Kontrola 35€
('single-extremity-doppler', 30.00, NULL, NULL), -- Color duplex scan 1 ekstremiteta 30€ (новая запись)
-- ── RENDGENSKA DIJAGNOSTIKA ───────────────────────────────────────────────
-- «Rendgenska dijagnostika koštano-zglobnog sistema:» — подзаголовок без цены
('x-ray-head-craniogram', 40.00, NULL, NULL), -- Lobanja 40€
('x-ray-sella-turcica', 40.00, NULL, NULL), -- Sella turcica 40€
('x-ray-paranasal-sinuses', 40.00, NULL, NULL), -- P.N.Š.-e 40€
('x-ray-cervical-spine', 40.00, NULL, NULL), -- C-e kičme 40€
('x-ray-thoracic-spine', 40.00, NULL, NULL), -- Th-e kičme 40€
-- «Rendgenska dijagnostika koštanog sistema gornjih ekstremiteta sa zglobovima 40€» —
-- одна цена на любой отдел руки; разложена на односторонние позиции каталога.
('x-ray-shoulder', 40.00, NULL, NULL),
('x-ray-upper-arm', 40.00, NULL, NULL),
('x-ray-elbow', 40.00, NULL, NULL),
('x-ray-forearm', 40.00, NULL, NULL),
('x-ray-wrist', 40.00, NULL, NULL),
('x-ray-hand', 40.00, NULL, NULL),
-- «Rendgenska dijagnostika koštanog sistema donjih ekstremiteta sa zglobovima 40€» — так же.
('x-ray-hip', 40.00, NULL, NULL),
('x-ray-thigh', 40.00, NULL, NULL),
('x-ray-knee', 40.00, NULL, NULL),
('x-ray-lower-leg', 40.00, NULL, NULL),
('x-ray-ankle', 40.00, NULL, NULL),
('x-ray-foot', 40.00, NULL, NULL),
('x-ray-pelvis', 40.00, NULL, NULL), -- Rendgenska dijagnostika karlice sa K.F-im zglobovima 40€
('x-ray-trachea', 35.00, NULL, NULL), -- Rendgenska dijagnostika traheje 35€ (новая запись)
('x-ray-chest-heart', 40.00, NULL, NULL), -- Rendgenska dijagnostika pluća i srca 40€
('intravenous-urography', 45.00, NULL, NULL), -- Rendgenska dijagnostika bubrega (IVU i infuziona urografija) 45€
('x-ray-abdomen-native', 35.00, NULL, NULL), -- Rendgenska dijagnostika abdomena(nativna radiografija) 35€
-- «Rendgenska kontrastna dijagnostika gastrointestinalnog trakta:» — подзаголовок
('barium-swallow-esophagography', 50.00, NULL, NULL), -- -rendgenski pregled akta gutanja i jednjaka 50€ (новая запись)
('esophagus-stomach-and-duodenum-fluoroscopy', 60.00, NULL, NULL), -- -radioskopija gastroduodenuma 60€
('small-bowel-standard-fluoroscopic-passage', 50.00, NULL, NULL), -- -pasaža tankog crijevastroduodenuma 50€ (склейка «crijeva»+«stroduodenuma» в источнике)
('barium-enema', 65.00, NULL, NULL), -- -irigografija 65€
('proctography', 80.00, NULL, NULL), -- -proktografija 80€ (новая запись)
('soft-tissue-x-ray', 40.00, NULL, NULL), -- Rendgenska dijagnostika mekih tkiva gornjih i donjih estremiteta i grudnog koša 40€ (новая запись)
-- ── MAMOGRAFSKA DIJAGNOSTIKA ──────────────────────────────────────────────
('mammography', 40.00, NULL, NULL), -- Rendgenska dijagnostika dojki i axilla (MAMOGRAFIJA) 40€
-- ── STOMATOLOŠKA DIJAGNOSTIKA ─────────────────────────────────────────────
('panoramic-x-ray', 20.00, NULL, NULL), -- 2D Ortopan 20€
('3d-dental-x-ray-cbct', 50.00, NULL, NULL), -- 3D Ortopan 50€
('intraoral-x-ray', 5.00, NULL, NULL), -- Dental 5€
-- ── CT DIJAGNOSTIKA (Nativno | Sa IV kontrastom) ──────────────────────────
('msct-abdomen-native', 80.00, NULL, NULL), -- MSCT gornjeg abdomena i urinarnog trakta 80€ | —
('msct-abdomen-with-contrast', 100.00, NULL, NULL), -- MSCT gornjeg abdomena i urinarnog trakta — | 100€
('msct-ivu-intravenous-urography', 100.00, NULL, NULL), -- MSCT urografija — | 100€
('msct-pelvis-native', 80.00, NULL, NULL), -- MSCT dijagnstika organa male karlice 80€ | —
('msct-pelvis-with-contrast', 100.00, NULL, NULL), -- MSCT dijagnstika organa male karlice — | 100€
('pediatric-msct-abdomen-and-pelvis-without-contrast', 70.00, NULL, NULL), -- MSCT dijagnostika abdomena i karlice u pedijatrijskoj populaciji 70€ | — (новая запись)
('pediatric-msct-abdomen-and-pelvis-with-contrast', 90.00, NULL, NULL), -- то же — | 90€ (новая запись)
('msct-angiography-abdominal-vessels', 140.00, NULL, NULL), -- MSCT arteriografija abdomena i male karlice — | 140€
('msct-angiography-abdominal-aorta-and-lower-extremities', 140.00, NULL, NULL), -- MSCT angiografija aortoilijačnog segmenta i arterija donjih ekstremiteta — | 140€
('msct-angiography-pulmonary-arteries-pte', 120.00, NULL, NULL), -- MSCT pneumoangiografija — | 120€
('msct-angiography-extremities', 140.00, NULL, NULL), -- MSCT arteriografija arterija gornjih ekstremiteta — | 140€
('msct-angiography-head-and-neck-vessels', 120.00, NULL, NULL), -- MSCT arteriografija vrata i endokranijuma — | 120€
('msct-head-endocranium-without-contrast', 80.00, NULL, NULL), -- MSCT endokranijuma 80€ | —
('msct-head-endocranium-with-contrast', 100.00, NULL, NULL), -- MSCT endokranijuma — | 100€
('msct-soft-tissue-neck-without-contrast', 80.00, NULL, NULL), -- MSCT vrata 80€ | — (новая запись)
('msct-soft-tissue-neck-with-contrast', 100.00, NULL, NULL), -- MSCT vrata — | 100€
('msct-thorax-chest-without-contrast', 80.00, NULL, NULL), -- MSCT pregled grudnog koša 80€ | —
('msct-thorax-chest-with-contrast', 100.00, NULL, NULL), -- MSCT pregled grudnog koša — | 100€
('msct-neck-and-chest-with-contrast', 180.00, NULL, NULL), -- MSCT pregled vrata i grudnog koša — | 180€
('msct-chest-and-abdomen-with-contrast', 180.00, NULL, NULL), -- MSCT pregled grudnog koša i abdomena — | 180€
-- «MSCT pregled koštano-zglobnog sistema:» — подзаголовок, далее только «Nativno»
('msct-cervical-spine', 80.00, NULL, NULL), -- -C-e kičme 80€
('msct-thoracic-spine', 80.00, NULL, NULL), -- -Th-e kičme 80€
('msct-lumbosacral-spine', 80.00, NULL, NULL), -- -L/S kičme 80€
('msct-upper-extremities-arm', 80.00, NULL, NULL), -- -koštanih struktura gornjih i donjih ekstremiteta 80€
('msct-lower-extremities-leg', 80.00, NULL, NULL), -- -koštanih struktura gornjih i donjih ekstremiteta 80€
('msct-pelvis-with-hips', 80.00, NULL, NULL), -- MSCT karlice sa K.F-im zglobovima 80€
('msct-soft-tissues-without-contrast', 70.00, NULL, NULL), -- MSCT dijagnostika mekih tkiva gornjih i donjih ekstremiteta, grudnog koša i abdomena. 70€ | — (новая запись)
('msct-soft-tissues-with-contrast', 90.00, NULL, NULL), -- то же — | 90€ (новая запись)
-- ── MAGNETNA REZONANCA (Nativno → price | Sa IV kontrastom → price_max) ──
('mri-brain', 110.00, NULL, 130.00), -- MRI endokranijuma 110€ | 130€
('mri-angiography-brain-and-neck-vessels', 180.00, NULL, NULL), -- MRI angiografija endokranijuma i vrata — | 180€
('mri-pituitary-gland-sella-turcica', 150.00, NULL, NULL), -- MRI hipofize — | 150€
('mri-soft-tissue-neck', 110.00, NULL, 130.00), -- MRI vrata 110€ | 130€
('mri-head-and-neck', 210.00, NULL, 230.00), -- MRI glave i vrata 210€ | 230€ (новая запись)
-- «MRI kičmenog stuba:» — подзаголовок
('mri-cervical-spine', 110.00, NULL, NULL), -- -C-e kičme 110€
('mri-thoracic-spine', 110.00, NULL, NULL), -- -Th-e kičme 110€
('mri-lumbosacral-spine', 110.00, NULL, NULL), -- -L/S kičme 110€
('mri-full-spine', 270.00, NULL, NULL), -- MRI C-e, Th-e i L/S 270€
-- «MRI muskuloskeletnog sistema i zglobova» — подзаголовок
('mri-musculoskeletal-system', 120.00, NULL, NULL), -- - kostiju i mekih tkiva 120€
('mri-shoulder', 120.00, NULL, NULL), -- - ramenog zgloba 120€
('mri-elbow-joint', 120.00, NULL, NULL), -- - lakatnog zgloba 120€ (новая запись)
('mri-wrist-joint-not-including-hand', 120.00, NULL, NULL), -- - ručnog zgloba 120€
('mri-hip-joints-in-pelvis', 120.00, NULL, NULL), -- - karlice sa K.F-im zglobovima 120€
('mri-knee-joint', 120.00, NULL, NULL), -- - kolenog zgloba 120€
('mri-ankle-joint-not-including-foot', 120.00, NULL, NULL), -- - skočnog zgloba 120€
('mri-temporomandibular-joints', 120.00, NULL, NULL), -- - temporomandibularnog zgloba 120€
('mri-thorax-and-mediastinum', 120.00, NULL, 140.00), -- MRI grudnog koša 120€ | 140€
('mri-abdomen', 120.00, NULL, 140.00), -- MRI abdomena 120€ | 140€
('mri-urography', 140.00, NULL, NULL), -- MRI urinarnog trakta — | 140€
('mri-prostate-multiparametric', 160.00, NULL, NULL), -- MRI prostate — | 160€ (контрастный протокол = мультипараметрическая МРТ)
('mri-pelvic-organs', 120.00, NULL, 140.00), -- MRI muške i ženske karlice 120€ | 140€
('mri-angiography-with-contrast', 150.00, NULL, NULL), -- Kontrastna MR angiografija — | 150€ (новая запись)
('mri-contrast-agent', 20.00, NULL, NULL), -- Kontrasno sredstvo — | 20€ (опечатка «Kontrasno» в источнике)
-- MR без цены — пост «MR Pregledi magnetnom rezonancom» (2024-08-06), «Pregledi magnetnom:
-- … dojke … šake … stopala … tanko crijevo … MRCP»; пост «Snimak sinusa magnetnom rezonancom».
('mri-breast', NULL, NULL, NULL), -- dojke
('mri-hand-not-including-wrist', NULL, NULL, NULL), -- šake
('mri-foot-not-including-ankle', NULL, NULL, NULL), -- stopala
('mri-enterography', NULL, NULL, NULL), -- tanko crijevo
('mri-cholangiography-mrcp', NULL, NULL, NULL), -- MRCP
('mri-paranasal-sinuses', NULL, NULL, NULL), -- «MR paranazalnih šupljina»
-- ── INTERNISTIČKA AMBULANTA (без цены) ────────────────────────────────────
('internist-examination', NULL, NULL, NULL), -- «našim pacijentima je omogućen pregled interniste»
-- ── STOMATOLOGIJA (без цены) ──────────────────────────────────────────────
('plaque-and-calculus-removal', NULL, NULL, NULL), -- /preventiva «SKIDANJE KAMENCA»
('topical-fluoride-treatment', NULL, NULL, NULL), -- /preventiva «fluorisanje zuba»
('surgical-tooth-extraction', NULL, NULL, NULL), -- /oralna-hirurgija «hiruško vađenje zuba ili zubnih korjenova»
('dental-implant-placement', NULL, NULL, NULL), -- /protetika «Ugradnja implantata radi se pod lokalnom anestezijom»
('fixed-orthodontic-braces-per-arch', NULL, NULL, NULL); -- пост 2024-08-06 «ortodoncija (fiksne proteze)»

-- Страховка: slug, не найденные в каталоге. Ожидается ПУСТО.
SELECT t.slug AS unmatched_service
FROM tmp_stojanovic_services t
LEFT JOIN medical_services ms ON ms.slug = t.slug
WHERE ms.id IS NULL;

INSERT INTO clinic_medical_services (clinic_id, medical_service_id, price, price_min, price_max, code)
SELECT @clinic_id, ms.id, t.price, t.price_min, t.price_max, NULL
FROM tmp_stojanovic_services t
JOIN medical_services ms ON ms.slug = t.slug
ON DUPLICATE KEY UPDATE price = VALUES(price), price_min = VALUES(price_min), price_max = VALUES(price_max);

DELETE cms FROM clinic_medical_services cms
JOIN medical_services ms ON ms.id = cms.medical_service_id
LEFT JOIN tmp_stojanovic_services t ON t.slug = ms.slug
WHERE cms.clinic_id = @clinic_id AND t.slug IS NULL;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- Ожидается 113 услуг, с ценой 101 (12 без цены: 6 MR из поста, интернист, 5 стоматология).
SELECT COUNT(*) AS services_total, SUM(price IS NOT NULL OR price_min IS NOT NULL) AS with_price
FROM clinic_medical_services WHERE clinic_id = @clinic_id;

-- Ожидается 13 новых записей каталога, у каждой категория и специальность;
-- плюс mri-full-spine и mri-urography теперь с категорией 1.
SELECT ms.id, ms.slug, ms.name_sr_cyrl,
	(SELECT GROUP_CONCAT(medical_service_category_id) FROM medical_service_categories_relations r WHERE r.medical_service_id = ms.id) AS cats,
	(SELECT GROUP_CONCAT(specialty_id) FROM medical_services_specialties sp WHERE sp.medical_service_id = ms.id) AS specs
FROM medical_services ms WHERE ms.slug IN ('single-extremity-doppler', 'x-ray-trachea', 'soft-tissue-x-ray',
	'barium-swallow-esophagography', 'proctography', 'pediatric-msct-abdomen-and-pelvis-without-contrast', 'pediatric-msct-abdomen-and-pelvis-with-contrast',
	'msct-soft-tissue-neck-without-contrast', 'msct-soft-tissues-without-contrast', 'msct-soft-tissues-with-contrast',
	'mri-head-and-neck', 'mri-elbow-joint', 'mri-angiography-with-contrast', 'mri-full-spine', 'mri-urography');

DROP TEMPORARY TABLE IF EXISTS tmp_stojanovic_services;

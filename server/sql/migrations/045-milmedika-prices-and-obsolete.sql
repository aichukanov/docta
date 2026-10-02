SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 045: Milmedika — цены с сайта + пометка позиций, которых в прайсе больше нет.
--
-- КОД ПОСЛЕ МИГРАЦИИ. Публичные запросы читают новую колонку is_obsolete —
-- выкатывать код до этой миграции нельзя, запросы упадут.
--
-- 1. is_obsolete в clinic_medical_services и clinic_lab_tests. Позиция, которой
--    клиника больше не публикует: в поиске, листингах, счётчиках, ранжировании
--    и sitemap её нет; по прямой ссылке на услугу/анализ клиника видна в конце
--    списка с пометкой «возможно, больше не оказывает». Предикат —
--    server/common/price-row-visibility.ts.
--
-- 2. Цены Milmedika (577 строк) с milmedika.com/cjenovnik/<филиал> на
--    2026-10-02 (Тиват = milmedika-porto-montenegro). Сопоставление «название
--    сайта ↔ запись каталога» проверено построчно, список —
--    data/clinic-imports/milmedika-prices-2026-10.md. Каждая правка с условием
--    на старую цену: строку, которую успели поправить руками, не перезапишет.
--
-- 3. Позиции, которых на сайте нет (18 строк) → is_obsolete = 1.
--    HIV Ag-Ab — комбинированный тест, на сайте только антитела: другой тест.
--    Не тронуты по решению юзера (непонятно, чему соответствуют): RTG grudnog
--    koša, Kontrolni specijalistički pregled 3, PAPA test sa uzimanjem brisa.
--
-- Клиники и записи каталога — по slug (id локально и на проде расходятся).

-- ═══ 1. Колонка is_obsolete ═══

SET @ddl = IF(
	(SELECT COUNT(*) FROM information_schema.COLUMNS
	  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'clinic_medical_services' AND COLUMN_NAME = 'is_obsolete') = 0,
	'ALTER TABLE clinic_medical_services ADD COLUMN is_obsolete TINYINT(1) NOT NULL DEFAULT 0 AFTER is_price_outdated',
	'DO 0');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @ddl = IF(
	(SELECT COUNT(*) FROM information_schema.COLUMNS
	  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'clinic_lab_tests' AND COLUMN_NAME = 'is_obsolete') = 0,
	'ALTER TABLE clinic_lab_tests ADD COLUMN is_obsolete TINYINT(1) NOT NULL DEFAULT 0 AFTER is_price_outdated',
	'DO 0');
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ═══ 2. Цены ═══

-- 17-hidroksprogesteron → «17-OH progesteron»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = '17-hydroxyprogesterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = '17-hydroxyprogesterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→22
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = '17-hydroxyprogesterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- 5-HIAA u 24h urinu → «5-HIAA u 24-časovnom urinu (test za karcinoidni tumor)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = '5-hiaa-in-24h-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Nikšić: 25→30

-- Kisela fosfataza → «Kisela fosfataza»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'acid-phosphatase'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6

-- Adrenokortikotropni hormon → «ACTH – adrenokortikotropni hormon (EDTA plazma)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'acth'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Podgorica: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'acth'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'acth'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Budva: 20→24

-- Aktivirano parcijalno tromboplastinsko vreme → «aPTT (aktivirano parcijalno tromboplastinsko vrijeme)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'activated-partial-thromboplastin-time'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Adenovirus IgG → «ADV IgG (adenovirus IgG)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'adenovirus-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- ADV IgG + IgM → «ADV IgG, ADV IgM (adenovirus IgG i IgM)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'adenovirus-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Adenovirus IgM → «ADV IgM (adenovirus IgM)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'adenovirus-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Adenovirus respiratorni test (bris nosa) → «Adenovirus respiratorni test (bris nosa)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'adenovirus-respiratory-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Adenovirus Rotavirus u stolici → «Adeno + Rotavirus test (feces) (brza detekcija virusnih uzročnika dijareje)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'adenovirus-rotavirus-in-stool'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Alfa fetoprotein → «AFP (alfa-fetoprotein)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'afp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Albumin → «Albumini»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'albumin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Podgorica: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'albumin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'albumin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Budva: 2→3

-- ACR analiza (odnos albumin/kreatinin) → «ACR analiza (odnos albumin / kreatinin)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'albumin-creatinine-ratio'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Alkalna fosfataza → «ALP (alkalna fosfataza)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'alkaline-phosphatase'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'alkaline-phosphatase'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Alanin aminotransferaza → «ALT»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'alt'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Amilaza → «Alfa-amilaza»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'amylase'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 5.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→5
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'amylase'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'amylase'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 5.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→5

-- ANA antinuklearna antitela → «s-ANA (antinuklearna antitijela)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ana-antinuclear-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Androstendion → «Androstendion»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'androstenedione'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Anti-CCP antitela → «Anti-CCP IgG (antitijela na ciklični citrulinski peptid)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-ccp-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-ccp-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Anti-HCV → «Anti HCV (antitijela na hepatitis C virus)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-hcv'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-hcv'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-hcv'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 20.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→20

-- Anti-Milerov hormon → «AMH (anti-Milerov hormon)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-mullerian-hormone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 35.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Podgorica: 30→35
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-mullerian-hormone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-mullerian-hormone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 35.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Budva: 30→35

-- Anti-SARS-CoV → «ACOV 2 (antitijela na SARS-CoV-2)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-sars-cov'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 17.00 AND r.price_max IS NULL; -- Podgorica: 17→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-sars-cov'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-sars-cov'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 17.00 AND r.price_max IS NULL; -- Budva: 17→24

-- Antitela na tireoglobulin → «TgAt (antitijela na tireoglobulin)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-thyroglobulin-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Podgorica: 10→12
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-thyroglobulin-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-thyroglobulin-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Budva: 10→12

-- Antitela na tireopeoksidazu → «Anti-TPO (antitijela na tireoidnu peroksidazu)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-tpo'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Podgorica: 10→12
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-tpo'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-tpo'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Budva: 10→12

-- Antitela na TSH receptor → «A-TSHR (antitijela na TSH receptor)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-tshr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Podgorica: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-tshr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'anti-tshr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Budva: 20→24

-- Antitrombin III → «Antitrombin III (test na poremećaje koagulacije, citratna plazma)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'antithrombin-iii'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Aspartat aminotransferaza → «AST»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ast'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- ASTO antistreptolizin O → «ASTO (antistreptolizin O titar)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'asto'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'asto'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'asto'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- AVRI multiplex – detekcija 16 respiratornih virusa → «AVRI multiplex – detekcija 16 respiratornih virusa»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'avri-multiplex-16'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 72.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Nikšić: 60→72

-- AZF delecije Y hromozoma → «AZF delecije Y hromozoma»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'azf-y-chromosome-deletions'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 100.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 120.00 AND r.price_max IS NULL; -- Podgorica: 120→100
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'azf-y-chromosome-deletions'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 144.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 120.00 AND r.price_max IS NULL; -- Nikšić: 120→144
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'azf-y-chromosome-deletions'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 100.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 150.00 AND r.price_max IS NULL; -- Budva: 150→100

-- Beta-2 GP1 IgG → «Beta-2 GP1 IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'beta-2-glycoprotein-1-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Beta-2 GP1 IgM → «Beta-2 GP1 IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'beta-2-glycoprotein-1-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Beta-2 mikroglobulin → «Beta-2 mikroglobulin (marker limfoproliferativnih bolesti)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'beta-2-microglobulin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Beta HCG → «Beta-HCG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'beta-hcg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Bikarbonati → «Bikarbonati (kiselinsko-bazna ravnoteža)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'bicarbonates'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Vreme krvarenja → «Vrijeme krvarenja»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'bleeding-time'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Hemokultura (bakterije) → «Hemokultura (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'blood-culture'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→48

-- Bordetella Pertussis PCR → «Bordetella pertussis – veliki kašalj (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'bordetella-pertussis-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Nikšić: 50→60
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'bordetella-pertussis-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 55.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Budva: 70→55

-- Borrelia Burgdorferi IgG → «Borelija IgG (Lyme bolest)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'borrelia-burgdorferi-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Borelija IgG + IgM (Lyme bolest) → «Borelija IgG, Borelija IgM (Lyme bolest)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'borrelia-burgdorferi-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Borrelia Burgdorferi IgM → «Borelija IgM (Lyme bolest)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'borrelia-burgdorferi-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Bris dojke (bakterije) → «Bris dojke ( bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'breast-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris dojke (gljivice) → «Bris dojke (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'breast-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- C-peptid → «C-peptid»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c-peptide'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- C-reaktivni protein → «CRP (C-reaktivni protein)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c-reactive-protein'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Nikšić: 8→10

-- C3 komplement → «C3»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c3-complement'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c3-complement'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c3-complement'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- C4 komplement → «C4»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c4-complement'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c4-complement'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'c4-complement'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Onkomarker CA 125 → «CA 125 (marker jajnika)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ca-125'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Onkomarker CA 15-3 → «CA 15-3 (marker dojke)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ca-15-3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Onkomarker CA 19-9 → «CA 19-9 (marker pankreasa i gastrointestinalnog trakta)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ca-19-9'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Onkomarker CA 72-4 → «CA 72-4 (marker želuca i jajnika)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ca-72-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Kalcitonin → «Kalcitonin (marker medularnog karcinoma štitne žlijezde)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'calcitonin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Kalcijum → «Kalcijum ukupni»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'calcium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'calcium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'calcium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→4

-- Kalcijum u urinu → «Kalcijum u urinu»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'calcium-in-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6

-- Kalprotektin → «Fekalni kalprotektin (upalni marker u stolici)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'calprotectin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→48

-- Campylobacter sp. (kultura) → «Campylobacter sp. (kultura)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'campylobacter-culture'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Campylobacter sp. test (feces) → «Campylobacter sp. test (feces)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'campylobacter-stool-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Gljivice (Candida sp.) → «Gljivice (Candida sp.)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'candida-culture'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- KKS + CRP → «KKS + CRP (immunoturbidimetric rapid determination)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cbc-with-crp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- KKS + CRP + MxA → «KKS + CRP + MxA (immunoturbidimetric rapid determination)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cbc-with-crp-and-mxa'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Karcinoembrionalni antigen → «CEA (karcinoembrionalni antigen)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cea'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Bris cerviksa bakterije → «Cervikalni bris (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cervical-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris cerviksa gljivice → «Cervikalni bris (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cervical-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Chlamydia trachomatis – genitalni bris → «Chlamydia trachomatis – genitalni bris»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chlamydia-genital-swab'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Chlamydia trachomatis (Real-Time PCR) → «Chlamydia trachomatis – hlamidija (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chlamydia-trachomatis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Podgorica: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chlamydia-trachomatis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Nikšić: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chlamydia-trachomatis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Budva: 35→27

-- Hlorid → «Hloridi»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chloride'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chloride'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chloride'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→4

-- Holesterol → «Holesterol»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cholesterol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Hromogranin A → «Hromogranin A (neuroendokrini marker)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'chromogranin-a'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→48

-- Kreatin kinaza → «CK (kreatin kinaza)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ck'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ck'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Kreatin kinaza MB → «CK-MB (srčani izoenzim kreatin kinaze)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ck-mb'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ck-mb'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Clostridium difficile – toxin A+B → «Clostridium difficile – toxin A+B (feces)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'clostridium-difficile-toxin-ab'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Nikšić: 25→30

-- Vreme koagulacije → «Vrijeme koagulacije»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'coagulation-time'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Kokain → «Kokain»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cocaine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Kompletna krvna slika → «KKS (kompletna krvna slika)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'complete-blood-count'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6

-- Kompletna krvna slika sa leukocitnom formulom → «Komplet krvna slika (KKS) sa leukocitnom formulom»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'complete-blood-count-with-leukocyte-formula'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'complete-blood-count-with-leukocyte-formula'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Kompletan pregled urina → «Cjelokupni pregled urina»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'complete-urinalysis'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'complete-urinalysis'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'complete-urinalysis'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Kortizol → «Kortizol»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cortisol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- COVID-19 antigen test → «SARS-CoV-2 antigenski test»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'covid-19-antigen-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Koksaki B IgG → «Coxackie IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'coxsackie-b-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Koksaki B IgM → «Coxackie IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'coxsackie-b-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Coxsackie IgG + IgM → «Coxackie IgG, Coxackie IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'coxsackie-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Kreatinin → «Kreatinin u serumu»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'creatinine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Klirens kreatinina → «Klirens kreatinina (procjena funkcije bubrega)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'creatinine-clearance'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'creatinine-clearance'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'creatinine-clearance'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Kreatinin u urinu → «Kreatinin u urinu»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'creatinine-in-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'creatinine-in-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'creatinine-in-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- CYFRA 21-1 → «Cyfra 21-1 (marker pluća – citokeratin 19 fragment)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cyfra-21-1'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cyfra-21-1'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Citomegalovirus IgG → «CMV IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cytomegalovirus-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cytomegalovirus-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- CMV IgG + IgM → «CMV IgG, CMV IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cytomegalovirus-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Citomegalovirus IgM → «CMV IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cytomegalovirus-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'cytomegalovirus-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- D-dimer → «D-dimer»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'd-dimer'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 21.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 17.00 AND r.price_max IS NULL; -- Nikšić: 17→21

-- Demodex vrste → «Demodex (mikroskopski preparat) (detekcija parazita trepavica i kože)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'demodex-species'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Dermatomikoze (nokti, dlaka, koža) – NMP → «Dermatomikoze (nokti, dlaka, koža) – NMP (gljivične infekcije kože i dodataka)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'dermatomycosis-nmp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Dermatofiti (mikološka kultura) → «Dermatofiti (mikološka kultura)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'dermatophytes-culture'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Dehidroepiandrosteron sulfat → «DHEAS»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'dhea-s'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Direktni bilirubin → «Bilirubin direktni»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'direct-bilirubin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Podgorica: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'direct-bilirubin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'direct-bilirubin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Budva: 2→3

-- Dabl test (biohemijski skrining 1. trimestar) → «Dabl test (biohemijski skrining u trudnoći – 1. trimestrar)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'double-test-first-trimester-screening'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Podgorica: 40→48
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'double-test-first-trimester-screening'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→48
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'double-test-first-trimester-screening'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Budva: 40→48

-- Panel droga 10 II → «Test na droge – 10 parametara»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'drug-panel-10-ii'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→36

-- Panel droga 5 novi → «Test na droge – 5 parametara»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'drug-panel-5-new'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→24

-- Bris uha (bakterije) → «Bris uha (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ear-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris uha (gljivice) → «Bris uha (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ear-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Epstein-Barr IgG → «EBV IgG (Epstein-Barr virus)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'epstein-barr-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'epstein-barr-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- EBV IgG + IgM → «EBV IgG, EBV IgM (Epstein-Barr virus)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'epstein-barr-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Epstein-Barr IgM → «EBV IgM (Epstein-Barr virus)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'epstein-barr-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'epstein-barr-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Brzina sedimentacije eritrocita → «Sedimentacija eritrocita»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'erythrocyte-sedimentation-rate'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Estradiol → «Estradiol»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'estradiol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Podgorica: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'estradiol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Nikšić: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'estradiol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Budva: 8→10

-- Bris oka (bakterije) → «Bris oka (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'eye-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris oka – hlamidija → «Bris oka – hlamidija (Chlamydia trachomatis)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'eye-swab-chlamydia'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Bris oka (gljivice) → «Bris oka (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'eye-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Okultno krvarenje u stolici → «Okultno krvarenje (feces)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'fecal-occult-blood'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Feritin → «Feritin»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ferritin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Fibrinogen → «Fibrinogen»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'fibrinogen'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Folna kiselina → «Folna kiselina»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'folic-acid'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Slobodni beta HCG → «F-BHCG (slobodni beta-HCG)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'free-beta-hcg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'free-beta-hcg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Budva: 20→24

-- Slobodni estriol → «s-Free estriol (slobodni estriol)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'free-estriol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Slobodni PSA → «Slobodni PSA»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'free-psa'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Slobodni T3 → «FT3 (slobodni T3)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'free-t3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Slobodni T4 → «FT4 (slobodni T4)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'free-t4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Slobodni testosteron → «Slobodni testosteron»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'free-testosterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Folikulostimulirajući hormon → «FSH»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'fsh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Podgorica: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'fsh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Nikšić: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'fsh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Budva: 8→10

-- GAD antitijela (test za dijabetes tip 1) → «GAD (test za dijabetes tip 1)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gad-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→48

-- Gama-glutamil transferaza → «Gama-GT»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gamma-gt'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gamma-gt'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Gardnerella vaginalis (Real-Time PCR) → «Gardnerella vaginalis (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gardnerella-vaginalis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Podgorica: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gardnerella-vaginalis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Nikšić: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gardnerella-vaginalis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Budva: 35→27

-- Bris glansa bakterije → «Bris glansa (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'glans-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris glansa gljivice → «Bris glansa (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'glans-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Glijadin IgG antitela → «s-AGA-T IgG (antiglijadinska antitijela IgG – celijakija)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gliadin-igg-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gliadin-igg-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gliadin-igg-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- Glukoza → «Glukoza»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'glucose'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Glikovani hemoglobin → «HbA1c (tromjesečni šećer)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hba1c'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- HBsAg → «HBsAg (hepatitis B površinski antigen)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hbsag'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hbsag'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hbsag'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→10

-- HDL holesterol → «HDL-holesterol»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hdl-cholesterol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Humani epididimalni protein 4 → «HE4 (human epididymal protein 4 – marker jajnika)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'he4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Podgorica: 25→30
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'he4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Nikšić: 25→30
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'he4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Budva: 25→30

-- Helicobacter Pylori antigen u fecesu → «Helicobacter pylori – feces (Helikobakterija u stolici)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-antigen-in-feces'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Helicobacter Pylori IgA → «HBP IgA (Helicobacter pylori IgA – aktivna ili nedavna infekcija)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-iga'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-iga'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-iga'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- Helicobacter Pylori IgG → «HBP IgG (Helicobacter pylori IgG – ranija ili hronična infekcija)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- HBP IgG, HBP IgA → «HBP IgG, HBP IgA (Helicobacter pylori – oba tipa antitijela)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'helicobacter-pylori-igg-iga-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Herpes Simplex I IgG → «HSV1 IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-i-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-i-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- HSV 1 IgG + IgM → «HSV 1 lgG, HSV 1 IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-i-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Herpes Simplex I IgM → «HSV1 IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-i-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-i-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Herpes Simplex II IgG → «HSV2 IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-ii-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-ii-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- HSV 2 IgG + IgM → «HSV 2 IgG, HSV 2 lgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-ii-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Herpes Simplex II IgM → «HSV2 IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-ii-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'herpes-simplex-ii-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Homocistein → «Homocistein (test za kardiovaskularni rizik)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'homocysteine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- HPV Quant 21 – 21 tip → «HPV Quant 21 – kvantitativni test za 21 HPV tip (6, 11, 16, 18, 26, 31, 33, 35, 39, 44, 45, 51, 52, 53, 56, 58, 59, 66, 68, 73, 82)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hpv-quant-21'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 145.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 120.00 AND r.price_max IS NULL; -- Nikšić: 120→145

-- HPV Quant 4 – tipovi 6, 11, 16, 18 → «HPV Quant 4 – kvantitativni test HPV tipova (6, 11, 16, 18)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hpv-quant-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 65.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Podgorica: 40→65
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hpv-quant-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 78.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 65.00 AND r.price_max IS NULL; -- Nikšić: 65→78

-- Imunoglobulin A → «IgA»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'iga'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'iga'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'iga'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Imunoglobulin E → «IgE»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ige'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Imunoglobulin G → «IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Imunoglobulin M → «IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Imunoglobulini (IgG, IgA, IgM) → «lmunoglobulini (IgG, IgA, IgM)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'immunoglobulins-panel-igg-iga-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Influenca A Plus B IHT → «Influenza A+B test (bris nosa)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'influenza-a-plus-b-iht'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Influenca A i B – brzi test na grip → «Influenca A i B – brzi test na grip»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'influenza-ab-rapid-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Inhibin A → «Inhibin A»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'inhibin-a'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Inhibin B → «Inhibin B»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'inhibin-b'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Podgorica: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'inhibin-b'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 35.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→35

-- Insulin → «Insulin»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'insulin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Insulinska rezistencija (0, 60, 120 min) → «Insulinska rezistencija (0', 60', 120' min)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'insulin-resistance-test-3-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Nikšić: 50→60

-- Insulinska rezistencija (0, 30, 60, 90, 120 min) → «Insulinska rezistencija (0', 30', 60', 90', 120' min)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'insulin-resistance-test-5-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 84.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Nikšić: 70→84

-- Interleukin-6 → «Interleukin 6 – marker zapaljenja i imunološkog odgovora (upale, COVID-19, autoimune bolesti)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'interleukin-6'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Podgorica: 25→30
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'interleukin-6'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Nikšić: 25→30
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'interleukin-6'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Budva: 25→30

-- Jonizovani kalcijum → «Kalcijum jonski»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ionized-calcium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ionized-calcium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ionized-calcium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→4

-- Gvožđe → «Gvožđe u serumu»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'iron'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'iron'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- Mikrobiološki nalaz za vrtić (grlo, perianalni otisak) → «Mikrobiološki nalaz za vrtić (grlo, perianalni otisak)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'kindergarten-microbiology-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Mikrobiološki nalaz za vrtić (grlo, nos, perianalni otisak) → «Mikrobiološki nalaz za vrtić (grlo, nos, perianalni otisak)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'kindergarten-microbiology-3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 29.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 24.00 AND r.price_max IS NULL; -- Nikšić: 24→29

-- Laktat dehidrogenaza → «LDH (laktat dehidrogenaza)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ldh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ldh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- LDL holesterol → «LDL-holesterol»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ldl-cholesterol'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4

-- LE ćelije (test na autoimune bolesti) → «LE ćelije (test na autoimune bolesti, citratna plazma)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'le-cells'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Luteinizirajući hormon → «LH»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'lh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Podgorica: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'lh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Nikšić: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'lh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Budva: 8→10

-- Lipaza → «Lipaza»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'lipase'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6

-- Lupus antikoagulans → «LA (lupus antikoagulans, citratna plazma)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'lupus-anticoagulant'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Magnezijum → «Magnezijum»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'magnesium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'magnesium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'magnesium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→4

-- Marihuana → «Marihuana»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'marijuana'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Mikroalbumin u urinu → «Mikroalbumini u urinu (rana detekcija oštećenja bubrega)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'microalbumin-in-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Morfin → «Heroin»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'morphine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Zaušnjaci IgG → «Mumps IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mumps-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Mumps IgG + IgM (zauške) → «Mumps IgG, Mumps IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mumps-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Zaušnjaci IgM → «Mumps IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mumps-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Mycoplasma i Chlamydia pneumoniae → «Mycoplasma i Chlamydia pneumoniae – respiratorne infekcije»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-chlamydia-pneumoniae-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Nikšić: 50→60

-- Mycoplasma genitalium (Real-Time PCR) → «Mycoplasma genitalium (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-genitalium-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Podgorica: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-genitalium-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Nikšić: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-genitalium-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Budva: 35→27

-- Mycoplasma hominis (Real-Time PCR) → «Mycoplasma hominis (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-hominis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Podgorica: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-hominis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Nikšić: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-hominis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Budva: 35→27

-- Mycoplasma + Ureaplasma – genitalni bris → «Mycoplasma + Ureaplasma – genitalni bris»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'mycoplasma-ureaplasma-genital-swab'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 42.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Nikšić: 35→42

-- Neisseria gonorrhoeae (kultura) → «Neisseria gonorrhoeae (kultura)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'neisseria-gonorrhoeae-culture'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Neisseria gonorrhoeae – DMP + rapid test → «Neisseria gonorrhoeae – DMP + rapid test (brza detekcija gonoreje)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'neisseria-gonorrhoeae-rapid-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Neisseria gonorrhoeae (Real-Time PCR) → «Neisseria gonorrhoeae – gonoreja (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'neisseria-gonorrhoeae-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Podgorica: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'neisseria-gonorrhoeae-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Nikšić: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'neisseria-gonorrhoeae-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Budva: 35→27

-- Bris nosa bakterije → «Bris nosa (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'nose-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Bris nosa gljivice → «Bris nosa (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'nose-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Neuron-specifična enolaza → «NSE (neuronspecifična enolaza – marker za neuroendokrine tumore)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'nse'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'nse'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- NT-proBNP → «Pro-BNP (NT-proBNP – marker za srčanu insuficijenciju)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'nt-probnp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Podgorica: 35→40
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'nt-probnp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'nt-probnp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 45.00 AND r.price_max IS NULL; -- Budva: 45→40

-- OGTT (0, 60, 120 min) → «OGTT (0', 60', 120' min)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ogtt-3-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Podgorica: 10→12
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ogtt-3-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ogtt-3-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Budva: 10→15

-- OGTT (0, 30, 60, 90, 120 min) → «OGTT (0', 30', 60', 90', 120' min)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ogtt-5-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ogtt-5-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ogtt-5-point'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 20.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→20

-- Bris usne duplje gljivice → «Bris usne šupljine (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'oral-cavity-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Bris usne duplje bakterije → «Bris usne šupljine (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'oral-cavity-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Antitela na jajnike → «Anti-ovarijalna antitijela»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ovarian-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- PAP test → «PAPA laboratorija (citološka analiza grlića materice – Papa test)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'pap-papanicolaou-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Protein A plazme povezan sa trudnoćom → «PAPP-A (plazma protein A povezan s trudnoćom)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'papp-a'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'papp-a'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Budva: 20→24

-- Parvo B19 IgA → «Parvo B19 IgA»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'parvovirus-b19-iga'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Parvovirus B19 IgG → «Parvo B19 IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'parvovirus-b19-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Parvo B19 IgG + IgA → «Parvo B19 IgG, Parvo B19 IgA»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'parvovirus-b19-igg-iga-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Perianalni otisak → «Perianalni otisak (mikroskopski preparat)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'perianal-impression'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- pH laboratorija 1 → «pH laboratorija 1»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ph-lab-test-1'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- pH laboratorija 2 → «pH laboratorija 2»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ph-lab-test-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→48

-- Fosfor → «Fosfor»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'phosphorus'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'phosphorus'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'phosphorus'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→4

-- Fosfor u urinu → «Fosfor u urinu»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'phosphorus-in-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6

-- Bris postoperativne rane / aerobni i anaerobni uslovi → «Bris postoperativne rane / aerobni i anaerobni uslovi (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'postoperative-wound-swab-anaerobic'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Nikšić: 25→30

-- Kalijum → «Kalijum»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'potassium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'potassium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'potassium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→4

-- Bris prepucijuma bakterije → «Bris prepucijuma (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'prepuce-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris prepucijuma gljivice → «Bris prepucijuma (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'prepuce-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Prokalcitonin → «Prokalcitonin (PCT) (marker bakterijskih infekcija i sepse)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'procalcitonin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Podgorica: 25→30
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'procalcitonin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Nikšić: 25→30
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'procalcitonin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Budva: 25→30

-- Progesteron → «Progesteron»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'progesterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Podgorica: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'progesterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Nikšić: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'progesterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Budva: 8→10

-- Prolaktin → «Prolaktin»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'prolactin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Podgorica: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'prolactin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Nikšić: 8→10
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'prolactin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 8.00 AND r.price_max IS NULL; -- Budva: 8→10

-- Prolaktin (3 puta) sa braunilom → «Prolaktin (3 puta) sa braunilom»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'prolactin-3x-with-iv-cannula'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Protein C → «Protein C (citratna plazma)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protein-c'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 42.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Nikšić: 35→42

-- Proteini u 24h urinu → «Proteini u 24-časovnom urinu»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protein-in-24h-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protein-in-24h-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protein-in-24h-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Protein S → «Protein S (citratna plazma)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protein-s'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 42.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Nikšić: 35→42

-- Protrombinsko vreme PT INR → «Protrombinsko vrijeme»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'prothrombin-time-pt-inr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6

-- Protia Allergy Q64 - inhalatorni panel (64 alergena) → «Protia Allergy Q64 – inhalatorni panel (64 alergena)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protia-allergy-q64-inhalation-panel-64-allergens'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 108.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 90.00 AND r.price_max IS NULL; -- Nikšić: 90→108

-- Protia Allergy Q64 - nutritivni panel (72 alergena) → «Protia Allergy Q64 – nutritivni panel (72 alergena)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protia-allergy-q64-nutritive-panel-72-allergens'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 108.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 90.00 AND r.price_max IS NULL; -- Nikšić: 90→108

-- Protia Allergy Q64S - kombinovani panel (63 alergena) → «Protia Allergy Q64S – kombinovani panel (63 alergena)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protia-allergy-q64s-combined-panel-63-allergens'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 120.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 100.00 AND r.price_max IS NULL; -- Nikšić: 100→120

-- Protia Allergy Q96M - kombinovani panel (107 alergena) → «Protia Allergy Q96M – kombinovani panel (107 alergena)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protia-allergy-q96m-combined-panel-107-allergens'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 168.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 140.00 AND r.price_max IS NULL; -- Nikšić: 140→168

-- Protozoe test – Giardia, Cryptosporidium, Entamoeba → «Protozoe test – Giardia, Cryptosporidium, Entamoeba (feces)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'protozoa-stool-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Prostatični specifični antigen → «PSA (prostata specifični antigen)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'psa'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Paratireoidni hormon → «PTH (paratiroidni hormon)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'pth'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Punktat / aerobni i anaerobni uslovi → «Punktat / aerobni i anaerobni uslovi (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'punctate-aerobic-anaerobic'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 25.00 AND r.price_max IS NULL; -- Nikšić: 25→30

-- Brzi test na streptokoke A → «Brzi strepto test (bris grla) (brza detekcija Streptococcus pyogenes)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rapid-strep-a'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Rektalni bris (bakterije) → «Rektalni bris (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rectal-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Rektalni bris (gljivice) → «Rektalni bris (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rectal-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Reumatoidni faktor → «Reuma faktor (reumatoidni faktor)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rheumatoid-factor'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rheumatoid-factor'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rheumatoid-factor'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Rubela IgG → «Rubela IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rubella-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rubella-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Rubela IgG + IgM → «Rubela IgG, Rubela IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rubella-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Rubela IgM → «Rubela IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rubella-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'rubella-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- SARS-CoV-2 IgG Spike protein → «ACOV 2 S (antitijela na SARS-CoV-2 -spike protein)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sars-cov-2-igg-spike-protein'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Podgorica: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sars-cov-2-igg-spike-protein'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sars-cov-2-igg-spike-protein'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Budva: 20→24

-- SARS-CoV-2 (Real-Time RT-PCR) → «SARS-CoV-2 – kovid test (Real-Time RT-PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sars-cov-2-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 54.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 45.00 AND r.price_max IS NULL; -- Nikšić: 45→54

-- Globulin koji vezuje polne hormone → «SHBG (globulin koji veže polne hormone)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'shbg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'shbg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Bris kože bakterije → «Bris kože (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'skin-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris kože gljivice → «Bris kože (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'skin-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Natrijum → «Natrijum»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sodium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Podgorica: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sodium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Nikšić: 3→4
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sodium'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 3.00 AND r.price_max IS NULL; -- Budva: 3→4

-- Kultura sperme bakterije → «Sperma (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sperm-culture-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Kultura sperme gljivice → «Sperma (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sperm-culture-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Antitela na spermatozoide ASA → «Anti-spermatozoidna antitijela»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'spermatozoa-antibodies-asa'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Sputum bakterije → «Kultura ispljuvka - sputum (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sputum-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Sputum gljivice → «Kultura ispljuvka - sputum (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'sputum-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- s-NT-proBNP (standardizovani marker za srčanu insuficijenciju) → «s-NT-proBNP (standardizovani marker za srčanu insuficijenciju)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'standardized-nt-probnp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 48.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→48

-- STD Multiplex 2 – detekcija 2 patogena → «STD Multiplex 2 – detekcija bilo koja 2 navedena patogena»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 45.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 38.00 AND r.price_max IS NULL; -- Podgorica: 38→45
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 54.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 45.00 AND r.price_max IS NULL; -- Nikšić: 45→54
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 45.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Budva: 60→45

-- STD Multiplex 3 – detekcija 3 patogena → «STD Multiplex 3 – detekcija bilo koja 3 navedena patogena»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 45.00 AND r.price_max IS NULL; -- Podgorica: 45→50
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 72.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Nikšić: 60→72
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Budva: 80→50

-- STD Multiplex 4 – detekcija 4 patogena → «STD Multiplex 4 – detekcija bilo koja 4 navedena patogena»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 65.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Podgorica: 60→65
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 84.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Nikšić: 70→84
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 65.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 105.00 AND r.price_max IS NULL; -- Budva: 105→65

-- STD Multiplex 4 + HPV Quant 4 → «STD Multiplex 4 + HPV Quant 4»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-4-plus-hpv-quant-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 130.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 150.00 AND r.price_max IS NULL; -- Podgorica: 150→130
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-4-plus-hpv-quant-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 180.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 150.00 AND r.price_max IS NULL; -- Nikšić: 150→180
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-4-plus-hpv-quant-4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 130.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 150.00 AND r.price_max IS NULL; -- Budva: 150→130

-- STD Multiplex 5 – detekcija 5 patogena → «STD Multiplex 5 – detekcija bilo koja 5 navedena patogena»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-5'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Podgorica: 70→80
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-5'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 96.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Nikšić: 80→96
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-5'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 135.00 AND r.price_max IS NULL; -- Budva: 135→80

-- STD Multiplex 6 – detekcija 6 patogena → «STD Multiplex 6 – detekcija bilo koja 6 navedena patogena»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-6'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 90.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Podgorica: 80→90
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-6'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 108.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 90.00 AND r.price_max IS NULL; -- Nikšić: 90→108
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-6'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 90.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 160.00 AND r.price_max IS NULL; -- Budva: 160→90

-- STD Multiplex 7 – detekcija 7 patogena → «STD Multiplex 7 – detekcija bilo koja 7 navedena patogena»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-7'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 100.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 90.00 AND r.price_max IS NULL; -- Podgorica: 90→100
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-7'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 222.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 185.00 AND r.price_max IS NULL; -- Nikšić: 185→222
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'std-multiplex-7'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 100.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 185.00 AND r.price_max IS NULL; -- Budva: 185→100

-- Stolica gljivice → «Feces (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'stool-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Paraziti u stolici → «Feces na crijevne parazite, protozoe (DMP) (parazitološki pregled stolice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'stool-parasites'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Trijodtironin → «T3»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 't3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 8.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 6.00 AND r.price_max IS NULL; -- Nikšić: 6→8
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 't3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 8.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 6.00 AND r.price_max IS NULL; -- Budva: 6→8

-- Tiroksin → «T4»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 't4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 8.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 6.00 AND r.price_max IS NULL; -- Nikšić: 6→8
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 't4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 8.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 6.00 AND r.price_max IS NULL; -- Budva: 6→8

-- TBC (tuberkuloza) test → «TBC (tuberkuloza) test»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tb-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Testosteron → «Testosteron»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'testosterone'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Bris grla bakterije → «Bris grla (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'throat-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Bris grla gljivice → «Bris grla (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'throat-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Trombofilija + folatni metabolizam → «Trombofilija + folatni metabolizam – genetski test za zgrušavanje krvi i folat ciklus»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'thrombophilia-folate-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 180.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 150.00 AND r.price_max IS NULL; -- Nikšić: 150→180
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'thrombophilia-folate-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 150.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 170.00 AND r.price_max IS NULL; -- Budva: 170→150

-- Tireoglobulin → «Tireoglobulin»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'thyroglobulin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- TSH, FT3, FT4 → «TSH, FT3, FT4»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'thyroid-panel-tsh-ft3-ft4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 32.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 26.00 AND r.price_max IS NULL; -- Nikšić: 26→32

-- TSH, FT4 → «TSH, FT4»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'thyroid-panel-tsh-ft4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 20.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 16.00 AND r.price_max IS NULL; -- Nikšić: 16→20

-- TSH, T3, T4 → «TSH, T3, T4»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'thyroid-panel-tsh-t3-t4'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 22.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 18.00 AND r.price_max IS NULL; -- Nikšić: 18→22

-- Ukupni kapacitet vezivanja gvožđa → «TIBC (ukupna sposobnost vezivanja gvožđa)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tibc'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tibc'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tibc'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Bris jezika bakterije → «Bris jezika (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tongue-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris jezika (gljivice) → «Bris jezika (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tongue-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- TORCH panel → «TORCH (skrining na infekcije u trudnoći)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'torch-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 96.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Podgorica: 80→96
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'torch-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 96.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Nikšić: 80→96
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'torch-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 96.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Budva: 80→96

-- Ukupni bilirubin → «Bilirubin ukupni»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'total-bilirubin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Podgorica: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'total-bilirubin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'total-bilirubin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Budva: 2→3

-- Ukupni proteini → «Proteini ukupni»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'total-protein'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Podgorica: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'total-protein'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'total-protein'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Budva: 2→3

-- Toksoplazma IgG → «TOXO IgG»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'toxoplasma-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'toxoplasma-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- TOXO IgG + IgM → «TOXO IgG, TOXO IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'toxoplasma-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Toksoplazma IgM → «TOXO IgM»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'toxoplasma-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'toxoplasma-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- TPHA Treponema Pallidum → «TPH»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tpha-treponema-pallidum'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tpha-treponema-pallidum'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tpha-treponema-pallidum'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 20.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→20

-- Transferin → «Transferin»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'transferrin'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Transglutaminaza IgA antitela → «Tkivna transglutaminaza IgA (marker celijakije – glavna antitijela)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'transglutaminase-iga-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'transglutaminase-iga-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'transglutaminase-iga-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- Transglutaminaza IgG antitela → «Tkivna transglutaminaza IgG (marker celijakije – autoimuna reakcija na gluten)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'transglutaminase-igg-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'transglutaminase-igg-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'transglutaminase-igg-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- Trichomonas vaginalis – NMP + rapid test → «Trichomonas vaginalis – NMP + rapid test (brza detekcija Trichomonas vaginalis)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'trichomonas-rapid-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Trichomonas vaginalis (Real-Time PCR) → «Trichomonas vaginalis – trihomonas (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'trichomonas-vaginalis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Podgorica: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'trichomonas-vaginalis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Nikšić: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'trichomonas-vaginalis-real-time-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Budva: 35→27

-- Trigliceridi → «Trigliceridi»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'triglycerides'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Tripl test (biohemijski skrining 2. trimestar) → «Tripl test (biohemijski skrining u trudnoći – 2. trimestrar)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'triple-test-second-trimester-screening'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 54.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 45.00 AND r.price_max IS NULL; -- Podgorica: 45→54
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'triple-test-second-trimester-screening'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 54.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 45.00 AND r.price_max IS NULL; -- Nikšić: 45→54
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'triple-test-second-trimester-screening'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 54.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 45.00 AND r.price_max IS NULL; -- Budva: 45→54

-- Troponin T visoke osetljivosti → «Troponin T»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'troponin-t-hs'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 20.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→20
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'troponin-t-hs'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'troponin-t-hs'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 20.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→20

-- Tireostimulirajući hormon → «TSH»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tsh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 8.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 6.00 AND r.price_max IS NULL; -- Podgorica: 6→8
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tsh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 8.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 6.00 AND r.price_max IS NULL; -- Nikšić: 6→8
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'tsh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 8.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 6.00 AND r.price_max IS NULL; -- Budva: 6→8

-- Neiskorišćeni kapacitet vezivanja gvožđa → «UIBC (nezasićena sposobnost vezivanja gvožđa)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'uibc'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'uibc'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'uibc'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Ultra TSH (ultrasenzitivni TSH test) → «Ultra TSH (ultrasenzitivni TSH test)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ultra-sensitive-tsh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Urea → «Urea»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urea'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3

-- Klirens ureje → «Klirens uree (procjena izlučivanja uree putem bubrega)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urea-clearance'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urea-clearance'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urea-clearance'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Ureaplasma complex (Real-Time PCR) → «Ureaplasma complex (Real-Time PCR)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ureaplasma-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Podgorica: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ureaplasma-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 22.00 AND r.price_max IS NULL; -- Nikšić: 22→27
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'ureaplasma-pcr'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 27.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 35.00 AND r.price_max IS NULL; -- Budva: 35→27

-- Bris uretre bakterije → «Uretralni bris (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urethral-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris uretre gljivice → «Uretralni bris (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urethral-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Mokraćna kiselina → «Mokraćna kiselina»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'uric-acid'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Podgorica: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'uric-acid'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Nikšić: 2→3
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'uric-acid'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 3.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Budva: 2→3

-- Mokraćna kiselina u urinu → «Mokraćna kiselina u urinu»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'uric-acid-in-urine'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6

-- Urin (bakterije) → «Urin (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urine-culture-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Urin gljivice → «Urin (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'urine-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Vaginalni sekret - grupa (DMP) → «Vaginalni sekret - grupa (DMP)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'vaginal-discharge-dmp'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 12.00 AND r.price_max IS NULL; -- Nikšić: 12→15

-- Bris vagine bakterije → «Bris vagine (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'vaginal-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris vagine gljivice → «Bris vagine (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'vaginal-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- VZV IgG + IgM → «VZV IgG, VZV IgM (Varicella-zoster)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'varicella-zoster-igg-igm-panel'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 36.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→36

-- Varicela Zoster Virus IgG → «VZV IgG (Varicella-zoster)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'varicella-zoster-virus-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'varicella-zoster-virus-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'varicella-zoster-virus-igg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- Varicela Zoster Virus IgM → «VZV IgM (Varicella-zoster)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'varicella-zoster-virus-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Podgorica: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'varicella-zoster-virus-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'varicella-zoster-virus-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Budva: 15→18

-- Vitamin B12 → «Vitamin B12»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'vitamin-b12'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 24.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→24

-- Vitamin D 25-OH → «Vitamin D»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'vitamin-d-25-oh'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 33.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 27.00 AND r.price_max IS NULL; -- Nikšić: 27→33

-- Bris vulve bakterije → «Bris vulve (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'vulvar-swab-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 16.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 13.00 AND r.price_max IS NULL; -- Nikšić: 13→16

-- Bris vulve gljivice → «Bris vulve (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'vulvar-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Valer-Rouz test → «Waaler-Rose (test na reumatoidni faktor)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'waaler-rose-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Podgorica: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'waaler-rose-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→6
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'waaler-rose-test'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 6.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Budva: 5→6

-- Bris rane / aerobni uslovi (bakterije) → «Bris rane / aerobni uslovi (bakterije)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'wound-swab-aerobic-bacteria'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 18.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 15.00 AND r.price_max IS NULL; -- Nikšić: 15→18

-- Bris rane gljivice → «Bris rane / aerobni uslovi (gljivice)»
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'wound-swab-fungi'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 12.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Nikšić: 10→12

-- Pregled alergologa → «Pregled alergologa»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'allergist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'allergist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Ultrazvuk dojki → «Ultrazvuk dojki»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'breast-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→50

-- Pregled kardiologa sa EKG-om → «Pregled kardiologa sa EKG-om»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cardiologist-examination-with-ecg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Podgorica: 60→70
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cardiologist-examination-with-ecg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Budva: 60→70

-- Pregled kardiologa sa EKG-om i ehokardiografijom (ultrazvuk srca) → «Pregled kardiologa sa ultrazvukom srca i EKG-om»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 90.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Podgorica: 80→90
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cardiologist-examination-with-ecg-and-echocardiography-heart-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 90.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Budva: 80→90

-- Ispiranje uha od cerumena → «Ispiranje uha»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'cerumen-ear-irrigation'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40

-- Kolonoskopija i gastroskopija sa anestezijom → «Kolonoskopija i gastroskopija sa anestezijom»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'colonoscopy-and-gastroscopy-with-anesthesia'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 390.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 320.00 AND r.price_max IS NULL; -- Nikšić: 320→390

-- Kolonoskopija sa anestezijom → «Kolonoskopija sa anestezijom»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'colonoscopy-with-anesthesia'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 250.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 210.00 AND r.price_max IS NULL; -- Nikšić: 210→250

-- Kolonoskopija bez anestezije → «Kolonoskopija bez anestezije»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'colonoscopy-without-anesthesia'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 210.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 170.00 AND r.price_max IS NULL; -- Nikšić: 170→210

-- Kolposkopija (pregled grlića materice) → «Kolposkopija (pregled grlića materice)»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'colposcopy'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Nikšić: 50→70

-- Kompletan pregled za glaukom → «Kompletan pregled za glaukom - pregled, mjerenje očnog pritiska, OCT vidnog živca i žute mrlje, KVP»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'complete-glaucoma-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 150.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 120.00 AND r.price_max IS NULL; -- Nikšić: 120→150

-- CTG monitoring (praćenje otkucaja srca ploda i kontrakcija) → «CTG monitoring (praćenje otkucaja srca ploda i kontrakcija)»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'ctg-fetal-monitoring'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→30

-- Dermatoskopija → «Dermatoskopija»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'dermatoscopy'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→70

-- E-konsultacija sa drugim specijalistom → «e-konsultacija sa drugim specijalistom»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'e-consultation-with-specialist'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→30

-- EKG → «EKG»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'ecg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 15.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 10.00 AND r.price_max IS NULL; -- Podgorica: 10→15
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'ecg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 10.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 5.00 AND r.price_max IS NULL; -- Nikšić: 5→10

-- Elektrokoagulacija (promjene na grliću materice) → «Elektrokoagulacija (PVU – promjene na grliću materice)»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'electrocoagulation-cervix'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 100.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Nikšić: 80→100

-- Pregled endokrinologa → «Pregled endokrinologa»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'endocrinologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'endocrinologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Pregled endokrinologa sa ultrazvukom štitne žlijezde → «Pregled endokrinologa sa ultrazvukom štitne žlijezde»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'endocrinologist-examination-with-thyroid-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Podgorica: 70→80
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'endocrinologist-examination-with-thyroid-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Budva: 70→80

-- Ekspertski ultrazvuk u trudnoći → «Ekspertski ultrazvuk u trudnoći»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'expert-pregnancy-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Nikšić: 70→80

-- Pregled specijaliste porodične medicine → «Pregled specijaliste porodične medicine»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'family-medicine-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Podgorica: 40→50
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'family-medicine-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Budva: 40→50

-- Prvi pregled gastroenterologa → «Pregled interniste gastroenterologa»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'first-gastroenterologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'first-gastroenterologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Kontrolni pregled opšteg ljekara → «Kontrolni pregled ljekara opšte prakse»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-general-practitioner-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Podgorica: 30→40
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-general-practitioner-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→30
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-general-practitioner-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Budva: 30→40

-- Kontrolni pedijatrijski pregled → «Kontrolni pedijatrijski pregled»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Podgorica: 30→40
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→30
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Budva: 30→40

-- Kontrolni profesorski pregled → «Kontrolni profesorski pregled»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-professor-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Nikšić: 70→80

-- Kontrolni subspecijalistički pregled → «Kontrolni subspecijalistički pregled»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-subspecialist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→50

-- Subspecijalistički kontrolni pregled pedijatra → «Subspecijalistički kontrolni pregled pedijatra»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-subspecialist-pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Podgorica: 40→50
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-subspecialist-pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Budva: 40→50

-- Gastroskopija sa anestezijom → «Gastroskopija sa anestezijom»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'gastroscopy-with-anesthesia'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 170.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 140.00 AND r.price_max IS NULL; -- Nikšić: 140→170

-- Gastroskopija bez anestezije → «Gastroskopija bez anestezije»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'gastroscopy-without-anesthesia'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 120.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 100.00 AND r.price_max IS NULL; -- Nikšić: 100→120

-- Pregled opšteg ljekara → «Pregled ljekara opšte prakse»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'general-practitioner-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Podgorica: 40→50
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'general-practitioner-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'general-practitioner-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Budva: 40→50

-- Specijalistički ginekološki pregled → «Specijalistički ginekološki pregled»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'gynecological-specialist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→50

-- Specijalistički ginekološki pregled sa ultrazvukom → «Specijalistički ginekološki pregled sa ultrazvukom»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'gynecological-specialist-examination-with-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Nikšić: 60→80

-- Ginekološki ultrazvuk → «Ginekološki ultrazvuk»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'gynecological-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→50

-- Pregled hematologa → «Pregled hematologa»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'hematologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'hematologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Ultrazvuk kukova → «Ultrazvuk kukova»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'hip-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40

-- Patohistološka analiza - 1 uzorak → «Patohistološka (PH) analiza – 1 uzorak»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'histopathology-1-sample'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40

-- Patohistološka analiza - 2 uzorka → «Patohistološka (PH) analiza – 2 uzorka»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'histopathology-2-samples'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Nikšić: 40→50

-- Kućna posjeta - uži centar → «Kućna posjeta - uži dio grada»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'home-visit-city-center'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Nikšić: 50→60

-- Kućna posjeta - prigradska naselja → «Kućna posjeta - prigradska naselja»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'home-visit-suburban'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Nikšić: 70→80

-- Pregled interniste sa EKG-om → «Pregled interniste sa EKG-om»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'internist-examination-with-ecg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Podgorica: 60→70
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'internist-examination-with-ecg'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Budva: 60→70

-- Biopsija jetre u lokalnoj anesteziji → «Biopsija jetre u lokalnoj anesteziji»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'liver-biopsy-local-anesthesia'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 600.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 500.00 AND r.price_max IS NULL; -- Nikšić: 500→600

-- Pregled medicinske dokumentacije i propisivanje recepta → «Pregled medicinske dokumentacije i propisivanje recepta»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'medical-documentation-review-and-prescription'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 30.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 20.00 AND r.price_max IS NULL; -- Nikšić: 20→30

-- Ultrazvuk vrata → «Ultrazvuk vrata»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'neck-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40

-- Pregled interniste onkologa → «Pregled interniste onkologa»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'oncologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60

-- Oftalmološki pregled → «Oftalmološki pregled»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'ophthalmological-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Nikšić: 50→70

-- Oftalmološki pregled sa UZ i proračunom sočiva → «Oftalmološki pregled sa UZ i proračunom sočiva»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'ophthalmological-examination-with-lens-calculation'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 150.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Nikšić: 80→150

-- Pregled pedijatra kardiologa sa ultrazvukom srca i EKG-om → «Pregled pedijatra – kardiolog sa ultrazvukom srca i EKG-om»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-cardiologist-examination-with-echocardiography'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 90.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Podgorica: 80→90

-- Pedijatrijski pregled → «Pedijatrijski pregled»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Podgorica: 40→50
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 50.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 40.00 AND r.price_max IS NULL; -- Budva: 40→50

-- Pregled pedijatra gastroenterologa → «Pregled pedijatra – gastroenterolog»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-gastroenterologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-gastroenterologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Pregled pedijatra hematologa → «Pregled pedijatra – hematolog»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-hematologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-hematologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Pregled pedijatra neurologa → «Pregled pedijatra – neurolog»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-neurologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Podgorica: 70→80

-- Pregled pedijatra pulmologa → «Pregled pedijatra – pulmolog»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pediatric-pulmonologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60

-- Postavljanje pesara → «Postavljanje pesara»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pessary-insertion'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40

-- Polipektomija (uklanjanje polipa) → «Polipektomija (uklanjanje polipa)»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'polypectomy'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 80.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 70.00 AND r.price_max IS NULL; -- Nikšić: 70→80

-- Pregled pulmologa → «Pregled pulmologa»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pulmonologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'pulmonologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Pregled reumatologa → «Pregled reumatologa»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'rheumatologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Podgorica: 60→70
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'rheumatologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 60.00 AND r.price_max IS NULL; -- Budva: 60→70

-- Ultrazvuk mekih tkiva → «Ultrazvuk mekih tkiva»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'soft-tissue-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40

-- Subspecijalistički pregled → «Subspecijalistički pregled»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'subspecialist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 70.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Nikšić: 50→70
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'subspecialist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Subspecijalistički pregled sa ultrazvukom → «Subspecijalistički pregled sa ultrazvukom»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'subspecialist-examination-with-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 100.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 80.00 AND r.price_max IS NULL; -- Nikšić: 80→100
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'subspecialist-examination-with-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-tivat'
   SET r.price = 180.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 160.00 AND r.price_max IS NULL; -- Tivat: 160→180

-- Subspecijalistički pregled pedijatra → «Subspecijalistički pregled pedijatra»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'subspecialist-pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Podgorica: 50→60
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'subspecialist-pediatric-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 60.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 50.00 AND r.price_max IS NULL; -- Budva: 50→60

-- Sistematski pregled paket 1 → «Sistematski pregled PAKET 1»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'systematic-examination-package-1'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 180.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 160.00 AND r.price_max IS NULL; -- Podgorica: 160→180
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'systematic-examination-package-1'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 180.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 160.00 AND r.price_max IS NULL; -- Budva: 160→180

-- Sistematski pregled paket 2 → «Sistematski pregled PAKET 2»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'systematic-examination-package-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.price = 230.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 210.00 AND r.price_max IS NULL; -- Podgorica: 210→230
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'systematic-examination-package-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.price = 230.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 210.00 AND r.price_max IS NULL; -- Budva: 210→230

-- Sistematski ginekološki pregled - paket usluga → «Sistematski ginekološki pregled – paket usluga»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'systematic-gynecological-examination-package'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 130.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 100.00 AND r.price_max IS NULL; -- Nikšić: 100→130

-- Ultrazvuk štitne žlijezde → «Ultrazvuk štitne i paraštitaste žlijezde»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'thyroid-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 40.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→40

-- Ultrazvuk urotrakta → «Ultrazvuk urotrakta»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'urinary-tract-ultrasound'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.price = 35.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 30.00 AND r.price_max IS NULL; -- Nikšić: 30→35

-- Uzimanje krvi iz vene → «Vađenje krvi»
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'venous-blood-draw'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-tivat'
   SET r.price = 4.00, r.price_max = NULL, r.is_price_outdated = 0
 WHERE r.price = 2.00 AND r.price_max IS NULL; -- Tivat: 2→4

-- ═══ 3. Нет на сайте ═══

UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'borrelia-burgdorferi-igm'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-tivat'
   SET r.is_obsolete = 1; -- Tivat: Borrelia Burgdorferi IgM
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gliadin-iga-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.is_obsolete = 1; -- Podgorica: Glijadin IgA antitela
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gliadin-iga-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Glijadin IgA antitela
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gliadin-iga-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-tivat'
   SET r.is_obsolete = 1; -- Tivat: Glijadin IgA antitela
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'gliadin-iga-antibodies'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.is_obsolete = 1; -- Budva: Glijadin IgA antitela
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hiv-ag-ab'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-podgorica'
   SET r.is_obsolete = 1; -- Podgorica: HIV Ag-Ab
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hiv-ag-ab'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: HIV Ag-Ab
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hiv-ag-ab'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-tivat'
   SET r.is_obsolete = 1; -- Tivat: HIV Ag-Ab
UPDATE clinic_lab_tests r
  JOIN lab_tests e ON e.id = r.lab_test_id AND e.slug = 'hiv-ag-ab'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-budva'
   SET r.is_obsolete = 1; -- Budva: HIV Ag-Ab
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'blood-vessels-doppler'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Dopler krvnih sudova
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-specialist-examination-type-1'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Kontrolni specijalistički pregled 1
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'follow-up-specialist-examination-type-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Kontrolni specijalistički pregled 2
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'professor-cardiologist-examination'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Profesorski pregled kardiologa
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'specialist-examination-type-1'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Specijalistički pregled 1
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'specialist-examination-type-2'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Specijalistički pregled 2
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'specialist-examination-type-3'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Specijalistički pregled 3
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'specialist-examination-with-additional-service'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Specijalistički pregled sa dodatnom medicinskom uslugom
UPDATE clinic_medical_services r
  JOIN medical_services e ON e.id = r.medical_service_id AND e.slug = 'specialist-examination-with-two-additional-services'
  JOIN clinics c ON c.id = r.clinic_id AND c.slug = 'milmedika-niksic'
   SET r.is_obsolete = 1; -- Nikšić: Specijalistički pregled sa dvije dodatne medicinske usluge

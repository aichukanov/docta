SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 051: хвосты импорта Moj Lab (2026-10-05).
--
-- 1. PH опухоли кожи. В прайсе In Vitro (invitro.co.me/cjenovnik.php, 2026-10-05) строка
--    «PH tumora kože (sljedeći uzorci po 15)» — 30 €: первый образец 30 €, каждый
--    следующий 15 €. При импорте In Vitro обе цены слиплись в одну запись
--    histopathology-skin-tumor-additional-samples-15 с ценой 30. Справка к этой записи
--    (lab_test_reference_info) описывает именно следующие образцы, поэтому:
--      * запись → «каждый следующий образец» (чистое название, slug без «-15», 301 со старого);
--        у In Vitro на ней цена 15 вместо 30;
--      * новая запись histopathology-skin-tumor — первый образец, у In Vitro 30;
--      * Moj Lab: «Biopsija tumora kože» / «Ph tumora kože» (первый образец) переезжают с
--        услуги histopathology-of-skin-tumor (КЦЦГ) на новую запись анализа — так же, как
--        остальная патогистология сети; «svaki sledeći uzorak» уже висит на переименованной.
--    Межкаталожная пара histopathology-of-skin-tumor (услуга) / histopathology-skin-tumor
--    (анализ) остаётся — это общий вопрос «PH в двух каталогах», не этой миграции.
--
-- 2. Натрий в моче. Импорт Poliklinika Diagnostica (в проде 2026-10-04) завёл
--    sodium-in-urine (разовая моча); у Diagnostica обе записи с разными ценами, значит это
--    разные анализы. «Urin - Natrijum» у Moj Lab без пометки 24h → разовая моча.
--    Калий, цитраты, оксалаты: записи по разовой моче нет — остаются на суточной (правило A).
--
-- 3. double-test / double-test-first-trimester-screening — дубль: ни одна клиника не держит
--    обе. Основная — длинная запись (как у triple test в 050); в неё же пишет неприменённый
--    insert-clinic-prices-vase-zdravlje-podgorica.sql, а в Codra и Tesla slug поправлен.
--
-- Идемпотентно: переименование — по старому slug, перенос строк — INSERT IGNORE + DELETE
-- по конкретным парам, слияние — процедурой (пропускает уже слитое). Клиники только по slug.

START TRANSACTION;

-- ═══ 1a. Запись «-15» → каждый следующий образец ═══

INSERT INTO slug_redirects (entity_type, old_slug, entity_id)
SELECT 'labtests', 'histopathology-skin-tumor-additional-samples-15', id
FROM lab_tests WHERE slug = 'histopathology-skin-tumor-additional-samples-15'
ON DUPLICATE KEY UPDATE entity_id = VALUES(entity_id);

UPDATE lab_tests
SET slug = 'histopathology-skin-tumor-each-additional-sample',
	name_en = 'Histopathology Skin Tumor (Each Additional Sample)',
	name_sr = 'PH tumora kože (svaki sljedeći uzorak)',
	name_sr_cyrl = 'ПХ тумора коже (сваки сљедећи узорак)',
	name_ru = 'Патогистологическое исследование опухоли кожи (каждый следующий образец)',
	name_de = 'Histopathologie Hauttumor (jede weitere Probe)',
	name_tr = 'Histopatoloji deri tümörü (her ek örnek)'
WHERE slug = 'histopathology-skin-tumor-additional-samples-15';

-- ═══ 1b. Новая запись — первый образец ═══

INSERT INTO lab_tests (name_en, slug, name_sr, name_sr_cyrl, name_ru, name_de, name_tr) VALUES
('Histopathology Skin Tumor', 'histopathology-skin-tumor', 'PH tumora kože', 'ПХ тумора коже',
	'Патогистологическое исследование опухоли кожи', 'Histopathologie Hauttumor', 'Histopatoloji deri tümörü')
ON DUPLICATE KEY UPDATE name_en = name_en;

INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
SELECT id, 24 FROM lab_tests WHERE slug = 'histopathology-skin-tumor';

-- ═══ 1c. In Vitro: 30 € — первый образец, 15 € — следующий ═══

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price, price_max, code, is_price_outdated, is_obsolete)
SELECT x.clinic_id, n.id, x.price, x.price_max, x.code, x.is_price_outdated, x.is_obsolete
FROM clinic_lab_tests x
JOIN clinics c ON c.id = x.clinic_id
JOIN lab_tests o ON o.id = x.lab_test_id AND o.slug = 'histopathology-skin-tumor-each-additional-sample'
JOIN lab_tests n ON n.slug = 'histopathology-skin-tumor'
WHERE c.slug IN ('in-vitro-podgorica', 'in-vitro-plus-podgorica', 'in-vitro-z-podgorica')
	AND x.price = 30.00;

UPDATE clinic_lab_tests x
JOIN clinics c ON c.id = x.clinic_id
JOIN lab_tests o ON o.id = x.lab_test_id AND o.slug = 'histopathology-skin-tumor-each-additional-sample'
SET x.price = 15.00
WHERE c.slug IN ('in-vitro-podgorica', 'in-vitro-plus-podgorica', 'in-vitro-z-podgorica')
	AND x.price = 30.00;

-- ═══ 1d. Moj Lab: первый образец — на анализ, с услуги КЦЦГ снять ═══

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price)
SELECT c.id, lt.id, NULL
FROM clinics c JOIN lab_tests lt ON lt.slug = 'histopathology-skin-tumor'
WHERE c.slug IN ('moj-lab-laboratorija-podgorica-moskovska', 'moj-lab-laboratorija-city-kvart', 'moj-lab-laboratorija-budva', 'moj-lab-laboratorija-ulcinj', 'moj-lab-laboratorija-cetinje', 'moj-lab-laboratorija-herceg-novi', 'moj-lab-laboratorija-kotor', 'moj-lab-laboratorija-niksic', 'moj-lab-laboratorija-tivat');

DELETE x FROM clinic_medical_services x
JOIN clinics c ON c.id = x.clinic_id
JOIN medical_services ms ON ms.id = x.medical_service_id
WHERE ms.slug = 'histopathology-of-skin-tumor'
	AND c.slug IN ('moj-lab-laboratorija-podgorica-moskovska', 'moj-lab-laboratorija-city-kvart', 'moj-lab-laboratorija-budva', 'moj-lab-laboratorija-ulcinj', 'moj-lab-laboratorija-cetinje', 'moj-lab-laboratorija-herceg-novi', 'moj-lab-laboratorija-kotor', 'moj-lab-laboratorija-niksic', 'moj-lab-laboratorija-tivat')
	AND x.price IS NULL;

-- ═══ 2. Moj Lab: натрий в разовой моче ═══

INSERT IGNORE INTO clinic_lab_tests (clinic_id, lab_test_id, price)
SELECT c.id, lt.id, NULL
FROM clinics c JOIN lab_tests lt ON lt.slug = 'sodium-in-urine'
WHERE c.slug IN ('moj-lab-laboratorija-podgorica-moskovska', 'moj-lab-laboratorija-city-kvart', 'moj-lab-laboratorija-budva', 'moj-lab-laboratorija-ulcinj', 'moj-lab-laboratorija-cetinje', 'moj-lab-laboratorija-herceg-novi', 'moj-lab-laboratorija-kotor', 'moj-lab-laboratorija-niksic', 'moj-lab-laboratorija-tivat')
	AND EXISTS (
		SELECT 1 FROM clinic_lab_tests y JOIN lab_tests o ON o.id = y.lab_test_id
		WHERE y.clinic_id = c.id AND o.slug = 'sodium-in-24h-urine' AND y.price IS NULL
	);

DELETE x FROM clinic_lab_tests x
JOIN clinics c ON c.id = x.clinic_id
JOIN lab_tests lt ON lt.id = x.lab_test_id
WHERE lt.slug = 'sodium-in-24h-urine'
	AND c.slug IN ('moj-lab-laboratorija-podgorica-moskovska', 'moj-lab-laboratorija-city-kvart', 'moj-lab-laboratorija-budva', 'moj-lab-laboratorija-ulcinj', 'moj-lab-laboratorija-cetinje', 'moj-lab-laboratorija-herceg-novi', 'moj-lab-laboratorija-kotor', 'moj-lab-laboratorija-niksic', 'moj-lab-laboratorija-tivat')
	AND x.price IS NULL
	AND EXISTS (SELECT 1 FROM lab_tests n WHERE n.slug = 'sodium-in-urine');

COMMIT;

-- ═══ 3. double-test → double-test-first-trimester-screening ═══
-- Процедура — копия из 050 (DDL процедур вне транзакции).

DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;

DELIMITER $$

CREATE PROCEDURE dedup_merge_lab_test(IN p_primary INT, IN p_secondary INT)
BEGIN
	IF (SELECT COUNT(*) FROM lab_tests WHERE id IN (p_primary, p_secondary)) = 2 THEN

		-- 1. Связи с клиниками
		INSERT IGNORE INTO clinic_lab_tests
			(lab_test_id, clinic_id, price, price_max, code, is_price_outdated, is_obsolete)
		SELECT p_primary, clinic_id, price, price_max, code, is_price_outdated, is_obsolete
		  FROM clinic_lab_tests
		 WHERE lab_test_id = p_secondary;

		-- 1.1 Клиника висела на обоих анализах — дозаполняем пустые поля
		UPDATE clinic_lab_tests p
		  JOIN clinic_lab_tests s
		    ON s.clinic_id = p.clinic_id AND s.lab_test_id = p_secondary
		   SET p.is_price_outdated = CASE
		           WHEN p.price IS NULL AND s.price IS NOT NULL THEN s.is_price_outdated
		           ELSE p.is_price_outdated
		       END,
		       p.price     = COALESCE(p.price, s.price),
		       p.price_max = COALESCE(p.price_max, s.price_max),
		       p.code      = COALESCE(p.code, s.code),
		       -- строка актуальна, если актуальна хотя бы одна из двух (045)
		       p.is_obsolete = LEAST(p.is_obsolete, s.is_obsolete)
		 WHERE p.lab_test_id = p_primary;

		-- 2. Категории
		INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
		SELECT p_primary, category_id
		  FROM lab_test_categories_relations
		 WHERE lab_test_id = p_secondary;

		-- 3. Синонимы. UNIQUE стоит на (another_name, language), смена
		-- lab_test_id его не задевает — обычного UPDATE достаточно.
		UPDATE lab_test_synonyms SET lab_test_id = p_primary WHERE lab_test_id = p_secondary;

		-- 4. Названия дубликата — в синонимы основного анализа
		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_en), 'en'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_en, '')) NOT IN ('', TRIM(COALESCE(p.name_en, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr), 'sr'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr, '')) NOT IN ('', TRIM(COALESCE(p.name_sr, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_sr_cyrl), 'sr-cyrl'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_sr_cyrl, '')) NOT IN ('', TRIM(COALESCE(p.name_sr_cyrl, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_ru), 'ru'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_ru, '')) NOT IN ('', TRIM(COALESCE(p.name_ru, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_de), 'de'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_de, '')) NOT IN ('', TRIM(COALESCE(p.name_de, '')));

		INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
		SELECT p_primary, TRIM(s.name_tr), 'tr'
		  FROM lab_tests s JOIN lab_tests p ON p.id = p_primary
		 WHERE s.id = p_secondary
		   AND TRIM(COALESCE(s.name_tr, '')) NOT IN ('', TRIM(COALESCE(p.name_tr, '')));

		-- 4.1 Справочный контент
		UPDATE IGNORE lab_test_reference_info
		   SET lab_test_id = p_primary
		 WHERE lab_test_id = p_secondary;

		-- 4.2 Тарифы ФЗОЦГ
		UPDATE medical_service_tariffs
		   SET lab_test_id = p_primary
		 WHERE lab_test_id = p_secondary;

		-- 5. Связи дубликата
		DELETE FROM clinic_lab_tests WHERE lab_test_id = p_secondary;
		DELETE FROM lab_test_categories_relations WHERE lab_test_id = p_secondary;

		-- 6. Редиректы
		UPDATE lab_test_redirects SET new_id = p_primary WHERE new_id = p_secondary;
		INSERT IGNORE INTO lab_test_redirects (old_id, new_id) VALUES (p_secondary, p_primary);

		-- 6.1 Слаг дубликата
		INSERT IGNORE INTO slug_redirects (entity_type, old_slug, entity_id)
		SELECT 'labtests', slug, p_primary
		  FROM lab_tests
		 WHERE id = p_secondary AND slug IS NOT NULL AND slug <> '';

		-- 7. Удаляем дубликат
		DELETE FROM lab_tests WHERE id = p_secondary;
	END IF;
END$$

CREATE PROCEDURE dedup_merge_lab_test_by_slug(IN p_primary VARCHAR(280), IN p_secondary VARCHAR(280))
BEGIN
	DECLARE v_primary INT DEFAULT NULL;
	DECLARE v_secondary INT DEFAULT NULL;
	-- Параметр берёт коллацию БАЗЫ на момент CREATE PROCEDURE, а она на
	-- локальной и прод-БД разная (0900_ai_ci / unicode_ci) — без явного
	-- COLLATE локально ERROR 1267.
	SET v_primary = (SELECT id FROM lab_tests WHERE slug = p_primary COLLATE utf8mb4_unicode_ci);
	SET v_secondary = (SELECT id FROM lab_tests WHERE slug = p_secondary COLLATE utf8mb4_unicode_ci);
	IF v_primary IS NOT NULL AND v_secondary IS NOT NULL AND v_primary <> v_secondary THEN
		CALL dedup_merge_lab_test(v_primary, v_secondary);
	END IF;
END$$

DELIMITER ;

CALL dedup_merge_lab_test_by_slug('double-test-first-trimester-screening', 'double-test');

DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;

-- ═══ VERIFICATION ═══

-- PH опухоли кожи: In Vitro 30 / 15, Moj Lab NULL / NULL
SELECT lt.slug, c.slug AS clinic, x.price
FROM clinic_lab_tests x JOIN lab_tests lt ON lt.id = x.lab_test_id JOIN clinics c ON c.id = x.clinic_id
WHERE lt.slug IN ('histopathology-skin-tumor', 'histopathology-skin-tumor-each-additional-sample')
	AND (c.slug LIKE 'in-vitro%' OR c.slug = 'moj-lab-laboratorija-kotor')
ORDER BY lt.slug, c.slug;

-- Moj Lab: услуга КЦЦГ снята (ожидается 0), натрий: 24h — 0, разовая — 9
SELECT
	(SELECT COUNT(*) FROM clinic_medical_services x JOIN clinics c ON c.id = x.clinic_id JOIN medical_services ms ON ms.id = x.medical_service_id
	 WHERE ms.slug = 'histopathology-of-skin-tumor' AND c.slug LIKE 'moj-lab-laboratorija-%') AS mojlab_skin_service,
	(SELECT COUNT(*) FROM clinic_lab_tests x JOIN clinics c ON c.id = x.clinic_id JOIN lab_tests lt ON lt.id = x.lab_test_id
	 WHERE lt.slug = 'sodium-in-24h-urine' AND c.slug LIKE 'moj-lab-laboratorija-%') AS mojlab_sodium_24h,
	(SELECT COUNT(*) FROM clinic_lab_tests x JOIN clinics c ON c.id = x.clinic_id JOIN lab_tests lt ON lt.id = x.lab_test_id
	 WHERE lt.slug = 'sodium-in-urine' AND c.slug LIKE 'moj-lab-laboratorija-%') AS mojlab_sodium_spot;

-- double-test слит (ожидается пусто), редиректы со старых слагов
SELECT slug AS still_exists FROM lab_tests WHERE slug IN ('double-test', 'histopathology-skin-tumor-additional-samples-15');
SELECT r.old_slug, lt.slug AS target FROM slug_redirects r JOIN lab_tests lt ON lt.id = r.entity_id
WHERE r.entity_type COLLATE utf8mb4_unicode_ci = 'labtests'
	AND r.old_slug COLLATE utf8mb4_unicode_ci IN ('double-test', 'histopathology-skin-tumor-additional-samples-15');

-- Лаборатории Moj Lab: анализов 703 + 1 = 704, услуг 7 − 1 = 6, цен 0
SELECT c.slug,
	(SELECT COUNT(*) FROM clinic_lab_tests x WHERE x.clinic_id = c.id) AS lab_tests,
	(SELECT COUNT(*) FROM clinic_medical_services x WHERE x.clinic_id = c.id) AS services,
	(SELECT COUNT(*) FROM clinic_lab_tests x WHERE x.clinic_id = c.id AND x.price IS NOT NULL) AS with_price
FROM clinics c WHERE c.slug LIKE 'moj-lab-laboratorija-%' ORDER BY c.slug;

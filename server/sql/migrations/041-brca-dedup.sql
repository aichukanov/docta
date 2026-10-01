SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 041: BRCA — один наследственный тест на трёх записях каталога.
--
-- Сверено с продом и первоисточниками 2026-10-01.
--
--   brca1-brca2-genetic-test (1783) «BRCA1 / BRCA2 – genetski test» — Milmedika
--       ×4, есть справка. ОСНОВНАЯ.
--   sentis-panel-brca-1-2 (1136) «Sentis panel BRCA 1-2» — Novi Standard (64),
--       590 €. Sentis — торговая марка генетических панелей лаборатории
--       Ginekaliks (Белград), «BRCA 1-2» у них — тест на 2 гена, BRCA1 и BRCA2
--       по крови. Тот же анализ → сливается в 1783, название уходит в синонимы
--       (поиск по «Sentis» продолжит находить).
--   brca1-brca2 (1409) «BRCA1 BRCA2» — Novi Standard, 0.01 €. В прайсе клиники
--       (08.04.2025.Cenovnik - Novi Standard.PDF, стр. 7, блок PCR II) так и
--       напечатано: «eK BRCA1, BRCA2 0.01». Это не ошибка распознавания:
--       0.01 во всём прайсе стоит ровно у двух строк, обе BRCA. Клиника так
--       заводит наборы — составная позиция за 0.01, полная сумма на другой
--       строке; для наследственного теста это строка Sentis BRCA за 590 € (тот
--       же материал eK). Строка-заглушка удаляется, запись сливается в 1783.
--
--   brca1-2-somatic-mutations (1410) — НЕ дубль: соматические мутации ищут в
--       ткани опухоли (материал KAL), под решение о PARP-ингибиторах. Остаётся
--       отдельной. В прайсе та же заглушка 0.01, пары с полной суммой нет →
--       цена NULL («цена неизвестна»). Последняя опубликованная цифра —
--       1090 € на standard.me/cjenovnik (Wayback, 27.03.2025), но она старше
--       прайса с заглушкой, ставить её нельзя. В названии потерян слэш:
--       «BRCA1 2» → «BRCA1/2».
--
--   Milmedika Budva: на milmedika.com/cjenovnik/milmedika-budva тест стоит
--       100 €, на проде 140. Остальные филиалы сходятся с сайтом
--       (Подгорица 100, Никшич 100, Porto Montenegro/Тиват 280).
--
-- Процедура слияния — копия из 039 (там она удаляется в конце файла).

-- ═══ 1. Заглушка 0.01 у клиники 64 ═══

DELETE clt FROM clinic_lab_tests clt
  JOIN lab_tests lt ON lt.id = clt.lab_test_id
 WHERE lt.slug = 'brca1-brca2'
   AND clt.clinic_id = 64
   AND clt.price = 0.01;

-- ═══ 2. Слияния ═══

DROP PROCEDURE IF EXISTS dedup_merge_lab_test;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;

DELIMITER $$

CREATE PROCEDURE dedup_merge_lab_test(IN p_primary INT, IN p_secondary INT)
BEGIN
	IF (SELECT COUNT(*) FROM lab_tests WHERE id IN (p_primary, p_secondary)) = 2 THEN

		-- 1. Связи с клиниками
		INSERT IGNORE INTO clinic_lab_tests
			(lab_test_id, clinic_id, price, price_max, code, is_price_outdated)
		SELECT p_primary, clinic_id, price, price_max, code, is_price_outdated
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
		       p.code      = COALESCE(p.code, s.code)
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

-- Sentis первым: строка клиники 64 за 590 € переезжает на основную запись
CALL dedup_merge_lab_test_by_slug('brca1-brca2-genetic-test', 'sentis-panel-brca-1-2');
-- заглушка уже удалена в шаге 1, сливаются только название и категория
CALL dedup_merge_lab_test_by_slug('brca1-brca2-genetic-test', 'brca1-brca2');

DROP PROCEDURE IF EXISTS dedup_merge_lab_test_by_slug;
DROP PROCEDURE IF EXISTS dedup_merge_lab_test;

-- ═══ 3. Соматические мутации ═══

UPDATE lab_tests
   SET name_en      = 'BRCA1/2 Somatic Mutations',
       name_sr      = 'BRCA1/2 somatske mutacije',
       name_sr_cyrl = 'BRCA1/2 соматске мутације',
       name_ru      = 'BRCA1/2 соматические мутации',
       name_de      = 'BRCA1/2 somatische Mutationen',
       name_tr      = 'BRCA1/2 Somatik Mutasyonlar'
 WHERE slug = 'brca1-2-somatic-mutations';

UPDATE clinic_lab_tests clt
  JOIN lab_tests lt ON lt.id = clt.lab_test_id
   SET clt.price = NULL
 WHERE lt.slug = 'brca1-2-somatic-mutations'
   AND clt.clinic_id = 64
   AND clt.price = 0.01;

-- ═══ 4. Milmedika Budva ═══

UPDATE clinic_lab_tests clt
  JOIN lab_tests lt ON lt.id = clt.lab_test_id
   SET clt.price = 100.00
 WHERE lt.slug = 'brca1-brca2-genetic-test'
   AND clt.clinic_id = 4
   AND clt.price = 140.00;

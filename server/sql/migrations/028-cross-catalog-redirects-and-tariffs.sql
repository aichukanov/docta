-- Подготовка к переносу анализов из каталога услуг в каталог анализов
-- (миграция 029). Схема + две возможности, которых сейчас нет.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/028-cross-catalog-redirects-and-tariffs.sql
--
-- Применять ДО 029 и вместе с правками кода из той же ветки:
--   server/common/redirect/slug-redirects.ts  — учитывает target_entity_type
--   server/common/tariffs.ts                  — общий загрузчик тарифов
--   server/api/labtests/details.ts            — отдаёт тарифы
--   pages/labtests/[labTestSlug]/index.vue    — показывает вкладку с тарифами
--
-- Скрипт идемпотентен: обе колонки добавляются только если их ещё нет.
--
-- 1. slug_redirects.target_entity_type
--    checkSlugRedirect собирает адрес как `/${entityType}/${targetSlug}`, то
--    есть 301 всегда оставался внутри своего каталога. Для переезда
--    /services/urine-culture → /labtests/urine-culture нужен явный тип цели.
--    NULL = цель того же типа, что и old_slug (все 46 существующих строк).
--
-- 2. medical_service_tariffs.lab_test_id
--    Коды ФЗОЦГ разделов K01/K02/L01/Z01 — это лабораторные позиции
--    (Urinokultura, Koprokultura, Diferencijalna krvna slika). Пока тариф
--    умеет ссылаться только на medical_services, после переезда 23 такие
--    строки отвязались бы по SET NULL и перестали вести на карточку.
--    Ссылка идёт максимум в один каталог; почему это соглашение, а не
--    ограничение БД — см. комментарий в конце файла.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

-- ---------------------------------------------------------------------------
-- 1. slug_redirects.target_entity_type
-- ---------------------------------------------------------------------------

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.COLUMNS
	  WHERE TABLE_SCHEMA = DATABASE()
	    AND TABLE_NAME = 'slug_redirects'
	    AND COLUMN_NAME = 'target_entity_type') = 0,
	'ALTER TABLE `slug_redirects`
		ADD COLUMN `target_entity_type` varchar(50) DEFAULT NULL
		COMMENT ''Каталог, в котором лежит цель. NULL = тот же, что entity_type''
		AFTER `entity_id`',
	'SELECT ''slug_redirects.target_entity_type already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------------------------------------------------------------------------
-- 2. medical_service_tariffs.lab_test_id
-- ---------------------------------------------------------------------------

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.COLUMNS
	  WHERE TABLE_SCHEMA = DATABASE()
	    AND TABLE_NAME = 'medical_service_tariffs'
	    AND COLUMN_NAME = 'lab_test_id') = 0,
	'ALTER TABLE `medical_service_tariffs`
		ADD COLUMN `lab_test_id` int DEFAULT NULL
		COMMENT ''Позиция прайса лабораторная — ссылка на lab_tests вместо medical_services''
		AFTER `medical_service_id`',
	'SELECT ''medical_service_tariffs.lab_test_id already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.STATISTICS
	  WHERE TABLE_SCHEMA = DATABASE()
	    AND TABLE_NAME = 'medical_service_tariffs'
	    AND INDEX_NAME = 'idx_lab_test_id') = 0,
	'ALTER TABLE `medical_service_tariffs` ADD KEY `idx_lab_test_id` (`lab_test_id`)',
	'SELECT ''idx_lab_test_id already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- FK повторяет поведение medical_service_id: удалили запись каталога —
-- тариф остаётся, но отвязывается.
SET @sql = IF(
	(SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
	  WHERE TABLE_SCHEMA = DATABASE()
	    AND TABLE_NAME = 'medical_service_tariffs'
	    AND CONSTRAINT_NAME = 'fk_medical_service_tariffs_lab_test') = 0,
	'ALTER TABLE `medical_service_tariffs`
		ADD CONSTRAINT `fk_medical_service_tariffs_lab_test`
		FOREIGN KEY (`lab_test_id`) REFERENCES `lab_tests` (`id`) ON DELETE SET NULL',
	'SELECT ''fk_medical_service_tariffs_lab_test already exists'''
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Правило «тариф ведёт максимум в один каталог» держится соглашением, а не
-- ограничением БД.
--
-- Здесь стоял CHECK (`medical_service_id` IS NULL OR `lab_test_id` IS NULL),
-- и MySQL 8 его не принимает:
--   ERROR 3823: Column 'lab_test_id' cannot be used in a check constraint
--   ... needed in a foreign key constraint ... referential action
-- Колонку, по которой у внешнего ключа стоит ON DELETE SET NULL, в CHECK
-- использовать нельзя — а SET NULL здесь нужнее: удаление записи каталога
-- не должно уносить строку прайса. Под это правило попадают ОБЕ колонки,
-- так что переписать условие нельзя, только отказаться от одного из двух.
--
-- Чем инвариант держится на самом деле:
--   * миграция 029 в каждом переносе присваивает одну ссылку и обнуляет
--     вторую ОДНИМ UPDATE, промежуточного состояния не возникает;
--   * server/common/tariffs.ts читает строго по одной колонке за запрос,
--     так что даже нарушенная строка не покажется в двух каталогах сразу.
-- Триггер сюда не ставим: в этой базе нет ни одного триггера и ни одного
-- CHECK, и заводить первый ради подстраховки одной колонки несоразмерно.
--
-- Проверить, что правило не нарушено:
--   SELECT id, code FROM medical_service_tariffs
--    WHERE medical_service_id IS NOT NULL AND lab_test_id IS NOT NULL;

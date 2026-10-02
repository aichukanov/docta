-- 044: перевести восемь таблиц и саму базу в utf8mb4_unicode_ci.
--
-- Run: на проде и локально; повторный запуск безопасен (CONVERT на таблице,
-- которая уже в unicode_ci, ничего не меняет).
--
-- ЗАЧЕМ. В базе жили две коллации: 68 таблиц в unicode_ci и восемь в
-- 0900_ai_ci (дефолт MySQL 8 — таблицы создавались без COLLATE). Любое
-- сравнение колонок между ними падало с ERROR 1267/1271, пойманы 029, 031, 043.
-- Коллация базы локально 0900_ai_ci, на проде unicode_ci — от неё зависят
-- колонки CREATE TABLE без COLLATE и параметры процедур (041). После 044 обе
-- базы однородны. Правила — docs/rules/SQL_COLLATIONS.md.
--
-- РИСКИ, сверено по дампу прода 2026-10-01:
--   * Строки в уникальных ключах — только lab_test_synonyms (another_name,
--     language) и slug_redirects (entity_type, old_slug). Коллизий после
--     перевода нет: хвостовых пробелов (unicode_ci — PAD SPACE) и невидимых
--     символов нет, слаги — только [a-z0-9-]. Точная проверка — блок ниже.
--     Если она что-то покажет, ALTER этих таблиц упадёт с ERROR 1062 и
--     откатится целиком, данные не пострадают; эти две таблицы идут первыми,
--     чтобы при ошибке остальные не успели поменяться.
--   * Внешних ключей на строковые колонки этих таблиц нет — CONVERT их не
--     задевает.
--   * Поведение кода: поиск задаёт коллацию явно (search-collation.ts), слаги
--     ASCII. Меняется только порядок синонимов с đ в ORDER BY another_name:
--     0900_ai_ci сортирует đ как d, unicode_ci — отдельной буквой.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Коллизии после перевода. Ожидается пустой результат в обоих запросах.
SELECT another_name COLLATE utf8mb4_unicode_ci AS name,
       language COLLATE utf8mb4_unicode_ci AS lang,
       GROUP_CONCAT(id ORDER BY id) AS ids
FROM lab_test_synonyms
GROUP BY 1, 2
HAVING COUNT(*) > 1;

SELECT entity_type COLLATE utf8mb4_unicode_ci AS entity_type,
       old_slug COLLATE utf8mb4_unicode_ci AS old_slug,
       GROUP_CONCAT(id ORDER BY id) AS ids
FROM slug_redirects
GROUP BY 1, 2
HAVING COUNT(*) > 1;

ALTER TABLE lab_test_synonyms                    CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE slug_redirects                       CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE lab_test_categories                  CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE lab_test_categories_relations        CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE medical_service_categories           CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE medical_service_categories_relations CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE medical_services_specialties         CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE clinic_medical_service_doctors       CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Без имени — текущая база (docta_me из команды запуска).
ALTER DATABASE CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Проверка. Ожидается: collation_database = utf8mb4_unicode_ci, оба списка пустые.
SELECT @@collation_database AS collation_database;

SELECT TABLE_NAME, TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_TYPE = 'BASE TABLE'
  AND TABLE_COLLATION <> 'utf8mb4_unicode_ci';

SELECT TABLE_NAME, COLUMN_NAME, COLLATION_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND COLLATION_NAME IS NOT NULL AND COLLATION_NAME <> 'utf8mb4_unicode_ci';

-- 043: удалить синонимы, целиком состоящие из «?».
--
-- Run: на проде и локально; повторный запуск безопасен.
--
-- Такие строки — кириллица, вставленная в старом импорте без utf8mb4: MySQL
-- заменил каждую букву на «?». В дампе прода 2026-10-01 нашлась одна:
-- lab_test_synonyms id 133, анализ 191 (PSA), ru, '??????'. Она же есть в
-- дампах 07-19 и 09-15. Правильный синоним «ПСА» у анализа уже есть, восстанавливать
-- нечего. Ни один файл в репозитории её не вставляет — после удаления не вернётся.
--
-- Условие по содержимому, а не по id: локальные id могут не совпадать с продом.
-- В medical_service_synonyms таких строк в дампе нет, проверка — на будущее.
--
-- Два отдельных SELECT, а не UNION: lab_test_synonyms в 0900_ai_ci, а
-- medical_service_synonyms в unicode_ci — UNION их колонок падает с ERROR 1271
-- (см. docs/rules/SQL_COLLATIONS.md).

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

SELECT id, lab_test_id, another_name, language
FROM lab_test_synonyms WHERE another_name REGEXP '^[?]+$';

SELECT id, medical_service_id, another_name, language
FROM medical_service_synonyms WHERE another_name REGEXP '^[?]+$';

DELETE FROM lab_test_synonyms WHERE another_name REGEXP '^[?]+$';
SELECT ROW_COUNT() AS lab_test_synonyms_deleted;

DELETE FROM medical_service_synonyms WHERE another_name REGEXP '^[?]+$';
SELECT ROW_COUNT() AS medical_service_synonyms_deleted;

-- Чистка синонимов, совпадающих с собственным названием записи.
--
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/031-drop-self-synonyms.sql
--
-- Хвост дедупликации (027–030). Слияние переносит синонимы дубликата на
-- основную запись обычным UPDATE — и синоним, который у дубликата был
-- осмысленным, на основной записи может совпасть с её собственным названием.
-- Пример: анализ 608 «Kanabinoidi THC» держал синоним «Marijuana»; после
-- слияния в анализ 120 «Marijuana» этот синоним стал повторять само название.
--
-- На странице анализа такие строки выводятся как «также известен как», то
-- есть карточка сообщает своё же имя во второй раз.
--
-- На момент сборки: 36 строк у 23 анализов, из них 19 существовали и до
-- дедупликации (старые импорты). У услуг таких строк нет ни одной, но запрос
-- симметричный — пусть чистит оба каталога.
--
-- Скрипт идемпотентен: повторный запуск не находит ничего.
--
-- Запрос повторяет разовую чистку из duplicate-synonyms-fix.txt. COLLATE
-- обязателен: lab_test_synonyms создана в utf8mb4_0900_ai_ci, а lab_tests —
-- в utf8mb4_unicode_ci, без него сравнение падает с ERROR 1267.

SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
SET collation_connection = 'utf8mb4_unicode_ci';

DELETE syn FROM lab_test_synonyms syn
  JOIN lab_tests t ON t.id = syn.lab_test_id
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN t.name_en
           WHEN 'sr' THEN t.name_sr
           WHEN 'sr-cyrl' THEN t.name_sr_cyrl
           WHEN 'ru' THEN t.name_ru
           WHEN 'de' THEN t.name_de
           WHEN 'tr' THEN t.name_tr
           ELSE NULL
       END;

DELETE syn FROM medical_service_synonyms syn
  JOIN medical_services m ON m.id = syn.medical_service_id
 WHERE syn.another_name COLLATE utf8mb4_unicode_ci = CASE syn.language
           WHEN 'en' THEN m.name_en
           WHEN 'sr' THEN m.name_sr
           WHEN 'sr-cyrl' THEN m.name_sr_cyrl
           WHEN 'ru' THEN m.name_ru
           WHEN 'de' THEN m.name_de
           WHEN 'tr' THEN m.name_tr
           ELSE NULL
       END;

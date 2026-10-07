# Коллации в SQL-миграциях и импортах

Ошибки `ERROR 1267 Illegal mix of collations … for operation '='` и
`ERROR 1271 … for operation 'UNION'` в этом проекте — не случайность, а следствие
того, что в базе жили две коллации. Эти правила для каждого `.sql` в
`server/sql/` и для каждого генератора, который такие файлы пишет.

## Состояние: всё в `utf8mb4_unicode_ci`

Вся база — таблицы, колонки и сама схема — в `utf8mb4_unicode_ci`. Так с
миграции 044 (2026-10-02). Новое должно появляться только в ней же.

Опасность в том, что у MySQL 8 для `utf8mb4` коллация по умолчанию —
`utf8mb4_0900_ai_ci`. Всё, у чего коллация не указана явно, может её получить, и
сравнение такого значения с колонкой `unicode_ci` падает.

**История.** До 044 восемь таблиц были в `0900_ai_ci`: `lab_test_synonyms`,
`lab_test_categories`, `lab_test_categories_relations`,
`medical_service_categories`, `medical_service_categories_relations`,
`medical_services_specialties`, `clinic_medical_service_doctors`,
`slug_redirects` — их создали без `COLLATE`. Коллация самой схемы
(`@@collation_database`) на проде была `unicode_ci`, локально — `0900_ai_ci`,
поэтому часть ошибок воспроизводилась только локально. Отсюда
`COLLATE utf8mb4_unicode_ci` в выражениях старых миграций (029, 031, 041, 043,
046, 047): после 044 он ничего не делает и ничему не мешает, вычищать не нужно.

**Проверка.** На любой базе — проде, локальной, развёрнутой из старого дампа —
первый запрос должен вернуть `utf8mb4_unicode_ci`, два других — пустой результат.
Если не так, 044 на этой базе не применена (или кто-то создал таблицу без
`COLLATE`), и правила 3–4 обязательны, а не страховка.

```sql
SELECT @@collation_database;

SELECT TABLE_NAME, TABLE_COLLATION FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_TYPE = 'BASE TABLE'
  AND TABLE_COLLATION <> 'utf8mb4_unicode_ci';

SELECT TABLE_NAME, COLUMN_NAME, COLLATION_NAME FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND COLLATION_NAME IS NOT NULL AND COLLATION_NAME <> 'utf8mb4_unicode_ci';
```

Исключение, которое не нарушает однородность: поиск по названиям сравнивает в
`utf8mb4_unicode_520_ci`, явно, в самом выражении
(`server/common/search-collation.ts`). Колонки при этом остаются `unicode_ci`.

## Правила

### 1. Шапка файла — нужна и после 044

Первая исполняемая строка каждого файла:

```sql
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Коллация соединения берётся из дефолта **сервера**, а не базы, поэтому 044 её не
меняет. Без `COLLATE` литералы и `@переменные` получают `0900_ai_ci`, и
`WHERE slug = @x` падает. Флаг `--default-character-set=utf8mb4` в команде
`mysql` этого не исправляет: он задаёт кодировку, а коллацию берёт дефолтную.

`SET CHARACTER SET utf8mb4` не писать. Он сбрасывает `collation_connection` на
дефолт сервера, то есть отменяет `SET NAMES` выше. В шаблонах `docs/import/` по
историческим причинам стоят три строки — `SET NAMES … COLLATE`,
`SET CHARACTER SET`, `SET collation_connection = 'utf8mb4_unicode_ci'`. Это тоже
работает, но две первые без третьей — нет.

### 2. Новые таблицы — только `unicode_ci`

В конце DDL каждой новой постоянной таблицы:

```sql
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Таблица без этой строки возьмёт коллацию базы. После 044 это `unicode_ci`, но
полагаться на настройку базы нельзя: восемь таблиц из списка выше появились именно
так. В `CREATE TEMPORARY TABLE` — `COLLATE` на каждой строковой колонке:

```sql
CREATE TEMPORARY TABLE tmp_x (
	name_en VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL PRIMARY KEY
);
```

### 3. Параметры процедур и функций

`IN p_slug VARCHAR(280)` получает коллацию схемы на момент `CREATE PROCEDURE`.
После 044 это `unicode_ci`, но на базе без неё (локальная до 044 — `0900_ai_ci`)
`WHERE slug = p_slug` падает на первом `CALL`, а процедуры кочуют из миграции в
миграцию копированием. Внутри процедур сравнивать так:

```sql
WHERE slug = p_slug COLLATE utf8mb4_unicode_ci
```

### 4. Колонки двух таблиц с разной коллацией

После 044 таких пар нет. Если проверка выше что-то вернула, в `JOIN`, `WHERE`,
`IN (SELECT …)`, `UNION`, `CASE`, `COALESCE`, `CONCAT` между колонками этой
таблицы и остальных коллацию указывают в выражении:

```sql
WHERE syn.another_name COLLATE utf8mb4_unicode_ci = t.name_en
```

`UNION` колонок с разной коллацией падает с `ERROR 1271` — либо `COLLATE` на
колонке в каждом `SELECT`, либо отдельные `SELECT` без `UNION`.

## Перед тем как отдать файл

1. Шапка — `SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;`, без одинокого
   `SET CHARACTER SET` после неё.
2. `CREATE TABLE` — `COLLATE=utf8mb4_unicode_ci` в DDL; `CREATE TEMPORARY TABLE`
   и `CREATE PROCEDURE` — `COLLATE` у каждой строковой колонки и параметра
   или в сравнении.
3. Прогнать **локально**, до прода.

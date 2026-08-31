-- Миграция 025: индексируемый ключ сортировки услуг (medical_services.sort_rank)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/025-medical-services-sort-rank.sql
--
-- Зачем: список услуг сортируется «ручной порядок вперёд, NULL в конец»:
--
--   ORDER BY ms.sort_order IS NULL, ms.sort_order ASC, ms.rank_score DESC, ms.name_en ASC
--
-- Ведущий член здесь — выражение, поэтому индекс idx_ms_sort_order(sort_order,
-- rank_score) неприменим, и MySQL честно читал всю таблицу:
--
--   EXPLAIN ... type: ALL, key: NULL, rows: 5081, Extra: Using filesort
--
-- И так на каждой странице /services, на каждом смещении пагинации, при каждом
-- наборе фильтров (в админском списке — на всех 5237 строках сразу).
--
-- Решение: колонка sort_rank = COALESCE(sort_order, 2147483647) и индекс по
-- (sort_rank, rank_score DESC, name_en). Порядок выдачи не меняется:
-- «NULL в конец» — это ровно «NULL = максимальный int», а sort_order у нас
-- принимает значения 1..3 (проверено на проде: MIN 1, MAX 3), так что
-- столкнуться с 2147483647 нечем. Сверка старого и нового порядка на всех
-- 5237 строках дала 0 расхождений (запрос — в конце файла).
--
-- Колонка VIRTUAL, а не STORED: значение нужно только индексу, а VIRTUAL не
-- занимает места в строке и позволяет ALTER без перестроения таблицы
-- (у STORED generated column ALGORITHM=INPLACE не поддерживается).
--
-- В индекс включён name_en — третий член сортировки. Без него MySQL всё равно
-- добирал бы filesort: индекс годится для ORDER BY, только если покрывает его
-- целиком.
--
-- ВНИМАНИЕ: миграция и код едут вместе. server/api/services/list.ts и
-- server/api/services/admin-list.ts после правки сортируют по ms.sort_rank —
-- без этой миграции они упадут на «Unknown column».
--
-- collation указываем явно: utf8mb4 без COLLATE берёт дефолт сервера
-- (utf8mb4_0900_ai_ci) и ломает JOIN с существующими таблицами.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE medical_services
	ADD COLUMN sort_rank INT
		GENERATED ALWAYS AS (COALESCE(sort_order, 2147483647)) VIRTUAL NOT NULL
		COMMENT 'Ключ сортировки списка услуг: ручной порядок, NULL в конец. Только для idx_ms_sort_rank',
	ADD KEY idx_ms_sort_rank (sort_rank, rank_score DESC, name_en);

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- 1. Значения колонки: расхождений с выражением быть не должно (0)
SELECT COUNT(*) AS wrong_sort_rank
FROM medical_services
WHERE sort_rank <> COALESCE(sort_order, 2147483647);

-- 2. Порядок выдачи не изменился: 0 строк, вставших на другое место
SELECT COUNT(*) AS order_mismatches FROM (
	SELECT id, ROW_NUMBER() OVER (
		ORDER BY sort_order IS NULL, sort_order ASC, rank_score DESC, name_en ASC
	) rn FROM medical_services
) old_order JOIN (
	SELECT id, ROW_NUMBER() OVER (
		ORDER BY sort_rank ASC, rank_score DESC, name_en ASC
	) rn FROM medical_services
) new_order ON old_order.rn = new_order.rn
WHERE old_order.id <> new_order.id;

-- 3. План: ожидается type: index, key: idx_ms_sort_rank, rows: 20, без filesort
EXPLAIN SELECT ms.id FROM medical_services ms
ORDER BY ms.sort_rank ASC, ms.rank_score DESC, ms.name_en ASC
LIMIT 20 OFFSET 0;

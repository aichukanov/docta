-- Пересчёт med_medicines.rank_score — популярность лекарства для сортировки /medicines
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/recalc-med-rank-score.sql
--
-- Идемпотентен, запускать ПОСЛЕ каждого импорта реестра CInMED
-- (scripts/medicines/build-med-sql.mjs → insert-med-medicines.sql) и после
-- правки popularity_weight в med_atc_groups. Требует миграции 023.
--
-- ФОРМУЛА. Ни цены, ни рейтинга, ни геопривязки у реестра нет, поэтому
-- «популярность» собирается из четырёх сигналов, которые в данных уже есть.
--
-- base:
--   +300 / +200 / +150 / 0   режим отпуска (dispensing_mode_id)
--        Главный сигнал: без рецепта человек покупает сам, стационарный
--        препарат он не купит никогда. 300 против 200 — разрыв больше суммы
--        всех остальных слагаемых, то есть безрецептурное идёт первым
--        осознанно, а не «случайно перевесило».
--   + 10 * med_atc_groups.popularity_weight   (0..30)
--        Ручной вес терапевтической группы, см. миграцию 023.
--   +  2 * LEAST(брендов в ATC-4, 30)         (0..60)
--        Число зарегистрированных брендов в химической подгруппе — прокси
--        спроса: конкуренция идёт за то, что продаётся (ибупрофен 19 брендов,
--        парацетамол-комбинации 23, пантопразол 14, онкопрепарат — 1-2).
--   + 15 * LEAST(внешних рынков бренда, 4)    (0..60)
--        Бренд, который есть в med_foreign_products (RU/UA/TR/DE/PL/US), —
--        мировой: Nurofen, Panadol, Voltaren, Aspirin, Canesten, Xarelto.
--        Без этого слагаемого внутри семейства побеждал алфавит, и NUROFEN
--        уезжал на 40-ю страницу за локальным BLOKMAX.
--
-- штрафы (порядок выдачи, а не «важность» препарата):
--   - 25 * LEAST(позиция среди тёзок - 1, 3)  (0..75)
--        Одно брендовое семейство не занимает всю первую страницу:
--        PANADOL ADVANCE / BABY / EXTRA ADVANCE идут не подряд.
--   -  5 * LEAST(позиция в ATC-4 - 1, 8)      (0..40)
--        Разнообразие категорий: не 19 ибупрофенов подряд.
--   -500 дублю фасовки (одинаковые название + дозировка)
--        В реестре 234 такие пары (BLOKMAX 200mg дважды: 10 и 20 таблеток).
--        Пока карточки не склеены, копия уходит вглубь выдачи, а не встаёт
--        рядом с оригиналом, где читается как баг.
--
-- Диапазон: -615..450.
--
-- collation указываем явно: utf8mb4 без COLLATE берёт дефолт сервера
-- (utf8mb4_0900_ai_ci) и ломает JOIN с существующими таблицами.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP TEMPORARY TABLE IF EXISTS tmp_med_rank;

CREATE TEMPORARY TABLE tmp_med_rank AS
WITH
-- Брендов в химической подгруппе ATC-4 (M01AE = производные пропионовой
-- кислоты, N02BE = анилиды). Считаем только действующие лицензии: снятые с
-- рынка бренды спрос не показывают. LEFT(atc_code, 5) — именно ATC-4:
-- полный код (7 знаков) — это уже конкретное вещество, по нему у моно-
-- препарата всегда 1 бренд, и сигнал вырождается.
atc_brands AS (
	SELECT LEFT(atc_code, 5) AS atc4, COUNT(DISTINCT name) AS brands
	FROM med_medicines
	WHERE is_active = 1 AND atc_code IS NOT NULL
	GROUP BY LEFT(atc_code, 5)
),
-- Сколько внешних рынков знает бренд. Ключ — первое слово названия без ®/™:
-- в реестре «NUROFEN ZA DJECU», «PANADOL EXTRA ADVANCE», в зарубежных
-- данных «Nurofen Cold & Flu», «Panadol Extra» — точное совпадение имён
-- ловит только 102 бренда из 1409, по первому слову совпадений втрое больше.
intl_brands AS (
	SELECT
		LOWER(REGEXP_SUBSTR(REGEXP_REPLACE(brand_name, '[®™]', ''), '[[:alnum:]-]+')) AS brand_key,
		COUNT(DISTINCT market_code) AS markets
	FROM med_foreign_products
	GROUP BY brand_key
),
base AS (
	SELECT
		m.id,
		m.name,
		LEFT(m.atc_code, 5) AS atc4,
		LOWER(REGEXP_SUBSTR(REGEXP_REPLACE(m.name, '[®™]', ''), '[[:alnum:]-]+')) AS brand_key,
		IFNULL(m.strength, '') AS strength_key,
		CASE m.dispensing_mode_id
			WHEN 2 THEN 300 -- без рецепта
			WHEN 1 THEN 200 -- обычный рецепт
			WHEN 6 THEN 200 -- однократный рецепт
			WHEN 7 THEN 200 -- многократный рецепт
			WHEN 8 THEN 150 -- ограниченный рецепт
			WHEN 9 THEN 150 -- особый рецепт
			ELSE 0          -- стационар, здравучреждение, нет данных
		END
		+ 10 * IFNULL(g.popularity_weight, 1)
		+ 2 * LEAST(IFNULL(ab.brands, 1), 30)
		+ 15 * LEAST(IFNULL(ib.markets, 0), 4) AS base_score
	FROM med_medicines m
	LEFT JOIN med_atc_groups g ON g.id = m.atc_group_id
	LEFT JOIN atc_brands ab ON ab.atc4 = LEFT(m.atc_code, 5)
	LEFT JOIN intl_brands ib
		ON ib.brand_key = LOWER(REGEXP_SUBSTR(REGEXP_REPLACE(m.name, '[®™]', ''), '[[:alnum:]-]+'))
),
ranked AS (
	SELECT
		id,
		base_score,
		ROW_NUMBER() OVER (PARTITION BY brand_key ORDER BY base_score DESC, name, id) AS brand_rn,
		ROW_NUMBER() OVER (PARTITION BY atc4 ORDER BY base_score DESC, name, id) AS atc_rn,
		ROW_NUMBER() OVER (PARTITION BY name, strength_key ORDER BY id) AS dup_rn
	FROM base
)
SELECT
	id,
	CAST(
		base_score
		- 25 * LEAST(brand_rn - 1, 3)
		- 5 * LEAST(atc_rn - 1, 8)
		- IF(dup_rn > 1, 500, 0)
		AS SIGNED
	) AS score
FROM ranked;

ALTER TABLE tmp_med_rank ADD PRIMARY KEY (id);

UPDATE med_medicines m
JOIN tmp_med_rank t ON t.id = m.id
SET m.rank_score = t.score;

DROP TEMPORARY TABLE tmp_med_rank;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION: первые 15 действующих по популярности
-- ═══════════════════════════════════════════════════════════════

SELECT rank_score, name, strength, atc_code, dispensing_mode_id
FROM med_medicines
WHERE is_active = 1
ORDER BY rank_score DESC, name, id
LIMIT 15;

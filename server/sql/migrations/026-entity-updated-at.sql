-- Миграция 026: дата изменения услуг, анализов и лекарств клиник (updated_at)
-- Run: mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/026-entity-updated-at.sql
--
-- Зачем: в sitemap не было ни одного тега <lastmod> на ~82 тыс. URL. Это было
-- сознательно — раньше туда подставлялось время генерации файла, то есть все
-- URL разом заявляли «изменились сейчас», и такой сигнал поисковик перестаёт
-- учитывать вообще. Но цена молчания реальна: для Google lastmod — единственный
-- рычаг переобхода (IndexNow он не поддерживает), а переобход у нас узкое место.
--
-- Чтобы тег стал правдивым, нужна настоящая дата изменения строки. Выяснилось,
-- что она уже есть у большей части сущностей:
--
--   doctors.updated_at              TIMESTAMP ... ON UPDATE CURRENT_TIMESTAMP
--   clinics.updated_at              то же
--   insurance_companies.updated_at  то же
--   med_medicines.updated_at        DATETIME ... ON UPDATE CURRENT_TIMESTAMP
--   reviews.updated_at              то же (даёт дату страницам /…/reviews)
--
-- Не хватает ровно трёх таблиц — их и заводит эта миграция:
--
--   medical_services  (5237 строк)  /services/{slug} и фасеты /services
--   lab_tests         (1591)        /labtests/{slug} и фасеты /labtests
--   medications       (33)          /medications/{slug}
--
-- Определение колонки скопировано с doctors.updated_at слово в слово, чтобы у
-- одинаковых по смыслу колонок не разъезжались тип и поведение.
--
-- ВЫКАТ И МИГРАЦИЯ НЕ СВЯЗАНЫ ПО ВРЕМЕНИ. Код (server/common/sitemap/lastmod.ts)
-- перед каждой сборкой sitemap спрашивает у information_schema, есть ли колонка,
-- и пока её нет — подставляет в запрос литерал NULL: файл собирается, тег просто
-- не выводится, как и до миграции. Найденные колонки кэшируются, ненайденные
-- перепроверяются, поэтому и применение миграции на работающем сервере
-- подхватится без перезапуска. Порядок «сначала код, потом миграция» и обратный
-- одинаково безопасны.
--
-- collation указываем явно: utf8mb4 без COLLATE берёт дефолт сервера
-- (utf8mb4_0900_ai_ci) и ломает JOIN с существующими таблицами.
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════
-- PART 1: колонки
-- ═══════════════════════════════════════════════════════════════
-- Колонка добавляется в конец: MySQL 8 делает это метаданными, без
-- перестроения таблицы. ALGORITHM=INSTANT явно НЕ пишем — если движок вдруг
-- не сможет, ALTER упадёт с ошибкой вместо того, чтобы просто перестроить
-- таблицу, а перестроить 5237 строк не жалко.
--
-- Осторожно: ADD COLUMN с DEFAULT CURRENT_TIMESTAMP проставляет СУЩЕСТВУЮЩИМ
-- строкам текущее время. То есть сразу после этих трёх ALTER'ов все 6861 строка
-- утверждает, что изменилась сию секунду, — ровно та ложь, ради ухода от
-- которой всё и затевается. PART 2 идёт следом и обязателен; между ними файл
-- прерывать нельзя.

ALTER TABLE medical_services
	ADD COLUMN updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
		ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Дата изменения строки. Источник <lastmod> в sitemap';

ALTER TABLE lab_tests
	ADD COLUMN updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
		ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Дата изменения строки. Источник <lastmod> в sitemap';

ALTER TABLE medications
	ADD COLUMN updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
		ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'Дата изменения строки. Источник <lastmod> в sitemap';

-- ═══════════════════════════════════════════════════════════════
-- PART 2: backfill — что писать строкам, у которых истории правок нет
-- ═══════════════════════════════════════════════════════════════
-- Пишем created_at. Разбор вариантов:
--
-- 1. Время миграции (то, что осталось бы от DEFAULT). Отпадает: это заявление
--    «5237 услуг изменились одновременно, в 03:14 такого-то числа». Именно
--    такая неправда и выключила lastmod у сайта в прошлый раз, только теперь
--    она была бы записана в БД и жила бы до первой правки каждой строки.
--
-- 2. NULL («не знаем»). Честно, но бесполезно: тег не выводился бы у 6861 URL
--    неограниченно долго — справочные строки правят редко, и большинство из
--    них так и осталось бы без даты. Ради этого миграцию делать незачем.
--
-- 3. created_at. Заниженная, но ПРАВДИВАЯ граница: «строка существует с этого
--    момента, более поздних изменений мы не знаем». Ошибка направлена в
--    безопасную сторону — занижение приводит к тому, что бот придёт позже, а
--    завышение к тому, что он перестанет верить сигналу вообще. И оно
--    самоустраняется: первая же правка строки поставит настоящую дату через
--    ON UPDATE. Даты не вырождены — у medical_services 33 разных дня создания,
--    у lab_tests 11, так что сигнал получается различающий, а не константа.
--
-- Справочные блоки услуг и анализов (medical_service_reference_info,
-- lab_test_reference_info) в backfill НЕ подмешиваем, хотя их правка меняет
-- содержимое страницы: их дату sitemap берёт на чтении, максимумом с датой
-- сущности (getSlugLastmodMap). Иначе разово учли бы то, что дальше всё равно
-- не отслеживается: правка справки не трогает строку услуги и ON UPDATE не
-- срабатывает.
--
-- Явное присваивание сильнее ON UPDATE CURRENT_TIMESTAMP: MySQL подставляет
-- текущее время, только если колонка в SET не упомянута.

UPDATE medical_services SET updated_at = created_at;
UPDATE lab_tests SET updated_at = created_at;
UPDATE medications SET updated_at = created_at;

-- ═══════════════════════════════════════════════════════════════
-- VERIFICATION
-- ═══════════════════════════════════════════════════════════════

-- 1. Колонки заведены и совпадают с эталоном (doctors.updated_at):
--    ожидается 4 строки, у всех одинаковые column_type, is_nullable,
--    column_default и extra.
SELECT table_name, column_type, is_nullable, column_default, extra
FROM information_schema.columns
WHERE table_schema = DATABASE()
	AND column_name = 'updated_at'
	AND table_name IN ('doctors', 'medical_services', 'lab_tests', 'medications')
ORDER BY table_name;

-- 2. Backfill отработал: ни одной строки со временем миграции вместо
--    created_at. Сравнение NULL-безопасное (<=>), поэтому строка без
--    created_at тоже сойдётся — у неё и updated_at обязан быть NULL.
--    Все три числа — нули.
SELECT
	(SELECT COUNT(*) FROM medical_services
		WHERE NOT (updated_at <=> created_at)) AS services_wrong,
	(SELECT COUNT(*) FROM lab_tests
		WHERE NOT (updated_at <=> created_at)) AS labtests_wrong,
	(SELECT COUNT(*) FROM medications
		WHERE NOT (updated_at <=> created_at)) AS medications_wrong;

-- 3. Дата не выродилась в одно значение — иначе сигнал бесполезен.
--    Ожидается: services ~33 дня, labtests ~11, medications 1 (все 33 строки
--    заведены одним импортом, это правда, а не ошибка).
SELECT 'medical_services' AS t, COUNT(DISTINCT DATE(updated_at)) AS days,
	MIN(updated_at) AS oldest, MAX(updated_at) AS newest FROM medical_services
UNION ALL
SELECT 'lab_tests', COUNT(DISTINCT DATE(updated_at)), MIN(updated_at),
	MAX(updated_at) FROM lab_tests
UNION ALL
SELECT 'medications', COUNT(DISTINCT DATE(updated_at)), MIN(updated_at),
	MAX(updated_at) FROM medications;

-- 4. То, что после этого увидит sitemap: дата карточки услуги как максимум
--    из самой услуги и её справочного блока. Строк должно быть столько же,
--    сколько услуг со слагом, и у каждой — непустая дата.
SELECT COUNT(*) AS services_with_lastmod FROM (
	SELECT e.slug,
		MAX(GREATEST(e.updated_at, COALESCE(r.updated_at, e.updated_at))) AS lastmod
	FROM medical_services e
	LEFT JOIN medical_service_reference_info r ON r.medical_service_id = e.id
	WHERE e.slug IS NOT NULL AND e.slug != '' AND e.updated_at IS NOT NULL
	GROUP BY e.slug
) AS m WHERE lastmod IS NOT NULL;

-- 5. Фасетная дата — максимум по участникам выборки. Ожидается 36 категорий,
--    у всех непустой lastmod.
SELECT COUNT(*) AS categories, COUNT(lastmod) AS categories_with_lastmod FROM (
	SELECT mscr.medical_service_category_id AS categoryId,
		MAX(ms.updated_at) AS lastmod
	FROM medical_service_categories_relations mscr
	INNER JOIN medical_services ms ON ms.id = mscr.medical_service_id
	GROUP BY mscr.medical_service_category_id
) AS f;

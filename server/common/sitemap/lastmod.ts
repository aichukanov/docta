import { getConnection } from '~/server/common/db-mysql';

/**
 * `<lastmod>` в sitemap: либо настоящая дата изменения, либо ничего.
 *
 * Тег заполняется ТОЛЬКО из `updated_at` сущности (для фасетных URL —
 * максимумом по участникам выборки). Ставить туда время генерации файла нельзя:
 * поисковик доверяет `lastmod`, пока тот стабильно правдив, а сайт, у которого
 * всё всегда «изменилось сейчас», выключает себе этот сигнал целиком —
 * подробности в комментарии к `SitemapLink` (utils.ts).
 *
 * Здесь же лежит защита от рассинхронизации выката и миграции: колонки
 * `updated_at` у части таблиц заводит миграция 026, а код может уехать раньше
 * (или наоборот). Пока колонки нет, выражение подменяется литералом `NULL` —
 * запрос отрабатывает, `lastmod` просто не выводится, как и до миграции.
 */

/**
 * Таблицы, из которых берётся дата изменения. Список закрытый и попадает в SQL
 * подстановкой (`FROM ${table}`), поэтому наружу он не открыт: значения — не
 * данные из запроса, а литералы из этого файла.
 */
export const LASTMOD_TABLES = [
	'doctors',
	'clinics',
	'medical_services',
	'lab_tests',
	'med_medicines',
	'insurance_companies',
	// Не сущность каталога, а источник даты для страниц `/…/{slug}/reviews`:
	// их содержимое — отзывы, и меняет их новый отзыв, а не правка врача.
	'reviews',
] as const;

export type LastmodTable = (typeof LASTMOD_TABLES)[number];

/**
 * Кэш присутствия колонки на процесс.
 *
 * Найденное не перепроверяем — колонка не исчезает; ненайденное перепроверяем
 * КАЖДЫЙ раз, и это осознанно: иначе процесс, поднятый до применения миграции,
 * до перезапуска считал бы, что `updated_at` нигде нет. Запросы к
 * information_schema идут не чаще, чем пересобирается кэш sitemap и эндпоинтов
 * комбинаций (раз в час на ключ), так что цена перепроверки — единицы запросов
 * в час, а плата за её отсутствие — молча пустой `lastmod` до ближайшего
 * рестарта.
 */
const tablesWithUpdatedAt = new Set<string>();
let allTablesFound = false;

async function loadTablesWithUpdatedAt(): Promise<ReadonlySet<string>> {
	if (allTablesFound) {
		return tablesWithUpdatedAt;
	}

	const placeholders = LASTMOD_TABLES.map(() => '?').join(', ');
	const sql = `
		SELECT table_name AS tableName
		FROM information_schema.columns
		WHERE table_schema = DATABASE()
			AND column_name = 'updated_at'
			AND table_name IN (${placeholders});
	`;

	const connection = await getConnection();

	try {
		const [rows] = await connection.execute<any[]>(sql, [...LASTMOD_TABLES]);

		for (const row of rows as Array<{ tableName: string }>) {
			tablesWithUpdatedAt.add(row.tableName);
		}

		allTablesFound = tablesWithUpdatedAt.size === LASTMOD_TABLES.length;
	} catch (error) {
		// Sitemap важнее `lastmod`: не смогли выяснить состав колонок — считаем,
		// что дат нет, и отдаём файл без тега. Падать всей секцией из-за
		// необязательного по спецификации поля нельзя.
		console.error('sitemap lastmod: не прочитались колонки таблиц', error);
	} finally {
		await connection.end();
	}

	return tablesWithUpdatedAt;
}

/**
 * Выражение с датой изменения — или литерал `NULL`, если колонки ещё нет.
 *
 * Выражение пишется на стороне вызова, потому что только там известны алиасы
 * (`MAX(d.updated_at)`, `c.updated_at`). Указанная таблица обязана быть той
 * самой, чей `updated_at` в выражении: сверить это автоматически нельзя.
 */
export async function lastmodSql(
	table: LastmodTable,
	expression: string,
): Promise<string> {
	const tables = await loadTablesWithUpdatedAt();
	return tables.has(table) ? expression : 'NULL';
}

/**
 * Значение из БД → `Date` для `<lastmod>`.
 *
 * Строго: всё, что не разобралось в дату, превращается в `undefined`, то есть в
 * отсутствие тега. Догадываться о формате нельзя — цена ошибки здесь не пустой
 * `lastmod`, а неверный, а он хуже пустого.
 */
export function toLastmod(value: unknown): Date | undefined {
	return value instanceof Date && !Number.isNaN(value.getTime())
		? value
		: undefined;
}

/**
 * Дата изменения карточек сущности: `slug` → `updated_at`.
 *
 * Отдельным запросом, а не колонкой в списочных эндпоинтах: их выдача уходит
 * ещё и в API, где дата не нужна, да и живут они вне sitemap-а.
 *
 * `referenceTable` — таблица со справочным текстом карточки (1:1 к сущности).
 * Её правка меняет содержимое страницы, но не трогает строку сущности, поэтому
 * дату берём максимумом: без этого страницы, у которых в июле появился
 * справочный блок, отчитывались бы датой создания записи.
 */
export async function getSlugLastmodMap(
	table: LastmodTable,
	referenceTable?: { name: string; foreignKey: string },
): Promise<Map<string, Date>> {
	const result = new Map<string, Date>();

	const updatedAt = await lastmodSql(table, 'e.updated_at');
	if (updatedAt === 'NULL') {
		return result;
	}

	// GROUP BY + MAX, а не голый JOIN: если у справочной таблицы вдруг окажется
	// несколько строк на сущность, слаг задвоится и в Map попадёт та дата,
	// которая пришла последней, — а нужна максимальная.
	const join = referenceTable
		? `LEFT JOIN ${referenceTable.name} r ON r.${referenceTable.foreignKey} = e.id`
		: '';
	const value = referenceTable
		? 'MAX(GREATEST(e.updated_at, COALESCE(r.updated_at, e.updated_at)))'
		: 'MAX(e.updated_at)';

	const sql = `
		SELECT e.slug AS slug, ${value} AS updatedAt
		FROM ${table} e
		${join}
		WHERE e.slug IS NOT NULL AND e.slug != '' AND e.updated_at IS NOT NULL
		GROUP BY e.slug;
	`;

	const connection = await getConnection();

	try {
		const [rows] = await connection.execute<any[]>(sql);

		for (const row of rows as Array<{ slug: string; updatedAt: unknown }>) {
			const lastmod = toLastmod(row.updatedAt);
			if (lastmod) {
				result.set(row.slug, lastmod);
			}
		}
	} catch (error) {
		console.error(`sitemap lastmod: не прочиталась дата для ${table}`, error);
	} finally {
		await connection.end();
	}

	return result;
}

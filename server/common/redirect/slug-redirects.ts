import { executeQuery, getConnection } from '~/server/common/db-mysql';
import type { H3Event } from 'h3';

/**
 * Entity type config for slug redirect lookups
 */
const ENTITY_TYPES: Record<string, { table: string; redirectTable?: string }> =
	{
		'clinics': { table: 'clinics' },
		'doctors': { table: 'doctors', redirectTable: 'doctor_redirects' },
		'services': {
			table: 'medical_services',
			redirectTable: 'medical_service_redirects',
		},
		'labtests': { table: 'lab_tests', redirectTable: 'lab_test_redirects' },
		'medications': { table: 'medications' },
		'medicines': { table: 'med_medicines' },
		'insurance-companies': { table: 'insurance_companies' },
	};

// Таблица slug_redirects целиком в памяти.
//
// SELECT по ней уходил на КАЖДОЙ детальной странице всех семи сущностей и
// стоял ПЕРЕД остальной работой: последовательный round-trip до начала
// рендера, который в 99,9% случаев возвращает пусто. Строк в таблице
// несколько десятков — она помещается в память целиком, и тогда обычная
// страница не открывает соединение с БД вообще.
// Образец такого кэша в проекте — citiesCache в
// server/api/geo/detect-location.get.ts.
//
// TTL минута, а не час: таблица правится не только вручную — в неё пишут
// addSlugRedirect (server/common/slug-db.ts) при смене слага и merge-эндпоинты
// врачей/услуг/анализов. Пока запись не видна воркеру, старый URL отвечает 404
// вместо 301, поэтому окно держим коротким. На БД это не нагрузка: один запрос
// в минуту на воркер вместо одного на каждого посетителя. Инвалидация по
// событию тут бы не помогла — pm2 поднят в кластере, и очистился бы кэш только
// того воркера, который обработал запись.
const SLUG_REDIRECTS_CACHE_TTL_MS = 60 * 1000;

type SlugRedirectMap = Map<string, number>;

let slugRedirectsCache: { map: SlugRedirectMap; expires: number } | null = null;
// Прогрев один на всех: без этого пачка параллельных запросов сразу после
// протухания ушла бы в БД целиком.
let slugRedirectsLoading: Promise<SlugRedirectMap> | null = null;

// Разделителем берём «/»: entity_type — ключ из списка выше, слаг — [a-z0-9-],
// ни в том, ни в другом слеша нет, поэтому склейка ключа не даст коллизии.
function slugRedirectKey(entityType: string, oldSlug: string): string {
	return entityType + '/' + oldSlug;
}

async function getSlugRedirectMap(): Promise<SlugRedirectMap> {
	if (slugRedirectsCache && slugRedirectsCache.expires > Date.now()) {
		return slugRedirectsCache.map;
	}

	if (!slugRedirectsLoading) {
		slugRedirectsLoading = (async () => {
			try {
				const rows = await executeQuery<{
					entity_type: string;
					old_slug: string;
					entity_id: number;
				}>('SELECT entity_type, old_slug, entity_id FROM slug_redirects');

				const map: SlugRedirectMap = new Map();
				for (const row of rows) {
					map.set(
						slugRedirectKey(row.entity_type, row.old_slug),
						row.entity_id,
					);
				}

				slugRedirectsCache = {
					map,
					expires: Date.now() + SLUG_REDIRECTS_CACHE_TTL_MS,
				};

				return map;
			} finally {
				slugRedirectsLoading = null;
			}
		})();
	}

	return await slugRedirectsLoading;
}

/**
 * Checks if the URL needs a redirect:
 * 1. Numeric ID → current slug (301)
 * 2. Old slug → current slug (301) via slug_redirects table
 * 3. Old merged-entity ID → new entity slug (301)
 */
export async function checkSlugRedirect(
	event: H3Event,
	pathArray: string[],
): Promise<{ url: string; status: number } | null> {
	const entityType = pathArray[0];
	const config = ENTITY_TYPES[entityType];
	if (!config || !pathArray[1]) {
		return null;
	}

	const param = pathArray[1];
	const id = parseInt(param, 10);
	const isNumericId = !isNaN(id) && id > 0 && String(id) === param;

	let connection: Awaited<ReturnType<typeof getConnection>> | null = null;

	try {
		let targetSlug: string | null = null;

		if (isNumericId) {
			// Numeric ID: resolve merged-entity redirect, then look up slug
			connection = await getConnection();
			let targetId = id;
			if (config.redirectTable) {
				const [redirectRows] = await connection.execute(
					`SELECT new_id FROM ${config.redirectTable} WHERE old_id = ?`,
					[id],
				);
				const redirectRow = (redirectRows as any[])[0];
				if (redirectRow) {
					targetId = redirectRow.new_id;
				}
			}

			const [rows] = await connection.execute(
				`SELECT slug FROM ${config.table} WHERE id = ?`,
				[targetId],
			);
			targetSlug = (rows as any[])[0]?.slug || null;
		} else {
			// String param: check if it's an old slug in slug_redirects.
			// Промах (обычная страница с актуальным слагом) разрешается по кэшу
			// в памяти — соединение с БД тут не берётся вообще.
			const entityId = (await getSlugRedirectMap()).get(
				slugRedirectKey(entityType, param),
			);
			if (entityId != null) {
				connection = await getConnection();
				const [rows] = await connection.execute(
					`SELECT slug FROM ${config.table} WHERE id = ?`,
					[entityId],
				);
				targetSlug = (rows as any[])[0]?.slug || null;
			}
		}

		if (targetSlug && targetSlug !== param) {
			const { searchParams } = getRequestURL(event);
			const queryString = searchParams.toString();
			const newUrl = `/${entityType}/${targetSlug}${
				queryString ? `?${queryString}` : ''
			}`;
			return { url: newUrl, status: 301 };
		}
	} catch (error) {
		console.error('Error checking slug redirect:', error);

		// Числовой ID НИКОГДА не является канонической ссылкой: если проверку
		// выполнить не удалось, мы не знаем слаг, но точно знаем, что отдавать
		// 200 с контентом по этому URL нельзя. Раньше здесь возвращался null
		// («редирект не нужен»), и при аварии БД в мае-июне 2026 числовые URL
		// отрендерились как обычные страницы — Яндекс проиндексировал 602 таких
		// URL (42% всего индекса), см. prd/silent-200-index-hygiene.
		// 500 краулер повторит, 200 запомнит навсегда.
		if (isNumericId) {
			throw createError({
				statusCode: 500,
				statusMessage: 'Unable to resolve canonical URL',
			});
		}

		// Для обычного слага null корректен: почти всегда слаг актуальный и
		// редирект действительно не нужен. Ронять основной трафик из-за упавшей
		// проверки таблицы slug_redirects нельзя.
	} finally {
		// end() пропатчен в release(), см. db-mysql.ts. Без finally соединение
		// не возвращалось в пул при ошибке: 10 ошибок = мёртвый пул
		// (connectionLimit 10, queueLimit 0) и висящие запросы до рестарта pm2.
		await connection?.end();
	}

	return null;
}

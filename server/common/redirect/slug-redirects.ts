import { getConnection } from '~/server/common/db-mysql';
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
		connection = await getConnection();
		let targetSlug: string | null = null;

		if (isNumericId) {
			// Numeric ID: resolve merged-entity redirect, then look up slug
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
			// String param: check if it's an old slug in slug_redirects
			const [redirectRows] = await connection.execute(
				`SELECT entity_id FROM slug_redirects WHERE entity_type = ? AND old_slug = ?`,
				[entityType, param],
			);
			const redirectRow = (redirectRows as any[])[0];
			if (redirectRow) {
				const [rows] = await connection.execute(
					`SELECT slug FROM ${config.table} WHERE id = ?`,
					[redirectRow.entity_id],
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

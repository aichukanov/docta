import { getConnection } from '~/server/common/db-mysql';
import type { H3Event } from 'h3';

/**
 * Проверяет, есть ли редирект для lab test ID
 * Возвращает новый URL если есть редирект, иначе null
 */
export async function checkLabTestRedirect(
	event: H3Event,
	pathArray: string[],
): Promise<{ url: string; status: number } | null> {
	// Проверяем только /labtests/{id}
	if (pathArray[0] !== 'labtests' || !pathArray[1]) {
		return null;
	}

	const labTestId = parseInt(pathArray[1], 10);
	if (isNaN(labTestId) || labTestId <= 0) {
		return null;
	}

	try {
		const connection = await getConnection();
		const [rows] = await connection.execute(
			'SELECT new_id FROM lab_test_redirects WHERE old_id = ?',
			[labTestId],
		);
		await connection.end();

		const row = (rows as any[])[0];
		if (row) {
			const { searchParams } = getRequestURL(event);
			const queryString = searchParams.toString();
			const newUrl = `/labtests/${row.new_id}${
				queryString ? `?${queryString}` : ''
			}`;
			return { url: newUrl, status: 301 };
		}
	} catch (error) {
		console.error('Error checking lab test redirect:', error);
	}

	return null;
}

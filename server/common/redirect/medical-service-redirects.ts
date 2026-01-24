import { getConnection } from '~/server/common/db-mysql';
import type { H3Event } from 'h3';

/**
 * Проверяет, есть ли редирект для medical service ID
 * Возвращает новый URL если есть редирект, иначе null
 */
export async function checkMedicalServiceRedirect(
	event: H3Event,
	pathArray: string[],
): Promise<{ url: string; status: number } | null> {
	// Проверяем только /services/{id}
	if (pathArray[0] !== 'services' || !pathArray[1]) {
		return null;
	}

	const serviceId = parseInt(pathArray[1], 10);
	if (isNaN(serviceId) || serviceId <= 0) {
		return null;
	}

	try {
		const connection = await getConnection();
		const [rows] = await connection.execute(
			'SELECT new_id FROM medical_service_redirects WHERE old_id = ?',
			[serviceId],
		);
		await connection.end();

		const row = (rows as any[])[0];
		if (row) {
			const { searchParams } = getRequestURL(event);
			const queryString = searchParams.toString();
			const newUrl = `/services/${row.new_id}${
				queryString ? `?${queryString}` : ''
			}`;
			return { url: newUrl, status: 301 };
		}
	} catch (error) {
		console.error('Error checking medical service redirect:', error);
	}

	return null;
}

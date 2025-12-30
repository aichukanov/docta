import { getConnection } from '~/server/common/db-mysql';
import type { H3Event } from 'h3';

/**
 * Проверяет, есть ли редирект для doctor ID
 * Возвращает новый URL если есть редирект, иначе null
 */
export async function checkDoctorRedirect(
	event: H3Event,
	pathArray: string[],
): Promise<{ url: string; status: number } | null> {
	// Проверяем только /doctors/{id}
	if (pathArray[0] !== 'doctors' || !pathArray[1]) {
		return null;
	}

	const doctorId = parseInt(pathArray[1], 10);
	if (isNaN(doctorId) || doctorId <= 0) {
		return null;
	}

	try {
		const connection = await getConnection();
		const [rows] = await connection.execute(
			'SELECT new_id FROM doctor_redirects WHERE old_id = ?',
			[doctorId],
		);
		await connection.end();

		const row = (rows as any[])[0];
		if (row) {
			const { searchParams } = getRequestURL(event);
			const queryString = searchParams.toString();
			const newUrl = `/doctors/${row.new_id}${
				queryString ? `?${queryString}` : ''
			}`;
			return { url: newUrl, status: 301 };
		}
	} catch (error) {
		console.error('Error checking doctor redirect:', error);
	}

	return null;
}

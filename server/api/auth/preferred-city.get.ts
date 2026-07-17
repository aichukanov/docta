import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

/**
 * Получение сохранённого города пользователя (для сортировки клиник по расстоянию)
 * GET /api/auth/preferred-city
 */
export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	try {
		const rows = await executeQuery<{ preferred_city_id: number | null }>(
			'SELECT preferred_city_id FROM auth_users WHERE id = ?',
			[user!.id],
		);

		return createSuccessResponse(SUCCESS_CODES.PREFERRED_CITY_FETCHED, {
			cityId: rows[0]?.preferred_city_id ?? null,
		});
	} catch {
		createErrorResponse(500, ERROR_CODES.ERROR_PROCESSING_REQUEST);
	}
});

import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import { validateCityId } from '~/common/validation';

/**
 * Сохранение выбранного города пользователя (null — сброс на автоопределение)
 * POST /api/auth/update-preferred-city
 */
export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const cityId = body?.cityId ?? null;

	if (
		cityId !== null &&
		!validateCityId({ cityId }, 'api/auth/update-preferred-city')
	) {
		createErrorResponse(400, ERROR_CODES.INVALID_CITY);
	}

	try {
		await executeQuery(
			'UPDATE auth_users SET preferred_city_id = ? WHERE id = ?',
			[cityId, user!.id],
		);

		logOperation(authLogger, 'User preferred city updated', {
			userId: user!.id,
			cityId,
		});

		return createSuccessResponse(SUCCESS_CODES.PREFERRED_CITY_UPDATED, {
			cityId,
		});
	} catch (error: any) {
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Update preferred city failed', error, {
			userId: user!.id,
		});
		createErrorResponse(500, ERROR_CODES.ERROR_UPDATING_PREFERRED_CITY);
	}
});

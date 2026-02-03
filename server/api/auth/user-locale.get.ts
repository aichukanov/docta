import { getCurrentUser } from '~/server/common/auth';
import { getUserLocale } from '~/server/utils/user-locale';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

/**
 * API endpoint для получения локали пользователя
 * GET /api/auth/user-locale
 */
export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	try {
		const locale = await getUserLocale(user.id, event);

		return createSuccessResponse(SUCCESS_CODES.LOCALE_UPDATED, { locale });
	} catch (error: any) {
		createErrorResponse(500, ERROR_CODES.ERROR_PROCESSING_REQUEST);
	}
});

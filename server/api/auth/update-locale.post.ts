import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import { Language } from '~/enums/language';
import { locales } from '~/composables/use-locale';

/**
 * API endpoint для обновления предпочитаемой локали пользователя
 * POST /api/auth/update-locale
 */
export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const { locale } = body;

	// Валидация локали
	if (!locale) {
		createErrorResponse(400, ERROR_CODES.LOCALE_REQUIRED);
	}

	// Проверяем что локаль из поддерживаемых
	if (!locales.includes(locale as Language)) {
		createErrorResponse(400, ERROR_CODES.INVALID_LOCALE);
	}

	try {
		// Обновляем локаль в БД
		await executeQuery(
			'UPDATE auth_users SET preferred_locale = ? WHERE id = ?',
			[locale, user.id],
		);

		logOperation(authLogger, 'User locale updated', {
			userId: user.id,
			locale,
		});

		return createSuccessResponse(SUCCESS_CODES.LOCALE_UPDATED, { locale });
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Update locale failed', error, { userId: user.id });
		createErrorResponse(500, ERROR_CODES.ERROR_UPDATING_LOCALE);
	}
});

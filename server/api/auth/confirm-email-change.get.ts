import { validateAndApplyEmailChange } from '~/server/utils/email-change';
import { getUserByEmail } from '~/server/utils/session';
import { sendEmailChangeNotification } from '~/server/utils/email';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const query = getQuery(event);
	const token = query.token as string;

	if (!token) {
		return createErrorResponse(400, ERROR_CODES.TOKEN_NOT_FOUND);
	}

	try {
		// Получаем старый email перед изменением
		const result = await validateAndApplyEmailChange(token);

		if (!result.valid) {
			return createErrorResponse(400, result.code, result.details);
		}

		// Получаем обновленные данные пользователя
		const updatedUser = await getUserByEmail(result.data!.newEmail);

		if (updatedUser) {
			// Отправляем уведомление на старый email
			const { getUserLocale } = await import('~/server/utils/user-locale');
			const locale = await getUserLocale(updatedUser.id, event);
			await sendEmailChangeNotification(
				result.data!.oldEmail,
				result.data!.newEmail,
				updatedUser.name,
				locale,
			);
		}

		logOperation(authLogger, 'Email change confirmed', {
			userId: result.data!.userId,
			newEmail: result.data!.newEmail,
		});

		return createSuccessResponse(SUCCESS_CODES.EMAIL_CHANGED);
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Confirm email change failed', error);
		return createErrorResponse(500, ERROR_CODES.ERROR_CHANGING_EMAIL);
	}
});

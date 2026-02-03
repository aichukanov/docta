import { validateEmail } from '~/server/utils/password';
import { getUserByEmail } from '~/server/utils/session';
import {
	createPasswordResetToken,
	deleteUserPasswordResetTokens,
} from '~/server/utils/password-reset';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import { getBaseUrl } from '~/server/utils/base-url';

export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { email } = body;

	// Валидация email
	if (!email || !validateEmail(email)) {
		createErrorResponse(400, ERROR_CODES.INVALID_EMAIL);
	}

	try {
		// Получаем пользователя
		const user = await getUserByEmail(email.toLowerCase());

		// Даже если пользователь не найден, возвращаем успех
		// Это защита от enumeration атак
		if (!user) {
			authLogger.debug('Password reset requested for non-existent user', {
				email,
			});
			return createSuccessResponse(SUCCESS_CODES.PASSWORD_RESET_EMAIL_SENT);
		}

		// Проверяем есть ли у пользователя возможность входа по паролю
		if (!user.password_hash) {
			authLogger.debug('Password reset requested for user without password', {
				userId: user.id,
			});
			// Все равно возвращаем успех для безопасности
			return createSuccessResponse(SUCCESS_CODES.PASSWORD_RESET_EMAIL_SENT);
		}

		// Удаляем старые токены пользователя
		await deleteUserPasswordResetTokens(user.id);

		// Создаем новый токен
		const token = await createPasswordResetToken(user.id);

		// Формируем ссылку для сброса
		const resetUrl = `${getBaseUrl()}/reset-password?token=${token}`;

		// Отправляем email
		const { sendPasswordResetEmail } = await import('~/server/utils/email');
		const { getUserLocale } = await import('~/server/utils/user-locale');
		const locale = await getUserLocale(user.id, event);
		await sendPasswordResetEmail(user.email, resetUrl, locale);

		logOperation(authLogger, 'Password reset email sent', {
			userId: user.id,
		});

		return createSuccessResponse(SUCCESS_CODES.PASSWORD_RESET_EMAIL_SENT, {
			// В development режиме возвращаем токен для тестирования
			...(process.env.NODE_ENV === 'development' && { resetUrl }),
		});
	} catch (error: any) {
		logError(authLogger, 'Forgot password failed', error);
		createErrorResponse(500, ERROR_CODES.ERROR_PROCESSING_REQUEST);
	}
});

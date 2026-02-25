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
import { getLocalizedUrl } from '~/server/utils/base-url';

export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { email } = body;

	// Валидация email
	if (!email || !validateEmail(email)) {
		return createErrorResponse(400, ERROR_CODES.INVALID_EMAIL);
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

		// Удаляем старые токены пользователя
		await deleteUserPasswordResetTokens(user.id);

		// Создаем новый токен
		const token = await createPasswordResetToken(user.id);

		// Отправляем email
		const { sendPasswordResetEmail } = await import('~/server/utils/email');
		const { getUserLocale } = await import('~/server/utils/user-locale');
		const locale = await getUserLocale(user.id, event);
		const resetUrl = getLocalizedUrl(`/reset-password?token=${token}`, locale);

		await sendPasswordResetEmail(user.email, resetUrl, locale);

		logOperation(authLogger, 'Password reset email sent', {
			userId: user.id,
		});

		return createSuccessResponse(SUCCESS_CODES.PASSWORD_RESET_EMAIL_SENT, {
			// В development режиме возвращаем токен для тестирования
			...(import.meta.dev && { resetUrl }),
		});
	} catch (error: any) {
		logError(authLogger, 'Forgot password failed', error);
		return createErrorResponse(500, ERROR_CODES.ERROR_PROCESSING_REQUEST);
	}
});

import { getCurrentUser } from '~/server/common/auth';
import { getUserByEmail } from '~/server/utils/session';
import { validateEmail } from '~/server/utils/password';
import { createEmailChangeToken } from '~/server/utils/email-change';
import { sendEmailVerification } from '~/server/utils/email';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import { getLocalizedUrl } from '~/server/utils/base-url';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		return createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const { newEmail } = body;

	// Валидация
	if (!newEmail || !validateEmail(newEmail)) {
		return createErrorResponse(400, ERROR_CODES.INVALID_EMAIL);
	}

	const normalizedEmail = newEmail.toLowerCase();

	// Проверяем, не совпадает ли с текущим
	if (normalizedEmail === user.email.toLowerCase()) {
		return createErrorResponse(400, ERROR_CODES.EMAIL_SAME_AS_CURRENT);
	}

	try {
		// Проверяем, не занят ли email
		const existingUser = await getUserByEmail(normalizedEmail);
		if (existingUser && existingUser.id !== user.id) {
			return createErrorResponse(409, ERROR_CODES.EMAIL_ALREADY_IN_USE);
		}

		// Создаем токен для подтверждения
		const token = await createEmailChangeToken(user.id, normalizedEmail);

		// Отправляем письмо на НОВЫЙ email
		const { getUserLocale } = await import('~/server/utils/user-locale');
		const locale = await getUserLocale(user.id, event);
		const confirmUrl = getLocalizedUrl(`/confirm-email-change?token=${token}`, locale);
		await sendEmailVerification(normalizedEmail, confirmUrl, user.name, locale);

		logOperation(authLogger, 'Email change requested', {
			userId: user.id,
			newEmail: normalizedEmail,
		});

		return createSuccessResponse(SUCCESS_CODES.EMAIL_CHANGE_CONFIRMATION_SENT, {
			...(process.env.NODE_ENV === 'development' && { confirmUrl }),
		});
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Request email change failed', error, {
			userId: user.id,
		});
		return createErrorResponse(500, ERROR_CODES.ERROR_REQUESTING_EMAIL_CHANGE);
	}
});

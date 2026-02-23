import { validatePassword, hashPassword } from '~/server/utils/password';
import {
	validatePasswordResetToken,
	markTokenAsUsed,
} from '~/server/utils/password-reset';
import { executeQuery } from '~/server/common/db-mysql';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { token, password, confirmPassword } = body;

	// Валидация входных данных
	if (!token || !password || !confirmPassword) {
		return createErrorResponse(400, ERROR_CODES.ALL_FIELDS_REQUIRED);
	}

	if (password !== confirmPassword) {
		return createErrorResponse(400, ERROR_CODES.PASSWORDS_DO_NOT_MATCH);
	}

	// Валидация пароля
	const passwordValidation = validatePassword(password);
	if (!passwordValidation.valid) {
		return createErrorResponse(
			400,
			passwordValidation.code,
			passwordValidation.details,
		);
	}

	try {
		// Проверяем токен
		const result = await validatePasswordResetToken(token);

		if (!result.valid) {
			return createErrorResponse(400, result.code, result.details);
		}

		// Хешируем новый пароль
		const passwordHash = await hashPassword(password);

		// Обновляем пароль пользователя
		await executeQuery('UPDATE auth_users SET password_hash = ? WHERE id = ?', [
			passwordHash,
			result.data!.userId,
		]);

		// Помечаем токен как использованный
		await markTokenAsUsed(token);

		logOperation(authLogger, 'Password reset completed', {
			userId: result.data!.userId,
		});

		return createSuccessResponse(SUCCESS_CODES.PASSWORD_CHANGED);
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Reset password failed', error);
		return createErrorResponse(500, ERROR_CODES.ERROR_RESETTING_PASSWORD);
	}
});

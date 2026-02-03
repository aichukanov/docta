import { getCurrentUser } from '~/server/common/auth';
import { getUserByEmail } from '~/server/utils/session';
import {
	verifyPassword,
	hashPassword,
	validatePassword,
} from '~/server/utils/password';
import { executeQuery } from '~/server/common/db-mysql';
import { authLogger, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const { currentPassword, newPassword, confirmPassword } = body;

	// Валидация входных данных
	if (!newPassword || !confirmPassword) {
		createErrorResponse(400, ERROR_CODES.NEW_PASSWORD_REQUIRED);
	}

	if (newPassword !== confirmPassword) {
		createErrorResponse(400, ERROR_CODES.PASSWORDS_DO_NOT_MATCH);
	}

	// Валидация нового пароля
	const passwordValidation = validatePassword(newPassword);
	if (!passwordValidation.valid) {
		createErrorResponse(
			400,
			passwordValidation.code,
			passwordValidation.details,
		);
	}

	try {
		// Получаем полные данные пользователя
		const fullUser = await getUserByEmail(user.email);

		if (!fullUser) {
			createErrorResponse(404, ERROR_CODES.USER_NOT_FOUND);
		}

		// Если у пользователя уже есть пароль, проверяем текущий
		if (fullUser.password_hash) {
			if (!currentPassword) {
				createErrorResponse(400, ERROR_CODES.CURRENT_PASSWORD_REQUIRED);
			}

			const isPasswordValid = await verifyPassword(
				currentPassword,
				fullUser.password_hash,
			);

			if (!isPasswordValid) {
				createErrorResponse(401, ERROR_CODES.INVALID_CURRENT_PASSWORD);
			}
		}

		// Хешируем новый пароль
		const passwordHash = await hashPassword(newPassword);

		// Обновляем пароль
		await executeQuery('UPDATE auth_users SET password_hash = ? WHERE id = ?', [
			passwordHash,
			user.id,
		]);

		return createSuccessResponse(SUCCESS_CODES.PASSWORD_CHANGED);
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Change password failed', error, { userId: user.id });
		createErrorResponse(500, ERROR_CODES.ERROR_CHANGING_PASSWORD);
	}
});

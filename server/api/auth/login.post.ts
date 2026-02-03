import { verifyPassword, validateEmail } from '~/server/utils/password';
import { getUserByEmail } from '~/server/utils/session';
import { createSession, setSessionCookie } from '~/server/utils/session';
import { authLogger, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import {
	logFailedLogin,
	logSuccessfulLogin,
} from '~/server/utils/login-history';

export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { email, password } = body;

	// Валидация входных данных
	if (!email || !password) {
		createErrorResponse(400, ERROR_CODES.EMAIL_REQUIRED);
	}

	// Валидация email
	if (!validateEmail(email)) {
		createErrorResponse(400, ERROR_CODES.INVALID_EMAIL);
	}

	try {
		// Получаем пользователя
		const user = await getUserByEmail(email.toLowerCase());

		if (!user || !user.password_hash) {
			createErrorResponse(401, ERROR_CODES.INVALID_CREDENTIALS);
		}

		// Проверяем пароль
		const isPasswordValid = await verifyPassword(password, user.password_hash);

		if (!isPasswordValid) {
			// Логируем неудачную попытку
			await logFailedLogin(user.id, event, 'email', 'Invalid password');

			createErrorResponse(401, ERROR_CODES.INVALID_CREDENTIALS);
		}

		// Логируем успешный вход
		await logSuccessfulLogin(user.id, event, 'email');

		// Создаем сессию
		const sessionId = await createSession(user.id);
		setSessionCookie(event, sessionId);

		// Проверяем redirect
		const redirectTo = getCookie(event, 'auth_redirect');
		if (redirectTo && redirectTo !== '/login') {
			deleteCookie(event, 'auth_redirect');
		}

		return createSuccessResponse(SUCCESS_CODES.LOGIN_SUCCESS, {
			user: {
				id: user.id,
				email: user.email,
				name: user.name,
				username: user.username,
				photo_url: user.photo_url,
				is_admin: user.is_admin,
			},
			redirectTo: redirectTo || '/',
		});
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Login failed', error, { email });
		createErrorResponse(500, ERROR_CODES.ERROR_DURING_LOGIN);
	}
});

import {
	hashPassword,
	validateEmail,
	validatePassword,
} from '~/server/utils/password';
import { executeQuery } from '~/server/common/db-mysql';
import { createSession, setSessionCookie } from '~/server/utils/session';
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
	const { email, password, name } = body;

	// Валидация входных данных
	if (!email || !password || !name) {
		createErrorResponse(400, ERROR_CODES.ALL_FIELDS_REQUIRED);
	}

	// Валидация email
	if (!validateEmail(email)) {
		createErrorResponse(400, ERROR_CODES.INVALID_EMAIL);
	}

	// Валидация пароля
	const passwordValidation = validatePassword(password);
	if (!passwordValidation.valid) {
		createErrorResponse(
			400,
			passwordValidation.code,
			passwordValidation.details,
		);
	}

	try {
		// Проверяем существует ли пользователь с таким email
		const existingUsers = await executeQuery(
			'SELECT id FROM auth_users WHERE email = ?',
			[email.toLowerCase()],
		);

		if (existingUsers.length > 0) {
			createErrorResponse(409, ERROR_CODES.USER_ALREADY_EXISTS);
		}

		// Хешируем пароль
		const passwordHash = await hashPassword(password);

		// Создаем пользователя (email еще не подтвержден)
		const result = await executeQuery(
			`INSERT INTO auth_users (email, name, password_hash, is_admin, email_verified)
       VALUES (?, ?, ?, FALSE, FALSE)`,
			[email.toLowerCase(), name, passwordHash],
		);

		const userId = (result as any).insertId;

		// Создаем токен для подтверждения email
		const { createEmailVerificationToken } = await import(
			'~/server/utils/email-verification'
		);
		const verificationToken = await createEmailVerificationToken(
			userId,
			email.toLowerCase(),
		);

		// Отправляем email с подтверждением
		const verificationUrl = `${getBaseUrl()}/verify-email?token=${verificationToken}`;

		const { sendEmailVerification } = await import('~/server/utils/email');
		const { getUserLocale } = await import('~/server/utils/user-locale');
		const locale = await getUserLocale(userId, event);
		await sendEmailVerification(
			email.toLowerCase(),
			verificationUrl,
			name,
			locale,
		);

		logOperation(authLogger, 'User registered', {
			userId,
			email: email.toLowerCase(),
		});

		// Создаем сессию (можно войти даже с неподтвержденным email)
		const sessionId = await createSession(userId);
		setSessionCookie(event, sessionId);

		// Проверяем redirect
		const redirectTo = getCookie(event, 'auth_redirect');
		if (redirectTo && redirectTo !== '/login') {
			deleteCookie(event, 'auth_redirect');
		}

		return createSuccessResponse(SUCCESS_CODES.REGISTRATION_SUCCESS, {
			user: {
				id: userId,
				email: email.toLowerCase(),
				name,
				is_admin: false,
				email_verified: false,
			},
			redirectTo: redirectTo || '/',
			needsEmailVerification: true,
			...(process.env.NODE_ENV === 'development' && { verificationUrl }),
		});
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Registration failed', error, { email });
		createErrorResponse(500, ERROR_CODES.ERROR_CREATING_ACCOUNT);
	}
});

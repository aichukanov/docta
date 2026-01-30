import { comparePassword } from '~/server/utils/password';
import {
	createSession,
	setSessionCookie,
	getUserByEmail,
} from '~/server/utils/session';

export default defineEventHandler(async (event) => {
	const body = await readBody(event);
	const { email, password } = body;

	// Валидация входных данных
	if (!email || !password) {
		throw createError({
			statusCode: 400,
			statusMessage: 'Email and password are required',
		});
	}

	// 1. Найти пользователя по email
	const user = await getUserByEmail(email);

	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Invalid email or password',
		});
	}

	// 2. Проверить что это администратор
	if (!user.is_admin) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Invalid email or password',
		});
	}

	// 3. Проверить что у пользователя есть password_hash
	if (!user.password_hash) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Invalid email or password',
		});
	}

	// 4. Сравнить пароль с хешем
	const isPasswordValid = await comparePassword(password, user.password_hash);

	if (!isPasswordValid) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Invalid email or password',
		});
	}

	// 5. Создать сессию
	const sessionId = await createSession(user.id);

	// 6. Установить cookie
	setSessionCookie(event, sessionId);

	// 7. Вернуть данные пользователя (без password_hash)
	return {
		success: true,
		user: {
			id: user.id,
			email: user.email,
			name: user.name,
			photo_url: user.photo_url,
			is_admin: user.is_admin,
		},
	};
});

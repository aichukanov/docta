import type { H3Event } from 'h3';
import { getUserFromSession, type User } from '~/server/utils/session';

/**
 * Проверяет права доступа администратора.
 * Проверяет сессию из БД и флаг is_admin.
 * Выбрасывает ошибку 401/403 если доступ запрещён.
 */
export async function requireAdmin(event: H3Event): Promise<void> {
	// 1. Получить session_id из cookie
	const sessionId = getCookie(event, 'session_id');

	if (!sessionId) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized: No session found',
		});
	}

	// 2. Получить пользователя из сессии
	const user = await getUserFromSession(sessionId);

	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized: Invalid or expired session',
		});
	}

	// 3. Проверить, что пользователь - администратор
	if (!user.is_admin) {
		throw createError({
			statusCode: 403,
			statusMessage: 'Forbidden: Admin access required',
		});
	}

	// 4. Сохранить пользователя в контексте для дальнейшего использования
	event.context.user = user;
}

/**
 * Получает текущего пользователя из сессии (опционально).
 * Не выбрасывает ошибку, если пользователь не авторизован.
 * @returns Пользователь или null
 */
export async function getCurrentUser(event: H3Event): Promise<User | null> {
	const sessionId = getCookie(event, 'session_id');

	if (!sessionId) {
		return null;
	}

	return await getUserFromSession(sessionId);
}

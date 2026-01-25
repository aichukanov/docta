import type { H3Event } from 'h3';

/**
 * Проверяет права доступа администратора.
 * Выбрасывает ошибку 404 если доступ запрещён.
 *
 * TODO: Заменить на настоящую авторизацию
 */
export function requireAdmin(event: H3Event): void {
	const adminCookie = getCookie(event, 'adm');
	if (adminCookie !== 'xpycm') {
		throw createError({ statusCode: 404, statusMessage: 'Not found' });
	}
}

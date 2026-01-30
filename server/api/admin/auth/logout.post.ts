import { deleteSession, clearSessionCookie } from '~/server/utils/session';

export default defineEventHandler(async (event) => {
	// 1. Получить session_id из cookie
	const sessionId = getCookie(event, 'session_id');

	if (sessionId) {
		// 2. Удалить сессию из БД
		await deleteSession(sessionId);
	}

	// 3. Очистить cookie
	clearSessionCookie(event);

	return {
		success: true,
		message: 'Successfully logged out',
	};
});

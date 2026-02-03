import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { clearSessionCookie } from '~/server/utils/session';
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

	// Получаем текущую сессию
	const currentSessionId = getCookie(event, 'session_id');

	// Удаляем все сессии пользователя кроме текущей
	await executeQuery(
		'DELETE FROM auth_sessions WHERE user_id = ? AND id != ?',
		[user.id, currentSessionId],
	);

	return createSuccessResponse(SUCCESS_CODES.ALL_SESSIONS_DELETED);
});

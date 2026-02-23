import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { ERROR_CODES, createErrorResponse } from '~/server/utils/api-codes';

interface SessionInfo {
	id: string;
	created_at: string;
	expires_at: number;
	is_current: boolean;
}

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		return createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	// Получаем текущую сессию
	const currentSessionId = getCookie(event, 'session_id');

	// Получаем все активные сессии пользователя
	const auth_sessions = await executeQuery<SessionInfo>(
		`SELECT id, created_at, expires_at 
     FROM auth_sessions 
     WHERE user_id = ? AND expires_at > UNIX_TIMESTAMP()
     ORDER BY created_at DESC`,
		[user.id],
	);

	// Помечаем текущую сессию
	const sessionsWithFlag = auth_sessions.map((session) => ({
		...session,
		is_current: session.id === currentSessionId,
	}));

	return sessionsWithFlag;
});

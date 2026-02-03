import { getCurrentUser } from '~/server/common/auth';
import { deleteSession } from '~/server/utils/session';
import { executeQuery } from '~/server/common/db-mysql';
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

	const sessionId = getRouterParam(event, 'sessionId');

	if (!sessionId) {
		createErrorResponse(400, ERROR_CODES.SESSION_ID_REQUIRED);
	}

	// Проверяем что сессия принадлежит текущему пользователю
	const auth_sessions = await executeQuery(
		'SELECT user_id FROM auth_sessions WHERE id = ?',
		[sessionId],
	);

	if (auth_sessions.length === 0) {
		createErrorResponse(404, ERROR_CODES.SESSION_NOT_FOUND);
	}

	if ((auth_sessions[0] as any).user_id !== user.id) {
		createErrorResponse(403, ERROR_CODES.FORBIDDEN);
	}

	// Удаляем сессию
	await deleteSession(sessionId);

	return createSuccessResponse(SUCCESS_CODES.SESSION_DELETED);
});

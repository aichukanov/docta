import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import { authLogger, logOperation, logError } from '~/server/utils/logger';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		return createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const { name } = body;

	// Валидация
	if (!name || name.trim().length === 0) {
		return createErrorResponse(400, ERROR_CODES.NAME_EMPTY);
	}

	if (name.length > 255) {
		return createErrorResponse(400, ERROR_CODES.NAME_TOO_LONG);
	}

	try {
		// Обновляем имя
		await executeQuery('UPDATE auth_users SET name = ? WHERE id = ?', [
			name.trim(),
			user.id,
		]);

		logOperation(authLogger, 'Name updated', {
			userId: user.id,
			newName: name.trim(),
		});

		return createSuccessResponse(SUCCESS_CODES.NAME_UPDATED, {
			name: name.trim(),
		});
	} catch (error: any) {
		logError(authLogger, 'Update name failed', error, { userId: user.id });
		return createErrorResponse(500, ERROR_CODES.ERROR_UPDATING_NAME);
	}
});

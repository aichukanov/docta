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
	const { isPublic } = body || {};

	if (typeof isPublic !== 'boolean') {
		return createErrorResponse(400, ERROR_CODES.INVALID_PRIVACY_VALUE);
	}

	try {
		await executeQuery(
			'UPDATE auth_users SET is_profile_public = ? WHERE id = ?',
			[isPublic, user.id],
		);

		logOperation(authLogger, 'Privacy updated', {
			userId: user.id,
			isPublic,
		});

		return createSuccessResponse(SUCCESS_CODES.PRIVACY_UPDATED, { isPublic });
	} catch (error: any) {
		logError(authLogger, 'Update privacy failed', error, { userId: user.id });
		return createErrorResponse(500, ERROR_CODES.ERROR_UPDATING_PRIVACY);
	}
});

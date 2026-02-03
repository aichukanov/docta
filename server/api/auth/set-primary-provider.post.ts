import { getCurrentUser } from '~/server/common/auth';
import { setPrimaryOAuthProvider } from '~/server/utils/oauth-profiles';
import { authLogger, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import { isValidPrimaryProvider } from '~/server/utils/oauth-providers';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const { provider } = body;

	// Валидация провайдера
	if (!isValidPrimaryProvider(provider)) {
		createErrorResponse(400, ERROR_CODES.INVALID_PROVIDER);
	}

	try {
		await setPrimaryOAuthProvider(user.id, provider);

		return createSuccessResponse(SUCCESS_CODES.PRIMARY_PROVIDER_UPDATED);
	} catch (error) {
		logError(authLogger, 'Set primary provider failed', error, {
			userId: user.id,
		});
		createErrorResponse(500, ERROR_CODES.ERROR_UPDATING_PRIMARY_PROVIDER);
	}
});

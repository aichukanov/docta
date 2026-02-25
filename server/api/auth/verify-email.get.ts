import {
	validateEmailVerificationToken,
	markEmailAsVerified,
} from '~/server/utils/email-verification';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const query = getQuery(event);
	const token = query.token as string;

	if (!token) {
		return createErrorResponse(400, ERROR_CODES.TOKEN_NOT_FOUND);
	}

	try {
		// Проверяем токен
		const result = await validateEmailVerificationToken(token);

		if (!result.valid) {
			return createErrorResponse(400, result.error!);
		}

		// Помечаем email как подтвержденный
		await markEmailAsVerified(result.userId!, result.email!);

		logOperation(authLogger, 'Email verified', {
			userId: result.userId,
		});

		return createSuccessResponse(SUCCESS_CODES.EMAIL_VERIFIED);
	} catch (error: any) {
		// Если это уже наша ошибка, пробрасываем
		if (error.statusCode) {
			throw error;
		}

		logError(authLogger, 'Email verification failed', error);
		return createErrorResponse(500, ERROR_CODES.ERROR_VERIFYING_EMAIL);
	}
});

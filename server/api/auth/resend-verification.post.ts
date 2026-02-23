import { getCurrentUser } from '~/server/common/auth';
import {
	createEmailVerificationToken,
	deleteUserEmailVerificationTokens,
} from '~/server/utils/email-verification';
import { sendEmailVerification } from '~/server/utils/email';
import { authLogger, logOperation, logError } from '~/server/utils/logger';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import { getLocalizedUrl } from '~/server/utils/base-url';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		return createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	try {
		// Удаляем старые токены
		await deleteUserEmailVerificationTokens(user.id);

		// Создаем новый токен
		const token = await createEmailVerificationToken(user.id, user.email);

		// Отправляем email
		const { getUserLocale } = await import('~/server/utils/user-locale');
		const locale = await getUserLocale(user.id, event);
		const verificationUrl = getLocalizedUrl(`/verify-email?token=${token}`, locale);
		await sendEmailVerification(user.email, verificationUrl, user.name, locale);

		logOperation(authLogger, 'Verification email resent', {
			userId: user.id,
		});

		return createSuccessResponse(SUCCESS_CODES.VERIFICATION_EMAIL_SENT, {
			...(process.env.NODE_ENV === 'development' && { verificationUrl }),
		});
	} catch (error: any) {
		logError(authLogger, 'Resend verification failed', error, {
			userId: user.id,
		});
		return createErrorResponse(500, ERROR_CODES.ERROR_SENDING_EMAIL);
	}
});

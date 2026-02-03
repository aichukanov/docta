import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { isValidOAuthProvider } from '~/server/utils/oauth-providers';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized',
		});
	}

	const provider = getRouterParam(event, 'provider');

	if (!provider || !isValidOAuthProvider(provider)) {
		throw createError({
			statusCode: 400,
			statusMessage: 'Invalid provider',
		});
	}

	// Проверяем сколько аккаунтов привязано
	const accounts = await executeQuery(
		'SELECT COUNT(*) as count FROM auth_oauth_accounts WHERE user_id = ?',
		[user.id],
	);

	const accountCount = (accounts[0] as any).count;

	if (accountCount <= 1) {
		throw createError({
			statusCode: 400,
			statusMessage: 'Cannot unlink the only authentication method',
		});
	}

	// Отвязываем аккаунт
	await executeQuery(
		'DELETE FROM auth_oauth_accounts WHERE user_id = ? AND provider = ?',
		[user.id, provider],
	);

	return {
		success: true,
		message: `${provider} account unlinked successfully`,
	};
});

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

	// Если отвязанный провайдер был основным — назначаем нового по приоритету
	const userRow = await executeQuery(
		'SELECT primary_oauth_provider FROM auth_users WHERE id = ?',
		[user.id],
	);
	if ((userRow[0] as any)?.primary_oauth_provider === provider) {
		const remaining = await executeQuery<{ provider: string }>(
			'SELECT provider FROM auth_oauth_accounts WHERE user_id = ?',
			[user.id],
		);
		const remainingProviders = remaining.map((r: any) => r.provider);

		const priority = ['google', 'facebook', 'telegram'];
		const newPrimary =
			priority.find((p) => remainingProviders.includes(p)) ?? null;

		await executeQuery(
			'UPDATE auth_users SET primary_oauth_provider = ? WHERE id = ?',
			[newPrimary, user.id],
		);
	}

	return {
		success: true,
		message: `${provider} account unlinked successfully`,
	};
});

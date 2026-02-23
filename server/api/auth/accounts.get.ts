import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		throw createError({
			statusCode: 401,
			statusMessage: 'Unauthorized',
		});
	}

	const [oauthAccounts, userRows] = await Promise.all([
		executeQuery<{ id: number; provider: string; provider_account_id: string; created_at: string }>(
			`SELECT id, provider, provider_account_id, created_at 
			 FROM auth_oauth_accounts 
			 WHERE user_id = ?
			 ORDER BY created_at DESC`,
			[user.id],
		),
		executeQuery<{ created_at: string; has_password: number }>(
			`SELECT created_at, (password_hash IS NOT NULL) AS has_password
			 FROM auth_users WHERE id = ?`,
			[user.id],
		),
	]);

	const result = [...oauthAccounts];

	if (userRows[0]?.has_password) {
		result.push({
			id: 0,
			provider: 'email',
			provider_account_id: user.email,
			created_at: userRows[0].created_at,
		});
	}

	return result;
});

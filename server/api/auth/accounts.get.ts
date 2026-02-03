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

	// Получаем все OAuth аккаунты пользователя
	const accounts = await executeQuery(
		`SELECT id, provider, provider_account_id, created_at 
     FROM auth_oauth_accounts 
     WHERE user_id = ?
     ORDER BY created_at DESC`,
		[user.id],
	);

	return accounts;
});

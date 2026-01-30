import { executeQuery } from '~/server/common/db-mysql';

export interface OAuthAccount {
	id: number;
	user_id: number;
	provider: string;
	provider_account_id: string;
	access_token: string | null;
	refresh_token: string | null;
	expires_at: number | null;
}

/**
 * Найти пользователя по OAuth аккаунту
 */
export async function findUserByOAuth(
	provider: string,
	providerAccountId: string,
): Promise<any | null> {
	const results = await executeQuery(
		`SELECT u.* FROM users u
     JOIN oauth_accounts oa ON u.id = oa.user_id
     WHERE oa.provider = ? AND oa.provider_account_id = ?`,
		[provider, providerAccountId],
	);

	return results[0] || null;
}

/**
 * Создать нового пользователя через OAuth
 */
export async function createOAuthUser(
	email: string,
	name: string,
	photoUrl: string | null,
	provider: string,
	providerAccountId: string,
	accessToken: string | null = null,
	refreshToken: string | null = null,
	expiresAt: number | null = null,
): Promise<number> {
	// 1. Создать пользователя
	const userResult = await executeQuery(
		`INSERT INTO users (email, name, photo_url, is_admin, password_hash)
     VALUES (?, ?, ?, FALSE, NULL)`,
		[email, name, photoUrl],
	);

	const userId = (userResult as any).insertId;

	// 2. Создать OAuth аккаунт
	await executeQuery(
		`INSERT INTO oauth_accounts (user_id, provider, provider_account_id, access_token, refresh_token, expires_at)
     VALUES (?, ?, ?, ?, ?, ?)`,
		[userId, provider, providerAccountId, accessToken, refreshToken, expiresAt],
	);

	return userId;
}

/**
 * Обновить токены OAuth аккаунта
 */
export async function updateOAuthTokens(
	provider: string,
	providerAccountId: string,
	accessToken: string | null,
	refreshToken: string | null = null,
	expiresAt: number | null = null,
): Promise<void> {
	await executeQuery(
		`UPDATE oauth_accounts
     SET access_token = ?, refresh_token = ?, expires_at = ?
     WHERE provider = ? AND provider_account_id = ?`,
		[accessToken, refreshToken, expiresAt, provider, providerAccountId],
	);
}

/**
 * Проверить существует ли пользователь с таким email
 */
export async function findUserByEmail(email: string): Promise<any | null> {
	const results = await executeQuery('SELECT * FROM users WHERE email = ?', [
		email,
	]);

	return results[0] || null;
}

/**
 * Привязать OAuth аккаунт к существующему пользователю
 */
export async function linkOAuthAccount(
	userId: number,
	provider: string,
	providerAccountId: string,
	accessToken: string | null = null,
	refreshToken: string | null = null,
	expiresAt: number | null = null,
): Promise<void> {
	await executeQuery(
		`INSERT INTO oauth_accounts (user_id, provider, provider_account_id, access_token, refresh_token, expires_at)
     VALUES (?, ?, ?, ?, ?, ?)`,
		[userId, provider, providerAccountId, accessToken, refreshToken, expiresAt],
	);
}

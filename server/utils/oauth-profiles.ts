import { executeQuery } from '~/server/common/db-mysql';
import type { OAuthProvider } from './oauth-providers';

// ============================================================================
// Google Profile
// ============================================================================

export interface GoogleProfile {
	id: number;
	oauth_account_id: number;
	google_id: string;
	email: string;
	verified_email: boolean;
	name: string | null;
	given_name: string | null;
	family_name: string | null;
	picture: string | null;
	locale: string | null;
	raw_data?: any;
	created_at: string;
	updated_at: string;
}

/**
 * Сохранить или обновить Google профиль
 */
export async function saveGoogleProfile(
	oauthAccountId: number,
	googleData: {
		id: string;
		email: string;
		name: string;
		given_name: string;
		family_name: string;
		picture: string;
		locale: string;
		verified_email: boolean;
	},
): Promise<void> {
	await executeQuery(
		`INSERT INTO auth_oauth_profiles_google (
			oauth_account_id, google_id, email, verified_email,
			name, given_name, family_name, picture, locale, raw_data
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
		ON DUPLICATE KEY UPDATE
			google_id = VALUES(google_id),
			email = VALUES(email),
			verified_email = VALUES(verified_email),
			name = VALUES(name),
			given_name = VALUES(given_name),
			family_name = VALUES(family_name),
			picture = VALUES(picture),
			locale = VALUES(locale),
			raw_data = VALUES(raw_data),
			updated_at = CURRENT_TIMESTAMP`,
		[
			oauthAccountId,
			googleData.id,
			googleData.email,
			googleData.verified_email ? 1 : 0,
			googleData.name,
			googleData.given_name,
			googleData.family_name,
			googleData.picture,
			googleData.locale,
			JSON.stringify(googleData),
		],
	);
}

/**
 * Получить Google профиль пользователя
 */
export async function getGoogleProfile(
	userId: number,
): Promise<GoogleProfile | null> {
	const results = await executeQuery<GoogleProfile>(
		`SELECT gp.* FROM auth_oauth_profiles_google gp
		 JOIN auth_oauth_accounts oa ON gp.oauth_account_id = oa.id
		 WHERE oa.user_id = ?`,
		[userId],
	);

	return results[0] || null;
}

// ============================================================================
// Telegram Profile
// ============================================================================

export interface TelegramProfile {
	id: number;
	oauth_account_id: number;
	telegram_id: number;
	first_name: string;
	last_name: string | null;
	username: string | null;
	photo_url: string | null;
	auth_date: number | null;
	raw_data?: any;
	created_at: string;
	updated_at: string;
}

/**
 * Сохранить или обновить Telegram профиль
 */
export async function saveTelegramProfile(
	oauthAccountId: number,
	telegramData: {
		id: number;
		first_name: string;
		last_name?: string;
		username?: string;
		photo_url?: string;
		auth_date?: number;
	},
): Promise<void> {
	await executeQuery(
		`INSERT INTO auth_oauth_profiles_telegram (
			oauth_account_id, telegram_id, first_name, last_name,
			username, photo_url, auth_date, raw_data
		) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
		ON DUPLICATE KEY UPDATE
			telegram_id = VALUES(telegram_id),
			first_name = VALUES(first_name),
			last_name = VALUES(last_name),
			username = VALUES(username),
			photo_url = VALUES(photo_url),
			auth_date = VALUES(auth_date),
			raw_data = VALUES(raw_data),
			updated_at = CURRENT_TIMESTAMP`,
		[
			oauthAccountId,
			telegramData.id,
			telegramData.first_name,
			telegramData.last_name || null,
			telegramData.username || null,
			telegramData.photo_url || null,
			telegramData.auth_date || null,
			JSON.stringify(telegramData),
		],
	);
}

/**
 * Получить Telegram профиль пользователя
 */
export async function getTelegramProfile(
	userId: number,
): Promise<TelegramProfile | null> {
	const results = await executeQuery<TelegramProfile>(
		`SELECT tp.* FROM auth_oauth_profiles_telegram tp
		 JOIN auth_oauth_accounts oa ON tp.oauth_account_id = oa.id
		 WHERE oa.user_id = ?`,
		[userId],
	);

	return results[0] || null;
}

// ============================================================================
// Facebook Profile
// ============================================================================

export interface FacebookProfile {
	id: number;
	oauth_account_id: number;
	facebook_id: string;
	name: string;
	email: string | null;
	picture_url: string | null;
	raw_data?: any;
	created_at: string;
	updated_at: string;
}

/**
 * Сохранить или обновить Facebook профиль
 */
export async function saveFacebookProfile(
	oauthAccountId: number,
	facebookData: {
		id: string;
		name: string;
		email?: string;
		picture?: {
			data: {
				url: string;
			};
		};
	},
): Promise<void> {
	const pictureUrl = facebookData.picture?.data?.url || null;

	await executeQuery(
		`INSERT INTO auth_oauth_profiles_facebook (
			oauth_account_id, facebook_id, name, email, picture_url, raw_data
		) VALUES (?, ?, ?, ?, ?, ?)
		ON DUPLICATE KEY UPDATE
			facebook_id = VALUES(facebook_id),
			name = VALUES(name),
			email = VALUES(email),
			picture_url = VALUES(picture_url),
			raw_data = VALUES(raw_data),
			updated_at = CURRENT_TIMESTAMP`,
		[
			oauthAccountId,
			facebookData.id,
			facebookData.name,
			facebookData.email || null,
			pictureUrl,
			JSON.stringify(facebookData),
		],
	);
}

/**
 * Получить Facebook профиль пользователя
 */
export async function getFacebookProfile(
	userId: number,
): Promise<FacebookProfile | null> {
	const results = await executeQuery<FacebookProfile>(
		`SELECT fp.* FROM auth_oauth_profiles_facebook fp
		 JOIN auth_oauth_accounts oa ON fp.oauth_account_id = oa.id
		 WHERE oa.user_id = ?`,
		[userId],
	);

	return results[0] || null;
}

// ============================================================================
// Общие утилиты
// ============================================================================

export interface AllOAuthProfiles {
	google: GoogleProfile | null;
	telegram: TelegramProfile | null;
	facebook: FacebookProfile | null;
}

/**
 * Получить все OAuth профили пользователя
 */
export async function getUserOAuthProfiles(
	userId: number,
): Promise<AllOAuthProfiles> {
	const [google, telegram, facebook] = await Promise.all([
		getGoogleProfile(userId),
		getTelegramProfile(userId),
		getFacebookProfile(userId),
	]);

	return { google, telegram, facebook };
}

/**
 * Получить приоритетный OAuth профиль
 */
export async function getPrimaryOAuthProfile(
	userId: number,
): Promise<{
	provider: OAuthProvider;
	profile: GoogleProfile | TelegramProfile | FacebookProfile;
} | null> {
	const userResults = await executeQuery(
		'SELECT primary_oauth_provider FROM auth_users WHERE id = ?',
		[userId],
	);

	if (userResults.length === 0) return null;

	const primaryProvider = (userResults[0] as any).primary_oauth_provider;

	if (primaryProvider === 'google') {
		const profile = await getGoogleProfile(userId);
		return profile ? { provider: 'google', profile } : null;
	} else if (primaryProvider === 'telegram') {
		const profile = await getTelegramProfile(userId);
		return profile ? { provider: 'telegram', profile } : null;
	} else if (primaryProvider === 'facebook') {
		const profile = await getFacebookProfile(userId);
		return profile ? { provider: 'facebook', profile } : null;
	}

	// Если не установлен приоритет, берем первый доступный
	const google = await getGoogleProfile(userId);
	if (google) return { provider: 'google', profile: google };

	const telegram = await getTelegramProfile(userId);
	if (telegram) return { provider: 'telegram', profile: telegram };

	const facebook = await getFacebookProfile(userId);
	if (facebook) return { provider: 'facebook', profile: facebook };

	return null;
}

/**
 * Установить приоритетный OAuth провайдер
 */
export async function setPrimaryOAuthProvider(
	userId: number,
	provider: OAuthProvider | null,
): Promise<void> {
	await executeQuery(
		'UPDATE auth_users SET primary_oauth_provider = ? WHERE id = ?',
		[provider, userId],
	);
}

/**
 * Получить ID oauth_account для провайдера
 */
export async function getOAuthAccountId(
	userId: number,
	provider: OAuthProvider,
): Promise<number | null> {
	const results = await executeQuery(
		'SELECT id FROM auth_oauth_accounts WHERE user_id = ? AND provider = ?',
		[userId, provider],
	);

	return results.length > 0 ? (results[0] as any).id : null;
}

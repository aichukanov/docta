import { getOAuthConfig } from '~/server/utils/oauth-config';
import {
	findUserByOAuth,
	createOAuthUser,
	updateOAuthTokens,
	updateUserProfile,
	findUserByEmail,
	linkOAuthAccount,
} from '~/server/utils/oauth';
import { createSession, setSessionCookie } from '~/server/utils/session';
import { authLogger, logError } from '~/server/utils/logger';
import { ERROR_CODES } from '~/server/utils/api-codes';

interface GoogleTokenResponse {
	access_token: string;
	refresh_token?: string;
	expires_in: number;
	token_type: string;
	id_token: string;
}

interface GoogleUserInfo {
	id: string;
	email: string;
	verified_email: boolean;
	name: string;
	given_name: string;
	family_name: string;
	picture: string;
	locale: string;
}

export default defineEventHandler(async (event) => {
	const query = getQuery(event);
	const code = query.code as string;
	const state = query.state as string;
	const error = query.error as string;

	// Проверка на ошибку от Google
	if (error) {
		authLogger.error('OAuth error from Google', { error });
		return sendRedirect(event, `/login?error=${ERROR_CODES.OAUTH_FAILED}`);
	}

	// Проверка наличия code
	if (!code) {
		return sendRedirect(event, `/login?error=${ERROR_CODES.NO_CODE}`);
	}

	// Проверка state (защита от CSRF)
	const savedState = getCookie(event, 'oauth_state');
	if (!savedState || savedState !== state) {
		authLogger.error('OAuth state mismatch', {
			hasSavedState: !!savedState,
			hasQueryState: !!state,
			requestHost: getRequestHeader(event, 'host'),
		});
		return sendRedirect(event, `/login?error=${ERROR_CODES.STATE_MISMATCH}`);
	}

	// Получаем сохраненный redirect_uri
	const savedRedirectUri = getCookie(event, 'oauth_redirect_uri');

	// Очищаем cookies
	deleteCookie(event, 'oauth_state');
	deleteCookie(event, 'oauth_redirect_uri');

	try {
		const config = getOAuthConfig();
		const { google } = config;

		// Используем сохраненный redirect_uri или из конфига (BASE_URL)
		const currentRedirectUri = savedRedirectUri || google.redirectUri;

		authLogger.debug('Google OAuth callback', {
			redirectUri: currentRedirectUri,
		});

		// 1. Обмениваем code на токены
		const tokenResponse = await $fetch<GoogleTokenResponse>(google.tokenUrl, {
			method: 'POST',
			body: {
				code,
				client_id: google.clientId,
				client_secret: google.clientSecret,
				redirect_uri: currentRedirectUri,
				grant_type: 'authorization_code',
			},
		});

		// 2. Получаем информацию о пользователе
		const userInfo = await $fetch<GoogleUserInfo>(google.userInfoUrl, {
			headers: {
				Authorization: `Bearer ${tokenResponse.access_token}`,
			},
		});

		if (!userInfo.email || !userInfo.verified_email) {
			return sendRedirect(event, `/login?error=${ERROR_CODES.EMAIL_NOT_VERIFIED}`);
		}

		// 3. Проверяем существует ли пользователь с этим Google аккаунтом
		let user = await findUserByOAuth('google', userInfo.id);

		const expiresAt = tokenResponse.expires_in
			? Math.floor(Date.now() / 1000) + tokenResponse.expires_in
			: null;

		if (user) {
			// Пользователь существует - обновляем токены и профиль
			await updateOAuthTokens(
				'google',
				userInfo.id,
				tokenResponse.access_token,
				tokenResponse.refresh_token,
				expiresAt,
			);
			await updateUserProfile(user.id, userInfo.name, userInfo.picture);

			// Сохраняем полный Google профиль
			const { getOAuthAccountId, saveGoogleProfile } = await import(
				'~/server/utils/oauth-profiles'
			);
			const oauthAccountId = await getOAuthAccountId(user.id, 'google');
			if (oauthAccountId) {
				await saveGoogleProfile(oauthAccountId, userInfo);
			}
		} else {
			// Проверяем есть ли текущая сессия (для привязки аккаунта)
			const sessionId = getCookie(event, 'session_id');
			let currentUserId: number | null = null;

			if (sessionId) {
				const { getUserFromSession } = await import('~/server/utils/session');
				const currentUser = await getUserFromSession(sessionId);
				if (currentUser) {
					currentUserId = currentUser.id;
				}
			}

			if (currentUserId) {
				// Привязываем Google к существующему пользователю
				await linkOAuthAccount(
					currentUserId,
					'google',
					userInfo.id,
					tokenResponse.access_token,
					tokenResponse.refresh_token,
					expiresAt,
				);

				// Обновляем профиль
				await updateUserProfile(currentUserId, userInfo.name, userInfo.picture);

				user = { id: currentUserId };
			} else {
				// Проверяем существует ли пользователь с таким email
				const existingUser = await findUserByEmail(userInfo.email);

				if (existingUser) {
					// Пользователь с таким email уже существует - привязываем Google аккаунт
					await linkOAuthAccount(
						existingUser.id,
						'google',
						userInfo.id,
						tokenResponse.access_token,
						tokenResponse.refresh_token,
						expiresAt,
					);

					// Обновляем профиль
					await updateUserProfile(
						existingUser.id,
						userInfo.name,
						userInfo.picture,
					);

					// Сохраняем полный Google профиль
					const {
						getOAuthAccountId,
						saveGoogleProfile,
						setPrimaryOAuthProvider,
					} = await import('~/server/utils/oauth-profiles');
					const oauthAccountId = await getOAuthAccountId(
						existingUser.id,
						'google',
					);
					if (oauthAccountId) {
						await saveGoogleProfile(oauthAccountId, userInfo);
						// Если это первый OAuth, делаем его основным
						await setPrimaryOAuthProvider(existingUser.id, 'google');
					}

					user = existingUser;
				} else {
					// Новый пользователь - создаем
					const userId = await createOAuthUser(
						userInfo.email,
						userInfo.name,
						userInfo.picture,
						'google',
						userInfo.id,
						tokenResponse.access_token,
						tokenResponse.refresh_token,
						expiresAt,
					);

					// Сохраняем полный Google профиль
					const {
						getOAuthAccountId,
						saveGoogleProfile,
						setPrimaryOAuthProvider,
					} = await import('~/server/utils/oauth-profiles');
					const oauthAccountId = await getOAuthAccountId(userId, 'google');
					if (oauthAccountId) {
						await saveGoogleProfile(oauthAccountId, userInfo);
						await setPrimaryOAuthProvider(userId, 'google');
					}

					// Получаем созданного пользователя
					user = {
						id: userId,
						email: userInfo.email,
						name: userInfo.name || userInfo.email,
						photo_url: userInfo.picture,
						is_admin: false,
					};
				}
			}
		}

		// 4. Создаем сессию
		const sessionId = await createSession(user.id);
		setSessionCookie(event, sessionId);

		// Логируем успешный вход
		const { logSuccessfulLogin } = await import('~/server/utils/login-history');
		await logSuccessfulLogin(user.id, event, 'google');

		// 5. Проверяем есть ли сохраненный redirect URL
		const redirectTo = getCookie(event, 'auth_redirect');
		if (redirectTo && redirectTo !== '/login') {
			deleteCookie(event, 'auth_redirect');
			return sendRedirect(event, redirectTo);
		}

		// 6. Редиректим на страницу профиля
		return sendRedirect(event, '/profile');
	} catch (err) {
		logError(authLogger, 'OAuth callback failed', err);
		return sendRedirect(event, `/login?error=${ERROR_CODES.OAUTH_CALLBACK_FAILED}`);
	}
});

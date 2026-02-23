import { getOAuthConfig } from '~/server/utils/oauth-config';
import {
	findUserByOAuth,
	createOAuthUser,
	updateOAuthTokens,
	findUserByEmail,
	linkOAuthAccount,
} from '~/server/utils/oauth';
import { createSession, setSessionCookie } from '~/server/utils/session';
import { authLogger, logError } from '~/server/utils/logger';
import { ERROR_CODES } from '~/server/utils/api-codes';

interface FacebookTokenResponse {
	access_token: string;
	token_type: string;
	expires_in: number;
}

interface FacebookUserInfo {
	id: string;
	name: string;
	email?: string;
	picture?: {
		data: {
			height: number;
			is_silhouette: boolean;
			url: string;
			width: number;
		};
	};
}

export default defineEventHandler(async (event) => {
	const query = getQuery(event);
	const code = query.code as string;
	const state = query.state as string;
	const error = query.error as string;

	// Проверка на ошибку от Facebook
	if (error) {
		authLogger.error('OAuth error from Facebook', { error });
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
		const { facebook } = config;

		// Используем сохраненный redirect_uri или из конфига (BASE_URL)
		const currentRedirectUri = savedRedirectUri || facebook.redirectUri;

		authLogger.debug('Facebook OAuth callback', {
			redirectUri: currentRedirectUri,
		});

		// 1. Обмениваем code на токен
		const tokenResponse = await $fetch<FacebookTokenResponse>(
			facebook.tokenUrl,
			{
				method: 'GET',
				query: {
					client_id: facebook.appId,
					client_secret: facebook.appSecret,
					redirect_uri: currentRedirectUri,
					code,
				},
			},
		);

		// 2. Получаем информацию о пользователе
		const userInfo = await $fetch<FacebookUserInfo>(facebook.userInfoUrl, {
			query: {
				fields: 'id,name,email,picture.width(200).height(200)',
				access_token: tokenResponse.access_token,
			},
		});

		if (!userInfo.email) {
			return sendRedirect(
				event,
				`/login?error=${ERROR_CODES.EMAIL_NOT_PROVIDED}`,
			);
		}

		// Получаем URL фото
		const photoUrl = userInfo.picture?.data?.url || null;

		// 3. Проверяем существует ли пользователь с этим Facebook аккаунтом
		let user = await findUserByOAuth('facebook', userInfo.id);

		const expiresAt = tokenResponse.expires_in
			? Math.floor(Date.now() / 1000) + tokenResponse.expires_in
			: null;

		if (user) {
			// Пользователь существует - обновляем токены и профиль провайдера
			await updateOAuthTokens(
				'facebook',
				userInfo.id,
				tokenResponse.access_token,
				null,
				expiresAt,
			);

			// Сохраняем полный Facebook профиль
			const { getOAuthAccountId, saveFacebookProfile } = await import(
				'~/server/utils/oauth-profiles'
			);
			const oauthAccountId = await getOAuthAccountId(user.id, 'facebook');
			if (oauthAccountId) {
				await saveFacebookProfile(oauthAccountId, userInfo);
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
				// Привязываем Facebook к существующему пользователю
				await linkOAuthAccount(
					currentUserId,
					'facebook',
					userInfo.id,
					tokenResponse.access_token,
					null,
					expiresAt,
				);

				// Сохраняем полный Facebook профиль
				const {
					getOAuthAccountId,
					saveFacebookProfile,
					setPrimaryOAuthProvider,
				} = await import('~/server/utils/oauth-profiles');
				const oauthAccountId = await getOAuthAccountId(
					currentUserId,
					'facebook',
				);
				if (oauthAccountId) {
					await saveFacebookProfile(oauthAccountId, userInfo);
					// Если primary ещё не задан — назначаем Facebook
					const userRow = await import('~/server/common/db-mysql').then((m) =>
						m.executeQuery(
							'SELECT primary_oauth_provider FROM auth_users WHERE id = ?',
							[currentUserId],
						),
					);
					if (!(userRow[0] as any)?.primary_oauth_provider) {
						await setPrimaryOAuthProvider(currentUserId, 'facebook');
					}
				}

				user = { id: currentUserId };
			} else {
				// Проверяем существует ли пользователь с таким email
				const existingUser = await findUserByEmail(userInfo.email);

				if (existingUser) {
					// Пользователь с таким email уже существует - привязываем Facebook аккаунт
					await linkOAuthAccount(
						existingUser.id,
						'facebook',
						userInfo.id,
						tokenResponse.access_token,
						null,
						expiresAt,
					);

					// Сохраняем полный Facebook профиль
					const {
						getOAuthAccountId,
						saveFacebookProfile,
						setPrimaryOAuthProvider,
					} = await import('~/server/utils/oauth-profiles');
					const oauthAccountId = await getOAuthAccountId(
						existingUser.id,
						'facebook',
					);
					if (oauthAccountId) {
						await saveFacebookProfile(oauthAccountId, userInfo);
						// Если это первый OAuth, делаем его основным
						await setPrimaryOAuthProvider(existingUser.id, 'facebook');
					}

					user = existingUser;
				} else {
					// Новый пользователь - создаем (name и photo_url не ставим — берутся из профиля провайдера)
					const userId = await createOAuthUser(
						userInfo.email,
						null,
						null,
						'facebook',
						userInfo.id,
						tokenResponse.access_token,
						null,
						expiresAt,
					);

					// Сохраняем полный Facebook профиль
					const {
						getOAuthAccountId,
						saveFacebookProfile,
						setPrimaryOAuthProvider,
					} = await import('~/server/utils/oauth-profiles');
					const oauthAccountId = await getOAuthAccountId(userId, 'facebook');
					if (oauthAccountId) {
						await saveFacebookProfile(oauthAccountId, userInfo);
						await setPrimaryOAuthProvider(userId, 'facebook');
					}

					// Получаем созданного пользователя
					user = {
						id: userId,
						email: userInfo.email,
						name: userInfo.name || userInfo.email,
						photo_url: photoUrl,
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
		await logSuccessfulLogin(user.id, event, 'facebook');

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
		return sendRedirect(
			event,
			`/login?error=${ERROR_CODES.OAUTH_CALLBACK_FAILED}`,
		);
	}
});

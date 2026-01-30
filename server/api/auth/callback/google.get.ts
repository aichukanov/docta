import { getOAuthConfig } from '~/server/utils/oauth-config';
import {
	findUserByOAuth,
	createOAuthUser,
	updateOAuthTokens,
} from '~/server/utils/oauth';
import { createSession, setSessionCookie } from '~/server/utils/session';

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
		console.error('OAuth error from Google:', error);
		return sendRedirect(event, '/?error=oauth_failed');
	}

	// Проверка наличия code
	if (!code) {
		return sendRedirect(event, '/?error=no_code');
	}

	// Проверка state (защита от CSRF)
	const savedState = getCookie(event, 'oauth_state');
	if (!savedState || savedState !== state) {
		console.error('OAuth state mismatch');
		return sendRedirect(event, '/?error=state_mismatch');
	}

	// Очищаем state cookie
	deleteCookie(event, 'oauth_state');

	try {
		const config = getOAuthConfig();
		const { google } = config;

		// 1. Обмениваем code на токены
		const tokenResponse = await $fetch<GoogleTokenResponse>(
			google.tokenUrl,
			{
				method: 'POST',
				body: {
					code,
					client_id: google.clientId,
					client_secret: google.clientSecret,
					redirect_uri: google.redirectUri,
					grant_type: 'authorization_code',
				},
			},
		);

		// 2. Получаем информацию о пользователе
		const userInfo = await $fetch<GoogleUserInfo>(google.userInfoUrl, {
			headers: {
				Authorization: `Bearer ${tokenResponse.access_token}`,
			},
		});

		if (!userInfo.email || !userInfo.verified_email) {
			return sendRedirect(event, '/?error=email_not_verified');
		}

		// 3. Проверяем существует ли пользователь с этим Google аккаунтом
		let user = await findUserByOAuth('google', userInfo.id);

		const expiresAt = tokenResponse.expires_in
			? Math.floor(Date.now() / 1000) + tokenResponse.expires_in
			: null;

		if (user) {
			// Пользователь существует - обновляем токены
			await updateOAuthTokens(
				'google',
				userInfo.id,
				tokenResponse.access_token,
				tokenResponse.refresh_token,
				expiresAt,
			);
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

			// Получаем созданного пользователя
			user = {
				id: userId,
				email: userInfo.email,
				name: userInfo.name,
				photo_url: userInfo.picture,
				is_admin: false,
			};
		}

		// 4. Создаем сессию
		const sessionId = await createSession(user.id);
		setSessionCookie(event, sessionId);

		// 5. Редиректим на главную страницу
		return sendRedirect(event, '/');
	} catch (err) {
		console.error('OAuth callback error:', err);
		return sendRedirect(event, '/?error=oauth_callback_failed');
	}
});

import { getOAuthConfig } from '~/server/utils/oauth-config';

export default defineEventHandler((event) => {
	const config = getOAuthConfig();
	const { google } = config;

	// Генерируем state для защиты от CSRF
	const state = crypto.randomUUID();

	// Сохраняем state в cookie для проверки в callback
	setCookie(event, 'oauth_state', state, {
		httpOnly: true,
		secure: process.env.NODE_ENV === 'production',
		sameSite: 'lax',
		maxAge: 600, // 10 минут
		path: '/',
	});

	// Строим URL для авторизации
	const params = new URLSearchParams({
		client_id: google.clientId,
		redirect_uri: google.redirectUri,
		response_type: 'code',
		scope: 'openid email profile',
		state,
		access_type: 'offline',
		prompt: 'consent',
	});

	const authUrl = `${google.authUrl}?${params.toString()}`;

	// Редиректим на Google
	return sendRedirect(event, authUrl);
});

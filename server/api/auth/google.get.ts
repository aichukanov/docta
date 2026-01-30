import { getOAuthConfig } from '~/server/utils/oauth-config';

export default defineEventHandler((event) => {
	const config = getOAuthConfig();
	const { google } = config;

	// Определяем текущий origin из запроса
	const host = getRequestHeader(event, 'host');
	const protocol = getRequestHeader(event, 'x-forwarded-proto') || 'http';
	const currentOrigin = `${protocol}://${host}`;
	const redirectUri = `${currentOrigin}/api/auth/callback/google`;

	console.log('[Google OAuth] Starting auth flow');
	console.log('[Google OAuth] Current origin:', currentOrigin);
	console.log('[Google OAuth] Redirect URI:', redirectUri);

	// Генерируем state для защиты от CSRF
	const state = crypto.randomUUID();

	// Сохраняем state в cookie для проверки в callback
	setCookie(event, 'oauth_state', state, {
		httpOnly: true,
		secure: protocol === 'https',
		sameSite: 'lax',
		maxAge: 600, // 10 минут
		path: '/',
	});

	// Сохраняем redirect_uri для использования в callback
	setCookie(event, 'oauth_redirect_uri', redirectUri, {
		httpOnly: true,
		secure: protocol === 'https',
		sameSite: 'lax',
		maxAge: 600,
		path: '/',
	});

	// Строим URL для авторизации
	const params = new URLSearchParams({
		client_id: google.clientId,
		redirect_uri: redirectUri,
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

import { getOAuthConfig } from '~/server/utils/oauth-config';
import { authLogger } from '~/server/utils/logger';

export default defineEventHandler((event) => {
	const config = getOAuthConfig();
	const { facebook } = config;

	// Используем redirect URI из конфига (BASE_URL)
	const redirectUri = facebook.redirectUri;
	const redirectUrl = new URL(redirectUri);
	const protocol = redirectUrl.protocol.replace(':', '');

	// Если пользователь зашёл с другого хоста (напр. localhost вместо ngrok),
	// перенаправляем на правильный хост, чтобы cookie сохранились на нужном домене
	const requestHost = getRequestHeader(event, 'host') || '';
	if (requestHost && requestHost !== redirectUrl.host) {
		authLogger.debug('Redirecting to correct origin for OAuth', {
			from: requestHost,
			to: redirectUrl.host,
		});
		return sendRedirect(event, `${redirectUrl.origin}/api/auth/facebook`);
	}

	authLogger.debug('Starting Facebook OAuth flow', {
		redirectUri,
	});

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

	// Проверяем и сохраняем redirect URL из referer
	const referer = getRequestHeader(event, 'referer');
	if (referer) {
		try {
			const refererUrl = new URL(referer);
			const returnTo = refererUrl.pathname + refererUrl.search;
			if (returnTo && returnTo !== '/login') {
				setCookie(event, 'auth_redirect', returnTo, {
					httpOnly: false, // Нужен доступ из браузера для sessionStorage
					secure: protocol === 'https',
					sameSite: 'lax',
					maxAge: 600,
					path: '/',
				});
			}
		} catch (error) {
			authLogger.error('Failed to parse referer', { error });
		}
	}

	// Строим URL для авторизации
	const params = new URLSearchParams({
		client_id: facebook.appId,
		redirect_uri: redirectUri,
		response_type: 'code',
		scope: 'email,public_profile',
		state,
	});

	const authUrl = `${facebook.authUrl}?${params.toString()}`;

	// Редиректим на Facebook
	return sendRedirect(event, authUrl);
});

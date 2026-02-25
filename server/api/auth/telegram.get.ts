import { getOAuthConfig } from '~/server/utils/oauth-config';
import { getBaseUrl } from '~/server/utils/base-url';
import { authLogger } from '~/server/utils/logger';

export default defineEventHandler((event) => {
	const config = getOAuthConfig();
	const { telegram } = config;
	const baseUrl = getBaseUrl();

	const baseUrlObj = new URL(baseUrl);
	const protocol = baseUrlObj.protocol.replace(':', '');

	// Если пользователь зашёл с другого хоста, перенаправляем на правильный
	const requestHost = getRequestHeader(event, 'host') || '';
	if (requestHost && requestHost !== baseUrlObj.host) {
		authLogger.debug('Redirecting to correct origin for Telegram OAuth', {
			from: requestHost,
			to: baseUrlObj.host,
		});
		return sendRedirect(event, `${baseUrlObj.origin}/api/auth/telegram`);
	}

	authLogger.debug('Starting Telegram OAuth flow');

	// Сохраняем redirect URL из referer (для возврата на /profile)
	const referer = getRequestHeader(event, 'referer');
	if (referer) {
		try {
			const refererUrl = new URL(referer);
			const returnTo = refererUrl.pathname + refererUrl.search;
			if (returnTo && returnTo !== '/login') {
				setCookie(event, 'auth_redirect', returnTo, {
					httpOnly: false,
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

	// Строим URL для Telegram OAuth
	// return_to указывает на клиентскую страницу-посредник,
	// т.к. Telegram отдаёт данные в URL-фрагменте (#tgAuthResult=base64),
	// а сервер фрагменты не видит
	const botId = telegram.botToken.split(':')[0];
	const callbackUrl = `${baseUrl}/auth/telegram-callback`;

	const params = new URLSearchParams({
		bot_id: botId,
		embed: '0',
		request_access: 'write',
		return_to: callbackUrl,
	});

	const authUrl = `https://oauth.telegram.org/auth?${params.toString()}`;

	// Редиректим на Telegram OAuth
	return sendRedirect(event, authUrl);
});

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

	// Строим URL для Telegram OAuth и редиректим на клиентскую страницу-посредник,
	// которая загрузит oauth.telegram.org в iframe и будет слушать postMessage.
	// Это необходимо, потому что на мобильных устройствах при redirect-авторизации
	// пользователь переключается в ТГ-приложение для подтверждения, и браузерная
	// вкладка с oauth.telegram.org уходит в фон — postMessage теряется.
	const botId = telegram.botToken.split(':')[0];

	const callbackParams = new URLSearchParams({
		bot_id: botId,
		origin: baseUrlObj.origin,
		request_access: 'write',
	});

	return sendRedirect(
		event,
		`/auth/telegram-callback?${callbackParams.toString()}`,
	);
});

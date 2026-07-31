/**
 * Composable для авторизации через Telegram.
 *
 * Используется top-level redirect на oauth.telegram.org, а НЕ popup-виджет
 * (`telegram-widget.js` + `Telegram.Login.auth`). Popup-поток отдаёт результат
 * либо через `postMessage` из popup в `opener`, либо, если popup успел
 * закрыться, — через `POST oauth.telegram.org/auth/get` с `withCredentials`,
 * то есть по сторонним кукам. Safari и Firefox их блокируют, Chrome
 * ограничивает; в этом случае виджет отдаёт `false`, и вход молча не случается:
 * Telegram авторизацию подтверждает, бот пишет пользователю «вы вошли»,
 * а на сайте ничего не происходит.
 *
 * Redirect-поток не зависит ни от popup, ни от сторонних куков и работает
 * во встроенных браузерах (в том числе в самом Telegram): Telegram сам
 * возвращает браузер на `return_to` с данными в hash-фрагменте, где их
 * подхватывает страница `/auth/telegram/return`.
 */
const TELEGRAM_OAUTH_URL = 'https://oauth.telegram.org/auth';

export const TELEGRAM_RETURN_PATH = '/auth/telegram/return';

export function useTelegramAuth() {
	const loading = ref(false);

	function openTelegramAuth(redirectTo?: string) {
		if (loading.value) return;

		const config = useRuntimeConfig();
		const botId = String(config.public.telegramBotId || '');

		if (!botId) {
			console.error('[TG Auth] TELEGRAM_BOT_ID not configured');
			return;
		}

		loading.value = true;

		if (redirectTo) {
			document.cookie = `auth_redirect=${encodeURIComponent(
				redirectTo,
			)}; path=/; max-age=600; SameSite=Lax`;
		}

		// request_access не запрашиваем: бот пользователям не пишет (вызовов
		// api.telegram.org в коде нет), а лишнее разрешение на экране согласия —
		// только повод отказаться
		const params = new URLSearchParams({
			bot_id: botId,
			origin: window.location.origin,
			return_to: `${window.location.origin}${TELEGRAM_RETURN_PATH}`,
		});

		// Уходим со страницы целиком — loading не сбрасываем, кнопка остаётся
		// заблокированной до навигации
		window.location.href = `${TELEGRAM_OAUTH_URL}?${params.toString()}`;
	}

	return {
		loading: readonly(loading),
		openTelegramAuth,
	};
}

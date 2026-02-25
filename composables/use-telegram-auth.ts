declare global {
	interface Window {
		Telegram?: {
			Login: {
				auth: (
					options: { bot_id: string; request_access?: boolean; lang?: string },
					callback: (data: TelegramWidgetData | false) => void,
				) => void;
			};
		};
	}
}

interface TelegramWidgetData {
	id: number;
	first_name: string;
	last_name?: string;
	username?: string;
	photo_url?: string;
	auth_date: number;
	hash: string;
}

let scriptLoaded = false;
let scriptLoading: Promise<void> | null = null;

function loadTelegramWidget(): Promise<void> {
	if (scriptLoaded && window.Telegram?.Login) return Promise.resolve();
	if (scriptLoading) return scriptLoading;

	scriptLoading = new Promise<void>((resolve, reject) => {
		const script = document.createElement('script');
		script.src = 'https://telegram.org/js/telegram-widget.js?22';
		script.async = true;
		script.onload = () => {
			scriptLoaded = true;
			resolve();
		};
		script.onerror = () => reject(new Error('Failed to load Telegram widget'));
		document.head.appendChild(script);
	});

	return scriptLoading;
}

/**
 * Composable для авторизации через стандартный Telegram Login Widget.
 *
 * Загружает telegram-widget.js и вызывает Telegram.Login.auth() —
 * виджет сам управляет popup, а данные приходят в callback.
 * После получения данных перенаправляет на серверный callback.
 *
 * Опционально принимает redirectTo для сохранения в cookie
 * через серверный callback.
 */
export function useTelegramAuth() {
	const loading = ref(false);

	async function openTelegramAuth(redirectTo?: string) {
		if (loading.value) return;
		loading.value = true;

		try {
			await loadTelegramWidget();

			if (!window.Telegram?.Login) {
				throw new Error('Telegram.Login not available');
			}

			const config = useRuntimeConfig();
			const botId = config.public.telegramBotId as string;

			if (!botId) {
				throw new Error('TELEGRAM_BOT_ID not configured');
			}

			if (redirectTo) {
				document.cookie = `auth_redirect=${encodeURIComponent(redirectTo)}; path=/; max-age=600; SameSite=Lax`;
			}

			window.Telegram.Login.auth(
				{ bot_id: botId, request_access: true },
				(data) => {
					if (!data) {
						loading.value = false;
						return;
					}

					const params = new URLSearchParams();
					for (const [key, value] of Object.entries(data)) {
						if (value !== undefined && value !== null) {
							params.set(key, String(value));
						}
					}
					window.location.href = `/api/auth/callback/telegram?${params.toString()}`;
				},
			);
		} catch (err) {
			console.error('[TG Auth] Failed:', err);
			loading.value = false;
		}
	}

	return {
		loading: readonly(loading),
		openTelegramAuth,
	};
}

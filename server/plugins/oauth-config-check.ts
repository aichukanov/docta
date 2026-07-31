import { authLogger } from '~/server/utils/logger';

/**
 * Проверяет на старте, что серверный TELEGRAM_BOT_TOKEN и публичный bot_id,
 * с которым рисуется кнопка входа, принадлежат одному боту.
 *
 * Разъехаться они могут незаметно: публичный bot_id перекрывается в рантайме
 * (NUXT_PUBLIC_TELEGRAM_BOT_ID из ecosystem.config.cjs), а токен остаётся
 * вшитым с этапа сборки — то есть смена бота или ротация токена без пересборки
 * ломает проверку подписи. Симптом был бы коварный: Telegram авторизацию
 * подтверждает и бот пишет пользователю «вы вошли», а сайт молча редиректит
 * на /login. См. docs/rules/RUNTIME_CONFIG_ENV.md.
 */
export default defineNitroPlugin(() => {
	const config = useRuntimeConfig();

	const botToken = config.telegramBotToken || '';
	const widgetBotId = String(config.public.telegramBotId || '');
	const serverBotId = botToken.split(':')[0];

	if (!botToken || !widgetBotId) {
		// Локально бот для входа нужен не всем — это не поломка конфигурации
		const message = 'Telegram login is not configured';
		const details = {
			hasBotToken: !!botToken,
			widgetBotId: widgetBotId || '(empty)',
		};

		if (import.meta.dev) {
			authLogger.warn(message, details);
		} else {
			authLogger.error(message, details);
		}
		return;
	}

	if (serverBotId !== widgetBotId) {
		authLogger.error('Telegram login misconfigured: bot id mismatch', {
			serverBotId,
			widgetBotId,
			hint: 'токен вшит на этапе сборки, а bot_id приходит из .env — нужна пересборка (npm run build), рестарта недостаточно',
		});
	}
});

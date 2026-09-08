import {
	getPrivateCacheControl,
	PRIVATE_CACHE_CONTROL,
} from '~/server/common/private-cache';

/**
 * Снимает разрешение кэшировать с ответов авторизованным посетителям.
 * Зачем именно так — в `server/common/private-cache.ts`.
 *
 * Хук `beforeResponse`, а не middleware: заголовки из `routeRules` nitro
 * выставляет по ходу обработки запроса, и middleware, отработавший до
 * рендера, перезаписали бы. `beforeResponse` вызывается последним, когда
 * ответ уже сформирован, но ещё не отправлен.
 *
 * Проверяется только НАЛИЧИЕ cookie, без обращения к БД: смысл всей затеи —
 * не ходить в базу на кэшируемых маршрутах. Подделанный `session_id` даст
 * лишь промах кэша для самого подделавшего.
 */
export default defineNitroPlugin((nitro) => {
	nitro.hooks.hook('beforeResponse', (event) => {
		const hasSession = Boolean(getCookie(event, 'session_id'));
		const next = getPrivateCacheControl(
			getResponseHeader(event, 'cache-control'),
			hasSession,
		);

		if (next) {
			setResponseHeader(event, 'cache-control', PRIVATE_CACHE_CONTROL);
		}
	});
});

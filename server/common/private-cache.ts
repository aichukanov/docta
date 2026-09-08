/**
 * Ответ авторизованному посетителю не должен попадать в общий кэш.
 *
 * Дело не только в баннере владельца клиники. Pinia сериализует состояние
 * своих сторов в `__NUXT_DATA__` КАЖДОЙ страницы, а `app.vue` зовёт
 * `useUserStore().fetchUser()` прямо в setup — и на сервере этот вызов идёт в
 * `/api/auth/active-user`, подкладывая cookie запроса
 * (`useRequestHeaders(['cookie'])`). Проверено на проде 2026-09-08: в payload
 * главной есть ключ `pinia.user`. У анонима там `null`, у вошедшего — объект с
 * именем, email и `is_admin`. В разметке этого не видно (шапка обёрнута в
 * `ClientOnly`), но в HTML лежит.
 *
 * То есть закэшировать чужие данные можно на ЛЮБОЙ странице из `routeRules`,
 * а не только на карточках клиник и врачей: достаточно, чтобы вошедший
 * посетитель первым прогрел запись после истечения `s-maxage`.
 *
 * Отсюда правило: есть cookie сессии — разрешение кэшировать снимается.
 *
 * Это подстраховка, а не основной механизм. Основной — условие по cookie в
 * самом Cache Rule (docs/rules/EDGE_LOCALE_CACHE.md, шаг 1): без него вошедший
 * получал бы из кэша анонимную версию и владелец клиники не увидел бы своего
 * баннера. Middleware закрывает обратный и куда более неприятный случай —
 * когда в общий кэш попадает персональный ответ.
 */
export const PRIVATE_CACHE_CONTROL = 'private, no-store';

/**
 * Чем заменить `Cache-Control`, или `null`, если трогать нечего.
 *
 * Признак «это страница, а не статика» — наличие `s-maxage`: он есть у всех
 * кэшируемых маршрутов и отсутствует у `_nuxt/**` (там `immutable` и
 * `max-age`), у `noindex`-страниц и у API. Проверка по заголовку, а не по
 * пути: список путей живёт в `nuxt.config.ts` и меняется, а это условие
 * остаётся верным само по себе.
 */
export function getPrivateCacheControl(
	cacheControl: string | number | string[] | undefined,
	hasSession: boolean,
): string | null {
	if (!hasSession) {
		return null;
	}

	const value = Array.isArray(cacheControl)
		? cacheControl.join(', ')
		: String(cacheControl ?? '');

	return value.includes('s-maxage') ? PRIVATE_CACHE_CONTROL : null;
}

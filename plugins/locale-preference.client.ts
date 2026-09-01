import { getLocaleFromQuery, defaultLocale } from '~/composables/use-locale';

/**
 * Восстанавливает выбранный посетителем язык на клиенте.
 *
 * Сервер локаль по cookie больше не выбирает — ответ зависит только от адреса,
 * иначе один URL отдавал бы разным людям разное и его нельзя было бы
 * кэшировать (см. server/common/redirect/regional-settings.ts). Плата за это —
 * возвращающийся посетитель по голой ссылке получает дефолтную локаль, и
 * вернуть его на свою нужно здесь.
 *
 * Работает только когда в адресе языка нет: явный `?lang=` — это осознанный
 * выбор в конкретной ссылке, перебивать его сохранённым предпочтением нельзя
 * (иначе ссылка на русскую версию, присланная в чат, откроется по-немецки).
 *
 * `router.replace`, а не `push`: подмена языка не должна попадать в историю
 * и ломать кнопку «назад».
 */
export default defineNuxtPlugin((nuxtApp) => {
	// Именно на `app:mounted`, а не в setup плагина: плагины выполняются до
	// того, как роутер завершил начальную навигацию, и `replace` оттуда просто
	// теряется — проверено, редирект не происходил вовсе.
	nuxtApp.hook('app:mounted', () => {
		const route = useRoute();
		const router = useRouter();

		if (route.query.lang != null) {
			return;
		}

		const cookieLocale = getLocaleFromQuery(useCookie<string>('locale').value);

		if (!cookieLocale || cookieLocale === defaultLocale) {
			return;
		}

		router.replace({
			path: route.path,
			query: { ...route.query, lang: cookieLocale },
			hash: route.hash,
		});
	});
});

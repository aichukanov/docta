import {
	getLocaleFromQuery,
	type Locale,
	defaultLocale,
} from '~/composables/use-locale';
import { getRegionalUrl } from '../../../common/url-utils';
import { Language } from '~/enums/language';

export async function fixUrlRegionalParams(
	event: any,
): Promise<{ status: 301; url: string } | null> {
	const query = getQuery(event);

	const localeData = getLocaleForQuery(event);

	if (localeData.redirectStatus) {
		const { pathname } = getRequestURL(event);

		return {
			status: localeData.redirectStatus,
			url: getRegionalUrl(
				pathname,
				query as Record<string, string | string[]>,
				localeData.locale,
			),
		};
	}

	return null;
}

/**
 * Локаль ответа определяется ТОЛЬКО адресом страницы.
 *
 * Раньше приоритет был обратный: сохранённая локаль пользователя и cookie
 * перебивали явный `?lang=` в URL. Для человека это удобно, но означает, что
 * один и тот же адрес отдаёт разным людям разное — а значит его нельзя
 * положить ни в какой общий кэш. Именно это блокировало кэширование HTML:
 * посетитель с cookie `de`, попавший на закэшированный ответ голого URL,
 * увидел бы сербскую версию. Плюс редирект по cookie был постоянным (301),
 * то есть отравлял ещё и кэш браузера.
 *
 * Теперь сервер детерминирован: голый URL — дефолтная локаль, `?lang=X` —
 * X, и никак иначе. Предпочтение пользователя не потеряно: cookie пишет
 * переключатель языка (components/language-switcher.vue), а восстанавливает
 * его на клиенте plugins/locale-preference.client.ts — уже после того, как
 * закэшированный HTML доехал.
 *
 * Редирект остался ровно один и он постоянный, потому что зависит только от
 * URL: избыточный или негодный `?lang=` уводится на канонический адрес.
 */
function getLocaleForQuery(event: any): {
	locale: Locale;
	redirectStatus: 301 | null;
} {
	const query = getQuery(event);

	// Устаревшие значения в cookie чистим (её пишет переключатель языка), но
	// на выбор локали для ответа она больше не влияет.
	const cookieValue = getCookie(event, 'locale');
	if (cookieValue) {
		const cookieLocale = getLocaleFromQuery(cookieValue);

		if (
			cookieLocale == null ||
			cookieLocale === Language.ME ||
			cookieLocale === Language.BA
		) {
			deleteCookie(event, 'locale');
		}
	}

	if (query.lang == null) {
		return { locale: defaultLocale, redirectStatus: null };
	}

	const queryLocale = getLocaleFromQuery(query.lang as string | string[]);
	const isValidNonDefault =
		queryLocale != null &&
		queryLocale !== defaultLocale &&
		queryLocale !== Language.ME &&
		queryLocale !== Language.BA;

	// Несколько значений подряд (`?lang=ru&lang=de`) канонизируем к первому.
	const hasExtraValues = Array.isArray(query.lang) && query.lang.length > 1;

	if (isValidNonDefault && !hasExtraValues) {
		return { locale: queryLocale as Locale, redirectStatus: null };
	}

	return {
		locale: isValidNonDefault ? (queryLocale as Locale) : defaultLocale,
		redirectStatus: 301,
	};
}

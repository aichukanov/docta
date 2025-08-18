import { getLocaleFromQuery, Locale } from '~/composables/use-locale';
import { getRegionalUrl } from '../../../common/url-utils';

export function fixUrlRegionalParams(
	event: any,
): { status: 301 | 302; url: string } | null {
	const query = getQuery(event);

	const localeData = getLocaleForQuery(event);

	if (localeData.redirectStatus) {
		const { pathname } = getRequestURL(event);

		const statuses = [localeData.redirectStatus].filter(Boolean) as (
			| 301
			| 302
		)[];

		return {
			status: Math.min(...statuses) as 301 | 302,
			url: getRegionalUrl(
				pathname,
				query as Record<string, string | string[]>,
				localeData.locale,
			),
		};
	}

	return null;
}

function getLocaleForQuery(event: any): {
	locale: Locale;
	redirectStatus: 301 | 302 | null;
} {
	const query = getQuery(event);

	let cookieLocale: Locale | null = null;
	const cookieValue = getCookie(event, 'locale');
	if (cookieValue) {
		cookieLocale = getLocaleFromQuery(cookieValue);

		if (cookieLocale == null) {
			deleteCookie(event, 'locale');
		}
	}

	const queryLocale = getLocaleFromQuery(query.lang as string | string[]);
	const defaultLocale = 'me';

	return {
		locale: cookieLocale || queryLocale || defaultLocale,
		redirectStatus:
			queryLocale == null ||
			(Array.isArray(query.lang) && query.lang.length > 1)
				? 301
				: cookieLocale != null && cookieLocale !== queryLocale
				? 302
				: null,
	};
}

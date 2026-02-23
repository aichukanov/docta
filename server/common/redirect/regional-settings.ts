import {
	getLocaleFromQuery,
	type Locale,
	defaultLocale,
} from '~/composables/use-locale';
import { getRegionalUrl } from '../../../common/url-utils';
import { Language } from '~/enums/language';
import { getUserPreferredLocale } from '~/server/utils/user-locale';
import { getCurrentUser } from '~/server/common/auth';

export async function fixUrlRegionalParams(
	event: any,
): Promise<{ status: 301 | 302; url: string } | null> {
	const query = getQuery(event);

	const localeData = await getLocaleForQuery(event);

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

async function getLocaleForQuery(event: any): Promise<{
	locale: Locale;
	redirectStatus: 301 | 302 | null;
}> {
	const query = getQuery(event);

	// 1. Проверяем явно сохранённую локаль пользователя в БД (наивысший приоритет)
	const user = await getCurrentUser(event);
	if (user?.id) {
		try {
			const preferredLocale = await getUserPreferredLocale(user.id);
			if (preferredLocale) {
				const queryLocale = query.lang
					? getLocaleFromQuery(query.lang as string | string[])
					: defaultLocale;

				return {
					locale: preferredLocale as Locale,
					redirectStatus: preferredLocale !== queryLocale ? 302 : null,
				};
			}
		} catch (error) {
			// Игнорируем ошибки и продолжаем с другими источниками
		}
	}

	// 2. Проверяем cookie
	let cookieLocale: Locale | null = null;
	const cookieValue = getCookie(event, 'locale');
	if (cookieValue) {
		cookieLocale = getLocaleFromQuery(cookieValue);

		if (cookieLocale == null) {
			deleteCookie(event, 'locale');
		}
	}

	// 3. Проверяем query параметр
	const queryLocale = query.lang
		? getLocaleFromQuery(query.lang as string | string[])
		: defaultLocale;

	// удаляем устаревшие куки для черногорского и боснийского
	const locale = cookieLocale || queryLocale;
	if (locale === Language.ME || locale === Language.BA) {
		deleteCookie(event, 'locale');

		return {
			locale: defaultLocale,
			redirectStatus: 301,
		};
	}

	return {
		locale,
		redirectStatus: (
			Array.isArray(query.lang)
				? query.lang.length > 1 || query.lang[0] === defaultLocale
				: query.lang === defaultLocale
		)
			? 301
			: cookieLocale != null && cookieLocale !== queryLocale
			? 302
			: null,
	};
}

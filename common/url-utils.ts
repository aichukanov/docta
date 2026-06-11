import {
	formatLocaleAsQuery,
	getLocaleFromQuery,
	defaultLocale,
} from '~/composables/use-locale';
import { SITE_URL } from '~/common/constants';

// Значения query: принимаем строки/числа (и их массивы) от кода приложения,
// а также null из vue-router LocationQuery. Пустые значения не попадают в URL.
export type UrlQueryValue =
	| string
	| number
	| null
	| undefined
	| Array<string | number | null>;
export type UrlQuery = Record<string, UrlQueryValue>;

function addQueryParams(
	searchParams: URLSearchParams,
	key: string,
	value: UrlQueryValue,
) {
	if (Array.isArray(value)) {
		value.forEach((v) => {
			if (notEmpty(v)) {
				searchParams.append(key, String(v));
			}
		});
	} else if (notEmpty(value)) {
		searchParams.append(key, String(value));
	}
}

function notEmpty(value: string | number | null | undefined): boolean {
	return value != null && value !== '';
}

function updateQueryInUrl(
	pathname: string,
	query: UrlQuery,
	newQuery: UrlQuery,
) {
	const searchParams = new URLSearchParams();

	Object.entries(query).forEach(([key, value]) => {
		if (key in newQuery) {
			return;
		} else {
			addQueryParams(searchParams, key, value);
		}
	});

	Object.entries(newQuery).forEach(([key, value]) => {
		addQueryParams(searchParams, key, value);
	});

	const finalQuery = searchParams.toString();
	if (finalQuery === '') {
		return pathname;
	}

	return `${pathname}?${finalQuery}`;
}

export function getRegionalQuery(lang: string) {
	const locale = getLocaleFromQuery(lang);
	return {
		lang: !locale || locale === defaultLocale ? undefined : locale,
	};
}

export function getRegionalUrl(url: string, query: UrlQuery, lang: string) {
	return updateQueryInUrl(url, query, getRegionalQuery(lang));
}

/**
 * Абсолютный канонический URL страницы: path + текущие query-параметры
 * с нормализованным `lang` (для дефолтной локали параметр опускается).
 * Единая точка истины для rel=canonical (app.vue) и URL страниц
 * в schema.org разметке — они обязаны совпадать.
 */
export function getCanonicalUrl(
	path: string,
	query: UrlQuery,
	lang: string,
): string {
	return getRegionalUrl(`${SITE_URL}${path}`, query, lang);
}

/**
 * Query для ссылки listing → detail-страницы: всегда regional (`lang`),
 * плюс активный фильтр городов, если он есть. Каждый город даёт свой
 * канонический URL детальной — нужно и для SEO, и чтобы выбор пользователя
 * сохранялся при переходе.
 */
export function getDetailLinkQuery(
	lang: string,
	filterCityIds?: readonly number[],
): Record<string, string | string[] | undefined> {
	const query: Record<string, string | string[] | undefined> = {
		...getRegionalQuery(lang),
	};
	if (filterCityIds?.length) {
		query.cityIds = filterCityIds.map(String);
	}
	return query;
}

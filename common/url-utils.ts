import {
	formatLocaleAsQuery,
	getLocaleFromQuery,
	defaultLocale,
} from '~/composables/use-locale';

function addQueryParams(
	searchParams: URLSearchParams,
	key: string,
	value: string | string[] | null,
) {
	if (Array.isArray(value)) {
		value.forEach((v) => {
			if (notEmpty(v)) {
				searchParams.append(key, v);
			}
		});
	} else if (notEmpty(value)) {
		searchParams.append(key, value as string);
	}
}

function notEmpty(value: string | string[] | null): boolean {
	return value != null && value !== '';
}

function updateQueryInUrl(
	pathname: string,
	query: Record<string, string | string[]>,
	newQuery: Record<string, string | string[]>,
) {
	const searchParams = new URLSearchParams();

	Object.entries(query).forEach(([key, value]) => {
		if (key in newQuery) {
			return;
		} else {
			addQueryParams(searchParams, key, value as string | string[]);
		}
	});

	Object.entries(newQuery).forEach(([key, value]) => {
		addQueryParams(searchParams, key, value as string | string[]);
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

export function getRegionalUrl(
	url: string,
	query: Record<string, string | string[]>,
	lang: string,
) {
	return updateQueryInUrl(url, query, getRegionalQuery(lang));
}

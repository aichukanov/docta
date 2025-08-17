import {
	CountryCode,
	getCountryCodeFromQuery,
} from '~/composables/use-country';
import {
	getCurrencyFromCountry,
	getCurrencyFromQuery,
} from '~/composables/currency';
import {
	getLocaleFromCountry,
	getLocaleFromQuery,
	Locale,
} from '~/composables/use-locale';
import { Currency } from '~/enums/currency';
import { getRegionalUrl } from '../../../common/url-utils';

export function fixUrlRegionalParams(
	event: any,
): { status: 301 | 302; url: string } | null {
	const query = getQuery(event);

	const countriesData = getCountriesForQuery(event);
	const currencyData = getCurrencyForQuery(event, countriesData.countryList);
	const localeData = getLocaleForQuery(event, countriesData.countryList);

	if (
		countriesData.redirectStatus ||
		currencyData.redirectStatus ||
		localeData.redirectStatus
	) {
		const { pathname } = getRequestURL(event);

		const statuses = [
			countriesData.redirectStatus,
			currencyData.redirectStatus,
			localeData.redirectStatus,
		].filter(Boolean) as (301 | 302)[];

		return {
			status: Math.min(...statuses) as 301 | 302,
			url: getRegionalUrl(
				pathname,
				query as Record<string, string | string[]>,
				countriesData.countryList,
				localeData.locale,
				currencyData.currency,
			),
		};
	}

	return null;
}

function getCountriesForQuery(event: any): {
	countryList: CountryCode[];
	redirectStatus: 301 | 302 | null;
} {
	const query = getQuery(event);

	let cookieCountry: CountryCode[] | null = null;
	const cookieValue = getCookie(event, 'country');
	if (cookieValue) {
		try {
			cookieCountry = getCountryCodeFromQuery(
				cookieValue.includes('[') ? JSON.parse(cookieValue) : cookieValue,
			);
		} catch (error) {
			// not valid cookie country
		}

		if (cookieCountry == null) {
			deleteCookie(event, 'country');
		}
	}

	const queryCountry = getCountryCodeFromQuery(
		query.country as string | string[],
	);

	const defaultCountryList = [CountryCode.MNE, CountryCode.BIH];

	return {
		countryList: cookieCountry || queryCountry || defaultCountryList,
		redirectStatus:
			queryCountry == null ||
			(Array.isArray(query.country) &&
				query.country.length > queryCountry.length)
				? 301
				: cookieCountry != null && !compareArrays(cookieCountry, queryCountry)
				? 302
				: null,
	};
}

function getLocaleForQuery(
	event: any,
	countries: CountryCode[],
): {
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
	const defaultLocale = getLocaleFromCountry(countries);

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

function getCurrencyForQuery(
	event: any,
	countries: CountryCode[],
): {
	currency: Currency;
	redirectStatus: 301 | 302 | null;
} {
	const query = getQuery(event);

	let cookieCurrency: Currency | null = null;
	const cookieValue = getCookie(event, 'currency');
	if (cookieValue) {
		cookieCurrency = getCurrencyFromQuery(cookieValue);

		if (cookieCurrency == null) {
			deleteCookie(event, 'currency');
		}
	}

	const queryCurrency = getCurrencyFromQuery(
		query.currency as string | string[],
	);

	const defaultCurrency = getCurrencyFromCountry(countries);

	return {
		currency: cookieCurrency || queryCurrency || defaultCurrency,
		redirectStatus:
			queryCurrency == null ||
			(Array.isArray(query.currency) && query.currency.length > 1)
				? 301
				: cookieCurrency != null && cookieCurrency !== queryCurrency
				? 302
				: null,
	};
}

function compareArrays(a: any[] | null, b: any[] | null): boolean {
	if (a == null || b == null) {
		return a == b;
	}

	if (a.length !== b.length) {
		return false;
	}

	for (let i = 0; i < a.length; i++) {
		if (a[i] !== b[i]) {
			return false;
		}
	}

	return a.every((value) => b.includes(value));
}

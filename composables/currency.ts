import { Currency } from '~/enums/currency';
import { CountryCode } from '~/composables/use-country';

export const rates = {
	[Currency.EUR]: {
		[Currency.EUR]: 1,
		[Currency.BAM]: 1.96,
	},
	[Currency.BAM]: {
		[Currency.BAM]: 1,
		[Currency.EUR]: 0.51,
	},
};

export function createFormatter(locale: string, currency: Currency) {
	const formatter = new Intl.NumberFormat(locale, {
		style: 'currency',
		currency,
		currencyDisplay: 'code',
	});

	// Заменяем BAM на KM для всех локалей
	if (currency === Currency.BAM) {
		return {
			format: (value: number) => {
				return formatter.format(value).replace('BAM', 'KM');
			},
		};
	}

	return formatter;
}

export const currencyList = [Currency.EUR, Currency.BAM];

export const currencyNames = {
	[Currency.EUR]: '€',
	[Currency.BAM]: 'KM',
};

export function getCurrencyFromQuery(
	query: string | string[],
): Currency | null {
	const currencyRaw: Currency = (
		Array.isArray(query) ? query[0] : query
	)?.toUpperCase() as Currency;
	if (currencyRaw && Currency[currencyRaw]) {
		return Currency[currencyRaw];
	}

	return null;
}

export function getCurrencyFromCountry(country: CountryCode[]): Currency {
	return country.length === 1 && country[0] === CountryCode.BIH
		? Currency.BAM
		: Currency.EUR;
}

export function convertToCurrency(
	amount: number,
	fromCurrency: Currency,
	toCurrency: Currency,
) {
	return Math.ceil(amount * rates[fromCurrency][toCurrency] * 100) / 100;
}

export function formatCurrencyAsQuery(currency: Currency): string {
	return currency.toLowerCase();
}

import { Currency } from '~/enums/currency';

const uiCurrency = ref<Currency>(Currency.EUR);

export function setCurrency(currency: Currency) {
	uiCurrency.value = currency;
}

export function useCurrency() {
	const { locale } = useI18n({ useScope: 'global' });

	function convertToUserCurrency(amount: number, currency: Currency) {
		return convertToCurrency(amount, currency, uiCurrency.value);
	}

	function localizeCurrency(amount: number, currency: Currency) {
		return formatCurrency(convertToUserCurrency(amount, currency), currency);
	}

	function formatCurrency(amount: number, currency: Currency) {
		const formatter = createFormatter(
			['ba', 'me'].includes(locale.value) ? 'sr' : locale.value,
			currency,
		);
		return formatter.format(amount);
	}

	return {
		uiCurrency,
		currencyList,
		currencyNames,
		localizeCurrency,
		formatCurrency,
		convertToUserCurrency,
		getCurrencyFromQuery,
		getCurrencyFromCountry,
	};
}

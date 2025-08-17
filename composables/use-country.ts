import { ref } from 'vue';

export type Country = {
	name: string;
	code: string;
};

export enum CountryCode {
	MNE = 'ME',
	BIH = 'BA',
}

export const allCountries = [CountryCode.MNE, CountryCode.BIH];

const country = ref<CountryCode[]>([CountryCode.MNE]);

export const useCountry = () => {
	return {
		country,
	};
};

// For sql
export function getCountryCode({ country }: { country: string[] }) {
	if (!country) {
		return null;
	}

	const countriesLine = getCountryCodeList(country)?.join('", "');
	return `("${countriesLine}")`;
}

export function getCountryCodeFromQuery(country: string | string[]) {
	if (!country) {
		return null;
	}

	return getCountryCodeList(Array.isArray(country) ? country : [country]);
}

function getCountryCodeList(country: string[]) {
	if (!country) {
		return null;
	}

	const countriesDict: Partial<Record<CountryCode, true>> = {};
	for (let i = 0; i < country.length; i++) {
		const upperCountry: CountryCode = country[i].toUpperCase() as CountryCode;
		if (allCountries.includes(upperCountry)) {
			countriesDict[upperCountry] = true;
		}
	}

	const finalCountries = Object.keys(countriesDict) as CountryCode[];
	return finalCountries.length > 0 ? finalCountries : null;
}

export function enrichForCountry(str: string) {
	if (country.value.length === 1) {
		return `${str}-${country.value[0]}`;
	}

	return str;
}

export function formatCountriesAsQuery(country: CountryCode[]): string[] {
	return country.map((country) => country.toLowerCase());
}

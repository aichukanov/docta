import { Language } from '~/enums/language';

export const locales = [
	Language.SR,
	Language.SR_CYRILLIC,
	Language.EN,
	Language.RU,
	Language.DE,
	Language.TR,
];

export type Locale = (typeof locales)[number];
export const defaultLocale: (typeof locales)[number] = Language.SR;

export const localeNames: Record<Locale, string> = {
	[Language.SR]: 'Srpski / Crnogorski',
	[Language.EN]: 'English',
	[Language.RU]: 'Русский',
	[Language.DE]: 'Deutsch',
	[Language.TR]: 'Türkçe',
	[Language.SR_CYRILLIC]: 'Српски (ћирилица)',
};

export const localeShortNames: Record<Locale, string> = {
	[Language.SR]: 'ME',
	[Language.EN]: 'EN',
	[Language.RU]: 'RU',
	[Language.DE]: 'DE',
	[Language.TR]: 'TR',
	[Language.SR_CYRILLIC]: 'SR',
};

export function getLocaleFromQuery(value: string | string[]): Locale | null {
	if (!value) {
		return null;
	}

	const locale = formatLocaleAsQuery(
		(Array.isArray(value) ? value[0] : value) || '',
	);

	return locale &&
		(locales.includes(locale) ||
			locale === Language.ME ||
			locale === Language.BA)
		? locale
		: null;
}

export function formatLocaleAsQuery(lang: Locale): string {
	return lang ? lang.toLowerCase() : '';
}

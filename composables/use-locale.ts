import { Language } from '~/enums/language';

export const locales = [
	Language.SR,
	Language.BA,
	Language.ME,
	Language.EN,
	Language.RU,
	Language.DE,
	Language.TR,
];

export type Locale = (typeof locales)[number];
export const defaultLocale: (typeof locales)[number] = Language.SR;

export const localeNames: Record<Locale, string> = {
	[Language.SR]: 'Srpski',
	[Language.BA]: 'Bosanski',
	[Language.ME]: 'Crnogorski',
	[Language.EN]: 'English',
	[Language.RU]: 'Русский',
	[Language.DE]: 'Deutsch',
	[Language.TR]: 'Türkçe',
};

export function getLocaleFromQuery(value: string | string[]): Locale | null {
	const locale = (
		(Array.isArray(value) ? value[0] : value) || ''
	).toLowerCase();

	return locale && locales.includes(locale) ? locale : null;
}

export function formatLocaleAsQuery(lang: Locale): string {
	return lang.toLowerCase();
}

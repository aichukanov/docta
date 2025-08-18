export const locales = ['sr', 'ba', 'me', 'en', 'ru', 'de', 'tr'];

export type Locale = (typeof locales)[number];
export const defaultLocale: (typeof locales)[number] = 'sr';

export const localeNames: Record<Locale, string> = {
	sr: 'Srpski',
	ba: 'Bosanski',
	me: 'Crnogorski',
	en: 'English',
	ru: 'Русский',
	de: 'Deutsch',
	tr: 'Türkçe',
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

import { Language } from '~/enums/language';

export const locales = [
	Language.SR,
	Language.SR_CYRILLIC,
	Language.EN,
	Language.RU,
	Language.DE,
	Language.TR,
] as const;

export type Locale = (typeof locales)[number];
export const defaultLocale: Locale = Language.SR;

// Устаревшие локали: принимаются во входящих URL/cookie, дальше 301-редиректятся на defaultLocale
const legacyLocales = [Language.ME, Language.BA] as const;
export type LegacyLocale = (typeof legacyLocales)[number];

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

export function getLocaleFromQuery(
	value?: string | string[] | null,
): Locale | LegacyLocale | null {
	if (!value) {
		return null;
	}

	const locale = formatLocaleAsQuery(
		(Array.isArray(value) ? value[0] : value) || '',
	);

	if ((locales as readonly string[]).includes(locale)) {
		return locale as Locale;
	}

	if ((legacyLocales as readonly string[]).includes(locale)) {
		return locale as LegacyLocale;
	}

	return null;
}

export function formatLocaleAsQuery(lang: string): string {
	return lang ? lang.toLowerCase() : '';
}

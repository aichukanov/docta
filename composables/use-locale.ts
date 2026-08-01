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

/**
 * Код локали → тег для атрибута `hreflang`.
 *
 * Наши коды локалей живут в URL (`?lang=sr-cyrl`) и потому строчные, а BCP 47
 * требует у скрипта заглавную первую букву: `sr-Cyrl`. Google к регистру
 * нечувствителен, поведение Яндекса не проверялось — а в его индексе
 * sr-cyrl-страниц ровно ноль (docs/audit/seo-2026-07.md). Правка дешёвая и
 * делает разметку валидной; ждать от неё многого не стоит.
 *
 * `sr` намеренно остаётся как есть, а не превращается в `sr-Latn`: это
 * дефолтная локаль с наибольшим числом показов, менять ей тег ради формальной
 * симметрии — риск без выигрыша. `sr` + `sr-Cyrl` — валидная пара, где
 * первый тег означает «сербский без уточнения скрипта».
 *
 * Регистр важен только в hreflang. В URL, cookie и `?lang=` код остаётся
 * строчным — там его сравнивают через `formatLocaleAsQuery`.
 */
const HREFLANG_TAGS: Partial<Record<Locale, string>> = {
	[Language.SR_CYRILLIC]: 'sr-Cyrl',
};

export function getHreflangTag(locale: Locale | string): string {
	return HREFLANG_TAGS[locale as Locale] ?? locale;
}

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

/**
 * Утилита для определения локали пользователя
 */
import { Language } from '~/enums/language';
import { executeQuery } from '~/server/common/db-mysql';
import type { H3Event } from 'h3';
import { getHeader } from 'h3';

// todo: проверить, насколько это нужно, нельзя ли оперировать одним объектом пользователя

/**
 * Получить предпочитаемую локаль пользователя из БД
 */
export async function getUserPreferredLocale(
	userId: number,
): Promise<Language | null> {
	try {
		const results = await executeQuery(
			'SELECT preferred_locale FROM auth_users WHERE id = ?',
			[userId],
		);

		if (results.length > 0 && results[0].preferred_locale) {
			return results[0].preferred_locale as Language;
		}
	} catch (error) {
		console.error('Failed to get user preferred locale:', error);
	}

	return null;
}

/**
 * Получить локаль пользователя из Google OAuth профиля
 */
async function getUserLocaleFromGoogleProfile(
	userId: number,
): Promise<Language | null> {
	try {
		const results = await executeQuery(
			`SELECT gp.locale
			 FROM auth_oauth_profiles_google gp
			 JOIN auth_oauth_accounts oa ON oa.id = gp.oauth_account_id
			 WHERE oa.user_id = ?`,
			[userId],
		);

		if (results.length > 0 && results[0].locale) {
			const locale = results[0].locale.toLowerCase();
			// Сопоставляем локали
			const localeMap: Record<string, Language> = {
				'sr': Language.SR,
				'en': Language.EN,
				'ru': Language.RU,
				'de': Language.DE,
				'tr': Language.TR,
				'sr-cyrl': Language.SR_CYRILLIC,
			};

			return localeMap[locale] || null;
		}
	} catch (error) {
		// Игнорируем ошибки, просто вернем null
		console.error('Failed to get user locale from Google profile:', error);
	}

	return null;
}

/**
 * Парсинг Accept-Language header
 */
function parseAcceptLanguage(acceptLanguage: string): Language | null {
	if (!acceptLanguage) return null;

	// Парсим Accept-Language header (например: "ru-RU,ru;q=0.9,en;q=0.8")
	const languages = acceptLanguage
		.split(',')
		.map((lang) => {
			const parts = lang.trim().split(';');
			const code = parts[0].toLowerCase();
			const quality = parts[1] ? parseFloat(parts[1].split('=')[1]) : 1.0;
			return { code, quality };
		})
		.sort((a, b) => b.quality - a.quality);

	// Маппинг языковых кодов на Language enum
	const languageMap: Record<string, Language> = {
		'sr': Language.SR,
		'sr-cyrl': Language.SR_CYRILLIC,
		'sr-latn': Language.SR,
		'en': Language.EN,
		'ru': Language.RU,
		'de': Language.DE,
		'tr': Language.TR,
	};

	// Ищем подходящий язык
	for (const { code } of languages) {
		// Проверяем полный код (например, "ru-RU")
		if (languageMap[code]) {
			return languageMap[code];
		}

		// Проверяем только языковую часть (например, "ru" из "ru-RU")
		const langCode = code.split('-')[0];
		if (languageMap[langCode]) {
			return languageMap[langCode];
		}
	}

	return null;
}

/**
 * Определить локаль из явного значения или Accept-Language header.
 * Используется, когда пользователя ещё нет в БД (регистрация).
 */
export function getLocaleFromRequest(
	explicitLocale: string | undefined,
	event?: H3Event,
): Language {
	if (
		explicitLocale &&
		Object.values(Language).includes(explicitLocale as Language)
	) {
		return explicitLocale as Language;
	}

	if (event) {
		const acceptLanguage = getHeader(event, 'accept-language');
		if (acceptLanguage) {
			const headerLocale = parseAcceptLanguage(acceptLanguage);
			if (headerLocale) {
				return headerLocale;
			}
		}
	}

	return Language.SR;
}

/**
 * Определить локаль пользователя
 * Приоритет:
 * 1. Локаль из профиля пользователя (preferred_locale)
 * 2. Локаль из Google OAuth профиля (если есть)
 * 3. Локаль из Accept-Language header
 * 4. Локаль по умолчанию (Serbian)
 */
export async function getUserLocale(
	userId: number | null,
	event?: H3Event,
): Promise<Language> {
	// 1. Пробуем получить из профиля пользователя
	if (userId) {
		const preferredLocale = await getUserPreferredLocale(userId);
		if (preferredLocale) {
			return preferredLocale;
		}

		// 2. Пробуем получить из Google профиля
		const googleLocale = await getUserLocaleFromGoogleProfile(userId);
		if (googleLocale) {
			return googleLocale;
		}
	}

	// 3. Пробуем получить из Accept-Language header
	if (event) {
		const acceptLanguage = getHeader(event, 'accept-language');
		if (acceptLanguage) {
			const headerLocale = parseAcceptLanguage(acceptLanguage);
			if (headerLocale) {
				return headerLocale;
			}
		}
	}

	// 4. Возвращаем локаль по умолчанию
	return Language.SR;
}

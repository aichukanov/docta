import { Language } from '~/enums/language';

const DEFAULT_LOCALE = Language.SR;

/**
 * Получает BASE_URL из переменных окружения с валидацией
 * @throws {Error} Если BASE_URL не установлен
 */
export function getBaseUrl(): string {
	const baseUrl = process.env.BASE_URL;

	if (!baseUrl) {
		throw new Error('BASE_URL environment variable is required');
	}

	return baseUrl;
}

/**
 * Формирует локализованный URL с query-параметром lang=XX.
 * Для дефолтной локали (sr) параметр не добавляется.
 */
export function getLocalizedUrl(path: string, locale: Language): string {
	const base = getBaseUrl();
	if (locale === DEFAULT_LOCALE) {
		return `${base}${path}`;
	}
	const separator = path.includes('?') ? '&' : '?';
	return `${base}${path}${separator}lang=${locale}`;
}

/**
 * OAuth providers constants and validation utilities
 * Централизованное управление списком OAuth провайдеров
 */

/**
 * Список доступных OAuth провайдеров
 */
export const OAUTH_PROVIDERS = ['google', 'telegram', 'facebook'] as const;

/**
 * Тип OAuth провайдера
 */
export type OAuthProvider = (typeof OAUTH_PROVIDERS)[number];

/**
 * Список методов аутентификации (включая email)
 */
export const AUTH_METHODS = ['email', ...OAUTH_PROVIDERS] as const;

/**
 * Тип метода аутентификации
 */
export type AuthMethod = (typeof AUTH_METHODS)[number];

/**
 * Проверяет, является ли строка валидным OAuth провайдером
 */
export function isValidOAuthProvider(value: unknown): value is OAuthProvider {
	return (
		typeof value === 'string' &&
		OAUTH_PROVIDERS.includes(value as OAuthProvider)
	);
}

/**
 * Проверяет, является ли строка валидным методом аутентификации
 */
export function isValidAuthMethod(value: unknown): value is AuthMethod {
	return (
		typeof value === 'string' && AUTH_METHODS.includes(value as AuthMethod)
	);
}

/**
 * Проверяет, является ли строка валидным primary provider (может быть null)
 */
export function isValidPrimaryProvider(
	value: unknown,
): value is OAuthProvider | null {
	return value === null || isValidOAuthProvider(value);
}

/**
 * Получает все доступные OAuth провайдеры
 */
export function getAvailableProviders(): readonly OAuthProvider[] {
	return OAUTH_PROVIDERS;
}

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

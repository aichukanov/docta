export function sanitizeLink(link: string): string {
	// Убираем все пробелы и оставляем только валидные символы для URL
	return link
		.replace(/\s+/g, '') // убираем все пробелы
		.replace(/[^a-zA-Z0-9\-._~:/?#[\]@!$&'()*+,;=%]/g, ''); // оставляем только валидные символы URL
}

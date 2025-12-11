export function sanitizeLink(link: string): string {
	// Убираем все пробелы и оставляем только валидные символы для URL
	return link
		.replace(/\s+/g, '') // убираем все пробелы
		.replace(/[^a-zA-Z0-9\-._~:/?#[\]@!$&'()*+,;=%]/g, ''); // оставляем только валидные символы URL
}

export function parseClinicPricesData(
	clinicPricesData: string | null,
): Array<{ clinicId: number; price: number | null; code: string | null }> {
	if (!clinicPricesData) {
		return [];
	}

	return clinicPricesData.split(',').map((priceData) => {
		const [clinicId, price, code] = priceData.split(':');
		return {
			clinicId: Number(clinicId),
			price: Number(price) || null,
			code: code || null,
		};
	});
}

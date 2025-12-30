export function sanitizeLink(link: string): string {
	// Убираем все пробелы и оставляем только валидные символы для URL
	return link
		.replace(/\s+/g, '') // убираем все пробелы
		.replace(/[^a-zA-Z0-9\-._~:/?#[\]@!$&'()*+,;=%]/g, ''); // оставляем только валидные символы URL
}

const LOCALE_TO_NAME_FIELD: Record<string, string> = {
	en: 'name',
	ru: 'name_ru',
	sr: 'name_sr',
	me: 'name_sr',
	de: 'name_de',
	tr: 'name_tr',
};

/**
 * Возвращает имя поля для локализованного названия
 */
export function getLocalizedNameField(locale?: string): string {
	return LOCALE_TO_NAME_FIELD[locale || 'en'] || 'name';
}

/**
 * Генерирует SQL ORDER BY для сортировки по цене:
 * сначала клиники с ценой (от дешёвых к дорогим), потом без цены
 * @param tableAlias - алиас таблицы (например 'clt', 'cm', 'cms'), или пустая строка для подзапросов
 */
export function getPriceOrderBySQL(tableAlias: string = ''): string {
	const priceField = tableAlias ? `${tableAlias}.price` : 'price';
	return `CASE WHEN ${priceField} > 0 THEN 0 ELSE 1 END, CASE WHEN ${priceField} > 0 THEN ${priceField} ELSE 999999999 END`;
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

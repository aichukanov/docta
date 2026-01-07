export function sanitizeLink(link: string): string {
	// Убираем все пробелы и оставляем только валидные символы для URL
	return link
		.replace(/\s+/g, '') // убираем все пробелы
		.replace(/[^a-zA-Z0-9\-._~:/?#[\]@!$&'()*+,;=%]/g, ''); // оставляем только валидные символы URL
}

const LOCALE_TO_NAME_FIELD: Record<string, string> = {
	'en': 'name_en',
	'ru': 'name_ru',
	'sr': 'name_sr',
	'de': 'name_de',
	'tr': 'name_tr',
	'sr-cyrl': 'name_sr_cyrl',
};

/**
 * Возвращает имя поля для локализованного названия
 */
export function getLocalizedNameField(locale?: string): string {
	return LOCALE_TO_NAME_FIELD[locale];
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
): Array<{ clinicId: number; price: number | null; priceMax: number | null; code: string | null }> {
	if (!clinicPricesData) {
		return [];
	}

	return clinicPricesData.split(',').map((priceData) => {
		const [clinicId, price, priceMax, code] = priceData.split(':');
		return {
			clinicId: Number(clinicId),
			price: price && price !== '0' ? Number(price) : null,
			priceMax: priceMax && priceMax !== '0' ? Number(priceMax) : null,
			code: code || null,
		};
	});
}

/**
 * Обрабатывает локализованные имена для клиник и врачей
 * Если locale = 'sr': возвращает только name (сербская латиница)
 * Если другие локали: возвращает локализованное имя (если есть) или сербское (если нет) + оригинальное имя на сербском латиницей
 */
export function processLocalizedNameForClinicOrDoctor(
	row: any,
	locale?: string,
): { name: string; localName: string } {
	const normalizedLocale = locale || 'en';

	// Для сербской локали возвращаем только оригинальное имя
	if (normalizedLocale === 'sr') {
		const name = row.name_sr || row.name_en || '';
		return {
			name,
			localName: '',
		};
	}

	// Для сербской кириллицы возвращаем только кириллицу
	if (normalizedLocale === 'sr-cyrl') {
		const localizedName = row.name_sr_cyrl || row.name_sr || row.name_en || '';
		const localName = row.name_sr || row.name_en || '';

		return {
			name: localizedName,
			localName: localizedName !== localName && localName ? localName : '',
		};
	}

	// Для русской локали: русское имя (если есть) или сербское латиницей (если нет) + оригинальное имя
	if (normalizedLocale === 'ru') {
		const localizedName = row.name_ru || row.name_sr || row.name_en || '';
		const localName = row.name_sr || row.name_en || '';

		return {
			name: localizedName,
			localName: localizedName !== localName && localName ? localName : '',
		};
	}

	// Для английской локали: английское имя (если есть) или сербское (если нет) + оригинальное имя
	if (normalizedLocale === 'en') {
		const localizedName = row.name_en || row.name_sr || '';
		const localName = row.name_sr || '';

		return {
			name: localizedName,
			localName: localizedName !== localName && localName ? localName : '',
		};
	}

	// Для других локалей (de, tr и т.д.): локализованное имя (если есть) или сербское (если нет) + оригинальное имя
	const nameField = getLocalizedNameField(normalizedLocale);
	let localizedName = row[nameField] || row.name_sr || row.name_en || '';
	const localName = row.name_sr || row.name_en || '';

	return {
		name: localizedName,
		localName: localizedName !== localName && localName ? localName : '',
	};
}

/**
 * Обрабатывает локализованные имена для лабораторных тестов
 * Если locale = 'sr': возвращает только name_sr (сербская латиница)
 * Если другие локали: возвращает локализованное имя (если есть) или сербское (если нет) + оригинальное имя на сербском латиницей
 */
export function processLocalizedNameForLabTest(
	row: any,
	locale?: string,
): { name: string; localName: string } {
	const normalizedLocale = locale || 'en';

	// Для сербской локали возвращаем только сербскую латиницу
	if (normalizedLocale === 'sr') {
		const name = row.name_sr || row.name_en || '';
		return {
			name,
			localName: '',
		};
	}

	// Для сербской кириллицы возвращаем только кириллицу
	if (normalizedLocale === 'sr-cyrl') {
		const localizedName = row.name_sr_cyrl || row.name_sr || row.name_en || '';
		const localName = row.name_sr || row.name_en || '';

		return {
			name: localizedName,
			localName: localizedName !== localName && localName ? localName : '',
		};
	}

	// Для других локалей: локализованное имя (если есть) или сербское (если нет) + оригинальное имя
	const nameField = getLocalizedNameField(normalizedLocale);
	let localizedName = row[nameField] || row.name_sr || row.name_en || '';
	const localName = row.name_sr || row.name_en || '';

	return {
		name: localizedName,
		localName: localizedName !== localName && localName ? localName : '',
	};
}

/**
 * Обрабатывает локализованные значения для town и address клиник
 * Если locale = 'sr': возвращает только значение на сербской латинице
 * Если locale = 'sr-cyrl': возвращает значение на кириллице или латинице как fallback
 * Если другие локали: возвращает значение на сербской латинице (оригинал)
 */
export function processLocalizedFieldForClinic(
	row: any,
	fieldName: 'town' | 'address',
	locale?: string,
): string {
	const normalizedLocale = locale || 'en';
	const baseField = `${fieldName}_sr`;
	const cyrlField = `${fieldName}_sr_cyrl`;

	// Для сербской локали возвращаем только оригинальное значение
	if (normalizedLocale === 'sr') {
		return row[baseField] || '';
	}

	// Для сербской кириллицы возвращаем кириллицу или латиницу как fallback
	if (normalizedLocale === 'sr-cyrl') {
		return row[cyrlField] || row[baseField] || '';
	}

	// Для других локалей (en, ru, de, tr и т.д.): сербское значение (оригинал)
	return row[baseField] || '';
}

/**
 * Обрабатывает локализованные значения для description клиник
 * Если locale = 'sr': возвращает только значение на сербской латинице
 * Если locale = 'sr-cyrl': возвращает значение на кириллице или латинице как fallback
 * Если другие локали: возвращает локализованное значение (если есть) или сербское (если нет)
 */
export function processLocalizedDescriptionForClinic(
	row: any,
	locale?: string,
): string {
	const normalizedLocale = locale || 'en';

	// Для сербской локали возвращаем только сербское значение
	if (normalizedLocale === 'sr') {
		return row.description_sr || '';
	}

	// Для сербской кириллицы возвращаем кириллицу или латиницу как fallback
	if (normalizedLocale === 'sr-cyrl') {
		return row.description_sr_cyrl || row.description_sr || '';
	}

	// Для других локалей: локализованное значение (если есть) или сербское (если нет)
	const descriptionField = `description_${normalizedLocale}`;
	return row[descriptionField] || row.description_sr || '';
}

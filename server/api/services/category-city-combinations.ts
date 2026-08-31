import { getCategoryCityCombinations } from '~/server/common/sitemap/filters/services';

// Пары (категория услуги, город) — источник для хабов перелинковки на
// /services (см. docs/audit/seo-2026-07.md, пункт 1b).

// Кэш на час: набор меняется только при правке услуг, а блок подсказок
// дожидается каждый листинг. Кэшируется функция, а не хендлер, — чтобы пустой
// список из catch не застревал в кэше после разовой ошибки БД.
const getCached = defineCachedFunction(getCategoryCityCombinations, {
	name: 'service-category-city-combinations',
	getKey: () => 'all',
	maxAge: 60 * 60,
	swr: true,
});

export default defineEventHandler(async () => {
	try {
		const categoryCityCombinations = await getCached();
		return { categoryCityCombinations };
	} catch (error) {
		console.error('API Error - services/category-city-combinations:', error);
		return { categoryCityCombinations: [] };
	}
});

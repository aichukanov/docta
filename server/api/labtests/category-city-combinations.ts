import { getCategoryCityCombinations } from '~/server/common/sitemap/filters/labtests';

// Пары (категория анализа, город) — источник для хабов перелинковки на
// /labtests (см. docs/audit/seo-2026-07.md, пункт 1b).

// Кэш на час: набор меняется только при правке анализов, а блок подсказок
// дожидается каждый листинг. Кэшируется функция, а не хендлер, — чтобы пустой
// список из catch не застревал в кэше после разовой ошибки БД.
const getCached = defineCachedFunction(getCategoryCityCombinations, {
	name: 'labtest-category-city-combinations',
	getKey: () => 'all',
	maxAge: 60 * 60,
	swr: true,
});

export default defineEventHandler(async () => {
	try {
		const categoryCityCombinations = await getCached();
		return { categoryCityCombinations };
	} catch (error) {
		console.error('API Error - labtests/category-city-combinations:', error);
		return { categoryCityCombinations: [] };
	}
});

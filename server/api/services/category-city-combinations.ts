import { getCategoryCityCombinations } from '~/server/common/sitemap/filters/services';

// Пары (категория услуги, город) — источник для хабов перелинковки на
// /services (см. docs/audit/seo-2026-07.md, пункт 1b).
export default defineEventHandler(async () => {
	try {
		const categoryCityCombinations = await getCategoryCityCombinations();
		return { categoryCityCombinations };
	} catch (error) {
		console.error('API Error - services/category-city-combinations:', error);
		return { categoryCityCombinations: [] };
	}
});

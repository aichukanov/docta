import { getCategoryCityCombinations } from '~/server/common/sitemap/filters/labtests';

// Пары (категория анализа, город) — источник для хабов перелинковки на
// /labtests (см. docs/audit/seo-2026-07.md, пункт 1b).
export default defineEventHandler(async () => {
	try {
		const categoryCityCombinations = await getCategoryCityCombinations();
		return { categoryCityCombinations };
	} catch (error) {
		console.error('API Error - labtests/category-city-combinations:', error);
		return { categoryCityCombinations: [] };
	}
});

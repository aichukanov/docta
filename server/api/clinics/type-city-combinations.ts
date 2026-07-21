import { getTypeCityCombinations } from '~/server/common/sitemap/filters/clinics';
import { SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS } from '~/common/constants';

// Пары (тип клиники, город) с достаточным числом клиник — источник для хабов
// перелинковки на /clinics (см. docs/audit/seo-2026-07.md, пункт 1b). Тот же
// порог, что и для sitemap, чтобы не ссылаться на тонкие страницы.
export default defineEventHandler(async () => {
	try {
		const typeCityCombinations = await getTypeCityCombinations(
			SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS,
		);
		return { typeCityCombinations };
	} catch (error) {
		console.error('API Error - clinics/type-city-combinations:', error);
		return { typeCityCombinations: [] };
	}
});

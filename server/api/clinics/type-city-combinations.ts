import { getTypeCityCombinations } from '~/server/common/sitemap/filters/clinics';
import { SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS } from '~/common/constants';

// Пары (тип клиники, город) с достаточным числом клиник — источник для хабов
// перелинковки на /clinics (см. docs/audit/seo-2026-07.md, пункт 1b). Тот же
// порог, что и для sitemap, чтобы не ссылаться на тонкие страницы.

// Набор меняется только при импорте или правке клиник, а дожидается его КАЖДЫЙ
// листинг — блок подсказок стоит на всех. Кэшируем на час.
//
// Кэшируется внутренняя функция, а не хендлер целиком: тогда исключение
// пробрасывается наружу и в кэш не попадает, а пустой список из catch ниже не
// застревает там на час после разовой ошибки БД.
const getCached = defineCachedFunction(getTypeCityCombinations, {
	name: 'clinic-type-city-combinations',
	getKey: (minClinics: number) => String(minClinics),
	maxAge: 60 * 60,
	swr: true,
});

export default defineEventHandler(async () => {
	try {
		const typeCityCombinations = await getCached(
			SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS,
		);
		return { typeCityCombinations };
	} catch (error) {
		console.error('API Error - clinics/type-city-combinations:', error);
		return { typeCityCombinations: [] };
	}
});

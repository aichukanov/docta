import { getSpecialtyCityCombinations } from '~/server/common/sitemap/filters/doctors';

// Пары (специальность, город), где реально есть хоть один врач — источник для
// хабов перелинковки на /doctors (см. docs/audit/seo-2026-07.md, пункт 1b).
// Тот же запрос, что и для sitemap-фильтров, чтобы не ссылаться на пустые комбинации.

// Кэш на час: набор меняется только при правке врачей, а блок подсказок стоит
// на каждом листинге. Кэшируется функция, а не хендлер, — чтобы пустой список
// из catch не попадал в кэш после разовой ошибки БД.
const getCached = defineCachedFunction(getSpecialtyCityCombinations, {
	name: 'doctor-specialty-city-combinations',
	getKey: () => 'all',
	maxAge: 60 * 60,
	swr: true,
});

export default defineEventHandler(async () => {
	try {
		const specialtyCityCombinations = await getCached();
		return { specialtyCityCombinations };
	} catch (error) {
		console.error('API Error - doctors/specialty-city-combinations:', error);
		return { specialtyCityCombinations: [] };
	}
});

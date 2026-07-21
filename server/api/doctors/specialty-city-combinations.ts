import { getSpecialtyCityCombinations } from '~/server/common/sitemap/filters/doctors';

// Пары (специальность, город), где реально есть хоть один врач — источник для
// хабов перелинковки на /doctors (см. docs/audit/seo-2026-07.md, пункт 1b).
// Тот же запрос, что и для sitemap-фильтров, чтобы не ссылаться на пустые комбинации.
export default defineEventHandler(async () => {
	try {
		const specialtyCityCombinations = await getSpecialtyCityCombinations();
		return { specialtyCityCombinations };
	} catch (error) {
		console.error(
			'API Error - doctors/specialty-city-combinations:',
			error,
		);
		return { specialtyCityCombinations: [] };
	}
});

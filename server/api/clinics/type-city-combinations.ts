import { getSitemapFilters } from '~/server/common/sitemap/filters/clinics';
import { SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS } from '~/common/constants';

// Все фасеты /clinics, которые публикует sitemap: одиночные города, одиночные
// типы клиник и пары «тип+город» с порогом
// SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS. Источник для хабов перелинковки
// (см. docs/audit/seo-2026-07.md, пункт 1b).
//
// Раньше отдавались только пары, и одиночные фасеты хаб мог показать лишь те,
// что встречаются в парах: 3 типа и 8 городов, не набирающие порога ни с кем,
// в sitemap были, а входящих ссылок не имели. Берём ровно `getSitemapFilters` —
// ту же функцию, из которой строится секция `clinic-filters`, чтобы набор
// ссылок был подмножеством публикуемого по построению, а не по договорённости.

// Набор меняется только при импорте или правке клиник, а дожидается его КАЖДЫЙ
// листинг — блок подсказок стоит на всех. Кэшируем на час.
//
// Кэшируется внутренняя функция, а не хендлер целиком: тогда исключение
// пробрасывается наружу и в кэш не попадает, а пустой ответ из catch ниже не
// застревает там на час после разовой ошибки БД.
//
// Имя ключа новое: под прежним ('clinic-type-city-combinations') в `.data/cache`
// лежит значение прошлой формы — голый массив пар. `swr` отдал бы его сразу и
// без вопросов, и первый час после выката хаб не видел бы ни городов, ни типов.
const getCached = defineCachedFunction(getSitemapFilters, {
	name: 'clinic-sitemap-facets',
	getKey: (minClinics: number) => String(minClinics),
	maxAge: 60 * 60,
	swr: true,
});

export default defineEventHandler(async () => {
	try {
		const facets = await getCached(SITEMAP_CLINIC_TYPE_CITY_MIN_CLINICS);

		// Даты изменения из ответа выкидываем: они нужны только `<lastmod>` в
		// sitemap, а тут поехали бы полем на каждую из ~60 строк в каждый заход
		// на каждый листинг клиник.
		return {
			cityIds: facets.cityIds.map((facet) => facet.cityId),
			clinicTypeIds: facets.clinicTypeIds.map((facet) => facet.clinicTypeId),
			typeCityCombinations: facets.typeCityCombinations.map((combo) => ({
				clinicTypeId: combo.clinicTypeId,
				cityId: combo.cityId,
				clinicCount: combo.clinicCount,
			})),
		};
	} catch (error) {
		console.error('API Error - clinics/type-city-combinations:', error);
		return { cityIds: [], clinicTypeIds: [], typeCityCombinations: [] };
	}
});

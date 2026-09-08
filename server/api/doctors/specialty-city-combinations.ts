import {
	getSpecialtyCityCombinations,
	getSpecialtyLanguageCombinations,
} from '~/server/common/sitemap/filters/doctors';

// Источники фасетов для хабов перелинковки на /doctors (см.
// docs/audit/seo-2026-07.md, пункт 1b). Оба набора — те же запросы, что и у
// sitemap-фильтров: набор ссылок обязан быть подмножеством публикуемого, иначе
// хаб заводит индексируемую поверхность, которой нет в sitemap.
//
// Имя маршрута осталось прежним, хотя теперь он отдаёт и языки: адрес уже
// закэширован Cloudflare и зашит в `useFetch`-ключ, а переименование ради
// точности формулировки стоило бы дороже, чем комментарий.

// Кэш на час: наборы меняются только при правке врачей, а блок подсказок
// дожидается каждый листинг. Кэшируется функция, а не хендлер, — чтобы пустой
// список из catch не попадал в кэш после разовой ошибки БД.
//
// Два кэша, а не один на объект: у пар «специальность+город» имя ключа уже
// живёт в `.data/cache` с прошлой выкладки и отдаёт МАССИВ. Один общий ключ с
// новой формой ответа пришлось бы называть иначе, иначе `swr` первый час отдавал
// бы старое значение под новым контрактом (та же ловушка, что описана у
// `getSitemapIndex`). Раздельные кэши обходятся без переименования.
const getCachedCityCombinations = defineCachedFunction(
	getSpecialtyCityCombinations,
	{
		name: 'doctor-specialty-city-combinations',
		getKey: () => 'all',
		maxAge: 60 * 60,
		swr: true,
	},
);

const getCachedLanguageCombinations = defineCachedFunction(
	getSpecialtyLanguageCombinations,
	{
		name: 'doctor-specialty-language-combinations',
		getKey: () => 'all',
		maxAge: 60 * 60,
		swr: true,
	},
);

export default defineEventHandler(async () => {
	try {
		const [cityCombinations, languageCombinations] = await Promise.all([
			getCachedCityCombinations(),
			getCachedLanguageCombinations(),
		]);

		// Даты изменения из ответа выкидываем: они нужны только `<lastmod>` в
		// sitemap, а тут поехали бы полем на каждую из ~530 строк в каждый заход
		// на каждый листинг врачей.
		return {
			specialtyCityCombinations: cityCombinations.map((combo) => ({
				specialtyId: combo.specialtyId,
				cityId: combo.cityId,
			})),
			specialtyLanguageCombinations: languageCombinations.map((combo) => ({
				specialtyId: combo.specialtyId,
				languageId: combo.languageId,
			})),
		};
	} catch (error) {
		console.error('API Error - doctors/specialty-city-combinations:', error);
		return {
			specialtyCityCombinations: [],
			specialtyLanguageCombinations: [],
		};
	}
});

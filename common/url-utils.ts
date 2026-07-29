import {
	formatLocaleAsQuery,
	getLocaleFromQuery,
	defaultLocale,
} from '~/composables/use-locale';
import { SITE_URL } from '~/common/constants';

// Значения query: принимаем строки/числа (и их массивы) от кода приложения,
// а также null из vue-router LocationQuery. Пустые значения не попадают в URL.
export type UrlQueryValue =
	| string
	| number
	| null
	| undefined
	| Array<string | number | null>;
export type UrlQuery = Record<string, UrlQueryValue>;

function addQueryParams(
	searchParams: URLSearchParams,
	key: string,
	value: UrlQueryValue,
) {
	if (Array.isArray(value)) {
		value.forEach((v) => {
			if (notEmpty(v)) {
				searchParams.append(key, String(v));
			}
		});
	} else if (notEmpty(value)) {
		searchParams.append(key, String(value));
	}
}

function notEmpty(value: string | number | null | undefined): boolean {
	return value != null && value !== '';
}

/**
 * Канонический порядок query-параметров.
 *
 * Раньше порядок брался из объекта как есть, поэтому
 * `?specialtyIds=4&cityIds=1` и `?cityIds=1&specialtyIds=4` давали два разных
 * self-canonical на одинаковый контент (prd/silent-200-index-hygiene, итерация 3).
 *
 * Список НЕ алфавитный, и это принципиально: он воспроизводит порядок, который
 * сайт и sitemap уже отдают — фильтр сущности перед `cityIds`, `substanceIds`
 * перед `atcGroupIds`, `specialtyIds` перед `languageIds`. Проверено по
 * прод-sitemap: все 12 встречающихся там комбинаций остаются побайтово теми же.
 * Алфавитная сортировка сломала бы каждую из них, а фасеты дают 29% показов в
 * Google — переезд на новую форму URL стоил бы дороже, чем исправляемый дубль.
 * Поэтому перестановки нормализуются К СУЩЕСТВУЮЩЕЙ форме, а не к новой.
 *
 * `lang` в списке нет: он всегда уезжает последним (приходит через `newQuery`).
 * Неизвестные параметры сохраняют относительный порядок и идут после known.
 */
const CANONICAL_QUERY_ORDER = [
	'substanceIds',
	'specialtyIds',
	'serviceCategoryIds',
	'categoryIds',
	'clinicTypeIds',
	'atcGroupIds',
	'cityIds',
	'languageIds',
	'page',
];

function canonicalQueryRank(key: string): number {
	const index = CANONICAL_QUERY_ORDER.indexOf(key);
	return index === -1 ? CANONICAL_QUERY_ORDER.length : index;
}

function updateQueryInUrl(
	pathname: string,
	query: UrlQuery,
	newQuery: UrlQuery,
) {
	const searchParams = new URLSearchParams();

	Object.entries(query)
		// Стабильная сортировка: known-параметры в каноническом порядке,
		// остальные — в порядке появления.
		.sort(([a], [b]) => canonicalQueryRank(a) - canonicalQueryRank(b))
		.forEach(([key, value]) => {
			if (key in newQuery) {
				return;
			} else {
				addQueryParams(searchParams, key, value);
			}
		});

	Object.entries(newQuery).forEach(([key, value]) => {
		addQueryParams(searchParams, key, value);
	});

	const finalQuery = searchParams.toString();
	if (finalQuery === '') {
		return pathname;
	}

	return `${pathname}?${finalQuery}`;
}

export function getRegionalQuery(lang: string) {
	const locale = getLocaleFromQuery(lang);
	return {
		lang: !locale || locale === defaultLocale ? undefined : locale,
	};
}

export function getRegionalUrl(url: string, query: UrlQuery, lang: string) {
	return updateQueryInUrl(url, query, getRegionalQuery(lang));
}

/**
 * Параметры, которые не влияют на содержимое страницы и потому не должны
 * попадать в canonical.
 *
 * `tab` — чисто клиентский скролл к секции: `components/entity-page/tab-bar.vue`
 * читает его только в `onMounted`, серверная разметка от него не зависит вообще.
 * При этом Яндекс, исполнив JS, нашёл и проиндексировал 6 таких URL как
 * отдельные страницы (`/labtests/cholesterol?tab=clinics` и т.п.).
 *
 * `sort` СОЗНАТЕЛЬНО не входит: на страницах отзывов он меняет порядок, а
 * значит и состав конкретной страницы пагинации — канонизировать
 * `?sort=X&page=2` в `?page=2` было бы неправдой.
 */
const NON_CANONICAL_QUERY_KEYS = ['tab'];

/**
 * Абсолютный канонический URL страницы: path + текущие query-параметры
 * с нормализованным `lang` (для дефолтной локали параметр опускается),
 * в каноническом порядке и без UI-параметров.
 * Единая точка истины для rel=canonical (app.vue) и URL страниц
 * в schema.org разметке — они обязаны совпадать.
 */
export function getCanonicalUrl(
	path: string,
	query: UrlQuery,
	lang: string,
): string {
	const meaningfulQuery: UrlQuery = {};
	Object.entries(query).forEach(([key, value]) => {
		if (!NON_CANONICAL_QUERY_KEYS.includes(key)) {
			meaningfulQuery[key] = value;
		}
	});

	return getRegionalUrl(`${SITE_URL}${path}`, meaningfulQuery, lang);
}

/**
 * Query для ссылки listing → detail-страницы: всегда regional (`lang`),
 * плюс активный фильтр городов, если он есть. Каждый город даёт свой
 * канонический URL детальной — нужно и для SEO, и чтобы выбор пользователя
 * сохранялся при переходе.
 */
export function getDetailLinkQuery(
	lang: string,
	filterCityIds?: readonly number[],
): Record<string, string | string[] | undefined> {
	const query: Record<string, string | string[] | undefined> = {
		...getRegionalQuery(lang),
	};
	if (filterCityIds?.length) {
		query.cityIds = filterCityIds.map(String);
	}
	return query;
}

import { RETIRED_SPECIALTY_IDS } from '~/enums/specialty';
import { getRegionalUrl } from '../../../common/url-utils';
import { getLocaleFromQuery, defaultLocale } from '~/composables/use-locale';
import type { UrlQuery } from '../../../common/url-utils';

/**
 * Снятые значения фильтров: имя query-параметра → карта «старый ID → новый».
 *
 * Сейчас запись одна, и это не недосмотр: сверка всей истории git по всем
 * файлам `enums/*.ts` даёт ровно одно снятое значение за время жизни проекта.
 * Структура общая, чтобы следующее переименование добавлялось строкой, а не
 * переписыванием механизма.
 */
const RETIRED_FILTER_IDS: Record<string, Record<number, number>> = {
	specialtyIds: RETIRED_SPECIALTY_IDS,
};

function toValueArray(value: unknown): string[] | null {
	if (typeof value === 'string') return [value];
	if (Array.isArray(value)) {
		return value.every((v) => typeof v === 'string')
			? (value as string[])
			: null;
	}
	return null;
}

/**
 * 301 со снятого значения фильтра на действующее.
 *
 * Проблема, которую это закрывает: `/doctors?specialtyIds=73` отдавал 200 с
 * полным каталогом (1316 врачей) и self-canonical на себя, потому что
 * валидатор отбрасывал неизвестный ID, а «фильтра нет» выглядит для листинга
 * как «фильтр не задан». Правка 7d отдаёт по таким URL `noindex`, но для
 * СНЯТОГО значения этого мало: страница уже ранжируется и приносит клики, а
 * преемник в индексе отсутствует — нужен именно перенос сигнала.
 *
 * Целевой URL собирается тем же `getRegionalUrl`, что и локальный редирект,
 * поэтому уезжает сразу в канонический порядок параметров и нормализованный
 * `lang` — один хоп вместо двух. Дедупликация нужна на случай
 * `?specialtyIds=73&specialtyIds=94`: после подстановки значения совпадут.
 */
export function fixRetiredFilterIds(
	event: any,
): { status: 301; url: string } | null {
	const { pathname } = getRequestURL(event);
	return buildRetiredFilterRedirect(pathname, getQuery(event));
}

/** Чистая часть: без h3-события, чтобы покрывалась юнит-тестами. */
export function buildRetiredFilterRedirect(
	pathname: string,
	query: Record<string, unknown>,
): { status: 301; url: string } | null {
	let changed = false;
	const nextQuery: UrlQuery = {};

	for (const [key, rawValue] of Object.entries(query)) {
		const retiredMap = RETIRED_FILTER_IDS[key];
		const values = retiredMap ? toValueArray(rawValue) : null;

		if (!retiredMap || !values) {
			nextQuery[key] = rawValue as UrlQuery[string];
			continue;
		}

		const mapped: string[] = [];
		for (const value of values) {
			const replacement = retiredMap[Number(value)];
			if (replacement != null) {
				changed = true;
				const asString = String(replacement);
				if (!mapped.includes(asString)) mapped.push(asString);
			} else if (!mapped.includes(value)) {
				mapped.push(value);
			}
		}

		nextQuery[key] = mapped;
	}

	if (!changed) {
		return null;
	}

	const locale = query.lang
		? getLocaleFromQuery(query.lang as string | string[]) || defaultLocale
		: defaultLocale;

	return {
		status: 301,
		url: getRegionalUrl(pathname, nextQuery, locale),
	};
}

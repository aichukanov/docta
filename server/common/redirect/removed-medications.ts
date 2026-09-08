import { getLocaleFromQuery, defaultLocale } from '~/composables/use-locale';
import { getRegionalUrl } from '../../../common/url-utils';

/**
 * Раздел `/medications` — лекарства с ценами по клиникам — снят с сайта.
 *
 * Не путать с `/medicines`: это реестр ЦИнМЕД (таблицы `med_*`), он остаётся и
 * развивается. Снятый слой жил в таблицах `medications` / `clinic_medications`,
 * держал 33 позиции против 3553 в реестре, и это были не лекарства из аптеки, а
 * то, что клиника колет на месте: растворы Рингера и Хартмана, физраствор,
 * глюкоза, ампулы витаминов. Данные устарели, слой признан ненужным.
 *
 * Таблицы в БД НЕ удалялись: пока данные на месте, решение обратимо.
 *
 * Просто убрать страницы нельзя — адреса в индексе. Отсюда три исхода:
 *
 * 1. Листинг `/medications` → 301 на `/medicines`. Интент «лекарства в
 *    Черногории» обслуживает реестр, это честный преемник, и сигнал ссылок
 *    стоит перенести.
 *
 * 2. Карточки `/medications/<slug>` → 410 Gone, а НЕ 301. Тёзка в реестре есть
 *    только у 5 слагов из 33, и даже там это разные вещи (ампула против
 *    потребительской упаковки). Увести оставшиеся 28 на реестр — обмануть и
 *    человека, и поисковик; 404 же дал бы «soft 404» на страницах, которые
 *    удалены намеренно и навсегда. 410 снимается из индекса быстрее всего.
 *
 * 3. Подстраницы `/clinics/<slug>/medications` → 301 на страницу клиники.
 *    Клиника существует, исчез только её раздел — ровно тот же ответ, что
 *    подстраница и раньше давала, когда позиций было меньше инлайнового порога.
 */
export type RemovedMedicationsAction =
	| { type: 'redirect'; status: 301; url: string }
	| { type: 'gone' };

/**
 * Чистая часть: без h3-события, чтобы покрывалась юнит-тестами.
 *
 * `pathArray` — сегменты пути без ведущего слеша (как в middleware).
 * `query` нужен только ради `lang`: целевой URL собирается тем же
 * `getRegionalUrl`, что и остальные редиректы, поэтому русская версия уезжает
 * на русскую, а не на сербскую — редирект между локалями Google считает
 * дефектом hreflang-кластера.
 */
export function buildRemovedMedicationsAction(
	pathArray: string[],
	query: Record<string, unknown>,
): RemovedMedicationsAction | null {
	const locale = query.lang
		? getLocaleFromQuery(query.lang as string | string[]) || defaultLocale
		: defaultLocale;

	if (pathArray[0] === 'medications') {
		// Листинг — на преемника; всё, что глубже (карточка и её хвосты) — 410
		return pathArray.length === 1
			? {
					type: 'redirect',
					status: 301,
					url: getRegionalUrl('/medicines', {}, locale),
				}
			: { type: 'gone' };
	}

	// `/clinics/<slug>/medications` и всё под ней (пагинация, фильтры)
	if (
		pathArray[0] === 'clinics' &&
		pathArray[1] &&
		pathArray[2] === 'medications'
	) {
		return {
			type: 'redirect',
			status: 301,
			url: getRegionalUrl(`/clinics/${pathArray[1]}`, {}, locale),
		};
	}

	return null;
}

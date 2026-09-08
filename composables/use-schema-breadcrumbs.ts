import { SITE_URL } from '~/common/constants';
import type { BreadcrumbItem } from '~/components/app-breadcrumbs.vue';
import type { BreadcrumbListSchema } from '~/types/schema-org';

/**
 * Видимые крошки из той же `BreadcrumbList`, которую страница уже отдала в
 * разметку.
 *
 * Единый источник — потому что расхождение «разметка есть, крошек нет» это
 * нарушение требования Google размечать только видимое, и оно возвращалось бы
 * с первой же правкой любой из страниц. Отдельный проп пришлось бы дублировать
 * в семи карточках и семи листингах.
 */
export function useSchemaBreadcrumbs() {
	const schemaOrgStore = useSchemaOrgStore();

	return computed<BreadcrumbItem[]>(() => {
		const list = schemaOrgStore.schemas.find(
			(schema): schema is BreadcrumbListSchema =>
				schema['@type'] === 'BreadcrumbList',
		);

		if (!list?.itemListElement?.length) {
			return [];
		}

		// Без имени крошку показать нечем. Показывать остальные — значит отдать
		// человеку трейл короче размеченного, то есть ровно то расхождение,
		// против которого всё и затевалось. Поэтому либо целиком, либо никак.
		if (list.itemListElement.some((element) => !element.name)) {
			return [];
		}

		return list.itemListElement.map((element) => ({
			label: element.name as string,
			// В разметке ссылки абсолютные — этого требует schema.org. NuxtLink на
			// абсолютный адрес своего же сайта считает его внешним и уходит в
			// полную перезагрузку, поэтому origin срезаем и навигация остаётся
			// клиентской.
			to:
				typeof element.item === 'string' && element.item.startsWith(SITE_URL)
					? element.item.slice(SITE_URL.length) || '/'
					: undefined,
		}));
	});
}

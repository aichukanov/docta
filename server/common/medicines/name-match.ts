// Объяснение, ПОЧЕМУ лекарство попало в результаты текстового поиска.
//
// Поиск по `/api/medicines/list?name=` совпадает не только с названием
// препарата: ещё с действующим веществом и — с 2026-08 — с названием
// зарубежного аналога («супрастин» → SYNOPEN). Без подписи такая выдача
// читается как поломка: пользователь ввёл «хлороп», получил «SYNOPEN, SYNOPEN»
// и не видит связи. Здесь собирается индекс совпадений (вещества + бренды),
// по которому карточка выводит причину.
import { normalizeForSearch } from '~/common/utils';
import {
	type Conn,
	localizedNameSql,
	nameFieldFor,
} from '~/server/common/medicines/helpers';
import type { MedicineMatch } from '~/interfaces/medicine';
import { foldedLike, foldedLikeAny } from '~/server/common/search-collation';

// Ограничители: у однобуквенного запроса совпадений сотни, а подпись всё равно
// показывает единицы. Отсекаем на уровне SQL, чтобы не тащить лишнее в память.
const SUBSTANCE_MATCH_LIMIT = 300;
const FOREIGN_MATCH_LIMIT = 500;
// Сколько причин показываем в карточке (остальное — на странице препарата).
const MAX_SUBSTANCES_PER_ITEM = 3;
const MAX_BRANDS_PER_ITEM = 3;

// Зарубежный продукт = (рынок, бренд, форма) со своим набором веществ —
// см. prd/drug-cross-country-reference/IMPLEMENTATION.md §1.
interface ForeignProduct {
	brand: string;
	substanceIds: Set<number>;
}

export interface MedicineNameMatchIndex {
	/** Исходный запрос — по нему карточка подсвечивает совпадение. */
	query: string;
	/** id вещества → локализованное имя (совпало название в любом языке). */
	substanceNames: Map<number, string>;
	/** id вещества → зарубежные продукты с этим веществом и совпавшим именем. */
	foreignProducts: Map<number, ForeignProduct[]>;
}

/**
 * Собирает индекс совпадений для запроса: вещества и зарубежные бренды.
 * Два лёгких запроса (обе таблицы — тысячи строк), выполняются параллельно.
 */
export async function buildNameMatchIndex(
	connection: Conn,
	name: string,
	locale?: string,
): Promise<MedicineNameMatchIndex> {
	const nameField = nameFieldFor(locale);
	const pattern = `%${name}%`;

	const [substanceRows, foreignRows] = await Promise.all([
		connection.execute(
			`SELECT s.id, ${localizedNameSql('s', nameField)} as name
			 FROM med_substances s
			 WHERE ${foldedLikeAny([
					's.name',
					's.name_en',
					`s.${nameField}`,
					's.name_ru',
					's.name_sr',
					's.name_sr_cyrl',
				])}
			 LIMIT ${SUBSTANCE_MATCH_LIMIT}`,
			[pattern, pattern, pattern, pattern, pattern, pattern],
		),
		// LIMIT стоит на ПРОДУКТАХ (во вложенном запросе), а не на строках
		// джойна: продукт — это набор веществ, и обрезанный по строкам набор
		// соврал бы в isSameSet, то есть пометил бы «точным аналогом» бренд,
		// у которого просто не доехала часть состава. Отобранные продукты
		// всегда приезжают с полным составом.
		connection.execute(
			`SELECT fp.id, fp.brand_name as brand, fps.substance_id as substanceId
			 FROM (
				SELECT id, brand_name
				FROM med_foreign_products
				WHERE ${foldedLike('brand_name')}
				ORDER BY brand_name ASC
				LIMIT ${FOREIGN_MATCH_LIMIT}
			 ) fp
			 JOIN med_foreign_product_substances fps ON fps.product_id = fp.id`,
			[pattern],
		),
	]);

	const substanceNames = new Map<number, string>();
	for (const row of substanceRows[0] as any[]) {
		substanceNames.set(Number(row.id), String(row.name || ''));
	}

	// Собираем состав каждого продукта: сравнение НАБОРОВ веществ отличает
	// настоящий аналог («Супрастин» = хлоропирамин) от препарата, который лишь
	// делит одно вещество («Nurofen Cold & Flu» ≠ чистый ибупрофен).
	const productById = new Map<number, ForeignProduct>();
	for (const row of foreignRows[0] as any[]) {
		const id = Number(row.id);
		const product: ForeignProduct = productById.get(id) || {
			brand: String(row.brand),
			substanceIds: new Set<number>(),
		};
		product.substanceIds.add(Number(row.substanceId));
		productById.set(id, product);
	}

	const foreignProducts = new Map<number, ForeignProduct[]>();
	for (const product of productById.values()) {
		for (const substanceId of product.substanceIds) {
			const list = foreignProducts.get(substanceId) || [];
			list.push(product);
			foreignProducts.set(substanceId, list);
		}
	}

	return { query: name, substanceNames, foreignProducts };
}

/**
 * Причина попадания одного лекарства в выдачу. `substanceIds` — состав
 * препарата (GROUP_CONCAT из списочного запроса).
 */
export function buildMedicineMatch(
	index: MedicineNameMatchIndex,
	medicineName: string,
	substanceIds: number[],
): MedicineMatch {
	const byName = includesQuery(medicineName, index.query);

	const substances: string[] = [];
	// Бренд может быть заведён на несколько форм и рынков; в подписи он один,
	// а fullMatch — по лучшей из его записей.
	const brandFullMatch = new Map<string, boolean>();
	const ownSubstances = new Set(substanceIds);

	for (const substanceId of substanceIds) {
		const substanceName = index.substanceNames.get(substanceId);
		if (substanceName && !substances.includes(substanceName)) {
			substances.push(substanceName);
		}
		for (const product of index.foreignProducts.get(substanceId) || []) {
			const fullMatch = isSameSet(product.substanceIds, ownSubstances);
			brandFullMatch.set(
				product.brand,
				brandFullMatch.get(product.brand) || fullMatch,
			);
		}
	}

	// Вперёд — настоящие аналоги, затем точнее совпавшие по названию:
	// начинающиеся с запроса, потом более короткие (совпала большая доля).
	const normalizedQuery = normalizeForSearch(index.query);
	const foreignBrands = [...brandFullMatch.entries()]
		.map(([brand, fullMatch]) => ({ brand, fullMatch }))
		.sort((a, b) => {
			if (a.fullMatch !== b.fullMatch) return a.fullMatch ? -1 : 1;
			const aStarts = normalizeForSearch(a.brand).startsWith(normalizedQuery);
			const bStarts = normalizeForSearch(b.brand).startsWith(normalizedQuery);
			if (aStarts !== bStarts) return aStarts ? -1 : 1;
			if (a.brand.length !== b.brand.length) {
				return a.brand.length - b.brand.length;
			}
			return a.brand.localeCompare(b.brand);
		})
		.slice(0, MAX_BRANDS_PER_ITEM);

	return {
		byName,
		substances: substances.slice(0, MAX_SUBSTANCES_PER_ITEM),
		foreignBrands,
	};
}

const isSameSet = (a: Set<number>, b: Set<number>): boolean =>
	a.size === b.size && [...a].every((value) => b.has(value));

const includesQuery = (value: string, query: string): boolean =>
	normalizeForSearch(value).includes(normalizeForSearch(query));

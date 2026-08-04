// Порядок выдачи реестра лекарств.
//
// Обычное ранжирование сайта (цена, рейтинг, близость) к /medicines
// неприменимо: записи реестра не привязаны ни к клиникам, ни к ценам.
// Поэтому здесь ровно два порядка — популярность и алфавит.

/** Популярность (дефолт): med_medicines.rank_score, см. recalc-med-rank-score.sql */
export const MEDICINE_SORT_POPULAR = 'popular';
/** Алфавит по локализованному названию */
export const MEDICINE_SORT_NAME_ASC = 'name-asc';

export const MEDICINE_SORTS = [
	MEDICINE_SORT_POPULAR,
	MEDICINE_SORT_NAME_ASC,
] as const;

export type MedicineSort = (typeof MEDICINE_SORTS)[number];

export const DEFAULT_MEDICINE_SORT: MedicineSort = MEDICINE_SORT_POPULAR;

export function isMedicineSort(value: unknown): value is MedicineSort {
	return (
		typeof value === 'string' && MEDICINE_SORTS.includes(value as MedicineSort)
	);
}

/**
 * Неизвестное значение (в том числе мусор из URL) → дефолт.
 *
 * Молча падать в дефолт здесь безопасно, в отличие от фильтров: порядок не
 * меняет СОСТАВ каталога, поэтому `?sort=99999` не открывает поверхность
 * дублей полного листинга (ср. hasInvalidFilters в stores/filters.ts).
 */
export function normalizeMedicineSort(value: unknown): MedicineSort {
	return isMedicineSort(value) ? value : DEFAULT_MEDICINE_SORT;
}

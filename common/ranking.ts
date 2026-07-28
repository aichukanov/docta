// Единый композитный скор ранжирования клиник:
//   composite = rank_score + вклад близости + бонус за указанную цену
//               (урезанный, если цена помечена устаревшей)
//
// rank_score (0..1) — общий рейтинг клиники (отзывы + заполненность профиля,
// см. server/utils/entity-ranking.ts). Вклад близости НЕ заменяет рейтинг,
// а добавляется к нему: между далёкими городами порядок решает качество,
// внутри города близость даёт ощутимое преимущество.
//
// Серверные зеркала формулы (порядок без локации = rank_score + бонус за цену):
// - server/common/utils.ts → getClinicRankOrderBySQL (детальные/листинговые
//   страницы услуг, анализов, лекарств);
// - server/api/clinics/list.ts → каталог с координатами пользователя
//   (полная формула с близостью в ORDER BY).

/** Максимальный вклад близости (на расстоянии 0 км) */
export const PROXIMITY_WEIGHT = 0.5;

/**
 * Полудистанция затухания: каждые 10 км вклад близости падает вдвое.
 * 0 км → +0.5, 10 км → +0.25, 25 км → +0.09, 100 км → ~0 — клиники
 * далёких городов автоматически конкурируют чистым rank_score.
 */
export const PROXIMITY_HALF_DISTANCE_KM = 10;

/**
 * Бонус за указанную цену на страницах позиций с ценами (услуги, анализы,
 * лекарства): страницу открывают сравнивать цены, карточка без цены не должна
 * легко вытеснять полезные наверх.
 */
export const CLINIC_PRICE_BONUS = 0.1;

/**
 * Доля ценового сигнала, которую сохраняет цена, помеченная как устаревшая
 * (is_price_outdated). Устаревшая цена полезнее полного отсутствия цены —
 * порядок величины пользователь понимает, — но заметно хуже актуальной:
 * её нельзя считать настоящей, к ней идёт дисклеймер «+X% и ?».
 *
 * Используется в обоих ценовых сигналах:
 * - бонус клиники здесь (CLINIC_OUTDATED_PRICE_BONUS);
 * - вес hasPricing услуг/анализов в server/utils/entity-ranking.ts.
 */
export const OUTDATED_PRICE_FACTOR = 0.35;

/** Бонус клиники за устаревшую цену: CLINIC_PRICE_BONUS × OUTDATED_PRICE_FACTOR */
export const CLINIC_OUTDATED_PRICE_BONUS =
	Math.round(CLINIC_PRICE_BONUS * OUTDATED_PRICE_FACTOR * 10000) / 10000;

/** Вклад близости; null/undefined (локация или координаты неизвестны) → 0 */
export function proximityBonus(distanceKm: number | null | undefined): number {
	if (distanceKm == null) return 0;
	return (
		PROXIMITY_WEIGHT * Math.pow(2, -distanceKm / PROXIMITY_HALF_DISTANCE_KM)
	);
}

export function compositeClinicScore(options: {
	rankScore?: number | null;
	distanceKm?: number | null;
	hasPrice?: boolean;
	isPriceOutdated?: boolean;
}): number {
	return (
		(options.rankScore ?? 0) +
		proximityBonus(options.distanceKm) +
		clinicPriceBonus(options.hasPrice, options.isPriceOutdated)
	);
}

/** Бонус за цену: полный за актуальную, урезанный за устаревшую, 0 без цены */
export function clinicPriceBonus(
	hasPrice?: boolean,
	isPriceOutdated?: boolean,
): number {
	if (!hasPrice) return 0;
	return isPriceOutdated ? CLINIC_OUTDATED_PRICE_BONUS : CLINIC_PRICE_BONUS;
}

// Единый композитный скор ранжирования клиник:
//   composite = rank_score + вклад близости + бонус за указанную цену
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
}): number {
	return (
		(options.rankScore ?? 0) +
		proximityBonus(options.distanceKm) +
		(options.hasPrice ? CLINIC_PRICE_BONUS : 0)
	);
}

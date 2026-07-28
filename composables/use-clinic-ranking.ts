import { calculateDistanceKm } from '~/common/distance';
import { compositeClinicScore } from '~/common/ranking';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';

/**
 * Клиентская часть единого механизма ранжирования клиник (common/ranking.ts):
 * расстояние до пользователя и пересортировка по композитному скору.
 *
 * До определения локации (и на SSR) вклад близости нулевой, поэтому порядок
 * совпадает с серверным (rank_score + бонус за цену) — гидрация не прыгает,
 * список перестраивается только когда локация реально появилась.
 */
export function useClinicRanking() {
	const { userLocation } = useUserLocation();

	const getDistanceKm = (
		clinic: Pick<ClinicData, 'latitude' | 'longitude'>,
	): number | null => {
		if (
			!userLocation.value ||
			clinic.latitude == null ||
			clinic.longitude == null
		) {
			return null;
		}
		return calculateDistanceKm(
			userLocation.value.latitude,
			userLocation.value.longitude,
			clinic.latitude,
			clinic.longitude,
		);
	};

	// Зеркало SQL-условия бонуса (price > 0 OR price_min > 0,
	// см. getClinicRankOrderBySQL): price_max сам по себе цену не показывает
	const hasPriceInfo = (priceInfo?: ClinicPrice): boolean =>
		priceInfo != null &&
		((priceInfo.price ?? 0) > 0 || (priceInfo.priceMin ?? 0) > 0);

	/**
	 * Пересортировка по композитному скору. `prices` передаются на страницах
	 * позиций с ценами (бонус за цену, урезанный для устаревшей); без них
	 * скор = rank_score + близость.
	 * Сортировка стабильная: при равном скоре сохраняется серверный порядок.
	 */
	const rankClinics = <T extends ClinicData>(
		clinics: T[],
		prices?: ClinicPrice[],
	): T[] => {
		const priceByClinic = new Map((prices ?? []).map((p) => [p.clinicId, p]));
		const scored = clinics.map((clinic) => {
			const priceInfo = priceByClinic.get(clinic.id);
			return {
				clinic,
				score: compositeClinicScore({
					rankScore: clinic.rankScore,
					distanceKm: getDistanceKm(clinic),
					hasPrice: prices ? hasPriceInfo(priceInfo) : undefined,
					isPriceOutdated: priceInfo?.isOutdated,
				}),
			};
		});
		scored.sort((a, b) => b.score - a.score);
		return scored.map(({ clinic }) => clinic);
	};

	return { getDistanceKm, rankClinics };
}

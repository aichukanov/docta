import { calculateDistanceKm } from '~/common/distance';
import { compositeClinicScore } from '~/common/ranking';
import type { ClinicData, ClinicPrice } from '~/interfaces/clinic';

/**
 * Переиспользует ранее показанный порядок, если состав набора не изменился.
 * Вернёт null, когда порядок неприменим (первый рендер, другая страница,
 * другой фильтр) — тогда набор надо ранжировать заново.
 */
export function reuseOrder<T extends { id: number }>(
	clinics: T[],
	order: number[] | null,
): T[] | null {
	if (!order || order.length !== clinics.length) return null;

	const byId = new Map(clinics.map((clinic) => [clinic.id, clinic]));
	const result: T[] = [];
	for (const id of order) {
		const clinic = byId.get(id);
		// Состав другой — сохранять нечего, ранжируем набор с нуля
		if (!clinic) return null;
		result.push(clinic);
	}
	return result;
}

/**
 * Клиентская часть единого механизма ранжирования клиник (common/ranking.ts):
 * расстояние до пользователя и пересортировка по композитному скору.
 *
 * До определения локации (и на SSR) вклад близости нулевой, поэтому порядок
 * совпадает с серверным (rank_score + бонус за цену) — гидрация не прыгает.
 *
 * Локация приезжает асинхронно и всегда ПОСЛЕ первого рендера
 * (useUserLocation.initLocation ходит в профиль/IP), поэтому пересортировка
 * уже показанных карточек — это сдвиг макета: пользователь читает карточку,
 * а она уезжает из-под курсора. Для метрики CLS момент гидрации и момент
 * ответа геосервиса ничем не отличаются.
 *
 * Поэтому порядок фиксируется на первом рендере набора: расстояние на
 * карточках показывается (это полезная информация), но перестановка
 * применяется только к следующему набору — другая страница списка, другой
 * фильтр, переход на детальную. Обратный вариант — рассортировать список
 * заново — «честнее» по близости ровно на один экран, но ломает уже начатое
 * чтение и попадание по ссылке.
 */
export function useClinicRanking() {
	const { userLocation } = useUserLocation();

	// Порядок последнего отранжированного набора: состояние на экземпляр
	// composable, то есть на карточку/страницу, а не общее на приложение
	let renderedOrder: number[] | null = null;

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
		// Состав тот же, что уже отрисован — отдаём показанный порядок
		const rendered = reuseOrder(clinics, renderedOrder);
		if (rendered) return rendered;

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
		const ranked = scored.map(({ clinic }) => clinic);
		renderedOrder = ranked.map((clinic) => clinic.id);
		return ranked;
	};

	return { getDistanceKm, rankClinics };
}

// Расстояние между двумя точками по формуле Haversine, в километрах.
// Та же формула используется в SQL-сортировке (server/api/clinics/list.ts).
export function calculateDistanceKm(
	lat1: number,
	lon1: number,
	lat2: number,
	lon2: number,
): number {
	const R = 6371; // радиус Земли, км
	const toRad = (degrees: number) => (degrees * Math.PI) / 180;

	const dLat = toRad(lat2 - lat1);
	const dLon = toRad(lon2 - lon1);

	const a =
		Math.sin(dLat / 2) * Math.sin(dLat / 2) +
		Math.cos(toRad(lat1)) *
			Math.cos(toRad(lat2)) *
			Math.sin(dLon / 2) *
			Math.sin(dLon / 2);

	const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
	return R * c;
}

// Округление до 1 знака — для отображения и для distance из API
export function roundDistanceKm(distanceKm: number): number {
	return Math.round(distanceKm * 10) / 10;
}

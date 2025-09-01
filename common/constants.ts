// Enum городов с ID из базы данных (соответствует cities.id)
export enum CityId {
	PODGORICA = 1,
	NIKSIC = 2,
	BUDVA = 3,
	TIVAT = 4,
	ULCINJ = 5,
	KOTOR = 6,
}

// Координаты городов по ID (из БД - реальные ID)
export const CITY_COORDINATES: Record<CityId, [number, number]> = {
	[CityId.PODGORICA]: [42.442574, 19.268646],
	[CityId.NIKSIC]: [42.7731, 18.9447],
	[CityId.BUDVA]: [42.2864, 18.84],
	[CityId.TIVAT]: [42.4349809, 18.7066398],
	[CityId.ULCINJ]: [41.9297, 19.2142],
	[CityId.KOTOR]: [42.43204384798873, 18.76945397467048],
};

// Константа для центра Черногории (Подгорица по умолчанию)
export const MONTENEGRO_CENTER: [number, number] =
	CITY_COORDINATES[CityId.PODGORICA];

// Границы Черногории для ограничения карты
export const MONTENEGRO_BOUNDS = {
	north: 43.6, // Северная граница
	south: 41.7, // Южная граница
	east: 20.5, // Восточная граница
	west: 18.3, // Западная граница
};

// Границы в формате Leaflet [[south, west], [north, east]]
export const MONTENEGRO_MAX_BOUNDS: [[number, number], [number, number]] = [
	[MONTENEGRO_BOUNDS.south, MONTENEGRO_BOUNDS.west],
	[MONTENEGRO_BOUNDS.north, MONTENEGRO_BOUNDS.east],
];

// Настройки зума для карты Черногории
export const MONTENEGRO_ZOOM_SETTINGS = {
	minZoom: 7, // Минимальный зум - видна вся страна
	maxZoom: 18, // Максимальный зум
	defaultZoom: 9, // Зум по умолчанию
};

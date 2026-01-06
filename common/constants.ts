import { CityId, CITY_COORDINATES } from '~/enums/cities';

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

// Данные сайта
export const SITE_URL = 'https://docta.me';
export const SITE_NAME = 'docta.me';
export const OG_IMAGE = `${SITE_URL}/apple-touch-icon.png`;

// Контактные данные проекта
export const PROJECT_CONTACTS = {
	email: 'contact@svad.net',
	telegram: 'https://t.me/svad_net',
};

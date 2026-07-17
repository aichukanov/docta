// Результат определения локации по IP (/api/geo/detect-location).
// Возвращается ТОЛЬКО уверенно определённый город Черногории из таблицы
// cities; во всех остальных случаях эндпоинт отдаёт null — локация считается
// неизвестной и в ранжировании не участвует (фолбэков нет).
export interface DetectedLocation {
	cityId: number;
	latitude: number;
	longitude: number;
}

// Локация пользователя на клиенте (composable useUserLocation).
// Всегда конкретный город из списка: ручной выбор, город из профиля
// или уверенный IP-детект.
export interface UserLocation {
	cityId: number;
	latitude: number;
	longitude: number;
	// auto — определено по IP, manual — выбрано вручную, profile — из БД пользователя
	source: 'auto' | 'manual' | 'profile';
}

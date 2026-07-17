import { CITY_COORDINATES, type CityId } from '~/enums/cities';
import type { DetectedLocation, UserLocation } from '~/interfaces/geo';

const STORAGE_KEY = 'user_location';
const STORAGE_TTL_DAYS = 30;

// Состояние общее на всё приложение (module-level singleton)
const userLocation = ref<UserLocation | null>(null);
const isLoadingLocation = ref(false);
let initPromise: Promise<void> | null = null;

// Маркер явного сброса города: пока он действует, автодетект по IP не
// запускается — город вернётся только ручным выбором или кнопкой
// «Определять автоматически»
const OPT_OUT = 'opt-out';

function loadFromStorage(): UserLocation | typeof OPT_OUT | null {
	try {
		const stored = localStorage.getItem(STORAGE_KEY);
		if (!stored) return null;

		const data = JSON.parse(stored) as {
			location?: UserLocation & { fallback?: boolean };
			optOut?: boolean;
			expiry?: string;
		};
		if (!data.expiry) return null;

		if (new Date(data.expiry) < new Date()) {
			localStorage.removeItem(STORAGE_KEY);
			return null;
		}

		if (data.optOut) return OPT_OUT;
		if (!data.location) return null;

		// Записи старого формата (фолбэк Подгорица или координаты без города)
		// не считаются локацией — выбрасываем, чтобы не искажали ранжирование
		if (
			data.location.fallback ||
			!data.location.cityId ||
			!CITY_COORDINATES[data.location.cityId as CityId]
		) {
			localStorage.removeItem(STORAGE_KEY);
			return null;
		}

		return data.location;
	} catch {
		return null;
	}
}

function buildExpiry(): string {
	const expiry = new Date();
	expiry.setDate(expiry.getDate() + STORAGE_TTL_DAYS);
	return expiry.toISOString();
}

function saveToStorage(location: UserLocation) {
	try {
		localStorage.setItem(
			STORAGE_KEY,
			JSON.stringify({ location, expiry: buildExpiry() }),
		);
	} catch (error) {
		console.error('Failed to save location to storage:', error);
	}
}

function saveOptOutToStorage() {
	try {
		localStorage.setItem(
			STORAGE_KEY,
			JSON.stringify({ optOut: true, expiry: buildExpiry() }),
		);
	} catch (error) {
		console.error('Failed to save location opt-out to storage:', error);
	}
}

function clearStorage() {
	try {
		localStorage.removeItem(STORAGE_KEY);
	} catch {
		// localStorage недоступен (private mode) — не критично
	}
}

export function useUserLocation() {
	const userStore = useUserStore();

	const fetchPreferredCityFromDb = async (): Promise<number | null> => {
		try {
			const response = await $fetch<{ data?: { cityId: number | null } }>(
				'/api/auth/preferred-city',
			);
			return response.data?.cityId ?? null;
		} catch {
			// не авторизован или миграция ещё не применена — молча пропускаем
			return null;
		}
	};

	const savePreferredCityToDb = async (cityId: number | null) => {
		if (!userStore.user) return;
		try {
			await $fetch('/api/auth/update-preferred-city', {
				method: 'POST',
				body: { cityId },
			});
		} catch (error) {
			console.error('Failed to save preferred city:', error);
		}
	};

	// null — город уверенно не определён (эндпоинт без фолбэков): локация
	// остаётся неизвестной и в ранжировании не участвует
	const detectByIp = async (): Promise<UserLocation | null> => {
		try {
			const detected = await $fetch<DetectedLocation | null>(
				'/api/geo/detect-location',
			);
			if (!detected) return null;
			return {
				cityId: detected.cityId,
				latitude: detected.latitude,
				longitude: detected.longitude,
				source: 'auto',
			};
		} catch (error) {
			console.error('Failed to detect location:', error);
			return null;
		}
	};

	/**
	 * Определяет локацию: профиль (БД) → localStorage → IP.
	 * Идемпотентно: повторные вызовы ждут первый.
	 */
	const initLocation = () => {
		if (import.meta.server) return Promise.resolve();
		if (initPromise) return initPromise;

		initPromise = (async () => {
			isLoadingLocation.value = true;
			try {
				// 1. Для авторизованных город из БД имеет приоритет
				await userStore.fetchUser().catch(() => null);
				if (userStore.user) {
					const cityId = await fetchPreferredCityFromDb();
					const coords = CITY_COORDINATES[cityId as CityId];
					if (cityId && coords) {
						userLocation.value = {
							cityId,
							latitude: coords[0],
							longitude: coords[1],
							source: 'profile',
						};
						return;
					}
				}

				// 2. Сохранённый выбор или явный сброс (TTL 30 дней)
				const stored = loadFromStorage();
				if (stored === OPT_OUT) {
					// Пользователь сбросил город — не автоопределяем
					return;
				}
				if (stored) {
					userLocation.value = stored;
					return;
				}

				// 3. Определение по IP
				const detected = await detectByIp();
				if (detected) {
					userLocation.value = detected;
					saveToStorage(detected);
				}
			} finally {
				isLoadingLocation.value = false;
			}
		})();

		return initPromise;
	};

	/** Пользователь вручную выбрал город */
	const setCity = (cityId: CityId) => {
		const coords = CITY_COORDINATES[cityId];
		if (!coords) return;

		const location: UserLocation = {
			cityId,
			latitude: coords[0],
			longitude: coords[1],
			source: 'manual',
		};
		userLocation.value = location;
		saveToStorage(location);
		savePreferredCityToDb(cityId);
	};

	/** Сброс на автоматическое определение по IP (снимает и явный сброс) */
	const resetToAuto = async () => {
		clearStorage();
		savePreferredCityToDb(null);
		isLoadingLocation.value = true;
		try {
			const detected = await detectByIp();
			userLocation.value = detected;
			if (detected) {
				saveToStorage(detected);
			}
		} finally {
			isLoadingLocation.value = false;
		}
	};

	/**
	 * Явный сброс города: локация неизвестна и в ранжировании не участвует.
	 * Чистит и localStorage (opt-out маркер блокирует автодетект),
	 * и preferred_city_id в БД у авторизованных.
	 */
	const resetCity = () => {
		userLocation.value = null;
		saveOptOutToStorage();
		savePreferredCityToDb(null);
	};

	return {
		userLocation: computed(() => userLocation.value),
		isLoadingLocation: computed(() => isLoadingLocation.value),
		initLocation,
		setCity,
		resetToAuto,
		resetCity,
	};
}

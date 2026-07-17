# Итерация 2: Геолокация и сортировка клиник по расстоянию

[← К списку итераций](README.md) | [← К оглавлению PRD](../index.md)

---

## ✅ Итог реализации (2026-06-12)

Итерация завершена. Код ниже по тексту — **псевдокод из ранней версии PRD**,
реальная реализация отличается:

- **Эндпоинт:** `server/api/geo/detect-location.get.ts` (GET, не POST).
  Возвращает `{ cityId, latitude, longitude, detected, fallback }` —
  `cityId` из таблицы `cities` (enum `CityId`), а не строковое имя города.
  Имя города по id локализуется через `i18n/city.ts`.
- **Кэш по IP на сервере** (in-memory, TTL 24ч, max 5000 записей) — чтобы не
  сжечь лимит ipapi.co 1000 req/день. IP в БД не сохраняется (NFR-12).
- **Координаты — центр города из БД**, а не точка IP: расстояние считается
  одинаково для автоопределения и ручного выбора (FR-2.2).
- Если ipapi вернул город не из нашего списка, но координаты валидны —
  используются они (`cityId: null`, селектор показывает «не определён»),
  сортировка по расстоянию всё равно работает.
- **Composable:** `composables/use-user-location.ts` (kebab-case по конвенции).
  Приоритет источников: БД (авторизованные) → localStorage (TTL 30 дней) → IP.
- **Утилита расстояния:** `common/distance.ts` (в проекте нет папки `utils/`).
  Форматирование — в `ClinicSummaryHeader` через локальный i18n
  (`i18n/location.ts`), а не функция с локалью.
- **Сортировка:** Haversine в SQL c плейсхолдерами (не интерполяция),
  `ORDER BY (coords IS NULL), distance ASC, rank_score DESC`. Поле `distance`
  возвращается в ответе. Расстояние на карточке считается на клиенте —
  показывается и когда сортировка по расстоянию выключена.
- **FR-2.6:** при активном фильтре по городу страница не передаёт
  `sortByDistance` — сортировка по расстоянию не применяется.
- **SSR:** локация определяется только на клиенте → SEO-выдача без локации
  не изменилась.
- **БД:** поле названо `auth_users.preferred_city_id` (таблица называется
  `auth_users`, не `users`). Миграция
  `server/sql/migrations/004-add-auth-users-preferred-city.sql` — ⚠️ ожидает
  применения. Эндпоинты: `GET /api/auth/preferred-city`,
  `POST /api/auth/update-preferred-city`.
- **LocationSelector** (`components/location-selector.vue`) — на Element Plus
  (el-select, filterable) и design-токенах, не самописный dropdown с hex.
  Выбор города НЕ перезагружает страницу — реактивный рефетч.
- **Не реализовано:** бейдж «Ваш город» / зелёная рамка (FR-2.7) — на карточке
  уже есть расстояние, бейдж дублирует; рамка конфликтует с платным highlight.

---

## Цель

Реализовать умную геолокацию пользователя по IP-адресу и сортировку списка клиник по расстоянию от пользователя. Пользователь должен видеть ближайшие к нему клиники первыми, с возможностью вручную изменить свой город.

**Важно:** Геолокация работает как умная сортировка, НЕ как фильтр. Все клиники остаются видимыми.

---

## Зависимости

**Требуется:**

- ✅ Базовый список клиник (Итерация 1)
- ✅ Таблица `cities` в БД
- ✅ Координаты (latitude, longitude) для всех клиник

**Опционально:**

- ⚠️ Авторизация пользователя (для сохранения города в БД)

---

## Задачи

### Задача 1: Настроить IP Geolocation API

**Что делать:**

1. Выбрать провайдера IP Geolocation:

   - **ipapi.co** (бесплатно 1000 запросов/день, HTTPS, JSON)
   - **ipgeolocation.io** (бесплатно 1000 запросов/день, много данных)
   - **ip-api.com** (бесплатно 45 req/min, без HTTPS на free tier)

   **Рекомендация:** Использовать `ipapi.co` для продакшена (HTTPS) и `ip-api.com` для разработки.

2. Создать API endpoint для определения города по IP

**Файл:** `server/api/geo/detect-location.get.ts`

```typescript
import type { H3Event } from 'h3';

interface IpApiResponse {
	city?: string;
	country_code?: string;
	latitude?: number;
	longitude?: number;
	region?: string;
}

interface DetectedLocation {
	city: string;
	country: string;
	latitude: number;
	longitude: number;
	detected: boolean;
	fallback: boolean;
}

const FALLBACK_LOCATION: DetectedLocation = {
	city: 'Podgorica',
	country: 'ME',
	latitude: 42.4304,
	longitude: 19.2594,
	detected: false,
	fallback: true,
};

export default defineEventHandler(
	async (event: H3Event): Promise<DetectedLocation> => {
		try {
			// Получаем IP пользователя
			const clientIp = getRequestIP(event, { xForwardedFor: true });

			// Локальные IP - используем fallback
			if (
				!clientIp ||
				clientIp === '127.0.0.1' ||
				clientIp.startsWith('192.168.') ||
				clientIp.startsWith('10.')
			) {
				console.log('[GEO] Local IP detected, using fallback location');
				return FALLBACK_LOCATION;
			}

			console.log(`[GEO] Detecting location for IP: ${clientIp}`);

			// Вызываем IP Geolocation API
			const response = await $fetch<IpApiResponse>(
				`https://ipapi.co/${clientIp}/json/`,
				{
					timeout: 3000, // 3 секунды максимум
				},
			);

			// Проверяем валидность ответа
			if (!response.city || !response.latitude || !response.longitude) {
				console.log('[GEO] Invalid response from IP API, using fallback');
				return FALLBACK_LOCATION;
			}

			// Ищем соответствующий город в нашей БД
			const db = useDatabase();
			const matchedCity = await db.sql<{ id: number; name: string }[]>`
      SELECT id, name
      FROM cities
      WHERE LOWER(name) = LOWER(${response.city})
         OR LOWER(name_local) = LOWER(${response.city})
      LIMIT 1
    `;

			// Если город найден в БД, используем его
			if (matchedCity.length > 0) {
				return {
					city: matchedCity[0].name,
					country: response.country_code || 'ME',
					latitude: response.latitude,
					longitude: response.longitude,
					detected: true,
					fallback: false,
				};
			}

			// Город не найден в БД - используем fallback
			console.log(
				`[GEO] City "${response.city}" not found in database, using fallback`,
			);
			return FALLBACK_LOCATION;
		} catch (error) {
			console.error('[GEO] Error detecting location:', error);
			return FALLBACK_LOCATION;
		}
	},
);
```

**Критерии приемки:**

- [ ] AC-1.1: API endpoint `/api/geo/detect-location` создан
- [ ] AC-1.2: Определяет город по IP-адресу пользователя
- [ ] AC-1.3: Возвращает координаты (latitude, longitude)
- [ ] AC-1.4: При ошибке возвращает fallback (Podgorica)
- [ ] AC-1.5: Логирует все операции для отладки

---

### Задача 2: Создать функцию расчета расстояния (Haversine)

**Что делать:**

Создать утилиту для расчета расстояния между двумя координатами.

**Файл:** `utils/distance.ts`

```typescript
/**
 * Рассчитывает расстояние между двумя точками по формуле Haversine
 * @param lat1 Широта первой точки
 * @param lon1 Долгота первой точки
 * @param lat2 Широта второй точки
 * @param lon2 Долгота второй точки
 * @returns Расстояние в километрах
 */
export function calculateDistance(
	lat1: number,
	lon1: number,
	lat2: number,
	lon2: number,
): number {
	const R = 6371; // Радиус Земли в километрах
	const dLat = toRadians(lat2 - lat1);
	const dLon = toRadians(lon2 - lon1);

	const a =
		Math.sin(dLat / 2) * Math.sin(dLat / 2) +
		Math.cos(toRadians(lat1)) *
			Math.cos(toRadians(lat2)) *
			Math.sin(dLon / 2) *
			Math.sin(dLon / 2);

	const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
	const distance = R * c;

	return Math.round(distance * 10) / 10; // Округляем до 1 знака после запятой
}

function toRadians(degrees: number): number {
	return degrees * (Math.PI / 180);
}

/**
 * Форматирует расстояние для отображения
 * @param distanceKm Расстояние в километрах
 * @param locale Текущая локаль
 * @returns Форматированная строка (например, "1.2 км" или "500 м")
 */
export function formatDistance(distanceKm: number, locale: string): string {
	if (distanceKm < 1) {
		const meters = Math.round(distanceKm * 1000);
		return locale === 'en' ? `${meters} m` : `${meters} м`;
	}

	return locale === 'en' ? `${distanceKm} km` : `${distanceKm} км`;
}
```

**Критерии приемки:**

- [ ] AC-2.1: Функция `calculateDistance` корректно рассчитывает расстояние
- [ ] AC-2.2: Функция `formatDistance` корректно форматирует для всех локалей
- [ ] AC-2.3: Расстояние менее 1 км отображается в метрах
- [ ] AC-2.4: Расстояние округляется до 1 знака после запятой

---

### Задача 3: Обновить API списка клиник для сортировки по расстоянию

**Что делать:**

Обновить `POST /api/clinics/list` для поддержки сортировки по расстоянию.

**Файл:** `server/api/clinics/list.post.ts`

Добавить опциональные параметры:

```typescript
interface ClinicsListRequest {
	// ... существующие поля
	userLatitude?: number;
	userLongitude?: number;
	sortByDistance?: boolean;
}
```

Обновить SQL запрос:

```typescript
// Если передана геолокация пользователя, добавляем расчет расстояния
let distanceSelect = '';
let orderBy = 'c.id DESC';

if (sortByDistance && userLatitude && userLongitude) {
	distanceSelect = `,
    (6371 * acos(
      cos(radians(${userLatitude})) * 
      cos(radians(c.latitude)) * 
      cos(radians(c.longitude) - radians(${userLongitude})) + 
      sin(radians(${userLatitude})) * 
      sin(radians(c.latitude))
    )) AS distance
  `;
	orderBy = 'distance ASC';
}

const clinics = await db.sql`
  SELECT
    c.id,
    c.name,
    c.name_local,
    c.address,
    c.city_id,
    c.latitude,
    c.longitude,
    c.phone,
    c.approved
    ${raw(distanceSelect)}
  FROM clinics c
  WHERE 1=1
  ${cityFilter}
  ${languageFilter}
  ${nameFilter}
  ORDER BY ${raw(orderBy)}
  LIMIT ${pageSize}
  OFFSET ${offset}
`;
```

**Критерии приемки:**

- [ ] AC-3.1: API принимает параметры `userLatitude`, `userLongitude`, `sortByDistance`
- [ ] AC-3.2: При передаче координат, список сортируется по расстоянию
- [ ] AC-3.3: Каждая клиника возвращает поле `distance` (в км)
- [ ] AC-3.4: Без координат, сортировка работает как раньше (по ID)
- [ ] AC-3.5: API работает быстро (< 500ms)

---

### Задача 4: Создать composable для работы с геолокацией

**Что делать:**

Создать `composable` для работы с локацией пользователя.

**Файл:** `composables/useUserLocation.ts`

```typescript
import { ref, computed } from 'vue';

interface UserLocation {
	city: string;
	latitude: number;
	longitude: number;
	detected: boolean;
	fallback: boolean;
}

const userLocation = ref<UserLocation | null>(null);
const isLoadingLocation = ref(false);

export function useUserLocation() {
	const STORAGE_KEY = 'user_location';
	const STORAGE_EXPIRY_DAYS = 30;

	/**
	 * Загружает локацию из localStorage
	 */
	function loadFromStorage(): UserLocation | null {
		if (process.server) return null;

		try {
			const stored = localStorage.getItem(STORAGE_KEY);
			if (!stored) return null;

			const data = JSON.parse(stored);
			const expiryDate = new Date(data.expiry);

			// Проверяем срок действия
			if (expiryDate < new Date()) {
				localStorage.removeItem(STORAGE_KEY);
				return null;
			}

			return data.location;
		} catch {
			return null;
		}
	}

	/**
	 * Сохраняет локацию в localStorage
	 */
	function saveToStorage(location: UserLocation) {
		if (process.server) return;

		try {
			const expiry = new Date();
			expiry.setDate(expiry.getDate() + STORAGE_EXPIRY_DAYS);

			localStorage.setItem(
				STORAGE_KEY,
				JSON.stringify({
					location,
					expiry: expiry.toISOString(),
				}),
			);
		} catch (error) {
			console.error('Failed to save location to storage:', error);
		}
	}

	/**
	 * Определяет локацию пользователя по IP
	 */
	async function detectLocation() {
		// Проверяем localStorage
		const cached = loadFromStorage();
		if (cached) {
			userLocation.value = cached;
			return cached;
		}

		// Определяем по IP
		isLoadingLocation.value = true;
		try {
			const detected = await $fetch<UserLocation>('/api/geo/detect-location');
			userLocation.value = detected;
			saveToStorage(detected);
			return detected;
		} catch (error) {
			console.error('Failed to detect location:', error);
			return null;
		} finally {
			isLoadingLocation.value = false;
		}
	}

	/**
	 * Устанавливает локацию вручную (когда пользователь выбирает город)
	 */
	function setLocation(city: string, latitude: number, longitude: number) {
		const location: UserLocation = {
			city,
			latitude,
			longitude,
			detected: false,
			fallback: false,
		};
		userLocation.value = location;
		saveToStorage(location);

		// TODO: Если пользователь авторизован, сохранить в БД
	}

	/**
	 * Очищает локацию
	 */
	function clearLocation() {
		userLocation.value = null;
		if (process.client) {
			localStorage.removeItem(STORAGE_KEY);
		}
	}

	return {
		userLocation: computed(() => userLocation.value),
		isLoadingLocation: computed(() => isLoadingLocation.value),
		detectLocation,
		setLocation,
		clearLocation,
	};
}
```

**Критерии приемки:**

- [ ] AC-4.1: `useUserLocation` возвращает текущую локацию пользователя
- [ ] AC-4.2: `detectLocation()` определяет город по IP
- [ ] AC-4.3: Локация сохраняется в localStorage на 30 дней
- [ ] AC-4.4: `setLocation()` позволяет вручную установить город
- [ ] AC-4.5: При повторном заходе, локация загружается из localStorage

---

### Задача 5: Создать компонент LocationSelector

**Что делать:**

Создать компонент для отображения и изменения города пользователя.

**Файл:** `components/LocationSelector.vue`

```vue
<script setup lang="ts">
import { ref, computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useUserLocation } from '~/composables/useUserLocation';

const { t, locale } = useI18n();
const { userLocation, setLocation } = useUserLocation();

// Загружаем список всех городов
const { data: cities } = await useFetch('/api/cities/list');

const isDropdownOpen = ref(false);
const searchQuery = ref('');

const filteredCities = computed(() => {
	if (!cities.value || !searchQuery.value) return cities.value;

	const query = searchQuery.value.toLowerCase();
	return cities.value.filter(
		(city: any) =>
			city.name.toLowerCase().includes(query) ||
			city.name_local.toLowerCase().includes(query),
	);
});

function selectCity(city: any) {
	setLocation(city.name, city.latitude, city.longitude);
	isDropdownOpen.value = false;
	searchQuery.value = '';

	// Перезагружаем страницу для применения сортировки
	window.location.reload();
}

const displayCity = computed(() => {
	if (!userLocation.value) return t('SelectCity');

	return userLocation.value.city;
});
</script>

<template>
	<div class="location-selector">
		<button
			class="location-selector__button"
			@click="isDropdownOpen = !isDropdownOpen"
			:aria-expanded="isDropdownOpen"
			:aria-label="t('ChangeLocation')"
		>
			<svg
				class="location-icon"
				width="16"
				height="16"
				viewBox="0 0 16 16"
				fill="currentColor"
			>
				<path
					d="M8 0C5.2 0 3 2.2 3 5c0 3.5 5 11 5 11s5-7.5 5-11c0-2.8-2.2-5-5-5zm0 7c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"
				/>
			</svg>
			<span class="location-selector__city">{{ displayCity }}</span>
			<svg
				class="dropdown-arrow"
				width="12"
				height="12"
				viewBox="0 0 12 12"
				fill="currentColor"
			>
				<path
					d="M2 4l4 4 4-4"
					stroke="currentColor"
					stroke-width="2"
					fill="none"
				/>
			</svg>
		</button>

		<div v-if="isDropdownOpen" class="location-selector__dropdown">
			<input
				v-model="searchQuery"
				type="text"
				class="location-selector__search"
				:placeholder="t('SearchCity')"
				autofocus
			/>

			<ul class="location-selector__list">
				<li
					v-for="city in filteredCities"
					:key="city.id"
					class="location-selector__item"
					:class="{ 'is-active': city.name === userLocation?.city }"
					@click="selectCity(city)"
				>
					{{ city.name }}
					<span v-if="city.name !== city.name_local" class="city-local">
						({{ city.name_local }})
					</span>
				</li>
			</ul>
		</div>
	</div>
</template>

<style scoped lang="less">
.location-selector {
	position: relative;

	&__button {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 8px 12px;
		background: #fff;
		border: 1px solid #e2e8f0;
		border-radius: 8px;
		cursor: pointer;
		font-size: 14px;
		color: #334155;
		transition: all 0.2s;

		&:hover {
			border-color: #cbd5e1;
			background: #f8fafc;
		}
	}

	&__city {
		font-weight: 500;
	}

	&__dropdown {
		position: absolute;
		top: calc(100% + 4px);
		left: 0;
		min-width: 280px;
		background: #fff;
		border: 1px solid #e2e8f0;
		border-radius: 12px;
		box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
		z-index: 1000;
		padding: 8px;
	}

	&__search {
		width: 100%;
		padding: 8px 12px;
		border: 1px solid #e2e8f0;
		border-radius: 8px;
		font-size: 14px;
		margin-bottom: 8px;

		&:focus {
			outline: none;
			border-color: #4f46e5;
		}
	}

	&__list {
		max-height: 300px;
		overflow-y: auto;
		list-style: none;
		padding: 0;
		margin: 0;
	}

	&__item {
		padding: 10px 12px;
		cursor: pointer;
		border-radius: 6px;
		font-size: 14px;
		color: #334155;
		transition: background 0.15s;

		&:hover {
			background: #f1f5f9;
		}

		&.is-active {
			background: #eef2ff;
			color: #4f46e5;
			font-weight: 500;
		}
	}
}

.city-local {
	color: #94a3b8;
	font-size: 13px;
}

.location-icon,
.dropdown-arrow {
	flex-shrink: 0;
	color: #64748b;
}
</style>
```

**Критерии приемки:**

- [ ] AC-5.1: Компонент отображает текущий город пользователя
- [ ] AC-5.2: По клику открывается dropdown со списком городов
- [ ] AC-5.3: Есть поле поиска для фильтрации городов
- [ ] AC-5.4: При выборе города, список клиник пересортировывается
- [ ] AC-5.5: Текущий город визуально выделен в списке
- [ ] AC-5.6: Компонент адаптивен для мобильных устройств

---

### Задача 6: Интегрировать LocationSelector в страницу клиник

**Что делать:**

Обновить страницу `/pages/clinics/index.vue` для интеграции геолокации.

**Изменения:**

1. Добавить `LocationSelector` в фильтры
2. Передавать координаты пользователя в API
3. Отображать расстояние на карточках клиник

```vue
<script setup lang="ts">
import { useUserLocation } from '~/composables/useUserLocation';
import { calculateDistance, formatDistance } from '~/utils/distance';

const { userLocation, detectLocation } = useUserLocation();
const { locale } = useI18n();

// Определяем локацию при загрузке страницы
onMounted(() => {
	detectLocation();
});

// Передаем координаты в API
const filterList = computed(() => ({
	cityIds: cityIds.value,
	languageIds: languageIds.value,
	name: name.value,
	locale: locale.value,
	page: pageNumber.value,
	// Добавляем геолокацию
	userLatitude: userLocation.value?.latitude,
	userLongitude: userLocation.value?.longitude,
	sortByDistance: !!userLocation.value,
}));

// Функция для отображения расстояния
function getDistance(clinic: any): string | null {
	if (!userLocation.value || !clinic.latitude || !clinic.longitude) {
		return null;
	}

	const distanceKm = calculateDistance(
		userLocation.value.latitude,
		userLocation.value.longitude,
		clinic.latitude,
		clinic.longitude,
	);

	return formatDistance(distanceKm, locale.value);
}
</script>

<template>
	<div class="clinics-page">
		<div class="filters">
			<!-- Существующие фильтры -->
			<FiltersPanel />

			<!-- Новый селектор локации -->
			<LocationSelector />
		</div>

		<div class="clinics-list">
			<ClinicCard
				v-for="clinic in clinicsList?.data"
				:key="clinic.id"
				:clinic="clinic"
				:distance="getDistance(clinic)"
			/>
		</div>
	</div>
</template>
```

**Критерии приемки:**

- [ ] AC-6.1: `LocationSelector` отображается на странице клиник
- [ ] AC-6.2: При первом заходе, город определяется автоматически
- [ ] AC-6.3: Список клиник сортируется по расстоянию
- [ ] AC-6.4: На карточках клиник отображается расстояние
- [ ] AC-6.5: При изменении города, список пересортировывается

---

### Задача 7: Обновить компонент ClinicCard для отображения расстояния

**Что делать:**

Добавить отображение расстояния на карточку клиники.

**Файл:** `components/ClinicCard.vue`

```vue
<script setup lang="ts">
defineProps<{
	clinic: any;
	distance?: string | null;
}>();
</script>

<template>
	<div class="clinic-card">
		<!-- Существующий контент карточки -->

		<!-- Новый бейдж с расстоянием -->
		<div v-if="distance" class="clinic-card__distance">
			<svg width="12" height="12" viewBox="0 0 12 12" fill="currentColor">
				<path
					d="M6 0C3.9 0 2.25 1.65 2.25 3.75c0 2.625 3.75 8.25 3.75 8.25s3.75-5.625 3.75-8.25C9.75 1.65 8.1 0 6 0zm0 5.25c-.825 0-1.5-.675-1.5-1.5s.675-1.5 1.5-1.5 1.5.675 1.5 1.5-.675 1.5-1.5 1.5z"
				/>
			</svg>
			<span>{{ distance }}</span>
		</div>
	</div>
</template>

<style scoped lang="less">
.clinic-card {
	position: relative;

	&__distance {
		display: inline-flex;
		align-items: center;
		gap: 4px;
		padding: 4px 8px;
		background: #f0fdf4;
		color: #16a34a;
		border-radius: 6px;
		font-size: 13px;
		font-weight: 500;
		margin-top: 8px;

		svg {
			flex-shrink: 0;
		}
	}
}
</style>
```

**Критерии приемки:**

- [ ] AC-7.1: Расстояние отображается на карточке клиники
- [ ] AC-7.2: Есть иконка маркера рядом с расстоянием
- [ ] AC-7.3: Расстояние форматируется правильно (км/м)
- [ ] AC-7.4: Для клиник без геолокации, расстояние не отображается

---

### Задача 8: Добавить сохранение города в БД для авторизованных пользователей

**Что делать:**

1. Добавить поле `preferred_city_id` в таблицу `users`
2. Создать API endpoint для сохранения города
3. Обновить `useUserLocation` для синхронизации с БД

**Миграция:** `server/sql/migrations/add_user_preferred_city.sql`

```sql
ALTER TABLE users ADD COLUMN preferred_city_id INT NULL;
ALTER TABLE users ADD FOREIGN KEY (preferred_city_id) REFERENCES cities(id) ON DELETE SET NULL;
```

**API Endpoint:** `server/api/user/set-location.post.ts`

```typescript
export default defineEventHandler(async (event) => {
	const session = await getUserSession(event);
	if (!session?.userId) {
		throw createError({ statusCode: 401, message: 'Unauthorized' });
	}

	const { cityId } = await readBody(event);
	const db = useDatabase();

	await db.sql`
    UPDATE users
    SET preferred_city_id = ${cityId}
    WHERE id = ${session.userId}
  `;

	return { success: true };
});
```

**Критерии приемки:**

- [ ] AC-8.1: Поле `preferred_city_id` добавлено в таблицу `users`
- [ ] AC-8.2: API endpoint `/api/user/set-location` создан
- [ ] AC-8.3: Для авторизованных пользователей город сохраняется в БД
- [ ] AC-8.4: При следующем заходе, город загружается из БД (а не localStorage)

---

## Критерии приемки итерации

- [x] **AC-I2-1:** Город пользователя определяется автоматически по IP при первом заходе
- [x] **AC-I2-2:** Список клиник сортируется по расстоянию от города пользователя
- [x] **AC-I2-3:** На карточках клиник отображается расстояние (км/м)
- [x] **AC-I2-4:** Компонент `LocationSelector` отображается на странице клиник
- [x] **AC-I2-5:** Пользователь может вручную изменить свой город
- [x] **AC-I2-6:** Выбранный город сохраняется в localStorage на 30 дней
- [x] **AC-I2-7:** Для авторизованных пользователей город сохраняется в БД (⚠️ требует применения миграции 004)
- [x] **AC-I2-8:** Геолокация НЕ скрывает клиники из других городов
- [x] **AC-I2-9:** При ошибке геолокации используется fallback (Podgorica)
- [x] **AC-I2-10:** Работает на всех 6 языках (локализация)
- [x] **AC-I2-11:** Производительность: определение города < 300ms (с in-memory кэшем по IP; первый запрос зависит от ipapi.co, таймаут 3с)
- [x] **AC-I2-12:** Производительность: сортировка по расстоянию < 500ms (Haversine в SQL)

---

## Инструкции по проверке

### Тест 1: Автоматическое определение города

1. Очистить localStorage (`localStorage.clear()`)
2. Открыть страницу `/clinics` в режиме инкогнито
3. Проверить, что город определился автоматически
4. Проверить, что список клиник отсортирован по расстоянию
5. Проверить, что на карточках показывается расстояние

**Ожидаемый результат:** Город определен, клиники отсортированы, расстояние отображается.

---

### Тест 2: Ручное изменение города

1. Открыть страницу `/clinics`
2. Кликнуть на `LocationSelector`
3. Выбрать другой город (например, Bar)
4. Проверить, что список пересортировался
5. Проверить, что расстояния пересчитались

**Ожидаемый результат:** Список обновлен, расстояния корректны.

---

### Тест 3: Сохранение города в localStorage

1. Выбрать город вручную
2. Обновить страницу (F5)
3. Проверить, что выбранный город сохранился
4. Проверить срок действия (30 дней)

**Ожидаемый результат:** Город сохранен, срок действия установлен.

---

### Тест 4: Fallback при ошибке геолокации

1. Заблокировать доступ к IP Geolocation API (DevTools → Network → Block)
2. Очистить localStorage
3. Открыть страницу `/clinics`
4. Проверить, что используется Podgorica как fallback

**Ожидаемый результат:** Podgorica установлена как город, список работает.

---

### Тест 5: Геолокация не фильтрует клиники

1. Установить город "Podgorica"
2. Проверить, что в списке есть клиники из других городов (Bar, Budva)
3. Проверить, что клиники из Podgorica идут первыми

**Ожидаемый результат:** Все клиники видны, но отсортированы по расстоянию.

---

### Тест 6: Сохранение в БД для авторизованных

1. Авторизоваться
2. Выбрать город
3. Проверить в БД, что `preferred_city_id` обновился
4. Выйти и зайти снова
5. Проверить, что город загрузился из БД

**Ожидаемый результат:** Город сохранен в БД и загружается при следующем входе.

---

## Статус

🟢 **Completed** (2026-06-12, см. «Итог реализации» вверху)

---

[← К списку итераций](README.md) | [← К оглавлению PRD](../index.md)

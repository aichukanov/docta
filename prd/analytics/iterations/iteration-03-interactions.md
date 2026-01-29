# Итерация 3: События взаимодействия

**Статус:** 🔴 Not Started  
**Приоритет:** P0 (критично)  
**Оценка:** 4-5 дней  
**Зависимости:** Итерации 1 и 2 должны быть завершены

---

## Цель

Добавить трэкинг всех пользовательских взаимодействий: клики на контакты, копирование данных, переходы между страницами, поиск, фильтры, карта, избранное.

---

## Scope

### В рамках итерации

✅ Трэкинг кликов и копирования контактов (телефон, email, адрес)  
✅ Трэкинг переходов на сайты клиник  
✅ Трэкинг переходов между страницами (service→clinic, doctor→clinic)  
✅ Трэкинг поиска и фильтров  
✅ Трэкинг взаимодействия с картой  
✅ Трэкинг избранного  
✅ Трэкинг социальных действий (share, reviews)  
✅ Расширение TypeScript типов

### Вне рамок

❌ Воронки и dashboards (итерация 4)  
❌ Advanced cohort analysis (итерация 4)

---

## Задачи

### 1. Расширение TypeScript типов

**Задача 1.1:** Добавить типы в `types/analytics.ts`

```typescript
export type EventName =
	// ... previous events
	// Contact Interactions
	| 'Phone Clicked'
	| 'Phone Copied'
	| 'Email Clicked'
	| 'Email Copied'
	| 'Address Copied'
	| 'Website Visited'
	// Navigation
	| 'Clinic Viewed from Service'
	| 'Clinic Viewed from Doctor'
	| 'Doctor Viewed from Clinic'
	| 'Service Clicked'
	| 'Card Clicked'
	// Search & Filters
	| 'Search Performed'
	| 'Search Result Clicked'
	| 'Filter Applied'
	| 'Filter Cleared'
	| 'Sort Changed'
	| 'Tag Clicked'
	// Map
	| 'Map Opened'
	| 'Map Marker Clicked'
	| 'Map Bounds Changed'
	// Social
	| 'Added to Favorites'
	| 'Removed from Favorites'
	| 'Content Shared'
	| 'Review Started'
	| 'Review Submitted';

// Phone/Email Events Properties
export interface ContactInteractionProperties extends BaseEventProperties {
	entity_type: 'clinic' | 'doctor';
	entity_id: string;
	entity_name: string;
	contact_type: 'phone' | 'email' | 'address';
	phone_type?: 'main' | 'mobile' | 'reception';
	source_page: string;
	interaction_type: 'click' | 'copy';
}

// Website Visit Properties
export interface WebsiteVisitedProperties extends BaseEventProperties {
	clinic_id: string;
	clinic_name: string;
	website_url: string;
	source_page:
		| 'clinic_page'
		| 'service_page'
		| 'doctor_page'
		| 'search_results';
}

// Navigation Properties
export interface NavigationProperties extends BaseEventProperties {
	from_entity_type: 'service' | 'doctor' | 'clinic' | 'search' | 'home';
	from_entity_id?: string;
	to_entity_type: 'clinic' | 'doctor' | 'service';
	to_entity_id: string;
	position_in_list?: number;
}

// Search Properties
export interface SearchPerformedProperties extends BaseEventProperties {
	query: string;
	search_type: 'clinics' | 'doctors' | 'services' | 'all';
	results_count: number;
	results_found: boolean;
	city?: string;
}

// Filter Properties
export interface FilterAppliedProperties extends BaseEventProperties {
	page_type: 'clinics' | 'doctors' | 'services';
	filter_name: string;
	filter_value: string | string[];
	results_count_before: number;
	results_count_after: number;
}

// Map Properties
export interface MapInteractionProperties extends BaseEventProperties {
	action: 'opened' | 'marker_clicked' | 'bounds_changed';
	entity_type?: 'clinic' | 'doctor';
	entity_id?: string;
	zoom_level?: number;
	visible_items_count?: number;
}

// Favorites Properties
export interface FavoritesProperties extends BaseEventProperties {
	entity_type: 'clinic' | 'doctor' | 'service';
	entity_id: string;
	entity_name: string;
	source_page: string;
	action: 'add' | 'remove';
}
```

### 2. Трэкинг контактных взаимодействий

**Задача 2.1:** Создать composable для контактов

```typescript
// composables/useContactTracking.ts
import type { ContactInteractionProperties } from '~/types/analytics';

export const useContactTracking = (
	entityType: 'clinic' | 'doctor',
	entityId: string,
	entityName: string,
) => {
	const { trackEvent } = useAnalytics();
	const route = useRoute();

	const trackPhoneClick = (phoneType: string) => {
		const properties: ContactInteractionProperties = {
			entity_type: entityType,
			entity_id: entityId,
			entity_name: entityName,
			contact_type: 'phone',
			phone_type: phoneType as any,
			source_page: route.name as string,
			interaction_type: 'click',
		};
		trackEvent('Phone Clicked', properties);
	};

	const trackPhoneCopy = (phoneType: string) => {
		const properties: ContactInteractionProperties = {
			entity_type: entityType,
			entity_id: entityId,
			entity_name: entityName,
			contact_type: 'phone',
			phone_type: phoneType as any,
			source_page: route.name as string,
			interaction_type: 'copy',
		};
		trackEvent('Phone Copied', properties);
	};

	const trackEmailClick = () => {
		const properties: ContactInteractionProperties = {
			entity_type: entityType,
			entity_id: entityId,
			entity_name: entityName,
			contact_type: 'email',
			source_page: route.name as string,
			interaction_type: 'click',
		};
		trackEvent('Email Clicked', properties);
	};

	const trackEmailCopy = () => {
		const properties: ContactInteractionProperties = {
			entity_type: entityType,
			entity_id: entityId,
			entity_name: entityName,
			contact_type: 'email',
			source_page: route.name as string,
			interaction_type: 'copy',
		};
		trackEvent('Email Copied', properties);
	};

	const trackAddressCopy = () => {
		const properties: ContactInteractionProperties = {
			entity_type: entityType,
			entity_id: entityId,
			entity_name: entityName,
			contact_type: 'address',
			source_page: route.name as string,
			interaction_type: 'copy',
		};
		trackEvent('Address Copied', properties);
	};

	return {
		trackPhoneClick,
		trackPhoneCopy,
		trackEmailClick,
		trackEmailCopy,
		trackAddressCopy,
	};
};
```

**Задача 2.2:** Обновить компонент контактов

```vue
<!-- components/clinic/ContactInfo.vue -->
<script setup lang="ts">
interface Props {
	clinicId: string;
	clinicName: string;
	phone?: string;
	mobilePhone?: string;
	email?: string;
	address?: string;
}

const props = defineProps<Props>();

const {
	trackPhoneClick,
	trackPhoneCopy,
	trackEmailClick,
	trackEmailCopy,
	trackAddressCopy,
} = useContactTracking('clinic', props.clinicId, props.clinicName);

const copyPhone = async (phone: string, type: string) => {
	try {
		await navigator.clipboard.writeText(phone);
		trackPhoneCopy(type);
		ElMessage.success('Телефон скопирован');
	} catch (error) {
		ElMessage.error('Не удалось скопировать');
	}
};

const copyEmail = async (email: string) => {
	try {
		await navigator.clipboard.writeText(email);
		trackEmailCopy();
		ElMessage.success('Email скопирован');
	} catch (error) {
		ElMessage.error('Не удалось скопировать');
	}
};

const copyAddress = async (address: string) => {
	try {
		await navigator.clipboard.writeText(address);
		trackAddressCopy();
		ElMessage.success('Адрес скопирован');
	} catch (error) {
		ElMessage.error('Не удалось скопировать');
	}
};
</script>

<template>
	<div class="contact-info">
		<!-- Phone -->
		<div v-if="phone" class="contact-item">
			<a :href="`tel:${phone}`" @click="trackPhoneClick('main')">
				{{ phone }}
			</a>
			<button @click="copyPhone(phone, 'main')">
				<Icon name="copy" />
			</button>
		</div>

		<!-- Mobile -->
		<div v-if="mobilePhone" class="contact-item">
			<a :href="`tel:${mobilePhone}`" @click="trackPhoneClick('mobile')">
				{{ mobilePhone }}
			</a>
			<button @click="copyPhone(mobilePhone, 'mobile')">
				<Icon name="copy" />
			</button>
		</div>

		<!-- Email -->
		<div v-if="email" class="contact-item">
			<a :href="`mailto:${email}`" @click="trackEmailClick">
				{{ email }}
			</a>
			<button @click="copyEmail(email)">
				<Icon name="copy" />
			</button>
		</div>

		<!-- Address -->
		<div v-if="address" class="contact-item">
			<span>{{ address }}</span>
			<button @click="copyAddress(address)">
				<Icon name="copy" />
			</button>
		</div>
	</div>
</template>
```

### 3. Трэкинг переходов на сайты

**Задача 3.1:** Создать composable для website visits

```typescript
// composables/useWebsiteTracking.ts
import type { WebsiteVisitedProperties } from '~/types/analytics';

export const useWebsiteTracking = () => {
	const { trackEvent } = useAnalytics();
	const route = useRoute();

	const trackWebsiteVisit = (
		clinicId: string,
		clinicName: string,
		websiteUrl: string,
	) => {
		const properties: WebsiteVisitedProperties = {
			clinic_id: clinicId,
			clinic_name: clinicName,
			website_url: websiteUrl,
			source_page: route.name as any,
		};
		trackEvent('Website Visited', properties);
	};

	return {
		trackWebsiteVisit,
	};
};
```

**Задача 3.2:** Использовать в компонентах

```vue
<script setup lang="ts">
const { trackWebsiteVisit } = useWebsiteTracking();

const visitWebsite = (url: string) => {
	trackWebsiteVisit(clinic.value.id, clinic.value.name, url);
	window.open(url, '_blank', 'noopener,noreferrer');
};
</script>

<template>
	<button @click="visitWebsite(clinic.website)"> Перейти на сайт </button>
</template>
```

### 4. Трэкинг навигации между страницами

**Задача 4.1:** Создать composable для navigation tracking

```typescript
// composables/useNavigationTracking.ts
import type { NavigationProperties } from '~/types/analytics';

export const useNavigationTracking = () => {
	const { trackEvent } = useAnalytics();

	const trackNavigation = (
		fromType: NavigationProperties['from_entity_type'],
		toType: NavigationProperties['to_entity_type'],
		toId: string,
		options?: {
			fromId?: string;
			position?: number;
		},
	) => {
		const properties: NavigationProperties = {
			from_entity_type: fromType,
			from_entity_id: options?.fromId,
			to_entity_type: toType,
			to_entity_id: toId,
			position_in_list: options?.position,
		};

		const eventName = `${
			toType.charAt(0).toUpperCase() + toType.slice(1)
		} Viewed from ${fromType.charAt(0).toUpperCase() + fromType.slice(1)}`;
		trackEvent(eventName as any, properties);
	};

	return {
		trackNavigation,
	};
};
```

**Задача 4.2:** Использовать в ClinicCard компоненте

```vue
<!-- components/shared/ClinicCard.vue -->
<script setup lang="ts">
const { trackNavigation } = useNavigationTracking();
const route = useRoute();

const handleClick = () => {
	// Определяем откуда пришел пользователь
	let fromType: NavigationProperties['from_entity_type'] = 'search';
	let fromId: string | undefined;

	if (route.name?.includes('services-id')) {
		fromType = 'service';
		fromId = route.params.id as string;
	} else if (route.name?.includes('doctors-id')) {
		fromType = 'doctor';
		fromId = route.params.id as string;
	}

	trackNavigation(fromType, 'clinic', props.clinic.id, {
		fromId,
		position: props.position,
	});

	// Navigate
	navigateTo(`/clinics/${props.clinic.id}`);
};
</script>

<template>
	<div class="clinic-card" @click="handleClick">
		<!-- Карточка клиники -->
	</div>
</template>
```

### 5. Трэкинг поиска

**Задача 5.1:** Обновить SearchBar компонент

```vue
<!-- components/shared/SearchBar.vue -->
<script setup lang="ts">
import type { SearchPerformedProperties } from '~/types/analytics';

const { trackEvent } = useAnalytics();
const searchQuery = ref('');
const searchType = ref<'all' | 'clinics' | 'doctors' | 'services'>('all');

const handleSearch = async () => {
	if (!searchQuery.value.trim()) return;

	// Выполнить поиск
	const results = await performSearch(searchQuery.value, searchType.value);

	// Track событие
	const properties: SearchPerformedProperties = {
		query: searchQuery.value,
		search_type: searchType.value,
		results_count: results.length,
		results_found: results.length > 0,
		city: route.query.city as string,
	};

	trackEvent('Search Performed', properties);

	// Navigate to results
	navigateTo({
		path: '/search',
		query: {
			q: searchQuery.value,
			type: searchType.value,
		},
	});
};
</script>
```

### 6. Трэкинг фильтров

**Задача 6.1:** Создать composable для фильтров

```typescript
// composables/useFilterTracking.ts
import type { FilterAppliedProperties } from '~/types/analytics';

export const useFilterTracking = (
	pageType: 'clinics' | 'doctors' | 'services',
) => {
	const { trackEvent } = useAnalytics();

	const trackFilterApplied = (
		filterName: string,
		filterValue: string | string[],
		resultsBefore: number,
		resultsAfter: number,
	) => {
		const properties: FilterAppliedProperties = {
			page_type: pageType,
			filter_name: filterName,
			filter_value: filterValue,
			results_count_before: resultsBefore,
			results_count_after: resultsAfter,
		};

		trackEvent('Filter Applied', properties);
	};

	const trackFilterCleared = () => {
		trackEvent('Filter Cleared', {
			page_type: pageType,
		});
	};

	return {
		trackFilterApplied,
		trackFilterCleared,
	};
};
```

**Задача 6.2:** Использовать в FilterPanel

```vue
<!-- components/shared/FilterPanel.vue -->
<script setup lang="ts">
const { trackFilterApplied, trackFilterCleared } = useFilterTracking('clinics');

const resultsCount = ref(0);
const previousCount = ref(0);

const applyFilter = (filterName: string, value: string) => {
	previousCount.value = resultsCount.value;

	// Применить фильтр
	// ... логика фильтрации

	// После получения новых результатов
	trackFilterApplied(
		filterName,
		value,
		previousCount.value,
		resultsCount.value,
	);
};

const clearAllFilters = () => {
	trackFilterCleared();
	// ... логика очистки
};
</script>
```

### 7. Трэкинг карты

**Задача 7.1:** Обновить MapView компонент

```vue
<!-- components/map/MapView.vue -->
<script setup lang="ts">
import type { MapInteractionProperties } from '~/types/analytics';

const { trackEvent } = useAnalytics();

const handleMapOpen = () => {
	const properties: MapInteractionProperties = {
		action: 'opened',
		visible_items_count: markers.value.length,
	};
	trackEvent('Map Opened', properties);
};

const handleMarkerClick = (
	entityType: 'clinic' | 'doctor',
	entityId: string,
) => {
	const properties: MapInteractionProperties = {
		action: 'marker_clicked',
		entity_type: entityType,
		entity_id: entityId,
		zoom_level: map.value?.getZoom(),
	};
	trackEvent('Map Marker Clicked', properties);
};
</script>
```

### 8. Трэкинг избранного

**Задача 8.1:** Создать composable

```typescript
// composables/useFavoritesTracking.ts
import type { FavoritesProperties } from '~/types/analytics';

export const useFavoritesTracking = () => {
	const { trackEvent } = useAnalytics();
	const route = useRoute();

	const trackAddToFavorites = (
		entityType: 'clinic' | 'doctor' | 'service',
		entityId: string,
		entityName: string,
	) => {
		const properties: FavoritesProperties = {
			entity_type: entityType,
			entity_id: entityId,
			entity_name: entityName,
			source_page: route.name as string,
			action: 'add',
		};
		trackEvent('Added to Favorites', properties);
	};

	const trackRemoveFromFavorites = (
		entityType: 'clinic' | 'doctor' | 'service',
		entityId: string,
		entityName: string,
	) => {
		const properties: FavoritesProperties = {
			entity_type: entityType,
			entity_id: entityId,
			entity_name: entityName,
			source_page: route.name as string,
			action: 'remove',
		};
		trackEvent('Removed from Favorites', properties);
	};

	return {
		trackAddToFavorites,
		trackRemoveFromFavorites,
	};
};
```

### 9. Тестирование

**Задача 9.1:** E2E тесты для interactions

```typescript
// e2e/analytics/interactions.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Contact Interactions', () => {
	test('should track phone copy', async ({ page }) => {
		let phoneCopyTracked = false;

		await page.route('**/api.mixpanel.com/**', async (route) => {
			const postData = route.request().postData();
			if (postData?.includes('Phone Copied')) {
				phoneCopyTracked = true;
			}
			await route.continue();
		});

		await page.goto('/clinics/test-clinic');
		await page.click('[data-testid="copy-phone-button"]');

		await page.waitForTimeout(1000);
		expect(phoneCopyTracked).toBe(true);
	});

	// More tests...
});
```

### 10. Документация

**Задача 10.1:** Обновить `docs/analytics/events.md`

Добавить документацию для всех новых событий взаимодействия.

---

## Критерии приемки

- [ ] Все контактные взаимодействия трэкаются
- [ ] Переходы на сайты трэкаются
- [ ] Навигация между страницами трэкается
- [ ] Поиск и фильтры трэкаются
- [ ] Карта трэкается
- [ ] Избранное трэкается
- [ ] TypeScript типы для всех событий
- [ ] Events видны в Mixpanel Live View
- [ ] Unit/E2E тесты проходят
- [ ] Документация обновлена

---

## Testing Checklist

### Manual Testing

- [ ] Скопировать телефон → проверить Phone Copied event
- [ ] Кликнуть на телефон → проверить Phone Clicked event
- [ ] Перейти на сайт клиники → проверить Website Visited event
- [ ] Перейти с услуги на клинику → проверить navigation event
- [ ] Выполнить поиск → проверить Search Performed event
- [ ] Применить фильтр → проверить Filter Applied event
- [ ] Добавить в избранное → проверить Added to Favorites event

---

## Следующие шаги

После завершения:

1. Переходим к **Итерации 4** - настройка воронок, dashboards, cohorts

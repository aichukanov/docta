# Итерация 2: События просмотра страниц

**Статус:** 🟢 Completed (код, 2026-06-11)

> Реальность: вместо отдельных «Clinic Viewed»/«Doctor Viewed» — единое
> событие `entity_viewed` с `entity_type/entity_id/entity_slug` на всех
> детальных страницах (клиника, врач, услуга, анализ, лекарство, статьи).
> Листинги покрыты автоматическим pageview (фильтры видны в URL события).
> Identify/reset подключены к auth (plugins/analytics-user.client.ts),
> user property `auth_provider`. Счётчики `incrementUserProperty` не делали —
> агрегируется в Mixpanel из событий. Unit-тестов нет (фреймворка нет в
> проекте). Каталог: ../events-catalog.md  
**Приоритет:** P0 (критично)  
**Оценка:** 3-4 дня  
**Зависимости:** Итерация 1 должна быть завершена

---

## Цель

Добавить трэкинг всех основных просмотров страниц: клиники, врачи, услуги, лекарства, статьи. Настроить user identification при авторизации.

---

## Scope

### В рамках итерации

✅ Трэкинг просмотра страниц клиник  
✅ Трэкинг просмотра страниц врачей  
✅ Трэкинг просмотра страниц услуг  
✅ Трэкинг просмотра страниц лекарств  
✅ Трэкинг просмотра статей  
✅ Трэкинг списочных страниц с фильтрами  
✅ User identification при авторизации  
✅ Инкрементирование счетчиков пользователя  
✅ Расширение TypeScript типов для новых событий

### Вне рамок

❌ События взаимодействия (клики, копирование) - итерация 3  
❌ Воронки и dashboards - итерация 4  
❌ Advanced user segmentation - итерация 4

---

## Задачи

### 1. Расширение TypeScript типов

**Задача 1.1:** Обновить `types/analytics.ts`

```typescript
// Добавить новые типы событий
export type EventName =
	// Page Views
	| 'Page Viewed'
	| 'Clinic Viewed'
	| 'Doctor Viewed'
	| 'Service Viewed'
	| 'Medicine Viewed'
	| 'Article Viewed'
	| 'List Page Viewed';

// Clinic Viewed Properties
export interface ClinicViewedProperties extends BaseEventProperties {
	clinic_id: string;
	clinic_name: string;
	city: string;
	district?: string;
	is_verified: boolean;
	rating?: number;
	reviews_count: number;
	services_count?: number;
	doctors_count?: number;
	has_working_hours: boolean;
	is_open_now?: boolean;
	source?: string; // referrer, откуда пришел пользователь
}

// Doctor Viewed Properties
export interface DoctorViewedProperties extends BaseEventProperties {
	doctor_id: string;
	doctor_name: string;
	specialization: string;
	clinic_id?: string;
	clinic_name?: string;
	experience_years?: number;
	rating?: number;
	reviews_count: number;
	has_photo: boolean;
	source?: string;
}

// Service Viewed Properties
export interface ServiceViewedProperties extends BaseEventProperties {
	service_id: string;
	service_name: string;
	category: string;
	subcategory?: string;
	price_range?: string;
	clinics_count: number; // сколько клиник предлагают эту услугу
	source?: string;
}

// Medicine Viewed Properties
export interface MedicineViewedProperties extends BaseEventProperties {
	medicine_id: string;
	medicine_name: string;
	category: string;
	manufacturer?: string;
	has_instructions: boolean;
	has_analogues: boolean;
	source?: string;
}

// Article Viewed Properties
export interface ArticleViewedProperties extends BaseEventProperties {
	article_id: string;
	title: string;
	category: string;
	tags?: string[];
	author?: string;
	read_time_minutes?: number;
	word_count?: number;
	source?: string;
}

// List Page Viewed Properties
export interface ListPageViewedProperties extends BaseEventProperties {
	page_type: 'clinics' | 'doctors' | 'services' | 'medicines' | 'articles';
	results_count: number;
	filters_applied?: string[]; // какие фильтры применены
	sort_by?: string;
	city?: string;
	search_query?: string;
}

// User Properties для профиля
export interface ExtendedUserProperties extends UserProperties {
	total_clinics_viewed?: number;
	total_doctors_viewed?: number;
	total_services_viewed?: number;
	total_articles_viewed?: number;
	favorite_categories?: string[];
	last_active?: string;
}
```

### 2. Трэкинг страницы клиники

**Задача 2.1:** Обновить `pages/clinics/[id].vue`

```vue
<script setup lang="ts">
import type { ClinicViewedProperties } from '~/types/analytics';

const route = useRoute();
const { trackEvent, incrementUserProperty } = useAnalytics();

// Fetch clinic data
const { data: clinic } = await useFetch(`/api/clinics/${route.params.id}`);

// Track page view
onMounted(() => {
	if (clinic.value) {
		const properties: ClinicViewedProperties = {
			clinic_id: clinic.value.id,
			clinic_name: clinic.value.name,
			city: clinic.value.city,
			district: clinic.value.district,
			is_verified: clinic.value.isVerified,
			rating: clinic.value.rating,
			reviews_count: clinic.value.reviewsCount || 0,
			services_count: clinic.value.servicesCount,
			doctors_count: clinic.value.doctorsCount,
			has_working_hours: !!clinic.value.workingHours,
			is_open_now: clinic.value.isOpenNow,
			source: document.referrer || 'direct',
		};

		trackEvent('Clinic Viewed', properties);

		// Increment user counter
		incrementUserProperty('total_clinics_viewed');
	}
});
</script>
```

### 3. Трэкинг страницы врача

**Задача 3.1:** Обновить `pages/doctors/[id].vue`

```vue
<script setup lang="ts">
import type { DoctorViewedProperties } from '~/types/analytics';

const route = useRoute();
const { trackEvent, incrementUserProperty } = useAnalytics();

const { data: doctor } = await useFetch(`/api/doctors/${route.params.id}`);

onMounted(() => {
	if (doctor.value) {
		const properties: DoctorViewedProperties = {
			doctor_id: doctor.value.id,
			doctor_name: doctor.value.name,
			specialization: doctor.value.specialization,
			clinic_id: doctor.value.clinic?.id,
			clinic_name: doctor.value.clinic?.name,
			experience_years: doctor.value.experienceYears,
			rating: doctor.value.rating,
			reviews_count: doctor.value.reviewsCount || 0,
			has_photo: !!doctor.value.photoUrl,
			source: document.referrer || 'direct',
		};

		trackEvent('Doctor Viewed', properties);
		incrementUserProperty('total_doctors_viewed');
	}
});
</script>
```

### 4. Трэкинг страницы услуги

**Задача 4.1:** Обновить `pages/services/[id].vue`

```vue
<script setup lang="ts">
import type { ServiceViewedProperties } from '~/types/analytics';

const route = useRoute();
const { trackEvent, incrementUserProperty } = useAnalytics();

const { data: service } = await useFetch(`/api/services/${route.params.id}`);

onMounted(() => {
	if (service.value) {
		const properties: ServiceViewedProperties = {
			service_id: service.value.id,
			service_name: service.value.name,
			category: service.value.category,
			subcategory: service.value.subcategory,
			price_range: service.value.priceRange,
			clinics_count: service.value.clinicsCount || 0,
			source: document.referrer || 'direct',
		};

		trackEvent('Service Viewed', properties);
		incrementUserProperty('total_services_viewed');
	}
});
</script>
```

### 5. Трэкинг страницы лекарства

**Задача 5.1:** Обновить `pages/medicines/[id].vue`

```vue
<script setup lang="ts">
import type { MedicineViewedProperties } from '~/types/analytics';

const route = useRoute();
const { trackEvent } = useAnalytics();

const { data: medicine } = await useFetch(`/api/medicines/${route.params.id}`);

onMounted(() => {
	if (medicine.value) {
		const properties: MedicineViewedProperties = {
			medicine_id: medicine.value.id,
			medicine_name: medicine.value.name,
			category: medicine.value.category,
			manufacturer: medicine.value.manufacturer,
			has_instructions: !!medicine.value.instructions,
			has_analogues: (medicine.value.analogues?.length || 0) > 0,
			source: document.referrer || 'direct',
		};

		trackEvent('Medicine Viewed', properties);
	}
});
</script>
```

### 6. Трэкинг страницы статьи

**Задача 6.1:** Обновить `pages/articles/[id].vue`

```vue
<script setup lang="ts">
import type { ArticleViewedProperties } from '~/types/analytics';

const route = useRoute();
const { trackEvent, incrementUserProperty } = useAnalytics();

const { data: article } = await useFetch(`/api/articles/${route.params.id}`);

onMounted(() => {
	if (article.value) {
		const properties: ArticleViewedProperties = {
			article_id: article.value.id,
			title: article.value.title,
			category: article.value.category,
			tags: article.value.tags,
			author: article.value.author,
			read_time_minutes: article.value.readTime,
			word_count: article.value.content?.split(' ').length,
			source: document.referrer || 'direct',
		};

		trackEvent('Article Viewed', properties);
		incrementUserProperty('total_articles_viewed');
	}
});
</script>
```

### 7. Трэкинг списочных страниц

**Задача 7.1:** Создать composable для списочных страниц

```typescript
// composables/useListPageTracking.ts
import type { ListPageViewedProperties } from '~/types/analytics';

export const useListPageTracking = (
	pageType: ListPageViewedProperties['page_type'],
) => {
	const route = useRoute();
	const { trackEvent } = useAnalytics();

	const trackListPageView = (resultsCount: number) => {
		const properties: ListPageViewedProperties = {
			page_type: pageType,
			results_count: resultsCount,
			filters_applied: getAppliedFilters(),
			sort_by: route.query.sort as string,
			city: route.query.city as string,
			search_query: route.query.q as string,
		};

		trackEvent('List Page Viewed', properties);
	};

	const getAppliedFilters = (): string[] => {
		const filters: string[] = [];
		const query = route.query;

		if (query.city) filters.push('city');
		if (query.district) filters.push('district');
		if (query.category) filters.push('category');
		if (query.verified) filters.push('verified');
		if (query.rating) filters.push('rating');
		if (query.price) filters.push('price');
		// ... добавить остальные фильтры

		return filters;
	};

	return {
		trackListPageView,
	};
};
```

**Задача 7.2:** Использовать в страницах списков

```vue
<!-- pages/clinics/index.vue -->
<script setup lang="ts">
const { trackListPageView } = useListPageTracking('clinics');
const { data: clinics } = await useFetch('/api/clinics', {
	query: useRoute().query,
});

watch(
	() => clinics.value,
	(newClinics) => {
		if (newClinics) {
			trackListPageView(newClinics.length);
		}
	},
	{ immediate: true },
);
</script>
```

### 8. User Identification при авторизации

**Задача 8.1:** Обновить auth callback или middleware

```typescript
// Опция 1: В auth plugin или callback
// plugins/auth.client.ts или где у вас обрабатывается успешная авторизация

const handleAuthSuccess = (user: User) => {
	const { identifyUser, setUserProperty } = useAnalytics();

	// Identify user
	identifyUser(user.id, {
		$name: user.name,
		$email: user.email,
		role: user.role,
		city: user.city,
		created_at: user.createdAt,
	});

	// Set additional properties
	if (user.clinic) {
		setUserProperty('has_clinic', true);
		setUserProperty('clinic_id', user.clinic.id);
	}
};
```

**Задача 8.2:** Reset при logout

```typescript
// При logout
const handleLogout = () => {
	const { reset } = useAnalytics();
	reset(); // Сбросит user identification

	// ... остальная логика logout
};
```

### 9. Тестирование

**Задача 9.1:** Unit тесты для page tracking

```typescript
// tests/pages/clinics/[id].test.ts
import { describe, it, expect, vi } from 'vitest';
import { mountSuspended } from '@nuxt/test-utils';
import ClinicPage from '~/pages/clinics/[id].vue';

describe('Clinic Page Analytics', () => {
	it('should track clinic view on mount', async () => {
		const trackEvent = vi.fn();

		// Mock useAnalytics
		vi.mock('~/composables/useAnalytics', () => ({
			useAnalytics: () => ({
				trackEvent,
				incrementUserProperty: vi.fn(),
			}),
		}));

		const wrapper = await mountSuspended(ClinicPage);
		await wrapper.vm.$nextTick();

		expect(trackEvent).toHaveBeenCalledWith(
			'Clinic Viewed',
			expect.objectContaining({
				clinic_id: expect.any(String),
				clinic_name: expect.any(String),
			}),
		);
	});
});
```

**Задача 9.2:** E2E тест

```typescript
// e2e/analytics/page-views.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Page View Analytics', () => {
	test('should track clinic page view', async ({ page }) => {
		// Intercept Mixpanel API calls
		await page.route('**/api.mixpanel.com/**', async (route) => {
			const request = route.request();
			const postData = request.postData();

			if (postData?.includes('Clinic Viewed')) {
				console.log('✅ Clinic Viewed event tracked');
			}

			await route.continue();
		});

		await page.goto('/clinics/test-clinic-id');

		// Wait for analytics to fire
		await page.waitForTimeout(1000);
	});
});
```

### 10. Документация

**Задача 10.1:** Обновить `docs/analytics/events.md`

````markdown
# Analytics Events Documentation

## Page View Events

### Clinic Viewed

**Когда:** При открытии страницы клиники

**Свойства:**

- `clinic_id` (string, required): ID клиники
- `clinic_name` (string, required): Название клиники
- `city` (string, required): Город
- `is_verified` (boolean, required): Верифицирована ли клиника
- `rating` (number, optional): Рейтинг клиники
- `reviews_count` (number, required): Количество отзывов
- ... (остальные свойства)

**Пример:**

```typescript
trackEvent('Clinic Viewed', {
	clinic_id: 'clinic-123',
	clinic_name: 'Медицинский центр "Здоровье"',
	city: 'Алматы',
	is_verified: true,
	rating: 4.5,
	reviews_count: 42,
});
```
````

### Doctor Viewed

**Когда:** При открытии страницы врача

... (аналогично для остальных событий)

```

---

## Критерии приемки

- [ ] События отслеживаются на всех страницах деталей (клиники, врачи, услуги, лекарства, статьи)
- [ ] События отслеживаются на списочных страницах
- [ ] TypeScript типы созданы для всех новых событий
- [ ] User identification работает при авторизации
- [ ] User reset работает при logout
- [ ] Счетчики просмотров инкрементируются
- [ ] Все обязательные свойства передаются
- [ ] События видны в Mixpanel Live View
- [ ] Unit тесты написаны и проходят
- [ ] Документация обновлена

---

## Testing Checklist

### Manual Testing

- [ ] Открыть страницу клиники → проверить событие в Mixpanel
- [ ] Открыть страницу врача → проверить событие
- [ ] Открыть страницу услуги → проверить событие
- [ ] Открыть список клиник с фильтрами → проверить filters_applied
- [ ] Авторизоваться → проверить user identification в Mixpanel
- [ ] Проверить счетчики в user profile (total_clinics_viewed и т.д.)

### Mixpanel Dashboard

- [ ] Создать report: топ 10 клиник по просмотрам
- [ ] Создать report: какие города самые популярные
- [ ] Создать funnel: Home → List → Detail (базовый)
- [ ] Проверить user profiles: свойства заполнены корректно

---

## Известные проблемы

_Пока нет_

---

## Следующие шаги

После завершения:
1. Переходим к **Итерации 3** - события взаимодействия (клики, копирование контактов и т.д.)
```

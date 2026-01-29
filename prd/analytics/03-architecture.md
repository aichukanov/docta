# 3. Архитектура

## Технологический стек

### Analytics Platforms

- **Mixpanel** - product analytics

  - Client SDK: `mixpanel-browser`
  - Version: latest stable
  - Integration: Nuxt plugin
  - Focus: Events, funnels, cohorts, retention

- **Google Analytics 4** - marketing analytics
  - Client SDK: `gtag.js` (via Nuxt module)
  - Module: `@nuxtjs/google-analytics` или `nuxt-gtag`
  - Integration: Nuxt plugin
  - Focus: Traffic, SEO, demographics, standard reports

### Frontend Integration

- **Nuxt 3 Plugins** - инициализация Mixpanel и GA4
- **Composables** - `useAnalytics()` для единообразного трэкинга
- **TypeScript** - типизация событий и свойств
- **Auto-imports** - композаблы доступны глобально

## Архитектурная диаграмма

```
┌─────────────────────────────────────────────────────────────────────┐
│                           User Browser                               │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │                      Nuxt 3 App                             │    │
│  │                                                             │    │
│  │  ┌───────────────────────────────────────────────────┐    │    │
│  │  │  plugins/mixpanel.client.ts                       │    │    │
│  │  │  - Initialize Mixpanel SDK                        │    │    │
│  │  │  - Check cookie consent                           │    │    │
│  │  │  - Register super properties                      │    │    │
│  │  └───────────────────────────────────────────────────┘    │    │
│  │                           │                                 │    │
│  │  ┌───────────────────────────────────────────────────┐    │    │
│  │  │  plugins/gtag.client.ts                           │    │    │
│  │  │  - Initialize Google Analytics 4                  │    │    │
│  │  │  - Check cookie consent                           │    │    │
│  │  │  - Configure GA4 settings                         │    │    │
│  │  └───────────────────────────────────────────────────┘    │    │
│  │                           │                                 │    │
│  │                           ▼                                 │    │
│  │  ┌───────────────────────────────────────────────────┐    │    │
│  │  │  composables/useAnalytics.ts                      │    │    │
│  │  │  - trackEvent() → Mixpanel + GA4                  │    │    │
│  │  │  - trackPageView() → Mixpanel + GA4               │    │    │
│  │  │  - identifyUser() → Mixpanel + GA4                │    │    │
│  │  │  - Unified API для обоих сервисов                 │    │    │
│  │  └───────────────────────────────────────────────────┘    │    │
│  │                           │                                 │    │
│  │                           ▼                                 │    │
│  │  ┌───────────────────────────────────────────────────┐    │    │
│  │  │  Components & Pages                               │    │    │
│  │  │  - pages/clinics/[id].vue                         │    │    │
│  │  │  - components/clinic/ContactInfo.vue              │    │    │
│  │  │  - components/shared/ClinicCard.vue               │    │    │
│  │  └───────────────────────────────────────────────────┘    │    │
│  └────────────────────────────────────────────────────────────┘    │
└────────────────────────┬──────────────┬──────────────────────────────┘
                         │ HTTPS        │ HTTPS
                         ▼              ▼
              ┌──────────────┐   ┌──────────────────┐
              │  Mixpanel    │   │  Google          │
              │  API         │   │  Analytics 4     │
              └──────────────┘   └──────────────────┘
                         │              │
                         ▼              ▼
              ┌──────────────┐   ┌──────────────────┐
              │  Mixpanel    │   │  GA4             │
              │  Storage     │   │  Storage         │
              │  - Events    │   │  - Events        │
              │  - Profiles  │   │  - Traffic       │
              │  - Funnels   │   │  - Demographics  │
              └──────────────┘   └──────────────────┘
```

## Структура файлов

```
nuxt-app/
├── plugins/
│   ├── mixpanel.client.ts          # Инициализация Mixpanel SDK
│   └── gtag.client.ts               # Инициализация Google Analytics 4
├── composables/
│   └── useAnalytics.ts             # Unified analytics composable
├── types/
│   └── analytics.ts                # TypeScript definitions
│       ├── EventName                # Union type всех событий
│       ├── EventProperties          # Свойства для каждого события
│       ├── UserProperties           # Свойства профиля пользователя
│       └── SuperProperties          # Глобальные свойства
├── utils/
│   └── analytics/
│       ├── events.ts                # Event name constants
│       ├── properties.ts            # Property helpers
│       ├── consent.ts               # Cookie consent logic
│       └── ga4-mapper.ts            # Map Mixpanel events to GA4 format
├── pages/
│   ├── clinics/
│   │   └── [id].vue                 # + trackPageView('Clinic Viewed')
│   ├── doctors/
│   │   └── [id].vue                 # + trackPageView('Doctor Viewed')
│   └── services/
│       └── [id].vue                 # + trackPageView('Service Viewed')
├── components/
│   ├── clinic/
│   │   ├── ContactInfo.vue          # + track contacts interactions
│   │   └── ClinicCard.vue           # + track card clicks
│   └── shared/
│       ├── SearchBar.vue            # + track search
│       └── FilterPanel.vue          # + track filters
└── docs/
    └── analytics/
        ├── events.md                # Документация всех событий
        ├── setup.md                 # Setup guide
        ├── ga4-events.md            # GA4 specific events
        └── best-practices.md        # Best practices
```

## Компоненты системы

### 1. Mixpanel Plugin (`plugins/mixpanel.client.ts`)

```typescript
// Псевдокод
export default defineNuxtPlugin(async (nuxtApp) => {
	// Проверяем cookie consent
	const { hasConsent } = useCookieConsent();
	if (!hasConsent.value) return;

	// Инициализируем Mixpanel
	const config = useRuntimeConfig();
	mixpanel.init(config.public.mixpanelToken, {
		track_pageview: false, // manual tracking
		persistence: 'localStorage',
		ignore_dnt: false,
	});

	// Регистрируем super properties
	mixpanel.register({
		platform: 'web',
		environment: config.public.environment,
		app_version: config.public.appVersion,
	});

	// Если пользователь авторизован, идентифицируем его
	const { user } = useAuth();
	if (user.value) {
		mixpanel.identify(user.value.id);
		mixpanel.people.set({
			$name: user.value.name,
			$email: user.value.email,
			role: user.value.role,
		});
	}

	// Предоставляем глобально
	return {
		provide: {
			mixpanel,
		},
	};
});
```

### 2. Google Analytics 4 Plugin (`plugins/gtag.client.ts`)

```typescript
// Псевдокод
export default defineNuxtPlugin((nuxtApp) => {
	const { hasConsent } = useCookieConsent();
	if (!hasConsent.value) return;

	const config = useRuntimeConfig();

	// Загружаем gtag.js
	const script = document.createElement('script');
	script.async = true;
	script.src = `https://www.googletagmanager.com/gtag/js?id=${config.public.ga4MeasurementId}`;
	document.head.appendChild(script);

	// Инициализируем gtag
	window.dataLayer = window.dataLayer || [];
	function gtag(...args: any[]) {
		window.dataLayer.push(args);
	}

	gtag('js', new Date());
	gtag('config', config.public.ga4MeasurementId, {
		send_page_view: false, // manual page view tracking
		anonymize_ip: true, // GDPR compliance
	});

	// Если пользователь авторизован
	const { user } = useAuth();
	if (user.value) {
		gtag('set', 'user_properties', {
			user_id: user.value.id,
			user_role: user.value.role,
		});
	}

	return {
		provide: {
			gtag,
		},
	};
});
```

### 3. Analytics Composable - Unified API (`composables/useAnalytics.ts`)

```typescript
// Псевдокод - обновленный для поддержки обоих сервисов
export const useAnalytics = () => {
	const { $mixpanel, $gtag } = useNuxtApp();
	const config = useRuntimeConfig();
	const route = useRoute();

	const isEnabled = computed(() => {
		return config.public.analyticsEnabled;
	});

	const trackEvent = (eventName: EventName, properties?: EventProperties) => {
		if (!isEnabled.value) return;

		try {
			const enrichedProps = {
				...properties,
				timestamp: new Date().toISOString(),
				page_url: window.location.href,
				page_title: document.title,
				page_path: route.path,
			};

			// Track in Mixpanel
			if ($mixpanel) {
				$mixpanel.track(eventName, enrichedProps);
			}

			// Track in GA4
			if ($gtag) {
				// Конвертируем Mixpanel event в GA4 формат
				const ga4EventName = mapToGA4EventName(eventName);
				const ga4Props = mapToGA4Properties(enrichedProps);
				$gtag('event', ga4EventName, ga4Props);
			}

			if (config.public.analyticsDebug) {
				console.log('[Analytics] Event tracked:', eventName, enrichedProps);
			}
		} catch (error) {
			console.error('[Analytics] Error tracking event:', error);
		}
	};

	const trackPageView = (
		pageName: string,
		properties?: BaseEventProperties,
	) => {
		trackEvent('Page Viewed', {
			page_name: pageName,
			...properties,
		});

		// Дополнительно отправляем page_view в GA4
		if ($gtag) {
			$gtag('event', 'page_view', {
				page_title: document.title,
				page_location: window.location.href,
				page_path: route.path,
			});
		}
	};

	const identifyUser = (userId: string, properties?: UserProperties) => {
		if (!isEnabled.value) return;

		try {
			// Mixpanel identification
			if ($mixpanel) {
				$mixpanel.identify(userId);

				if (properties) {
					$mixpanel.people.set(properties);
				}
			}

			// GA4 user identification
			if ($gtag) {
				$gtag('set', 'user_properties', {
					user_id: userId,
					...properties,
				});
			}

			if (config.public.analyticsDebug) {
				console.log('[Analytics] User identified:', userId, properties);
			}
		} catch (error) {
			console.error('[Analytics] Error identifying user:', error);
		}
	};

	// ... остальные методы (setUserProperty, incrementUserProperty, reset, optOut, optIn)

	return {
		trackEvent,
		trackPageView,
		identifyUser,
		setUserProperty,
		incrementUserProperty,
		reset,
		optOut,
		optIn,
	};
};

// Helper functions для маппинга событий
function mapToGA4EventName(mixpanelEvent: string): string {
	// Конвертируем "Clinic Viewed" → "view_clinic"
	return mixpanelEvent
		.toLowerCase()
		.replace(/\s+/g, '_')
		.replace('_viewed', '_view')
		.replace('_clicked', '_click');
}

function mapToGA4Properties(props: any): any {
	// Конвертируем snake_case свойства в GA4 формат
	const ga4Props: any = {};

	for (const [key, value] of Object.entries(props)) {
		// Пропускаем некоторые служебные поля
		if (['timestamp', 'page_url', 'page_title'].includes(key)) continue;

		ga4Props[key] = value;
	}

	return ga4Props;
}
```

### 4. Type Definitions (`types/analytics.ts`)

```typescript
// Типизация событий
export type EventName =
	// Page Views
	| 'Page Viewed'
	| 'Clinic Viewed'
	| 'Doctor Viewed'
	| 'Service Viewed'
	| 'Medicine Viewed'
	| 'Article Viewed'
	// Interactions
	| 'Phone Clicked'
	| 'Phone Copied'
	| 'Email Clicked'
	| 'Email Copied'
	| 'Address Copied'
	| 'Website Visited'
	// Navigation
	| 'Clinic Viewed from Service'
	| 'Clinic Viewed from Doctor'
	| 'Card Clicked'
	// Search
	| 'Search Performed'
	| 'Filter Applied'
	| 'Filter Cleared'
	| 'Sort Changed'
	| 'Tag Clicked'
	// Map
	| 'Map Opened'
	| 'Map Marker Clicked'
	// Social
	| 'Added to Favorites'
	| 'Removed from Favorites'
	| 'Content Shared'
	| 'Review Started'
	| 'Review Submitted';

export interface ClinicViewedProperties {
	clinic_id: string;
	clinic_name: string;
	city: string;
	is_verified: boolean;
	rating?: number;
	reviews_count?: number;
	source?: string; // where user came from
}

export interface PhoneClickedProperties {
	entity_type: 'clinic' | 'doctor';
	entity_id: string;
	entity_name: string;
	phone_type: 'main' | 'mobile' | 'reception';
	source_page: string;
}

// ... остальные interfaces для каждого события
```

### 4. Event Constants (`utils/analytics/events.ts`)

```typescript
// Константы для названий событий
export const ANALYTICS_EVENTS = {
	// Page Views
	PAGE_VIEWED: 'Page Viewed',
	CLINIC_VIEWED: 'Clinic Viewed',
	DOCTOR_VIEWED: 'Doctor Viewed',
	SERVICE_VIEWED: 'Service Viewed',

	// Interactions
	PHONE_CLICKED: 'Phone Clicked',
	PHONE_COPIED: 'Phone Copied',
	WEBSITE_VISITED: 'Website Visited',

	// ... остальные
} as const;
```

## Интеграция в компоненты

### Пример: Tracking в странице клиники

```vue
<!-- pages/clinics/[id].vue -->
<script setup lang="ts">
const route = useRoute();
const { trackPageView, trackEvent, incrementUserProperty } = useAnalytics();
const { data: clinic } = await useFetch(`/api/clinics/${route.params.id}`);

// Track page view
onMounted(() => {
	if (clinic.value) {
		trackPageView('Clinic Viewed', {
			clinic_id: clinic.value.id,
			clinic_name: clinic.value.name,
			city: clinic.value.city,
			is_verified: clinic.value.isVerified,
			rating: clinic.value.rating,
			reviews_count: clinic.value.reviewsCount,
		});

		// Increment user counter
		incrementUserProperty('total_clinics_viewed');
	}
});

// Track website visit
const handleWebsiteClick = () => {
	trackEvent('Website Visited', {
		clinic_id: clinic.value.id,
		source_page: 'clinic_page',
	});
	window.open(clinic.value.website, '_blank');
};
</script>
```

### Пример: Tracking контактов

```vue
<!-- components/clinic/ContactInfo.vue -->
<script setup lang="ts">
const { trackEvent } = useAnalytics();

const copyPhone = async (phone: string, type: string) => {
	await navigator.clipboard.writeText(phone);

	trackEvent('Phone Copied', {
		entity_type: 'clinic',
		entity_id: props.clinicId,
		entity_name: props.clinicName,
		phone_type: type,
		source_page: route.name,
	});

	// Show success notification
};

const handlePhoneClick = (type: string) => {
	trackEvent('Phone Clicked', {
		entity_type: 'clinic',
		entity_id: props.clinicId,
		entity_name: props.clinicName,
		phone_type: type,
		source_page: route.name,
	});
};
</script>

<template>
	<div class="contact-info">
		<a :href="`tel:${clinic.phone}`" @click="handlePhoneClick('main')">
			{{ clinic.phone }}
		</a>
		<button @click="copyPhone(clinic.phone, 'main')"> Копировать </button>
	</div>
</template>
```

## Cookie Consent Integration

```typescript
// composables/useCookieConsent.ts
export const useCookieConsent = () => {
	const consent = useCookie('analytics_consent');

	const hasConsent = computed(() => consent.value === 'granted');

	const grantConsent = () => {
		consent.value = 'granted';
		// Reinitialize analytics if needed
		window.location.reload();
	};

	const revokeConsent = () => {
		consent.value = 'denied';
		// Opt out from Mixpanel
		mixpanel?.opt_out_tracking();
	};

	return {
		hasConsent,
		grantConsent,
		revokeConsent,
	};
};
```

## Environment Configuration

```typescript
// nuxt.config.ts
export default defineNuxtConfig({
	runtimeConfig: {
		public: {
			mixpanelToken: process.env.MIXPANEL_TOKEN,
			ga4MeasurementId: process.env.GA4_MEASUREMENT_ID,
			environment: process.env.NODE_ENV,
			appVersion: process.env.npm_package_version,
			analyticsEnabled: process.env.ANALYTICS_ENABLED === 'true',
		},
	},
});
```

```bash
# .env
MIXPANEL_TOKEN=your_mixpanel_project_token
GA4_MEASUREMENT_ID=G-XXXXXXXXXX
ANALYTICS_ENABLED=true
NODE_ENV=production
```

## Data Flow

1. **User Action** → Пользователь взаимодействует со страницей
2. **Event Trigger** → Компонент вызывает `trackEvent()`
3. **Enrichment** → Composable добавляет общие свойства
4. **Type Check** → TypeScript проверяет корректность события
5. **Consent Check** → Проверяется согласие на cookies
6. **Send to Mixpanel** → Mixpanel SDK отправляет событие
7. **Send to GA4** → gtag отправляет событие в GA4 (с маппингом)
8. **Queue/Retry** → При ошибке событие сохраняется для повтора
9. **Storage** → Данные сохраняются в обоих сервисах
10. **Processing** → Данные доступны в Mixpanel UI и GA4 в реальном времени

## Event Mapping: Mixpanel ↔ GA4

### Naming Convention Mapping

| Mixpanel Event       | GA4 Event          | Примечание            |
| -------------------- | ------------------ | --------------------- |
| `Clinic Viewed`      | `view_clinic`      | Стандартизация        |
| `Phone Clicked`      | `click_phone`      | Стандартизация        |
| `Website Visited`    | `visit_website`    | Custom event          |
| `Search Performed`   | `search`           | GA4 recommended event |
| `Added to Favorites` | `add_to_favorites` | Custom event          |

### Property Mapping

| Mixpanel Property | GA4 Parameter   | Type   |
| ----------------- | --------------- | ------ |
| `clinic_id`       | `clinic_id`     | string |
| `clinic_name`     | `clinic_name`   | string |
| `entity_type`     | `content_type`  | string |
| `source_page`     | `page_referrer` | string |
| `query`           | `search_term`   | string |

### GA4 Recommended Events Usage

Используем стандартные GA4 события где возможно:

- **`page_view`** - вместо "Page Viewed"
- **`search`** - вместо "Search Performed"
- **`select_content`** - вместо "Card Clicked"
- **Custom events** - для специфичных действий (Phone Copied, etc)

## Naming Conventions

### Event Names

- Format: `Entity Action` (Title Case)
- Examples: `Clinic Viewed`, `Phone Clicked`, `Search Performed`
- Always use past tense for actions

### Property Names

- Format: `snake_case`
- Examples: `clinic_id`, `source_page`, `is_verified`
- Be consistent with database naming

### User Properties

- Use Mixpanel reserved properties when applicable: `$name`, `$email`, `$phone`
- Custom properties: `role`, `city`, `created_at`

## Performance Considerations

1. **Async Loading** - Mixpanel SDK загружается асинхронно
2. **Batching** - События группируются перед отправкой
3. **No Blocking** - Analytics never blocks UI interactions
4. **Lazy Init** - SDK инициализируется только при необходимости
5. **Local Queue** - События сохраняются локально при offline

## Security & Privacy

1. **No PII in Events** - Не отправляем sensitive данные в событиях
2. **Hash When Needed** - Email/phone хешируются если необходимо
3. **Consent Required** - Tracking только после согласия
4. **Opt-out Available** - Пользователь может отключить tracking
5. **GDPR Compliance** - Право на удаление данных

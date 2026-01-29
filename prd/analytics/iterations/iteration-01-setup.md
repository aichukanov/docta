# Итерация 1: Настройка Mixpanel, GA4 и базовые события

**Статус:** 🔴 Not Started  
**Приоритет:** P0 (критично)  
**Оценка:** 4-5 дней

---

## Цель

Настроить базовую инфраструктуру для двойной аналитики: установить и сконфигурировать Mixpanel SDK и Google Analytics 4, создать единый composable для отправки событий в оба сервиса, интегрировать с cookie consent.

---

## Scope

### В рамках итерации

✅ Установка и инициализация Mixpanel SDK  
✅ Установка и инициализация Google Analytics 4  
✅ Nuxt plugins для client-side инициализации обоих сервисов  
✅ Unified composable `useAnalytics()` с базовыми методами  
✅ TypeScript типы для событий и свойств  
✅ Cookie consent интеграция  
✅ Debug mode для development  
✅ Environment configuration  
✅ Event mapping между Mixpanel и GA4  
✅ Error handling и graceful degradation  
✅ Базовая документация

### Вне рамок

❌ Конкретные события (будут в следующих итерациях)  
❌ Воронки и dashboards (итерация 4)  
❌ Server-side tracking  
❌ Advanced features (cohorts, experiments)  
❌ Google Ads интеграция

---

## Задачи

### 1. Подготовка аналитических платформ

**Задача 1.1:** Создать Mixpanel project

- [ ] Зарегистрироваться на mixpanel.com (free tier)
- [ ] Создать project "Docta.me - Production"
- [ ] Создать project "Docta.me - Development" (опционально)
- [ ] Скопировать Project Token

**Задача 1.2:** Настроить Mixpanel project settings

- [ ] Включить GDPR mode в настройках
- [ ] Настроить data residency (EU или US)
- [ ] Настроить session timeout (30 минут)

**Задача 1.3:** Создать Google Analytics 4 property

- [ ] Зайти в Google Analytics (analytics.google.com)
- [ ] Создать новый property "Docta.me"
- [ ] Создать Data Stream для веб-сайта
- [ ] Скопировать Measurement ID (G-XXXXXXXXXX)

**Задача 1.4:** Настроить GA4 property settings

- [ ] Включить Google Signals (для demographics data)
- [ ] Настроить Data retention (14 months recommended)
- [ ] Включить Enhanced measurement
- [ ] Настроить IP anonymization (GDPR compliance)

### 2. Установка пакетов

**Задача 2.1:** Установить dependencies

```bash
npm install mixpanel-browser
npm install -D @types/mixpanel-browser
# GA4 устанавливается через gtag.js CDN, не нужен отдельный npm пакет
```

### 3. Environment Configuration

**Задача 3.1:** Добавить в `.env`

```bash
# .env
MIXPANEL_TOKEN=your_production_mixpanel_token_here
GA4_MEASUREMENT_ID=G-XXXXXXXXXX
ANALYTICS_ENABLED=true
```

**Задача 3.2:** Добавить в `.env.development`

```bash
# .env.development
MIXPANEL_TOKEN=your_development_mixpanel_token_here
GA4_MEASUREMENT_ID=G-YYYYYYYYYY  # можно использовать отдельный для dev
ANALYTICS_ENABLED=true
ANALYTICS_DEBUG=true
```

**Задача 3.3:** Обновить `nuxt.config.ts`

```typescript
export default defineNuxtConfig({
	runtimeConfig: {
		public: {
			mixpanelToken: process.env.MIXPANEL_TOKEN || '',
			ga4MeasurementId: process.env.GA4_MEASUREMENT_ID || '',
			analyticsEnabled: process.env.ANALYTICS_ENABLED === 'true',
			analyticsDebug: process.env.ANALYTICS_DEBUG === 'true',
			environment: process.env.NODE_ENV || 'development',
		},
	},
});
```

### 4. TypeScript Types

**Задача 4.1:** Создать `types/analytics.ts`

```typescript
// Base types
export type EventName = string; // Will expand in next iterations

export interface BaseEventProperties {
	timestamp?: string;
	page_url?: string;
	page_title?: string;
	page_path?: string;
	[key: string]: any;
}

export interface UserProperties {
	$name?: string;
	$email?: string;
	role?: 'patient' | 'clinic_owner' | 'doctor';
	city?: string;
	created_at?: string;
	[key: string]: any;
}

export interface SuperProperties {
	platform: 'web' | 'mobile_web';
	environment: 'production' | 'staging' | 'development';
	app_version?: string;
	[key: string]: any;
}

// Analytics interface
export interface Analytics {
	trackEvent: (eventName: EventName, properties?: BaseEventProperties) => void;
	trackPageView: (pageName: string, properties?: BaseEventProperties) => void;
	identifyUser: (userId: string, properties?: UserProperties) => void;
	setUserProperty: (key: string, value: any) => void;
	incrementUserProperty: (key: string, by?: number) => void;
	reset: () => void;
	optOut: () => void;
	optIn: () => void;
}

// GA4 types
export interface GA4Config {
	send_page_view?: boolean;
	anonymize_ip?: boolean;
	cookie_flags?: string;
}
```

### 5. Mixpanel Plugin

**Задача 5.1:** Создать `plugins/mixpanel.client.ts`

```typescript
import mixpanel from 'mixpanel-browser';

export default defineNuxtPlugin(async (nuxtApp) => {
	const config = useRuntimeConfig();

	// Проверяем, включена ли аналитика
	if (!config.public.analyticsEnabled || !config.public.mixpanelToken) {
		console.warn(
			'[Analytics/Mixpanel] Analytics is disabled or token is missing',
		);
		return {
			provide: {
				mixpanel: null,
			},
		};
	}

	// Проверяем cookie consent
	const { hasConsent } = useCookieConsent();
	if (!hasConsent.value) {
		console.log('[Analytics/Mixpanel] Waiting for cookie consent');
		return {
			provide: {
				mixpanel: null,
			},
		};
	}

	try {
		// Инициализация Mixpanel
		mixpanel.init(config.public.mixpanelToken, {
			debug: config.public.analyticsDebug,
			track_pageview: false, // Manual tracking
			persistence: 'localStorage',
			ignore_dnt: false,
			api_host: 'https://api-eu.mixpanel.com', // EU endpoint for GDPR
			loaded: (mixpanel) => {
				console.log('[Analytics/Mixpanel] Loaded successfully');
			},
		});

		// Регистрируем super properties
		mixpanel.register({
			platform: 'web',
			environment: config.public.environment,
			app_version: '1.0.0', // TODO: Get from package.json
		});

		// Автоматическая идентификация если пользователь авторизован
		const { user } = useAuth();
		if (user?.value) {
			mixpanel.identify(user.value.id);
			mixpanel.people.set({
				$name: user.value.name,
				$email: user.value.email,
			});
		}
	} catch (error) {
		console.error('[Analytics/Mixpanel] Failed to initialize:', error);
	}

	return {
		provide: {
			mixpanel,
		},
	};
});
```

### 6. Google Analytics 4 Plugin

**Задача 6.1:** Создать `plugins/gtag.client.ts`

```typescript
export default defineNuxtPlugin((nuxtApp) => {
	const config = useRuntimeConfig();

	if (!config.public.analyticsEnabled || !config.public.ga4MeasurementId) {
		console.warn(
			'[Analytics/GA4] Analytics is disabled or measurement ID is missing',
		);
		return {
			provide: {
				gtag: null,
			},
		};
	}

	// Проверяем cookie consent
	const { hasConsent } = useCookieConsent();
	if (!hasConsent.value) {
		console.log('[Analytics/GA4] Waiting for cookie consent');
		return {
			provide: {
				gtag: null,
			},
		};
	}

	try {
		// Загружаем gtag.js
		const script = document.createElement('script');
		script.async = true;
		script.src = `https://www.googletagmanager.com/gtag/js?id=${config.public.ga4MeasurementId}`;
		document.head.appendChild(script);

		// Инициализируем dataLayer и gtag function
		window.dataLayer = window.dataLayer || [];
		function gtag(...args: any[]) {
			window.dataLayer.push(args);
		}

		gtag('js', new Date());
		gtag('config', config.public.ga4MeasurementId, {
			send_page_view: false, // Manual page view tracking
			anonymize_ip: true, // GDPR compliance
			cookie_flags: 'SameSite=None;Secure',
		});

		// Если пользователь авторизован, устанавливаем user_id
		const { user } = useAuth();
		if (user?.value) {
			gtag('set', 'user_properties', {
				user_id: user.value.id,
				user_role: user.value.role,
			});
		}

		console.log('[Analytics/GA4] Loaded successfully');

		return {
			provide: {
				gtag,
			},
		};
	} catch (error) {
		console.error('[Analytics/GA4] Failed to initialize:', error);
		return {
			provide: {
				gtag: null,
			},
		};
	}
});

// Type declaration for window.dataLayer
declare global {
	interface Window {
		dataLayer: any[];
	}
}
```

### 7. Unified Analytics Composable

**Задача 7.1:** Создать `composables/useAnalytics.ts`

```typescript
import type {
	Analytics,
	EventName,
	BaseEventProperties,
	UserProperties,
} from '~/types/analytics';

export const useAnalytics = (): Analytics => {
	const { $mixpanel, $gtag } = useNuxtApp();
	const config = useRuntimeConfig();
	const route = useRoute();

	const isEnabled = computed(() => {
		return config.public.analyticsEnabled;
	});

	const trackEvent = (
		eventName: EventName,
		properties?: BaseEventProperties,
	) => {
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

	const setUserProperty = (key: string, value: any) => {
		if (!isEnabled.value) return;

		try {
			if ($mixpanel) {
				$mixpanel.people.set({ [key]: value });
			}

			if ($gtag) {
				$gtag('set', 'user_properties', { [key]: value });
			}
		} catch (error) {
			console.error('[Analytics] Error setting user property:', error);
		}
	};

	const incrementUserProperty = (key: string, by: number = 1) => {
		if (!isEnabled.value) return;

		try {
			if ($mixpanel) {
				$mixpanel.people.increment(key, by);
			}
			// GA4 doesn't support increments directly
		} catch (error) {
			console.error('[Analytics] Error incrementing property:', error);
		}
	};

	const reset = () => {
		if (!isEnabled.value) return;

		try {
			if ($mixpanel) {
				$mixpanel.reset();
			}
			// GA4 doesn't have a reset method, we'd need to clear cookies manually if needed
			if (config.public.analyticsDebug) {
				console.log('[Analytics] User session reset');
			}
		} catch (error) {
			console.error('[Analytics] Error resetting:', error);
		}
	};

	const optOut = () => {
		if (!isEnabled.value) return;

		try {
			if ($mixpanel) {
				$mixpanel.opt_out_tracking();
			}
			if ($gtag) {
				// GA4 opt-out через window property
				window[`ga-disable-${config.public.ga4MeasurementId}`] = true;
			}
			if (config.public.analyticsDebug) {
				console.log('[Analytics] User opted out');
			}
		} catch (error) {
			console.error('[Analytics] Error opting out:', error);
		}
	};

	const optIn = () => {
		if (!isEnabled.value) return;

		try {
			if ($mixpanel) {
				$mixpanel.opt_in_tracking();
			}
			if ($gtag) {
				window[`ga-disable-${config.public.ga4MeasurementId}`] = false;
			}
			if (config.public.analyticsDebug) {
				console.log('[Analytics] User opted in');
			}
		} catch (error) {
			console.error('[Analytics] Error opting in:', error);
		}
	};

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

// Helper: Convert Mixpanel event name to GA4 format
function mapToGA4EventName(mixpanelEvent: string): string {
	// Recommended GA4 events
	const ga4RecommendedEvents: Record<string, string> = {
		'Search Performed': 'search',
		'Card Clicked': 'select_content',
		'Page Viewed': 'page_view',
	};

	if (ga4RecommendedEvents[mixpanelEvent]) {
		return ga4RecommendedEvents[mixpanelEvent];
	}

	// Custom events: "Clinic Viewed" → "view_clinic"
	return mixpanelEvent
		.toLowerCase()
		.replace(/\s+/g, '_')
		.replace('_viewed', '')
		.replace('_clicked', '');
}

// Helper: Map properties to GA4 format
function mapToGA4Properties(props: any): Record<string, any> {
	const ga4Props: Record<string, any> = {};

	for (const [key, value] of Object.entries(props)) {
		// Skip internal properties
		if (['timestamp', 'page_url', 'page_title', 'page_path'].includes(key)) {
			continue;
		}

		// GA4 has 25-character limit for parameter names
		const ga4Key = key.length > 25 ? key.substring(0, 25) : key;
		ga4Props[ga4Key] = value;
	}

	return ga4Props;
}
```

### 8. Cookie Consent (базовая версия)

**Задача 8.1:** Создать `composables/useCookieConsent.ts`

```typescript
export const useCookieConsent = () => {
	const consent = useCookie('analytics_consent', {
		maxAge: 60 * 60 * 24 * 365, // 1 year
	});

	const hasConsent = computed(() => consent.value === 'granted');

	const grantConsent = () => {
		consent.value = 'granted';

		// Reload page to initialize analytics
		if (process.client) {
			window.location.reload();
		}
	};

	const revokeConsent = () => {
		consent.value = 'denied';

		// Opt out from tracking
		const { optOut } = useAnalytics();
		optOut();
	};

	return {
		hasConsent,
		grantConsent,
		revokeConsent,
	};
};
```

**Задача 8.2:** Создать `components/analytics/CookieConsentBanner.vue`

```vue
<template>
	<div v-if="!hasConsent && !isDismissed" class="cookie-consent-banner">
		<div class="cookie-consent-content">
			<p>
				Мы используем cookies и аналитику (Mixpanel, Google Analytics) для
				улучшения вашего опыта.
				<NuxtLink to="/privacy">Подробнее</NuxtLink>
			</p>
			<div class="cookie-consent-actions">
				<button @click="handleAccept" class="btn-accept">Принять</button>
				<button @click="handleDecline" class="btn-decline">Отклонить</button>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
const { hasConsent, grantConsent, revokeConsent } = useCookieConsent();
const isDismissed = ref(false);

const handleAccept = () => {
	grantConsent();
	isDismissed.value = true;
};

const handleDecline = () => {
	revokeConsent();
	isDismissed.value = true;
};
</script>

<style scoped>
.cookie-consent-banner {
	position: fixed;
	bottom: 0;
	left: 0;
	right: 0;
	background: var(--color-background-elevated);
	border-top: 1px solid var(--color-border);
	padding: var(--spacing-4);
	z-index: 1000;
	box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

.cookie-consent-content {
	max-width: 1200px;
	margin: 0 auto;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-4);
}

.cookie-consent-actions {
	display: flex;
	gap: var(--spacing-2);
}

.btn-accept,
.btn-decline {
	padding: var(--spacing-2) var(--spacing-4);
	border-radius: var(--radius-md);
	border: none;
	cursor: pointer;
	font-weight: 500;
}

.btn-accept {
	background: var(--color-primary);
	color: white;
}

.btn-decline {
	background: var(--color-background);
	border: 1px solid var(--color-border);
}

@media (max-width: 768px) {
	.cookie-consent-content {
		flex-direction: column;
		text-align: center;
	}
}
</style>
```

### 9. Тестирование

**Задача 9.1:** Создать базовый тест для composable

```typescript
// tests/composables/useAnalytics.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { useAnalytics } from '~/composables/useAnalytics';

describe('useAnalytics', () => {
	beforeEach(() => {
		// Mock Nuxt app
		vi.mock('#app', () => ({
			useNuxtApp: () => ({
				$mixpanel: {
					track: vi.fn(),
					identify: vi.fn(),
					people: {
						set: vi.fn(),
						increment: vi.fn(),
					},
				},
				$gtag: vi.fn(),
			}),
			useRuntimeConfig: () => ({
				public: {
					analyticsEnabled: true,
					analyticsDebug: false,
					ga4MeasurementId: 'G-TEST',
				},
			}),
			useRoute: () => ({
				path: '/test',
				name: 'test',
			}),
		}));
	});

	it('should track event with properties', () => {
		const { trackEvent } = useAnalytics();
		trackEvent('Test Event', { foo: 'bar' });
		// Assert mocks were called
	});

	it('should send events to both Mixpanel and GA4', () => {
		const { trackEvent } = useAnalytics();
		const { $mixpanel, $gtag } = useNuxtApp();

		trackEvent('Test Event', { test: true });

		expect($mixpanel.track).toHaveBeenCalled();
		expect($gtag).toHaveBeenCalled();
	});

	// More tests...
});
```

### 10. Документация

**Задача 10.1:** Создать `docs/analytics/setup.md`

````markdown
# Analytics Setup Guide (Mixpanel + Google Analytics 4)

## Installation

1. Install dependencies:
   ```bash
   npm install mixpanel-browser
   ```
````

2. Configure environment variables:

   ```bash
   MIXPANEL_TOKEN=your_token_here
   GA4_MEASUREMENT_ID=G-XXXXXXXXXX
   ANALYTICS_ENABLED=true
   ```

3. Plugins и composables уже настроены автоматически

## Usage

### Track event (отправляется в оба сервиса)

```typescript
const { trackEvent } = useAnalytics();
trackEvent('Button Clicked', { button_name: 'Submit' });
```

### Track page view

```typescript
const { trackPageView } = useAnalytics();
trackPageView('Home Page');
```

### Identify user

```typescript
const { identifyUser } = useAnalytics();
identifyUser('user-123', { $name: 'John Doe' });
```

## Testing

Debug mode:

```bash
ANALYTICS_DEBUG=true npm run dev
```

Check console for analytics events from both Mixpanel and GA4.

## Verification

### Mixpanel

- Go to Mixpanel dashboard → Live View
- Perform actions on your site
- Events should appear in real-time

### Google Analytics 4

- Go to GA4 dashboard → Reports → Realtime
- Perform actions on your site
- Events should appear within 1-2 minutes

## More docs

- [Events Documentation](./events.md)
- [GA4 Events Mapping](./ga4-events.md)
- [Best Practices](./best-practices.md)

````

**Задача 10.2:** Создать `docs/analytics/ga4-events.md`

```markdown
# Google Analytics 4 Events Mapping

## Event Name Conversion

Mixpanel использует Title Case ("Clinic Viewed"), GA4 использует snake_case ("view_clinic").

### Автоматический маппинг

| Mixpanel Event | GA4 Event | Type |
|----------------|-----------|------|
| Search Performed | search | Recommended |
| Card Clicked | select_content | Recommended |
| Clinic Viewed | view_clinic | Custom |
| Doctor Viewed | view_doctor | Custom |
| Phone Clicked | click_phone | Custom |

### GA4 Recommended Events

Где возможно, используем рекомендованные GA4 события:
- `search` - поисковые запросы
- `select_content` - клики на элементы
- `page_view` - просмотры страниц

### Custom Events

Для специфичных действий используем custom events с префиксами:
- `view_*` - просмотры (view_clinic, view_doctor)
- `click_*` - клики (click_phone, click_email)
- `copy_*` - копирование (copy_phone, copy_address)

## Property Mapping

GA4 имеет ограничения:
- Максимум 25 символов для имени параметра
- Максимум 100 символов для значения

Автоматически обрезаем длинные имена параметров.
````

---

## Критерии приемки

- [ ] Mixpanel SDK установлен и инициализирован
- [ ] GA4 установлен и инициализирован через gtag.js
- [ ] Plugins загружаются только на client-side
- [ ] Composable `useAnalytics()` работает корректно
- [ ] События отправляются в оба сервиса одновременно
- [ ] TypeScript типы созданы и работают
- [ ] Environment variables настроены
- [ ] Cookie consent banner отображается
- [ ] Debug mode работает в development
- [ ] Errors не ломают приложение (graceful degradation)
- [ ] Нет ошибок в консоли
- [ ] События видны в Mixpanel Live View
- [ ] События видны в GA4 Realtime
- [ ] Базовая документация создана

---

## Testing Checklist

### Manual Testing

- [ ] SDK загружаются без ошибок
- [ ] Cookie consent banner появляется для новых пользователей
- [ ] После согласия, события отправляются в оба сервиса
- [ ] Debug logs видны в development mode
- [ ] При отключенном consent, события не отправляются
- [ ] Можно вызвать `trackEvent()` из любого компонента

### Проверка в Mixpanel Dashboard

- [ ] События появляются в Mixpanel Live View
- [ ] Super properties присутствуют
- [ ] User identification работает

### Проверка в GA4 Dashboard

- [ ] События появляются в GA4 Realtime
- [ ] Event names корректно сконвертированы (snake_case)
- [ ] User properties устанавливаются

---

## Известные проблемы

_Пока нет_

---

## Следующие шаги

После завершения этой итерации:

1. Переходим к **Итерации 2** - события просмотра страниц
2. Начинаем добавлять конкретные события в компоненты

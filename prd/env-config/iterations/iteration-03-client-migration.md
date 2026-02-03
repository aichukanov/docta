# Итерация 3: Миграция client-side кода

[← Назад к итерациям](README.md) | [← Предыдущая: Итерация 2](iteration-02-server-migration.md)

---

## Информация об итерации

**Статус:** 🔴 Not Started  
**Приоритет:** P0 (критично)  
**Оценка времени:** 2-3 часа

---

## Цель

Мигрировать клиентскую часть приложения с `useRuntimeConfig()` на прямое использование `process.env` с префиксом `NUXT_PUBLIC_` для публичных переменных.

**Файлы для миграции:**

- `composables/use-analytics.ts` - Mixpanel, Cloudflare
- `components/TelegramLoginButton.vue` - Telegram OAuth (если используется)

**Результат:**

- ✅ Клиентская часть использует только `process.env`
- ✅ Публичные переменные имеют префикс `NUXT_PUBLIC_`
- ✅ Аналитика работает (Mixpanel, Cloudflare)
- ✅ OAuth работает

---

## Предварительные условия

- ✅ Завершена [Итерация 2: Миграция server-side кода](iteration-02-server-migration.md)
- ✅ Server-side код мигрирован
- ✅ Валидация env работает

---

## Зависимости

**От чего зависит:**

- Итерация 2 (server-side должен быть мигрирован)

**Что зависит от этой итерации:**

- Итерация 4 (финальная очистка)

---

## ⚠️ Важно: Публичные переменные

В Nuxt 3 переменные окружения **не доступны в браузере** по умолчанию.

Чтобы переменная была доступна в клиентском коде, нужно использовать префикс `NUXT_PUBLIC_`:

```bash
# ❌ НЕ доступна в браузере
MIXPANEL_TOKEN=abc123

# ✅ Доступна в браузере
NUXT_PUBLIC_MIXPANEL_TOKEN=abc123
```

---

## Задачи

### Задача 3.1: Переименовать публичные env переменные

**Цель:** Добавить префикс `NUXT_PUBLIC_` к переменным, используемым в клиенте

**Шаги:**

1. Открыть `.env` файл

2. Переименовать следующие переменные:

```bash
# До
MIXPANEL_TOKEN=your_token_here
CLOUDFLARE_TOKEN=your_token_here
TELEGRAM_BOT_USERNAME=your_bot_username

# После
NUXT_PUBLIC_MIXPANEL_TOKEN=your_token_here
NUXT_PUBLIC_CLOUDFLARE_TOKEN=your_token_here
NUXT_PUBLIC_TELEGRAM_BOT_USERNAME=your_bot_username
```

3. Обновить `.env.example`:

```bash
# Analytics
NUXT_PUBLIC_MIXPANEL_TOKEN=your_mixpanel_token
NUXT_PUBLIC_CLOUDFLARE_TOKEN=your_cloudflare_token
NUXT_PUBLIC_GTAG_ID=your_gtag_id

# OAuth
NUXT_PUBLIC_TELEGRAM_BOT_USERNAME=your_bot_username
NUXT_PUBLIC_FACEBOOK_APP_ID=your_app_id

# Application
NUXT_PUBLIC_BASE_URL=https://docta.me
```

4. Обновить `types/env.d.ts`:

```typescript
declare global {
	namespace NodeJS {
		interface ProcessEnv {
			// ... другие переменные ...

			// Analytics (публичные)
			NUXT_PUBLIC_MIXPANEL_TOKEN?: string;
			NUXT_PUBLIC_CLOUDFLARE_TOKEN?: string;
			NUXT_PUBLIC_GTAG_ID?: string;

			// OAuth (публичные)
			NUXT_PUBLIC_TELEGRAM_BOT_USERNAME?: string;
			NUXT_PUBLIC_FACEBOOK_APP_ID?: string;

			// Application (публичные)
			NUXT_PUBLIC_BASE_URL?: string;
		}
	}
}

export {};
```

**AC-3.1:**

- ✅ Все клиентские переменные в `.env` имеют префикс `NUXT_PUBLIC_`
- ✅ `.env.example` обновлен с новыми именами
- ✅ `types/env.d.ts` обновлен с новыми именами
- ✅ Приложение запускается без ошибок

---

### Задача 3.2: Мигрировать composables/use-analytics.ts

**Цель:** Заменить `useRuntimeConfig()` на `process.env` в composable аналитики

**Текущий код:**

```typescript
export function useAnalytics() {
	const config = useRuntimeConfig(); // ❌ Убрать
	const { gtag } = useGtag();
	const { isConsentGiven } = useCookieControl();

	const initMixpanel = () => {
		if (config.public.mixpanelToken && isConsentGiven.value) {
			// ❌ Убрать
			mixpanel.init(config.public.mixpanelToken, {
				// ❌ Убрать
				debug: process.env.NODE_ENV !== 'production',
				track_pageview: true,
				persistence: 'localStorage',
				ignore_dnt: true,
			});
		}
	};

	const initCloudflare = () => {
		// ...
		const token = config.public.cloudflareToken; // ❌ Убрать
		// ...
	};

	// ...
}
```

**Новый код:**

```typescript
export function useAnalytics() {
	// ✅ Прямой доступ к process.env
	const mixpanelToken = process.env.NUXT_PUBLIC_MIXPANEL_TOKEN;
	const cloudflareToken = process.env.NUXT_PUBLIC_CLOUDFLARE_TOKEN;

	const { gtag } = useGtag();
	const { isConsentGiven } = useCookieControl();

	const initMixpanel = () => {
		if (mixpanelToken && isConsentGiven.value) {
			mixpanel.init(mixpanelToken, {
				debug: process.env.NODE_ENV !== 'production',
				track_pageview: true,
				persistence: 'localStorage',
				ignore_dnt: true,
			});
		}
	};

	const initCloudflare = () => {
		if (typeof window === 'undefined' || !isConsentGiven.value) {
			return;
		}

		const domain = window.location.hostname;

		if (domain === 'localhost') {
			console.log('Cloudflare is not initialized on localhost');
			return;
		}

		const token = cloudflareToken;

		if (!token) {
			console.error('Token for cloudflare is not defined. Domain:', domain);
			return;
		}

		const script = document.createElement('script');
		script.async = true;
		script.src = 'https://static.cloudflareinsights.com/beacon.min.js';
		script.dataset.cfBeacon = JSON.stringify({
			token: token,
		});

		document.body.appendChild(script);
	};

	const initGTag = () => {
		gtag('consent', 'update', {
			ad_user_data: 'granted',
			ad_personalization: 'granted',
			ad_storage: 'granted',
			analytics_storage: 'granted',
		});
	};

	const trackEvent = (eventName: string, properties?: Record<string, any>) => {
		if (isConsentGiven.value) {
			mixpanel.track(eventName, properties);
		}
	};

	const identifyUser = (userId: string) => {
		if (isConsentGiven.value) {
			mixpanel.identify(userId);
		}
	};

	return {
		initMixpanel,
		initCloudflare,
		initGTag,
		trackEvent,
		identifyUser,
	};
}
```

**Шаги:**

1. Открыть `composables/use-analytics.ts`
2. Удалить строку `const config = useRuntimeConfig();`
3. Добавить в начало функции:
   ```typescript
   const mixpanelToken = process.env.NUXT_PUBLIC_MIXPANEL_TOKEN;
   const cloudflareToken = process.env.NUXT_PUBLIC_CLOUDFLARE_TOKEN;
   ```
4. Заменить все `config.public.mixpanelToken` на `mixpanelToken`
5. Заменить все `config.public.cloudflareToken` на `cloudflareToken`
6. Сохранить файл
7. Проверить отсутствие TypeScript ошибок

**AC-3.2:**

- ✅ Файл `composables/use-analytics.ts` не использует `useRuntimeConfig()`
- ✅ Используется `process.env.NUXT_PUBLIC_MIXPANEL_TOKEN`
- ✅ Используется `process.env.NUXT_PUBLIC_CLOUDFLARE_TOKEN`
- ✅ Нет TypeScript ошибок
- ✅ Приложение запускается

---

### Задача 3.3: Мигрировать components/TelegramLoginButton.vue (если нужно)

**Цель:** Заменить `useRuntimeConfig()` на `process.env` в компоненте Telegram

**Шаги:**

1. Проверить, использует ли компонент `useRuntimeConfig`:

```bash
grep "useRuntimeConfig" components/TelegramLoginButton.vue
```

2. Если используется - мигрировать:

**Было:**

```vue
<script setup lang="ts">
const config = useRuntimeConfig(); // ❌ Убрать
const botUsername = config.public.telegramBotUsername; // ❌ Убрать
</script>
```

**Стало:**

```vue
<script setup lang="ts">
const botUsername = process.env.NUXT_PUBLIC_TELEGRAM_BOT_USERNAME; // ✅
</script>
```

3. Если не используется - пропустить задачу

**AC-3.3:**

- ✅ Компонент проверен
- ✅ Если использовался `useRuntimeConfig` - мигрирован
- ✅ Или подтверждено, что компонент не использует `useRuntimeConfig`

---

### Задача 3.4: Проверить другие клиентские файлы

**Цель:** Убедиться, что больше нет использований `useRuntimeConfig` в клиенте

**Шаги:**

1. Выполнить поиск в composables/ и components/:

```bash
grep -r "useRuntimeConfig" composables/ components/ --include="*.ts" --include="*.vue"
```

2. Если найдены использования - мигрировать аналогично предыдущим задачам

**AC-3.4:**

- ✅ Проверены все файлы в `composables/` и `components/`
- ✅ Все использования `useRuntimeConfig` мигрированы
- ✅ Или подтверждено, что других использований нет

---

### Задача 3.5: Тестирование client-side функциональности

**Цель:** Убедиться, что все клиентские функции работают после миграции

**Шаги:**

1. **Mixpanel:**

   - Открыть приложение в браузере
   - Открыть DevTools Console
   - Проверить, что Mixpanel инициализируется без ошибок
   - Проверить, что события отправляются (если настроено)

2. **Cloudflare:**

   - Проверить в Network вкладке DevTools
   - Должен быть запрос к `cloudflareinsights.com/beacon.min.js`
   - Или проверить, что скрипт добавлен в `<body>`

3. **Telegram OAuth:**

   - Открыть страницу с Telegram login кнопкой
   - Проверить, что кнопка отображается
   - Проверить, что клик работает (открывается Telegram)

4. **Console errors:**

   - Проверить DevTools Console
   - Не должно быть ошибок типа `undefined variable`

**AC-3.5:**

- ✅ Mixpanel инициализируется (проверить в Console)
- ✅ Cloudflare скрипт загружается (проверить в Network)
- ✅ Telegram кнопка работает (если есть)
- ✅ Нет ошибок в DevTools Console
- ✅ Приложение работает корректно

---

## Acceptance Criteria (общие для итерации)

- ✅ **AC-3.1:** Публичные переменные переименованы с префиксом `NUXT_PUBLIC_`
- ✅ **AC-3.2:** `composables/use-analytics.ts` мигрирован
- ✅ **AC-3.3:** `components/TelegramLoginButton.vue` проверен/мигрирован
- ✅ **AC-3.4:** Все client-side файлы проверены
- ✅ **AC-3.5:** Все client-side функции протестированы и работают
- ✅ Нет использований `useRuntimeConfig` в `composables/` и `components/`
- ✅ TypeScript компилируется без ошибок
- ✅ Приложение работает в браузере

---

## Проверка итерации

### Checklist

**Код:**

- [ ] `.env` обновлен с `NUXT_PUBLIC_` префиксами
- [ ] `.env.example` обновлен
- [ ] `types/env.d.ts` обновлен
- [ ] `composables/use-analytics.ts` мигрирован
- [ ] Компоненты проверены/мигрированы
- [ ] Поиск `useRuntimeConfig` в клиенте возвращает 0 результатов
- [ ] TypeScript компилируется: `npm run build`

**Функциональность:**

- [ ] Приложение запускается: `npm run dev`
- [ ] Приложение открывается в браузере
- [ ] Mixpanel инициализируется (Console)
- [ ] Cloudflare скрипт загружается (Network)
- [ ] Telegram OAuth работает (если есть)
- [ ] Нет ошибок в DevTools Console

**Проверка команды:**

```bash
# Должен вернуть 0 результатов
grep -r "useRuntimeConfig" composables/ components/ --include="*.ts" --include="*.vue"

# Должен найти новые использования NUXT_PUBLIC_
grep -r "NUXT_PUBLIC_" composables/ --include="*.ts"
```

---

## Troubleshooting

### Проблема: Mixpanel не инициализируется

**Возможные причины:**

1. Переменная не установлена в .env
2. Отсутствует префикс `NUXT_PUBLIC_`
3. Переменная undefined в браузере

**Решение:**

```typescript
// Добавить временный debug
const mixpanelToken = process.env.NUXT_PUBLIC_MIXPANEL_TOKEN;
console.log('Mixpanel token:', mixpanelToken);
```

### Проблема: process.env.VARIABLE возвращает undefined в браузере

**Причина:** Отсутствует префикс `NUXT_PUBLIC_`

**Решение:**

1. Добавить префикс в `.env`:
   ```bash
   NUXT_PUBLIC_MIXPANEL_TOKEN=abc123
   ```
2. Использовать полное имя в коде:
   ```typescript
   process.env.NUXT_PUBLIC_MIXPANEL_TOKEN;
   ```

### Проблема: TypeScript ошибка "Property does not exist"

**Решение:**

1. Проверить, что переменная добавлена в `types/env.d.ts`
2. Перезапустить TypeScript сервер в IDE

---

## Откат изменений

Если что-то пошло не так:

```bash
# Откатить изменения в use-analytics.ts
git checkout HEAD -- composables/use-analytics.ts

# Откатить .env (вернуть старые имена переменных)
git checkout HEAD -- .env

# Перезапустить приложение
npm run dev
```

---

## Следующие шаги

После завершения этой итерации:

1. Проверить все Acceptance Criteria
2. Создать commit: `feat: migrate client-side code to process.env with NUXT_PUBLIC_ prefix`
3. Перейти к [Итерации 4: Очистка и документация](iteration-04-cleanup.md)

---

[← Назад к итерациям](README.md) | [← Предыдущая: Итерация 2](iteration-02-server-migration.md) | [Далее: Итерация 4 →](iteration-04-cleanup.md)

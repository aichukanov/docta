# 3. Архитектура

[← Назад к оглавлению](index.md) | [← Предыдущая: Требования](02-requirements.md)

---

## Общий подход

Миграция с `runtimeConfig` на `process.env` выполняется в 4 итерации:

1. **Аудит и подготовка** - типизация, валидация, план
2. **Миграция server-side** - server utils, API routes
3. **Миграция client-side** - composables, components
4. **Очистка** - удаление runtimeConfig, документация

---

## Структура файлов

### Новые файлы

```
types/
└── env.d.ts                    # TypeScript типы для process.env

server/
└── utils/
    └── validate-env.ts         # Валидация обязательных переменных

docs/
└── ENV_MIGRATION.md            # Migration guide для команды
```

### Изменяемые файлы

```
nuxt.config.ts                  # Удалить runtimeConfig секцию

server/
├── common/
│   └── db-mysql.ts            # useRuntimeConfig → process.env
└── utils/
    └── email.ts               # useRuntimeConfig → process.env (если используется)

composables/
└── use-analytics.ts           # useRuntimeConfig → process.env

components/
└── TelegramLoginButton.vue    # useRuntimeConfig → process.env (если используется)
```

---

## Типизация переменных окружения

### types/env.d.ts

Создаем глобальные типы для всех переменных окружения:

```typescript
declare global {
	namespace NodeJS {
		interface ProcessEnv {
			// Node environment
			NODE_ENV: 'development' | 'production' | 'test';

			// Database (обязательные)
			DB_HOST: string;
			DB_USER: string;
			DB_PASSWORD: string;

			// Analytics (опциональные)
			MIXPANEL_TOKEN?: string;
			CLOUDFLARE_TOKEN?: string;
			GTAG_ID?: string;

			// OAuth (опциональные)
			GOOGLE_CLIENT_ID?: string;
			GOOGLE_CLIENT_SECRET?: string;
			TELEGRAM_BOT_TOKEN?: string;
			TELEGRAM_BOT_USERNAME?: string;
			FACEBOOK_APP_ID?: string;
			FACEBOOK_APP_SECRET?: string;

			// Email (обязательные)
			SMTP_HOST: string;
			SMTP_PORT: string;
			SMTP_USER: string;
			SMTP_PASSWORD: string;
			SMTP_FROM: string;

			// Application
			BASE_URL?: string;
			PORT?: string;
		}
	}
}

export {};
```

**Преимущества:**

- ✅ TypeScript автокомплит для `process.env.*`
- ✅ Проверка типов на этапе компиляции
- ✅ Документация доступных переменных в коде
- ✅ Различие обязательных и опциональных переменных

---

## Валидация переменных окружения

### server/utils/validate-env.ts

```typescript
/**
 * Валидация обязательных переменных окружения
 * Вызывается при старте приложения
 */
export function validateEnv() {
	const required = [
		'DB_HOST',
		'DB_USER',
		'DB_PASSWORD',
		'SMTP_HOST',
		'SMTP_PORT',
		'SMTP_USER',
		'SMTP_PASSWORD',
		'SMTP_FROM',
	];

	const missing: string[] = [];
	const empty: string[] = [];

	for (const key of required) {
		if (!(key in process.env)) {
			missing.push(key);
		} else if (!process.env[key]) {
			empty.push(key);
		}
	}

	if (missing.length > 0 || empty.length > 0) {
		const errors: string[] = [];

		if (missing.length > 0) {
			errors.push(`Missing variables: ${missing.join(', ')}`);
		}

		if (empty.length > 0) {
			errors.push(`Empty variables: ${empty.join(', ')}`);
		}

		throw new Error(
			`Environment validation failed:\n${errors.join('\n')}\n\n` +
				`Please check your .env file.`,
		);
	}

	console.log('✅ Environment variables validated successfully');
}
```

### Вызов валидации

В `server/plugins/init.ts` (если есть) или в начале main entry point:

```typescript
// server/plugins/init.ts
import { validateEnv } from '~/server/utils/validate-env';

export default defineNitroPlugin((nitroApp) => {
	// Валидируем env при старте сервера
	validateEnv();
});
```

---

## Примеры миграции

### До миграции

#### server/common/db-mysql.ts

```typescript
import mysql from 'mysql2/promise';

let pool: mysql.Pool | null = null;

export async function getConnection() {
	try {
		const config = useRuntimeConfig(); // ❌ useRuntimeConfig
		const { host, user, password } = config.public.connection; // ❌ nested object

		if (!pool) {
			pool = mysql.createPool({
				host,
				user,
				password,
				database: 'docta_me',
				port: 3306,
				waitForConnections: true,
				connectionLimit: 10,
				queueLimit: 0,
				charset: 'utf8mb4',
				timezone: '+00:00',
			});
		}

		return await pool.getConnection();
	} catch (error) {
		console.error('Database connection error:', error);
		throw error;
	}
}
```

#### composables/use-analytics.ts

```typescript
export function useAnalytics() {
	const config = useRuntimeConfig(); // ❌ useRuntimeConfig

	const initMixpanel = () => {
		if (config.public.mixpanelToken && isConsentGiven.value) {
			// ❌ nested access
			mixpanel.init(config.public.mixpanelToken, {
				debug: process.env.NODE_ENV !== 'production',
				track_pageview: true,
				persistence: 'localStorage',
				ignore_dnt: true,
			});
		}
	};

	const initCloudflare = () => {
		const token = config.public.cloudflareToken; // ❌ nested access
		// ...
	};

	// ...
}
```

---

### После миграции

#### server/common/db-mysql.ts

```typescript
import mysql from 'mysql2/promise';

let pool: mysql.Pool | null = null;

export async function getConnection() {
	try {
		// ✅ Прямой доступ к process.env
		const host = process.env.DB_HOST;
		const user = process.env.DB_USER;
		const password = process.env.DB_PASSWORD;

		if (!pool) {
			pool = mysql.createPool({
				host,
				user,
				password,
				database: 'docta_me',
				port: 3306,
				waitForConnections: true,
				connectionLimit: 10,
				queueLimit: 0,
				charset: 'utf8mb4',
				timezone: '+00:00',
			});
		}

		return await pool.getConnection();
	} catch (error) {
		console.error('Database connection error:', error);
		throw error;
	}
}
```

#### composables/use-analytics.ts

```typescript
export function useAnalytics() {
	// ✅ Прямой доступ к process.env
	const mixpanelToken = process.env.MIXPANEL_TOKEN;
	const cloudflareToken = process.env.CLOUDFLARE_TOKEN;

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
		const token = cloudflareToken;
		// ...
	};

	// ...
}
```

---

## Безопасность: Client-side переменные

### ⚠️ Важно: Не все переменные доступны в браузере

В Nuxt 3 переменные в `process.env` доступны **только на сервере** по умолчанию.

Чтобы переменная была доступна в браузере, нужно использовать префикс `NUXT_PUBLIC_`:

```bash
# .env

# ❌ НЕ доступна в браузере (только на сервере)
DB_PASSWORD=secret123

# ✅ Доступна в браузере
NUXT_PUBLIC_MIXPANEL_TOKEN=abc123
```

### Переменные, которые должны быть публичными

Следующие переменные используются в client-side коде и должны иметь префикс `NUXT_PUBLIC_`:

```bash
# Analytics
NUXT_PUBLIC_MIXPANEL_TOKEN=your_token_here
NUXT_PUBLIC_CLOUDFLARE_TOKEN=your_token_here
NUXT_PUBLIC_GTAG_ID=your_id_here

# OAuth (публичные ID)
NUXT_PUBLIC_TELEGRAM_BOT_USERNAME=your_bot_username
NUXT_PUBLIC_FACEBOOK_APP_ID=your_app_id

# Application
NUXT_PUBLIC_BASE_URL=https://docta.me
```

### Переменные, которые должны быть приватными

```bash
# Database (только server-side)
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=secret

# OAuth secrets (только server-side)
GOOGLE_CLIENT_SECRET=secret
FACEBOOK_APP_SECRET=secret
TELEGRAM_BOT_TOKEN=secret

# Email (только server-side)
SMTP_PASSWORD=secret
```

### Использование в коде

```typescript
// ✅ Server-side (API routes, server utils)
const dbPassword = process.env.DB_PASSWORD; // Работает
const mixpanelToken = process.env.NUXT_PUBLIC_MIXPANEL_TOKEN; // Работает

// ✅ Client-side (composables, components)
const mixpanelToken = process.env.NUXT_PUBLIC_MIXPANEL_TOKEN; // Работает
const dbPassword = process.env.DB_PASSWORD; // undefined (безопасно!)
```

---

## Чеклист миграции

Для каждого файла, использующего `useRuntimeConfig()`:

- [ ] Удалить импорт/вызов `useRuntimeConfig()`
- [ ] Заменить `config.public.variableName` на `process.env.VARIABLE_NAME`
- [ ] Для client-side: убедиться, что переменная имеет префикс `NUXT_PUBLIC_`
- [ ] Для server-side: убедиться, что приватные переменные БЕЗ префикса
- [ ] Проверить TypeScript ошибки
- [ ] Протестировать функциональность
- [ ] Обновить тесты (если есть)

---

## Откат изменений

Если что-то пойдет не так, откат простой:

1. Вернуть секцию `runtimeConfig` в `nuxt.config.ts`
2. Вернуть `useRuntimeConfig()` в файлах
3. Перезапустить приложение

Все изменения локализованы и легко откатываются через git revert.

---

[← Назад к оглавлению](index.md) | [← Предыдущая: Требования](02-requirements.md) | [Далее: Риски и метрики →](04-risks-and-metrics.md)

# Конфигурация BASE_URL

## Описание

`BASE_URL` - это основной URL приложения, который используется для:

- Генерации OAuth redirect URI (Google, Facebook, Telegram)
- Создания ссылок в email (верификация, сброс пароля, смена email)
- E2E тестирования

## Настройка

### Переменная окружения

Обязательно установите `BASE_URL` в файле `.env`:

```env
# Локальная разработка
BASE_URL=http://localhost:3000

# Production
BASE_URL=https://docta.me
```

## Использование

### Используем утилиту getBaseUrl()

Для удобства и консистентности создана утилита `getBaseUrl()`, которая:

- Читает `process.env.BASE_URL`
- Валидирует его наличие
- Выбрасывает понятную ошибку, если не установлен

```typescript
import { getBaseUrl } from '~/server/utils/base-url';

// ✅ ПРАВИЛЬНО - используем утилиту
const resetUrl = `${getBaseUrl()}/reset-password?token=${token}`;

// ❌ НЕПРАВИЛЬНО - прямое использование с fallback
const baseUrl = process.env.BASE_URL || 'http://localhost:3000';

// ❌ НЕПРАВИЛЬНО - дублирование валидации
const baseUrl = process.env.BASE_URL;
if (!baseUrl) {
	throw new Error('BASE_URL environment variable is required');
}
```

## Важные правила

1. **Используем утилиту** - везде вызываем `getBaseUrl()` вместо прямого доступа к `process.env`
2. **Никаких хардкод значений** - `localhost:3000` должен быть только в `.env`
3. **Никаких fallback значений** - лучше упасть с ошибкой, чем работать с неправильным URL
4. **Единый способ доступа** - вся валидация и логика в одном месте

## Примеры использования

### В API endpoints

```typescript
import { getBaseUrl } from '~/server/utils/base-url';

export default defineEventHandler(async (event) => {
	// Формируем ссылку
	const resetUrl = `${getBaseUrl()}/reset-password?token=${token}`;

	// Отправляем email
	await sendPasswordResetEmail(user.email, resetUrl);
});
```

### В утилитах

```typescript
import { getBaseUrl } from '~/server/utils/base-url';

export function getOAuthConfig(): OAuthConfig {
	const baseUrl = getBaseUrl();

	return {
		google: {
			redirectUri: `${baseUrl}/api/auth/callback/google`,
		},
	};
}
```

## Troubleshooting

### Ошибка: "BASE_URL environment variable is required"

Убедитесь, что в файле `.env` есть строка:

```env
BASE_URL=http://localhost:3000
```

### OAuth не работает с localhost

Для некоторых OAuth провайдеров (например, Telegram) localhost не работает.
Используйте ngrok:

```bash
ngrok http 3000
```

И обновите `.env`:

```env
BASE_URL=https://your-subdomain.ngrok-free.dev
```

### Email ссылки ведут на неправильный домен

Проверьте, что `BASE_URL` установлен правильно для вашего окружения:

- Development: `http://localhost:3000`
- Production: `https://docta.me`

## E2E тестирование

Для E2E тестов используется отдельная переменная `E2E_BASE_URL`:

```env
E2E_BASE_URL=http://localhost:3000
```

Это позволяет тестировать приложение на другом URL, если нужно.

## Реализация утилиты

```typescript
// server/utils/base-url.ts
export function getBaseUrl(): string {
	const baseUrl = process.env.BASE_URL;

	if (!baseUrl) {
		throw new Error('BASE_URL environment variable is required');
	}

	return baseUrl;
}
```

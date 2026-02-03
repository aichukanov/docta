# Централизованное управление OAuth провайдерами

## Описание

Создан централизованный модуль для управления списком OAuth провайдеров в системе аутентификации. Это обеспечивает единую точку истины для списка доступных провайдеров и их валидации.

## Файл: `server/utils/oauth-providers.ts`

### Константы

```typescript
// Список всех доступных OAuth провайдеров
export const OAUTH_PROVIDERS = ['google', 'telegram', 'facebook'] as const;

// Список всех методов аутентификации (OAuth + email)
export const AUTH_METHODS = ['email', ...OAUTH_PROVIDERS] as const;
```

### Типы

```typescript
// Тип OAuth провайдера
type OAuthProvider = 'google' | 'telegram' | 'facebook';

// Тип метода аутентификации
type AuthMethod = 'email' | 'google' | 'telegram' | 'facebook';
```

### Функции валидации

#### `isValidOAuthProvider(value: unknown): value is OAuthProvider`

Проверяет, является ли значение валидным OAuth провайдером.

```typescript
if (isValidOAuthProvider(provider)) {
	// provider имеет тип OAuthProvider
}
```

#### `isValidAuthMethod(value: unknown): value is AuthMethod`

Проверяет, является ли значение валидным методом аутентификации.

```typescript
if (isValidAuthMethod(method)) {
	// method имеет тип AuthMethod
}
```

#### `isValidPrimaryProvider(value: unknown): value is OAuthProvider | null`

Проверяет, является ли значение валидным primary provider (может быть null).

```typescript
if (isValidPrimaryProvider(provider)) {
	// provider имеет тип OAuthProvider | null
}
```

#### `getAvailableProviders(): readonly OAuthProvider[]`

Возвращает массив всех доступных OAuth провайдеров.

```typescript
const providers = getAvailableProviders(); // ['google', 'telegram', 'facebook']
```

## Использование

### В API endpoints

```typescript
import {
	isValidOAuthProvider,
	isValidPrimaryProvider,
} from '~/server/utils/oauth-providers';

// Валидация провайдера в unlink
const provider = getRouterParam(event, 'provider');
if (!provider || !isValidOAuthProvider(provider)) {
	throw createError({ statusCode: 400, statusMessage: 'Invalid provider' });
}

// Валидация primary provider (может быть null)
const { provider } = await readBody(event);
if (!isValidPrimaryProvider(provider)) {
	createErrorResponse(400, ERROR_CODES.INVALID_PROVIDER);
}
```

### В типах и интерфейсах

```typescript
import type { OAuthProvider, AuthMethod } from '~/server/utils/oauth-providers';

// Для функций логирования входа
async function logSuccessfulLogin(
	userId: number,
	event: H3Event,
	method: AuthMethod, // 'email' | 'google' | 'telegram' | 'facebook'
): Promise<void> {
	// ...
}

// Для OAuth профилей
async function setPrimaryOAuthProvider(
	userId: number,
	provider: OAuthProvider | null, // 'google' | 'telegram' | 'facebook' | null
): Promise<void> {
	// ...
}
```

## Обновленные файлы

1. **`server/utils/oauth-providers.ts`** (новый) - Централизованное управление провайдерами
2. **`server/api/auth/set-primary-provider.post.ts`** - Использует `isValidPrimaryProvider`
3. **`server/api/auth/unlink/[provider].post.ts`** - Использует `isValidOAuthProvider`
4. **`server/utils/login-history.ts`** - Использует тип `AuthMethod`
5. **`server/utils/oauth-profiles.ts`** - Использует тип `OAuthProvider`

## Преимущества

1. **Единая точка истины** - все провайдеры определены в одном месте
2. **Типобезопасность** - TypeScript автоматически проверяет типы
3. **Легко расширяется** - для добавления нового провайдера достаточно обновить константу `OAUTH_PROVIDERS`
4. **Переиспользуемость** - валидация в одном месте, используется везде
5. **Поддержка** - проще найти все места, где используются провайдеры

## Добавление нового провайдера

Чтобы добавить новый OAuth провайдер:

1. Добавить его в массив `OAUTH_PROVIDERS` в `server/utils/oauth-providers.ts`:

```typescript
export const OAUTH_PROVIDERS = [
	'google',
	'telegram',
	'facebook',
	'github',
] as const;
```

2. Все остальные файлы автоматически получат обновленную типизацию и валидацию!

## Миграция существующего кода

Вместо:

```typescript
if (!['google', 'telegram', 'facebook'].includes(provider)) {
	// error
}
```

Использовать:

```typescript
import { isValidOAuthProvider } from '~/server/utils/oauth-providers';

if (!isValidOAuthProvider(provider)) {
	// error
}
```

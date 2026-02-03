# API Response Codes System

Система кодов ответов для единообразной обработки сообщений API. Коды используются для поиска по кодовой базе и идентификации типов ответов.

## Архитектура

### Backend (Server)

#### `server/utils/api-codes.ts`

Единственный источник всех кодов ответов API (enum'ы):

```typescript
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

// Успешный ответ
return createSuccessResponse(SUCCESS_CODES.LOGIN_SUCCESS, {
	user: { id: 1, email: 'user@example.com' },
});

// Ошибка
createErrorResponse(400, ERROR_CODES.INVALID_EMAIL);
```

### Frontend (Client)

#### `composables/use-api-messages.ts`

Composable для работы с кодами (без локализации):

```typescript
import { SUCCESS_CODES, ERROR_CODES } from '~/server/utils/api-codes';

// Импортируем напрямую из api-codes
const { logSuccess, logError } = useApiMessages();

// Просто логирует коды в консоль
logSuccess(response); // Выведет код, например "LOGIN_SUCCESS"
logError(error); // Выведет код ошибки
```

## Структура ответов

**Успешный ответ:**

```json
{
	"success": true,
	"code": "LOGIN_SUCCESS",
	"user": { "id": 1, "email": "user@example.com" }
}
```

**Ошибка:**

```json
{
	"statusCode": 400,
	"statusMessage": "INVALID_EMAIL",
	"data": {
		"code": "INVALID_EMAIL",
		"details": ["Additional error details if any"]
	}
}
```

## Использование

### На Backend

```typescript
// server/api/auth/example.post.ts
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const body = await readBody(event);

	// Валидация
	if (!body.email) {
		createErrorResponse(400, ERROR_CODES.EMAIL_REQUIRED);
	}

	try {
		// ... бизнес-логика

		return createSuccessResponse(SUCCESS_CODES.EMAIL_CHANGED);
	} catch (error: any) {
		if (error.statusCode) {
			throw error;
		}
		createErrorResponse(500, ERROR_CODES.INTERNAL_ERROR);
	}
});
```

### На Frontend (Vue/Nuxt)

**Компонент сам обрабатывает коды и решает, что показывать пользователю:**

```vue
<script setup>
import { SUCCESS_CODES, ERROR_CODES } from '~/server/utils/api-codes';

const handleLogin = async () => {
	try {
		const response = await $fetch('/api/auth/login', {
			method: 'POST',
			body: { email, password },
		});

		// Компонент сам обрабатывает код и показывает своё сообщение
		if (response.code === SUCCESS_CODES.LOGIN_SUCCESS) {
			toast.success('Добро пожаловать!'); // Своя локализация в компоненте
			navigateTo('/dashboard');
		}
	} catch (error: any) {
		// Компонент сам обрабатывает ошибку и локализует
		const code = error?.data?.code || error?.statusMessage;

		if (code === ERROR_CODES.INVALID_CREDENTIALS) {
			toast.error('Неверный email или пароль'); // Своя локализация
		} else if (code === ERROR_CODES.USER_NOT_FOUND) {
			toast.error('Пользователь не найден');
		} else {
			toast.error('Произошла ошибка при входе');
		}

		// Дополнительные детали
		if (error?.data?.details) {
			console.error('Details:', error.data.details);
		}
	}
};
</script>
```

## Доступные коды

### Success Codes (`SUCCESS_CODES`)

- `LOGIN_SUCCESS` - Успешный вход
- `LOGOUT_SUCCESS` - Успешный выход
- `REGISTRATION_SUCCESS` - Успешная регистрация
- `PASSWORD_CHANGED` - Пароль изменен
- `PASSWORD_RESET_EMAIL_SENT` - Письмо для сброса пароля отправлено
- `EMAIL_CHANGED` - Email изменен
- `EMAIL_VERIFIED` - Email подтвержден
- `EMAIL_CHANGE_CONFIRMATION_SENT` - Письмо подтверждения отправлено
- `VERIFICATION_EMAIL_SENT` - Письмо верификации отправлено
- `NAME_UPDATED` - Имя обновлено
- `PRIMARY_PROVIDER_UPDATED` - Приоритетный провайдер обновлен
- `SESSION_DELETED` - Сессия удалена
- `ALL_SESSIONS_DELETED` - Все остальные сессии удалены
- `ACCOUNT_LINKED` - Аккаунт привязан
- `ACCOUNT_UNLINKED` - Аккаунт отвязан

### Error Codes (`ERROR_CODES`)

#### Authentication Errors

- `UNAUTHORIZED` - Требуется авторизация
- `INVALID_CREDENTIALS` - Неверные учетные данные

#### Validation Errors

- `INVALID_EMAIL` - Некорректный email
- `INVALID_PASSWORD` - Некорректный пароль
- `EMAIL_REQUIRED` - Email обязателен
- `PASSWORD_REQUIRED` - Пароль обязателен
- `NAME_REQUIRED` - Имя обязательно
- `ALL_FIELDS_REQUIRED` - Все поля обязательны
- `PASSWORDS_DO_NOT_MATCH` - Пароли не совпадают
- `NAME_TOO_LONG` - Имя слишком длинное
- `NAME_EMPTY` - Имя пустое
- `CURRENT_PASSWORD_REQUIRED` - Требуется текущий пароль
- `NEW_PASSWORD_REQUIRED` - Требуется новый пароль

#### User Errors

- `USER_NOT_FOUND` - Пользователь не найден
- `USER_ALREADY_EXISTS` - Пользователь уже существует
- `EMAIL_ALREADY_IN_USE` - Email уже используется
- `EMAIL_SAME_AS_CURRENT` - Email совпадает с текущим
- `INVALID_CURRENT_PASSWORD` - Неверный текущий пароль

#### Token Errors

- `TOKEN_NOT_FOUND` - Токен не найден
- `INVALID_TOKEN` - Недействительный токен
- `TOKEN_EXPIRED` - Токен истек
- `TOKEN_ALREADY_USED` - Токен уже использован

#### Session Errors

- `SESSION_ID_REQUIRED` - ID сессии обязателен
- `SESSION_NOT_FOUND` - Сессия не найдена

#### Provider Errors

- `INVALID_PROVIDER` - Недопустимый провайдер

#### Permission Errors

- `FORBIDDEN` - Доступ запрещен

#### Generic Errors

- `INTERNAL_ERROR` - Внутренняя ошибка
- `ERROR_CREATING_ACCOUNT` - Ошибка создания аккаунта
- `ERROR_SENDING_EMAIL` - Ошибка отправки email
- `ERROR_UPDATING_NAME` - Ошибка обновления имени
- `ERROR_CHANGING_PASSWORD` - Ошибка изменения пароля
- `ERROR_CHANGING_EMAIL` - Ошибка изменения email
- `ERROR_VERIFYING_EMAIL` - Ошибка верификации email
- `ERROR_RESETTING_PASSWORD` - Ошибка сброса пароля
- `ERROR_REQUESTING_EMAIL_CHANGE` - Ошибка запроса смены email
- `ERROR_UPDATING_PRIMARY_PROVIDER` - Ошибка обновления провайдера
- `ERROR_DURING_LOGIN` - Ошибка при входе
- `ERROR_PROCESSING_REQUEST` - Ошибка обработки запроса

## Добавление нового кода

### 1. Добавить код в `server/utils/api-codes.ts`

```typescript
export enum SUCCESS_CODES {
	// ...
	NEW_SUCCESS_CODE = 'NEW_SUCCESS_CODE',
}

// или для ошибок
export enum ERROR_CODES {
	// ...
	NEW_ERROR_CODE = 'NEW_ERROR_CODE',
}
```

### 2. Использовать в API endpoint

```typescript
return createSuccessResponse(SUCCESS_CODES.NEW_SUCCESS_CODE);
// или
createErrorResponse(400, ERROR_CODES.NEW_ERROR_CODE);
```

### 3. Обработать в компоненте

```vue
<script setup>
if (response.code === SUCCESS_CODES.NEW_SUCCESS_CODE) {
	toast.success('Своё сообщение для пользователя');
}
</script>
```

## Преимущества

✅ **Консистентность** - все коды в одном месте  
✅ **Поиск по кодовой базе** - легко найти все места использования кода  
✅ **Type-safe** - TypeScript enum проверяет существование кодов  
✅ **Гибкость** - каждый компонент сам решает, как локализовать и показывать сообщения  
✅ **Централизованное управление** - один источник правды для кодов  
✅ **Безопасность** - не показываем технические детали пользователям  
✅ **Отсутствие дублирования** - коды определены только в `api-codes.ts`

## Миграция старого кода

### Было (текстовые сообщения):

```typescript
throw createError({
	statusCode: 400,
	statusMessage: 'Invalid email address',
});

return {
	success: true,
	message: 'Session deleted',
};
```

### Стало (коды из enum):

```typescript
createErrorResponse(400, ERROR_CODES.INVALID_EMAIL);

return createSuccessResponse(SUCCESS_CODES.SESSION_DELETED);
```

## Философия

- **Коды для программистов** - используются для поиска по коду и идентификации
- **Локализация в компонентах** - каждый компонент сам решает, как показывать сообщения пользователю
- **Нет централизованной локализации** - компоненты сами управляют своей локализацией
- **Простота** - минимум абстракций, максимум гибкости

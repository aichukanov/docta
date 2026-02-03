# Email Templates Localization

## Обзор

Система email-шаблонов с поддержкой локализации на все языки из `use-locale`.

## Структура

### Файлы

1. **`server/utils/email-templates.ts`** - Локализованные шаблоны email
2. **`server/utils/email.ts`** - Утилиты для отправки email через Mailgun
3. **`server/utils/user-locale.ts`** - Определение локали пользователя

## Поддерживаемые языки

- 🇷🇸 Serbian (Latin) - `sr`
- 🇷🇸 Serbian (Cyrillic) - `sr-cyrl`
- 🇬🇧 English - `en`
- 🇷🇺 Russian - `ru`
- 🇩🇪 German - `de`
- 🇹🇷 Turkish - `tr`

## Типы email-шаблонов

### 1. Password Reset (Восстановление пароля)

```typescript
sendPasswordResetEmail(
  email: string,
  resetUrl: string,
  locale?: Language
)
```

### 2. Email Verification (Подтверждение email)

```typescript
sendEmailVerification(
  email: string,
  verificationUrl: string,
  userName: string,
  locale?: Language
)
```

### 3. Login Notification (Уведомление о входе)

```typescript
sendLoginNotification(
  email: string,
  userName: string,
  loginInfo: {
    ip: string;
    userAgent: string;
    location?: string;
    timestamp: Date;
  },
  locale?: Language
)
```

### 4. Email Change Notification (Уведомление об изменении email)

```typescript
sendEmailChangeNotification(
  oldEmail: string,
  newEmail: string,
  userName: string,
  locale?: Language
)
```

## Определение локали пользователя

Функция `getUserLocale()` определяет локаль в следующем приоритете:

1. **Локаль из профиля пользователя** (поле `preferred_locale` в БД)
2. **Локаль из Google OAuth профиля** (если пользователь входил через Google)
3. **Локаль из `Accept-Language` header** запроса
4. **Локаль по умолчанию** - Serbian (`sr`)

### Использование

```typescript
import { getUserLocale } from '~/server/utils/user-locale';

// В API endpoint
const locale = await getUserLocale(userId, event);
await sendEmailVerification(email, url, name, locale);
```

## Сохранение локали пользователя

Пользователи могут сохранить предпочитаемый язык в профиле:

```typescript
// Клиентская сторона
const { updateUserLocale } = useUserLocale();
await updateUserLocale(Language.RU);

// Серверная сторона
POST /api/auth/update-locale
{ "locale": "ru" }
```

См. полную документацию: [USER_LOCALE_SYSTEM.md](./USER_LOCALE_SYSTEM.md)

## Добавление нового языка

### 1. Добавить в `use-locale.ts`

```typescript
export const locales = [
	// ... existing
	Language.FR, // новый язык
];
```

### 2. Добавить переводы в `email-templates.ts`

```typescript
const passwordResetTemplates: Record<Language, EmailTemplate> = {
	// ... existing
	[Language.FR]: {
		subject: 'Réinitialisation du mot de passe sur docta.me',
		heading: 'Réinitialisation du mot de passe',
		greeting: () => 'Bonjour!',
		content: [
			'Vous avez demandé une réinitialisation du mot de passe...',
			// ... rest
		],
		buttonText: 'Définir un nouveau mot de passe',
		footer: [],
		copyright: '© 2026 docta.me - Tous droits réservés',
	},
};
```

### 3. Обновить все 4 шаблона

- `passwordResetTemplates`
- `emailVerificationTemplates`
- `loginNotificationTemplates`
- `emailChangeNotificationTemplates`

## Дизайн email

### Цветовая схема

- **Primary Gradient**: `linear-gradient(135deg, #667eea 0%, #764ba2 100%)`
- **Button Color**: `#667eea`
- **Danger Button**: `#dc3545`
- **Link Color**: `#667eea`
- **Text Color**: `#333`
- **Background**: `#f9f9f9`

### Структура

```html
<!DOCTYPE html>
<html>
	<head>
		<style>
			/* общие стили */
		</style>
	</head>
	<body>
		<div class="container">
			<div class="header"><!-- заголовок с градиентом --></div>
			<div class="content"><!-- основное содержимое --></div>
			<div class="footer"><!-- copyright --></div>
		</div>
	</body>
</html>
```

## API Integration

### Регистрация (`register.post.ts`)

```typescript
const locale = await getUserLocale(userId, event);
await sendEmailVerification(email, verificationUrl, name, locale);
```

### Восстановление пароля (`forgot-password.post.ts`)

```typescript
const locale = await getUserLocale(user.id, event);
await sendPasswordResetEmail(user.email, resetUrl, locale);
```

### Повторная отправка подтверждения (`resend-verification.post.ts`)

```typescript
const locale = await getUserLocale(user.id, event);
await sendEmailVerification(user.email, verificationUrl, user.name, locale);
```

### Запрос изменения email (`request-email-change.post.ts`)

```typescript
const locale = await getUserLocale(user.id, event);
await sendEmailVerification(normalizedEmail, confirmUrl, user.name, locale);
```

### Подтверждение изменения email (`confirm-email-change.get.ts`)

```typescript
const locale = await getUserLocale(updatedUser.id, event);
await sendEmailChangeNotification(
	result.data!.oldEmail,
	result.data!.newEmail,
	updatedUser.name,
	locale,
);
```

## Development Mode

В режиме разработки (`NODE_ENV=development`):

- Email не отправляются через Mailgun
- Выводятся в console через logger
- URL для подтверждения возвращаются в API response

```json
{
	"code": "REGISTRATION_SUCCESS",
	"verificationUrl": "http://localhost:3000/verify-email?token=..."
}
```

## Mailgun Configuration

Необходимые переменные окружения:

```env
MAILGUN_API_KEY=your-api-key
MAILGUN_API_URL=https://api.eu.mailgun.net
MAILGUN_DOMAIN=mg.docta.me
MAILGUN_FROM_EMAIL=noreply@docta.me
MAILGUN_FROM_NAME=docta.me
```

## Testing

### Тестирование локализации

```bash
# В development mode проверяем логи
npm run dev

# Регистрируемся с разными Accept-Language
curl -H "Accept-Language: ru-RU" -X POST /api/auth/register
curl -H "Accept-Language: en-US" -X POST /api/auth/register
curl -H "Accept-Language: de-DE" -X POST /api/auth/register
```

### Preview Email шаблонов

В development режиме доступна страница для просмотра всех email шаблонов:

**URL:** http://localhost:3000/dev/email-preview

Функции:

- Выбор типа шаблона (password-reset, email-verification, login-notification, email-change)
- Выбор языка (sr, sr-cyrl, en, ru, de, tr)
- Live preview в iframe

**API Endpoint для preview:**

```
GET /api/test/email-preview?type=password-reset&locale=ru
GET /api/test/email-preview?type=email-verification&locale=en
```

### Проверка шаблонов

Проверьте что все языки имеют:

- ✅ Корректные переводы
- ✅ Одинаковую структуру content массива
- ✅ buttonText определён
- ✅ copyright локализован

## Best Practices

1. **DRY**: Все шаблоны используют общую функцию `generateEmailHTML()`
2. **Type Safety**: Используем TypeScript интерфейсы для шаблонов
3. **Fallback**: Если локаль не найдена, используем English
4. **Security**: Не раскрываем существование пользователей через email
5. **UX**: Всегда предоставляем и ссылку и кнопку в email

## Будущие улучшения

- [ ] Добавить поле `locale` в таблицу `auth_users`
- [ ] Позволить пользователям выбирать язык email в профиле
- [ ] Добавить A/B тестирование для subject lines
- [ ] Использовать email-шаблонизаторы (Handlebars, Pug)
- [ ] Добавить preview режим для просмотра email

# User Locale Preference System

## Обзор

Система сохранения предпочитаемого языка пользователя в базе данных с автоматической синхронизацией.

## Архитектура

### Приоритет определения локали

```
┌─────────────────────────────────────────┐
│ 1. Локаль из профиля пользователя (БД)  │  ← Highest priority
│    preferred_locale in auth_users        │
└─────────────────────────────────────────┘
                   ↓ (если NULL)
┌─────────────────────────────────────────┐
│ 2. Локаль из Google OAuth профиля       │
│    locale in auth_oauth_profiles_google │
└─────────────────────────────────────────┘
                   ↓ (если NULL)
┌─────────────────────────────────────────┐
│ 3. Локаль из cookie                     │
│    cookie: 'locale'                     │
└─────────────────────────────────────────┘
                   ↓ (если пусто)
┌─────────────────────────────────────────┐
│ 4. Локаль из query параметра            │
│    ?lang=ru                             │
└─────────────────────────────────────────┘
                   ↓ (если пусто)
┌─────────────────────────────────────────┐
│ 5. Локаль из Accept-Language header     │
│    Accept-Language: ru-RU,ru;q=0.9      │
└─────────────────────────────────────────┘
                   ↓ (если пусто)
┌─────────────────────────────────────────┐
│ 6. Локаль по умолчанию (Serbian)        │
│    Language.SR                          │
└─────────────────────────────────────────┘
```

## Компоненты системы

### 1. База данных

**Миграция:** `server/sql/migrations/006_user_preferred_locale.sql`

```sql
ALTER TABLE auth_users
ADD COLUMN preferred_locale VARCHAR(10) DEFAULT NULL
COMMENT 'Preferred language: sr, sr-cyrl, en, ru, de, tr';
```

### 2. API Endpoints

#### GET /api/auth/user-locale

Получить текущую локаль пользователя

**Response:**

```json
{
	"success": true,
	"code": "LOCALE_UPDATED",
	"data": {
		"locale": "ru"
	}
}
```

#### POST /api/auth/update-locale

Обновить предпочитаемую локаль пользователя

**Request:**

```json
{
	"locale": "ru"
}
```

**Response:**

```json
{
	"success": true,
	"code": "LOCALE_UPDATED",
	"data": {
		"locale": "ru"
	}
}
```

### 3. Middleware

**File:** `middleware/locale.global.ts`

Global middleware который запускается на каждом переходе и инициализирует локаль в правильном приоритете.

### 4. Plugin

**File:** `plugins/01.locale.client.ts`

Client-side plugin который запускается при загрузке приложения и инициализирует локаль пользователя.

### 5. Composable

**File:** `composables/use-user-locale.ts`

```typescript
const { fetchUserLocale, updateUserLocale } = useUserLocale();

// Получить локаль из профиля
const locale = await fetchUserLocale();

// Обновить локаль
await updateUserLocale(Language.RU);
```

### 6. Component

**File:** `components/language-switcher.vue`

Автоматически сохраняет выбранную локаль в БД если пользователь залогинен.

## Использование

### Для залогиненных пользователей

```typescript
// В компоненте
const { updateUserLocale } = useUserLocale();

// Пользователь выбирает язык
await updateUserLocale(Language.RU);

// Локаль автоматически:
// - Обновляется в БД (preferred_locale)
// - Сохраняется в cookie
// - Применяется в приложении
```

### Для незалогиненных пользователей

```typescript
// Локаль сохраняется только в cookie
const { locale } = useI18n();
const cookieLocale = useCookie('locale');

locale.value = 'ru';
cookieLocale.value = 'ru';
```

## Поток данных

### При загрузке страницы

```
User opens page
       ↓
Plugin: 01.locale.client.ts
       ↓
Is user authenticated?
   ↙         ↘
 YES         NO
  ↓           ↓
Fetch         Check cookie
/api/auth/    then query
user-locale   then default
  ↓           ↓
Update        Update
locale        locale
```

### При смене языка через language-switcher

```
User selects language
       ↓
language-switcher.vue
       ↓
updateLocale(value)
       ↓
Is user authenticated?
   ↙         ↘
 YES         NO
  ↓           ↓
POST          Update
/api/auth/    cookie only
update-locale
  ↓
Update cookie
and route query
```

## Server-side использование

Для email и других серверных операций:

```typescript
import { getUserLocale } from '~/server/utils/user-locale';

// В API endpoint
const locale = await getUserLocale(userId, event);

// Теперь locale берется из:
// 1. preferred_locale (если установлен)
// 2. Google OAuth профиля
// 3. Accept-Language header
// 4. Default (Serbian)
```

## Миграция существующих пользователей

Существующие пользователи получат `preferred_locale = NULL`.

При следующей смене языка через language-switcher значение будет автоматически сохранено в БД.

## API Codes

### Success

- `LOCALE_UPDATED` - Локаль успешно обновлена

### Errors

- `UNAUTHORIZED` - Пользователь не авторизован
- `LOCALE_REQUIRED` - Локаль не указана
- `INVALID_LOCALE` - Неподдерживаемая локаль
- `ERROR_UPDATING_LOCALE` - Ошибка при обновлении

## Тестирование

### Manual Testing

```bash
# 1. Запустить dev server
npm run dev

# 2. Залогиниться

# 3. Сменить язык через language-switcher

# 4. Проверить в БД
mysql> SELECT id, email, preferred_locale FROM auth_users WHERE email = 'test@example.com';

# 5. Обновить страницу - язык должен сохраниться

# 6. Залогиниться на другом устройстве - язык должен быть тот же
```

### API Testing

```bash
# Получить текущую локаль
curl -X GET http://localhost:3000/api/auth/user-locale \
  -H "Cookie: session_id=YOUR_SESSION"

# Обновить локаль
curl -X POST http://localhost:3000/api/auth/update-locale \
  -H "Content-Type: application/json" \
  -H "Cookie: session_id=YOUR_SESSION" \
  -d '{"locale":"ru"}'
```

## Файлы

### Новые файлы

1. `server/sql/migrations/006_user_preferred_locale.sql` - Миграция БД
2. `server/api/auth/update-locale.post.ts` - API для обновления
3. `server/api/auth/user-locale.get.ts` - API для получения
4. `middleware/locale.global.ts` - Global middleware
5. `plugins/01.locale.client.ts` - Client plugin
6. `composables/use-user-locale.ts` - Composable
7. `docs/USER_LOCALE_SYSTEM.md` - Документация

### Обновленные файлы

1. `server/utils/api-codes.ts` - Добавлены коды
2. `server/utils/user-locale.ts` - Добавлена проверка БД
3. `components/language-switcher.vue` - Сохранение в БД
4. `docs/EMAIL_LOCALIZATION.md` - Обновлен приоритет

## Best Practices

1. **Всегда используйте composable** для работы с локалью пользователя
2. **Проверяйте авторизацию** перед вызовом API
3. **Fallback на cookie** если API недоступен
4. **Логируйте ошибки** но не показывайте пользователю
5. **Синхронизируйте** локаль между cookie и БД

## Будущие улучшения

- [ ] UI для выбора "запомнить язык"
- [ ] Админ панель для просмотра статистики по языкам
- [ ] A/B тестирование локалей
- [ ] Автоматическая миграция Google локали в preferred_locale
- [ ] Webhook для синхронизации между устройствами

---

**Готово!** Система полностью функциональна и готова к использованию.

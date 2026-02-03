# Система авторизации docta.me

## Обзор

Система авторизации построена на OAuth 2.0 и поддерживает вход через:
- **Google** - OAuth 2.0 авторизация
- **Telegram** - Login Widget

## Архитектура

### Компоненты

#### 1. Композабл `useAuth()`

Основной композабл для работы с авторизацией на клиенте.

```typescript
const {
  // State
  isAuthenticated,
  currentUser,
  isAdmin,
  isLoading,
  
  // Methods
  fetchUser,
  loginWithGoogle,
  logout,
  requireAuth,
  requireAdmin,
} = useAuth();
```

**Возможности:**
- Получение информации о текущем пользователе
- Проверка авторизации и прав доступа
- Выход из системы
- Редирект после авторизации

#### 2. Middleware

**`middleware/auth.ts`** - Защита пользовательских маршрутов
```vue
definePageMeta({
  middleware: 'auth'
})
```

**`middleware/admin-auth.ts`** - Защита админ-панели
```vue
definePageMeta({
  middleware: 'admin-auth'
})
```

#### 3. Server Utils

**`server/utils/session.ts`** - Управление сессиями
- `createSession(userId)` - создание сессии
- `getUserFromSession(sessionId)` - получение пользователя
- `deleteSession(sessionId)` - удаление сессии
- `setSessionCookie(event, sessionId)` - установка cookie
- `clearSessionCookie(event)` - очистка cookie

**`server/utils/oauth.ts`** - Работа с OAuth
- `findUserByOAuth(provider, providerId)` - поиск по OAuth
- `createOAuthUser(...)` - создание пользователя через OAuth
- `linkOAuthAccount(userId, provider, ...)` - привязка OAuth аккаунта
- `updateOAuthTokens(...)` - обновление токенов
- `updateUserProfile(...)` - обновление профиля

**`server/utils/telegram-auth.ts`** - Проверка Telegram данных
- `verifyTelegramAuth(data, botToken)` - проверка подлинности
- `getTelegramFullName(data)` - получение имени
- `getTelegramUsername(data)` - получение username

**`server/common/auth.ts`** - Общие функции авторизации
- `requireAdmin(event)` - проверка прав администратора
- `getCurrentUser(event)` - получение текущего пользователя

### API Endpoints

#### Авторизация

**`GET /api/auth/google`**
- Инициирует OAuth flow для Google
- Сохраняет redirect URL для возврата после авторизации

**`GET /api/auth/callback/google`**
- Обрабатывает callback от Google OAuth
- Создает или обновляет пользователя
- Создает сессию
- Поддерживает привязку к существующему аккаунту

**`GET /api/auth/callback/telegram`**
- Обрабатывает callback от Telegram Login Widget
- Проверяет подлинность данных
- Создает или обновляет пользователя
- Создает сессию
- Поддерживает привязку к существующему аккаунту

#### Управление сессией

**`GET /api/admin/auth/me`**
- Получение информации о текущем пользователе
- Возвращает `{ authenticated: boolean, user: User | null }`

**`POST /api/admin/auth/logout`**
- Выход из системы
- Удаляет сессию из БД и cookie

#### Управление OAuth аккаунтами

**`GET /api/auth/accounts`**
- Получение списка привязанных OAuth аккаунтов
- Требует авторизации

**`POST /api/auth/unlink/:provider`**
- Отвязка OAuth аккаунта
- Требует авторизации
- Нельзя отвязать единственный способ входа

## Функциональность

### 1. Базовая авторизация

- Вход через Google или Telegram
- Автоматическое создание пользователя при первом входе
- Сессии с cookie (HttpOnly, Secure в production)
- Продолжительность сессии: 30 дней

### 2. Редирект после авторизации

При переходе на защищенную страницу без авторизации:
1. URL страницы сохраняется в `sessionStorage`
2. Пользователь перенаправляется на `/login`
3. После успешной авторизации возвращается на исходную страницу

### 3. Множественные OAuth провайдеры

Пользователь может привязать несколько способов входа:
- Google + Telegram к одному аккаунту
- Объединение аккаунтов по email (для Google)
- Привязка через страницу профиля

**Логика объединения:**
- Если пользователь авторизован, новый OAuth привязывается к текущему аккаунту
- Если не авторизован и email совпадает - привязывается к существующему
- Если не авторизован и email новый - создается новый пользователь

### 4. Страница профиля

**`/profile`** - управление аккаунтом:
- Просмотр информации о пользователе
- Список привязанных OAuth аккаунтов
- Привязка новых способов входа
- Отвязка OAuth аккаунтов (кроме последнего)
- Выход из системы

### 5. Защита маршрутов

**Пользовательские маршруты:**
```vue
<script setup>
definePageMeta({
  middleware: 'auth'
})
</script>
```

**Админ-панель:**
```vue
<script setup>
definePageMeta({
  middleware: 'admin-auth'
})
</script>
```

## Безопасность

### Google OAuth
- CSRF защита через state parameter
- HttpOnly cookies для хранения сессий
- Secure cookies в production
- Проверка redirect_uri
- Проверка верификации email

### Telegram Login Widget
- HMAC-SHA256 проверка подлинности данных
- Проверка времени авторизации (24 часа)
- Защита от подделки данных

### Сессии
- UUID идентификаторы
- Автоматическое истечение через 30 дней
- Проверка в БД на каждый запрос
- HttpOnly, Secure, SameSite cookies

## База данных

### Таблица `users`
```sql
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  username VARCHAR(100) UNIQUE,
  photo_url TEXT,
  is_admin BOOLEAN DEFAULT FALSE,
  password_hash VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Таблица `oauth_accounts`
```sql
CREATE TABLE oauth_accounts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  provider VARCHAR(50) NOT NULL,
  provider_account_id VARCHAR(255) NOT NULL,
  access_token TEXT,
  refresh_token TEXT,
  expires_at INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY unique_provider_account (provider, provider_account_id)
);
```

### Таблица `sessions`
```sql
CREATE TABLE sessions (
  id VARCHAR(36) PRIMARY KEY,
  user_id INT NOT NULL,
  expires_at INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_expires (expires_at)
);
```

## Переменные окружения

```bash
# Google OAuth
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret

# Telegram OAuth
TELEGRAM_BOT_TOKEN=your-bot-token
TELEGRAM_BOT_USERNAME=your_bot_username

# Base URL (для OAuth redirect)
BASE_URL=http://localhost:3000
```

## Использование

### Пример защиты страницы

```vue
<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
});

const { currentUser, isAdmin } = useAuth();
</script>

<template>
  <div>
    <h1>Привет, {{ currentUser?.name }}!</h1>
    <p v-if="isAdmin">Вы администратор</p>
  </div>
</template>
```

### Пример проверки авторизации

```vue
<script setup lang="ts">
const { isAuthenticated, fetchUser } = useAuth();

onMounted(async () => {
  await fetchUser();
  
  if (isAuthenticated.value) {
    // Пользователь авторизован
  }
});
</script>
```

### Пример кнопки выхода

```vue
<script setup lang="ts">
const { logout } = useAuth();

async function handleLogout() {
  try {
    await logout();
    // Автоматический редирект на главную
  } catch (error) {
    console.error('Logout error:', error);
  }
}
</script>

<template>
  <button @click="handleLogout">Выйти</button>
</template>
```

## Дальнейшие улучшения

Возможные будущие расширения:

1. **Email + пароль авторизация**
   - Регистрация с подтверждением email
   - Восстановление пароля
   - Изменение пароля

2. **Расширенная безопасность**
   - Двухфакторная авторизация (2FA)
   - История входов
   - Управление активными сессиями
   - Logout из всех устройств

3. **Дополнительные провайдеры**
   - GitHub OAuth
   - Facebook OAuth
   - Apple Sign In

4. **Улучшения профиля**
   - Редактирование имени и фото
   - Настройки приватности
   - Экспорт данных

5. **Административные функции**
   - Управление пользователями
   - Назначение ролей
   - Блокировка аккаунтов
   - Аудит действий

## Отладка

### Логи

Все OAuth операции логируются с префиксами:
- `[Google OAuth]` - Google авторизация
- `[Telegram Auth]` - Telegram авторизация

### Проверка сессии

```typescript
// Server side
const user = await getCurrentUser(event);
console.log('Current user:', user);

// Client side
const { currentUser, isAuthenticated } = useAuth();
console.log('Authenticated:', isAuthenticated.value);
console.log('User:', currentUser.value);
```

### Проблемы и решения

**Проблема:** Telegram виджет не загружается на localhost
**Решение:** Используйте ngrok для тестирования или создайте отдельного бота для development

**Проблема:** State mismatch ошибка в Google OAuth
**Решение:** Проверьте настройки cookies (Secure, SameSite)

**Проблема:** Не могу отвязать OAuth аккаунт
**Решение:** Нельзя отвязать единственный способ входа - привяжите сначала другой

## Тестирование

### Тестовые сценарии

1. **Первый вход через Google**
   - Создается новый пользователь
   - Создается сессия
   - Редирект на главную

2. **Первый вход через Telegram**
   - Создается новый пользователь
   - Создается сессия
   - Редирект на главную

3. **Привязка второго OAuth**
   - Войти через Google
   - На странице профиля привязать Telegram
   - Проверить список аккаунтов

4. **Отвязка OAuth**
   - Иметь 2 привязанных аккаунта
   - Отвязать один
   - Проверить что можно войти через оставшийся

5. **Редирект после авторизации**
   - Перейти на защищенную страницу без авторизации
   - Авторизоваться
   - Проверить редирект на исходную страницу

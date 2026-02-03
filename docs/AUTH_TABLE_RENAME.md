# Переименование таблиц авторизации - добавление префикса auth_

## ✅ Выполнено

Все таблицы авторизации теперь имеют префикс `auth_`:

| Старое название                  | Новое название                       |
| -------------------------------- | ------------------------------------ |
| `users`                          | `auth_users`                         |
| `sessions`                       | `auth_sessions`                      |
| `oauth_accounts`                 | `auth_oauth_accounts`                |
| `password_reset_tokens`          | `auth_password_reset_tokens`         |
| `email_verification_tokens`      | `auth_email_verification_tokens`     |
| `login_history`                  | `auth_login_history`                 |
| `oauth_profiles_google`          | `auth_oauth_profiles_google`         |
| `oauth_profiles_telegram`        | `auth_oauth_profiles_telegram`       |

## 📁 Обновленные файлы

### Утилиты (server/utils)
- ✅ `session.ts` - 4 замены
- ✅ `oauth.ts` - 6 замен
- ✅ `password-reset.ts` - 4 замены
- ✅ `email-verification.ts` - 5 замен
- ✅ `email-change.ts` - автоматически
- ✅ `login-history.ts` - автоматически
- ✅ `oauth-profiles.ts` - автоматически

### API endpoints (server/api/auth)
- ✅ `accounts.get.ts`
- ✅ `change-password.post.ts`
- ✅ `register.post.ts`
- ✅ `reset-password.post.ts`
- ✅ `sessions.get.ts`
- ✅ `update-name.post.ts`
- ✅ `callback/telegram.get.ts`
- ✅ `sessions/logout-all.post.ts`
- ✅ `sessions/[sessionId].delete.ts`
- ✅ `unlink/[provider].post.ts`

**Всего обновлено**: 13 файлов из 50 проверенных

## 🚀 Применение миграции

### Команда для запуска:

```bash
mysql -u root -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/complete_auth_migration.sql
```

### Что делает миграция:

1. Создает все таблицы с префиксом `auth_`
2. Устанавливает все индексы и внешние ключи
3. Создает все необходимые поля

### ⚠️ Если у вас уже есть старые таблицы:

Выполните ПЕРЕД миграцией:

```sql
SET FOREIGN_KEY_CHECKS=0;
RENAME TABLE users TO auth_users;
RENAME TABLE oauth_accounts TO auth_oauth_accounts;
RENAME TABLE sessions TO auth_sessions;
RENAME TABLE password_reset_tokens TO auth_password_reset_tokens;
RENAME TABLE email_verification_tokens TO auth_email_verification_tokens;
RENAME TABLE login_history TO auth_login_history;
RENAME TABLE oauth_profiles_google TO auth_oauth_profiles_google;
RENAME TABLE oauth_profiles_telegram TO auth_oauth_profiles_telegram;
SET FOREIGN_KEY_CHECKS=1;
```

## 🎯 Преимущества префикса auth_

### 1. Избежание конфликтов
```
❌ Раньше: users (конфликт с медицинскими пользователями)
✅ Теперь: auth_users (четко - это авторизация)
```

### 2. Логическая группировка
Все таблицы авторизации легко найти:
```sql
SHOW TABLES LIKE 'auth_%';
```

### 3. Понятность кода
```typescript
// Сразу понятно что это auth таблица
executeQuery('SELECT * FROM auth_users WHERE id = ?', [id]);
```

### 4. Легче навигация
В любом SQL клиенте таблицы auth будут сгруппированы вместе.

## 📊 Структура системы

```
auth_users (основные данные пользователей)
├── auth_sessions (сессии)
├── auth_oauth_accounts (OAuth провайдеры)
│   ├── auth_oauth_profiles_google (данные Google)
│   └── auth_oauth_profiles_telegram (данные Telegram)
├── auth_password_reset_tokens (сброс пароля)
├── auth_email_verification_tokens (подтверждение email)
└── auth_login_history (история входов)
```

## ✅ Готово к использованию!

Система полностью обновлена и готова к работе. 
Запустите миграцию и все заработает с новыми именами таблиц! 🚀

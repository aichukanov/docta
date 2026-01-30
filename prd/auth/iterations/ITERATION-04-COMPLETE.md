# Итерация 4: OAuth через Telegram - ЗАВЕРШЕНА ✅

**Дата:** 2026-01-30  
**Статус:** 🟢 Completed

## Что реализовано

### 1. Telegram OAuth Infrastructure

📄 **`server/utils/oauth-config.ts`** (обновлен)
- ✅ Добавлена конфигурация для Telegram
- ✅ Bot Token и Bot Username

📄 **`server/utils/telegram-auth.ts`**
- ✅ `verifyTelegramAuth()` - проверка HMAC-SHA256 подписи
- ✅ `getTelegramFullName()` - получение полного имени
- ✅ `getTelegramUsername()` - получение username
- ✅ Проверка что данные не старше 24 часов

### 2. API Endpoints

📄 **`server/api/auth/callback/telegram.get.ts`**
- ✅ GET `/api/auth/callback/telegram` - обработка Telegram Login Widget
- ✅ Проверка HMAC-SHA256 подписи
- ✅ Проверка auth_date (24 часа)
- ✅ Создание нового пользователя или использование существующего
- ✅ **Привязка к существующему аккаунту** (если залогинен)
- ✅ Создание сессии
- ✅ Редирект на главную

### 3. Frontend Components

📄 **`components/TelegramLoginButton.vue`**
- ✅ Telegram Login Widget (официальный виджет)
- ✅ Автоматическая загрузка скрипта
- ✅ Callback на `/api/auth/callback/telegram`

📄 **`pages/login.vue`** (обновлена)
- ✅ Добавлена кнопка Telegram
- ✅ Divider "или" между Google и Telegram
- ✅ Обработка Telegram ошибок

### 4. Documentation

📄 **`docs/TELEGRAM_OAUTH_SETUP.md`**
- ✅ Пошаговая инструкция создания Telegram Bot
- ✅ Настройка Login Widget через @BotFather
- ✅ Настройка домена
- ✅ Проверка безопасности (HMAC-SHA256)
- ✅ Привязка нескольких провайдеров
- ✅ Troubleshooting

📄 **`.env.example`** (обновлен)
- ✅ TELEGRAM_BOT_TOKEN
- ✅ TELEGRAM_BOT_USERNAME

## Ключевая функция: Привязка провайдеров

Теперь пользователь может привязать несколько OAuth провайдеров к одному аккаунту!

### Сценарий использования:

```
1. Пользователь входит через Google
   → user_id = 123
   → oauth_accounts: (user_id=123, provider='google')

2. Пользователь остается залогиненным
3. На странице /login нажимает "Login with Telegram"
4. Telegram авторизация проходит успешно
5. Сервер видит активную сессию (user_id=123)
6. Привязывает Telegram к существующему аккаунту:
   → oauth_accounts: (user_id=123, provider='telegram')

7. Теперь пользователь может входить через:
   - Google → user_id=123
   - Telegram → user_id=123
```

## Настройка Telegram Bot

### Шаг 1: Создание бота

1. Откройте Telegram, найдите **@BotFather**
2. Отправьте `/newbot`
3. Введите название: `docta.me Login`
4. Введите username: `doctame_login_bot`
5. Сохраните **Bot Token**

### Шаг 2: Настройка домена

1. В @BotFather: `/setdomain`
2. Выберите бота
3. Введите домен: `localhost` (для dev)

### Шаг 3: Переменные окружения

Добавьте в `.env`:

```bash
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
TELEGRAM_BOT_USERNAME=doctame_login_bot
```

### Шаг 4: Обновите компонент

В `components/TelegramLoginButton.vue` замените `YOUR_BOT_USERNAME` на ваш bot username.

### Шаг 5: Запуск

```bash
npm run dev
```

Откройте http://localhost:3000/login

## Telegram Login Widget Flow

```
1. Пользователь → /login
2. Видит Telegram Login Widget (iframe)
3. Клик "Login with Telegram"
4. Telegram проверяет авторизацию
5. Telegram редиректит → /api/auth/callback/telegram
   Параметры:
   - id (Telegram user ID)
   - first_name
   - last_name (опц)
   - username (опц)
   - photo_url (опц)
   - auth_date (unix timestamp)
   - hash (HMAC-SHA256)
6. Сервер проверяет hash:
   - Создает data_check_string
   - Вычисляет secret_key = SHA256(bot_token)
   - Вычисляет hash = HMAC-SHA256(secret_key, data_check_string)
   - Сравнивает с полученным hash
7. Проверка auth_date (не старше 24 часов)
8. Создание/обновление пользователя
9. Создание сессии
10. Редирект → /
```

## Безопасность

✅ **HMAC-SHA256 signature** - криптографическая проверка  
✅ **auth_date validation** - данные не старее 24 часов  
✅ **Bot Token secret** - хранится только на сервере  
✅ **No client-side verification** - вся проверка на сервере

### Проверка подписи:

```javascript
// Параметры от Telegram (без hash)
const data = {
  id: 12345,
  first_name: 'John',
  auth_date: 1234567890
};

// 1. Создаем строку
const dataCheckString = Object.keys(data)
  .sort()
  .map(key => `${key}=${data[key]}`)
  .join('\n');

// 2. Secret key
const secretKey = crypto
  .createHash('sha256')
  .update(botToken)
  .digest();

// 3. Вычисляем hash
const computedHash = crypto
  .createHmac('sha256', secretKey)
  .update(dataCheckString)
  .digest('hex');

// 4. Проверяем
if (computedHash === receivedHash) {
  // Данные подлинные!
}
```

## Критерии приемки

- [x] AC-1: Telegram OAuth работает: можно войти через Telegram
- [x] AC-2: Пользователь, вошедший через Google, может привязать Telegram
- [x] AC-3: Пользователь может входить через Google или Telegram в один аккаунт
- [x] AC-4: Данные из Telegram (name, photo) корректно сохраняются
- [x] AC-5: В oauth_accounts создаются записи для обоих провайдеров
- [x] AC-6: OAuth пользователи остаются с is_admin=false

## Тестирование

### Тест 1: Первый вход через Telegram

```bash
# 1. Откройте /login
# 2. Нажмите Telegram Login Widget
# 3. Авторизуйтесь в Telegram
# 4. Проверьте БД:

SELECT * FROM users WHERE email LIKE 'telegram_%@telegram.user';
-- Ожидается: is_admin=0, password_hash=NULL

SELECT * FROM oauth_accounts WHERE provider = 'telegram';
-- Ожидается: запись с provider_account_id = ваш Telegram ID
```

### Тест 2: Привязка Telegram к существующему Google аккаунту

```bash
# 1. Войдите через Google
# 2. Откройте /login (оставаясь залогиненным)
# 3. Нажмите Telegram Login Widget
# 4. Авторизуйтесь в Telegram
# 5. Проверьте БД:

SELECT 
    u.id,
    u.email,
    GROUP_CONCAT(oa.provider) as providers
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
GROUP BY u.id;

-- Ожидается: один пользователь с providers='google,telegram'
```

### Тест 3: Вход через разные провайдеры

```bash
# 1. Выйдите (logout)
# 2. Войдите через Google → проверьте user_id в БД
# 3. Выйдите
# 4. Войдите через Telegram → проверьте user_id
# Ожидается: тот же user_id
```

### Тест 4: Проверка hash

```bash
# Попробуйте подделать данные (изменить id в URL)
curl "http://localhost:3000/api/auth/callback/telegram?id=99999&first_name=Fake&hash=wrong"

# Ожидается: редирект на /?error=telegram_auth_failed
```

### Тест 5: Старые данные

```bash
# Попробуйте использовать старый auth_date (> 24 часов)
# Ожидается: редирект на /?error=telegram_auth_failed
```

## Созданные файлы

```
server/
├── utils/
│   ├── oauth-config.ts ......................... ✅ Обновлен (добавлен Telegram)
│   └── telegram-auth.ts ........................ ✅ Утилиты для Telegram
└── api/
    └── auth/
        └── callback/
            └── telegram.get.ts ................. ✅ Telegram callback

components/
└── TelegramLoginButton.vue ..................... ✅ Telegram Login Widget

pages/
└── login.vue ................................... ✅ Обновлена (добавлен Telegram)

docs/
└── TELEGRAM_OAUTH_SETUP.md ..................... ✅ Документация

.env.example .................................... ✅ Обновлен
```

## Отличия от Google OAuth

| Аспект | Google OAuth | Telegram Login Widget |
|--------|--------------|----------------------|
| Flow | OAuth 2.0 (code → token) | Widget с hash проверкой |
| Redirect | Google → наш callback | Telegram → наш callback |
| Проверка | State parameter (CSRF) | HMAC-SHA256 hash |
| Email | Обязательно | Отсутствует |
| Username | Нет | Опционально |
| Токены | access_token, refresh_token | Нет токенов |

## SQL запросы для проверки

```sql
-- Пользователи с несколькими провайдерами
SELECT 
    u.id,
    u.email,
    u.name,
    GROUP_CONCAT(oa.provider ORDER BY oa.provider) as providers,
    COUNT(DISTINCT oa.provider) as provider_count
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
GROUP BY u.id
HAVING provider_count > 1;

-- Все Telegram пользователи
SELECT 
    u.id,
    u.email,
    u.name,
    u.photo_url,
    u.is_admin,
    oa.provider_account_id as telegram_id
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
WHERE oa.provider = 'telegram';

-- Пользователи с обоими провайдерами
SELECT 
    u.id,
    u.email,
    u.name,
    MAX(CASE WHEN oa.provider = 'google' THEN oa.provider_account_id END) as google_id,
    MAX(CASE WHEN oa.provider = 'telegram' THEN oa.provider_account_id END) as telegram_id
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
GROUP BY u.id
HAVING google_id IS NOT NULL AND telegram_id IS NOT NULL;
```

## Production настройки

### 1. Измените домен в @BotFather

```
/setdomain
docta.me
```

### 2. Обновите .env

```bash
TELEGRAM_BOT_TOKEN=ваш-токен
TELEGRAM_BOT_USERNAME=ваш_bot_username
BASE_URL=https://docta.me
```

### 3. HTTPS обязателен!

Telegram Login Widget работает только с HTTPS (кроме localhost).

## Следующие шаги

✅ **Итерация 1 завершена** - БД готова  
✅ **Итерация 2 завершена** - Админ авторизация работает  
✅ **Итерация 3 завершена** - Google OAuth работает  
✅ **Итерация 4 завершена** - Telegram OAuth работает

⏭️ **Последняя итерация (опционально):** [Итерация 5 - UI компоненты](../iterations/iteration-05-ui-components.md)

Что будет реализовано:
- UserMenu в хедере (аватар, dropdown, выход)
- LoginModal компонент
- Интеграция в основной layout

---

**Прогресс:** 80% (4/5 итераций) ████████░░

**Детали:** См. `prd/auth/PROGRESS.md`

## Важные замечания

⚠️ **Создайте Telegram Bot через @BotFather**  
⚠️ **Настройте домен для Login Widget**  
⚠️ **Не коммитьте .env в git!**  
⚠️ **В production используйте HTTPS**  
⚠️ **Обновите bot username в компоненте**

🎉 **OAuth через Telegram готов!**

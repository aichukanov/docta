# Настройка Telegram OAuth (Login Widget)

## Шаг 1: Создание Telegram Bot

1. Откройте Telegram и найдите бота **@BotFather**
2. Отправьте команду `/newbot`
3. Введите название бота (например: `docta.me Login`)
4. Введите username бота (например: `doctame_login_bot`)
   - Username должен заканчиваться на `_bot` или `Bot`
5. BotFather пришлет вам **Bot Token** - сохраните его!

**Пример:**
```
Use this token to access the HTTP API:
1234567890:ABCdefGHIjklMNOpqrsTUVwxyz1234567890

Keep your token secure and store it safely, it can be used by anyone to control your bot.
```

## Шаг 2: Настройка Login Widget

1. В чате с @BotFather отправьте команду `/setdomain`
2. Выберите вашего бота
3. Введите домен для авторизации:
   - Для разработки: `localhost`
   - Для production: `docta.me`

**Важно:** Можно указать только один домен. Для production нужно будет изменить на `docta.me`.

### Альтернатива: несколько доменов

Если нужно поддерживать и localhost, и production:
- Создайте 2 бота (один для dev, другой для prod)
- Или используйте туннель (ngrok) для локальной разработки

## Шаг 3: Настройка переменных окружения

Добавьте в `.env`:

```bash
# OAuth Telegram
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz1234567890
TELEGRAM_BOT_USERNAME=doctame_login_bot
```

**Важно:**
- `TELEGRAM_BOT_TOKEN` - токен от @BotFather
- `TELEGRAM_BOT_USERNAME` - username бота (без @)

## Шаг 4: Обновление компонента

Откройте `components/TelegramLoginButton.vue` и замените `YOUR_BOT_USERNAME`:

```vue
<script
  async
  src="https://telegram.org/js/telegram-widget.js?22"
  data-telegram-login="doctame_login_bot"  <!-- Ваш bot username -->
  data-size="large"
  data-auth-url="/api/auth/callback/telegram"
  data-request-access="write"
></script>
```

## Шаг 5: Проверка работы

1. Запустите dev сервер: `npm run dev`
2. Откройте `http://localhost:3000/login`
3. Нажмите на Telegram Login Widget
4. Авторизуйтесь в Telegram (если еще не авторизованы)
5. Нажмите "Accept" для предоставления доступа
6. Проверьте создание записей в БД:

```sql
-- Проверить Telegram пользователя
SELECT u.*, oa.provider, oa.provider_account_id
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
WHERE oa.provider = 'telegram';

-- Проверить что is_admin=false и password_hash=NULL
SELECT id, email, is_admin, password_hash
FROM users
WHERE id IN (SELECT user_id FROM oauth_accounts WHERE provider = 'telegram');
```

## Как работает Telegram Login Widget

### Flow авторизации:

```
1. Пользователь → /login
2. Видит Telegram Login Widget (iframe от Telegram)
3. Клик на "Login with Telegram"
4. Telegram проверяет авторизацию в приложении
5. Telegram редиректит → /api/auth/callback/telegram?id=XXX&first_name=YYY&hash=ZZZ
6. Сервер проверяет hash (crypto signature)
7. Проверка что данные не старше 24 часов
8. Создание/обновление пользователя в БД
9. Создание сессии
10. Редирект → /
```

### Параметры от Telegram:

- `id` - Telegram user ID
- `first_name` - Имя
- `last_name` - Фамилия (опционально)
- `username` - Username (опционально)
- `photo_url` - URL аватара (опционально)
- `auth_date` - Unix timestamp
- `hash` - HMAC-SHA256 подпись для проверки

## Безопасность

✅ **Проверка hash** - защита от подделки данных  
✅ **Проверка auth_date** - данные не старше 24 часов  
✅ **HMAC-SHA256** - криптографическая подпись  
✅ **Bot Token в secret** - токен хранится только на сервере

### Как проверяется hash:

```javascript
// 1. Создаем строку из параметров (без hash)
data_check_string = "auth_date=...\nfirst_name=...\nid=...\n..."

// 2. Создаем secret key из bot token
secret_key = SHA256(bot_token)

// 3. Вычисляем hash
computed_hash = HMAC-SHA256(secret_key, data_check_string)

// 4. Сравниваем с полученным hash
if (computed_hash === hash) {
  // Данные подлинные
}
```

## Привязка нескольких провайдеров

Пользователь может привязать и Google, и Telegram к одному аккаунту:

### Сценарий 1: Сначала Google, потом Telegram

```
1. Пользователь входит через Google
2. user_id = 123, email = user@gmail.com
3. Запись в oauth_accounts: (user_id=123, provider='google')
4. Пользователь нажимает "Привязать Telegram"
5. Telegram авторизация с активной сессией
6. Добавляется запись: (user_id=123, provider='telegram')
7. Теперь можно входить через любой из провайдеров
```

### Сценарий 2: Сначала Telegram, потом Google

```
1. Пользователь входит через Telegram
2. user_id = 456, email = telegram_12345@telegram.user
3. Пользователь входит через Google с тем же email?
   - Если email совпадает → привязка к существующему user_id
   - Если email разный → создание нового пользователя
```

## Production настройки

### 1. Измените домен в @BotFather

```
/setdomain
docta.me
```

### 2. Обновите .env для production

```bash
TELEGRAM_BOT_TOKEN=ваш-токен
TELEGRAM_BOT_USERNAME=ваш_bot_username
BASE_URL=https://docta.me
```

### 3. HTTPS обязателен!

Telegram Login Widget работает только с HTTPS (кроме localhost).

## Troubleshooting

### "Bot domain invalid"

Проверьте:
- Домен настроен в @BotFather через `/setdomain`
- Используете правильный домен (localhost или docta.me)
- В production используете HTTPS

### "Authentication failed"

Проверьте:
- `TELEGRAM_BOT_TOKEN` правильный
- Hash проверяется корректно
- Время на сервере синхронизировано (NTP)

### "User data not saved"

Проверьте БД:
```sql
SELECT * FROM oauth_accounts WHERE provider = 'telegram';
```

Если записи нет - проверьте логи сервера.

### Widget не отображается

Проверьте:
- Скрипт загружается: https://telegram.org/js/telegram-widget.js
- `data-telegram-login` указан правильный username
- Bot существует и активен

## Полезные ссылки

- [Telegram Login Widget Documentation](https://core.telegram.org/widgets/login)
- [BotFather Commands](https://core.telegram.org/bots#botfather)
- [Telegram Bot API](https://core.telegram.org/bots/api)

## SQL запросы для проверки

```sql
-- Пользователь с обоими провайдерами
SELECT 
    u.id,
    u.email,
    u.name,
    GROUP_CONCAT(oa.provider) as providers
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
GROUP BY u.id
HAVING COUNT(DISTINCT oa.provider) > 1;

-- Все OAuth аккаунты пользователя
SELECT 
    u.email,
    u.name,
    oa.provider,
    oa.provider_account_id
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
ORDER BY u.id, oa.provider;
```

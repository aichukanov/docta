# Переключение между dev и production ботами

## Настройка для локальной разработки (localhost)

### В .env используйте:

```bash
# OAuth Telegram (для локальной разработки)
TELEGRAM_BOT_TOKEN=8397397653:AAHBVRF4FbmSno-BYxLznW64bYJeoUYVTac
TELEGRAM_BOT_USERNAME=docta_localhost_login_bot
BASE_URL=http://localhost:3000
```

### В @BotFather настройте домен:

```
/setdomain
docta_localhost_login_bot
localhost
```

### В компоненте:

`components/TelegramLoginButton.vue` должен иметь:
```html
data-telegram-login="docta_localhost_login_bot"
```

---

## Настройка для production (docta.me)

### В .env используйте:

```bash
# OAuth Telegram (для production)
TELEGRAM_BOT_TOKEN=8176462434:AAEDTmNNVQtqUG0i2QXKZuJCD4JM4p7V6hw
TELEGRAM_BOT_USERNAME=doctame_login_bot
BASE_URL=https://docta.me
```

### В @BotFather настройте домен:

```
/setdomain
doctame_login_bot
docta.me
```

### В компоненте:

`components/TelegramLoginButton.vue` должен иметь:
```html
data-telegram-login="doctame_login_bot"
```

---

## Текущая настройка

✅ **Локальная разработка готова:**
- Bot: `docta_localhost_login_bot`
- Token: `8397397653:AAHBVRF4FbmSno-BYxLznW64bYJeoUYVTac`
- Domain: `localhost` (нужно настроить в @BotFather)

✅ **Production готов:**
- Bot: `doctame_login_bot`
- Token: `8176462434:AAEDTmNNVQtqUG0i2QXKZuJCD4JM4p7V6hw`
- Domain: `docta.me` (нужно настроить в @BotFather)

---

## Следующие шаги

### 1. Настройте домен для локального бота

Откройте Telegram, найдите @BotFather:

```
/setdomain
→ Выберите: docta_localhost_login_bot
→ Введите: localhost
```

### 2. Настройте домен для production бота

```
/setdomain
→ Выберите: doctame_login_bot
→ Введите: docta.me
```

### 3. Проверьте локально

```bash
npm run dev
```

Откройте http://localhost:3000/login

### 4. Для деплоя на production

1. Измените `.env` на сервере:
   ```bash
   TELEGRAM_BOT_TOKEN=8176462434:AAEDTmNNVQtqUG0i2QXKZuJCD4JM4p7V6hw
   TELEGRAM_BOT_USERNAME=doctame_login_bot
   BASE_URL=https://docta.me
   ```

2. Измените в `components/TelegramLoginButton.vue`:
   ```html
   data-telegram-login="doctame_login_bot"
   ```

3. Деплой!

---

## Альтернатива: Динамический выбор бота

Если хотите автоматическое переключение, используйте `TelegramLoginButtonDynamic.vue`:

```vue
<TelegramLoginButtonDynamic />
```

Этот компонент автоматически выбирает:
- `docta_localhost_login_bot` для dev
- `doctame_login_bot` для production

Просто замените в `pages/login.vue`:
```vue
<TelegramLoginButtonDynamic />
```
вместо
```vue
<TelegramLoginButton />
```

---

## Troubleshooting

### "Bot domain invalid" в localhost

Проверьте что в @BotFather настроен домен `localhost` для `docta_localhost_login_bot`.

### "Bot domain invalid" в production

Проверьте что:
1. Домен `docta.me` настроен в @BotFather для `doctame_login_bot`
2. Используется HTTPS (обязательно для production)
3. В `.env` правильный `TELEGRAM_BOT_USERNAME`

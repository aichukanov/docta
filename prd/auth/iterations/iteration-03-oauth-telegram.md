# Итерация 3: OAuth через Telegram

[← К списку итераций](README.md) | [← Предыдущая](iteration-02-oauth-google.md) | [Следующая →](iteration-04-ui-components.md)

---

## Цель

Добавить возможность входа через Telegram.

## Зависимости

Итерация 2 (базовая OAuth инфраструктура готова)

## Задачи

1. Создать Telegram Bot и получить bot token
2. Реализовать Telegram Login Widget provider
3. Добавить обработку Telegram OAuth callback
4. Поддержка привязки нескольких провайдеров к одному аккаунту (merge)

## Ключевые компоненты

- `server/utils/telegram-provider.ts` - custom provider для Telegram
- Обновление `server/api/auth/[...].ts` для поддержки Telegram
- `.env` - TELEGRAM_BOT_TOKEN

## Критерии приемки

- [ ] AC-1: Telegram OAuth работает: можно войти через Telegram
- [ ] AC-2: Пользователь, вошедший через Google, может привязать Telegram к тому же аккаунту
- [ ] AC-3: Пользователь может войти как через Google, так и через Telegram в один аккаунт
- [ ] AC-4: Данные пользователя из Telegram (name, photo) корректно сохраняются
- [ ] AC-5: В таблице oauth_accounts создаются записи для обоих провайдеров

## Как проверить

1. Создать аккаунт через Google
2. Войти в профиль, попробовать привязать Telegram
3. Выйти и войти через Telegram - должен использоваться тот же user_id
4. Проверить БД: должно быть 2 записи oauth_accounts с provider='google' и 'telegram'

## Статус

**Not Started**

---

**Следующая итерация:** [4. UI компоненты →](iteration-04-ui-components.md)

# Итерация 2: OAuth через Google

[← К списку итераций](README.md) | [← Предыдущая](iteration-01-database.md) | [Следующая →](iteration-03-oauth-telegram.md)

---

## Цель

Настроить OAuth авторизацию через Google и базовую инфраструктуру для будущих провайдеров.

## Зависимости

Итерация 1 (таблицы users, oauth_accounts, sessions должны существовать)

## Задачи

1. Установить `@sidebase/nuxt-auth` или альтернативу
2. Настроить Google OAuth (получить credentials, настроить callback)
3. Создать custom adapter для работы с MySQL
4. Настроить session management
5. Создать базовые API endpoints для auth

## Ключевые файлы

- `nuxt.config.ts` - конфигурация nuxt-auth
- `server/api/auth/[...].ts` - OAuth handler
- `server/utils/auth-adapter.ts` - custom MySQL adapter
- `.env` - переменные окружения (AUTH_SECRET, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)

## Критерии приемки

- [ ] AC-1: Google OAuth работает: можно войти и создается пользователь в БД
- [ ] AC-2: При повторном входе через Google используется существующий пользователь
- [ ] AC-3: Сессия сохраняется в БД и работает корректно
- [ ] AC-4: После входа пользователь редиректится на главную страницу
- [ ] AC-5: Данные пользователя (email, name, photo) корректно сохраняются
- [ ] AC-6: В таблице oauth_accounts создается запись с provider='google'

## Как проверить

1. Запустить dev сервер: `npm run dev`
2. Открыть `/api/auth/signin`
3. Нажать "Sign in with Google"
4. Пройти OAuth flow
5. Проверить создание записей в БД (users, oauth_accounts, sessions)
6. Проверить что после logout и повторного login используется тот же user_id

## Статус

**Not Started**

---

**Следующая итерация:** [3. OAuth через Telegram →](iteration-03-oauth-telegram.md)

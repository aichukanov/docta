# Facebook OAuth Integration 🎯

> Полная интеграция Facebook OAuth для docta.me платформы

[![Status](https://img.shields.io/badge/status-ready-success.svg)]()
[![Version](https://img.shields.io/badge/version-1.0-blue.svg)]()
[![Facebook API](https://img.shields.io/badge/Facebook%20API-v18.0-blue.svg)]()

---

## 🚀 Быстрый старт

Нужно быстро запустить? Следуйте этому руководству:

👉 **[FACEBOOK_OAUTH_QUICKSTART.md](./FACEBOOK_OAUTH_QUICKSTART.md)** - 6 шагов за 15 минут

---

## 📚 Документация

### Для разработчиков

| Документ | Описание | Когда использовать |
|----------|----------|-------------------|
| **[Быстрый старт](./FACEBOOK_OAUTH_QUICKSTART.md)** | Краткая инструкция для запуска | Первый раз настраиваете |
| **[Полное руководство](./FACEBOOK_OAUTH_SETUP.md)** | Детальная настройка Facebook App | Нужны подробности настройки |
| **[Архитектура](./FACEBOOK_OAUTH_ARCHITECTURE.md)** | Схемы, потоки данных, структура | Нужно понять как работает |
| **[Реализация](./FACEBOOK_OAUTH_IMPLEMENTATION.md)** | Что добавлено, детали кода | Обзор всех изменений |
| **[Чеклист](./FACEBOOK_OAUTH_CHECKLIST.md)** | Список всех задач и статусов | Проверка завершенности |

### Для продакт-менеджеров

| Документ | Описание |
|----------|----------|
| **[PRD Итерация 6](../prd/auth/iterations/iteration-06-oauth-facebook.md)** | Требования, критерии приемки |
| **[PRD Главный](../prd/auth/index.md)** | Общий контекст системы авторизации |

---

## ✨ Что это дает

### Для пользователей

- ✅ Быстрый вход через Facebook (2 клика)
- ✅ Не нужно запоминать пароль
- ✅ Автоматический импорт имени и фото
- ✅ Один аккаунт для всех OAuth провайдеров

### Для бизнеса

- ✅ Снижение барьера входа → больше регистраций
- ✅ Доверие к платформе (узнаваемый Facebook)
- ✅ Меньше запросов на восстановление пароля
- ✅ Данные пользователей уже верифицированы Facebook

### Для разработки

- ✅ Готовая инфраструктура для других OAuth
- ✅ Консистентный код с Google/Telegram
- ✅ Полная документация
- ✅ Тестовые сценарии

---

## 🎯 Основные фичи

```
✅ Полный OAuth 2.0 flow
✅ CSRF защита (state parameter)
✅ Привязка к существующим аккаунтам по email
✅ Хранение полного профиля Facebook
✅ История входов
✅ Session management
✅ Error handling и user-friendly сообщения
✅ Responsive UI (mobile + desktop)
✅ HTTPS ready для продакшена
```

---

## 🏗️ Архитектура (кратко)

```
User → Facebook Login Button
     → /api/auth/facebook (generate state)
     → Facebook OAuth Dialog
     → /api/auth/callback/facebook (exchange code → token)
     → Get user profile
     → Create/update user + OAuth account + Facebook profile
     → Create session
     → Redirect to home
```

**Детали**: [FACEBOOK_OAUTH_ARCHITECTURE.md](./FACEBOOK_OAUTH_ARCHITECTURE.md)

---

## 📦 Что включено

### Backend (5 файлов)

- `server/api/auth/facebook.get.ts` - OAuth initiation
- `server/api/auth/callback/facebook.get.ts` - OAuth callback handler
- `server/utils/oauth-config.ts` - Configuration (updated)
- `server/utils/oauth-profiles.ts` - Facebook profiles (updated)
- `server/sql/migrations/006_facebook_oauth_profiles.sql` - Database migration

### Frontend (2 файла)

- `components/FacebookLoginButton.vue` - UI button component
- `pages/login.vue` - Login page (updated)

### Документация (5 файлов)

- Все файлы в `docs/` с префиксом `FACEBOOK_OAUTH_*`
- PRD итерация 6

**Полный список**: [FACEBOOK_OAUTH_CHECKLIST.md](./FACEBOOK_OAUTH_CHECKLIST.md)

---

## 🔐 Безопасность

### Реализовано

- ✅ State parameter для CSRF защиты
- ✅ App Secret хранится в .env (не в коде)
- ✅ Secure cookies (httpOnly, sameSite)
- ✅ Минимальные разрешения (email, public_profile)
- ✅ HTTPS support для продакшена
- ✅ Input validation
- ✅ Error handling без утечки sensitive данных

### Best Practices

```env
# ✅ Правильно: разные credentials для окружений
# Development
FACEBOOK_APP_ID=123456789_dev
FACEBOOK_APP_SECRET=secret_dev

# Production (на сервере)
FACEBOOK_APP_ID=987654321_prod
FACEBOOK_APP_SECRET=secret_prod
```

```bash
# ❌ Неправильно: не коммитить
git add .env

# ✅ Правильно: .env в .gitignore
echo ".env" >> .gitignore
```

---

## 🧪 Тестирование

### Быстрый тест

```bash
# 1. Настроить .env
FACEBOOK_APP_ID=your_id
FACEBOOK_APP_SECRET=your_secret

# 2. Применить миграцию
mysql -u root -p docta_me < server/sql/migrations/006_facebook_oauth_profiles.sql

# 3. Запустить
npm run dev

# 4. Открыть
http://localhost:3000/login

# 5. Нажать "Войти через Facebook"
```

### Тестовые сценарии

- ✅ Новый пользователь
- ✅ Существующий пользователь (по email)
- ✅ Повторный вход
- ✅ Привязка к залогиненному аккаунту
- ✅ Отмена на Facebook
- ✅ Email не предоставлен
- ✅ Ошибки сети

**Детали**: [FACEBOOK_OAUTH_IMPLEMENTATION.md](./FACEBOOK_OAUTH_IMPLEMENTATION.md#тестирование)

---

## 🚢 Деплой на продакшн

### Чеклист перед деплоем

```
[ ] Создан отдельный Facebook App для продакшена
[ ] Добавлены продакшн redirect URIs
[ ] FACEBOOK_APP_ID и FACEBOOK_APP_SECRET на сервере
[ ] Применена миграция БД на проде
[ ] HTTPS настроен и работает
[ ] BASE_URL в .env указывает на продакшн домен
[ ] Facebook App прошел App Review
[ ] Facebook App переключен в Live mode
[ ] Privacy Policy опубликован
[ ] Terms of Service опубликованы
[ ] Monitoring настроен
[ ] Протестировано на проде
```

**Подробнее**: [FACEBOOK_OAUTH_SETUP.md](./FACEBOOK_OAUTH_SETUP.md#публикация-приложения)

---

## 📊 Мониторинг

### Ключевые метрики

```sql
-- Количество пользователей с Facebook
SELECT COUNT(*) 
FROM auth_oauth_accounts 
WHERE provider = 'facebook';

-- Входы за последние 7 дней
SELECT DATE(created_at) as date, COUNT(*) as logins
FROM auth_login_history
WHERE provider = 'facebook' 
  AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
GROUP BY DATE(created_at);

-- Пользователи с несколькими провайдерами
SELECT COUNT(*) 
FROM (
  SELECT user_id 
  FROM auth_oauth_accounts 
  GROUP BY user_id 
  HAVING COUNT(DISTINCT provider) > 1
) as multi_oauth;
```

---

## 🐛 Troubleshooting

### Частые проблемы

| Проблема | Решение |
|----------|---------|
| "URL Blocked" | Проверьте Valid OAuth Redirect URIs в Facebook App |
| "App Not Set Up" | Добавьте Platform (Website) в настройках |
| "email_not_provided" | Пользователь без email - попросите войти другим способом |
| Работает на localhost, не работает на проде | Проверьте HTTPS, redirect URIs, App Mode (Live) |

**Полный список**: [FACEBOOK_OAUTH_SETUP.md](./FACEBOOK_OAUTH_SETUP.md#troubleshooting)

---

## 🔮 Roadmap

### Ближайшие улучшения

- [ ] Long-lived tokens (автопродление)
- [ ] Расширенный профиль (birthday, location)
- [ ] Страница управления OAuth аккаунтами
- [ ] Отвязка Facebook аккаунта

### Будущие фичи

- [ ] Больше OAuth провайдеров (GitHub, Apple, VK)
- [ ] Facebook Login Analytics
- [ ] Import friends from Facebook
- [ ] Share to Facebook

**Детали**: [FACEBOOK_OAUTH_ARCHITECTURE.md](./FACEBOOK_OAUTH_ARCHITECTURE.md#будущие-расширения)

---

## 📈 Статистика проекта

```
Время разработки:  ~2 часа
Строк кода:        ~600 (backend + frontend)
Строк документации: ~800
Новых файлов:      8
Обновленных файлов: 4
Тестовых сценариев: 7
```

---

## 🤝 Поддержка

### Если что-то не работает

1. Проверьте [Troubleshooting](./FACEBOOK_OAUTH_SETUP.md#troubleshooting)
2. Изучите [Архитектуру](./FACEBOOK_OAUTH_ARCHITECTURE.md)
3. Проверьте [Чеклист](./FACEBOOK_OAUTH_CHECKLIST.md)

### Полезные ссылки

- [Facebook for Developers](https://developers.facebook.com/)
- [Facebook Login Docs](https://developers.facebook.com/docs/facebook-login/)
- [Graph API Reference](https://developers.facebook.com/docs/graph-api/)
- [App Review Guidelines](https://developers.facebook.com/docs/app-review/)

---

## 📝 Changelog

### Version 1.0 (2026-01-31)

- ✅ Initial Facebook OAuth implementation
- ✅ Full documentation suite
- ✅ Database migration
- ✅ UI components
- ✅ Security measures
- ✅ Error handling
- ✅ Testing scenarios

---

## 📄 Лицензия

Часть проекта docta.me. Все права защищены.

---

## 🎉 Готово к использованию!

Интеграция Facebook OAuth полностью завершена и готова к использованию.

Начните с [Быстрого старта](./FACEBOOK_OAUTH_QUICKSTART.md) 🚀

---

**Документ**: README для Facebook OAuth  
**Версия**: 1.0  
**Дата**: 31 января 2026  
**Статус**: ✅ Production Ready

# Итерация 6: OAuth через Facebook

[← К списку итераций](README.md) | [← Предыдущая](iteration-05-ui-components.md)

---

## Цель

Настроить OAuth авторизацию через Facebook для обычных пользователей, добавив третий способ входа наряду с Google и Telegram.

## Зависимости

- Итерация 1 (таблицы users, oauth_accounts, sessions должны существовать)
- Итерация 3 (базовая OAuth инфраструктура готова)
- Итерация 4 (утилиты для OAuth профилей созданы)

## Задачи

1. Создать Facebook App и получить App ID и App Secret
2. Добавить конфигурацию Facebook OAuth
3. Создать API endpoints для Facebook OAuth flow
4. Создать компонент кнопки входа через Facebook
5. Добавить таблицу для хранения Facebook профилей
6. Обновить страницу логина
7. Обновить документацию

## Ключевые файлы

### Backend

- `server/utils/oauth-config.ts` - конфигурация OAuth провайдеров (добавлен Facebook)
- `server/api/auth/facebook.get.ts` - инициация Facebook OAuth flow
- `server/api/auth/callback/facebook.get.ts` - обработка callback от Facebook
- `server/utils/oauth-profiles.ts` - утилиты для работы с Facebook профилями
- `server/sql/migrations/006_facebook_oauth_profiles.sql` - миграция БД

### Frontend

- `components/FacebookLoginButton.vue` - кнопка входа через Facebook
- `pages/login.vue` - обновлена страница логина

### Документация

- `docs/FACEBOOK_OAUTH_SETUP.md` - руководство по настройке Facebook OAuth

### Переменные окружения

```env
FACEBOOK_APP_ID=your_app_id
FACEBOOK_APP_SECRET=your_app_secret
BASE_URL=http://localhost:3000  # или ваш продакшн URL
```

## Критерии приемки

- [ ] AC-1: Facebook OAuth работает: можно войти и создается пользователь в БД
- [ ] AC-2: При повторном входе через Facebook используется существующий пользователь
- [ ] AC-3: Если пользователь с таким email уже существует, Facebook аккаунт привязывается к нему
- [ ] AC-4: Сессия создается корректно после Facebook входа
- [ ] AC-5: Данные пользователя (email, name, photo) корректно сохраняются
- [ ] AC-6: В таблице auth_oauth_accounts создается запись с provider='facebook'
- [ ] AC-7: В таблице auth_oauth_profiles_facebook сохраняется полный профиль
- [ ] AC-8: OAuth пользователи имеют is_admin=false и password_hash=NULL
- [ ] AC-9: Кнопка "Войти через Facebook" отображается на странице /login
- [ ] AC-10: История входов записывается с provider='facebook'

## Как проверить

### 1. Настройка Facebook App

1. Следуйте инструкциям в `docs/FACEBOOK_OAUTH_SETUP.md`
2. Получите FACEBOOK_APP_ID и FACEBOOK_APP_SECRET
3. Добавьте их в `.env`

### 2. Применение миграции

```bash
mysql -u your_user -p your_database < server/sql/migrations/006_facebook_oauth_profiles.sql
```

### 3. Локальное тестирование

1. Запустить dev сервер: `npm run dev`
2. Открыть `/login`
3. Нажать "Войти через Facebook"
4. Пройти OAuth flow
5. Проверить создание записей в БД:

```sql
-- Пользователь
SELECT * FROM auth_users WHERE email = 'your_email@example.com';

-- OAuth аккаунт
SELECT * FROM auth_oauth_accounts WHERE provider = 'facebook';

-- Facebook профиль
SELECT * FROM auth_oauth_profiles_facebook;

-- Сессия
SELECT * FROM auth_sessions WHERE user_id = YOUR_USER_ID;

-- История входов
SELECT * FROM auth_login_history WHERE provider = 'facebook';
```

6. Убедиться что `is_admin=false` и `password_hash=NULL`
7. Выйти и войти снова - должен использоваться тот же user_id

### 4. Тест привязки к существующему пользователю

1. Создайте пользователя через Google с email test@example.com
2. Выйдите
3. Войдите через Facebook с тем же email test@example.com
4. Проверьте что user_id остался тот же
5. Проверьте что в auth_oauth_accounts две записи для одного user_id:
   - Одна с provider='google'
   - Одна с provider='facebook'

### 5. Тест ошибок

Проверьте обработку ошибок:
- Отмена на стороне Facebook (должен редирект на /?error=oauth_failed)
- Пользователь не предоставил email (должен редирект на /?error=email_not_provided)

## Технические детали

### Facebook OAuth Flow

1. Пользователь кликает "Войти через Facebook"
2. GET `/api/auth/facebook` - генерирует state, редиректит на Facebook
3. Facebook запрашивает разрешения: `email`, `public_profile`
4. После подтверждения Facebook редиректит на `/api/auth/callback/facebook?code=...&state=...`
5. Сервер обменивает code на access_token
6. Сервер запрашивает данные пользователя через Graph API
7. Создается/обновляется пользователь, OAuth аккаунт и профиль
8. Создается сессия
9. Редирект на главную страницу

### Структура данных Facebook

**Token Response:**
```typescript
{
  access_token: string;
  token_type: "bearer";
  expires_in: number; // секунды
}
```

**User Info:**
```typescript
{
  id: string;
  name: string;
  email?: string;
  picture?: {
    data: {
      url: string;
      width: number;
      height: number;
      is_silhouette: boolean;
    }
  }
}
```

### Таблица auth_oauth_profiles_facebook

```sql
CREATE TABLE auth_oauth_profiles_facebook (
    id INT PRIMARY KEY AUTO_INCREMENT,
    oauth_account_id INT NOT NULL,
    facebook_id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    picture_url TEXT,
    raw_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_oauth_account (oauth_account_id),
    UNIQUE KEY unique_facebook_id (facebook_id),
    FOREIGN KEY (oauth_account_id) REFERENCES auth_oauth_accounts(id) ON DELETE CASCADE
);
```

## Безопасность

1. **State parameter**: Защита от CSRF атак
2. **HTTPS требуется**: Facebook требует HTTPS для продакшен redirect URIs
3. **App Secret**: Никогда не коммитить в Git, хранить только в .env
4. **Scope минимальный**: Запрашиваем только email и public_profile
5. **Token истечение**: Facebook токены истекают через ~60 дней

## Известные ограничения

1. **Email может отсутствовать**: Если пользователь зарегистрирован через телефон или не подтвердил email
2. **Режим разработки**: По умолчанию Facebook App в dev режиме - нужно опубликовать для публичного использования
3. **Refresh tokens**: Facebook не возвращает refresh_token в базовом OAuth flow
4. **Rate limits**: Facebook имеет ограничения на количество запросов к API

## Следующие шаги

После завершения этой итерации:

1. Можно добавить больше OAuth провайдеров (GitHub, Apple, VK и т.д.)
2. Реализовать Long-lived tokens для Facebook
3. Добавить возможность отвязки OAuth аккаунтов
4. Реализовать объединение дубликатов пользователей

## Полезные ссылки

- [Facebook Login Documentation](https://developers.facebook.com/docs/facebook-login/)
- [Graph API Explorer](https://developers.facebook.com/tools/explorer/)
- [Facebook App Dashboard](https://developers.facebook.com/apps/)
- Внутренняя документация: [docs/FACEBOOK_OAUTH_SETUP.md](../../docs/FACEBOOK_OAUTH_SETUP.md)

---

**Статус**: ✅ Готово к разработке

**Оценка времени**: 2-3 часа

**Приоритет**: P1 (важно, но не критично)

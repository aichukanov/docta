# Настройка Google OAuth

## Шаг 1: Создание проекта в Google Cloud Console

1. Откройте [Google Cloud Console](https://console.cloud.google.com/)
2. Создайте новый проект или выберите существующий
3. Перейдите в раздел **APIs & Services** → **Credentials**

## Шаг 2: Настройка OAuth Consent Screen

1. Нажмите **OAuth consent screen** в боковом меню
2. Выберите **External** (для тестирования) или **Internal** (для организации)
3. Заполните обязательные поля:
   - **App name**: docta.me
   - **User support email**: ваш email
   - **Developer contact information**: ваш email
4. Добавьте необходимые scopes:
   - `openid`
   - `email`
   - `profile`
5. Нажмите **Save and Continue**

## Шаг 3: Создание OAuth Client ID

1. Перейдите в **Credentials** → **Create Credentials** → **OAuth client ID**
2. Выберите **Application type**: **Web application**
3. Заполните поля:
   - **Name**: docta.me Web App
   - **Authorized JavaScript origins**:
     - `http://localhost:3000` (для разработки)
     - `https://docta.me` (для production)
   - **Authorized redirect URIs**:
     - `http://localhost:3000/api/auth/callback/google` (для разработки)
     - `https://docta.me/api/auth/callback/google` (для production)
4. Нажмите **Create**
5. Скопируйте **Client ID** и **Client Secret**

## Шаг 4: Настройка переменных окружения

Создайте файл `.env` в корне проекта:

```bash
# OAuth Google
GOOGLE_CLIENT_ID=ваш-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=ваш-client-secret

# Base URL
BASE_URL=http://localhost:3000
```

**Для production:**

```bash
BASE_URL=https://docta.me
```

## Шаг 5: Проверка работы

1. Запустите dev сервер: `npm run dev`
2. Откройте `http://localhost:3000/login`
3. Нажмите "Войти через Google"
4. Пройдите авторизацию
5. Проверьте, что пользователь создался в БД:

```sql
SELECT * FROM users WHERE email = 'ваш-google-email@gmail.com';
SELECT * FROM oauth_accounts WHERE provider = 'google';
SELECT * FROM sessions;
```

## Важно для production

⚠️ **Не коммитьте .env файл в git!**

Добавьте в `.gitignore`:

```
.env
.env.local
.env.production
```

⚠️ **Используйте HTTPS в production**

В production обязательно настройте:
- SSL сертификат
- `BASE_URL=https://docta.me`
- Обновите Authorized redirect URIs в Google Console

## Тестовые пользователи (для External apps)

Если вы выбрали **External** тип приложения, то в режиме Testing оно будет доступно только для тестовых пользователей:

1. Перейдите в **OAuth consent screen**
2. В разделе **Test users** нажмите **Add Users**
3. Добавьте email адреса тестовых пользователей
4. Нажмите **Save**

## Публикация приложения

Для использования в production с любыми пользователями:

1. Перейдите в **OAuth consent screen**
2. Нажмите **Publish App**
3. Дождитесь верификации от Google (может занять несколько дней)

## Troubleshooting

### Ошибка "redirect_uri_mismatch"

Проверьте что:
- В Google Console правильно указан redirect URI
- В `.env` правильно указан `BASE_URL`
- URL точно совпадает (включая протокол http/https)

### Ошибка "Access blocked: This app's request is invalid"

Проверьте OAuth Consent Screen:
- Приложение должно быть опубликовано или пользователь добавлен в Test users
- Проверьте что все обязательные поля заполнены

### Ошибка "email_not_verified"

Пользователь должен подтвердить email в Google аккаунте.

## API Endpoints

После настройки доступны следующие endpoints:

- `GET /api/auth/google` - начало OAuth flow
- `GET /api/auth/callback/google` - callback после авторизации
- `GET /api/admin/auth/me` - получение текущего пользователя
- `POST /api/admin/auth/logout` - выход

## Проверка в БД

```sql
-- Проверить пользователей OAuth
SELECT u.*, oa.provider, oa.provider_account_id
FROM users u
JOIN oauth_accounts oa ON u.id = oa.user_id
WHERE oa.provider = 'google';

-- Проверить что is_admin=false и password_hash=NULL
SELECT id, email, is_admin, password_hash
FROM users
WHERE id IN (SELECT user_id FROM oauth_accounts WHERE provider = 'google');
```

## Полезные ссылки

- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Google Cloud Console](https://console.cloud.google.com/)

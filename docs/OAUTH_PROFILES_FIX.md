# OAuth Profiles - Отдельные таблицы для каждого провайдера

## 🎯 Архитектурное решение

### Проблема одной таблицы с nullable полями

❌ **Плохо:**
```sql
CREATE TABLE oauth_profiles (
  provider VARCHAR(50),
  -- Google поля
  given_name VARCHAR(255),      -- NULL для Telegram
  family_name VARCHAR(255),     -- NULL для Telegram
  locale VARCHAR(10),           -- NULL для Telegram
  -- Telegram поля
  first_name VARCHAR(255),      -- NULL для Google
  username VARCHAR(255),        -- NULL для Google
  telegram_id BIGINT,           -- NULL для Google
  -- И так далее для каждого провайдера...
  -- + 100500 полей при добавлении новых провайдеров
);
```

**Проблемы:**
- 🔴 Невозможно понять, какое поле к какому провайдеру относится
- 🔴 Куча NULL значений
- 🔴 Нет типобезопасности (все поля nullable)
- 🔴 При добавлении нового провайдера - миграция на всю таблицу
- 🔴 Индексы неэффективны из-за nullable полей

### ✅ Решение: Отдельная таблица для каждого провайдера

```
users
└── oauth_accounts
    ├── oauth_profiles_google
    ├── oauth_profiles_telegram
    ├── oauth_profiles_github (в будущем)
    └── oauth_profiles_facebook (в будущем)
```

## 📊 Структура таблиц

### oauth_profiles_google

Хранит **только** Google-специфичные данные:

```sql
CREATE TABLE oauth_profiles_google (
    id INT PRIMARY KEY,
    oauth_account_id INT UNIQUE,
    
    -- Все поля NOT NULL (где возможно)
    google_id VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    verified_email TINYINT(1),
    name VARCHAR(255),
    given_name VARCHAR(255),
    family_name VARCHAR(255),
    picture TEXT,
    locale VARCHAR(10),
    
    raw_data JSON,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Поля:**
- `google_id` - уникальный ID от Google
- `email` - email от Google
- `verified_email` - подтвержден ли email
- `given_name` / `family_name` - имя/фамилия отдельно
- `locale` - язык пользователя (ru, en, etc)
- `picture` - URL аватара
- `raw_data` - полный JSON ответ от Google

### oauth_profiles_telegram

Хранит **только** Telegram-специфичные данные:

```sql
CREATE TABLE oauth_profiles_telegram (
    id INT PRIMARY KEY,
    oauth_account_id INT UNIQUE,
    
    -- Все поля NOT NULL (где возможно)
    telegram_id BIGINT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255),
    username VARCHAR(255),
    photo_url TEXT,
    auth_date BIGINT,
    
    raw_data JSON,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

**Поля:**
- `telegram_id` - уникальный ID от Telegram (BIGINT!)
- `first_name` / `last_name` - имя/фамилия отдельно
- `username` - @username без собаки
- `photo_url` - URL аватара
- `auth_date` - когда пользователь авторизовался
- `raw_data` - полный JSON ответ от Telegram

## ✨ Преимущества

### 1. Чистая схема
- ✅ Каждая таблица хранит только нужные поля
- ✅ Нет NULL значений (кроме действительно опциональных)
- ✅ Понятно, какие поля откуда

### 2. Типобезопасность
```typescript
interface GoogleProfile {
  google_id: string;          // NOT NULL
  email: string;              // NOT NULL
  given_name: string | null;  // nullable только если опционально
  locale: string | null;
}

interface TelegramProfile {
  telegram_id: number;        // NOT NULL, BIGINT
  first_name: string;         // NOT NULL
  username: string | null;    // nullable - не у всех есть
}
```

### 3. Легко добавлять новые провайдеры
```sql
-- Добавляем GitHub - просто новая таблица!
CREATE TABLE oauth_profiles_github (
    oauth_account_id INT UNIQUE,
    github_id BIGINT NOT NULL,
    login VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    -- GitHub-специфичные поля
);
```

### 4. Эффективные индексы
```sql
-- Google: индекс по email
CREATE INDEX idx_email ON oauth_profiles_google(email);

-- Telegram: индекс по username
CREATE INDEX idx_username ON oauth_profiles_telegram(username);

-- Все NOT NULL, индексы работают оптимально!
```

### 5. Нет конфликтов
```
Пользователь #1:
  oauth_accounts:
    - id: 100, provider: 'google'
    - id: 101, provider: 'telegram'
  
  oauth_profiles_google (oauth_account_id = 100):
    email: "john@gmail.com"
    given_name: "John"
    family_name: "Doe"
    locale: "en"
  
  oauth_profiles_telegram (oauth_account_id = 101):
    first_name: "Джон"
    last_name: "Доу"
    username: "johndoe"
    telegram_id: 123456789

✅ Никаких конфликтов! Каждый провайдер в своей таблице.
```

## 🔄 Логика работы

### Сохранение Google профиля:

```typescript
// Google callback
const userInfo = await fetchGoogleUserInfo(accessToken);

// Сохраняем в oauth_profiles_google
await saveGoogleProfile(oauthAccountId, {
  id: userInfo.id,
  email: userInfo.email,
  name: userInfo.name,
  given_name: userInfo.given_name,
  family_name: userInfo.family_name,
  picture: userInfo.picture,
  locale: userInfo.locale,
  verified_email: userInfo.verified_email
});
```

### Сохранение Telegram профиля:

```typescript
// Telegram callback
const telegramData = validateTelegramAuth(...);

// Сохраняем в oauth_profiles_telegram
await saveTelegramProfile(oauthAccountId, {
  id: telegramData.id,
  first_name: telegramData.first_name,
  last_name: telegramData.last_name,
  username: telegramData.username,
  photo_url: telegramData.photo_url,
  auth_date: telegramData.auth_date
});
```

### Получение профилей:

```typescript
// API: GET /api/auth/oauth-profiles
const profiles = await getUserOAuthProfiles(userId);

// Результат:
{
  google: {
    email: "john@gmail.com",
    given_name: "John",
    family_name: "Doe",
    locale: "en"
  },
  telegram: {
    first_name: "Джон",
    last_name: "Доу",
    username: "johndoe",
    telegram_id: 123456789
  },
  primaryProvider: "google"
}
```

## 🎨 UI

На странице профиля каждый провайдер показывает **свои** данные:

### Google профиль:
```
🔵 Google [Основной]
├─ Email: john@gmail.com ✅ Подтвержден
├─ Имя: John
├─ Фамилия: Doe
└─ Локаль: en

[Отвязать]
```

### Telegram профиль:
```
💬 Telegram
├─ Имя: Джон
├─ Фамилия: Доу
├─ Username: @johndoe
└─ ID: 123456789

[Отвязать] [Сделать основным]
```

## 📖 API

### Получение профилей:
```typescript
GET /api/auth/oauth-profiles

Response:
{
  google: GoogleProfile | null,
  telegram: TelegramProfile | null,
  primaryProvider: 'google' | 'telegram' | null
}
```

### Установка основного провайдера:
```typescript
POST /api/auth/set-primary-provider
{
  provider: 'google' | 'telegram' | null
}
```

## 🚀 Добавление нового провайдера

Например, GitHub:

### 1. Миграция:
```sql
CREATE TABLE oauth_profiles_github (
    id INT AUTO_INCREMENT PRIMARY KEY,
    oauth_account_id INT NOT NULL UNIQUE,
    github_id BIGINT NOT NULL,
    login VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    company VARCHAR(255),
    location VARCHAR(255),
    raw_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_github_id (github_id),
    INDEX idx_login (login),
    FOREIGN KEY (oauth_account_id) REFERENCES oauth_accounts(id) ON DELETE CASCADE
);
```

### 2. TypeScript интерфейс:
```typescript
export interface GitHubProfile {
  id: number;
  oauth_account_id: number;
  github_id: number;
  login: string;
  avatar_url: string | null;
  bio: string | null;
  company: string | null;
  location: string | null;
  raw_data?: any;
}
```

### 3. Утилиты:
```typescript
export async function saveGitHubProfile(
  oauthAccountId: number,
  githubData: { ... }
): Promise<void> { ... }

export async function getGitHubProfile(
  userId: number
): Promise<GitHubProfile | null> { ... }
```

### 4. Обновить общий метод:
```typescript
export interface AllOAuthProfiles {
  google: GoogleProfile | null;
  telegram: TelegramProfile | null;
  github: GitHubProfile | null;  // <-- добавили
}
```

**Все!** Никаких изменений в существующих таблицах, никаких миграций старых данных.

## 📊 Сравнение подходов

| Критерий | Одна таблица | Отдельные таблицы |
|----------|--------------|-------------------|
| Понятность | ❌ Куча полей | ✅ Четкая структура |
| NULL значения | ❌ Много | ✅ Минимум |
| Типобезопасность | ❌ Слабая | ✅ Сильная |
| Добавление провайдера | ❌ Миграция всей таблицы | ✅ Новая таблица |
| Индексы | ❌ Неэффективны | ✅ Оптимальны |
| Размер таблицы | ❌ Растет с каждым провайдером | ✅ Каждая маленькая |
| Конфликты | ❌ Возможны | ✅ Невозможны |

## 🎯 Итого

**Отдельная таблица для каждого OAuth провайдера** - это:
- ✅ Чистая архитектура
- ✅ Типобезопасность
- ✅ Легкая расширяемость
- ✅ Оптимальная производительность
- ✅ Нет конфликтов данных
- ✅ Понятный код

При добавлении 10 новых провайдеров - просто 10 новых таблиц, без изменения существующих! 🚀

# 4. Схема базы данных

[← Назад к оглавлению](index.md)

---

## Новые таблицы

### users - Пользователи

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    photo_url VARCHAR(500),
    password_hash VARCHAR(255) NULL, -- Для админов с email/password авторизацией
    is_admin BOOLEAN DEFAULT FALSE, -- Флаг администратора
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_is_admin (is_admin)
);
```

**Назначение:** Хранение базовой информации о пользователях и администраторах.

**Поля:**

- `id` - уникальный идентификатор пользователя
- `email` - email (уникальный)
- `name` - имя пользователя
- `photo_url` - URL фото (из OAuth или загруженное вручную)
- `password_hash` - хешированный пароль (только для админов с email/password авторизацией, NULL для OAuth пользователей)
- `is_admin` - флаг, указывающий что пользователь является администратором
- `created_at` / `updated_at` - системные метки времени

**Примечания:**

- Администраторы создаются вручную в БД с `is_admin=true` и заполненным `password_hash`
- OAuth пользователи имеют `password_hash=NULL` и `is_admin=false`
- На этом этапе не добавляем поле `doctor_id` - оно будет в других PRD

### oauth_accounts - OAuth аккаунты

```sql
CREATE TABLE oauth_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(50) NOT NULL, -- 'google', 'telegram'
    provider_account_id VARCHAR(255) NOT NULL, -- ID из OAuth провайдера
    access_token TEXT,
    refresh_token TEXT,
    expires_at BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_provider_account (provider, provider_account_id),
    INDEX idx_user_id (user_id),
    INDEX idx_provider (provider, provider_account_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

**Назначение:** Связь пользователей с OAuth провайдерами (поддержка нескольких провайдеров на одного пользователя).

**Поля:**

- `user_id` - ссылка на users.id
- `provider` - название провайдера ('google', 'telegram')
- `provider_account_id` - ID пользователя в системе провайдера
- `access_token` / `refresh_token` - токены OAuth (опционально)
- `expires_at` - время истечения токена

### sessions - Сессии

```sql
CREATE TABLE sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL,
    expires_at BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

**Назначение:** Хранение сессий пользователей (database-based sessions).

**Поля:**

- `id` - уникальный идентификатор сессии (обычно генерируется библиотекой auth)
- `user_id` - ссылка на users.id
- `expires_at` - время истечения сессии (UNIX timestamp)

**Примечания:**

- Index на `expires_at` для эффективной очистки истекших сессий
- Можно использовать cron job для очистки: `DELETE FROM sessions WHERE expires_at < UNIX_TIMESTAMP()`

## Схема связей

```
┌─────────┐
│  users  │
└────┬────┘
     │
     │ 1:N
     │
     ├──────────────┬─────────────┐
     │              │             │
     ▼              ▼             ▼
┌─────────────┐  ┌──────────┐  [Другие PRD]
│oauth_accounts│  │ sessions │  - doctor_profile
└──────────────┘  └──────────┘  - clinic_profile
                                - permissions
```

## Индексы для производительности

```sql
-- Частые запросы по email
CREATE INDEX idx_users_email ON users(email);

-- Поиск OAuth аккаунтов по провайдеру
CREATE INDEX idx_oauth_provider ON oauth_accounts(provider, provider_account_id);
CREATE INDEX idx_oauth_user ON oauth_accounts(user_id);

-- Поиск и очистка сессий
CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_expires ON sessions(expires_at);
```

## Миграции

### Создание таблиц

Файл: `server/sql/migrations/001_auth_basic.sql`

```sql
-- Создаем таблицу пользователей
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    photo_url VARCHAR(500),
    password_hash VARCHAR(255) NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_is_admin (is_admin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Создаем таблицу OAuth аккаунтов
CREATE TABLE IF NOT EXISTS oauth_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(50) NOT NULL,
    provider_account_id VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    expires_at BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_provider_account (provider, provider_account_id),
    INDEX idx_user_id (user_id),
    INDEX idx_provider (provider, provider_account_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Создаем таблицу сессий
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL,
    expires_at BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Откат (Rollback)

Файл: `server/sql/migrations/001_auth_basic_rollback.sql`

```sql
-- Удаляем таблицы в обратном порядке (учитываем FK)
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS oauth_accounts;
DROP TABLE IF EXISTS users;
```

## Seed данные для тестирования

Файл: `server/sql/seeds/001_auth_test_data.sql`

```sql
-- Тестовый администратор
-- Пароль: admin123 (хеш для bcrypt с cost=10)
INSERT INTO users (email, name, password_hash, is_admin) VALUES
('admin@docta.me', 'Admin User', '$2b$10$rKjHZpVqJYqZ1Y5KQx9D4OZ7qYJZXqVZkQbXqZkQbXqZkQbXqZkQb', TRUE);

-- Тестовый OAuth пользователь
INSERT INTO users (email, name, photo_url, is_admin) VALUES
('user@example.com', 'Test User', 'https://via.placeholder.com/150', FALSE);

-- OAuth аккаунт для тестового пользователя
INSERT INTO oauth_accounts (user_id, provider, provider_account_id) VALUES
(2, 'google', 'google_test_id_123');

-- Активная сессия для администратора (истекает через 30 дней)
INSERT INTO sessions (id, user_id, expires_at) VALUES
('admin_session_123', 1, UNIX_TIMESTAMP(DATE_ADD(NOW(), INTERVAL 30 DAY)));

-- Активная сессия для тестового пользователя (истекает через 30 дней)
INSERT INTO sessions (id, user_id, expires_at) VALUES
('user_session_456', 2, UNIX_TIMESTAMP(DATE_ADD(NOW(), INTERVAL 30 DAY)));
```

**Примечание:** Для создания реального хеша пароля используйте bcrypt:

```javascript
// Node.js пример
const bcrypt = require('bcrypt');
const hash = await bcrypt.hash('your_password', 10);
console.log(hash);
```

## Что НЕ включено в этот PRD

Следующие таблицы будут созданы в других PRD:

- `clinic_users`, `clinic_join_requests` → **clinic-profile**, **clinic-verification**
- `audit_logs` → **permissions**
- `clinic_verified_contacts` → **clinic-verification**

Следующие изменения в таблицах `clinics`, `doctors` будут в других PRD:

- Статусы клиник → **clinic-profile**
- Верификация врачей → **doctor-profile**

---

**Предыдущая секция:** [← 3. Архитектура](03-architecture.md)  
**Следующая секция:** [Итерации разработки →](iterations/iteration-01-database.md)

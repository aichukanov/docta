# Итерация 1: База данных - ЗАВЕРШЕНА ✅

**Дата:** 2026-01-30  
**Статус:** 🟢 Completed

## Что создано

### 1. Миграции

📄 **`server/sql/migrations/001_auth_basic.sql`**
- Таблица `users` - пользователи (админы + OAuth юзеры)
- Таблица `oauth_accounts` - OAuth привязки (Google, Telegram)
- Таблица `sessions` - сессии с expiration tracking
- Индексы для производительности
- Foreign keys с CASCADE

📄 **`server/sql/migrations/001_auth_basic_rollback.sql`**
- Rollback скрипт для отката миграции

### 2. Тестовые данные

📄 **`server/sql/seeds/001_auth_test_data.sql`**
- Тестовый админ: `admin@docta.me` / `admin123`
- Тестовый OAuth юзер: `user@example.com`
- Активные сессии для обоих

⚠️ **Только для development!** Не используйте в production.

### 3. Документация

📄 **`server/sql/migrations/README.md`**
- Детальная инструкция по применению миграций
- Troubleshooting
- Как создать первого реального админа

📄 **`DATABASE_SCHEMA.md`** (обновлен)
- Добавлены описания таблиц: users, oauth_accounts, sessions
- Обновлена секция "Core Implementation Logic"

## Как применить миграцию

### Шаг 1: Применить миграцию

```bash
# Вариант 1: MySQL CLI
mysql -u your_user -p your_database < server/sql/migrations/001_auth_basic.sql

# Вариант 2: Интерактивно
mysql -u your_user -p your_database
source server/sql/migrations/001_auth_basic.sql;
```

### Шаг 2: Загрузить тестовые данные (опционально, только dev)

```bash
mysql -u your_user -p your_database < server/sql/seeds/001_auth_test_data.sql
```

### Шаг 3: Проверить

```sql
-- Проверить структуру
DESCRIBE users;
DESCRIBE oauth_accounts;
DESCRIBE sessions;

-- Проверить тестовые данные
SELECT email, name, is_admin FROM users;
```

## Структура таблицы users

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    photo_url VARCHAR(500),
    password_hash VARCHAR(255) NULL,      -- Для админов
    is_admin BOOLEAN DEFAULT FALSE,       -- Флаг админа
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_is_admin (is_admin)
);
```

**Ключевые поля:**
- `password_hash` - NULL для OAuth юзеров, заполнен для админов (bcrypt)
- `is_admin` - TRUE для администраторов, FALSE для обычных пользователей

## Как создать реального админа

### 1. Сгенерировать хеш пароля

```bash
node -e "const bcrypt = require('bcrypt'); bcrypt.hash('YourSecurePassword123!', 10).then(console.log)"
```

### 2. Вставить в БД

```sql
INSERT INTO users (email, name, password_hash, is_admin) VALUES
('your.email@docta.me', 'Your Name', '$2b$10$HASH_HERE', TRUE);
```

## Критерии приемки

- [x] AC-1: Таблица `users` создана с полями: id, email, name, photo_url, password_hash, is_admin
- [x] AC-2: Таблица `oauth_accounts` создана с FK к users
- [x] AC-3: Таблица `sessions` создана с FK к users и индексом на expires_at
- [x] AC-4: Индексы на users.email и users.is_admin созданы
- [x] AC-5: Unique constraint на oauth_accounts (provider, provider_account_id)
- [x] AC-6: Миграция использует IF NOT EXISTS (идемпотентна)
- [x] AC-7: Rollback скрипт создан
- [x] AC-8: Seed данные с тестовым админом созданы
- [x] AC-9: DATABASE_SCHEMA.md обновлен
- [x] AC-10: Создана инструкция по применению миграций

## Следующие шаги

✅ **Итерация 1 завершена** - структура БД готова

⏭️ **Следующая итерация:** [Итерация 2 - Email/Password авторизация для админов](../iterations/iteration-02-admin-auth.md)

Что будет реализовано:
- Страница входа `/admin/login`
- API endpoints: `/api/admin/auth/login`, `/api/admin/auth/logout`
- Middleware для защиты админских роутов
- Утилиты для работы с паролями (bcrypt) и сессиями

## Файлы для review

Перед переходом к Итерации 2, пожалуйста проверьте:
- ✅ `server/sql/migrations/001_auth_basic.sql`
- ✅ `server/sql/migrations/001_auth_basic_rollback.sql`
- ✅ `server/sql/seeds/001_auth_test_data.sql`
- ✅ `server/sql/migrations/README.md`
- ✅ `DATABASE_SCHEMA.md`
- ✅ `prd/auth/PROGRESS.md`

---

**Прогресс:** 20% (1/5 итераций) ██░░░░░░░░

**Детали:** См. `prd/auth/PROGRESS.md`

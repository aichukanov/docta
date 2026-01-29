# 4. База данных

[← Назад к оглавлению](index.md)

---

## Изменения в существующих таблицах

### users - добавить поля

```sql
ALTER TABLE users ADD COLUMN display_name VARCHAR(100) AFTER name;
ALTER TABLE users ADD COLUMN is_profile_public BOOLEAN DEFAULT TRUE AFTER photo_url;
ALTER TABLE users ADD COLUMN updated_profile_at TIMESTAMP NULL AFTER updated_at;
```

**Новые поля:**

- `display_name` - отображаемое имя (можно редактировать, fallback к name из OAuth)
- `is_profile_public` - публичный или приватный профиль
- `updated_profile_at` - когда последний раз обновлялся профиль

## Примечания

- Таблица `oauth_accounts` уже создана в **auth** PRD
- Для маскировки email используется функция на уровне приложения (не БД)
- Настройки приватности хранятся в поле `is_profile_public` в таблице users

## Миграции

### Файл: `server/sql/migrations/003_user_profile.sql`

```sql
-- Добавляем поля для профиля пользователя
ALTER TABLE users
ADD COLUMN display_name VARCHAR(100) AFTER name,
ADD COLUMN is_profile_public BOOLEAN DEFAULT TRUE AFTER photo_url,
ADD COLUMN updated_profile_at TIMESTAMP NULL AFTER updated_at;

-- Индекс для быстрого поиска публичных профилей
CREATE INDEX idx_users_public ON users(is_profile_public);
```

### Rollback: `server/sql/migrations/003_user_profile_rollback.sql`

```sql
ALTER TABLE users
DROP COLUMN updated_profile_at,
DROP COLUMN is_profile_public,
DROP COLUMN display_name;

DROP INDEX idx_users_public ON users;
```

## Примеры запросов

### Получить профиль пользователя

```sql
SELECT
  u.id,
  u.email,
  u.name,
  u.display_name,
  u.photo_url,
  u.is_profile_public,
  u.created_at,
  u.updated_profile_at
FROM users u
WHERE u.id = ?;
```

### Получить OAuth аккаунты пользователя

```sql
SELECT
  oa.id,
  oa.provider,
  oa.provider_account_id,
  oa.created_at
FROM oauth_accounts oa
WHERE oa.user_id = ?
ORDER BY oa.created_at DESC;
```

### Обновить display_name

```sql
UPDATE users
SET display_name = ?,
    updated_profile_at = CURRENT_TIMESTAMP
WHERE id = ?;
```

### Обновить настройки приватности

```sql
UPDATE users
SET is_profile_public = ?,
    updated_at = CURRENT_TIMESTAMP
WHERE id = ?;
```

### Получить публичный профиль (для комментариев)

```sql
SELECT
  u.id,
  CASE
    WHEN u.is_profile_public = TRUE THEN u.email
    ELSE NULL
  END as email,
  u.is_profile_public
FROM users u
WHERE u.id = ?;
```

---

**Предыдущая секция:** [← 3. Архитектура](03-architecture.md)  
**Следующая секция:** [5. Риски и метрики →](05-risks-and-metrics.md)

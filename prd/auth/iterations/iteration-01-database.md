# Итерация 1: База данных и миграции

[← К списку итераций](README.md) | [Следующая итерация →](iteration-02-admin-auth.md)

---

## Цель

Создать структуру БД для авторизации (email/password для админов + OAuth для пользователей) и хранения сессий.

## Зависимости

Нет (первая итерация)

## Задачи

1. Создать SQL миграционный файл с 3 таблицами: users (с полями для админов), oauth_accounts, sessions
2. Создать SQL файл для отката (rollback)
3. Создать seed данные для тестирования (включая тестового админа)
4. Документировать изменения в `DATABASE_SCHEMA.md`
5. Протестировать миграции

## Технические детали

### Создать файл: `server/sql/migrations/001_auth_basic.sql`

См. полную схему SQL в [04-database.md](../04-database.md)

**Таблицы:**

1. `users` - базовая информация пользователя (id, email, name, photo_url, **password_hash**, **is_admin**)
2. `oauth_accounts` - привязки OAuth провайдеров
3. `sessions` - сессии пользователей

**Важные изменения:**
- Добавлено поле `password_hash` (VARCHAR(255) NULL) - для админов с email/password
- Добавлено поле `is_admin` (BOOLEAN DEFAULT FALSE) - флаг администратора
- Добавлен индекс на `is_admin` для быстрого поиска администраторов

### Создать файл: `server/sql/migrations/001_auth_basic_rollback.sql`

```sql
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS oauth_accounts;
DROP TABLE IF EXISTS users;
```

### Создать файл: `server/sql/seeds/001_auth_test_data.sql`

Тестовый администратор + тестовый OAuth пользователь + сессии для локальной разработки.

**Важно:** Включить тестового админа с is_admin=true и хешированным паролем.

### Обновить: `DATABASE_SCHEMA.md`

Добавить описание 3 новых таблиц с их назначением.

## Критерии приемки

- [ ] AC-1: Все 3 таблицы созданы без ошибок
- [ ] AC-2: Foreign keys настроены корректно (cascade delete)
- [ ] AC-3: Индексы созданы для часто запрашиваемых полей (email, provider, expires_at)
- [ ] AC-4: DATABASE_SCHEMA.md обновлен с новыми таблицами
- [ ] AC-5: SQL миграции выполняются идемпотентно (можно запустить повторно)
- [ ] AC-6: Rollback успешно удаляет все таблицы
- [ ] AC-7: Seed данные успешно вставляются
- [ ] AC-8: Constraint проверки работают (unique email, unique provider+account_id)

## Как проверить

1. **Запустить миграции на тестовой БД:**

   ```sql
   mysql -u root -p docta_test < server/sql/migrations/001_auth_basic.sql
   ```

2. **Проверить наличие всех таблиц:**

   ```sql
   SHOW TABLES;
   -- Должно показать: users, oauth_accounts, sessions
   ```

3. **Проверить структуру каждой таблицы:**

   ```sql
   DESCRIBE users;
   DESCRIBE oauth_accounts;
   DESCRIBE sessions;
   ```

4. **Проверить foreign keys:**

   ```sql
   SHOW CREATE TABLE oauth_accounts;
   SHOW CREATE TABLE sessions;
   -- Должны быть FK на users(id) с ON DELETE CASCADE
   ```

5. **Проверить индексы:**

   ```sql
   SHOW INDEX FROM users;
   SHOW INDEX FROM oauth_accounts;
   SHOW INDEX FROM sessions;
   ```

6. **Попробовать вставить тестовые данные:**

   ```sql
   mysql -u root -p docta_test < server/sql/seeds/001_auth_test_data.sql
   SELECT * FROM users;
   SELECT * FROM oauth_accounts;
   SELECT * FROM sessions;
   ```

7. **Проверить constraint'ы:**

   ```sql
   -- Попробовать вставить дубликат email - должна быть ошибка
   INSERT INTO users (email, name) VALUES ('test@example.com', 'Duplicate');

   -- Попробовать вставить OAuth с несуществующим user_id - должна быть ошибка
   INSERT INTO oauth_accounts (user_id, provider, provider_account_id)
   VALUES (999, 'google', 'test');
   ```

8. **Проверить rollback:**

   ```sql
   mysql -u root -p docta_test < server/sql/migrations/001_auth_basic_rollback.sql
   SHOW TABLES;
   -- Таблицы users, oauth_accounts, sessions должны исчезнуть
   ```

9. **Проверить повторное выполнение (идемпотентность):**
   ```sql
   -- Запустить миграцию 2 раза подряд - не должно быть ошибок
   mysql -u root -p docta_test < server/sql/migrations/001_auth_basic.sql
   mysql -u root -p docta_test < server/sql/migrations/001_auth_basic.sql
   ```

## Статус

**Not Started**

---

**Следующая итерация:** [2. OAuth через Google →](iteration-02-oauth-google.md)

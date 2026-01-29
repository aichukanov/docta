# Итерация 1: База данных и миграции

[← К списку итераций](README.md) | [Следующая итерация →](iteration-02-oauth-google.md)

---

## Цель

Создать структуру БД для пользователей, OAuth, ролей и прав доступа.

## Зависимости

Нет (первая итерация)

## Задачи

1. Создать SQL миграционный файл с новыми таблицами
2. Создать SQL файл для изменения существующих таблиц (clinics, doctors)
3. Добавить seed данные для тестирования (тестовый суперадмин)
4. Документировать изменения в `DATABASE_SCHEMA.md`

## Технические детали

### Создать файл: `server/sql/migrations/001_auth_system.sql`

См. полную схему таблиц в [04-database.md](../04-database.md):

- users
- oauth_accounts
- sessions
- clinic_users
- clinic_join_requests
- audit_logs
- clinic_verified_contacts

### Создать файл: `server/sql/migrations/002_alter_existing_tables.sql`

```sql
-- Добавить статусы для клиник
ALTER TABLE clinics ADD COLUMN status ENUM('draft', 'pending_verification', 'published', 'rejected')
    NOT NULL DEFAULT 'draft' AFTER updated_at;

ALTER TABLE clinics ADD COLUMN is_contact_verified BOOLEAN DEFAULT FALSE AFTER status;
ALTER TABLE clinics ADD COLUMN created_by INT NULL AFTER is_contact_verified;
ALTER TABLE clinics ADD FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL;

-- Добавить флаг верификации для врачей
ALTER TABLE doctors ADD COLUMN is_verified BOOLEAN DEFAULT FALSE AFTER updated_at;
ALTER TABLE doctors ADD COLUMN user_id INT NULL AFTER is_verified;
ALTER TABLE doctors ADD FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;
```

### Обновить: `DATABASE_SCHEMA.md`

Добавить описание новых таблиц в существующий файл DATABASE_SCHEMA.md

## Критерии приемки

- [ ] AC-1: Все таблицы созданы без ошибок
- [ ] AC-2: Foreign keys настроены корректно
- [ ] AC-3: Индексы созданы для часто запрашиваемых полей
- [ ] AC-4: DATABASE_SCHEMA.md обновлен с новыми таблицами
- [ ] AC-5: SQL файлы выполняются идемпотентно (можно запустить повторно)

## Как проверить

1. Запустить SQL миграции на тестовой БД
2. Проверить наличие всех таблиц: `SHOW TABLES;`
3. Проверить структуру каждой таблицы: `DESCRIBE users;` и т.д.
4. Проверить foreign keys: `SHOW CREATE TABLE clinic_users;`
5. Попробовать вставить тестовые данные и проверить связи

## Статус

**Not Started**

---

**Следующая итерация:** [2. OAuth через Google →](iteration-02-oauth-google.md)

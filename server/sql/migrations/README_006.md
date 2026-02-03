# Database Migration: User Preferred Locale

## Что добавляет миграция

Добавляет колонку `preferred_locale` в таблицу `auth_users` для сохранения предпочитаемого языка пользователя.

```sql
ALTER TABLE auth_users
ADD COLUMN preferred_locale VARCHAR(10) DEFAULT NULL
COMMENT 'Preferred language: sr, sr-cyrl, en, ru, de, tr';
```

## Как применить миграцию

### Вариант 1: Автоматический скрипт (рекомендуется)

#### Linux/Mac:

```bash
cd /path/to/nuxt
chmod +x scripts/migrate-user-locale.sh
./scripts/migrate-user-locale.sh
```

#### Windows:

```cmd
cd C:\path\to\nuxt
scripts\migrate-user-locale.bat
```

### Вариант 2: Вручную через MySQL

```bash
mysql -u root -p docta < server/sql/migrations/006_user_preferred_locale.sql
```

### Вариант 3: Через phpMyAdmin или другой GUI

1. Открыть phpMyAdmin
2. Выбрать базу данных `docta`
3. Перейти в SQL tab
4. Вставить содержимое файла `006_user_preferred_locale.sql`
5. Выполнить

## Проверка

После применения миграции проверьте что колонка добавлена:

```sql
DESCRIBE auth_users;
```

Вы должны увидеть:

```
+----------------------+--------------+------+-----+---------+-------+
| Field                | Type         | Null | Key | Default | Extra |
+----------------------+--------------+------+-----+---------+-------+
| preferred_locale     | varchar(10)  | YES  | MUL | NULL    |       |
+----------------------+--------------+------+-----+---------+-------+
```

## Откат миграции

Если нужно откатить изменения:

```sql
ALTER TABLE auth_users DROP COLUMN preferred_locale;
ALTER TABLE auth_users DROP INDEX idx_preferred_locale;
```

## Существующие пользователи

Все существующие пользователи получат `preferred_locale = NULL`.

При первой смене языка через language-switcher значение автоматически сохранится в БД.

## Совместимость

- **MySQL:** 5.7+
- **MariaDB:** 10.2+
- **Обратная совместимость:** Да (NULL означает использование старой логики)

## Что дальше

После применения миграции:

1. ✅ Миграция применена
2. ✅ API endpoints готовы (`/api/auth/update-locale`, `/api/auth/user-locale`)
3. ✅ Middleware настроен (`middleware/locale.global.ts`)
4. ✅ Plugin инициализирован (`plugins/01.locale.client.ts`)
5. ✅ Language-switcher обновлен (автоматическое сохранение)

**Система готова к использованию!**

## Troubleshooting

### Ошибка: "Column already exists"

Миграция уже была применена. Проверьте:

```sql
SELECT COUNT(*) FROM auth_users WHERE preferred_locale IS NOT NULL;
```

### Ошибка: "Access denied"

Недостаточно прав. Используйте пользователя с правами ALTER TABLE:

```sql
GRANT ALTER ON docta.* TO 'your_user'@'localhost';
FLUSH PRIVILEGES;
```

### Ошибка: "Table doesn't exist"

Проверьте что вы в правильной базе данных:

```sql
USE docta;
SHOW TABLES LIKE 'auth_users';
```

## Дополнительная информация

- 📘 [USER_LOCALE_SYSTEM.md](../docs/USER_LOCALE_SYSTEM.md) - Полная документация системы
- 📘 [EMAIL_LOCALIZATION.md](../docs/EMAIL_LOCALIZATION.md) - Как используется для email

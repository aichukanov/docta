# User Locale System - Implementation Checklist

## ✅ Database

- [x] Создана миграция `006_user_preferred_locale.sql`
- [x] Добавлена колонка `preferred_locale VARCHAR(10)` в `auth_users`
- [x] Добавлен индекс `idx_preferred_locale`
- [x] Создан README для миграции
- [x] Созданы скрипты применения (bash, bat)

## ✅ API Endpoints

- [x] `POST /api/auth/update-locale` - Обновить локаль пользователя
- [x] `GET /api/auth/user-locale` - Получить текущую локаль

## ✅ Server Utils

- [x] Обновлен `server/utils/user-locale.ts`:
  - [x] Добавлена функция `getUserPreferredLocale()`
  - [x] Обновлен приоритет в `getUserLocale()`
- [x] Обновлен `server/utils/api-codes.ts`:
  - [x] Добавлен `SUCCESS_CODES.LOCALE_UPDATED`
  - [x] Добавлен `ERROR_CODES.INVALID_LOCALE`
  - [x] Добавлен `ERROR_CODES.LOCALE_REQUIRED`
  - [x] Добавлен `ERROR_CODES.ERROR_UPDATING_LOCALE`

## ✅ Client Side

- [x] Создан `composables/use-user-locale.ts`:
  - [x] Функция `fetchUserLocale()`
  - [x] Функция `updateUserLocale()`
- [x] Обновлен `components/language-switcher.vue`:
  - [x] Добавлено сохранение в БД для залогиненных
- [x] Создан `middleware/locale.global.ts`:
  - [x] Global middleware для инициализации локали
  - [x] Приоритет: профиль → cookie → query → default
- [x] Создан `plugins/01.locale.client.ts`:
  - [x] Client plugin для загрузки локали при старте

## ✅ Documentation

- [x] `docs/USER_LOCALE_SYSTEM.md` - Полная документация
- [x] `server/sql/migrations/README_006.md` - Инструкция по миграции
- [x] Обновлен `docs/EMAIL_LOCALIZATION.md` - Новый приоритет

## ✅ Scripts

- [x] `scripts/migrate-user-locale.sh` (Linux/Mac)
- [x] `scripts/migrate-user-locale.bat` (Windows)

## ✅ Quality

- [x] Нет ошибок линтера
- [x] TypeScript типы корректны
- [x] Обратная совместимость (NULL = старое поведение)

## 📋 Deployment Checklist

### 1. Применить миграцию БД

```bash
# Linux/Mac
./scripts/migrate-user-locale.sh

# Windows
scripts\migrate-user-locale.bat

# Или вручную
mysql -u root -p docta < server/sql/migrations/006_user_preferred_locale.sql
```

### 2. Проверить миграцию

```sql
DESCRIBE auth_users preferred_locale;
-- Должно показать колонку VARCHAR(10) с индексом
```

### 3. Деплой кода

```bash
# Build
npm run build

# Start
npm start
```

### 4. Тестирование

#### Manual Testing

```bash
# 1. Открыть приложение
open http://localhost:3000

# 2. Залогиниться

# 3. Сменить язык через language-switcher

# 4. Проверить в БД
mysql> SELECT id, email, preferred_locale FROM auth_users LIMIT 5;

# 5. Обновить страницу - язык сохранен ✅

# 6. Открыть в другом браузере - язык синхронизирован ✅
```

#### API Testing

```bash
# Получить локаль
curl http://localhost:3000/api/auth/user-locale \
  -H "Cookie: session_id=YOUR_SESSION"

# Обновить локаль
curl -X POST http://localhost:3000/api/auth/update-locale \
  -H "Content-Type: application/json" \
  -H "Cookie: session_id=YOUR_SESSION" \
  -d '{"locale":"ru"}'
```

## 🎯 Статистика

- **Новых файлов:** 10
- **Обновленных файлов:** 4
- **Строк кода:** ~800
- **Миграций БД:** 1

## 📊 Приоритет локали (финальный)

```
1. auth_users.preferred_locale        ← NEW! Highest priority
2. Google OAuth profile locale
3. Cookie 'locale'
4. Query parameter ?lang=
5. Accept-Language header
6. Default (Serbian)
```

## ⚠️ Important Notes

1. **NULL означает автоопределение** - не устанавливайте пустую строку
2. **Синхронизация cookie** - при обновлении БД обновляется и cookie
3. **Fallback безопасен** - если API недоступен, используется cookie
4. **Незалогиненные пользователи** - работают как раньше (cookie + query)

## 🚀 Ready to Deploy

Все готово! После применения миграции БД система полностью функциональна.

---

✅ **Задача выполнена!**

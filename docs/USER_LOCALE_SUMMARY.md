# User Locale Preference System - Summary

## 🎯 Цель

Реализовать систему сохранения предпочитаемого языка пользователя в базе данных с автоматической синхронизацией между устройствами.

## ✅ Что сделано

### 1. База данных (1 файл)

**Миграция:** `server/sql/migrations/006_user_preferred_locale.sql`

- Добавлена колонка `preferred_locale VARCHAR(10)` в таблицу `auth_users`
- Добавлен индекс для быстрого поиска
- NULL означает автоматическое определение (обратная совместимость)

### 2. API Endpoints (2 файла)

**`POST /api/auth/update-locale`** - Обновить локаль

```typescript
Request: { locale: "ru" }
Response: { success: true, code: "LOCALE_UPDATED", data: { locale: "ru" } }
```

**`GET /api/auth/user-locale`** - Получить локаль

```typescript
Response: { success: true, code: "LOCALE_UPDATED", data: { locale: "ru" } }
```

### 3. Server Utils (2 файла обновлены)

**`server/utils/user-locale.ts`**

- Добавлена функция `getUserPreferredLocale()` - чтение из БД
- Обновлен приоритет в `getUserLocale()`:
  1. Профиль пользователя (БД) ← NEW!
  2. Google OAuth профиль
  3. Accept-Language header
  4. Default (Serbian)

**`server/utils/api-codes.ts`**

- Добавлены коды: `LOCALE_UPDATED`, `INVALID_LOCALE`, `LOCALE_REQUIRED`, `ERROR_UPDATING_LOCALE`

### 4. Client Side (4 новых файла)

**`composables/use-user-locale.ts`** - Composable для работы с локалью

```typescript
const { fetchUserLocale, updateUserLocale } = useUserLocale();
```

**`middleware/locale.global.ts`** - Global middleware

- Запускается на каждом переходе
- Приоритет: профиль → cookie → query → default

**`plugins/01.locale.client.ts`** - Client plugin

- Инициализация при загрузке приложения
- Автоматическая синхронизация

**`components/language-switcher.vue`** - Обновлен

- Автоматическое сохранение в БД для залогиненных пользователей
- Fallback на cookie для незалогиненных

### 5. Scripts (2 файла)

**`scripts/migrate-user-locale.sh`** (Linux/Mac)
**`scripts/migrate-user-locale.bat`** (Windows)

- Автоматическое применение миграции
- Проверка результатов
- Статистика пользователей

### 6. Documentation (3 файла)

**`docs/USER_LOCALE_SYSTEM.md`** - Полная документация
**`docs/USER_LOCALE_CHECKLIST.md`** - Чеклист для deployment
**`server/sql/migrations/README_006.md`** - Инструкция по миграции
**`docs/EMAIL_LOCALIZATION.md`** - Обновлен приоритет

## 📊 Архитектура

### Приоритет определения локали

```
┌─────────────────────────────────────────┐
│ 1. БД: auth_users.preferred_locale      │ ← NEW! Highest
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│ 2. Google OAuth: locale                 │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│ 3. Cookie: 'locale'                     │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│ 4. Query: ?lang=ru                      │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│ 5. Header: Accept-Language              │
└─────────────────────────────────────────┘
                   ↓
┌─────────────────────────────────────────┐
│ 6. Default: Serbian                     │
└─────────────────────────────────────────┘
```

### Data Flow

#### При смене языка (залогиненный пользователь)

```
User selects language
       ↓
language-switcher.vue
       ↓
updateLocale(value)
       ↓
POST /api/auth/update-locale
       ↓
UPDATE auth_users SET preferred_locale
       ↓
Update cookie
       ↓
Update i18n locale
```

#### При загрузке страницы

```
Page load
    ↓
Plugin: 01.locale.client.ts
    ↓
GET /api/auth/user-locale
    ↓
SELECT preferred_locale FROM auth_users
    ↓
Set locale from:
1. БД (preferred_locale)
2. Google OAuth
3. Cookie
4. Default
```

## 🚀 Использование

### Для разработчика

```typescript
// В компоненте
const { updateUserLocale } = useUserLocale();
await updateUserLocale(Language.RU);

// В API endpoint (server-side)
import { getUserLocale } from '~/server/utils/user-locale';
const locale = await getUserLocale(userId, event);
```

### Для пользователя

1. Залогиниться
2. Выбрать язык через language-switcher
3. Язык сохраняется автоматически
4. При входе с другого устройства - тот же язык

## 📈 Статистика

| Категория              | Количество |
| ---------------------- | ---------- |
| **Новых файлов**       | 10         |
| **Обновленных файлов** | 4          |
| **Строк кода**         | ~800       |
| **Миграций БД**        | 1          |
| **API endpoints**      | 2          |
| **Middleware**         | 1          |
| **Plugins**            | 1          |
| **Composables**        | 1          |

## ✅ Преимущества

1. **Синхронизация между устройствами** - вход с разных браузеров/устройств с тем же языком
2. **Персонализация** - каждый пользователь видит свой язык
3. **Email на правильном языке** - автоматически используется локаль пользователя
4. **Обратная совместимость** - NULL = старое поведение
5. **Fallback безопасен** - если API недоступен, используется cookie
6. **Zero breaking changes** - существующий код продолжает работать

## 🔄 Миграция существующих пользователей

| Состояние                    | Поведение                                   |
| ---------------------------- | ------------------------------------------- |
| **До миграции**              | Локаль из cookie/query/Accept-Language      |
| **После миграции**           | `preferred_locale = NULL` → то же поведение |
| **После первой смены языка** | `preferred_locale = 'ru'` → сохранено в БД  |
| **Следующий вход**           | Локаль из БД → синхронизировано             |

## 🎯 Deployment

### 1. Применить миграцию

```bash
./scripts/migrate-user-locale.sh
# или
scripts\migrate-user-locale.bat
```

### 2. Деплой кода

```bash
npm run build
npm start
```

### 3. Готово! ✅

Все пользователи автоматически начнут использовать новую систему.

## 📝 Файлы

### Новые (10 файлов)

**Database:**

1. `server/sql/migrations/006_user_preferred_locale.sql`
2. `server/sql/migrations/README_006.md`

**API:** 3. `server/api/auth/update-locale.post.ts` 4. `server/api/auth/user-locale.get.ts`

**Client:** 5. `composables/use-user-locale.ts` 6. `middleware/locale.global.ts` 7. `plugins/01.locale.client.ts`

**Scripts:** 8. `scripts/migrate-user-locale.sh` 9. `scripts/migrate-user-locale.bat`

**Docs:** 10. `docs/USER_LOCALE_SYSTEM.md` 11. `docs/USER_LOCALE_CHECKLIST.md`

### Обновленные (4 файла)

1. `server/utils/user-locale.ts` - Приоритет из БД
2. `server/utils/api-codes.ts` - Новые коды
3. `components/language-switcher.vue` - Сохранение в БД
4. `docs/EMAIL_LOCALIZATION.md` - Обновлен приоритет

## 🎉 Результат

**Полнофункциональная система сохранения локали пользователя:**

✅ База данных готова  
✅ API endpoints работают  
✅ Middleware инициализирует локаль  
✅ Plugin загружает при старте  
✅ Language-switcher сохраняет в БД  
✅ Email отправляются на правильном языке  
✅ Синхронизация между устройствами  
✅ Обратная совместимость  
✅ Zero breaking changes  
✅ Документация полная

**Готово к production! 🚀**

---

**Автор:** AI Assistant  
**Дата:** 2026-02-03  
**Версия:** 1.0.0

# User Locale System - Quick Start

## 🚀 Быстрый старт

### 1. Применить миграцию БД (1 минута)

```bash
# Linux/Mac
./scripts/migrate-user-locale.sh

# Windows
scripts\migrate-user-locale.bat
```

### 2. Готово! ✅

Система автоматически работает:

- Language-switcher сохраняет выбор в БД
- Middleware загружает локаль при старте
- Plugin синхронизирует между устройствами

## 💻 Использование

### Для пользователя

Просто выбрать язык → автоматически сохраняется

### Для разработчика

```typescript
// В компоненте
const { updateUserLocale } = useUserLocale();
await updateUserLocale(Language.RU);

// В API endpoint
import { getUserLocale } from '~/server/utils/user-locale';
const locale = await getUserLocale(userId, event);
```

## 📚 Документация

- 📘 [USER_LOCALE_SYSTEM.md](./USER_LOCALE_SYSTEM.md) - Полная документация
- ✅ [USER_LOCALE_CHECKLIST.md](./USER_LOCALE_CHECKLIST.md) - Чеклист deployment
- 📊 [USER_LOCALE_SUMMARY.md](./USER_LOCALE_SUMMARY.md) - Краткое резюме

## 🔧 Troubleshooting

**Ошибка: "Column already exists"**

- Миграция уже применена ✅

**Локаль не сохраняется**

- Проверьте что пользователь залогинен
- Проверьте console на ошибки API

**Email приходят на английском**

- Проверьте что `preferred_locale` установлен в БД
- См. [EMAIL_LOCALIZATION.md](./EMAIL_LOCALIZATION.md)

---

🎉 **Все работает!**

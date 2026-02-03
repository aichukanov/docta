# Email Templates Localization - Checklist

## ✅ Реализация

- [x] Создан `server/utils/email-templates.ts` с шаблонами на 6 языках
- [x] Создан `server/utils/user-locale.ts` для определения локали
- [x] Обновлен `server/utils/email.ts` с поддержкой локали
- [x] Обновлен `server/utils/email-change.ts` для возврата oldEmail
- [x] Обновлены все API endpoints для передачи локали:
  - [x] `/api/auth/register.post.ts`
  - [x] `/api/auth/resend-verification.post.ts`
  - [x] `/api/auth/request-email-change.post.ts`
  - [x] `/api/auth/forgot-password.post.ts`
  - [x] `/api/auth/confirm-email-change.get.ts`

## ✅ Preview & Testing

- [x] Создан `/api/test/email-preview.get.ts` (dev only)
- [x] Создана страница `/dev/email-preview.vue` для UI
- [x] Создан тестовый файл `__test-email-templates.ts`

## ✅ Документация

- [x] `docs/EMAIL_LOCALIZATION.md` - полная документация
- [x] `docs/EMAIL_TEMPLATES_README.md` - quick reference
- [x] `docs/EMAIL_TEMPLATES_SUMMARY.md` - краткое резюме

## ✅ Языки

- [x] 🇷🇸 Serbian (Latin) - `sr`
- [x] 🇷🇸 Serbian (Cyrillic) - `sr-cyrl`
- [x] 🇬🇧 English - `en`
- [x] 🇷🇺 Russian - `ru`
- [x] 🇩🇪 German - `de`
- [x] 🇹🇷 Turkish - `tr`

## ✅ Email Templates

- [x] Password Reset (Восстановление пароля)
- [x] Email Verification (Подтверждение email)
- [x] Login Notification (Уведомление о входе)
- [x] Email Change Notification (Уведомление об изменении email)

## ✅ Quality

- [x] Нет ошибок линтера
- [x] TypeScript типы корректны
- [x] Все импорты работают
- [x] DRY - нет дублирования кода
- [x] Обратная совместимость (locale опциональный параметр)

## 📋 Тестирование (TODO для пользователя)

### Manual Testing

```bash
# 1. Запустить dev server
npm run dev

# 2. Открыть preview
open http://localhost:3000/dev/email-preview

# 3. Проверить все комбинации:
# - Password Reset × 6 языков
# - Email Verification × 6 языков
# - Login Notification × 6 языков
# - Email Change × 6 языков
```

### API Testing

```bash
# Регистрация с разными Accept-Language
curl -H "Accept-Language: ru-RU" -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!","name":"Test"}'

curl -H "Accept-Language: en-US" -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test2@example.com","password":"Test123!","name":"Test"}'

# Проверить логи - должен быть правильный язык
```

### Google OAuth Testing

```bash
# Войти через Google (получит локаль из Google профиля)
# Затем запросить password reset
# Email должен прийти на языке из Google профиля
```

## 🚀 Готово к использованию

Все шаблоны локализованы, система автоматически определяет язык пользователя.

**Использование:**

```typescript
// В любом API endpoint
const locale = await getUserLocale(userId, event);
await sendPasswordResetEmail(email, resetUrl, locale);
```

**Preview:**  
http://localhost:3000/dev/email-preview

---

✅ **Задача выполнена!**

# Email Templates - Quick Reference

## Использование

```typescript
import { getUserLocale } from '~/server/utils/user-locale';
import {
  sendPasswordResetEmail,
  sendEmailVerification,
  sendLoginNotification,
  sendEmailChangeNotification,
} from '~/server/utils/email';

// В вашем API endpoint
const locale = await getUserLocale(userId, event);

// Восстановление пароля
await sendPasswordResetEmail(email, resetUrl, locale);

// Подтверждение email
await sendEmailVerification(email, verificationUrl, userName, locale);

// Уведомление о входе
await sendLoginNotification(email, userName, loginInfo, locale);

// Уведомление об изменении email
await sendEmailChangeNotification(oldEmail, newEmail, userName, locale);
```

## Поддерживаемые языки

🇷🇸 `sr` 🇷🇸 `sr-cyrl` 🇬🇧 `en` 🇷🇺 `ru` 🇩🇪 `de` 🇹🇷 `tr`

## Добавление нового языка

1. Добавить в `composables/use-locale.ts`
2. Добавить переводы во все 4 шаблона в `server/utils/email-templates.ts`:
   - `passwordResetTemplates`
   - `emailVerificationTemplates`
   - `loginNotificationTemplates`
   - `emailChangeNotificationTemplates`

## Файлы

- 📄 `server/utils/email-templates.ts` - Шаблоны
- 📄 `server/utils/email.ts` - Отправка email
- 📄 `server/utils/user-locale.ts` - Определение локали
- 📘 `docs/EMAIL_LOCALIZATION.md` - Полная документация

## Preview (Development)

Просмотр всех email шаблонов:
- 🌐 http://localhost:3000/dev/email-preview
- 📡 http://localhost:3000/api/test/email-preview?type=password-reset&locale=ru

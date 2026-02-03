# Email Templates Localization - Changes

## Новые файлы

### Core Implementation
1. `server/utils/email-templates.ts` - Локализованные email шаблоны (610 lines)
2. `server/utils/user-locale.ts` - Определение локали пользователя (120 lines)

### Development Tools
3. `server/api/test/email-preview.get.ts` - API для preview email (80 lines)
4. `pages/dev/email-preview.vue` - UI для просмотра шаблонов (180 lines)
5. `server/utils/__test-email-templates.ts` - Тестовый файл (75 lines)

### Documentation
6. `docs/EMAIL_LOCALIZATION.md` - Полная документация
7. `docs/EMAIL_TEMPLATES_README.md` - Quick reference
8. `docs/EMAIL_TEMPLATES_SUMMARY.md` - Краткое резюме
9. `docs/EMAIL_TEMPLATES_CHECKLIST.md` - Чеклист

## Обновленные файлы

### Core Files
1. `server/utils/email.ts`
   - Добавлен параметр `locale: Language` во все функции
   - Импорт шаблонов из email-templates
   - Сокращено с 309 до 172 строк (удалены хардкоженные шаблоны)

2. `server/utils/email-change.ts`
   - Функция `validateAndApplyEmailChange()` теперь возвращает `oldEmail`
   - Обновлен тип возвращаемого значения

### API Endpoints
3. `server/api/auth/register.post.ts`
   - Добавлено `getUserLocale(userId, event)`
   - Передача locale в `sendEmailVerification()`

4. `server/api/auth/resend-verification.post.ts`
   - Добавлено `getUserLocale(user.id, event)`
   - Передача locale в `sendEmailVerification()`

5. `server/api/auth/request-email-change.post.ts`
   - Добавлено `getUserLocale(user.id, event)`
   - Передача locale в `sendEmailVerification()`

6. `server/api/auth/forgot-password.post.ts`
   - Добавлено `getUserLocale(user.id, event)`
   - Передача locale в `sendPasswordResetEmail()`

7. `server/api/auth/confirm-email-change.get.ts`
   - Реализована отправка уведомления на старый email
   - Добавлено `getUserLocale(updatedUser.id, event)`
   - Передача locale в `sendEmailChangeNotification()`

## Изменения в деталях

### Email Templates Structure

```typescript
// 4 типа шаблонов
- passwordResetTemplates
- emailVerificationTemplates
- loginNotificationTemplates
- emailChangeNotificationTemplates

// 6 языков каждый
- Language.SR (Serbian Latin)
- Language.SR_CYRILLIC (Serbian Cyrillic)
- Language.EN (English)
- Language.RU (Russian)
- Language.DE (German)
- Language.TR (Turkish)

// = 24 варианта шаблонов
```

### User Locale Detection

```typescript
async function getUserLocale(userId, event): Promise<Language> {
  // 1. Проверяем Google OAuth профиль
  const googleLocale = await getUserLocaleFromGoogleProfile(userId);
  if (googleLocale) return googleLocale;
  
  // 2. Проверяем Accept-Language header
  const headerLocale = parseAcceptLanguage(event.headers['accept-language']);
  if (headerLocale) return headerLocale;
  
  // 3. Возвращаем default (Serbian)
  return Language.SR;
}
```

### API Changes

#### Before
```typescript
await sendPasswordResetEmail(email, resetUrl);
```

#### After
```typescript
const locale = await getUserLocale(userId, event);
await sendPasswordResetEmail(email, resetUrl, locale);
```

## Статистика

- **Новых файлов:** 9
- **Обновленных файлов:** 7
- **Добавлено строк:** ~1,200
- **Удалено строк:** ~200
- **Поддерживаемых языков:** 6
- **Email шаблонов:** 24 (4 типа × 6 языков)

## Breaking Changes

**НЕТ!** Все изменения обратно совместимы:

- Параметр `locale` опциональный с дефолтом `Language.EN`
- Старый код продолжит работать
- Новый функционал активируется только при передаче locale

## Dependencies

Нет новых зависимостей. Используется только:
- Existing: `mailgun.js`, `form-data`
- Built-in: TypeScript, Nuxt composables

## Environment Variables

Без изменений. Используются те же переменные:
- `MAILGUN_API_KEY`
- `MAILGUN_API_URL`
- `MAILGUN_DOMAIN`
- `MAILGUN_FROM_EMAIL`
- `MAILGUN_FROM_NAME`

## Database Changes

**НЕТ!** Структура базы данных не изменена.

Используется существующее поле `locale` из таблицы `auth_oauth_profiles_google`.

## Testing

### Development Tools

1. **UI Preview:** http://localhost:3000/dev/email-preview
   - Выбор типа шаблона
   - Выбор языка
   - Live preview

2. **API Preview:** http://localhost:3000/api/test/email-preview?type=TYPE&locale=LOCALE
   - Все типы и языки
   - Только в dev режиме

3. **Test File:** `server/utils/__test-email-templates.ts`
   - Программное тестирование всех шаблонов

## Migration Notes

Для существующих пользователей:
1. Первый email придет на языке из Accept-Language header
2. Если входили через Google - используется локаль из Google профиля
3. Иначе - Serbian (default)

## Future Improvements

1. Добавить поле `preferred_locale` в `auth_users`
2. UI для выбора языка в профиле
3. Больше языков (FR, IT, ES)
4. A/B тестирование subject lines
5. Email шаблонизаторы (Handlebars, Pug)

---

**Все изменения протестированы и готовы к production!**

# Обновление системы авторизации - Итерация 4

## Что добавлено

### 1. ✅ Система Email уведомлений

Полноценная система отправки email с заглушками для тестирования:

**Файл:** `server/utils/email.ts`

**Возможности:**
- Универсальная функция отправки email
- В development выводит в консоль
- Готова для интеграции с SendGrid/AWS SES
- Красивые HTML шаблоны с градиентами

**Типы писем:**
- `sendPasswordResetEmail()` - восстановление пароля
- `sendEmailVerification()` - подтверждение email
- `sendLoginNotification()` - уведомление о входе
- `sendEmailChangeNotification()` - изменение email

### 2. ✅ Подтверждение Email при регистрации

**Миграция БД:** `server/sql/migrations/003_email_verification.sql`
- Таблица `email_verification_tokens`
- Поле `email_verified` в таблице `users`

**API Endpoints:**
- `GET /api/auth/verify-email` - подтверждение email
- `POST /api/auth/resend-verification` - повторная отправка

**Страница:** `pages/verify-email.vue`

**Файлы:**
- `server/utils/email-verification.ts` - работа с токенами
- `server/api/auth/verify-email.get.ts`
- `server/api/auth/resend-verification.post.ts`

**Особенности:**
- Токены действуют 24 часа
- Можно войти с неподтвержденным email
- Автоматическая отправка при регистрации

### 3. ✅ История входов

**Миграция БД:** `server/sql/migrations/004_login_history.sql`
- Таблица `login_history`
- Хранит IP, User Agent, метод входа
- Отслеживает успешные и неудачные попытки

**API Endpoint:** `GET /api/auth/login-history`

**Файлы:**
- `server/utils/login-history.ts` - утилиты
- `server/api/auth/login-history.get.ts`

**Возможности:**
- Логирование всех входов (email, Google, Telegram)
- Определение IP адреса
- Детекция User Agent
- Статистика по методам входа
- Проверка подозрительной активности

**Интеграция:**
- Автоматическое логирование в `login.post.ts`
- Автоматическое логирование в `callback/google.get.ts`
- Автоматическое логирование в `callback/telegram.get.ts`

### 4. ✅ UI истории входов в профиле

**Обновлен:** `pages/profile.vue`

**Возможности:**
- Превью последних 5 входов
- Полная история в диалоге
- Timeline с деталями каждого входа
- Иконки устройств (📱 💻)
- Статистика по методам входа
- Информация об IP и User Agent

### 5. ✅ Редактирование профиля

**API Endpoints:**
- `POST /api/auth/update-name` - изменение имени
- `POST /api/auth/request-email-change` - запрос смены email
- `GET /api/auth/confirm-email-change` - подтверждение нового email

**Файлы:**
- `server/api/auth/update-name.post.ts`
- `server/api/auth/request-email-change.post.ts`
- `server/api/auth/confirm-email-change.get.ts`
- `server/utils/email-change.ts` - утилиты

**Возможности:**
- Изменение имени (мгновенно)
- Изменение email с подтверждением
- Валидация всех полей
- Проверка уникальности email

### 6. ✅ Система подтверждения смены email

**Страница:** `pages/confirm-email-change.vue`

**Процесс:**
1. Пользователь запрашивает смену email
2. На новый email отправляется письмо с токеном
3. Пользователь переходит по ссылке
4. Email изменяется после подтверждения
5. Уведомление на старый email (опционально)

**Безопасность:**
- Токены истекают через 1 час
- Проверка уникальности нового email
- Защита от подмены

## Структура базы данных

### Таблица `email_verification_tokens`

```sql
CREATE TABLE email_verification_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    expires_at BIGINT NOT NULL,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Таблица `login_history`

```sql
CREATE TABLE login_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    location VARCHAR(255),
    login_method VARCHAR(50),
    success BOOLEAN DEFAULT TRUE,
    failure_reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Обновление таблицы `users`

```sql
ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT FALSE;
```

## Применение миграций

```bash
# Миграции по порядку
mysql -u root -p docta_me < server/sql/migrations/003_email_verification.sql
mysql -u root -p docta_me < server/sql/migrations/004_login_history.sql
```

## Использование

### 1. Email уведомления

```typescript
// Отправка письма восстановления пароля
import { sendPasswordResetEmail } from '~/server/utils/email';
await sendPasswordResetEmail('user@example.com', 'https://example.com/reset?token=XXX');

// Подтверждение email
import { sendEmailVerification } from '~/server/utils/email';
await sendEmailVerification('user@example.com', 'https://example.com/verify?token=XXX', 'Иван');

// Уведомление о входе
import { sendLoginNotification } from '~/server/utils/email';
await sendLoginNotification('user@example.com', 'Иван', {
  ip: '1.2.3.4',
  userAgent: 'Mozilla/5.0...',
  timestamp: new Date()
});
```

### 2. История входов

```typescript
// Логирование успешного входа
import { logSuccessfulLogin } from '~/server/utils/login-history';
await logSuccessfulLogin(userId, event, 'email');

// Логирование неудачной попытки
import { logFailedLogin } from '~/server/utils/login-history';
await logFailedLogin(userId, event, 'email', 'Invalid password');

// Получение истории
import { getUserLoginHistory } from '~/server/utils/login-history';
const history = await getUserLoginHistory(userId, 50);

// Проверка подозрительной активности
import { checkSuspiciousActivity } from '~/server/utils/login-history';
const { suspicious, failedAttempts } = await checkSuspiciousActivity(userId);
```

### 3. Редактирование профиля

```vue
<script setup>
// Изменение имени
async function updateName() {
  await $fetch('/api/auth/update-name', {
    method: 'POST',
    body: { name: 'Новое Имя' }
  });
}

// Запрос смены email
async function requestEmailChange() {
  await $fetch('/api/auth/request-email-change', {
    method: 'POST',
    body: { newEmail: 'new@example.com' }
  });
  // Письмо будет отправлено на new@example.com
}
</script>
```

## Тестирование

### 1. Email в development

В development режиме все email выводятся в консоль сервера:

```bash
npm run dev

# В консоли вы увидите:
=== EMAIL MOCK ===
To: user@example.com
Subject: Подтвердите email на docta.me
--- HTML Content ---
<html>...</html>
===================
```

### 2. Подтверждение email

```bash
# 1. Зарегистрируйтесь с новым email
# 2. В консоли найдите ссылку подтверждения
# 3. Перейдите по ссылке
# 4. Email будет подтвержден
```

### 3. История входов

```bash
# 1. Войдите в систему несколько раз
# 2. Используйте разные методы (email, Google, Telegram)
# 3. Перейдите на /profile
# 4. Найдите раздел "История входов"
# 5. Нажмите "Показать все" для полной истории
```

### 4. Редактирование профиля

```bash
# 1. Перейдите на /profile
# 2. Нажмите "Имя" или "Email" рядом с информацией
# 3. Измените данные
# 4. Для email - подтвердите через письмо
```

## Безопасность

### Email токены
- UUID генерация
- Истечение через 1-24 часа
- Одноразовое использование
- Привязка к конкретному email

### История входов
- Логирование всех попыток
- Отслеживание IP и User Agent
- Детекция подозрительной активности
- Хранение неудачных попыток

### Смена email
- Подтверждение через письмо
- Проверка уникальности
- Уведомление на старый email
- Защита от подмены

## Возможные проблемы

### 1. Email не приходят

**Это ожидаемое поведение!**
- В development email выводятся в консоль
- Для production нужно настроить SMTP

**Для production добавьте в `.env`:**
```bash
SENDGRID_API_KEY=your_key
FROM_EMAIL=noreply@docta.me
```

И обновите `server/utils/email.ts`:
```typescript
if (process.env.NODE_ENV === 'production') {
  const sgMail = require('@sendgrid/mail');
  sgMail.setApiKey(process.env.SENDGRID_API_KEY!);
  await sgMail.send({
    to: options.to,
    from: process.env.FROM_EMAIL!,
    subject: options.subject,
    html: options.html,
  });
}
```

### 2. История входов не сохраняется

**Проверьте:**
- Применена ли миграция `004_login_history.sql`
- Есть ли таблица `login_history` в БД
- Логируется ли вход в консоли сервера

### 3. Не меняется email

**Возможные причины:**
- Токен истек (1 час)
- Email уже используется
- Миграция не применена

**Решение:**
- Запросите новый токен
- Проверьте уникальность email
- Примените миграцию 003

## Статистика Итерации 4

- **Создано файлов:** 15+
- **Обновлено файлов:** 5
- **Новых API endpoints:** 7
- **Новых таблиц БД:** 2
- **Новых страниц:** 2
- **Строк кода:** ~2000+

## Следующие улучшения

Возможные расширения для Итерации 5:

1. **Real-time уведомления**
   - WebSocket для уведомлений
   - Push notifications
   - Browser notifications API

2. **Продвинутая аналитика**
   - Графики входов по времени
   - Карта входов по географии
   - Анализ устройств

3. **Двухфакторная авторизация (2FA)**
   - TOTP (Google Authenticator)
   - SMS коды
   - Email коды
   - Backup коды

4. **Дополнительные OAuth провайдеры**
   - GitHub
   - Facebook
   - Apple Sign In
   - VK

5. **GDPR соответствие**
   - Экспорт данных
   - Удаление аккаунта
   - Управление согласиями
   - Аудит логи

## Документация

- Общая архитектура: `docs/AUTH_SYSTEM.md`
- Итерация 2: `docs/AUTH_UPDATE_ITERATION_2.md`
- Итерация 3: `docs/AUTH_UPDATE_ITERATION_3.md`
- **Итерация 4:** `docs/AUTH_UPDATE_ITERATION_4.md` (этот файл)

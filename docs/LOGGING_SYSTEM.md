# Система логирования

## Обзор

В проекте используется централизованная система логирования на основе **consola** (официальной библиотеки для Nuxt).

## Преимущества

✅ **Структурированные логи** с временными метками и уровнями важности  
✅ **Модульная организация** - отдельные логгеры для разных частей приложения  
✅ **Автоматическая фильтрация** чувствительных данных (пароли, токены)  
✅ **Настраиваемые уровни** логирования для dev/prod окружений  
✅ **Цветной вывод** в терминале для удобства разработки

## Использование

### Базовый импорт

```typescript
import { authLogger, emailLogger, dbLogger } from '~/server/utils/logger';
```

### Доступные логгеры

- `authLogger` - для всех операций авторизации и аутентификации
- `emailLogger` - для отправки email
- `dbLogger` - для операций с базой данных
- `billingLogger` - для биллинга

### Создание нового модульного логгера

```typescript
import { createModuleLogger } from '~/server/utils/logger';

const myLogger = createModuleLogger('my-module');
```

## Уровни логирования

Consola поддерживает следующие уровни:

- `logger.debug('debug info', { data })` - детальная отладочная информация (только в dev)
- `logger.info('operation completed', { userId })` - информационные сообщения
- `logger.warn('something unusual', { context })` - предупреждения
- `logger.error('error occurred', { error })` - ошибки

## Хелперы для стандартных операций

### logOperation - успешные операции

```typescript
import { authLogger, logOperation } from '~/server/utils/logger';

logOperation(authLogger, 'User registered', {
	userId: 123,
	email: 'user@example.com',
	// password будет автоматически удален
});
```

### logError - обработка ошибок

```typescript
import { authLogger, logError } from '~/server/utils/logger';

try {
	// ваш код
} catch (error) {
	logError(authLogger, 'Registration failed', error, {
		email: 'user@example.com',
	});
}
```

## Автоматическая фильтрация

Следующие поля **автоматически удаляются** из логов:

- `password`
- `token`
- `accessToken`

Это защищает от утечки чувствительных данных в логи.

## Примеры из кода

### API endpoint

```typescript
import { authLogger, logOperation, logError } from '~/server/utils/logger';

export default defineEventHandler(async (event) => {
	try {
		// выполняем операцию
		await updateUserName(userId, newName);

		logOperation(authLogger, 'Name updated', {
			userId,
			newName,
		});

		return { success: true };
	} catch (error: any) {
		logError(authLogger, 'Update name failed', error, { userId });
		throw createError({ statusCode: 500 });
	}
});
```

### Утилита

```typescript
import { emailLogger } from '~/server/utils/logger';

export async function sendEmail(options: EmailOptions) {
	emailLogger.info('Sending email', { to: options.to });

	try {
		await mailgun.send(options);
		emailLogger.info('Email sent successfully', { to: options.to });
	} catch (error) {
		emailLogger.error('Failed to send email', { error, to: options.to });
	}
}
```

## Конфигурация окружений

### Development

- Уровень: `debug` (4) - показываются все логи
- Цветной вывод в терминале
- Детальные временные метки

### Production

- Уровень: `info` (3) - debug логи скрываются
- Структурированный JSON вывод
- Можно интегрировать с системами сбора логов

## Просмотр логов

### В разработке

Логи автоматически выводятся в терминал где запущен `npm run dev`:

```bash
[14:23:45]  INFO  [auth] User registered { userId: 123, email: 'user@example.com' }
[14:23:46]  INFO  [email] Email sent successfully { to: 'user@example.com' }
```

### В продакшене

Логи можно собирать через:

- Docker logs: `docker logs <container-id>`
- PM2: `pm2 logs`
- Сервисы логирования: Sentry, LogRocket, Datadog

## Миграция с console.log

❌ **Старый подход:**

```typescript
console.log('[Auth] User logged in:', userId);
console.error('Login failed:', error);
```

✅ **Новый подход:**

```typescript
import { authLogger } from '~/server/utils/logger';

authLogger.info('User logged in', { userId });
authLogger.error('Login failed', { error });
```

## Лучшие практики

1. **Используйте структурированные данные** вместо конкатенации строк
2. **Добавляйте контекст** (userId, email, операция) для упрощения отладки
3. **Выбирайте правильный уровень**:
   - `debug` - для отладки разработки
   - `info` - для важных операций
   - `warn` - для необычных ситуаций
   - `error` - только для реальных ошибок
4. **Не логируйте в циклах** - может засорить логи
5. **Создавайте модульные логгеры** для новых областей приложения

## Дополнительная документация

- [Consola GitHub](https://github.com/unjs/consola)
- [Nuxt Logging](https://nuxt.com/docs/api/utils/console)

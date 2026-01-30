# Итерация 2: Email/Password авторизация для админов

[← К списку итераций](README.md) | [← Предыдущая итерация](iteration-01-database.md) | [Следующая итерация →](iteration-03-oauth-google.md)

---

## Цель

Реализовать авторизацию для администраторов через email + password с защитой админских роутов.

## Зависимости

- Итерация 1: База данных (таблица users с полями password_hash, is_admin)

## Задачи

1. Создать страницу входа `/admin/login` с формой email/password
2. Создать API endpoint для авторизации админов `POST /api/admin/auth/login`
3. Создать API endpoint для выхода `POST /api/admin/auth/logout`
4. Создать middleware `adminAuth` для защиты админских роутов
5. Настроить session management для админов
6. Создать утилиты для хеширования/проверки паролей (bcrypt)
7. Документировать процесс создания админа вручную в БД

## Технические детали

### 1. Создать страницу: `pages/admin/login.vue`

Форма авторизации для администраторов.

**Поля:**
- Email (input type="email", required)
- Password (input type="password", required)
- Кнопка "Войти"

**Функциональность:**
- Валидация на фронтенде (непустые поля, валидный email)
- POST запрос на `/api/admin/auth/login`
- При успехе: редирект на `/admin/dashboard` (или другую админскую страницу)
- При ошибке: показать сообщение об ошибке

**UI:**
- Использовать Element Plus компоненты (el-form, el-input, el-button)
- Центрированная форма
- Минимальный дизайн (логотип + форма)

### 2. Создать API: `server/api/admin/auth/login.post.ts`

Endpoint для авторизации администраторов.

**Вход:**
```typescript
{
  email: string,
  password: string
}
```

**Логика:**
1. Найти пользователя по email
2. Проверить `is_admin === true`
3. Проверить `password_hash !== null`
4. Сравнить пароль с хешем (bcrypt.compare)
5. При успехе:
   - Создать сессию в БД (таблица sessions)
   - Установить HTTPOnly cookie с session_id
   - Вернуть данные пользователя (без password_hash)
6. При ошибке:
   - Вернуть 401 Unauthorized с сообщением "Неверный email или пароль"

**Выход:**
```typescript
{
  success: true,
  user: {
    id: number,
    email: string,
    name: string,
    is_admin: boolean
  }
}
```

### 3. Создать API: `server/api/admin/auth/logout.post.ts`

Endpoint для выхода из системы.

**Логика:**
1. Получить session_id из cookie
2. Удалить сессию из БД
3. Очистить cookie
4. Вернуть success

### 4. Создать middleware: `server/middleware/adminAuth.ts`

Middleware для защиты админских роутов.

**Логика:**
1. Проверить наличие session_id в cookie
2. Найти сессию в БД
3. Проверить срок действия сессии (expires_at)
4. Загрузить пользователя по user_id
5. Проверить `is_admin === true`
6. При успехе: добавить user в event.context.user
7. При ошибке: вернуть 401 Unauthorized

**Применение:**
- Автоматически применяется ко всем роутам `/api/admin/*` (кроме `/api/admin/auth/login`)

### 5. Создать утилиты: `server/utils/password.ts`

Утилиты для работы с паролями.

```typescript
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 10;

/**
 * Хеширует пароль с помощью bcrypt
 */
export async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

/**
 * Сравнивает пароль с хешем
 */
export async function comparePassword(
  password: string,
  hash: string
): Promise<boolean> {
  return bcrypt.compare(password, hash);
}
```

### 6. Обновить: `server/utils/session.ts`

Утилиты для управления сессиями.

```typescript
import type { H3Event } from 'h3';
import { randomUUID } from 'crypto';

const SESSION_DURATION = 30 * 24 * 60 * 60; // 30 дней в секундах

/**
 * Создает новую сессию для пользователя
 */
export async function createSession(userId: number): Promise<string> {
  const sessionId = randomUUID();
  const expiresAt = Math.floor(Date.now() / 1000) + SESSION_DURATION;
  
  // Сохранить в БД
  await db.execute(
    'INSERT INTO sessions (id, user_id, expires_at) VALUES (?, ?, ?)',
    [sessionId, userId, expiresAt]
  );
  
  return sessionId;
}

/**
 * Устанавливает session cookie
 */
export function setSessionCookie(event: H3Event, sessionId: string) {
  setCookie(event, 'session_id', sessionId, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: SESSION_DURATION,
    path: '/'
  });
}

/**
 * Удаляет сессию
 */
export async function deleteSession(sessionId: string) {
  await db.execute('DELETE FROM sessions WHERE id = ?', [sessionId]);
}

/**
 * Получает пользователя из сессии
 */
export async function getUserFromSession(sessionId: string) {
  const result = await db.execute(
    `SELECT u.* FROM users u
     JOIN sessions s ON u.id = s.user_id
     WHERE s.id = ? AND s.expires_at > UNIX_TIMESTAMP()`,
    [sessionId]
  );
  
  return result.rows[0] || null;
}
```

## Критерии приемки (AC)

- [ ] AC-1: Страница `/admin/login` существует и доступна
- [ ] AC-2: Форма логина содержит поля email и password
- [ ] AC-3: Форма валидирует обязательные поля
- [ ] AC-4: При вводе корректных данных администратора происходит успешный вход
- [ ] AC-5: При вводе неверного пароля показывается ошибка "Неверный email или пароль"
- [ ] AC-6: При вводе email не-администратора показывается ошибка
- [ ] AC-7: После успешного входа создается сессия в БД
- [ ] AC-8: После успешного входа устанавливается HTTPOnly cookie
- [ ] AC-9: После успешного входа происходит редирект на админскую страницу
- [ ] AC-10: Middleware `adminAuth` блокирует доступ к `/api/admin/*` для неавторизованных
- [ ] AC-11: Middleware `adminAuth` пропускает запросы с валидной сессией админа
- [ ] AC-12: Endpoint `/api/admin/auth/logout` удаляет сессию из БД
- [ ] AC-13: После logout очищается cookie
- [ ] AC-14: Пароли хешируются с использованием bcrypt (cost >= 10)

## Инструкции по проверке

### 1. Создать тестового администратора

```bash
# Подключиться к БД
mysql -u root -p docta_me

# Создать хеш пароля (используя Node.js)
node -e "const bcrypt = require('bcrypt'); bcrypt.hash('admin123', 10).then(console.log)"

# Вставить администратора (замените HASH на результат выше)
INSERT INTO users (email, name, password_hash, is_admin) VALUES
('admin@docta.me', 'Admin User', 'HASH', TRUE);
```

### 2. Тест: Успешный вход

1. Открыть `http://localhost:3000/admin/login`
2. Ввести email: `admin@docta.me`
3. Ввести password: `admin123`
4. Нажать "Войти"
5. **Ожидается:** Редирект на админскую страницу, создана сессия

### 3. Тест: Неверный пароль

1. Открыть `http://localhost:3000/admin/login`
2. Ввести email: `admin@docta.me`
3. Ввести password: `wrongpassword`
4. Нажать "Войти"
5. **Ожидается:** Ошибка "Неверный email или пароль"

### 4. Тест: Не-администратор

1. Создать обычного пользователя (is_admin=false)
2. Попытаться войти с его данными
3. **Ожидается:** Ошибка авторизации

### 5. Тест: Middleware защиты

1. Без входа в систему попробовать открыть админский API
2. **Ожидается:** 401 Unauthorized
3. После входа попробовать снова
4. **Ожидается:** Доступ разрешен

### 6. Тест: Logout

1. Войти как администратор
2. Вызвать `POST /api/admin/auth/logout`
3. Проверить БД: сессия удалена
4. Проверить cookie: очищен
5. Попытаться получить доступ к защищенному роуту
6. **Ожидается:** 401 Unauthorized

## Документация

### Создание нового администратора (вручную)

Поскольку регистрация админов закрыта, новые администраторы создаются вручную в БД:

```bash
# 1. Сгенерировать хеш пароля
node -e "const bcrypt = require('bcrypt'); bcrypt.hash('your_password', 10).then(console.log)"

# 2. Вставить в БД
INSERT INTO users (email, name, password_hash, is_admin) VALUES
('new_admin@docta.me', 'New Admin Name', 'GENERATED_HASH', TRUE);
```

**Важно:**
- Используйте сильные пароли (минимум 12 символов)
- Храните пароли в безопасном месте (password manager)
- Не коммитьте реальные пароли в git

## Следующие шаги

После завершения этой итерации:

1. ✅ Администраторы могут входить в систему
2. ✅ Админские роуты защищены
3. ⏳ Следующая итерация: OAuth для обычных пользователей (Google)

---

**Предыдущая итерация:** [← База данных](iteration-01-database.md)  
**Следующая итерация:** [OAuth через Google →](iteration-03-oauth-google.md)

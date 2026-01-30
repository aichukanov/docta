# Быстрый старт: Авторизация для админки

> **ВАЖНО:** В первую очередь реализуем авторизацию для администраторов, затем OAuth для пользователей.

## Шаг 1: База данных (Итерация 1)

### Создать миграцию

Файл: `server/sql/migrations/001_auth_basic.sql`

```sql
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    photo_url VARCHAR(500),
    password_hash VARCHAR(255) NULL,      -- Для админов
    is_admin BOOLEAN DEFAULT FALSE,       -- Флаг админа
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_is_admin (is_admin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- oauth_accounts и sessions - см. prd/auth/04-database.md
```

### Создать первого админа

```bash
# 1. Генерируем хеш пароля
node -e "const bcrypt = require('bcrypt'); bcrypt.hash('admin123', 10).then(console.log)"

# 2. Вставляем в БД (замените HASH на результат из шага 1)
mysql -u root -p docta_me
INSERT INTO users (email, name, password_hash, is_admin) VALUES
('admin@docta.me', 'Admin User', 'HASH_HERE', TRUE);
```

## Шаг 2: Авторизация админов (Итерация 2)

### Установить зависимости

```bash
npm install bcrypt
```

### Создать страницу входа

Файл: `pages/admin/login.vue`

```vue
<template>
  <div class="admin-login">
    <el-form @submit.prevent="handleLogin">
      <el-form-item label="Email">
        <el-input v-model="form.email" type="email" required />
      </el-form-item>
      <el-form-item label="Пароль">
        <el-input v-model="form.password" type="password" required />
      </el-form-item>
      <el-button type="primary" native-type="submit">Войти</el-button>
    </el-form>
  </div>
</template>

<script setup lang="ts">
const form = reactive({ email: '', password: '' });

async function handleLogin() {
  const { data, error } = await useFetch('/api/admin/auth/login', {
    method: 'POST',
    body: form
  });
  
  if (error.value) {
    ElMessage.error('Неверный email или пароль');
  } else {
    navigateTo('/admin/dashboard');
  }
}
</script>
```

### Создать API endpoint

Файл: `server/api/admin/auth/login.post.ts`

```typescript
import bcrypt from 'bcrypt';
import { createSession, setSessionCookie } from '~/server/utils/session';

export default defineEventHandler(async (event) => {
  const { email, password } = await readBody(event);
  
  // 1. Найти пользователя
  const user = await db.execute(
    'SELECT * FROM users WHERE email = ? AND is_admin = TRUE',
    [email]
  ).then(r => r.rows[0]);
  
  if (!user || !user.password_hash) {
    throw createError({ statusCode: 401, message: 'Неверный email или пароль' });
  }
  
  // 2. Проверить пароль
  const valid = await bcrypt.compare(password, user.password_hash);
  if (!valid) {
    throw createError({ statusCode: 401, message: 'Неверный email или пароль' });
  }
  
  // 3. Создать сессию
  const sessionId = await createSession(user.id);
  setSessionCookie(event, sessionId);
  
  return {
    success: true,
    user: {
      id: user.id,
      email: user.email,
      name: user.name,
      is_admin: user.is_admin
    }
  };
});
```

### Создать middleware

Файл: `server/middleware/adminAuth.ts`

```typescript
import { getUserFromSession } from '~/server/utils/session';

export default defineEventHandler(async (event) => {
  const path = event.node.req.url;
  
  // Пропускаем публичные роуты
  if (path?.startsWith('/api/admin/auth/login')) {
    return;
  }
  
  // Защищаем админские роуты
  if (path?.startsWith('/api/admin/')) {
    const sessionId = getCookie(event, 'session_id');
    if (!sessionId) {
      throw createError({ statusCode: 401, message: 'Unauthorized' });
    }
    
    const user = await getUserFromSession(sessionId);
    if (!user || !user.is_admin) {
      throw createError({ statusCode: 403, message: 'Forbidden' });
    }
    
    event.context.user = user;
  }
});
```

## Проверка

### Тест 1: Успешный вход

1. Открыть `http://localhost:3000/admin/login`
2. Ввести email: `admin@docta.me`
3. Ввести password: `admin123`
4. Нажать "Войти"
5. **Ожидается:** Редирект на `/admin/dashboard`

### Тест 2: Неверный пароль

1. Открыть `/admin/login`
2. Ввести неверный пароль
3. **Ожидается:** Ошибка "Неверный email или пароль"

### Тест 3: Middleware

1. Без входа попробовать открыть `/api/admin/users`
2. **Ожидается:** 401 Unauthorized

## Что дальше?

После завершения Итерации 2 (Админская авторизация):

→ **Итерация 3:** OAuth через Google  
→ **Итерация 4:** OAuth через Telegram  
→ **Итерация 5:** UI компоненты для обычных пользователей

---

**Полная документация:** [prd/auth/index.md](./index.md)  
**Детали Итерации 2:** [iterations/iteration-02-admin-auth.md](./iterations/iteration-02-admin-auth.md)

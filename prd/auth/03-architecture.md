# 3. Техническая архитектура

[← Назад к оглавлению](index.md)

---

## 3.1 Стек технологий

- **Frontend:** Nuxt 3, Element Plus (UI components), Pinia (state management)
- **Backend:** Nuxt 3 Server API, MySQL
- **Auth:** `@sidebase/nuxt-auth` или `next-auth` (для OAuth)
- **OAuth провайдеры:** Google OAuth 2.0, Telegram Login Widget
- **Session:** Redis или database-based sessions
- **Middleware:** Nuxt middleware для защиты роутов

## 3.2 API Endpoints

### Auth

- `GET /api/auth/[...].ts` - OAuth callbacks и сессии (через nuxt-auth)
- `POST /api/auth/logout` - Выход из системы
- `GET /api/auth/session` - Получить текущую сессию

### User

- `GET /api/user/profile` - Получить профиль текущего пользователя
- `PUT /api/user/profile` - Обновить профиль
- `POST /api/user/become-doctor` - Создать профиль врача для пользователя
- `GET /api/user/my-clinics` - Получить список клиник пользователя

### Clinic

- `POST /api/clinics` - Создать клинику
- `PUT /api/clinics/[id]` - Обновить клинику (требует прав)
- `GET /api/clinics/[id]/access` - Проверить права доступа к клинике
- `POST /api/clinics/[id]/request-verification` - Отправить на верификацию
- `GET /api/clinics/my` - Получить клиники, где пользователь имеет доступ

### Clinic Verification

- `POST /api/clinics/[id]/verify-via-oauth` - Верифицировать клинику через OAuth контакт
- `GET /api/clinics/[id]/verification-status` - Получить статус верификации контактов

### Clinic Access

- `POST /api/clinics/[id]/join-request` - Запрос на присоединение
- `GET /api/clinics/[id]/join-requests` - Список запросов (только для админов)
- `PUT /api/clinics/[id]/join-requests/[requestId]` - Одобрить/отклонить запрос
- `GET /api/clinics/[id]/users` - Список пользователей с доступом
- `DELETE /api/clinics/[id]/users/[userId]` - Удалить доступ пользователя

### Admin

- `GET /api/admin/clinics/pending` - Список клиник на верификации
- `PUT /api/admin/clinics/[id]/verify` - Верифицировать клинику
- `PUT /api/admin/clinics/[id]/reject` - Отклонить клинику
- `GET /api/admin/audit-logs` - Просмотр аудит логов

## 3.3 Frontend Компоненты

### Auth

- `components/auth/LoginModal.vue` - Модальное окно входа с кнопками OAuth
- `components/auth/UserMenu.vue` - Меню пользователя (аватар, имя, выход)
- `components/auth/ProtectedRoute.vue` - Wrapper для защищенных страниц

### User

- `pages/profile/index.vue` - Страница профиля пользователя
- `pages/profile/doctor.vue` - Создание/редактирование профиля врача
- `components/user/ProfileForm.vue` - Форма редактирования профиля
- `components/user/DoctorForm.vue` - Форма создания/редактирования врача

### Clinic

- `pages/clinics/new.vue` - Создание новой клиники
- `pages/clinics/[id]/edit.vue` - Редактирование клиники
- `pages/clinics/[id]/verify-callback.vue` - Callback после OAuth верификации
- `components/clinic/ClinicForm.vue` - Форма клиники
- `components/clinic/VerifyViaOAuthButton.vue` - Компонент верификации через OAuth
- `components/clinic/ClinicAccessManager.vue` - Управление доступом к клинике
- `components/clinic/JoinRequestList.vue` - Список запросов на присоединение
- `components/clinic/JoinRequestButton.vue` - Кнопка запроса на присоединение

### Admin

- `pages/admin/dashboard.vue` - Админ панель
- `pages/admin/clinics/verification.vue` - Страница верификации клиник
- `components/admin/ClinicVerificationCard.vue` - Карточка клиники для верификации
- `components/admin/AuditLogTable.vue` - Таблица аудит логов

## 3.4 Диаграммы

### Схема связей

```
users (1) -----> (0..1) doctors (через user_id или doctor_id)
users (1) -----> (N) oauth_accounts
users (1) -----> (N) sessions
users (N) <-----> (N) clinics (через clinic_users)
users (N) -----> (N) clinic_join_requests

clinics.created_by --> users.id
clinics.status (draft | pending_verification | published | rejected)
```

### Flow регистрации

```
1. User кликает "Login with Google"
2. OAuth redirect -> Google
3. Google callback -> /api/auth/callback/google
4. Проверка: user exists?
   - Да: Login
   - Нет: Create user + Create oauth_account
5. Create session
6. Redirect to /profile
```

### Flow создания клиники

```
1. User (authenticated) -> /clinics/new
2. Заполняет форму клиники
3. POST /api/clinics
4. Backend:
   - Create clinic (status: draft, created_by: user.id)
   - Create clinic_users (clinic_id, user_id, role: admin)
   - Create audit_log
5. Redirect to /clinics/[id]/edit
```

### Flow верификации через OAuth

```
1. User создает клинику с email admin@clinic.com
2. User нажимает "Подтвердить через OAuth"
3. OAuth flow с Google
4. Callback проверяет: user.email === clinic.email?
5. Если ДА:
   - Create clinic_verified_contacts
   - UPDATE clinic SET is_contact_verified = TRUE, status = 'published'
   - INSERT clinic_users (role: admin)
6. Redirect to /clinics/[id] с успехом
```

---

**Предыдущая секция:** [← 2. Требования](02-requirements.md)  
**Следующая секция:** [4. База данных →](04-database.md)

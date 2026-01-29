# 4. Схема базы данных

[← Назад к оглавлению](index.md)

---

## Новые таблицы

### users - Пользователи

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    photo_url VARCHAR(500),
    doctor_id INT NULL, -- FK к doctors.id (если пользователь является врачом)
    is_superadmin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE SET NULL
);
```

### oauth_accounts - OAuth аккаунты

```sql
CREATE TABLE oauth_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(50) NOT NULL, -- 'google', 'telegram'
    provider_account_id VARCHAR(255) NOT NULL, -- ID из OAuth провайдера
    access_token TEXT,
    refresh_token TEXT,
    expires_at BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_provider_account (provider, provider_account_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### sessions - Сессии

```sql
CREATE TABLE sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL,
    expires_at BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### clinic_users - Пользователи клиник

```sql
CREATE TABLE clinic_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_id INT NOT NULL,
    user_id INT NOT NULL,
    role ENUM('admin', 'editor') NOT NULL DEFAULT 'editor',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_clinic_user (clinic_id, user_id),
    FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### clinic_join_requests - Запросы на присоединение

```sql
CREATE TABLE clinic_join_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_id INT NOT NULL,
    user_id INT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    message TEXT, -- Сообщение от пользователя
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    reviewed_by INT, -- user_id который рассмотрел запрос
    reviewed_at TIMESTAMP NULL,
    UNIQUE KEY unique_pending_request (clinic_id, user_id, status),
    FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
);
```

### audit_logs - Аудит лог

```sql
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL, -- 'clinic_created', 'clinic_verified', 'user_joined_clinic'
    entity_type VARCHAR(50), -- 'clinic', 'doctor', 'user'
    entity_id INT,
    details JSON, -- Дополнительная информация
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
```

### clinic_verified_contacts - Верификационные контакты

```sql
CREATE TABLE clinic_verified_contacts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_id INT NOT NULL,
    contact_type ENUM('email', 'phone', 'telegram', 'whatsapp', 'viber') NOT NULL,
    contact_value VARCHAR(255) NOT NULL,
    verified_by_user_id INT NOT NULL, -- Кто подтвердил доступ
    verified_via_oauth_account_id INT NULL, -- Какой OAuth аккаунт использовался
    verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_primary BOOLEAN DEFAULT FALSE, -- Основной контакт для верификации
    UNIQUE KEY unique_clinic_contact (clinic_id, contact_type, contact_value),
    INDEX idx_contact_value (contact_value),
    FOREIGN KEY (clinic_id) REFERENCES clinics(id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by_user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (verified_via_oauth_account_id) REFERENCES oauth_accounts(id) ON DELETE SET NULL
);
```

## Изменения существующих таблиц

### clinics - Добавление статусов и верификации

```sql
-- Добавить статусы для клиник
ALTER TABLE clinics ADD COLUMN status ENUM('draft', 'pending_verification', 'published', 'rejected')
    NOT NULL DEFAULT 'draft' AFTER updated_at;

-- Флаг верификации через контакты
ALTER TABLE clinics ADD COLUMN is_contact_verified BOOLEAN DEFAULT FALSE AFTER status;

-- Создатель клиники
ALTER TABLE clinics ADD COLUMN created_by INT NULL AFTER is_contact_verified;
ALTER TABLE clinics ADD FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL;
```

### doctors - Добавление верификации и связи с пользователем

```sql
-- Флаг верификации врача
ALTER TABLE doctors ADD COLUMN is_verified BOOLEAN DEFAULT FALSE AFTER updated_at;

-- Связь с пользователем
ALTER TABLE doctors ADD COLUMN user_id INT NULL AFTER is_verified;
ALTER TABLE doctors ADD FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;
```

## Схема связей

```
┌─────────┐
│  users  │◄────────┐
└────┬────┘         │
     │              │
     │ 1            │ N
     │              │
     ▼              │
┌──────────────┐   │
│oauth_accounts│───┘
└──────────────┘

┌─────────┐     ┌──────────────┐     ┌─────────┐
│  users  │────►│clinic_users  │◄────│ clinics │
└────┬────┘  N  └──────────────┘  N  └────┬────┘
     │                                      │
     │ 0..1                                 │ 1
     │                                      │
     ▼                                      ▼
┌─────────┐                         ┌──────────────────────┐
│ doctors │                         │clinic_verified_contacts│
└─────────┘                         └──────────────────────┘
```

## Индексы для производительности

```sql
-- Частые запросы по email
CREATE INDEX idx_users_email ON users(email);

-- Поиск OAuth аккаунтов
CREATE INDEX idx_oauth_provider ON oauth_accounts(provider, provider_account_id);

-- Проверка прав доступа к клиникам
CREATE INDEX idx_clinic_users_clinic ON clinic_users(clinic_id);
CREATE INDEX idx_clinic_users_user ON clinic_users(user_id);

-- Фильтр запросов по статусу
CREATE INDEX idx_join_requests_status ON clinic_join_requests(status);
CREATE INDEX idx_join_requests_clinic ON clinic_join_requests(clinic_id, status);

-- Поиск по контактам
-- Уже создан: INDEX idx_contact_value ON clinic_verified_contacts(contact_value);

-- Фильтр клиник по статусу
CREATE INDEX idx_clinics_status ON clinics(status);
CREATE INDEX idx_clinics_created_by ON clinics(created_by);
```

---

**Предыдущая секция:** [← 3. Архитектура](03-architecture.md)  
**Следующая секция:** [Итерации разработки →](iterations/iteration-01-database.md)

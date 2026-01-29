# Итерация 1: База данных отзывов

[← К списку итераций](README.md) | [Следующая →](iteration-02-basic-reviews.md)

---

## Статус: 🔴 Not Started

---

## Цель

Создать полную схему базы данных для хранения отзывов, верификационных файлов, логов модерации и AI Summary.

## Зависимости

**Требуется перед началом:**

- ✅ **auth** - таблица `users` должна существовать
- ✅ **doctor-profile** - таблица `doctors` должна существовать
- ✅ **clinic-profile** - таблица `clinics` должна существовать

**Блокирующие факторы:**

- Нет

---

## Задачи

### 1. Создание таблицы `reviews`

Основная таблица для хранения всех отзывов (внутренних и внешних).

**Файл:** `server/database/migrations/XXX_create_reviews_table.sql`

```sql
CREATE TABLE reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,

  -- Тип и цель отзыва
  target_type ENUM('doctor', 'clinic') NOT NULL,
  target_id INT NOT NULL,

  -- Автор (NULL для внешних отзывов)
  user_id INT NULL,

  -- Тип отзыва
  review_type ENUM('internal', 'external') NOT NULL DEFAULT 'internal',

  -- Для внешних отзывов
  external_source VARCHAR(50) NULL,
  external_source_url VARCHAR(500) NULL,
  external_author_name VARCHAR(255) NULL,
  external_review_date DATE NULL,

  -- Оценки
  rating TINYINT NOT NULL,
  criteria_professionalism TINYINT NULL,
  criteria_attitude TINYINT NULL,
  criteria_quality TINYINT NULL,
  criteria_price_quality TINYINT NULL,

  -- Контент
  text TEXT NULL,
  language VARCHAR(10) DEFAULT 'ru',

  -- Статусы
  status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  is_verified BOOLEAN DEFAULT FALSE,

  -- Метаданные
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  moderated_at TIMESTAMP NULL,
  moderated_by INT NULL,
  rejection_reason TEXT NULL,

  -- Soft delete
  deleted_at TIMESTAMP NULL,

  -- Индексы
  INDEX idx_target (target_type, target_id),
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_type (review_type),
  INDEX idx_created (created_at),

  -- Ограничения
  CONSTRAINT fk_review_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_review_moderator FOREIGN KEY (moderated_by)
    REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT chk_rating CHECK (rating >= 1 AND rating <= 5),
  CONSTRAINT chk_criteria CHECK (
    (criteria_professionalism IS NULL OR (criteria_professionalism >= 1 AND criteria_professionalism <= 5)) AND
    (criteria_attitude IS NULL OR (criteria_attitude >= 1 AND criteria_attitude <= 5)) AND
    (criteria_quality IS NULL OR (criteria_quality >= 1 AND criteria_quality <= 5)) AND
    (criteria_price_quality IS NULL OR (criteria_price_quality >= 1 AND criteria_price_quality <= 5))
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 2. Создание таблицы `review_verification_files`

Таблица для хранения файлов верификации (чеки, назначения).

**Файл:** `server/database/migrations/XXX_create_review_verification_files_table.sql`

```sql
CREATE TABLE review_verification_files (
  id INT AUTO_INCREMENT PRIMARY KEY,
  review_id INT NOT NULL UNIQUE,

  -- Файл
  file_path VARCHAR(500) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_type VARCHAR(50) NOT NULL,
  file_size INT NOT NULL,

  -- Статус верификации
  verification_status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  verified_at TIMESTAMP NULL,
  verified_by INT NULL,
  rejection_reason TEXT NULL,

  -- Метаданные
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- Ограничения
  CONSTRAINT fk_verification_review FOREIGN KEY (review_id)
    REFERENCES reviews(id) ON DELETE CASCADE,
  CONSTRAINT fk_verification_moderator FOREIGN KEY (verified_by)
    REFERENCES users(id) ON DELETE SET NULL,

  INDEX idx_review (review_id),
  INDEX idx_status (verification_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 3. Создание таблицы `review_moderation_logs`

Таблица для логирования всех действий модераторов.

**Файл:** `server/database/migrations/XXX_create_review_moderation_logs_table.sql`

```sql
CREATE TABLE review_moderation_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  review_id INT NOT NULL,

  -- Действие
  action ENUM('created', 'approved', 'rejected', 'edited', 'deleted', 'verified', 'verification_rejected') NOT NULL,
  comment TEXT NULL,

  -- Модератор
  moderator_id INT NULL,

  -- Метаданные
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- Ограничения
  CONSTRAINT fk_modlog_review FOREIGN KEY (review_id)
    REFERENCES reviews(id) ON DELETE CASCADE,
  CONSTRAINT fk_modlog_moderator FOREIGN KEY (moderator_id)
    REFERENCES users(id) ON DELETE SET NULL,

  INDEX idx_review (review_id),
  INDEX idx_moderator (moderator_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 4. Создание таблицы `review_ai_summaries`

Таблица для хранения AI-сгенерированных саммари.

**Файл:** `server/database/migrations/XXX_create_review_ai_summaries_table.sql`

```sql
CREATE TABLE review_ai_summaries (
  id INT AUTO_INCREMENT PRIMARY KEY,

  -- Цель
  target_type ENUM('doctor', 'clinic') NOT NULL,
  target_id INT NOT NULL,

  -- Язык
  language VARCHAR(10) NOT NULL,

  -- AI Summary
  sentiment ENUM('positive', 'neutral', 'negative') NOT NULL,
  positives JSON NULL,
  negatives JSON NULL,
  recommendations TEXT NULL,

  -- Метаданные
  reviews_count INT NOT NULL,
  generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  regenerated_at TIMESTAMP NULL,

  -- Уникальность
  UNIQUE KEY unique_summary (target_type, target_id, language),

  INDEX idx_target (target_type, target_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 5. Обновление таблицы `doctors`

Добавить поля для кэширования рейтинга.

**Файл:** `server/database/migrations/XXX_add_rating_to_doctors.sql`

```sql
ALTER TABLE doctors
  ADD COLUMN average_rating DECIMAL(2,1) DEFAULT NULL,
  ADD COLUMN reviews_count INT DEFAULT 0,
  ADD INDEX idx_rating (average_rating);
```

### 6. Обновление таблицы `clinics`

Добавить поля для кэширования рейтинга.

**Файл:** `server/database/migrations/XXX_add_rating_to_clinics.sql`

```sql
ALTER TABLE clinics
  ADD COLUMN average_rating DECIMAL(2,1) DEFAULT NULL,
  ADD COLUMN reviews_count INT DEFAULT 0,
  ADD INDEX idx_rating (average_rating);
```

### 7. Создание миграционного скрипта

**Файл:** `scripts/migrate-reviews.js` (опционально)

Скрипт для запуска всех миграций в правильном порядке.

```javascript
// Пример структуры
const migrations = [
	'001_create_reviews_table',
	'002_create_review_verification_files_table',
	'003_create_review_moderation_logs_table',
	'004_create_review_ai_summaries_table',
	'005_add_rating_to_doctors',
	'006_add_rating_to_clinics',
];

// Запуск миграций
for (const migration of migrations) {
	await runMigration(migration);
}
```

---

## Технические детали

### Индексы

Все критичные для производительности индексы включены в схему:

- `idx_target` - для быстрого поиска отзывов по врачу/клинике
- `idx_user` - для поиска отзывов пользователя
- `idx_status` - для фильтрации по статусу
- `idx_created` - для сортировки по дате

### Foreign Keys

- Все foreign keys используют `ON DELETE SET NULL` для user_id (мягкое удаление)
- Для `review_verification_files` используется `ON DELETE CASCADE` (удаляется вместе с отзывом)

### Constraints

- Проверка значений рейтинга (1-5)
- Unique constraint для AI Summary (один summary на язык)

---

## Критерии приемки (Acceptance Criteria)

- [ ] **AC-1:** Таблица `reviews` создана со всеми полями и индексами
- [ ] **AC-2:** Таблица `review_verification_files` создана и связана с `reviews` через FK
- [ ] **AC-3:** Таблица `review_moderation_logs` создана и связана с `reviews` через FK
- [ ] **AC-4:** Таблица `review_ai_summaries` создана с unique constraint
- [ ] **AC-5:** Поля `average_rating` и `reviews_count` добавлены в таблицы `doctors` и `clinics`
- [ ] **AC-6:** Все foreign keys корректно настроены
- [ ] **AC-7:** Все индексы созданы
- [ ] **AC-8:** Constraints (CHECK, UNIQUE) работают корректно
- [ ] **AC-9:** Миграции можно запустить без ошибок
- [ ] **AC-10:** Миграции идемпотентны (можно запустить повторно без ошибок)

---

## Как проверить

### 1. Запуск миграций

```bash
# Запустить миграции
npm run db:migrate

# Или вручную через MySQL CLI
mysql -u root -p docta_me < server/database/migrations/XXX_create_reviews_table.sql
# ... и так далее для всех миграций
```

### 2. Проверка структуры таблиц

```sql
-- Проверка таблицы reviews
DESCRIBE reviews;

-- Проверка индексов
SHOW INDEX FROM reviews;

-- Проверка foreign keys
SELECT
  CONSTRAINT_NAME,
  TABLE_NAME,
  REFERENCED_TABLE_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'reviews'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### 3. Тестовые вставки

```sql
-- Вставка тестового внутреннего отзыва
INSERT INTO reviews (
  target_type, target_id, user_id, review_type,
  rating, text, language, status
) VALUES (
  'doctor', 1, 1, 'internal',
  5, 'Отличный врач!', 'ru', 'pending'
);

-- Вставка тестового внешнего отзыва
INSERT INTO reviews (
  target_type, target_id, review_type,
  external_source, external_author_name, external_review_date,
  rating, text, language, status
) VALUES (
  'doctor', 1, 'external',
  'google_maps', 'John Doe', '2026-01-15',
  4, 'Good doctor', 'en', 'approved'
);

-- Проверка вставки
SELECT * FROM reviews;

-- Удаление тестовых данных
DELETE FROM reviews WHERE id IN (1, 2);
```

### 4. Проверка constraints

```sql
-- Попытка вставить невалидный рейтинг (должна вернуть ошибку)
INSERT INTO reviews (
  target_type, target_id, user_id, review_type,
  rating, status
) VALUES (
  'doctor', 1, 1, 'internal',
  6, 'pending'  -- Ошибка: рейтинг должен быть 1-5
);
```

---

## Rollback план

Если нужно откатить миграции:

```sql
-- Удаление в обратном порядке
DROP TABLE IF EXISTS review_moderation_logs;
DROP TABLE IF EXISTS review_ai_summaries;
DROP TABLE IF EXISTS review_verification_files;
DROP TABLE IF EXISTS reviews;

-- Удаление добавленных полей
ALTER TABLE doctors
  DROP COLUMN average_rating,
  DROP COLUMN reviews_count,
  DROP INDEX idx_rating;

ALTER TABLE clinics
  DROP COLUMN average_rating,
  DROP COLUMN reviews_count,
  DROP INDEX idx_rating;
```

---

## Оценка времени

**Ожидаемое время:** 1 день  
**Сложность:** Низкая

---

## Следующие шаги

После завершения этой итерации можно переходить к:

- **[Итерация 2: Базовый функционал отзывов](iteration-02-basic-reviews.md)**

---

**Назад:** [← К списку итераций](README.md)  
**Далее:** [Итерация 2: Базовый функционал →](iteration-02-basic-reviews.md)

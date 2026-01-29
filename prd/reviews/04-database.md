# 4. База данных

[← Назад к оглавлению](index.md)

---

## 4.1 Схема базы данных

### Новые таблицы

#### reviews

Основная таблица отзывов (внутренние и внешние).

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
  external_source VARCHAR(50) NULL,     -- facebook, google_maps, booking, other
  external_source_url VARCHAR(500) NULL,
  external_author_name VARCHAR(255) NULL,
  external_review_date DATE NULL,

  -- Оценки
  rating TINYINT NOT NULL,              -- 1-5 (общая оценка)
  criteria_professionalism TINYINT NULL,     -- 1-5
  criteria_attitude TINYINT NULL,            -- 1-5
  criteria_quality TINYINT NULL,             -- 1-5
  criteria_price_quality TINYINT NULL,       -- 1-5

  -- Контент
  text TEXT NULL,
  language VARCHAR(10) DEFAULT 'ru',    -- ru, en, sr, de, tr

  -- Статусы
  status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  is_verified BOOLEAN DEFAULT FALSE,    -- прошел верификацию

  -- Метаданные
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  moderated_at TIMESTAMP NULL,
  moderated_by INT NULL,                -- user_id модератора
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

**Пояснения:**

- `target_type` + `target_id` - к чему относится отзыв (врач или клиника)
- `user_id` - автор отзыва (NULL для внешних отзывов)
- `review_type` - тип отзыва (internal/external)
- `external_*` - поля для внешних отзывов
- `criteria_*` - дополнительные оценки по критериям
- `is_verified` - прошел ли отзыв верификацию
- `status` - статус модерации
- `deleted_at` - soft delete (отзыв удален, но остается в БД)

#### review_verification_files

Файлы верификации отзывов (чеки, направления).

```sql
CREATE TABLE review_verification_files (
  id INT AUTO_INCREMENT PRIMARY KEY,
  review_id INT NOT NULL UNIQUE,        -- 1:1 с отзывом

  -- Файл
  file_path VARCHAR(500) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_type VARCHAR(50) NOT NULL,       -- image/jpeg, image/png, application/pdf
  file_size INT NOT NULL,               -- bytes

  -- Статус верификации
  verification_status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
  verified_at TIMESTAMP NULL,
  verified_by INT NULL,                 -- user_id модератора
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

**Пояснения:**

- Один отзыв может иметь только один файл верификации (1:1)
- Файлы хранятся локально (в будущем - S3/Cloudinary)
- Модератор проверяет файл и одобряет/отклоняет верификацию

#### review_moderation_logs

Логи модерации отзывов (история всех действий модераторов).

```sql
CREATE TABLE review_moderation_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  review_id INT NOT NULL,

  -- Действие
  action ENUM('created', 'approved', 'rejected', 'edited', 'deleted', 'verified', 'verification_rejected') NOT NULL,
  comment TEXT NULL,

  -- Модератор
  moderator_id INT NULL,                -- NULL для системных действий

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

**Пояснения:**

- История всех действий с отзывом
- Используется для audit trail
- Можно отследить, кто и когда модерировал отзыв

#### review_ai_summaries

AI-сгенерированные саммари отзывов.

```sql
CREATE TABLE review_ai_summaries (
  id INT AUTO_INCREMENT PRIMARY KEY,

  -- Цель (врач или клиника)
  target_type ENUM('doctor', 'clinic') NOT NULL,
  target_id INT NOT NULL,

  -- Язык саммари
  language VARCHAR(10) NOT NULL,        -- ru, en, sr

  -- AI Summary
  sentiment ENUM('positive', 'neutral', 'negative') NOT NULL,
  positives JSON NULL,                  -- ['Профессиональный врач', 'Хорошее отношение', ...]
  negatives JSON NULL,                  -- ['Долгое ожидание', ...]
  recommendations TEXT NULL,

  -- Метаданные
  reviews_count INT NOT NULL,           -- количество отзывов, использованных для генерации
  generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  regenerated_at TIMESTAMP NULL,

  -- Уникальность
  UNIQUE KEY unique_summary (target_type, target_id, language),

  INDEX idx_target (target_type, target_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Пояснения:**

- Один summary на врача/клинику для каждого языка
- JSON для списка позитивных/негативных моментов
- Обновляется при добавлении новых отзывов

---

## 4.2 Изменения существующих таблиц

### doctors

Добавить поля для кэширования рейтинга.

```sql
ALTER TABLE doctors
  ADD COLUMN average_rating DECIMAL(2,1) DEFAULT NULL,
  ADD COLUMN reviews_count INT DEFAULT 0,
  ADD INDEX idx_rating (average_rating);
```

### clinics

Добавить поля для кэширования рейтинга.

```sql
ALTER TABLE clinics
  ADD COLUMN average_rating DECIMAL(2,1) DEFAULT NULL,
  ADD COLUMN reviews_count INT DEFAULT 0,
  ADD INDEX idx_rating (average_rating);
```

**Пояснения:**

- Денормализация для быстрого отображения рейтинга
- Обновляется при изменении отзывов
- Позволяет сортировать врачей/клиники по рейтингу

---

## 4.3 Миграции

### Миграция 001: Создание таблицы reviews

```sql
-- migrations/001_create_reviews_table.sql

CREATE TABLE reviews (
  -- [см. выше]
);
```

### Миграция 002: Создание таблицы review_verification_files

```sql
-- migrations/002_create_review_verification_files_table.sql

CREATE TABLE review_verification_files (
  -- [см. выше]
);
```

### Миграция 003: Создание таблицы review_moderation_logs

```sql
-- migrations/003_create_review_moderation_logs_table.sql

CREATE TABLE review_moderation_logs (
  -- [см. выше]
);
```

### Миграция 004: Создание таблицы review_ai_summaries

```sql
-- migrations/004_create_review_ai_summaries_table.sql

CREATE TABLE review_ai_summaries (
  -- [см. выше]
);
```

### Миграция 005: Добавление рейтингов в таблицы doctors и clinics

```sql
-- migrations/005_add_ratings_to_doctors_and_clinics.sql

ALTER TABLE doctors
  ADD COLUMN average_rating DECIMAL(2,1) DEFAULT NULL,
  ADD COLUMN reviews_count INT DEFAULT 0,
  ADD INDEX idx_rating (average_rating);

ALTER TABLE clinics
  ADD COLUMN average_rating DECIMAL(2,1) DEFAULT NULL,
  ADD COLUMN reviews_count INT DEFAULT 0,
  ADD INDEX idx_rating (average_rating);
```

---

## 4.4 Индексы и производительность

### Ключевые индексы

- **reviews**:

  - `idx_target (target_type, target_id)` - быстрый поиск отзывов для врача/клиники
  - `idx_user (user_id)` - отзывы пользователя
  - `idx_status (status)` - фильтрация по статусу
  - `idx_created (created_at)` - сортировка по дате

- **doctors/clinics**:
  - `idx_rating (average_rating)` - сортировка по рейтингу

### Оценка размера данных

**Предположения:**

- 1000 врачей
- 500 клиник
- 5000 пользователей
- Средне 10 отзывов на врача/клинику
- 30% отзывов с верификацией

**Оценка:**

- `reviews`: ~15,000 строк × ~500 bytes = ~7.5 MB
- `review_verification_files`: ~4,500 строк × ~300 bytes = ~1.4 MB
- `review_moderation_logs`: ~60,000 строк × ~200 bytes = ~12 MB
- `review_ai_summaries`: ~4,500 строк × ~1 KB = ~4.5 MB

**Итого:** ~25 MB (без учета файлов верификации)

**Файлы верификации:** 4,500 файлов × 2 MB = ~9 GB

### Масштабирование

- Индексы оптимизированы для быстрых запросов
- При росте данных (100,000+ отзывов) рассмотреть:
  - Партиционирование таблицы reviews по target_type
  - Перенос старых отзывов в архивную таблицу
  - Перенос файлов верификации в S3/Cloudinary

---

## 4.5 Queries примеры

### Получение отзывов для врача

```sql
SELECT
  r.*,
  u.name as author_name,
  u.photo_url as author_photo,
  vf.file_path as verification_file
FROM reviews r
LEFT JOIN users u ON r.user_id = u.id
LEFT JOIN review_verification_files vf ON r.id = vf.review_id
WHERE r.target_type = 'doctor'
  AND r.target_id = 123
  AND r.status = 'approved'
  AND r.deleted_at IS NULL
ORDER BY r.created_at DESC
LIMIT 10 OFFSET 0;
```

### Расчет среднего рейтинга

```sql
SELECT
  AVG(rating) as average_rating,
  COUNT(*) as reviews_count,
  SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) as rating_5,
  SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) as rating_4,
  SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) as rating_3,
  SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) as rating_2,
  SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) as rating_1,
  AVG(criteria_professionalism) as avg_professionalism,
  AVG(criteria_attitude) as avg_attitude,
  AVG(criteria_quality) as avg_quality,
  AVG(criteria_price_quality) as avg_price_quality
FROM reviews
WHERE target_type = 'doctor'
  AND target_id = 123
  AND status = 'approved'
  AND deleted_at IS NULL;
```

### Обновление кэшированного рейтинга

```sql
UPDATE doctors
SET
  average_rating = (
    SELECT AVG(rating)
    FROM reviews
    WHERE target_type = 'doctor'
      AND target_id = doctors.id
      AND status = 'approved'
      AND deleted_at IS NULL
  ),
  reviews_count = (
    SELECT COUNT(*)
    FROM reviews
    WHERE target_type = 'doctor'
      AND target_id = doctors.id
      AND status = 'approved'
      AND deleted_at IS NULL
  )
WHERE id = 123;
```

---

**Предыдущий раздел:** [← 3. Архитектура](03-architecture.md)  
**Следующий раздел:** [5. Риски и метрики →](05-risks-and-metrics.md)

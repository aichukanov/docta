# 3. Архитектура

[← Назад к оглавлению](index.md)

---

## 3.1 Стек технологий

### Frontend

- **Framework:** Nuxt 3
- **UI Library:** Element Plus (для форм, диалогов, рейтингов)
- **State Management:** Pinia (для управления состоянием отзывов)
- **Rich Text Editor:** Markdown (простой textarea с предпросмотром)
- **Star Rating:** Element Plus ElRate компонент
- **File Upload:** Element Plus ElUpload компонент

### Backend

- **Framework:** Nuxt 3 Server API
- **Database:** MySQL 8.0+
- **ORM:** Raw SQL queries через mysql2
- **File Storage:** Локальное хранилище (в будущем - S3/Cloudinary)
- **AI Integration:** OpenAI API (GPT-4) для AI Summary

### Инфраструктура

- **Caching:** Redis (опционально, для кэширования рейтингов и AI Summary)
- **Job Queue:** (опционально, для асинхронной генерации AI Summary)

---

## 3.2 Компоненты

### Frontend компоненты

```
components/
├── review/
│   ├── list.vue                    # Список отзывов с сортировкой и фильтрацией
│   ├── item.vue                    # Карточка одного отзыва
│   ├── create-dialog.vue           # Диалог создания отзыва
│   ├── edit-dialog.vue             # Диалог редактирования отзыва
│   ├── rating-display.vue          # Отображение рейтинга (звезды + число)
│   ├── rating-input.vue            # Ввод рейтинга (звезды)
│   ├── criteria-ratings.vue        # Оценки по критериям
│   ├── verification-badge.vue      # Verified badge
│   ├── source-badge.vue            # External/Internal badge
│   ├── summary-card.vue            # Карточка с общей статистикой рейтингов
│   ├── distribution-chart.vue      # Histogram распределения рейтингов
│   ├── ai-summary.vue              # AI Summary блок
│   └── moderation-panel.vue        # Панель модерации (для админов)
├── doctor/
│   └── reviews-section.vue         # Секция отзывов на странице врача
└── clinic/
    └── reviews-section.vue         # Секция отзывов на странице клиники
```

### API Endpoints

#### Отзывы (CRUD)

```typescript
// Получение отзывов
POST /api/reviews/list
{
  targetType: 'doctor' | 'clinic',
  targetId: number,
  page?: number,
  limit?: number,
  sortBy?: 'date' | 'rating',
  sortOrder?: 'asc' | 'desc',
  filters?: {
    type?: 'internal' | 'external' | 'verified',
    rating?: 1 | 2 | 3 | 4 | 5
  }
}

// Создание отзыва
POST /api/reviews/create
{
  targetType: 'doctor' | 'clinic',
  targetId: number,
  rating: number,           // 1-5
  text?: string,
  criteriaRatings?: {
    professionalism?: number,
    attitude?: number,
    quality?: number,
    priceQuality?: number
  },
  verificationFile?: File  // multipart/form-data
}

// Редактирование отзыва
PUT /api/reviews/[id]
{
  rating: number,
  text?: string,
  criteriaRatings?: { ... }
}

// Удаление отзыва
DELETE /api/reviews/[id]

// Получение своих отзывов
GET /api/reviews/my-reviews
```

#### Рейтинги

```typescript
// Получение статистики рейтингов
GET /api/reviews/rating-stats?targetType=doctor&targetId=123
Response: {
  averageRating: 4.3,
  totalReviews: 42,
  distribution: {
    5: 20,
    4: 15,
    3: 5,
    2: 1,
    1: 1
  },
  criteriaAverages: {
    professionalism: 4.5,
    attitude: 4.2,
    quality: 4.1,
    priceQuality: 4.0
  }
}
```

#### AI Summary

```typescript
// Получение AI Summary
GET /api/reviews/ai-summary?targetType=doctor&targetId=123&lang=ru
Response: {
  summary: {
    sentiment: 'positive' | 'neutral' | 'negative',
    positives: string[],
    negatives: string[],
    recommendations: string
  },
  generatedAt: string,
  reviewsCount: number
}

// Генерация AI Summary (вызывается из E2E теста)
POST /api/reviews/generate-ai-summary
{
  targetType: 'doctor' | 'clinic',
  targetId: number,
  language: 'ru' | 'en' | 'sr'
}
```

#### Модерация

```typescript
// Список отзывов на модерации
GET /api/admin/reviews/pending

// Модерация отзыва
POST /api/admin/reviews/[id]/moderate
{
  action: 'approve' | 'reject',
  reason?: string  // для reject
}

// Модерация верификации
POST /api/admin/reviews/[id]/verify
{
  action: 'approve' | 'reject'
}
```

#### Внешние отзывы (только суперадмин)

```typescript
// Создание внешнего отзыва
POST /api/admin/reviews/external/create
{
  targetType: 'doctor' | 'clinic',
  targetId: number,
  source: 'facebook' | 'google_maps' | 'booking' | 'other',
  sourceUrl?: string,
  authorName: string,
  rating: number,
  text: string,
  reviewDate: string,
  language: string
}

// Массовый импорт внешних отзывов
POST /api/admin/reviews/external/bulk-import
{
  reviews: ExternalReview[]
}
```

---

## 3.3 Структура страниц

### Страница врача с отзывами

```
/doctors/[doctorId]
├── doctor-info
├── reviews-section
│   ├── summary-card (рейтинг, распределение)
│   ├── ai-summary (блок AI анализа)
│   ├── create-review-button (если авторизован)
│   ├── filters (тип, оценка)
│   ├── sorting (по дате, по рейтингу)
│   └── reviews-list
│       ├── review-item (verified badge, source badge)
│       ├── review-item
│       └── ...
└── pagination
```

### Страница клиники с отзывами

```
/clinics/[clinicId]
├── clinic-info
├── reviews-section
│   └── [аналогично странице врача]
```

### Страница "Мои отзывы" в профиле

```
/profile/my-reviews
├── tabs (Все / На модерации / Одобренные / Отклоненные)
└── my-reviews-list
    ├── review-item (с кнопками Edit/Delete)
    └── ...
```

### Админ панель модерации

```
/admin/reviews/moderation
├── tabs (На модерации / Верификация)
├── pending-reviews-list
│   ├── review-item
│   │   ├── review-content
│   │   ├── verification-file (если есть)
│   │   └── moderation-actions (approve/reject)
│   └── ...
└── pagination
```

---

## 3.4 Диаграммы

### Flow создания отзыва

```
User
  ↓
Click "Написать отзыв"
  ↓
Open CreateReviewDialog
  ↓
Fill rating + text + criteria + upload verification
  ↓
Submit
  ↓
POST /api/reviews/create
  ↓
Save to DB (status: pending)
  ↓
Upload verification file (if exists)
  ↓
Return success
  ↓
Show success message
  ↓
Review added to moderation queue
  ↓
Moderator approves/rejects
  ↓
User receives notification (optional)
```

### Flow генерации AI Summary

```
Trigger (новый отзыв или cron job)
  ↓
Fetch all reviews for target
  ↓
Prepare prompt for OpenAI
  ↓
Call OpenAI API (GPT-4)
  ↓
Parse response
  ↓
Save to DB (review_ai_summaries table)
  ↓
Cache in Redis (optional)
  ↓
Display on page
```

### ERD (Entity Relationship Diagram)

```
users
  ├─→ reviews (1:N)

doctors
  ├─→ reviews (1:N)

clinics
  ├─→ reviews (1:N)

reviews
  ├─→ review_verification_files (1:1)
  ├─→ review_moderation_logs (1:N)

doctors/clinics
  ├─→ review_ai_summaries (1:N по языкам)
```

---

## 3.5 Безопасность

### Авторизация и права

- **Создание отзыва:** требуется авторизация
- **Редактирование отзыва:** только автор (в течение 7 дней)
- **Удаление отзыва:** только автор
- **Модерация:** только модераторы/суперадмины
- **Верификация:** только модераторы/суперадмины
- **Внешние отзывы:** только суперадмины

### Валидация

- Rating: 1-5 (целые числа)
- Text: минимум 10 символов (если указан)
- Verification file: max 5MB, только JPG/PNG/PDF
- Rate limiting: 1 отзыв на врача/клинику, max 1 отзыв в час

### Санитизация

- Текст отзывов санитизируется (XSS защита)
- HTML теги удаляются (кроме базового форматирования через Markdown)
- SQL injection защита через prepared statements

---

## 3.6 Кэширование

### Что кэшируется

- **Рейтинги** (средний рейтинг, распределение) - кэш на 5 минут
- **AI Summary** - кэш на 24 часа (или до следующей регенерации)
- **Список отзывов** (первая страница) - кэш на 1 минуту

### Инвалидация кэша

- При создании нового отзыва
- При модерации отзыва
- При добавлении внешнего отзыва

---

## 3.7 Производительность

### Оптимизации

- **Пагинация:** 10 отзывов на страницу
- **Lazy loading:** подгрузка отзывов при скролле
- **Индексы БД:** на targetType + targetId, userId, status
- **AI Summary:** генерируется асинхронно (не блокирует UI)
- **Рейтинги:** кэшируются и обновляются при изменении

---

**Предыдущий раздел:** [← 2. Требования](02-requirements.md)  
**Следующий раздел:** [4. База данных →](04-database.md)

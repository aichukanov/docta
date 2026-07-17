# Прогресс разработки: Система отзывов

**PRD:** [Система отзывов](index.md)
**Текущий статус:** 🟢 Завершено (6/6 итераций); миграция 005 применена 2026-06-12

---

## Общий прогресс

```
██████████ 100% (6/6 итераций завершено)
```

---

## Статус итераций

| #   | Название                                                       | Статус  | Завершено  |
| --- | -------------------------------------------------------------- | ------- | ---------- |
| 1   | [База данных отзывов](iterations/iteration-01-database.md)     | 🟢 Done | 2026-03-20 |
| 2   | [Базовый функционал](iterations/iteration-02-basic-reviews.md) | 🟢 Done | ~2026-03   |
| 3   | [Верификация отзывов](iterations/iteration-03-verification.md) | 🟢 Done | 2026-06-12 |
| 4   | [Внешние отзывы](iterations/iteration-04-external-reviews.md)  | 🟢 Done | 2026-03-20 |
| 5   | [AI Summary](iterations/iteration-05-ai-summary.md)            | 🟢 Done | 2026-06-12 |
| 6   | [Модерация](iterations/iteration-06-moderation.md)             | 🟢 Done | 2026-06-12 |

---

## Ключевые решения и отступления от PRD (2026-06-12)

### Модель модерации: ПОСТ-модерация

Отзывы публикуются сразу (статус `pending`, виден публично) — текущее UX не
меняется. Админ в очереди модерации одобряет (`approved`) или отклоняет
(`rejected`, причина обязательна). Отклонённые скрываются из публичной выдачи,
рейтингов и ранжирования, но автор видит свой отзыв с причиной отклонения.
Существующие и импортируемые внешние отзывы — `approved` (DEFAULT колонки,
импорт-скрипты не менялись).

Обоснование: пре-модерация ухудшила бы UX (отзыв «исчезает» до аппрува),
а трафик отзывов мал — админ успевает разбирать очередь постфактум.

### Прочие отступления

- **Ролей `moderator`/`superadmin` нет** — модерация через существующий
  `is_admin` (`requireAdmin()`), как все admin-endpoints.
- **Файлы верификации — только изображения** (JPG/PNG/WebP и т.д. → webp через
  sharp, до 10 МБ), без PDF из PRD: загрузка переиспользует валидацию
  `use-image-upload.ts`, а чеки фотографируют с телефона. Хранение —
  НЕ в `public/` (PRD ошибался: это персональные данные), а в
  `VERIFICATIONS_DIR` (дефолт `storage/verifications`), выдача только автору
  и админу через `/api/reviews/verification-file`.
- **Генерация AI summary — ручная, без API-ключа** (решение пользователя
  2026-06-12, заменило первоначальную автоматическую фоновую генерацию через
  Anthropic SDK): сбор запускается время от времени в сессии Claude Code,
  модель сессии анализирует отзывы и выдаёт SQL в `review_ai_summaries` —
  workflow в `docs/import/AI_SUMMARY_WORKFLOW.md`. GET `/api/reviews/ai-summary`
  только читает кэш. SDK `@anthropic-ai/sdk`, env-ключи и
  `server/common/ai-summary.ts` удалены.
- **Локализация AI summary**: один проход генерирует сразу все 6 локалей,
  sentiment общий; кэш в `review_ai_summaries` по (entity, language).
- **Кнопки «Обновить анализ» для пользователей нет** — обновление только через
  ручной workflow.
- **Очередь жалоб (reports) не реализована** — механизма жалоб в продукте нет;
  очередь модерации = новые отзывы + файлы верификации.

---

## Что сделано (итерации 3, 5, 6 — 2026-06-12)

### БД (миграция `server/sql/migrations/005-reviews-moderation.sql` — применена 2026-06-12)

- `reviews`: + `status` enum(pending/approved/rejected) DEFAULT 'approved',
  `is_verified`, `moderated_by`, `moderated_at`, `rejection_reason`, индекс по status
- Новые таблицы: `review_verification_files` (1 файл на отзыв, статус проверки),
  `review_moderation_logs` (аудит действий), `review_ai_summaries`
  (кэш по entity_type+entity_id+language)

### API

- `POST /api/reviews/upload-verification` — автор, multipart, изображение → webp
- `GET /api/reviews/verification-file?reviewId=` — стрим файла автору/админу
- `GET /api/admin/reviews/queue?type=&status=&page=` — очередь + статистика
- `POST /api/admin/reviews/moderate` — approve/reject (reject требует причину) + лог
- `POST /api/admin/reviews/verify` — approve/reject верификации → `is_verified` + лог
- `GET /api/reviews/ai-summary?entityType=&entityId=&locale=` — только чтение кэша
  (генерация — ручной workflow, `docs/import/AI_SUMMARY_WORKFLOW.md`)
- `POST /api/reviews/create` — теперь вставляет `status='pending'`
- `fetchReviews`/`fetchRating`/`entity-ranking` — исключают `rejected`;
  own-отзыв отдаётся автору всегда со status/reason/verificationStatus

### UI

- `components/review/verification-upload.vue`, `verified-badge.vue`,
  `ai-summary.vue`; шаг верификации в `form.vue` после отправки отзыва;
  бейдж и уведомления автора в `item.vue`; AI-блок в `reviews-page.vue`
- Админка: суб-таб «Модерация» (`components/admin/review-moderation.vue`) —
  статистика, фильтры по типу/статусу, approve/reject, предпросмотр файлов
- i18n: +23 ключа × 6 локалей в `i18n/reviews.ts` (иекавица, sr-cyrl зеркалит sr)

---

## Блокеры

| Проблема | Статус | Описание |
| -------- | ------ | -------- |
| Миграция 005 не применена | ✅ Closed 2026-06-12 | Применена пользователем, отмечена в APPLIED.md |
| ANTHROPIC_API_KEY | ✅ Closed 2026-06-12 | Ключа не будет: генерация AI-обзоров — ручной workflow в сессии Claude Code (`docs/import/AI_SUMMARY_WORKFLOW.md`), сайт читает только кэш. |

---

## Метрики (см. PRD)

- % верифицированных отзывов (цель 30%) — `reviews.is_verified`
- % отклонённых при модерации (мониторинг, цель < 5%) — `reviews.status`
- Среднее время модерации — `review_moderation_logs.created_at - reviews.published_at`

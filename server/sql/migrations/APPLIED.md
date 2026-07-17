# Applied Migrations Log

## 2026-03-20: deploy-reviews.sql

Deployed reviews system to production. Applied by docta_admin on 89.116.111.68.

Schema changes:
- `clinics`: added `google_place_id` (VARCHAR(255), UNIQUE)
- `auth_users`: added `is_phantom`, `profile_url`, made `email` nullable
- Created tables: `reviews`, `review_replies`, `review_likes`, `review_reply_likes`
- `reviews`: added `likes_count` column + index

## 2026-03-20: Google Maps reviews import

Data collected: 2026-03-18 — 2026-03-19. Applied by docta_admin on 89.116.111.68.

Imported reviews for 7 clinics:
- a3-medical-sutomore
- buntic (Bar)
- dental-esthetic-studio (Bar)
- dr-zejnilovic (Bar)
- just-dental (Bar)
- medical-vranes-bar (Bar)
- pavlin (Bar)

SQL files removed after successful import (regenerable via `generate-reviews-sql.mjs` from configs in `data/review-import-configs/`).

## 2026-04-10: deploy-medicines.sql

Medicine register from CInMED (cinmed.me) — Montenegro Ministry of Health.

Single deploy file: `server/sql/migrations/deploy-medicines.sql`

```bash
mysql -u docta_admin -p --default-character-set=utf8mb4 docta_me < server/sql/migrations/deploy-medicines.sql
```

Created tables:
- `countries` (39) — shared country table with 6-language translations
- `med_dispensing_modes` (9) — prescription modes with translations
- `med_pharma_forms` (147) — pharmaceutical forms with translations
- `med_substances` (904) — INN/active substances with translations
- `med_atc_groups` (14) — ATC therapeutic categories with translations
- `med_auth_holders` (46) — marketing authorization holders (legal entities in MNE)
- `med_manufacturers` (421) — manufacturers with full addresses and country FK
- `med_medicines` (3553) — main medicines table, 2523 with active license
- `med_medicine_substances` (4404) — M:N medicine ↔ substance links

Data source: `data/medicines.json` (scraped via `scripts/scrape-medicines.mjs`).
Translations: `data/med-translations/` (JSON batches).
Regenerate SQL from JSON: `node scripts/build-med-sql.mjs`.

## 2026-06-12: 004-add-auth-users-preferred-city.sql

Каталог клиник, итерация 2 (геолокация). Applied by user (confirmed 2026-06-12).

Schema changes:
- `auth_users`: added `preferred_city_id` (INT NULL, FK -> cities.id, ON DELETE SET NULL)

Используется эндпоинтами `GET /api/auth/preferred-city` и
`POST /api/auth/update-preferred-city` (сохранение города для сортировки
клиник по расстоянию, composable `use-user-location.ts`).

## 2026-06-12: 004-user-privacy.sql

Приватность профиля (prd/user-profile, итерации 3–4). Applied by user (confirmed 2026-06-12).

Schema changes:
- `auth_users`: added `is_profile_public` (BOOLEAN NOT NULL DEFAULT FALSE) — дефолт приватный
- Backfill: `is_profile_public = TRUE` для фантомных пользователей (импортированные отзывы остаются с именами)

Используется в сессии (`server/utils/session.ts`), эндпоинте
`POST /api/auth/update-privacy` и подписи автора отзыва (`server/common/reviews.ts`:
приватный → анонимно, публичный без имени → маскированный email).

## 2026-06-12: 005-reviews-moderation.sql

Отзывы: модерация, верификация, AI summary (prd/reviews, итерации 3, 5, 6).
Applied by user (confirmed 2026-06-12).

Schema changes:
- `reviews`: added `status` ENUM('pending','approved','rejected') DEFAULT 'approved',
  `is_verified`, `moderated_by` (FK -> auth_users, SET NULL), `moderated_at`,
  `rejection_reason`; index `idx_reviews_status`
- Created `review_verification_files` — файлы подтверждения визита
  (1 на отзыв, непубличное хранилище `VERIFICATIONS_DIR`)
- Created `review_moderation_logs` — аудит действий модерации
- Created `review_ai_summaries` — кэш AI-обзоров по (entity_type, entity_id, language)

Модель — ПОСТ-модерация: новые отзывы `pending` и видны сразу, `rejected`
скрываются из публичной выдачи/рейтингов/ранжирования (автор видит причину).
Используется эндпоинтами `server/api/reviews/upload-verification|verification-file|ai-summary`
и `server/api/admin/reviews/queue|moderate|verify`; AI summary включается
переменной `ANTHROPIC_API_KEY` (на момент применения не заведена — фича выключена).

## 2026-06-12: 006-clinic-cabinet.sql

Кабинет клиники (prd/clinic-profile, итерации 2–6). Applied by user (confirmed 2026-06-12).

Schema changes:
- `clinics`: added `created_by` (INT NULL, FK -> auth_users.id, ON DELETE SET NULL) —
  владелец пользовательской клиники (NULL для клиник из админки/импортов)
- `clinics`: added `status` ENUM('draft','pending_verification','published','rejected')
  NOT NULL DEFAULT 'published' — существующие клиники остались опубликованными
- Indexes: `idx_clinics_status`, `idx_clinics_created_by`

Используется кабинетом клиники (`server/api/clinics/my-*`, таб «Мои клиники»)
и гейтингом черновиков (details/list/reviews/sitemap — только `published`).
`logo_url` существовал ранее, в миграцию не входит.

## 2026-06-12: 007-clinic-billing-orders.sql

Self-service биллинг клиник (prd/clinic-billing, итерации 1–4, Stripe).
Applied by user (confirmed 2026-06-12).

Created tables:
- `billing_service_prices` — прайс по периодам 1/3/6/12 мес, суммы в центах EUR;
  сид: 12 цен для DOFOLLOW/HIGHLIGHT/APPROVED
- `billing_orders` — заказы (UUID PK, статусы pending_payment/processing/completed/failed/cancelled)
- `billing_order_items` — состав заказа с зафиксированной ценой
- `billing_payment_transactions` — лог транзакций Stripe (session_id UNIQUE, metadata JSON)

Legacy-таблицы покупок (`billing_clinic_service_purchases*`) не менялись —
активация после оплаты пишет в них (cents/100, DECIMAL в евро).
Stripe-ключи (`STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`) на момент применения
не заведены — онлайн-оплата выключена, каталог/заказы/история работают.

## 2026-06-12: 008-billing-remove-dofollow-prices.sql

Вывод DOFOLLOW из продажи + новые цены. Applied by user (confirmed 2026-06-12).

- DOFOLLOW (id 1): все цены деактивированы — услуга пропала из каталога
  и создания заказов (продажа dofollow-ссылок нарушает Google link spam
  policy). Строка в `billing_paid_services` осталась — на неё ссылаются
  выданные через админку покупки.
- HIGHLIGHT (id 2): 10 €/мес, скидка за длительность — 27/48/84 € за 3/6/12 мес.
- APPROVED (id 3): символическая цена, только два периода — 1 €/мес и 10 €/год;
  цены за 3/6 мес деактивированы.

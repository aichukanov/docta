# Задача: self-service покупка платных услуг для клиник (Stripe)

Реализуй все 4 итерации PRD `prd/clinic-billing/`. Запускать ТОЛЬКО после
завершения `03-clinic-cabinet.md` (нужна связь user→clinic и кабинет клиники).

## Перед началом прочитай

- `prd/clinic-billing/index.md`, `02-requirements.md`, `03-architecture.md`, `04-database.md`
- Все `prd/clinic-billing/iterations/iteration-01..04-*.md`
- Текущий код биллинга — **админская часть уже существует и работает**:
  `server/api/billing/services/list.ts`, `server/api/billing/clinic-purchases/`
  (add, delete, restore, list), админ-UI в `components/admin/`. Каталог платных
  услуг и таблицы покупок уже есть в БД — построй self-service ПОВЕРХ них,
  не дублируя сущности.
- `docs/DATABASE_SCHEMA.md`, `docs/rules/API_CODES_SYSTEM.md`

## Важные поправки к PRD (документация устарела)

- Auth готов. Роли clinic_admin нет и отдельный permissions-PRD не существует —
  права определяй через `clinics.created_by` (владелец клиники), созданный в
  задаче 03. Этого достаточно, не строй систему ролей.
- Платёжка: PRD упоминает выбор провайдера — принято решение Stripe (Checkout
  Session, не custom-форма). Работай в test mode.

## Что сделать

1. **Итерация 1 — страница услуг**: `pages/profile/clinics/[id]/billing` (или
   встроенный раздел кабинета из задачи 03 — согласуй с его структурой): каталог
   платных услуг (DOFOLLOW, HIGHLIGHT, APPROVED) с описаниями и ценами, история
   покупок клиники (реиспользуй существующие billing API, добавив проверку
   владельца вместо админа). Доступ — только владелец клиники.
2. **Итерация 2 — заказ**: выбор услуг и периода (1/3/6/12 мес), расчёт стоимости,
   создание заказа в БД (новая таблица заказов по `04-database.md`, сверь с
   реальной схемой purchases).
3. **Итерация 3 — оплата**: пакет `stripe`, Checkout Session с metadata
   (order_id, clinic_id), редирект, webhook `server/api/billing/webhook.post.ts`
   с проверкой подписи, обработка success/cancel/failure. Ключи —
   `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `NUXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
   в `.env.example` + runtimeConfig. Без ключей фича аккуратно отключена
   (сообщение «оплата временно недоступна»), всё остальное работает.
4. **Итерация 4 — активация**: по успешному webhook — записи в clinic-purchases
   (та же таблица, что использует админка, чтобы услуги сразу применялись на
   публичной странице), email-уведомление (найди существующую почтовую
   инфраструктуру в server/ — verify-email уже шлётся; используй её),
   лог транзакций, идемпотентность webhook (повторная доставка не дублирует покупку).

## Конвенции проекта (обязательно)

- SQL-миграции НЕ применять: файл в `server/sql/migrations/` + команда mysql
  пользователю, после подтверждения — отметка в `APPLIED.md`.
- Деньги: суммы в центах в БД, валюта EUR (Черногория).
- i18n: 6 локалей (en, ru, sr, sr-cyrl, de, tr), иекавица.
- Только дизайн-токены; AppBreadcrumbs.
- `npm run typecheck` зелёный. НЕ запускай `nuxt build` при работающем dev-сервере.
- НЕ коммить — пользователь коммитит сам.

## Definition of Done

- Полный цикл в test mode: каталог → заказ → Stripe Checkout → webhook →
  услуга активна и видна в истории и на публичной странице.
- Без Stripe-ключей ничего не падает.
- typecheck зелёный, тексты на 6 локалях.
- `prd/clinic-billing/PROGRESS.md` и итерации обновлены (зафиксируй, что админская
  ручная выдача услуг существовала до этой задачи).
- Сводка: файлы, миграции, какие env-ключи нужны от пользователя, как настроить
  webhook в Stripe Dashboard, сценарий проверки с тестовой картой.

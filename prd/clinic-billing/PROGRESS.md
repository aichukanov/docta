# 📊 Прогресс разработки: Самостоятельная покупка платных услуг для клиник

[← Назад к оглавлению](index.md)

---

## Общий прогресс

```
██████████ 100% завершено (4/4 итераций)
```

**Статус:** 🟢 Complete (ожидает применения миграции и Stripe-ключей)  
**Дата начала:** 2026-06-11  
**Дата завершения:** 2026-06-12

---

## Итерации

| #   | Название                                 | Статус  | Дата завершения |
| --- | ---------------------------------------- | ------- | --------------- |
| 1   | Страница платных услуг в профиле клиники | ✅ Done | 2026-06-12      |
| 2   | Выбор и формирование заказа              | ✅ Done | 2026-06-12      |
| 3   | Интеграция платежной системы (Stripe)    | ✅ Done | 2026-06-12      |
| 4   | Подтверждение и активация услуг          | ✅ Done | 2026-06-12      |

---

## Контекст: что существовало до этой задачи

**Админская ручная выдача услуг работала до начала задачи** и не менялась:

- `billing_paid_services` (DOFOLLOW=1, HIGHLIGHT=2, APPROVED=3)
- `billing_clinic_service_purchases` + `billing_clinic_service_purchase_items`
- `server/api/billing/services/list.ts`, `server/api/billing/clinic-purchases/{add,delete,restore,list}.ts` (requireAdmin)
- Активные покупки уже применяются на публичных страницах
  (`features` в clinics/list и clinics/details)

Self-service построен ПОВЕРХ этих сущностей: активация пишет в те же
purchases-таблицы, поэтому купленные услуги сразу видны на публичной странице.

---

## Принятые решения и отступления от PRD

| Тема | Решение |
| --- | --- |
| Роль `clinic_admin` | Не реализована (permissions-PRD не существует). Права = владелец клиники `clinics.created_by` (из задачи 03-clinic-cabinet) или админ. |
| Платёжный провайдер | Stripe Checkout Session (test mode), не custom-форма. |
| Деньги | Новые таблицы хранят суммы в **центах** (INT, EUR). Legacy `billing_clinic_service_purchases.price` остаётся DECIMAL в евро — туда пишется `cents/100`. |
| `valid_until` при активации | PRD-пример с `MAX(months)` дарил бы короткие услуги на длинный срок. Вместо этого позиции заказа группируются по периоду — по одной purchase-записи на период. |
| `billing_activation_errors` (ит. 4) | Таблица не создавалась: активация атомарна (одна транзакция), при ошибке webhook отвечает 500 и Stripe ретраит доставку. Лог — `billing_payment_transactions` + server-logger. |
| Email об истечении услуг (FR-27/28) | Вне скоупа (v2), как и автопродление/промокоды/refunds. |
| Страница биллинга | Встроена в кабинет: `/profile/clinics/[clinicId]/billing` внутри лейаута профиля (таб «Мои клиники» переехал в `pages/profile/clinics/index.vue`). |
| Без Stripe-ключей | `/api/billing/payment-status` → UI показывает «оплата временно недоступна», кнопка Pay отключена; каталог/заказы/история работают, webhook отвечает 503. |

---

## Что реализовано

### База данных

Миграция `server/sql/migrations/007-clinic-billing-orders.sql` (см. APPLIED.md):

- `billing_service_prices` — прайс по периодам 1/3/6/12 мес + сид цен из PRD (в центах)
- `billing_orders` — заказы (UUID, статусы pending_payment/processing/completed/failed/cancelled, created_by)
- `billing_order_items` — состав заказа с зафиксированной ценой
- `billing_payment_transactions` — лог транзакций (session_id, статусы, metadata JSON)

### API

- `GET /api/billing/services/catalog` — каталог с ценами (публичный)
- `GET /api/billing/purchases/my?clinicId=` — история покупок (владелец клиники)
- `POST /api/billing/orders/create` — заказ; цены только из БД, клиентским не доверяем
- `GET /api/billing/orders/[id]` — детали заказа (checkout + поллинг активации)
- `POST /api/billing/orders/[id]/payment` — Stripe Checkout Session (503 без ключей)
- `POST /api/billing/orders/[id]/cancel` — отмена неоплаченного заказа
- `POST /api/billing/webhook` — подпись через `constructEvent`; `checkout.session.completed` → активация, `checkout.session.expired` → failed
- `GET /api/billing/payment-status` — настроена ли оплата
- Хелперы: `server/common/billing-orders.ts` (getOwnedOrder), `server/utils/stripe.ts`

### Активация (итерация 4)

- В одной транзакции: purchases + purchase_items + order→completed + transaction→success
- Идемпотентность: `SELECT ... FOR UPDATE` + проверка `status='completed'` — повторный webhook не дублирует покупку
- Email-подтверждение владельцу (Mailgun-инфраструктура, `server/utils/billing-email.ts`, 6 локалей, в dev — мок с логом)
- Ошибка активации → 500 → Stripe ретраит

### UI

- `pages/profile/clinics/[clinicId]/billing/index.vue` — каталог (чекбоксы, периоды, итог) + история с фильтрами
- `.../billing/checkout.vue` — подтверждение заказа, Оплатить/Отменить
- `.../billing/success.vue` — поллинг активации (в обработке → успех)
- `.../billing/error.vue` — отмена/ошибка, повторная попытка
- `components/billing/service-card.vue`, `components/billing/purchase-history.vue`
- Кнопка «Платные услуги» в `components/profile/ClinicCard.vue`
- `i18n/clinic-billing.ts` — 6 локалей; AppBreadcrumbs; дизайн-токены

### Конфигурация

- `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `NUXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` — `.env.example` + runtimeConfig
- Пакет `stripe` добавлен в dependencies

---

## Следующие шаги

1. ⏳ Применить миграцию `007-clinic-billing-orders.sql` (+ `006-clinic-cabinet.sql` из задачи 03, если ещё не применена)
2. ⏳ Завести Stripe test-mode ключи, настроить webhook на `/api/billing/webhook`
3. ⏳ Пройти тестовый цикл с картой `4242 4242 4242 4242`
4. 💡 v2: автопродление, промокоды, refunds, email об истечении срока

---

## Зависимости

- **auth** ✅
- **clinic-profile** (кабинет клиники, created_by) ✅ — задача 03-clinic-cabinet
- **permissions** ❌ не существует — заменено проверкой владельца
- **Stripe** ✅ выбран и интегрирован (test mode)

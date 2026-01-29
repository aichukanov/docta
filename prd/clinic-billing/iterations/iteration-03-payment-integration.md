# Итерация 3: Интеграция платежной системы

[← К списку итераций](README.md) | [Предыдущая](iteration-02-order-creation.md) | [Следующая →](iteration-04-activation.md)

---

## Статус: 🔴 Not Started

---

## Цель

Интегрировать платежную систему (Stripe) для онлайн-оплаты заказов с обработкой webhook для подтверждения платежей.

---

## Зависимости

- **Итерации 1-2** - страница услуг и создание заказа (✅ требуется)
- **Платежная система** - аккаунт Stripe и API ключи (⏳ требуется)

---

## Задачи

### 1. Миграция: Таблица транзакций

**Файл:** `server/database/migrations/003_create_billing_payment_transactions.sql`

```sql
CREATE TABLE IF NOT EXISTS billing_payment_transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  transaction_id VARCHAR(255) NOT NULL UNIQUE,
  payment_provider VARCHAR(50) NOT NULL DEFAULT 'stripe',
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  status ENUM('pending', 'success', 'failed', 'refunded') DEFAULT 'pending',
  payment_url TEXT,
  session_id VARCHAR(255),
  metadata JSON,
  error_message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (order_id) REFERENCES billing_orders(id),
  INDEX idx_order (order_id),
  INDEX idx_transaction (transaction_id),
  INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

### 2. Установить Stripe SDK

```bash
npm install stripe
```

**Добавить env переменные:**

```.env
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
BASE_URL=http://localhost:3000
```

---

### 3. API: Создание платежной сессии

**Файл:** `server/api/billing/orders/[id]/payment.post.ts`

```typescript
import Stripe from 'stripe';
import { getConnection } from '~/server/common/db-mysql';
import { requireAuth } from '~/server/common/auth';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
	apiVersion: '2023-10-16',
});

export default defineEventHandler(async (event) => {
	try {
		requireAuth(event);

		const orderId = getRouterParam(event, 'id');

		if (!orderId) {
			throw createError({
				statusCode: 400,
				statusMessage: 'Order ID required',
			});
		}

		const connection = await getConnection();

		// Получить заказ
		const [orderRows]: any = await connection.execute(
			`SELECT * FROM billing_orders WHERE id = ?`,
			[orderId],
		);

		if (orderRows.length === 0) {
			await connection.end();
			throw createError({ statusCode: 404, statusMessage: 'Order not found' });
		}

		const order = orderRows[0];

		// Проверить статус заказа
		if (order.status !== 'pending_payment') {
			await connection.end();
			throw createError({
				statusCode: 400,
				statusMessage: `Order status is ${order.status}, cannot proceed to payment`,
			});
		}

		// Получить элементы заказа
		const [itemRows]: any = await connection.execute(
			`SELECT 
        oi.service_id,
        s.name as service_name,
        oi.months,
        oi.price
       FROM billing_order_items oi
       JOIN billing_paid_services s ON oi.service_id = s.id
       WHERE oi.order_id = ?`,
			[orderId],
		);

		// Создать Stripe checkout session
		const session = await stripe.checkout.sessions.create({
			payment_method_types: ['card'],
			line_items: itemRows.map((item: any) => ({
				price_data: {
					currency: 'eur',
					product_data: {
						name: item.service_name,
						description: `${item.months} ${
							item.months === 1 ? 'month' : 'months'
						}`,
					},
					unit_amount: Math.round(item.price * 100), // в центах
				},
				quantity: 1,
			})),
			mode: 'payment',
			success_url: `${process.env.BASE_URL}/profile/clinics/${order.clinic_id}/billing/success?session_id={CHECKOUT_SESSION_ID}`,
			cancel_url: `${process.env.BASE_URL}/profile/clinics/${order.clinic_id}/billing/error?order_id=${orderId}`,
			metadata: {
				orderId: order.id,
				clinicId: order.clinic_id.toString(),
			},
		});

		// Сохранить транзакцию
		await connection.execute(
			`INSERT INTO billing_payment_transactions 
       (order_id, transaction_id, payment_provider, amount, currency, status, payment_url, session_id, metadata)
       VALUES (?, ?, 'stripe', ?, 'EUR', 'pending', ?, ?, ?)`,
			[
				orderId,
				session.id,
				order.total_amount,
				session.url,
				session.id,
				JSON.stringify({ stripeSessionId: session.id }),
			],
		);

		// Обновить статус заказа
		await connection.execute(
			`UPDATE billing_orders SET status = 'processing' WHERE id = ?`,
			[orderId],
		);

		await connection.end();

		return {
			paymentUrl: session.url,
			sessionId: session.id,
		};
	} catch (error) {
		console.error('API Error - create payment session:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to create payment session',
		});
	}
});
```

---

### 4. API: Webhook от Stripe

**Файл:** `server/api/billing/webhooks/payment.post.ts`

```typescript
import Stripe from 'stripe';
import { getConnection } from '~/server/common/db-mysql';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
	apiVersion: '2023-10-16',
});

export default defineEventHandler(async (event) => {
	try {
		const sig = getHeader(event, 'stripe-signature');
		const body = await readRawBody(event);

		if (!sig || !body) {
			throw createError({ statusCode: 400, statusMessage: 'Invalid request' });
		}

		let stripeEvent: Stripe.Event;

		try {
			stripeEvent = stripe.webhooks.constructEvent(
				body,
				sig,
				process.env.STRIPE_WEBHOOK_SECRET!,
			);
		} catch (err) {
			console.error('Webhook signature verification failed:', err);
			throw createError({
				statusCode: 400,
				statusMessage: 'Invalid signature',
			});
		}

		console.log('Received Stripe webhook:', stripeEvent.type);

		if (stripeEvent.type === 'checkout.session.completed') {
			const session = stripeEvent.data.object as Stripe.Checkout.Session;
			const orderId = session.metadata?.orderId;

			if (!orderId) {
				console.error('Order ID not found in session metadata');
				return { success: false, error: 'Order ID missing' };
			}

			console.log('Payment succeeded for order:', orderId);

			const connection = await getConnection();

			try {
				await connection.beginTransaction();

				// Проверить, не обработан ли уже этот webhook (идемпотентность)
				const [existingRows]: any = await connection.execute(
					`SELECT status FROM billing_payment_transactions 
           WHERE transaction_id = ? AND status = 'success'`,
					[session.id],
				);

				if (existingRows.length > 0) {
					console.log('Payment already processed, skipping');
					await connection.commit();
					await connection.end();
					return { success: true, message: 'Already processed' };
				}

				// Обновить транзакцию
				await connection.execute(
					`UPDATE billing_payment_transactions 
           SET status = 'success', metadata = ?, updated_at = NOW()
           WHERE transaction_id = ?`,
					[JSON.stringify(session), session.id],
				);

				// Обновить статус заказа
				await connection.execute(
					`UPDATE billing_orders 
           SET status = 'completed', updated_at = NOW()
           WHERE id = ?`,
					[orderId],
				);

				await connection.commit();

				console.log('Payment processed successfully for order:', orderId);

				// В следующей итерации здесь будет активация услуг
			} catch (error) {
				await connection.rollback();
				throw error;
			} finally {
				await connection.end();
			}
		} else if (stripeEvent.type === 'checkout.session.expired') {
			const session = stripeEvent.data.object as Stripe.Checkout.Session;
			const orderId = session.metadata?.orderId;

			if (orderId) {
				const connection = await getConnection();

				await connection.execute(
					`UPDATE billing_payment_transactions 
           SET status = 'failed', error_message = 'Session expired'
           WHERE transaction_id = ?`,
					[session.id],
				);

				await connection.execute(
					`UPDATE billing_orders 
           SET status = 'failed'
           WHERE id = ?`,
					[orderId],
				);

				await connection.end();
			}
		}

		return { success: true };
	} catch (error) {
		console.error('Webhook error:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Webhook processing failed',
		});
	}
});
```

---

### 5. Компонент: Обработка платежа

**Файл:** `components/billing/PaymentProcessor.vue`

```vue
<script setup lang="ts">
interface Props {
	orderId: string;
}

const props = defineProps<Props>();
const isProcessing = ref(false);
const error = ref<string | null>(null);

onMounted(async () => {
	try {
		isProcessing.value = true;

		const { data, error: fetchError } = await useFetch(
			`/api/billing/orders/${props.orderId}/payment`,
			{ method: 'POST' },
		);

		if (fetchError.value) {
			throw new Error('Failed to create payment session');
		}

		if (data.value?.paymentUrl) {
			// Редирект на Stripe Checkout
			window.location.href = data.value.paymentUrl;
		}
	} catch (err) {
		error.value = 'Ошибка инициализации оплаты';
		isProcessing.value = false;
	}
});
</script>

<template>
	<div class="payment-processor">
		<div v-if="isProcessing" class="processing">
			<el-icon class="is-loading" :size="48"><Loading /></el-icon>
			<h3>{{ $t('billing.payment.redirecting') }}</h3>
			<p>{{ $t('billing.payment.pleaseWait') }}</p>
		</div>

		<el-alert
			v-if="error"
			type="error"
			:title="error"
			show-icon
			:closable="false"
		/>
	</div>
</template>

<style scoped>
.payment-processor {
	max-width: 600px;
	margin: 48px auto;
	padding: 24px;
}

.processing {
	text-align: center;
	padding: 48px 24px;
}

.processing h3 {
	font-size: 24px;
	margin: 24px 0 12px;
}

.processing p {
	color: var(--el-text-color-secondary);
}
</style>
```

---

### 6. Страница успешной оплаты

**Файл:** `pages/profile/clinics/[id]/billing/success.vue`

```vue
<script setup lang="ts">
const route = useRoute();
const router = useRouter();
const clinicId = Number(route.params.id);
const sessionId = route.query.session_id as string;

// В следующей итерации здесь будет проверка активации услуг

const goToBilling = () => {
	router.push(`/profile/clinics/${clinicId}/billing`);
};
</script>

<template>
	<div class="success-page">
		<el-result
			icon="success"
			:title="$t('billing.payment.success.title')"
			:sub-title="$t('billing.payment.success.message')"
		>
			<template #extra>
				<el-button type="primary" size="large" @click="goToBilling">
					{{ $t('billing.backToBilling') }}
				</el-button>
			</template>
		</el-result>
	</div>
</template>

<style scoped>
.success-page {
	max-width: 800px;
	margin: 48px auto;
	padding: 24px;
}
</style>
```

---

### 7. Страница ошибки оплаты

**Файл:** `pages/profile/clinics/[id]/billing/error.vue`

```vue
<script setup lang="ts">
const route = useRoute();
const router = useRouter();
const clinicId = Number(route.params.id);
const orderId = route.query.order_id as string;

const retryPayment = () => {
	if (orderId) {
		router.push(`/profile/clinics/${clinicId}/billing/payment/${orderId}`);
	}
};

const goBack = () => {
	router.push(`/profile/clinics/${clinicId}/billing`);
};
</script>

<template>
	<div class="error-page">
		<el-result
			icon="error"
			:title="$t('billing.payment.error.title')"
			:sub-title="$t('billing.payment.error.message')"
		>
			<template #extra>
				<el-space>
					<el-button @click="goBack">
						{{ $t('common.back') }}
					</el-button>
					<el-button v-if="orderId" type="primary" @click="retryPayment">
						{{ $t('billing.payment.error.retry') }}
					</el-button>
				</el-space>
			</template>
		</el-result>
	</div>
</template>

<style scoped>
.error-page {
	max-width: 800px;
	margin: 48px auto;
	padding: 24px;
}
</style>
```

---

### 8. Обновить checkout страницу

**Файл:** `pages/profile/clinics/[id]/billing/checkout.vue` (обновить)

Изменить метод `handlePayment`:

```typescript
const handlePayment = () => {
	// Редирект на страницу обработки платежа
	router.push(`/profile/clinics/${clinicId}/billing/payment/${orderId.value}`);
};
```

---

### 9. Страница обработки платежа

**Файл:** `pages/profile/clinics/[id]/billing/payment/[orderId].vue`

```vue
<script setup lang="ts">
const route = useRoute();
const orderId = route.params.orderId as string;
</script>

<template>
	<div class="payment-page">
		<BillingPaymentProcessor :order-id="orderId" />
	</div>
</template>

<style scoped>
.payment-page {
	min-height: 60vh;
	display: flex;
	align-items: center;
	justify-content: center;
}
</style>
```

---

### 10. Локализация

Добавить в `locales/ru.json`:

```json
{
	"billing": {
		"payment": {
			"redirecting": "Перенаправление на страницу оплаты...",
			"pleaseWait": "Пожалуйста, подождите. Не закрывайте это окно.",
			"success": {
				"title": "Оплата прошла успешно!",
				"message": "Ваши услуги будут активированы в течение нескольких минут."
			},
			"error": {
				"title": "Ошибка оплаты",
				"message": "К сожалению, оплата не прошла. Попробуйте еще раз или свяжитесь с поддержкой.",
				"retry": "Попробовать снова"
			}
		},
		"proceedToPayment": "Перейти к оплате",
		"backToBilling": "Вернуться к платным услугам"
	}
}
```

---

## Настройка Stripe Webhook

### Локальное тестирование

1. Установить Stripe CLI:

```bash
# Windows
scoop install stripe

# macOS
brew install stripe/stripe-cli/stripe

# Linux
https://stripe.com/docs/stripe-cli
```

2. Авторизоваться:

```bash
stripe login
```

3. Прослушивать webhooks:

```bash
stripe listen --forward-to localhost:3000/api/billing/webhooks/payment
```

4. Получить webhook secret и добавить в `.env`:

```
STRIPE_WEBHOOK_SECRET=whsec_...
```

### Production настройка

1. В Stripe Dashboard → Developers → Webhooks
2. Add endpoint: `https://yourdomain.com/api/billing/webhooks/payment`
3. Select events:
   - `checkout.session.completed`
   - `checkout.session.expired`
4. Скопировать Signing secret в `.env`

---

## Критерии приемки

- [ ] **AC-1:** При клике "Оплатить" создается Stripe checkout session
- [ ] **AC-2:** Пользователь перенаправляется на Stripe Checkout форму
- [ ] **AC-3:** На форме отображаются выбранные услуги и цены
- [ ] **AC-4:** После успешной оплаты пользователь возвращается на `/success`
- [ ] **AC-5:** После отмены оплаты пользователь возвращается на `/error`
- [ ] **AC-6:** Webhook от Stripe обрабатывается корректно
- [ ] **AC-7:** Статус заказа меняется на `completed` после оплаты
- [ ] **AC-8:** Транзакция сохраняется в `billing_payment_transactions`
- [ ] **AC-9:** Webhook идемпотентен (повторный вызов не создает дубликаты)
- [ ] **AC-10:** Истекшие сессии обрабатываются (статус `failed`)
- [ ] **AC-11:** Можно повторить попытку оплаты при ошибке
- [ ] **AC-12:** Все платежи логируются в БД

---

## Тестирование

### Тестовые карты Stripe

```
Успешная оплата:
4242 4242 4242 4242

Отклоненная карта:
4000 0000 0000 0002

Требуется 3D Secure:
4000 0025 0000 3155
```

### Сценарии тестирования

1. **Успешная оплата:**

   - Выбрать услуги → Создать заказ → Оплатить
   - Использовать тестовую карту `4242...`
   - Проверить редирект на `/success`
   - Проверить webhook в БД
   - Проверить статус заказа = `completed`

2. **Отменная оплата:**

   - Начать оплату
   - Кликнуть "Back" на Stripe форме
   - Проверить редирект на `/error`
   - Проверить возможность retry

3. **Webhook обработка:**
   - Запустить `stripe listen`
   - Совершить тестовый платеж
   - Проверить логи webhook
   - Проверить обновление БД

---

## Следующие шаги

**Следующая итерация:** [4. Подтверждение и активация услуг →](iteration-04-activation.md)

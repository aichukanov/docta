# Итерация 4: Подтверждение и активация услуг

[← К списку итераций](README.md) | [Предыдущая](iteration-03-payment-integration.md)

---

## Статус: 🔴 Not Started

---

## Цель

Автоматически активировать услуги после подтверждения оплаты через webhook, отправить email подтверждение и обновить публичную страницу клиники.

---

## Зависимости

- **Итерации 1-3** - полный flow от выбора до оплаты (✅ требуется)
- **Email система** - для отправки подтверждений (⏳ требуется)

---

## Задачи

### 1. Функция активации услуг

**Файл:** `server/utils/billing/activateServices.ts`

```typescript
import type { Connection } from 'mysql2/promise';
import { getConnection } from '~/server/common/db-mysql';

interface ActivationResult {
	success: boolean;
	purchaseId?: number;
	error?: string;
}

export async function activateServices(
	orderId: string,
): Promise<ActivationResult> {
	const connection = await getConnection();

	try {
		await connection.beginTransaction();

		// Получить заказ
		const [orderRows]: any = await connection.execute(
			`SELECT * FROM billing_orders WHERE id = ?`,
			[orderId],
		);

		if (orderRows.length === 0) {
			throw new Error(`Order ${orderId} not found`);
		}

		const order = orderRows[0];

		// Проверить, что заказ уже completed
		if (order.status !== 'completed') {
			throw new Error(
				`Order ${orderId} is not completed (status: ${order.status})`,
			);
		}

		// Проверить, не активированы ли уже услуги
		const [existingPurchases]: any = await connection.execute(
			`SELECT COUNT(*) as count
       FROM billing_clinic_service_purchases
       WHERE clinic_id = ? AND purchased_at >= ?`,
			[order.clinic_id, order.created_at],
		);

		if (existingPurchases[0].count > 0) {
			console.log(`Services already activated for order ${orderId}`);
			await connection.commit();
			await connection.end();
			return { success: true, purchaseId: existingPurchases[0].id };
		}

		// Получить элементы заказа
		const [itemRows]: any = await connection.execute(
			`SELECT service_id, months, price
       FROM billing_order_items
       WHERE order_id = ?`,
			[orderId],
		);

		if (itemRows.length === 0) {
			throw new Error(`No items found for order ${orderId}`);
		}

		// Определить максимальный период (для valid_until)
		const maxMonths = Math.max(...itemRows.map((item: any) => item.months));

		// Создать покупку
		const [insertResult]: any = await connection.execute(
			`INSERT INTO billing_clinic_service_purchases 
       (clinic_id, price, purchased_at, valid_until, deleted)
       VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL ? MONTH), FALSE)`,
			[order.clinic_id, order.total_amount, maxMonths],
		);

		const purchaseId = insertResult.insertId;

		// Добавить элементы покупки
		for (const item of itemRows) {
			await connection.execute(
				`INSERT INTO billing_clinic_service_purchase_items 
         (purchase_id, service_id)
         VALUES (?, ?)`,
				[purchaseId, item.service_id],
			);
		}

		console.log(
			`Services activated for order ${orderId}, purchase ID: ${purchaseId}`,
		);

		await connection.commit();

		return { success: true, purchaseId };
	} catch (error) {
		await connection.rollback();
		console.error(`Failed to activate services for order ${orderId}:`, error);
		return {
			success: false,
			error: error instanceof Error ? error.message : 'Unknown error',
		};
	} finally {
		await connection.end();
	}
}
```

---

### 2. Обновить webhook для активации

**Файл:** `server/api/billing/webhooks/payment.post.ts` (обновить)

Добавить вызов `activateServices` после успешной оплаты:

```typescript
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

		// ... existing code для обновления транзакции и заказа ...

		await connection.commit();
		await connection.end();

		// НОВОЕ: Активировать услуги
		const activationResult = await activateServices(orderId);

		if (!activationResult.success) {
			console.error(
				`Failed to activate services for order ${orderId}:`,
				activationResult.error,
			);

			// Логировать ошибку активации
			const errorConnection = await getConnection();
			await errorConnection.execute(
				`INSERT INTO billing_activation_errors 
         (order_id, error_message, created_at)
         VALUES (?, ?, NOW())`,
				[orderId, activationResult.error],
			);
			await errorConnection.end();

			// Вернуть успех webhook, но логировать проблему
			return { success: true, warning: 'Services activation failed' };
		}

		// НОВОЕ: Отправить email подтверждение
		await sendPurchaseConfirmationEmail(orderId, activationResult.purchaseId!);

		console.log('Services activated and email sent for order:', orderId);
	} catch (error) {
		await connection.rollback();
		throw error;
	} finally {
		await connection.end();
	}
}
```

---

### 3. Миграция: Таблица ошибок активации

**Файл:** `server/database/migrations/004_create_billing_activation_errors.sql`

```sql
CREATE TABLE IF NOT EXISTS billing_activation_errors (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  error_message TEXT,
  resolved BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP NULL,

  FOREIGN KEY (order_id) REFERENCES billing_orders(id),
  INDEX idx_order (order_id),
  INDEX idx_resolved (resolved)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

### 4. Email: Подтверждение покупки

**Файл:** `server/utils/billing/sendPurchaseConfirmationEmail.ts`

```typescript
import { getConnection } from '~/server/common/db-mysql';
import { sendEmail } from '~/server/utils/email'; // Предполагаем наличие email утилиты

export async function sendPurchaseConfirmationEmail(
	orderId: string,
	purchaseId: number,
): Promise<void> {
	const connection = await getConnection();

	try {
		// Получить данные покупки
		const [purchaseRows]: any = await connection.execute(
			`SELECT 
        p.*,
        c.name as clinic_name,
        c.email as clinic_email
       FROM billing_clinic_service_purchases p
       JOIN clinics c ON p.clinic_id = c.id
       WHERE p.id = ?`,
			[purchaseId],
		);

		if (purchaseRows.length === 0) {
			throw new Error(`Purchase ${purchaseId} not found`);
		}

		const purchase = purchaseRows[0];

		// Получить услуги
		const [serviceRows]: any = await connection.execute(
			`SELECT s.name, s.description
       FROM billing_clinic_service_purchase_items i
       JOIN billing_paid_services s ON i.service_id = s.id
       WHERE i.purchase_id = ?`,
			[purchaseId],
		);

		await connection.end();

		// Формируем email
		const emailHTML = `
      <h2>Подтверждение покупки платных услуг</h2>
      <p>Здравствуйте!</p>
      <p>Ваша оплата успешно обработана, и услуги активированы для клиники <strong>${
				purchase.clinic_name
			}</strong>.</p>
      
      <h3>Детали покупки:</h3>
      <ul>
        ${serviceRows
					.map(
						(s: any) =>
							`<li><strong>${s.name}</strong> - ${s.description}</li>`,
					)
					.join('')}
      </ul>
      
      <p><strong>Стоимость:</strong> €${purchase.price}</p>
      <p><strong>Дата покупки:</strong> ${new Date(
				purchase.purchased_at,
			).toLocaleDateString('ru-RU')}</p>
      <p><strong>Действительно до:</strong> ${new Date(
				purchase.valid_until,
			).toLocaleDateString('ru-RU')}</p>
      
      <p>Вы можете увидеть активированные услуги на публичной странице вашей клиники.</p>
      
      <p>С уважением,<br>Команда Docta.me</p>
    `;

		// Отправить email
		await sendEmail({
			to: purchase.clinic_email,
			subject: 'Подтверждение покупки платных услуг',
			html: emailHTML,
		});

		console.log(`Confirmation email sent for purchase ${purchaseId}`);
	} catch (error) {
		console.error(
			`Failed to send confirmation email for purchase ${purchaseId}:`,
			error,
		);
		// Не бросаем ошибку - email не критичен
	}
}
```

---

### 5. API: Проверка статуса активации

**Файл:** `server/api/billing/orders/[id]/activation-status.get.ts`

```typescript
import { getConnection } from '~/server/common/db-mysql';
import { requireAuth } from '~/server/common/auth';

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

		// Проверить статус заказа
		const [orderRows]: any = await connection.execute(
			`SELECT status FROM billing_orders WHERE id = ?`,
			[orderId],
		);

		if (orderRows.length === 0) {
			await connection.end();
			throw createError({ statusCode: 404, statusMessage: 'Order not found' });
		}

		const orderStatus = orderRows[0].status;

		// Проверить наличие покупки
		const [purchaseRows]: any = await connection.execute(
			`SELECT p.id, p.purchased_at, p.valid_until
       FROM billing_clinic_service_purchases p
       JOIN billing_orders o ON p.clinic_id = o.clinic_id
       WHERE o.id = ? AND p.purchased_at >= o.created_at
       LIMIT 1`,
			[orderId],
		);

		const isActivated = purchaseRows.length > 0;

		// Проверить ошибки активации
		const [errorRows]: any = await connection.execute(
			`SELECT error_message, created_at
       FROM billing_activation_errors
       WHERE order_id = ? AND resolved = FALSE
       ORDER BY created_at DESC
       LIMIT 1`,
			[orderId],
		);

		await connection.end();

		return {
			orderId,
			orderStatus,
			isActivated,
			purchaseInfo: isActivated
				? {
						purchaseId: purchaseRows[0].id,
						purchasedAt: purchaseRows[0].purchased_at,
						validUntil: purchaseRows[0].valid_until,
				  }
				: null,
			activationError: errorRows.length > 0 ? errorRows[0].error_message : null,
		};
	} catch (error) {
		console.error('API Error - activation status:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch activation status',
		});
	}
});
```

---

### 6. Обновить страницу успеха

**Файл:** `pages/profile/clinics/[id]/billing/success.vue` (обновить)

```vue
<script setup lang="ts">
const route = useRoute();
const router = useRouter();
const clinicId = Number(route.params.id);
const sessionId = route.query.session_id as string;

// Получить orderId из session (упрощенно - в реальности через API)
const orderId = ref<string | null>(null);

// Загрузить статус активации
const { data: activationStatus, pending } = await useFetch(
	() => `/api/billing/orders/${orderId.value}/activation-status`,
	{
		watch: [orderId],
		immediate: false,
	},
);

// Polling для проверки активации (если еще не активировано)
const pollInterval = ref<NodeJS.Timeout | null>(null);

onMounted(async () => {
	// Здесь нужно получить orderId из sessionId
	// Для упрощения предполагаем, что он передается в query
	orderId.value = route.query.order_id as string;

	// Начать polling, если заказ не активирован
	if (!activationStatus.value?.isActivated) {
		pollInterval.value = setInterval(async () => {
			// Reload activation status
			await refreshNuxtData('activation-status');

			if (activationStatus.value?.isActivated) {
				clearInterval(pollInterval.value!);
				ElMessage.success('Услуги активированы!');
			}
		}, 5000); // Проверять каждые 5 секунд
	}
});

onUnmounted(() => {
	if (pollInterval.value) {
		clearInterval(pollInterval.value);
	}
});

const goToBilling = () => {
	router.push(`/profile/clinics/${clinicId}/billing`);
};

const goToClinicPage = () => {
	router.push(`/clinics/${clinicId}`);
};
</script>

<template>
	<div class="success-page">
		<el-result icon="success" :title="$t('billing.payment.success.title')">
			<template #sub-title>
				<div v-if="pending" class="activation-checking">
					<el-icon class="is-loading"><Loading /></el-icon>
					<span>{{ $t('billing.activation.checking') }}</span>
				</div>

				<div
					v-else-if="activationStatus?.isActivated"
					class="activation-success"
				>
					<el-icon color="#67C23A"><CircleCheck /></el-icon>
					<span>{{ $t('billing.activation.success') }}</span>
					<p class="activation-date">
						{{
							$t('billing.activation.validUntil', {
								date: new Date(
									activationStatus.purchaseInfo.validUntil,
								).toLocaleDateString('ru-RU'),
							})
						}}
					</p>
				</div>

				<div
					v-else-if="activationStatus?.activationError"
					class="activation-error"
				>
					<el-icon color="#F56C6C"><CircleClose /></el-icon>
					<span>{{ $t('billing.activation.error') }}</span>
					<p class="error-message">{{ activationStatus.activationError }}</p>
				</div>

				<div v-else class="activation-pending">
					<el-icon class="is-loading"><Loading /></el-icon>
					<span>{{ $t('billing.activation.pending') }}</span>
				</div>
			</template>

			<template #extra>
				<el-space>
					<el-button type="primary" size="large" @click="goToClinicPage">
						{{ $t('billing.viewClinicPage') }}
					</el-button>
					<el-button size="large" @click="goToBilling">
						{{ $t('billing.backToBilling') }}
					</el-button>
				</el-space>
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

.activation-checking,
.activation-success,
.activation-error,
.activation-pending {
	display: flex;
	align-items: center;
	gap: 12px;
	justify-content: center;
	margin-top: 16px;
	font-size: 16px;
}

.activation-date,
.error-message {
	margin-top: 8px;
	font-size: 14px;
	color: var(--el-text-color-secondary);
}
</style>
```

---

### 7. Админка: Мануальная активация

**Файл:** `pages/admin/billing/activation-errors.vue`

```vue
<script setup lang="ts">
// Страница для суперадмина для просмотра и исправления ошибок активации

const { data: errors } = await useFetch('/api/admin/billing/activation-errors');

const retryActivation = async (orderId: string) => {
	try {
		await $fetch(`/api/admin/billing/retry-activation`, {
			method: 'POST',
			body: { orderId },
		});

		ElMessage.success('Активация повторена');
		refreshNuxtData('activation-errors');
	} catch (error) {
		ElMessage.error('Ошибка повторной активации');
	}
};
</script>

<template>
	<div class="activation-errors-page">
		<h1>Ошибки активации услуг</h1>

		<el-table :data="errors?.errors || []">
			<el-table-column prop="orderId" label="Order ID" />
			<el-table-column prop="clinicName" label="Клиника" />
			<el-table-column prop="errorMessage" label="Ошибка" />
			<el-table-column prop="createdAt" label="Дата" />
			<el-table-column label="Действия">
				<template #default="{ row }">
					<el-button @click="retryActivation(row.orderId)">
						Повторить
					</el-button>
				</template>
			</el-table-column>
		</el-table>
	</div>
</template>
```

---

### 8. Локализация

Добавить в `locales/ru.json`:

```json
{
	"billing": {
		"activation": {
			"checking": "Проверка активации услуг...",
			"success": "Услуги успешно активированы!",
			"error": "Ошибка активации услуг",
			"pending": "Активация услуг в процессе...",
			"validUntil": "Действительно до {date}"
		},
		"viewClinicPage": "Посмотреть страницу клиники"
	}
}
```

---

## Критерии приемки

- [ ] **AC-1:** После успешной оплаты создается запись в `billing_clinic_service_purchases`
- [ ] **AC-2:** Создаются записи в `billing_clinic_service_purchase_items` для каждой услуги
- [ ] **AC-3:** Период действия (`valid_until`) рассчитывается корректно
- [ ] **AC-4:** Отправляется email подтверждение администратору клиники
- [ ] **AC-5:** На публичной странице клиники отображаются активированные услуги:
  - APPROVED badge виден
  - HIGHLIGHT работает в списках
  - DOFOLLOW применяется к ссылкам
- [ ] **AC-6:** Ошибки активации логируются в `billing_activation_errors`
- [ ] **AC-7:** Существует API для проверки статуса активации
- [ ] **AC-8:** Страница success показывает статус активации (в процессе/успешно/ошибка)
- [ ] **AC-9:** Суперадмин может видеть ошибки активации и повторять их

---

## Тестирование

### Сценарий 1: Успешная активация

1. Выбрать услуги (например, APPROVED)
2. Оплатить через Stripe
3. Дождаться webhook
4. Проверить:
   - Запись в `billing_clinic_service_purchases`
   - Email получен
   - На странице клиники виден бейдж APPROVED
   - В истории покупок услуга отмечена как активная

### Сценарий 2: Ошибка активации

1. Имитировать ошибку БД (temporary failure)
2. Совершить оплату
3. Проверить:
   - Webhook обработан успешно
   - Ошибка залогирована в `billing_activation_errors`
   - Админ видит ошибку в админке
   - Можно повторить активацию вручную

### Сценарий 3: Проверка на странице клиники

1. Активировать услугу APPROVED
2. Открыть публичную страницу клиники `/clinics/[id]`
3. Проверить наличие бейджа ✓ "Верифицировано"

---

## Файловая структура

```
server/
├── database/migrations/
│   └── 004_create_billing_activation_errors.sql ✅
├── utils/billing/
│   ├── activateServices.ts ✅
│   └── sendPurchaseConfirmationEmail.ts ✅
└── api/
    ├── billing/
    │   ├── webhooks/payment.post.ts (обновить) ✅
    │   └── orders/[id]/activation-status.get.ts ✅
    └── admin/billing/
        ├── activation-errors.get.ts ✅
        └── retry-activation.post.ts ✅

pages/
├── profile/clinics/[id]/billing/
│   └── success.vue (обновить) ✅
└── admin/billing/
    └── activation-errors.vue ✅

locales/
└── ru.json (обновить) ✅
```

---

## Завершение разработки

После завершения этой итерации:

✅ Пользователи могут самостоятельно покупать платные услуги  
✅ Оплата проходит через Stripe  
✅ Услуги активируются автоматически  
✅ Отправляются email подтверждения  
✅ Публичная страница обновляется

**PRD завершен!** 🎉

---

**Вернуться к:** [← Обзору итераций](README.md) | [← Оглавлению PRD](../index.md)

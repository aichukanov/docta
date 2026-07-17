# Итерация 2: Выбор и формирование заказа

[← К списку итераций](README.md) | [Предыдущая](iteration-01-services-page.md) | [Следующая →](iteration-03-payment-integration.md)

---

## Статус: ✅ Done (2026-06-12, детали и отступления — в ../PROGRESS.md)

---

## Цель

Добавить возможность выбора нескольких услуг, периода действия и создания заказа с расчетом итоговой стоимости.

---

## Зависимости

- **Итерация 1** - страница платных услуг (✅ требуется)

---

## Задачи

### 1. Миграции: Таблицы заказов

**Файл:** `server/database/migrations/002_create_billing_orders.sql`

```sql
-- Таблица заказов
CREATE TABLE IF NOT EXISTS billing_orders (
  id VARCHAR(36) PRIMARY KEY COMMENT 'UUID заказа',
  clinic_id INT NOT NULL,
  status ENUM('pending_payment', 'processing', 'completed', 'failed', 'cancelled')
    DEFAULT 'pending_payment',
  total_amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (clinic_id) REFERENCES clinics(id),
  INDEX idx_clinic_status (clinic_id, status),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблица элементов заказа
CREATE TABLE IF NOT EXISTS billing_order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  service_id INT NOT NULL,
  months INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (order_id) REFERENCES billing_orders(id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id),
  INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

### 2. Pinia Store для управления заказом

**Файл:** `stores/billing.ts`

```typescript
export const useBillingStore = defineStore('billing', {
	state: () => ({
		services: [] as BillingService[],
		selectedItems: [] as Array<{
			serviceId: number;
			months: 1 | 3 | 6 | 12;
		}>,
		currentOrder: null as Order | null,
	}),

	getters: {
		totalAmount(): number {
			return this.selectedItems.reduce((sum, item) => {
				const service = this.services.find((s) => s.id === item.serviceId);
				const price = service?.pricing[item.months] || 0;
				return sum + price;
			}, 0);
		},

		hasSelection(): boolean {
			return this.selectedItems.length > 0;
		},
	},

	actions: {
		toggleService(serviceId: number, months: 1 | 3 | 6 | 12) {
			const index = this.selectedItems.findIndex(
				(item) => item.serviceId === serviceId,
			);

			if (index >= 0) {
				// Если уже выбрано - обновляем период или удаляем
				if (this.selectedItems[index].months === months) {
					this.selectedItems.splice(index, 1);
				} else {
					this.selectedItems[index].months = months;
				}
			} else {
				// Добавляем новую услугу
				this.selectedItems.push({ serviceId, months });
			}
		},

		clearSelection() {
			this.selectedItems = [];
		},

		async createOrder(clinicId: number) {
			const { data, error } = await useFetch('/api/billing/orders/create', {
				method: 'POST',
				body: {
					clinicId,
					items: this.selectedItems,
				},
			});

			if (error.value) {
				throw new Error('Failed to create order');
			}

			this.currentOrder = data.value;
			return data.value.orderId;
		},
	},
});
```

---

### 3. API: Создание заказа

**Файл:** `server/api/billing/orders/create.post.ts`

```typescript
import { getConnection } from '~/server/common/db-mysql';
import { requireAuth } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';
import { randomUUID } from 'crypto';

interface CreateOrderRequest {
	clinicId: number;
	items: Array<{
		serviceId: number;
		months: 1 | 3 | 6 | 12;
	}>;
}

export default defineEventHandler(async (event) => {
	try {
		requireAuth(event);

		const body = await readBody<CreateOrderRequest>(event);

		if (!validateBody(body, 'api/billing/orders/create')) {
			throw createError({ statusCode: 400, statusMessage: 'Invalid request' });
		}

		if (!validateNonNegativeInteger(body.clinicId)) {
			throw createError({
				statusCode: 400,
				statusMessage: 'Invalid clinic ID',
			});
		}

		if (!body.items || body.items.length === 0) {
			throw createError({
				statusCode: 400,
				statusMessage: 'No items selected',
			});
		}

		// TODO: Проверить права clinic_admin

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Получить цены на услуги
			const serviceIds = body.items.map((item) => item.serviceId);
			const [priceRows]: any = await connection.execute(
				`SELECT service_id, months, price 
         FROM billing_service_prices 
         WHERE service_id IN (?) AND active = TRUE`,
				[serviceIds],
			);

			// Создать map цен
			const pricesMap = new Map<string, number>();
			for (const row of priceRows) {
				pricesMap.set(`${row.service_id}-${row.months}`, row.price);
			}

			// Рассчитать итоговую сумму и проверить наличие цен
			let totalAmount = 0;
			for (const item of body.items) {
				const key = `${item.serviceId}-${item.months}`;
				const price = pricesMap.get(key);

				if (!price) {
					throw createError({
						statusCode: 400,
						statusMessage: `Price not found for service ${item.serviceId} / ${item.months} months`,
					});
				}

				totalAmount += price;
			}

			// Создать заказ
			const orderId = randomUUID();
			await connection.execute(
				`INSERT INTO billing_orders (id, clinic_id, total_amount, status)
         VALUES (?, ?, ?, 'pending_payment')`,
				[orderId, body.clinicId, totalAmount],
			);

			// Добавить элементы заказа
			for (const item of body.items) {
				const key = `${item.serviceId}-${item.months}`;
				const price = pricesMap.get(key)!;

				await connection.execute(
					`INSERT INTO billing_order_items (order_id, service_id, months, price)
           VALUES (?, ?, ?, ?)`,
					[orderId, item.serviceId, item.months, price],
				);
			}

			await connection.commit();

			return {
				orderId,
				totalAmount,
				currency: 'EUR',
			};
		} catch (error) {
			await connection.rollback();
			throw error;
		} finally {
			await connection.end();
		}
	} catch (error) {
		console.error('API Error - create order:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to create order',
		});
	}
});
```

---

### 4. API: Получение деталей заказа

**Файл:** `server/api/billing/orders/[id].get.ts`

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

		// Получить элементы заказа
		const [itemRows]: any = await connection.execute(
			`SELECT 
        oi.service_id as serviceId,
        s.name as serviceName,
        oi.months,
        oi.price
       FROM billing_order_items oi
       JOIN billing_paid_services s ON oi.service_id = s.id
       WHERE oi.order_id = ?`,
			[orderId],
		);

		await connection.end();

		return {
			id: order.id,
			clinicId: order.clinic_id,
			status: order.status,
			totalAmount: order.total_amount,
			currency: order.currency,
			createdAt: order.created_at,
			items: itemRows.map((item: any) => ({
				serviceId: item.serviceId,
				serviceName: item.serviceName,
				months: item.months,
				price: item.price,
			})),
		};
	} catch (error) {
		console.error('API Error - get order:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch order',
		});
	}
});
```

---

### 5. Обновить ServiceCard для выбора

**Файл:** `components/billing/ServiceCard.vue` (обновить)

Добавить:

- Чекбокс для выбора услуги
- Радио-кнопки для выбора периода (1, 3, 6, 12 месяцев)
- Эмиты для v-model

```vue
<script setup lang="ts">
// ... existing code ...

const emit = defineEmits<{
	'update:selected': [boolean];
	'update:months': [1 | 3 | 6 | 12];
}>();

const selectedMonths = ref<1 | 3 | 6 | 12>(1);
</script>

<template>
	<el-card class="service-card">
		<!-- ... existing header ... -->

		<!-- Выбор услуги -->
		<div v-if="!isActive" class="selection-section">
			<el-checkbox
				:model-value="selected"
				@update:model-value="emit('update:selected', $event)"
			>
				{{ $t('billing.selectService') }}
			</el-checkbox>

			<div v-if="selected" class="period-selection">
				<div class="period-label">{{ $t('billing.selectPeriod') }}</div>
				<el-radio-group
					v-model="selectedMonths"
					@change="emit('update:months', selectedMonths)"
				>
					<el-radio :label="1"
						>1 мес ({{ formatPrice(service.pricing[1]) }})</el-radio
					>
					<el-radio :label="3"
						>3 мес ({{ formatPrice(service.pricing[3]) }})</el-radio
					>
					<el-radio :label="6"
						>6 мес ({{ formatPrice(service.pricing[6]) }})</el-radio
					>
					<el-radio :label="12"
						>12 мес ({{ formatPrice(service.pricing[12]) }})</el-radio
					>
				</el-radio-group>
			</div>
		</div>
	</el-card>
</template>
```

---

### 6. Компонент: Корзина заказа

**Файл:** `components/billing/OrderBasket.vue`

```vue
<script setup lang="ts">
import { useBillingStore } from '~/stores/billing';

const billingStore = useBillingStore();
const router = useRouter();

const emit = defineEmits<{
	checkout: [];
}>();

const formatPrice = (price: number) => {
	return new Intl.NumberFormat('en-US', {
		style: 'currency',
		currency: 'EUR',
	}).format(price);
};

const handleCheckout = () => {
	emit('checkout');
};
</script>

<template>
	<el-card v-if="billingStore.hasSelection" class="order-basket">
		<h3>{{ $t('billing.selectedServices') }}</h3>

		<div class="selected-items">
			<div
				v-for="item in billingStore.selectedItems"
				:key="item.serviceId"
				class="selected-item"
			>
				<div class="item-info">
					<span class="service-name">
						{{ $t(`billing.services.${getServiceName(item.serviceId)}.name`) }}
					</span>
					<span class="item-period">{{ item.months }} мес.</span>
				</div>
				<div class="item-price">
					{{ formatPrice(getItemPrice(item)) }}
				</div>
			</div>
		</div>

		<div class="basket-footer">
			<div class="total">
				<span class="total-label">{{ $t('billing.total') }}:</span>
				<span class="total-amount">
					{{ formatPrice(billingStore.totalAmount) }}
				</span>
			</div>

			<el-button type="primary" size="large" @click="handleCheckout">
				{{ $t('billing.proceedToPayment') }}
			</el-button>
		</div>
	</el-card>
</template>

<style scoped>
.order-basket {
	position: sticky;
	top: 24px;
}

h3 {
	font-size: 18px;
	font-weight: 600;
	margin-bottom: 16px;
}

.selected-items {
	display: flex;
	flex-direction: column;
	gap: 12px;
	margin-bottom: 20px;
}

.selected-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 12px;
	background: var(--el-fill-color-light);
	border-radius: 4px;
}

.item-info {
	display: flex;
	flex-direction: column;
	gap: 4px;
}

.service-name {
	font-weight: 600;
}

.item-period {
	font-size: 12px;
	color: var(--el-text-color-secondary);
}

.item-price {
	font-weight: 600;
	color: var(--el-color-primary);
}

.basket-footer {
	border-top: 2px solid var(--el-border-color);
	padding-top: 16px;
}

.total {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
	font-size: 18px;
}

.total-label {
	font-weight: 600;
}

.total-amount {
	font-size: 24px;
	font-weight: 700;
	color: var(--el-color-primary);
}
</style>
```

---

### 7. Страница подтверждения заказа

**Файл:** `pages/profile/clinics/[id]/billing/checkout.vue`

```vue
<script setup lang="ts">
const route = useRoute();
const router = useRouter();
const clinicId = Number(route.params.id);
const billingStore = useBillingStore();

// Создать заказ при загрузке страницы
const isLoading = ref(false);
const orderId = ref<string | null>(null);

onMounted(async () => {
	if (!billingStore.hasSelection) {
		router.push(`/profile/clinics/${clinicId}/billing`);
		return;
	}

	try {
		isLoading.value = true;
		orderId.value = await billingStore.createOrder(clinicId);
	} catch (error) {
		ElMessage.error('Ошибка создания заказа');
		router.push(`/profile/clinics/${clinicId}/billing`);
	} finally {
		isLoading.value = false;
	}
});

// Загрузить детали заказа
const { data: orderData } = await useFetch(
	() => `/api/billing/orders/${orderId.value}`,
	{
		watch: [orderId],
	},
);

const handlePayment = () => {
	// В следующей итерации - редирект на оплату
	router.push(`/profile/clinics/${clinicId}/billing/payment/${orderId.value}`);
};

const handleCancel = () => {
	router.push(`/profile/clinics/${clinicId}/billing`);
	billingStore.clearSelection();
};
</script>

<template>
	<div class="checkout-page">
		<el-page-header @back="handleCancel">
			<template #content>
				<span class="page-title">{{ $t('billing.checkout.title') }}</span>
			</template>
		</el-page-header>

		<el-card v-if="orderData" class="order-summary">
			<h2>{{ $t('billing.checkout.orderSummary') }}</h2>

			<div class="order-items">
				<div
					v-for="item in orderData.items"
					:key="item.serviceId"
					class="order-item"
				>
					<div class="item-name">
						{{ $t(`billing.services.${item.serviceName.toLowerCase()}.name`) }}
					</div>
					<div class="item-period"
						>{{ item.months }} {{ $t('billing.months') }}</div
					>
					<div class="item-price">{{ formatPrice(item.price) }}</div>
				</div>
			</div>

			<div class="order-total">
				<span class="total-label">{{ $t('billing.total') }}:</span>
				<span class="total-amount">
					{{ formatPrice(orderData.totalAmount) }}
				</span>
			</div>

			<div class="actions">
				<el-button @click="handleCancel">
					{{ $t('common.cancel') }}
				</el-button>
				<el-button type="primary" size="large" @click="handlePayment">
					{{ $t('billing.proceedToPayment') }}
				</el-button>
			</div>
		</el-card>

		<div v-else-if="isLoading" class="loading">
			<el-icon class="is-loading"><Loading /></el-icon>
			<span>{{ $t('billing.creatingOrder') }}</span>
		</div>
	</div>
</template>
```

---

## Критерии приемки

- [ ] **AC-1:** Можно выбрать несколько услуг через чекбоксы
- [ ] **AC-2:** Для каждой выбранной услуги можно выбрать период (1, 3, 6, 12 мес.)
- [ ] **AC-3:** Отображается итоговая стоимость заказа в реальном времени
- [ ] **AC-4:** Кнопка "Купить" активна только если выбрана хотя бы одна услуга
- [ ] **AC-5:** При клике "Купить" создается заказ в БД со статусом `pending_payment`
- [ ] **AC-6:** Открывается страница `/profile/clinics/[id]/billing/checkout`
- [ ] **AC-7:** На странице checkout отображается список услуг и итоговая стоимость
- [ ] **AC-8:** Цена на момент заказа сохраняется в `billing_order_items`
- [ ] **AC-9:** Можно отменить заказ и вернуться к выбору
- [ ] **AC-10:** Можно перейти к оплате (кнопка "Оплатить")

---

## Следующие шаги

**Следующая итерация:** [3. Интеграция платежной системы →](iteration-03-payment-integration.md)

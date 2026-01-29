# 3. Архитектура: Самостоятельная покупка платных услуг для клиник

[← Назад к оглавлению](index.md)

---

## 3.1 Стек технологий

### Frontend

- **Nuxt 3** - фреймворк
- **Vue 3** - composition API
- **Element Plus** - UI компоненты
- **Pinia** - state management (для корзины заказа)
- **VueUse** - утилиты

### Backend

- **Nuxt 3 Server API** - API endpoints
- **MySQL** - база данных
- **Платежная система** (один из):
  - Stripe (рекомендуется)
  - PayPal
  - Локальный провайдер

### Инфраструктура

- **Email** - отправка уведомлений
- **Logging** - логирование транзакций

---

## 3.2 API Endpoints

### Публичные endpoints (для администраторов клиник)

#### `GET /api/billing/services/catalog`

Получить каталог услуг с ценами

**Query Parameters:**

- `lang?: string` - язык (ru, en, de, tr, sr, sr-cyrl)

**Response:**

```typescript
{
  services: [
    {
      id: number;
      name: string;
      description: string;
      icon?: string;
      pricing: {
        "1": number;   // цена за 1 месяц
        "3": number;   // цена за 3 месяца
        "6": number;   // цена за 6 месяцев
        "12": number;  // цена за 12 месяцев
      };
    }
  ]
}
```

#### `POST /api/billing/orders/create`

Создать новый заказ

**Body:**

```typescript
{
  clinicId: number;
  items: [
    {
      serviceId: number;
      months: 1 | 3 | 6 | 12;
    }
  ];
}
```

**Response:**

```typescript
{
	orderId: string;
	totalAmount: number;
	currency: string;
}
```

#### `GET /api/billing/orders/[id]`

Получить детали заказа

**Response:**

```typescript
{
  id: string;
  clinicId: number;
  status: "pending_payment" | "processing" | "completed" | "failed" | "cancelled";
  items: [
    {
      serviceId: number;
      serviceName: string;
      months: number;
      price: number;
    }
  ];
  totalAmount: number;
  currency: string;
  createdAt: string;
}
```

#### `POST /api/billing/orders/[id]/payment`

Инициировать оплату заказа

**Response:**

```typescript
{
	paymentUrl: string; // URL платежной формы
	sessionId: string; // ID сессии платежной системы
}
```

#### `GET /api/billing/purchases/my`

Получить покупки администратора клиники (для конкретной клиники)

**Query Parameters:**

- `clinicId: number` - ID клиники
- `filter?: "all" | "active" | "expired"` - фильтр

**Response:**

```typescript
{
  purchases: [
    {
      id: number;
      clinicId: number;
      price: number;
      purchasedAt: string;
      validUntil: string;
      deleted: boolean;
      services: [
        {
          id: number;
          name: string;
        }
      ];
      isActive: boolean;
      isExpired: boolean;
    }
  ];
}
```

### Webhook endpoints

#### `POST /api/billing/webhooks/payment`

Webhook от платежной системы для подтверждения оплаты

**Headers:**

- `X-Signature: string` - подпись платежной системы

**Body:**

```typescript
{
  event: "payment.success" | "payment.failed";
  orderId: string;
  transactionId: string;
  amount: number;
  currency: string;
  metadata: {
    clinicId: number;
    items: [...];
  };
}
```

**Response:**

```typescript
{
	success: true;
}
```

### Админ endpoints (существующие, не изменяются)

- `POST /api/billing/services/list` - список услуг (для админки)
- `POST /api/billing/clinic-purchases/add` - добавить покупку вручную (суперадмин)
- `POST /api/billing/clinic-purchases/delete` - удалить покупку (суперадмин)
- `POST /api/billing/clinic-purchases/restore` - восстановить покупку (суперадмин)

---

## 3.3 Frontend Компоненты

### Страницы (pages)

#### `pages/profile/clinics/[id]/billing.vue`

Главная страница платных услуг

**Секции:**

- Header с названием и кнопкой "Назад"
- Каталог услуг (ServiceCatalog)
- История покупок (PurchaseHistory)

#### `pages/profile/clinics/[id]/billing/checkout.vue`

Страница подтверждения заказа

**Содержит:**

- Список выбранных услуг
- Итоговая стоимость
- Кнопка "Оплатить"

#### `pages/profile/clinics/[id]/billing/success.vue`

Страница успешной оплаты

**Содержит:**

- Сообщение об успехе
- Список активированных услуг
- Кнопка "Вернуться к профилю"

#### `pages/profile/clinics/[id]/billing/error.vue`

Страница ошибки оплаты

**Содержит:**

- Сообщение об ошибке
- Причина ошибки (если известна)
- Кнопка "Попробовать снова"

### Компоненты (components)

#### `components/billing/ServiceCard.vue`

Карточка услуги

**Props:**

```typescript
{
  service: {
    id: number;
    name: string;
    description: string;
    icon?: string;
    pricing: { [key: string]: number };
    isActive: boolean;
    validUntil?: string;
  };
  selected: boolean;
  selectedMonths?: 1 | 3 | 6 | 12;
}
```

**Events:**

```typescript
{
  "update:selected": boolean;
  "update:selectedMonths": number;
}
```

#### `components/billing/ServiceCatalog.vue`

Каталог всех услуг

**Props:**

```typescript
{
	clinicId: number;
}
```

**Events:**

```typescript
{
  "checkout": {
    items: Array<{ serviceId: number; months: number }>;
  };
}
```

#### `components/billing/PurchaseHistory.vue`

История покупок клиники

**Props:**

```typescript
{
	clinicId: number;
}
```

**Внутреннее состояние:**

- filter: "all" | "active" | "expired"
- purchases: Array<Purchase>

#### `components/billing/OrderSummary.vue`

Итоговая информация о заказе

**Props:**

```typescript
{
	items: Array<{
		serviceName: string;
		months: number;
		price: number;
	}>;
	totalAmount: number;
	currency: string;
}
```

#### `components/billing/PaymentProcessor.vue`

Обработчик платежа (редирект на платежную форму)

**Props:**

```typescript
{
	orderId: string;
}
```

**Lifecycle:**

1. При mount вызывает `POST /api/billing/orders/[id]/payment`
2. Получает `paymentUrl`
3. Редиректит на `paymentUrl`

---

## 3.4 База данных

### Существующие таблицы (используются, не изменяются)

#### `billing_paid_services`

```sql
CREATE TABLE billing_paid_services (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Данные:**

- id: 1, name: "DOFOLLOW"
- id: 2, name: "HIGHLIGHT"
- id: 3, name: "APPROVED"

#### `billing_clinic_service_purchases`

```sql
CREATE TABLE billing_clinic_service_purchases (
  id INT PRIMARY KEY AUTO_INCREMENT,
  clinic_id INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  purchased_at DATETIME NOT NULL,
  valid_until DATETIME NOT NULL,
  deleted BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (clinic_id) REFERENCES clinics(id)
);
```

#### `billing_clinic_service_purchase_items`

```sql
CREATE TABLE billing_clinic_service_purchase_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  purchase_id INT NOT NULL,
  service_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (purchase_id) REFERENCES billing_clinic_service_purchases(id),
  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id)
);
```

### Новые таблицы

#### `billing_orders`

Заказы на покупку услуг (до оплаты)

```sql
CREATE TABLE billing_orders (
  id VARCHAR(36) PRIMARY KEY,  -- UUID
  clinic_id INT NOT NULL,
  status ENUM('pending_payment', 'processing', 'completed', 'failed', 'cancelled') DEFAULT 'pending_payment',
  total_amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (clinic_id) REFERENCES clinics(id),
  INDEX idx_clinic_status (clinic_id, status)
);
```

#### `billing_order_items`

Элементы заказа

```sql
CREATE TABLE billing_order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  service_id INT NOT NULL,
  months INT NOT NULL,  -- 1, 3, 6, 12
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES billing_orders(id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id)
);
```

#### `billing_payment_transactions`

Транзакции платежной системы

```sql
CREATE TABLE billing_payment_transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id VARCHAR(36) NOT NULL,
  transaction_id VARCHAR(255) NOT NULL,  -- ID от платежной системы
  payment_provider VARCHAR(50) NOT NULL,  -- stripe, paypal, etc
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  status ENUM('pending', 'success', 'failed', 'refunded') DEFAULT 'pending',
  payment_url TEXT,  -- URL платежной формы
  session_id VARCHAR(255),  -- ID сессии платежной системы
  metadata JSON,  -- дополнительные данные
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES billing_orders(id),
  INDEX idx_transaction (transaction_id),
  INDEX idx_order (order_id)
);
```

#### `billing_service_prices`

Цены на услуги (для гибкости)

```sql
CREATE TABLE billing_service_prices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  service_id INT NOT NULL,
  months INT NOT NULL,  -- 1, 3, 6, 12
  price DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'EUR',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id),
  UNIQUE KEY unique_service_months (service_id, months, active)
);
```

**Пример данных:**

```sql
INSERT INTO billing_service_prices (service_id, months, price) VALUES
  (1, 1, 10.00),   -- DOFOLLOW: 10 EUR / месяц
  (1, 3, 27.00),   -- DOFOLLOW: 27 EUR / 3 месяца (скидка 10%)
  (1, 6, 48.00),   -- DOFOLLOW: 48 EUR / 6 месяцев (скидка 20%)
  (1, 12, 84.00),  -- DOFOLLOW: 84 EUR / 12 месяцев (скидка 30%)
  (2, 1, 20.00),   -- HIGHLIGHT: 20 EUR / месяц
  (2, 3, 54.00),   -- HIGHLIGHT: 54 EUR / 3 месяца
  (2, 6, 96.00),   -- HIGHLIGHT: 96 EUR / 6 месяцев
  (2, 12, 168.00), -- HIGHLIGHT: 168 EUR / 12 месяцев
  (3, 1, 15.00),   -- APPROVED: 15 EUR / месяц
  (3, 3, 40.50),   -- APPROVED: 40.50 EUR / 3 месяца
  (3, 6, 72.00),   -- APPROVED: 72 EUR / 6 месяцев
  (3, 12, 126.00); -- APPROVED: 126 EUR / 12 месяцев
```

---

## 3.5 Диаграммы

### Процесс покупки (sequence diagram)

```
Администратор    Frontend       Backend         PaymentSystem    Webhook
     |               |              |                  |              |
     |-- Открыть --→|              |                  |              |
     |   /billing    |              |                  |              |
     |               |              |                  |              |
     |               |--GET catalog→|                  |              |
     |               |←-services----|                  |              |
     |               |              |                  |              |
     |-- Выбрать --→|              |                  |              |
     |   услуги      |              |                  |              |
     |               |              |                  |              |
     |-- Купить ---→|              |                  |              |
     |               |--POST create→|                  |              |
     |               |←--orderId----|                  |              |
     |               |              |                  |              |
     |               |--Редирект--→|                  |              |
     |               |   /checkout  |                  |              |
     |               |              |                  |              |
     |-- Оплатить -→|              |                  |              |
     |               |--POST payment→|                 |              |
     |               |←-paymentUrl--|                  |              |
     |               |              |                  |              |
     |               |--Редирект-------------→|        |              |
     |               |   на платежную форму    |        |              |
     |               |              |                  |              |
     |-- Оплата -------------------→|                 |              |
     |               |              |                  |              |
     |               |              |←--webhook-----------------→|    |
     |               |              |  payment.success |              |
     |               |              |                  |              |
     |               |              |--Активация услуг→|              |
     |               |              |                  |              |
     |               |              |--Send email---→|              |
     |               |              |                  |              |
     |←-Редирект----←----------------←-success URL----|              |
     |   на /success |              |                  |              |
```

### Архитектура компонентов

```
pages/profile/clinics/[id]/billing.vue
├── BillingHeader
├── ServiceCatalog
│   ├── ServiceCard (для каждой услуги)
│   │   ├── ServiceIcon
│   │   ├── ServiceInfo
│   │   ├── PricingOptions
│   │   └── SelectButton
│   └── CheckoutButton
└── PurchaseHistory
    ├── FilterTabs
    └── PurchaseCard (для каждой покупки)
        ├── PurchaseInfo
        ├── ServiceList
        └── StatusBadge
```

---

## 3.6 State Management (Pinia Store)

### `stores/billing.ts`

```typescript
export const useBillingStore = defineStore('billing', {
	state: () => ({
		services: [] as BillingService[],
		selectedItems: [] as { serviceId: number; months: number }[],
		currentOrder: null as Order | null,
		purchases: [] as Purchase[],
	}),

	getters: {
		totalAmount(): number {
			return this.selectedItems.reduce((sum, item) => {
				const service = this.services.find((s) => s.id === item.serviceId);
				return sum + (service?.pricing[item.months] || 0);
			}, 0);
		},

		activePurchases(): Purchase[] {
			return this.purchases.filter((p) => p.isActive && !p.deleted);
		},

		expiredPurchases(): Purchase[] {
			return this.purchases.filter((p) => p.isExpired || p.deleted);
		},
	},

	actions: {
		async loadServices(lang?: string) {
			const data = await $fetch('/api/billing/services/catalog', {
				query: { lang },
			});
			this.services = data.services;
		},

		async loadPurchases(clinicId: number, filter?: string) {
			const data = await $fetch('/api/billing/purchases/my', {
				query: { clinicId, filter },
			});
			this.purchases = data.purchases;
		},

		async createOrder(clinicId: number) {
			const data = await $fetch('/api/billing/orders/create', {
				method: 'POST',
				body: {
					clinicId,
					items: this.selectedItems,
				},
			});
			this.currentOrder = data;
			return data.orderId;
		},

		async initiatePayment(orderId: string) {
			const data = await $fetch(`/api/billing/orders/${orderId}/payment`, {
				method: 'POST',
			});
			return data.paymentUrl;
		},
	},
});
```

---

## 3.7 Интеграция с платежной системой (Stripe пример)

### Создание платежной сессии

```typescript
// server/api/billing/orders/[id]/payment.post.ts
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export default defineEventHandler(async (event) => {
	const orderId = getRouterParam(event, 'id');

	// Получить заказ из БД
	const order = await getOrderById(orderId);

	// Создать Stripe checkout session
	const session = await stripe.checkout.sessions.create({
		payment_method_types: ['card'],
		line_items: order.items.map((item) => ({
			price_data: {
				currency: 'eur',
				product_data: {
					name: item.serviceName,
					description: `${item.months} ${
						item.months === 1 ? 'месяц' : 'месяцев'
					}`,
				},
				unit_amount: item.price * 100, // в центах
			},
			quantity: 1,
		})),
		mode: 'payment',
		success_url: `${process.env.BASE_URL}/profile/clinics/${order.clinicId}/billing/success?session_id={CHECKOUT_SESSION_ID}`,
		cancel_url: `${process.env.BASE_URL}/profile/clinics/${order.clinicId}/billing/error`,
		metadata: {
			orderId: order.id,
			clinicId: order.clinicId,
		},
	});

	// Сохранить session_id в БД
	await savePaymentTransaction({
		orderId: order.id,
		sessionId: session.id,
		paymentUrl: session.url,
	});

	return {
		paymentUrl: session.url,
		sessionId: session.id,
	};
});
```

### Обработка webhook

```typescript
// server/api/billing/webhooks/payment.post.ts
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export default defineEventHandler(async (event) => {
	const sig = getHeader(event, 'stripe-signature');
	const body = await readRawBody(event);

	let stripeEvent: Stripe.Event;

	try {
		stripeEvent = stripe.webhooks.constructEvent(
			body!,
			sig!,
			process.env.STRIPE_WEBHOOK_SECRET!,
		);
	} catch (err) {
		console.error('Webhook signature verification failed:', err);
		throw createError({ statusCode: 400 });
	}

	if (stripeEvent.type === 'checkout.session.completed') {
		const session = stripeEvent.data.object as Stripe.Checkout.Session;
		const orderId = session.metadata?.orderId;

		if (orderId) {
			// Активировать услуги
			await activateServices(orderId);

			// Отправить email
			await sendPurchaseConfirmationEmail(orderId);
		}
	}

	return { success: true };
});
```

---

**Следующая секция:** [4. База данных →](04-database.md)

# Итерация 1: Страница платных услуг в профиле клиники

[← К списку итераций](README.md) | [Следующая →](iteration-02-order-creation.md)

---

## Статус: ✅ Done (2026-06-12, детали и отступления — в ../PROGRESS.md)

---

## Цель

Создать интерфейс для просмотра доступных платных услуг и истории покупок клиники. Администратор клиники должен видеть кнопку перехода в раздел платных услуг из профиля клиники.

---

## Зависимости

- **auth PRD** - базовая авторизация (✅ требуется)
- **clinic-profile PRD** - профиль клиники, Итерация 1+ (✅ требуется)
- **permissions PRD** - роль `clinic_admin` (⏳ требуется)

---

## Задачи

### 1. Миграции базы данных

**Файл:** `server/database/migrations/001_create_billing_service_prices.sql`

Создать таблицу для хранения цен на услуги:

```sql
CREATE TABLE IF NOT EXISTS billing_service_prices (
  id INT PRIMARY KEY AUTO_INCREMENT,
  service_id INT NOT NULL,
  months INT NOT NULL COMMENT 'Период: 1, 3, 6, 12 месяцев',
  price DECIMAL(10,2) NOT NULL COMMENT 'Цена в EUR',
  currency VARCHAR(3) DEFAULT 'EUR',
  active BOOLEAN DEFAULT TRUE COMMENT 'Активная цена',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (service_id) REFERENCES billing_paid_services(id),
  UNIQUE KEY unique_service_months (service_id, months, active),
  INDEX idx_service_active (service_id, active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Добавить начальные цены
INSERT INTO billing_service_prices (service_id, months, price, currency) VALUES
  -- DOFOLLOW (id: 1)
  (1, 1, 10.00, 'EUR'),
  (1, 3, 27.00, 'EUR'),
  (1, 6, 48.00, 'EUR'),
  (1, 12, 84.00, 'EUR'),

  -- HIGHLIGHT (id: 2)
  (2, 1, 20.00, 'EUR'),
  (2, 3, 54.00, 'EUR'),
  (2, 6, 96.00, 'EUR'),
  (2, 12, 168.00, 'EUR'),

  -- APPROVED (id: 3)
  (3, 1, 15.00, 'EUR'),
  (3, 3, 40.50, 'EUR'),
  (3, 6, 72.00, 'EUR'),
  (3, 12, 126.00, 'EUR');
```

---

### 2. API Endpoint: Каталог услуг

**Файл:** `server/api/billing/services/catalog.get.ts`

```typescript
import { getConnection } from '~/server/common/db-mysql';

interface ServicePrice {
	id: number;
	name: string;
	description: string;
	pricing: {
		[key: string]: number;
	};
}

export default defineEventHandler(
	async (event): Promise<{ services: ServicePrice[] }> => {
		try {
			const connection = await getConnection();

			// Получить услуги с ценами
			const [rows]: any = await connection.execute(`
      SELECT 
        s.id,
        s.name,
        s.description,
        p.months,
        p.price
      FROM billing_paid_services s
      LEFT JOIN billing_service_prices p 
        ON s.id = p.service_id 
        AND p.active = TRUE
      ORDER BY s.id, p.months
    `);

			await connection.end();

			// Группируем по услугам
			const servicesMap = new Map<number, ServicePrice>();

			for (const row of rows) {
				if (!servicesMap.has(row.id)) {
					servicesMap.set(row.id, {
						id: row.id,
						name: row.name,
						description: row.description || '',
						pricing: {},
					});
				}

				if (row.months && row.price) {
					servicesMap.get(row.id)!.pricing[row.months] = row.price;
				}
			}

			return {
				services: Array.from(servicesMap.values()),
			};
		} catch (error) {
			console.error('API Error - billing services catalog:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch services catalog',
			});
		}
	},
);
```

---

### 3. API Endpoint: Мои покупки

**Файл:** `server/api/billing/purchases/my.get.ts`

```typescript
import { getConnection } from '~/server/common/db-mysql';
import { requireAuth } from '~/server/common/auth';
import { validateNonNegativeInteger } from '~/common/validation';

interface Purchase {
	id: number;
	clinicId: number;
	price: number;
	purchasedAt: string;
	validUntil: string;
	deleted: boolean;
	services: Array<{
		id: number;
		name: string;
	}>;
	isActive: boolean;
	isExpired: boolean;
}

export default defineEventHandler(
	async (event): Promise<{ purchases: Purchase[] }> => {
		try {
			requireAuth(event);

			const query = getQuery(event);
			const clinicId = Number(query.clinicId);
			const filter = (query.filter as string) || 'all';

			if (!validateNonNegativeInteger(clinicId)) {
				throw createError({
					statusCode: 400,
					statusMessage: 'Invalid clinic ID',
				});
			}

			// TODO: Проверить, что пользователь - администратор этой клиники
			// await requireClinicAdmin(event, clinicId);

			const connection = await getConnection();

			const [rows]: any = await connection.execute(
				`
      SELECT 
        p.id,
        p.clinic_id as clinicId,
        p.price,
        p.purchased_at as purchasedAt,
        p.valid_until as validUntil,
        p.deleted,
        GROUP_CONCAT(s.id) as serviceIds,
        GROUP_CONCAT(s.name) as serviceNames,
        CASE 
          WHEN p.valid_until > NOW() AND p.deleted = FALSE THEN 1 
          ELSE 0 
        END as isActive,
        CASE 
          WHEN p.valid_until <= NOW() THEN 1 
          ELSE 0 
        END as isExpired
      FROM billing_clinic_service_purchases p
      LEFT JOIN billing_clinic_service_purchase_items i 
        ON p.id = i.purchase_id
      LEFT JOIN billing_paid_services s 
        ON i.service_id = s.id
      WHERE p.clinic_id = ?
      GROUP BY p.id
      ORDER BY p.purchased_at DESC
    `,
				[clinicId],
			);

			await connection.end();

			let purchases = rows.map((row: any) => ({
				id: row.id,
				clinicId: row.clinicId,
				price: row.price,
				purchasedAt: row.purchasedAt,
				validUntil: row.validUntil,
				deleted: Boolean(row.deleted),
				services: row.serviceIds
					? row.serviceIds.split(',').map((id: string, idx: number) => ({
							id: Number(id),
							name: row.serviceNames.split(',')[idx],
					  }))
					: [],
				isActive: Boolean(row.isActive),
				isExpired: Boolean(row.isExpired),
			}));

			// Фильтрация
			if (filter === 'active') {
				purchases = purchases.filter((p: Purchase) => p.isActive);
			} else if (filter === 'expired') {
				purchases = purchases.filter((p: Purchase) => p.isExpired || p.deleted);
			}

			return { purchases };
		} catch (error) {
			console.error('API Error - my purchases:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch purchases',
			});
		}
	},
);
```

---

### 4. Страница платных услуг

**Файл:** `pages/profile/clinics/[id]/billing.vue`

```vue
<script setup lang="ts">
const route = useRoute();
const clinicId = Number(route.params.id);

// Загрузка услуг
const { data: servicesData } = await useFetch('/api/billing/services/catalog');

// Загрузка покупок клиники
const filterPurchases = ref<'all' | 'active' | 'expired'>('all');
const { data: purchasesData, refresh: refreshPurchases } = await useFetch(
	'/api/billing/purchases/my',
	{
		query: {
			clinicId,
			filter: filterPurchases,
		},
	},
);

const services = computed(() => servicesData.value?.services || []);
const purchases = computed(() => purchasesData.value?.purchases || []);

// Проверка активности услуги для клиники
const isServiceActive = (serviceId: number) => {
	return purchases.value.some(
		(p) =>
			p.isActive && !p.deleted && p.services.some((s) => s.id === serviceId),
	);
};

// Найти активную покупку для услуги
const getActivePurchase = (serviceId: number) => {
	return purchases.value.find(
		(p) =>
			p.isActive && !p.deleted && p.services.some((s) => s.id === serviceId),
	);
};
</script>

<template>
	<div class="billing-page">
		<div class="page-header">
			<h1>{{ $t('billing.title') }}</h1>
			<p class="subtitle">{{ $t('billing.subtitle') }}</p>
		</div>

		<!-- Каталог услуг -->
		<div class="services-section">
			<h2>{{ $t('billing.availableServices') }}</h2>

			<div class="services-grid">
				<BillingServiceCard
					v-for="service in services"
					:key="service.id"
					:service="service"
					:is-active="isServiceActive(service.id)"
					:active-until="getActivePurchase(service.id)?.validUntil"
				/>
			</div>
		</div>

		<!-- История покупок -->
		<div class="purchases-section">
			<div class="section-header">
				<h2>{{ $t('billing.purchaseHistory') }}</h2>

				<el-radio-group v-model="filterPurchases" @change="refreshPurchases">
					<el-radio-button label="all">
						{{ $t('billing.filter.all') }}
					</el-radio-button>
					<el-radio-button label="active">
						{{ $t('billing.filter.active') }}
					</el-radio-button>
					<el-radio-button label="expired">
						{{ $t('billing.filter.expired') }}
					</el-radio-button>
				</el-radio-group>
			</div>

			<div v-if="purchases.length === 0" class="empty-state">
				<p>{{ $t('billing.noPurchases') }}</p>
			</div>

			<BillingPurchaseHistory v-else :purchases="purchases" />
		</div>
	</div>
</template>

<style scoped>
.billing-page {
	max-width: 1200px;
	margin: 0 auto;
	padding: 24px;
}

.page-header {
	margin-bottom: 32px;
}

.page-header h1 {
	font-size: 32px;
	font-weight: 600;
	margin-bottom: 8px;
}

.subtitle {
	font-size: 16px;
	color: var(--el-text-color-secondary);
}

.services-section {
	margin-bottom: 48px;
}

.services-section h2 {
	font-size: 24px;
	font-weight: 600;
	margin-bottom: 24px;
}

.services-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 24px;
}

.purchases-section {
	margin-top: 48px;
}

.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
}

.section-header h2 {
	font-size: 24px;
	font-weight: 600;
}

.empty-state {
	text-align: center;
	padding: 48px 24px;
	color: var(--el-text-color-secondary);
}
</style>
```

---

### 5. Компонент: Карточка услуги

**Файл:** `components/billing/ServiceCard.vue`

```vue
<script setup lang="ts">
interface ServicePrice {
	id: number;
	name: string;
	description: string;
	pricing: {
		[key: string]: number;
	};
}

interface Props {
	service: ServicePrice;
	isActive: boolean;
	activeUntil?: string;
}

const props = defineProps<Props>();

const formatPrice = (price: number) => {
	return new Intl.NumberFormat('en-US', {
		style: 'currency',
		currency: 'EUR',
	}).format(price);
};

const formatDate = (dateString: string) => {
	return new Date(dateString).toLocaleDateString('ru-RU');
};

const getServiceIcon = (name: string) => {
	switch (name) {
		case 'DOFOLLOW':
			return 'Link';
		case 'HIGHLIGHT':
			return 'Star';
		case 'APPROVED':
			return 'CircleCheck';
		default:
			return 'Service';
	}
};
</script>

<template>
	<el-card class="service-card" :class="{ active: isActive }">
		<div class="card-header">
			<el-icon :size="32" class="service-icon">
				<component :is="getServiceIcon(service.name)" />
			</el-icon>

			<el-tag v-if="isActive" type="success" size="small">
				{{ $t('billing.active') }}
			</el-tag>
		</div>

		<h3>{{ $t(`billing.services.${service.name.toLowerCase()}.name`) }}</h3>
		<p class="description">
			{{ $t(`billing.services.${service.name.toLowerCase()}.description`) }}
		</p>

		<div v-if="isActive && activeUntil" class="active-info">
			<el-icon><Clock /></el-icon>
			<span>{{
				$t('billing.activeUntil', { date: formatDate(activeUntil) })
			}}</span>
		</div>

		<div class="pricing">
			<div class="price-title">{{ $t('billing.pricing') }}</div>
			<div class="price-list">
				<div
					v-for="(price, months) in service.pricing"
					:key="months"
					class="price-item"
				>
					<span class="months">{{ months }} {{ $t('billing.months') }}</span>
					<span class="price">{{ formatPrice(price) }}</span>
				</div>
			</div>
		</div>
	</el-card>
</template>

<style scoped>
.service-card {
	transition: all 0.3s;
}

.service-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.service-card.active {
	border-color: var(--el-color-success);
}

.card-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 16px;
}

.service-icon {
	color: var(--el-color-primary);
}

h3 {
	font-size: 20px;
	font-weight: 600;
	margin-bottom: 8px;
}

.description {
	font-size: 14px;
	color: var(--el-text-color-secondary);
	margin-bottom: 16px;
	line-height: 1.6;
}

.active-info {
	display: flex;
	align-items: center;
	gap: 8px;
	padding: 8px 12px;
	background: var(--el-color-success-light-9);
	border-radius: 4px;
	margin-bottom: 16px;
	font-size: 14px;
	color: var(--el-color-success);
}

.pricing {
	border-top: 1px solid var(--el-border-color);
	padding-top: 16px;
}

.price-title {
	font-size: 14px;
	font-weight: 600;
	margin-bottom: 12px;
}

.price-list {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.price-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: 14px;
}

.months {
	color: var(--el-text-color-secondary);
}

.price {
	font-weight: 600;
	color: var(--el-color-primary);
}
</style>
```

---

### 6. Компонент: История покупок

**Файл:** `components/billing/PurchaseHistory.vue`

```vue
<script setup lang="ts">
interface Purchase {
	id: number;
	clinicId: number;
	price: number;
	purchasedAt: string;
	validUntil: string;
	deleted: boolean;
	services: Array<{
		id: number;
		name: string;
	}>;
	isActive: boolean;
	isExpired: boolean;
}

interface Props {
	purchases: Purchase[];
}

const props = defineProps<Props>();

const formatPrice = (price: number) => {
	return new Intl.NumberFormat('en-US', {
		style: 'currency',
		currency: 'EUR',
	}).format(price);
};

const formatDate = (dateString: string) => {
	return new Date(dateString).toLocaleDateString('ru-RU');
};

const getStatusType = (purchase: Purchase) => {
	if (purchase.deleted) return 'info';
	if (purchase.isActive) return 'success';
	if (purchase.isExpired) return 'warning';
	return 'info';
};

const getStatusText = (purchase: Purchase) => {
	if (purchase.deleted) return 'billing.status.deleted';
	if (purchase.isActive) return 'billing.status.active';
	if (purchase.isExpired) return 'billing.status.expired';
	return 'billing.status.unknown';
};
</script>

<template>
	<div class="purchase-history">
		<el-card
			v-for="purchase in purchases"
			:key="purchase.id"
			class="purchase-card"
			:class="{ expired: purchase.isExpired || purchase.deleted }"
		>
			<div class="purchase-header">
				<div class="purchase-date">
					<el-icon><Calendar /></el-icon>
					<span>{{ formatDate(purchase.purchasedAt) }}</span>
				</div>

				<el-tag :type="getStatusType(purchase)" size="small">
					{{ $t(getStatusText(purchase)) }}
				</el-tag>
			</div>

			<div class="purchase-services">
				<div class="services-label">{{ $t('billing.services.label') }}:</div>
				<div class="services-list">
					<el-tag
						v-for="service in purchase.services"
						:key="service.id"
						size="small"
					>
						{{ $t(`billing.services.${service.name.toLowerCase()}.name`) }}
					</el-tag>
				</div>
			</div>

			<div class="purchase-footer">
				<div class="valid-period">
					<el-icon><Clock /></el-icon>
					<span>
						{{
							$t('billing.validUntil', {
								date: formatDate(purchase.validUntil),
							})
						}}
					</span>
				</div>

				<div class="purchase-price">
					{{ formatPrice(purchase.price) }}
				</div>
			</div>
		</el-card>
	</div>
</template>

<style scoped>
.purchase-history {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.purchase-card {
	transition: all 0.2s;
}

.purchase-card.expired {
	opacity: 0.7;
}

.purchase-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
}

.purchase-date {
	display: flex;
	align-items: center;
	gap: 8px;
	font-size: 14px;
	font-weight: 600;
}

.purchase-services {
	margin-bottom: 16px;
}

.services-label {
	font-size: 14px;
	color: var(--el-text-color-secondary);
	margin-bottom: 8px;
}

.services-list {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.purchase-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding-top: 16px;
	border-top: 1px solid var(--el-border-color);
}

.valid-period {
	display: flex;
	align-items: center;
	gap: 8px;
	font-size: 14px;
	color: var(--el-text-color-secondary);
}

.purchase-price {
	font-size: 18px;
	font-weight: 600;
	color: var(--el-color-primary);
}
</style>
```

---

### 7. Добавить кнопку в профиль клиники

**Файл:** `pages/profile/clinics/[id]/index.vue` (или компонент навигации профиля)

Добавить кнопку/ссылку для перехода на страницу платных услуг:

```vue
<template>
	<!-- В меню профиля клиники -->
	<el-menu>
		<!-- ...другие пункты меню... -->

		<el-menu-item
			v-if="isClinicAdmin"
			:route="{ path: `/profile/clinics/${clinicId}/billing` }"
		>
			<el-icon><CreditCard /></el-icon>
			<span>{{ $t('menu.billing') }}</span>
		</el-menu-item>
	</el-menu>
</template>
```

---

### 8. Локализация

**Файл:** `locales/ru.json`

Добавить переводы:

```json
{
	"billing": {
		"title": "Платные услуги",
		"subtitle": "Улучшите видимость вашей клиники с платными услугами",
		"availableServices": "Доступные услуги",
		"purchaseHistory": "История покупок",
		"active": "Активно",
		"activeUntil": "Активно до {date}",
		"pricing": "Цены",
		"months": "мес.",
		"noPurchases": "У вас пока нет покупок",
		"filter": {
			"all": "Все",
			"active": "Активные",
			"expired": "Истекшие"
		},
		"status": {
			"active": "Активно",
			"expired": "Истекло",
			"deleted": "Удалено",
			"unknown": "Неизвестно"
		},
		"services": {
			"dofollow": {
				"name": "Dofollow ссылки",
				"description": "Ссылки с вашего профиля будут dofollow, что улучшит SEO вашего сайта"
			},
			"highlight": {
				"name": "Выделение в списках",
				"description": "Ваша клиника будет выделяться в результатах поиска и списках"
			},
			"approved": {
				"name": "Верификация",
				"description": "Получите бейдж верифицированной клиники и повысьте доверие пользователей"
			},
			"label": "Услуги"
		},
		"validUntil": "Действует до {date}"
	},
	"menu": {
		"billing": "Платные услуги"
	}
}
```

---

## Критерии приемки (Acceptance Criteria)

- [ ] **AC-1:** В профиле клиники отображается кнопка "Платные услуги"
- [ ] **AC-2:** Кнопка доступна только для администраторов клиники (роль `clinic_admin`)
- [ ] **AC-3:** При клике открывается страница `/profile/clinics/[id]/billing`
- [ ] **AC-4:** На странице отображается каталог всех доступных услуг из `billing_paid_services`
- [ ] **AC-5:** Для каждой услуги показаны: название, описание, цены за 1/3/6/12 месяцев
- [ ] **AC-6:** Если услуга активна для клиники, отображается бейдж "Активно до [дата]"
- [ ] **AC-7:** Отображается история покупок клиники с фильтрами (Все/Активные/Истекшие)
- [ ] **AC-8:** Для каждой покупки показаны: дата, список услуг, период, стоимость, статус

---

## Как проверить

### 1. Миграция базы данных

```bash
# Выполнить миграцию
mysql -u root -p docta_me < server/database/migrations/001_create_billing_service_prices.sql

# Проверить данные
mysql -u root -p docta_me -e "SELECT * FROM billing_service_prices;"
```

**Ожидаемый результат:** Таблица создана, 12 записей с ценами добавлены

### 2. API Endpoint: Каталог услуг

```bash
# Запрос к API
curl http://localhost:3000/api/billing/services/catalog
```

**Ожидаемый результат:**

```json
{
  "services": [
    {
      "id": 1,
      "name": "DOFOLLOW",
      "description": "...",
      "pricing": {
        "1": 10.00,
        "3": 27.00,
        "6": 48.00,
        "12": 84.00
      }
    },
    ...
  ]
}
```

### 3. API Endpoint: Мои покупки

```bash
# Запрос к API (требуется авторизация)
curl -H "Cookie: session_token=..." \
  "http://localhost:3000/api/billing/purchases/my?clinicId=1"
```

**Ожидаемый результат:** Список покупок клиники (может быть пустым)

### 4. Страница платных услуг

1. Авторизоваться как администратор клиники
2. Перейти в профиль клиники `/profile/clinics/[id]`
3. Кликнуть "Платные услуги"
4. Проверить, что отображаются:
   - 3 карточки услуг (DOFOLLOW, HIGHLIGHT, APPROVED)
   - Для каждой услуги цены за 4 периода
   - История покупок (если есть)

### 5. Фильтрация покупок

1. На странице `/profile/clinics/[id]/billing`
2. Переключать фильтры: Все / Активные / Истекшие
3. Проверить, что список покупок обновляется

---

## Файловая структура

```
server/
├── database/migrations/
│   └── 001_create_billing_service_prices.sql ✅
└── api/billing/
    ├── services/
    │   └── catalog.get.ts ✅
    └── purchases/
        └── my.get.ts ✅

pages/profile/clinics/[id]/
└── billing.vue ✅

components/billing/
├── ServiceCard.vue ✅
└── PurchaseHistory.vue ✅

locales/
└── ru.json (обновить) ✅
```

---

## Следующие шаги

После завершения этой итерации переходим к **Итерации 2: Выбор и формирование заказа**.

**Следующая итерация:** [2. Выбор и формирование заказа →](iteration-02-order-creation.md)

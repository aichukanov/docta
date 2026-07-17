<script setup lang="ts">
import clinicBillingI18n from '~/i18n/clinic-billing';
import { getRegionalQuery } from '~/common/url-utils';
import {
	formatEurCents,
	type BillingCatalogService,
	type BillingMyPurchase,
	type BillingPeriod,
} from '~/interfaces/billing';

definePageMeta({
	middleware: 'auth',
	layout: 'default',
});

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicBillingI18n.messages,
});

const route = useRoute();
const clinicId = Number(route.params.clinicId);

const { data: catalogData } = await useFetch<{
	services: BillingCatalogService[];
}>('/api/billing/services/catalog', { key: 'billing-catalog' });

// 403/404 здесь означает «не ваша клиника» — отдаём страницу ошибки
const { data: purchasesData, error: purchasesError } = await useFetch<{
	purchases: BillingMyPurchase[];
}>('/api/billing/purchases/my', {
	key: `billing-purchases-${clinicId}`,
	query: { clinicId },
});

if (purchasesError.value) {
	throw createError({
		statusCode: purchasesError.value.statusCode || 403,
		statusMessage: 'Clinic not available',
	});
}

const { data: paymentStatus } = await useFetch<{ enabled: boolean }>(
	'/api/billing/payment-status',
	{ key: 'billing-payment-status' },
);

const services = computed(() => catalogData.value?.services || []);
const purchases = computed(() => purchasesData.value?.purchases || []);
const paymentEnabled = computed(() => paymentStatus.value?.enabled !== false);

// --- Выбор услуг ---

const selection = reactive<
	Record<number, { selected: boolean; months: BillingPeriod }>
>({});

watch(
	services,
	(list) => {
		for (const service of list) {
			if (!selection[service.id]) {
				const firstPeriod = (Object.keys(service.pricing)
					.map(Number)
					.sort((a, b) => a - b)[0] || 1) as BillingPeriod;
				selection[service.id] = { selected: false, months: firstPeriod };
			}
		}
	},
	{ immediate: true },
);

const selectedItems = computed(() =>
	services.value
		.filter((service) => selection[service.id]?.selected)
		.map((service) => ({
			serviceId: service.id,
			months: selection[service.id].months,
			priceCents: service.pricing[selection[service.id].months] || 0,
		})),
);

const totalCents = computed(() =>
	selectedItems.value.reduce((sum, item) => sum + item.priceCents, 0),
);

// --- Активные услуги клиники (для бейджей в карточках) ---

const activePurchaseForService = (serviceId: number) =>
	purchases.value.find(
		(purchase) =>
			purchase.isActive && purchase.serviceIds.includes(serviceId),
	);

// --- Создание заказа ---

const isCreating = ref(false);

async function checkout() {
	if (!selectedItems.value.length) return;

	isCreating.value = true;
	try {
		const result = await $fetch<{ data?: { orderId: string } }>(
			'/api/billing/orders/create',
			{
				method: 'POST',
				body: {
					clinicId,
					items: selectedItems.value.map(({ serviceId, months }) => ({
						serviceId,
						months,
					})),
				},
			},
		);
		const orderId = result.data?.orderId;
		if (!orderId) throw new Error('No order id');

		await navigateTo({
			path: `/profile/clinics/${clinicId}/billing/checkout`,
			query: { orderId, ...getRegionalQuery(locale.value) },
		});
	} catch {
		ElMessage.error(t('OrderCreateError'));
	} finally {
		isCreating.value = false;
	}
}

const breadcrumbs = computed(() => [
	{
		label: t('BreadcrumbProfile'),
		to: { name: 'profile-basic', query: getRegionalQuery(locale.value) },
	},
	{
		label: t('BreadcrumbMyClinics'),
		to: { name: 'profile-clinics', query: getRegionalQuery(locale.value) },
	},
	{ label: t('BreadcrumbBilling') },
]);

useSeoMeta({ title: () => t('BillingTitle'), robots: 'noindex' });
</script>

<template>
	<div class="billing-page">
		<AppBreadcrumbs :items="breadcrumbs" />

		<div class="billing-page__header">
			<h2 class="billing-page__title">{{ t('BillingTitle') }}</h2>
			<p class="billing-page__subtitle">{{ t('BillingSubtitle') }}</p>
		</div>

		<BillingPaymentUnavailableAlert v-if="!paymentEnabled" />

		<!-- Каталог -->
		<section class="billing-page__section">
			<h3 class="billing-page__section-title">{{ t('CatalogTitle') }}</h3>
			<div class="billing-page__grid">
				<BillingServiceCard
					v-for="service in services"
					:key="service.id"
					:service="service"
					:is-active="!!activePurchaseForService(service.id)"
					:active-until="activePurchaseForService(service.id)?.validUntil"
					v-model:selected="selection[service.id].selected"
					v-model:months="selection[service.id].months"
				/>
			</div>

			<div class="billing-page__summary">
				<span class="billing-page__total">
					{{ t('TotalLabel') }}:
					<strong>{{ formatEurCents(totalCents) }}</strong>
				</span>
				<el-button
					type="primary"
					:disabled="!selectedItems.length"
					:loading="isCreating"
					@click="checkout"
				>
					{{ t('BtnCheckout') }}
				</el-button>
			</div>
		</section>

		<!-- История покупок -->
		<section class="billing-page__section">
			<h3 class="billing-page__section-title">{{ t('HistoryTitle') }}</h3>
			<BillingPurchaseHistory :purchases="purchases" />
		</section>
	</div>
</template>

<style scoped>
.billing-page {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.billing-page__header {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xs);
}

.billing-page__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.billing-page__subtitle {
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
	margin: 0;
}

.billing-page__section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.billing-page__section-title {
	font-size: var(--font-size-xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.billing-page__grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	gap: var(--spacing-lg);
}

.billing-page__summary {
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: var(--spacing-xl);
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-lg);
}

.billing-page__total {
	font-size: var(--font-size-lg);
	color: var(--color-text-primary);
}

@media (max-width: 640px) {
	.billing-page__summary {
		flex-direction: column;
		align-items: stretch;
		text-align: center;
	}
}
</style>

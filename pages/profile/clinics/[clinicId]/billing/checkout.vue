<script setup lang="ts">
import clinicBillingI18n from '~/i18n/clinic-billing';
import { getRegionalQuery } from '~/common/url-utils';
import { BillingService } from '~/enums/billing-service';
import {
	formatEurCents,
	type BillingOrderDetails,
} from '~/interfaces/billing';
import { ERROR_CODES } from '~/server/utils/api-codes';

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
const orderId = computed(() => String(route.query.orderId || ''));

const { data: order, error: orderError } = await useFetch<BillingOrderDetails>(
	() => `/api/billing/orders/${orderId.value}`,
	{ key: `billing-order-${orderId.value}` },
);

if (orderError.value || !order.value) {
	throw createError({
		statusCode: orderError.value?.statusCode || 404,
		statusMessage: 'Order not found',
	});
}

const { data: paymentStatus } = await useFetch<{ enabled: boolean }>(
	'/api/billing/payment-status',
	{ key: 'billing-payment-status' },
);
const paymentEnabled = computed(() => paymentStatus.value?.enabled !== false);

const SERVICE_NAME_KEYS: Record<number, string> = {
	[BillingService.DOFOLLOW]: 'ServiceDofollowName',
	[BillingService.HIGHLIGHT]: 'ServiceHighlightName',
	[BillingService.APPROVED]: 'ServiceApprovedName',
};

const serviceName = (id: number) =>
	SERVICE_NAME_KEYS[id] ? t(SERVICE_NAME_KEYS[id]) : `#${id}`;

const billingLink = computed(() => ({
	path: `/profile/clinics/${clinicId}/billing`,
	query: getRegionalQuery(locale.value),
}));

// --- Оплата ---

const isPaying = ref(false);

async function pay() {
	if (!order.value) return;

	isPaying.value = true;
	try {
		const result = await $fetch<{ data?: { paymentUrl: string | null } }>(
			`/api/billing/orders/${order.value.id}/payment`,
			{ method: 'POST' },
		);
		if (result.data?.paymentUrl) {
			// Редирект на Stripe Checkout
			window.location.href = result.data.paymentUrl;
			return;
		}
		ElMessage.error(t('PaymentInitError'));
	} catch (e: any) {
		if (e?.data?.data?.code === ERROR_CODES.PAYMENT_NOT_CONFIGURED) {
			ElMessage.warning(t('PaymentUnavailable'));
		} else {
			ElMessage.error(t('PaymentInitError'));
		}
	} finally {
		isPaying.value = false;
	}
}

// --- Отмена ---

const isCancelling = ref(false);

async function cancelOrder() {
	if (!order.value) return;

	isCancelling.value = true;
	try {
		await $fetch(`/api/billing/orders/${order.value.id}/cancel`, {
			method: 'POST',
		});
		ElMessage.success(t('OrderCancelled'));
		await navigateTo(billingLink.value);
	} catch {
		ElMessage.error(t('OrderCreateError'));
	} finally {
		isCancelling.value = false;
	}
}

const breadcrumbs = computed(() => [
	{
		label: t('BreadcrumbMyClinics'),
		to: { name: 'profile-clinics', query: getRegionalQuery(locale.value) },
	},
	{ label: t('BreadcrumbBilling'), to: billingLink.value },
	{ label: t('CheckoutTitle') },
]);

useSeoMeta({ title: () => t('CheckoutTitle'), robots: 'noindex' });
</script>

<template>
	<div class="checkout-page">
		<AppBreadcrumbs :items="breadcrumbs" />

		<h2 class="checkout-page__title">{{ t('CheckoutTitle') }}</h2>

		<BillingPaymentUnavailableAlert v-if="!paymentEnabled" />

		<section v-if="order" class="checkout-page__card">
			<h3 class="checkout-page__subtitle">{{ t('OrderItemsTitle') }}</h3>

			<div class="checkout-page__items">
				<div
					v-for="item in order.items"
					:key="item.serviceId"
					class="checkout-page__item"
				>
					<span class="checkout-page__item-name">
						{{ serviceName(item.serviceId) }}
					</span>
					<span class="checkout-page__item-period">
						{{ t(`Period${item.months}`) }}
					</span>
					<span class="checkout-page__item-price">
						{{ formatEurCents(item.priceCents) }}
					</span>
				</div>
			</div>

			<div class="checkout-page__total">
				{{ t('TotalLabel') }}:
				<strong>{{ formatEurCents(order.totalAmountCents) }}</strong>
			</div>

			<div class="checkout-page__actions">
				<el-button :loading="isCancelling" @click="cancelOrder">
					{{ t('BtnCancelOrder') }}
				</el-button>
				<el-button
					type="primary"
					:disabled="!paymentEnabled"
					:loading="isPaying"
					@click="pay"
				>
					{{ t('BtnPay') }}
				</el-button>
			</div>
		</section>
	</div>
</template>

<style scoped>
.checkout-page {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.checkout-page__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.checkout-page__card {
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-xl);
	box-shadow: var(--shadow-sm);
	padding: var(--spacing-2xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.checkout-page__subtitle {
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.checkout-page__items {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.checkout-page__item {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-sm) 0;
	border-bottom: 1px solid var(--color-border-secondary);
}

.checkout-page__item-name {
	flex: 1;
	min-width: 0;
	font-weight: var(--font-weight-medium);
	color: var(--color-text-primary);
}

.checkout-page__item-period {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.checkout-page__item-price {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
}

.checkout-page__total {
	font-size: var(--font-size-lg);
	color: var(--color-text-primary);
	text-align: right;
}

.checkout-page__actions {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
}

@media (max-width: 640px) {
	.checkout-page__card {
		padding: var(--spacing-xl) var(--spacing-lg);
	}
}
</style>

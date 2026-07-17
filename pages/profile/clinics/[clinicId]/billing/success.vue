<script setup lang="ts">
import clinicBillingI18n from '~/i18n/clinic-billing';
import { getRegionalQuery } from '~/common/url-utils';
import type { BillingOrderDetails } from '~/interfaces/billing';

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
const orderId = String(route.query.order_id || '');

// Webhook активирует услуги асинхронно — поллим статус заказа.
type ActivationState = 'processing' | 'done' | 'pending';
const state = ref<ActivationState>('processing');

const POLL_INTERVAL_MS = 2000;
const MAX_ATTEMPTS = 10;

onMounted(async () => {
	if (!orderId) {
		state.value = 'pending';
		return;
	}

	for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
		try {
			const order = await $fetch<BillingOrderDetails>(
				`/api/billing/orders/${orderId}`,
			);
			if (order.status === 'completed') {
				state.value = 'done';
				await refreshNuxtData(`billing-purchases-${clinicId}`);
				return;
			}
		} catch {
			break;
		}
		await new Promise((resolve) => setTimeout(resolve, POLL_INTERVAL_MS));
	}

	// Платёж получен, но webhook ещё не доехал — услуги появятся чуть позже
	state.value = 'pending';
});

const billingLink = computed(() => ({
	path: `/profile/clinics/${clinicId}/billing`,
	query: getRegionalQuery(locale.value),
}));

useSeoMeta({ title: () => t('SuccessTitle'), robots: 'noindex' });
</script>

<template>
	<div class="result-page">
		<div class="result-page__icon result-page__icon--success">
			<IconCheck :size="40" />
		</div>
		<h2 class="result-page__title">{{ t('SuccessTitle') }}</h2>
		<p class="result-page__desc">
			<template v-if="state === 'processing'">
				{{ t('SuccessProcessing') }}
			</template>
			<template v-else-if="state === 'done'">{{ t('SuccessDone') }}</template>
			<template v-else>{{ t('SuccessPending') }}</template>
		</p>
		<span
			v-if="state === 'processing'"
			class="result-page__spinner"
			aria-hidden="true"
		/>
		<NuxtLink :to="billingLink">
			<el-button type="primary">{{ t('BtnBackToBilling') }}</el-button>
		</NuxtLink>
	</div>
</template>

<style scoped>
.result-page {
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-xl);
	box-shadow: var(--shadow-sm);
	padding: var(--spacing-3xl) var(--spacing-2xl);
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: var(--spacing-lg);
	text-align: center;
	min-height: 320px;
	justify-content: center;
}

.result-page__icon {
	width: 80px;
	height: 80px;
	border-radius: var(--border-radius-full);
	display: flex;
	align-items: center;
	justify-content: center;
}

.result-page__icon--success {
	background: var(--color-success-bg);
	color: var(--color-primary-green);
}

.result-page__title {
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
}

.result-page__desc {
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);
	margin: 0;
	max-width: 440px;
	line-height: 1.5;
}

.result-page__spinner {
	width: 24px;
	height: 24px;
	border: 3px solid var(--color-border-secondary);
	border-top-color: var(--color-primary);
	border-radius: 50%;
	animation: billing-success-spin 0.8s linear infinite;
}

@keyframes billing-success-spin {
	to {
		transform: rotate(360deg);
	}
}
</style>

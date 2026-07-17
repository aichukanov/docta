<script setup lang="ts">
import clinicBillingI18n from '~/i18n/clinic-billing';
import { getRegionalQuery } from '~/common/url-utils';

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

const billingLink = computed(() => ({
	path: `/profile/clinics/${clinicId}/billing`,
	query: getRegionalQuery(locale.value),
}));

// Заказ остаётся в БД — повторная попытка ведёт обратно на checkout
const retryLink = computed(() => ({
	path: `/profile/clinics/${clinicId}/billing/checkout`,
	query: { orderId, ...getRegionalQuery(locale.value) },
}));

useSeoMeta({ title: () => t('ErrorTitle'), robots: 'noindex' });
</script>

<template>
	<div class="result-page">
		<div class="result-page__icon result-page__icon--error">
			<IconClose :size="36" />
		</div>
		<h2 class="result-page__title">{{ t('ErrorTitle') }}</h2>
		<p class="result-page__desc">{{ t('ErrorDesc') }}</p>
		<div class="result-page__actions">
			<NuxtLink :to="billingLink">
				<el-button>{{ t('BtnBackToBilling') }}</el-button>
			</NuxtLink>
			<NuxtLink v-if="orderId" :to="retryLink">
				<el-button type="primary">{{ t('BtnRetry') }}</el-button>
			</NuxtLink>
		</div>
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

.result-page__icon--error {
	background: var(--color-danger-bg);
	color: var(--color-danger-dark);
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

.result-page__actions {
	display: flex;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
	justify-content: center;
}
</style>

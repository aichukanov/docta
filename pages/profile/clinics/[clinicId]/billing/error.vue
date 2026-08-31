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
	background: var(--kit-color-bg-primary);
	border: 1px solid var(--kit-color-border-secondary);
	border-radius: var(--kit-border-radius-xl);
	box-shadow: var(--kit-shadow-sm);
	padding: var(--kit-spacing-3xl) var(--kit-spacing-2xl);
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: var(--kit-spacing-lg);
	text-align: center;
	min-height: 320px;
	justify-content: center;
}

.result-page__icon {
	width: 80px;
	height: 80px;
	border-radius: var(--kit-border-radius-full);
	display: flex;
	align-items: center;
	justify-content: center;
}

.result-page__icon--error {
	background: var(--kit-color-danger-bg);
	color: var(--kit-color-danger-dark);
}

.result-page__title {
	font-size: var(--kit-font-size-2xl);
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-heading);
	margin: 0;
}

.result-page__desc {
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-secondary);
	margin: 0;
	max-width: 440px;
	line-height: 1.5;
}

.result-page__actions {
	display: flex;
	gap: var(--kit-spacing-sm);
	flex-wrap: wrap;
	justify-content: center;
}
</style>

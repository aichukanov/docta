<script setup lang="ts">
import clinicBillingI18n from '~/i18n/clinic-billing';
import { BillingService } from '~/enums/billing-service';
import type { BillingMyPurchase } from '~/interfaces/billing';

const props = defineProps<{
	purchases: BillingMyPurchase[];
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicBillingI18n.messages,
});

const filter = ref<'all' | 'active' | 'expired'>('all');

const filteredPurchases = computed(() => {
	if (filter.value === 'active') {
		return props.purchases.filter((p) => p.isActive);
	}
	if (filter.value === 'expired') {
		return props.purchases.filter((p) => p.isExpired || p.deleted);
	}
	return props.purchases;
});

const SERVICE_NAME_KEYS: Record<number, string> = {
	[BillingService.DOFOLLOW]: 'ServiceDofollowName',
	[BillingService.HIGHLIGHT]: 'ServiceHighlightName',
	[BillingService.APPROVED]: 'ServiceApprovedName',
};

const serviceName = (id: number) =>
	SERVICE_NAME_KEYS[id] ? t(SERVICE_NAME_KEYS[id]) : `#${id}`;

const formatDate = (value: string) =>
	new Date(value).toLocaleDateString(locale.value);

const statusKey = (purchase: BillingMyPurchase) => {
	if (purchase.deleted) return 'StatusDeleted';
	if (purchase.isActive) return 'StatusActive';
	return 'StatusExpired';
};

const statusType = (purchase: BillingMyPurchase) => {
	if (purchase.deleted) return 'info';
	if (purchase.isActive) return 'success';
	return 'warning';
};
</script>

<template>
	<div class="history">
		<div class="history__filters">
			<el-radio-group v-model="filter">
				<el-radio-button value="all">{{ t('FilterAll') }}</el-radio-button>
				<el-radio-button value="active">{{ t('FilterActive') }}</el-radio-button>
				<el-radio-button value="expired">
					{{ t('FilterExpired') }}
				</el-radio-button>
			</el-radio-group>
		</div>

		<p v-if="!filteredPurchases.length" class="history__empty">
			{{ t('NoPurchases') }}
		</p>

		<div
			v-for="purchase in filteredPurchases"
			:key="purchase.id"
			class="history__item"
			:class="{ 'history__item--inactive': !purchase.isActive }"
		>
			<div class="history__item-header">
				<span class="history__date">
					{{ t('PurchasedOn', { date: formatDate(purchase.purchasedAt) }) }}
				</span>
				<el-tag :type="statusType(purchase)" size="small">
					{{ t(statusKey(purchase)) }}
				</el-tag>
			</div>

			<div class="history__services">
				<el-tag
					v-for="serviceId in purchase.serviceIds"
					:key="serviceId"
					size="small"
					type="info"
					effect="plain"
				>
					{{ serviceName(serviceId) }}
				</el-tag>
			</div>

			<div class="history__item-footer">
				<span class="history__valid">
					{{ t('ValidUntilLabel', { date: formatDate(purchase.validUntil) }) }}
				</span>
				<span class="history__price">€{{ purchase.price.toFixed(2) }}</span>
			</div>
		</div>
	</div>
</template>

<style scoped>
.history {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.history__filters {
	display: flex;
}

.history__empty {
	color: var(--color-text-muted);
	font-size: var(--font-size-md);
	text-align: center;
	padding: var(--spacing-2xl) 0;
	margin: 0;
}

.history__item {
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-lg);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.history__item--inactive {
	opacity: 0.75;
}

.history__item-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
}

.history__date {
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-primary);
}

.history__services {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
}

.history__item-footer {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
	border-top: 1px solid var(--color-border-secondary);
	padding-top: var(--spacing-md);
}

.history__valid {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}

.history__price {
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
}
</style>

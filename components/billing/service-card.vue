<script setup lang="ts">
import { Star, CircleCheck } from '@element-plus/icons-vue';
import clinicBillingI18n from '~/i18n/clinic-billing';
import { BillingService } from '~/enums/billing-service';
import {
	formatEurCents,
	type BillingCatalogService,
	type BillingPeriod,
} from '~/interfaces/billing';

const props = defineProps<{
	service: BillingCatalogService;
	isActive: boolean;
	activeUntil?: string;
	selected: boolean;
	months: BillingPeriod;
}>();

const emit = defineEmits<{
	(e: 'update:selected', value: boolean): void;
	(e: 'update:months', value: BillingPeriod): void;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: clinicBillingI18n.messages,
});

const SERVICE_KEYS: Record<number, { name: string; desc: string }> = {
	[BillingService.HIGHLIGHT]: {
		name: 'ServiceHighlightName',
		desc: 'ServiceHighlightDesc',
	},
	[BillingService.APPROVED]: {
		name: 'ServiceApprovedName',
		desc: 'ServiceApprovedDesc',
	},
};

const serviceIcon = computed(() =>
	props.service.id === BillingService.HIGHLIGHT ? Star : CircleCheck,
);

const nameKey = computed(
	() => SERVICE_KEYS[props.service.id]?.name || 'CatalogTitle',
);
const descKey = computed(() => SERVICE_KEYS[props.service.id]?.desc || '');

const periods = computed(() =>
	(Object.keys(props.service.pricing) as unknown as string[])
		.map(Number)
		.sort((a, b) => a - b),
);

const formattedActiveUntil = computed(() =>
	props.activeUntil
		? new Date(props.activeUntil).toLocaleDateString(locale.value)
		: '',
);

const selectedModel = computed({
	get: () => props.selected,
	set: (value: boolean) => emit('update:selected', value),
});

const monthsModel = computed({
	get: () => props.months,
	set: (value: BillingPeriod) => emit('update:months', value),
});
</script>

<template>
	<section class="service-card" :class="{ 'service-card--selected': selected }">
		<div class="service-card__header">
			<div class="service-card__icon">
				<el-icon :size="22"><component :is="serviceIcon" /></el-icon>
			</div>
			<h3 class="service-card__name">{{ t(nameKey) }}</h3>
		</div>

		<p class="service-card__desc">{{ descKey ? t(descKey) : '' }}</p>

		<div v-if="isActive && formattedActiveUntil" class="service-card__active">
			<IconCheck :size="14" />
			{{ t('ActiveUntil', { date: formattedActiveUntil }) }}
		</div>

		<div class="service-card__pricing">
			<el-radio-group v-model="monthsModel">
				<el-radio
					v-for="period in periods"
					:key="period"
					:value="period"
					class="service-card__price-option"
				>
					<span class="service-card__period">{{ t(`Period${period}`) }}</span>
					<span class="service-card__price">
						{{ formatEurCents(service.pricing[period as BillingPeriod] || 0) }}
					</span>
				</el-radio>
			</el-radio-group>
		</div>

		<el-button
			class="service-card__add"
			:type="selected ? 'primary' : 'default'"
			:plain="selected"
			@click="selectedModel = !selectedModel"
		>
			<IconCheck v-if="selected" :size="14" class="service-card__add-icon" />
			{{ t(selected ? 'BtnAdded' : 'BtnAdd') }}
		</el-button>
	</section>
</template>

<style scoped>
.service-card {
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-secondary);
	border-radius: var(--border-radius-xl);
	box-shadow: var(--shadow-sm);
	padding: var(--spacing-xl);
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
	transition: border-color var(--transition-base);
}

.service-card--selected {
	border-color: var(--color-primary);
}

.service-card__header {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
}

.service-card__icon {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	border-radius: var(--border-radius-lg);
	background: var(--color-primary-bg);
	color: var(--color-primary);
	flex-shrink: 0;
}

.service-card__name {
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	margin: 0;
	flex: 1;
	min-width: 0;
}

.service-card__add {
	width: 100%;
	margin-top: auto;
}

.service-card__add-icon {
	margin-right: 6px;
}

.service-card__desc {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
	margin: 0;
	line-height: 1.5;
}

.service-card__active {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-medium);
	color: var(--color-primary-green);
	background: var(--color-success-bg);
	border: 1px solid var(--color-success-border);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-xs) var(--spacing-md);
	align-self: flex-start;
}

.service-card__pricing {
	border-top: 1px solid var(--color-border-secondary);
	padding-top: var(--spacing-md);
}

.service-card__pricing :deep(.el-radio-group) {
	display: flex;
	flex-direction: column;
	align-items: stretch;
	gap: var(--spacing-xs);
}

.service-card__pricing :deep(.el-radio) {
	margin-right: 0;
	height: auto;
	padding: 4px 0;
}

.service-card__pricing :deep(.el-radio__label) {
	display: inline-flex;
	justify-content: space-between;
	flex: 1;
	width: 100%;
	gap: var(--spacing-md);
}

.service-card__period {
	color: var(--color-text-secondary);
	font-size: var(--font-size-sm);
}

.service-card__price {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
	font-size: var(--font-size-sm);
}
</style>

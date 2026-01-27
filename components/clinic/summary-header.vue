<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import { getLocalizedName } from '~/common/utils';
import type { ClinicData } from '~/interfaces/clinic';
import { BillingService } from '~/enums/billing-service';

const props = withDefaults(
	defineProps<{
		clinic: ClinicData;
		price?: number | null;
		priceMin?: number | null;
		priceMax?: number | null;
		showPrice?: boolean;
	}>(),
	{
		showPrice: true,
	},
);

defineEmits<{
	(e: 'show-on-map'): void;
}>();

const headerI18n = {
	'en': {
		LanguageAssistance: 'The clinic provides assistance in:',
		PriceUnknown: 'Price not specified',
		PriceFrom: 'from {price}',
	},
	'ru': {
		LanguageAssistance:
			'В клинике предоставляется сопровождение на следующих языках:',
		PriceUnknown: 'Цена не указана',
		PriceFrom: 'от {price}',
	},
	'de': {
		LanguageAssistance: 'Die Klinik bietet Unterstützung in:',
		PriceUnknown: 'Preis nicht angegeben',
		PriceFrom: 'ab {price}',
	},
	'tr': {
		LanguageAssistance: 'Klinik aşağıdaki dillerde destek sunar:',
		PriceUnknown: 'Fiyat belirtilmedi',
		PriceFrom: '{price} başlayan',
	},
	'sr': {
		LanguageAssistance: 'Klinika pruža pomoć na sledećim jezicima:',
		PriceUnknown: 'Cena nije navedena',
		PriceFrom: 'od {price}',
	},
	'sr-cyrl': {
		LanguageAssistance: 'Клиника пружа помоћ на следећим језицима:',
		PriceUnknown: 'Цена није наведена',
		PriceFrom: 'од {price}',
	},
};

const { t, n, locale } = useI18n({
	useScope: 'local',
	messages: headerI18n,
});

const localizedName = computed(() =>
	getLocalizedName(props.clinic, locale.value),
);

const hasHighlight = computed(() =>
	props.clinic.features?.includes(BillingService.HIGHLIGHT),
);

const hasPrice = computed(() => props.price != null || props.priceMin != null);

const formattedPrice = computed(() => {
	const formatNumber = (num: number) =>
		n(num, { style: 'currency', currency: 'EUR' });

	// Если есть priceMin - показываем "от X евро"
	if (props.priceMin != null) {
		return t('PriceFrom', { price: formatNumber(props.priceMin) });
	}

	// Если есть price и priceMax - показываем диапазон "X - Y евро"
	if (
		props.price != null &&
		props.priceMax != null &&
		props.priceMax !== props.price
	) {
		return `${formatNumber(props.price)} - ${formatNumber(props.priceMax)}`;
	}

	// Если есть только price - показываем "X евро"
	if (props.price != null) {
		return formatNumber(props.price);
	}

	return null;
});

const clinicLink = computed(() => ({
	name: 'clinics-clinicId',
	params: { clinicId: props.clinic.id },
	query: getRegionalQuery(locale.value),
}));
</script>

<template>
	<header
		class="clinic-header"
		:class="{ 'clinic-header--highlight': hasHighlight }"
	>
		<div class="clinic-info">
			<div class="clinic-name-row">
				<div class="clinic-name-wrapper">
					<NuxtLink
						:to="clinicLink"
						class="clinic-name"
						:class="{ 'clinic-name--highlight': hasHighlight }"
					>
						{{ localizedName }}
					</NuxtLink>
					<ClinicApprovedBadge :clinic="clinic" :small="true" />
				</div>
				<div
					v-if="showPrice"
					class="price-badge"
					:class="{ 'price-badge__unknown': !hasPrice }"
				>
					<template v-if="formattedPrice">{{ formattedPrice }}</template>
					<template v-else>{{ t('PriceUnknown') }}</template>
				</div>
			</div>

			<div class="clinic-address">
				<el-icon class="address-icon"><LocationFilled /></el-icon>
				<ClinicLocationAddress :clinic="clinic" />
			</div>

			<ConsultationLanguages :languageIds="clinic.languageIds">
				{{ t('LanguageAssistance') }}
			</ConsultationLanguages>
		</div>

		<div class="clinic-actions">
			<ClinicShowOnMapButton :clinic="clinic" @click="$emit('show-on-map')" />
			<ClinicRouteButton :clinic="clinic" />
		</div>
	</header>
</template>

<style scoped lang="less">
.clinic-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	gap: var(--spacing-lg);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: var(--color-surface-primary);
}

.clinic-info {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	flex: 1;
	min-width: 0;
}

.clinic-name-row {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	gap: var(--spacing-md);
}

.clinic-name-wrapper {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.clinic-name {
	font-size: var(--font-size-xl);
	font-weight: 600;
	color: var(--color-primary);
	text-decoration: none;
	overflow-wrap: break-word;

	&:hover {
		color: var(--color-primary-dark);
		text-decoration: underline;
	}
}

.clinic-header--highlight {
	background: var(--color-highlight-bg);
}

.price-badge {
	padding: var(--spacing-xs) var(--spacing-md);
	background: var(--color-primary);
	border-radius: var(--border-radius-sm);
	color: white;
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-bold);
	white-space: nowrap;

	&__unknown {
		background: var(--color-surface-secondary);
		color: var(--color-text-muted);
		font-weight: var(--font-weight-normal);
		font-style: italic;
	}
}

.clinic-address {
	display: flex;
	align-items: center;
	gap: var(--spacing-xs);
	font-size: var(--font-size-md);
	color: var(--color-text-secondary);

	.address-icon {
		flex-shrink: 0;
		color: var(--color-text-muted);
	}
}

.clinic-actions {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	min-width: 160px;
}

@media (max-width: 950px) {
	.clinic-header {
		flex-direction: column;
		gap: var(--spacing-md);
	}

	.clinic-actions {
		flex-direction: row;
		flex-wrap: wrap;
		width: 100%;
		min-width: unset;
	}
}

@media (max-width: 600px) {
	.clinic-header {
		padding: var(--spacing-md);
	}
}
</style>

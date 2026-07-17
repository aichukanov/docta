<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { getRegionalQuery } from '~/common/url-utils';
import { REVIEWS_THRESHOLD } from '~/common/constants';
import { getLocalizedName } from '~/common/utils';
import RatingStars from '~/components/rating-stars.vue';
import { BillingService } from '~/enums/billing-service';
import clinicCommonI18n from '~/i18n/clinic-common';
import clinicTypeI18n from '~/i18n/clinic-type';
import locationI18n from '~/i18n/location';
import { combineI18nMessages } from '~/i18n/utils';
import type { ClinicData } from '~/interfaces/clinic';

const props = withDefaults(
	defineProps<{
		clinic: ClinicData;
		price?: number | null;
		priceMin?: number | null;
		priceMax?: number | null;
		showPrice?: boolean;
		// Расстояние до пользователя в км; null/undefined — локация неизвестна
		distance?: number | null;
	}>(),
	{
		showPrice: true,
	},
);

defineEmits<{
	(e: 'show-on-map'): void;
}>();

const { t, n, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([
		clinicCommonI18n,
		clinicTypeI18n,
		locationI18n,
	]),
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

// «500 м» до 1 км, дальше «2,3 км»; число форматируется по локали
const formattedDistance = computed(() => {
	if (props.distance == null) return null;
	if (props.distance < 1) {
		return t('DistanceM', { distance: n(Math.round(props.distance * 1000)) });
	}
	return t('DistanceKm', {
		distance: n(Math.round(props.distance * 10) / 10, {
			maximumFractionDigits: 1,
		}),
	});
});

const clinicTypeNames = computed(() => {
	if (!props.clinic.clinicTypeIds) return [];
	return props.clinic.clinicTypeIds
		.split(',')
		.map(Number)
		.filter(Boolean)
		.map((id) => t(`clinic_type_${id}`));
});

const clinicLink = computed(() => {
	if (!props.clinic.slug) return null;
	return {
		name: 'clinics-clinicSlug',
		params: { clinicSlug: props.clinic.slug },
		query: getRegionalQuery(locale.value),
	};
});

const { trackEvent } = useAnalytics();

const trackClinicLinkClick = () => {
	trackEvent('entity_link_clicked', {
		entity_type: 'clinic',
		entity_id: props.clinic.id,
		entity_slug: props.clinic.slug,
		entity_name: props.clinic.name,
	});
};

// Больше порога — отдельная страница отзывов, иначе якорь на детальной
const reviewsLink = computed(() => {
	if (!props.clinic.slug || !props.clinic.rating?.totalReviews) return null;
	const base = {
		params: { clinicSlug: props.clinic.slug },
		query: getRegionalQuery(locale.value),
	};
	if (props.clinic.rating.totalReviews > REVIEWS_THRESHOLD) {
		return { name: 'clinics-clinicSlug-reviews', ...base };
	}
	return { name: 'clinics-clinicSlug', ...base, hash: '#reviews' };
});
</script>

<template>
	<header
		class="clinic-header"
		:class="{ 'clinic-header--highlight': hasHighlight }"
	>
		<ClinicLogo :logoUrl="clinic.logoUrl" :name="localizedName" :size="64" />
		<div class="clinic-info">
			<div class="clinic-name-row">
				<div class="clinic-name-wrapper">
					<NuxtLink
						v-if="clinicLink"
						:to="clinicLink"
						class="clinic-name"
						:class="{ 'clinic-name--highlight': hasHighlight }"
						@click="trackClinicLinkClick"
					>
						{{ localizedName }}
					</NuxtLink>
					<span v-else class="clinic-name">{{ localizedName }}</span>
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
				<span v-if="formattedDistance" class="clinic-distance">
					· {{ formattedDistance }}
				</span>
			</div>

			<ClinicWorkingStatusBadge :workingHours="clinic.workingHours" />

			<div v-if="clinicTypeNames.length" class="clinic-types">
				<CategoryTag
					v-for="typeName in clinicTypeNames"
					:key="typeName"
					small
					>{{ typeName }}</CategoryTag
				>
			</div>

			<RatingStars
				v-if="clinic.rating && clinic.rating.averageRating"
				:rating="clinic.rating.averageRating"
				:count="clinic.rating.totalReviews"
				:count-link="reviewsLink"
				show-value
			/>

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
	font-size: var(--font-size-lg);
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
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-semibold);
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
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);

	.address-icon {
		flex-shrink: 0;
		color: var(--color-text-muted);
	}

	.clinic-distance {
		flex-shrink: 0;
		color: var(--color-text-muted);
		white-space: nowrap;
	}
}

.clinic-types {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
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

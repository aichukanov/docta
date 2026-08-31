<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import clinicCommonI18n from '~/i18n/clinic-common';

const props = defineProps<{
	id: number;
	slug: string;
	name: string;
	localName?: string;
	price?: number | null;
	priceMin?: number | null;
	priceMax?: number | null;
	isOutdated?: boolean;
	routeName?: string;
	routeParamName?: string;
}>();

const { t, n, locale } = useI18n({
	useScope: 'local',
	messages: clinicCommonI18n.messages,
});

const itemLink = computed(() => {
	if (!props.routeName || !props.routeParamName || !props.slug) {
		return null;
	}
	return {
		name: props.routeName,
		params: { [props.routeParamName]: props.slug },
		query: getRegionalQuery(locale.value),
	};
});

const { trackEvent } = useAnalytics();

const trackItemLinkClick = () => {
	const entityType = getEntityTypeByRouteName(props.routeName);
	if (!entityType) return;
	trackEvent('entity_link_clicked', {
		entity_type: entityType,
		entity_id: props.id,
		entity_slug: props.slug,
		entity_name: props.name,
	});
};

const isPriceUnknown = computed(
	() => props.price == null && props.priceMin == null,
);

const formattedPrice = computed(() => {
	if (isPriceUnknown.value) return null;

	const formatNumber = (num: number) =>
		n(num, { style: 'currency', currency: 'EUR' });

	// Если есть priceMin - показываем "от X евро"
	if (props.priceMin != null) {
		return t('PriceFrom', { price: formatNumber(props.priceMin) });
	}

	// Если есть price и priceMax - показываем диапазон "X - Y евро"
	if (props.priceMax && props.priceMax !== props.price) {
		return `${formatNumber(props.price!)} - ${formatNumber(props.priceMax)}`;
	}

	return formatNumber(props.price!);
});
</script>

<template>
	<div class="item-card">
		<div class="item-info">
			<NuxtLink
				v-if="itemLink"
				:to="itemLink"
				class="item-name item-link"
				@click="trackItemLinkClick"
			>
				{{ name }}
			</NuxtLink>
			<span v-else class="item-name">{{ name }}</span>
			<span v-if="localName" class="item-local-name">{{ localName }}</span>
		</div>
		<div class="item-price" :class="{ 'item-price__unknown': isPriceUnknown }">
			<template v-if="formattedPrice">
				{{ formattedPrice }}
				<template v-if="isOutdated"> {{ t('PriceOutdatedSuffix') }}</template>
				<PriceOutdatedBadge v-if="isOutdated" small inverse />
			</template>
			<template v-else>{{ t('PriceUnknown') }}</template>
		</div>
	</div>
</template>

<style scoped lang="less">
.item-card {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: var(--kit-spacing-sm);
	padding: var(--kit-spacing-md);
	background: var(--kit-color-surface-primary);
	border: 1px solid var(--kit-color-border-light);
	border-radius: var(--kit-border-radius-md);
	transition: border-color var(--kit-transition-fast);

	&:hover {
		border-color: var(--kit-color-border-accent);
	}
}

.item-info {
	display: flex;
	flex-direction: column;
	gap: 2px;
	flex: 1;
}

.item-name {
	font-size: var(--kit-font-size-base);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-text-primary);
	line-height: 1.3;
	overflow-wrap: break-word;

	&.item-link {
		color: var(--kit-color-primary);
		text-decoration: none;

		&:hover {
			color: var(--kit-color-primary-dark);
			text-decoration: underline;
		}
	}
}

.item-local-name {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}

.item-price {
	display: inline-flex;
	align-items: center;
	gap: var(--kit-spacing-xs);
	padding: var(--kit-spacing-xs) var(--kit-spacing-sm);
	background: var(--kit-color-primary);
	border-radius: var(--kit-border-radius-sm);
	color: white;
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-bold);
	white-space: nowrap;

	&__unknown {
		background: var(--kit-color-surface-secondary);
		color: var(--kit-color-text-muted);
		font-weight: var(--kit-font-weight-normal);
		font-style: italic;
	}
}
</style>

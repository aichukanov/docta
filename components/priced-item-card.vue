<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const props = defineProps<{
	id: number;
	name: string;
	localName?: string;
	price?: number | null;
	priceMin?: number | null;
	priceMax?: number | null;
	routeName?: string;
	routeParamName?: string;
}>();

const { t, n, locale } = useI18n({
	messages: {
		'en': { PriceUnknown: 'Price not specified', PriceFrom: 'from {price}' },
		'ru': { PriceUnknown: 'Цена не указана', PriceFrom: 'от {price}' },
		'sr': { PriceUnknown: 'Cena nije navedena', PriceFrom: 'od {price}' },
		'de': { PriceUnknown: 'Preis nicht angegeben', PriceFrom: 'ab {price}' },
		'tr': { PriceUnknown: 'Fiyat belirtilmedi', PriceFrom: '{price} başlayan' },
		'sr-cyrl': { PriceUnknown: 'Цена није наведена', PriceFrom: 'од {price}' },
	},
});

const itemLink = computed(() => {
	if (!props.routeName || !props.routeParamName) {
		return null;
	}
	return {
		name: props.routeName,
		params: { [props.routeParamName]: props.id },
		query: getRegionalQuery(locale.value),
	};
});

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
			<NuxtLink v-if="itemLink" :to="itemLink" class="item-name item-link">
				{{ name }}
			</NuxtLink>
			<span v-else class="item-name">{{ name }}</span>
			<span v-if="localName" class="item-local-name">{{ localName }}</span>
		</div>
		<div class="item-price" :class="{ 'item-price__unknown': isPriceUnknown }">
			<template v-if="formattedPrice">{{ formattedPrice }}</template>
			<template v-else>{{ t('PriceUnknown') }}</template>
		</div>
	</div>
</template>

<style scoped lang="less">
.item-card {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	transition: border-color var(--transition-fast);

	&:hover {
		border-color: var(--color-border-accent);
	}
}

.item-info {
	display: flex;
	flex-direction: column;
	gap: 2px;
	flex: 1;
}

.item-name {
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-medium);
	color: var(--color-text-primary);
	line-height: 1.3;
	overflow-wrap: break-word;

	&.item-link {
		color: var(--color-primary);
		text-decoration: none;

		&:hover {
			color: var(--color-primary-dark);
			text-decoration: underline;
		}
	}
}

.item-local-name {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}

.item-price {
	padding: var(--spacing-xs) var(--spacing-sm);
	background: var(--color-primary);
	border-radius: var(--border-radius-sm);
	color: white;
	font-size: var(--font-size-sm);
	font-weight: var(--font-weight-bold);
	white-space: nowrap;

	&__unknown {
		background: var(--color-surface-secondary);
		color: var(--color-text-muted);
		font-weight: var(--font-weight-normal);
		font-style: italic;
	}
}
</style>

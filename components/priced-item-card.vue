<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

const props = defineProps<{
	id: number;
	name: string;
	localName?: string;
	price?: number | null;
	priceMax?: number | null;
	routeName?: string;
	routeParamName?: string;
}>();

const { n, locale } = useI18n();

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

// Форматирует цену с учетом диапазона
const formattedPrice = computed(() => {
	if (!props.price) return null;

	const formatNumber = (num: number) =>
		n(num, { style: 'currency', currency: 'EUR' });

	// Диапазон показываем только если priceMax отличается от price
	if (props.priceMax && props.priceMax !== props.price) {
		return `${formatNumber(props.price)} - ${formatNumber(props.priceMax)}`;
	}

	return formatNumber(props.price);
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
		<div v-if="formattedPrice" class="item-price">
			{{ formattedPrice }}
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
}
</style>

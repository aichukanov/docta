<script setup lang="ts">
import { Currency } from '~/enums/currency';

const props = defineProps<{
	price: number;
	currency: Currency;
	userPrice: number;
}>();

const { formatCurrency, uiCurrency } = useCurrency();

const isConverted = computed(() => props.currency !== uiCurrency.value);
</script>

<template>
	<div class="converted-price">
		<span v-if="isConverted" class="converted-price__original">
			{{ formatCurrency(price, currency) }} =
		</span>
		<div class="converted-price__main">
			<slot :formatted-price="formatCurrency(userPrice, uiCurrency)" />
		</div>
	</div>
</template>

<style lang="less" scoped>
@import url('~/assets/css/vars.less');

.converted-price {
	display: flex;
	flex-direction: column;
	align-items: flex-start;
	gap: 2px;

	&__main {
		display: flex;
		align-items: center;
	}

	&__original {
		font-size: 14px;
		font-weight: 400;
		color: @dark-gray-color;
		white-space: nowrap;
	}
}
</style>

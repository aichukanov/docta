<script setup lang="ts">
import type { Currency } from '~/enums/currency';

defineProps<{
	smaller?: boolean;
}>();

const router = useRouter();
const route = useRoute();

const { uiCurrency, currencyList, currencyNames } = useCurrency();
const { t } = useI18n();
const isExpanded = ref(false);

const cookieCurrency = useCookie<string>('currency', {
	default: (): string => '',
	maxAge: 1000 * 60 * 60 * 24 * 365,
});

function updateCurrency(value: Currency) {
	uiCurrency.value = value;
	cookieCurrency.value = value;

	router.replace({
		query: {
			...route.query,
			currency: formatCurrencyAsQuery(uiCurrency.value),
		},
	});
}

function handleVisibleChange(visible: boolean) {
	isExpanded.value = visible;
}
</script>

<template>
	<div
		class="currency-switcher-wrapper"
		role="group"
		:aria-label="t('CurrencySelector')"
	>
		<el-select
			:modelValue="uiCurrency"
			@update:modelValue="updateCurrency($event)"
			@visible-change="handleVisibleChange"
			:size="smaller ? 'default' : 'large'"
			role="combobox"
			:aria-expanded="isExpanded"
			:aria-label="t('CurrencySelector')"
		>
			<el-option
				v-for="value in currencyList"
				:key="value"
				:label="currencyNames[value]"
				:value="value"
				role="option"
				:aria-selected="uiCurrency === value"
				:aria-label="t('Currency') + ': ' + currencyNames[value]"
			>
				{{ currencyNames[value] }}
			</el-option>
		</el-select>
	</div>
</template>

<style lang="less" scoped>
.currency-switcher-wrapper {
	width: 80px;
}
</style>

<i18n lang="json">
{
	"en": {
		"CurrencySelector": "Select currency",
		"Currency": "Currency"
	},
	"ru": {
		"CurrencySelector": "Выберите валюту",
		"Currency": "Валюта"
	},
	"sr": {
		"CurrencySelector": "Izaberite valutu",
		"Currency": "Valuta"
	},
	"me": {
		"CurrencySelector": "Izaberite valutu",
		"Currency": "Valuta"
	},
	"ba": {
		"CurrencySelector": "Izaberite valutu",
		"Currency": "Valuta"
	},
	"de": {
		"CurrencySelector": "Währung auswählen",
		"Currency": "Währung"
	},
	"tr": {
		"CurrencySelector": "Para birimi seçin",
		"Currency": "Para birimi"
	}
}
</i18n>

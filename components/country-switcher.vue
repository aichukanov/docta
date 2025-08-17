<script setup lang="ts">
import { useCountry, CountryCode } from '~/composables/use-country';

defineProps<{
	smaller?: boolean;
}>();

const router = useRouter();
const route = useRoute();

const { t } = useI18n();
const { country } = useCountry();
const isExpanded = ref(false);

const cookieCountry = useCookie<string[]>('country', {
	maxAge: 1000 * 60 * 60 * 24 * 365,
});

function updateCountry(value: CountryCode[]) {
	country.value = value;
	cookieCountry.value = value;

	router.replace({
		query: {
			...route.query,
			country: formatCountriesAsQuery(country.value),
		},
	});
}

function handleVisibleChange(visible: boolean) {
	isExpanded.value = visible;
}
</script>

<template>
	<div
		class="country-switcher-wrapper"
		role="combobox"
		:aria-label="t('CountrySelector')"
		:aria-expanded="isExpanded"
		aria-haspopup="listbox"
	>
		<el-select
			multiple
			:size="smaller ? 'default' : 'large'"
			:aria-label="t('CountrySelector')"
			:modelValue="country"
			@update:modelValue="updateCountry($event)"
			@visible-change="handleVisibleChange"
		>
			<template #label="{ value }">
				<div
					class="one-line"
					:title="t(value)"
					:aria-label="t('SelectedCountry') + ': ' + t(value)"
				>
					<div
						class="country-switcher-flag"
						:class="`country-switcher-flag-${value}`"
						:aria-label="`${t('FlagOf')} [${t(value)}]`"
						role="img"
					></div>
					<div v-if="country.length === 1" class="country-switcher__tag-name">
						{{ t(value) }}
					</div>
				</div>
			</template>
			<el-option
				v-for="code in allCountries"
				:key="code"
				:label="code.toUpperCase()"
				:value="code"
				:disabled="country.length === 1 && country[0] === code"
				:aria-label="t(code)"
			>
				<div class="country-switcher-option">
					<div
						class="country-switcher-flag"
						:class="`country-switcher-flag-${code}`"
						:aria-label="`${t('FlagOf')} [${t(code)}]`"
						role="img"
					></div>
					<span>{{ t(code) }}</span>
				</div>
			</el-option>
		</el-select>
	</div>
</template>

<style lang="less" scoped>
.country-switcher-wrapper {
	width: 170px;
}

.country-switcher-option {
	display: flex;
	align-items: center;
	gap: 10px;
	padding-right: 20px;
}

.country-switcher-flag {
	width: 20px;
	height: 20px;
	background-size: contain;
	background-repeat: no-repeat;
	background-position: center;

	&.country-switcher-flag-ME {
		background-image: url('/flags/mne.png');
	}

	&.country-switcher-flag-BA {
		background-image: url('/flags/bih.png');
	}
}

.one-line {
	display: flex;
	justify-content: space-between;
	min-width: 0;
	gap: 8px;
	align-items: center;
}

.country-switcher__tag-name {
	flex: 0 1 auto;
	min-width: 1px;
}
</style>

<i18n lang="json">
{
	"en": {
		"ME": "Montenegro",
		"BA": "Bosnia and Herzegovina",
		"CountrySelector": "Select countries",
		"FlagOf": "Flag of",
		"SelectedCountry": "Selected country"
	},
	"ru": {
		"ME": "Черногория",
		"BA": "Босния и Герцеговина",
		"CountrySelector": "Выберите страны",
		"FlagOf": "Флаг",
		"SelectedCountry": "Выбранная страна"
	},
	"sr": {
		"ME": "Crna Gora",
		"BA": "Bosna i Hercegovina",
		"CountrySelector": "Izaberite zemlje",
		"FlagOf": "Zastava",
		"SelectedCountry": "Izabrana zemlja"
	},
	"me": {
		"ME": "Crna Gora",
		"BA": "Bosna i Hercegovina",
		"CountrySelector": "Izaberite zemlje",
		"FlagOf": "Zastava",
		"SelectedCountry": "Izabrana zemlja"
	},
	"ba": {
		"ME": "Crna Gora",
		"BA": "Bosna i Hercegovina",
		"CountrySelector": "Izaberite zemlje",
		"FlagOf": "Zastava",
		"SelectedCountry": "Izabrana zemlja"
	},
	"de": {
		"ME": "Montenegro",
		"BA": "Bosnien und Herzegowina",
		"CountrySelector": "Länder auswählen",
		"FlagOf": "Flagge von",
		"SelectedCountry": "Ausgewähltes Land"
	},
	"tr": {
		"ME": "Karadağ",
		"BA": "Bosna Hersek",
		"CountrySelector": "Ülkeleri seçin",
		"FlagOf": "Bayrağı",
		"SelectedCountry": "Seçilen ülke"
	}
}
</i18n>

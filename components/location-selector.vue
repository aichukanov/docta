<template>
	<KitSelect
		v-model="selectedCityId"
		:options="cityOptions"
		:aria-label="t('YourLocation')"
		:placeholder="t('AllMontenegro')"
		:loading="isLoadingLocation"
		:loading-text="uiText('Loading')"
		:no-data-text="uiText('NothingFound')"
		:clear-label="uiText('Clear')"
		size="large"
		clearable
		dropdown-width="20rem"
		class="header-location"
	>
		<template #prefix>
			<IconMapPin :size="18" />
		</template>
		<template #header>
			{{ t('LocationSortHint') }}
		</template>
	</KitSelect>
</template>

<script setup lang="ts">
import IconMapPin from '~/components/icon/map-pin.vue';
import { CityId } from '~/enums/cities';
import cityI18n from '~/i18n/city';
import locationI18n from '~/i18n/location';
import { combineI18nMessages } from '~/i18n/utils';

const { uiText } = useUiText();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([locationI18n, cityI18n]),
});

const { userLocation, isLoadingLocation, initLocation, setCity, resetCity } =
	useUserLocation();

// Хедер есть на каждой странице — определение локации стартует отсюда
// (initLocation идемпотентен, повторный вызов со страниц безвреден)
onMounted(() => {
	initLocation();
});

const selectedCityId = computed({
	get: () => userLocation.value?.cityId ?? undefined,
	set: (value: number | undefined) => {
		if (value) {
			setCity(value as CityId);
		} else {
			// Крестик clearable = сброс города, плейсхолдер «Вся Черногория»
			resetCity();
		}
	},
});

const cities = computed(() =>
	Object.values(CityId)
		.filter(Number)
		.map((key) => ({
			text: t(`city_${key}`),
			value: key as number,
		}))
		.sort((a, b) => a.text.localeCompare(b.text)),
);

/* KitSelect ждёт { value, label }; `cities` с полем text оставляем как есть —
   на него завязаны другие места компонента */
const cityOptions = computed(() =>
	cities.value.map(({ text, value }) => ({ value, label: text })),
);
</script>

<style scoped>
.header-location {
	/* Фиксированная ширина — во flex-шапке не сжиматься (как у языка) */
	width: 190px;
	flex-shrink: 0;
}

@media only screen and (max-width: 500px) {
	.header-location {
		width: 140px;
	}
}
</style>

<!--
	Глобальный блок стилей попера удалён вместе с el-select: у KitSelect
	выпадашка своя, а подсказка над списком оформлена в самом компоненте
	(.kit-select__header). Панель шире поля (dropdown-width): в ширину узкого
	контрола подсказка над списком крошилась на пять строк.
-->

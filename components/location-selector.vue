<template>
	<el-select
		v-model="selectedCityId"
		size="large"
		:aria-label="t('YourLocation')"
		:placeholder="t('AllMontenegro')"
		:loading="isLoadingLocation"
		clearable
		class="header-location"
		popper-class="header-location-popper"
	>
		<template #prefix>
			<el-icon :size="18">
				<LocationFilled />
			</el-icon>
		</template>
		<template #header>
			<p class="header-location-popper__hint">{{ t('LocationSortHint') }}</p>
		</template>
		<el-option
			v-for="{ text, value } in cities"
			:key="value"
			:label="text"
			:value="value"
		/>
	</el-select>
</template>

<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import { CityId } from '~/enums/cities';
import cityI18n from '~/i18n/city';
import locationI18n from '~/i18n/location';
import { combineI18nMessages } from '~/i18n/utils';

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

<!-- Дропдаун телепортируется в body — стили попера вне scoped -->
<style>
.header-location-popper {
	/* Без потолка длинная подсказка растянула бы попер на весь экран */
	max-width: 320px;
}

.header-location-popper__hint {
	margin: 0;
	font-size: var(--font-size-sm);
	line-height: 1.4;
	color: var(--color-text-secondary);
}
</style>

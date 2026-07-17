<template>
	<FilterWrapper :label="hideLabel ? undefined : t('City')">
		<el-select
			ref="selectRef"
			v-model="cityIds"
			:placeholder="t('AnyCity')"
			:aria-label="t('City')"
			size="large"
			:multiple="multiple"
			collapse-tags
			collapse-tags-tooltip
			class="filter-city"
			@change="selectRef?.blur()"
		>
			<el-option
				v-for="{ text, value } in cities"
				:key="value"
				:label="text"
				:value="value"
			/>
		</el-select>
		<!-- Быстрый фильтр по городу пользователя (геопозиция из хедера) -->
		<el-button
			v-if="quickCity"
			size="small"
			type="primary"
			plain
			class="city-quick-chip"
			:icon="LocationFilled"
			:title="t('QuickCityFilterTitle')"
			@click="applyQuickCity"
		>
			{{ quickCity.text }}
		</el-button>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { LocationFilled } from '@element-plus/icons-vue';
import type { ElSelect } from 'element-plus';
import { CityId } from '~/enums/cities';
import { combineI18nMessages } from '~/i18n/utils';
import citiesI18n from '~/i18n/city';
import locationI18n from '~/i18n/location';

const selectRef = ref<InstanceType<typeof ElSelect>>();

const props = withDefaults(
	defineProps<{
		value: number[];
		multiple?: boolean;
		// Если передан — селект показывает только эти города и для каждого
		// дописывает количество в скобках (для detail-страниц с клиник-фильтром).
		availableCities?: Array<{ value: number; count: number }>;
		// Прячет верхний label «Город» — нужно, когда селект встроен в шапку секции.
		hideLabel?: boolean;
	}>(),
	{
		multiple: true,
	},
);

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([citiesI18n, locationI18n]),
});

const { userLocation } = useUserLocation();

const cityIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const cities = computed(() => {
	if (props.availableCities) {
		return props.availableCities
			.map(({ value, count }) => ({
				value,
				text: `${t(`city_${value}`)} (${count})`,
			}))
			.sort((a, b) => a.text.localeCompare(b.text));
	}
	return Object.values(CityId)
		.filter(Number)
		.map((key) => ({
			text: t(`city_${key}`),
			value: key,
		}))
		.sort((a, b) => a.text.localeCompare(b.text));
});

// Чип показывается, пока город пользователя не выбран в фильтре
// (и есть среди доступных, если список ограничен availableCities)
const quickCity = computed(() => {
	const cityId = userLocation.value?.cityId;
	if (!cityId) return null;
	if (props.value.includes(cityId)) return null;
	if (
		props.availableCities &&
		!props.availableCities.some((c) => c.value === cityId)
	) {
		return null;
	}
	return { value: cityId, text: t(`city_${cityId}`) };
});

const applyQuickCity = () => {
	if (!quickCity.value) return;
	emit(
		'update:value',
		props.multiple ? [...props.value, quickCity.value.value] : [quickCity.value.value],
	);
};
</script>

<style scoped>
.city-quick-chip {
	align-self: flex-start;
}
</style>

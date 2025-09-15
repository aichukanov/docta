<template>
	<FilterWrapper :label="t('City')">
		<el-select
			v-model="cityIds"
			:placeholder="t('AnyCity')"
			size="large"
			multiple
			collapse-tags
			collapse-tags-tooltip
			class="filter-city"
		>
			<el-option
				v-for="{ text, value } in cities"
				:key="value"
				:label="text"
				:value="value"
			/>
		</el-select>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { CityId } from '~/enums/cities';
import citiesI18n from '~/i18n/city';

const emit = defineEmits<{
	search: [];
}>();

const { t } = useI18n(citiesI18n);

const { cityIds } = useFilters();

const cities = computed(() =>
	Object.values(CityId)
		.filter(Number)
		.map((key) => ({
			text: t(`city_${key}`),
			value: key,
		}))
		.sort((a, b) => a.text.localeCompare(b.text)),
);
</script>

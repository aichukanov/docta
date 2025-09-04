<template>
	<el-select
		v-model="cityIds"
		:placeholder="t('AnyCity')"
		multiple
		collapse-tags
		collapse-tags-tooltip
	>
		<el-option
			v-for="{ text, value } in cities"
			:key="value"
			:label="text"
			:value="value"
		/>
	</el-select>
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
	Object.keys(CityId)
		.filter(Number)
		.map((key) => ({
			text: t(key),
			value: key,
		}))
		.sort((a, b) => a.text.localeCompare(b.text)),
);
</script>

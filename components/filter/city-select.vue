<template>
	<FilterWrapper :label="t('City')">
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
	</FilterWrapper>
</template>

<script setup lang="ts">
import type { ElSelect } from 'element-plus';
import { CityId } from '~/enums/cities';
import citiesI18n from '~/i18n/city';

const selectRef = ref<InstanceType<typeof ElSelect>>();

const props = withDefaults(
	defineProps<{
		value: number[];
		multiple?: boolean;
	}>(),
	{
		multiple: true,
	},
);

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(citiesI18n);

const cityIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

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

<template>
	<FilterWrapper :label="t('Category')">
		<FilterableSelect
			:items="categories"
			v-model:value="categoryIds"
			:placeholder="t('AnyCategory')"
			:placeholderSearch="t('SearchCategory')"
			:ariaLabel="t('Category')"
			:noDataText="t('NotFound')"
			multiple
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { LabTestCategory } from '~/enums/labtest-category';
import labTestCategoryI18n from '~/i18n/labtest-category';

const props = defineProps<{
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(labTestCategoryI18n);

const categoryIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const categories = computed(() =>
	Object.values(LabTestCategory)
		.filter(Number)
		.map((key) => ({
			label: t(`lab_test_category_${key}`),
			value: key,
		}))
		.sort((a, b) => a.label.localeCompare(b.label)),
);
</script>

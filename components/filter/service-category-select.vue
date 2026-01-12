<template>
	<FilterWrapper :label="t('ServiceCategory')">
		<FilterableSelect
			:items="categories"
			v-model:value="serviceCategoryIds"
			:placeholder="t('AnyServiceCategory')"
			:placeholderSearch="t('SearchServiceCategory')"
			:noDataText="t('ServiceCategoryNotFound')"
			multiple
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { MedicalServiceCategory } from '~/enums/medical-service-category';
import medicalServiceCategoryI18n from '~/i18n/medical-service-category';

const props = defineProps<{
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(medicalServiceCategoryI18n);

const serviceCategoryIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const categories = computed(() =>
	Object.values(MedicalServiceCategory)
		.filter(Number)
		.map((key) => ({
			label: t(`medical_service_category_${key}`),
			value: key,
		}))
		.sort((a, b) => a.label.localeCompare(b.label)),
);
</script>

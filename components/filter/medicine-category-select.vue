<template>
	<FilterWrapper :label="t('FilterMedicineCategory')">
		<FilterableSelect
			:items="categories"
			v-model:value="medicineCategoryIds"
			:placeholder="t('FilterAnyMedicineCategory')"
			:placeholderSearch="t('FilterSearchMedicineCategory')"
			:ariaLabel="t('FilterMedicineCategory')"
			:noDataText="t('NoMedicinesFound')"
			multiple
			wrapItems
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import {
	MEDICINE_CATEGORY_IDS,
	getMedicineCategoryKey,
} from '~/enums/medicine-category';
import medicineCategoryI18n from '~/i18n/medicine-category';
import medicineI18n from '~/i18n/medicine';
import { combineI18nMessages } from '~/i18n/utils';

const props = defineProps<{
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([medicineCategoryI18n, medicineI18n]),
});

const medicineCategoryIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

// Порядок — как в enum'е: он выстроен от бытового к специализированному
// («обезболивающие» первыми, «онкология» последней), а не по алфавиту, который
// в каждой локали свой.
const categories = computed(() =>
	MEDICINE_CATEGORY_IDS.map((id) => ({
		value: id as number,
		label: t(getMedicineCategoryKey(id)),
	})),
);
</script>

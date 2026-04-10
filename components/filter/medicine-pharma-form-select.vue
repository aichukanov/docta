<template>
	<FilterWrapper :label="t('FilterPharmaForm')">
		<FilterableSelect
			:items="items"
			v-model:value="pharmaFormIds"
			:placeholder="t('FilterAnyPharmaForm')"
			:placeholderSearch="t('FilterSearchPharmaForm')"
			:ariaLabel="t('FilterPharmaForm')"
			:noDataText="t('NoMedicinesFound')"
			multiple
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import medicineI18n from '~/i18n/medicine';

const props = defineProps<{
	value: number[];
	items: { value: number; label: string }[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(medicineI18n);

const pharmaFormIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});
</script>

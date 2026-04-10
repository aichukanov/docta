<template>
	<FilterWrapper :label="t('FilterDispensingMode')">
		<FilterableSelect
			:items="modes"
			v-model:value="dispensingModeIds"
			:placeholder="t('FilterAnyDispensingMode')"
			:placeholderSearch="t('FilterSearchDispensingMode')"
			:ariaLabel="t('FilterDispensingMode')"
			:noDataText="t('NoMedicinesFound')"
			multiple
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { DispensingMode } from '~/enums/dispensing-mode';
import dispensingModeI18n from '~/i18n/dispensing-mode';
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
	messages: combineI18nMessages([dispensingModeI18n, medicineI18n]),
});

const dispensingModeIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const modes = computed(() =>
	Object.values(DispensingMode)
		.filter(Number)
		.map((key) => ({
			label: t(`dm_${key}`),
			value: key as number,
		})),
);
</script>

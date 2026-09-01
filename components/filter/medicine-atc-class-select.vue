<template>
	<FilterWrapper :label="t('FilterAtcClass')">
		<FilterableSelect
			:items="classes"
			v-model:value="atcClassCodes"
			:placeholder="t('FilterAnyAtcClass')"
			:placeholderSearch="t('FilterSearchAtcClass')"
			:ariaLabel="t('FilterAtcClass')"
			:noDataText="t('NoMedicinesFound')"
			multiple
			wrapItems
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { capitalizeFirstLetter } from '~/common/string-utils';
import { ATC_CLASS_CODES, getAtcClassKeyByCode } from '~/enums/atc-class';
import atcClassI18n from '~/i18n/atc-class';
import medicineI18n from '~/i18n/medicine';
import { combineI18nMessages } from '~/i18n/utils';

const props = defineProps<{
	value: string[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: string[]): void;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([atcClassI18n, medicineI18n]),
});

const atcClassCodes = computed({
	get: () => props.value,
	set: (value: string[]) => {
		emit('update:value', value);
	},
});

// Классов 79 — в отличие от категорий, порядок задаём по алфавиту локали:
// осмысленной «бытовой» последовательности у фармакологических классов нет.
const classes = computed(() =>
	[...ATC_CLASS_CODES]
		.map((code) => ({
			value: code,
			label: capitalizeFirstLetter(t(getAtcClassKeyByCode(code)), locale.value),
		}))
		.sort((a, b) => a.label.localeCompare(b.label, locale.value)),
);
</script>

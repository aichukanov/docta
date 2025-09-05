<template>
	<el-select
		v-model="specialtyIds"
		:placeholder="t('AnySpecialty')"
		multiple
		filterable
		collapse-tags
		collapse-tags-tooltip
	>
		<el-option
			v-for="{ text, value } in specialties"
			:key="value"
			:label="text"
			:value="value"
		/>
	</el-select>
</template>

<script setup lang="ts">
import { DoctorSpecialty } from '~/enums/specialty';
import specialtyI18n from '~/i18n/specialty';

const emit = defineEmits<{
	search: [];
}>();

const { t } = useI18n(specialtyI18n);

const { specialtyIds } = useFilters();

const specialties = computed(() =>
	Object.keys(DoctorSpecialty)
		.filter(Number)
		.map((key) => ({
			text: t(key),
			value: key,
		}))
		.sort((a, b) => a.text.localeCompare(b.text)),
);
</script>

<template>
	<FilterWrapper :label="t('Specialty')">
		<FilterableSelect
			:items="specialties"
			v-model:value="specialtyIds"
			:placeholder="t('AnySpecialty')"
			:placeholderSearch="t('SearchSpecialty')"
			:noDataText="t('NotFound')"
			multiple
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { DoctorSpecialty } from '~/enums/specialty';
import specialtyI18n from '~/i18n/specialty';

const props = defineProps<{
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(specialtyI18n);

const specialtyIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

const specialties = computed(() =>
	Object.values(DoctorSpecialty)
		.filter(Number)
		.map((key) => ({
			label: t(`specialty_${key}`),
			value: key,
		}))
		.sort((a, b) => a.label.localeCompare(b.label)),
);
</script>

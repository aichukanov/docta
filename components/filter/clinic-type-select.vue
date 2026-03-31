<template>
	<FilterWrapper :label="t('ClinicType')">
		<el-select
			ref="selectRef"
			v-model="clinicTypeIds"
			:placeholder="t('AnyClinicType')"
			:aria-label="t('ClinicType')"
			size="large"
			multiple
			collapse-tags
			collapse-tags-tooltip
			class="filter-clinic-type"
			@change="selectRef?.blur()"
		>
			<el-option
				v-for="{ text, value } in clinicTypes"
				:key="value"
				:label="text"
				:value="value"
			/>
		</el-select>
	</FilterWrapper>
</template>

<script setup lang="ts">
import type { ElSelect } from 'element-plus';
import { ClinicType } from '~/enums/clinic-type';
import clinicTypeI18n from '~/i18n/clinic-type';

const selectRef = ref<InstanceType<typeof ElSelect>>();

const props = defineProps<{
	value: number[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(clinicTypeI18n);

const clinicTypeIds = computed({
	get: () => props.value,
	set: (value: number[]) => {
		emit('update:value', value);
	},
});

/** Типы, которые показываем в фильтре сейчас (остальные откроем позже) */
const VISIBLE_TYPES: ClinicType[] = [
	ClinicType.HOSPITAL,
	ClinicType.POLYCLINIC,
	ClinicType.DENTAL_CLINIC,
	ClinicType.GYNECOLOGICAL_CLINIC,
	ClinicType.UROLOGICAL_CLINIC,
	ClinicType.OPHTHALMOLOGY_CLINIC,
	ClinicType.CARDIOLOGY_CLINIC,
	ClinicType.ENT_CLINIC,
	ClinicType.ORTHOPEDIC_CLINIC,
	ClinicType.DIAGNOSTIC_LAB,
];

const clinicTypes = computed(() =>
	VISIBLE_TYPES
		.map((key) => ({
			text: t(`clinic_type_${key}`),
			value: key,
		}))
		.sort((a, b) => a.text.localeCompare(b.text)),
);
</script>

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
import { ALL_CLINIC_TYPES, ClinicType } from '~/enums/clinic-type';
import clinicTypeI18n from '~/i18n/clinic-type';

const selectRef = ref<InstanceType<typeof ElSelect>>();

const props = defineProps<{
	value: number[];
	/**
	 * Какие типы показывать в списке. По умолчанию — все: редакторы обязаны
	 * видеть любой назначенный тип, иначе `el-select` печатает сырое число.
	 * Публичный фильтр передаёт `FILTERABLE_CLINIC_TYPES`.
	 */
	types?: ClinicType[];
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

const clinicTypes = computed(() =>
	(props.types ?? ALL_CLINIC_TYPES)
		.map((key) => ({
			text: t(`clinic_type_${key}`),
			value: key,
		}))
		.sort((a, b) => a.text.localeCompare(b.text)),
);
</script>

<template>
	<FilterWrapper :label="t('ClinicType')">
		<KitSelect
			v-model="clinicTypeIds"
			:options="clinicTypeOptions"
			:placeholder="t('AnyClinicType')"
			:aria-label="t('ClinicType')"
			:no-data-text="uiText('NothingFound')"
			size="large"
			multiple
			:max-tags="3"
			class="filter-clinic-type"
		/>
	</FilterWrapper>
</template>

<script setup lang="ts">
import { ALL_CLINIC_TYPES, ClinicType } from '~/enums/clinic-type';
import clinicTypeI18n from '~/i18n/clinic-type';

const props = defineProps<{
	value: number[];
	/**
	 * Какие типы показывать в списке. По умолчанию — все: редакторы обязаны
	 * видеть любой назначенный тип, иначе `KitSelect` печатает сырое число.
	 * Публичный фильтр передаёт `FILTERABLE_CLINIC_TYPES`.
	 */
	types?: ClinicType[];
}>();

const emit = defineEmits<{
	(e: 'update:value', value: number[]): void;
}>();

const { t } = useI18n(clinicTypeI18n);
const { uiText } = useUiText();

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

const clinicTypeOptions = computed(() =>
	clinicTypes.value.map(({ text, value }) => ({ value, label: text })),
);
</script>

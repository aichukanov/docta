<template>
	<!-- el-select-v2 без filterable — как сортировка в clinic/items-page-filters:
	     поисковая строка на двух вариантах только мешает -->
	<el-select-v2
		v-model="sort"
		:options="options"
		:aria-label="t('SortLabel')"
		size="large"
		class="medicine-sort-select"
	/>
</template>

<script setup lang="ts">
import medicineI18n from '~/i18n/medicine';
import {
	MEDICINE_SORTS,
	MEDICINE_SORT_POPULAR,
	MEDICINE_SORT_NAME_ASC,
	normalizeMedicineSort,
	type MedicineSort,
} from '~/common/medicine-sort';

const props = defineProps<{
	value: MedicineSort;
}>();

const emit = defineEmits<{
	(e: 'update:value', value: MedicineSort): void;
}>();

const { t } = useI18n({ useScope: 'local', messages: medicineI18n.messages });

const sort = computed({
	get: () => props.value,
	// Селект типизирован строкой, поэтому нормализуем: наружу уходит только
	// значение из MEDICINE_SORTS
	set: (value: string) => emit('update:value', normalizeMedicineSort(value)),
});

const LABEL_KEYS: Record<MedicineSort, string> = {
	[MEDICINE_SORT_POPULAR]: 'SortPopular',
	[MEDICINE_SORT_NAME_ASC]: 'SortNameAsc',
};

const options = computed(() =>
	MEDICINE_SORTS.map((value) => ({ value, label: t(LABEL_KEYS[value]) })),
);
</script>

<style lang="less" scoped>
.medicine-sort-select {
	width: 200px;

	@media (max-width: 500px) {
		width: 100%;
	}
}
</style>

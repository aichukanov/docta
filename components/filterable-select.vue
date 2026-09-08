<script setup lang="ts">
/**
 * Обёртка над KitSelect с API, принятым в проекте (`value` + `update:value`
 * вместо `v-model`). Существует ради того, чтобы её потребители — фильтры
 * каталогов и админка — не знали, на чём именно она сделана: раньше это был
 * `el-select-v2`, теперь KitSelect.
 */
type ValueType = string | number;

const props = withDefaults(
	defineProps<{
		items: { value: ValueType; label: string }[];
		value: ValueType | ValueType[] | null;
		placeholder?: string;
		placeholderSearch?: string;
		ariaLabel?: string;
		noDataText?: string;
		multiple?: boolean;
		clearable?: boolean;
		/**
		 * Переносить длинные подписи на вторую строку. По умолчанию выключено:
		 * список виртуальный, с фиксированной высотой строки, и увеличение
		 * высоты ради переноса съедает видимую часть выпадашки. Там, где подписи
		 * короткие (города, специальности), это не нужно.
		 */
		wrapItems?: boolean;
	}>(),
	{
		placeholder: '',
		placeholderSearch: '',
		ariaLabel: '',
		noDataText: '',
		multiple: false,
		clearable: false,
		wrapItems: true,
	},
);

const emit = defineEmits<{
	(e: 'update:value', value: ValueType | ValueType[] | null): void;
}>();

const { uiText } = useUiText();

const value = computed({
	get: () => props.value,
	set: (value: ValueType | ValueType[] | null) => {
		emit('update:value', value);
	},
});
</script>

<template>
	<KitSelect
		v-model="value"
		:options="items"
		:placeholder="placeholder"
		:search-placeholder="placeholderSearch"
		:aria-label="ariaLabel"
		:no-data-text="noDataText"
		:multiple="multiple"
		:clearable="clearable"
		:wrap-labels="wrapItems"
		:clear-label="uiText('Clear')"
		filterable
		size="large"
	/>
</template>

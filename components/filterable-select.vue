<script setup lang="ts">
import type { ElSelectV2 } from 'element-plus';

type ValueType = string | number;

const selectRef = ref<InstanceType<typeof ElSelectV2>>();

const props = withDefaults(
	defineProps<{
		items: { value: ValueType; label: string }[];
		value: ValueType | ValueType[] | null;
		placeholder?: string;
		placeholderSearch?: string;
		ariaLabel?: string;
		noDataText?: string;
		multiple?: boolean;
	}>(),
	{
		placeholder: '',
		placeholderSearch: '',
		ariaLabel: '',
		noDataText: '',
		multiple: false,
	},
);

const emit = defineEmits<{
	(e: 'update:value', value: ValueType | ValueType[] | null): void;
}>();

const value = computed({
	get: () => props.value,
	set: (value: ValueType | ValueType[] | null) => {
		emit('update:value', value);
	},
});
</script>

<template>
	<el-select-v2
		ref="selectRef"
		v-model="value"
		:options="items"
		:placeholder="placeholder"
		:aria-label="ariaLabel"
		:no-data-text="noDataText"
		:multiple="multiple"
		filterable
		size="large"
		@change="selectRef?.blur()"
	/>
</template>

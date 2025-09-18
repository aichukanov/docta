<script setup lang="ts">
type ValueType = string | number;

const props = withDefaults(
	defineProps<{
		items: { value: ValueType; label: string }[];
		value: ValueType | ValueType[] | null;
		placeholder?: string;
		placeholderSearch?: string;
		noDataText?: string;
		multiple?: boolean;
	}>(),
	{
		placeholder: '',
		placeholderSearch: '',
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

const searchItemName = ref('');
const searchInput = ref<HTMLInputElement | null>(null);

const filteredItems = computed(() => {
	return props.items.filter((item) =>
		item.label.toLowerCase().includes(searchItemName.value.toLowerCase()),
	);
});

const focusSearchItemNameInput = async (visible: boolean) => {
	if (visible && searchInput.value) {
		await nextTick();
		searchInput.value.focus();
	}
};
</script>

<template>
	<el-select
		v-model="value"
		:placeholder="placeholder"
		size="large"
		:multiple="multiple"
		:no-data-text="noDataText"
		@visible-change="focusSearchItemNameInput($event)"
	>
		<template #header>
			<el-input
				ref="searchInput"
				v-model="searchItemName"
				:placeholder="placeholderSearch"
			/>
		</template>
		<el-option
			v-for="{ value, label } in filteredItems"
			:key="value"
			:label="label"
			:value="value"
		/>
	</el-select>
</template>

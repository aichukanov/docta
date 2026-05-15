<script setup lang="ts">
import { Search } from '@element-plus/icons-vue';

interface CategoryOption {
	categoryId: number;
	title: string;
	count: number;
}

interface SortOption {
	value: string;
	label: string;
}

const props = withDefaults(
	defineProps<{
		search: string;
		category: number | null;
		sort: string;
		categories: CategoryOption[];
		sortOptions?: SortOption[];
		searchPlaceholder: string;
		allCategoriesLabel: string;
		sortPlaceholder?: string;
	}>(),
	{
		sortOptions: () => [],
		sortPlaceholder: '',
	},
);

const emit = defineEmits<{
	(e: 'update:search', value: string): void;
	(e: 'update:category', value: number | null): void;
	(e: 'update:sort', value: string): void;
}>();

const searchModel = computed({
	get: () => props.search,
	set: (v: string) => emit('update:search', v),
});

const categoryOptions = computed(() =>
	props.categories.map((c) => ({
		value: c.categoryId,
		label: `${c.title} (${c.count})`,
	})),
);

const categoryModel = computed({
	get: () => props.category,
	set: (v: number | null) => emit('update:category', v),
});

const sortModel = computed({
	get: () => props.sort,
	set: (v: string) => emit('update:sort', v ?? ''),
});
</script>

<template>
	<div class="items-page-filters">
		<el-input
			v-model="searchModel"
			:placeholder="searchPlaceholder"
			:prefix-icon="Search"
			size="large"
			clearable
			class="filter-search"
		/>
		<el-select-v2
			v-if="categoryOptions.length > 0"
			v-model="categoryModel"
			:options="categoryOptions"
			:placeholder="allCategoriesLabel"
			size="large"
			filterable
			clearable
			class="filter-select"
		/>
		<el-select-v2
			v-if="sortOptions.length > 0"
			v-model="sortModel"
			:options="sortOptions"
			:placeholder="sortPlaceholder"
			size="large"
			clearable
			class="filter-select"
		/>
	</div>
</template>

<style lang="less" scoped>
.items-page-filters {
	display: grid;
	grid-template-columns: minmax(0, 2fr) minmax(0, 1fr) minmax(0, 1fr);
	gap: var(--spacing-md);

	@media (max-width: 760px) {
		grid-template-columns: 1fr;
	}
}

.filter-search,
.filter-select {
	width: 100%;
}
</style>

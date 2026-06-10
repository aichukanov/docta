<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

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
		clinicSlug: string;
		clinicName: string;
		clinicLink: object;
		breadcrumbHomeLabel: string;
		breadcrumbClinicsLabel: string;
		breadcrumbCurrentLabel: string;
		pageTitle: string;
		items: any[];
		totalCount: number;
		categories: CategoryOption[];
		sortOptions?: SortOption[];
		defaultSort?: string;
		emptyText: string;
		searchPlaceholder: string;
		allCategoriesLabel: string;
		sortPlaceholder?: string;
		pagination: {
			page: number;
			pageSize: number;
			totalCount: number;
			totalPages: number;
		};
		isLoading?: boolean;
	}>(),
	{
		sortOptions: () => [],
		defaultSort: '',
		isLoading: false,
		sortPlaceholder: '',
	},
);

const { locale } = useI18n();
const { currentSearch, currentCategory, currentSort, pushQuery } =
	useClinicItemsRoute();

const searchLocal = ref(currentSearch.value);
let searchTimer: ReturnType<typeof setTimeout> | null = null;

watch(currentSearch, (v) => {
	if (v !== searchLocal.value) searchLocal.value = v;
});

const onSearchUpdate = (v: string) => {
	searchLocal.value = v;
	if (searchTimer) clearTimeout(searchTimer);
	searchTimer = setTimeout(() => {
		pushQuery({ search: v || null, page: null });
	}, 350);
};

const onCategoryUpdate = (id: number | null) => {
	pushQuery({ category: id == null ? null : String(id), page: null });
};

const displayedSort = computed(() => currentSort.value || props.defaultSort);

const onSortUpdate = (sort: string) => {
	const next = !sort || sort === props.defaultSort ? null : sort;
	pushQuery({ sort: next, page: null });
};

const onPageChange = (page: number) => {
	pushQuery({ page: page > 1 ? page : null });
	if (import.meta.client) {
		window.scrollTo({ top: 0, behavior: 'smooth' });
	}
};

const homeLink = computed(() => ({
	path: '/',
	query: getRegionalQuery(locale.value),
}));
const clinicsLink = computed(() => ({
	name: 'clinics',
	query: getRegionalQuery(locale.value),
}));

const breadcrumbs = computed(() => [
	{ label: props.breadcrumbHomeLabel, to: homeLink.value },
	{ label: props.breadcrumbClinicsLabel, to: clinicsLink.value },
	{ label: props.clinicName, to: props.clinicLink },
	{ label: props.breadcrumbCurrentLabel },
]);
</script>

<template>
	<div class="items-page">
		<ClinicItemsPageHeader
			:breadcrumbs="breadcrumbs"
			:title="pageTitle"
			:count="totalCount"
		>
			<template v-if="$slots.badges" #badges>
				<slot name="badges" />
			</template>
		</ClinicItemsPageHeader>

		<ClinicItemsPageFilters
			:search="searchLocal"
			:category="currentCategory"
			:sort="displayedSort"
			:categories="categories"
			:sort-options="sortOptions"
			:search-placeholder="searchPlaceholder"
			:all-categories-label="allCategoriesLabel"
			:sort-placeholder="sortPlaceholder"
			@update:search="onSearchUpdate"
			@update:category="onCategoryUpdate"
			@update:sort="onSortUpdate"
		/>

		<div v-loading="isLoading && items.length > 0" class="items-area">
			<el-empty
				v-if="!isLoading && items.length === 0"
				:description="emptyText"
			/>
			<div v-else-if="isLoading && items.length === 0" class="items-grid">
				<SkeletonCard v-for="i in 6" :key="i" :rows="2" :show-media="false" />
			</div>
			<div v-else class="items-grid">
				<slot v-for="item in items" :key="item.id" :item="item" />
			</div>
		</div>

		<Pagination
			v-if="pagination.totalPages > 1"
			:total="pagination.totalCount"
			:currentPage="pagination.page"
			:pageSize="pagination.pageSize"
			align="center"
			@update:current-page="onPageChange"
		/>
	</div>
</template>

<style lang="less" scoped>
.items-page {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
	max-width: 1100px;
	width: 100%;
	margin: 0 auto;
	padding: var(--spacing-xl);
	box-sizing: border-box;
}

.items-area {
	min-height: 200px;
}

.items-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	gap: var(--spacing-md);
}

@media (max-width: 640px) {
	.items-page {
		padding: var(--spacing-md);
		gap: var(--spacing-lg);
	}
}
</style>

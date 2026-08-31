<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import type { ClinicItemTypeSummary } from '~/interfaces/clinic';

const props = withDefaults(
	defineProps<{
		title?: string;
		summary: ClinicItemTypeSummary;
		clinicSlug: string;
		subpageRouteName: string;
		categoryQueryKey: string;
		getCategoryTitle: (categoryId: number) => string;
		viewAllLabel: string;
		popularLabel?: string;
		categoriesLabel?: string;
		maxCategories?: number;
	}>(),
	{
		maxCategories: 8,
		popularLabel: '',
		categoriesLabel: '',
	},
);

const slots = useSlots();
const { locale } = useI18n();

const topCategories = computed(() => {
	const named = props.summary.categories
		.filter((c) => c.categoryId != null)
		.map((c) => ({
			categoryId: c.categoryId as number,
			count: c.count,
			title: props.getCategoryTitle(c.categoryId as number),
		}))
		.filter((c) => !!c.title)
		.slice(0, props.maxCategories);

	return named.map((c) => ({
		key: `cat-${c.categoryId}`,
		title: c.title,
		count: c.count,
		query: {
			...getRegionalQuery(locale.value),
			[props.categoryQueryKey]: String(c.categoryId),
		},
	}));
});

const viewAllLink = computed(() => ({
	name: props.subpageRouteName,
	params: { clinicSlug: props.clinicSlug },
	query: getRegionalQuery(locale.value),
}));

const categoryLink = (query: Record<string, string | undefined>) => ({
	name: props.subpageRouteName,
	params: { clinicSlug: props.clinicSlug },
	query,
});

const hasTopItems = computed(
	() => !!slots.item && !!props.summary.topItems?.length,
);

const hasCategories = computed(() => topCategories.value.length > 0);
</script>

<template>
	<div class="items-summary">
		<header class="summary-header">
			<EntityPageSectionTitle v-if="title" :title="title">
				<template #icon>
					<slot name="icon" />
				</template>
			</EntityPageSectionTitle>
			<ViewAllLink :to="viewAllLink" :label="viewAllLabel" />
		</header>

		<section v-if="hasTopItems" class="top-items-section">
			<p v-if="popularLabel" class="subsection-label">{{ popularLabel }}</p>
			<div class="top-items-grid">
				<slot v-for="item in summary.topItems" name="item" :item="item" />
			</div>
		</section>

		<section v-if="hasCategories" class="categories-section">
			<p v-if="categoriesLabel" class="subsection-label">
				{{ categoriesLabel }}
			</p>
			<ul class="category-list">
				<li v-for="row in topCategories" :key="row.key" class="category-item">
					<NuxtLink :to="categoryLink(row.query)" class="category-link">
						<span class="category-title">{{ row.title }}</span>
						<span class="category-count">{{ row.count }}</span>
					</NuxtLink>
				</li>
			</ul>
		</section>
	</div>
</template>

<style lang="less" scoped>
.items-summary {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
}

.summary-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-md);
	flex-wrap: wrap;
}

.subsection-label {
	margin: 0 0 var(--kit-spacing-sm) 0;
	font-size: var(--kit-font-size-xs);
	font-weight: 600;
	color: var(--kit-color-text-muted);
	text-transform: uppercase;
	letter-spacing: 0.06em;
}

.top-items-grid {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: var(--kit-spacing-sm);

	@media (max-width: 640px) {
		grid-template-columns: 1fr;
	}
}

.top-items-section + .categories-section {
	margin-top: var(--kit-spacing-md);
}

.category-list {
	list-style: none;
	margin: 0;
	padding: 0;
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: var(--kit-spacing-xs) var(--kit-spacing-md);

	@media (max-width: 640px) {
		grid-template-columns: 1fr;
	}
}

.category-item {
	margin: 0;
}

.category-link {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-sm);
	padding: var(--kit-spacing-md);
	border-radius: var(--kit-border-radius-md);
	text-decoration: none;
	color: var(--kit-color-text-primary);
	background: var(--kit-color-bg-secondary, transparent);
	transition:
		background-color 0.15s ease,
		color 0.15s ease;

	&:hover {
		background: var(--kit-color-bg-tertiary);
		color: var(--kit-color-primary);
	}
}

.category-title {
	font-size: var(--kit-font-size-md);
	font-weight: 500;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.category-count {
	font-size: var(--kit-font-size-sm);
	font-weight: 500;
	color: var(--kit-color-text-secondary);
	background: var(--kit-color-bg-tertiary);
	padding: 2px 8px;
	border-radius: 10px;
	line-height: 1.4;
	flex-shrink: 0;
}
</style>

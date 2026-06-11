<script setup lang="ts" generic="T extends { id: number }">
import { getRegionalQuery } from '~/common/url-utils';

interface CategoryWithTitle {
	title: string;
	items: T[];
}

const props = defineProps<{
	title: string;
	totalCount: number;
	routeName: string;
	categories: CategoryWithTitle[];
	// 0 — show all items in each category without show-more.
	initialLimit?: number;
}>();

const { locale } = useI18n();

const sectionLink = computed(() => ({
	name: props.routeName,
	query: {
		...getRegionalQuery(locale.value),
	},
}));
</script>

<template>
	<div v-if="totalCount > 0" class="categorized-section">
		<EntityPageSectionTitle
			:title="title"
			:count="totalCount"
			:link="sectionLink"
		>
			<template #icon>
				<slot name="icon" />
			</template>
		</EntityPageSectionTitle>

		<div class="section-body">
			<ClinicCategorySubsection
				v-for="(category, index) in categories"
				:key="index"
				:title="category.title"
				:items="category.items"
				:initialLimit="initialLimit"
			>
				<template #default="{ item }">
					<slot :item="item" />
				</template>
			</ClinicCategorySubsection>
		</div>
	</div>
</template>

<style lang="less" scoped>
.categorized-section {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);

	.section-body {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xl);
	}
}
</style>

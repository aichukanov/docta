<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

interface CategoryWithTitle {
	title: string;
	items: { id: number }[];
}

const props = defineProps<{
	title: string;
	totalCount: number;
	routeName: string;
	categories: CategoryWithTitle[];
	otherCategory?: CategoryWithTitle;
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
			>
				<template #default="{ item }">
					<slot :item="item" />
				</template>
			</ClinicCategorySubsection>

			<ClinicCategorySubsection
				v-if="otherCategory"
				:title="otherCategory.title"
				:items="otherCategory.items"
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
	.section-body {
		display: flex;
		flex-direction: column;
		gap: var(--spacing-xl);
	}
}
</style>

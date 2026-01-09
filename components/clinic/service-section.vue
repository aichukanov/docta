<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';

interface Props {
	title: string;
	items: unknown[];
	routeName: string;
	initialLimit?: number;
}

const props = withDefaults(defineProps<Props>(), {
	initialLimit: 10,
});

const { locale } = useI18n();

const totalCount = computed(() => props.items.length);

const sectionLink = computed(() => ({
	name: props.routeName,
	query: {
		...getRegionalQuery(locale.value),
	},
}));
</script>

<template>
	<div v-if="items.length > 0" class="service-section">
		<div class="section-header">
			<slot name="icon" />
			<NuxtLink :to="sectionLink" class="section-title-link">
				<h2 class="section-title">{{ title }}</h2>
			</NuxtLink>
			<el-badge :value="totalCount" type="primary" class="section-badge" />
		</div>

		<div class="section-body">
			<ClinicServiceSectionContent :items="items" :initialLimit="initialLimit">
				<template #default="{ item }">
					<slot :item="item" />
				</template>
			</ClinicServiceSectionContent>
		</div>
	</div>
</template>

<style lang="less" scoped>
.service-section {
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	overflow: hidden;
}

.section-header {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	padding: var(--spacing-lg) var(--spacing-xl);
	background: linear-gradient(to right, rgba(79, 70, 229, 0.04), transparent);
	border-bottom: 1px solid var(--color-border-light);
}

.section-title-link {
	flex: 1;
	text-decoration: none;
	color: inherit;

	&:hover .section-title {
		color: var(--color-primary);
	}
}

.section-title {
	font-size: var(--font-size-lg);
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
	font-family: system-ui, -apple-system, sans-serif;
	transition: color var(--transition-base);
}

.section-body {
	padding: var(--spacing-lg) var(--spacing-xl);
}
</style>

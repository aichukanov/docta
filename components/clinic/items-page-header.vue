<script setup lang="ts">
import type { BreadcrumbItem } from '~/components/app-breadcrumbs.vue';

defineProps<{
	breadcrumbs: BreadcrumbItem[];
	title: string;
	count: number;
}>();
</script>

<template>
	<header class="items-page-header">
		<AppBreadcrumbs :items="breadcrumbs" />

		<div class="title-row">
			<h1 class="title">{{ title }}</h1>
			<el-tag round size="large" type="primary" effect="dark">{{
				count
			}}</el-tag>
		</div>

		<div v-if="$slots.badges" class="badges">
			<slot name="badges" />
		</div>
	</header>
</template>

<style lang="less" scoped>
.items-page-header {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.title-row {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	flex-wrap: wrap;
}

.title {
	font-size: var(--font-size-4xl);
	font-weight: var(--font-weight-bold);
	color: var(--color-text-heading);
	margin: 0;
	line-height: 1.2;
}

.badges {
	display: flex;
	flex-wrap: wrap;
	gap: var(--spacing-xs);
}

@media (max-width: 640px) {
	.title {
		font-size: var(--font-size-3xl);
	}
}
</style>

<script setup lang="ts">
interface Crumb {
	label: string;
	to?: object;
}

defineProps<{
	breadcrumbs: Crumb[];
	title: string;
	count: number;
}>();
</script>

<template>
	<header class="items-page-header">
		<el-breadcrumb separator="/" class="breadcrumb">
			<el-breadcrumb-item
				v-for="(crumb, i) in breadcrumbs"
				:key="i"
				:to="crumb.to"
			>
				{{ crumb.label }}
			</el-breadcrumb-item>
		</el-breadcrumb>

		<div class="title-row">
			<h1 class="title">{{ title }}</h1>
			<el-tag round size="large" type="primary" effect="dark">{{ count }}</el-tag>
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

.breadcrumb {
	font-size: var(--font-size-sm);
}

.title-row {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	flex-wrap: wrap;
}

.title {
	font-size: 2rem;
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
		font-size: 1.5rem;
	}
}
</style>

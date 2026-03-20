<script setup lang="ts">
defineProps<{
	title: string;
	count?: number;
	link?: object;
}>();
</script>

<template>
	<div class="section-title-row">
		<span v-if="$slots.icon" class="section-title-icon">
			<slot name="icon" />
		</span>
		<NuxtLink v-if="link" :to="link" class="section-title-link">
			<h2 class="section-title">{{ title }}</h2>
		</NuxtLink>
		<h2 v-else class="section-title">{{ title }}</h2>
		<span v-if="count != null" class="section-title-count">{{ count }}</span>
	</div>
</template>

<style lang="less" scoped>
.section-title-row {
	display: flex;
	align-items: baseline;
	gap: var(--spacing-md);
	margin-bottom: var(--spacing-lg);
}

.section-title-icon {
	display: flex;
	align-items: center;
	align-self: center;
	color: var(--color-text-primary);
	flex-shrink: 0;
}

.section-title-link {
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
	transition: color 0.15s ease;
}

.section-title-count {
	font-size: var(--font-size-sm);
	font-weight: 500;
	color: var(--color-text-secondary);
	background: var(--color-bg-tertiary);
	padding: 2px 8px;
	border-radius: 10px;
	line-height: 1.4;
}
</style>

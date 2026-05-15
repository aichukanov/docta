<script setup lang="ts">
import { ArrowRight } from '@element-plus/icons-vue';
import type { RouteLocationRaw } from 'vue-router';

defineProps<{
	to: RouteLocationRaw;
	label: string;
}>();
</script>

<template>
	<NuxtLink :to="to" class="view-all-link">
		<span>{{ label }}</span>
		<el-icon class="view-all-icon"><ArrowRight /></el-icon>
	</NuxtLink>
</template>

<style lang="less" scoped>
.view-all-link {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	color: var(--color-primary);
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-md);
	text-decoration: none;
	white-space: nowrap;
	padding: var(--spacing-xs) var(--spacing-sm);
	border-radius: var(--border-radius-md);
	transition:
		color 0.15s ease,
		background-color 0.15s ease;

	&:hover {
		color: var(--color-primary-dark);
		background: var(--color-bg-tertiary);

		.view-all-icon {
			transform: translateX(2px);
		}
	}
}

.view-all-icon {
	font-size: 16px;
	transition: transform 0.15s ease;
}
</style>

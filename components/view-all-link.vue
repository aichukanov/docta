<script setup lang="ts">
import IconArrowRight from '~/components/icon/arrow-right.vue';
import type { RouteLocationRaw } from 'vue-router';

defineProps<{
	to: RouteLocationRaw;
	label: string;
}>();
</script>

<template>
	<NuxtLink :to="to" class="view-all-link">
		<span>{{ label }}</span>
		<IconArrowRight :size="16" class="view-all-icon" />
	</NuxtLink>
</template>

<style lang="less" scoped>
.view-all-link {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	color: var(--kit-color-primary);
	font-weight: var(--kit-font-weight-semibold);
	font-size: var(--kit-font-size-md);
	text-decoration: none;
	white-space: nowrap;
	padding: var(--kit-spacing-xs) var(--kit-spacing-sm);
	border-radius: var(--kit-border-radius-md);
	transition:
		color 0.15s ease,
		background-color 0.15s ease;

	&:hover {
		color: var(--kit-color-primary-dark);
		background: var(--kit-color-bg-tertiary);

		.view-all-icon {
			transform: translateX(2px);
		}
	}
}

.view-all-icon {
	flex-shrink: 0;
	transition: transform 0.15s ease;
}
</style>

<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router';

export interface BreadcrumbItem {
	label: string;
	to?: RouteLocationRaw;
}

defineProps<{
	items: BreadcrumbItem[];
	ariaLabel?: string;
}>();
</script>

<template>
	<nav class="app-breadcrumbs" :aria-label="ariaLabel || 'Breadcrumbs'">
		<template v-for="(item, index) in items" :key="index">
			<NuxtLink
				v-if="item.to && index < items.length - 1"
				class="app-breadcrumbs__link"
				:to="item.to"
			>
				{{ item.label }}
			</NuxtLink>
			<span
				v-else
				class="app-breadcrumbs__current"
				:aria-current="index === items.length - 1 ? 'page' : undefined"
			>
				{{ item.label }}
			</span>
			<span
				v-if="index < items.length - 1"
				class="app-breadcrumbs__separator"
				aria-hidden="true"
			>
				/
			</span>
		</template>
	</nav>
</template>

<style scoped lang="less">
@import '~/assets/css/vars.less';

.app-breadcrumbs {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	gap: var(--spacing-sm);
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);

	&__link {
		color: inherit;
		text-decoration: none;
		transition: color 0.15s ease;

		&:hover {
			color: var(--color-primary);
			text-decoration: underline;
		}
	}

	&__separator {
		color: var(--color-text-muted);
		opacity: 0.5;
	}

	&__current {
		color: var(--color-text-secondary);
		font-weight: var(--font-weight-medium);
	}
}
</style>

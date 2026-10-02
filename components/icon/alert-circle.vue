<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 24 24"
		fill="none"
		stroke="currentColor"
		stroke-width="2"
		stroke-linecap="round"
		stroke-linejoin="round"
	>
		<circle cx="12" cy="12" r="10" />
		<line x1="12" y1="8" x2="12" y2="12" />
		<line x1="12" y1="16" x2="12.01" y2="16" />
	</svg>
</template>

<script setup lang="ts">
/*
 * Без width/height SVG растягивается на всю доступную ширину — `size="1em"`
 * раньше молча игнорировался. CSS-размер (как в tips/item.vue) по-прежнему
 * перебивает атрибуты, так что старые места не меняются.
 */
withDefaults(defineProps<{ size?: string | number }>(), {
	size: 24,
});
</script>

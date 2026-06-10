<!-- Tabler Icons (MIT) — https://tabler.io/icons -->
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
		:style="{ color }"
	>
		<path d="M17 3l4 4" />
		<path d="M19 5l-4.5 4.5" />
		<path d="M11.5 6.5l6 6" />
		<path d="M16.5 11.5l-6.5 6.5h-4v-4l6.5 -6.5" />
		<path d="M7.5 12.5l1.5 1.5" />
		<path d="M10.5 9.5l1.5 1.5" />
		<path d="M3 21l3 -3" />
	</svg>
</template>

<script setup lang="ts">
interface Props {
	size?: string | number;
	color?: string;
}

withDefaults(defineProps<Props>(), {
	size: 24,
	color: 'currentColor',
});
</script>

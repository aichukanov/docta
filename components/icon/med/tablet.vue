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
		<path d="M3 8a5 5 0 1 0 10 0a5 5 0 1 0 -10 0" />
		<path d="M13 17a4 4 0 1 0 8 0a4 4 0 1 0 -8 0" />
		<path d="M4.5 4.5l7 7" />
		<path d="M19.5 14.5l-5 5" />
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

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
		<path
			d="M3 12a6 6 0 0 1 6 -6h6a6 6 0 0 1 6 6a6 6 0 0 1 -6 6h-6a6 6 0 0 1 -6 -6"
		/>
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

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
			d="M4 12a2 2 0 0 1 2 -2h4a2 2 0 0 1 2 2v7a2 2 0 0 1 -2 2h-4a2 2 0 0 1 -2 -2l0 -7"
		/>
		<path d="M6 10v-4a1 1 0 0 1 1 -1h2a1 1 0 0 1 1 1v4" />
		<path d="M15 7h.01" />
		<path d="M18 9h.01" />
		<path d="M18 5h.01" />
		<path d="M21 3h.01" />
		<path d="M21 7h.01" />
		<path d="M21 11h.01" />
		<path d="M10 7h1" />
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

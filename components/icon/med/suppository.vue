<!-- Suppository / rectal form — bullet shape (custom, matches Tabler stroke style) -->
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
			d="M12 3c3.2 0 5 2.7 5 6v3.5c0 4 -2.2 7.8 -5 10.5c-2.8 -2.7 -5 -6.5 -5 -10.5v-3.5c0 -3.3 1.8 -6 5 -6z"
		/>
		<path d="M8.5 8.5c1.2 1 5.8 1 7 0" />
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

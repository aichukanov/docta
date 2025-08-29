<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 24 24"
		:style="{ color }"
	>
		<path
			stroke="currentColor"
			stroke-width="2"
			stroke-linecap="round"
			stroke-linejoin="round"
			d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"
		/>
		<circle cx="12" cy="10" r="3" stroke="currentColor" stroke-width="2" />
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

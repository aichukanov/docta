<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 24 24"
		:style="{ color }"
	>
		<circle cx="11" cy="11" r="8" stroke="currentColor" stroke-width="2" />
		<path d="m21 21-4.35-4.35" stroke="currentColor" stroke-width="2" />
	</svg>
</template>

<script setup lang="ts">
interface Props {
	size?: string | number;
	color?: string;
}

withDefaults(defineProps<Props>(), {
	size: 16,
	color: '#999',
});
</script>

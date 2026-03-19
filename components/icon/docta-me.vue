<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 18 18"
	>
		<path
			d="M9 0l2.76 5.59 6.17.9-4.47 4.35 1.05 6.13L9 14.6 3.49 16.97l1.05-6.13L0.07 6.49l6.17-.9L9 0z"
			fill="currentColor"
		/>
	</svg>
</template>

<script setup lang="ts">
interface Props {
	size?: string | number;
}

withDefaults(defineProps<Props>(), {
	size: 24,
});
</script>

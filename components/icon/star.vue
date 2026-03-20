<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 256 256"
		fill="none"
		:style="{ color }"
	>
		<path
			d="M128,16l30.6,66.4L232,93.2l-52,48.8L192.4,216,128,178.4,63.6,216l12.4-73.9L24,93.2l73.4-10.8Z"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
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

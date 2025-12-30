<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 256 256"
		:style="{ color }"
	>
		<circle
			cx="112"
			cy="112"
			r="80"
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<line
			x1="168.57"
			y1="168.57"
			x2="224"
			y2="224"
			fill="none"
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
	size: 16,
	color: '#999',
});
</script>

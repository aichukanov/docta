<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 256 256"
		fill="none"
		:style="{ color }"
	>
		<circle
			cx="128"
			cy="128"
			r="96"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<line
			x1="128"
			y1="120"
			x2="128"
			y2="176"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<circle cx="128" cy="84" r="10" fill="currentColor" />
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

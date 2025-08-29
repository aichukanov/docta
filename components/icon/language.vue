<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 256 256"
		:style="{ color }"
	>
		<rect width="256" height="256" fill="none" />
		<path
			d="M128,56a72,72,0,0,1,72,72c0,24.12-29.6,61.36-56.68,84.7a8,8,0,0,1-9.25,0C107.6,189.36,78,152.12,78,128A72,72,0,0,1,128,56Zm0,104a32,32,0,1,0-32-32A32,32,0,0,0,128,128Z"
			fill="currentColor"
		/>
		<path
			d="M128,24A104,104,0,1,0,232,128,104.11,104.11,0,0,0,128,24Zm0,192a88,88,0,1,1,88-88A88.1,88.1,0,0,1,128,216Z"
			fill="currentColor"
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

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
			d="M231.49,70.67,205,207.58a16,16,0,0,1-23.06,11.62L119,187.53a8,8,0,0,1-3.21-1.94L96,166.07,73.33,153.86a16,16,0,0,1,2.44-29.91l144-48A16,16,0,0,1,231.49,70.67Z"
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<line
			x1="96"
			y1="166.07"
			x2="48.09"
			y2="190.25"
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<line
			x1="96"
			y1="166.07"
			x2="112"
			y2="200"
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
	size: 24,
	color: 'currentColor',
});
</script>

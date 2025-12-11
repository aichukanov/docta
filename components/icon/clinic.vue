<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 256 256"
		fill="none"
		:style="{ color }"
	>
		<line
			x1="32"
			y1="216"
			x2="248"
			y2="216"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<path
			d="M48,216V48a8,8,0,0,1,8-8h96a8,8,0,0,1,8,8V216"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<path
			d="M160,120h64a8,8,0,0,1,8,8v88"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<line
			x1="104"
			y1="72"
			x2="104"
			y2="120"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<line
			x1="80"
			y1="96"
			x2="128"
			y2="96"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<polyline
			points="128 216 128 160 80 160 80 216"
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

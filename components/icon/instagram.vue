<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 256 256"
		:style="color ? { color } : undefined"
	>
		<rect width="256" height="256" fill="none" />
		<circle
			cx="128"
			cy="128"
			r="40"
			fill="none"
			stroke="currentColor"
			stroke-miterlimit="10"
			stroke-width="16"
		/>
		<rect
			x="32"
			y="32"
			width="192"
			height="192"
			rx="48"
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
		/>
		<circle cx="180" cy="76" r="12" />
	</svg>
</template>

<script setup lang="ts">
/*
 * Инлайновый style ставится ТОЛЬКО когда цвет передали пропсом. Раньше он
 * был всегда (`color: currentColor` по умолчанию) и молча перебивал любое
 * CSS-правило вида `svg { color: ... }` — инлайн сильнее правила. Без пропса
 * цвет наследуется, и стилизовать иконку из CSS снова можно.
 */
interface Props {
	size?: string | number;
	color?: string;
}

withDefaults(defineProps<Props>(), {
	size: 24,
});
</script>

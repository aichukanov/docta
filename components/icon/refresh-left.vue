<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 256 256"
		:style="color ? { color } : undefined"
	>
		<path
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
			d="M67.6 188.4a88 88 0 1 0 0-120.8L24 104"
		/>
		<path
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
			d="M24 64v40h40"
		/>
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

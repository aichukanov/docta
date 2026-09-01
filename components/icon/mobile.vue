<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 24 24"
		fill="none"
		stroke="currentColor"
		stroke-width="2"
		stroke-linecap="round"
		stroke-linejoin="round"
		:style="color ? { color } : undefined"
	>
		<rect x="5" y="2" width="14" height="20" rx="2" ry="2" />
		<line x1="12" y1="18" x2="12.01" y2="18" />
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

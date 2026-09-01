<template>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		:width="size"
		:height="size"
		viewBox="0 0 12 7"
		:style="color ? { color } : undefined"
	>
		<path
			fill="none"
			d="M1 1L6 6L11 1"
			stroke="currentColor"
			stroke-width="1.2"
			stroke-linecap="round"
			stroke-linejoin="round"
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

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
			d="M200 56L56 200"
		/>
		<path
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
			d="M72 72a16 16 0 1 1-32 0 16 16 0 0 1 32 0"
		/>
		<path
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
			d="M216 184a16 16 0 1 1-32 0 16 16 0 0 1 32 0"
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

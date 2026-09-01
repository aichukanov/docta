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
			d="M32 80h192v128H32z"
		/>
		<path
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
			d="M88 80V56h80v24"
		/>
		<path
			fill="none"
			stroke="currentColor"
			stroke-linecap="round"
			stroke-linejoin="round"
			stroke-width="16"
			d="M32 128h192"
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

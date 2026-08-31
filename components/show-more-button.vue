<script setup lang="ts">
withDefaults(
	defineProps<{
		label: string;
		/**
		 * Кнопка лежит поверх затухающего края контента, а не отдельной строкой
		 * под ним. Для блоков, свёрнутых по высоте (см. CollapsibleContent и таб
		 * купонов): строкой кнопка добавляет блоку ~60 px, а затухание и так
		 * показывает, что содержимое продолжается.
		 */
		overlay?: boolean;
	}>(),
	{ overlay: false },
);

defineEmits<{
	click: [];
}>();
</script>

<template>
	<button
		class="show-more-button"
		:class="{ 'show-more-button--overlay': overlay }"
		@click="$emit('click')"
	>
		{{ label }}
	</button>
</template>

<style lang="less" scoped>
.show-more-button {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	padding: var(--kit-spacing-md);
	background: transparent;
	border: 1px dashed var(--kit-color-border-light);
	border-radius: var(--kit-border-radius-md);
	color: var(--kit-color-primary);
	font-size: var(--kit-font-size-sm);
	font-family: inherit;
	font-weight: 500;
	cursor: pointer;
	transition:
		border-color 0.15s ease,
		background 0.15s ease;

	&:hover {
		border-color: var(--kit-color-primary);
		background: rgba(79, 70, 229, 0.04);
	}

	/* Родителю нужен position: relative — он владеет затуханием */
	&--overlay {
		position: absolute;
		left: 0;
		right: 0;
		bottom: 0;
		padding: var(--kit-spacing-sm);
		background: rgba(255, 255, 255, 0.85);
		backdrop-filter: blur(2px);
		border-color: var(--kit-color-border-secondary);
	}
}
</style>

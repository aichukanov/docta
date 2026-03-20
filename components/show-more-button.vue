<script setup lang="ts">
defineProps<{
	label: string;
}>();

defineEmits<{
	click: [];
}>();
</script>

<template>
	<button class="show-more-button" @click="$emit('click')">
		{{ label }}
	</button>
</template>

<style lang="less" scoped>
.show-more-button {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	padding: var(--spacing-md);
	background: transparent;
	border: 1px dashed var(--color-border-light);
	border-radius: var(--border-radius-md);
	color: var(--color-primary);
	font-size: var(--font-size-sm);
	font-family: inherit;
	font-weight: 500;
	cursor: pointer;
	transition: border-color 0.15s ease, background 0.15s ease;

	&:hover {
		border-color: var(--color-primary);
		background: rgba(79, 70, 229, 0.04);
	}
}
</style>

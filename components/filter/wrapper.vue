<template>
	<div class="filter-group">
		<label v-if="label" class="filter-label">{{ label }}</label>
		<slot />
	</div>
</template>

<script setup lang="ts">
defineProps<{
	label?: string;
}>();
</script>

<style scoped>
.filter-group {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
}

.filter-label {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}
</style>

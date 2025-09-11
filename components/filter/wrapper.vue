<template>
	<div class="filter-group">
		<label class="filter-label">{{ label }}</label>
		<slot />
	</div>
</template>

<script setup lang="ts">
defineProps<{
	label: string;
}>();
</script>

<style scoped>
.filter-group {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.filter-label {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}
</style>

<script setup lang="ts">
withDefaults(
	defineProps<{
		title: string;
		hint?: string;
	}>(),
	{
		hint: '',
	},
);
</script>

<template>
	<div class="admin-field-group">
		<div class="admin-field-group__header">
			<span class="admin-field-group__title">{{ title }}</span>
			<span v-if="hint" class="admin-field-group__hint">{{ hint }}</span>
		</div>
		<div class="admin-field-group__body">
			<slot />
		</div>
	</div>
</template>

<style scoped lang="less">
.admin-field-group {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
	padding: var(--spacing-md);
	border-radius: var(--border-radius-md);
	background: var(--color-bg-soft);
	border: 1px solid var(--color-border-light);
	box-shadow: var(--shadow-soft);
}

.admin-field-group__header {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
}

.admin-field-group__title {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
	font-size: var(--font-size-md);
}

.admin-field-group__hint {
	color: var(--color-text-muted);
	font-size: var(--font-size-sm);
}

.admin-field-group__body {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}
</style>

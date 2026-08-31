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
	gap: var(--kit-spacing-sm);
	padding: var(--kit-spacing-md);
	border-radius: var(--kit-border-radius-md);
	background: var(--kit-color-bg-soft);
	border: 1px solid var(--kit-color-border-light);
	box-shadow: var(--kit-shadow-soft);
}

.admin-field-group__header {
	display: flex;
	align-items: center;
	gap: var(--kit-spacing-sm);
}

.admin-field-group__title {
	font-weight: var(--kit-font-weight-semibold);
	color: var(--kit-color-text-primary);
	font-size: var(--kit-font-size-md);
}

.admin-field-group__hint {
	color: var(--kit-color-text-muted);
	font-size: var(--kit-font-size-sm);
}

.admin-field-group__body {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
}
</style>

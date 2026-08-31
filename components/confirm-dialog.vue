<script setup lang="ts">
const visible = defineModel<boolean>({ default: false });

const props = withDefaults(
	defineProps<{
		title?: string;
		confirmText?: string;
		cancelText?: string;
		confirmType?: 'primary' | 'danger';
	}>(),
	{
		title: '',
		confirmText: 'OK',
		cancelText: 'Cancel',
		confirmType: 'primary',
	},
);

const emit = defineEmits<{
	confirm: [];
	cancel: [];
}>();

const handleCancel = () => {
	visible.value = false;
	emit('cancel');
};
</script>

<template>
	<AppDialog v-model="visible" :title="title" width="400px">
		<div class="confirm-body">
			<slot />
		</div>
		<template #footer>
			<button class="confirm-btn cancel" @click="handleCancel">
				{{ cancelText }}
			</button>
			<button
				class="confirm-btn"
				:class="confirmType"
				@click="$emit('confirm')"
			>
				{{ confirmText }}
			</button>
		</template>
	</AppDialog>
</template>

<style scoped>
.confirm-body {
	font-size: var(--kit-font-size-base);
	color: var(--kit-color-text-secondary);
	line-height: 1.5;
}

.confirm-btn {
	padding: var(--kit-spacing-sm) var(--kit-spacing-lg);
	border-radius: var(--kit-border-radius-md);
	font-size: var(--kit-font-size-base);
	font-weight: var(--kit-font-weight-medium);
	cursor: pointer;
	border: none;
	transition: opacity var(--kit-transition-base);
}

.confirm-btn:hover {
	opacity: 0.85;
}

.confirm-btn.cancel {
	background: var(--kit-color-bg-secondary);
	color: var(--kit-color-text-secondary);
}

.confirm-btn.primary {
	background: var(--kit-color-primary);
	color: var(--kit-color-bg-primary);
}

.confirm-btn.danger {
	background: var(--kit-color-danger-dark, #991b1b);
	color: #fff;
}
</style>

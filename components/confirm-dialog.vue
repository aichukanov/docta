<script setup lang="ts">
const props = withDefaults(
	defineProps<{
		visible: boolean;
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
</script>

<template>
	<Teleport to="body">
		<Transition name="confirm-dialog">
			<div v-if="visible" class="confirm-overlay" @click.self="emit('cancel')">
				<div class="confirm-dialog" role="alertdialog" aria-modal="true">
					<h3 v-if="title" class="confirm-title">{{ title }}</h3>
					<div class="confirm-body">
						<slot />
					</div>
					<div class="confirm-actions">
						<button class="confirm-btn cancel" @click="emit('cancel')">
							{{ cancelText }}
						</button>
						<button
							class="confirm-btn"
							:class="confirmType"
							@click="emit('confirm')"
						>
							{{ confirmText }}
						</button>
					</div>
				</div>
			</div>
		</Transition>
	</Teleport>
</template>

<style scoped>
.confirm-overlay {
	position: fixed;
	inset: 0;
	z-index: 2000;
	display: flex;
	align-items: center;
	justify-content: center;
	background: rgba(0, 0, 0, 0.4);
	backdrop-filter: blur(4px);
}

.confirm-dialog {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	padding: var(--spacing-xl);
	max-width: 400px;
	width: calc(100% - 2 * var(--spacing-lg));
	box-shadow: var(--shadow-lg);
}

.confirm-title {
	margin: 0 0 var(--spacing-md);
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
}

.confirm-body {
	font-size: var(--font-size-base);
	color: var(--color-text-secondary);
	line-height: 1.5;
}

.confirm-actions {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
	margin-top: var(--spacing-xl);
}

.confirm-btn {
	padding: var(--spacing-sm) var(--spacing-lg);
	border-radius: var(--border-radius-md);
	font-size: var(--font-size-base);
	font-weight: var(--font-weight-medium);
	cursor: pointer;
	border: none;
	transition: opacity var(--transition-base), background-color var(--transition-base);
}

.confirm-btn:hover {
	opacity: 0.85;
}

.confirm-btn.cancel {
	background: var(--color-bg-secondary);
	color: var(--color-text-secondary);
}

.confirm-btn.primary {
	background: var(--color-primary);
	color: var(--color-bg-primary);
}

.confirm-btn.danger {
	background: var(--color-danger, #ef4444);
	color: #fff;
}

.confirm-dialog-enter-active,
.confirm-dialog-leave-active {
	transition: opacity 0.15s ease;
}

.confirm-dialog-enter-active .confirm-dialog,
.confirm-dialog-leave-active .confirm-dialog {
	transition: transform 0.15s ease;
}

.confirm-dialog-enter-from,
.confirm-dialog-leave-to {
	opacity: 0;
}

.confirm-dialog-enter-from .confirm-dialog {
	transform: scale(0.95);
}

.confirm-dialog-leave-to .confirm-dialog {
	transform: scale(0.95);
}
</style>

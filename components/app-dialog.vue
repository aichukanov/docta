<script setup lang="ts">
withDefaults(
	defineProps<{
		title?: string;
		width?: string;
	}>(),
	{
		title: '',
		width: '480px',
	},
);

const visible = defineModel<boolean>({ default: false });

function setAppInert(inert: boolean) {
	document.getElementById('__nuxt')?.toggleAttribute('inert', inert);
	document.body.style.overflow = inert ? 'hidden' : '';
}

watch(visible, (open) => setAppInert(open));

onBeforeUnmount(() => setAppInert(false));
</script>

<template>
	<Teleport to="body">
		<Transition name="app-dialog">
			<div v-if="visible" class="dialog-overlay" @click.self="visible = false">
				<div class="dialog-panel" :style="{ maxWidth: width }" role="dialog" aria-modal="true">
					<header v-if="title || $slots.header" class="dialog-header">
						<slot name="header">
							<h3 class="dialog-title">{{ title }}</h3>
						</slot>
						<button class="dialog-close" @click="visible = false" aria-label="Close">
							&times;
						</button>
					</header>
					<div class="dialog-body">
						<slot />
					</div>
					<footer v-if="$slots.footer" class="dialog-footer">
						<slot name="footer" />
					</footer>
				</div>
			</div>
		</Transition>
	</Teleport>
</template>

<style scoped>
.dialog-overlay {
	position: fixed;
	inset: 0;
	z-index: 2000;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: var(--spacing-lg);
	background: rgba(0, 0, 0, 0.4);
	backdrop-filter: blur(4px);
}

.dialog-panel {
	background: var(--color-bg-primary);
	border-radius: var(--border-radius-xl);
	width: 100%;
	max-height: calc(100vh - 2 * var(--spacing-lg));
	overflow-y: auto;
	box-shadow: var(--shadow-lg);
	display: flex;
	flex-direction: column;
}

.dialog-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: var(--spacing-lg) var(--spacing-xl);
	border-bottom: var(--border-width-thin) solid var(--color-border-secondary);
}

.dialog-title {
	margin: 0;
	font-size: var(--font-size-lg);
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-heading);
}

.dialog-close {
	background: none;
	border: none;
	font-size: 1.5rem;
	line-height: 1;
	color: var(--color-text-muted);
	cursor: pointer;
	padding: 0 var(--spacing-xs);
	transition: color var(--transition-base);
}

.dialog-close:hover {
	color: var(--color-text-primary);
}

.dialog-body {
	padding: var(--spacing-xl);
}

.dialog-footer {
	display: flex;
	justify-content: flex-end;
	gap: var(--spacing-sm);
	padding: var(--spacing-lg) var(--spacing-xl);
	border-top: var(--border-width-thin) solid var(--color-border-secondary);
}

.app-dialog-enter-active,
.app-dialog-leave-active {
	transition: opacity 0.15s ease;
}

.app-dialog-enter-active .dialog-panel,
.app-dialog-leave-active .dialog-panel {
	transition: transform 0.15s ease;
}

.app-dialog-enter-from,
.app-dialog-leave-to {
	opacity: 0;
}

.app-dialog-enter-from .dialog-panel {
	transform: scale(0.95);
}

.app-dialog-leave-to .dialog-panel {
	transform: scale(0.95);
}
</style>

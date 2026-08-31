<script setup lang="ts">
withDefaults(
	defineProps<{
		rows?: number;
		showMedia?: boolean;
	}>(),
	{
		rows: 3,
		showMedia: true,
	},
);
</script>

<template>
	<div class="skeleton-card" aria-hidden="true">
		<div class="skeleton-card__layout">
			<KitSkeleton
				v-if="showMedia"
				variant="image"
				class="skeleton-card__media"
			/>
			<div class="skeleton-card__body">
				<KitSkeleton variant="heading" width="45%" />
				<KitSkeleton variant="text" width="30%" />
				<KitSkeleton
					v-for="i in rows"
					:key="i"
					variant="text"
					:width="i === rows ? '40%' : '85%'"
				/>
			</div>
		</div>
	</div>
</template>

<style scoped>
.skeleton-card {
	box-sizing: border-box;
	background: var(--kit-color-surface-secondary);
	border: 1px solid var(--kit-color-border-primary);
	border-radius: var(--kit-border-radius-lg);
	padding: var(--kit-spacing-xl) var(--kit-spacing-2xl);
}

.skeleton-card__layout {
	display: flex;
	gap: var(--kit-spacing-xl);
}

/* Квадратная миниатюра вместо широкой заглушки-картинки из KitSkeleton */
.skeleton-card__media {
	width: 96px;
	height: 96px;
	border-radius: var(--kit-border-radius-lg);
	flex-shrink: 0;
}

.skeleton-card__body {
	flex: 1;
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
}

/*
 * Правила для prefers-reduced-motion здесь больше нет: KitSkeleton гасит
 * анимацию сам, а обходить его scoped-стили через :deep() не нужно.
 */
</style>

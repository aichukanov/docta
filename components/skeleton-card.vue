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
		<el-skeleton animated>
			<template #template>
				<div class="skeleton-card__layout">
					<el-skeleton-item
						v-if="showMedia"
						variant="image"
						class="skeleton-card__media"
					/>
					<div class="skeleton-card__body">
						<el-skeleton-item variant="h3" style="width: 45%" />
						<el-skeleton-item variant="text" style="width: 30%" />
						<el-skeleton-item
							v-for="i in rows"
							:key="i"
							variant="text"
							:style="{ width: i === rows ? '40%' : '85%' }"
						/>
					</div>
				</div>
			</template>
		</el-skeleton>
	</div>
</template>

<style scoped>
.skeleton-card {
	box-sizing: border-box;
	background: var(--color-surface-secondary);
	border: 1px solid var(--color-border-primary);
	border-radius: var(--border-radius-lg);
	padding: var(--spacing-xl) var(--spacing-2xl);
}

.skeleton-card__layout {
	display: flex;
	gap: var(--spacing-xl);
}

.skeleton-card__media {
	width: 96px;
	height: 96px;
	border-radius: var(--border-radius-lg);
	flex-shrink: 0;
}

.skeleton-card__body {
	flex: 1;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

@media (prefers-reduced-motion: reduce) {
	.skeleton-card :deep(.el-skeleton.is-animated .el-skeleton__item) {
		animation: none;
	}
}
</style>

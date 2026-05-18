<script setup lang="ts">
defineProps<{
	sectionId: string;
	title?: string;
	count?: number;
	link?: object;
}>();
</script>

<template>
	<section :id="sectionId" class="entity-section">
		<header v-if="title || $slots.actions" class="entity-section__header">
			<EntityPageSectionTitle
				v-if="title"
				:title="title"
				:count="count"
				:link="link"
			>
				<template v-if="$slots.icon" #icon>
					<slot name="icon" />
				</template>
			</EntityPageSectionTitle>
			<div v-if="$slots.actions" class="entity-section__actions">
				<slot name="actions" />
			</div>
		</header>
		<slot />
	</section>
</template>

<style lang="less" scoped>
.entity-section {
	scroll-margin-top: 120px;
	background: var(--color-bg-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-xl);
	overflow: hidden;
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.entity-section__header {
	display: flex;
	flex-wrap: wrap;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
}

.entity-section__actions {
	flex: 0 1 auto;
	min-width: 220px;
	max-width: 280px;
	margin-left: auto;
}

@media (max-width: 600px) {
	.entity-section__actions {
		flex: 1 1 100%;
		min-width: 0;
		max-width: 100%;
		margin-left: 0;
	}
}

@media (max-width: 500px) {
	.entity-section {
		padding: var(--spacing-md);
		border-radius: var(--border-radius-sm);
	}
}
</style>

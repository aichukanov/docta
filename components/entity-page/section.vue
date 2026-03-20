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
}

@media (max-width: 500px) {
	.entity-section {
		padding: var(--spacing-md);
		border-radius: var(--border-radius-sm);
	}
}
</style>

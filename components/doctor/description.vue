<script setup lang="ts">
defineProps<{
	description: string;
}>();
</script>

<template>
	<section v-if="description" class="doctor-description">
		<MarkedContent :content="description" class="doctor-description-content" />
	</section>
</template>

<style scoped lang="less">
.doctor-description {
	background: var(--color-surface-primary);
	border: 1px solid var(--color-border-light);
	border-radius: var(--border-radius-md);
	padding: var(--spacing-lg) var(--spacing-xl);
}

.doctor-description-content {
	color: var(--color-text-primary);
	line-height: 1.6;
}
</style>

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
	background: var(--kit-color-surface-primary);
	border: 1px solid var(--kit-color-border-light);
	border-radius: var(--kit-border-radius-md);
	padding: var(--kit-spacing-lg) var(--kit-spacing-xl);
}

.doctor-description-content {
	color: var(--kit-color-text-primary);
	line-height: 1.6;
}
</style>

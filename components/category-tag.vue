<script setup lang="ts">
defineProps<{
	small?: boolean;
}>();
</script>

<template>
	<span class="category-tag" :class="{ 'category-tag--small': small }">
		<slot />
	</span>
</template>

<style scoped>
.category-tag {
	display: inline-block;
	font-size: var(--font-size-base);
	color: var(--color-primary);
	background: var(--color-primary-bg);
	padding: var(--spacing-xs) var(--spacing-md);
	border-radius: var(--border-radius-sm);
	border: 1px solid rgba(79, 70, 229, 0.15);
}

.category-tag--small {
	font-size: var(--font-size-xs);
	padding: 2px var(--spacing-sm);
}
</style>

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
	font-size: var(--kit-font-size-base);
	color: var(--kit-color-primary);
	background: var(--kit-color-primary-bg);
	padding: var(--kit-spacing-xs) var(--kit-spacing-md);
	border-radius: var(--kit-border-radius-sm);
	border: 1px solid rgba(79, 70, 229, 0.15);
}

.category-tag--small {
	font-size: var(--kit-font-size-xs);
	padding: 2px var(--kit-spacing-sm);
}
</style>

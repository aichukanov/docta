<script setup lang="ts">
import { marked } from 'marked';

const props = defineProps<{
	content?: string | null;
}>();

const htmlContent = computed(() => {
	if (!props.content) {
		return '';
	}
	return marked.parse(props.content, {
		breaks: true,
		gfm: true,
	});
});
</script>

<template>
	<div v-if="htmlContent" class="marked-content" v-html="htmlContent"></div>
</template>

<style lang="less">
.marked-content {
	font-size: var(--font-size-md);
	line-height: 1.6;
	color: var(--color-text-primary);

	p {
		margin-bottom: var(--spacing-sm);
		&:last-child {
			margin-bottom: 0;
		}
	}

	ul,
	ol {
		margin-bottom: var(--spacing-sm);
		padding-left: var(--spacing-lg);
	}

	li {
		margin-bottom: var(--spacing-xs);
	}

	strong {
		font-weight: 600;
	}

	h1,
	h2,
	h3 {
		font-weight: 600;
		margin-top: var(--spacing-md);
		margin-bottom: var(--spacing-xs);
		color: var(--color-text-primary);
	}

	h1 {
		font-size: var(--font-size-xl);
	}
	h2 {
		font-size: var(--font-size-lg);
	}
	h3 {
		font-size: var(--font-size-md);
	}
}
</style>

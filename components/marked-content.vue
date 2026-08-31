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
	font-size: var(--kit-font-size-md);
	line-height: 1.6;
	color: var(--kit-color-text-primary);
	overflow-wrap: break-word;
	word-break: break-word;

	p {
		margin-bottom: var(--kit-spacing-sm);
		&:last-child {
			margin-bottom: 0;
		}
	}

	ul,
	ol {
		margin-bottom: var(--kit-spacing-sm);
		padding-left: var(--kit-spacing-lg);
	}

	li {
		margin-bottom: var(--kit-spacing-xs);
	}

	strong {
		font-weight: 600;
	}

	h1,
	h2,
	h3 {
		font-weight: 600;
		margin-top: var(--kit-spacing-md);
		margin-bottom: var(--kit-spacing-xs);
		color: var(--kit-color-text-primary);
	}

	h1 {
		font-size: var(--kit-font-size-xl);
	}
	h2 {
		font-size: var(--kit-font-size-lg);
	}
	h3 {
		font-size: var(--kit-font-size-md);
	}
}
</style>

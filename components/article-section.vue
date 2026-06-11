<script setup lang="ts">
// id для якорной навигации приходит обычным атрибутом
// и попадает на корневой <section> через наследование атрибутов
defineProps<{
	title: string;
	count: number;
}>();
</script>

<template>
	<section class="article-section">
		<h2 class="article-section__title">
			{{ title }}
			<span class="article-section__count">({{ count }})</span>
		</h2>
		<slot />
	</section>
</template>

<style scoped lang="less">
.article-section {
	// Якорная навигация: не прятать заголовок секции под шапкой сайта
	scroll-margin-top: calc(60px + var(--spacing-lg));
}

.article-section__title {
	margin: 0 0 var(--spacing-xl);
	font-size: var(--font-size-2xl);
	font-weight: var(--font-weight-semibold);
	letter-spacing: -0.01em;
	color: var(--color-text-heading);
}

.article-section__count {
	font-weight: var(--font-weight-normal);
	color: var(--color-text-muted);
}
</style>

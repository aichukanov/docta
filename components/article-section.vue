<script setup lang="ts">
// id для якорной навигации приходит обычным атрибутом
// и попадает на корневой <section> через наследование атрибутов
defineProps<{
	title: string;
	count?: number;
}>();
</script>

<template>
	<section class="article-section">
		<h2 class="article-section__title">
			{{ title }}
			<span v-if="count != null" class="article-section__count">
				({{ count }})
			</span>
		</h2>
		<slot />
	</section>
</template>

<style scoped lang="less">
.article-section {
	// Якорная навигация: не прятать заголовок секции под шапкой сайта
	scroll-margin-top: calc(60px + var(--kit-spacing-lg));
}

.article-section__title {
	margin: 0 0 var(--kit-spacing-xl);
	font-size: var(--kit-font-size-2xl);
	font-weight: var(--kit-font-weight-semibold);
	letter-spacing: -0.01em;
	color: var(--kit-color-text-heading);
}

.article-section__count {
	font-weight: var(--kit-font-weight-normal);
	color: var(--kit-color-text-muted);
}
</style>

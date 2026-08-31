<script setup lang="ts">
import { highlightParts } from '~/common/search-highlight';

const props = defineProps<{
	text: string | null | undefined;
	query?: string | null;
}>();

const parts = computed(() => highlightParts(props.text, props.query));
</script>

<template>
	<span
		><template v-for="(part, index) in parts" :key="index"
			><mark v-if="part.match" class="search-highlight">{{ part.text }}</mark
			><template v-else>{{ part.text }}</template></template
		></span
	>
</template>

<style lang="less" scoped>
/* Заливка вместо жирного: жирный конфликтует с весом заголовка карточки */
.search-highlight {
	background: var(--kit-color-search-highlight-bg);
	color: inherit;
	border-radius: var(--kit-border-radius-sm);
	padding: 0 1px;
}
</style>

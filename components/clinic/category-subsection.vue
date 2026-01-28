<script setup lang="ts">
const props = withDefaults(
	defineProps<{
		title: string;
		items: { id: number }[];
		initialLimit?: number;
	}>(),
	{
		initialLimit: 4,
	},
);

const { t } = useI18n();

const showAll = ref(false);

const totalCount = computed(() => props.items.length);
const hasMoreItems = computed(() => totalCount.value > props.initialLimit);
const hiddenCount = computed(() => totalCount.value - props.initialLimit);

const visibleItems = computed(() => {
	if (showAll.value || props.items.length <= props.initialLimit) {
		return props.items;
	}

	return props.items.slice(0, props.initialLimit);
});

const toggleShowAll = () => {
	showAll.value = !showAll.value;
};
</script>

<template>
	<div v-if="items.length > 0" class="category-subsection">
		<h3 class="category-title">{{ title }}</h3>
		<div class="items-grid">
			<slot v-for="item in visibleItems" :key="item.id" :item="item" />
		</div>
		<button v-if="hasMoreItems" class="show-more-button" @click="toggleShowAll">
			{{ showAll ? t('ShowLess') : t('ShowMore', { count: hiddenCount }) }}
		</button>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"ShowMore": "Show more ({count})",
		"ShowLess": "Show less"
	},
	"ru": {
		"ShowMore": "Показать ещё ({count})",
		"ShowLess": "Свернуть"
	},
	"de": {
		"ShowMore": "Mehr anzeigen ({count})",
		"ShowLess": "Weniger anzeigen"
	},
	"tr": {
		"ShowMore": "Daha fazla göster ({count})",
		"ShowLess": "Daha az göster"
	},
	"sr": {
		"ShowMore": "Prikaži više ({count})",
		"ShowLess": "Prikaži manje"
	},
	"sr-cyrl": {
		"ShowMore": "Прикажи више ({count})",
		"ShowLess": "Прикажи мање"
	}
}
</i18n>

<style lang="less" scoped>
.category-subsection {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.category-title {
	font-size: var(--font-size-md);
	font-weight: 600;
	color: var(--color-text-secondary);
	margin: 0;
	padding-bottom: var(--spacing-xs);
	border-bottom: 1px solid var(--color-border-light);
	font-family: system-ui, -apple-system, sans-serif;
}

.items-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: var(--spacing-sm);

	@media (max-width: 640px) {
		grid-template-columns: 1fr;
	}
}

.show-more-button {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	padding: var(--spacing-md);
	background: transparent;
	border: 1px dashed var(--color-border-light);
	border-radius: var(--border-radius-md);
	color: var(--color-primary);
	font-size: var(--font-size-sm);
	font-weight: 500;
	cursor: pointer;
	transition: all var(--transition-base);

	&:hover {
		border-color: var(--color-primary);
		background: rgba(79, 70, 229, 0.04);
	}
}
</style>

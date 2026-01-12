<script setup lang="ts">
const props = withDefaults(
	defineProps<{
		items: unknown[];
		initialLimit?: number;
	}>(),
	{
		initialLimit: 6,
	},
);

const { t } = useI18n();

const showAll = ref(false);

const totalCount = computed(() => props.items.length);
const hasMoreItems = computed(() => totalCount.value > props.initialLimit);
const hiddenCount = computed(() => totalCount.value - props.initialLimit);

const isHidden = (index: number) =>
	!showAll.value && index >= props.initialLimit;
</script>

<template>
	<div v-if="items.length > 0" class="section-content">
		<div class="items-grid">
			<div
				v-for="(item, index) in items"
				:key="index"
				:class="{ hidden: isHidden(index) }"
			>
				<slot :item="item" />
			</div>
		</div>
		<button
			v-if="hasMoreItems"
			class="show-more-button"
			@click="showAll = !showAll"
		>
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
.section-content {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.items-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: var(--spacing-sm);

	@media (max-width: 640px) {
		grid-template-columns: 1fr;
	}

	.hidden {
		display: none;
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

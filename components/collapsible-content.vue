<script setup lang="ts">
const props = withDefaults(
	defineProps<{
		maxHeight?: number;
	}>(),
	{
		maxHeight: 320,
	},
);

const { t } = useI18n();

const expanded = ref(false);
const isOverflowing = ref(false);
const contentRef = ref<HTMLElement | null>(null);
let observer: ResizeObserver | null = null;

const measure = () => {
	if (!contentRef.value) return;
	isOverflowing.value =
		contentRef.value.scrollHeight > props.maxHeight + 4;
};

onMounted(() => {
	if (!contentRef.value) return;
	measure();
	if (typeof ResizeObserver !== 'undefined') {
		observer = new ResizeObserver(measure);
		observer.observe(contentRef.value);
	}
});

onBeforeUnmount(() => {
	observer?.disconnect();
});

const wrapperStyle = computed(() => {
	if (!isOverflowing.value || expanded.value) return undefined;
	return { maxHeight: `${props.maxHeight}px` };
});
</script>

<template>
	<div class="collapsible-content">
		<div
			ref="contentRef"
			class="collapsible-content__inner"
			:class="{
				'collapsible-content__inner--collapsed':
					isOverflowing && !expanded,
			}"
			:style="wrapperStyle"
		>
			<slot />
		</div>
		<ShowMoreButton
			v-if="isOverflowing"
			:label="expanded ? t('ShowLess') : t('ShowMore')"
			@click="expanded = !expanded"
		/>
	</div>
</template>

<i18n lang="json">
{
	"en": { "ShowMore": "Show more", "ShowLess": "Show less" },
	"ru": { "ShowMore": "Показать ещё", "ShowLess": "Свернуть" },
	"de": { "ShowMore": "Mehr anzeigen", "ShowLess": "Weniger anzeigen" },
	"tr": { "ShowMore": "Daha fazla göster", "ShowLess": "Daha az göster" },
	"sr": { "ShowMore": "Prikaži više", "ShowLess": "Prikaži manje" },
	"sr-cyrl": { "ShowMore": "Прикажи више", "ShowLess": "Прикажи мање" }
}
</i18n>

<style lang="less" scoped>
.collapsible-content {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-md);
}

.collapsible-content__inner {
	position: relative;
	overflow: hidden;

	&--collapsed::after {
		content: '';
		position: absolute;
		left: 0;
		right: 0;
		bottom: 0;
		height: 80px;
		pointer-events: none;
		background: linear-gradient(
			to bottom,
			rgba(255, 255, 255, 0),
			var(--color-bg-primary)
		);
	}
}
</style>

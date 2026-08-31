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
// Есть ли что разворачивать — известно только после замера в браузере, поэтому
// от этого флага зависит ТОЛЬКО кнопка. Ограничение высоты от него не зависит.
const isOverflowing = ref(false);
const contentRef = ref<HTMLElement | null>(null);
let observer: ResizeObserver | null = null;

const measure = () => {
	if (!contentRef.value) return;
	// scrollHeight у обрезанного блока — полная высота содержимого, обрезка
	// max-height замеру не мешает.
	isOverflowing.value = contentRef.value.scrollHeight > props.maxHeight + 4;
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

// Обрезка ставится сразу на сервере: CSS-ограничение высоты замера не требует,
// а если ждать onMounted, блок сначала рендерится на полную высоту и после
// гидратации схлопывается — на странице врача это первая секция после
// героблока, и всё под ней прыгает вверх на сотни пикселей.
const wrapperStyle = computed(() =>
	expanded.value ? undefined : { maxHeight: `${props.maxHeight}px` },
);
</script>

<template>
	<div class="collapsible-content">
		<div class="collapsible-content__wrapper">
			<div
				ref="contentRef"
				class="collapsible-content__inner"
				:class="{
					'collapsible-content__inner--collapsed': isOverflowing && !expanded,
				}"
				:style="wrapperStyle"
			>
				<slot />
			</div>
			<!-- Пока свёрнуто, кнопка лежит на затухании; раскрытый блок ставит её
			     строкой под содержимым -->
			<ShowMoreButton
				v-if="isOverflowing && !expanded"
				overlay
				:label="t('ShowMore')"
				@click="expanded = true"
			/>
		</div>
		<ShowMoreButton
			v-if="isOverflowing && expanded"
			:label="t('ShowLess')"
			@click="expanded = false"
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
	gap: var(--kit-spacing-md);
}

.collapsible-content__wrapper {
	position: relative;
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
			var(--kit-color-bg-primary)
		);
	}
}
</style>

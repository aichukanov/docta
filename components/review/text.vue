<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';

const props = defineProps<{
	text?: string | null;
	originalText?: string | null;
	originalLanguage?: string;
}>();

// Слияние на уровне модуля, а не в setup: словарь отзывов константный, а этот
// компонент рендерится на каждый отзыв страницы. Ссылка общая для экземпляров.
const messages = combineI18nMessages([reviewsI18n]);

const { t } = useI18n({ useScope: 'local', messages });

const showingOriginal = ref(false);

const displayText = computed(() =>
	showingOriginal.value && props.originalText ? props.originalText : props.text,
);

const langName = computed(() => {
	if (!props.originalLanguage) return '';
	return props.originalLanguage.replace(/-.*$/, '').toUpperCase();
});
</script>

<template>
	<div class="review-text-block" v-if="displayText">
		<div class="review-text">{{ displayText }}</div>
		<button
			v-if="originalText"
			class="toggle-original-btn"
			@click="showingOriginal = !showingOriginal"
		>
			{{
				showingOriginal
					? t('ShowTranslation')
					: t('ShowOriginal', { lang: langName })
			}}
		</button>
	</div>
</template>

<style scoped>
.review-text {
	line-height: 1.6;
	color: var(--kit-color-text-primary);
	white-space: pre-wrap;
}

.toggle-original-btn {
	display: inline-block;
	margin-top: var(--kit-spacing-sm);
	padding: 0;
	border: none;
	background: none;
	color: var(--kit-color-primary);
	font-size: var(--kit-font-size-base);
	cursor: pointer;
	text-decoration: none;
}

.toggle-original-btn:hover {
	text-decoration: underline;
}
</style>

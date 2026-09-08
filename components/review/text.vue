<script setup lang="ts">
const props = defineProps<{
	text?: string | null;
	originalText?: string | null;
	originalLanguage?: string;
}>();

const { t } = useReviewsI18n();

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

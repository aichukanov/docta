<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';

// Слияние на уровне модуля, а не в setup: словарь отзывов константный, а этот
// компонент рендерится на каждый отзыв страницы. Ссылка общая для экземпляров.
const messages = combineI18nMessages([reviewsI18n]);

const { t } = useI18n({ useScope: 'local', messages });
</script>

<template>
	<span class="verified-badge" :title="t('VerifiedReviewHint')">
		<IconCheck :size="12" />
		{{ t('VerifiedReview') }}
	</span>
</template>

<style scoped>
.verified-badge {
	display: inline-flex;
	align-items: center;
	gap: var(--kit-spacing-xs);
	font-size: var(--kit-font-size-sm);
	font-weight: var(--kit-font-weight-medium);
	color: var(--kit-color-success-dark);
	background: var(--kit-color-success-bg);
	padding: 2px var(--kit-spacing-sm);
	border-radius: var(--kit-border-radius-sm);
	white-space: nowrap;
}
</style>

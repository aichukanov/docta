<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import { getReviewDateFormat } from '~/common/date-format';
import type { ReviewReply } from '~/interfaces/review';

defineProps<{
	reply: ReviewReply;
}>();

// Слияние на уровне модуля, а не в setup: словарь отзывов константный, а этот
// компонент рендерится на каждый отзыв страницы. Ссылка общая для экземпляров.
const messages = combineI18nMessages([reviewsI18n]);

const { t } = useI18n({ useScope: 'local', messages });
</script>

<template>
	<aside class="reply-item">
		<header class="reply-header">
			<strong class="reply-author">
				{{ t(`Replier_${reply.responderType}`) }}
			</strong>
			<time
				class="reply-date"
				v-if="reply.publishedAt"
				:datetime="reply.publishedAt"
			>
				<LocalizedDate
					:value="reply.publishedAt"
					:format="getReviewDateFormat(reply.provider)"
				/>
			</time>
		</header>
		<ReviewText
			:text="reply.text"
			:originalText="reply.originalText"
			:originalLanguage="reply.originalLanguage"
		/>
	</aside>
</template>

<style scoped>
.reply-item {
	padding: var(--kit-spacing-lg);
	background: var(--kit-color-bg-secondary);
	border-radius: var(--kit-border-radius-lg);
	margin-top: var(--kit-spacing-sm);
}

.reply-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: var(--kit-spacing-sm);
}

.reply-author {
	color: var(--kit-color-primary);
	font-size: var(--kit-font-size-md);
}

.reply-date {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-muted);
}
</style>

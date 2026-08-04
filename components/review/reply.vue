<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import { getReviewDateFormat } from '~/common/date-format';
import type { ReviewReply } from '~/interfaces/review';

defineProps<{
	reply: ReviewReply;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});
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
	padding: var(--spacing-lg);
	background: var(--color-bg-secondary);
	border-radius: var(--border-radius-lg);
	margin-top: var(--spacing-sm);
}

.reply-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: var(--spacing-sm);
}

.reply-author {
	color: var(--color-primary);
	font-size: var(--font-size-md);
}

.reply-date {
	font-size: var(--font-size-sm);
	color: var(--color-text-muted);
}
</style>

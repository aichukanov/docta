<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import type { ReviewReply } from '~/interfaces/review';

defineProps<{
	reply: ReviewReply;
}>();

const { t, locale } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});

const formatReviewDate = (dateString: string, provider: string) => {
	if (provider === 'google_maps') {
		const now = Date.now();
		const diff = now - new Date(dateString).getTime();
		const days = Math.floor(diff / 86_400_000);
		const weeks = Math.floor(days / 7);
		const months = Math.floor(days / 30);
		const years = Math.floor(days / 365);
		const rtf = new Intl.RelativeTimeFormat(locale.value, { numeric: 'auto' });
		if (years > 0) return rtf.format(-years, 'year');
		if (months > 0) return rtf.format(-months, 'month');
		if (weeks > 0) return rtf.format(-weeks, 'week');
		if (days > 0) return rtf.format(-days, 'day');
		return rtf.format(0, 'day');
	}
	return new Date(dateString).toLocaleDateString(locale.value, {
		year: 'numeric',
		month: 'long',
		day: 'numeric',
	});
};
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
				{{ formatReviewDate(reply.publishedAt, reply.provider) }}
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

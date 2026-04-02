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
	<div class="reply-item">
		<div class="reply-header">
			<div class="reply-author">
				{{ t(`Replier_${reply.responderType}`) }}
			</div>
			<div class="reply-date" v-if="reply.publishedAt">
				{{ formatReviewDate(reply.publishedAt, reply.provider) }}
			</div>
		</div>
		<ReviewText
			:text="reply.text"
			:originalText="reply.originalText"
			:originalLanguage="reply.originalLanguage"
		/>
	</div>
</template>

<style scoped>
.reply-item {
	padding: 1rem;
	background: #f8f9fa;
	border-radius: 8px;
	margin-top: 0.5rem;
}

.reply-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 0.5rem;
}

.reply-author {
	font-weight: 600;
	color: #007bff;
	font-size: 0.9rem;
}

.reply-date {
	font-size: 0.8rem;
	color: #666;
}
</style>

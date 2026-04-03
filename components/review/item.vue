<script setup lang="ts">
import { getRegionalQuery } from '~/common/url-utils';
import RatingStars from '~/components/rating-stars.vue';
import ReviewProviderIcon from '~/components/review-provider-icon.vue';
import reviewsI18n from '~/i18n/reviews';
import { combineI18nMessages } from '~/i18n/utils';
import type { Review } from '~/interfaces/review';

const props = defineProps<{
	review: Review;
	clinicInfo?: Record<number, { name: string; slug: string }>;
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

const clinic = computed(() => {
	const id = props.review.clinicId;
	return id && props.clinicInfo ? props.clinicInfo[id] : undefined;
});
</script>

<template>
	<article class="review-item">
		<!-- Header -->
		<header class="review-header">
			<div class="author-name">
				{{ review.author?.name || t('Anonymous') }}
			</div>
			<div class="review-meta">
				<RatingStars v-if="review.rating" :rating="review.rating" />
				<time
					class="review-date"
					v-if="review.publishedAt"
					:datetime="review.publishedAt"
				>
					{{ formatReviewDate(review.publishedAt, review.provider) }}
				</time>
				<span
					class="review-provider"
					v-if="review.provider && review.provider !== 'docta_me'"
				>
					<ReviewProviderIcon :provider="review.provider" />
					{{ t(`Provider_${review.provider}`) }}
				</span>
				<NuxtLink
					v-if="clinic"
					class="review-clinic"
					:to="{
						name: 'clinics-clinicSlug',
						params: { clinicSlug: clinic.slug },
						query: getRegionalQuery(locale),
					}"
				>
					{{ clinic.name }}
				</NuxtLink>
			</div>
		</header>

		<!-- Text -->
		<ReviewText
			:text="review.text"
			:originalText="review.originalText"
			:originalLanguage="review.originalLanguage"
		/>

		<!-- Replies -->
		<div
			class="review-replies"
			v-if="review.replies && review.replies.length > 0"
		>
			<ReviewReply
				v-for="reply in review.replies"
				:key="reply.id"
				:reply="reply"
			/>
		</div>
	</article>
</template>

<style scoped>
.review-item {
	width: 100%;
	box-sizing: border-box;
	padding: var(--spacing-xl);
	border: var(--border-width-thin) solid var(--color-border-secondary);
	border-radius: var(--border-radius-xl);
	background: var(--color-bg-primary);
	box-shadow: var(--shadow-sm);
}

.review-header {
	margin-bottom: var(--spacing-lg);
}

.author-name {
	font-weight: var(--font-weight-semibold);
	color: var(--color-text-primary);
	margin-bottom: var(--spacing-xs);
}

.review-meta {
	display: flex;
	align-items: center;
	gap: var(--spacing-md);
	font-size: var(--font-size-base);
	color: var(--color-text-muted);
}

.review-date {
	font-size: var(--font-size-base);
	color: var(--color-text-muted);
}

.review-provider {
	font-size: var(--font-size-sm);
	color: var(--color-primary);
	background: var(--color-primary-bg);
	padding: 0.2rem 0.5rem;
	border-radius: var(--border-radius-sm);
	display: inline-flex;
	align-items: center;
	gap: var(--spacing-xs);
}

.review-clinic {
	font-size: var(--font-size-base);
	color: var(--color-primary);
	text-decoration: none;
}

.review-clinic:hover {
	text-decoration: underline;
}

.review-replies {
	border-top: var(--border-width-thin) solid var(--color-border-secondary);
	padding-top: var(--spacing-lg);
	margin-top: var(--spacing-lg);
}
</style>

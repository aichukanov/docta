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
	<div class="review-item">
		<!-- Header -->
		<div class="review-header">
			<div class="author-name">
				{{ review.author?.name || t('Anonymous') }}
			</div>
			<div class="review-meta">
				<RatingStars v-if="review.rating" :rating="review.rating" />
				<span class="review-date" v-if="review.publishedAt">
					{{ formatReviewDate(review.publishedAt, review.provider) }}
				</span>
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
		</div>

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
	</div>
</template>

<style scoped>
.review-item {
	width: 100%;
	box-sizing: border-box;
	padding: 1.5rem;
	border: 1px solid #e9ecef;
	border-radius: 12px;
	background: #fff;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.review-header {
	margin-bottom: 1rem;
}

.author-name {
	font-weight: 600;
	color: #333;
	margin-bottom: 0.25rem;
}

.review-meta {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	font-size: 0.85rem;
	color: #666;
}

.review-date {
	font-size: 0.85rem;
	color: #666;
}

.review-provider {
	font-size: 0.8rem;
	color: #007bff;
	background: #e7f3ff;
	padding: 0.2rem 0.5rem;
	border-radius: 4px;
	display: inline-flex;
	align-items: center;
	gap: 0.25rem;
}

.review-clinic {
	font-size: 0.85rem;
	color: #007bff;
	text-decoration: none;
}

.review-clinic:hover {
	text-decoration: underline;
}

.review-replies {
	border-top: 1px solid #e9ecef;
	padding-top: 1rem;
	margin-top: 1rem;
}
</style>

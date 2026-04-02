<script setup lang="ts">
import RatingStars from '~/components/rating-stars.vue';
import reviewsI18n from '~/i18n/reviews';
import type { Rating, Review } from '~/interfaces/review';
import { combineI18nMessages } from '~/i18n/utils';

const props = withDefaults(
	defineProps<{
		reviews?: Review[];
		rating?: Rating;
		noReviewsText?: string;
		clinicInfo?: Record<number, { name: string; slug: string }>;
		allReviewsLink?: object;
	}>(),
	{
		reviews: () => [],
		rating: undefined,
		noReviewsText: undefined,
		clinicInfo: () => ({}),
		allReviewsLink: undefined,
	},
);

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});
</script>

<template>
	<div class="doctor-reviews">
		<!-- Rating summary -->
		<div class="rating-summary" v-if="rating && rating.totalReviews > 0">
			<RatingStars :rating="rating.averageRating" :show-value="true" />
			<span class="reviews-count">
				{{ t('BasedOn', { count: rating.totalReviews }) }}
			</span>
		</div>

		<!-- Reviews list -->
		<div class="reviews-list" v-if="reviews && reviews.length > 0">
			<ReviewItem
				v-for="review in reviews"
				:key="review.id"
				:review="review"
				:clinicInfo="clinicInfo"
			/>
		</div>

		<!-- All reviews link -->
		<NuxtLink
			v-if="allReviewsLink && rating"
			class="all-reviews-link"
			:to="allReviewsLink"
		>
			{{ t('AllReviews', { count: rating.totalReviews }) }}
		</NuxtLink>

		<!-- No reviews -->
		<div class="no-reviews" v-else-if="!reviews || reviews.length === 0">
			{{ noReviewsText || t('NoReviews') }}
		</div>
	</div>
</template>

<style scoped>
.doctor-reviews {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-lg);
}

.rating-summary {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	padding: 1rem;
	background: #f8f9fa;
	border-radius: 8px;
}

.reviews-count {
	font-size: 0.9rem;
	color: #666;
}

.reviews-list {
	display: flex;
	flex-direction: column;
	gap: 1.5rem;
}

.all-reviews-link {
	display: inline-flex;
	align-items: center;
	padding: 0.75rem 1.5rem;
	background: #007bff;
	color: #fff;
	border-radius: 8px;
	text-decoration: none;
	font-weight: 600;
	font-size: 0.95rem;
	transition: background-color 0.2s;
	align-self: center;
}

.all-reviews-link:hover {
	background: #0056b3;
}
</style>

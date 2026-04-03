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
	gap: var(--spacing-sm);
	padding: var(--spacing-lg);
	background: var(--color-bg-secondary);
	border-radius: var(--border-radius-lg);
}

.reviews-count {
	font-size: var(--font-size-md);
	color: var(--color-text-muted);
}

.reviews-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}

.all-reviews-link {
	display: inline-flex;
	align-items: center;
	padding: var(--spacing-md) var(--spacing-xl);
	background: var(--color-primary);
	color: var(--color-bg-primary);
	border-radius: var(--border-radius-lg);
	text-decoration: none;
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-lg);
	transition: background-color var(--transition-base);
	align-self: center;
}

.all-reviews-link:hover {
	background: var(--color-primary-dark);
}
</style>

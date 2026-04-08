<script setup lang="ts">
import reviewsI18n from '~/i18n/reviews';
import type { Review } from '~/interfaces/review';
import { combineI18nMessages } from '~/i18n/utils';

const props = withDefaults(
	defineProps<{
		reviews?: Review[];
		noReviewsText?: string;
		clinicInfo?: Record<number, { name: string; slug: string }>;
	}>(),
	{
		reviews: () => [],
		noReviewsText: undefined,
		clinicInfo: () => ({}),
	},
);

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});
</script>

<template>
	<div class="doctor-reviews">
		<!-- Reviews list -->
		<div class="reviews-list" v-if="reviews.length > 0">
			<ReviewItem
				v-for="review in reviews"
				:key="review.id"
				:review="review"
				:clinicInfo="clinicInfo"
			/>
		</div>

		<!-- No reviews -->
		<div class="no-reviews" v-else>
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

.reviews-list {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-xl);
}
</style>

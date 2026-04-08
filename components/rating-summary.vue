<script setup lang="ts">
import RatingStars from '~/components/rating-stars.vue';
import reviewsI18n from '~/i18n/reviews';
import type { Rating } from '~/interfaces/review';
import { combineI18nMessages } from '~/i18n/utils';

defineProps<{
	rating: Rating;
	hideWriteButton?: boolean;
}>();

defineEmits<{
	writeReview: [];
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: combineI18nMessages([reviewsI18n]),
});
</script>

<template>
	<div class="rating-summary">
		<div class="rating-info">
			<RatingStars :rating="rating.averageRating" :show-value="true" />
			<span class="reviews-count">
				{{ t('BasedOn', { count: rating.totalReviews }) }}
			</span>
		</div>
		<el-button
			v-if="!hideWriteButton"
			type="primary"
			@click="$emit('writeReview')"
		>
			{{ t('WriteReview') }}
		</el-button>
	</div>
</template>

<style scoped>
.rating-summary {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-md);
	padding: var(--spacing-lg);
	background: var(--color-bg-secondary);
	border-radius: var(--border-radius-lg);
}

.rating-info {
	display: flex;
	align-items: center;
	gap: var(--spacing-sm);
}

.reviews-count {
	font-size: var(--font-size-md);
	color: var(--color-text-muted);
}
</style>

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
		<!-- Ноль отзывов — вместо пустых звёзд приглашение оставить первый:
		     кнопка живёт только здесь, без этой ветки её не было бы вовсе -->
		<div v-if="rating.totalReviews > 0" class="rating-info">
			<RatingStars :rating="rating.averageRating" :show-value="true" />
			<span class="reviews-count">
				{{ t('BasedOn', { count: rating.totalReviews }) }}
			</span>
		</div>
		<span v-else class="reviews-count">{{ t('NoReviews') }}</span>
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
	flex-wrap: wrap;
	gap: var(--kit-spacing-md);
	padding: var(--kit-spacing-lg);
	background: var(--kit-color-bg-secondary);
	border-radius: var(--kit-border-radius-lg);
}

.rating-info {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	gap: var(--kit-spacing-sm);
}

.reviews-count {
	font-size: var(--kit-font-size-md);
	color: var(--kit-color-text-muted);
}
</style>

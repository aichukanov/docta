<script setup lang="ts">
import type { Review } from '~/interfaces/review';

withDefaults(
	defineProps<{
		reviews?: Review[];
		clinicInfo?: Record<number, { name: string; slug: string }>;
	}>(),
	{
		reviews: () => [],
		clinicInfo: () => ({}),
	},
);
</script>

<template>
	<!-- Пустое состояние — забота вызывающего (RatingSummary на детальной,
	     KitEmpty на странице отзывов): список чужих отзывов бывает пуст и при
	     наличии собственного, свой текст «нет отзывов» здесь врал бы -->
	<div class="doctor-reviews" v-if="reviews.length > 0">
		<div class="reviews-list">
			<ReviewItem
				v-for="review in reviews"
				:key="review.id"
				:review="review"
				:clinicInfo="clinicInfo"
			/>
		</div>
	</div>
</template>

<style scoped>
.doctor-reviews {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-lg);
}

.reviews-list {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-xl);
}
</style>

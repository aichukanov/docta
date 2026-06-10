<template>
	<div
		class="rating-stars"
		v-if="rating !== null && rating !== undefined"
		:aria-label="`${formattedRating} / 5`"
	>
		<span
			v-for="star in 5"
			:key="star"
			class="star"
			:class="{
				filled: star <= Math.floor(rating),
				half: star === Math.ceil(rating) && rating % 1 !== 0,
			}"
		>
			★
		</span>
		<span class="rating-value" v-if="showValue">{{ formattedRating }}</span>
		<NuxtLink
			v-if="showValue && count && countLink"
			class="rating-count rating-count--link"
			:to="countLink"
			>({{ count }})</NuxtLink
		>
		<span class="rating-count" v-else-if="showValue && count"
			>({{ count }})</span
		>
	</div>
</template>

<script setup lang="ts">
import type { RouteLocationRaw } from 'vue-router';

interface Props {
	rating: number | null;
	showValue?: boolean;
	count?: number | null;
	// Ссылка на отзывы: якорь #reviews или отдельная страница /reviews
	countLink?: RouteLocationRaw | null;
}

const props = withDefaults(defineProps<Props>(), {
	showValue: false,
	count: null,
	countLink: null,
});

const formattedRating = computed(() =>
	props.rating != null ? Number(props.rating).toFixed(1) : '',
);
</script>

<style scoped>
.rating-stars {
	display: inline-flex;
	align-items: center;
	gap: 2px;
}

.star {
	color: var(--color-text-muted);
	font-size: 1.2em;
	line-height: 1;
}

.star.filled {
	color: var(--color-rating);
}

.star.half {
	color: var(--color-text-muted);
	position: relative;
}

.star.half::after {
	content: '★';
	position: absolute;
	top: 0;
	left: 0;
	width: 50%;
	overflow: hidden;
	color: var(--color-rating);
}

.rating-value {
	margin-left: var(--spacing-xs);
	font-size: 0.9em;
	font-weight: var(--font-weight-medium);
	color: var(--color-text-primary);
}

.rating-count {
	margin-left: var(--spacing-xs);
	font-size: 0.9em;
	color: var(--color-text-muted);
}

.rating-count--link {
	text-decoration: none;
}

.rating-count--link:hover {
	color: var(--color-primary);
	text-decoration: underline;
}
</style>

<template>
	<div class="rating-stars" v-if="rating !== null && rating !== undefined">
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
		<span class="rating-value" v-if="showValue">({{ rating }})</span>
	</div>
</template>

<script setup lang="ts">
interface Props {
	rating: number | null;
	showValue?: boolean;
}

withDefaults(defineProps<Props>(), {
	showValue: false,
});
</script>

<style scoped>
.rating-stars {
	display: inline-flex;
	align-items: center;
	gap: 2px;
}

.star {
	color: #ddd;
	font-size: 1.2em;
	line-height: 1;
}

.star.filled {
	color: #ffc107;
}

.star.half {
	color: #ddd;
	position: relative;
}

.star.half::after {
	content: '★';
	position: absolute;
	top: 0;
	left: 0;
	width: 50%;
	overflow: hidden;
	color: #ffc107;
}

.rating-value {
	margin-left: 4px;
	font-size: 0.9em;
	color: #666;
}
</style>

<script setup lang="ts">
const rating = defineModel<number>({ default: 0 });

const hoverRating = ref(0);
const displayRating = computed(() => hoverRating.value || rating.value);
</script>

<template>
	<div class="stars-input">
		<button
			v-for="star in 5"
			:key="star"
			type="button"
			class="star-btn"
			:class="{ active: star <= displayRating }"
			@click="rating = star"
			@mouseenter="hoverRating = star"
			@mouseleave="hoverRating = 0"
		>
			★
		</button>
	</div>
</template>

<style scoped>
.stars-input {
	display: flex;
	gap: 4px;
}

.star-btn {
	background: none;
	border: none;
	cursor: pointer;
	font-size: 1.8rem;
	color: #ddd;
	padding: 0;
	line-height: 1;
	transition: color 0.15s, transform 0.15s;
}

.star-btn:hover {
	transform: scale(1.15);
}

.star-btn.active {
	color: #ffc107;
}
</style>

<template>
	<div class="doctor-marker" :class="{ 'forced-marker': isForced }">
		<div v-if="doctorCount === 1" class="marker-inner">
			<IconDoctor />
		</div>
		<div v-else class="marker-inner-group">
			{{ doctorCount }}
		</div>
	</div>
</template>

<script setup lang="ts">
defineProps<{
	doctorCount: number;
	isForced?: boolean;
}>();
</script>

<style scoped>
.doctor-marker {
	position: absolute;
	width: 40px;
	height: 40px;
	cursor: pointer;
	transform: translate(-50%, -50%);
	z-index: 1000;
	transition: all 0.2s ease;
}

.doctor-marker:hover {
	transform: translate(-50%, -50%) scale(1.1);
	z-index: 1001;
}

.doctor-marker.forced-marker {
	animation: pulse 2s infinite;
	border: 3px solid var(--color-secondary);
}

/* Одиночный врач */
.doctor-marker:has(.marker-inner) {
	background: var(--color-primary);
	border-radius: var(--border-radius-lg);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

/* Группа врачей */
.doctor-marker:has(.marker-inner-group) {
	background: var(--color-primary);
	border-radius: var(--border-radius-full);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

.marker-inner,
.marker-inner-group {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	height: 100%;
	color: var(--color-bg-primary);
	font-family: system-ui, -apple-system, sans-serif;
}

.marker-inner-group {
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-sm);
}

@keyframes pulse {
	0% {
		box-shadow: var(--shadow-hover);
	}
	50% {
		box-shadow: var(--shadow-lg);
	}
	100% {
		box-shadow: var(--shadow-hover);
	}
}
</style>

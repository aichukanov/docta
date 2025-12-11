<template>
	<div class="clinic-service-marker" :class="{ 'is-icon': showIcon }">
		<div class="marker-inner-group">
			<IconClinic v-if="showIcon" :size="20" color="white" />
			<template v-else>{{ clinicServiceCount }}</template>
		</div>
	</div>
</template>

<script setup lang="ts">
defineProps<{
	clinicServiceCount: number;
	showIcon?: boolean;
}>();
</script>

<style scoped>
.clinic-service-marker {
	position: absolute;
	width: 40px;
	height: 40px;
	cursor: pointer;
	transform: translate(-50%, -50%);
	z-index: 1000;
	transition: all 0.2s ease;
}

.clinic-service-marker:hover {
	transform: translate(-50%, -50%) scale(1.1);
	z-index: 1001;
}

/* Одиночный врач */
.clinic-service-marker:has(.marker-inner) {
	background: var(--color-primary);
	border-radius: var(--border-radius-lg);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

/* Группа врачей */
.clinic-service-marker:has(.marker-inner-group) {
	background: var(--color-primary);
	border-radius: var(--border-radius-full);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

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

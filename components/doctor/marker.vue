<template>
	<Teleport v-if="teleportTarget && hasValidData" :to="teleportTarget">
		<div
			class="doctor-marker"
			:class="{ 'forced-marker': isForced }"
			@click="handleClick"
		>
			<div v-if="isSingleDoctor" class="marker-inner">
				<IconDoctor class="doctor-icon" />
			</div>
			<div v-else class="marker-inner-group">
				{{ doctorCount }}
			</div>
		</div>
	</Teleport>
</template>

<script setup lang="ts">
import type { DoctorWithClinics, DoctorClinicFull } from '~/interfaces/doctor';

const props = defineProps<{
	doctors: DoctorWithClinics[];
	clinics: DoctorClinicFull[];
	location: { lat: number; lng: number };
	teleportTarget: string | null;
	isForced?: boolean;
}>();

const emit = defineEmits<{
	markerClick: [
		data: {
			doctors: DoctorWithClinics[];
			clinics: DoctorClinicFull[];
			location: { lat: number; lng: number };
		},
	];
}>();

// Computed properties with safety checks
const doctorCount = computed(() => props.doctors?.length || 0);
const isSingleDoctor = computed(() => doctorCount.value === 1);

// Safety check for valid data
const hasValidData = computed(
	() =>
		props.doctors &&
		props.doctors.length > 0 &&
		props.clinics &&
		props.clinics.length > 0,
);

const handleClick = () => {
	if (!hasValidData.value) {
		console.warn('Marker clicked with invalid data');
		return;
	}

	emit('markerClick', {
		doctors: props.doctors,
		clinics: props.clinics,
		location: props.location,
	});
};
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

.doctor-icon {
	width: 24px;
	height: 24px;
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

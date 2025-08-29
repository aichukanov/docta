<template>
	<div class="markers-container">
		<DoctorMarker
			v-for="marker in validMarkers"
			:key="marker.id"
			:doctors="marker.doctors"
			:clinics="marker.clinics"
			:location="marker.location"
			:teleport-target="`#marker-${marker.id}`"
			:is-forced="marker.isForced"
			@marker-click="handleMarkerClick"
		/>
	</div>
</template>

<script setup lang="ts">
import type { DoctorWithClinics, DoctorClinicFull } from '~/interfaces/doctor';

export interface MarkerData {
	id: string;
	doctors: DoctorWithClinics[];
	clinics: DoctorClinicFull[];
	location: { lat: number; lng: number };
	isForced?: boolean;
}

const props = defineProps<{
	markers: MarkerData[];
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

// Фильтруем только валидные маркеры
const validMarkers = computed(() => {
	return (
		props.markers?.filter(
			(marker) =>
				marker &&
				marker.doctors &&
				marker.doctors.length > 0 &&
				marker.clinics &&
				marker.clinics.length > 0 &&
				marker.id &&
				marker.location,
		) || []
	);
});

const handleMarkerClick = (data: {
	doctors: DoctorWithClinics[];
	clinics: DoctorClinicFull[];
	location: { lat: number; lng: number };
}) => {
	emit('markerClick', data);
};
</script>

<style scoped>
.markers-container {
	/* Контейнер невидим, маркеры телепортируются в нужные места */
	display: none;
}
</style>

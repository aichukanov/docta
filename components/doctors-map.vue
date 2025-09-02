<template>
	<div class="doctors-map-container">
		<div ref="mapContainer" class="map">
			<div v-if="isLoading" class="map-loading">
				<p>{{ t('MapLoading') }}</p>
			</div>
		</div>

		<template v-if="isTeleportReady">
			<Teleport
				v-for="clinic in clinicsWithDoctors"
				:key="clinic.id"
				:to="`#${getClinicMarkerId(clinic.id)}`"
			>
				<DoctorMarker
					:doctorCount="clinic.doctors.length"
					:isForced="false"
					@click.stop="openClinicPopup(clinic)"
				/>
			</Teleport>

			<Teleport v-if="selectedClinic" to="#popup-container">
				<MapClinicPopup
					:clinic="selectedClinic"
					:doctors="selectedClinicDoctors"
				/>
			</Teleport>
		</template>
	</div>
</template>

<script setup lang="ts">
import type { ClinicData, DoctorData } from '~/interfaces/doctor';
import type { MarkerData } from '~/interfaces/marker';
import { getClinicMarkerId } from '~/common/utils';

const props = defineProps<{
	clinics: ClinicData[];
	doctors: DoctorData[];
}>();

const { t } = useI18n();

const { isLoading, initializeMap, addMarker, markers, openPopup } =
	useLeaflet();

const markerList = ref<MarkerData[]>([]);
const mapContainer = ref<HTMLElement | null>(null);
const isTeleportReady = ref(false);

const selectedClinic = ref<ClinicData | null>(null);

const clinicsWithDoctors = computed(() => {
	return props.clinics
		.map((clinic) => {
			return {
				...clinic,
				doctors: getClinicDoctors(clinic),
			};
		})
		.filter((clinic) => clinic.doctors.length > 0);
});

const getClinicDoctors = (clinic: ClinicData) => {
	return props.doctors.filter((doctor) =>
		doctor.clinicIds.split(',').map(Number).includes(clinic.id),
	);
};

const selectedClinicDoctors = computed(() => {
	return selectedClinic.value ? getClinicDoctors(selectedClinic.value) : [];
});

const openClinicPopup = async (clinic: ClinicData) => {
	selectedClinic.value = null;
	await nextTick();

	openPopup(clinic.latitude, clinic.longitude);
	selectedClinic.value = clinic;
};

// Инициализация карты при монтировании
onMounted(async () => {
	if (mapContainer.value) {
		await initializeMap(mapContainer.value);

		props.clinics.forEach((clinic) => {
			addMarker(
				getClinicMarkerId(clinic.id),
				clinic.latitude,
				clinic.longitude,
			);
		});

		isTeleportReady.value = true;
	}
});

defineExpose({
	openClinicPopup,
});
</script>

<style>
.doctors-map-container {
	width: 100%;
	height: 100%;
	position: relative;
}

.map {
	width: 100%;
	height: 100%;
	position: relative;
}

.map-loading {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	z-index: var(--z-raised);
	background: var(--color-bg-primary);
	padding: var(--spacing-lg) var(--spacing-2xl);
	border-radius: var(--border-radius-md);
	box-shadow: var(--shadow-md);
}

.map-wrapper {
	width: 100%;
	height: 100%;
	position: relative;
}

/* Стили для маркеров врачей */
/* .doctor-marker {
	background: var(--color-primary);
	border-radius: var(--border-radius-lg);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

.doctor-marker-group {
	background: var(--color-primary);
	border-radius: var(--border-radius-full);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

.marker-inner {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	height: 100%;
	color: var(--color-bg-primary);
	font-family: system-ui, -apple-system, sans-serif;
}

.marker-inner-group {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	height: 100%;
	color: var(--color-bg-primary);
	font-family: system-ui, -apple-system, sans-serif;
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-sm);
}

.forced-marker {
	animation: pulse 2s infinite;
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
} */
</style>

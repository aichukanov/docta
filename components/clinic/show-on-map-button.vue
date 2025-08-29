<template>
	<DsButton
		variant="primary"
		size="sm"
		@click="showOnMap()"
		:title="t('ShowOnMap')"
	>
		<template #icon>
			<IconMapPin :size="20" />
		</template>
		{{ t('ShowOnMap') }}
	</DsButton>
</template>

<script setup lang="ts">
import type { DoctorClinicFull } from '~/interfaces/doctor';

const props = defineProps<{
	clinic: DoctorClinicFull;
	locationIndex?: number;
	doctorId?: number;
}>();

const { t } = useI18n();

const emit = defineEmits<{
	showOnMap: [clinic: DoctorClinicFull, coordinates: [number, number]];
}>();

function showOnMap() {
	// Проверяем что координаты определены
	if (!props.clinic.latitude || !props.clinic.longitude) {
		console.warn('Clinic coordinates are not defined');
		return;
	}

	const coordinates: [number, number] = [
		props.clinic.latitude,
		props.clinic.longitude,
	];

	// Эмитим событие для показа клиники на карте
	emit('showOnMap', props.clinic, coordinates);

	// Прокручиваем к карте на десктопе
	const mapContainer = document.querySelector('.doctor-map-sidebar');
	if (mapContainer && window.innerWidth > 1024) {
		mapContainer.scrollIntoView({
			behavior: 'smooth',
			block: 'start',
		});
	}
}
</script>

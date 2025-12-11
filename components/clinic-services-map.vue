<script setup lang="ts">
import { getClinicMarkerId } from '~/common/utils';
import type { ClinicData, ClinicServiceItem } from '~/interfaces/clinic';

const props = defineProps<{
	clinics: ClinicData[];
	services: ClinicServiceItem[];
}>();

const emit = defineEmits<{
	(e: 'ready'): void;
}>();

const { t } = useI18n();

const { isLoading, initializeMap, addMarker, openPopup, centerOnLocations } =
	useLeaflet();

const mapContainer = ref<HTMLElement | null>(null);
const isTeleportReady = ref(false);

const selectedClinic = ref<ClinicData | null>(null);

const isClinicMode = computed(() => props.services.length === 0);

const clinicsWithServices = computed<
	Array<ClinicData & { services: number[] }>
>(() => {
	// Если services пустой, показываем все клиники (для страницы клиник)
	if (props.services.length === 0) {
		return props.clinics.map((clinic) => ({
			...clinic,
			services: [],
		}));
	}

	return props.clinics
		.map((clinic) => {
			return {
				...clinic,
				services: getClinicServices(clinic),
			};
		})
		.filter((clinic) => clinic.services.length > 0);
});

const getClinicServices = (clinic: ClinicData): number[] => {
	return props.services.filter(({ clinicIds }) =>
		clinicIds.split(',').map(Number).includes(clinic.id),
	);
};

const selectedClinicServices = computed(() => {
	return selectedClinic.value ? getClinicServices(selectedClinic.value) : [];
});

const shouldScrollToMap = (): boolean => {
	if (!mapContainer.value || typeof window === 'undefined') return false;

	const rect = mapContainer.value.getBoundingClientRect();
	const viewportHeight =
		window.innerHeight || document.documentElement.clientHeight;
	const visibleTop = Math.max(rect.top, 0);
	const visibleBottom = Math.min(rect.bottom, viewportHeight);
	const visibleHeight = Math.max(0, visibleBottom - visibleTop);
	return visibleHeight < rect.height / 2;
};

const scrollToMap = () => {
	if (shouldScrollToMap()) {
		mapContainer.value?.scrollIntoView({ behavior: 'smooth' });
	}
};

const openClinicPopup = async (clinic: ClinicData) => {
	selectedClinic.value = null;
	await nextTick();

	openPopup(clinic.latitude, clinic.longitude);
	selectedClinic.value = clinic;

	scrollToMap();
};

const centerOnClinics = (clinics: ClinicData[]) => {
	centerOnLocations(
		clinics.map((clinic) => [clinic.latitude, clinic.longitude]),
	);

	scrollToMap();
};

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
		emit('ready');
	}
});

defineExpose({
	openClinicPopup,
	centerOnClinics,
	centerOnLocations,
});
</script>

<template>
	<div class="clinic-services-map-container">
		<div ref="mapContainer" class="clinic-services-map">
			<div v-if="isLoading" class="map-loading">
				<p>{{ t('MapLoading') }}</p>
			</div>
		</div>

		<template v-if="isTeleportReady">
			<Teleport
				v-for="clinic in clinicsWithServices"
				:key="clinic.id"
				:to="`#${getClinicMarkerId(clinic.id)}`"
			>
				<MapMarker
					:clinicServiceCount="clinic.services.length"
					:showIcon="isClinicMode"
					@click.stop="openClinicPopup(clinic)"
				/>
			</Teleport>

			<Teleport v-if="selectedClinic" to="#popup-container">
				<MapClinicPopup
					:clinic="selectedClinic"
					:services="selectedClinicServices"
				>
					<template #default="{ service }">
						<slot name="map-clinic-popup">
							<ServiceInfo :service="service" />
						</slot>
					</template>
				</MapClinicPopup>
			</Teleport>
		</template>
	</div>
</template>

<i18n lang="json">
{
	"en": {
		"MapLoading": "Loading map"
	},
	"ru": {
		"MapLoading": "Загрузка карты"
	},
	"de": {
		"MapLoading": "Karte wird geladen"
	},
	"tr": {
		"MapLoading": "Harita yükleniyor"
	},
	"sr": {
		"MapLoading": "Učitava mapu"
	},
	"ba": {
		"MapLoading": "Učitava mapu"
	},
	"me": {
		"MapLoading": "Učitava mapu"
	}
}
</i18n>

<style>
.clinic-services-map-container {
	width: 100%;
	min-width: min(400px, 100%);
	height: 100%;
	min-height: 500px;
	position: relative;
}

.clinic-services-map {
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
</style>

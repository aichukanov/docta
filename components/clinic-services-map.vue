<script setup lang="ts">
import { getClinicMarkerId } from '~/common/utils';
import type { ClinicData, ClinicServiceItem } from '~/interfaces/clinic';

const props = defineProps<{
	clinics: ClinicData[];
	services: ClinicServiceItem[];
	showAllClinics?: boolean;
	detailsRouteName?: string;
	detailsParamName?: string;
}>();

const emit = defineEmits<{
	(e: 'ready'): void;
}>();

const { t } = useI18n();

const {
	isLoading,
	initializeMap,
	addMarker,
	removeMarker,
	markers,
	openPopup,
	centerOnLocations,
} = useLeaflet();

const mapContainer = ref<HTMLElement | null>(null);
const isTeleportReady = ref(false);

const selectedClinic = ref<ClinicData | null>(null);

// Реактивный Set для отслеживания существующих маркеров
const existingMarkerIds = ref(new Set<string>());

const isClinicMode = computed(() => props.showAllClinics);

const clinicsWithServices = computed<
	Array<ClinicData & { services: number[] }>
>(() => {
	// Режим клиник: показываем все переданные клиники
	if (props.showAllClinics) {
		return props.clinics.map((clinic) => ({
			...clinic,
			services: [],
		}));
	}

	// Режим услуг: показываем только клиники с услугами из списка
	return props.clinics
		.map((clinic) => {
			return {
				...clinic,
				services: getClinicServices(clinic),
			};
		})
		.filter((clinic) => clinic.services.length > 0);
});

// Клиники с существующими маркерами для безопасного Teleport
const clinicsWithMarkers = computed(() => {
	return clinicsWithServices.value.filter((clinic) =>
		existingMarkerIds.value.has(getClinicMarkerId(clinic.id)),
	);
});

const getClinicServices = (clinic: ClinicData): ClinicServiceItem[] => {
	return props.services.filter(
		({ clinicIds }) =>
			clinicIds && clinicIds.split(',').map(Number).includes(clinic.id),
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
		mapContainer.value?.scrollIntoView({ behavior: 'smooth', block: 'end' });
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

const syncMarkers = () => {
	const currentMarkerIds = new Set(markers.keys());
	const newClinicIds = new Set(
		props.clinics.map((clinic) => getClinicMarkerId(clinic.id)),
	);

	// Удаляем маркеры для клиник, которых больше нет в списке
	currentMarkerIds.forEach((markerId) => {
		if (!newClinicIds.has(markerId)) {
			removeMarker(markerId);
		}
	});

	// Добавляем маркеры для новых клиник
	props.clinics.forEach((clinic) => {
		const markerId = getClinicMarkerId(clinic.id);
		if (!currentMarkerIds.has(markerId)) {
			addMarker(markerId, clinic.latitude, clinic.longitude);
		}
	});

	// Обновляем реактивный Set существующих маркеров
	existingMarkerIds.value = new Set(markers.keys());
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

		// Инициализируем Set существующих маркеров
		existingMarkerIds.value = new Set(markers.keys());

		isTeleportReady.value = true;
		emit('ready');

		// Следим за изменениями списка клиник
		watch(
			() => props.clinics,
			() => {
				syncMarkers();
			},
			{ deep: true },
		);
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
				v-for="clinic in clinicsWithMarkers"
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
						<slot name="map-clinic-popup" :service="service">
							<ServiceInfo
								:service="service"
								:detailsRouteName="detailsRouteName"
								:detailsParamName="detailsParamName"
							/>
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
	"sr-cyrl": {
		"MapLoading": "Учитава мапу"
	}
}
</i18n>

<style>
.clinic-services-map-container {
	width: 100%;
	min-width: min(400px, 100%);
	height: 100%;
	min-height: inherit;
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

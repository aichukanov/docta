<script setup lang="ts">
import { getClinicMarkerId, getLocalizedName } from '~/common/utils';
import type { ClinicData } from '~/interfaces/clinic';

// Полноразмерная карта клиник (режим «Карта» на /clinics): кластеризация
// маркеров, попап с названием/адресом/ссылкой. В отличие от
// clinic-services-map.vue маркеры — статичный HTML (см. AddMarkerOptions.html).
const props = defineProps<{
	clinics: ClinicData[];
}>();

const { t, locale } = useI18n();
const { trackEvent } = useAnalytics();

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

const clinicsWithCoords = computed(() =>
	props.clinics.filter((clinic) => clinic.latitude && clinic.longitude),
);

// Иконка повторяет components/icon/clinic.vue (там Vue-компонент,
// здесь нужен статичный HTML для divIcon)
const MARKER_SVG = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 256 256" fill="none" aria-hidden="true">
	<line x1="32" y1="216" x2="248" y2="216" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<path d="M48,216V48a8,8,0,0,1,8-8h96a8,8,0,0,1,8,8V216" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<path d="M160,120h64a8,8,0,0,1,8,8v88" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<line x1="104" y1="72" x2="104" y2="120" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<line x1="80" y1="96" x2="128" y2="96" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
	<polyline points="128 216 128 160 80 160 80 216" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/>
</svg>`;

const markerHtml = `<div class="clinics-map-marker">${MARKER_SVG}</div>`;

const openClinicPopup = async (clinic: ClinicData) => {
	selectedClinic.value = null;
	await nextTick();

	openPopup(clinic.latitude, clinic.longitude);
	selectedClinic.value = clinic;
};

const syncMarkers = () => {
	const nextIds = new Set(
		clinicsWithCoords.value.map((clinic) => getClinicMarkerId(clinic.id)),
	);

	[...markers.keys()].forEach((markerId) => {
		if (!nextIds.has(markerId)) {
			removeMarker(markerId);
		}
	});

	clinicsWithCoords.value.forEach((clinic) => {
		const markerId = getClinicMarkerId(clinic.id);
		if (!markers.has(markerId)) {
			addMarker(markerId, clinic.latitude, clinic.longitude, {
				title: getLocalizedName(clinic, locale.value),
				html: markerHtml,
				onClick: () => {
					trackEvent('map_marker_clicked', {
						entity_type: 'clinic',
						entity_id: clinic.id,
						entity_slug: clinic.slug,
					});
					openClinicPopup(clinic);
				},
			});
		}
	});
};

const fitToClinics = () => {
	centerOnLocations(
		clinicsWithCoords.value.map((clinic) => [
			clinic.latitude,
			clinic.longitude,
		]),
	);
};

onMounted(async () => {
	if (!mapContainer.value) return;

	await initializeMap(mapContainer.value, { cluster: true });
	syncMarkers();
	fitToClinics();
	isTeleportReady.value = true;

	// Карта монтируется по переключателю «Карта» — mount и есть «открытие»
	trackEvent('map_opened', { markers_count: clinicsWithCoords.value.length });

	watch(
		() => props.clinics,
		() => {
			syncMarkers();
			fitToClinics();
		},
		{ deep: true },
	);
});
</script>

<template>
	<div class="clinics-map-view">
		<div ref="mapContainer" class="clinics-map-view__map">
			<div v-if="isLoading" class="map-loading">
				<p>{{ t('MapLoading') }}</p>
			</div>
		</div>

		<Teleport
			v-if="isTeleportReady && selectedClinic"
			to="#popup-container"
		>
			<MapClinicPopup :clinic="selectedClinic" :services="[]" />
		</Teleport>
	</div>
</template>

<i18n lang="json">
{
	"en": { "MapLoading": "Loading map" },
	"ru": { "MapLoading": "Загрузка карты" },
	"de": { "MapLoading": "Karte wird geladen" },
	"tr": { "MapLoading": "Harita yükleniyor" },
	"sr": { "MapLoading": "Učitava mapu" },
	"sr-cyrl": { "MapLoading": "Учитава мапу" }
}
</i18n>

<style>
/* Не scoped: маркеры и кластеры рендерятся Leaflet'ом вне Vue-дерева */
.clinics-map-marker {
	position: absolute;
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	cursor: pointer;
	transform: translate(-50%, -50%);
	background: var(--color-primary);
	color: var(--color-bg-primary);
	border-radius: var(--border-radius-full);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
	transition: transform 0.2s ease;
}

.clinics-map-marker:hover {
	transform: translate(-50%, -50%) scale(1.1);
}

.map-cluster-marker {
	position: absolute;
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	cursor: pointer;
	transform: translate(-50%, -50%);
	background: var(--color-primary-dark);
	color: var(--color-bg-primary);
	border-radius: var(--border-radius-full);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
	font-weight: var(--font-weight-semibold);
	font-size: var(--font-size-sm);
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
}
</style>

<style scoped>
.clinics-map-view {
	width: 100%;
	height: 100%;
	min-height: inherit;
	position: relative;
}

.clinics-map-view__map {
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
</style>

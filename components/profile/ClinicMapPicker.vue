<script setup lang="ts">
import clinicProfileI18n from '~/i18n/clinic-profile';

const props = defineProps<{
	latitude: number | null;
	longitude: number | null;
}>();

// Точку можно только поставить и перетащить кликом. Снять её нельзя: без
// координат клиника исчезает с карты каталога и из поиска по расстоянию, а
// вернуть их пользователь обычно не догадывается. Стереть точку может админ
// сайта через админку.
const emit = defineEmits<{
	(e: 'pick', latitude: number, longitude: number): void;
}>();

const { t } = useI18n({
	useScope: 'local',
	messages: clinicProfileI18n.messages,
});

const MARKER_ID = 'clinic-location-pin';

const mapContainer = ref<HTMLElement | null>(null);
const {
	initializeMap,
	isInitialized,
	addMarker,
	updateMarkerPosition,
	removeMarker,
	centerOnLocations,
	onMapClick,
} = useLeaflet();

const hasPoint = computed(
	() => props.latitude != null && props.longitude != null,
);

const round6 = (value: number) => Math.round(value * 1e6) / 1e6;

function placeMarker(lat: number, lng: number) {
	if (!isInitialized.value) return;
	if (markerPlaced) {
		updateMarkerPosition(MARKER_ID, lat, lng);
	} else {
		addMarker(MARKER_ID, lat, lng);
		markerPlaced = true;
	}
}

let markerPlaced = false;

onMounted(async () => {
	if (!mapContainer.value) return;
	await initializeMap(mapContainer.value);

	onMapClick((lat, lng) => {
		emit('pick', round6(lat), round6(lng));
	});

	if (props.latitude != null && props.longitude != null) {
		placeMarker(props.latitude, props.longitude);
		centerOnLocations([[props.latitude, props.longitude]]);
	}
});

watch(
	() => [props.latitude, props.longitude] as const,
	([lat, lng]) => {
		if (lat != null && lng != null) {
			placeMarker(lat, lng);
		} else if (markerPlaced) {
			removeMarker(MARKER_ID);
			markerPlaced = false;
		}
	},
);
</script>

<template>
	<div class="map-picker">
		<p class="map-picker__hint">{{ t('MapPickerHint') }}</p>
		<div ref="mapContainer" class="map-picker__map" />
		<div class="map-picker__footer">
			<span class="map-picker__coords">
				{{
					hasPoint
						? t('CoordinatesSet', { lat: latitude, lng: longitude })
						: t('CoordinatesNotSet')
				}}
			</span>
		</div>
	</div>
</template>

<style scoped>
.map-picker {
	display: flex;
	flex-direction: column;
	gap: var(--kit-spacing-sm);
}

.map-picker__hint {
	font-size: var(--kit-font-size-xs);
	color: var(--kit-color-text-tertiary);
	margin: 0;
}

.map-picker__map {
	height: 320px;
	border-radius: var(--kit-border-radius-md);
	overflow: hidden;
	border: 1px solid var(--kit-color-border-secondary);
	cursor: crosshair;
}

/* Маркер создаётся Leaflet'ом вне Vue-шаблона — стилизуем через :deep */
.map-picker__map :deep(.custom-marker-icon > div) {
	width: 18px;
	height: 18px;
	margin: 11px;
	border-radius: 50%;
	background: var(--kit-color-primary);
	border: 3px solid #fff;
	box-shadow: var(--kit-shadow-md);
}

.map-picker__footer {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--kit-spacing-sm);
	flex-wrap: wrap;
}

.map-picker__coords {
	font-size: var(--kit-font-size-sm);
	color: var(--kit-color-text-secondary);
}
</style>

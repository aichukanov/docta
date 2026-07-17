<script setup lang="ts">
import clinicProfileI18n from '~/i18n/clinic-profile';

const props = defineProps<{
	latitude: number | null;
	longitude: number | null;
}>();

const emit = defineEmits<{
	(e: 'pick', latitude: number, longitude: number): void;
	(e: 'clear'): void;
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
			<el-button v-if="hasPoint" size="small" @click="emit('clear')">
				{{ t('ClearPoint') }}
			</el-button>
		</div>
	</div>
</template>

<style scoped>
.map-picker {
	display: flex;
	flex-direction: column;
	gap: var(--spacing-sm);
}

.map-picker__hint {
	font-size: var(--font-size-xs);
	color: var(--color-text-tertiary);
	margin: 0;
}

.map-picker__map {
	height: 320px;
	border-radius: var(--border-radius-md);
	overflow: hidden;
	border: 1px solid var(--color-border-secondary);
	cursor: crosshair;
}

/* Маркер создаётся Leaflet'ом вне Vue-шаблона — стилизуем через :deep */
.map-picker__map :deep(.custom-marker-icon > div) {
	width: 18px;
	height: 18px;
	margin: 11px;
	border-radius: 50%;
	background: var(--color-primary);
	border: 3px solid #fff;
	box-shadow: var(--shadow-md);
}

.map-picker__footer {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: var(--spacing-sm);
	flex-wrap: wrap;
}

.map-picker__coords {
	font-size: var(--font-size-sm);
	color: var(--color-text-secondary);
}
</style>

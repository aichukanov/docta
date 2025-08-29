<template>
	<div class="doctors-map-container">
		<div ref="mapContainer" class="map">
			<div v-if="isLoading" class="map-loading">
				<p>{{ t('MapLoading') }}</p>
			</div>
		</div>

		<DoctorPopup />
		<DoctorMarkersContainer
			:markers="doctorMarkers.vueMarkers"
			@marker-click="onVueMarkerClick"
		/>
	</div>
</template>

<script setup lang="ts">
import { debounce } from 'lodash-es';
import { CityId } from '~/common/constants';
import { useDoctorsStore } from '~/stores/doctors';

const props = defineProps<{
	hidePopup?: boolean;
	mapId?: string;
}>();

const emit = defineEmits<{
	mapReady: [mapInstance: any];
	doctorsVisible: [visibleDoctorIds: number[]];
	showOnMap: [data: { doctorId: number; clinic: any; doctor: any }];
}>();

const { t } = useI18n();
const mapStore = useMapStore();
const doctorsStore = useDoctorsStore();

// Реактивные данные
const mapContainer = ref<HTMLElement | null>(null);

const debouncedNotifyVisibleDoctors = debounce(() => {
	const visibleDoctorIds = doctorMarkers.getVisibleDoctors();
	doctorsStore.setVisibleDoctorIds(visibleDoctorIds);
}, 300);

// Используем useLeaflet напрямую
const {
	isLoading,
	initializeMap,
	setView,
	fitBounds,
	getBounds,
	getCenter,
	getZoom,
	invalidateSize,
	centerOnLocation,
	centerOnLocations,
} = useLeaflet({
	onViewportChanged: debouncedNotifyVisibleDoctors,
});

// Инициализируем композабл для маркеров - он сам получит данные из сторов
const doctorMarkers = useDoctorMarkers(props.hidePopup);

// Обработчик клика по Vue маркеру
const onVueMarkerClick = async (markerData: {
	doctors: any[];
	clinics: any[];
	location: { lat: number; lng: number };
}) => {
	if (props.hidePopup) return;

	// Для Vue маркеров мы можем напрямую использовать store без поиска маркера
	await mapStore.showPopupForMarker(
		null, // Vue маркеры не нуждаются в Leaflet маркере
		markerData.doctors,
		markerData.clinics,
		{ maxWidth: 420, maxHeight: 600 },
	);
};

// Упрощенный обработчик клика по маркеру (DRY - используем store) - DEPRECATED
const onMarkerClick = async (markerData: any) => {
	if (props.hidePopup) return;

	const marker = mapStore.findMarkerAtLocation(markerData.location);
	if (!marker) return;

	// Используем общий метод из store (DRY)
	await mapStore.showPopupForMarker(
		marker,
		markerData.doctors,
		markerData.clinics,
		{ maxWidth: 420, maxHeight: 600 }, // Немного больше для карточек врачей
	);
};

// Слушаем клики по маркерам
doctorMarkers.onMarkerClick(onMarkerClick);

// Инициализация карты при монтировании
onMounted(async () => {
	await nextTick();

	if (mapContainer.value) {
		await initializeMap(mapContainer.value);
		debouncedNotifyVisibleDoctors();
	}
});

// Следим за изменениями города в фильтрах
// watch(
// 	() => filtersStore.city,
// 	(newCity) => {
// 		if (newCity) {
// 			// Преобразуем строку города в массив ID городов
// 			// TODO: Нужно создать функцию для преобразования названия города в CityId
// 			const cityIds = [newCity as unknown as CityId]; // Временное решение
// 			mapStore.centerMapOnCities(cityIds);
// 		} else {
// 			// Если город не выбран, показываем все маркеры
// 			mapStore.centerMapOnCities([]);
// 		}
// 	},
// );
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
:global(.doctor-marker) {
	background: var(--color-primary);
	border-radius: var(--border-radius-lg);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

:global(.doctor-marker-group) {
	background: var(--color-primary);
	border-radius: var(--border-radius-full);
	border: 2px solid var(--color-bg-primary);
	box-shadow: var(--shadow-hover);
}

:global(.marker-inner) {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 100%;
	height: 100%;
	color: var(--color-bg-primary);
	font-family: system-ui, -apple-system, sans-serif;
}

:global(.marker-inner-group) {
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

:global(.forced-marker) {
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
}
</style>

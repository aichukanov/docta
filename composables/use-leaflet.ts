import type { Ref } from 'vue';
import {
	MONTENEGRO_CENTER,
	MONTENEGRO_MAX_BOUNDS,
	MONTENEGRO_ZOOM_SETTINGS,
} from '~/common/constants';

interface LeafletMapOptions {
	center?: [number, number];
	zoom?: number;
	maxBounds?: [[number, number], [number, number]];
	maxBoundsViscosity?: number;
	minZoom?: number;
	maxZoom?: number;
}

interface ViewportChangeEvent {
	bounds: any;
	center: any;
	zoom: number;
}

export function useLeaflet() {
	let leafletMap: any = null;
	let popup: any = null;

	const isLoading = ref(true);
	const isInitialized = ref(false);
	const markers = new Map<string, any>();

	const loadLeaflet = async (): Promise<void> => {
		if (typeof window !== 'undefined' && window.L) {
			return Promise.resolve();
		}

		return new Promise((resolve, reject) => {
			// Load CSS
			const cssLink = document.createElement('link');
			cssLink.rel = 'stylesheet';
			cssLink.href = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css';
			cssLink.integrity = 'sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=';
			cssLink.crossOrigin = '';
			document.head.appendChild(cssLink);

			// Load JS
			const script = document.createElement('script');
			script.src = 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js';
			script.integrity = 'sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=';
			script.crossOrigin = '';

			script.onload = () => resolve();
			script.onerror = () => reject(new Error('Failed to load Leaflet'));

			document.head.appendChild(script);
		});
	};

	const initializeMap = async (container: HTMLElement): Promise<void> => {
		if (typeof window === 'undefined') return;

		if (isInitialized.value) {
			return;
		}

		try {
			isLoading.value = true;
			await loadLeaflet();

			leafletMap = window.L.map(container, {
				center: MONTENEGRO_CENTER,
				zoom: MONTENEGRO_ZOOM_SETTINGS.defaultZoom,
				// maxBounds: MONTENEGRO_MAX_BOUNDS,
				minZoom: MONTENEGRO_ZOOM_SETTINGS.minZoom,
				maxZoom: MONTENEGRO_ZOOM_SETTINGS.maxZoom,
			});

			window.L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
				attribution:
					'© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
			}).addTo(leafletMap);

			// Setup viewport change listeners
			leafletMap.on('moveend zoomend', () => {
				console.log('moveend zoomend');
				// if (onViewportChanged) {
				// 	const bounds = leafletMap.getBounds();
				// 	const center = leafletMap.getCenter();
				// 	const zoom = leafletMap.getZoom();
				// 	onViewportChanged({ bounds, center, zoom });
				// }
			});

			isInitialized.value = true;
			isLoading.value = false;
		} catch (error) {
			console.error('Error initializing map:', error);
			isLoading.value = false;
		}
	};

	const centerOnLocations = async (
		locations: [number, number][],
		padding = 0.2,
	): Promise<void> => {
		if (
			!leafletMap ||
			!locations ||
			locations.length === 0 ||
			typeof window === 'undefined' ||
			!window.L
		) {
			return;
		}

		if (locations.length === 1) {
			leafletMap.centerOnLocation(locations[0]);
			return;
		}

		try {
			const bounds = new window.L.LatLngBounds(locations);
			fitBounds(bounds.pad(padding));
		} catch (error) {
			console.error('Error centering on locations:', error);
		}
	};

	const addMarker = (id: string, lat: number, lng: number) => {
		if (!lat || !lng) {
			console.error('Error adding marker:', id, lat, lng);
		}

		const icon = window.L.divIcon({
			html: `<div id="${id}"></div>`,
			className: 'custom-marker-icon',
			iconSize: [40, 40],
			iconAnchor: [20, 20],
		});

		const marker = window.L.marker([lat, lng], { icon });
		marker.addTo(leafletMap);
		markers.set(id, marker);
	};

	const removeMarker = (id: string): void => {
		const marker = markers.get(id);
		if (marker && leafletMap) {
			leafletMap.removeLayer(marker);
			markers.delete(id);
		}
	};

	const updateMarkerPosition = (id: string, lat: number, lng: number): void => {
		const marker = markers.get(id);
		if (marker) {
			marker.setLatLng([lat, lng]);
		}
	};

	const clearMarkers = (): void => {
		markers.forEach((marker) => {
			leafletMap.removeLayer(marker);
		});
		markers.clear();
	};

	const openPopup = (lat: number, lng: number, onClose: () => void) => {
		if (!popup) {
			popup = window.L.popup({
				minWidth: 350,
				maxWidth: 500,
				maxHeight: 500,
				offset: [-20, -30],
			}).setContent('<div id="popup-container"></div>');
		}
		popup.setLatLng([lat, lng]).openOn(leafletMap);

		// Получаем размеры контейнера карты
		const mapSize = leafletMap.getSize();

		const targetPoint = window.L.point(
			mapSize.x / 2, // центр по горизонтали
			400 + (mapSize.y - 400) / 2, // 400px - высота попапа
		);

		// Получаем текущую пиксельную позицию целевой точки
		const currentPoint = leafletMap.latLngToContainerPoint([lat, lng]);

		// Вычисляем смещение
		const offsetPoint = currentPoint.subtract(targetPoint);

		// Получаем текущий центр карты в пиксельных координатах
		const currentCenter = leafletMap.getCenter();
		const currentCenterPoint = leafletMap.latLngToContainerPoint(currentCenter);

		// Вычисляем новый центр карты
		const newCenterPoint = currentCenterPoint.add(offsetPoint);
		const newCenter = leafletMap.containerPointToLatLng(newCenterPoint);

		// Плавно перемещаем карту к новому центру
		leafletMap.panTo(newCenter, {
			animate: true,
			duration: 0.5,
		});
	};

	return {
		isLoading: readonly(isLoading),
		isInitialized: readonly(isInitialized),

		initializeMap,
		centerOnLocations,

		openPopup,
		markers,
		addMarker,
		removeMarker,
		updateMarkerPosition,
		clearMarkers,
	};
}

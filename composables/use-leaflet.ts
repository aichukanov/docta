import { debounce } from 'lodash-es';
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

interface UseLeafletOptions {
	onViewportChanged?: (event: ViewportChangeEvent) => void;
}

export function useLeaflet(options: UseLeafletOptions = {}) {
	const { onViewportChanged } = options;

	const leafletMap = ref<any>(null);
	const isLoading = ref(true);
	const isInitialized = ref(false);

	const debouncedViewportChange = debounce(
		(bounds: any, center: any, zoom: number) => {
			if (onViewportChanged) {
				onViewportChanged({ bounds, center, zoom });
			}
		},
		300,
	);

	// Load Leaflet library
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

			leafletMap.value = window.L.map(container, {
				center: MONTENEGRO_CENTER,
				zoom: MONTENEGRO_ZOOM_SETTINGS.defaultZoom,
				maxBounds: MONTENEGRO_MAX_BOUNDS,
				maxBoundsViscosity: 1.0,
				minZoom: MONTENEGRO_ZOOM_SETTINGS.minZoom,
				maxZoom: MONTENEGRO_ZOOM_SETTINGS.maxZoom,
				...mapOptions,
			});

			// Add OpenStreetMap tiles
			window.L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
				attribution:
					'© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
			}).addTo(leafletMap.value);

			// Setup viewport change listeners
			leafletMap.value.on('moveend zoomend', () => {
				const bounds = leafletMap.value.getBounds();
				const center = leafletMap.value.getCenter();
				const zoom = leafletMap.value.getZoom();

				debouncedViewportChange(bounds, center, zoom);
			});

			isInitialized.value = true;
			isLoading.value = false;
		} catch (error) {
			console.error('Error initializing map:', error);
			isLoading.value = false;
		}
	};

	// Map control methods
	const setView = (center: [number, number], zoom: number): void => {
		if (!leafletMap.value) return;
		leafletMap.value.setView(center, zoom);
	};

	const fitBounds = (bounds: any, options: any = {}): void => {
		if (!leafletMap.value) return;
		leafletMap.value.fitBounds(bounds, options);
	};

	const getBounds = () => {
		if (!leafletMap.value) return null;
		return leafletMap.value.getBounds();
	};

	const getCenter = () => {
		if (!leafletMap.value) return null;
		return leafletMap.value.getCenter();
	};

	const getZoom = (): number | null => {
		if (!leafletMap.value) return null;
		return leafletMap.value.getZoom();
	};

	const invalidateSize = (): void => {
		if (!leafletMap.value) return;
		leafletMap.value.invalidateSize();
	};

	const centerOnLocation = (coordinates: [number, number], zoom = 15): void => {
		if (!leafletMap.value || !coordinates || coordinates.length !== 2) return;
		setView(coordinates, zoom);
	};

	const centerOnLocations = async (
		locations: [number, number][],
		padding = 0.2,
	): Promise<void> => {
		if (
			!leafletMap.value ||
			!locations ||
			locations.length === 0 ||
			typeof window === 'undefined' ||
			!window.L
		) {
			return;
		}

		if (locations.length === 1) {
			centerOnLocation(locations[0]);
			return;
		}

		try {
			const bounds = new window.L.LatLngBounds(locations);
			fitBounds(bounds.pad(padding));
		} catch (error) {
			console.error('Error centering on locations:', error);
		}
	};

	// Cleanup function
	const destroyMap = (): void => {
		if (leafletMap.value) {
			leafletMap.value.remove();
			leafletMap.value = null;
			isInitialized.value = false;
		}
	};

	onUnmounted(() => {
		destroyMap();
	});

	return {
		isLoading: readonly(isLoading),
		isInitialized: readonly(isInitialized),

		// Methods
		initializeMap,
		destroyMap,
		setView,
		fitBounds,
		getBounds,
		getCenter,
		getZoom,
		invalidateSize,
		centerOnLocation,
		centerOnLocations,
	};
}

import {
	MONTENEGRO_CENTER,
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

interface InitializeMapOptions {
	// Группировать маркеры через leaflet.markercluster (грузится по требованию)
	cluster?: boolean;
}

interface AddMarkerOptions {
	title?: string;
	alt?: string;
	// Статичный HTML иконки вместо телепорт-контейнера <div id="...">.
	// Обязателен при кластеризации: markercluster пересоздаёт DOM маркеров
	// при сборке/разборке кластеров, и Teleport-цели внутри них пропадают.
	html?: string;
	onClick?: () => void;
}

interface ViewportChangeEvent {
	bounds: any;
	center: any;
	zoom: number;
}

export function useLeaflet() {
	let leafletMap: any = null;
	let popup: any = null;
	let clusterGroup: any = null;

	const isLoading = ref(true);
	const isInitialized = ref(false);
	const markers = new Map<string, any>();
	let mapClickHandler: ((lat: number, lng: number) => void) | null = null;

	/** Подписка на клик по карте (используется map-picker'ом координат). */
	const onMapClick = (handler: (lat: number, lng: number) => void): void => {
		mapClickHandler = handler;
	};

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

	const loadMarkerCluster = async (): Promise<void> => {
		if (typeof window === 'undefined') return;
		// markercluster — плагин, его нет в @types/leaflet
		if ((window.L as any)?.markerClusterGroup) {
			return Promise.resolve();
		}

		const base = 'https://unpkg.com/leaflet.markercluster@1.5.3/dist';

		['MarkerCluster.css', 'MarkerCluster.Default.css'].forEach((file) => {
			const cssLink = document.createElement('link');
			cssLink.rel = 'stylesheet';
			cssLink.href = `${base}/${file}`;
			cssLink.crossOrigin = '';
			document.head.appendChild(cssLink);
		});

		return new Promise((resolve, reject) => {
			const script = document.createElement('script');
			script.src = `${base}/leaflet.markercluster.js`;
			script.crossOrigin = '';

			script.onload = () => resolve();
			script.onerror = () =>
				reject(new Error('Failed to load leaflet.markercluster'));

			document.head.appendChild(script);
		});
	};

	const initializeMap = async (
		container: HTMLElement,
		options?: InitializeMapOptions,
	): Promise<void> => {
		if (typeof window === 'undefined') return;

		if (isInitialized.value) {
			return;
		}

		try {
			isLoading.value = true;
			await loadLeaflet();
			if (options?.cluster) {
				await loadMarkerCluster();
			}

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

			leafletMap.on('click', (e: any) => {
				mapClickHandler?.(e.latlng.lat, e.latlng.lng);
			});

			if (options?.cluster) {
				clusterGroup = (window.L as any).markerClusterGroup({
					showCoverageOnHover: false,
					maxClusterRadius: 60,
					iconCreateFunction: (cluster: any) =>
						window.L.divIcon({
							html: `<div class="map-cluster-marker">${cluster.getChildCount()}</div>`,
							className: 'custom-marker-icon',
							iconSize: [40, 40],
							iconAnchor: [20, 20],
						}),
				});
				leafletMap.addLayer(clusterGroup);
			}

			// leafletMap.on('moveend zoomend', () => {
			// if (onViewportChanged) {
			// 	const bounds = leafletMap.getBounds();
			// 	const center = leafletMap.getCenter();
			// 	const zoom = leafletMap.getZoom();
			// 	onViewportChanged({ bounds, center, zoom });
			// }
			// });

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
			leafletMap.setView(locations[0], MONTENEGRO_ZOOM_SETTINGS.cityZoom, {
				animate: true,
			});
			return;
		}

		try {
			const bounds = new window.L.LatLngBounds(locations);
			leafletMap.fitBounds(bounds.pad(padding));
		} catch (error) {
			console.error('Error centering on locations:', error);
		}
	};

	const addMarker = (
		id: string,
		lat: number,
		lng: number,
		options?: AddMarkerOptions,
	) => {
		// Без координат L.marker бросит исключение и оборвёт добавление
		// остальных маркеров — такую клинику просто пропускаем
		if (!lat || !lng) {
			console.error('Error adding marker:', id, lat, lng);
			return;
		}

		const icon = window.L.divIcon({
			html: options?.html ?? `<div id="${id}"></div>`,
			className: 'custom-marker-icon',
			iconSize: [40, 40],
			iconAnchor: [20, 20],
		});

		const marker = window.L.marker([lat, lng], {
			icon,
			title: options?.title,
			alt: options?.alt || options?.title,
		});

		if (options?.onClick) {
			marker.on('click', options.onClick);
		}

		if (clusterGroup) {
			clusterGroup.addLayer(marker);
		} else {
			marker.addTo(leafletMap);
		}

		const el = marker.getElement();
		if (el && options?.title) {
			el.setAttribute('aria-label', options.title);
		}

		markers.set(id, marker);
	};

	const removeMarker = (id: string): void => {
		const marker = markers.get(id);
		if (!marker) return;
		if (clusterGroup) {
			clusterGroup.removeLayer(marker);
			markers.delete(id);
		} else if (leafletMap) {
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
		if (clusterGroup) {
			clusterGroup.clearLayers();
		} else {
			markers.forEach((marker) => {
				leafletMap.removeLayer(marker);
			});
		}
		markers.clear();
	};

	const openPopup = (lat: number, lng: number) => {
		if (!popup) {
			popup = window.L.popup({
				minWidth: 340,
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
		onMapClick,

		openPopup,
		markers,
		addMarker,
		removeMarker,
		updateMarkerPosition,
		clearMarkers,
	};
}

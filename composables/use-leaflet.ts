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

/**
 * Leaflet и плагин кластеризации отдаются со своего домена (public/leaflet/),
 * а не с unpkg.com: чужой CDN — это лишние DNS + TLS + запрос на критическом
 * пути (боковая карта листингов начинает грузиться сразу, наблюдатель
 * пересечения срабатывает с запасом 200px), а при недоступности unpkg карта
 * просто не работает (см. prd/maps/index.md, п. 3.3).
 *
 * Откуда файлы:
 * - leaflet-1.9.4/{leaflet.js,leaflet.css,images/} — копия
 *   node_modules/leaflet/dist (пакет `leaflet` уже в зависимостях), файлы
 *   побайтово совпадают с раздачей unpkg: sha256 сходится со старыми
 *   integrity-атрибутами (20nQCchB9co0… и p4NxAoJBhIIN…);
 * - leaflet.markercluster-1.5.3/* — dist плагина
 *   (npm-пакета в зависимостях нет).
 *
 * Как обновлять: положить новую версию в НОВУЮ папку `<пакет>-<версия>`
 * и поменять константы ниже — так обновление не упирается в кеш браузера и
 * CDN, а откат сводится к возврату константы. Старую папку удалять после
 * выката. images/ нужны рядом с leaflet.css: Leaflet определяет путь к
 * иконкам маркеров по url() из этой таблицы стилей.
 */
const LEAFLET_BASE = '/leaflet/leaflet-1.9.4';
const MARKERCLUSTER_BASE = '/leaflet/leaflet.markercluster-1.5.3';

// Промисы на уровне модуля, а не экземпляра composable: карт на странице
// бывает несколько (боковая + полноэкранная), и раньше параллельные вызовы
// вставляли в <head> по второму тегу <script> на ту же библиотеку
let leafletPromise: Promise<void> | null = null;
let markerClusterPromise: Promise<void> | null = null;

/**
 * Подключение таблицы стилей, не блокирующее первый рендер: динамически
 * добавленный в <head> <link rel=stylesheet> Chrome считает render-blocking и
 * держит кадр до загрузки файла. media="print" выводит его из-под этого
 * правила, а после загрузки media переключается на "all".
 *
 * Ошибка загрузки не отклоняет промис: без стилей карта некрасивая, но живая,
 * ронять из-за этого инициализацию нечего.
 */
function loadStylesheet(href: string): Promise<void> {
	return new Promise((resolve) => {
		if (document.querySelector(`link[data-leaflet-css="${href}"]`)) {
			resolve();
			return;
		}

		const link = document.createElement('link');
		link.rel = 'stylesheet';
		link.href = href;
		link.media = 'print';
		link.dataset.leafletCss = href;
		link.onload = () => {
			link.media = 'all';
			resolve();
		};
		link.onerror = () => resolve();
		document.head.appendChild(link);
	});
}

function loadScript(src: string, errorMessage: string): Promise<void> {
	return new Promise((resolve, reject) => {
		const script = document.createElement('script');
		script.src = src;
		// Свой домен: integrity/crossorigin не нужны, файл лежит в репозитории
		script.onload = () => resolve();
		script.onerror = () => reject(new Error(errorMessage));
		document.head.appendChild(script);
	});
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

	// Стили ждём наравне со скриптом: карта инициализируется уже с ними,
	// иначе первый кадр карты — расползшиеся тайлы
	const loadLeaflet = (): Promise<void> => {
		if (typeof window === 'undefined' || window.L) {
			return Promise.resolve();
		}

		if (!leafletPromise) {
			leafletPromise = Promise.all([
				loadStylesheet(`${LEAFLET_BASE}/leaflet.css`),
				loadScript(`${LEAFLET_BASE}/leaflet.js`, 'Failed to load Leaflet'),
			])
				.then(() => undefined)
				.catch((error) => {
					// Сбрасываем кеш промиса, чтобы следующая карта повторила попытку
					leafletPromise = null;
					throw error;
				});
		}

		return leafletPromise;
	};

	const loadMarkerCluster = (): Promise<void> => {
		if (typeof window === 'undefined') return Promise.resolve();
		// markercluster — плагин, его нет в @types/leaflet
		if ((window.L as any)?.markerClusterGroup) {
			return Promise.resolve();
		}

		if (!markerClusterPromise) {
			markerClusterPromise = Promise.all([
				loadStylesheet(`${MARKERCLUSTER_BASE}/MarkerCluster.css`),
				loadStylesheet(`${MARKERCLUSTER_BASE}/MarkerCluster.Default.css`),
				loadScript(
					`${MARKERCLUSTER_BASE}/leaflet.markercluster.js`,
					'Failed to load leaflet.markercluster',
				),
			])
				.then(() => undefined)
				.catch((error) => {
					markerClusterPromise = null;
					throw error;
				});
		}

		return markerClusterPromise;
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

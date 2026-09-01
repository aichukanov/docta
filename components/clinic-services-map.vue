<script setup lang="ts">
import { getClinicMarkerId } from '~/common/utils';
import type { ClinicData, ClinicServiceItem } from '~/interfaces/clinic';
import { getLocalizedName } from '~/common/utils';
import { getClinicMarkerHtml, groupServicesByClinicId } from './map/markers';

// На карту приходят элементы listing-страниц: для медикаментов/режима клиник
// массив пустой, поэтому все поля кроме id опциональны.
type MapServiceItem = Partial<ClinicServiceItem> & { id: number };

const props = defineProps<{
	clinics: ClinicData[];
	services: MapServiceItem[];
	showAllClinics?: boolean;
	// Авто-центрирование по видимым маркерам после синхронизации.
	// list-page включает его, когда город не выбран — иначе картой
	// управляет центрирование по выбранному городу.
	autoFit?: boolean;
	detailsRouteName?: string;
	detailsParamName?: string;
}>();

const emit = defineEmits<{
	(e: 'ready'): void;
}>();

const { t, locale } = useI18n();
const { trackEvent } = useAnalytics();

const {
	isLoading,
	isInitialized,
	initializeMap,
	addMarker,
	removeMarker,
	markers,
	openPopup,
	centerOnLocations,
} = useLeaflet();

const mapContainer = ref<HTMLElement | null>(null);
// Готовность цели Teleport для попапа: #popup-container создаёт Leaflet
const isTeleportReady = ref(false);

const selectedClinic = ref<ClinicData | null>(null);

// Клиники без координат на карту не попадают
const clinicsWithCoords = computed(() =>
	props.clinics.filter((clinic) => clinic.latitude && clinic.longitude),
);

// clinicIds разбираем один раз на услугу, а не на каждую пару
// «клиника × услуга»: было 126 клиник × 20 услуг ≈ 2500 split(',') на пересчёт
const servicesByClinicId = computed(() =>
	groupServicesByClinicId(props.services),
);

// Общий пустой массив: новый [] на каждый промах зря менял бы
// результат зависимых computed'ов
const NO_SERVICES: MapServiceItem[] = [];

const getClinicServices = (clinic: ClinicData): MapServiceItem[] =>
	servicesByClinicId.value.get(clinic.id) ?? NO_SERVICES;

// Клиники, на которые ставим маркеры. В режиме услуг — только те, у кого
// есть услуги из текущего списка: раньше маркеры создавались на ВСЕ клиники
// стора, и пустые прозрачные иконки 40×40 перехватывали клики по видимым
const visibleClinics = computed<ClinicData[]>(() => {
	if (props.showAllClinics) {
		return clinicsWithCoords.value;
	}

	return clinicsWithCoords.value.filter((clinic) =>
		servicesByClinicId.value.has(clinic.id),
	);
});

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

const waitForInit = () => {
	if (isInitialized.value) return Promise.resolve();
	return new Promise<void>((resolve) => {
		const stop = watch(isInitialized, (v) => {
			if (v) {
				stop();
				resolve();
			}
		});
	});
};

const openClinicPopup = async (clinic: ClinicData) => {
	await waitForInit();

	selectedClinic.value = null;
	await nextTick();

	openPopup(clinic.latitude, clinic.longitude);
	selectedClinic.value = clinic;

	scrollToMap();
};

// Ищем клинику по id, а не держим её в замыкании обработчика: маркер живёт
// дольше одного набора props, и замыкание отдало бы в попап устаревший объект
const onMarkerClick = (clinicId: number) => {
	const clinic = visibleClinics.value.find(({ id }) => id === clinicId);
	if (!clinic) return;

	trackEvent('map_marker_clicked', {
		entity_type: 'clinic',
		entity_id: clinic.id,
		entity_slug: clinic.slug,
	});
	openClinicPopup(clinic);
};

const centerOnClinics = async (clinics: ClinicData[]) => {
	await waitForInit();
	centerOnLocations(
		clinics.map((clinic) => [clinic.latitude, clinic.longitude]),
	);

	scrollToMap();
};

// Содержимое статичной иконки Leaflet сам не перерисует, поэтому маркер
// с изменившейся подписью (название или число услуг) пересоздаём
const markerSignatures = new Map<string, string>();

const getMarkerSignature = (clinic: ClinicData, title: string) =>
	`${title}|${props.showAllClinics ? 'icon' : getClinicServices(clinic).length}`;

const syncMarkers = () => {
	const nextClinics = new Map<string, ClinicData>();
	visibleClinics.value.forEach((clinic) => {
		nextClinics.set(getClinicMarkerId(clinic.id), clinic);
	});

	// Удаляем маркеры клиник, которых больше нет в списке или у которых
	// изменилось содержимое иконки
	[...markers.keys()].forEach((markerId) => {
		const clinic = nextClinics.get(markerId);
		if (
			!clinic ||
			markerSignatures.get(markerId) !==
				getMarkerSignature(clinic, getLocalizedName(clinic, locale.value))
		) {
			removeMarker(markerId);
			markerSignatures.delete(markerId);
		}
	});

	nextClinics.forEach((clinic, markerId) => {
		if (markers.has(markerId)) return;

		const title = getLocalizedName(clinic, locale.value);
		addMarker(markerId, clinic.latitude, clinic.longitude, {
			title,
			html: getClinicMarkerHtml(
				getClinicServices(clinic).length,
				props.showAllClinics,
			),
			onClick: () => onMarkerClick(clinic.id),
		});
		markerSignatures.set(markerId, getMarkerSignature(clinic, title));
	});
};

// Подгоняем вьюпорт под видимые маркеры: без этого стартовый вид
// (Подгорица, дефолтный зум) оставляет прибрежные и северные клиники за кадром
const fitToMarkers = () => {
	if (!props.autoFit) return;
	centerOnLocations(
		visibleClinics.value.map((clinic) => [clinic.latitude, clinic.longitude]),
	);
};

// Наблюдатель регистрируется здесь, а не в конце onMounted: после `await`
// активный scope компонента потерян, и такой watch НЕ останавливается при
// размонтировании — он продолжал срабатывать (проверено: 2 из 2 раз после
// unmount), то есть каждое открытие карты навсегда добавляло живой
// наблюдатель, дёргающий syncMarkers на уже мёртвой карте.
// Ждёт инициализации: до неё маркеров нет, а стартовый набор ставит onMounted.
//
// Один наблюдатель на visibleClinics вместо двух по props: он зависит и от
// clinics, и от services (пагинация, фильтры). deep не нужен — стор клиник
// держит shallowRef и всегда заменяет массив целиком, так что сравнения по
// ссылке достаточно, а обход дерева из 126 объектов стоил на каждом заходе.
watch(visibleClinics, () => {
	if (!isInitialized.value) return;
	syncMarkers();
	fitToMarkers();
});

// Leaflet грузится с CDN, и за это время со страницы могли уйти. Продолжать
// работу на размонтированном компоненте нельзя: маркеры уедут в оторванный
// от документа контейнер, а `map_opened` уйдёт в аналитику за карту, которую
// никто не увидел.
let isAlive = true;
onBeforeUnmount(() => {
	isAlive = false;
});

onMounted(async () => {
	if (!mapContainer.value) return;

	// cluster: близко стоящие клиники иначе перекрывают друг друга и
	// кликабелен только верхний маркер (PRD prd/maps, итерация 1)
	await initializeMap(mapContainer.value, { cluster: true });
	if (!isAlive) return;

	syncMarkers();
	fitToMarkers();

	isTeleportReady.value = true;
	emit('ready');

	// Карта монтируется лениво (по виду/кнопке) — mount и есть «открытие»
	trackEvent('map_opened', { markers_count: markers.size });
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

		<Teleport v-if="isTeleportReady && selectedClinic" to="#popup-container">
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
/* Не scoped: маркеры и кластеры рендерит Leaflet вне Vue-дерева.
   .map-cluster-marker дублирует clinics-map-view.vue: карты монтируются
   независимо и на разных страницах, так что каждая везёт стили своих
   маркеров с собой. */
.clinic-service-marker {
	position: absolute;
	display: flex;
	align-items: center;
	justify-content: center;
	width: 40px;
	height: 40px;
	cursor: pointer;
	transform: translate(-50%, -50%);
	background: var(--kit-color-primary);
	color: var(--kit-color-bg-primary);
	border-radius: var(--kit-border-radius-full);
	border: 2px solid var(--kit-color-bg-primary);
	box-shadow: var(--kit-shadow-hover);
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
	font-weight: var(--kit-font-weight-semibold);
	font-size: var(--kit-font-size-sm);
	transition: transform 0.2s ease;
}

.clinic-service-marker:hover {
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
	background: var(--kit-color-primary-dark);
	color: var(--kit-color-bg-primary);
	border-radius: var(--kit-border-radius-full);
	border: 2px solid var(--kit-color-bg-primary);
	box-shadow: var(--kit-shadow-hover);
	font-weight: var(--kit-font-weight-semibold);
	font-size: var(--kit-font-size-sm);
	font-family:
		system-ui,
		-apple-system,
		sans-serif;
}

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
	z-index: var(--kit-z-raised);
	background: var(--kit-color-bg-primary);
	padding: var(--kit-spacing-lg) var(--kit-spacing-2xl);
	border-radius: var(--kit-border-radius-md);
	box-shadow: var(--kit-shadow-md);
}

.map-wrapper {
	width: 100%;
	height: 100%;
	position: relative;
}
</style>

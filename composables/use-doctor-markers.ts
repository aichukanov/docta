import type { Map as LeafletMap, Marker, FeatureGroup, DivIcon } from 'leaflet';
import type { DoctorClinicFull, DoctorWithClinics } from '~/interfaces/doctor';
import type { MarkerData } from '~/components/doctor/markers-container.vue';
import { createEventHook } from '@vueuse/core';
import { useDoctorsStore } from '~/stores/doctors';
import { useMapStore } from '~/stores/map-state';

interface LocationData {
	lat: number;
	lng: number;
	doctorClinics: DoctorClinicGroup[];
}

interface DoctorClinicGroup {
	doctor: DoctorWithClinics;
	clinic: DoctorClinicFull;
}

interface MarkerClickEvent {
	doctors: DoctorWithClinics[];
	clinics: DoctorClinicFull[];
	location: { lat: number; lng: number };
}

export const useDoctorMarkers = (hidePopup = false) => {
	// Получаем данные из сторов через computed для правильной реактивности
	const doctorsStore = useDoctorsStore();
	const mapStore = useMapStore();
	const doctors = computed(() => doctorsStore.filteredDoctors);
	const map = computed(() => mapStore.map);

	// Реактивные данные для Vue компонентов
	const vueMarkers = ref<MarkerData[]>([]);
	const markerContainers = ref<Map<string, HTMLElement>>(new Map());

	// Старые данные для совместимости (постепенно уберем)
	const markersGroup: Ref<FeatureGroup | null> = ref(null);
	const forcedMarkers: Ref<Map<string, Marker>> = ref(new Map());

	// События
	const emit = createEventHook<MarkerClickEvent>();

	// Создание HTML контейнера для Vue маркера на карте
	const createMarkerContainer = (
		id: string,
		lat: number,
		lng: number,
	): HTMLElement | null => {
		if (!map.value || typeof window === 'undefined') return null;

		try {
			// Создаем HTML элемент
			const container = document.createElement('div');
			container.id = `marker-${id}`;
			container.className = 'vue-marker-container';
			container.style.position = 'absolute';
			container.style.zIndex = '1000';

			// Конвертируем координаты в пиксели карты
			const point = map.value.latLngToContainerPoint([lat, lng]);
			container.style.left = `${point.x}px`;
			container.style.top = `${point.y}px`;

			// Добавляем на карту
			const mapPane = map.value.getPanes().overlayPane;
			mapPane.appendChild(container);

			return container;
		} catch (error) {
			console.error('Error creating marker container:', error);
			return null;
		}
	};

	// Обновление позиции контейнера маркера
	const updateMarkerContainerPosition = (
		container: HTMLElement,
		lat: number,
		lng: number,
	) => {
		if (!map.value) return;

		const point = map.value.latLngToContainerPoint([lat, lng]);
		container.style.left = `${point.x}px`;
		container.style.top = `${point.y}px`;
	};

	// Преобразование LocationData в MarkerData
	const createMarkerData = (locationData: LocationData): MarkerData | null => {
		const { lat, lng, doctorClinics } = locationData;

		// Проверяем, что у нас есть данные
		if (!doctorClinics || doctorClinics.length === 0) {
			console.warn('No doctor clinics data for location', { lat, lng });
			return null;
		}

		// Получаем уникальные клиники в этой локации
		const uniqueClinics: DoctorClinicFull[] = [];
		const clinicNames = new Set<string>();
		doctorClinics.forEach(({ clinic }) => {
			if (clinic && !clinicNames.has(clinic.clinicName)) {
				clinicNames.add(clinic.clinicName);
				uniqueClinics.push(clinic);
			}
		});

		// Получаем всех уникальных врачей в этой локации
		const uniqueDoctors: DoctorWithClinics[] = [];
		const doctorIds = new Set<number>();
		doctorClinics.forEach(({ doctor }) => {
			if (doctor && !doctorIds.has(doctor.id)) {
				doctorIds.add(doctor.id);
				uniqueDoctors.push(doctor);
			}
		});

		// Проверяем, что у нас есть данные после фильтрации
		if (uniqueDoctors.length === 0 || uniqueClinics.length === 0) {
			console.warn('No valid doctors or clinics after filtering for location', {
				lat,
				lng,
			});
			return null;
		}

		const id = `${lat.toFixed(6)}-${lng.toFixed(6)}`;

		return {
			id,
			doctors: uniqueDoctors,
			clinics: uniqueClinics,
			location: { lat, lng },
		};
	};

	// Группировка врачей по локации
	const groupDoctorsByLocation = (
		doctors: DoctorWithClinics[],
	): Map<string, LocationData> => {
		const locationGroups = new Map<string, LocationData>();

		doctors.forEach((doctor) => {
			doctor.clinics.forEach((clinic) => {
				// Используем только координаты из клиники - fail fast подход
				const lat = clinic.latitude;
				const lng = clinic.longitude;

				// Проверка валидности координат - fail fast
				if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
					console.error(
						`DoctorMarkers: Missing or invalid coordinates for clinic ID ${clinic.clinicId} (Doctor: ${doctor.name})`,
					);
					return; // Пропускаем элемент без координат
				}

				// Создаем ключ для группировки (округляем до 6 знаков для группировки близких координат)
				const locationKey = `${lat.toFixed(6)},${lng.toFixed(6)}`;

				if (!locationGroups.has(locationKey)) {
					locationGroups.set(locationKey, {
						lat: lat,
						lng: lng,
						doctorClinics: [], // Массив объектов {doctor, clinic}
					});
				}

				locationGroups.get(locationKey)!.doctorClinics.push({
					doctor: doctor,
					clinic: clinic,
				});
			});
		});

		return locationGroups;
	};

	// SVG иконка врача для маркеров
	const DOCTOR_ICON_SVG = `
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
	<path d="M12 12C14.21 12 16 10.21 16 8C16 5.79 14.21 4 12 4C9.79 4 8 5.79 8 8C8 10.21 9.79 12 12 12ZM12 14C9.33 14 4 15.34 4 18V20H20V18C20 15.34 14.67 14 12 14Z" fill="white"/>
</svg>
	`;

	// Создание иконки маркера
	const createMarkerIcon = async (
		doctorCount: number,
		isSingleDoctor: boolean = false,
	): Promise<DivIcon | null> => {
		if (typeof window === 'undefined') return null;

		try {
			if (isSingleDoctor || doctorCount === 1) {
				// Для одиночного врача используем иконку доктора
				return window.L.divIcon({
					className: 'doctor-marker',
					html: `<div class="marker-inner">
						${DOCTOR_ICON_SVG}
					</div>`,
					iconSize: [40, 40],
					iconAnchor: [20, 20],
					popupAnchor: [0, -20],
				});
			} else {
				// Для группы врачей используем кружочек с числом
				return window.L.divIcon({
					className: 'doctor-marker-group',
					html: `<div class="marker-inner-group">${doctorCount}</div>`,
					iconSize: [40, 40],
					iconAnchor: [20, 20],
					popupAnchor: [0, -20],
				});
			}
		} catch (error) {
			console.error('Error creating marker icon:', error);
			return null;
		}
	};

	// Создание маркера для группы врачей в одной локации
	const createLocationMarker = async (
		locationData: LocationData,
	): Promise<Marker | null> => {
		if (typeof window === 'undefined') return null;

		const { lat, lng, doctorClinics } = locationData;
		const doctorCount = doctorClinics.length;

		try {
			// Получаем уникальные клиники в этой локации
			const uniqueClinics: DoctorClinicFull[] = [];
			const clinicNames = new Set<string>();
			doctorClinics.forEach(({ clinic }) => {
				if (!clinicNames.has(clinic.clinicName)) {
					clinicNames.add(clinic.clinicName);
					uniqueClinics.push(clinic);
				}
			});

			// Получаем всех уникальных врачей в этой локации
			const uniqueDoctors: DoctorWithClinics[] = [];
			const doctorIds = new Set<number>();
			doctorClinics.forEach(({ doctor }) => {
				if (!doctorIds.has(doctor.id)) {
					doctorIds.add(doctor.id);
					uniqueDoctors.push(doctor);
				}
			});

			// Собираем метаданные для фильтрации
			const allLanguages = new Set<string>();
			const allSpecialtyIds = new Set<number>();
			const allCityIds = new Set<number>();

			uniqueDoctors.forEach((doctor: DoctorWithClinics) => {
				doctor.languages.forEach((lang: string) => allLanguages.add(lang));
				doctor.specialtyIds.forEach((id: number) => allSpecialtyIds.add(id));
			});

			doctorClinics.forEach(({ clinic }: { clinic: DoctorClinicFull }) => {
				allCityIds.add(clinic.cityId);
			});

			// Создаем иконку маркера
			const markerIcon = await createMarkerIcon(doctorCount);
			if (!markerIcon) return null;

			const marker = window.L.marker([lat, lng], { icon: markerIcon });

			// Добавляем метаданные к маркеру для фильтрации и поиска
			(marker as any).doctorData = {
				doctorIds: Array.from(doctorIds),
				specialtyIds: Array.from(allSpecialtyIds),
				cityIds: Array.from(allCityIds),
				languages: Array.from(allLanguages),
				doctorCount: doctorCount,
				uniqueDoctors,
				uniqueClinics,
			};

			// Обработчик клика по маркеру
			marker.on('click', () => {
				emit.trigger({
					doctors: uniqueDoctors,
					clinics: uniqueClinics,
					location: { lat, lng },
				});
			});

			return marker;
		} catch (error) {
			console.error('Error creating location marker:', error);
			return null;
		}
	};

	// Создание одиночного маркера врача (для принудительного показа)
	const createSingleDoctorMarker = async (
		doctor: DoctorWithClinics,
		clinic: DoctorClinicFull,
	): Promise<Marker | null> => {
		// Используем только координаты из клиники - fail fast подход
		const lat = clinic.latitude;
		const lng = clinic.longitude;

		// Проверка валидности координат - fail fast
		if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
			console.error(
				`DoctorMarkers: Missing or invalid coordinates for clinic ID ${clinic.clinicId} (Doctor: ${doctor.name})`,
			);
			return null;
		}

		try {
			// Создаем иконку одиночного врача
			const doctorIcon = await createMarkerIcon(1, true);
			if (!doctorIcon) return null;

			const marker = window.L.marker([lat, lng], { icon: doctorIcon });

			// Добавляем метаданные к маркеру для фильтрации и поиска
			(marker as any).doctorData = {
				doctorIds: [doctor.id], // Массив для совместимости
				specialtyIds: doctor.specialtyIds,
				cityIds: [clinic.cityId],
				languages: doctor.languages,
				doctorCount: 1,
			};

			// Обработчик клика по маркеру
			marker.on('click', () => {
				emit.trigger({
					doctors: [doctor],
					clinics: [clinic],
					location: { lat, lng },
				});
			});

			return marker;
		} catch (error) {
			console.error('Error creating single doctor marker:', error);
			return null;
		}
	};

	// Обновление маркеров на карте (Vue компоненты)
	const updateMarkers = async (): Promise<void> => {
		if (!map.value) return;

		// Очищаем старые HTML контейнеры
		markerContainers.value.forEach((container) => {
			container.remove();
		});
		markerContainers.value.clear();

		// Группируем врачей по локации
		const locationGroups = groupDoctorsByLocation(doctors.value);

		// Создаем данные для Vue маркеров и HTML контейнеры
		const newVueMarkers: MarkerData[] = [];
		const newContainers = new Map<string, HTMLElement>();

		locationGroups.forEach((locationData) => {
			const markerData = createMarkerData(locationData);

			// Пропускаем, если данные некорректные
			if (!markerData) {
				return;
			}

			// Создаем HTML контейнер на карте
			const container = createMarkerContainer(
				markerData.id,
				markerData.location.lat,
				markerData.location.lng,
			);

			if (container) {
				newVueMarkers.push(markerData);
				newContainers.set(markerData.id, container);
			}
		});

		// Обновляем реактивные данные
		vueMarkers.value = newVueMarkers;
		markerContainers.value = newContainers;

		// Обновляем позиции при изменениях карты
		if (map.value) {
			const updatePositions = () => {
				vueMarkers.value.forEach((marker) => {
					const container = markerContainers.value.get(marker.id);
					if (container) {
						updateMarkerContainerPosition(
							container,
							marker.location.lat,
							marker.location.lng,
						);
					}
				});
			};

			// Подписываемся на события карты для обновления позиций
			map.value.on('zoom', updatePositions);
			map.value.on('move', updatePositions);
		}
	};

	// Добавление принудительного маркера
	const addForcedMarker = async (
		doctor: DoctorWithClinics,
		clinic: DoctorClinicFull,
	): Promise<Marker | null> => {
		const forcedMarker = await createSingleDoctorMarker(doctor, clinic);
		if (forcedMarker) {
			// Применяем дополнительные стили для принудительного маркера
			const element = forcedMarker.getElement();
			if (element) {
				element.classList.add('forced-marker');
				// Добавляем цветную границу для выделения
				element.style.border = `3px solid var(--color-secondary)`;
			}
			const markerKey = `${doctor.id}-${clinic.cityId}`;

			// Удаляем предыдущий принудительный маркер
			if (forcedMarkers.value.has(markerKey)) {
				const existingMarker = forcedMarkers.value.get(markerKey);
				if (existingMarker && map.value) {
					map.value.removeLayer(existingMarker);
				}
			}

			forcedMarkers.value.set(markerKey, forcedMarker);
			if (map.value) {
				forcedMarker.addTo(map.value);
			}
			return forcedMarker;
		}
		return null;
	};

	// Получение маркеров врача
	const getDoctorMarkers = (doctorId: number): Marker[] => {
		const foundMarkers: Marker[] = [];
		if (markersGroup.value) {
			markersGroup.value.eachLayer(function (layer) {
				const marker = layer as any;
				if (
					marker.doctorData &&
					marker.doctorData.doctorIds &&
					marker.doctorData.doctorIds.includes(doctorId)
				) {
					foundMarkers.push(marker);
				}
			});
		}
		return foundMarkers;
	};

	// Получение видимых врачей в текущем viewport
	const getVisibleDoctors = (): number[] => {
		if (!map || !markersGroup.value) {
			return [];
		}

		const bounds = map.getBounds();
		const visibleDoctorIds = new Set<number>();

		markersGroup.value.eachLayer(function (layer) {
			const marker = layer as any;
			const markerBounds = bounds.contains(marker.getLatLng());
			if (markerBounds && marker.doctorData && marker.doctorData.doctorIds) {
				// Добавляем всех врачей из группы
				marker.doctorData.doctorIds.forEach((doctorId: number) => {
					visibleDoctorIds.add(doctorId);
				});
			}
		});

		return Array.from(visibleDoctorIds);
	};

	// Наблюдение за изменениями в списке врачей
	watch(doctors, updateMarkers, { deep: true });

	// Наблюдение за изменениями карты
	watch(map, (newMap) => {
		if (newMap) {
			updateMarkers();
		}
	});

	// Обработчик клика по Vue маркеру
	const handleVueMarkerClick = (data: {
		doctors: DoctorWithClinics[];
		clinics: DoctorClinicFull[];
		location: { lat: number; lng: number };
	}) => {
		emit.trigger(data);
	};

	return {
		// События
		onMarkerClick: emit.on,

		// Методы
		updateMarkers,
		addForcedMarker,
		getDoctorMarkers,
		getVisibleDoctors,
		handleVueMarkerClick,

		vueMarkers,

		markersGroup: readonly(markersGroup),
	};
};

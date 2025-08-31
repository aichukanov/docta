import { defineStore } from 'pinia';
import {
	CITY_COORDINATES,
	MONTENEGRO_CENTER,
	CityId,
} from '~/common/constants';

export const useMapStore = defineStore('mapState', () => {
	// Основное состояние карты
	const map = ref<any>(null);
	const mapController = ref<any>(null);
	const doctorMarker = ref<any>(null);

	// Состояние попапов
	const popupDoctors = ref<any[]>([]);
	const popupClinics = ref<any[]>([]);
	const currentPopupMarker = ref<any>(null);
	const currentPopupId = ref<string | null>(null);

	// Устанавливаем ссылки на компоненты карты
	const setMapComponents = (components: {
		map: any;
		mapController: any;
		doctorMarker: any;
	}) => {
		map.value = components.map;
		mapController.value = components.mapController;
		doctorMarker.value = components.doctorMarker;
	};

	// Метод для переинициализации карты
	const reinitializeMap = () => {
		// if (mapController.value) {
		// 	mapController.value.invalidateSize();
		// }
	};

	// Простые функции для центрирования (KISS)
	const centerOnAllMarkers = () => {
		// if (doctorMarker.value?.markersGroup?.getLayers()?.length > 0) {
		// 	mapController.value.fitBounds(
		// 		doctorMarker.value.markersGroup.getBounds().pad(0.1),
		// 	);
		// } else {
		// 	mapController.value.setView(MONTENEGRO_CENTER, 8);
		// }
	};

	const centerOnSingleCity = (cityId: CityId) => {
		// const cityCoords = CITY_COORDINATES[cityId];
		// if (cityCoords) {
		// 	mapController.value.setView(cityCoords, 13);
		// }
	};

	const centerOnMultipleCities = (cityIds: CityId[]) => {
		// const cityLocations = cityIds
		// 	.map((id) => CITY_COORDINATES[id])
		// 	.filter(Boolean);
		// if (cityLocations.length > 0) {
		// 	mapController.value.centerOnLocations(cityLocations, 0.2);
		// }
	};

	// Упрощенное центрирование карты (KISS)
	const centerMapOnCities = (cityIds: CityId[]) => {
		// if (!mapController.value) return;
		// if (cityIds.length === 0) {
		// 	centerOnAllMarkers();
		// } else if (cityIds.length === 1) {
		// 	centerOnSingleCity(cityIds[0]);
		// } else {
		// 	centerOnMultipleCities(cityIds);
		// }
	};

	// Поиск маркера по локации
	const findMarkerAtLocation = (location: any) => {
		// if (!doctorMarker.value || !doctorMarker.value.markersGroup) {
		// 	return null;
		// }
		// let foundMarker = null;
		// doctorMarker.value.markersGroup.eachLayer((marker: any) => {
		// 	const markerLatLng = marker.getLatLng();
		// 	if (
		// 		Math.abs(markerLatLng.lat - location.lat) < 0.00001 &&
		// 		Math.abs(markerLatLng.lng - location.lng) < 0.00001
		// 	) {
		// 		foundMarker = marker;
		// 	}
		// });
		// return foundMarker;
	};

	const filterClinicData = (markerData: any, clinicId: any) => {
		// const clinicDoctors =
		// 	markerData.uniqueDoctors?.filter((doctor: any) =>
		// 		doctor.clinics.some(
		// 			(docClinic: any) => docClinic.clinicId === clinicId,
		// 		),
		// 	) || [];
		// const clinicClinics =
		// 	markerData.uniqueClinics?.filter(
		// 		(markerClinic: any) => markerClinic.clinicId === clinicId,
		// 	) || [];
		// return { clinicDoctors, clinicClinics };
	};

	const bindPopupToMarker = async (
		marker: any,
		content: string,
		options: any = {},
	) => {
		// const defaultOptions = {
		// 	maxWidth: 400,
		// 	maxHeight: 500,
		// 	keepInView: true,
		// 	autoPan: true,
		// };
		// const popupOptions = { ...defaultOptions, ...options };
		// if (!(marker as any).getPopup()) {
		// 	(marker as any).bindPopup(content, popupOptions);
		// } else {
		// 	(marker as any).getPopup().setContent(content);
		// }
		// currentPopupMarker.value = marker;
		// (marker as any).openPopup();
	};

	const showPopupForMarker = async (
		marker: any,
		doctors: any[],
		clinics: any[],
		popupOptions?: any,
	) => {
		// Обновляем данные для popup - попап сам отрендерится
		// popupDoctors.value = doctors;
		// popupClinics.value = clinics;
		// currentPopupMarker.value = marker;
		// // Для Vue маркеров marker может быть null
		// if (marker) {
		// 	// Открываем попап с контейнером для teleport
		// 	const popupId = `popup-${Date.now()}`;
		// 	await bindPopupToMarker(
		// 		marker,
		// 		`<div id="${popupId}" class="popup-container"></div>`,
		// 		popupOptions,
		// 	);
		// 	// Сохраняем id для teleport
		// 	currentPopupId.value = popupId;
		// } else {
		// 	// Для Vue маркеров создаем виртуальный попап на карте
		// 	const popupId = `vue-popup-${Date.now()}`;
		// 	currentPopupId.value = popupId;
		// 	// Создаем временный контейнер на карте
		// 	if (map.value && doctors[0] && clinics[0]) {
		// 		const clinic = clinics[0];
		// 		const tempPopup = window.L.popup({
		// 			maxWidth: popupOptions?.maxWidth || 400,
		// 			maxHeight: popupOptions?.maxHeight || 500,
		// 			keepInView: true,
		// 			autoPan: true,
		// 		})
		// 			.setLatLng([clinic.latitude, clinic.longitude])
		// 			.setContent(`<div id="${popupId}" class="popup-container"></div>`)
		// 			.openOn(map.value);
		// 	}
		// }
	};

	// Упрощенный показ попапа для клиники (KISS + DRY)
	const showClinicPopup = async (clinic: any) => {
		// if (!doctorMarker.value || !map.value) return;
		// const clinicLocation = { lat: clinic.latitude, lng: clinic.longitude };
		// const marker = findMarkerAtLocation(clinicLocation) as any;
		// if (!marker?.doctorData) return;
		// const { clinicDoctors, clinicClinics } = filterClinicData(
		// 	marker.doctorData,
		// 	clinic.clinicId,
		// );
		// if (clinicDoctors.length === 0) return;
		// await showPopupForMarker(marker, clinicDoctors, clinicClinics);
	};

	// Метод для показа клиники на карте
	const showClinicOnMap = async (
		clinic: any,
		coordinates: [number, number],
	) => {
		// if (!coordinates || !clinic || !mapController.value) return;
		// // Центрируем карту на клинике с оптимальным зумом
		// mapController.value.centerOnLocation(coordinates, 16);
		// // Ищем и показываем попап для этой клиники
		// setTimeout(async () => {
		// 	await showClinicPopup(clinic);
		// }, 500); // Ждем завершения анимации центрирования
	};

	// Очистка данных попапа
	const clearPopup = () => {
		// popupDoctors.value = [];
		// popupClinics.value = [];
		// currentPopupMarker.value = null;
		// currentPopupId.value = null;
	};

	return {
		// Состояние
		map: readonly(map),
		mapController: readonly(mapController),
		doctorMarker: readonly(doctorMarker),
		popupDoctors,
		popupClinics,
		currentPopupMarker: readonly(currentPopupMarker),
		currentPopupId: readonly(currentPopupId),

		// Публичные методы (YAGNI - только необходимые)
		setMapComponents,
		reinitializeMap,
		centerMapOnCities,
		showClinicOnMap,
		showPopupForMarker, // Общий метод (DRY)
		findMarkerAtLocation, // Нужен для onMarkerClick
		clearPopup, // Очистка попапа
	};
});

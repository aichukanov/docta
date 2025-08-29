import { defineStore } from 'pinia';
import type { DoctorWithClinics, DoctorFilters } from '~/interfaces/doctor';

export const useDoctorsStore = defineStore('doctors', () => {
	// Основные данные
	const allDoctors = ref<DoctorWithClinics[]>([]);
	const specialties = ref<{ id: number; name: string }[]>([]);
	const cities = ref<{ id: number; name: string }[]>([]);

	// Состояние загрузки
	const loading = ref(false);

	const searchQuery = ref('');
	const mapFilterEnabled = ref(false);
	const visibleDoctorIds = ref<number[]>([]);

	// Фильтрованный список врачей на основе всех активных фильтров
	const filteredDoctors = computed(() => {
		let result = allDoctors.value;

		// // Фильтр по поисковому запросу
		// if (searchQuery.value) {
		// 	const query = searchQuery.value.toLowerCase();
		// 	result = result.filter(
		// 		(doctor) =>
		// 			doctor.name.toLowerCase().includes(query) ||
		// 			(doctor.clinics &&
		// 				doctor.clinics.some(
		// 					(clinic) =>
		// 						clinic.clinicName.toLowerCase().includes(query) ||
		// 						clinic.cityName.toLowerCase().includes(query) ||
		// 						clinic.address.toLowerCase().includes(query),
		// 				)),
		// 	);
		// }

		// // Фильтр по видимости на карте
		// if (mapFilterEnabled.value && visibleDoctorIds.value.length > 0) {
		// 	result = result.filter((doctor) =>
		// 		visibleDoctorIds.value.includes(doctor.id),
		// 	);
		// }

		return result;
	});

	const loadDoctors = async (filters?: DoctorFilters) => {
		try {
			loading.value = true;

			const query: Record<string, any> = {};
			if (filters?.specialtyIds?.length) {
				query.specialtyIds = filters.specialtyIds;
			}
			if (filters?.languages?.length) {
				query.languages = filters.languages;
			}
			if (filters?.cityIds?.length) {
				query.cityIds = filters.cityIds;
			}

			const response = await $fetch<{
				doctors: DoctorWithClinics[];
				totalCount: number;
			}>('/api/doctors', { query });

			allDoctors.value = response.doctors;
			return response;
		} catch (err) {
			console.error('Error loading doctors:', err);
			throw err;
		} finally {
			loading.value = false;
		}
	};

	// Загрузка одного врача по ID
	const loadDoctor = async (id: number) => {
		try {
			loading.value = true;

			const doctor = await $fetch<DoctorWithClinics>(`/api/doctors/${id}`);
			return doctor;
		} catch (err) {
			console.error('Error loading doctor:', err);
			throw err;
		} finally {
			loading.value = false;
		}
	};

	// Загрузка специальностей
	const loadSpecialties = async () => {
		try {
			const response = await $fetch<{ id: number; name: string }[]>(
				'/api/specialties',
			);
			specialties.value = response;
			return response;
		} catch (err) {
			console.error('Error loading specialties:', err);
			throw err;
		}
	};

	// Загрузка городов
	const loadCities = async () => {
		try {
			const response = await $fetch<{ id: number; name: string }[]>(
				'/api/cities',
			);
			cities.value = response;
			return response;
		} catch (err) {
			console.error('Error loading cities:', err);
			throw err;
		}
	};

	// Получение названий специальностей для врача
	const getSpecialtyNames = (doctor: DoctorWithClinics): string[] => {
		return doctor.specialtyIds
			.map((id) => {
				const specialty = specialties.value.find((s) => s.id === id);
				return specialty?.name || '';
			})
			.filter(Boolean);
	};

	// Методы для управления дополнительными фильтрами
	const setSearchQuery = (query: string) => {
		searchQuery.value = query;
	};

	const setMapFilterEnabled = (enabled: boolean) => {
		mapFilterEnabled.value = enabled;
	};

	const setVisibleDoctorIds = (ids: number[]) => {
		visibleDoctorIds.value = ids;
	};

	// Очистка всех данных
	const clearAll = () => {
		allDoctors.value = [];
		specialties.value = [];
		cities.value = [];
		searchQuery.value = '';
		mapFilterEnabled.value = false;
		visibleDoctorIds.value = [];
	};

	return {
		// Основные данные (только для чтения)
		allDoctors: readonly(allDoctors),
		filteredDoctors,
		specialties: readonly(specialties),
		cities: readonly(cities),

		// Состояние
		loading: readonly(loading),
		mapFilterEnabled,

		// Дополнительные фильтры (для чтения)
		searchQuery: readonly(searchQuery),
		visibleDoctorIds: readonly(visibleDoctorIds),

		// Методы загрузки
		loadDoctors,
		loadDoctor,
		loadSpecialties,
		loadCities,

		// Утилиты
		getSpecialtyNames,

		// Методы управления фильтрами
		setSearchQuery,
		setVisibleDoctorIds,

		// Очистка
		clearAll,
	};
});

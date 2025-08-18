import type { DoctorWithClinics, DoctorFilters } from '~/interfaces/doctor';

export const useDoctors = () => {
	const doctors = ref<DoctorWithClinics[]>([]);
	const specialties = ref<{ id: number; name: string }[]>([]);
	const cities = ref<{ id: number; name: string }[]>([]);
	const loading = ref(false);
	const error = ref<string | null>(null);

	// Load all doctors
	const loadDoctors = async (filters?: DoctorFilters) => {
		try {
			loading.value = true;
			error.value = null;

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

			doctors.value = response.doctors;
			return response;
		} catch (err) {
			error.value = 'Ошибка загрузки врачей';
			console.error('Error loading doctors:', err);
			throw err;
		} finally {
			loading.value = false;
		}
	};

	// Load single doctor by ID
	const loadDoctor = async (id: number) => {
		try {
			loading.value = true;
			error.value = null;

			const doctor = await $fetch<DoctorWithClinics>(`/api/doctors/${id}`);
			return doctor;
		} catch (err) {
			error.value = 'Врач не найден';
			console.error('Error loading doctor:', err);
			throw err;
		} finally {
			loading.value = false;
		}
	};

	// Load specialties
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

	// Load cities
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

	// Get specialty names for a doctor
	const getSpecialtyNames = (doctor: DoctorWithClinics): string[] => {
		return doctor.specialtyIds
			.map((id) => {
				const specialty = specialties.value.find((s) => s.id === id);
				return specialty?.name || '';
			})
			.filter(Boolean);
	};

	return {
		// State
		doctors,
		specialties,
		cities,
		loading,
		error,

		// Methods
		loadDoctors,
		loadDoctor,
		loadSpecialties,
		loadCities,
		getSpecialtyNames,
	};
};

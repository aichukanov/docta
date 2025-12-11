import { defineStore } from 'pinia';
import type { ClinicData } from '~/interfaces/clinic';

export const useClinicsStore = defineStore('clinics', () => {
	const clinics = ref<ClinicData[]>([]);
	const isLoading = ref(false);
	const isLoaded = ref(false);

	const fetchPromise = ref<Promise<void> | null>(null);

	const loadClinicsData = async () => {
		isLoading.value = true;

		fetchPromise.value = $fetch<{
			clinics: ClinicData[];
			totalCount: number;
		}>('/api/clinics/list', {
			method: 'POST',
		}).catch((error) => {
			console.error('Failed to fetch clinics:', error);
			throw error;
		});

		const response = await fetchPromise.value;

		clinics.value = response.clinics || [];
		isLoaded.value = true;
		isLoading.value = false;
	};

	const fetchClinics = async () => {
		if (isLoaded.value) {
			return;
		}

		if (fetchPromise.value) {
			await fetchPromise.value;
		} else {
			await loadClinicsData();
		}
	};

	const refresh = async () => {
		fetchPromise.value = null;
		isLoaded.value = false;
		await loadClinicsData();
	};

	return {
		clinics,
		isLoading,
		isLoaded,
		fetchClinics,
		refresh,
	};
});

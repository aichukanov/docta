import { defineStore } from 'pinia';
import type { ClinicData } from '~/interfaces/clinic';

export const useClinicsStore = defineStore('clinics', () => {
	const { locale } = useI18n();

	const clinics = ref<ClinicData[]>([]);
	const isLoading = ref(false);
	const isLoaded = ref(false);
	const currentLocale = ref<string | null>(null);

	const fetchPromise = ref<Promise<void> | null>(null);

	const loadClinicsData = async () => {
		isLoading.value = true;
		currentLocale.value = locale.value;

		fetchPromise.value = $fetch<{
			clinics: ClinicData[];
			totalCount: number;
		}>('/api/clinics/list', {
			method: 'POST',
			body: {
				locale: locale.value || 'en',
			},
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
		if (isLoaded.value && currentLocale.value === locale.value) {
			return;
		}

		if (fetchPromise.value && currentLocale.value === locale.value) {
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

	// Автоматически перезагружаем данные при смене языка
	watch(locale, () => {
		if (isLoaded.value) {
			refresh();
		}
	});

	/**
	 * Получает клиники по строке ID, сохраняя порядок (для сортировки по цене)
	 * @param clinicIdsString - строка с ID клиник через запятую (например "1,5,3")
	 */
	const getClinicsByIds = (
		clinicIdsString: string | undefined,
	): ClinicData[] => {
		if (!clinicIdsString || !clinics.value.length) {
			return [];
		}

		const clinicIdsArray = clinicIdsString.split(',').map(Number);
		return clinicIdsArray
			.map((id) => clinics.value.find((clinic) => clinic.id === id))
			.filter(Boolean) as ClinicData[];
	};

	return {
		clinics,
		isLoading,
		isLoaded,
		fetchClinics,
		refresh,
		getClinicsByIds,
	};
});

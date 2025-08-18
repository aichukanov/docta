import { defineStore } from 'pinia';

export const useFiltersStore = defineStore('filters', () => {
	const category = ref<'doctors' | 'pharmacies'>('doctors');
	const specialties = ref<string[]>([]);
	const city = ref<string | null>(null);
	const language = ref<string | null>(null);

	const hasActiveFilters = computed(() => {
		return specialties.value.length > 0 || !!city.value || !!language.value;
	});

	const filtersCount = computed(() => {
		let count = 0;
		if (specialties.value.length > 0) count++;
		if (city.value) count++;
		if (language.value) count++;
		return count;
	});

	const setCategory = (newCategory: 'doctors' | 'pharmacies') => {
		category.value = newCategory;
	};

	const setSpecialties = (newSpecialties: string[]) => {
		specialties.value = newSpecialties;
	};

	const addSpecialty = (specialty: string) => {
		if (!specialties.value.includes(specialty)) {
			specialties.value.push(specialty);
		}
	};

	const removeSpecialty = (specialty: string) => {
		specialties.value = specialties.value.filter((s) => s !== specialty);
	};

	const setCity = (newCity: string | null) => {
		city.value = newCity;
	};

	const setLanguage = (newLanguage: string | null) => {
		language.value = newLanguage;
	};

	const clearAllFilters = () => {
		specialties.value = [];
		city.value = null;
		language.value = null;
	};

	return {
		category,
		specialties,
		city,
		language,
		hasActiveFilters,
		filtersCount,
		setCategory,
		setSpecialties,
		addSpecialty,
		removeSpecialty,
		setCity,
		setLanguage,
		clearAllFilters,
	};
});

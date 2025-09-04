const specialtyIds = ref<number[]>([]);
const languageIds = ref<string[]>([]);
const cityIds = ref<number[]>([]);

export const useFilters = () => {
	return {
		specialtyIds,
		languageIds,
		cityIds,
	};
};

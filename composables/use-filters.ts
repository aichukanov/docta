import {
	validateSpecialtyIds,
	validateDoctorLanguageIds,
	validateCityIds,
} from '~/common/validation';

const specialtyIds = ref<number[]>([]);
const languageIds = ref<number[]>([]);
const cityIds = ref<number[]>([]);

const getRouteParams = () => {
	return {
		query: {
			specialtyIds: specialtyIds.value,
			languageIds: languageIds.value,
			cityIds: cityIds.value,
		},
	};
};

const updateFromRoute = (query: Record<string, string | string[]>) => {
	const preparedSpecialtyIds = query.specialtyIds
		? Array.isArray(query.specialtyIds)
			? query.specialtyIds.map(Number)
			: [+query.specialtyIds]
		: null;

	const preparedLanguageIds = query.languageIds
		? Array.isArray(query.languageIds)
			? query.languageIds.map(Number)
			: [+query.languageIds]
		: null;

	const preparedCityIds = query.cityIds
		? Array.isArray(query.cityIds)
			? query.cityIds.map(Number)
			: [+query.cityIds]
		: null;

	if (
		preparedSpecialtyIds &&
		validateSpecialtyIds({ specialtyIds: preparedSpecialtyIds }, 'use-filters')
	) {
		specialtyIds.value = preparedSpecialtyIds;
	}

	if (
		preparedLanguageIds &&
		validateDoctorLanguageIds(
			{ languageIds: preparedLanguageIds },
			'use-filters',
		)
	) {
		languageIds.value = preparedLanguageIds;
	}

	if (
		preparedCityIds &&
		validateCityIds({ cityIds: preparedCityIds }, 'use-filters')
	) {
		cityIds.value = preparedCityIds;
	}
};

export const useFilters = () => {
	return {
		getRouteParams,
		updateFromRoute,
		specialtyIds,
		languageIds,
		cityIds,
	};
};

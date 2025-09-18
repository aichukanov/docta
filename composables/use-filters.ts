import {
	validateSpecialtyIds,
	validateDoctorLanguageIds,
	validateCityIds,
} from '~/common/validation';

const specialtyIds = ref<number[]>([]);
const languageIds = ref<number[]>([]);
const cityIds = ref<number[]>([]);
const name = ref<string>('');

const getRouteParams = () => {
	return {
		query: {
			specialtyIds: specialtyIds.value,
			languageIds: languageIds.value,
			cityIds: cityIds.value,
			name: name.value,
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

	const preparedName = query.name ? query.name : null;

	if (
		preparedSpecialtyIds &&
		validateSpecialtyIds({ specialtyIds: preparedSpecialtyIds }, 'use-filters')
	) {
		specialtyIds.value = preparedSpecialtyIds;
	} else {
		specialtyIds.value = [];
	}

	if (
		preparedLanguageIds &&
		validateDoctorLanguageIds(
			{ languageIds: preparedLanguageIds },
			'use-filters',
		)
	) {
		languageIds.value = preparedLanguageIds;
	} else {
		languageIds.value = [];
	}

	if (
		preparedCityIds &&
		validateCityIds({ cityIds: preparedCityIds }, 'use-filters')
	) {
		cityIds.value = preparedCityIds;
	} else {
		cityIds.value = [];
	}

	if (preparedName) {
		name.value = preparedName;
	} else {
		name.value = '';
	}
};

export const useFilters = () => {
	return {
		getRouteParams,
		updateFromRoute,
		specialtyIds,
		languageIds,
		cityIds,
		name,
	};
};

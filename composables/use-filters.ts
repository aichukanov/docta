import {
	validateSpecialtyIds,
	validateDoctorLanguageIds,
	validateCityIds,
	validateClinicIds,
} from '~/common/validation';

const specialtyIds = ref<number[]>([]);
const languageIds = ref<number[]>([]);
const cityIds = ref<number[]>([]);
const name = ref<string>('');
const clinicIds = ref<number[]>([]);

const getRouteParams = () => {
	return {
		query: {
			specialtyIds: specialtyIds.value,
			languageIds: languageIds.value,
			cityIds: cityIds.value,
			name: name.value,
			clinicIds: clinicIds.value,
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

	const preparedClinicIds = query.clinicIds
		? Array.isArray(query.clinicIds)
			? query.clinicIds.map(Number)
			: [+query.clinicIds]
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

	if (
		preparedClinicIds &&
		validateClinicIds({ clinicIds: preparedClinicIds }, 'use-filters')
	) {
		clinicIds.value = preparedClinicIds;
	} else {
		clinicIds.value = [];
	}

	if (preparedName) {
		name.value = preparedName;
	} else {
		name.value = undefined;
	}
};

export const useFilters = () => {
	return {
		getRouteParams,
		updateFromRoute,
		specialtyIds,
		languageIds,
		cityIds,
		clinicIds,
		name,
	};
};

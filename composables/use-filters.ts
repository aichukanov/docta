import {
	validateSpecialtyIds,
	validateDoctorLanguageIds,
	validateCityIds,
	validateClinicIds,
	validateClinicTypeIds,
	validateCategoryIds,
	validateServiceCategoryIds,
	validateNonNegativeIntegerArray,
} from '~/common/validation';

const specialtyIds = ref<number[]>([]);
const languageIds = ref<number[]>([]);
const cityIds = ref<number[]>([]);
const categoryIds = ref<number[]>([]);
const serviceCategoryIds = ref<number[]>([]);
const clinicTypeIds = ref<number[]>([]);
const name = ref<string>('');
const clinicIds = ref<number[]>([]);
const atcGroupIds = ref<number[]>([]);
const substanceIds = ref<number[]>([]);
const pharmaFormIds = ref<number[]>([]);
const manufacturerIds = ref<number[]>([]);

const getRouteParams = () => {
	return {
		query: {
			specialtyIds: specialtyIds.value,
			languageIds: languageIds.value,
			cityIds: cityIds.value,
			categoryIds: categoryIds.value,
			serviceCategoryIds: serviceCategoryIds.value,
			clinicTypeIds: clinicTypeIds.value,
			name: name.value || undefined,
			clinicIds: clinicIds.value,
			atcGroupIds: atcGroupIds.value,
			substanceIds: substanceIds.value,
			pharmaFormIds: pharmaFormIds.value,
			manufacturerIds: manufacturerIds.value,
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

	const preparedCategoryIds = query.categoryIds
		? Array.isArray(query.categoryIds)
			? query.categoryIds.map(Number)
			: [+query.categoryIds]
		: null;

	const preparedServiceCategoryIds = query.serviceCategoryIds
		? Array.isArray(query.serviceCategoryIds)
			? query.serviceCategoryIds.map(Number)
			: [+query.serviceCategoryIds]
		: null;

	const preparedClinicTypeIds = query.clinicTypeIds
		? Array.isArray(query.clinicTypeIds)
			? query.clinicTypeIds.map(Number)
			: [+query.clinicTypeIds]
		: null;

	const preparedClinicIds = query.clinicIds
		? Array.isArray(query.clinicIds)
			? query.clinicIds.map(Number)
			: [+query.clinicIds]
		: null;

	const preparedAtcGroupIds = query.atcGroupIds
		? Array.isArray(query.atcGroupIds)
			? query.atcGroupIds.map(Number)
			: [+query.atcGroupIds]
		: null;

	const preparedSubstanceIds = query.substanceIds
		? Array.isArray(query.substanceIds)
			? query.substanceIds.map(Number)
			: [+query.substanceIds]
		: null;

	const preparedPharmaFormIds = query.pharmaFormIds
		? Array.isArray(query.pharmaFormIds)
			? query.pharmaFormIds.map(Number)
			: [+query.pharmaFormIds]
		: null;

	const preparedManufacturerIds = query.manufacturerIds
		? Array.isArray(query.manufacturerIds)
			? query.manufacturerIds.map(Number)
			: [+query.manufacturerIds]
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
		preparedCategoryIds &&
		validateCategoryIds({ categoryIds: preparedCategoryIds }, 'use-filters')
	) {
		categoryIds.value = preparedCategoryIds;
	} else {
		categoryIds.value = [];
	}

	if (
		preparedServiceCategoryIds &&
		validateServiceCategoryIds(
			{ serviceCategoryIds: preparedServiceCategoryIds },
			'use-filters',
		)
	) {
		serviceCategoryIds.value = preparedServiceCategoryIds;
	} else {
		serviceCategoryIds.value = [];
	}

	if (
		preparedClinicTypeIds &&
		validateClinicTypeIds(
			{ clinicTypeIds: preparedClinicTypeIds },
			'use-filters',
		)
	) {
		clinicTypeIds.value = preparedClinicTypeIds;
	} else {
		clinicTypeIds.value = [];
	}

	if (
		preparedClinicIds &&
		validateClinicIds({ clinicIds: preparedClinicIds }, 'use-filters')
	) {
		clinicIds.value = preparedClinicIds;
	} else {
		clinicIds.value = [];
	}

	if (
		preparedAtcGroupIds &&
		validateNonNegativeIntegerArray(preparedAtcGroupIds.map(String))
	) {
		atcGroupIds.value = preparedAtcGroupIds;
	} else {
		atcGroupIds.value = [];
	}

	if (
		preparedSubstanceIds &&
		validateNonNegativeIntegerArray(preparedSubstanceIds.map(String))
	) {
		substanceIds.value = preparedSubstanceIds;
	} else {
		substanceIds.value = [];
	}

	if (
		preparedPharmaFormIds &&
		validateNonNegativeIntegerArray(preparedPharmaFormIds.map(String))
	) {
		pharmaFormIds.value = preparedPharmaFormIds;
	} else {
		pharmaFormIds.value = [];
	}

	if (
		preparedManufacturerIds &&
		validateNonNegativeIntegerArray(preparedManufacturerIds.map(String))
	) {
		manufacturerIds.value = preparedManufacturerIds;
	} else {
		manufacturerIds.value = [];
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
		categoryIds,
		serviceCategoryIds,
		clinicTypeIds,
		clinicIds,
		name,
		atcGroupIds,
		substanceIds,
		pharmaFormIds,
		manufacturerIds,
	};
};

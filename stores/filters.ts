import { defineStore } from 'pinia';
import type { LocationQuery } from 'vue-router';
import {
	validateSpecialtyIds,
	validateDoctorLanguageIds,
	validateCityIds,
	validateClinicIds,
	validateClinicTypeIds,
	validateCategoryIds,
	validateServiceCategoryIds,
	validateNonNegativeIntegerArray,
	validateMinRating,
} from '~/common/validation';

export type FilterNamespace =
	| 'clinics'
	| 'services'
	| 'doctors'
	| 'labtests'
	| 'medicines'
	| 'medications';

interface FilterState {
	specialtyIds: number[];
	languageIds: number[];
	cityIds: number[];
	categoryIds: number[];
	serviceCategoryIds: number[];
	clinicTypeIds: number[];
	clinicIds: number[];
	dispensingModeIds: number[];
	atcGroupIds: number[];
	substanceIds: number[];
	pharmaFormIds: number[];
	manufacturerIds: number[];
	name: string;
	openNow: boolean;
	// Минимальный средний рейтинг (0 — фильтр выключен), шаг 0.5
	minRating: number;
}

type IdArrayKey = {
	[K in keyof FilterState]: FilterState[K] extends number[] ? K : never;
}[keyof FilterState];

const createInitialState = (): FilterState => ({
	specialtyIds: [],
	languageIds: [],
	cityIds: [],
	categoryIds: [],
	serviceCategoryIds: [],
	clinicTypeIds: [],
	clinicIds: [],
	dispensingModeIds: [],
	atcGroupIds: [],
	substanceIds: [],
	pharmaFormIds: [],
	manufacturerIds: [],
	name: '',
	openNow: false,
	minRating: 0,
});

const parseIdArray = (
	value: string | string[] | undefined,
): number[] | null => {
	if (!value) return null;
	return Array.isArray(value) ? value.map(Number) : [+value];
};

export const useFiltersStore = defineStore('filters', () => {
	const namespaces = reactive<Record<FilterNamespace, FilterState>>({
		clinics: createInitialState(),
		services: createInitialState(),
		doctors: createInitialState(),
		labtests: createInitialState(),
		medicines: createInitialState(),
		medications: createInitialState(),
	});

	const getRouteParams = (ns: FilterNamespace) => {
		const s = namespaces[ns];
		return {
			query: {
				specialtyIds: s.specialtyIds,
				languageIds: s.languageIds,
				cityIds: s.cityIds,
				categoryIds: s.categoryIds,
				serviceCategoryIds: s.serviceCategoryIds,
				clinicTypeIds: s.clinicTypeIds,
				name: s.name || undefined,
				clinicIds: s.clinicIds,
				dispensingModeIds: s.dispensingModeIds,
				atcGroupIds: s.atcGroupIds,
				substanceIds: s.substanceIds,
				pharmaFormIds: s.pharmaFormIds,
				manufacturerIds: s.manufacturerIds,
				openNow: s.openNow ? 'true' : undefined,
				minRating: s.minRating || undefined,
			},
		};
	};

	// Счётчик URL-синхронизаций: инкрементируется на каждый updateFromRoute,
	// чтобы трекинг фильтров (use-filter-tracking) отличал восстановление
	// состояния из URL (back/forward, переход по ссылке) от действий пользователя
	const routeSyncVersion = ref(0);

	const updateFromRoute = (ns: FilterNamespace, query: LocationQuery) => {
		routeSyncVersion.value++;
		const s = namespaces[ns];
		const setIfValid = (
			key: IdArrayKey,
			validator: (ids: number[]) => boolean,
		) => {
			const parsed = parseIdArray(query[key] as string | string[] | undefined);
			s[key] = parsed && validator(parsed) ? parsed : [];
		};

		setIfValid('specialtyIds', (ids) =>
			validateSpecialtyIds({ specialtyIds: ids }, `filters-store:${ns}`),
		);
		setIfValid('languageIds', (ids) =>
			validateDoctorLanguageIds({ languageIds: ids }, `filters-store:${ns}`),
		);
		setIfValid('cityIds', (ids) =>
			validateCityIds({ cityIds: ids }, `filters-store:${ns}`),
		);
		setIfValid('categoryIds', (ids) =>
			validateCategoryIds({ categoryIds: ids }, `filters-store:${ns}`),
		);
		setIfValid('serviceCategoryIds', (ids) =>
			validateServiceCategoryIds(
				{ serviceCategoryIds: ids },
				`filters-store:${ns}`,
			),
		);
		setIfValid('clinicTypeIds', (ids) =>
			validateClinicTypeIds({ clinicTypeIds: ids }, `filters-store:${ns}`),
		);
		setIfValid('clinicIds', (ids) =>
			validateClinicIds({ clinicIds: ids }, `filters-store:${ns}`),
		);
		setIfValid('dispensingModeIds', (ids) =>
			validateNonNegativeIntegerArray(ids.map(String)),
		);
		setIfValid('atcGroupIds', (ids) =>
			validateNonNegativeIntegerArray(ids.map(String)),
		);
		setIfValid('substanceIds', (ids) =>
			validateNonNegativeIntegerArray(ids.map(String)),
		);
		setIfValid('pharmaFormIds', (ids) =>
			validateNonNegativeIntegerArray(ids.map(String)),
		);
		setIfValid('manufacturerIds', (ids) =>
			validateNonNegativeIntegerArray(ids.map(String)),
		);

		s.name = typeof query.name === 'string' ? query.name : '';
		s.openNow = query.openNow === 'true' || query.openNow === '1';

		const ratingRaw = Array.isArray(query.minRating)
			? query.minRating[0]
			: query.minRating;
		const ratingNum = ratingRaw != null ? Number(ratingRaw) : 0;
		s.minRating = validateMinRating({ minRating: ratingNum }) ? ratingNum : 0;
	};

	return {
		namespaces,
		getRouteParams,
		updateFromRoute,
		routeSyncVersion,
	};
});

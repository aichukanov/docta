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
	validateMedicineCategoryIds,
	validateAtcClassCodes,
	validateNonNegativeIntegerArray,
	validateMinRating,
} from '~/common/validation';

export type FilterNamespace =
	| 'clinics'
	| 'services'
	| 'doctors'
	| 'labtests'
	| 'medicines'
	| 'medications'
	| 'insurance-companies';

interface FilterState {
	specialtyIds: number[];
	languageIds: number[];
	cityIds: number[];
	categoryIds: number[];
	serviceCategoryIds: number[];
	clinicTypeIds: number[];
	clinicIds: number[];
	dispensingModeIds: number[];
	// Потребительские категории лекарств (enums/medicine-category.ts). Отдельный
	// ключ, а не общий categoryIds: тот занят категориями анализов и валидируется
	// по своему enum'у для всех namespace сразу.
	medicineCategoryIds: number[];
	// Фармакологический класс = ATC level-2 («R06» — все антигистаминные).
	// Строки, а не id: код ВОЗ и есть натуральный ключ, свой enum тут был бы
	// лишним слоем, который пришлось бы синхронизировать с классификацией.
	atcClassCodes: string[];
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
	medicineCategoryIds: [],
	atcClassCodes: [],
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
		'clinics': createInitialState(),
		'services': createInitialState(),
		'doctors': createInitialState(),
		'labtests': createInitialState(),
		'medicines': createInitialState(),
		'medications': createInitialState(),
		'insurance-companies': createInitialState(),
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
				medicineCategoryIds: s.medicineCategoryIds,
				atcClassCodes: s.atcClassCodes,
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

	/**
	 * Ключи фильтров, значения которых пришли в URL, но не прошли валидацию.
	 *
	 * `setIfValid` в таком случае ставит `[]`, то есть фильтр молча исчезает и
	 * страница отдаёт ПОЛНЫЙ каталог: `/doctors?specialtyIds=99999` показывал
	 * все 1316 врачей с self-canonical на этот мусорный URL и без `noindex`.
	 * Поскольку значение может быть любым, это неограниченная поверхность
	 * дублей базового листинга. Флаг нужен, чтобы `list-page.vue` мог отдать
	 * `noindex` — см. пункт 7d в docs/audit/seo-2026-07.md.
	 *
	 * Валидаторы проверяют членство в enum'ах (`DoctorSpecialty`, `CityId` и
	 * т.п.), без обращения к БД, поэтому «всё стало невалидным из-за аварии»
	 * здесь невозможно, и строгость безопасна.
	 */
	const invalidFilterKeys = reactive(
		Object.fromEntries(
			(Object.keys(namespaces) as FilterNamespace[]).map((ns) => [
				ns,
				new Set<string>(),
			]),
		) as Record<FilterNamespace, Set<string>>,
	);

	const hasInvalidFilters = (ns: FilterNamespace) =>
		invalidFilterKeys[ns].size > 0;

	const updateFromRoute = (ns: FilterNamespace, query: LocationQuery) => {
		routeSyncVersion.value++;
		const s = namespaces[ns];
		const invalid = invalidFilterKeys[ns];
		invalid.clear();

		const setIfValid = (
			key: IdArrayKey,
			validator: (ids: number[]) => boolean,
		) => {
			const parsed = parseIdArray(query[key] as string | string[] | undefined);
			const isValid = parsed != null && validator(parsed);
			// Отсутствующий параметр — не ошибка; ошибка — когда он есть, но
			// значение не проходит валидацию.
			if (!isValid && query[key] != null) {
				invalid.add(key);
			}
			s[key] = isValid ? parsed : [];
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
		setIfValid('medicineCategoryIds', (ids) =>
			validateMedicineCategoryIds(
				{ medicineCategoryIds: ids },
				`filters-store:${ns}`,
			),
		);
		// Единственный строковый фасет — парсится отдельно от числовых
		const atcClassRaw = query.atcClassCodes;
		const atcClassParsed = atcClassRaw
			? (Array.isArray(atcClassRaw) ? atcClassRaw : [atcClassRaw]).map(String)
			: null;
		const isAtcClassValid =
			atcClassParsed != null &&
			validateAtcClassCodes(
				{ atcClassCodes: atcClassParsed },
				`filters-store:${ns}`,
			);
		if (!isAtcClassValid && atcClassRaw != null) {
			invalid.add('atcClassCodes');
		}
		s.atcClassCodes = isAtcClassValid
			? atcClassParsed.map((code) => code.toUpperCase())
			: [];

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
		const isRatingValid = validateMinRating({ minRating: ratingNum });
		if (!isRatingValid && ratingRaw != null) {
			invalid.add('minRating');
		}
		s.minRating = isRatingValid ? ratingNum : 0;

		// `name` и `openNow` сознательно не проверяем: у поиска любое значение
		// осмысленно, а у `openNow` всё, кроме 'true'/'1', означает «выключено» —
		// то есть значение по умолчанию, а не отброшенный фильтр.
	};

	return {
		namespaces,
		getRouteParams,
		updateFromRoute,
		routeSyncVersion,
		hasInvalidFilters,
	};
});

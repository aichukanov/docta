import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
	processLocalizedNameForClinicOrDoctor,
	getLocalizedNameField,
} from '~/server/common/utils';
import type { ClinicServiceList } from '~/interfaces/clinic';
import {
	validateBody,
	validateName,
	validateCityIds,
	validateServiceCategoryIds,
} from '~/common/validation';
import { LIST_PAGE_SIZE, LIST_CARD_MAX_CLINICS } from '~/common/constants';

export default defineEventHandler(async (event): Promise<ClinicServiceList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/services/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return { items: [], totalCount: 0 };
		}
		if (body.cityIds && !validateCityIds(body, 'api/services/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { items: [], totalCount: 0 };
		}

		return getMedicalServiceList(body);
	} catch (error) {
		console.error('API Error - services:', error);
		return { items: [], totalCount: 0 };
	}
});

export async function getMedicalServiceList(
	body: {
		clinicIds?: number[];
		cityIds?: number[];
		serviceCategoryIds?: number[];
		name?: string;
		locale?: string;
		page?: number;
		pageSize?: number;
		sort?: 'name-asc' | 'price-asc' | 'price-desc';
	} = {},
) {
	const whereFilters: string[] = [];
	const queryParams: Array<number | string> = [];
	const locale = body.locale || 'en';
	const usePagination = body.page != null;
	const pageRaw = Number(body.page);
	const pageSizeRaw = Number(body.pageSize);
	const pageSize =
		Number.isFinite(pageSizeRaw) && pageSizeRaw > 0
			? Math.min(Math.trunc(pageSizeRaw), 100)
			: LIST_PAGE_SIZE;
	const page = Math.max(Number.isFinite(pageRaw) ? pageRaw : 1, 1);
	const offset = Math.max(Math.trunc((page - 1) * pageSize), 0);

	const buildInPlaceholders = (values: Array<number | string>) => {
		const arr = Array.isArray(values) ? values : [values];
		queryParams.push(...arr);
		return arr.map(() => '?').join(',');
	};

	if (body.clinicIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_medical_services cms_f WHERE cms_f.medical_service_id = ms.id AND cms_f.clinic_id IN (${buildInPlaceholders(
				body.clinicIds,
			)}))`,
		);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_medical_services cms_f JOIN clinics c_f ON cms_f.clinic_id = c_f.id WHERE cms_f.medical_service_id = ms.id AND c_f.city_id IN (${buildInPlaceholders(
				body.cityIds,
			)}))`,
		);
	}
	if (
		body.serviceCategoryIds?.length > 0 &&
		validateServiceCategoryIds(body, 'api/services/list')
	) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM medical_service_categories_relations mscr_f WHERE mscr_f.medical_service_id = ms.id AND mscr_f.medical_service_category_id IN (${buildInPlaceholders(
				body.serviceCategoryIds,
			)}))`,
		);
	}
	if (body.name && validateName(body, 'api/services/list')) {
		const nameField = getLocalizedNameField(locale) || 'name_en';
		const namePattern = `%${body.name}%`;
		// Match against tariff codes too (e.g. "J09001", "A05Z") so users can
		// search by FZOCG code. Codes are short alpha-numeric strings; we
		// only enable the lookup when the query looks code-like, to avoid
		// noise from short name fragments.
		const trimmedName = body.name.trim();
		const codeLike = /^[A-Z0-9]{2,8}$/i.test(trimmedName);
		const tariffCodeClause = codeLike
			? ` OR EXISTS (SELECT 1 FROM medical_service_tariffs t_search WHERE t_search.medical_service_id = ms.id AND t_search.code = ?)`
			: '';
		whereFilters.push(
			`(ms.name_en LIKE ? OR ms.${nameField} LIKE ? OR ms.name_sr LIKE ? OR ms.name_sr_cyrl LIKE ? OR ms.name_ru LIKE ? OR ms.name_de LIKE ? OR ms.name_tr LIKE ?${tariffCodeClause})`,
		);
		queryParams.push(
			namePattern,
			namePattern,
			namePattern,
			namePattern,
			namePattern,
			namePattern,
			namePattern,
		);
		if (codeLike) {
			queryParams.push(trimmedName.toUpperCase());
		}
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	const paginationClause = usePagination
		? `LIMIT ${pageSize} OFFSET ${offset}`
		: '';

	// City filter applied inside the SELECT subqueries so the card only lists
	// clinics from the selected city (otherwise all clinics of the service leak through).
	const hasCitySelectFilter = body.cityIds?.length > 0;
	const cityFilterInSelect = hasCitySelectFilter
		? ` AND EXISTS (SELECT 1 FROM clinics cms_city WHERE cms_city.id = cms.clinic_id AND cms_city.city_id IN (${body.cityIds.map(() => '?').join(',')}))`
		: '';
	const selectCityParams: Array<number | string> = hasCitySelectFilter
		? [...body.cityIds, ...body.cityIds]
		: [];

	const priceOrder = getPriceOrderBySQL('cms');

	// Sort: 'name-asc' / 'price-asc' / 'price-desc' override the default rank-based order.
	// Price sort only works when scoped to a single clinic.
	const localizedNameField =
		getLocalizedNameField(locale) || 'name_en';
	const singleClinicId =
		body.clinicIds?.length === 1 ? body.clinicIds[0] : null;
	const usePriceSort =
		(body.sort === 'price-asc' || body.sort === 'price-desc') &&
		singleClinicId != null;
	const sortPriceSelect = usePriceSort
		? `(SELECT cms_sort.price FROM clinic_medical_services cms_sort WHERE cms_sort.medical_service_id = ms.id AND cms_sort.clinic_id = ? AND cms_sort.price IS NOT NULL ORDER BY cms_sort.price ASC LIMIT 1) as sortPrice,`
		: '';
	const sortPriceParams: number[] = usePriceSort ? [singleClinicId!] : [];
	let orderByClause =
		'ms.sort_order IS NULL, ms.sort_order ASC, ms.rank_score DESC, ms.name_en ASC';
	if (body.sort === 'name-asc') {
		orderByClause = `COALESCE(NULLIF(ms.${localizedNameField}, ''), ms.name_en) ASC`;
	} else if (usePriceSort) {
		const dir = body.sort === 'price-asc' ? 'ASC' : 'DESC';
		orderByClause = `sortPrice IS NULL, sortPrice ${dir}, ms.name_en ASC`;
	}

	const totalCountQuery = `
		SELECT COUNT(DISTINCT ms.id) as totalCount
		FROM medical_services ms
		${whereFiltersString};
	`;
	const medicalServicesQuery = `
		SELECT
			ms.id,
			ms.slug,
			ms.name_en,
			ms.name_sr,
			ms.name_sr_cyrl,
			ms.name_ru,
			ms.name_de,
			ms.name_tr,
			ms.sort_order,
			${sortPriceSelect}
			(SELECT COALESCE(GROUP_CONCAT(DISTINCT cms.clinic_id ORDER BY ${priceOrder}), '') FROM clinic_medical_services cms WHERE cms.medical_service_id = ms.id${cityFilterInSelect}) as clinicIds,
			(SELECT GROUP_CONCAT(
				DISTINCT CONCAT(cms.clinic_id, ':', IFNULL(cms.price, ''), ':', IFNULL(cms.price_min, ''), ':', IFNULL(cms.price_max, ''), ':', COALESCE(cms.code, ''))
				ORDER BY ${priceOrder}
			) FROM clinic_medical_services cms WHERE cms.medical_service_id = ms.id${cityFilterInSelect}) as clinicPricesData,
			(
				SELECT GROUP_CONCAT(DISTINCT mscr2.medical_service_category_id ORDER BY mscr2.medical_service_category_id)
				FROM medical_service_categories_relations mscr2
				WHERE mscr2.medical_service_id = ms.id
			) as categoryIds
		FROM medical_services ms
		${whereFiltersString}
		ORDER BY ${orderByClause}
		${paginationClause};
	`;

	const connection = await getConnection();
	let totalCount = 0;
	if (usePagination) {
		const [countRows] = await connection.execute(totalCountQuery, queryParams);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}
	const [medicalServiceRows] = await connection.execute(
		medicalServicesQuery,
		[...sortPriceParams, ...selectCityParams, ...queryParams],
	);
	await connection.end();

	const items = medicalServiceRows.map((row: any) => {
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			row,
			locale,
		);
		// Удаляем избыточные поля локализации
		const {
			name_en,
			name_sr,
			name_sr_cyrl,
			name_ru,
			name_de,
			name_tr,
			...rest
		} = row;
		// Listing-карточка показывает только первые LIST_CARD_MAX_CLINICS клиник,
		// поэтому отдаём только их id/цены — остальное доступно на странице деталей.
		const allClinicIds = row.clinicIds
			? String(row.clinicIds).split(',').filter(Boolean)
			: [];
		const clinicCount = allClinicIds.length;
		const limitedIds = new Set(allClinicIds.slice(0, LIST_CARD_MAX_CLINICS));
		const limitedClinicIds = Array.from(limitedIds).join(',');
		const allClinicPrices = parseClinicPricesData(row.clinicPricesData);
		const limitedClinicPrices = allClinicPrices.filter((p) =>
			limitedIds.has(String(p.clinicId)),
		);
		return {
			...rest,
			id: row.id,
			name: name || '',
			localName: localName || '',
			clinicIds: limitedClinicIds,
			clinicCount,
			clinicPrices: limitedClinicPrices,
			categoryIds: row.categoryIds
				? row.categoryIds.split(',').map(Number)
				: [],
		};
	});

	return {
		items,
		totalCount: usePagination ? totalCount : items.length,
	};
}

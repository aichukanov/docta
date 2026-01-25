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
import { LIST_PAGE_SIZE } from '~/common/constants';

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
	} = {},
) {
	const whereFilters: string[] = [];
	const queryParams: Array<number | string> = [];
	const locale = body.locale || 'en';
	const usePagination = body.page != null;
	const pageRaw = Number(body.page);
	const pageSize = LIST_PAGE_SIZE;
	const page = Math.max(Number.isFinite(pageRaw) ? pageRaw : 1, 1);
	const offset = Math.max(Math.trunc((page - 1) * pageSize), 0);

	const buildInPlaceholders = (values: Array<number | string>) => {
		queryParams.push(...values);
		return values.map(() => '?').join(',');
	};

	if (body.clinicIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_medical_services cms_f WHERE cms_f.medical_service_id = ms.id AND cms_f.clinic_id IN (${buildInPlaceholders(body.clinicIds)}))`,
		);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM clinic_medical_services cms_f JOIN clinics c_f ON cms_f.clinic_id = c_f.id WHERE cms_f.medical_service_id = ms.id AND c_f.city_id IN (${buildInPlaceholders(body.cityIds)}))`,
		);
	}
	if (
		body.serviceCategoryIds?.length > 0 &&
		validateServiceCategoryIds(body, 'api/services/list')
	) {
		whereFilters.push(
			`EXISTS (SELECT 1 FROM medical_service_categories_relations mscr_f WHERE mscr_f.medical_service_id = ms.id AND mscr_f.medical_service_category_id IN (${buildInPlaceholders(body.serviceCategoryIds)}))`,
		);
	}
	if (body.name && validateName(body, 'api/services/list')) {
		const nameField = getLocalizedNameField(locale) || 'name_en';
		const namePattern = `%${body.name}%`;
		whereFilters.push(
			`(ms.name_en LIKE ? OR ms.${nameField} LIKE ? OR ms.name_sr LIKE ? OR ms.name_sr_cyrl LIKE ? OR ms.name_ru LIKE ? OR ms.name_de LIKE ? OR ms.name_tr LIKE ?)`,
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
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';
	const paginationClause = usePagination
		? `LIMIT ${pageSize} OFFSET ${offset}`
		: '';

	const priceOrder = getPriceOrderBySQL('cms');
	const totalCountQuery = `
		SELECT COUNT(DISTINCT ms.id) as totalCount
		FROM medical_services ms
		${whereFiltersString};
	`;
	const medicalServicesQuery = `
		SELECT
			ms.id,
			ms.name_en,
			ms.name_sr,
			ms.name_sr_cyrl,
			ms.name_ru,
			ms.name_de,
			ms.name_tr,
			ms.sort_order,
			(SELECT COALESCE(GROUP_CONCAT(DISTINCT cms.clinic_id ORDER BY ${priceOrder}), '') FROM clinic_medical_services cms WHERE cms.medical_service_id = ms.id) as clinicIds,
			(SELECT GROUP_CONCAT(
				DISTINCT CONCAT(cms.clinic_id, ':', IFNULL(cms.price, ''), ':', IFNULL(cms.price_min, ''), ':', IFNULL(cms.price_max, ''), ':', COALESCE(cms.code, ''))
				ORDER BY ${priceOrder}
			) FROM clinic_medical_services cms WHERE cms.medical_service_id = ms.id) as clinicPricesData,
			(
				SELECT GROUP_CONCAT(DISTINCT mscr2.medical_service_category_id ORDER BY mscr2.medical_service_category_id)
				FROM medical_service_categories_relations mscr2
				WHERE mscr2.medical_service_id = ms.id
			) as categoryIds
		FROM medical_services ms
		${whereFiltersString}
		ORDER BY ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC
		${paginationClause};
	`;

	const connection = await getConnection();
	let totalCount = 0;
	if (usePagination) {
		const [countRows] = await connection.execute(
			totalCountQuery,
			queryParams,
		);
		totalCount = Number((countRows as any[])?.[0]?.totalCount || 0);
	}
	const [medicalServiceRows] = await connection.execute(
		medicalServicesQuery,
		queryParams,
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
		return {
			...rest,
			id: row.id,
			name: name || '',
			localName: localName || '',
			clinicIds: row.clinicIds,
			clinicPrices: parseClinicPricesData(row.clinicPricesData),
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

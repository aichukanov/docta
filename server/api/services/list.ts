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
	} = {},
) {
	const whereFilters = [];
	const locale = body.locale || 'en';
	let joinCategory = '';

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`cms.clinic_id IN (${body.clinicIds.join(',')})`);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(`cities.id IN (${body.cityIds.join(',')})`);
	}
	if (
		body.serviceCategoryIds?.length > 0 &&
		validateServiceCategoryIds(body, 'api/services/list')
	) {
		joinCategory =
			'LEFT JOIN medical_service_categories_relations mscr ON ms.id = mscr.medical_service_id';
		whereFilters.push(
			`mscr.medical_service_category_id IN (${body.serviceCategoryIds.join(
				',',
			)})`,
		);
	}
	if (body.name && validateName(body, 'api/services/list')) {
		const nameField = getLocalizedNameField(locale) || 'name_en';
		whereFilters.push(
			`(ms.name_en LIKE '%${body.name}%' OR ms.${nameField} LIKE '%${body.name}%' OR ms.name_sr LIKE '%${body.name}%' OR ms.name_sr_cyrl LIKE '%${body.name}%' OR ms.name_ru LIKE '%${body.name}%' OR ms.name_de LIKE '%${body.name}%' OR ms.name_tr LIKE '%${body.name}%')`,
		);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const priceOrder = getPriceOrderBySQL('cms');
	const medicalServicesQuery = `
		SELECT DISTINCT
			ms.id,
			ms.name_en,
			ms.name_sr,
			ms.name_sr_cyrl,
			ms.name_ru,
			ms.name_de,
			ms.name_tr,
			ms.sort_order,
			COALESCE(GROUP_CONCAT(DISTINCT cms.clinic_id ORDER BY ${priceOrder}), '') as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(cms.clinic_id, ':', IFNULL(cms.price, ''), ':', IFNULL(cms.price_min, ''), ':', IFNULL(cms.price_max, ''), ':', COALESCE(cms.code, ''))
				ORDER BY ${priceOrder}
			) as clinicPricesData,
			(
				SELECT GROUP_CONCAT(DISTINCT mscr2.medical_service_category_id ORDER BY mscr2.medical_service_category_id)
				FROM medical_service_categories_relations mscr2
				WHERE mscr2.medical_service_id = ms.id
			) as categoryIds
		FROM medical_services ms
		LEFT JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
		LEFT JOIN clinics ON cms.clinic_id = clinics.id
		LEFT JOIN cities ON clinics.city_id = cities.id
		${joinCategory}
		${whereFiltersString}
		GROUP BY ms.id, ms.name_en, ms.name_sr, ms.name_sr_cyrl, ms.name_ru, ms.name_de, ms.name_tr, ms.sort_order
		ORDER BY ms.sort_order IS NULL, ms.sort_order ASC, ms.name_en ASC;
	`;

	const connection = await getConnection();
	const [medicalServiceRows] = await connection.execute(medicalServicesQuery);
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
		totalCount: items.length,
	};
}

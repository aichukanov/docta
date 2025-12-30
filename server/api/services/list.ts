import { getConnection } from '~/server/common/db-mysql';
import { parseClinicPricesData } from '~/server/common/utils';
import type { ClinicServiceList } from '~/interfaces/clinic';
import {
	validateBody,
	validateName,
	validateCityIds,
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
		name?: string;
	} = {},
) {
	const whereFilters = [];

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`cms.clinic_id IN (${body.clinicIds.join(',')})`);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(`cities.id IN (${body.cityIds.join(',')})`);
	}
	if (body.name && validateName(body, 'api/services/list')) {
		whereFilters.push(`ms.name LIKE '%${body.name}%'`);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const medicalServicesQuery = `
		SELECT DISTINCT
			ms.id,
			ms.name,
			GROUP_CONCAT(DISTINCT cms.clinic_id ORDER BY
				CASE WHEN cms.price > 0 THEN 0 ELSE 1 END,
				CASE WHEN cms.price > 0 THEN cms.price ELSE 999999999 END
			) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(cms.clinic_id, ':', COALESCE(cms.price, 0), ':', COALESCE(cms.code, ''))
				ORDER BY
					CASE WHEN cms.price > 0 THEN 0 ELSE 1 END,
					CASE WHEN cms.price > 0 THEN cms.price ELSE 999999999 END
			) as clinicPricesData
		FROM medical_services ms
		LEFT JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
		LEFT JOIN clinics ON cms.clinic_id = clinics.id
		LEFT JOIN cities ON clinics.city_id = cities.id
		${whereFiltersString}
		GROUP BY ms.id, ms.name 
		ORDER BY ms.name ASC;
	`;

	const connection = await getConnection();
	const [medicalServiceRows] = await connection.execute(medicalServicesQuery);
	await connection.end();

	const items = medicalServiceRows.map((row) => ({
		id: row.id,
		name: row.name,
		clinicIds: row.clinicIds,
		clinicPrices: parseClinicPricesData(row.clinicPricesData),
	}));

	return {
		items,
		totalCount: items.length,
	};
}

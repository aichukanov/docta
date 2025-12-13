import { getConnection } from '~/server/common/db-mysql';
import { parseClinicPricesData } from '~/server/common/utils';
import type { ClinicServiceList } from '~/interfaces/clinic';
import { validateBody, validateName } from '~/common/validation';

export default defineEventHandler(async (event): Promise<ClinicServiceList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/services/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
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
		name?: string;
	} = {},
) {
	const whereFilters = [];

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`cms.clinic_id IN (${body.clinicIds.join(',')})`);
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
			GROUP_CONCAT(DISTINCT cms.clinic_id ORDER BY cms.clinic_id) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(cms.clinic_id, ':', COALESCE(cms.price, 0), ':', COALESCE(cms.code, ''))
				ORDER BY cms.clinic_id
			) as clinicPricesData
		FROM medical_services ms
		LEFT JOIN clinic_medical_services cms ON ms.id = cms.medical_service_id
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

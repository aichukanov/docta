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

		if (!validateBody(body, 'api/medications/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return { items: [], totalCount: 0 };
		}
		if (body.cityIds && !validateCityIds(body, 'api/medications/list')) {
			setResponseStatus(event, 400, 'Invalid city');
			return { items: [], totalCount: 0 };
		}

		return getMedicationList(body);
	} catch (error) {
		console.error('API Error - medications:', error);
		return { items: [], totalCount: 0 };
	}
});

export async function getMedicationList(
	body: {
		clinicIds?: number[];
		cityIds?: number[];
		name?: string;
	} = {},
) {
	const whereFilters = [];

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`cm.clinic_id IN (${body.clinicIds.join(',')})`);
	}
	if (body.cityIds?.length > 0) {
		whereFilters.push(`cities.id IN (${body.cityIds.join(',')})`);
	}
	if (body.name && validateName(body, 'api/medications/list')) {
		whereFilters.push(`m.name LIKE '%${body.name}%'`);
	}

	const whereFiltersString =
		whereFilters.length > 0 ? 'WHERE ' + whereFilters.join(' AND ') : '';

	const medicationsQuery = `
		SELECT DISTINCT
			m.id,
			m.name,
			GROUP_CONCAT(DISTINCT cm.clinic_id ORDER BY cm.clinic_id) as clinicIds,
			GROUP_CONCAT(
				DISTINCT CONCAT(cm.clinic_id, ':', COALESCE(cm.price, 0), ':', COALESCE(cm.code, ''))
				ORDER BY cm.clinic_id
			) as clinicPricesData
		FROM medications m
		LEFT JOIN clinic_medications cm ON m.id = cm.medication_id
		LEFT JOIN clinics ON cm.clinic_id = clinics.id
		LEFT JOIN cities ON clinics.city_id = cities.id
		${whereFiltersString}
		GROUP BY m.id, m.name 
		ORDER BY m.name ASC;
	`;

	const connection = await getConnection();
	const [medicationRows] = await connection.execute(medicationsQuery);
	await connection.end();

	const items = medicationRows.map((row) => ({
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

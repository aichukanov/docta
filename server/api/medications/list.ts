import { getConnection } from '~/server/common/db-mysql';
import type { MedicationList } from '~/interfaces/medication';
import { validateBody, validateName } from '~/common/validation';

export default defineEventHandler(async (event): Promise<MedicationList> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/medications/list')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		return getMedicationList(body);
	} catch (error) {
		console.error('API Error - medications:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch medications',
		});
	}
});

export async function getMedicationList(
	body: {
		clinicIds?: number[];
		name?: string;
	} = {},
) {
	const whereFilters = [];

	if (body.clinicIds?.length > 0) {
		whereFilters.push(`cm.clinic_id IN (${body.clinicIds.join(',')})`);
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
			GROUP_CONCAT(DISTINCT cm.clinic_id ORDER BY cm.clinic_id) as clinicIds
		FROM medications m
		LEFT JOIN clinic_medications cm ON m.id = cm.medication_id
		${whereFiltersString}
		GROUP BY m.id, m.name 
		ORDER BY m.name ASC;
	`;

	const connection = await getConnection();
	const [medicationRows] = await connection.execute(medicationsQuery);
	await connection.end();

	return {
		medications: medicationRows,
		totalCount: medicationRows.length,
	};
}

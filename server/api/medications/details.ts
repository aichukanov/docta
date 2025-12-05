import { getConnection } from '~/server/common/db-mysql';
import type { MedicationData } from '~/interfaces/medication';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<MedicationData> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/medications/details')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.medicationId)) {
			setResponseStatus(event, 400, 'Invalid medication id');
			return null;
		}

		const medicationQuery = `
			SELECT DISTINCT
				m.id,
				m.name,
				GROUP_CONCAT(DISTINCT cm.clinic_id ORDER BY cm.clinic_id) as clinicIds
			FROM medications m
			LEFT JOIN clinic_medications cm ON m.id = cm.medication_id
			WHERE m.id = ?
			GROUP BY m.id, m.name;
		`;

		const connection = await getConnection();
		const [medicationRows] = await connection.execute(medicationQuery, [
			body.medicationId,
		]);
		await connection.end();

		return medicationRows[0];
	} catch (error) {
		console.error('API Error - medication data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch medication data',
		});
	}
});

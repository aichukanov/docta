import { getConnection } from '~/server/common/db-mysql';
import { parseClinicPricesData } from '~/server/common/utils';
import type { ClinicServiceWithPrices } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<ClinicServiceWithPrices> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/services/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.serviceId)) {
				setResponseStatus(event, 400, 'Invalid medical service id');
				return null;
			}

			const medicalServiceQuery = `
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
			WHERE ms.id = ?
			GROUP BY ms.id, ms.name;
		`;

			const connection = await getConnection();
			const [medicalServiceRows] = await connection.execute(
				medicalServiceQuery,
				[body.serviceId],
			);
			await connection.end();

			const row = medicalServiceRows[0];
			if (!row) {
				return null;
			}

			return {
				id: row.id,
				name: row.name,
				clinicIds: row.clinicIds,
				clinicPrices: parseClinicPricesData(row.clinicPricesData),
			};
		} catch (error) {
			console.error('API Error - medical service data:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medical service data',
			});
		}
	},
);

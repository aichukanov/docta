import { getConnection } from '~/server/common/db-mysql';
import { parseClinicPricesData, getPriceOrderBySQL } from '~/server/common/utils';
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

			const priceOrder = getPriceOrderBySQL();
			const medicalServiceQuery = `
			SELECT DISTINCT
				ms.id,
				ms.name,
				(
					SELECT GROUP_CONCAT(clinic_id ORDER BY ${priceOrder})
					FROM clinic_medical_services
					WHERE medical_service_id = ms.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(clinic_id, ':', COALESCE(price, 0), ':', COALESCE(code, ''))
						ORDER BY ${priceOrder}
					)
					FROM clinic_medical_services
					WHERE medical_service_id = ms.id
				) as clinicPricesData
			FROM medical_services ms
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

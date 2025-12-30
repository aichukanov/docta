import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
} from '~/server/common/utils';
import type { ClinicServiceWithPrices } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<ClinicServiceWithPrices> => {
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

			const priceOrder = getPriceOrderBySQL();
			const medicationQuery = `
			SELECT DISTINCT
				m.id,
				m.name,
				(
					SELECT GROUP_CONCAT(clinic_id ORDER BY ${priceOrder})
					FROM clinic_medications
					WHERE medication_id = m.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(clinic_id, ':', COALESCE(price, 0), ':', COALESCE(code, ''))
						ORDER BY ${priceOrder}
					)
					FROM clinic_medications
					WHERE medication_id = m.id
				) as clinicPricesData
			FROM medications m
			WHERE m.id = ?
			GROUP BY m.id, m.name;
		`;

			const connection = await getConnection();
			const [medicationRows] = await connection.execute(medicationQuery, [
				body.medicationId,
			]);
			await connection.end();

			const row = medicationRows[0];
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
			console.error('API Error - medication data:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medication data',
			});
		}
	},
);

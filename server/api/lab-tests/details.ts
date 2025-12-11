import { getConnection } from '~/server/common/db-mysql';
import { parseClinicPricesData } from '~/server/common/utils';
import type { ClinicServiceWithPrices } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<ClinicServiceWithPrices> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/lab-tests/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.labTestId)) {
				setResponseStatus(event, 400, 'Invalid lab test id');
				return null;
			}

			const labTestQuery = `
			SELECT DISTINCT
				lt.id,
				lt.name,
				GROUP_CONCAT(DISTINCT clt.clinic_id ORDER BY clt.clinic_id) as clinicIds,
				GROUP_CONCAT(
					DISTINCT CONCAT(clt.clinic_id, ':', COALESCE(clt.price, 0), ':', COALESCE(clt.code, ''))
					ORDER BY clt.clinic_id
				) as clinicPricesData
			FROM lab_tests lt
			LEFT JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
			WHERE lt.id = ?
			GROUP BY lt.id, lt.name;
		`;

			const connection = await getConnection();
			const [labTestRows] = await connection.execute(labTestQuery, [
				body.labTestId,
			]);
			await connection.end();

			const row = labTestRows[0];
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
			console.error('API Error - lab test data:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch lab test data',
			});
		}
	},
);

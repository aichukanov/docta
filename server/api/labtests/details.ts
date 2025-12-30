import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getPriceOrderBySQL,
	getLocalizedNameField,
} from '~/server/common/utils';
import type { LabTestItem } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<LabTestItem | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/labtests/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.labTestId)) {
				setResponseStatus(event, 400, 'Invalid lab test id');
				return null;
			}

			const nameField = getLocalizedNameField(body.locale);
			const locale = body.locale || 'en';
			const priceOrder = getPriceOrderBySQL();

			const labTestQuery = `
			SELECT DISTINCT
				lt.id,
				COALESCE(NULLIF(lt.${nameField}, ''), NULLIF(lt.name_sr, ''), lt.name) as name,
				COALESCE(NULLIF(lt.name_sr, ''), lt.name) as originalName,
				(
					SELECT GROUP_CONCAT(clinic_id ORDER BY ${priceOrder})
					FROM clinic_lab_tests
					WHERE lab_test_id = lt.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(clinic_id, ':', COALESCE(price, 0), ':', COALESCE(code, ''))
						ORDER BY ${priceOrder}
					)
					FROM clinic_lab_tests
					WHERE lab_test_id = lt.id
				) as clinicPricesData,
				(SELECT GROUP_CONCAT(DISTINCT ltcr.category_id ORDER BY ltcr.category_id)
				 FROM lab_test_categories_relations ltcr
				 WHERE ltcr.lab_test_id = lt.id) as categoryIds
			FROM lab_tests lt
			WHERE lt.id = ?
			GROUP BY lt.id, lt.${nameField}, lt.name_sr, lt.name;
		`;

			const connection = await getConnection();
			const [labTestRows] = await connection.execute(labTestQuery, [
				body.labTestId,
			]);

			const row = (labTestRows as any[])[0];
			if (!row) {
				await connection.end();
				return null;
			}

			// Получаем синонимы на выбранном языке
			const synonymsQuery = `
				SELECT another_name
				FROM lab_test_synonyms
				WHERE lab_test_id = ?
				AND language = ?
				ORDER BY another_name ASC
			`;
			const [synonymRows] = await connection.execute(synonymsQuery, [
				body.labTestId,
				locale,
			]);
			await connection.end();

			const synonyms = (synonymRows as any[]).map((r) => r.another_name);

			return {
				id: row.id,
				name: row.name,
				originalName:
					row.originalName !== row.name ? row.originalName : undefined,
				synonyms,
				clinicIds: row.clinicIds,
				clinicPrices: parseClinicPricesData(row.clinicPricesData),
				categoryIds: row.categoryIds
					? row.categoryIds.split(',').map(Number)
					: undefined,
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

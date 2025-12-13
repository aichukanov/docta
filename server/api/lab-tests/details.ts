import { getConnection } from '~/server/common/db-mysql';
import { parseClinicPricesData } from '~/server/common/utils';
import type { LabTestItem } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

const LOCALE_TO_NAME_FIELD: Record<string, string> = {
	en: 'name',
	ru: 'name_ru',
	sr: 'name_sr',
	me: 'name_sr',
	de: 'name_de',
	tr: 'name_tr',
};

function getNameField(locale?: string): string {
	return LOCALE_TO_NAME_FIELD[locale || 'en'] || 'name';
}

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

			const nameField = getNameField(body.locale);
			const locale = body.locale || 'en';

			const labTestQuery = `
			SELECT DISTINCT
				lt.id,
				COALESCE(NULLIF(lt.${nameField}, ''), NULLIF(lt.name_sr, ''), lt.name) as name,
				COALESCE(NULLIF(lt.name_sr, ''), lt.name) as originalName,
				GROUP_CONCAT(DISTINCT clt.clinic_id ORDER BY clt.clinic_id) as clinicIds,
				GROUP_CONCAT(
					DISTINCT CONCAT(clt.clinic_id, ':', COALESCE(clt.price, 0), ':', COALESCE(clt.code, ''))
					ORDER BY clt.clinic_id
				) as clinicPricesData,
				(SELECT GROUP_CONCAT(DISTINCT ltcr.category_id ORDER BY ltcr.category_id)
				 FROM lab_test_categories_relations ltcr
				 WHERE ltcr.lab_test_id = lt.id) as categoryIds
			FROM lab_tests lt
			LEFT JOIN clinic_lab_tests clt ON lt.id = clt.lab_test_id
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

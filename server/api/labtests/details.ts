import { getConnection } from '~/server/common/db-mysql';
import {
	parseClinicPricesData,
	getClinicRankOrderBySQL,
	processLocalizedNameForLabTest,
	buildReferenceInfo,
} from '~/server/common/utils';
import type { LabTestItem } from '~/interfaces/clinic';
import { validateBody } from '~/common/validation';

export default defineEventHandler(
	async (event): Promise<LabTestItem | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/labtests/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid lab test slug');
				return null;
			}

			const locale = body.locale || 'en';
			// Порядок клиник: композитный скор без локации (rank_score + бонус
			// за цену); вклад расстояния добавит клиент (use-clinic-ranking.ts)
			const rankOrder = getClinicRankOrderBySQL('c_rank', 'clt');

			const labTestQuery = `
			SELECT DISTINCT
				lt.id,
				lt.slug,
				lt.name_en,
				lt.name_sr,
				lt.name_sr_cyrl,
				lt.name_ru,
				lt.name_de,
				lt.name_tr,
				(
					SELECT GROUP_CONCAT(clt.clinic_id ORDER BY ${rankOrder})
					FROM clinic_lab_tests clt
					JOIN clinics c_rank ON c_rank.id = clt.clinic_id AND c_rank.status = 'published'
					WHERE clt.lab_test_id = lt.id
				) as clinicIds,
				(
					SELECT GROUP_CONCAT(
						CONCAT(clt.clinic_id, ':', IFNULL(clt.price, ''), ':', '', ':', IFNULL(clt.price_max, ''), ':', COALESCE(clt.code, ''), ':', clt.is_price_outdated)
						ORDER BY ${rankOrder}
					)
					FROM clinic_lab_tests clt
					JOIN clinics c_rank ON c_rank.id = clt.clinic_id AND c_rank.status = 'published'
					WHERE clt.lab_test_id = lt.id
				) as clinicPricesData,
				(SELECT GROUP_CONCAT(DISTINCT ltcr.category_id ORDER BY ltcr.category_id)
				 FROM lab_test_categories_relations ltcr
				 WHERE ltcr.lab_test_id = lt.id) as categoryIds
			FROM lab_tests lt
			WHERE lt.slug = ?;
		`;

			const connection = await getConnection();
			const [labTestRows] = await connection.execute(labTestQuery, [body.slug]);

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
				row.id,
				locale,
			]);

			const [referenceInfoRows] = await connection.execute(
				`SELECT * FROM lab_test_reference_info WHERE lab_test_id = ?`,
				[row.id],
			);
			await connection.end();

			const synonyms = (synonymRows as any[]).map((r) => r.another_name);

			// Обрабатываем локализованные имена
			const { name, localName } = processLocalizedNameForLabTest(row, locale);

			return {
				id: row.id,
				slug: row.slug,
				name: name || '',
				localName: localName || '',
				synonyms,
				clinicIds: row.clinicIds,
				clinicPrices: parseClinicPricesData(row.clinicPricesData),
				categoryIds: row.categoryIds
					? row.categoryIds.split(',').map(Number)
					: undefined,
				referenceInfo: buildReferenceInfo(
					(referenceInfoRows as any[])[0],
					locale,
				),
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

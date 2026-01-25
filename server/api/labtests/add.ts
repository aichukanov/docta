import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody } from '~/common/validation';
import type { ClinicPrice, LabTestNames } from '~/interfaces/clinic';

interface AddLabTestBody extends LabTestNames {
	categoryIds?: number[];
	clinicPrices?: ClinicPrice[];
}

export default defineEventHandler(async (event): Promise<number | null> => {
	try {
		requireAdmin(event);

		const body: AddLabTestBody = await readBody(event);

		if (!validateBody(body, 'api/labtests/add')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.name || !body.name_sr) {
			setResponseStatus(event, 400, 'Name and name_sr are required');
			return null;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// 1. Создаём анализ
			const insertQuery = `
				INSERT INTO lab_tests (name_en, name_sr, name_sr_cyrl, name_ru, name_de, name_tr)
				VALUES (?, ?, ?, ?, ?, ?)
			`;
			const [result]: any = await connection.execute(insertQuery, [
				body.name,
				body.name_sr,
				body.name_sr_cyrl || '',
				body.name_ru || '',
				body.name_de || '',
				body.name_tr || '',
			]);

			const labTestId = result.insertId;

			// 2. Добавляем категории
			if (body.categoryIds?.length > 0) {
				const categoryValues = body.categoryIds
					.map((catId) => `(${labTestId}, ${catId})`)
					.join(',');
				await connection.execute(
					`INSERT INTO lab_test_categories_relations (lab_test_id, category_id) VALUES ${categoryValues}`,
				);
			}

			// 3. Добавляем связи с клиниками (с ценой и кодом)
			if (body.clinicPrices?.length > 0) {
				for (const cp of body.clinicPrices) {
					await connection.execute(
						`INSERT INTO clinic_lab_tests (lab_test_id, clinic_id, price, price_max, code) VALUES (?, ?, ?, ?, ?)`,
						[
							labTestId,
							cp.clinicId,
							cp.price || null,
							cp.priceMax || null,
							cp.code || null,
						],
					);
				}
			}

			await connection.commit();
			await connection.end();

			return labTestId;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - lab test add:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to add lab test',
		});
	}
});

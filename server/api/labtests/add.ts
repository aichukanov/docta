import { getConnection } from '~/server/common/db-mysql';
import { validateBody } from '~/common/validation';

interface AddLabTestBody {
	name: string;
	name_sr: string;
	name_ru?: string;
	name_de?: string;
	name_tr?: string;
	categoryIds?: number[];
	clinicIds?: number[];
}

export default defineEventHandler(async (event): Promise<number | null> => {
	try {
		const adminCookie = getCookie(event, 'adm');
		if (adminCookie !== 'xpycm') {
			throw createError({ statusCode: 404, statusMessage: 'Not found' });
		}

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
				INSERT INTO lab_tests (name, name_sr, name_ru, name_de, name_tr)
				VALUES (?, ?, ?, ?, ?)
			`;
			const [result]: any = await connection.execute(insertQuery, [
				body.name,
				body.name_sr,
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

			// 3. Добавляем связи с клиниками (без цены и кода)
			if (body.clinicIds?.length > 0) {
				const clinicValues = body.clinicIds
					.map((clinicId) => `(${labTestId}, ${clinicId})`)
					.join(',');
				await connection.execute(
					`INSERT INTO clinic_lab_tests (lab_test_id, clinic_id) VALUES ${clinicValues}`,
				);
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

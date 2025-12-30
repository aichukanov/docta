import { getConnection } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		const adminCookie = getCookie(event, 'adm');
		if (adminCookie !== 'xpycm') {
			throw createError({ statusCode: 404, statusMessage: 'Not found' });
		}

		const body = await readBody(event);

		if (!validateBody(body, 'api/labtests/remove')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.labTestId)) {
			setResponseStatus(event, 400, 'Invalid lab test id');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Удаляем связи
			await connection.execute(
				'DELETE FROM clinic_lab_tests WHERE lab_test_id = ?',
				[body.labTestId],
			);
			await connection.execute(
				'DELETE FROM lab_test_categories_relations WHERE lab_test_id = ?',
				[body.labTestId],
			);
			await connection.execute(
				'DELETE FROM lab_test_synonyms WHERE lab_test_id = ?',
				[body.labTestId],
			);

			// Удаляем анализ
			const [result]: any = await connection.execute(
				'DELETE FROM lab_tests WHERE id = ?',
				[body.labTestId],
			);

			await connection.commit();
			await connection.end();

			return result.affectedRows > 0;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - lab test remove:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to remove lab test',
		});
	}
});

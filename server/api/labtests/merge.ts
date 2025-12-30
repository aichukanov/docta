import { getConnection } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		const adminCookie = getCookie(event, 'adm');
		if (adminCookie !== 'xpycm') {
			throw createError({ statusCode: 404, statusMessage: 'Not found' });
		}

		const body = await readBody(event);

		if (!validateBody(body, 'api/labtests/merge')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.primaryLabTestId)) {
			setResponseStatus(event, 400, 'Invalid primary lab test id');
			return false;
		}

		if (!validateNonNegativeInteger(body.secondaryLabTestId)) {
			setResponseStatus(event, 400, 'Invalid secondary lab test id');
			return false;
		}

		if (body.primaryLabTestId === body.secondaryLabTestId) {
			setResponseStatus(event, 400, 'Cannot merge lab test with itself');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// Проверяем существование обоих анализов
			const [labTestRows]: any = await connection.execute(
				'SELECT id, name_sr FROM lab_tests WHERE id IN (?, ?)',
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			if (labTestRows.length !== 2) {
				throw createError({
					statusCode: 400,
					statusMessage: 'One or both lab tests not found',
				});
			}

			const secondaryLabTest = labTestRows.find(
				(r: any) => r.id === body.secondaryLabTestId,
			);

			// 1. Переносим связи с клиниками (без дублирования)
			await connection.execute(
				`INSERT IGNORE INTO clinic_lab_tests (lab_test_id, clinic_id, price, code)
				 SELECT ?, clinic_id, price, code
				 FROM clinic_lab_tests
				 WHERE lab_test_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			// 2. Переносим категории (без дублирования)
			await connection.execute(
				`INSERT IGNORE INTO lab_test_categories_relations (lab_test_id, category_id)
				 SELECT ?, category_id
				 FROM lab_test_categories_relations
				 WHERE lab_test_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			// 3. Переносим синонимы
			await connection.execute(
				`UPDATE lab_test_synonyms SET lab_test_id = ? WHERE lab_test_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);

			// 4. Добавляем название удаляемого анализа как синоним
			if (secondaryLabTest?.name_sr) {
				await connection.execute(
					`INSERT IGNORE INTO lab_test_synonyms (lab_test_id, another_name, language)
					 VALUES (?, ?, 'me')`,
					[body.primaryLabTestId, secondaryLabTest.name_sr],
				);
			}

			// 5. Удаляем связи удаляемого анализа
			await connection.execute(
				'DELETE FROM clinic_lab_tests WHERE lab_test_id = ?',
				[body.secondaryLabTestId],
			);
			await connection.execute(
				'DELETE FROM lab_test_categories_relations WHERE lab_test_id = ?',
				[body.secondaryLabTestId],
			);

			// 6. Обновляем существующие редиректы и добавляем новый
			await connection.execute(
				`UPDATE lab_test_redirects SET new_id = ? WHERE new_id = ?`,
				[body.primaryLabTestId, body.secondaryLabTestId],
			);
			await connection.execute(
				`INSERT IGNORE INTO lab_test_redirects (old_id, new_id) VALUES (?, ?)`,
				[body.secondaryLabTestId, body.primaryLabTestId],
			);

			// 7. Удаляем анализ
			const [result]: any = await connection.execute(
				'DELETE FROM lab_tests WHERE id = ?',
				[body.secondaryLabTestId],
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
		console.error('API Error - lab test merge:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to merge lab tests',
		});
	}
});

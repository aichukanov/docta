import { getConnection } from '~/server/common/db-mysql';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

interface ClinicPrice {
	clinicId: number;
	price?: number | null;
	code?: string | null;
}

interface UpdateLabTestBody {
	id: number;
	name: string;
	name_sr: string;
	name_ru: string;
	name_de: string;
	name_tr: string;
	categoryIds: number[];
	clinicPrices: ClinicPrice[];
	synonyms: { language: string; values: string[] }[];
}

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		const adminCookie = getCookie(event, 'adm');
		if (adminCookie !== 'xpycm') {
			throw createError({ statusCode: 404, statusMessage: 'Not found' });
		}

		const body: UpdateLabTestBody = await readBody(event);

		if (!validateBody(body, 'api/labtests/update')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.id)) {
			setResponseStatus(event, 400, 'Invalid lab test id');
			return false;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			// 1. Обновляем основные данные анализа
			const updateQuery = `
				UPDATE lab_tests SET
					name = ?,
					name_sr = ?,
					name_ru = ?,
					name_de = ?,
					name_tr = ?
				WHERE id = ?
			`;
			await connection.execute(updateQuery, [
				body.name,
				body.name_sr,
				body.name_ru,
				body.name_de,
				body.name_tr,
				body.id,
			]);

			// 2. Обновляем категории (только дифф)
			const [existingCategories]: any = await connection.execute(
				'SELECT category_id FROM lab_test_categories_relations WHERE lab_test_id = ?',
				[body.id],
			);
			const existingCategoryIds = existingCategories.map(
				(row: any) => row.category_id,
			);
			const newCategoryIds = body.categoryIds || [];

			const categoriesToRemove = existingCategoryIds.filter(
				(id: number) => !newCategoryIds.includes(id),
			);
			const categoriesToAdd = newCategoryIds.filter(
				(id: number) => !existingCategoryIds.includes(id),
			);

			if (categoriesToRemove.length > 0) {
				const placeholders = categoriesToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM lab_test_categories_relations WHERE lab_test_id = ? AND category_id IN (${placeholders})`,
					[body.id, ...categoriesToRemove],
				);
			}

			for (const categoryId of categoriesToAdd) {
				await connection.execute(
					'INSERT INTO lab_test_categories_relations (lab_test_id, category_id) VALUES (?, ?)',
					[body.id, categoryId],
				);
			}

			// 3. Обновляем цены клиник (только дифф)
			const [existingClinicPrices]: any = await connection.execute(
				'SELECT clinic_id, price, code FROM clinic_lab_tests WHERE lab_test_id = ?',
				[body.id],
			);
			const existingClinicIds = existingClinicPrices.map(
				(row: any) => row.clinic_id,
			);
			const newClinicPrices = body.clinicPrices || [];
			const newClinicIds = newClinicPrices.map((cp) => cp.clinicId);

			// Удаляем клиники, которых больше нет
			const clinicsToRemove = existingClinicIds.filter(
				(id: number) => !newClinicIds.includes(id),
			);
			if (clinicsToRemove.length > 0) {
				const placeholders = clinicsToRemove.map(() => '?').join(',');
				await connection.execute(
					`DELETE FROM clinic_lab_tests WHERE lab_test_id = ? AND clinic_id IN (${placeholders})`,
					[body.id, ...clinicsToRemove],
				);
			}

			// Обновляем или добавляем клиники
			for (const cp of newClinicPrices) {
				const existing = existingClinicPrices.find(
					(e: any) => e.clinic_id === cp.clinicId,
				);
				if (existing) {
					// Обновляем только если изменилось
					if (existing.price !== cp.price || existing.code !== cp.code) {
						await connection.execute(
							'UPDATE clinic_lab_tests SET price = ?, code = ? WHERE lab_test_id = ? AND clinic_id = ?',
							[cp.price || null, cp.code || null, body.id, cp.clinicId],
						);
					}
				} else {
					// Добавляем новую
					await connection.execute(
						'INSERT INTO clinic_lab_tests (lab_test_id, clinic_id, price, code) VALUES (?, ?, ?, ?)',
						[body.id, cp.clinicId, cp.price || null, cp.code || null],
					);
				}
			}

			// 4. Обновляем синонимы
			await connection.execute(
				'DELETE FROM lab_test_synonyms WHERE lab_test_id = ?',
				[body.id],
			);

			if (body.synonyms?.length > 0) {
				for (const langSynonyms of body.synonyms) {
					for (const synonym of langSynonyms.values) {
						if (synonym.trim()) {
							await connection.execute(
								'INSERT INTO lab_test_synonyms (lab_test_id, another_name, language) VALUES (?, ?, ?)',
								[body.id, synonym.trim(), langSynonyms.language],
							);
						}
					}
				}
			}

			await connection.commit();
			await connection.end();

			return true;
		} catch (err) {
			await connection.rollback();
			await connection.end();
			throw err;
		}
	} catch (error) {
		console.error('API Error - lab test update:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to update lab test',
		});
	}
});

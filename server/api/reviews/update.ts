import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/reviews/update')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.id)) {
			setResponseStatus(event, 400, 'Invalid review id');
			return null;
		}

		const connection = await getConnection();

		try {
			await connection.beginTransaction();

			await connection.execute(
				`UPDATE reviews SET
					user_id = ?,
					clinic_id = ?,
					doctor_id = ?,
					medical_service_id = ?,
					rating = ?,
					original_language = ?,
					original_text = ?,
					text_sr = ?,
					text_sr_cyrl = ?,
					text_en = ?,
					text_ru = ?,
					text_de = ?,
					text_tr = ?
				WHERE id = ?`,
				[
					body.userId || null,
					body.clinicId || null,
					body.doctorId || null,
					body.medicalServiceId || null,
					body.rating || null,
					body.originalLanguage || '',
					body.originalText || '',
					body.text_sr || '',
					body.text_sr_cyrl || '',
					body.text_en || '',
					body.text_ru || '',
					body.text_de || '',
					body.text_tr || '',
					body.id,
				],
			);

			// Обновляем существующие ответы (только те, что уже есть в БД)
			if (Array.isArray(body.replies)) {
				for (const reply of body.replies) {
					if (!validateNonNegativeInteger(reply.id)) continue;
					await connection.execute(
						`UPDATE review_replies SET
							original_language = ?,
							original_text = ?,
							text_sr = ?,
							text_sr_cyrl = ?,
							text_en = ?,
							text_ru = ?,
							text_de = ?,
							text_tr = ?
						WHERE id = ? AND review_id = ?`,
						[
							reply.originalLanguage || '',
							reply.originalText || '',
							reply.text_sr || '',
							reply.text_sr_cyrl || '',
							reply.text_en || '',
							reply.text_ru || '',
							reply.text_de || '',
							reply.text_tr || '',
							reply.id,
							body.id,
						],
					);
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
		console.error('API Error - review update:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to update review',
		});
	}
});

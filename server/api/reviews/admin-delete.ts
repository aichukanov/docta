import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<boolean> => {
	try {
		await requireAdmin(event);

		const body = await readBody(event);

		if (!validateBody(body, 'api/reviews/admin-delete')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return false;
		}

		if (!validateNonNegativeInteger(body.reviewId)) {
			setResponseStatus(event, 400, 'Invalid review id');
			return false;
		}

		const connection = await getConnection();

		const [result]: any = await connection.execute(
			'DELETE FROM reviews WHERE id = ?',
			[body.reviewId],
		);

		await connection.end();

		return result.affectedRows > 0;
	} catch (error) {
		console.error('API Error - review admin-delete:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to delete review',
		});
	}
});

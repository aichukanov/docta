import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import {
	ERROR_CODES,
	SUCCESS_CODES,
	createErrorResponse,
	createSuccessResponse,
} from '~/server/utils/api-codes';

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);
	if (!user) {
		return createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const { reviewId } = body;

	if (!reviewId || typeof reviewId !== 'number') {
		return createErrorResponse(400, ERROR_CODES.REVIEW_NOT_FOUND);
	}

	// Verify review exists and belongs to user
	const rows = await executeQuery<{ id: number; user_id: number }>(
		`SELECT id, user_id FROM reviews WHERE id = ? AND provider = 'docta_me'`,
		[reviewId],
	);
	if (rows.length === 0) {
		return createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}
	if (rows[0].user_id !== user.id) {
		return createErrorResponse(403, ERROR_CODES.REVIEW_NOT_OWN);
	}

	// Delete replies first, then the review
	await executeQuery('DELETE FROM review_replies WHERE review_id = ?', [reviewId]);
	await executeQuery('DELETE FROM reviews WHERE id = ?', [reviewId]);

	return createSuccessResponse(SUCCESS_CODES.REVIEW_DELETED);
});

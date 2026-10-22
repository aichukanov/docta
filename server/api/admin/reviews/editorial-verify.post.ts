import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import type { User } from '~/server/utils/session';
import {
	ERROR_CODES,
	SUCCESS_CODES,
	createErrorResponse,
	createSuccessResponse,
} from '~/server/utils/api-codes';

/**
 * Редакционная верификация: is_verified без файла от автора — редакция видела
 * документы вне платформы (переписка, платёжные документы). Комментарий
 * обязателен: это запись в журнале, ЧТО именно видела редакция. Файловый путь
 * (verify.post.ts) продолжает работать независимо.
 * POST { reviewId, verified: boolean, comment }
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);
	const moderator = event.context.user as User;

	const body = await readBody(event);
	const reviewId = parseInt(String(body?.reviewId || ''), 10);
	const verified = body?.verified === true;
	const comment = typeof body?.comment === 'string' ? body.comment.trim() : '';

	if (!reviewId || reviewId <= 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}
	if (!comment) {
		createErrorResponse(400, ERROR_CODES.REVIEW_COMMENT_REQUIRED);
	}

	const rows = await executeQuery<{ id: number }>(
		'SELECT id FROM reviews WHERE id = ?',
		[reviewId],
	);
	if (rows.length === 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}

	await executeQuery('UPDATE reviews SET is_verified = ? WHERE id = ?', [
		verified,
		reviewId,
	]);

	await executeQuery(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id, comment)
		VALUES (?, ?, ?, ?)`,
		[
			reviewId,
			verified ? 'editorial_verified' : 'editorial_unverified',
			moderator.id,
			comment,
		],
	);

	return createSuccessResponse(
		SUCCESS_CODES.REVIEW_EDITORIAL_VERIFICATION_UPDATED,
		{ verified },
	);
});

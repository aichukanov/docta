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
 * Модерация отзыва: одобрить или отклонить (с обязательной причиной).
 * POST { reviewId, action: 'approve' | 'reject', reason? }
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);
	const moderator = event.context.user as User;

	const body = await readBody(event);
	const reviewId = parseInt(String(body?.reviewId || ''), 10);
	const action = body?.action;
	const reason = typeof body?.reason === 'string' ? body.reason.trim() : '';

	if (!reviewId || reviewId <= 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}
	if (!['approve', 'reject'].includes(action)) {
		createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ACTION);
	}
	if (action === 'reject' && !reason) {
		createErrorResponse(400, ERROR_CODES.REVIEW_REASON_REQUIRED);
	}

	const rows = await executeQuery<{ id: number }>(
		'SELECT id FROM reviews WHERE id = ?',
		[reviewId],
	);
	if (rows.length === 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}

	const newStatus = action === 'approve' ? 'approved' : 'rejected';

	await executeQuery(
		`UPDATE reviews
		SET status = ?, moderated_by = ?, moderated_at = NOW(), rejection_reason = ?
		WHERE id = ?`,
		[newStatus, moderator.id, action === 'reject' ? reason : null, reviewId],
	);

	await executeQuery(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id, comment)
		VALUES (?, ?, ?, ?)`,
		[reviewId, newStatus, moderator.id, reason || null],
	);

	return createSuccessResponse(SUCCESS_CODES.REVIEW_MODERATED, {
		status: newStatus,
	});
});

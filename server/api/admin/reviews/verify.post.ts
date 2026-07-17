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
 * Модерация файла верификации: approve ставит отзыву is_verified = TRUE.
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
		createErrorResponse(404, ERROR_CODES.REVIEW_VERIFICATION_NOT_FOUND);
	}
	if (!['approve', 'reject'].includes(action)) {
		createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_ACTION);
	}

	const rows = await executeQuery<{ id: number }>(
		'SELECT id FROM review_verification_files WHERE review_id = ?',
		[reviewId],
	);
	if (rows.length === 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_VERIFICATION_NOT_FOUND);
	}

	const newStatus = action === 'approve' ? 'approved' : 'rejected';

	await executeQuery(
		`UPDATE review_verification_files
		SET status = ?, reviewed_at = NOW(), reviewed_by = ?, rejection_reason = ?
		WHERE review_id = ?`,
		[newStatus, moderator.id, action === 'reject' ? reason || null : null, reviewId],
	);

	await executeQuery('UPDATE reviews SET is_verified = ? WHERE id = ?', [
		action === 'approve',
		reviewId,
	]);

	await executeQuery(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id, comment)
		VALUES (?, ?, ?, ?)`,
		[
			reviewId,
			action === 'approve' ? 'verification_approved' : 'verification_rejected',
			moderator.id,
			reason || null,
		],
	);

	return createSuccessResponse(SUCCESS_CODES.VERIFICATION_MODERATED, {
		status: newStatus,
	});
});

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
 * Закрепление отзыва: закреплённый всегда первый в выдаче при любой сортировке
 * (ORDER BY-префикс в server/common/reviews.ts). Работает для отзывов любого
 * провайдера; реджект снимает закрепление (см. moderate.post.ts).
 * POST { reviewId, pinned: boolean }
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);
	const moderator = event.context.user as User;

	const body = await readBody(event);
	const reviewId = parseInt(String(body?.reviewId || ''), 10);
	const pinned = body?.pinned === true;

	if (!reviewId || reviewId <= 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}

	const rows = await executeQuery<{ id: number; status: string }>(
		'SELECT id, status FROM reviews WHERE id = ?',
		[reviewId],
	);
	if (rows.length === 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}
	// Закреплять можно только одобренный отзыв: pending/rejected наверху
	// публичной выдачи делать нечего
	if (pinned && rows[0].status !== 'approved') {
		createErrorResponse(400, ERROR_CODES.REVIEW_NOT_APPROVED);
	}

	await executeQuery(
		'UPDATE reviews SET is_pinned = ?, pinned_at = ? WHERE id = ?',
		[pinned, pinned ? new Date() : null, reviewId],
	);

	await executeQuery(
		`INSERT INTO review_moderation_logs (review_id, action, moderator_id, comment)
		VALUES (?, ?, ?, NULL)`,
		[reviewId, pinned ? 'pinned' : 'unpinned', moderator.id],
	);

	return createSuccessResponse(SUCCESS_CODES.REVIEW_PIN_UPDATED, { pinned });
});

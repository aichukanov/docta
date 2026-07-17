import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import { ERROR_CODES, createErrorResponse } from '~/server/utils/api-codes';
import { getVerificationsRoot } from '~/server/utils/image-processing';

/**
 * Отдаёт файл верификации отзыва (изображение). Доступ: автор отзыва или админ.
 * GET /api/reviews/verification-file?reviewId=N
 */
export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);
	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const query = getQuery(event);
	const reviewId = parseInt(String(query.reviewId || ''), 10);
	if (!reviewId || reviewId <= 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_VERIFICATION_NOT_FOUND);
	}

	const rows = await executeQuery<{
		user_id: number | null;
		stored_name: string;
		file_type: string;
	}>(
		`SELECT r.user_id, vf.stored_name, vf.file_type
		FROM review_verification_files vf
		JOIN reviews r ON r.id = vf.review_id
		WHERE vf.review_id = ?`,
		[reviewId],
	);

	if (rows.length === 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_VERIFICATION_NOT_FOUND);
	}

	const isAuthor = rows[0].user_id === user!.id;
	if (!isAuthor && !user!.is_admin) {
		createErrorResponse(403, ERROR_CODES.FORBIDDEN);
	}

	// stored_name — UUID, сгенерированный сервером; на всякий случай отсекаем
	// любые попытки path traversal из БД
	const storedName = rows[0].stored_name.replace(/[/\\]/g, '');

	try {
		const file = await readFile(join(getVerificationsRoot(), storedName));
		setHeader(event, 'Content-Type', rows[0].file_type || 'image/webp');
		setHeader(event, 'Cache-Control', 'private, no-store');
		return file;
	} catch {
		createErrorResponse(404, ERROR_CODES.REVIEW_VERIFICATION_NOT_FOUND);
	}
});

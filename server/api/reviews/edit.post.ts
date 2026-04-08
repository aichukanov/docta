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
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const { reviewId, rating, text, locale } = body;

	if (!reviewId || typeof reviewId !== 'number') {
		createErrorResponse(400, ERROR_CODES.REVIEW_NOT_FOUND);
	}

	if (!rating || typeof rating !== 'number' || rating < 1 || rating > 5) {
		createErrorResponse(400, ERROR_CODES.REVIEW_INVALID_RATING);
	}

	const trimmedText = (text || '').trim();

	// Verify review exists and belongs to user
	const rows = await executeQuery<{ id: number; user_id: number }>(
		`SELECT id, user_id FROM reviews WHERE id = ? AND provider = 'docta_me'`,
		[reviewId],
	);
	if (rows.length === 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}
	if (rows[0].user_id !== user!.id) {
		createErrorResponse(403, ERROR_CODES.REVIEW_NOT_OWN);
	}

	const validLocales = ['sr', 'sr-cyrl', 'en', 'ru', 'de', 'tr'];
	const originalLanguage = validLocales.includes(locale) ? locale : 'en';

	const localeToColumn: Record<string, string> = {
		'sr': 'text_sr',
		'sr-cyrl': 'text_sr_cyrl',
		'en': 'text_en',
		'ru': 'text_ru',
		'de': 'text_de',
		'tr': 'text_tr',
	};
	const textColumn = localeToColumn[originalLanguage] || 'text_en';

	await executeQuery(
		`UPDATE reviews
		SET rating = ?, original_language = ?, original_text = ?, ${textColumn} = ?, updated_at = NOW()
		WHERE id = ?`,
		[rating, originalLanguage, trimmedText, trimmedText, reviewId],
	);

	return createSuccessResponse(SUCCESS_CODES.REVIEW_UPDATED);
});

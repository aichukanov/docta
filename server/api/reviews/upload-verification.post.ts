import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import {
	ERROR_CODES,
	SUCCESS_CODES,
	createErrorResponse,
	createSuccessResponse,
} from '~/server/utils/api-codes';
import {
	createModuleLogger,
	logOperation,
	logError,
} from '~/server/utils/logger';
import {
	validateImageFile,
	processAndSaveVerificationImage,
	deleteVerificationImage,
} from '~/server/utils/image-processing';

const verificationLogger = createModuleLogger('review-verification');

/**
 * Загрузка файла верификации (чек/направление) к собственному отзыву.
 * Файл — персональные данные: хранится вне public/, доступен только
 * автору и админу через /api/reviews/verification-file.
 */
export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);
	if (!user) {
		createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const formData = await readMultipartFormData(event);
	if (!formData) {
		createErrorResponse(400, ERROR_CODES.NO_FILE);
	}

	const fileField = formData!.find((f) => f.name === 'file');
	const reviewIdField = formData!.find((f) => f.name === 'reviewId');
	const reviewId = parseInt(reviewIdField?.data?.toString() || '', 10);

	if (!reviewId || reviewId <= 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}

	const validationError = validateImageFile(
		fileField ? { type: fileField.type, size: fileField.data?.length } : null,
	);
	if (validationError) {
		createErrorResponse(
			400,
			ERROR_CODES[validationError as keyof typeof ERROR_CODES],
		);
	}

	const reviewRows = await executeQuery<{ id: number; user_id: number }>(
		`SELECT id, user_id FROM reviews
		WHERE id = ? AND provider = 'docta_me'`,
		[reviewId],
	);
	if (reviewRows.length === 0) {
		createErrorResponse(404, ERROR_CODES.REVIEW_NOT_FOUND);
	}
	if (reviewRows[0].user_id !== user!.id) {
		createErrorResponse(403, ERROR_CODES.REVIEW_NOT_OWN);
	}

	// Повторная загрузка разрешена только после отклонения модератором:
	// отклонённый файл заменяется, pending/approved — нет
	const existing = await executeQuery<{
		id: number;
		status: string;
		stored_name: string;
	}>(
		'SELECT id, status, stored_name FROM review_verification_files WHERE review_id = ?',
		[reviewId],
	);
	if (existing.length > 0 && existing[0].status !== 'rejected') {
		createErrorResponse(409, ERROR_CODES.REVIEW_VERIFICATION_EXISTS);
	}

	let storedName: string | null = null;
	try {
		const saved = await processAndSaveVerificationImage(fileField!.data);
		storedName = saved.storedName;

		if (existing.length > 0) {
			// Замена отклонённого файла. Гард по status в WHERE закрывает гонку
			// двойной отправки: вторая замена не находит rejected-строку
			const updateResult: any = await executeQuery(
				`UPDATE review_verification_files
				SET stored_name = ?, file_name = ?, file_type = 'image/webp',
					file_size = ?, status = 'pending', uploaded_at = NOW(),
					reviewed_at = NULL, reviewed_by = NULL, rejection_reason = NULL
				WHERE id = ? AND status = 'rejected'`,
				[
					saved.storedName,
					fileField!.filename || null,
					saved.size,
					existing[0].id,
				],
			);
			if (!updateResult?.affectedRows) {
				createErrorResponse(409, ERROR_CODES.REVIEW_VERIFICATION_EXISTS);
			}
			await deleteVerificationImage(existing[0].stored_name).catch(() => {});
		} else {
			await executeQuery(
				`INSERT INTO review_verification_files
					(review_id, stored_name, file_name, file_type, file_size, status)
				VALUES (?, ?, ?, ?, ?, 'pending')`,
				[
					reviewId,
					saved.storedName,
					fileField!.filename || null,
					'image/webp',
					saved.size,
				],
			);
		}

		await executeQuery(
			`INSERT INTO review_moderation_logs (review_id, action, moderator_id)
			VALUES (?, 'verification_uploaded', NULL)`,
			[reviewId],
		);

		logOperation(verificationLogger, 'Verification file uploaded', {
			userId: user!.id,
			reviewId,
		});

		return createSuccessResponse(SUCCESS_CODES.VERIFICATION_UPLOADED, {
			status: 'pending',
		});
	} catch (error: any) {
		// Файл уже записан на диск — не оставляем сироту с персональными данными
		if (storedName) {
			await deleteVerificationImage(storedName).catch(() => {});
		}
		// Гонка двойной отправки: параллельный INSERT успел первым —
		// это конфликт (верификация уже существует), а не сбой загрузки
		if (error?.code === 'ER_DUP_ENTRY') {
			createErrorResponse(409, ERROR_CODES.REVIEW_VERIFICATION_EXISTS);
		}
		if (error?.statusCode) {
			throw error;
		}
		logError(verificationLogger, 'Verification upload failed', error, {
			userId: user!.id,
			reviewId,
		});
		return createErrorResponse(500, ERROR_CODES.UPLOAD_FAILED);
	}
});

import { join } from 'node:path';
import { unlink } from 'node:fs/promises';
import { getCurrentUser } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';
import {
	SUCCESS_CODES,
	ERROR_CODES,
	createSuccessResponse,
	createErrorResponse,
} from '~/server/utils/api-codes';
import {
	createModuleLogger,
	logOperation,
	logError,
} from '~/server/utils/logger';
import {
	VALID_CATEGORIES,
	type ImageCategory,
} from '~/server/utils/image-processing';

const uploadLogger = createModuleLogger('upload');

function getPhotoUrlQuery(category: ImageCategory, userId: number) {
	switch (category) {
		case 'avatars':
			return {
				sql: 'SELECT photo_url FROM auth_users WHERE id = ?',
				clearSql: "UPDATE auth_users SET photo_url = '' WHERE id = ?",
				params: [userId],
			};
		case 'doctors':
			return {
				sql: 'SELECT photo_url FROM doctors WHERE user_id = ?',
				clearSql: "UPDATE doctors SET photo_url = '' WHERE user_id = ?",
				params: [userId],
			};
		default:
			return null;
	}
}

/**
 * Удаляет файл с диска, если URL указывает на локальный upload.
 * Внешние URL (OAuth-аватары и т.п.) не трогает.
 */
async function deleteFileFromDisk(photoUrl: string) {
	if (!photoUrl || !photoUrl.startsWith('/uploads/')) return;

	const filePath = join(process.cwd(), 'public', photoUrl);
	try {
		await unlink(filePath);
	} catch {
		// файл уже удалён или не существует — не критично
	}
}

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		return createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const body = await readBody(event);
	const category = body?.category as ImageCategory | undefined;

	if (!category || !VALID_CATEGORIES.includes(category)) {
		return createErrorResponse(400, ERROR_CODES.INVALID_FILE_TYPE);
	}

	try {
		const query = getPhotoUrlQuery(category, user.id);
		if (!query) {
			return createSuccessResponse(SUCCESS_CODES.PHOTO_UPDATED);
		}

		const rows = await executeQuery<{ photo_url: string }>(
			query.sql,
			query.params,
		);
		const currentUrl = rows[0]?.photo_url || '';

		await deleteFileFromDisk(currentUrl);
		await executeQuery(query.clearSql, query.params);

		logOperation(uploadLogger, 'Photo removed', {
			userId: user.id,
			category,
			deletedUrl: currentUrl,
		});

		return createSuccessResponse(SUCCESS_CODES.PHOTO_UPDATED);
	} catch (error: any) {
		logError(uploadLogger, 'Photo removal failed', error, {
			userId: user.id,
			category,
		});
		return createErrorResponse(500, ERROR_CODES.UPLOAD_FAILED);
	}
});

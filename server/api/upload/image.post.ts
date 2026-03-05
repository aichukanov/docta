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
	validateImageFile,
	processAndSaveImage,
	VALID_CATEGORIES,
	type ImageCategory,
} from '~/server/utils/image-processing';

const uploadLogger = createModuleLogger('upload');

function getQueryConfig(category: ImageCategory, userId: number) {
	switch (category) {
		case 'avatars':
			return {
				selectSql: 'SELECT photo_url FROM auth_users WHERE id = ?',
				updateSql: 'UPDATE auth_users SET photo_url = ? WHERE id = ?',
				params: [userId],
			};
		case 'doctors':
			return {
				selectSql: 'SELECT photo_url FROM doctors WHERE user_id = ?',
				updateSql: 'UPDATE doctors SET photo_url = ? WHERE user_id = ?',
				params: [userId],
			};
		default:
			return null;
	}
}

async function deleteOldFile(photoUrl: string) {
	if (!photoUrl || !photoUrl.startsWith('/uploads/')) return;
	try {
		await unlink(join(process.cwd(), 'public', photoUrl));
	} catch {
		// файл не существует — ок
	}
}

export default defineEventHandler(async (event) => {
	const user = await getCurrentUser(event);

	if (!user) {
		return createErrorResponse(401, ERROR_CODES.UNAUTHORIZED);
	}

	const formData = await readMultipartFormData(event);
	if (!formData) {
		return createErrorResponse(400, ERROR_CODES.NO_FILE);
	}

	const fileField = formData.find((f) => f.name === 'file');
	const categoryField = formData.find((f) => f.name === 'category');

	const category = categoryField?.data?.toString() as ImageCategory | undefined;
	if (!category || !VALID_CATEGORIES.includes(category)) {
		return createErrorResponse(400, ERROR_CODES.INVALID_FILE_TYPE);
	}

	const validationError = validateImageFile(
		fileField ? { type: fileField.type, size: fileField.data?.length } : null,
	);
	if (validationError) {
		return createErrorResponse(
			400,
			ERROR_CODES[validationError as keyof typeof ERROR_CODES],
		);
	}

	try {
		const config = getQueryConfig(category, user.id);

		if (config) {
			const rows = await executeQuery<{ photo_url: string }>(
				config.selectSql,
				config.params,
			);
			await deleteOldFile(rows[0]?.photo_url || '');
		}

		const url = await processAndSaveImage(fileField!.data, category);

		if (config) {
			await executeQuery(config.updateSql, [url, ...config.params]);
		}

		logOperation(uploadLogger, 'Image uploaded', {
			userId: user.id,
			category,
			url,
		});

		return createSuccessResponse(SUCCESS_CODES.PHOTO_UPDATED, { url });
	} catch (error: any) {
		logError(uploadLogger, 'Image upload failed', error, {
			userId: user.id,
			category,
		});
		return createErrorResponse(500, ERROR_CODES.UPLOAD_FAILED);
	}
});

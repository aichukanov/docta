import { requireAdmin } from '~/server/common/auth';
import {
	validateImageFile,
	processAndSaveImage,
	VALID_CATEGORIES,
	type ImageCategory,
} from '~/server/utils/image-processing';

/**
 * Admin-only image upload endpoint.
 * Accepts multipart form with `file` and `category` fields.
 * Returns processed image URL without binding to any DB record.
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);

	const formData = await readMultipartFormData(event);
	if (!formData) {
		throw createError({ statusCode: 400, statusMessage: 'No form data' });
	}

	const fileField = formData.find((f) => f.name === 'file');
	const categoryField = formData.find((f) => f.name === 'category');
	const category = categoryField?.data?.toString() as ImageCategory | undefined;

	if (!category || !VALID_CATEGORIES.includes(category)) {
		throw createError({ statusCode: 400, statusMessage: 'Invalid category' });
	}

	const validationError = validateImageFile(
		fileField ? { type: fileField.type, size: fileField.data?.length } : null,
	);
	if (validationError) {
		throw createError({ statusCode: 400, statusMessage: validationError });
	}

	const url = await processAndSaveImage(fileField!.data, category);

	return { url };
});

import { isValidLocale, validateBody } from '~/common/validation';
import { getMedicineDetails } from '~/server/common/medicines/details-service';
import type { MedicineDetails } from '~/interfaces/medicine';

export default defineEventHandler(
	async (event): Promise<MedicineDetails | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/medicines/details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}
			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid slug');
				return null;
			}

			return await getMedicineDetails(body.slug, isValidLocale(body.locale) ? body.locale : 'en');
		} catch (error) {
			console.error('API Error - medicine details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch medicine data',
			});
		}
	},
);

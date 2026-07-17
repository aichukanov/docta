import { fetchClinicItemsSummary } from '~/server/common/clinic-items-summary';
import { getConnection } from '~/server/common/db-mysql';
import { processLocalizedNameForClinicOrDoctor } from '~/server/common/utils';
import type { ClinicItemsSummary } from '~/interfaces/clinic';
import { validateBody } from '~/common/validation';

export interface ClinicItemsSummaryResponse {
	id: number;
	slug: string;
	name: string;
	localName: string;
	itemsSummary: ClinicItemsSummary;
}

export default defineEventHandler(
	async (event): Promise<ClinicItemsSummaryResponse | null> => {
		try {
			const body = await readBody(event);

			if (!validateBody(body, 'api/clinics/items-summary')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}
			if (!body.slug || typeof body.slug !== 'string') {
				setResponseStatus(event, 400, 'Invalid clinic slug');
				return null;
			}

			const locale = body.locale || 'en';
			const connection = await getConnection();
			const [rows] = await connection.execute(
				`SELECT id, slug, name_sr, name_sr_cyrl, name_ru FROM clinics
				WHERE slug = ? AND status = 'published' LIMIT 1`,
				[body.slug],
			);
			await connection.end();

			const clinic = (rows as any[])[0];
			// Clinic subpages are public content. Drafts must look missing even
			// to their owner or an administrator, before redirect logic can run.
			if (!clinic) {
				setResponseStatus(event, 404, 'Clinic not found');
				return null;
			}

			const { name, localName } = processLocalizedNameForClinicOrDoctor(
				clinic,
				locale,
			);
			const itemsSummary = await fetchClinicItemsSummary(clinic.id, locale);

			return {
				id: clinic.id,
				slug: clinic.slug,
				name,
				localName,
				itemsSummary,
			};
		} catch (error) {
			console.error('API Error - clinic items-summary:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch clinic items summary',
			});
		}
	},
);

import { executeQuery } from '~/server/common/db-mysql';
import type { Specialty } from '~/interfaces/doctor';

export default defineEventHandler(
	async (event): Promise<{ id: number; name: string }[]> => {
		try {
			const specialties = await executeQuery<Specialty>(
				`SELECT DISTINCT s.id, s.name 
			 FROM specialties s 
			 JOIN doctor_specialties ds ON s.id = ds.specialty_id 
			 ORDER BY s.name`,
			);

			return specialties.map((specialty) => ({
				id: specialty.id,
				name: specialty.name,
			}));
		} catch (error) {
			console.error('API Error - specialties:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch specialties',
			});
		}
	},
);

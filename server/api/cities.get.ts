import { executeQuery } from '~/server/common/db-mysql';
import type { CityId } from '~/common/constants';

export default defineEventHandler(
	async (event): Promise<{ id: CityId; name: string }[]> => {
		try {
			const cities = await executeQuery<{ id: CityId; name: string }>(
				`SELECT DISTINCT c.id, c.name 
			 FROM cities c 
			 JOIN clinics cl ON c.id = cl.city_id
			 JOIN doctor_clinics dc ON cl.id = dc.clinic_id 
			 ORDER BY c.name`,
			);

			return cities.map((city) => ({
				id: city.id,
				name: city.name,
			}));
		} catch (error) {
			console.error('API Error - cities:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch cities',
			});
		}
	},
);

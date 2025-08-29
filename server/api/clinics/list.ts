import { getConnection } from '~/server/common/db-mysql';
import type { ClinicList } from '~/interfaces/doctor';

export default defineEventHandler(async (event): Promise<ClinicList> => {
	try {
		const clinicsQuery = `
			SELECT DISTINCT
				c.id,
				c.name,
				c.city_id as cityId,
				c.address,
				c.latitude,
				c.longitude,
				c.phone,
				c.email,
				c.facebook,
				c.instagram,
				c.telegram,
				c.whatsapp,
				c.viber,
				c.website
			FROM clinics c;
		`;

		const connection = await getConnection();
		const [clinics] = await connection.execute(clinicsQuery);
		await connection.end();

		return {
			clinics,
			totalCount: clinics.length,
		};
	} catch (error) {
		console.error('API Error - clinics:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinics',
		});
	}
});

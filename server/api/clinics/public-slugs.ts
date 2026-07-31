import { clinicIsPublicSql } from '~/server/common/clinic-visibility';
import { getConnection } from '~/server/common/db-mysql';

// Слаги публичных клиник — по ним статьи решают, оставлять ли ссылку.
// В статьях ссылки на клиники захардкожены слагами (это часть текста, а не
// выборка), и после скрытия клиники ссылка вела бы на 410. Отдельный лёгкий
// эндпоинт вместо /api/clinics/list: нужен только список слагов, а не сотня
// клиник с расписаниями в payload SEO-страницы.
export default defineEventHandler(async (): Promise<{ slugs: string[] }> => {
	const connection = await getConnection();
	try {
		const [rows] = await connection.execute<any[]>(
			`SELECT c.slug FROM clinics c WHERE ${clinicIsPublicSql('c')} ORDER BY c.slug`,
		);
		return { slugs: rows.map((row) => row.slug as string) };
	} catch (error) {
		console.error('API Error - clinics/public-slugs:', error);
		// Пустой список означал бы «все ссылки битые» — безопаснее считать,
		// что клиники на месте, чем молча снять все ссылки в статьях.
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch public clinic slugs',
		});
	} finally {
		await connection.end();
	}
});

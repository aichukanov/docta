import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';

interface ReviewListItem {
	id: number;
	label: string;
}

export default defineEventHandler(async (event): Promise<ReviewListItem[]> => {
	try {
		await requireAdmin(event);

		const connection = await getConnection();

		const [rows]: any = await connection.execute(`
			SELECT
				r.id,
				r.rating,
				r.published_at,
				COALESCE(u.name, 'Аноним') as author_name,
				COALESCE(c.name_sr, '') as clinic_name,
				COALESCE(d.name_sr, '') as doctor_name
			FROM reviews r
			LEFT JOIN auth_users u ON r.user_id = u.id
			LEFT JOIN clinics c ON r.clinic_id = c.id
			LEFT JOIN doctors d ON r.doctor_id = d.id
			ORDER BY r.published_at DESC
			LIMIT 1000
		`);

		await connection.end();

		return rows.map((r: any) => {
			const parts = [
				`#${r.id}`,
				r.rating ? `${r.rating}★` : '',
				r.author_name,
				r.clinic_name || r.doctor_name || '',
				r.published_at
					? new Date(r.published_at).toISOString().slice(0, 10)
					: '',
			].filter(Boolean);
			return { id: r.id, label: parts.join(' | ') };
		});
	} catch (error) {
		console.error('API Error - reviews list:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch reviews list',
		});
	}
});

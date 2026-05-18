import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';

export interface RecentRealUserReview {
	id: number;
	userId: number;
	authorName: string;
	authorPhotoUrl: string;
	rating: number | null;
	originalLanguage: string;
	originalText: string;
	publishedAt: string | null;
	provider: string;
	clinicId: number | null;
	clinicName: string;
	doctorId: number | null;
	doctorName: string;
}

export default defineEventHandler(
	async (event): Promise<RecentRealUserReview[]> => {
		try {
			await requireAdmin(event);

			const connection = await getConnection();

			const [rows]: any = await connection.execute(
				`SELECT
					r.id,
					r.user_id,
					r.rating,
					r.original_language,
					r.original_text,
					r.published_at,
					r.provider,
					r.clinic_id,
					r.doctor_id,
					COALESCE(u.name, '') AS author_name,
					COALESCE(u.photo_url, '') AS author_photo_url,
					COALESCE(c.name_sr, '') AS clinic_name,
					COALESCE(d.name_sr, '') AS doctor_name
				FROM reviews r
				INNER JOIN auth_users u ON r.user_id = u.id
				LEFT JOIN clinics c ON r.clinic_id = c.id
				LEFT JOIN doctors d ON r.doctor_id = d.id
				WHERE u.is_phantom = FALSE
				ORDER BY r.published_at DESC, r.id DESC
				LIMIT 10`,
			);

			await connection.end();

			return rows.map((r: any) => ({
				id: r.id,
				userId: r.user_id,
				authorName: r.author_name,
				authorPhotoUrl: r.author_photo_url,
				rating: r.rating ?? null,
				originalLanguage: r.original_language || '',
				originalText: r.original_text || '',
				publishedAt: r.published_at
					? new Date(r.published_at).toISOString()
					: null,
				provider: r.provider,
				clinicId: r.clinic_id ?? null,
				clinicName: r.clinic_name,
				doctorId: r.doctor_id ?? null,
				doctorName: r.doctor_name,
			}));
		} catch (error) {
			console.error('API Error - recent reviews from real users:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch recent reviews from real users',
			});
		}
	},
);

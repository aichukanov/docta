import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';

export interface UserAdminListItem {
	id: number;
	email: string;
	name: string;
	photoUrl: string;
	isPhantom: boolean;
	primaryOauthProvider: string;
	createdAt: string | null;
	reviewsCount: number;
	lastReviewAt: string | null;
}

export default defineEventHandler(
	async (event): Promise<UserAdminListItem[]> => {
		try {
			await requireAdmin(event);

			const connection = await getConnection();

			const [rows]: any = await connection.execute(
				`SELECT
					u.id,
					COALESCE(u.email, '') AS email,
					COALESCE(u.name, '') AS name,
					COALESCE(u.photo_url, '') AS photo_url,
					u.is_phantom,
					COALESCE(u.primary_oauth_provider, '') AS primary_oauth_provider,
					u.created_at,
					(SELECT COUNT(*) FROM reviews r WHERE r.user_id = u.id) AS reviews_count,
					(SELECT MAX(r.published_at) FROM reviews r WHERE r.user_id = u.id) AS last_review_at
				FROM auth_users u
				ORDER BY u.created_at DESC, u.id DESC`,
			);

			await connection.end();

			return rows.map((r: any) => ({
				id: r.id,
				email: r.email,
				name: r.name,
				photoUrl: r.photo_url,
				isPhantom: !!r.is_phantom,
				primaryOauthProvider: r.primary_oauth_provider,
				createdAt: r.created_at ? new Date(r.created_at).toISOString() : null,
				reviewsCount: Number(r.reviews_count) || 0,
				lastReviewAt: r.last_review_at
					? new Date(r.last_review_at).toISOString()
					: null,
			}));
		} catch (error) {
			console.error('API Error - users admin-list:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch users admin list',
			});
		}
	},
);

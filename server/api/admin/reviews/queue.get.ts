import { requireAdmin } from '~/server/common/auth';
import { executeQuery } from '~/server/common/db-mysql';

export interface ModerationStats {
	pendingReviews: number;
	approvedReviews: number;
	rejectedReviews: number;
	verifiedReviews: number;
	pendingVerifications: number;
}

export interface ModerationReviewItem {
	id: number;
	rating: number | null;
	text: string | null;
	originalLanguage: string;
	publishedAt: string | null;
	status: 'pending' | 'approved' | 'rejected';
	rejectionReason: string | null;
	moderatedAt: string | null;
	isVerified: boolean;
	authorName: string | null;
	authorEmail: string | null;
	targetType: 'doctor' | 'clinic' | 'service';
	targetName: string;
	targetSlug: string | null;
}

export interface ModerationVerificationItem {
	reviewId: number;
	uploadedAt: string;
	status: 'pending' | 'approved' | 'rejected';
	rejectionReason: string | null;
	fileName: string | null;
	rating: number | null;
	text: string | null;
	authorName: string | null;
	targetName: string;
}

const VALID_STATUSES = ['pending', 'approved', 'rejected'];
const PAGE_SIZE = 20;

/**
 * Очередь модерации для админки: пользовательские отзывы (docta_me)
 * и файлы верификации, с фильтром по статусу.
 * GET /api/admin/reviews/queue?type=reviews|verifications&status=pending&page=1
 */
export default defineEventHandler(async (event) => {
	await requireAdmin(event);

	const query = getQuery(event);
	const type = query.type === 'verifications' ? 'verifications' : 'reviews';
	const status = VALID_STATUSES.includes(String(query.status))
		? String(query.status)
		: 'pending';
	const page = Math.max(1, parseInt(String(query.page)) || 1);
	const offset = (page - 1) * PAGE_SIZE;

	const [statsRow] = await executeQuery<any>(`
		SELECT
			SUM(IF(status = 'pending', 1, 0)) AS pendingReviews,
			SUM(IF(status = 'approved', 1, 0)) AS approvedReviews,
			SUM(IF(status = 'rejected', 1, 0)) AS rejectedReviews,
			SUM(IF(is_verified, 1, 0)) AS verifiedReviews
		FROM reviews
		WHERE provider = 'docta_me'
	`);
	const [verifStatsRow] = await executeQuery<any>(`
		SELECT COUNT(*) AS pendingVerifications
		FROM review_verification_files
		WHERE status = 'pending'
	`);

	const stats: ModerationStats = {
		pendingReviews: Number(statsRow?.pendingReviews || 0),
		approvedReviews: Number(statsRow?.approvedReviews || 0),
		rejectedReviews: Number(statsRow?.rejectedReviews || 0),
		verifiedReviews: Number(statsRow?.verifiedReviews || 0),
		pendingVerifications: Number(verifStatsRow?.pendingVerifications || 0),
	};

	if (type === 'reviews') {
		const items = await executeQuery<any>(
			`SELECT
				r.id,
				r.rating,
				r.original_text AS text,
				r.original_language AS originalLanguage,
				r.published_at AS publishedAt,
				r.status,
				r.rejection_reason AS rejectionReason,
				r.moderated_at AS moderatedAt,
				r.is_verified AS isVerified,
				u.name AS authorName,
				u.email AS authorEmail,
				CASE
					WHEN r.doctor_id IS NOT NULL THEN 'doctor'
					WHEN r.clinic_id IS NOT NULL THEN 'clinic'
					ELSE 'service'
				END AS targetType,
				COALESCE(d.name_sr, c.name_sr, '') AS targetName,
				COALESCE(d.slug, c.slug) AS targetSlug
			FROM reviews r
			LEFT JOIN auth_users u ON r.user_id = u.id
			LEFT JOIN doctors d ON r.doctor_id = d.id
			LEFT JOIN clinics c ON r.clinic_id = c.id
			WHERE r.provider = 'docta_me' AND r.status = ?
			ORDER BY r.published_at ASC
			LIMIT ${PAGE_SIZE} OFFSET ${offset}`,
			[status],
		);

		const [countRow] = await executeQuery<any>(
			`SELECT COUNT(*) AS total FROM reviews
			WHERE provider = 'docta_me' AND status = ?`,
			[status],
		);

		return {
			stats,
			reviews: items.map((r: any) => ({
				...r,
				isVerified: Boolean(r.isVerified),
			})) as ModerationReviewItem[],
			pagination: {
				page,
				pageSize: PAGE_SIZE,
				total: Number(countRow?.total || 0),
			},
		};
	}

	const items = await executeQuery<any>(
		`SELECT
			vf.review_id AS reviewId,
			vf.uploaded_at AS uploadedAt,
			vf.status,
			vf.rejection_reason AS rejectionReason,
			vf.file_name AS fileName,
			r.rating,
			r.original_text AS text,
			u.name AS authorName,
			COALESCE(d.name_sr, c.name_sr, '') AS targetName
		FROM review_verification_files vf
		JOIN reviews r ON r.id = vf.review_id
		LEFT JOIN auth_users u ON r.user_id = u.id
		LEFT JOIN doctors d ON r.doctor_id = d.id
		LEFT JOIN clinics c ON r.clinic_id = c.id
		WHERE vf.status = ?
		ORDER BY vf.uploaded_at ASC
		LIMIT ${PAGE_SIZE} OFFSET ${offset}`,
		[status],
	);

	const [countRow] = await executeQuery<any>(
		'SELECT COUNT(*) AS total FROM review_verification_files WHERE status = ?',
		[status],
	);

	return {
		stats,
		verifications: items as ModerationVerificationItem[],
		pagination: {
			page,
			pageSize: PAGE_SIZE,
			total: Number(countRow?.total || 0),
		},
	};
});

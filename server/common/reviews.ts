import type { Connection } from 'mysql2/promise';
import type { Rating, Review } from '~/interfaces/review';

export type ReviewSort =
	| 'rank'
	| 'newest'
	| 'oldest'
	| 'rating_high'
	| 'rating_low';

const VALID_SORTS: ReviewSort[] = [
	'rank',
	'newest',
	'oldest',
	'rating_high',
	'rating_low',
];

export function isValidSort(value: unknown): value is ReviewSort {
	return typeof value === 'string' && VALID_SORTS.includes(value as ReviewSort);
}

/**
 * Build CASE expression for localized text field.
 * Used for reviews and review replies.
 */
function localizedTextField(
	locale: string,
	tableAlias: string,
	fallbackField = 'original_text',
): string {
	return `CASE
		WHEN '${locale}' = 'sr' THEN COALESCE(${tableAlias}.text_sr, ${tableAlias}.${fallbackField})
		WHEN '${locale}' = 'sr-cyrl' THEN COALESCE(${tableAlias}.text_sr_cyrl, ${tableAlias}.${fallbackField})
		WHEN '${locale}' = 'en' THEN COALESCE(${tableAlias}.text_en, ${tableAlias}.${fallbackField})
		WHEN '${locale}' = 'ru' THEN COALESCE(${tableAlias}.text_ru, ${tableAlias}.${fallbackField})
		WHEN '${locale}' = 'de' THEN COALESCE(${tableAlias}.text_de, ${tableAlias}.${fallbackField})
		WHEN '${locale}' = 'tr' THEN COALESCE(${tableAlias}.text_tr, ${tableAlias}.${fallbackField})
		ELSE ${tableAlias}.${fallbackField}
	END`;
}

function buildOrderByClause(sort: ReviewSort, textExpr: string): string {
	switch (sort) {
		case 'newest':
			return 'r.published_at DESC';
		case 'oldest':
			return 'r.published_at ASC';
		case 'rating_high':
			return 'r.rating DESC, r.published_at DESC';
		case 'rating_low':
			return 'r.rating ASC, r.published_at DESC';
		case 'rank':
		default:
			return `IF(CHAR_LENGTH(COALESCE(${textExpr}, '')) > 0, 0, 1), (
				0.30 * EXP(-(LN(2)/365) * GREATEST(0, DATEDIFF(NOW(), COALESCE(r.published_at, DATE_SUB(NOW(), INTERVAL 730 DAY))))) +
				0.30 * LEAST(1.0, CHAR_LENGTH(COALESCE(${textExpr}, '')) / 300.0) +
				0.20 * LEAST(1.0, LOG2(1 + COALESCE(r.likes_count, 0)) / 5.0) +
				0.10 * IF(r.rating IS NOT NULL, 1.0, 0.0) +
				0.10 * CASE r.provider
					WHEN 'docta_me' THEN 1.0
					WHEN 'facebook' THEN 0.9
					WHEN 'telegram' THEN 0.85
					WHEN 'google_maps' THEN 0.75
					ELSE 0.7
				END +
				IF(EXISTS(SELECT 1 FROM review_replies rr WHERE rr.review_id = r.id), 0.03, 0.0)
			) DESC`;
	}
}

/**
 * Fetch rating for a doctor or clinic.
 */
export async function fetchRating(
	connection: Connection,
	entityType: 'doctor' | 'clinic',
	entityId: number,
): Promise<Rating> {
	const column = entityType === 'doctor' ? 'doctor_id' : 'clinic_id';
	const query = `
		SELECT
			ROUND(AVG(rating), 1) as averageRating,
			COUNT(*) as totalReviews
		FROM reviews
		WHERE ${column} = ? AND rating IS NOT NULL
	`;
	const [rows] = await connection.execute(query, [entityId]);
	const row = (rows as any[])[0];
	return {
		averageRating: row.averageRating ? parseFloat(row.averageRating) : null,
		totalReviews: row.totalReviews || 0,
	};
}

export interface FetchReviewsOptions {
	sort?: ReviewSort;
	limit?: number;
	offset?: number;
	minRating?: number;
	/** Мягкий приоритет: отзывы с рейтингом >= boostMinRating идут первыми, но остальные не скрываются */
	boostMinRating?: number;
	currentUserId?: number;
}

export interface FetchReviewsResult {
	reviews: Review[];
	ownReview: Review | null;
	totalCount: number;
}

const reviewSelectFields = (textExpr: string) => `
	r.id,
	r.user_id as userId,
	r.doctor_id as doctorId,
	r.clinic_id as clinicId,
	r.provider,
	r.provider_review_id as providerReviewId,
	r.rating,
	r.original_language as originalLanguage,
	r.original_text as originalText,
	${textExpr} as text,
	r.published_at as publishedAt,
	r.likes_count as likesCount,
	r.updated_at as updatedAt,
	COALESCE(
		NULLIF(u.name, ''),
		CASE u.primary_oauth_provider
			WHEN 'google'   THEN gp.name
			WHEN 'telegram' THEN CONCAT(tp.first_name, IFNULL(CONCAT(' ', NULLIF(tp.last_name, '')), ''))
			WHEN 'facebook' THEN fp.name
		END,
		u.email
	) as authorName,
	COALESCE(
		NULLIF(u.photo_url, ''),
		CASE u.primary_oauth_provider
			WHEN 'google'   THEN gp.picture
			WHEN 'telegram' THEN tp.photo_url
			WHEN 'facebook' THEN fp.picture_url
		END
	) as authorPhotoUrl,
	u.profile_url as authorProfileUrl
`;

const REVIEW_JOINS = `
	FROM reviews r
	LEFT JOIN auth_users u ON r.user_id = u.id
	LEFT JOIN auth_oauth_accounts goa ON u.id = goa.user_id AND goa.provider = 'google'
	LEFT JOIN auth_oauth_profiles_google gp ON goa.id = gp.oauth_account_id
	LEFT JOIN auth_oauth_accounts toa ON u.id = toa.user_id AND toa.provider = 'telegram'
	LEFT JOIN auth_oauth_profiles_telegram tp ON toa.id = tp.oauth_account_id
	LEFT JOIN auth_oauth_accounts foa ON u.id = foa.user_id AND foa.provider = 'facebook'
	LEFT JOIN auth_oauth_profiles_facebook fp ON foa.id = fp.oauth_account_id
`;

/**
 * Fetch reviews for a doctor or clinic with SQL-level sorting, pagination, and filtering.
 * Own review (if currentUserId provided) is fetched separately and unaffected by minRating/pagination.
 */
export async function fetchReviews(
	connection: Connection,
	entityType: 'doctor' | 'clinic',
	entityId: number,
	locale: string,
	options: FetchReviewsOptions = {},
): Promise<FetchReviewsResult> {
	const {
		sort = 'rank',
		limit,
		offset = 0,
		minRating = 0,
		boostMinRating,
		currentUserId,
	} = options;
	const column = entityType === 'doctor' ? 'doctor_id' : 'clinic_id';
	const textExpr = localizedTextField(locale, 'r');
	const replyTextExpr = localizedTextField(locale, 'rr');
	const selectFields = reviewSelectFields(textExpr);

	// Build WHERE for other reviews (excluding own)
	const conditions = [`r.${column} = ?`];
	const params: any[] = [entityId];

	if (minRating > 0) {
		conditions.push('r.rating >= ?');
		params.push(minRating);
	}

	if (currentUserId) {
		conditions.push('(r.user_id != ? OR r.user_id IS NULL)');
		params.push(currentUserId);
	}

	const whereClause = conditions.join(' AND ');

	// Count query (total other reviews matching filters)
	const [countRows] = await connection.execute(
		`SELECT COUNT(*) as total FROM reviews r WHERE ${whereClause}`,
		params,
	);
	const totalCount = (countRows as any[])[0].total;

	// Main query with sorting and pagination
	const boostPrefix =
		boostMinRating != null
			? `IF(r.rating >= ${Math.floor(Number(boostMinRating))}, 0, 1), `
			: '';
	const orderBy = boostPrefix + buildOrderByClause(sort, textExpr);
	const limitClause =
		limit != null
			? `LIMIT ${Math.max(0, Math.floor(Number(limit)))} OFFSET ${Math.max(0, Math.floor(Number(offset)))}`
			: '';

	const mainQuery = `
		SELECT ${selectFields}
		${REVIEW_JOINS}
		WHERE ${whereClause}
		ORDER BY ${orderBy}
		${limitClause}
	`;
	const [reviewsRows] = await connection.execute(mainQuery, params);

	// Own review (separate query, no minRating/pagination)
	let ownReviewRow: any = null;
	if (currentUserId) {
		const ownQuery = `
			SELECT ${selectFields}
			${REVIEW_JOINS}
			WHERE r.${column} = ? AND r.user_id = ?
		`;
		const [ownRows] = await connection.execute(ownQuery, [
			entityId,
			currentUserId,
		]);
		ownReviewRow = (ownRows as any[])[0] || null;
	}

	// Fetch replies for all fetched reviews
	const allRows = [...(reviewsRows as any[])];
	if (ownReviewRow) allRows.push(ownReviewRow);

	const reviewIds = allRows.map((r) => r.id);
	let replies: any[] = [];
	if (reviewIds.length > 0) {
		const repliesQuery = `
			SELECT
				rr.id,
				rr.review_id as reviewId,
				rr.responder_type as responderType,
				rr.clinic_id as clinicId,
				rr.doctor_id as doctorId,
				rr.user_id as userId,
				rr.original_text as originalText,
				rr.original_language as originalLanguage,
				${replyTextExpr} as text,
				rr.provider,
				rr.likes_count as likesCount,
				rr.published_at as publishedAt,
				rr.updated_at as updatedAt
			FROM review_replies rr
			WHERE rr.review_id IN (${reviewIds.map(() => '?').join(',')})
			ORDER BY rr.created_at ASC
		`;
		const [repliesRows] = await connection.execute(repliesQuery, reviewIds);
		replies = repliesRows as any[];
	}

	// Process review row into Review object
	const processReview = (review: any): Review => {
		const reviewReplies = replies
			.filter((r) => r.reviewId === review.id)
			.map((reply) => ({
				...reply,
				originalText:
					reply.originalText === reply.text ? null : reply.originalText,
			}));
		return {
			...review,
			originalText:
				review.originalText === review.text ? null : review.originalText,
			replies: reviewReplies,
			author: review.userId
				? {
						name: review.authorName,
						photoUrl: review.authorPhotoUrl,
						profileUrl: review.authorProfileUrl,
					}
				: undefined,
			isOwn: currentUserId ? review.userId === currentUserId : undefined,
		};
	};

	const reviews = (reviewsRows as any[]).map(processReview);
	const ownReview = ownReviewRow ? processReview(ownReviewRow) : null;

	return { reviews, ownReview, totalCount };
}

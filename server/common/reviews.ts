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

function applySorting(reviews: Review[], sort: ReviewSort): void {
	switch (sort) {
		case 'newest':
			reviews.sort(
				(a, b) =>
					new Date(b.publishedAt || 0).getTime() -
					new Date(a.publishedAt || 0).getTime(),
			);
			break;
		case 'oldest':
			reviews.sort(
				(a, b) =>
					new Date(a.publishedAt || 0).getTime() -
					new Date(b.publishedAt || 0).getTime(),
			);
			break;
		case 'rating_high':
			reviews.sort((a, b) => (b.rating || 0) - (a.rating || 0));
			break;
		case 'rating_low':
			reviews.sort((a, b) => (a.rating || 0) - (b.rating || 0));
			break;
		case 'rank':
		default:
			sortReviewsByRank(reviews);
			break;
	}
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

/**
 * Fetch reviews and their replies for a doctor or clinic.
 * Returns processed reviews with replies attached, sorted by rank.
 */
export async function fetchReviews(
	connection: Connection,
	entityType: 'doctor' | 'clinic',
	entityId: number,
	locale: string,
	sort: ReviewSort = 'rank',
	currentUserId?: number,
): Promise<Review[]> {
	const column = entityType === 'doctor' ? 'doctor_id' : 'clinic_id';

	const reviewsQuery = `
		SELECT
			r.id,
			r.user_id as userId,
			r.doctor_id as doctorId,
			r.clinic_id as clinicId,
			r.provider,
			r.provider_review_id as providerReviewId,
			r.rating,
			r.original_language as originalLanguage,
			r.original_text as originalText,
			${localizedTextField(locale, 'r')} as text,
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
		FROM reviews r
		LEFT JOIN auth_users u ON r.user_id = u.id
		LEFT JOIN auth_oauth_accounts goa ON u.id = goa.user_id AND goa.provider = 'google'
		LEFT JOIN auth_oauth_profiles_google gp ON goa.id = gp.oauth_account_id
		LEFT JOIN auth_oauth_accounts toa ON u.id = toa.user_id AND toa.provider = 'telegram'
		LEFT JOIN auth_oauth_profiles_telegram tp ON toa.id = tp.oauth_account_id
		LEFT JOIN auth_oauth_accounts foa ON u.id = foa.user_id AND foa.provider = 'facebook'
		LEFT JOIN auth_oauth_profiles_facebook fp ON foa.id = fp.oauth_account_id
		WHERE r.${column} = ?
		ORDER BY r.created_at DESC
	`;
	const [reviewsRows] = await connection.execute(reviewsQuery, [entityId]);

	// Fetch replies
	const reviewIds = (reviewsRows as any[]).map((r) => r.id);
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
				${localizedTextField(locale, 'rr')} as text,
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

	// Process: attach replies, clean originalText
	const reviews = (reviewsRows as any[]).map((review) => {
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
	});

	applySorting(reviews, sort);

	// Move user's own reviews to the top
	if (currentUserId) {
		const own = reviews.filter((r) => r.isOwn);
		const rest = reviews.filter((r) => !r.isOwn);
		return [...own, ...rest];
	}

	return reviews;
}

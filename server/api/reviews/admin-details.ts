import { getConnection } from '~/server/common/db-mysql';
import { requireAdmin } from '~/server/common/auth';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export interface ReplyAdminData {
	id: number;
	responderType: 'clinic' | 'doctor';
	originalLanguage: string;
	originalText: string;
	text_sr: string;
	text_sr_cyrl: string;
	text_en: string;
	text_ru: string;
	text_de: string;
	text_tr: string;
	provider: string;
	likesCount: number;
}

export interface ReviewAdminDetails {
	id: number;
	userId: number | null;
	clinicId: number | null;
	doctorId: number | null;
	medicalServiceId: number | null;
	provider: string;
	providerReviewId: string;
	rating: number | null;
	originalLanguage: string;
	originalText: string;
	text_sr: string;
	text_sr_cyrl: string;
	text_en: string;
	text_ru: string;
	text_de: string;
	text_tr: string;
	publishedAt: string | null;
	likesCount: number;
	// Display-only fields
	authorName: string;
	authorPhotoUrl: string;
	clinicName: string;
	doctorName: string;
	replies: ReplyAdminData[];
}

export default defineEventHandler(
	async (event): Promise<ReviewAdminDetails | null> => {
		try {
			await requireAdmin(event);

			const body = await readBody(event);

			if (!validateBody(body, 'api/reviews/admin-details')) {
				setResponseStatus(event, 400, 'Invalid parameters');
				return null;
			}

			if (!validateNonNegativeInteger(body.reviewId)) {
				setResponseStatus(event, 400, 'Invalid review id');
				return null;
			}

			const connection = await getConnection();

			const [rows]: any = await connection.execute(
				`SELECT
					r.id, r.user_id, r.clinic_id, r.doctor_id, r.medical_service_id,
					r.provider, r.provider_review_id, r.rating,
					r.original_language, r.original_text,
					r.text_sr, r.text_sr_cyrl, r.text_en, r.text_ru, r.text_de, r.text_tr,
					r.published_at, r.likes_count,
					COALESCE(u.name, '') as author_name,
					COALESCE(u.photo_url, '') as author_photo_url,
					COALESCE(c.name_sr, '') as clinic_name,
					COALESCE(d.name_sr, '') as doctor_name
				FROM reviews r
				LEFT JOIN auth_users u ON r.user_id = u.id
				LEFT JOIN clinics c ON r.clinic_id = c.id
				LEFT JOIN doctors d ON r.doctor_id = d.id
				WHERE r.id = ?`,
				[body.reviewId],
			);

			if (!rows.length) {
				await connection.end();
				return null;
			}

			const [replyRows]: any = await connection.execute(
				`SELECT id, responder_type, original_language, original_text,
					text_sr, text_sr_cyrl, text_en, text_ru, text_de, text_tr,
					provider, likes_count
				FROM review_replies
				WHERE review_id = ?
				ORDER BY responder_type ASC`,
				[body.reviewId],
			);

			await connection.end();

			const r = rows[0];

			const replies: ReplyAdminData[] = replyRows.map((rr: any) => ({
				id: rr.id,
				responderType: rr.responder_type,
				originalLanguage: rr.original_language || '',
				originalText: rr.original_text || '',
				text_sr: rr.text_sr || '',
				text_sr_cyrl: rr.text_sr_cyrl || '',
				text_en: rr.text_en || '',
				text_ru: rr.text_ru || '',
				text_de: rr.text_de || '',
				text_tr: rr.text_tr || '',
				provider: rr.provider,
				likesCount: rr.likes_count,
			}));

			return {
				id: r.id,
				userId: r.user_id ?? null,
				clinicId: r.clinic_id ?? null,
				doctorId: r.doctor_id ?? null,
				medicalServiceId: r.medical_service_id ?? null,
				provider: r.provider,
				providerReviewId: r.provider_review_id || '',
				rating: r.rating ?? null,
				originalLanguage: r.original_language || '',
				originalText: r.original_text || '',
				text_sr: r.text_sr || '',
				text_sr_cyrl: r.text_sr_cyrl || '',
				text_en: r.text_en || '',
				text_ru: r.text_ru || '',
				text_de: r.text_de || '',
				text_tr: r.text_tr || '',
				publishedAt: r.published_at
					? new Date(r.published_at).toISOString()
					: null,
				likesCount: r.likes_count,
				authorName: r.author_name,
				authorPhotoUrl: r.author_photo_url,
				clinicName: r.clinic_name,
				doctorName: r.doctor_name,
				replies,
			};
		} catch (error) {
			console.error('API Error - review admin details:', error);
			throw createError({
				statusCode: 500,
				statusMessage: 'Failed to fetch review details',
			});
		}
	},
);

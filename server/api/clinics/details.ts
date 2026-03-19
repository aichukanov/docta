import { getConnection } from '~/server/common/db-mysql';
import {
	processLocalizedNameForClinicOrDoctor,
	processLocalizedFieldForClinic,
	processLocalizedDescription,
} from '~/server/common/utils';
import type { ClinicData } from '~/interfaces/clinic';
import { validateBody, validateNonNegativeInteger } from '~/common/validation';

export default defineEventHandler(async (event): Promise<ClinicData> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/clinics/details')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!validateNonNegativeInteger(body.clinicId)) {
			setResponseStatus(event, 400, 'Invalid clinic id');
			return null;
		}

		const locale = body.locale || 'en';

		const clinicsQuery = `
			SELECT
				c.id,
				c.name_sr,
				c.name_ru,
				c.name_sr_cyrl,
				c.city_id as cityId,
				c.address_sr,
				c.address_sr_cyrl,
				c.town_sr,
				c.town_sr_cyrl,
				c.postal_code as postalCode,
				c.latitude,
				c.longitude,
				c.phone,
				c.email,
				c.facebook,
				c.instagram,
				c.telegram,
				c.whatsapp,
				c.viber,
				c.website,
				c.description_sr,
				c.description_sr_cyrl,
				c.description_en,
				c.description_ru,
				c.description_de,
				c.description_tr,
				COALESCE(GROUP_CONCAT(DISTINCT cl.language_id ORDER BY cl.language_id), '1') as languageIds,
				COALESCE(
					GROUP_CONCAT(DISTINCT bspi.service_id ORDER BY bspi.service_id),
					''
				) as features
			FROM clinics c
			LEFT JOIN clinic_languages cl ON c.id = cl.clinic_id
			LEFT JOIN billing_clinic_service_purchases bscp
				ON c.id = bscp.clinic_id
				AND bscp.deleted = 0
				AND bscp.purchased_at <= NOW()
				AND bscp.valid_until >= NOW()
			LEFT JOIN billing_clinic_service_purchase_items bspi
				ON bscp.id = bspi.purchase_id
			WHERE c.id = ?
			GROUP BY c.id;
		`;

		const connection = await getConnection();
		const [clinicRows] = await connection.execute(clinicsQuery, [
			body.clinicId,
		]);

		const clinic = clinicRows[0];
		if (!clinic) {
			await connection.end();
			return null;
		}

		// Загружаем рейтинг клиники
		const ratingQuery = `
			SELECT
				ROUND(AVG(rating), 1) as averageRating,
				COUNT(*) as totalReviews
			FROM reviews
			WHERE clinic_id = ? AND rating IS NOT NULL
		`;
		const [ratingRows] = await connection.execute(ratingQuery, [body.clinicId]);
		const ratingRow = (ratingRows as any[])[0];
		const rating = {
			averageRating: ratingRow.averageRating
				? parseFloat(ratingRow.averageRating)
				: null,
			totalReviews: ratingRow.totalReviews || 0,
		};

		// Загружаем отзывы клиники
		const reviewsQuery = `
			SELECT
				r.id,
				r.user_id as userId,
				r.clinic_id as clinicId,
				r.provider,
				r.provider_review_id as providerReviewId,
				r.rating,
				r.original_language as originalLanguage,
				r.original_text as originalText,
				CASE
					WHEN '${locale}' = 'sr' THEN COALESCE(r.text_sr, r.original_text)
					WHEN '${locale}' = 'sr-cyrl' THEN COALESCE(r.text_sr_cyrl, r.original_text)
					WHEN '${locale}' = 'en' THEN COALESCE(r.text_en, r.original_text)
					WHEN '${locale}' = 'ru' THEN COALESCE(r.text_ru, r.original_text)
					WHEN '${locale}' = 'de' THEN COALESCE(r.text_de, r.original_text)
					WHEN '${locale}' = 'tr' THEN COALESCE(r.text_tr, r.original_text)
					ELSE r.original_text
				END as text,
				r.published_at as publishedAt,
				r.likes_count as likesCount,
				r.created_at as createdAt,
				r.updated_at as updatedAt,
				u.name as authorName,
				u.photo_url as authorPhotoUrl,
				u.profile_url as authorProfileUrl
			FROM reviews r
			LEFT JOIN auth_users u ON r.user_id = u.id
			WHERE r.clinic_id = ?
			ORDER BY r.likes_count DESC, r.created_at DESC
		`;
		const [reviewsRows] = await connection.execute(reviewsQuery, [
			body.clinicId,
		]);

		// Загружаем ответы на отзывы
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
					CASE
						WHEN '${locale}' = 'sr' THEN COALESCE(rr.text_sr, rr.original_text)
						WHEN '${locale}' = 'sr-cyrl' THEN COALESCE(rr.text_sr_cyrl, rr.original_text)
						WHEN '${locale}' = 'en' THEN COALESCE(rr.text_en, rr.original_text)
						WHEN '${locale}' = 'ru' THEN COALESCE(rr.text_ru, rr.original_text)
						WHEN '${locale}' = 'de' THEN COALESCE(rr.text_de, rr.original_text)
						WHEN '${locale}' = 'tr' THEN COALESCE(rr.text_tr, rr.original_text)
						ELSE rr.original_text
					END as text,
					rr.provider,
					rr.likes_count as likesCount,
					rr.published_at as publishedAt,
					rr.created_at as createdAt,
					rr.updated_at as updatedAt
				FROM review_replies rr
				WHERE rr.review_id IN (${reviewIds.map(() => '?').join(',')})
				ORDER BY rr.created_at ASC
			`;
			const [repliesRows] = await connection.execute(repliesQuery, reviewIds);
			replies = repliesRows as any[];
		}

		await connection.end();

		// Обрабатываем локализованные имена
		const { name, localName } = processLocalizedNameForClinicOrDoctor(
			clinic,
			locale,
		);

		// Обрабатываем локализованные town и address
		const address = processLocalizedFieldForClinic(clinic, 'address', locale);
		const town = processLocalizedFieldForClinic(clinic, 'town', locale);

		// Обрабатываем локализованное description
		const description = processLocalizedDescription(clinic, locale);
		const features = clinic.features
			? clinic.features.split(',').map(Number)
			: [];

		// Обрабатываем отзывы
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
			};
		});

		return {
			id: clinic.id,
			cityId: clinic.cityId,
			postalCode: clinic.postalCode,
			latitude: clinic.latitude,
			longitude: clinic.longitude,
			phone: clinic.phone,
			email: clinic.email,
			facebook: clinic.facebook,
			instagram: clinic.instagram,
			telegram: clinic.telegram,
			whatsapp: clinic.whatsapp,
			viber: clinic.viber,
			website: clinic.website,
			description,
			languageIds: clinic.languageIds,
			features,
			name,
			localName,
			address,
			town,
			rating,
			reviews,
		};
	} catch (error) {
		console.error('API Error - clinic data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch clinic data',
		});
	}
});

import { validateBody } from '~/common/validation';
import type { DoctorData } from '~/interfaces/doctor';
import { getCurrentUser } from '~/server/common/auth';
import { getConnection } from '~/server/common/db-mysql';
import {
	getServicesByClinicAndSpecialty,
	type ClinicServicesMap,
} from '~/server/common/services';
import {
	processLocalizedDescription,
	processLocalizedNameForClinicOrDoctor,
} from '~/server/common/utils';

export default defineEventHandler(async (event): Promise<DoctorData> => {
	try {
		const body = await readBody(event);

		if (!validateBody(body, 'api/doctors/details')) {
			setResponseStatus(event, 400, 'Invalid parameters');
			return null;
		}

		if (!body.slug || typeof body.slug !== 'string') {
			setResponseStatus(event, 400, 'Invalid doctor slug');
			return null;
		}

		const locale = body.locale || 'en';
		const includeServices = body.includeServices || false;

		const doctorsQuery = `
			SELECT DISTINCT
				d.id,
				d.slug,
				d.user_id,
				d.hidden,
				d.is_draft,
				d.name_sr,
				d.name_sr_cyrl,
				d.name_ru,
				d.name_en,
				d.description_sr,
				d.description_sr_cyrl,
				d.description_ru,
				d.description_en,
				d.description_de,
				d.description_tr,
				d.professional_title as professionalTitle,
				d.photo_url as photoUrl,
				d.phone,
				d.email,
				d.facebook,
				d.instagram,
				d.telegram,
				d.whatsapp,
				d.viber,
				d.website,
				GROUP_CONCAT(DISTINCT s.id ORDER BY s.id) as specialtyIds,
				GROUP_CONCAT(DISTINCT languages.id ORDER BY languages.id) as languageIds,
				GROUP_CONCAT(DISTINCT dc.clinic_id ORDER BY dc.clinic_id) as clinicIds
			FROM doctors d
			LEFT JOIN doctor_specialties ds ON d.id = ds.doctor_id
			LEFT JOIN specialties s ON ds.specialty_id = s.id
			LEFT JOIN doctor_languages dl ON d.id = dl.doctor_id
			LEFT JOIN languages ON dl.language_id = languages.id
			LEFT JOIN doctor_clinics dc ON d.id = dc.doctor_id
			WHERE d.slug = ?
			GROUP BY d.id;
		`;

		const connection = await getConnection();
		const [doctorRows] = await connection.execute(doctorsQuery, [body.slug]);

		const doctor = (doctorRows as any[])[0];
		if (!doctor || doctor.hidden || doctor.is_draft) {
			await connection.end();
			return null;
		}

		// Загружаем услуги, если требуется
		let clinicServices: ClinicServicesMap | undefined;
		if (includeServices && doctor.clinicIds && doctor.specialtyIds) {
			const clinicIds = doctor.clinicIds.split(',').map(Number);
			const specialtyIds = doctor.specialtyIds.split(',').map(Number);
			clinicServices = await getServicesByClinicAndSpecialty(
				connection,
				clinicIds,
				specialtyIds,
				locale,
				doctor.id, // Передаём ID врача для получения индивидуальных цен
			);
		}

		// Загружаем рейтинг врача
		const ratingQuery = `
			SELECT
				ROUND(AVG(rating), 1) as averageRating,
				COUNT(*) as totalReviews
			FROM reviews
			WHERE doctor_id = ? AND rating IS NOT NULL
		`;
		const [ratingRows] = await connection.execute(ratingQuery, [doctor.id]);
		const rating = (ratingRows as any[])[0];

		// Преобразуем строку в число
		const processedRating = {
			averageRating: rating.averageRating
				? parseFloat(rating.averageRating)
				: null,
			totalReviews: rating.totalReviews || 0,
		};

		// Загружаем отзывы врача
		const reviewsQuery = `
			SELECT
				r.id,
				r.user_id as userId,
				r.doctor_id as doctorId,
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
				r.updated_at as updatedAt,
				u.name as authorName,
				u.photo_url as authorPhotoUrl,
				u.profile_url as authorProfileUrl
			FROM reviews r
			LEFT JOIN auth_users u ON r.user_id = u.id
			WHERE r.doctor_id = ?
			ORDER BY r.created_at DESC
		`;
		const [reviewsRows] = await connection.execute(reviewsQuery, [
			doctor.id,
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
			doctor,
			locale,
		);

		// Обрабатываем локализованное описание
		const description = processLocalizedDescription(doctor, locale);

		// Сортируем clinicIds по количеству услуг (больше услуг — выше)
		let sortedClinicIds = doctor.clinicIds;
		if (clinicServices && doctor.clinicIds) {
			const clinicIdsList = doctor.clinicIds.split(',').map(Number);
			clinicIdsList.sort((a: number, b: number) => {
				const aCount = clinicServices[a]?.length || 0;
				const bCount = clinicServices[b]?.length || 0;
				return bCount - aCount;
			});
			sortedClinicIds = clinicIdsList.join(',');
		}

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

		sortReviewsByRank(reviews);

		const currentUser = await getCurrentUser(event);
		const isOwner =
			!!currentUser && !!doctor.user_id && currentUser.id === doctor.user_id;

		const {
			hidden: _hidden,
			is_draft: _isDraft,
			user_id: _userId,
			name_sr,
			name_sr_cyrl,
			name_ru,
			name_en,
			description_sr,
			description_sr_cyrl,
			description_ru,
			description_en,
			description_de,
			description_tr,
			...rest
		} = doctor;

		return {
			...rest,
			name,
			localName,
			description,
			clinicIds: sortedClinicIds,
			clinicServices,
			isOwner,
			rating: processedRating,
			reviews,
		};
	} catch (error) {
		console.error('API Error - doctor data:', error);
		throw createError({
			statusCode: 500,
			statusMessage: 'Failed to fetch doctor data',
		});
	}
});
